/*!/usr/bin/env python
* A set of Javascript functions which will allow the DOX page to be downloaded
* as a PDF file
#---------------------------------------------------------------------------
* Copyright 2017 The Open Source Electronic Health Record Agent
#
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
#
*     http://www.apache.org/licenses/LICENSE-2.0
#
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

    function openAccordionVal(event) {
        ret = [].indexOf.call(event.path[1].children, event.target);
        $('#accordion' ).accordion( 'option', 'active', ret );
    }


    // Capture the DOX images as DataURL to be shown in the PDF
    function toDataUrl(file,callback) {
       var xhr = new XMLHttpRequest();
          xhr.onload = function() {
         var reader = new FileReader();
         reader.onloadend = function() {
          callback(reader.result);
       }
         reader.readAsDataURL(xhr.response);
      };
       if(typeof file != "undefined") {
         xhr.open('GET', file);
         xhr.responseType = 'blob';
         xhr.send();
       } else{
         callback("data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAABAAEDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9/KKKKAP/2Q==")
       }
       }
    // Get the data that should only be shown as text (Routine Headers and source links)
    function getText(pdfObj) {
      var rowObj = ["",""]
      var returnObj = []
      fullVals = $("."+pdfObj.tag).text()
      var docDefinitionAddition={text: fullVals}
      return [docDefinitionAddition]
    }
    // Get the data that contains an image (CallerGraphs and acompanying tables)
    function getImage(pdfObj) {
      if ((pdfObj.tag == "callG") || (pdfObj.tag == "callerG")) {
         tableVal = getTableListWithHeader(pdfObj)
      }
      else {
        tableVal = getTableList(pdfObj)
      }
      return [{image:pdfObj.tag,			width: 467}].concat(tableVal)
    }

    function getTableListWithHeader(pdfObj) {
      //Set outside
      var OrigObj=[]
      var sizeArray=[]
      for (i=0; i<pdfObj.numCols;i++) {
        OrigObj.push("");
        sizeArray.push(pdfObj.colSize)
      }
      var rowObj=OrigObj.slice()
      var returnObj = []
      tableRows = $("tr."+pdfObj.tag)
      for (numRow=0;numRow<tableRows.length; numRow++) {
          var tableObj = $(tableRows[numRow]).children()
          tableObj.each(function (child) {
            rowObj[child % pdfObj.numCols] = $(tableObj[child]).text()
          })
        if (i % pdfObj.numCols == 0 && i !=0) {
          returnObj.push(rowObj);
          rowObj = OrigObj.slice()
        }
      }
      if (returnObj.length == 0) {
          returnObj.push("")
      }
      var docDefinitionAddition =  {table: {
        headerRows: 1,
        widths:sizeArray,
        body: returnObj}, layout: {
            fillColor: function (i, node) { return (i % 2 === 0) ?  '#CCCCCC' : null; }
      }}
      return [docDefinitionAddition]
    }
    function getTableList(pdfObj) {
      var OrigObj=[]
      var sizeArray=[]
      for (i=0; i<pdfObj.numCols;i++) {
        OrigObj.push("");
        sizeArray.push(pdfObj.colSize)
      }

      var rowObj = OrigObj.slice()
      var returnObj = []

      fullVals = $("."+pdfObj.tag).text().split(pdfObj.sep)
      var i,j;
      for (i=0,j=fullVals.length; i<j; i++) {
            if (i % pdfObj.numCols == 0 && i !=0) {
              if(rowObj != OrigObj.slice()) {
                returnObj.push(rowObj);
                rowObj = OrigObj.slice()
              }
            }
            if(fullVals[i] != "") {
                 rowObj[i % pdfObj.numCols] = (fullVals[i])
            }
      }
      if (rowObj.length == 0) {
          rowObj.push("")
      }
      returnObj.push(rowObj)
      var docDefinitionAddition =  {table: {
        //headerRows: titleDic[test]["headerrow"],
        widths:sizeArray,
        body: returnObj},layout: {
            fillColor: function (i, node) { return (i % 2 === 0) ?  '#CCCCCC' : null; }
      }}
      return [docDefinitionAddition]
    }
    var titleDic  =  {
                      "Namespace": {"tag": "null","sep": /\s{3}/,"headerrow":0,"generator": getText,"numCols":0,"colSize":0},
                      "Doc": {"tag": "null","sep": /\s{3}/,"headerrow":0,"generator": getText,"numCols":0,"colSize":0},
                      "Dependency Graph": {"tag": "_dependency","sep": /\s{3}/,"headerrow":0,"generator": getImage,"numCols":7,"colSize":68},
                      "Dependent Graph":{"tag": "_dependent","sep": /\s{3}/,"headerrow":0,"generator": getImage,"numCols":7,"colSize":68},
                      "ICR Entries":{"tag": "icrVals","sep": /\s{4}/,"headerrow":0,"generator":getTableList,"numCols":7,"colSize":68},
                      "FileMan Files":{"tag": "fmFiles","sep": /\s{4}/,"headerrow":0,"generator":getTableList,"numCols":7,"colSize":68},
                      "Non-FileMan Globals":{"tag": "nonfmFiles","sep": /\s{4}/,"headerrow":0,"generator":getTableList,"numCols":7,"colSize":68},
                      "All Routines":{"tag": "rtns","sep": /\s{4}/,"headerrow":0,"generator":getTableList,"numCols":7,"colSize":68},
                      "Info":{"tag": "information","sep": /\s{4}/,"headerrow":0,"generator": getText,"numCols":0,"colSize":68},
                      "Desc":{"tag": "null","sep": /\s{4}/,"headerrow":0,"generator": getText,"numCols":0,"colSize":68},
                      "Directly Accessed By Routines":{"tag": "directCall","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":3,"colSize":68},
                      "Accessed By FileMan Db Calls":{"tag": "gblRtnDep","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":3,"colSize":68},
                      "Pointed To By FileMan Files":{"tag": "gblPointedTo","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":3,"colSize":68},
                      "Pointer To FileMan Files":{"tag": "gblPointerTo","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":3,"colSize":68},
                      "Fields":{"tag": "fmFields","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":5,"colSize":95},
                      "Source":{"tag": "null","sep": /\s{4}/,"headerrow":0,"generator": getText,"numCols":0,"colSize":68},
                      "Call Graph":{"tag": "callG","sep": /\s{2}/,"headerrow":0,"generator":getImage,"numCols":3,"colSize":158},
                      "Caller Graph":{"tag": "callerG","sep": /\s{2}/,"headerrow":0,"generator":getImage,"numCols":3,"colSize":158},
                      "Entry Points":{"tag": "null","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":3,"colSize":158},
                      "External References":{"tag": "external","sep": /\s{1}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":2,"colSize":238},
                      "Interaction Calls":{"tag": "null","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":2,"colSize":238},
                      "Used in HL7 Interface":{"tag": "hl7","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":3,"colSize":158},
                      "FileMan Files Accessed Via FileMan Db Call":{"tag": "dbcall","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":3,"colSize":158},
                      "Global Variables Directly Accessed":{"tag": "directAccess","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":2,"colSize":238},
                      "Label References":{"tag": "label","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":2,"colSize":238},
                      "Naked Globals":{"tag": "naked","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":2,"colSize":238},
                      "Local Variables":{"tag": "local","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":2,"colSize":238},
                      "Marked Items":{"tag": "marked","sep": /\s{4}/,"headerrow":0,"generator":getTableListWithHeader,"numCols":2,"colSize":238},
                     }
    function writePDF(event) {
      toDataUrl($("#img_called").attr("src"),function(callGraph) {
        toDataUrl($("#img_caller").attr("src"),function(callerGraph) {
          toDataUrl($("#package_dependencyGraph").attr("src"),function(dependencyVal) {
            toDataUrl($("#package_dependentGraph").attr("src"),function(dependentVal) {
              var docDefinition = {
                images : {
                },
                styles: {
                },
                content:[
                  {text:$("#pageTitle").html(), bold:true, fontSize:15} ,
                ]
              }
              titleList.forEach(function(test) {
                docDefinition.content.push({text:test, fontSize:15})
                docDefinition.content= docDefinition.content.concat(titleDic[test]["generator"](titleDic[test]))
              });
              docDefinition.images._dependent=dependentVal;
              docDefinition.images._dependency=dependencyVal;
              docDefinition.images.callG=callGraph;
              docDefinition.images.callerG=callerGraph;
              pdfMake.createPdf(docDefinition).download("testPDF.pdf")
            })
          })
        })
      })
    }
