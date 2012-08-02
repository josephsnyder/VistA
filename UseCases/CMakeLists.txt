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
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddAllergiesError.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddAllergiesError.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddClinics.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddClinics.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddDivisions.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddDivisions.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddDoctors.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddDoctors.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddElectronicSignature.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddElectronicSignature.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddHCSDivision.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddHCSDivision.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddHolidays.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddHolidays.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddInstitutions.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddInstitutions.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddLRZStrepTest.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddLRZStrepTest.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddPatients.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddPatients.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddOneClinic.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddOneClinic.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddOneDivision.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddOneDivision.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddOneDoctor.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddOneDoctor.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddOneHoliday.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddOneHoliday.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddOneInstitution.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddOneInstitution.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddOnePatient.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddOnePatient.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/AddTIUCoordinator.py.in" "@CMAKE_CURRENT_BINARY_DIR@/AddTIUCoordinator.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/ChangeAccessionNumber.py.in" "@CMAKE_CURRENT_BINARY_DIR@/ChangeAccessionNumber.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/ChangeOnceSchedule.py.in" "@CMAKE_CURRENT_BINARY_DIR@/ChangeOnceSchedule.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/ChangeStreptozymeTest.py.in" "@CMAKE_CURRENT_BINARY_DIR@/ChangeStreptozymeTest.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/ConnectToVista.py.in" "@CMAKE_CURRENT_BINARY_DIR@/ConnectToVista.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/CreateInstitution.py.in" "@CMAKE_CURRENT_BINARY_DIR@/CreateInstitution.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/CreateSystemManager.py.in" "@CMAKE_CURRENT_BINARY_DIR@/CreateSystemManager.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/InitializeDevice.py.in" "@CMAKE_CURRENT_BINARY_DIR@/InitializeDevice.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/InitializeFileman.py.in" "@CMAKE_CURRENT_BINARY_DIR@/InitializeFileman.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/MakeAppointment.py.in" "@CMAKE_CURRENT_BINARY_DIR@/MakeAppointment.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/PostSetup.py.in" "@CMAKE_CURRENT_BINARY_DIR@/PostImportSetup.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/RegisterVitalsInformation.py.in" "@CMAKE_CURRENT_BINARY_DIR@/RegisterVitalsInformation.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/Scenario001.py.in" "@CMAKE_CURRENT_BINARY_DIR@/Scenario001.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/SetupCPRS.py.in" "@CMAKE_CURRENT_BINARY_DIR@/SetupCPRS.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/SetupDomain.py.in" "@CMAKE_CURRENT_BINARY_DIR@/SetupDomain.py")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/StartTaskMan.py.in" "@CMAKE_CURRENT_BINARY_DIR@/StartTaskMan.py")


add_test(CASE_Add_Appointment ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/MakeAppointment.py" 07/16/2012 1000 30 VHC "CARTER, DAVID JR")
add_test(CASE_Holiday_Appointment ${PYTHON_EXECUTABLE} "@CMAKE_CURRENT_BINARY_DIR@/MakeAppointment.py" 07/4/2012 1000 30 VHC "CARTER, DAVID JR")
