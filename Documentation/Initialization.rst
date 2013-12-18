VistA Initialization
=========================
.. role:: usertype
    :class: usertype

The OSEHRA testing harness has a `python file`_ that will perform a large
amount of VistA work to initalize the instance as a normal hospital.  It
starts Taskman, an RPC Listener, and adds doctors, nurses and a patient.

The file is configured during the TEST_VISTA_FRESH option_ and can be
executed with the following command from the VistA Binary Dir:

.. parsed-literal::
  user\@machine VistA-build/$ :usertype:`python Testing/Setup/PostImportSetupScript.py`

It is highly recommended that you use this script to set up a test instance,
In the event that it cannot be run, this page will go over the setup steps
which will allow you to connect CPRS to the VistA instance and start the Task
Manager.


Edit NULL Device
-------------------
The CPRS GUI utilizes the VistA NULL device during its connection.  The
default $I of the device after the FOIA process, "NLA0", causes an error to be
thrown when trying to connect.  This needs to be changed via FileMan to a new
path to avoid the error.  The Sign-On capability also needs to be removed from
the device.

The commands to do this in the PostImportSetupScript can be found under the
comment that reads:

"Ensure that the null device is correctly configured."

On Windows
************

On Windows machines, the $I value should be set to "//./nul"

.. parsed-literal::
 VISTA> :usertype:`S DUZ=1 D Q^DI`


 VA FileMan 22.0


 Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES



 INPUT TO WHAT FILE: DEVICE// :usertype:`DEVICE`       (52 entries)
 EDIT WHICH FIELD: ALL// :usertype:`$I`
 THEN EDIT FIELD: :usertype:`SIGN-ON/SYSTEM DEVICE`
 THEN EDIT FIELD:


 Select DEVICE NAME: :usertype:`NULL`
     1   NULL      NT SYSTEM     NLA0:
     2   NULL  GTM-UNIX-NULL    Bit Bucket (GT.M-Unix)     /dev/null
     3   NULL-DSM      Bit Bucket     _NLA0:
 CHOOSE 1-3: :usertype:`1` NULL    NT SYSTEM     NLA0:
 $I: NLA0:// :usertype:`//./nul`
 SIGN-ON/SYSTEM DEVICE: YES// :usertype:`NO`  NO


 Select DEVICE NAME: :usertype:`<enter>`

 Select OPTION: :usertype:`<enter>`

 VISTA>


On Linux
***********

On Linux machines, the $I value should be set to "/dev/null"

.. parsed-literal::
 VISTA> :usertype:`S DUZ=1 D Q^DI`


 VA FileMan 22.0

 Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES



 INPUT TO WHAT FILE: DEVICE// :usertype:`DEVICE`
 EDIT WHICH FIELD: ALL// :usertype:`$I`
 THEN EDIT FIELD: :usertype:`SIGN-ON/SYSTEM DEVICE`
 THEN EDIT FIELD:


 Select DEVICE NAME: :usertype:`NULL`
     1   NULL      NT SYSTEM     NLA0:
     2   NULL  GTM-UNIX-NULL    Bit Bucket (GT.M-Unix)     /dev/null
     3   NULL-DSM      Bit Bucket     _NLA0:
 CHOOSE 1-3: :usertype:`1` NULL    NT SYSTEM     NLA0:
 $I: NLA0:// :usertype:`/dev/null`          This $I in use by other Devices.
 SIGN-ON/SYSTEM DEVICE: NO// :usertype:`N`  NO


 Select DEVICE NAME: :usertype:`<enter>`

 Select OPTION: :usertype:`<enter>`

 VISTA>


Set up a Domain
----------------
Next, a domain should be set up for the VistA instance.  A domain name is
typically used to uniquely identify an instance on a network.  While this
is not necessary to do for test instances, it is recommended that a new domain
be added.  The OSEHRA script adds a domain called "DEMO.OSEHRA.ORG", and the
commands can be found under the comment that reads:

"Create and Christen the New Domain"

Those commands will utilize an extra call to "CHRISTEN^XMUDCHR", which is not
necessary for a CPRS connection.

First we add the entry to the DOMAIN file through FileMan

