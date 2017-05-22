import sys
import re
import os
import random
import json

allEntities= {}
allConnections= []
crossRef= None
packageNameList = []
grpVal = 0
entryExists=False

def updateGroups(outJSON,field,entry):
  outVal = allEntities[entry]["group"]
  try:
    foundIndex = next(i for i,v in enumerate(outJSON['nodes']) if v["id"] == field)
    outVal = outJSON['nodes'][foundIndex]['group']
  except StopIteration:
    print ""
  try:
    foundIndex = next(i for i,v in enumerate(allEntities) if v["id"] == field)
    outVal = allEntities[foundIndex]['group']
  except:
    print ""
  return outVal

def checkForEntry(entry, jsonEntries, updateData=None):
      global grpVal
      global entryExists
      for i in jsonEntries:
        if "id" in i:
          if i["id"] == entry:
            grpVal = i['group']
            entryExists = True
            if updateData:
              i = updateData
            return i
          else:
            if "_children" in i:
              ret = checkForEntry(entry, i["_children"],updateData)
              if ret:
                grpVal = i['group']
                return ret
      return None
def parseEntityName(line):
  global allEntities
  global groupIndex
  fileInfo = re.match("(?P<name>[0-9A-Z_]*?)?_(?P<numberMaj>[0-9_]+)(?=(_nested)?_file)",line.replace("ENTITY  ",''))  #_(?P<numberMin>[0-9]+)?_?(nested_)?file
  entity={}
  if fileInfo:
    # assumes that the last two numbers it finds in the group are the values for the file numberMaj
    # Eliminates problem with ENTITY  AMIS_RCS_14_4_60_06_nested_file
    fileNum =  fileInfo.groups()[1].split("_")
    entity["num"] = ".".join(fileNum[-2:])
    entity["ID"] =fileInfo.groups()[0]+"_"+fileInfo.groups()[1]
    entity["name"] =fileInfo.groups()[0]
    if fileInfo.groups()[2]:
      entity["isNested"] = True
      entity["ID"] += "_nested"
    entity["ID"] += "_file"
  else:
    entity["name"] = line
    entity["ID"] =   line
  entity["fields"]=[]
  entity["connections"]=[]
  entity["subfiles"]=[]
  if crossRef and ("num" in entity):
    globalInfo = crossRef.getGlobalByFileNo(entity["num"].replace('_','.'))
    if globalInfo:
      packageName = globalInfo.getPackage().getName()
      if packageNameList.index(packageName):
        groupIndex = packageNameList.index(packageName)
  entity["group"] = groupIndex
  return entity

def parseFieldLine(line,foundFile,foundEntity):
  global allEntities
  nonNull=False
  match = re.match("ROLE (?P<fieldName>.+) FOR (?P<fileID>.+)",line)
  if line.split(" ")[0] in allEntities.keys():
    foundFile = line.split(" ")[0]
    return foundFile
  elif match:
      foundEntity["fields"].append( {"name": match.groups()[0],'nonNull': nonNull})
      connection = {'source': foundFile, 'target': foundEntity["ID"]+"_"+match.groups()[0]}
      if not (connection in foundEntity['connections']):
        foundEntity['connections'].append(connection)
  else:
    fileName = line.split(" ")
    if len(fileName) > 1:
      nonNull = True
    if (fileName[0] not in ['ROLE','DELETE','REPLACE',"INSERT"]):
      foundEntity["fields"].append( {"name": fileName[0],'nonNull': nonNull})
  return foundFile

def parseKeyLine(line,foundEntity):
  global allEntities
  if (line in allEntities.keys()) and foundEntity['isNested']:
      allEntities[line]["subfiles"].append(foundEntity["ID"])
      return False
  return True

def parseFile(inFile,out,inCrossRef=None):
  global allConnections
  allConnections = []
  global allEntities
  global packageNameList
  global crossRef
  global entryExists
  allEntities= {}
  if inCrossRef:
    crossRef= inCrossRef
    packageNameList = crossRef.getAllPackages().keys()
  with open(inFile,"r") as file:
    foundFile=''
    inEntity=False
    inKey = False
    for line in file:
      startMatch = re.match("^ENTITY",line)
      if startMatch:
        foundEntity = parseEntityName(line)
        inEntity=True
        continue
      if line.strip() == "ENDENTITY":
        allEntities[foundEntity["ID"]] = foundEntity
        inEntity=False
        continue
      if inEntity:
        if line.strip() == "KEY":
          inKey=True
          continue
        if line.strip() == "ENDKEY":
          inKey=False
          continue
        if inKey:
          inKey = parseKeyLine(line.strip(),foundEntity)
        else:
          foundFile = parseFieldLine(line.strip(),foundFile,foundEntity)
        continue
  base=os.path.basename(inFile);
  with open(os.path.join(out,base.replace('.sml','.json')),'w') as outFile:
    outJSON={}
    outJSON["nodes"]=[]
    outJSON["links"]=[]
    for entry in sorted(allEntities,key=lambda entry: "isNested" in allEntities[entry]):
      outJSONEntry = checkForEntry(entry,outJSON['nodes'],None)
      grpVal = allEntities[entry]["group"]
      if not outJSONEntry:
        entryExists= False
        outJSONEntry={"shape":"square","size":200,"_children":[],"children":[], "group":allEntities[entry]["group"]}
        outJSONEntry["id"] = allEntities[entry]["ID"]
        outJSONEntry["name"] = allEntities[entry]["name"]
      for field in allEntities[entry]["fields"]:
        if not (field['name'] == allEntities[entry]["ID"]):
          outJSONEntry['_children'].append({'id':allEntities[entry]["ID"]+"_"+field['name'],'name':allEntities[entry]["ID"]+"_"+field['name'],"shape":"circle","size":50,"group":grpVal})
          outJSON['links'].append({'source': allEntities[entry]["ID"],"target": allEntities[entry]["ID"]+"_"+field['name']})
      for field in allEntities[entry]["subfiles"]:
        outJSONEntry["_children"].append({"id": field,"name": field,"isNested":True,"shape":"triangle-up","size":200,"_children":[],"children":[],"group":grpVal})
        outJSON['links'].append({'source': allEntities[entry]["ID"],"target": field})
      for connection in allEntities[entry]["connections"]:
        outJSON["links"].append(connection)
      if not("isNested" in allEntities[entry]):
        outJSON["nodes"].append(outJSONEntry)
      if entryExists:
        checkForEntry(entry,outJSON['nodes'],outJSONEntry)
    outFile.write(json.dumps(outJSON))

if __name__ == '__main__':
  parseFile("C:/Users/joe.snyder/Desktop/HL.sml",'D:/wamp/www/Product-Management/Visual/files/files_json')