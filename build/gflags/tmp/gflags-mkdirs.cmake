# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/graphvite_mpi/external/gflags"
  "/home/graphvite_mpi/build/gflags"
  "/home/graphvite_mpi/build/gflags"
  "/home/graphvite_mpi/build/gflags/tmp"
  "/home/graphvite_mpi/build/gflags/src/gflags-stamp"
  "/home/graphvite_mpi/build/gflags/src"
  "/home/graphvite_mpi/build/gflags/src/gflags-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/graphvite_mpi/build/gflags/src/gflags-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/graphvite_mpi/build/gflags/src/gflags-stamp${cfgdir}") # cfgdir has leading slash
endif()
