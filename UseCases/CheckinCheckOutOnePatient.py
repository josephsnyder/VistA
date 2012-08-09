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
  while True:
    index = VistA.multiwait(['Select Scheduling Manager\'s Menu Option:',
                             'Select Appointment Menu Option:',
                             'Select Patient:',
                             'Next Patient:',
                             'Next Clinic:',
                             'Next Appointment Date:'])
    VistA.write('^')
    if index != 0:
      continue
    else:
      break
  VistA.wait(PROMPT)

def CheckInOnePatient(VistA, patientName, clinicName, date, time):
  GotoAppointmentMenu(VistA)
  VistA.write('CK')
  VistA.wait('Select Appointment Check In or Check Out:')
  VistA.write('CI')
  VistA.wait('Appointment Date:')
  VistA.write(date)
  VistA.wait('Select Clinic:')
  VistA.write(clinicName) # future appointment only
  VistA.wait('Select Patient:')
  VistA.write(patientName)
  VistA.wait('Select Appointment:')
# figure out which Next Appointment Date:appoint is the one we wanPress RETURN to continue:ted
  allTexts = VistA.getBefore().split('\n')
  dateTime = '%s@%s' % (date, time)
  apptLine = None
  choice = None
  for txt in allTexts:
    if txt.find(dateTime) > 0 :
      hasAppt = True
      apptLine = txt
      break
  if apptLine:
    # find out the line #
    choice = re.search('^ (?P<choice>\d+) +', apptLine)
    if choice:
      choice = int(choice.group('choice'))
      VistA.write(str(choice))
      VistA.wait('Continue\?')
      VistA.write("YES")
      index = VistA.multiwait(['CHECKED-IN:',
                               'Press RETURN to continue:'])
      if index == 0:
        print "Appointment is already checked in"
        VistA.write('^')
      else:
        VistA.write('')
  else:CHECKED-IN:
    print "Could not find the appointment %s@%s %s" % (date, time, clinicName)
    VistA.write('^')
  GotoPrompt(VistA)
  return (apptLine != None)

def CheckOutOnePatient(VistA, patientName, clinicName,
                       apptdate, appttime, checkoutDT,
                       provider, ICDCode, diagnosis, 
                       procedure):
  GotoAppointmentMenu(VistA)
  VistA.write('CK')
  VistA.wait('Select Appointment Check In or CheEnter PROCEDURE ck Out:')
  VistA.write('CO')
  VistA.wait('Appointment Date:')
  VistA.write(date)
  VistA.wait('Select Clinic:')
  VistA.write(clinicName) # future appointment only
  VistA.wait('Select Patient:')
  VistA.write(patientName)
  VistA.wait('Select Appointment:')
# figure out which Next Appointment Date
  allTexts = VistA.getBefore().split('\n')
  dateTime = '%s@%s' % (date, time)
  apptLine = None
  choice = None
  for txt in allTexts:
    print txt
    if txt.find(dateTime) > 0 :
      hasAppt = True
      apptLine = txt
      break
  if apptLine:
    # find out the line #
    choice = re.search('^ (?P<choice>\d+) +', apptLine)
    if choice:
      choice = int(choice.group('choice'))
      print choice
      VistA.write(str(choice))
      VistA.wait('Check out date and time:')
      VistA.write(checkoutDT)
      VistA.wait('Enter PROVIDER:')
      VistA.write(provider)
      VistA.wait('Enter Diagnosis :')
      VistA.write(diagnosis)
      VistA.wait('Enter PROCEDURE ')
      VistA.write(procedure)
      VistA.wait('Continue\?')
      VistA.write("YES")
      VistA.wait('Press RETURN to continue:')
      VistA.write('')
  else:
    print "Could not find the appointment %s@%s %s" % (date, time, clinicName)
    VistA.write('^')
  GotoPrompt(VistA)
  return (apptLine != None)

from OSEHRAHelper import ConnectToMUMPS,PROMPT
from ConnectToVista import ConnectToVista
if __name__ == '__main__':
  VistA = ConnectToVista("TEST.LOG")
  CheckInOnePatient(VistA, "ZZTEST,EIGHT", 
                    "Medical Center Primary Care",
                    "AUG 03, 2012",
                    "12:30")
