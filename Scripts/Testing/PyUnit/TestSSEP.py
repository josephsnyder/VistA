#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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
import socket
import sys,os
import unittest

def createAndConnect(host="127.0.0.1", port=9210):
  print "Connect to host %s, port %s" % (host, port)
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sock.connect((host, port))
  sock.setblocking(0) # non-blocking
  return sock

def sendDivGet(sock):
  inputfile = "divget.xml"
  sendRequestByFile(inputfile, sock)

def sendDivSet(sock):
  inputfile = "divset.xml"
  sendRequestByFile(inputfile, sock)

def sendGetUserInfo(sock):
  inputfile = "getuserinfo.xml"
  sendRequestByFile(inputfile, sock)

def sendIamHere(sock):
  inputfile = "im_here.xml"
  sendRequestByFile(inputfile, sock)

def sendGetPatientList(sock):
  inputfile = "getpatientlist.xml"
  sendRequestByFile(inputfile, sock)

def sendGetPatientVitals(sock):
  inputfile = "getpatientvitals.xml"
  sendRequestByFile(inputfile, sock)

def sendIntroMsgGet(sock):
  inputfile = "getintromessage.xml"
  sendRequestByFile(inputfile, sock)

def createORContext(sock):
  inputfile = "createorguichartcontext.xml"
  sendRequestByFile(inputfile,sock)

def createSignonContext(sock):
  inputfile = "createSignonContext.xml"
  sendRequestByFile(inputfile,sock)

def signInAlexander(sock):
  inputfile = "signonDr.xml"
  sendRequestByFile(inputfile,sock)

def signInClerk(sock):
  inputfile = "signonCl.xml"
  sendRequestByFile(inputfile,sock)

def sendRequestByFile(inputfile, sock):
  sock.settimeout(5)
  if os.path.dirname(__file__)+ "/" == "/":
    commandfile = inputfile
  else:
    commandfile = os.path.dirname(__file__)+ "/" + inputfile
  with open(commandfile,'r') as input:
    for line in input:
      sock.send(line)
  sock.send(chr(4))

def getResponse(sock, timeout=10):
  sock.settimeout(10)
  output = ""
  while True:
    data=sock.recv(256)
    if data:
      output = output + data
      if chr(4) in data:
        break
  return output

def runRPC(self,rpcfilename, signonName):
  if os.path.dirname(__file__)+ "/" == "/":
    resultsfile = rpcfilename.replace(".xml","_results.xml")
  else:
    resultsfile = os.path.dirname(__file__)+ "/" + rpcfilename.replace(".xml","_results.xml")
  correct_response = open(resultsfile,'r').read()
  sock = createSocket()
  createSignonContext(sock)
  getResponse(sock)
  if signonName == "dr":
    signInAlexander(sock)
    getResponse(sock)
    createORContext(sock)
    getResponse(sock)
  else:
    signInClerk(sock)
    getResponse(sock)
    print "blah"

  sendRequestByFile(rpcfilename,sock)
  response = getResponse(sock)
  print "Response from " + rpcfilename
  print response
  self.assertEquals(response[:-1],correct_response, msg= "Didn't find a correct response to '" + rpcfilename + "'" )
  sock.close()

def createSocket():
  sock = None
  sock = createAndConnect(results.host,int(results.port))
  return sock

class TestM2MBroker(unittest.TestCase):

  def test_IamHere_NoSignon(self):
    runRPC(self,"imhere.xml","cl")
  def test_IamHere_Signon(self):
    runRPC(self,"imhere.xml","dr")
  def test_GetIntroMessage_NoSignon(self):
    runRPC(self,"getintromessage.xml","dr")
  def test_GetPatientList_Signon(self):
    runRPC(self,"getpatientlist.xml","dr")
  def test_GetPatientList_NoSignon(self):
    runRPC(self,"patientlisterror.xml","cl")
  def test_GetPatientVitals_NoSignon(self):
    runRPC(self,"getpatientvitals.xml","cl")

def main():
  # Import Argparse and add Scripts/ directory to sys.path
  # by finding directory of current script and going up two levels
  import argparse
  curDir = os.path.dirname(os.path.abspath(__file__))
  scriptDir = os.path.normpath(os.path.join(curDir, "../../"))
  if scriptDir not in sys.path:
    sys.path.append(scriptDir)

  # OSEHRA Imports
  from RPCBrokerCheck import CheckRPCListener
  from VistATestClient import createTestClientArgParser,VistATestClientFactory

  # Arg Parser to get address and port of RPC Listener along with a log file
  # Inherits the connection arguments of the testClientParser

  testClientParser = createTestClientArgParser()
  ssepTestParser= argparse.ArgumentParser(description='Test the M2M broker via XML files',
                                           parents=[testClientParser])
  ssepTestParser.add_argument("-ha",required=True,dest='host',
                              help='Address of the host where RPC Broker is listening')
  ssepTestParser.add_argument("-hp",required=True,dest='port',
                              help='Port of the host machine where RPC Broker is listening')
  ssepTestParser.add_argument("-l",required=True,dest='log_file',
                              help='Path to a file to log the output.')

  # A global variable so that each test is able to use the port and address of the host
  global results
  results = ssepTestParser.parse_args()
  testClient = VistATestClientFactory.createVistATestClientWithArgs(results)
  assert testClient
  with testClient:
    # If checkresult == 0, RPC listener is set up correctly and tests should be run
    # else, don't bother running the tests
    testClient.setLogFile(results.log_file)
    checkresult = CheckRPCListener(testClient.getConnection(),results.host,results.port)
  if checkresult == 0:
    suite = unittest.TestLoader().loadTestsFromTestCase(TestM2MBroker)
    unittest.TextTestRunner(verbosity=2).run(suite)
  else:
    print "FAILED: The RPC listener is not set up as needed."

if __name__ == "__main__":
  main()
