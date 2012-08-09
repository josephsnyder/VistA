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

def parseTaskList(output):
  taskList = []
  curTask = None
  for line in output.split('\n'):
    line = line.strip()
    if len(line) == 0:
      continue
    #print "The current line is [%s]" % line
    if re.search('^-+$', line):
      if curTask and len(curTask) > 3:
        taskList.append(curTask)
        curTask = None
      continue
    if not curTask:
      result = re.search('^(?P<taskid>[0-9]+): (?P<routine>.*?),', line)
      if result:
        curTask = dict()
        curTask['routine'] = result.group('routine')
        pieces = line.split('.')
        if pieces and len(pieces) > 2:
          curTask['device'] = pieces[1]
          curTask['volset'] = pieces[2]
    else:
      result = re.search('^Scheduled for (?P<date>.*?) at (?P<time>.*?)$', line)
      if result:
        curTask['date'] = result.group('date')
        curTask['time'] = result.group('time')
  if curTask and len(curTask) > 3:
    taskList.append(curTask)
  print taskList
  return taskList

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
  VistA.wait('Enter RETURN to continue or')
  parseTaskList(VistA.getBefore())
  VistA.write('')
  VistA.wait('Select Type Of Listing:')
  VistA.write('')
  VistA.wait('Select Taskman Management Option:')
  VistA.write('^')

from OSEHRAHelper import ConnectToMUMPS,PROMPT
from ConnectToVista import ConnectToVista

if __name__ == '__main__':
  VistA = ConnectToVista("TEST.LOG")
  GetTaskList(VistA)
