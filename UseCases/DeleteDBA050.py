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

# Remove One institution from the instiatution file

def deleteFileManEntry(VistA, filemanName, entryName):
  VistA.wait('Select OPTION:')
  VistA.write('1')
  VistA.wait('INPUT TO WHAT FILE:')
  VistA.write(filemanName)
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('NAME')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('')
  VistA.wait(' NAME:')
  VistA.write(entryName)
  index = VistA.multiwait(['Are you adding ','NAME:'])
  if index == 0:
    VistA.write('^')
    VistA.wait(' NAME:')
    VistA.write('^')
    return
  VistA.write('@')
  VistA.wait('SURE YOU WANT TO DELETE')
  VistA.write('Y')
  VistA.wait('DO YOU WANT THOSE POINTERS UPDATED')
  VistA.write('YES')
  VistA.wait('CHOOSE 1\) OR 2\):')
  VistA.write('1') # delete all file pointers
  VistA.wait('DELETE ALL POINTERS\? Yes\/\/')
  VistA.write('')
  VistA.wait(' NAME:')
  VistA.write('')

def RemoveOneInstitution(VistA,institutionName, divisionName):
  deleteFileManEntry(VistA, "4", institutionName)
  deleteFileManEntry(VistA, "40.8", divisionName)

def DeleteDBA050(VistA):
  RemoveOneInstitution(VistA, "SOFTWARE SERVICE", "DBA")

from OSEHRAHelper import ConnectToMUMPS,PROMPT
from ConnectToVista import ConnectToVista

if __name__ == '__main__':
  VistA = ConnectToVista("TEST.LOG")
  VistA.write('S DUZ=1 D Q^DI')
  DeleteDBA050(VistA)
