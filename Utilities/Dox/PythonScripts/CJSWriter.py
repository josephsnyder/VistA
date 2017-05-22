#---------------------------------------------------------------------------
# Copyright 2017 The Open Source Electronic Health Record Agent
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
import sys
import os
import json
import argparse
import glob
sys.path.append('D:/Work/OSEHRA/VistA/Python/vista')
from OSEHRAHelper import ConnectToMUMPS,PROMPT

SCRIPTS_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPTS_DIR)

from InitCrossReferenceGenerator import createInitialCrossRefGenArgParser
from InitCrossReferenceGenerator import parseCrossRefGeneratorWithArgs
from parseSMLtoJSON import parseFile
initParser = createInitialCrossRefGenArgParser()
initParser.add_argument('-outdir', help='top directory to generate output in html')
result = initParser.parse_args()
crossRef = parseCrossRefGeneratorWithArgs(result)
outDir = os.path.normpath(result.outdir)
globalNums = crossRef.getAllFileManGlobals().keys()
packages = crossRef.getAllPackages().keys()
nameDict = []
VistA=ConnectToMUMPS("D:/Work/OSEHRA/VistA-build/Testing/Temporary/cjsOut.log","VISTA")
if ('' and ''):
  VistA.login('','')
if VistA.type=='cache':
  try:
    VistA.ZN('VISTA')
  except IndexError,no_namechange:
    pass
print "...Starting collection of .SML files..."
for val in globalNums:
  globalVal = str(val).lstrip("0")
  if globalVal[-2:] == ".0":
    globalVal= globalVal[:-2]
  globalInfo = crossRef.getGlobalByFileNo(val)
  fullGlobalName = globalInfo.getFileManName().replace(' ','_').replace('/','-')
  globalName = fullGlobalName
  nameDict.append({"label": fullGlobalName,"value": globalName})
  VistA.wait(PROMPT)
  VistA.write("D ^CJS")
  VistA.wait('Select files')
  VistA.write('R')
  VistA.wait('First file')
  VistA.write(globalVal)
  index = VistA.multiwait(['Last file','First file'])
  if index == 1:
    VistA.write("^")
    continue
  VistA.write(globalVal)
  VistA.wait('Model Name')
  VistA.write(globalName)
  VistA.wait('Full path')
  VistA.write(outDir)
  index = VistA.multiwait(["FRAMESTACK",VistA.prompt])
  if index == 0:
    VistA.write("Q")
    VistA.wait(PROMPT)
  VistA.write('K')
  if os.path.exists(os.path.join(outDir,globalName+".sml")):
    allConnections = []
    allEntities= {}
    parseFile(os.path.join(outDir,globalName+".sml"),outDir, crossRef)
print "...Writing out file dictionary..."
with open(os.path.join(outDir,'fileDictionary.json'),'w') as outFile:
  outFile.write(json.dumps(nameDict));