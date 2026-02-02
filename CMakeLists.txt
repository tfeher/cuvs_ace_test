# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2026, NVIDIA CORPORATION.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on

cmake_minimum_required(VERSION 3.30.4 FATAL_ERROR)

set(rapids-cmake-version "26.02")
set(RAPIDS_VERSION_MAJOR_MINOR "26.02")
set(rapids-cmake-branch "release/${rapids-cmake-version}")
# ------------- configure rapids-cmake --------------#
if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/RAPIDS.cmake)
  file(DOWNLOAD https://raw.githubusercontent.com/rapidsai/rapids-cmake/release/25.12/RAPIDS.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/RAPIDS.cmake)
endif()
include(${CMAKE_CURRENT_BINARY_DIR}/RAPIDS.cmake)

include(rapids-cmake)
include(rapids-cpm)
include(rapids-cuda)
include(rapids-export)
include(rapids-find)

# ------------- configure project --------------#

rapids_cuda_init_architectures(test_cuvs)

project(test_cuvs LANGUAGES CXX CUDA)
find_package(Threads)

# ------------- configure cuvs -----------------#
rapids_cpm_init()

# Try to find pre-installed cuvs first (any version)
find_package(cuvs)
if(NOT cuvs_FOUND)
  message(FATAL_ERROR "Pre-installed cuvs not found")
else()
  message(STATUS "Using pre-installed cuvs from ${cuvs_DIR}")
endif()

# -------------- compile tasks ----------------- #
add_executable(HNSW_OPENAI_EXAMPLE src/hnsw_openai_example.cu)

# `$<TARGET_NAME_IF_EXISTS:conda_env>` is a generator expression that ensures that targets are
# installed in a conda environment, if one exists
target_link_libraries(HNSW_OPENAI_EXAMPLE PRIVATE cuvs::cuvs $<TARGET_NAME_IF_EXISTS:conda_env>)
