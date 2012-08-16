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

#---------------------------------------------------------------------------
# Add location of OSEHRAHelper to the Python path
import sys
import json
import pprint
#---------------------------------------------------------------------------

class JSONConfigParser(object):
  def __init__(self, JSONConfigFile):
    self._configFile = JSONConfigFile
    self._allPatients = None
    self._allDoctors = None
    self._allInstitutions = None
    self._allDivisions = None
    self._allClinics = None
    self.__parseConfig__()

  def __parseConfig__(self):
    configJson = json.load(open(self._configFile,'rb'), encoding='ascii')
    if "Patients" in configJson:
      self.__parseAllPatientsArray__(configJson['Patients'])
    if "Doctors" in configJson:
      self.__parseAllDoctorsArray__(configJson['Doctors'])
    if "Clinics" in configJson:
      self._allClinics = self.__getResultArrayFromInputFile__(configJson['Clinics'], 'Clinics')
    if "Institutions" in configJson:
      self._allInstitutions = self.__getResultArrayFromInputFile__(configJson['Institutions'], 'Institutions')
    if "Divisions" in configJson:
      self._allDivisions = self.__getResultArrayFromInputFile__(configJson['Divisions'], 'Divisions')

  def __getResultArrayFromInputFile__(self, jsonInputFile, keyName):
      jsonFile = open(jsonInputFile, 'rb')
      resultDict = json.load(jsonFile)
      return resultDict.get(keyName)

  def __parseAllPatientsArray__(self, patientsJson):
      patientsArray = []
      if "Common Patients" in patientsJson:
          patientsArray.extend(
              self.__getResultArrayFromInputFile__(patientsJson["Common Patients"],
                                                   'Patients'))
      if "Unique Patients" in patientsJson:
          patientsArray.extend(
              self.__getResultArrayFromInputFile__(patientsJson["Unique Patients"],
                                                   'Patients'))
      self._allPatients = patientsArray

  def __parseAllDoctorsArray__(self, doctorsJson):
      doctorsArray = []
      if "Common Doctors" in doctorsJson:
          doctorsArray.extend(
              self.__getResultArrayFromInputFile__(doctorsJson["Common Doctors"],
                                                   'Doctors'))
      if "Unique Doctors" in doctorsJson:
          doctorsArray.extend(
              self.__getResultArrayFromInputFile__(doctorsJson["Unique Doctors"],
                                                   'Doctors'))
      self._allDoctors = doctorsArray

  def getAllPatients(self):
    return self._allPatients

  def getAllInstitutions(self):
    return self._allInstitutions

  def getAllDoctors(self):
    return self._allDoctors

  def getAllClinics(self):
    return self._allClinics

  def getAllDivisions(self):
    return self._allDivisions

if __name__ == '__main__':
  configParser = JSONConfigParser('Scenario001.json')
  patients = configParser.getAllPatients()
  for patient in patients:
    print patient
  for doctor in configParser.getAllDoctors():
    print doctor
