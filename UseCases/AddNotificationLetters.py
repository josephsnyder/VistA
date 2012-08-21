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

from AddOneNotificationLetter import AddOneNotificationLetter

def AddNotificationLetters(VistA):
# predefined letter type 
#   APPOINTMENT CANCELLED
#   CLINIC CANCELLED
#   COPAY EXEMPTION TEST
#   MEANS TEST
#   NO-SHOW
#   PRE-APPOINTMENT

  AddOneNotificationLetter(VistA, "APPOINTMENT CANCELLED", "ZZAPPTCANCELLED",
                                  "SAMPLE APPOINTMENT CANCELLED LETTER", 
                                  "SINCERELY")
  AddOneNotificationLetter(VistA, "CLINIC CANCELLED", "ZZCLINICCANCELLED",
                                  "SAMPLE CLINIC CANCELLED LETTER", 
                                  "SINCERELY")
  AddOneNotificationLetter(VistA, "NO-SHOW", "ZZNOSHOW",
                                  "SAMPLE NO-SHOW LETTER", 
                                  "SINCERELY")
  AddOneNotificationLetter(VistA, "PRE-APPOINTMENT", "ZZPREAPPT",
                                  "SAMPLE PRE-APPOINTMENT LETTER", 
                                  "SINCERELY")

def AddNotificationLettersByConfig(VistA, lettersJson):
  for letter in lettersJson:
    AddOneNotificationLetter(VistA, letter['Type'],
                                    letter['Name'],
                                    letter['First Paragraph'],
                                    letter['Second Paragraph'])
