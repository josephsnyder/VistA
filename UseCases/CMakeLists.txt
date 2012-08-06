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

set(VISTA_STATE "" CACHE STRING "Set the State the Health Care system will be in")
file(GLOB PythonInput ${CMAKE_CURRENT_SOURCE_DIR}/*.py.in)
foreach(InputFile ${PythonInput})
  get_filename_component(pythonFileName ${InputFile} NAME_WE)
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${pythonFileName}.py.in" "@CMAKE_CURRENT_BINARY_DIR@/@pythonFileName@.py")
endforeach()
file(GLOB PythonFiles ${CMAKE_CURRENT_SOURCE_DIR}/*.py)
foreach(PythonFile ${PythonFiles})
  get_filename_component(fileName ${PythonFile} NAME)
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${fileName}" "${CMAKE_CURRENT_BINARY_DIR}/${fileName}")
endforeach()

add_test(CASE_Scenario001 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario001.py")
