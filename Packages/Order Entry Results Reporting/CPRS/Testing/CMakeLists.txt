#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------
add_delphi_project(CPRSTesting)

# Search through the Tests directory for files
file(GLOB testsuites ${CMAKE_CURRENT_SOURCE_DIR}/Tests/*.pas)
foreach (suite ${testsuites})
  # Read through each file and find the class name that precedes "=class(TTestCase)"
  file(STRINGS ${suite} testcontents)
  foreach(line ${testcontents})
    #message(${line})
    string(REGEX MATCH "[A-Za-z0-9 ]+=[ ]*class\\(TTestCase\\)" name ${line})
    if(name)
      string(REGEX REPLACE "[ =]*class\\(TTestCase\\)|^ +" "" name ${name} )
      add_test(NAME DUnit${name} COMMAND ${CMAKE_CURRENT_BINARY_DIR}/bin/$<CONFIGURATION>/CPRSTesting.exe "${name}")
      # If our 'No registered tests' message is found, the test fails.
      set_tests_properties(DUnit${name} PROPERTIES FAIL_REGULAR_EXPRESSION "No registered tests")
    endif()
  endforeach()
endforeach()