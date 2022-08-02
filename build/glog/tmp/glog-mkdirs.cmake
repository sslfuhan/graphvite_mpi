# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/graphvite_mpi/external/glog"
  "/home/graphvite_mpi/build/glog"
  "/home/graphvite_mpi/build/glog"
  "/home/graphvite_mpi/build/glog/tmp"
  "/home/graphvite_mpi/build/glog/src/glog-stamp"
  "/home/graphvite_mpi/build/glog/src"
  "/home/graphvite_mpi/build/glog/src/glog-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/graphvite_mpi/build/glog/src/glog-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/graphvite_mpi/build/glog/src/glog-stamp${cfgdir}") # cfgdir has leading slash
endif()
