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
import os
import sys
import subprocess
import re
import argparse
import difflib
from LoggerManager import logger, initConsoleLogging

""" Utilities Functions to wrap around git command functions via subprocess
    1. make sure git is accessible directly via command line,
       or git is in the %path% for windows or $PATH for Unix/Linux
"""

DEFAULT_GIT_HASH_LENGTH = 40 # default git hash length is 40

def getGitRepoRevisionHash(revision="HEAD", gitRepoDir=None):
  """
    Utility function to get the git hash based on a given git revision
    @revision: input revision, default is HEAD on the current branch
    @gitRepoDir: git repository directory, default is current directory.
    @return: return git hash if success, None otherwise
  """
  git_command_list = ["git", "rev-parse", "--verify", revision]
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  if not result:
    return None
  lines = output.split('\r\n')
  for line in lines:
    line = line.strip(' \r\n')
    if re.search('^[0-9a-f]+$', line):
      return line
  return None

def commitChange(commitMsgFile, gitRepoDir=None):
  """
    Utility function to commit the change in the current branch
    @commitMsgFile: input commit message file for commit
    @gitRepoDir: git repository directory, default is current directory.
    @return: return True if success, False otherwise
  """
  if not os.path.exists(commitMsgFile):
    return False
  git_command_list = ["git", "commit", "-F", commitMsgFile]
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  logger.info(output)
  return result

def addChangeSet(gitRepoDir=None, patternList=[]):
  """
    Utility function to add all the files changed to staging area
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only add all changes under that directory
    @patternList: a list of pattern for matching files.
                  need to escape wildcard character '*'
    @return: return True if success, False otherwise
  """
  git_command_list = ["git", "diff","--", "*.zwr"]
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  test = output.split("\n")
  outLineStack = []
  results = []
  """
    Attempts to check each global file for more than two lines of change
    This will prevent every global from being updated in each commit thanks to
    the date change written in by ZGO.

    This assumes the script will be run in the "Packages" directory, which necessitates the
    removal of the "Packages/" string from the filename
  """
  patternIncludeList = ["*.m"]
  currentFile=None
  skipNext=False
  for index, line in enumerate(test):
    print line
    if '.zwr' in line:
      print results
      if "OK" in results:
         patternIncludeList.append(currentFile)
      currentFile = line[6:].strip()
      results = []
      continue
    if line.startswith("-"):
      outLineStack.append(line)
    elif line.startswith("+"):
      if len(outLineStack):
        diffStack=[]
        out = difflib.ndiff(line[1:].split("^"), outLineStack[0][1:].split("^"))
        print out
        outList = '|'.join(out).split("|")
        print outList
        listlen = len(outList) - 1
        print "#######"
        if len(outList) > 2:
          for i,s in enumerate(outList):
            print s
            if i == listlen:
              results.append("OK")
            if i < listlen:
              if s[0]=="-":
                diffStack.append(s[2:])
              if s[0] == "+":
                if len(diffStack):
                  print "TRYING TO DIFF"
                  print s[2:]
                  print diffStack[0]
                  if re.search("[0-9]{7}(\.[0-9]{4,6})*",s[2:]) or re.search("[0-9]{7}(\.[0-9]{4,6})*",diffStack[0]):
                    break
                  if re.search("[0-9]{2}\-[A-Z]{3}\-[0-9]{4}",s[2:]) or re.search("[0-9]{2}\:[0-9]{2}\:[0-9]{2}",diffStack[0]) :
                    break
                  if re.search("[0-9]{2}:[0-9]{2}:[0-9]{2}",s[2:]) or re.search("[0-9]{2}\:[0-9]{2}\:[0-9]{2}",diffStack[0]) :
                    break
                  # Removes a specific global entry in DEVICE file which maintains a count of the times the device was opened
                  if re.search("%ZIS\([0-9]+,[0-9]+,5",s[2:]):
                    break
                  diffStack.pop(0)
          print "#########"
          outLineStack.pop(0)
      else:
        results.append("OK")
  print patternIncludeList
  sys.exit(0)
  """ Now add everything that can be found or was called for"""
  git_command_list = ["git", "add", "--"]
  totalIncludeList = patternList + patternIncludeList
  for file in totalIncludeList:
   git_command = git_command_list + [file.encode('string-escape')]
   result, output = _runGitCommand(git_command, gitRepoDir)
  logger.info(output)
  """ Add the untracked files through checking for "other" files and
  then add the list
  """
  git_command = ["git","ls-files","-o","--exclude-standard"]
  result, lsFilesOutput = _runGitCommand(git_command, gitRepoDir)
  git_command_list = ["git","add"]
  for file in lsFilesOutput.split("\n"):
    if len(file):
      git_command = git_command_list + [file.encode('string-escape')]
      result, output = _runGitCommand(git_command, gitRepoDir)
  return result

def switchBranch(branchName, gitRepoDir=None):
  """
    Utility function to switch to a different branch
    @branchName: the name of the branch to switch to
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only add all changes under that directory
    @return: return True if success, False otherwise
  """
  git_command_list = ["git", "checkout", branchName]
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  logger.info(output)
  return result

def getStatus(gitRepoDir=None, subDirPath=None):
  """
    Utility function to report git status on the directory
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only add all changes under that directory
    @subDirPath: report only the status for the subdirectory provided
    @return: return the status message
  """
  git_command_list = ["git", "status"]
  if subDirPath:
    git_command_list.extend(['--', subDirPath])
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  return output

def getCommitInfo(gitRepoDir=None, revision='HEAD'):
  """
    Utility function to retrieve commit information
    like date/time in Unix timestamp, title and hash
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only report info WRT to git repository
    @revision: the revision to retrieve info, default is HEAD
    @return: return commit info dictionary
  """
  delim = '\n'
  outfmtLst = ("%ct","%s","%H")
  git_command_list = ["git", "log"]
  fmtStr = "--format=%s" % delim.join(outfmtLst)
  git_command_list.extend([fmtStr, "-n1", revision])
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  if result:
    return dict(zip(outfmtLst, output.strip('\r\n').split(delim)))
  return None

def _runGitCommand(gitCmdList, workingDir):
  """
    Private Utility function to run git command in subprocess
    @gitCmdList: a list of git commands to run
    @workingDir: the working directory of the child process
    @return: return a tuple of (True, output) if success,
             (False, output) otherwise
  """
  output = None
  try:
    popen = subprocess.Popen(gitCmdList,
                             cwd=workingDir, # set child working directory
                             stdout=subprocess.PIPE)
    output = popen.communicate()[0]
    if popen.returncode != 0: # command error
      return (False, output)
    return (True, output)
  except OSError as ex:
    logger.error(ex)
  return (False, output)

def main():
  initConsoleLogging()
  addChangeSet("D:/Work/OSEHRA/VistA-M/Packages")
  pass

if __name__ == '__main__':
  main()
