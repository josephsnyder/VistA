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
set(VISTA_STATE "ALABAMA" CACHE STRING "Set the State the Health Care system will be in")
set_property(CACHE VISTA_STATE PROPERTY STRINGS "ALABAMA;GEORGIA")
set(VISTA_BACKUP "" CACHE PATH "Path to the local backup of VistA")
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
file(GLOB JSONFiles ${CMAKE_CURRENT_SOURCE_DIR}/*.json)
foreach(JSONFile ${JSONFiles})
  get_filename_component(fileName ${JSONFile} NAME)
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${fileName}" "${CMAKE_CURRENT_BINARY_DIR}/${fileName}")
endforeach()
file(GLOB JSONInputFile ${CMAKE_CURRENT_SOURCE_DIR}/*.json.in)
foreach(JSONInput ${JSONInputFile})
  get_filename_component(jsonFileName ${JSONInput} NAME_WE)
  configure_file("${JSONInput}" "${CMAKE_CURRENT_BINARY_DIR}/${jsonFileName}.json")
endforeach()
file(GLOB JSONInputFile ${CMAKE_CURRENT_SOURCE_DIR}/${VISTA_STATE}/*.json.in)
foreach(JSONInput ${JSONInputFile})
  get_filename_component(jsonFileName ${JSONInput} NAME_WE)
  configure_file("${JSONInput}" "${CMAKE_CURRENT_BINARY_DIR}/${jsonFileName}.json")
endforeach()

add_test(CASE_Scenario001 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario001.py")
add_test(CASE_Scenario002 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario002.py")
add_test(CASE_Scenario003 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario003.py")
add_test(CASE_Scenario004 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario004.py")
add_test(CASE_Scenario005 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario005.py")
add_test(CASE_Scenario006 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario006.py")
add_test(CASE_Scenario007 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario007.py")
add_test(CASE_Scenario008 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario008.py")
add_test(CASE_Scenario009 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario009.py")
add_test(CASE_Scenario010 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario010.py")
add_test(CASE_Scenario011 ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/Scenario011.py")
