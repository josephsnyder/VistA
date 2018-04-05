#!/usr/bin/env python

# A python script to generate the
# Visual Cross Reference Documentation (DOX) pages.
#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
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

import argparse
import bisect
import csv
import json
import logging
import os
import os.path
import re
import shutil
import string
import subprocess
import sys
import urllib

from operator import itemgetter
from LogManager import logger

from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, KeepTogether
from reportlab.platypus import Table, TableStyle, Image
from reportlab.platypus import ListFlowable, ListItem
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.pagesizes import landscape, letter, inch
from reportlab.lib import colors
import io
import PIL

from CrossReferenceBuilder import CrossReferenceBuilder
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser
from CrossReference import *

# PDF stylesheet
styles = getSampleStyleSheet()

componentTypeDict = {
  "action" : "A",
  "extended action" : "Ea",
  "event driver" : "Ed",
  "subscriber" : "Su",
  "protocol" : "P",
  "limited protocol" : "LP",

  # Option Values
  "run routine":"RR",
  "broker":"B",
  "edit":"E",
  "server":"Se",
  "print":"P",
  "screenman":"SM",
  "inquire":"I"
}
sectionLinkObj = {
    "Option":{"number":"19", "color":"color=orangered"},
    "Function":{"number":".5", "color":"color=royalblue"},
    "List_Manager_Templates":{"number":"409.61", "color":"color=saddlebrown"},
    "Dialog":{"number":".84", "color":"color=turquoise"},
    "Key":{"number":"19.1", "color":"color=limegreen"},
    "Remote_Procedure":{"number":"8994", "color":"color=firebrick"},
    "Protocol":{"number":"101", "color":"color=indigo"},
    "Help_Frame":{"number":"9.2", "color":"color=moccasin"},
    "Form":{"number":".403", "color":"color=cadetblue"},
    "Sort_Template":{"number":".401", "color":"color=salmon"},
    "HL7_APPLICATION_PARAMETER":{"number":"771", "color":"color=violetred"},
    "Input_Template": {"number":".402","color":"color=skyblue"},
    "Print_Template": {"number":".4","color":"color=yellowgreen"},
    }

# Note: Other scripts depend on the pkgMap
pkgMap = {
    'AUTOMATED INFO COLLECTION SYS': 'Automated Information Collection System',
    'AUTOMATED MED INFO EXCHANGE': 'Automated Medical Information Exchange',
    'BAR CODE MED ADMIN': 'Barcode Medication Administration',
    'CLINICAL INFO RESOURCE NETWORK': 'Clinical Information Resource Network',
    #  u'DEVICE HANDLER',
    #  u'DISCHARGE SUMMARY',
    'E CLAIMS MGMT ENGINE': 'E Claims Management Engine',
    #  u'EDUCATION TRACKING',
    'EMERGENCY DEPARTMENT': 'Emergency Department Integration Software',
    #  u'EXTENSIBLE EDITOR',
    #  u'EXTERNAL PEER REVIEW',
    'FEE BASIS CLAIMS SYSTEM' : 'Fee Basis',
    'GEN. MED. REC. - GENERATOR': 'General Medical Record - Generator',
    'GEN. MED. REC. - I/O' : 'General Medical Record - IO',
    'GEN. MED. REC. - VITALS' : 'General Medical Record - Vitals',
    #  u'GRECC',
    #  u'HEALTH MANAGEMENT PLATFORM',
    #  u'INDIAN HEALTH SERVICE',
    #  u'INSURANCE CAPTURE BUFFER',
    #  u'IV PHARMACY',
    'MASTER PATIENT INDEX': 'Master Patient Index VistA',
    'MCCR BACKBILLING' : 'MCCR National Database - Field',
    #  u'MINIMAL PATIENT DATASET',
    #  u'MOBILE SCHEDULING APPLICATIONS SUITE',
    #  u'Missing Patient Register',
    'MYHEALTHEVET': 'My HealtheVet',
    'NATIONAL HEALTH INFO NETWORK' : 'National Health Information Network',
    #  u'NEW PERSON',
    #  u'PATIENT ASSESSMENT DOCUM',
    #  u'PATIENT FILE',
    #  u'PROGRESS NOTES',
    #  u'QUALITY ASSURANCE',
    #  u'QUALITY IMPROVEMENT CHECKLIST',
    #  u'REAL TIME LOCATION SYSTEM',
    'TEXT INTEGRATION UTILITIES' : 'Text Integration Utility',
    #  u'UNIT DOSE PHARMACY',
    'VA POINT OF SERVICE (KIOSKS)' : 'VA Point of Service',
    #  u'VDEM',
    'VISTA INTEGRATION ADAPTOR' : 'VistA Integration Adapter',
    'VENDOR - DOCUMENT STORAGE SYS' : 'Vendor - Document Storage Systems'
    #  u'VETERANS ADMINISTRATION',
    #  u'VOLUNTARY SERVICE SYSTEM',
    #  u'VPFS',
    #  u'cds',
    #  u'person.demographics',
    #  u'person.lookup',
    #  u'term',
    #  u'term.access'])
} # this is the mapping between CUSTODIAL PACKAGE and packages in Dox

MAX_DEPENDENCY_LIST_SIZE = 30 # Do not generate the graph if have more than 30 nodes
PROGRESS_METER = 1000

GLOBAL_VARIABLE_SECTION_HEADER_LIST = [
     "Name",
      '''Line Occurrences &nbsp;(* Changed, &nbsp;! Killed)''']
FILENO_FILEMANDB_SECTION_HEADER_LIST = [
     "FileNo",
      '''Call Tags''']
RPC_REFERENCE_SECTION_HEADER_LIST = [
     "RPC Name",
      '''Call Tags''']
HL7_REFERENCE_SECTION_HEADER_LIST = [
     "HL7 Protocol Name",
      '''Call Tags''']
LABEL_REFERENCE_SECTION_HEADER_LIST = ["Name", "Line Occurrences"]
ENTRY_POINT_SECTION_HEADER_LIST = ["Name", "Comments", "DBIA/ICR reference"]
DEFAULT_VARIABLE_SECTION_HEADER_LIST = ["Name", "Line Occurrences",]
PACKAGE_OBJECT_SECTION_HEADER_LIST = ["Name", "Field # of Occurrence",]

LINE_TAG_PER_LINE = 10

# constants for html page
GOOGLE_ANALYTICS_JS_CODE = """
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-26757196-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'https://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
"""

TOP_INDEX_BAR_PART = """
<center>
<a href="index.html" class="qindex">Home</a>&nbsp;&nbsp;
<a href="packages.html" class="qindex">Package List</a>&nbsp;&nbsp;
<a href="routines.html" class="qindex">Routine Alphabetical List</a>&nbsp;&nbsp;
<a href="globals.html" class="qindex">Global Alphabetical List</a>&nbsp;&nbsp;
<a href="filemanfiles.html" class="qindex">FileMan Files List</a>&nbsp;&nbsp;
<a href="filemansubfiles.html" class="qindex">FileMan Sub-Files List</a>&nbsp;&nbsp;
<a href="PackageComponents.html" class="qindex">Package Component Lists</a>&nbsp;&nbsp;
<a href="Packages_Namespace_Mapping.html" class="qindex">
Package-Namespace Mapping</a>&nbsp;&nbsp;
<BR>
</center>
<script type="text/javascript" src="PDF_Script.js"></script>
"""

COMMON_HEADER_PART = """
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html><head>
<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<link href="DoxygenStyle.css" rel="stylesheet" type="text/css">
"""

SWAP_VIEW_HTML = """
<button id="swapDisplay">Switch Display Mode</button>
<script type="text/javascript\">
  $(window).on("scroll",function(event) {
    scrollLoc = 55 - $(this).scrollTop()
    if(scrollLoc < 0) scrollLoc=0
    $("#pageCommands").css('top',scrollLoc);
  });
  $("#swapDisplay").click( function(event) {
    if ($("#terseDisplay").is(':visible')) {
      $("#terseDisplay").hide()
      $("#expandedDisplay").show()
    }
    else {
      $("#terseDisplay").show()
      $("#expandedDisplay").hide()
    }
  });
</script>
"""

HEADER_END = """
</head>
"""
DEFAULT_BODY_PART = """
<body bgcolor="#ffffff">
"""
SOURCE_CODE_BODY_PART = """
<body bgcolor="#ffffff" onload="prettyPrint()">
"""
CODE_PRETTY_JS_CODE = """
<link href="code_pretty_scripts/prettify.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="code_pretty_scripts/prettify.js"></script>
<script type="text/javascript" src="code_pretty_scripts/lang-mumps.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
"""
INDEX_HTML_PAGE_HEADER = """
<div class="header">
  <div class="headertitle">
  </div>
 <h1>VistA Cross Reference Documentation</h1>
</div>
"""

XINDEXLegend = """
  <div>
    <h3>Legend:</h3>
    <table>
      <tbody>
        <tr>
          <td class="IndexKey"> >> </td>
          <td class="IndexValue"> Not killed explicitly</td>
          </tr><tr>
          <td class="IndexKey"> * </td>
          <td class="IndexValue">Changed</td>
          </tr><tr>
          <td class="IndexKey"> ! </td>
          <td class="IndexValue">Killed</td>
          </tr><tr>
          <td class="IndexKey">~</td>
          <td class="IndexValue">Newed</td>
        </tr>
      </tbody>
    </table>
    <br/>
"""

PCLegend = """
  <div>
    <h4>Package Component Superscript legend</h4>
    <table>
      <tbody>
        <tr>
        """
for key in componentTypeDict.keys():
  PCLegend += """ <td class="IndexKey"> %s </td>
          <td class="IndexValue"> <sup>%s</sup> </td>
          """ %(key,componentTypeDict[key])
PCLegend += """
        </tr>
      </tbody>
    </table>
    <br/>
  </div>
"""
INDEX_HTML_PAGE_OSEHRA_IMAGE_PART = """
<br/>
<left>
<div class="content">
<a href="https://www.osehra.org">
<img src="https://www.osehra.org/profiles/drupal_commons/themes/commons_osehra_earth/logo.png"
style="border-width:0" alt="OSEHRA" /></a>
</div>
</left>
<br/>
"""

INDEX_HTML_PAGE_INTRODUCTION_PART = """
<h2><a class ="anchor" id="intro"></a>Introduction</h2>
<p>
Welcome to VistA Cross Reference Documentation Page.
This documentation is generated with the results of XINDEX and
 FileMan Data Dictionary utility running against the VistA code base pulled
 from the <a href="https://code.osehra.org/gitweb?p=VistA-M.git;a=summary"/>
repository</a>.
This documentation provides direct dependency information among packages,
 among FileMan files,  between globals and routines,
 as well as direct call/caller graphs and source code for individual routine.
<br/>
<h2><a class ="anchor" id="howto"></a>How to use this documentation</h2>
<ul><li>
To view information related to a specified package like dependency graph,
assigned namespaces, FileMan files, globals and routines list, please click
 "<a href="packages.html" class="qindex">Package List</a>" link at the top
 and select the package that you are interested in.
</li><li>
To view information related to a specified FileMan file like fields,
 direct access routines and FileMan pointer dependency list, please click
 "<a href="filemanfiles.html" class="qindex">FileMan Files List</a>" link at
 the top and select the FileMan file that you are interested in.
</li><li>
To view information related to a specified routine/global, you can either
find the routine/global via
 "<a href="routines.html" class="qindex">Routine Alphabetical List</a>"/
"<a href="globals.html" class="qindex">Global Alphabetical List</a>" link or
 under the individual package page.
</li></ul>
<br/>
<br/>
"""

def writePDFCustomization(outputFile, titleList):
  outputFile.write("<script>initTitleList="+titleList+"\n")
  outputFile.write(" initTitleList.forEach(function(obj) {\n")
  outputFile.write('''   if (obj == "Doc") {return }\n''');
  outputFile.write('''   $("#pdfSelection").append('<input class="headerVal" type="checkbox" val="'+obj+'" checked>'+obj+'</input>')\n''');
  outputFile.write('''   $("#pdfSelection").append('<br/>')\n''');
  outputFile.write(" })\n")
  outputFile.write("</script>\n")

# utility functions
accordionOpenFun = """
    <script type='text/javascript'>
        function openAccordionVal(event) {
          if ($(".accordion").length > 5) {
            $('.accordion').accordion( {active:false, collapsible:true });
            classVal = ".accordion"
            if (event.target.classList[1] != "Allaccord") {
              classVal= classVal+"."+event.target.classList[1]
            }
            $(classVal).accordion( 'option', 'active',0 );
          }
        }
    </script>

"""

def getAccordionHTML():
  return """
    <script type='text/javascript'>
       $( document ).ready(function() {
           if ($(".accordion").length > 5) {
               $( '.accordion' ).accordion({
                   heightStyle: "content",
                   collapsible: true,
                   active: false
               })
           }
       })
    </script>
  """

def findRelevantIndex(sectionGenLst,existingOutFile):
  indexList = []
  idxLst = []
  for idx, item in enumerate(sectionGenLst):
    if existingOutFile and (idx < 5):
      continue
    extraarg = item.get('dataarg', [])
    if item['data'](*extraarg):
      indexList.append(item['name'])
      idxLst.append(idx)
  return indexList,idxLst

# Note: This function is called from other scripts
def getGlobalHtmlFileNameByName(globalName):
    return ("Global_%s.html" %
                        normalizeGlobalName(globalName))
def getGlobalPDFFileNameByName(globalName):
    return ("Global_%s.pdf" %
                        normalizeGlobalName(globalName))

def getICRHtmlFileName(icrEntry):
    # TODO: Needs to be a more general address?
    return ("https://code.osehra.org/vivian/files/ICR/ICR-%s.html" % icrEntry["NUMBER"])

def getGlobalHtmlFileName(globalVar):
    if globalVar.isSubFile():
        return getFileManSubFileHtmlFileNameByName(globalVar.getFileNo())
    return getGlobalHtmlFileNameByName(globalVar.getName())

def getGlobalDisplayName(globalVar):
    if globalVar.isFileManFile():
        return "%s(#%s)" % ( globalVar.getFileManName(), globalVar.getFileNo() )
    return globalVar.getName()

def getICRDisplayName(icrEntry):
    outString = "ICR Entry: %s <br><ul>" % (icrEntry["NUMBER"])
    if "TYPE" in icrEntry:
      outString +="<li>TYPE: %s</li>" % (icrEntry["TYPE"])
      if icrEntry["TYPE"] == "Routine":
        if "ROUTINE" in icrEntry:
          outString += "<li>Routine Called: %s</li>" % (icrEntry['ROUTINE'])
      if icrEntry["TYPE"] == "File":
        if "GLOBAL ROOT" in icrEntry:
          outString += "<li>Global Ref Called: %s</li>" % (icrEntry["GLOBAL ROOT"])
    if "STATUS" in icrEntry:
      outString +="<li>Status: %s</li>" % (icrEntry["STATUS"])
    if "USAGE" in icrEntry:
      outString +="<li>Usage: %s</li></ul>" % (icrEntry["USAGE"])
    return outString

# FileMan File (Global) related Functions
def getFileManFileHypeLink(GlobalVar):
    if not GlobalVar.isFileManFile():
        return getGlobalHypeLinkByName(GlobalVar.getName())
    if GlobalVar.isSubFile():
        return getFileManSubFileHtmlFileNameByName(GlobalVar.getFileNo())
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileName(GlobalVar),
                                      getGlobalDisplayName(GlobalVar))

def getFileManFileHypeLinkWithFileNo(GlobalVar):
    if not GlobalVar.isFileManFile():
        return getGlobalHypeLinkByName(GlobalVar.getName())
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileName(GlobalVar),
                                      GlobalVar.getFileNo())

def getFileManFileHypeLinkWithFileManName(GlobalVar):
    if not GlobalVar.isFileManFile():
        return getGlobalHypeLinkByName(GlobalVar.getName())
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileName(GlobalVar),
                                      GlobalVar.getFileManName())

def getFileManFileHyperLinkWithNameFileNo(GlobalVar):
    if not GlobalVar.isFileManFile():
        return getGlobalHypeLinkByName(GlobalVar.getName())
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileName(GlobalVar),
                                      "%s - [#%s]" % (GlobalVar.getName(),
                                      GlobalVar.getFileNo()))

# sub fileman files related functions
def getFileManSubFileHtmlFileNameByName(subFileNo):
    return urllib.quote("SubFile_%s.html" % subFileNo)
def getFileManSubFilePDFFileNameByName(subFileNo):
    return urllib.quote("SubFile_%s.pdf" % subFileNo)

def getFileManSubFileHtmlFileName(subFile):
    return getFileManSubFileHtmlFileNameByName(subFile.getFileNo())
def getFileManSubFileHypeLinkByName(subFileNo):
    return "<a href=\"%s\">%s</a>" % (getFileManSubFileHtmlFileNameByName(subFileNo),
                                      subFileNo)
def getFileManSubFileHypeLinkWithName(subFile):
    return ("<a href=\"%s\">%s</a>" %
            (getFileManSubFileHtmlFileName(subFile),
                                      subFile.getFileManName()))
# Note: This function is called from other scripts
def getRoutineHtmlFileName(routineName, title=""):
    return urllib.quote(getRoutineHtmlFileNameUnquoted(routineName))
def getRoutineHtmlFileNameUnquoted(routineName, title=""):
    return "Routine_%s.html" % routineName
def getRoutinePdfFileNameUnquoted(routineName):
    return "Routine_%s.pdf" % routineName
def getPackageObjHtmlFileNameUnquoted(optionName, title=""):
    title = "Routine"
    if "getObjectType" in dir(optionName):
      title = optionName.getObjectType()
    elif "Global" in str(type(optionName)):
      return getGlobalHtmlFileNameByName(optionName.getName())
    if not isinstance(optionName,basestring):
      optionName = optionName.getName()
    return "%s_%s.html" % (title, re.sub("[ /.*?&<>:]",'_',optionName))
def findDotColor(object, title=""):
    color = "color=black"
    if "getObjectType" in dir(object):
      color = sectionLinkObj[object.getObjectType()]["color"]
    elif "Global" in str(type(object)):
      color = "color=magenta"
    return color
def getPackageObjHtmlFileName(FunctionName, title=""):
    return urllib.quote(getPackageObjHtmlFileNameUnquoted(FunctionName, title))

# Note: This function is called from other scripts
def getPackageHtmlFileName(packageName):
    return urllib.quote("Package_%s.html" %
                        normalizePackageName(packageName))
def getPackagePdfFileName(packageName):
    return urllib.quote("Package_%s.pdf" %
                        normalizePackageName(packageName))

def getRoutineHypeLinkByName(routineName):
    return "<a href=\"%s\">%s</a>" % (getRoutineHtmlFileName(routineName),
                                      routineName)
def getGlobalHypeLinkByName(globalName):
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileNameByName(globalName),
                                      globalName)

def getPackageHyperLinkByName(packageName):
    if packageName in pkgMap:
      packageName = pkgMap[packageName]
    return "<a href=\"%s\">%s</a>" % (getPackageHtmlFileName(packageName),
                                      packageName)

# Note: This function is called from other scripts
def normalizePackageName(packageName):
    newName = packageName.replace(' ', '_')
    return newName.replace('-', "_").replace('.', '_').replace('/', '_')

def normalizeGlobalName(globalName):
    import base64
    return base64.urlsafe_b64encode(globalName)

def getRoutineSourceCodeFileByName(routineName, packageName, sourceDir):
    return os.path.join(sourceDir, "Packages" +
                        os.path.sep + packageName +
                        os.path.sep + "Routines" +
                        os.path.sep +
                        routineName + ".m")

def getRoutineSourceHtmlFileNameUnquoted(routineName):
    return "Routine_%s_source.html" % routineName

def getRoutineSourceHtmlFileName(routineName):
    return urllib.quote(getRoutineSourceHtmlFileNameUnquoted(routineName))

# generate index bar based on input list
def generateIndexBar(outputFile, inputList, archList=None, isIndex=False,
                      printButton=False, packageName=None):
    if (not inputList) or len(inputList) == 0:
        return
    hasArchList = archList and len(archList) == len(inputList)
    outputFile.write(accordionOpenFun)
    outputFile.write("<div class=\"qindex\">\n")
    for i in range(len(inputList) - 1):
        if hasArchList:
            archName = archList[i]
        else:
            archName = inputList[i]
        outputFile.write("<a onclick=\"openAccordionVal(event)\" class=\"qindex %s\" href=\"#%s\">%s</a>&nbsp;|&nbsp;\n" % (archName.split(" ")[0],archName,
                                                                                     inputList[i]))
    if hasArchList:
        archName = archList[-1]
    else:
        archName = inputList[-1]
    outputFile.write("<a onclick=\"openAccordionVal(event)\" class=\"qindex %s\" href=\"#%s\">%s</a>&nbsp;|&nbsp;\n" % (archName.split(" ")[0],archName,
        inputList[-1]))
    outputFile.write("<a onclick=\"openAccordionVal(event)\" class=\"qindex Allaccord\" href=\"#%s\">%s</a></div>\n" % ("All","All"))
    if not isIndex and printButton:
      outputFile.write("<div class=\"qindex\">\n")
      outputFile.write("<a onclick=\"startWritePDF(event)\" class=\"qindex printPage\" href=\"#Print\">Print Page as PDF</a>")
      if packageName:
        # Note: Do NOT use os.path.join, want a "/" even if path is generated on Windows
        # TODO: This is hardcoded to the path (currently) set in CMakeLists
        pdfZipFilename = "PDF/" + normalizePackageName(packageName) + ".zip"
        outputFile.write("&nbsp;|&nbsp;")
        outputFile.write("<a onclick=\"startDownloadPDFBundle('" + pdfZipFilename + "')\" \
                        class=\"qindex printAll\" href=\"#PrintAll\">Print All `" + packageName + "` Pages as PDF</a>")
      outputFile.write("</div>")
      outputFile.write("<div style=\"display:none;\" id=pdfSelection>\n")
      outputFile.write('''<h3>Customize PDF page</h3>\n''');
      outputFile.write('''<p>Select the objects that you wish to see in the downloaded PDF</p>\n''');
      outputFile.write('''</div>\n''');