.. parsed-literal::
  VISTA> :usertype:`S DUZ=1 D Q^DI`


  VA FileMan 22.0


  Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES



  INPUT TO WHAT FILE: // :usertype:`DOMAIN`
                                         (70 entries)
  EDIT WHICH FIELD: ALL// :usertype:`ALL`


  Select DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
    Are you adding 'DEMO.OSEHRA.ORG' as a new DOMAIN (the 71ST)? No// :usertype:`Y`  (Yes)
  FLAGS: :usertype:`^`

  Select DOMAIN NAME: :usertype:`<enter>`

  Select OPTION: :usertype:`<enter>`
  VISTA>

The next step is to find the IEN of the newly created domain. This can be done
by inquiring about the entry using FileMan and printing the Record Number:

.. parsed-literal::
  VISTA> :usertype:`S DUZ=1 D Q^DI`


  VA FileMan 22.0


  Select OPTION: :usertype:`5`  INQUIRE TO FILE ENTRIES



  OUTPUT FROM WHAT FILE: DOMAIN// :usertype:`DOMAIN`   (71 entries)
  Select DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
  ANOTHER ONE:
  STANDARD CAPTIONED OUTPUT? Yes// :usertype:`Y`  (Yes)
  Include COMPUTED fields:  (N/Y/R/B): NO// :usertype:`Record Number (IEN)`

  NUMBER: 76                              NAME: DEMO.OSEHRA.ORG

  Select DOMAIN NAME: :usertype:`^`




 Select OPTION: :usertype:`^`
 VISTA>


Then we propogate that entry to the Kernel System Parameters and
RPC Broker Site Parameters files.  The value that is being set should
be the same as the "NUMBER" value from the above result.

.. parsed-literal::
  VISTA> :usertype:`S $P(^XWB(8994.1,1,0),"^")=76`
  VISTA> :usertype:`S $P(^XTV(8989.3,1,0),"^")=76`

Once that is done, those two files need to be re-indexed through FileMan.

.. parsed-literal::
 VISTA> :usertype:`D Q^DI`


 VA FileMan 22.0


 Select OPTION: :usertype:`UTILITY FUNCTIONS`
 Select UTILITY OPTION: :usertype:`RE-INDEX FILE`

 MODIFY WHAT FILE: RPC BROKER SITE PARAMETERS// :usertype:`8994.1`  RPC BROKER SITE PARAMETERS
                                         (1 entry)

 THERE ARE 5 INDICES WITHIN THIS FILE
 DO YOU WISH TO RE-CROSS-REFERENCE ONE PARTICULAR INDEX? No// :usertype:`No`  (No)
 OK, ARE YOU SURE YOU WANT TO KILL OFF THE EXISTING 5 INDICES? No// :usertype:`Y`  (Yes)
 DO YOU THEN WANT TO 'RE-CROSS-REFERENCE'? Yes// :usertype:`Y`  (Yes)
 ...SORRY, LET ME THINK ABOUT THAT A MOMENT...
 FILE WILL NOW BE 'RE-CROSS-REFERENCED'......


 Select UTILITY OPTION: :usertype:`RE-INDEX FILE`

 MODIFY WHAT FILE: RPC BROKER SITE PARAMETERS// :usertype:`8989.3`  KERNEL SYSTEM PARAMETERS
                                         (1 entry)
 THERE ARE 14 INDICES WITHIN THIS FILE
 DO YOU WISH TO RE-CROSS-REFERENCE ONE PARTICULAR INDEX? No// :usertype:`N`  (No)
 OK, ARE YOU SURE YOU WANT TO KILL OFF THE EXISTING 14 INDICES? No// :usertype:`Y`  (Yes)
 DO YOU THEN WANT TO 'RE-CROSS-REFERENCE'? Yes// :usertype:`Y` (Yes)
 ...HMMM, THIS MAY TAKE A FEW MOMENTS...
 FILE WILL NOW BE 'RE-CROSS-REFERENCED'.................


 Select UTILITY OPTION: :usertype:`<enter>`

 Select OPTION: :usertype:`<enter>`

 VISTA>



Start TaskMan
------------------------
The Task Manager is an integral part of a running VistA instance.
The section of the PostImportSetupScript.py that runs this setup can be found
under the

