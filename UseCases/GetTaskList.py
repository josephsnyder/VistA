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

def GetTaskList(VistA):
  # go to the taskman menu
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('Select OPTION NAME:')
  VistA.write('XUTM MGR')
  VistA.wait('Select Taskman Management Option:')
  VistA.write('List Tasks')
  VistA.wait('Select Type Of Listing:')
  VistA.write('Every task')
  VistA.wait('DEVICE: ')
  VistA.write(';132;9999')
  while True:
    index = VistA.multiwait(['-+\r','\d+:.*?\n','Enter RETURN to continue or'])
    if index == 2:
      VistA.write('')
      break
    if index == 0:
      continue
    if index == 1: 
      print VistA.getAfter()
      continue
  VistA.wait('Select Type Of Listing:')
  VistA.write('')
  VistA.wait('Select Taskman Management Option:')
  VistA.write('^')

from OSEHRAHelper import ConnectToMUMPS,PROMPT
from ConnectToVista import ConnectToVista

if __name__ == '__main__':
  VistA = ConnectToVista("TEST.LOG")
  GetTaskList(VistA)
