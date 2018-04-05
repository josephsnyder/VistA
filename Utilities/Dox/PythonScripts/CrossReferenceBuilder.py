#!/usr/bin/env python

# A Python model to build CrossRefence Python Object Model based on input
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

import os
import argparse
from InitCrossReferenceGenerator import createInitialCrossRefGenArgParser
from InitCrossReferenceGenerator import parseCrossReferenceGeneratorArgs
from CallerGraphParser import parseAllCallGraphLog
from CallerGraphParser import createCallGraphLogAugumentParser
from DataDictionaryParser import parseDataDictionaryLogFile
from DataDictionaryParser import createDataDictionaryAugumentParser
from FileManDbCallParser import parseFileManDBJSONFile
from FileManDbCallParser import createFileManDBFileAugumentParser

def createCrossReferenceLogArgumentParser():
    initCrossRefParser = createInitialCrossRefGenArgParser()
    callLogArgParser = createCallGraphLogAugumentParser()
    dataDictLogArgParser = createDataDictionaryAugumentParser()
    filemanDBJsonArgParser = createFileManDBFileAugumentParser()
    parser = argparse.ArgumentParser(add_help=False,
                                     parents=[initCrossRefParser,
                                              callLogArgParser,
                                              dataDictLogArgParser,
                                              filemanDBJsonArgParser])
    return parser
class CrossReferenceBuilder(object):
    def __init__(self):
        pass
    def buildCrossReferenceWithArgs(self, arguments, pkgDepJson=None, icrJson=None,inputTemplateDeps=None,sortTemplateDeps=None,printTemplateDeps=None):
        return self.buildCrossReference(arguments.xindexLogDir,
                                        arguments.MRepositDir,
                                        arguments.patchRepositDir,
                                        arguments.fileSchemaDir,
                                        arguments.filemanDbJson,
                                        pkgDepJson,
                                        icrJson,
                                        arguments.outdir,
                                        inputTemplateDeps=inputTemplateDeps,sortTemplateDeps=sortTemplateDeps,printTemplateDeps=printTemplateDeps)
    def buildCrossReference(self, xindexLogDir, MRepositDir,
                            patchRepositDir, fileSchemaDir=None,
                            filemanDbJson=None, pkgDepJson=None, icrJson=None,outdir=None,
                            inputTemplateDeps=None,sortTemplateDeps=None,printTemplateDeps=None):

        crossRef = parseCrossReferenceGeneratorArgs(MRepositDir,
                                                    patchRepositDir)
        crossRef.outDir= outdir
        crossRef._inputTemplateDeps = inputTemplateDeps
        crossRef._sortTemplateDeps  = sortTemplateDeps
        crossRef._printTemplateDeps  = printTemplateDeps

        if fileSchemaDir:
            crossRef = parseDataDictionaryLogFile(crossRef,
                                       fileSchemaDir).getCrossReference()
        if xindexLogDir:
            crossRef = parseAllCallGraphLog(xindexLogDir,
                crossRef, icrJson).getCrossReference()
        if filemanDbJson:
            crossRef = parseFileManDBJSONFile(crossRef,
                                   filemanDbJson).getCrossReference()
        crossRef.generateAllPackageDependencies(pkgDepJson)
        return crossRef
    def buildCrossReferenceFromMongoDB(self):
        pass

def main():
    crossRefParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
          description='VistA Cross-Reference Builder',
          parents=[crossRefParse])
    parser.add_argument('-pj', '--pkgDepJson',
                        help='Output JSON file for package dependencies')
    parser.add_argument('-o', '--outdir', required=True,
                        help='Output Web Page directory')
    result = parser.parse_args()
    from LogManager import initConsoleLogging
    initConsoleLogging()
    crossRefBlder = CrossReferenceBuilder()
    crossRefBlder.buildCrossReferenceWithArgs(result, result.pkgDepJson)

"""
    main entry
"""
if __name__ == '__main__':
    main()