"Start TaskMan"

comment.  The steps for starting TaskMan are not found in the first "if"
statement, but after it.   The script follows a path through a few
different menus, while the text below will go directly to the menu that you
need to visit.

.. parsed-literal::
  VISTA> :usertype:`S DUZ=1 D ^XUP`

  Setting up programmer environment
  This is a TEST account.

  Terminal Type set to: C-VT220

  You have 2914 new messages.
  Select OPTION NAME: :usertype:`TASKMAN MANAGEMENT UTILITIES`  XUTM UTIL     Taskman Manageme
  nt Utilities


   MTM    Monitor Taskman
          Check Taskman's Environment
          Edit Taskman Parameters ...
          Restart Task Manager
          Place Taskman in a WAIT State
          Remove Taskman from WAIT State
          Stop Task Manager
          Taskman Error Log ...
          Clean Task File
          Problem Device Clear
          Problem Device report.
          SYNC flag file control


  You've got PRIORITY mail!


  Select Taskman Management Utilities <TEST ACCOUNT> Option: :usertype:`Restart Task Manager`
  ARE YOU SURE YOU WANT TO RESTART TASKMAN? NO// :usertype:`Y`  (YES)
  Restarting...TaskMan restarted!


   MTM    Monitor Taskman
          Check Taskman's Environment
          Edit Taskman Parameters ...
          Restart Task Manager
          Place Taskman in a WAIT State
          Remove Taskman from WAIT State
          Stop Task Manager
          Taskman Error Log ...
          Clean Task File<F5>
          Problem Device Clear
          Problem Device report.
          SYNC flag file control


  You've got PRIORITY mail!

  Select Taskman Management Utilities <TEST ACCOUNT> Option: :usertype:`^`

Set BOX:VOLUME pair
------------------------
Setting up the proper BOX:VOLUME pair is very important in getting CPRS to
connect to VistA.  The first step is to find the box volume pair for the
local machine

.. parsed-literal::
  VISTA> :usertype:`D GETENV^%ZOSV W Y`

which will print out a message with four parts separated by "^" that could
look something like:

.. parsed-literal::
  VISTA^VISTA^palaven^VISTA:CACHE

The BOX:VOLUME pair is the final piece of that string and contains two bits of
information. The first piece is the Volume Set, which is used to determine
where the VistA system will be able to find the routines.


The second bit of info is the BOX, which references the system that the
instance is on. In a Cache system, it would be the name of the Cache
instance while on GT.M, it should reference the hostname of the machine.

The Volume Set result needs to be altered in the VOLUME SET file (`#14.5`_),
and we will reuse some setup by writing over the name of the first entry that
is already in the VistA system.  We select the first one with the notation

"\`1", to select the item with the record number of 1.

Then we rename the first BOX:VOLUME pair in the TaskMan site parameters
(`#14.7`_) to match what was found above.

For this demonstration instance, the Volume Set will be VISTA.

The commands can be found in the PostImportSetupScript after the

"Set up the proper Box:Volume pair"

comment.

.. parsed-literal::
  VISTA> :usertype:`S DUZ=1 D Q^DI`


  VA FileMan 22.0


  Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES

  INPUT TO WHAT FILE: DEVICE// :usertype:`14.5`  VOLUME SET  (1 entry)
  EDIT WHICH FIELD: ALL// :usertype:`VOLUME SET`
  THEN EDIT FIELD: :usertype:`TASKMAN FILES UCI`
  THEN EDIT FIELD: :usertype:`<enter>`


  Select VOLUME SET: :usertype:`\`1`  PLA
  VOLUME SET: PLA// :usertype:`VISTA`
  TASKMAN FILES UCI: PLA// :usertype:`VISTA`


  Select VOLUME SET: :usertype:`<enter>`


  INPUT TO WHAT FILE: TASKMAN SITE PARAMETERS// :usertype:`14.7`  TASKMAN SITE PARAMETERS
                                          (1 entry)
  EDIT WHICH FIELD: ALL// :usertype:`<enter>`


  Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR: :usertype:`\`1`  PLA:PLAISCSVR
  BOX-VOLUME PAIR: PLA:PLAISCSVR// :usertype:`VISTA:CACHE`
  RESERVED: :usertype:`^`


  Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR: :usertype:`<enter>`
  Select OPTION: :usertype:`<enter>`


