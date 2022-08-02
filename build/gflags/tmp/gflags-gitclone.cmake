# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

if(EXISTS "/home/graphvite_mpi/build/gflags/src/gflags-stamp/gflags-gitclone-lastrun.txt" AND EXISTS "/home/graphvite_mpi/build/gflags/src/gflags-stamp/gflags-gitinfo.txt" AND
  "/home/graphvite_mpi/build/gflags/src/gflags-stamp/gflags-gitclone-lastrun.txt" IS_NEWER_THAN "/home/graphvite_mpi/build/gflags/src/gflags-stamp/gflags-gitinfo.txt")
  message(STATUS
    "Avoiding repeated git clone, stamp file is up to date: "
    "'/home/graphvite_mpi/build/gflags/src/gflags-stamp/gflags-gitclone-lastrun.txt'"
  )
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E rm -rf "/home/graphvite_mpi/external/gflags"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/home/graphvite_mpi/external/gflags'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git" 
            clone --no-checkout --config "advice.detachedHead=false" "git@github.com:gflags/gflags.git" "gflags"
    WORKING_DIRECTORY "/home/graphvite_mpi/external"
    RESULT_VARIABLE error_code
  )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once: ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'git@github.com:gflags/gflags.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git" 
          checkout "master" --
  WORKING_DIRECTORY "/home/graphvite_mpi/external/gflags"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'master'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/usr/bin/git" 
            submodule update --recursive --init 
    WORKING_DIRECTORY "/home/graphvite_mpi/external/gflags"
    RESULT_VARIABLE error_code
  )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/home/graphvite_mpi/external/gflags'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy "/home/graphvite_mpi/build/gflags/src/gflags-stamp/gflags-gitinfo.txt" "/home/graphvite_mpi/build/gflags/src/gflags-stamp/gflags-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/home/graphvite_mpi/build/gflags/src/gflags-stamp/gflags-gitclone-lastrun.txt'")
endif()