# generate Indexed Page Table Row
def generateIndexedTableRow(outputFile, inputList, httpLinkFunction,
                            nameFunc=None, indexSet=set(char for char in string.uppercase)):
    if not inputList or len(inputList) == 0:
        return
    outputFile.write("<tr>")
    for item in inputList:
        if len(item) == 1 and item in indexSet:
            outputFile.write("<td><a name=\"%s\"></a>" % item)
            outputFile.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">")
            outputFile.write("<tr><td><div class=\"ah\">&nbsp;&nbsp;%s&nbsp;&nbsp;</div></td></tr>" % item)
            outputFile.write("</table></td>")
            indexSet.remove(item)
        else:
            displayName = item
            if nameFunc:
                displayName = nameFunc(item)
            outputFile.write("<td><a class=\"el\" href=\"%s\">%s</a>&nbsp;&nbsp;&nbsp;</td>" %
                             (httpLinkFunction(item),
                              displayName))
    outputFile.write("</tr>\n")

def generateIndexedPackageTableRow(outputFile, inputList,
                                   nameFunc=None, indexSet=set(char for char in string.uppercase)):
    generateIndexedTableRow(outputFile, inputList, getPackageHtmlFileName,
                            nameFunc, indexSet)

def generateIndexedRoutineTableRow(outputFile, inputList,
                                   nameFunc=None, indexSet=set(char for char in string.uppercase)):
    generateIndexedTableRow(outputFile, inputList, getRoutineHtmlFileName,
                            nameFunc, indexSet)
def generateIndexedPackageComponentTableRow(outputFile, inputList,
                                   nameFunc=None, indexSet=set(char for char in string.uppercase)):
    generateIndexedTableRow(outputFile, inputList, getPackageObjHtmlFileName,
                            nameFunc, indexSet)
def generateIndexedGlobalTableRow(outputFile, inputList,
                                  nameFunc=None, indexSet=set(char for char in string.uppercase)):
    generateIndexedTableRow(outputFile, inputList, getGlobalHtmlFileNameByName,
                            nameFunc, indexSet)

def getPackageDependencyHtmlFile(packageName, depPackageName):
    firstName = normalizePackageName(packageName)
    secondName = normalizePackageName(depPackageName)
    if firstName < secondName:
        temp = firstName
        firstName = secondName
        secondName = temp
    return "Package_%s-%s_detail.html" % (firstName, secondName)

def getPackagePackageDependencyHyperLink(packageName, depPackageName, name,
                                         tooltip, dependency):
    if dependency:
        edgeLinkArch = packageName
    else:
        edgeLinkArch = depPackageName
    packageDependencyHtmlFile = getPackageDependencyHtmlFile(packageName, depPackageName)
    return "<a href=\"%s#%s\", title=\"%s\">%s</a>" % (packageDependencyHtmlFile,
                                                       edgeLinkArch,
                                                       tooltip,
                                                       name)

#------------------------------------------------------------------------------
# Html helper functions
#------------------------------------------------------------------------------
def writeTableHeader(headerList, outputFile, classid=""):
    outputFile.write("<table>\n")
    outputFile.write("<tr class=\"%s\">\n" % classid)
    for header in headerList:
        outputFile.write("<th class=\"IndexKey\">%s</th>\n" % header)
    outputFile.write("</tr>\n")
def writeTableData(itemRow, outputFile):
    outputFile.write("<tr>\n")
    index = 0;
    for data in itemRow:
        if index == 0:
            key = "IndexKey"
        else:
            key = "IndexValue"
        outputFile.write("<td class=\"%s\">%s</td>\n" % (key, data))
        index += 1
    outputFile.write("</tr>\n")
def writeGenericTablizedData(headerList, itemList, outputFile):
    outputFile.write("<div><table>\n")
    if headerList and len(headerList) > 0:
        writeTableHeader(headerList, outputFile)
    if itemList and len(itemList) > 0:
        for itemRow in itemList:
            writeTableData(itemRow, outputFile)
    outputFile.write("</table></div>\n")
def writeListData(listData, outputFile, classid=""):
    outputFile.write(generateHtmlListData(listData, classid))

def writeColorLegend(outDir, outputFile):
    outputFile.write("<img id=\"colorLegendImg\"src=\"%s\" border=\"0\" alt=\"%s\" usemap=\"caller_colors\"/>\n" % (urllib.quote("colorLegend.png"),"Legend of Colors"))
    cmapFile = open(os.path.join(outDir, "colorLegend.cmapx"), 'r')
    for line in cmapFile:
        outputFile.write(line)

def writeLegends(outDir, outputFile):
    outputFile.write("<h3>Legends:</h3>")
    outputFile.write("<div class=\"contents colorLegendGrp\">\n")
    writeColorLegend(outDir,outputFile)
    outputFile.write(PCLegend.replace("<td class=\"","<td class=\"colorLegend " ))
    outputFile.write("</div>\n")

def generateHtmlListData(listData, classid=""):
    if not listData : return "<div></div>"
    output = "<div class=\"%s\"><ul>" % classid
    for item in listData:
        output += "<li>%s</li>" % item
    output += "</ul></div>"
    return output

def listDataToCommaSeperatorString(listData):
    if not listData: return ""
    result = ""
    index = 0
    for item in listData:
        if index < len(listData) - 1:
            result += "%s,&nbsp;" % item
        else:
            result += "%s&nbsp;" % item
        index += 1
    return result

def writeSectionEnd(outputFile):
    outputFile.write("</div>\n")
def writeSubSectionHeader(headerName, outputFile, classid=""):
    outputFile.write("<h3 class=\"%s\"align=\"left\">%s</h3>\n" % (classid, headerName))

#------------------------------------------------------------------------------
# PDF helper functions
#------------------------------------------------------------------------------
def generatePDFTableRow(data):
    row = []
    for val in data:
        row.append(generateParagraph(val))
    return row

def generateParagraph(text):
    try:
        if text is None: text = ""
        return Paragraph(text, styles['Heading6'])
    except UnicodeDecodeError as e:
        logger.warning("Failed to write to PDF:")
        logger.warning(text)
        logger.warning(e)
        return Paragraph(unicode(text, errors='ignore'), styles['Heading6'])

def generatePDFTableHeader(headerList, splitHeader=True):
    row = []
    for header in headerList:
        cell = []
        if splitHeader:
            # TODO: There is an extra line between words
            words = header.split(" ")
            for word in words:
                cell.append(Paragraph(word, styles['Heading4']))
        else:
            cell.append(Paragraph(header, styles['Heading4']))
        row.append(cell)
    return row

def generatePDFListData(listData):
    if not listData:
        return generateParagraph("")
    list = []
    for item in listData:
        list.append(ListItem(generateParagraph(item),leftIndent=7))
    return generateList(list)

def generateList(data):
    # Note: start is required when using `bullet` bulletType
    # (even though it's not explicitly mentioned in documentation)
    # TODO: Bullets need to be closer to text and indented
    return ListFlowable(data,
                        bulletType='bullet',
                        start='circle',
                        bulletFontSize=6,
                        leftIndent=7)

#------------------------------------------------------------------------------
# PDF *and* Html helper functions
#------------------------------------------------------------------------------
def writeSectionHeader(headerName, archName, outputFile, pdf, isAccordion='accordion'):
    outputFile.write("<div class='%s  %s'><h2 align=\"left\"><a name=\"%s\">%s</a></h2>\n"
        % (isAccordion,archName.split(" ")[0], archName, headerName))
    if pdf is not None:
        pdf.append(Spacer(1, 20))
        pdf.append(Paragraph(headerName, styles['Heading2']))

###############################################################################
# class to generate the web page based on input
class WebPageGenerator:
    def __init__(self, crossReference, outDir, pdfOutDir, repDir, docRepDir, git,
                 includeSource=False, rtnJson=None):
        self._crossRef = crossReference
        self._allPackages = crossReference.getAllPackages()
        self._allRoutines = crossReference.getAllRoutines()
        self._allGlobals = crossReference.getAllGlobals()
        self._outDir = outDir
        self._pdfOutDir = pdfOutDir
        if not os.path.exists(self._pdfOutDir):
            os.mkdir(self._pdfOutDir)
        self._repDir = repDir
        self._docRepDir = docRepDir
        self._git = git
        self._header = [] # TODO: Not used? header.html is in repo and __includeHeader__ is called.. a lot
        self._footer = []
        self._dot = ""
        self._source_header = []  # TODO: Not used?
        self._includeSource = includeSource
        self.__initWebTemplateFile__()
        with open(rtnJson, 'r') as jsonFile:
            self._rtnRefJson = json.load(jsonFile)

    def __initWebTemplateFile__(self):
        #load _header and _footer in the memory
        self.__generateHtmlPageHeader__(True)
        self.__generateHtmlPageHeader__(False)
        webDir = os.path.join(self._docRepDir, "Web")
        footer = open(os.path.join(webDir, "footer.html"), 'r')
        for line in footer:
            self._footer.append(line)
        footer.close()

    def setDot(self, dot):
        self._dot = dot

    def __includeHeader__(self, outputFile, indexList=""):
        for line in (self._header):
            outputFile.write(line)
    def __includeFooter__(self, outputFile):
        for line in self._footer:
            outputFile.write(line)
    def __includeSourceHeader__(self, outputFile):
        for line in self._source_header:
            outputFile.write(line)

    def __getPDFDirectory__(self, packageName):
        dir = os.path.join(self._pdfOutDir, normalizePackageName(packageName))
        if not os.path.exists(dir):
            os.mkdir(dir)
        return dir

    def queryICRInfo(self, package, type, val):
      icrList = []
      #  Find entries that have a certain top-level parameter
      #
      #  example call queryICRInfo("ROUTINE","ROUTINE","SDAM1")
      #  Would return all "ROUTINE" types where the "ROUTINE" field equals 'SDAM1'
      #
      if package in self._crossRef._icrJson.keys():
        for keyVal in self._crossRef._icrJson[package].keys():
          if type == "*":
              for keyEntry in self._crossRef._icrJson[package][keyVal].keys():
                for entry in self._crossRef._icrJson[package][keyVal][keyEntry]:
                  icrList.append(entry)
          else:
            if val in self._crossRef._icrJson[package][keyVal].keys():
              for entry in self._crossRef._icrJson[package][keyVal][val]:
                icrList.append(entry)
      return icrList

    def generateWebPage(self):
        self.failures = []
        self.generateIndexHtmlPage()
        self.generateColorLegend()
        self.generatePackageNamespaceGlobalMappingPage()
        if self._dot:
            self.generatePackageDependenciesGraph()
            self.generatePackageDependentsGraph()
        self.generateGlobalNameIndexPage()
        self.generateIndividualGlobalPage()
        self.generateGlobalFileNoIndexPage()
        self.generateFileManSubFileIndexPage()
        self.generatePackageIndexPage()
        self.generateRoutineIndexPage()
        if self._dot:
            self.generateRoutineCallGraph()
            self.generateRoutineCallerGraph()
        self.generateAllSourceCodePage(not self._includeSource)
        self.generateAllIndividualRoutinePage()
        self.generatePackagePackageInteractionDetail()
        self.generatePackageInformationPages()
        self.generateIndividualPackagePage()

        self.copyFilesToOutputDir()
        self.zipPDFFiles()
        if self.failures:
          # TODO: Log failures
          pass

#===============================================================================
# Method to generate the index.html page
#===============================================================================
    def generateIndexHtmlPage(self):
        outputFile = open(os.path.join(self._outDir, "index.html"), 'wb')
        outputFile.write(COMMON_HEADER_PART)
        outputFile.write("<title>OSEHRA VistA Code Documentation</title>")
        outputFile.write(GOOGLE_ANALYTICS_JS_CODE)
        outputFile.write(HEADER_END)
        outputFile.write(DEFAULT_BODY_PART)
        outputFile.write(INDEX_HTML_PAGE_OSEHRA_IMAGE_PART)
        outputFile.write(INDEX_HTML_PAGE_HEADER)
        outputFile.write(TOP_INDEX_BAR_PART)
        outputFile.write(INDEX_HTML_PAGE_INTRODUCTION_PART)
        self.__generateGitRepositoryKey__(outputFile)
        self.__includeFooter__(outputFile)

    def __generateGitRepositoryKey__(self, outputFile):
        sha1Key = self.__getGitRepositLatestSha1Key__()
        outputFile.write("""<h6><a class ="anchor" id="howto"></a>Note:Repository SHA1 key:%s</h6>\n""" % sha1Key)

    def __getGitRepositLatestSha1Key__(self):
        gitCommand = "\"" + self._git + "\"" + " rev-parse --verify HEAD"
        os.chdir(self._repDir)
        if os.path.exists(os.path.join(self._repDir,'.git')):
          logger.debug("git Command is %s" % gitCommand)
          result = subprocess.check_output(gitCommand, shell=True)
          return result.strip()
        return ""
    def __generateHtmlPageHeader__(self, isSource = False):
        if isSource:
            output = self._source_header
        else:
            output = self._header
        output.append(COMMON_HEADER_PART)
        if isSource:
            output.append(CODE_PRETTY_JS_CODE)
        output.append(GOOGLE_ANALYTICS_JS_CODE)
        output.append(HEADER_END)
        if isSource:
            output.append(SOURCE_CODE_BODY_PART)
        else:
            output.append(DEFAULT_BODY_PART)
        output.append(TOP_INDEX_BAR_PART)

#===============================================================================
# Method to generate Package Namespace Mapping page
#===============================================================================
    def generatePackageNamespaceGlobalMappingPage(self):
        outputFile = open(os.path.join(self._outDir, "Packages_Namespace_Mapping.html"), 'wb')
        self.__includeHeader__(outputFile)
        outputFile.write("<title>Package Namespace Mapping</title>")
        outputFile.write("<div><h1>%s</h1></div>\n" % "Package Namespace Mapping")
        writeTableHeader(["PackageName",
                          "Namespaces",
                          "Additional Globals"],
                         outputFile)
        allPackage = sorted(self._allPackages.keys())
        for packageName in allPackage:
            package = self._allPackages[packageName]
            namespaces = package.getNamespaces()
            globalNamespaces = package.getGlobalNamespace()
            totalCol = max(len(namespaces),
                           len(globalNamespaces))
            for index in range(totalCol):
                outputFile.write("<tr>")
                # write the package name
                if index == 0:
                    outputFile.write("<td class=\"IndexKey\">%s</td>" % getPackageHyperLinkByName(packageName))
                else:
                    outputFile.write("<td class=\"IndexKey\"></td>")
                # write the namespace
                if index <= len(namespaces) - 1:
                    outputFile.write("<td class=\"IndexValue\">%s</td>" % namespaces[index])
                else:
                    outputFile.write("<td class=\"IndexValue\"></td>")
                # write the additional globals
                if index <= len(globalNamespaces) - 1:
                    outputFile.write("<td class=\"IndexValue\">%s</td>" % globalNamespaces[index])
                else:
                    outputFile.write("<td class=\"IndexValue\"></td>")
                outputFile.write("</tr>\n")
        outputFile.write("</table>\n")
        outputFile.write("<BR>\n")
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
#
#===============================================================================
    def generateGlobalNameIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "globals.html"), 'w')
        self.__includeHeader__(outputFile)
        outputFile.write("<title>Global Index List</title>")
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Global Index List</h1>\n</div>\n</div>")
        generateIndexBar(outputFile, string.uppercase, isIndex = True, printButton=True)
        outputFile.write("<div class=\"contents\">\n")
        sortedGlobals = [] # a list of list
        for globalVar in self._allGlobals.itervalues():
            sortedName = globalVar.getName()[1:] # get rid of ^
            if sortedName.startswith('%'): # get rid of %
                sortedName = sortedName[1:]
            sortedGlobals.append([sortedName, globalVar.getName()])
        sortedGlobals = sorted(sortedGlobals,
                             key=lambda item: item[0])
        for letter in string.uppercase:
            bisect.insort_left(sortedGlobals, [letter, letter])
        totalGlobals = len(sortedGlobals)
        totalCol = 4
        numPerCol = totalGlobals / totalCol + 1
        outputFile.write("<table align=\"center\" width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n")
        for i in range(numPerCol):
            itemsPerRow = [];
            for j in range(totalCol):
                if (i + numPerCol * j) < totalGlobals:
                    itemsPerRow.append(sortedGlobals[i + numPerCol * j][1]);
            generateIndexedGlobalTableRow(outputFile, itemsPerRow)
        outputFile.write("</table>\n</div>\n")
        generateIndexBar(outputFile, string.uppercase, isIndex = True)
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
#
#===============================================================================
    def generateGlobalFileNoIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "filemanfiles.html"), 'wb')

