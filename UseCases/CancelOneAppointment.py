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

def GotoAppointmentMenu(VistA):
  # go to the appointment menu
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('Select OPTION NAME:')
  VistA.write('SDMGR')
  VistA.wait('Select Scheduling Manager\'s Menu Option: ')
  VistA.write('Appointment Menu')
  VistA.wait('Select Appointment Menu Option:')

def GotoPrompt(VistA):
  VistA.wait('Select PATIENT NAME:')
  VistA.write('^')
  VistA.wait('Select Appointment Menu Option:')
  VistA.write('^')
  VistA.wait('Select Scheduling Manager\'s Menu Option:')
  VistA.write('^')
  VistA.wait(PROMPT)

def CancelOneAppointment(VistA, patientName, clinicName, reason, datetime, length, isPatientCancelled = True):
  GotoAppointmentMenu(VistA)
  VistA.write('Cancel Appointment')
  VistA.wait('Select PATIENT NAME:')
  VistA.write(patientName)
  VistA.wait('DO YOU WANT TO CANCEL \(P\)AST OR \(F\)UTURE APPOINTMENTS\?')
  VistA.write('F') # future appointment only
  VistA.wait('APPOINTMENTS CANCELLED BY \(P\)ATIENT OR BY \(C\)LINIC\?')
  if isPatientCancelled:
    VistA.write('P') # patient cancel
  else:
    VistA.write('C') # clinic cancel
  VistA.wait('Select CANCELLATION REASONS NAME:')
  VistA.write(reason)
  VistA.wait('CANCELLATION REMARKS:')
  VistA.write('')
  VistA.wait('READY TO CANCEL')
  index = VistA.multiwait(['SELECT APPOINTMENTS TO BE CANCELLED:',
                           'Select PATIENT NAME:'])
  if index == 1:
    print "No appointment for patient: %s" % patientName
    VistA.write('^')
    GotoPrompt(VistA)
    return
# figure out which appoint is the one we wanted
  allTexts = VistA.getBefore().split('\n')
  hasAppt = False
  apptLine = None
  choice = None
  for txt in allTexts:
    print txt
    if (txt.find(datetime) > 0 and 
        txt.find(clinicName) > 0 ):
      hasAppt = True
      apptLine = txt
      break
  if hasAppt:
    # figure the choice
    start = txt.find('(')
    end = txt.find(')', start + 1)
    choice = int(txt[start+1:end])
  if choice:
    VistA.write(str(choice))
  else:
    print "Count not find the appointment to cancel"
    VistA.write('^')
    GotoPrompt(VistA)
    return
  VistA.wait('Press RETURN to continue:')
  VistA.write('')
  VistA.wait('DO YOU WISH TO REBOOK ANY APPOINTMENT')
  VistA.write('N')
  VistA.wait('DO YOU WISH TO PRINT LETTERS FOR THE CANCELLED APPOINTMENT')
  VistA.write('Y')
  VistA.wait('DEVICE')
  VistA.write(';132;999')
  GotoPrompt(VistA)

from OSEHRAHelper import ConnectToMUMPS,PROMPT
from ConnectToVista import ConnectToVista

if __name__ == '__main__':
  VistA = ConnectToVista("TEST.LOG")
  CancelOneAppointment(VistA, "ZZTEST,EIGHT", 
                       "Medical Center Primary Care",
                       "UNABLE TO KEEP APPOINTMENT",
                       "Aug 22, 2012  8:00 AM",
                       "60")

  CancelOneAppointment(VistA, "ZZTEST,EIGHT", 
                       "Medical Center Primary Care",
                       "CLINIC CANCELLED",
                       "Aug 20, 2012  1:00 PM",
                       "30", False)
