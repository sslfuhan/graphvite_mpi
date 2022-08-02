# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/graphvite_mpi/external/faiss"
  "/home/graphvite_mpi/external/faiss"
  "/home/graphvite_mpi/build/faiss"
  "/home/graphvite_mpi/build/faiss/tmp"
  "/home/graphvite_mpi/build/faiss/src/faiss-stamp"
  "/home/graphvite_mpi/build/faiss/src"
  "/home/graphvite_mpi/build/faiss/src/faiss-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/graphvite_mpi/build/faiss/src/faiss-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/graphvite_mpi/build/faiss/src/faiss-stamp${cfgdir}") # cfgdir has leading slash
endif()