#===============================================================================
#
#===============================================================================
    def __generateGlobalFileNoIndexPage__(self):
        allFileManFilesList = []
        for item in self._allGlobals.itervalues():
            if item.isFileManFile():
                allFileManFilesList.append(item)
        self.__includeHeader__(outputFile)
        outputFile.write("<title>FileMan Files List</title>")
        outputFile.write("<div><h1>%s</h1></div>\n" % "All FileMan Files List Total: %d" % len(allFileManFilesList))
        writeTableHeader(["FileMan Name",
                          "FileMan FileNo",
                          "Global Name"],
                         outputFile)
        sortedFileManList = sorted(allFileManFilesList, key=lambda item: float(item.getFileNo()))
        for fileManFile in sortedFileManList:
            outputFile.write("<tr>")
            outputFile.write("<td class=\"IndexKey\">%s</td>" % getFileManFileHypeLinkWithFileManName(fileManFile))
            outputFile.write("<td class=\"IndexKey\">%s</td>" % getFileManFileHypeLinkWithFileNo(fileManFile))
            outputFile.write("<td class=\"IndexKey\">%s</td>" % getGlobalHypeLinkByName(fileManFile.getName()))
            outputFile.write("</tr>\n")
        outputFile.write("</table>\n")
        outputFile.write("<BR>\n")
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
#
#===============================================================================
    def generateFileManSubFileIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "filemansubfiles.html"), 'wb')
        allSubFiles = self._crossRef.getAllFileManSubFiles()
        self.__includeHeader__(outputFile)
        outputFile.write("<title id=\"pageTitle\">Fileman Sub-Files</title>")
        outputFile.write("<div><h1>%s</h1></div>\n" % "All FileMan Sub-Files List Total: %d" % len(allSubFiles))
        writeTableHeader(["Sub-File Name",
                          "Sub-File FileNo",
                          "Package Name"],
                         outputFile)
        sortedSubFileList = sorted(allSubFiles.values(), key=lambda item: float(item.getFileNo()))
        for subFile in sortedSubFileList:
            outputFile.write("<tr>")
            outputFile.write("<td class=\"IndexKey\">%s</td>" %
                getFileManSubFileHypeLinkWithName(subFile))
            outputFile.write("<td class=\"IndexKey\">%s</td>" %
                getFileManSubFileHypeLinkByName(subFile))
            package = subFile.getRootFile().getPackage()
            outputFile.write("<td class=\"IndexKey\">%s</td>" %
                getPackageHyperLinkByName(package.getName()))
            outputFile.write("</tr>\n")
        outputFile.write("</table>\n")
        outputFile.write("<BR>\n")
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
#
#===============================================================================
    def generateIndividualGlobalPage(self):
        logger.info("Start generating individual globals......")

        for package in self._allPackages.itervalues():
            packageName = package.getName()
            for (globalName, globalVar) in package.getAllGlobals().iteritems():
                isFileManFile = globalVar.isFileManFile()

                if isFileManFile:
                    indexList = ["Info", "Desc",
                                 "Directly Accessed By Routines",
                                 "Accessed By FileMan Db Calls",
                                 "Pointed To By FileMan Files",
                                 "Pointer To FileMan Files", "Fields"]
                else:
                    indexList = ["Directly Accessed By Routines"]
                htmlFileName = os.path.join(self._outDir,
                                               getGlobalHtmlFileNameByName(globalName))
                pdfFileName = os.path.join(self.__getPDFDirectory__(packageName),
                                           getGlobalPDFFileNameByName(globalName))
                outputFile = open(htmlFileName, 'wb')

                # Setup the pdf document
                buf = io.BytesIO()
                self.doc = SimpleDocTemplate(
                    buf,
                    rightMargin=inch/2,
                    leftMargin=inch/2,
                    topMargin=inch/2,
                    bottomMargin=inch/2,
                    pagesize=letter,
                )
                pdf = []

                rtnIndexes = [
                   {
                     "name": "External References", # this is also the link name
                     "data" : globalVar.getExternalReference, # the data source
                   },
                   # Interaction Code section
                   {
                     "name": "Interaction Calls", # this is also the link name
                     "data" : globalVar.getInteractionEntries, # the data source
                   },
                   # Used in RPC section
                   {
                     "name": "Used in RPC", # this is also the link name
                     "data" : self.__getRpcReferences__, # the data source
                     "dataarg" : [globalName], # extra arguments for data source
                   },
                   # Used in HL7 Interface section
                   {
                     "name": "Used in HL7 Interface", # this is also the link name
                     "data" : self.__getHl7References__, # the data source
                     "dataarg" : [globalName], # extra arguments for data source
                   },
                   # FileMan Files Accessed Via FileMan Db Call section
                   {
                     "name": "FileMan Files Accessed Via FileMan Db Call", # this is also the link name
                     "data" : globalVar.getFilemanDbCallGlobals, # the data source
                   },
                   # Global Variables Directly Accessed section
                   {
                     "name": "Global Variables Directly Accessed", # this is also the link name
                     "data" : globalVar.getGlobalVariables, # the data source
                   },
                   # Label References section
                   {
                     "name": "Label References", # this is also the link name
                     "data" : globalVar.getLabelReferences, # the data source
                   },
                   # Naked Globals section
                   {
                     "name": "Naked Globals", # this is also the link name
                     "data" : globalVar.getNakedGlobals, # the data source
                   },
                   # Local Variables section
                   {
                     "name": "Local Variables", # this is also the link name
                     "data" : globalVar.getLocalVariables, # the data source
                   },
                   # Marked Items section
                   {
                     "name": "Marked Items", # this is also the link name
                     "data" : globalVar.getMarkedItems, # the data source
                   }
                ]
                outputFile = open(os.path.join(self._outDir,
                                               getGlobalHtmlFileNameByName(globalName)), 'wb')
                self.__includeHeader__(outputFile)

                icrList = self.queryICRInfo(packageName.upper(),"GLOBAL", globalName[1:])
                if icrList:
                  indexList.append("ICR Entries")

                rtnIndexList,idxLst = findRelevantIndex(rtnIndexes,None)
                indexList = indexList + rtnIndexList
                outputFile.write("<script>var titleList = " + str(indexList) + "</script>\n")
                outputFile.write("")
                # generated the qindex bar
                generateIndexBar(outputFile, indexList, printButton=True)
                title = "Global: %s" % globalName
                writePDFCustomization(outputFile, str(indexList))
                self.writeTitleBlock(title, title, package, outputFile, pdf)
                outputFile.write(getAccordionHTML())
                if isFileManFile:
                    # Information
                    writeSectionHeader("Information", "Info", outputFile, pdf, isAccordion="")
                    infoHeader = ["FileMan FileNo", "FileMan Filename", "Package"]
                    itemList = [[globalVar.getFileNo(),
                              globalVar.getFileManName(),
                              getPackageHyperLinkByName(package.getName())]]
                    self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid="information")
                    self.__writeGenericTablizedPDFData__(infoHeader, itemList, pdf)
                    writeSectionHeader("Description", "Desc", outputFile, pdf,isAccordion="")
                    # TODO: Write as a normal paragraph or series of paragraphs (i.e. not a list)
                    writeListData(globalVar.getDescription(), outputFile, classid="description")
                    pdf.append(generatePDFListData(globalVar.getDescription()))
                    writeSectionEnd(outputFile)
                # Directly Accessed By Routines
                totalRoutines = globalVar.getTotalNumberOfReferencedRoutines()
                if totalRoutines:
                    writeSectionHeader("Directly Accessed By Routines, Total: %d" % totalRoutines,
                                        "Directly Accessed By Routines", outputFile,
                                        pdf if totalRoutines else None)
                    self.generateGlobalRoutineDependentsSection(globalVar.getAllReferencedRoutines(),
                                                                outputFile, pdf, classid="directCall")
                    writeSectionEnd(outputFile)
                # Accessed By FileMan Db Calls
                fileManDbCallRtns = globalVar.getFileManDbCallRoutines()
                totalNumDbCallRtns = 0
                if fileManDbCallRtns:
                    DbCallRtnsNos = [len(x) for x in
                        fileManDbCallRtns.itervalues()]
                    totalNumDbCallRtns = sum(DbCallRtnsNos)
                if isFileManFile:
                    writeSectionHeader("Accessed By FileMan Db Calls, Total: %d" %
                                       totalNumDbCallRtns,
                                       "Accessed By FileMan Db Calls", outputFile,
                                       pdf if totalNumDbCallRtns else None)
                if fileManDbCallRtns:
                    self.generateGlobalRoutineDependentsSection(fileManDbCallRtns,
                                                                outputFile,
                                                                pdf if totalNumDbCallRtns else None,
                                                                classid="gblRtnDep")
                else:
                    outputFile.write("<div></div>")
                writeSectionEnd(outputFile)
                if isFileManFile:
                    # Pointed to By FileMan Files
                    writeSectionToPDF = globalVar.getTotalNumberOfReferredGlobals() > 0
                    writeSectionHeader("Pointed To By FileMan Files, Total: %d" % globalVar.getTotalNumberOfReferredGlobals(),
                                       "Pointed To By FileMan Files",
                                       outputFile,
                                       pdf if writeSectionToPDF else None)
                    self.generateGlobalPointedToSection(globalVar, outputFile,
                                                        pdf if writeSectionToPDF else None,
                                                        True, classid="gblPointedTo")
                    writeSectionEnd(outputFile)

                    # Pointer To FileMan Files
                    writeSectionToPDF = globalVar.getTotalNumberOfReferencedGlobals() > 0
                    writeSectionHeader("Pointer To FileMan Files, Total: %d" % globalVar.getTotalNumberOfReferencedGlobals(),
                                       "Pointer To FileMan Files",
                                       outputFile,
                                       pdf if writeSectionToPDF else None)
                    self.generateGlobalPointedToSection(globalVar, outputFile,
                                                        pdf if writeSectionToPDF else None,
                                                        False, classid="gblPointerTo")
                    writeSectionEnd(outputFile)

                    # Fields
                    totalNoFields = 0
                    allFields = globalVar.getAllFileManFields()
                    if allFields: totalNoFields = len(allFields)
                    writeSectionHeader("Fields, Total: %d" % totalNoFields, "Fields", outputFile, pdf)
                    self.__generateFileManFileDetails__(globalVar, outputFile, pdf)
                    writeSectionEnd(outputFile)

                if icrList:
                   writeSectionHeader("ICR Entries", "ICR Entries", outputFile, pdf)
                   self.generateGlobalICRSection(icrList, outputFile, pdf)
                   writeSectionEnd(outputFile)
                self.__generateIndividualRoutinePage__(globalVar,pdf,platform=None,existingOutFile=outputFile,DEFAULT_HEADER_LIST=PACKAGE_OBJECT_SECTION_HEADER_LIST)
                generateIndexBar(outputFile, indexList)
                self.__includeFooter__(outputFile)
                outputFile.close()

                try:
                    # Write the PDF to a file
                    self.doc.build(pdf)
                    with open(pdfFileName, 'w') as fd:
                        fd.write(buf.getvalue())
                except:
                    self.failures.append(pdfFileName)
                    pass

                # generate individual sub files
                if isFileManFile:
                    subFiles = globalVar.getAllSubFiles()
                    if subFiles:
                        for subFile in subFiles.itervalues():
                            self.__generateFileManSubFilePage__(subFile)
        logger.info("End of generating individual globals......")

#===============================================================================
#
#===============================================================================
    def __generateFileManSubFilePage__(self, subFile):
        logger.debug("Start generating individual subfile [%s]" % subFile.getFileNo())
        indexList = ["Info", "Details"]
        outputFile = open(os.path.join(self._outDir,
                                       getFileManSubFileHtmlFileName(subFile)), 'wb')

        # Setup the pdf document
        buf = io.BytesIO()
        self.doc = SimpleDocTemplate(
            buf,
            rightMargin=inch/2,
            leftMargin=inch/2,
            topMargin=inch/2,
            bottomMargin=inch/2,
            pagesize=landscape(letter),
            )
        pdf = []

        # write the same _header file
        self.__includeHeader__(outputFile)
        # generated the qindex bar
        generateIndexBar(outputFile, indexList, printButton=True)
        writePDFCustomization(outputFile, str(indexList))
        # get the root file package
        fileIter = subFile
        topDownList=[fileIter]
        while not fileIter.isRootFile():
            fileIter = fileIter.getParentFile()
            topDownList.append(fileIter)
        topDownList.reverse()
        package = fileIter.getPackage()
        title = "Sub-Field: %s" % subFile.getFileNo()
        # generate # link list
        linkHtmlTxt = ""
        linkPDFTxt = ""
        index = 0
        for item in topDownList:
            if index == 0:
                linkHtmlTxt += getFileManFileHypeLink(item)
                if not item.isFileManFile():
                    linkPDFTxt += item.getName()
                if item.isSubFile():
                    linkPDFTxt += getFileManSubFileHtmlFileNameByName(item.getFileNo())
                linkPDFTxt += getGlobalDisplayName(item)
            else:
                linkHtmlTxt += getFileManSubFileHypeLinkByName(item.getFileNo())
                linkPDFTxt += item.getFileNo()
            if index < len(topDownList) - 1:
                linkHtmlTxt += "-->"
                linkPDFTxt += "-->"
            index += 1
        self.writeTitleBlock(title, title, package, outputFile, pdf, linkHtmlTxt, linkPDFTxt)
        outputFile.write(getAccordionHTML())

        packageName = package.getName();

        # Information
        writeSectionHeader("Information", "Info", outputFile, pdf,isAccordion="") 
        infoHeader = ["Parent File", "Name", "Number", "Package"]
        parentFile = subFile.getParentFile()
        parentFileLink = ""
        if parentFile.isRootFile():
            parentFileLink = getFileManFileHypeLink(parentFile)
        else:
            parentFileLink =  getFileManSubFileHypeLinkByName(parentFile.getFileNo())
        itemList = [[parentFileLink, subFile.getFileManName(), subFile.getFileNo(),
                  getPackageHyperLinkByName(packageName)]]
        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid="information")
        self.__writeGenericTablizedPDFData__(infoHeader, itemList, pdf)
        writeSectionEnd(outputFile)

        # Details
        writeSectionHeader("Details", "Details", outputFile, pdf)
        self.__generateFileManFileDetails__(subFile, outputFile, pdf)
        writeSectionEnd(outputFile)

        # generated the index bar at the bottom
        generateIndexBar(outputFile, indexList)
        self.__includeFooter__(outputFile)
        outputFile.close()

        try:
            # Write the PDF to a file
            pdfFileName = os.path.join(self.__getPDFDirectory__(packageName),
                                       getFileManSubFilePDFFileNameByName(subFile))
            self.doc.build(pdf)
            with open(pdfFileName, 'w') as fd:
                fd.write(buf.getvalue())
        except:
            self.failures.append(pdfFileName)
            pass

        logger.debug("End of generating individual subFile [%s]" % subFile.getFileNo())

#===============================================================================
#
#===============================================================================
    def __generateFileManFileDetails__(self, fileManFile, outputFile, pdf):
        assert isinstance(fileManFile, FileManFile)
        # sort the file man field by file #
        allFields = fileManFile.getAllFileManFields()
        if not allFields or len(allFields) == 0: return
        # sort the fields # by the float value
        sortedFields = sorted(allFields.keys(), key=lambda item: float(item))
        outputFieldsList = []
        pdfOutputFieldsList = []
        for key in sortedFields:
            value = allFields[key]
            location = value.getLocation()
            if not location: location = ""
            fieldNo = value.getFieldNo()
            fieldNoTxt = "<a name=\"%s\">%s</a>" % (fieldNo, fieldNo)
            type = value.getTypeName()
            if type is None: type = ""
            # Add the first 4 columns to the row
            fieldRow = [fieldNoTxt, value.getName(), location, type]
            pdfFieldRow = []
            # Make sure we're adding Paragraphs not just strings
            # so that the text will wrap, if needed
            pdfFieldRow.append(generateParagraph(fieldNo))
            pdfFieldRow.append(generateParagraph(value.getName()))
            pdfFieldRow.append(generateParagraph(location))
            pdfFieldRow.append(generateParagraph(type))
            # Generate the last column
            fieldDetails = ""
            pdfFieldDetails = ""
            pdfCell = []
            if value.__getattribute__("_isRequired"):
                text = "************************REQUIRED FIELD************************"
                fieldDetails += "<div style='text-align: center'><b>%s</b></div>" % text
                pdfCell.append(generateParagraph(("<b>****REQUIRED FIELD****</b>")))
            if value.isSetType():
                # nice display of set members
                setIter = value.getSetMembers()
                fieldDetails += generateHtmlListData(setIter)
                pdfCell.append(generatePDFListData(setIter))
            elif value.isFilePointerType():
                globalVar = value.getPointedToFile()
                if globalVar:
                    fieldDetails += (getFileManFileHypeLink(globalVar))
                    if not globalVar.isFileManFile():
                        pdfFieldDetails += globalVar.getName()
                    elif globalVar.isSubFile():
                        pdfFieldDetails += getFileManSubFileHtmlFileNameByName(globalVar.getFileNo())
                    else:
                        pdfFieldDetails += getGlobalDisplayName(globalVar)
            elif value.isVariablePointerType():
                fileManFiles = value.getPointedToFiles()
                for pointedToFile in fileManFiles:
                    fieldDetails += getFileManFileHypeLink(pointedToFile) + "&nbsp;&nbsp;"
                    if not pointedToFile.isFileManFile():
                        pdfFieldDetails += pointedToFile.getName()
                    elif pointedToFile.isSubFile():
                        pdfFieldDetails += getFileManSubFileHtmlFileNameByName(pointedToFile.getFileNo())
                    else:
                        pdfFieldDetails += getGlobalDisplayName(pointedToFile)
            elif value.isSubFilePointerType():
                filePointer = value.getPointedToSubFile()
                if filePointer:
                    fieldDetails += getFileManSubFileHypeLinkByName(filePointer.getFileNo())
                    pdfFieldDetails += filePointer.getFileNo()
            # logic to append field extra details here
            fieldDetails += self.__generateFileManFieldPropsDetailsList__(value)
            fieldRow.append(fieldDetails)
            outputFieldsList.append(fieldRow)
            pdfCell.append(generateParagraph(pdfFieldDetails))
            numSections, pdfDetailsList = self.__generateFileManFieldPropsDetailsListPDF__(value)
            if pdfDetailsList is not None:
                if numSections == 1:
                    pdfCell.append(pdfDetailsList)
                else:
                    # make copy of the row
                    row = pdfFieldRow[:]
                    cell = pdfCell[:]
                    n = 0
                    for details in pdfDetailsList:
                        cell.append(details)
                        row.append(cell)
                        if n > 0:
                            row[0] = (generateParagraph(fieldNo + " (cont.)"))
                        pdfOutputFieldsList.append(row)
                        row = pdfFieldRow[:]
                        cell =[]
                        n += 1
            if numSections < 2: # 0 or 1
                pdfFieldRow.append(pdfCell)
                pdfOutputFieldsList.append(pdfFieldRow)
        fieldHeaderList = ["Field #", "Name", "Loc", "Type", "Details"]
        self.writeGenericTablizedHtmlData(fieldHeaderList, outputFieldsList, outputFile, classid="fmFields")
        columns = 13
        columnWidth = self.doc.width/columns
        colWidths = [columnWidth, columnWidth*2, columnWidth, columnWidth*2, columnWidth*7]
        self.__writeGenericTablizedPDFData__(fieldHeaderList, pdfOutputFieldsList, pdf,
                                              columnWidths=colWidths, isString=False)
#===============================================================================
#
#===============================================================================
    def __generateFileManFieldPropsDetailsList__(self, fileManField):
        if not fileManField:
            return ""
        propList = fileManField.getPropList()
        if not propList or len(propList) == 0:
            return ""
        output = "<p><ul>"
        for (name, values) in propList:
            output += "<li><dl><dt>%s&nbsp;&nbsp;<code>%s</code></dt>" % (name, values[0])
            for value in values[1:]:
                output += "<dd><pre>%s</pre></dd>" % value
            output += "</dl></li>"
        output += "</ul>"
        return output

    def __generateFileManFieldPropsDetailsListPDF__(self, fileManField):
        # TODO: The formatting on this is not identical to the HTML page (above)
        if not fileManField:
            return 0, None
        propList = fileManField.getPropList()
        if not propList or len(propList) == 0:
            return 0, None
        if len(propList) <= 1:
            output = []
            for (name, values) in propList:
                item = []
                item.append(generateParagraph("<b>%s</b> %s" % (name, values[0])))
                for value in values[1:]:
                    item.append(generateParagraph(value))
                output.append(ListItem(item, leftIndent=7, bulletOffsetY=-3))
            return 1, generateList(output)
        retval = []
        output = []
        for (name, values) in propList:
            if "CROSS-REFERENCE" in name or \
               "TECHNICAL DESCR" in name or \
               "DESCRIPTION" in name or \
               "FIELD INDEX" in name:
                # Start a new row for each potentially really long field...
                # This is an attempt to keep the entire row on one page
                # (reportlab limitation)
                retval.append(generateList(output))
                output = []
            fieldName = generateParagraph("<b>%s</b> %s" % (name, values[0]))
            if "TECHNICAL DESCR" not in name and "DESCRIPTION" not in name:
                item = []
                item.append(fieldName)
                for value in values[1:]:
                    item.append(generateParagraph(value))
                output.append(ListItem(item, leftIndent=7, bulletOffsetY=-3))
            # Each paragraph of 'TECHNICAL DESCR' and 'DESCRIPTION' is split
            # into its own row
            else:
                for value in values[1:]:
                    item = []
                    item.append(fieldName)
                    item.append(generateParagraph(value))
                    # TODO: This shouldn't be bulleted, just indented
                    retval.append(generateList(item))
        retval.append(generateList(output))
        return len(retval), retval

#===============================================================================
#
#===============================================================================
    def generateGlobalPointedToSection(self, globalVar, outputFile, pdf, isPointedBy, classid=""):
        if isPointedBy:
          pointedByGlobals = globalVar.getAllReferencedFileManFiles()
        else:
          pointedByGlobals = globalVar.getAllReferredFileManFiles()
        sortedPackage = sorted(sorted(pointedByGlobals.keys()),
                           key=lambda item: len(pointedByGlobals[item]),
                           reverse=True)
        infoHeader = ["Package", "Total", "FileMan Files"]
        itemList = []
        pdfItemList = []
        for package in sortedPackage:
            globalDict = pointedByGlobals[package]
            itemRow = []
            itemRow.append(getPackageHyperLinkByName(package.getName()))
            itemRow.append(len(globalDict))
            #
            pdfItemRow = []
            pdfItemRow.append(generateParagraph(package.getName()))
            pdfItemRow.append(generateParagraph(str(len(globalDict))))
            #
            globalData = ""
            pdfGlobalData = []
            index = 0
            for Global in sorted(globalDict.keys()):
                globalData += ("<a class=\"e1\" href=\"%s\">%s</a>" %
                             (getGlobalHtmlFileNameByName(Global.getName()),
                              getGlobalDisplayName(Global)))
                pdfData = getGlobalDisplayName(Global)
                detailedList = globalDict[Global]
                if not detailedList or len(detailedList) ==0:
                    continue
                fieldLinkGlobal = Global
                if not isPointedBy:
                    fieldLinkGlobal = globalVar
                globalData +="["
                pdfData += "["
                index = 0
                for item in detailedList:
                    if not item[1]:
                        itemHtmlText = ("<a class=\"e2 %s\" href=\"%s#%s\">%s</a>" %
                                       (classid,
                                        getGlobalHtmlFileNameByName(fieldLinkGlobal.getName()),
                                        item[0], item[0]))
                        itemPDFText = item[0]
                    else:
                        itemHtmlText = ("<a class=\"e2\" href=\"%s#%s\">#%s(%s)</a>" %
                                       (getFileManSubFileHtmlFileNameByName(item[1]),
                                        item[0], item[1], item[0]))
                        itemPDFText = "#%s(%s)" % (item[1], item[0])
                    globalData += itemHtmlText
                    pdfData += itemPDFText
                    if index < len(detailedList) - 1:
                        globalData += ",&nbsp"
                    index += 1
                globalData +="]"
                pdfData += "]"
                if (index + 1) % 4 == 0:
                    globalData += "<BR>"
                else:
                    globalData += "&nbsp;&nbsp;&nbsp;&nbsp;"
                index += 1
                pdfGlobalData.append(generateParagraph(pdfData))

            itemRow.append(globalData)
            pdfItemRow.append(pdfGlobalData)

            itemList.append(itemRow)
            pdfItemList.append(pdfItemRow)
        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid=classid)
        if pdf is not None:
            columns = 8
            columnWidth = self.doc.width/columns
            colWidths = [columnWidth, columnWidth, columnWidth * 6]
            self.__writeGenericTablizedPDFData__(infoHeader, pdfItemList, pdf,
                                                 columnWidths=colWidths, isString=False)

#===============================================================================
#
#===============================================================================
    def generateGlobalRoutineDependentsSection(self, depRoutines,
                                               outputFile, pdf, classid=""):
        sortedPackage = sorted(sorted(depRoutines.keys()),
                               key=lambda item: len(depRoutines[item]),
                               reverse=True)
        infoHeader = ["Package", "Total", "Routines"]
        itemList = []
        pdfItemList = [] # No html markup
        for package in sortedPackage:
            routineSet = depRoutines[package]
            #
            itemRow = []
            itemRow.append(getPackageHyperLinkByName(package.getName()))
            itemRow.append(len(routineSet))
            #
            pdfItemRow = []
            pdfItemRow.append(package.getName())
            pdfItemRow.append(len(routineSet))
            #
            routineData = ""
            pdfRoutineData = ""
            index = 0
            for routine in sorted(routineSet):
                routineData += ("<a class=\"e1\" href=\"%s\">%s" %
                             (getRoutineHtmlFileName(routine.getName()),
                              routine.getName()))
                if (index + 1) % 8 == 0:
                    routineData += "</a><BR>"
                else:
                    routineData += "</a>&nbsp;&nbsp;&nbsp;&nbsp;"
                pdfRoutineData += routine.getName() + " "
                index += 1
            itemRow.append(routineData)
            itemList.append(itemRow)
            pdfItemRow.append(pdfRoutineData)
            pdfItemList.append(pdfItemRow)
        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid=classid)
        if pdf:
            columns = 8
            columnWidth = self.doc.width/columns
            colWidths = [columnWidth, columnWidth, columnWidth * 6]
            self.__writeGenericTablizedPDFData__(infoHeader, pdfItemList, pdf, colWidths)

