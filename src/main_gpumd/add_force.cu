/*
    Copyright 2017 Zheyong Fan and GPUMD development team
    This file is part of GPUMD.
    GPUMD is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    GPUMD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with GPUMD.  If not, see <http://www.gnu.org/licenses/>.
*/

/*----------------------------------------------------------------------------80
Add force to a group of atoms.
------------------------------------------------------------------------------*/

#include "add_force.cuh"
#include "model/atom.cuh"
#include "model/group.cuh"
#include "utilities/gpu_macro.cuh"
#include "utilities/read_file.cuh"
#include <iostream>
#include <vector>
#include <cstring>

static void __global__ add_force(
  const int group_size,
  const int group_size_sum,
  const int* g_group_contents,
  const double added_fx,
  const double added_fy,
  const double added_fz,
  double* g_fx,
  double* g_fy,
  double* g_fz)
{
  const int tid = blockIdx.x * blockDim.x + threadIdx.x;
  if (tid < group_size) {
    const int atom_id = g_group_contents[group_size_sum + tid];
    g_fx[atom_id] += added_fx;
    g_fy[atom_id] += added_fy;
    g_fz[atom_id] += added_fz;
  }
}

void Add_Force::compute(const int step, const std::vector<Group>& groups, Atom& atom)
{
  for (int call = 0; call < num_calls_; ++call) {
    const int step_mod_table_length = step % table_length_[call];
    const double added_fx = force_table_[call][0 * table_length_[call] + step_mod_table_length];
    const double added_fy = force_table_[call][1 * table_length_[call] + step_mod_table_length];
    const double added_fz = force_table_[call][2 * table_length_[call] + step_mod_table_length];
    const int num_atoms_total = atom.force_per_atom.size() / 3;
    const int group_size = groups[grouping_method_[call]].cpu_size[group_id_[call]];
    const int group_size_sum = groups[grouping_method_[call]].cpu_size_sum[group_id_[call]];
    add_force<<<(group_size - 1) / 64 + 1, 64>>>(
      group_size,
      group_size_sum,
      groups[grouping_method_[call]].contents.data(),
      added_fx,
      added_fy,
      added_fz,
      atom.force_per_atom.data(),
      atom.force_per_atom.data() + num_atoms_total,
      atom.force_per_atom.data() + num_atoms_total * 2);
    GPU_CHECK_KERNEL
  }
}

void Add_Force::parse(const char** param, int num_param, const std::vector<Group>& group)
{
  printf("Add force.\n");

  // check the number of parameters
  if (num_param != 6 && num_param != 4) {
    PRINT_INPUT_ERROR("add_force should have 5 or 3 parameters.\n");
  }

  // parse grouping method
  if (!is_valid_int(param[1], &grouping_method_[num_calls_])) {
    PRINT_INPUT_ERROR("grouping method should be an integer.\n");
  }
  if (grouping_method_[num_calls_] < 0) {
    PRINT_INPUT_ERROR("grouping method should >= 0.\n");
  }
  if (grouping_method_[num_calls_] >= group.size()) {
    PRINT_INPUT_ERROR("grouping method should < maximum number of grouping methods.\n");
  }

  // parse group id
  if (!is_valid_int(param[2], &group_id_[num_calls_])) {
    PRINT_INPUT_ERROR("group id should be an integer.\n");
  }
  if (group_id_[num_calls_] < 0) {
    PRINT_INPUT_ERROR("group id should >= 0.\n");
  }
  if (group_id_[num_calls_] >= group[grouping_method_[num_calls_]].number) {
    PRINT_INPUT_ERROR("group id should < maximum number of groups in the grouping method.\n");
  }

  printf(
    "    for atoms in group %d of grouping method %d.\n",
    group_id_[num_calls_],
    grouping_method_[num_calls_]);

  if (num_param == 6) {
    table_length_[num_calls_] = 1;
    force_table_[num_calls_].resize(table_length_[num_calls_] * 3);
    if (!is_valid_real(param[3], &force_table_[num_calls_][0])) {
      PRINT_INPUT_ERROR("fx should be a number.\n");
    }
    if (!is_valid_real(param[4], &force_table_[num_calls_][1])) {
      PRINT_INPUT_ERROR("fy should be a number.\n");
    }
    if (!is_valid_real(param[5], &force_table_[num_calls_][2])) {
      PRINT_INPUT_ERROR("fz should be a number.\n");
    }
    printf("    fx = %g eV/A.\n", force_table_[num_calls_][0]);
    printf("    fy = %g eV/A.\n", force_table_[num_calls_][1]);
    printf("    fz = %g eV/A.\n", force_table_[num_calls_][2]);
  } else {
    std::ifstream input(param[3]);
    if (!input.is_open()) {
      printf("Failed to open %s.\n", param[3]);
      exit(1);
    }

    std::vector<std::string> tokens = get_tokens(input);
    if (tokens.size() != 1) {
      PRINT_INPUT_ERROR("The first line of the add_force file should have 1 value.");
    }
    table_length_[num_calls_] = get_int_from_token(tokens[0], __FILE__, __LINE__);
    if (table_length_[num_calls_] < 2) {
      PRINT_INPUT_ERROR("Number of steps in the add_force file should >= 2.\n");
    } else {
      printf("    number of values in the add_force file = %d.\n", table_length_[num_calls_]);
    }

    force_table_[num_calls_].resize(table_length_[num_calls_] * 3);
    for (int n = 0; n < table_length_[num_calls_]; ++n) {
      std::vector<std::string> tokens = get_tokens(input);
      if (tokens.size() != 3) {
        PRINT_INPUT_ERROR("Number of force components at each step should be 3.");
      }
      for (int t = 0; t < 3; ++t) {
        force_table_[num_calls_][t * table_length_[num_calls_] + n] =
          get_double_from_token(tokens[t], __FILE__, __LINE__);
      }
    }
  }

  ++num_calls_;

  if (num_calls_ > 10) {
    PRINT_INPUT_ERROR("add_force cannot be used more than 10 times in one run.");
  }
}

void Add_Force::finalize() { num_calls_ = 0; }