The final steps are to edit entries in the RPC Broker Site Parameters file
and the Kernel System Parameters file.  The RPC Broker steps will set up
information that references both the the Port that the listener will run on and
the BOX:VOLUME pair of the instance.

The final questions of this section asks if the listener should be started
and then if it should be controlled by the Listener starter.

The answer to these questions is dependent on the MUMPS platform that is in
use:

On Cache
************
Cache systems are free to start the listener from this point and allow the
Listener Starter to control it.

.. parsed-literal::
 VISTA> :usertype:`S DUZ=1 D Q^DI`


 VA FileMan 22.0


 Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES

 INPUT TO WHAT FILE: VOLUME SET// :usertype:`8994.1`  RPC BROKER SITE PARAMETERS
                                         (1 entry)
 EDIT WHICH FIELD: ALL// :usertype:`LISTENER`    (multiple)
    EDIT WHICH LISTENER SUB-FIELD: ALL// :usertype:`<enter>`
 THEN EDIT FIELD: :usertype:`<enter>`


 Select RPC BROKER SITE PARAMETERS DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
         ...OK? Yes// :usertype:`Y`   (Yes)

 Select BOX-VOLUME PAIR: // :usertype:`VISTA:CACHE`
  BOX-VOLUME PAIR: VISTA:CACHE//
  Select PORT: :usertype:`9210`
  Are you adding '9210' as a new PORT (the 1ST for this LISTENER)? No// :usertype:`Y`  (Yes)
    TYPE OF LISTENER: :usertype:`1`  New Style
    STATUS: STOPPED// :usertype:`1` START
          Task: RPC Broker Listener START on VISTA-VISTA:CACHE, port 9210
          has been queued as task 1023
    CONTROLLED BY LISTENER STARTER: :usertype:`1`  YES

 Select RPC BROKER SITE PARAMETERS DOMAIN NAME: :usertype:`<enter>`

On GT.M
************

Since GT.M systems do not use the Listener as Cache systems, we will answer
"No" or "0" to both of those questions.  More information on setting up the
listener for GT.M will follow.

.. parsed-literal::
 VISTA> :usertype:`S DUZ=1 D Q^DI`


 VA FileMan 22.0


 Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES


 INPUT TO WHAT FILE: VOLUME SET// :usertype:`8994.1`  RPC BROKER SITE PARAMETERS
                                         (1 entry)
 EDIT WHICH FIELD: ALL// :usertype:`LISTENER`    (multiple)
    EDIT WHICH LISTENER SUB-FIELD: ALL// :usertype:`<enter>`
 THEN EDIT FIELD: :usertype:`<enter>`


 Select RPC BROKER SITE PARAMETERS DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
         ...OK? Yes// :usertype:`Y`   (Yes)

 Select BOX-VOLUME PAIR: // :usertype:`VISTA:CACHE`
  BOX-VOLUME PAIR: VISTA:CACHE//
  Select PORT: :usertype:`9210`
  Are you adding '9210' as a new PORT (the 1ST for this LISTENER)? No// :usertype:`Y`  (Yes)
    TYPE OF LISTENER: :usertype:`1`  New Style
    STATUS: STOPPED// :usertype:`<enter>`
    CONTROLLED BY LISTENER STARTER: :usertype:`0`  No

 Select RPC BROKER SITE PARAMETERS DOMAIN NAME: :usertype:`<enter>`

Next, Edit the Kernel System Parameters to add the new Volume Set to the
DEMO.OSEHRA.ORG domain and set some constraints about signing on.