#===============================================================================
# method to generate the interactive detail list page between any two packages
#===============================================================================
    def generatePackagePackageInteractionDetail(self):
        packDepDict = dict()
        for package in self._allPackages.itervalues():
            for depDict in (package.getPackageRoutineDependencies(),
                            package.getPackageGlobalRoutineDependencies(),
                            package.getPackageGlobalDependencies(),
                            package.getPackageFileManFileDependencies(),
                            package.getPackageFileManDbCallDependencies()):
                self._updatePackageDepDict(package, depDict, packDepDict)
        for (key, value) in packDepDict.iteritems():
            self.generatePackageInteractionDetailPage(key, value[0], value[1])

    def generateGlobalICRSection(self, icrInfo, outfile, pdf):
      headerList = ["ICR LINK", "Subscribing Package(s)",
                    "Fields Referenced", "Description"]
      icrTable = []
      icrTablePDF = []
      for entry in icrInfo:
        icrLink = "<a href='%s'>ICR #%s</a>" % (getICRHtmlFileName(entry), entry["NUMBER"])
        icrLinkPDF = generateParagraph("ICR #%s" % entry["NUMBER"])
        subscribingPackage = ""
        subscribingPackagesPDF = []
        if "SUBSCRIBING PACKAGE" in entry:
          subscribingPackages = []
          for value in entry["SUBSCRIBING PACKAGE"]:
            pkgName = value["SUBSCRIBING PACKAGE"][0] if type(value["SUBSCRIBING PACKAGE"]) is list else value["SUBSCRIBING PACKAGE"]
            subscribingPackage += "<li>" + getPackageHyperLinkByName(pkgName) + "</li>"
            if pkgName in pkgMap:
              pkgName = pkgMap[pkgName]
            subscribingPackages.append(generateParagraph(pkgName))
          subscribingPackagesPDF = generateList(subscribingPackages)
        fieldsReferenced = ""
        fieldsReferencedPDF = []
        if ("GLOBAL REFERENCE" in entry):
          for reference in entry["GLOBAL REFERENCE"]:
            if "FIELD NUMBER" in reference:
              for value in reference["FIELD NUMBER"]:
                name = value["FIELD NAME"] if "FIELD NAME" in value else ""
                num = value["FIELD NUMBER"] if "FIELD NUMBER" in value else ""
                accessString = value["ACCESS"] if "ACCESS" in value else ""
                fieldsReferenced += "%s (<a href='#%s'>%s</a>). <br/> <b>Access:</b> %s" % (name, num, num, accessString)
                fieldsReferenced += "<br/><br/>"
                fieldsReferencedPDF.append(generateParagraph("%s (%s)." % (name, num)))
                fieldsReferencedPDF.append(generateParagraph("<b>Access:</b> %s" % accessString))
        else:
            fieldsReferencedPDF.append(generateParagraph(""))
        description = ""
        if ("GLOBAL REFERENCE" in entry):
          for reference in entry["GLOBAL REFERENCE"]:
            if "GLOBAL DESCRIPTION" in reference:
              for value in reference["GLOBAL DESCRIPTION"]:
                description += value
        row = []
        row.append(icrLink)
        row.append(subscribingPackage)
        row.append(fieldsReferenced)
        row.append(description)
        icrTable.append(row)

        pdfRow = []
        pdfRow.append(icrLinkPDF)
        pdfRow.append(subscribingPackagesPDF)
        pdfRow.append(fieldsReferencedPDF)
        pdfRow.append(generateParagraph(description))
        icrTablePDF.append(pdfRow)
      self.writeGenericTablizedHtmlData(headerList, icrTable, outfile, classid="icrVals")
      columns = 10
      columnWidth = self.doc.width/columns
      colWidths = [columnWidth, columnWidth * 2, columnWidth * 3, columnWidth * 4]
      self.__writeGenericTablizedPDFData__(headerList, icrTablePDF, pdf,
                                           columnWidths=colWidths, isString=False)

    def _updatePackageDepDict(self, package, depDict, packDepDict):
        for depPack in depDict.iterkeys():
            fileName = getPackageDependencyHtmlFile(package.getName(),
                                                    depPack.getName())
            if fileName not in packDepDict:
                packDepDict[fileName] = (package, depPack)

