import sys
sys.path = [sys.argv[7] + '/Python'] + sys.path

from OSEHRAHelper import ConnectToMUMPS,PROMPT

VistA=ConnectToMUMPS(sys.argv[1],sys.argv[3],sys.argv[4])
if (sys.argv[5] and sys.argv[6]):
  VistA.login(sys.argv[5],sys.argv[6])
if VistA.type=='cache':
  try:
    errorPrompt = '%s [0-9a-z]+>' % sys.argv[4]
    VistA.ZN(sys.argv[4])
  except IndexError,no_namechange:
    pass
VistA.wait(PROMPT)
VistA.write("W $J")
VistA.wait(PROMPT)
VistA.write('K ^XUTL("XQ",$J)')
VistA.wait(PROMPT)
VistA.write('D ^XINDEX')
if VistA.type == 'cache':
  index=VistA.multiwait(['No =>', errorPrompt])
  if index ==1:
    VistA.write('D ^ZTER')
    VistA.wait(errorPrompt)
    VistA.write('ZW IO')
    VistA.wait(errorPrompt)
    VistA.write('h')
    sys.exit(1)
  else:
    VistA.write('No')
arglist = sys.argv[2].split(',')
for routine in arglist:
  VistA.wait('Routine:')
  VistA.write(routine)
VistA.wait('Routine:')
VistA.write('')
selectionList = ['Select BUILD NAME:',
                 'Select INSTALL NAME:',
                 'Select PACKAGE NAME:']
while True:
  index = VistA.multiwait(selectionList)
  VistA.write('')
  if index == len(selectionList) - 1:
    break
VistA.wait('warnings?')
VistA.write('No')
VistA.wait('routines?')
VistA.write('NO')
VistA.wait('DEVICE:')
VistA.write(';;9999')
if sys.platform == 'win32':
  VistA.wait('Right Margin:')
  VistA.write('')
index = VistA.multiwait(['continue:','output QUEUED'])
while 1:
  if index==0:
    VistA.write('')
    break
  elif index == 1 and VistA.type == 'Cache':
    errorPrompt = '%s [0-9a-z]+>' % sys.argv[4]
    VistA.write('N')
    VistA.wait(errorPrompt)
    VistA.write('ZW IO')
    VistA.wait(PROMPT)
    VistA.write('h')
    sys.exit(1)
VistA.wait('--- END ---')
VistA.write('')
VistA.wait(PROMPT)
VistA.write('h')
