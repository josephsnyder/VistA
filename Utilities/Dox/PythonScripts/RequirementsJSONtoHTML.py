import json
import argparse
import os.path
import cgi
import logging
import pprint

from LogManager import logger, initConsoleLogging
from DataTableHtml import outputDataTableHeader, outputDataTableFooter
from DataTableHtml import writeTableListInfo, outputDataListTableHeader
from DataTableHtml import outputLargeDataListTableHeader, outputDataRecordTableHeader
from DataTableHtml import outputFileEntryTableList, safeElementId

def createArgParser():
    parser = argparse.ArgumentParser(description='VistA Requirements JSON to Html')
    parser.add_argument('reqJsonFile', help='path to the VistA Requirements JSON file')
    parser.add_argument('outDir', help='path to the output web page directory')
    return parser

fieldList = ['description',"BFFLink",'link','type','id',"name"]
allReqs = []
def getReqHTMLLink(reqID, reqEntry, **kargs):
        rpcFilename = '%s-%s.html' % ("BFFReq",reqID )
        return '<a href=\"%s\">%s</a>' % (rpcFilename, reqID)

def convertBFFLinks(linkList, reqEntry, **kargs):
        returnList = []
        for entry in linkList:
          returnList.append('<a href="%s-%s.html">%s</a>' % (entry.replace('/','_'),"Req", entry))
        return returnList
summary_list_fields = [
    ('description', None, None),
    ('BFFlink', None, convertBFFLinks),
    ('link', None, None),
    ('type', None, None),
    ('id', None, getReqHTMLLink),
    ('name', None, None)
]

