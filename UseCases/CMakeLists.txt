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
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/MakeAppointment.py.in" "@CMAKE_CURRENT_BINARY_DIR@/MakeAppointment.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/PostSetup.py.in" "@CMAKE_CURRENT_BINARY_DIR@/PostImportSetup.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddPatient.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddPatient.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddDoctors.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddDoctors.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddOneDoctor.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddOneDoctor.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddOneClinic.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddOneClinic.py")

add_test(CASE_Add_Appointment ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/MakeAppointment.py" 07/16/2012 1000 30 VHC "CARTER, DAVID JR")
add_test(CASE_Holiday_Appointment ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/MakeAppointment.py" 07/4/2012 1000 30 VHC "CARTER, DAVID JR")
