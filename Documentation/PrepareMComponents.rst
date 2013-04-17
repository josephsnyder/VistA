Prepare M source for Import into instance
=========================================

.. role:: usertype
    :class: usertype

Within the VistA-FOIA source tree, there is a Packages folder which contains all of the VistA-FOIA M components divided by package name.
Inside each package directory lies a 'Routines' directory and a 'Globals' directory.  The 'Routines' directory contains the routines, while
the latter contains globals divided into the FileMan files they contain.

We have written a python file, found in the VistA Scripts directory, which will create the two necessary files that will be
used to perform the actual import process.  The required arguments are a list of the full path to directories that contain M components files.
During the execution, these directories, and all subdirectories below them, will be searched for components to pack. The script
has some optional tags which can introduce some other behavior:

  ========================   =======================================
            Tag                            Description
  ========================   =======================================
            -h                  Displays the help text for the file

            -o                 Sets directory that the output files
                               will be saved to

            -r                 The path that the paths in the
                               globals.lst will share as a common
                               root.  This path will be needed later
                               if the option is used.

  ========================   =======================================

An example usage follows

.. parsed-literal::

  VistA$ :usertype:`python Scripts/PrepareMComponentsForImport.py "C:/path-to/VistA-FOIA" "C:/path-to/VistA/Scripts"`

The script will find all files in the VistA-FOIA that have the extension \'.m\' and passes those names to the python script PackRO.py to
pack them into file routine.ro.  It will also find two OSEHRA specific routines ZGI and ZGO which are used to import and export globals.
These routines are found in the VistA/Scripts directory.  The scripts last step is to find all files that have the extension \'.zwr\' and
write the file location of those globals in a file called 'globals.lst'.
This 'globals.lst' will be read by the OSEHRA ZGI routine during a later import step.