.. parsed-literal::
 Select OPTION: :usertype:`1`  ENTER OR EDIT FILE ENTRIES



 INPUT TO WHAT FILE: RPC BROKER SITE PARAMETERS// :usertype:`KERNEL SYSTEM PARAMETERS`
                                          (1 entry)
 EDIT WHICH FIELD: ALL// :usertype:`VOLUME SET`    (multiple)
   EDIT WHICH VOLUME SET SUB-FIELD: ALL// :usertype:`<enter>`
 THEN EDIT FIELD: :usertype:`<enter>`


 Select KERNEL SYSTEM PARAMETERS DOMAIN NAME: :usertype:`DEMO.OSEHRA.ORG`
         ...OK? Yes// :usertype:`Y` (Yes)

 Select VOLUME SET: PLA// :usertype:`VISTA`
  Are you adding 'VISTA' as a new VOLUME SET (the 2ND for this KERNEL SYSTEM PARAMETERS)? No// :usertype:`Y`
  (Yes)
  MAX SIGNON ALLOWED: :usertype:`500`
  LOG SYSTEM RT?: :usertype:`N`  NO
 Select VOLUME SET: :usertype:`<enter>`


 Select KERNEL SYSTEM PARAMETERS DOMAIN NAME: :usertype:`<enter>`




 Select OPTION: :usertype:`<enter>`

Start TCP Listener
------------------------
The first thing that is needed to connect CPRS to a VistA instance is a
TCP Listener for the GUI to connect to.

For Cache
***********

The PostImportSetupScript on Windows will start a TCP Listener for CPRS to
connect to using the Listener Starter and TaskMan. The steps above will
have created a TaskMan entry to start a listener.

The PostImportSetupScript commands can be found under the same header as the
TaskMan steps:

"Start TaskMan"

The commands for the Listener setup ARE found in the first "if" statement.


If the instance or machine is restarted, the Listener will need to be restarted
as well.  There is simple command that will perform the same task which doesn't
require the Listener Starter or TaskMan.  It takes a single argument: a port
number to start the Listener on.  This port number should be the same as what
was set in the RPC Broker Site Parameters file in the previous step.

.. parsed-literal::
  VISTA> :usertype:`D STRT^XWBTCP(9210)`
  Start TCP Listener...
  Checking if TCP Listener has started...
  TCP Listener started successfully.
  VISTA>

There will be a different message if there is already a listener on that port:

.. parsed-literal::
  VISTA>D STRT^XWBTCP(9210)
  Start TCP Listener...
  TCP Listener on port 9210 appears to be running already.

  VISTA>

For GT.M
**********

the process is a bit more complicated, but OSEHRA has a
`wiki page`_ which describes the process of the set up.


Add User
----------------

Another important step is to create a user that has access to the menus
that CPRS uses. The things to make sure that this new user has are

 * A menu option (Primary or Secondary) of "OR CPRS GUI CHART"
 * CPRS Tab Access
 * An ACCESS CODE
 * A VERIFY CODE
 * Service/Section (required for any user)

The adding of the user is done through the User Management menu in the XUP
menu system, which will ask for information in a series of promps then will
open a Screenman instance to complete the task.  The PostImportSetupScript file
adds a fair amount of information more.  The comment of

"Enter the Doctor Robert Alexander"

starts the section that shows an example of the commands needed to enter a
doctor user into the system.

The following steps will add a generic "CPRS,USER" person who will be able to
sign into CPRS and not much else.


.. parsed-literal::
  VISTA> :usertype:`S DUZ=1 D ^XUP`

  Setting up programmer environment
  This is a TEST account.

  Terminal Type set to: C-VT220

  Select OPTION NAME:  :usertype:`Systems Manager Menu`

  WARNING -- TASK MANAGER DOESN'T SEEM TO BE RUNNING!!!!




          Core Applications ...
          Device Management ...
          Menu Management ...
          Programmer Options ...
          Operations Management ...
          Spool Management ...
          Information Security Officer Menu ...
          Taskman Management ...
          User Management ...
          Application Utilities ...
          Capacity Planning ...
          HL7 Main Menu ...


  You have PENDING ALERTS
          Enter  "VA to jump to VIEW ALERTS option

  Select Systems Manager Menu <TEST ACCOUNT> Option: :usertype:`USER Management`


          Add a New User to the System
          Grant Access by Profile
          Edit an Existing User
          Deactivate a User
          Reactivate a User
          List users
          User Inquiry
          Switch Identities
          File Access Security ...
             \**> Out of order:  ACCESS DISABLED
          Clear Electronic signature code
          Electronic Signature Block Edit
          List Inactive Person Class Users
          Manage User File ...
          OAA Trainee Registration Menu ...
          Person Class Edit
          Reprint Access agreement letter


  You have PENDING ALERTS
          Enter  "VA to jump to VIEW ALERTS option

  Select User Management <TEST ACCOUNT> Option: :usertype:`ADD a New User to the System`
  Enter NEW PERSON's name (Family,Given Middle Suffix): :usertype:`CPRS,USER`
    Are you adding 'CPRS,USER' as a new NEW PERSON (the 56TH)? No// :usertype:`Y`  (Yes)
  Checking SOUNDEX for matches.
  No matches found.
  Now for the Identifiers.
  INITIAL: :usertype:`UC`
  SSN: :usertype:`000000002`
  SEX: :usertype:`M`  MALE
  NPI:

Once in the ScreenMan interface, you will need to set the necessary bits
of information mentioned above. Four pieces of information are able to be set
on the first page of the ScreenMan interface.  The arrows are for emphasis to
highlight where information needs to be entered and will not show up in the
terminal window.

To add an access or verify codes, you need to first answer "Y" to the
"Want to edit ..." questions, it will then prompt you to change the codes.

.. parsed-literal::
                             Edit an Existing User
 NAME: CPRS,USER                                                     Page 1 of 5
 _______________________________________________________________________________
    NAME... CPRS,USER                                   INITIAL: UC
     TITLE:                                           NICK NAME:
       SSN: 000000002                                       DOB:
    DEGREE:                                           MAIL CODE:
   DISUSER:                                     TERMINATION DATE:
   Termination Reason:

      ---> PRIMARY MENU OPTION:
  Select SECONDARY MENU OPTIONS:
 Want to edit ACCESS CODE (Y/N):   <---  FILE MANAGER ACCESS CODE:
 Want to edit VERIFY CODE (Y/N):   <---

               Select DIVISION:
          ---> SERVICE/SECTION:
 _______________________________________________________________________________
  Exit     Save     Next Page     Refresh

 Enter a command or '^' followed by a caption to jump to a specific field.


 COMMAND:                                     Press <PF1>H for help    Insert

The CPRS Tab Access cannot be set on that first page.
To change to other pages, hit the down arrow key until the cursor
reaches the COMMAND box.  Then type "N" and hit enter to display the next page.

The final bit of information is on the fourth page.
Underneath the CPRS TAB ACCESS header. set the name to be "COR" for
"Core Tab Access" and enter an effective date of today.

.. parsed-literal::
                             Edit an Existing User
 NAME: CPRS,USER                                                     Page 4 of 5
 _______________________________________________________________________________
 RESTRICT PATIENT SELECTION:        OE/RR LIST:

 CPRS TAB ACCESS:
   Name  Description                          Effective Date  Expiration Date
 ->








 _______________________________________________________________________________





 COMMAND:                                       Press <PF1>H for help

Once that is done, save and exit from the COMMAND box and then answer the final
questions regarding access letters, security keys and mail groups:

.. parsed-literal::
 Exit     Save     Next Page     Refresh

 Enter a command or '^' followed by a caption to jump to a specific field.


 COMMAND: :usertype:`E`                                     Press <PF1>H for help    Insert

 Print User Account Access Letter? :usertype:`NO`
 Do you wish to allocate security keys? NO// :usertype:`NO`
 Do you wish to add this user to mail groups? NO// :usertype:`NO`

 *<snip>*
 Select User Management <TEST ACCOUNT> Option: :usertype:`^<enter>`
 VISTA>


.. _`python file`: https://github.com/OSEHRA/VistA/blob/master/Testing/Setup/PostImportSetupScript.py.in
.. _option: SetupTestingEnvironment.rst
.. _`#14.5`: http://code.osehra.org/dox/Global_XiVaSVMoMTQuNQ==.html
.. _`#14.7`: http://code.osehra.org/dox/Global_XiVaSVMoMTQuNw==.html
.. _`wiki page`: http://wiki.osehra.org/pages/viewpage.action?pageId=3047628#Developmentenvironmentinstall%28OSEHRAVM%29-Configurexinetd