class RequirementsConverter:
    def __init__(self, outDir):
        self._outDir = outDir

    def _convertReqEntryToSummaryInfo(self, reqEntry):
        summaryInfo = [""]*len(summary_list_fields)
        for idx, id in enumerate(summary_list_fields):
            if id[1] and id[1] in reqEntry.keys():
                summaryInfo[idx] = reqEntry[id[1]]
            elif id[0] in reqEntry.keys():
                summaryInfo[idx] = reqEntry[id[0]]
            if summaryInfo[idx] and id[2]:
                summaryInfo[idx] = id[2](summaryInfo[idx], reqEntry)
        return summaryInfo

    def _reqEntryToHtml(self, output, reqJSON):
        for field in fieldList:
            if field in reqJSON: # we have this field
                value = reqJSON[field]
                if False: #isSubFile(field):
                    output.write ("<tr>\n")
                    output.write("<td>%s</td>\n" % field)
                    output.write("<td>\n")
                    output.write ("<ol>\n")
                    self._icrSubFileToHtml(output, value, field)
                    output.write ("</ol>\n")
                    output.write("</td>\n")
                    output.write ("</tr>\n")
                    continue
                #value = self._convertIndividualFieldValue(field, reqJSON, value)
                output.write ("<tr>\n")
                output.write ("<td>%s</td>\n" % field)
                output.write ("<td>%s</td>\n" % value)
                output.write ("</tr>\n")
    def _generateIndividualRequirementsPage(self,reqJSON):
        ien = reqJSON['id']
        outIcrFile = os.path.join(self._outDir, 'BFFReq-' + str(ien) + '.html')
        tName = safeElementId("%s-%s" % ('BFFReq', ien))
        with open(outIcrFile, 'w') as output:
            output.write ("<html>")
            outputDataRecordTableHeader(output, tName)
            output.write("<body id=\"dt_example\">")
            output.write("""<div id="container" style="width:80%">""")
            output.write ("<h1>%s (%s) &nbsp;&nbsp;  %s (%s)</h1>\n" % (reqJSON['name'], ien,
                                                              'Req',
                                                              ien))
            outputFileEntryTableList(output, tName)
            """ table body """
            self._reqEntryToHtml(output, reqJSON)
            output.write("</tbody>\n")
            output.write("</table>\n")
            output.write("</div>\n")
            output.write("</div>\n")
            output.write ("</body></html>")
    def convertJsonToHtml(self, inputJsonFile):
        with open(inputJsonFile, 'r') as inputFile:
            inputJson = json.load(inputFile)
            self._generateRequirementsSummaryPage(inputJson)

    def _generateRequirementsSummaryPageImpl(self, inputJson, listName, pkgName, isForAll=False):
        outDir = self._outDir
        listName = listName.strip()
        pkgName = pkgName.strip()
        pkgHtmlName = pkgName.replace('/','_')
        outFilename = "%s/%s-%s.html" % (outDir, pkgName.replace('/','_'), listName)
        if not isForAll:
            outFilename = "%s/%s-Req.html" % (outDir, pkgHtmlName)
        with open(outFilename, 'w+') as output:
            output.write("<html>\n")
            tName = "%s-%s" % (listName.replace(' ', '_'), pkgName.replace(' ', '_'))
            useAjax = False #useAjaxDataTable(len(inputJson))
            columnNames = ["BFF Entry"] + fieldList
            searchColumns = ["BFF Entry"] + fieldList
            if useAjax:
                ajaxSrc = '%s_array.txt' % pkgName
                outputLargeDataListTableHeader(output, ajaxSrc, tName,
                                                columnNames, searchColumns)
            else:
                outputDataListTableHeader(output, tName, columnNames, searchColumns)
            output.write("<body id=\"dt_example\">")
            output.write("""<div id="container" style="width:80%">""")

            if isForAll:
                output.write("<h1>%s %s</h1>" % (pkgName, listName))
                reqData= inputJson
            else:
                reqData=inputJson[pkgName]
                output.write("<h2 align=\"right\"><a href=\"./All-%s.html\">"
                             "All %s</a></h2>" % (listName, listName))
                output.write("<h1>BFF Entry: %s %s</h1>" % (pkgName, listName))
            outputDataTableHeader(output, columnNames, tName)
            outputDataTableFooter(output, columnNames, tName)
            """ table body """
            output.write("<tbody>\n")
            if not useAjax:
                """ Now convert the requirements Data to Table data """
                for reqEntry in reqData:
                    output.write("<tr>\n")
                    if not isForAll:
                      reqSummary = self._convertReqEntryToSummaryInfo(reqEntry);
                      if not reqSummary in allReqs:
                        allReqs.append(reqSummary)
                      output.write("<td>%s</td>\n" % reqEntry['name'])
                    else:
                      reqSummary = reqEntry
                      output.write("<td>%s</td>\n" % reqEntry[5])
                    for idx,item in enumerate(fieldList):
                        # List of objects should be displayed as a UL object
                        if type(reqSummary[idx]) is list:
                          output.write("<td><ul>")
                          for entry in reqSummary[idx]:
                            output.write("<li>%s</li>\n" %  entry)
                          output.write("</ul></td>")
                        # Otherwise, write it out as is
                        else:
                          output.write("<td>%s</td>\n" %  reqSummary[idx])
                    output.write("</tr>\n")
            else:
                logging.info("Ajax source file: %s" % ajaxSrc)
                """ Write out the data file in JSON format """
                outJson = {"aaData": []}
                with open(os.path.join(outDir, ajaxSrc), 'w') as ajaxOut:
                    outArray =  outJson["aaData"]
                    for reqSummary in inputJson:
                        outArray.append(reqSummary)
                    json.dump(outJson, ajaxOut)
            output.write("</tbody>\n")
            output.write("</table>\n")
            output.write("</div>\n")
            output.write("</div>\n")
            output.write ("</body></html>\n")

    def _generateRequirementsSummaryPage(self, inputJson):
        for key in inputJson.keys():
          self._generateRequirementsSummaryPageImpl(inputJson, 'Requirement List', key, False)
          for bffEntry in inputJson[key]:
            self._generateIndividualRequirementsPage(bffEntry)
        self._generateRequirementsSummaryPageImpl(allReqs, 'Requirement List', "All", True)
if __name__ == '__main__':
    parser = createArgParser()
    result = parser.parse_args()
    initConsoleLogging()
    # pprint.pprint(set(crossRef.getAllPackages().keys()))
    # initConsoleLogging(logging.DEBUG)
    if result.reqJsonFile:
      requirementConverter = RequirementsConverter(result.outDir)
      requirementConverter.convertJsonToHtml(result.reqJsonFile)