#===============================================================================
# method to generate the detail of package
#===============================================================================
    def generatePackageRoutineDependencyDetailPage(self, package, depPackage, outputFile,titleIndex):
        packageHyperLink = getPackageHyperLinkByName(package.getName())
        depPackageHyperLink = getPackageHyperLinkByName(depPackage.getName())
        # generate section header
        writeSectionHeader("%s-->%s :" % (packageHyperLink, depPackageHyperLink),
                           package.getName(), outputFile, None)
        routineDepDict = package.getPackageRoutineDependencies()
        globalDepDict = package.getPackageGlobalDependencies()
        globalRtnDepDict = package.getPackageGlobalRoutineDependencies()
        fileManDepDict = package.getPackageFileManFileDependencies()
        dbCallDepDict = package.getPackageFileManDbCallDependencies()
        optionDepDict = package.getPackageComponentDependencies()
        gblgblDepDicts = package.getPackageGlobalGlobalDependencies()
        callerRoutines = set()
        calledRoutines = set()
        optionCallRoutines = set()
        globalRtnCallRoutines = set()
        globalRtnCalledRoutines = set()
        globalGblCallRoutines = set()
        globalGblCalledRoutines = set()
        optionCalledRoutines = set()
        referredRoutines = set()
        referredGlobals = set()
        referredFileManFiles = set()
        referencedFileManFiles = set()
        dbCallRoutines = set()
        dbCallFileManFiles = set()
        titleList = ['Summary'+titleIndex]
        if routineDepDict and depPackage in routineDepDict:
            callerRoutines = routineDepDict[depPackage][0]
            calledRoutines = routineDepDict[depPackage][1]
            titleList = titleList + ["Caller Routines"+titleIndex, "Called Routines"+titleIndex]
        if globalDepDict and depPackage in globalDepDict:
            referredRoutines = globalDepDict[depPackage][0]
            referredGlobals = globalDepDict[depPackage][1]
            titleList = titleList + ["Referred Routines"+titleIndex, "Referenced Globals"+titleIndex]
        if fileManDepDict and depPackage in fileManDepDict:
            referredFileManFiles = fileManDepDict[depPackage][0]
            referencedFileManFiles = fileManDepDict[depPackage][1]
            titleList = titleList + ["Referred FileMan Files"+titleIndex, "Referenced FileMan Files"+titleIndex]
        if dbCallDepDict and depPackage in dbCallDepDict:
            dbCallRoutines = dbCallDepDict[depPackage][0]
            dbCallFileManFiles = dbCallDepDict[depPackage][1]
            titleList = titleList + ["FileMan Db Call Routines"+titleIndex, "FileMan Db Call Accessed FileMan Files"+titleIndex]
        pdfList = titleList
        pdfList.append("Legend Graph")
        writePDFCustomization(outputFile,str(pdfList))
        if optionDepDict and depPackage in optionDepDict:
            optionCallRoutines = optionDepDict[depPackage][0]
            optionCalledRoutines = optionDepDict[depPackage][1]
        if globalRtnDepDict and depPackage in globalRtnDepDict:
            globalRtnCallRoutines = globalRtnDepDict[depPackage][0]
            globalRtnCalledRoutines = globalRtnDepDict[depPackage][1]
        if gblgblDepDicts and depPackage in gblgblDepDicts:
            globalGblCallRoutines = gblgblDepDicts[depPackage][0]
            globalGblCalledRoutines = gblgblDepDicts[depPackage][1]
        optionCalledHtml = "<span class=\"comment\">%d</span>" % len(optionCalledRoutines)
        optionCallerHtml = "<span class=\"comment\">%d</span>" % len(optionCallRoutines)
        gblRtnCallerHtml = "<span class=\"comment\">%d</span>" % len(globalRtnCallRoutines)
        gblRtnCalledHtml = "<span class=\"comment\">%d</span>" % len(globalRtnCalledRoutines)
        gblGblCallerHtml = "<span class=\"comment\">%d</span>" % len(globalGblCallRoutines)
        gblGblCalledHtml = "<span class=\"comment\">%d</span>" % len(globalGblCalledRoutines)
        totalCalledHtml = "<span class=\"comment\">%d</span>" % len(callerRoutines)
        totalCallerHtml = "<span class=\"comment\">%d</span>" % len(calledRoutines)
        totalReferredRoutineHtml = "<span class=\"comment\">%d</span>" % len(referredRoutines)
        totalReferredGlobalHtml = "<span class=\"comment\">%d</span>" % len(referredGlobals)
        totalReferredFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(referredFileManFiles)
        totalReferencedFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(referencedFileManFiles)
        totalDbCallRoutinesHtml = "<span class=\"comment\">%d</span>" % len(dbCallRoutines)
        totalDbCallFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(dbCallFileManFiles)
        summaryHeader = "Summary:<BR> Total %s routine(s) in %s called total %s routine(s) in %s" % (totalCalledHtml,
                                                                                               packageHyperLink,
                                                                                               totalCallerHtml,
                                                                                               depPackageHyperLink)
        summaryHeader += "<BR> Total %s Global(s) in %s called total %s routine(s) in %s" % (gblRtnCallerHtml,
                                                                                               packageHyperLink,
                                                                                               gblRtnCalledHtml,
                                                                                               depPackageHyperLink)
        summaryHeader += "<BR> Total %s Global(s) in %s called total %s Global(s) in %s" % (gblGblCallerHtml,
                                                                                               packageHyperLink,
                                                                                               gblGblCalledHtml,
                                                                                               depPackageHyperLink)
        summaryHeader += "<BR> Total %s Package Component(s) in %s called total %s routine(s) in %s" % (optionCalledHtml,
                                                                                               packageHyperLink,
                                                                                               optionCallerHtml,
                                                                                               depPackageHyperLink)
        summaryHeader += "<BR> Total %s routine(s) in %s accessed total %s global(s) in %s" % (totalReferredRoutineHtml,
                                                                                             packageHyperLink,
                                                                                             totalReferredGlobalHtml,
                                                                                             depPackageHyperLink)
        summaryHeader += "<BR> Total %s fileman file(s) in %s pointed to total %s fileman file(s) in %s" % (totalReferredFileManFilesHtml,
                                                                                             packageHyperLink,
                                                                                             totalReferencedFileManFilesHtml,
                                                                                             depPackageHyperLink)
        summaryHeader += "<BR> Total %s routine(s) in %s accessed via fileman db call to total %s fileman file(s) in %s" % (totalDbCallRoutinesHtml,
                                                                                             packageHyperLink,
                                                                                             totalDbCallFileManFilesHtml,
                                                                                             depPackageHyperLink)
        writeSubSectionHeader(summaryHeader, outputFile,classid="summary")
        # print out the routine details
        if len(callerRoutines) > 0:
            writeSubSectionHeader("Caller Routines List in %s : %s" % (packageHyperLink,
                                                                       totalCalledHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(callerRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName,classid="callerRoutines")
        if len(calledRoutines) > 0:
            writeSubSectionHeader("Called Routines List in %s : %s" % (depPackageHyperLink,
                                                                       totalCallerHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(calledRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName,classid="calledRoutines")
        # print out the Global -> routine details
        if len(globalRtnCallRoutines) > 0:
            writeSubSectionHeader("Caller Global List in %s : %s" % (packageHyperLink,
                                                                       gblRtnCallerHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(globalRtnCallRoutines), outputFile,
                                          getGlobalHtmlFileName)
        if len(globalRtnCalledRoutines) > 0:
            writeSubSectionHeader("Called Routines List in %s : %s" % (depPackageHyperLink,
                                                                       gblRtnCalledHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(globalRtnCalledRoutines), outputFile,
                                            getRoutineHtmlFileName, self.getRoutineDisplayName)

        # print out the Global -> global details
        if len(globalGblCallRoutines) > 0:
            writeSubSectionHeader("Caller Global List in %s : %s" % (packageHyperLink,
                                                                       gblGblCallerHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(globalGblCallRoutines), outputFile,
                                          getGlobalHtmlFileName)
        if len(globalGblCalledRoutines) > 0:
            writeSubSectionHeader("Called Globals List in %s : %s" % (depPackageHyperLink,
                                                                       gblGblCalledHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(globalGblCalledRoutines), outputFile,
                                          getGlobalHtmlFileName)
        # print out the Package Component details
        if len(optionCallRoutines) > 0:
            writeSubSectionHeader("Caller Package Components List in %s : %s" % (packageHyperLink,
                                                                       optionCallerHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(optionCallRoutines), outputFile,
                                          getPackageObjHtmlFileName, self.getPackageComponentDisplayName)
        if len(optionCalledRoutines) > 0:
            writeSubSectionHeader("Called Routines in %s : %s" % (depPackageHyperLink,
                                                                       optionCalledHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(optionCalledRoutines), outputFile,
                                          getPackageObjHtmlFileName, self.getRoutineDisplayName)
        if len(referredRoutines) > 0:
            writeSubSectionHeader("Referred Routines List in %s : %s" % (packageHyperLink,
                                                                       totalReferredRoutineHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName,classid="referredRoutines")
        if len(referredGlobals) > 0:
            writeSubSectionHeader("Referenced Globals List in %s : %s" % (depPackageHyperLink,
                                                                       totalReferredGlobalHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredGlobals), outputFile,
                                          getGlobalHtmlFileName,classid="referredGlobals")
        if len(referredFileManFiles) > 0:
            writeSubSectionHeader("Referred FileMan Files List in %s : %s" % (packageHyperLink,
                                                                       totalReferredFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredFileManFiles), outputFile,
                                          getGlobalHtmlFileName, getGlobalDisplayName,classid="referredFileManFiles")
        if len(referencedFileManFiles) > 0:
            writeSubSectionHeader("Referenced FileMan Files List in %s : %s" % (depPackageHyperLink,
                                                                       totalReferencedFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referencedFileManFiles), outputFile,
                                          getGlobalHtmlFileName, getGlobalDisplayName,classid="referencedFileManFiles")
        if len(dbCallRoutines) > 0:
            writeSubSectionHeader("FileMan Db Call Routines List in %s : %s" % (packageHyperLink,
                                                                       totalDbCallRoutinesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(dbCallRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName,classid="dbCallRoutines")
        if len(dbCallFileManFiles) > 0:
            writeSubSectionHeader("FileMan Db Call Accessed FileMan Files List in %s : %s" % (depPackageHyperLink,
                                                                       totalDbCallFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(dbCallFileManFiles), outputFile,
                                          getGlobalHtmlFileName,classid="dbCallFileManFiles")
        writeSectionEnd(outputFile)
        outputFile.write("<br/>\n")

#===============================================================================
# method to generate the individual package/package interaction detail page
#===============================================================================
    def generatePackageInteractionDetailPage(self, fileName, package, depPackage):
        outputFile = open(os.path.join(self._outDir, fileName), 'w')
        self.__includeHeader__(outputFile)
        packageHyperLink = getPackageHyperLinkByName(package.getName())
        depPackageHyperLink = getPackageHyperLinkByName(depPackage.getName())
        #generate the index bar
        inputList = ["%s-->%s" % (package.getName(), depPackage.getName()),
                   "%s-->%s" % (depPackage.getName(), package.getName())]
        archList = [package.getName(), depPackage.getName()]
        generateIndexBar(outputFile, inputList, archList, isIndex = False, printButton=True)
        outputFile.write("<title id=\"pageTitle\">" + package.getName() + " : " + depPackage.getName() + "</title>")
        outputFile.write("<div><h1>%s and %s Interaction Details</h1></div>\n" %
                         (packageHyperLink, depPackageHyperLink))

        writeLegends(self._outDir,outputFile)
        #generate the summary part.
        self.generatePackageRoutineDependencyDetailPage(package, depPackage, outputFile,"_1")
        self.generatePackageRoutineDependencyDetailPage(depPackage, package, outputFile,"_2")
        generateIndexBar(outputFile, inputList, archList, isIndex = False)
        self.__includeFooter__(outputFile)
        outputFile.close()

    ###########################################################################
    def __parseReadCmd__(self, matchArray, routine, lineNo):
      for matchObj in matchArray:
        setup = matchObj[0].split(",")
        interaction = {}
        interaction["type"]= "READ"
        interaction["line"]= str(lineNo)
        interaction['timeout'] = matchObj[1]
        # Read directly into a variable
        if len(setup) == 1:
          interaction['variable'] = setup[0]
        # Read into a variable with some prompt
        elif len(setup) == 2:
          (interaction['string'], interaction['variable']) = tuple(setup)
        # Read into a variable with a prompt and some extra parameters/formatting
        elif len(setup) == 3:
          (interaction['formatting'], interaction['string'], interaction['variable']) = tuple(setup)
        routine.addInteractionEntry(interaction)

    def __parseWriteCmd__(self,line, routine,lineNo):
      # splits the line into a space separated list which ignores spaces found within quotes
      lineList =  re.split(''' (?=(?:[^'"]|'[^']*'|"[^"]*")*$)''', line)
      lastIndex = 0
      for i in lineList:
        # Captures the conditional value of the write, while trying to remove false matches like "WRITE" as an entry point
        match = re.search("^W(?!\w)($|(?P<conditional>\:.+)?)",i)
        if match:
          interaction = {}
          # Make sure we aren't going to look past the end
          if lineList[lastIndex:].index(i) + 1+lastIndex  >= len(lineList):
            continue
          interaction["string"] = lineList[lineList[lastIndex:].index(i) + 1+lastIndex]
          lastIndex=lineList.index(i) + 1
          interaction["type"]= "WRITE"
          interaction["line"]= str(lineNo)
          if match.group('conditional'):
            interaction["conditional"]= match.group('conditional')[1:]
          routine.addInteractionEntry(interaction)

#===============================================================================
# Method to parse the source code and generate source code page or just extract comments
#===============================================================================
    def __generateSourceCodePageByName__(self, sourceCodeName, routine, justComment):
        ENTRY_POINT = re.compile("^[A-Z0-9]+[(]?")
        COMMENT  = re.compile("^ ; ")
        READ_CMD = re.compile(" R (?P<params>.+?):(?! )(?P<timeout>.+?) ")
        WRITE_CMD = re.compile(" W (?P<string>.+?)\s")
        if not routine:
            logger.error("Routine can not be None")
            return
        package = routine.getPackage()
        if not package:
            logger.error("Routine %s does not belong to a package" % routine)
            return
        packageName = package.getName()
        routineName = routine.getName()
        sourcePath = getRoutineSourceCodeFileByName(sourceCodeName,
                                                    packageName,
                                                    self._repDir)
        if not os.path.exists(sourcePath):
            logger.error("Souce file:[%s] does not exist\n" % sourcePath)
            return
        sourceFile = open(sourcePath, 'r')
        if not justComment:
            outputFile = open(os.path.join(self._outDir,
                                         getRoutineSourceHtmlFileNameUnquoted(sourceCodeName)), 'wb')
            self.__includeSourceHeader__(outputFile)
            outputFile.write("<title id=\"pageTitle\">Routine: " + sourceCodeName + "</title>")
            outputFile.write("<div><h1>%s.m</h1></div>\n" % sourceCodeName)
            outputFile.write("<div id='pageCommands' style='position:fixed; top:55; background: white;'>")
            outputFile.write("  <a href=\"%s\">Go to the documentation of this file.</a>" %
                             getRoutineHtmlFileName(routineName))
            if routine._structuredCode:
              outputFile.write(SWAP_VIEW_HTML)
            outputFile.write('</div>')
            outputFile.write("<xmp id=\"terseDisplay\" class=\"prettyprint lang-mumps linenums:1\">")
        # Inititalize the new variables
        lineNo = 0
        entry = ""
        entryOffset = 0
        currentEntryPoint = routineName
        comment=[]
        icrJson=[]
        inComment=False
        for line in sourceFile:
            if lineNo <= 1:
                routine.addComment(line)
            if ENTRY_POINT.search(line) and lineNo > 1:
              if entry:
                routine.addEntryPoint(entry, comment, icrJson)
                comment=[]
              inComment = True
              foundLine = line.replace("\t"," ").split(" ",1)
              if len(foundLine) > 1:
                entry = foundLine[0]
                commentString = foundLine[1]
              else:
                commentString = "@"
                entry= line
              currentEntryPoint= entry
              entryOffset= 0
              comment.append(commentString)
              if not commentString[0]==";":
                comment=[]
                # if No comment on the first line, assume no other comments will follow it
                inComment= False
              icrJson = self.queryICRInfo(packageName.upper(),"ROUTINE", routineName)
            # Check for more comments that are 1 space in from the beginning of the line
            elif COMMENT.search(line) and inComment:
              comment.append(line)
            else:
              # If here, assume we have reached the code part of the entry point and stop checking for comments
              inComment=False
            if READ_CMD.search(line):
                self.__parseReadCmd__(READ_CMD.findall(line), routine, currentEntryPoint+"+"+str(entryOffset))
            if WRITE_CMD.search(line):
                self.__parseWriteCmd__(line, routine, currentEntryPoint+"+"+str(entryOffset))
            if justComment and lineNo > 1:
               continue
            if not justComment:
                outputFile.write(line)
            lineNo += 1
            entryOffset += 1
        sourceFile.close()
        routine.addEntryPoint(entry, comment, icrJson)
        if not justComment:
            outputFile.write("</xmp>\n")
            if routine._structuredCode:
              outputFile.write("<xmp id=\"expandedDisplay\" class=\"prettyprint lang-mumps linenums:1\" style='display:none;'>")
              for line in routine._structuredCode:
                if len(line):
                  outputFile.write("%s \n" % line)
              outputFile.write("</xmp>\n")
            self.__includeFooter__(outputFile)
            outputFile.close()

#===============================================================================
# Method to generate individual source code page for Platform Dependent Routines
#===============================================================================
    def __generatePlatformDependentRoutineSourcePage__(self, genericRoutine, justComment):
        assert genericRoutine
        assert isinstance(genericRoutine, PlatformDependentGenericRoutine)
        assert self._crossRef.isPlatformGenericRoutineByName(genericRoutine.getName())
        allRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in allRoutines.itervalues():
            routine = routineInfo[0]
            sourceCodeName = routine.getOriginalName()
            self.__generateSourceCodePageByName__(sourceCodeName, routine, justComment)

#===============================================================================
# Method to generate individual source code page
# sourceDir should be VistA-M git repository
#===============================================================================
    def generateAllSourceCodePage(self, justComment=True):
        for packageName in self._allPackages.iterkeys():
            for (routineName, routine) in self._allPackages[packageName].getAllRoutines().iteritems():
                if self._crossRef.isPlatformGenericRoutineByName(routineName):
                    self.__generatePlatformDependentRoutineSourcePage__(routine, justComment)
                    continue
                # check for platform dependent routine
                if not self._crossRef.routineHasSourceCodeByName(routineName):
                    logger.debug("Routine:%s does not have source code" % routineName)
                    continue
                sourceCodeName = routine.getOriginalName()
                self.__generateSourceCodePageByName__(sourceCodeName, routine, justComment)

#===============================================================================
# utility method to show component type
#===============================================================================
    def getPackageComponentDisplayName(self, routine):
        routineName = routine.getName()
        if "componentType" in dir(routine):
          if routine.componentType.strip() in componentTypeDict:
              return "%s<sup>(%s)</sup>" % (routineName,componentTypeDict[routine.componentType.strip()])
        return routineName
#===============================================================================
# utility method to show routine name
#===============================================================================
    def getRoutineDisplayNameByName(self, routineName):
        if self._crossRef.isPlatformGenericRoutineByName(routineName):
            return "%s&sup1" % routineName # superscript 1
        if not self._crossRef.routineHasSourceCodeByName(routineName):
            return "%s&sup2" % routineName # superscript 2
        return routineName
    def getRoutineDisplayName(self, routine):
        return self.getRoutineDisplayNameByName(routine.getName())

#===============================================================================
# Method to generate routine Index page
#===============================================================================
    def generateRoutineIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "routines.html"), 'w')
        self.__includeHeader__(outputFile)
        outputFile.write("<title>Routine Index List</title>")
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Routine Index List</h1>\n</div>\n</div>")
        indexList = [char for char in string.uppercase]
        indexList.insert(0, "%")
        indexSet = sorted(set(indexList))
        generateIndexBar(outputFile, indexList, isIndex = True, printButton=True)
        outputFile.write("<div class=\"contents\">\n")
        sortedRoutines = []
        for routine in self._allRoutines.itervalues():
            sortedRoutines.append(routine.getName())
        sortedRoutines = sorted(sortedRoutines)
        for letter in indexList:
            bisect.insort_left(sortedRoutines, letter)
        totalRoutines = len(sortedRoutines)
        totalCol = 4
        numPerCol = totalRoutines / totalCol + 1
        outputFile.write("<table align=\"center\" width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n")
        for i in range(numPerCol):
            itemsPerRow = [];
            for j in range(totalCol):
                if (i + numPerCol * j) < totalRoutines:
                    item = sortedRoutines[i + numPerCol * j]
                    itemsPerRow.append(item);
            generateIndexedRoutineTableRow(outputFile, itemsPerRow,
                                           self.getRoutineDisplayNameByName,
                                           indexSet)
        outputFile.write("</table>\n</div>\n")
        generateIndexBar(outputFile, indexList, isIndex = True)
        self.__includeFooter__(outputFile)
        outputFile.close()

    #===============================================================================
    # Return a dict with package as key, a list of 6 as value
    #===============================================================================
    def __mergePackageDependenciesList__(self, package, isDependencies=True):
        packageDepDict = dict()
        if isDependencies:
            routineDeps = package.getPackageRoutineDependencies()
            globalDeps = package.getPackageGlobalDependencies()
            globalRtnDeps = package.getPackageGlobalRoutineDependencies()
            globalGblDeps = package.getPackageGlobalGlobalDependencies()
            fileManDeps = package.getPackageFileManFileDependencies()
            dbCallDeps = package.getPackageFileManDbCallDependencies()
            optionDeps = package.getPackageComponentDependencies()
        else:
            routineDeps = package.getPackageRoutineDependents()
            globalDeps = package.getPackageGlobalDependents()
            globalRtnDeps = package.getPackageGlobalRoutineDependendents()
            globalGblDeps = package.getPackageGlobalGlobalDependents()
            fileManDeps = package.getPackageFileManFileDependents()
            dbCallDeps = package.getPackageFileManDbCallDependents()
            optionDeps = {}
        for (package, depTuple) in routineDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][0] = len(depTuple[0])
            packageDepDict[package][1] = len(depTuple[1])
        for (package, depTuple) in globalDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][2] = len(depTuple[0])
            packageDepDict[package][3] = len(depTuple[1])
        for (package, depTuple) in fileManDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][4] = len(depTuple[0])
            packageDepDict[package][5] = len(depTuple[1])
        for (package, depTuple) in dbCallDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][6] = len(depTuple[0])
            packageDepDict[package][7] = len(depTuple[1])
        for (package, depTuple) in optionDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][8] = len(depTuple[0])
            packageDepDict[package][9] = len(depTuple[1])
        for (package, depTuple) in globalRtnDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][10] = len(depTuple[0])
            packageDepDict[package][11] = len(depTuple[1])
        for (package, depTuple) in globalGblDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][12] = len(depTuple[0])
            packageDepDict[package][13] = len(depTuple[1])
        return packageDepDict

    #===============================================================================
    ## Method to generate merge and sorted Dependeny list by Package
    #===============================================================================
    def __mergeAndSortDependencyListByPackage__(self, package, isDependencyList):
        depPackageMerged = self.__mergePackageDependenciesList__(package, isDependencyList)
        # sort by the sum of the total # of routines
        depPackages = sorted(depPackageMerged.keys(),
                           key=lambda item: sum(depPackageMerged[item][0:7:2]),
                           reverse=True)
        return (depPackages, depPackageMerged)

    #===============================================================================
    ## Method to generate the package dependency/dependent graph
    #===============================================================================
    def generatePackageDependencyGraph(self, package, dependencyList=True):
        # merge the routine and package list
        depPackages, depPackageMerged = self.__mergeAndSortDependencyListByPackage__(
                                                                      package,
                                                                      dependencyList)
        if dependencyList:
            packageSuffix = "_dependency"
        else:
            packageSuffix = "_dependent"
        packageName = package.getName()
        normalizedName = normalizePackageName(packageName)
        totalPackage = len(depPackageMerged)
        if  (totalPackage == 0) or (totalPackage > MAX_DEPENDENCY_LIST_SIZE):
            logger.info("Nothing to do exiting... Package: %s Total: %d " %
                         (packageName, totalPackage))
            return
        try:
            dirName = os.path.join(self._outDir, packageName)
            if not os.path.exists(dirName):
                os.makedirs(dirName)
        except OSError, e:
            logger.error("Error making dir %s : Error: %s" % (dirName, e))
            return
        output = open(os.path.join(dirName, normalizedName + packageSuffix + ".dot"), 'w')
        output.write("digraph %s {\n" % (normalizedName + packageSuffix))
        output.write("\tnode [shape=box fontsize=14];\n") # set the node shape to be box
        output.write("\tnodesep=0.35;\n") # set the node sep to be 0.35
        output.write("\transsep=0.55;\n") # set the rank sep to be 0.75
        output.write("\tedge [fontsize=12];\n") # set the edge label and size props
        output.write("\t%s [style=filled fillcolor=orange label=\"%s\"];\n" % (normalizedName,
                                                                               packageName))
        for depPackage in depPackages:
            depPackageName = depPackage.getName()
            normalizedDepPackName = normalizePackageName(depPackageName)
            output.write("\t%s [label=\"%s\" URL=\"%s\"];\n" % (normalizedDepPackName,
                                                                depPackageName,
                                                                getPackageHtmlFileName(depPackageName)))
    #            output.write("\t%s->%s [label=\"depends\"];\n" % (normalizedName, normalizePackageName(depPackageName.getName())))
            depMetricsList = depPackageMerged[depPackage]
            edgeWeight = sum(depMetricsList[0:7:2])
            edgeLinkURL = getPackageDependencyHtmlFile(normalizedName, normalizedDepPackName)
            edgeStartNode = normalizedName
            edgeEndNode = normalizedDepPackName
            edgeLinkArch = packageName
            toolTipStartPackage = packageName
            toolTipEndPackage = depPackageName
            if not dependencyList:
                edgeStartNode = normalizedDepPackName
                edgeEndNode = normalizedName
                edgeLinkArch = depPackageName
                toolTipStartPackage = depPackageName
                toolTipEndPackage = packageName
            (edgeLabel, edgeToolTip, edgeStyle) = self.__getPackageGraphEdgePropsByMetrics__(depMetricsList,
                                                                                             toolTipStartPackage,
                                                                                             toolTipEndPackage)
            output.write("\t%s->%s [label=\"%s\" weight=%d URL=\"%s#%s\" style=\"%s\" labeltooltip=\"%s\" edgetooltip=\"%s\"];\n" % (edgeStartNode,
                                                     edgeEndNode,
                                                     edgeLabel,
                                                     edgeWeight,
                                                     edgeLinkURL,
                                                     edgeLinkArch,
                                                     edgeStyle,
                                                     edgeToolTip,
                                                     edgeToolTip))
        output.write("}\n")
        output.close()
        # use dot tools to generated the image and client side mapping
        outputName = os.path.join(dirName, normalizedName + packageSuffix + ".png")
        outputmap = os.path.join(dirName, normalizedName + packageSuffix + ".cmapx")
        inputName = os.path.join(dirName, normalizedName + packageSuffix + ".dot")
        # this is to generated the image in gif format and also cmapx (client side map) to make sure link
        # embeded in the graph is clickable
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                               outputName,
                                                               outputmap,
                                                               inputName)
        logger.debug("command is %s" % command)
        retCode = subprocess.call(command, shell=True)
        if retCode != 0:
            logger.error("calling dot with command[%s] returns %d" % (command, retCode))

#===============================================================================
#  return a tuple of Edge Label, Edge ToolTip, Edge Style
#===============================================================================
    def __getPackageGraphEdgePropsByMetrics__(self, depMetricsList,
                                              toolTipStartPackage,
                                              toolTipEndPackage,
                                              isEdgeLabel=True):
        assert(len(depMetricsList) >= 8)
        # default for routine only
        toolTip =("Total %d routine(s) in %s called total %d routine(s) in %s" % (depMetricsList[0],
                                                                     toolTipStartPackage,
                                                                     depMetricsList[1],
                                                                     toolTipEndPackage),
                  "Total %d routine(s) in %s accessed total %d global(s) in %s" % (depMetricsList[2],
                                                                     toolTipStartPackage,
                                                                     depMetricsList[3],
                                                                     toolTipEndPackage),
                  "Total %d fileman file(s) in %s pointed to total %d fileman file(s) in %s" % (depMetricsList[4],
                                                                     toolTipStartPackage,
                                                                     depMetricsList[5],
                                                                     toolTipEndPackage),
                  "Total %d routines(s) in %s accessed via fileman db calls to total %d fileman file(s) in %s" % (depMetricsList[6],
                                                                     toolTipStartPackage,
                                                                     depMetricsList[7],
                                                                     toolTipEndPackage),
                  "Total %d Package Component(s) in %s accessed total %d Routine(s) in %s" % (depMetricsList[8],
                                                                     toolTipStartPackage,
                                                                     depMetricsList[9],
                                                                     toolTipEndPackage),
                  "Total %d Global(s) in %s accessed total %d Routines(s) in %s" % (depMetricsList[10],
                                                                     toolTipStartPackage,
                                                                     depMetricsList[11],
                                                                     toolTipEndPackage),
                  "Total %d Global(s) in %s accessed total %d Routines(s) in %s" % (depMetricsList[12],
                                                                     toolTipStartPackage,
                                                                     depMetricsList[13],
                                                                     toolTipEndPackage)
                  )
        labelText =("%s(R)->(R)%s" % (depMetricsList[0],depMetricsList[1]),
                    "%s(R)->(G)%s" % (depMetricsList[2],depMetricsList[3]),
                    "%s(F)->(F)%s" % (depMetricsList[4],depMetricsList[5]),
                    "%s(R)->(F)%s" % (depMetricsList[6],depMetricsList[7]),
                    "%s(PC)->(R)%s" % (depMetricsList[8],depMetricsList[9]),
                    "%s(G)->(R)%s" % (depMetricsList[10],depMetricsList[11]),
                    "%s(G)->(G)%s" % (depMetricsList[12],depMetricsList[13])
                    )

        metricValue = 0
        (edgeLabel, edgeToolTip, edgeStyle) = ("","","")
        metricValue = 0
        for i in range(0,7):
            if depMetricsList[i*2] > 0:
                if len(edgeLabel) == 0:
                  edgeLabel = labelText[i]
                elif isEdgeLabel:
                  edgeLabel = "%s\\n%s" % (edgeLabel, labelText[i])
                else:
                  edgeLabel = "%s:%s" % (edgeLabel, labelText[i])
                if len(edgeToolTip) > 0:
                  edgeToolTip = "%s. %s" % (edgeToolTip, toolTip[i])
                else:
                  edgeToolTip = toolTip[i]
                metricValue += 1 * 2**i
        if metricValue >= 7:
            edgeStyle = "bold"
        elif metricValue == 2:
            edgeStyle = "dashed"
        elif metricValue == 4:
            edgeStyle = "dotted"
        else:
            edgeStyle = "solid"
        return (edgeLabel, edgeToolTip, edgeStyle)

#===============================================================================
#
#===============================================================================
    def generatePackageInformationPages(self):
        self.generatePackageComponentListPage()
        for keyVal in sectionLinkObj.keys():
          self.generateAllIndividualPackageComponentPage(keyVal)
#===============================================================================
#
#===============================================================================
    def copyFilesToOutputDir(self):
       cssFile = os.path.join(os.path.abspath(self._docRepDir),
                              "Web/DoxygenStyle.css")
       pdfFile = os.path.join(os.path.abspath(self._docRepDir),
                              "PythonScripts/PDF_Script.js")
       shutil.copy(cssFile, self._outDir)
       shutil.copy(pdfFile, self._outDir)

    def zipPDFFiles(self):
        toZip = [x[0] for x in os.walk(self._pdfOutDir)]
        for dir in toZip[1:]: # Don't zip top-level directory
            shutil.make_archive(dir, 'zip', dir)
        # TODO: Delete non-zipped directories?

#===============================================================================
#  Generate Color legend image
#===============================================================================
    def generateColorLegend(self, isCalled=True):
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                    os.path.join(self._outDir,"colorLegend.png"),
                                                    os.path.join(self._outDir,"colorLegend.cmapx"),
                                                    os.path.join(self._docRepDir,'callerGraph_color_legend.dot'))
        logger.debug("command is %s" % command)
        retCode = subprocess.call(command, shell=True)
        if retCode != 0:
            logger.error("calling dot with command[%s] returns %d" % (command, retCode))
#===============================================================================
#
#===============================================================================
    def generateRoutineCallGraph(self, isCalled=True):
        logger.info("Start Routine generating call graph......")
        for package in self._allPackages.itervalues():
            routines = package.getAllRoutines()
            for routine in routines.itervalues():
                isPlatformGenericRoutine = self._crossRef.isPlatformGenericRoutineByName(routine.getName())
                if isCalled and isPlatformGenericRoutine:
                    self.generatePlatformGenericDependencyGraph(routine, isCalled)
                else:
                    self.generateRoutineDependencyGraph(routine, isCalled)
        logger.info("End of generating call graph......")

#===============================================================================
# Method to generate routine caller graph for platform dependent routines
#===============================================================================
    def generatePlatformGenericDependencyGraph(self, genericRoutine, isDependency):
        assert genericRoutine
        assert isinstance(genericRoutine, PlatformDependentGenericRoutine)
        if not isDependency:
            return
        platformRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in platformRoutines.itervalues():
            self.generateRoutineDependencyGraph(routineInfo[0], isDependency)

#===============================================================================
#
#===============================================================================
    def generateRoutineCallerGraph(self):
        self.generateRoutineCallGraph(False)

#===============================================================================
## generate all dot file and use dot to generated the image file format
#===============================================================================
    def generateRoutineDependencyGraph(self, routine, isDependency=True):
        if not routine.getPackage():
            return
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        if isDependency:
            depRoutines = routine.getCalledRoutines()
            routineSuffix = "_called"
            totalDep = routine.getTotalCalled()
        else:
            depRoutines = routine.getCallerRoutines()
            routineSuffix = "_caller"
            totalDep = routine.getTotalCaller()
        #do not generate graph if no dep routines, totalDep routines > max_dependency_list
        if (not depRoutines
            or len(depRoutines) == 0
            or  totalDep > MAX_DEPENDENCY_LIST_SIZE):
            logger.debug("No called Routines found! for routine:%s package:%s" % (routineName, packageName))
            return
        try:
            dirName = os.path.join(self._outDir, packageName)
            if not os.path.exists(dirName):
                os.makedirs(dirName)
        except OSError, e:
            logger.error("Error making dir %s : Error: %s" % (dirName, e))
            return
        output = open(os.path.join(dirName, routineName + routineSuffix + ".dot"), 'wb')
        output.write("digraph \"%s\" {\n" % (routineName + routineSuffix))
        output.write("\tnode [shape=box fontsize=14];\n") # set the node shape to be box
        output.write("\tnodesep=0.45;\n") # set the node sep to be 0.15
        output.write("\transsep=0.45;\n") # set the rank sep to be 0.75
#        output.write("\tedge [fontsize=12];\n") # set the edge label and size props
        if routine.getPackage() not in depRoutines:
            output.write("\tsubgraph \"cluster_%s\"{\n" % (routine.getPackage()))
            output.write("\t\t\"%s\" [style=filled fillcolor=orange];\n" % routineName)
            output.write("\t}\n")
        for (package, callDict) in depRoutines.iteritems():
            output.write("\tsubgraph \"cluster_%s\"{\n" % (package))
            for routine in callDict.keys():
                output.write("\t\t\"%s\" [penwidth=2 %s URL=\"%s\" tooltip=\"%s\"];\n" % (routine,
                                                         findDotColor(routine),
                                                         getPackageObjHtmlFileName(routine),
                                                         getPackageObjHtmlFileName(routine)
                                                        ))
                if str(package) == packageName:
                    output.write("\t\t\"%s\" [style=filled fillcolor=orange];\n" % routineName)
            output.write("\t\tlabel=\"%s\";\n" % package)
            output.write("\t}\n")
            for (routine, tags) in callDict.iteritems():
                if isDependency:
                    output.write("\t\t\"%s\"->\"%s\"" % (routineName, routine))
                else:
                    output.write("\t\t\"%s\"->\"%s\"" % (routine, routineName))
                output.write(";\n")
        output.write("}\n")
        output.close()
        outputName = os.path.join(dirName, routineName + routineSuffix + ".png")
        outputmap = os.path.join(dirName, routineName + routineSuffix + ".cmapx")
        inputName = os.path.join(dirName, routineName + routineSuffix + ".dot")
        # this is to generated the image in png format and also cmapx (client side map) to make sure link
        # embeded in the graph is clickable
        # @TODO this should be able to run in parallel
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                               outputName,
                                                               outputmap,
                                                               inputName)
        logger.debug("command is %s" % command)
        retCode = subprocess.call(command, shell=True)
        if retCode != 0:
            logger.error("calling dot with command[%s] returns %d" % (command, retCode))

#===============================================================================
#
#===============================================================================
    def generatePackageDependenciesGraph(self, isDependency=True):
        # generate all dot file and use dot to generated the image file format
        if isDependency:
            name = "dependencies"
        else:
            name = "dependents"
        logger.info("Start generating package %s......" % name)
        logger.info("Total Packages: %d" % len(self._allPackages))
        for package in self._allPackages.values():
            self.generatePackageDependencyGraph(package, isDependency)
        logger.info("End of generating package %s......" % name)

#===============================================================================
#
#===============================================================================
    def generatePackageDependentsGraph(self):
        self.generatePackageDependenciesGraph(False)

#===============================================================================
#
#===============================================================================
    def generatePackageIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "packages.html"), 'w')
        self.__includeHeader__(outputFile)
        #write the _header
        outputFile.write("<title>Package List</title>")
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Package List</h1>\n</div>\n</div>")
        generateIndexBar(outputFile, string.uppercase, isIndex = True, printButton=True)
        outputFile.write("<div class=\"contents\">\n")
        #generated the table
        totalNumPackages = len(self._allPackages) + len(string.uppercase)
        totalCol = 3
        # list in three columns
        numPerCol = totalNumPackages / totalCol + 1
        sortedPackages = sorted(self._allPackages.keys())
        for letter in string.uppercase:
            bisect.insort_left(sortedPackages, letter)
        # write the table first
        outputFile.write("<table align=\"center\" width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n")
        for i in range(numPerCol):
            itemsPerRow = [];
            for j in range(totalCol):
                if (i + numPerCol * j) < totalNumPackages:
                    itemsPerRow.append(sortedPackages[i + j * numPerCol]);
            generateIndexedPackageTableRow(outputFile, itemsPerRow)
        outputFile.write("</table>\n</div>\n")
        generateIndexBar(outputFile, string.uppercase, isIndex = True)
        self.__includeFooter__(outputFile)
        outputFile.close()

