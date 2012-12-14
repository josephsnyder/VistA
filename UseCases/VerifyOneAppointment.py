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
import re

def GotoAppointmentMenu(VistA):
  # go to the appointment menu
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('Select OPTION NAME:')
  VistA.write('SDMGR')
  VistA.wait('Select Scheduling Manager\'s Menu Option: ')
  VistA.write('Appointment Menu')
  VistA.wait('Select Appointment Menu Option:')

def GotoPrompt(VistA):
  VistA.write('^')
  VistA.wait('Select Appointment Menu Option:')
  VistA.write('^')
  VistA.wait('Select Scheduling Manager\'s Menu Option:')
  VistA.write('^')
  #VistA.wait(PROMPT)

def VerifyOneAppointment(VistA, patientName, clinicName, datetime, length):
  Found = False
  GotoAppointmentMenu(VistA)
  VistA.write('Display Appointments')
  VistA.wait('Select PATIENT NAME:')
  VistA.write(patientName)
  index = VistA.multiwait(['Select PATIENT NAME:',
           'Do you want to see only pending appointments\?'])
  if index == 0: # patient is not found
    print "Patient %s does not exist" % patientName
    GotoPrompt(VistA)
    return False
  VistA.write('YES') # future appointment only
  VistA.wait('DEVICE')
  VistA.write(';132;999')
  VistA.wait('Select PATIENT NAME:')
# figure out which appoint is the one we wanted
  allTexts = VistA.getBefore().split('\n')
  hasAppt = False
  for txt in allTexts:
    if ( txt.find(datetime) >= 0 and 
         re.search(clinicName, txt, re.IGNORECASE) ):
      hasAppt = True
      break
  if hasAppt:
    print "Found the appointment %s %s" % (datetime, clinicName)
    Found = True
  else:
    print "Could not find the appointment %s %s" % (datetime, clinicName)
  GotoPrompt(VistA)
  return Found

from OSEHRAHelper import ConnectToMUMPS,PROMPT
from ConnectToVista import ConnectToVista

if __name__ == '__main__':
  VistA = ConnectToVista("TEST.LOG")
  VerifyOneAppointment(VistA, "ZZTEST,EIGHT", 
                       "Medical Center Primary Care",
                       "Aug 22, 2012  1:00 PM",
                       "60")

  VerifyOneAppointment(VistA, "ZZTEST,EIGHT", 
                       "Medical Center Primary Care",
                       "Aug 20, 2012  8:00 AM",
                       "30")
