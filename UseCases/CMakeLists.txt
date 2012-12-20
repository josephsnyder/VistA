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
set_property(CACHE VISTA_STATE PROPERTY STRINGS "ALABAMA;CALIFORNIA;GEORGIA")
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

configure_file( "${CMAKE_CURRENT_SOURCE_DIR}/BackupDatabase.py.in" "${CMAKE_CURRENT_BINARY_DIR}/BackupDatabase.py")
add_test(CASE_ScenarioPre ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/BackupDatabase.py")
set_tests_properties(CASE_ScenarioPre PROPERTIES FAIL_REGULAR_EXPRESSION "VistA Backup was unsuccessful")

file(GLOB ScenarioInputFile ${CMAKE_CURRENT_SOURCE_DIR}/Scenario*)
foreach(ScenarioInput ${ScenarioInputFile})
  get_filename_component(ScenarioFileName ${ScenarioInput} NAME_WE)
  configure_file("${ScenarioInput}" "${CMAKE_CURRENT_BINARY_DIR}/${ScenarioFileName}.py")

  add_test(CASE_${ScenarioFileName} ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/${ScenarioFileName}.py")
  set_property(TEST CASE_${ScenarioFileName} PROPERTY DEPENDS CASE_ScenarioPre)
endforeach()