#=======================================================================
# Method to generate package dependency/dependent section info
#=======================================================================
    def generatePackageDependencySection(self, packageName, outputFile,
                                         pdf, isDependencyList=True):
        if isDependencyList:
            sectionGraphHeader = "Dependency Graph"
            sectionListHeader = "Package Dependency List"
            packageSuffix = "_dependency"
        else:
            sectionGraphHeader = "Dependent Graph"
            sectionListHeader = "Package Dependent List"
            packageSuffix = "_dependent"
        package = self._allPackages[packageName]
        depPackages, depPackagesMerged = \
          self.__mergeAndSortDependencyListByPackage__(package, isDependencyList)
        totalPackages = 0
        if depPackages:
            totalPackages = len(depPackages)

        paragraphs = []
        writeSectionHeader(sectionGraphHeader, sectionGraphHeader, outputFile,
                           paragraphs if totalPackages > 0 else None, isAccordion="")
        outputFile.write("<div>\n")
        try:
            # write the image of the dependency graph
            fileNamePrefix = normalizePackageName(packageName) + packageSuffix
            cmapFile = open(os.path.join(self._outDir, packageName + "/" + fileNamePrefix + ".cmapx"), 'r')
            outputFile.write("<div class=\"contents\">\n")
            imageFileName = packageName + "/" + fileNamePrefix + ".png"
            outputFile.write("<img id=\"package%sGraph\" src=\"%s\" border=\"0\" alt=\"Call Graph\" usemap=\"#%s\"/>\n"
                       % (packageSuffix, imageFileName, fileNamePrefix))
            if totalPackages > 0:
                self.__writeImageToPDF__(imageFileName, paragraphs)

            # append the content of map outputFile
            for line in cmapFile:
                outputFile.write(line)
                if totalPackages > 0: # TODO: Need this check here?
                    paragraphs.append(generateParagraph(line))
            outputFile.write("</div>\n")
        except IOError:
            pass
        total = "%s Total: %d " % (sectionListHeader, totalPackages)
        writeSubSectionHeader(total, outputFile)
        if totalPackages > 0:
            paragraphs.append(Spacer(1, 1))
            paragraphs.append(Paragraph(total, styles['Heading3']))
            # Only write the key if there are packages
            key = """Format:&nbsp;&nbsp;
                            package[# of caller routines(R) -> # of called routines(R):
                            # of global-accessing routines(R) -> # of called globals(G):
                            # of caller fileman files(F) -> # of called fileman files(F):
                            # of caller routines(R) -> # of fileman files accessed via db call(F):
                            # of package components accessing routines(PC) -> # of called routines(R):
                            # of caller globals(G) -> # of called routines (R):
                            # of caller globals(G) -> # of called globals (G):"""
            outputFile.write("<h4>%s</h4><BR>\n" % key)
            paragraphs.append(Spacer(1, 1))
            paragraphs.append(generateParagraph(key))
            paragraphs.append(Spacer(1, 10))

            outputFile.write("<div class=\"contents\"><table>\n")
            numOfCol = 6
            numOfRow = totalPackages / numOfCol + 1
            data = []
            for index in range(numOfRow):
                row = []
                outputFile.write("<tr>")
                for j in range(numOfCol):
                    if (index * numOfCol + j) < totalPackages:
                        depPackage = depPackages[index * numOfCol + j]
                        depPackageName = depPackage.getName()
                        toolTipStartPackage = packageName
                        toolTipEndPackage = depPackageName
                        if not isDependencyList:
                            toolTipStartPackage = depPackageName
                            toolTipEndPackage = packageName
                        depMetricsList = depPackagesMerged[depPackage]
                        linkName, tooltip, edgeStyle = self.__getPackageGraphEdgePropsByMetrics__(
                                                         depMetricsList,
                                                         toolTipStartPackage,
                                                         toolTipEndPackage,
                                                         False)

                        depHyperLink = getPackagePackageDependencyHyperLink(packageName,
                                                                          depPackageName,
                                                                          linkName,
                                                                          tooltip,
                                                                          isDependencyList)
                        outputFile.write("<td class=\"indexkey %s\"><a class=\"e1\" href=\"%s\">%s</a> [%s]&nbsp;&nbsp;&nbsp</td>"
                                   % (packageSuffix, getPackageHtmlFileName(depPackageName), depPackageName, depHyperLink))
                        row.append(generateParagraph("%s [%s]" % (depPackageName, linkName)))
                if row:
                    data.append(row)
                outputFile.write("</tr>\n")
            outputFile.write("</table></div>\n")

            t = self.__generatePDFTable__(data)
            paragraphs.append(t)
        if totalPackages > 0:
            pdf.append(KeepTogether(paragraphs))
        writeSectionEnd(outputFile)
        outputFile.write("</div>\n")

#===============================================================================
#
#===============================================================================
    def writeTitleBlock(self, pageTitle, title, package, outputFile, pdf,
                        extraHtmlHeader=None, extraPDFHeader=None):
        outputFile.write("<title id=\"pageTitle\">%s</title>" % pageTitle)
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        if package is not None:
            outputFile.write(("<h4>Package: %s</h4>\n</div>\n</div>"
                               % getPackageHyperLinkByName(package.getName())))
            pdf.append(Paragraph("Package: %s" % package.getName(), styles['Heading4']))
            pdf.append(Spacer(1, 10))
        if extraHtmlHeader:
            outputFile.write("<h4>%s</h4>\n</div>\n</div><br/>\n" % extraHtmlHeader)
        if extraPDFHeader:
            pdf.append(Paragraph(extraPDFHeader, styles['Heading4']))
            pdf.append(Spacer(1, 10))
        outputFile.write("<h1>%s</h1>\n</div>\n</div><br/>\n" % title)
        pdf.append(Paragraph(title, styles['Title']))

#===============================================================================
# method to generate a tablized representation of data
#===============================================================================
    def generateTablizedItemList(self, sortedItemList, outputFile, htmlMappingFunc,
                                 nameFunc=None, totalCol=8, classid="", keyVal=None):
        table = []
        totalNumRoutine = 0
        if sortedItemList:
            totalNumRoutine = len(sortedItemList)
        numOfRow = totalNumRoutine / totalCol + 1
        if totalNumRoutine > 0:
            outputFile.write("<div class=\"contents\"><table>\n")
            for index in range(numOfRow):
                row = []
                outputFile.write("<tr class=\"%s\">" % classid)
                for i in range(totalCol):
                    position = index * totalCol + i
                    if position < totalNumRoutine:
                        displayName = sortedItemList[position]
                        linkName = htmlMappingFunc(sortedItemList[position])
                        borderColorString = findDotColor(sortedItemList[position]).replace("color=",'')
                        if keyVal:  linkName = htmlMappingFunc(sortedItemList[position],keyVal)
                        if nameFunc: displayName = nameFunc(displayName)
                        outputFile.write("<td style=\"border: 2px solid %s;\" class=\"indexkey\"><a class=\"e1\" href=\"%s\">%s</a>&nbsp;&nbsp;&nbsp;&nbsp;</td>"
                                   % (borderColorString, linkName, displayName))
                        # format name for pdf
                        displayName = str(displayName)
                        displayName = displayName.replace("<li>", "")
                        displayName = displayName.replace("</li>", " ")
                        displayName = displayName.replace("<ul>", "")
                        displayName = displayName.replace("</ul>", "")
                        displayName = displayName.replace("&sup2", "")
                        lines = displayName.split("<br>")
                        if len(lines) > 1:
                            cell = []
                            for line in lines:
                                cell.append(generateParagraph((line)))
                            row.append(cell)
                        else:
                            row.append(generateParagraph((displayName)))
                outputFile.write("</tr>\n")
                if row:
                    table.append(row)
            outputFile.write("</table>\n</div>\n")
        else:
            outputFile.write("<div>\n</div>\n")
        return table

#===============================================================================
#
#===============================================================================
    def __generatePDFTable__(self, data, columnWidths=None):
        if columnWidths is None:
            t = Table(data)
        elif type(columnWidths) is not list:
            # Evenly spaced columns
            columns = columnWidths
            t = Table(data, colWidths=[self.doc.width/columns]*columns)
        else:
            # Custom width columns
            t = Table(data, colWidths=columnWidths)
        t.setStyle(TableStyle([('INNERGRID', (0,0), (-1,-1), 0.25, colors.black),
                               ('BOX', (0,0), (-1,-1), 0.25, colors.black),
                               ('VALIGN', (0,0), (-1,-1), 'TOP'),
                               ]))
        return t

    def __writeImageToPDF__(self, imageFileName, pdf):
        if not os.path.exists(os.path.join(self._outDir, imageFileName)):
            return
        # Get image dimensions so can be scaled (if needed)
        im = PIL.Image.open(os.path.join(self._outDir, imageFileName))
        width, height = letter
        if im.width > width or im.height > height:
            rh = 1.0
            rw = 1.0
            if im.height > height: rh = height / im.height
            if im.width > width: rw = width / im.width
            r = min([rh, rw])
            pdf.append(Image(os.path.join(self._outDir, imageFileName),
                                im.width * r, im.height * r))
        else:
            pdf.append(Image(os.path.join(self._outDir, imageFileName)))

#===============================================================================
#
#===============================================================================
    def writeGenericTablizedHtmlData(self, headerList, itemList, outputFile, classid="" ):
        outputFile.write("<div><table>\n")
        if headerList and len(headerList) > 0:
            outputFile.write("<tr class=\"%s\" >\n" % (classid))
            for header in headerList:
                outputFile.write("<th class=\"IndexKey\">%s</th>\n" % ( header))
            outputFile.write("</tr>\n")
        if itemList and len(itemList) > 0:
            for itemRow in itemList:
                outputFile.write("<tr class=\"%s\">\n" % (classid))
                for data in itemRow:
                    outputFile.write("<td class=\"IndexValue\">%s</td>\n" % (data))
                outputFile.write("</tr>\n")
        outputFile.write("</table></div></div>\n")  # the second </div> closes the accordion

    def __writeGenericTablizedPDFData__(self, headerList, itemList, pdf,
                                        columnWidths=None, isString=True):
        table = []
        if headerList and len(headerList) > 0:
            table.append(generatePDFTableHeader(headerList, False))
        if itemList and len(itemList) > 0:
            for itemRow in itemList:
                row = []
                for data in itemRow:
                    if isString:
                        # Make sure data is a string...
                        data = str(data)
                        # ... and then remove html markup
                        data = data.replace("<para>", "")
                        data = data.replace("</para>", "")
                        data = data.replace("<BR>", "")
                        data = re.sub(r'<a href=".*?\.html">', "", data)
                        data = data.replace("</a>", "")
                        row.append(generateParagraph((data)))
                    else:
                        row.append(data)
                table.append(row)
        t = self.__generatePDFTable__(table, columnWidths)
        pdf.append(t)

#===============================================================================
# method to generate individual package page
#===============================================================================
    def generateIndividualPackagePage(self):
        indexList = ["Namespace", "Doc", "Dependency Graph",
                     "Dependent Graph",
                     "All ICR Entries","FileMan Files",
                     "Non-FileMan Globals", "All Routines"]
        for packageName in self._allPackages.iterkeys():
            # Setup the document with paper size and margins
            buf = io.BytesIO()
            self.doc = SimpleDocTemplate(
                buf,
                rightMargin=inch/2,
                leftMargin=inch/2,
                topMargin=inch/2,
                bottomMargin=inch/2,
                pagesize=landscape(letter),
            )
            pdf = []
            package = self._allPackages[packageName]
            indexList = ["Namespace", "Doc", "Dependency Graph",
                         "Dependent Graph",
                         "All ICR Entries","FileMan Files",
                         "Non-FileMan Globals", "All Routines"]
            for keyVal in sectionLinkObj.keys():
                  totalObjectDict = package.getAllPackageComponents(keyVal)
                  if not len(totalObjectDict) == 0:
                    indexList.append(keyVal.replace("_"," "))

            outputFile = open(os.path.join(self._outDir, getPackageHtmlFileName(packageName)), 'w')

            # Write the _header part
            self.__includeHeader__(outputFile)
            generateIndexBar(outputFile, indexList,
                              printButton=True, packageName=packageName)
            # Title
            title = "Package: %s" % packageName
            pdfList = indexList
            pdfList.append("Legend Graph")
            self.writeTitleBlock(title, title, None, outputFile, pdf)
            writePDFCustomization(outputFile, str(pdfList))
            # Namespace
            namespace = "Namespace: %s" % listDataToCommaSeperatorString(package.getNamespaces())
            outputFile.write(getAccordionHTML())
            writeSectionHeader("Namespace", "Namespace", outputFile, pdf,isAccordion="")
            outputFile.write("<div class=packageNamespace>")
            outputFile.write("<div><p><h4 id=\"packageNamespace\">%s</h4></div>" % namespace)
            pdf.append(generateParagraph(namespace))
            globalNamespaces = package.getGlobalNamespace()
            if globalNamespaces and len(globalNamespaces) > 0:
                globalNamespace = "Additional Global Namespace: %s" % listDataToCommaSeperatorString(globalNamespaces)
                outputFile.write("<div><p><h4 id=\"packageNamespace\">" + globalNamespace + "</h4></div>")
                pdf.append(generateParagraph(globalNamespace))
            else:
                outputFile.write("</h4></div>")
            writeSectionEnd(outputFile)
            # Link to VA documentation
            # Do not write in pdf
            writeSectionHeader("Documentation", "Doc", outputFile, None,isAccordion="")
            if len(package.getDocLink()) > 0:
                outputFile.write("<div><p><h4 id=\"packageDocs\">VA documentation in the <a target='blank' href=\"%s\">VistA Documentation Library</a></p></div>" % package.getDocLink())
                if len(package.getDocMirrorLink()) > 0:
                    outputFile.write("&nbsp;or&nbsp;<a href=\"%s\">OSEHRA Mirror site</a></h4></div>\n" % package.getDocMirrorLink())
            else:
                outputFile.write("<div><p><h4><a href=\"https://www.va.gov/vdl/\">VA documentation in the VistA Documentation Library</a></h4></p></div>\n")
            writeSectionEnd(outputFile)

            #
            self.generatePackageDependencySection(packageName, outputFile, pdf, True)
            self.generatePackageDependencySection(packageName, outputFile, pdf, False)

            # Find all ICR entries that have the package as a "CUSTODIAL Package"
            icr = []
            icrList = self.queryICRInfo(packageName.upper(),"*","*")
            writeSectionHeader("All ICR Entries: %d" % len(icrList),
                               "All ICR Entries",
                               outputFile,
                               icr if len(icrList) > 0 else None)
            sortedICRList = sorted(icrList, key=lambda item: float(item["NUMBER"]))
            data = self.generateTablizedItemList(sortedICRList, outputFile,
                                                 getICRHtmlFileName,
                                                 getICRDisplayName, classid="icrVals")

            if data:
                table = self.__generatePDFTable__(data)
                icr.append(table)
                pdf.append(KeepTogether(icr))
            writeSectionEnd(outputFile)

            # separate fileman files and non-fileman globals
            fileManList, globalList = [], []
            allGlobals = package.getAllGlobals()
            for globalVar in allGlobals.itervalues():
                if globalVar.isFileManFile():
                    fileManList.append(globalVar)
                else:
                    globalList.append(globalVar)

            # section of All FileMan files
            allFilemanFiles = []
            writeSectionHeader("All FileMan Files Total: %d" % len(fileManList),
                               "FileMan Files", outputFile,
                               allFilemanFiles if len(fileManList) > 0 else None)

            sortedFileManList = sorted(fileManList, key=lambda item: float(item.getFileNo())) # sorted by fileMan file No
            data = self.generateTablizedItemList(sortedFileManList, outputFile,
                                                 getGlobalHtmlFileName,
                                                 getGlobalDisplayName, classid="fmFiles")

            if data:
                # Note: In generateTablizedItemList, number of columns is set to 8
                table = self.__generatePDFTable__(data, 8)
                allFilemanFiles.append(table)
                pdf.append(KeepTogether(allFilemanFiles))
            writeSectionEnd(outputFile)

            # section of All Non-FileMan Globals
            nonFilemanGlobals = []
            writeSectionHeader("Non FileMan Globals Total: %d" % len(globalList),
                               "Non-FileMan Globals",
                               outputFile,
                               nonFilemanGlobals if len(globalList) > 0 else None)
            sortedGlobalList = sorted(globalList, key=lambda item: item.getName()) # sorted by global Name
            data = self.generateTablizedItemList(sortedGlobalList, outputFile,
                                                 getGlobalHtmlFileName,
                                                 getGlobalDisplayName, classid="nonfmFiles")
            if data:
                table = self.__generatePDFTable__(data)
                nonFilemanGlobals.append(table)
                pdf.append(KeepTogether(nonFilemanGlobals))
            writeSectionEnd(outputFile)

            # section of all routines
            allRoutines = []
            sortedRoutines = sorted(package.getAllRoutines().keys())
            totalNumRoutine = len(sortedRoutines)
            writeSectionHeader("All Routines Total: %d" % totalNumRoutine,
                               "All Routines",
                               outputFile,
                               allRoutines if totalNumRoutine > 0 else None)

            data = self.generateTablizedItemList(sortedRoutines, outputFile,
                                                 getRoutineHtmlFileName,
                                                 self.getRoutineDisplayNameByName,
                                                 8, classid="rtns")
            if data:
                table = self.__generatePDFTable__(data)
                allRoutines.append(table)
                pdf.append(KeepTogether(allRoutines))
            writeSectionEnd(outputFile)

            # footer

            writeLegends(self._outDir, outputFile)
            
            # Package Components
            for keyVal in sectionLinkObj.keys():
              totalObjectDict = package.getAllPackageComponents(keyVal)
              if len(totalObjectDict) == 0:
                continue
              totalComponents  = []
              pdfComponents  = []
              for value in totalObjectDict.keys():
                totalComponents.append(totalObjectDict[value])
              sortedComponents = sorted(totalComponents, key=lambda x:x.getName())
              totalNumObjects = len(sortedComponents)
              writeSectionHeader("All %s Total: %d" % (keyVal, totalNumObjects),
                                 keyVal.replace("_"," "),
                                 outputFile,
                                 pdfComponents if totalNumObjects > 0 else None)
              self.generateTablizedItemList(sortedComponents, outputFile,
                                getPackageObjHtmlFileName,
                                self.getPackageComponentDisplayName,
                                8,
                                keyVal = keyVal,
                                classid = keyVal+"_data")
              if data:
                table = self.__generatePDFTable__(data)
                pdfComponents.append(table)
                pdf.append(KeepTogether(pdfComponents))
              writeSectionEnd(outputFile)
            writeSectionEnd(outputFile)
            generateIndexBar(outputFile, indexList)
            self.__includeFooter__(outputFile)
            outputFile.close()

            try:
                # Write the PDF to a file
                pdfFileName = os.path.join(self.__getPDFDirectory__(packageName),
                                            getPackagePdfFileName(packageName))
                self.doc.build(pdf)
                with open(pdfFileName, 'w') as fd:
                    fd.write(buf.getvalue())
            except:
                self.failures.append(pdfFileName)
                pass

#===============================================================================
# method to generate Routine Dependency and Dependents page
#===============================================================================
    def generateRoutineDependencySection(self, routine, outputFile, pdf, isDependency=True):
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        if isDependency:
            depRoutines = routine.getCalledRoutines()
            sectionGraphHeader = "Call Graph"
            sectionListHeader = "Called Routines"
            totalNum = routine.getTotalCalled()
        else:
            depRoutines = routine.getCallerRoutines()
            sectionGraphHeader = "Caller Graph"
            sectionListHeader = "Caller Routines"
            routineSuffix = "_caller"
            totalNum = routine.getTotalCaller()
        if not depRoutines:
          return
        self.__writeRoutineDepGraphSection__(routine, depRoutines,
                                             sectionGraphHeader,
                                             sectionGraphHeader,
                                             outputFile, pdf, isDependency)
        self.__writeRoutineDepListSection__(routine, depRoutines,
                                            sectionListHeader,
                                            sectionListHeader,
                                            outputFile, pdf, isDependency)

    def __getDataEntryDetailHtmlLink__(self, fileNo, ien):
      return ("https://code.osehra.org/vivian/files/%s/%s-%s.html" % (fileNo.replace('.','_'),fileNo,
            ien))
