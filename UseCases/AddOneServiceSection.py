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

# Add one Division inside an Institution

def AddOneServiceSection(VistA, serviceName, serviceType):
  VistA.wait('Select OPTION:')
  VistA.write('1')
  VistA.wait('INPUT TO WHAT FILE:')
  VistA.write('49')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('NAME')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('TYPE OF SERVICE')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('NATIONAL SERVICE')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('')
  VistA.wait('Select SERVICE/SECTION NAME:')
  VistA.write(serviceName)
  index = VistA.multiwait(['Are you adding',
                           'NAME'])
  if index == 0:
    VistA.write('Y')
    VistA.wait('SECTION MAIL SYMBOL:')
    VistA.write('')
    VistA.wait('PARENT SERVICE:')
    VistA.write('')
  else:
    VistA.write(serviceName)
  VistA.wait('TYPE OF SERVICE:')
  VistA.write(serviceType)
  VistA.write('')
  VistA.wait('Select SERVICE/SECTION NAME:')
  VistA.write('')

from OSEHRAHelper import ConnectToMUMPS,PROMPT
from ConnectToVista import ConnectToVista

if __name__ == '__main__':
  VistA = ConnectToVista("TEST.LOG")
  VistA.write("S DUZ=1 D Q^DI")
  AddOneServiceSection(VistA, "MEDICINE", "C")
  AddOneServiceSection(VistA, "SURGICAL", "C")
  AddOneServiceSection(VistA, "PSYCHIATRIC", "C")
  AddOneServiceSection(VistA, "ANCILLARY", "")
