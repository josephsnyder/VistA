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

from OSEHRAHelper import PROMPT
# letter type is slightly different from the type in notification letter
# PRE-APPOINTMENT LETTER
# CLINIC CANCELLATION LETTER
# APPT. CANCELLATION LETTER
# NO SHOW LETTER
def AssignOneClinicNotificationLetter(VistA, letterName, letterType, clinicName):
  VistA.write('S DUZ=1 D Q^DI')
  VistA.wait('Select OPTION:')
  VistA.write('1')
  VistA.wait('INPUT TO WHAT FILE:')
  VistA.write('44') # hospital location file
  VistA.wait('EDIT WHICH FIELD:')
  VistA.write(letterType)
  VistA.wait('THEN EDIT FIELD:')
  VistA.write('')
  VistA.wait('Select HOSPITAL LOCATION NAME:')
  VistA.write(clinicName)
  VistA.wait(letterType)
  VistA.write(letterName)
  VistA.wait('Select HOSPITAL LOCATION NAME:')
  VistA.write('^')
  VistA.wait('Select OPTION:')
  VistA.write('^')
  VistA.wait(PROMPT)

def AddOneNotificationLetter(VistA, letterType, letterName, firstPara, lastPara):
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('Select OPTION NAME')
  VistA.write('SDMGR')
  VistA.wait('Select Scheduling Manager\'s Menu Option:')
  VistA.write('Supervisor Menu')
  VistA.wait('Select Supervisor Menu Option:')
  VistA.write('Enter/Edit Letters')
  VistA.wait('SELECT TYPE OF LETTER:')
  VistA.write(letterType)
  VistA.wait('SELECT LETTER:')
  VistA.write(letterName)
  index = VistA.multiwait(['Are you adding', 'NAME:'])
  if index != 0: # if exists, just return
    VistA.write('^')
    VistA.wait('Select Supervisor Menu Option:')
    VistA.write('^')
    VistA.wait('Select Scheduling Manager\'s Menu Option:')
    VistA.write('^')
    VistA.wait(PROMPT)
    return
  VistA.write('Y')
  VistA.wait('NAME:')
  VistA.write('')
  VistA.wait('TYPE:')
  VistA.write('')
  VistA.wait('INITIAL SECTION OF LETTER:')
  VistA.wait('1\>')
  VistA.write(firstPara)
  VistA.wait('2\>')
  VistA.write('')
  VistA.wait('EDIT Option:')
  VistA.write('')
  VistA.wait('FINAL SECTION OF LETTER:')
  VistA.wait('1\>')
  VistA.write(lastPara)
  VistA.wait('2\>')
  VistA.write('')
  VistA.wait('EDIT Option:')
  VistA.write('')
  VistA.wait('SELECT TYPE OF LETTER:')
  VistA.write('')
  VistA.wait('Select Supervisor Menu Option:')
  VistA.write('')
  VistA.wait('Select Scheduling Manager\'s Menu Option:')
  VistA.write('^')
  VistA.wait(PROMPT)

from OSEHRAHelper import ConnectToMUMPS,PROMPT
from ConnectToVista import ConnectToVista

if __name__ == '__main__':
  VistA = ConnectToVista("TEST.LOG")
# predefined letter type
#   APPOINTMENT CANCELLED
#   CLINIC CANCELLED
#   COPAY EXEMPTION TEST
#   MEANS TEST
#   NO-SHOW
#   PRE-APPOINTMENT

  AddOneNotificationLetter(VistA, "APPOINTMENT CANCELLED", "ZZAPPTCANCELLED",
                                  "SAMPLE APPOINTMENT CANCELLED LETTER",
                                  "SINCERELY")
  AddOneNotificationLetter(VistA, "CLINIC CANCELLED", "ZZCLINICCELLED",
                                  "SAMPLE CLINIC CANCELLED LETTER",
                                  "SINCERELY")
  AddOneNotificationLetter(VistA, "NO-SHOW", "ZZNOSHOW",
                                  "SAMPLE NO-SHOW LETTER",
                                  "SINCERELY")
  AddOneNotificationLetter(VistA, "PRE-APPOINTMENT", "ZZPREAPPT",
                                  "SAMPLE PRE-APPOINTMENT LETTER",
                                  "SINCERELY")

# letter type is slightly different from the type in notification letter
# PRE-APPOINTMENT LETTER
# CLINIC CANCELLATION LETTER
# APPT. CANCELLATION LETTER
# NO SHOW LETTER

  AssignOneClinicNotificationLetter(VistA, "ZZAPPTCANCELLED",
                                    "APPT. CANCELLATION LETTER",
                                    "Medical Center Primary Care")

  AssignOneClinicNotificationLetter(VistA, "ZZCLINICCELLED",
                                    "CLINIC CANCELLATION LETTER",
                                    "Medical Center Primary Care")

  AssignOneClinicNotificationLetter(VistA, "ZZNOSHOW",
                                    "NO SHOW LETTER",
                                    "Medical Center Primary Care")

  AssignOneClinicNotificationLetter(VistA, "ZZPREAPPT",
                                    "PRE-APPOINTMENT LETTER",
                                    "Medical Center Primary Care")