#===============================================================================
# Method to generate routine variables sections such as Local Variables, Global Variables
#===============================================================================
    def __findDataURL__(self, name, routine):
       (field, ienVal) = name.split("DATA")
       if "+" in ienVal:
         ien,loc = ienVal.split("+")
       return "<a href=\"#%s\">%s</a>(IEN:<a href=\"%s\">%s</a>)" % (field, field, self.__getDataEntryDetailHtmlLink__(routine.getFileNo(),ien), ien)
    def generateRoutineVariableSection(self, outputFile, routine, sectionTitle, headerList, variables,
                                       converFunc):
        writeSectionHeader(sectionTitle, sectionTitle, outputFile)
        outputList = converFunc(variables, routine=routine)
        writeGenericTablizedData(headerList, outputList, outputFile)
    def __getDataEntryDetailHtmlLink__(self, fileNo, ien):
      return ("https://code.osehra.org/vivian/files/%s/%s-%s.html" % (fileNo.replace('.','_'),fileNo,
            ien))
    def __convertRPCDataReference__(self, variables, routine=None):
        return self.__convertRtnDataReference__(variables, '8994')
    def __convertHL7DataReference__(self, variables, routine=None):
        return self.__convertRtnDataReference__(variables, '101')
    def __convertRtnDataReference__(self, variables, fileNo):
        output = []
        for item in variables:
            detailLink = self.__getDataEntryDetailHtmlLink__(fileNo,
                item['ien'])
            name = "<a href=\"%s\">%s</a>" % (detailLink, item['name'])
            tag = item.get('tag', "")
            output.append((name, tag))
        return output

    def __convertVariableToTableData__(self, variables, isGlobal = False, routine=None):
        output = []
        allVars = sorted(variables.iterkeys())
        for varName in allVars:
            if varName == None:
              continue
            var = variables[varName]
            if isGlobal and varName in self._allGlobals:
                globalVar = self._allGlobals[varName]
                varName = getFileManFileHyperLinkWithNameFileNo(globalVar)
            lineOccurencesString = self.__generateLineOccurencesString__(var.getLineOffsets(), routine)
            output.append(((var.getPrefix()+varName).strip(), lineOccurencesString))
        return output

    def __generateLineOccurencesString__(self, lineOccurences,routine):
        lineOccurencesString = ""
        index = 0
        for offset in lineOccurences:
            offsetStr = offset
            if re.search("[0-9.]+DATA[0-9]+", offset):
              if routine:
                  offsetStr = self.__findDataURL__(offset,routine)
            if index > 0:
                lineOccurencesString += ",&nbsp;"
            lineOccurencesString += offsetStr
            if (index + 1) % LINE_TAG_PER_LINE == 0:
                lineOccurencesString +="<BR>"
            index += 1
        return lineOccurencesString

    def __convertGlobalVarToTableData__(self, variables, routine=None):
        return self.__convertVariableToTableData__(variables, isGlobal=True, routine=routine)
    def __convertFileManDbCallToTableData__(self, variables, routine=None):
        output = []
        allVars = sorted(variables.keys())
        for fileNo in allVars:
            varInst, tags = variables[fileNo]
            varName = None
            if varInst.getFileNo() and varInst.isSubFile():
                varName = getFileManSubFileHypeLinkByName(varInst.getFileNo())
            else:
                varName = getFileManFileHyperLinkWithNameFileNo(varInst)
            callTagsStr = ""
            index = 0
            for item in tags:
                if index > 0:
                    callTagsStr += ", &nbsp;"
                if item == None:
                    callTagsStr += "Classic Fileman Calls"
                else:
                    tag, rtn = "", ""
                    rst = item.split('^')
                    if len(rst) == 0:
                      rtn = rst[0]
                    else:
                      tag = rst[0]
                      rtn = rst[1]
                    callTagsStr += tag + '^' + getRoutineHypeLinkByName(rtn)
                index += 1
            output.append((varName, callTagsStr))
        return output

    def __convertNakedGlobaToTableData__(self, variables, routine=None):
        return self.__convertVariableToTableData__(variables, isGlobal=False,routine=routine)
    def __convertMarkedItemToTableData__(self, variables, routine=None):
        return self.__convertVariableToTableData__(variables, isGlobal=False,routine=routine)
    def __convertLabelReferenceToTableData__(self, variables, routine=None):
        return self.__convertVariableToTableData__(variables, isGlobal=False,routine=routine)
    def __convertExternalReferenceToTableData__(self, variables, routine=None):
        output = []
        allVars = sorted(variables.iterkeys(), key = itemgetter(0,1))
        for nameTag in allVars:
            lineOccurencesString = self.__generateLineOccurencesString__(variables[nameTag], routine)
            output.append((nameTag[1]+"^"+getRoutineHypeLinkByName(nameTag[0]),
                           lineOccurencesString))
        return output

#===============================================================================
# Methods to generate individual routine page
#===============================================================================
    def __getRpcReferences__(self, rtnName):
        return self.__getRtnDataFileRefs__(rtnName, '8994')

    def __getHl7References__(self, rtnName):
        return self.__getRtnDataFileRefs__(rtnName, '101')

    def __getRtnDataFileRefs__(self, rtnName, fileNo):
        if self._rtnRefJson and rtnName in self._rtnRefJson:
          refFilesJson = self._rtnRefJson[rtnName]
          return refFilesJson.get(fileNo)
        return None

    ###########################################################################
    # Generator functions
    def __writeRoutineInfoSection__(self, routine, data, header, link,
                                    outputFile, pdf, classid=""):
        writeSectionHeader(header, link, outputFile, pdf,isAccordion="")
        outputFile.write("<div>")
        for comment in data:
            outputFile.write("<p><span class=\"information %s\">%s</span></p>\n" % (classid, comment))
            pdf.append(generateParagraph(comment))
        outputFile.write("</div>")

    def __writeRoutineSourceSection__(self, routine, data, header, link,
                                      outputFile, pdf, classid="", isAccordion=""):
        # Do not write source file link in PDF
        writeSectionHeader(header, link, outputFile, None)
        if routine._objType in sectionLinkObj.keys():
          outputFile.write('<div><p><span class=\"information\">%s Information &lt;<a class=\"el\" href=\"http://code.osehra.org/vivian/files/%s/%s-%s.html\">%s</a>&gt;</span></p></div>\n'\
                                     % (routine._objType, sectionLinkObj[routine._objType]['number'].replace('.','_'), sectionLinkObj[routine._objType]['number'] ,routine.getIEN(), routine.getOriginalName())
          )
        else:
          outputFile.write("<div class=\"%s\"><p><span class=\"sourcefile\">Source file &lt;<a class=\"el\" href=\"%s\">%s.m</a>&gt;</span></p></div>\n" %
                         (classid,
                          getRoutineSourceHtmlFileName(routine.getOriginalName()),
                          routine.getOriginalName()))

    # Generate routine variables sections
    # (e.g. Local Variables or Global Variables)
    def __writeRoutineVariableSection__(self, routine, data, header, link,
                                        outputFile, pdf, tableHeader,
                                        convFunc, classid=""):
        section = []
        writeSectionHeader(header, header, outputFile, section)
        outputList = convFunc(data)
        self.writeGenericTablizedHtmlData(tableHeader, outputList, outputFile, classid)
        # 'Line Occurrences' column can be really long
        columns = 4
        columnWidth = self.doc.width/columns
        columnWidths = [columnWidth, columnWidth * 3]
        self.__writeGenericTablizedPDFData__(tableHeader, outputList, section, columnWidths)
        pdf.append(KeepTogether(section))

    ###########################################################################
    def __generateICRInformation__(self, icrVals):
      icrString = ""
      for icrEntry in icrVals:
        icrString += "<li><a href='%s'>ICR #%s</a></li>" % (getICRHtmlFileName(icrEntry),icrEntry["NUMBER"])
        if "STATUS" in icrEntry:
          icrString +="<ul><li>Status: %s</li></ul>" % (icrEntry["STATUS"])
        if "USAGE" in icrEntry:
          icrString +="<ul><li>Usage: %s</li></ul>" % (icrEntry["USAGE"])
      return icrString

    def __generateICRInformationPDF__(self, icrVals): # No links
      icrList = []
      for icrEntry in icrVals:
        icrList.append("ICR #%s" % icrEntry["NUMBER"])
        if "STATUS" in icrEntry:
          icrList.append("Status: %s" % icrEntry["STATUS"])
        if "USAGE" in icrEntry:
          icrList.append("Usage: %s" % icrEntry["USAGE"])
      return generatePDFListData(icrList)

    def __writeInteractionCommandHTML__(self, entry):
      outstring = "<ul>"
      entryDict = {
                  "formatting": "Formatting:",
                  "string": "Prompt:",
                  "variable": "Variable:",
                  "timeout": "Timeout:",
                  "conditional": "Condition for execution:",
                  "line": "Line Location:"
                 }
      for key in entryDict:
        if key in entry:
          outstring += "<li>%s %s</li>" % (entryDict[key],entry[key])
      outstring +=  "</ul>"
      return outstring

    def __writeInteractionCommandPDF__(self, entry):
      out = []
      entryDict = {
                  "formatting": "Formatting:",
                  "string": "Prompt:",
                  "variable": "Variable:",
                  "timeout": "Timeout:",
                  "conditional": "Condition for execution:",
                  "line": "Line Location:"
                 }
      for key in entryDict:
        if key in entry:
          text = "%s %s" % (entryDict[key],entry[key])
          # TODO: Want to use 'Preformatted' instead of 'Paragraph' but it
          # doesn't wrap! Filter out problematic characters instead
          text = re.sub(r'<.*?>', "", text)
          text = re.sub(r'<.*?', "", text)
          out.append(ListItem(generateParagraph(text), leftIndent=7))
      return generateList(out)

    def __writeEntryPointSection__(self, routine, data, header, link,
                                   outputFile, pdf, tableHeader, classid=""):
        writeSectionHeader("Entry Points", "Routine Entry Points", outputFile, pdf)
        entryPoints = routine.getEntryPoints()
        tableData = []
        pdfData = []
        for entry in entryPoints:
            row = []
            pdfRow = []
            comments = entryPoints[entry]["comments"] if entryPoints[entry]["comments"] else ""
            # Build table row
            row.append(entry)
            pdfRow.append(generateParagraph(entry))
            val = ""
            pdfVal = []
            for line in comments:
                val += line + '<br/>'
                # TODO: Want to use 'Preformatted' instead of 'Paragraph' but it
                # doesn't wrap! Filter out problematic characters instead
                line = re.sub(r'<.*?>', "", line)
                line = re.sub(r'<.*?', "", line)
                pdfVal.append(Paragraph(line, styles['Heading6']))
            row.append(val)
            pdfRow.append(pdfVal)
            row.append(self.__generateICRInformation__(entryPoints[entry]["icr"]))
            print routine.getName()
            pdfRow.append(self.__generateICRInformationPDF__(entryPoints[entry]["icr"]))
            tableData.append(row)
            pdfData.append(pdfRow)
        self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile, classid=classid)
        self.__writeGenericTablizedPDFData__(tableHeader, pdfData, pdf, isString=False)

    def __writeInteractionSection__(self, routine, data, header, link,
                                    outputFile, pdf, tableHeader, classid=""):
        writeSectionHeader("Interaction Calls", "Interaction Calls", outputFile, pdf)
        calledRtns = routine.getFilteredExternalReference(['DIR','VALM','DDS','DIE','DIC','%ZIS','DIALOG','DIALOGU'])
        tableData = []
        pdfTableData = []
        for entry in data:  # R and W commands
          row = []
          pdfRow = []
          functionCall = "Function Call: %s" % entry['type']
          row.append(functionCall)
          pdfRow.append(generateParagraph(functionCall))
          row.append(self.__writeInteractionCommandHTML__(entry))
          pdfRow.append(self.__writeInteractionCommandPDF__(entry))
          tableData.append(row)
          pdfTableData.append(pdfRow)
        # Write out the entries that are "interaction" routines
        for entry in calledRtns:
          row = []
          pdfRow = []
          row.append("Routine Call")
          pdfRow.append(generateParagraph("Routine Call"))
          pdfVal = []
          val = "<ul>"
          val += "<li>" + entry[0] + "</li>"
          pdfVal.append(entry[0])
          # Nicely show the ENTRYPOINT+OFFSET values for location
          if type(calledRtns[entry]) is list:
            val += "<li>Line Location:</li>"
            pdfVal.append("Line Location:")
            val += "<ul>"
            for location in calledRtns[entry]:
              val += "<li>" + location + "</li>"
              pdfVal.append(location)
            val += "</ul>"
          else:
            val += "<li>" + str(calledRtns[entry]) + "</li>"
            pdfVal.append(calledRtns[entry])
          val += "</ul>"
          row.append(val)
          tableData.append(row)
          pdfRow.append(generatePDFListData(pdfVal))
          pdfTableData.append(pdfRow)
        self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile, classid=classid)
        self.__writeGenericTablizedPDFData__(tableHeader, pdfTableData, pdf, isString=False)

    ###########################################################################
    # Generator function
    def __writeRoutineDepGraphSection__(self, routine, data, header, link,
                                        outputFile, pdf, isDependency=True, classid=""):
        section = []
        writeSectionHeader(header, link, outputFile, section, isAccordion="")
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        if isDependency:
          routineSuffix = "_called"
        else:
          routineSuffix = "_caller"
        fileNamePrefix = routineName + routineSuffix
        fileName = os.path.join(self._outDir,
                                packageName + "/" + fileNamePrefix + ".cmapx")
        if os.path.exists(fileName):
          if not isDependency:
            writeLegends(self._outDir,outputFile)
          outputFile.write("<div class=\"contents\">\n")
          imageFileName = packageName + "/" + fileNamePrefix + ".png"
          outputFile.write("<img id=\"img%s\"src=\"%s\" border=\"0\" alt=\"%s\" usemap=\"#%s\"/>\n"
                     % (routineSuffix,
                        urllib.quote(imageFileName),
                        header,
                        fileNamePrefix))
          self.__writeImageToPDF__(imageFileName, section)
          # append the content of map outputFile
          with open(fileName, 'r') as cmapFile:
            for line in cmapFile:
                outputFile.write(line)
                section.append(generateParagraph((line)))
        self.__writeRoutineDepListSection__(routine, data, header, link,
                                            outputFile, section, isDependency, classid=classid)
        pdf.append(KeepTogether(section))

    ###########################################################################

    def __writeRoutineDepListSection__(self, routine, data, header, link,
                                       outputFile, pdf, isDependency=True,
                                       classid=""):
      if isDependency:
          totalNum = routine.getTotalCalled()
      else:
          totalNum = routine.getTotalCaller()
      paragraphs = []
      paragraphs.append(Paragraph("%s Total: %d" % (header, totalNum), styles['Heading3']))
      writeSubSectionHeader("%s Total: %d" % (header, totalNum), outputFile)
      tableHeader = ["Package", "Total", header]
      table = []  # pdf
      tableData = []  # html
      table.append(generatePDFTableHeader(tableHeader, False))
      # sort the key by Total # of routines
      sortedDepRoutines = sorted(sorted(data.keys()),
                               key=lambda item: len(data[item]),
                               reverse=True)
      for depPackage in sortedDepRoutines:
          routinePackageLink = getPackageHyperLinkByName(depPackage.getName())
          routineNameLink = ""
          routineName = "" # Printed to PDF, no links
          index = 0
          for depRoutine in sorted(data[depPackage].keys()):
              if isDependency: # append tag information for called routines
                  allTags = data[depPackage][depRoutine].keys()
                  sortedTags = sorted(allTags)
                  # format the tag
                  tagString = ""
                  if len(sortedTags) > 1:
                      tagString = "("
                  idx = 0
                  for tag in sortedTags:
                      if idx > 0:
                          tagString += ","
                      idx += 1
                      tagString += tag
                  if len(sortedTags) > 1:
                      tagString += ")"
                  routineNameLink += tagString + "^"
                  routineName += tagString + "^"
              routineName += depRoutine.getName()
              routineName += "  "
              routineNameLink += "<a href=%s>%s</a>" % (getPackageObjHtmlFileName(depRoutine),depRoutine.getName())
              routineNameLink += "&nbsp;&nbsp;"
              if (index + 1) % 8 == 0:
                  routineNameLink += "<BR>"
              index += 1
          # No html links in PDF table
          pdfRow = [depPackage.getName(), "%d" % len(data[depPackage]), routineName]
          table.append(generatePDFTableRow(pdfRow))
          row = []
          row.append(routinePackageLink)
          row.append("%d" % len(data[depPackage]))
          row.append(routineNameLink)
          tableData.append(row)
      self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile, classid=classid)
      columns = 10
      columnWidth = self.doc.width/columns
      columnWidths = [columnWidth * 2, columnWidth, columnWidth * 7]
      t = self.__generatePDFTable__(table, columnWidths)
      paragraphs.append(t)
      pdf.append(KeepTogether(paragraphs))

    def __generateIndividualRoutinePage__(self, routine, pdf, platform=None, existingOutFile = None, fileNameGenerator=getRoutineHtmlFileNameUnquoted,DEFAULT_HEADER_LIST=DEFAULT_VARIABLE_SECTION_HEADER_LIST):
        assert routine
        routineName = routine.getName()
        # This is a list of sections that might be applicable to a routine
        sectionGenLst = [
           # Name section
           {
             "name": "Info", # this is also the link name
             "header" : "Information", # this is the actual display name
             "data" : routine.getComment, # the data source
             "generator" : self.__writeRoutineInfoSection__, # section generator
             'classid': "header"
           },
           # Source section
           {
             "name": "Source", # this is also the link name
             "header" : "Source Information", # this is the actual display name
             "data" : routine.hasSourceCode, # the data source
             "generator" : self.__writeRoutineSourceSection__, # section generator
             "classid":"source"
           },
           # Call Graph section
           {
             "name": "Call Graph", # this is also the link name
             "data" : routine.getCalledRoutines, # the data source
             "generator" : self.__writeRoutineDepGraphSection__, # section generator
             "classid"  :"callG"
           },
           # Caller Graph section
           {
             "name": "Caller Graph", # this is also the link name
             "data" : routine.getCallerRoutines, # the data source
             "generator" : self.__writeRoutineDepGraphSection__, # section generator
             "classid"  :"callerG",
             "geneargs" : [False],
           },
            # Entry Point section
           {
             "name": "Entry Points", # this is also the link name
             "data" : routine.getEntryPoints, # the data source
             "generator" : self.__writeEntryPointSection__, # section generator
             "geneargs" : [ENTRY_POINT_SECTION_HEADER_LIST], # extra argument
             "classid"  :"entrypoint"
           },
           # External References section
           {
             "name": "External References", # this is also the link name
             "data" : routine.getExternalReference, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_HEADER_LIST,
                           self.__convertExternalReferenceToTableData__], # extra argument
             "classid"  :"external"
           },
           # Interaction Code section
           {
             "name": "Interaction Calls", # this is also the link name
             "data" : routine.getInteractionEntries, # the data source
             "generator" : self.__writeInteractionSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST], # extra argument
             "classid"  :"interactioncalls"
           },
           # Used in RPC section
           {
             "name": "Used in RPC", # this is also the link name
             "data" : self.__getRpcReferences__, # the data source
             "dataarg" : [routineName], # extra arguments for data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [RPC_REFERENCE_SECTION_HEADER_LIST,
                           self.__convertRPCDataReference__], # extra argument
             "classid"  :"rpc"
           },
           # Used in HL7 Interface section
           {
             "name": "Used in HL7 Interface", # this is also the link name
             "data" : self.__getHl7References__, # the data source
             "dataarg" : [routineName], # extra arguments for data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [HL7_REFERENCE_SECTION_HEADER_LIST,
                           self.__convertHL7DataReference__], # extra argument
             "classid"  :"hl7"
           },
           # FileMan Files Accessed Via FileMan Db Call section
           {
             "name": "FileMan Files Accessed Via FileMan Db Call", # this is also the link name
             "data" : routine.getFilemanDbCallGlobals, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [FILENO_FILEMANDB_SECTION_HEADER_LIST,
                           self.__convertFileManDbCallToTableData__], # extra argument
             "classid"  :"dbCall"
           },
           # Global Variables Directly Accessed section
           {
             "name": "Global Variables Directly Accessed", # this is also the link name
             "data" : routine.getGlobalVariables, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [GLOBAL_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertGlobalVarToTableData__], # extra argument
             "classid"  :"directAccess"
           },
           # Label References section
           {
             "name": "Label References", # this is also the link name
             "data" : routine.getLabelReferences, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [LABEL_REFERENCE_SECTION_HEADER_LIST,
                           self.__convertLabelReferenceToTableData__], # extra argument
             "classid"  :"label"
           },
           # Naked Globals section
           {
             "name": "Naked Globals", # this is also the link name
             "data" : routine.getNakedGlobals, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_HEADER_LIST,
                           self.__convertNakedGlobaToTableData__], # extra argument
             "classid"  :"naked"
           },
           # Local Variables section
           {
             "name": "Local Variables", # this is also the link name
             "data" : routine.getLocalVariables, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_HEADER_LIST,
                           self.__convertVariableToTableData__], # extra argument
             "classid"  :"local"
           },
           # Marked Items section
           {
             "name": "Marked Items", # this is also the link name
             "data" : routine.getMarkedItems, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_HEADER_LIST,
                           self.__convertMarkedItemToTableData__], # extra argument
             "classid"  :"marked"
           },
        ]
        package = routine.getPackage()
        if existingOutFile:
          outputFile = existingOutFile
        else:
          outputFile = open(os.path.join(self._outDir,fileNameGenerator(routine, routine._title)), 'w')
          self.__includeHeader__(outputFile)
        # generated the qindex bar
        indexList, idxLst = findRelevantIndex(sectionGenLst,existingOutFile)
        if not existingOutFile:
          generateIndexBar(outputFile, indexList, printButton=True)
          # Title
          writePDFCustomization(outputFile, str(indexList))
          title = "Routine: %s" % routineName
          routineHeader = title
          if platform:
              routineHeader += "Platform: %s" % platform
          self.writeTitleBlock(title, routineHeader, package, outputFile, pdf)
          #outputFile.write(getAccordionHTML())
        for idx in idxLst:
          sectionGen = sectionGenLst[idx]
          data = sectionGen['data'](*sectionGen.get('dataarg',[]))
          link = sectionGen['name']
          header = sectionGen.get('header', link)
          geneargs = sectionGen.get('geneargs',[])
          classid  = sectionGen.get('classid', "")
          sectionGen['generator'](routine, data, header, link, outputFile, pdf, classid=classid,
                                  *geneargs)
          writeSectionEnd(outputFile)
          if header == "Local Variables":
            # TODO: ?
            outputFile.write("</div>\n")
        if not existingOutFile:
        # generated the index bar at the bottom
          generateIndexBar(outputFile, indexList)
          self.__includeFooter__(outputFile)
          outputFile.close()
#===============================================================================
# Method to generate page for platform-dependent generic routine page
#===============================================================================
    def __generatePlatformDependentGenericRoutinePage__(self, genericRoutine, pdf):
        assert genericRoutine
        assert isinstance(genericRoutine, PlatformDependentGenericRoutine)
        # generated the subpage for each platform routines
        platformDepRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in platformDepRoutines.itervalues():
            routineInfo[0]._title="Routine"
            self.__generateIndividualRoutinePage__(routineInfo[0], pdf, routineInfo[1])
        indexList = ["Platform Dependent Routines", "Caller Graph", "Caller Routines"]
        routineName = genericRoutine.getName()
        package = genericRoutine.getPackage()
        outputFile = open(os.path.join(self._outDir,
                                       getRoutineHtmlFileNameUnquoted(routineName)), 'w')
        self.__includeHeader__(outputFile)
        # generated the qindex bar
        generateIndexBar(outputFile, indexList, printButton=True)
        title = "Routine: %s" % routineName
        self.writeTitleBlock(title, title, package, outputFile, pdf)
        writeSectionHeader("Platform Dependent Routines", "DepRoutines", outputFile, pdf)
        # output the Platform part.
        tableRowList = []
        pdfTableRowList = []
        for routineInfo in platformDepRoutines.itervalues():
            tableRowList.append([getRoutineHypeLinkByName(routineInfo[0].getName()), routineInfo[1]])
            pdfTableRowList.append([routineInfo[0].getName(), routineInfo[1]])
        self.generateRoutineDependencySection(genericRoutine, outputFile, pdf, False)
        self.__writeGenericTablizedPDFData__(["Routine", "Platform"], tableRowList, pdf)
        outputFile.write("<br/>\n")
        # generated the index bar at the bottom
        generateIndexBar(outputFile, indexList)
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
# Method to generate all individual Package Components pages
#===============================================================================
    def __writePackageComponentSourceSection__(self, routine, data, header, link, outputFile, classid=""):
        fileNo = sectionLinkObj[routine.getObjectType()]['number']
        sourcePath = os.path.join(self._outDir,"..",fileNo.replace(".",'_'),fileNo+"-"+routine.getIEN()+".html")
        writeSectionHeader(header, link, outputFile,isAccordion="")

        if os.path.exists(sourcePath):
          file = open(sourcePath, 'r')
          fileLines = file.readlines()
          outputFile.write("<div><table>")
          for line in fileLines[fileLines.index( '<thead>\n'):]:
            outputFile.write(line.replace('<tr>','<tr class="%s">' % classid).replace('<td>','<td class="IndexValue %s">' % classid).replace('<th>','<th class="indexkey %s">' % classid))
          outputFile.write("</div></table>")

          file.close()
        else:
          outputFile.write("<div><p %s>Source Info Missing</p></div>" % classid)

          writeSectionEnd(outputFile)
    def __generatePackageComponentPage__(self, routine, platform=None, fileNameGenerator=getRoutineHtmlFileNameUnquoted,DEFAULT_HEADER_LIST=DEFAULT_VARIABLE_SECTION_HEADER_LIST):
            assert routine
            routineName = routine.getName()
            """ This is a list sections that might be applicable to a routine
            """
            sectionGenLst = [
                       # Name section
                       {
                         "name": "Info", # this is also the link name
                         "header" : "Information", # this is the actual display name
                         "data" : routine.getComment, # the data source
                         "generator" : self.__writeRoutineInfoSection__, # section generator
                         'classid': "header"
                       },
                       # Source section
                       {
                         "name": "Component Source", # this is also the link name
                         "header" : "Source Information", # this is the actual display name
                         "data" : routine.hasSourceCode, # the data source
                         "generator" : self.__writePackageComponentSourceSection__, # section generator
                         "classid":"source"
                       },
                       # Call Graph section
                       {
                         "name": "Call Graph", # this is also the link name
                         "data" : routine.getCalledRoutines, # the data source
                         "generator" : self.__writeRoutineDepGraphSection__, # section generator
                         "classid"  :"callG"
                       },
                       # Caller Graph section
                       {
                         "name": "Caller Graph", # this is also the link name
                         "data" : routine.getCallerRoutines, # the data source
                         "generator" : self.__writeRoutineDepGraphSection__, # section generator
                         "classid"  :"callerG",
                         "geneargs" : [False],
                       },
                        # Entry Point section
                       {
                         "name": "Entry Points", # this is also the link name
                         "data" : routine.getEntryPoints, # the data source
                         "generator" : self.__writeEntryPointSection__, # section generator
                         "geneargs" : [ENTRY_POINT_SECTION_HEADER_LIST], # extra argument
                         "classid"  :"entrypoint"
                       },
                       # External References section
                       {
                         "name": "External References", # this is also the link name
                         "data" : routine.getExternalReference, # the data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [DEFAULT_HEADER_LIST,
                                       self.__convertExternalReferenceToTableData__], # extra argument
                         "classid"  :"external"
                       },
                       # Interaction Code section
                       {
                         "name": "Interaction Calls", # this is also the link name
                         "data" : routine.getInteractionEntries, # the data source
                         "generator" : self.__writeInteractionSection__, # section generator
                         "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST], # extra argument
                         "classid"  :"interactioncalls"
                       },
                       # Used in RPC section
                       {
                         "name": "Used in RPC", # this is also the link name
                         "data" : self.__getRpcReferences__, # the data source
                         "dataarg" : [routineName], # extra arguments for data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [RPC_REFERENCE_SECTION_HEADER_LIST,
                                       self.__convertRPCDataReference__], # extra argument
                         "classid"  :"rpc"
                       },
                       # Used in HL7 Interface section
                       {
                         "name": "Used in HL7 Interface", # this is also the link name
                         "data" : self.__getHl7References__, # the data source
                         "dataarg" : [routineName], # extra arguments for data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [HL7_REFERENCE_SECTION_HEADER_LIST,
                                       self.__convertHL7DataReference__], # extra argument
                         "classid"  :"hl7"
                       },
                       # FileMan Files Accessed Via FileMan Db Call section
                       {
                         "name": "FileMan Files Accessed Via FileMan Db Call", # this is also the link name
                         "data" : routine.getFilemanDbCallGlobals, # the data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [FILENO_FILEMANDB_SECTION_HEADER_LIST,
                                       self.__convertFileManDbCallToTableData__], # extra argument
                         "classid"  :"dbCall"
                       },
                       # Global Variables Directly Accessed section
                       {
                         "name": "Global Variables Directly Accessed", # this is also the link name
                         "data" : routine.getGlobalVariables, # the data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [GLOBAL_VARIABLE_SECTION_HEADER_LIST,
                                       self.__convertGlobalVarToTableData__], # extra argument
                         "classid"  :"directAccess"
                       },
                       # Label References section
                       {
                         "name": "Label References", # this is also the link name
                         "data" : routine.getLabelReferences, # the data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [LABEL_REFERENCE_SECTION_HEADER_LIST,
                                       self.__convertLabelReferenceToTableData__], # extra argument
                         "classid"  :"label"
                       },
                       # Naked Globals section
                       {
                         "name": "Naked Globals", # this is also the link name
                         "data" : routine.getNakedGlobals, # the data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [DEFAULT_HEADER_LIST,
                                       self.__convertNakedGlobaToTableData__], # extra argument
                         "classid"  :"naked"
                       },
                       # Local Variables section
                       {
                         "name": "Local Variables", # this is also the link name
                         "data" : routine.getLocalVariables, # the data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [DEFAULT_HEADER_LIST,
                                       self.__convertVariableToTableData__], # extra argument
                         "classid"  :"local"
                       },
                       # Marked Items section
                       {
                         "name": "Marked Items", # this is also the link name
                         "data" : routine.getMarkedItems, # the data source
                         "generator" : self.__writeRoutineVariableSection__, # section generator
                         "geneargs" : [DEFAULT_HEADER_LIST,
                                       self.__convertMarkedItemToTableData__], # extra argument
                         "classid"  :"marked"
                       },
            ]
            package = routine.getPackage()
            outputFile = open(os.path.join(self._outDir,fileNameGenerator(routine, routine._title)), 'w')
            self.__includeHeader__(outputFile)
            # generated the qindex bar
            indexList = []
            idxLst = []
            for idx, item in enumerate(sectionGenLst):
              extraarg = item.get('dataarg', [])
              if item['data'](*extraarg):
                indexList.append(item['name'])
                idxLst.append(idx)
            title = routine._title+": "+routineName
            self.writeTitleBlock(title, title, package, outputFile)
            generateIndexBar(outputFile, indexList, printButton=True)
            writePDFCustomization(outputFile, str(indexList))
            #outputFile.write(getAccordionHTML())
            for idx in idxLst:
              sectionGen = sectionGenLst[idx]
              data = sectionGen['data'](*sectionGen.get('dataarg',[]))
              link = sectionGen['name']
              header = sectionGen.get('header', link)
              geneargs = sectionGen.get('geneargs',[])
              classid  = sectionGen.get('classid', "")
              sectionGen['generator'](routine, data, header, link, outputFile, classid=classid, *geneargs)
              writeSectionEnd(outputFile)
              if header == "Local Variables":
               outputFile.write("</div>\n")
          # generated the index bar at the bottom
            generateIndexBar(outputFile, indexList)
            self.__includeFooter__(outputFile)
            outputFile.close()

    def generateAllIndividualPackageComponentPage(self,keyVal):
        logger.info("Start generating all individual "+keyVal+"......")
        for package in self._allPackages.itervalues():
          for routine in package.getAllPackageComponents(keyVal).itervalues():
            routine._title = keyVal
            self.__generatePackageComponentPage__(routine,fileNameGenerator=getPackageObjHtmlFileName,DEFAULT_HEADER_LIST=PACKAGE_OBJECT_SECTION_HEADER_LIST)
        logger.info("End of generating all individual "+keyVal+"......")

    def generatePackageComponentIndexPage(self,keyVal, outputFile):
        outputFile.write('<div class="componentList" style="display: none;" id=%s>' % keyVal)
        outputFile.write("<title>"+keyVal+" Index List</title>")
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>"+keyVal+"  Index List</h1>\n</div>\n</div>")
        indexList = [char for char in string.uppercase]
        indexList.insert(0, "%")
        indexSet = sorted(set(indexList))
        generateIndexBar(outputFile, indexList, isIndex=True)
        outputFile.write("<div class=\"contents\">\n")
        sortedComponents = []
        objectDict = {}
        for package in self._allPackages.itervalues():
            for object in package.getAllPackageComponents(keyVal).itervalues():
                sortedComponents.append(object.getName())
                objectDict[object.getName()] = object
        sortedComponents = sorted(sortedComponents)#, key=lambda x:x.getName())
        for letter in indexList:
            bisect.insort_left(sortedComponents, letter)
        for value in sortedComponents:
          if value in objectDict.keys():
            sortedComponents[sortedComponents.index(value)] = objectDict[value]
        totalComponents = len(sortedComponents)
        totalCol = 4
        numPerCol = totalComponents / totalCol + 1
        outputFile.write("<table align=\"center\" width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n")
        for i in range(numPerCol):
            itemsPerRow = [];
            for j in range(totalCol):
                if (i + numPerCol * j) < totalComponents:
                    item = sortedComponents[i + numPerCol * j]
                    itemsPerRow.append(item);
            generateIndexedPackageComponentTableRow(outputFile, itemsPerRow,
                                           self.getPackageComponentDisplayName,
                                           indexSet)
        outputFile.write("</table>\n</div>\n")
        generateIndexBar(outputFile, indexList)
        outputFile.write('</div>')

    def generatePackageComponentListPage(self):
        outputFile = open(os.path.join(self._outDir,"PackageComponents.html"), 'w')
        self.__includeHeader__(outputFile)
        outputFile.write("""
<script type='text/javascript'>
$( document ).ready(function() {
  $(".componentList").first().show()
  $("#componentSelector").on("change", function(event) {
      $(".componentList").hide()
      $("#"+$(event.target).val().replace(/ /g,"_")).show()
  })
})
</script>
        """)
        outputFile.write("<title>Package Components Link List</title>")
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Package Components List</h1>\n</div>\n</div>")
        outputFile.write("<h3>Legends:</h3>")
        outputFile.write(PCLegend)
        outputFile.write("<div><label for=\"componentSelector\">Select Package Component Type:</label></div>")
        allObjects = sorted(sectionLinkObj.keys())
        outputFile.write("<select id='componentSelector'>")
        for objectKey in allObjects:
            outputFile.write("<option class=\"IndexKey\">%s</option>" % objectKey.replace("_"," "))
        outputFile.write("</select>\n")
        for objectKey in allObjects:
          self.generatePackageComponentIndexPage(objectKey,outputFile)
        self.__includeFooter__(outputFile)
        outputFile.close()
#===============================================================================
# Method to generate all individual routine pages
#===============================================================================
    def generateAllIndividualRoutinePage(self):
        logger.info("Start generating all individual Routines......")
        totalNoRoutines = len(self._allRoutines)
        routineIndex = 0
        for package in self._allPackages.itervalues():
            packageName = package.getName()
            for routine in package.getAllRoutines().itervalues():
                routineName = getRoutinePdfFileNameUnquoted(routine.getName())
                pdfFileName = os.path.join(self.__getPDFDirectory__(packageName),
                                                    routineName)
                if (routineIndex + 1) % PROGRESS_METER == 0:
                    logger.info("Processing %d of total %d" % (routineIndex, totalNoRoutines))
                routineIndex += 1
                # Setup the pdf document
                buf = io.BytesIO()
                self.doc = SimpleDocTemplate(
                    buf,
                    rightMargin=inch/2,
                    leftMargin=inch/2,
                    topMargin=inch/2,
                    bottomMargin=inch/2,
                    pagesize=landscape(letter),
                )
                pdf = []
                routine._title="Routine"
                # handle the special case for platform dependent routine
                if self._crossRef.isPlatformGenericRoutineByName(routine.getName()):
                    self.__generatePlatformDependentGenericRoutinePage__(routine, pdf)
                else:
                    self.__generateIndividualRoutinePage__(routine, pdf)
                try:
                    # Write the PDF to a file
                    self.doc.build(pdf)
                    with open(pdfFileName, 'w') as fd:
                        fd.write(buf.getvalue())
                except:
                    self.failures.append(pdfFileName)
                    pass

        logger.info("End of generating individual routines......")

###############################################################################
# Logging

# constants
DEFAULT_OUTPUT_LOG_FILE_NAME = "WebPageGen.log"

import tempfile
def getTempLogFile():
    return os.path.join(tempfile.gettempdir(), DEFAULT_OUTPUT_LOG_FILE_NAME)

def initLogging(outputFileName):
    logger.setLevel(logging.DEBUG)
    fileHandle = logging.FileHandler(outputFileName, 'w')
    fileHandle.setLevel(logging.DEBUG)
    formatStr = '%(asctime)s %(message)s'
    formatter = logging.Formatter(formatStr)
    fileHandle.setFormatter(formatter)
    #set up the stream handle (console)
    consoleHandle = logging.StreamHandler(sys.stdout)
    consoleHandle.setLevel(logging.INFO)
    consoleFormatter = logging.Formatter(formatStr)
    consoleHandle.setFormatter(consoleFormatter)
    logger.addHandler(fileHandle)
    logger.addHandler(consoleHandle)

def readIntoDictionary(infileName):
    values = {}
    with open(infileName,"r") as templateData:
      sniffer = csv.Sniffer()
      dialect = sniffer.sniff(templateData.read(1024))
      templateData.seek(0)
      hasHeader = sniffer.has_header(templateData.read(1024))
      logger.info ("hasHeader: %s" % hasHeader)
      templateData.seek(0)
      for index, line in enumerate(csv.reader(templateData,dialect)):
        if index == 0:
          continue
        if line[1] not in values.keys():
          values[line[1]] = []
        values[line[1]].append(line)
    return values
#===============================================================================
# main
#===============================================================================
def run(args):
    # Reads in the ICR JSON file and generates
    # a dictionary that consists of only the routine information
    #
    # Each key is a routine and it points to a list of all of the entries
    # that have that routine marked as a "ROUTINE" field.
    #
    if args.icrJsonFile:
      icrJson = os.path.abspath(args.icrJsonFile)
    parsedICRJSON= {}
    with open(icrJson, 'r') as icrFile:
      icrEntries =  json.load(icrFile)
      for entry in icrEntries:
        if 'CUSTODIAL PACKAGE' in entry:
          # Finding a Custodial Package means the entry should belong somewhere, for now
          # we ignore those that don't have one
          if not (entry['CUSTODIAL PACKAGE'] in parsedICRJSON):
            # First time we come across a package, add dictionaries for the used types
            parsedICRJSON[entry['CUSTODIAL PACKAGE']] = {}
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["ROUTINE"] = {}
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["GLOBAL"] = {}
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["OTHER"] = {}
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["OTHER"]["ENTRIES"] = []
          if "ROUTINE" in entry:
            if not (entry["ROUTINE"] in parsedICRJSON[entry['CUSTODIAL PACKAGE']]["ROUTINE"]):
              parsedICRJSON[entry['CUSTODIAL PACKAGE']]["ROUTINE"][entry["ROUTINE"]] = []
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["ROUTINE"][entry["ROUTINE"]].append(entry)
          elif "GLOBAL ROOT" in entry:
            globalRoot = entry['GLOBAL ROOT'].replace(',','')
            if not (globalRoot in parsedICRJSON[entry['CUSTODIAL PACKAGE']]["GLOBAL"]):
              parsedICRJSON[entry['CUSTODIAL PACKAGE']]["GLOBAL"][globalRoot] = []
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["GLOBAL"][globalRoot].append(entry)
          else:
            # Take all other entries into "OTHER", so that they can be shown on the package page
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["OTHER"]["ENTRIES"].append(entry)
    crossRef = CrossReferenceBuilder().buildCrossReferenceWithArgs(args, pkgDepJson=None, icrJson=parsedICRJSON,
                                                                   inputTemplateDeps=readIntoDictionary(args.inputTemplateDep),
                                                                   sortTemplateDeps=readIntoDictionary(args.sortTemplateDep),
                                                                   printTemplateDeps=readIntoDictionary(args.printTemplateDep)
                                                                   )
    logger.info ("Starting generating web pages....")
    doxDir = os.path.join(args.patchRepositDir, 'Utilities/Dox')

    webPageGen = WebPageGenerator(crossRef,
                                  args.outdir,
                                  args.pdfOutdir,
                                  args.MRepositDir,
                                  doxDir,
                                  args.git,
                                  args.includeSource,
                                  args.rtnJson)
    if args.dot:
        webPageGen.setDot(args.dot)
    webPageGen.generateWebPage()
    logger.info ("End of generating web pages....")

if __name__ == '__main__':
    crossRefArgParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
        description='VistA Visual Cross-Reference Documentation Generator',
        parents=[crossRefArgParse])
    parser.add_argument('-o', '--outdir', required=True,
                        help='Output Web Page directory')
    parser.add_argument('-pdf', '--pdfOutdir', required=True,
                        help='Output PDF directory')
    parser.add_argument('-git', required=True, help='git executable')
    parser.add_argument('-dot', required=False,
                        help='path to the folder containing dot excecutable')
    parser.add_argument('-is', '--includeSource', required=False,
                        default=False, action='store_true',
                        help='generate routine source code page?')
    parser.add_argument('-lf', '--outputLogFileName', required=False,
                        help='the output Logging file')
    parser.add_argument('-rj','--rtnJson', required=True,
                        help='routine reference in VistA data file in JSON format')
    parser.add_argument('-icr','--icrJsonFile', required=True,
                        help='JSON formatted information of DBIA/ICR')
    parser.add_argument('-st','--sortTemplateDep', required=True, help='CSV formatted "Relational Jump" field data for Sort Templates')
    parser.add_argument('-it','--inputTemplateDep', required=True, help='CSV formatted "Relational Jump" field data for Input Templates')
    parser.add_argument('-pt','--printTemplateDep', required=True, help='CSV formatted "Relational Jump" field data for Print Templates')
    result = parser.parse_args();

    if not result.outputLogFileName:
      outputLogFile = getTempLogFile()
    else:
      outputLogFile = result.outputLogFileName
    initLogging(outputLogFile)
    logger.debug (result)

    run(result)
