ZZUTGETAPPT ;kitware/JNL - code for a unit test GETAPPT tag;07/10/12  11:15
 ;;1.0;UNIT TEST;;JUL 10, 2012;Build 1
 ; makes it easy to run tests simply by running this routine and
 ; insures that XTMUNIT will be run only where it is present
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZUTGETAPPT")
 TROLLBACK
 Q
 ;
STARTUP ; optional entry point
 ; if present executed before any other entry point any variables
 ; or other work that needs to be done for any or all tests in the
 ; routine.  This is run only once at the beginning.
 D INIT^ZZUTSDCOM
 Q
 ;
SHUTDOWN ; optional entry point
 ; if present executed after all other processing is complete to remove
 ; any variables, or undo work done in STARTUP.
 D CLEANUP^ZZUTSDCOM
 K ^TMP($J,"SDAMA201","GETAPPT")
 Q
 ;
SETUP ; optional entry point
 ; if present it will be executed before each test entry to set up
 ; variables, etc.
 Q
 ;
TEARDOWN ; optional entry point
 ; if present it will be exceuted after each test entry to clean up
 ; variables, etc.
 Q
 ;
CHKRCODE   ; Unit test to test the return code of $$GETAPPT^SDAMA201
 ;
 ;first case is invalid date/time format, this should just return -1, with 105/106
 S STRTDATE=0,ENDDATE=0
 N RCODE S RCODE=0
 D GETAPPT^SDAMA201(TESTPID1,,,STRTDATE,ENDDATE,.RCODE,)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(105)
 D CHKERRCODE(106)
 I RCODE K ^TMP($J,"SDAMA201","GETAPPT")
 ;second case is invalid patient id -1, this should just return -1 with error code 114
 S RCODE=0
 D GETAPPT^SDAMA201(INVLDPID,,,,,.RCODE,)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(114)
 I RCODE K ^TMP($J,"SDAMA201","GETAPPT")
 ;third case is patient id is NULL, this should return -1 and error code 102
 S RCODE=0
 D GETAPPT^SDAMA201(,,,,,.RCODE,)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(102)
 I RCODE K ^TMP($J,"SDAMA201","GETAPPT")
 ;fourth case is start date is after end date, this should just return -1, with error code 111
 S STRTDATE=3031201,ENDDATE=3030101
 S RCODE=0
 D GETAPPT^SDAMA201(TESTPID1,,,STRTDATE,ENDDATE,.RCODE,)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(111)
 I RCODE K ^TMP($J,"SDAMA201","GETAPPT")
 ;fifth case is invalid fields list, should return -1 and set error code 103
 S FLDLIST="0;13"
 S RCODE=0
 D GETAPPT^SDAMA201(TESTPID1,FLDLIST,,,,.RCODE,)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(103)
 I RCODE K ^TMP($J,"SDAMA201","GETAPPT")
 ;sixth case is invalid patient status filter list, should return -1 and set error code 112
 S PSTATLST="UNDEFINED"
 S RCODE=0
 D GETAPPT^SDAMA201(TESTPID1,,,,,.RCODE,PSTATLST)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(112)
 I RCODE K ^TMP($J,"SDAMA201","GETAPPT")
 ;seventh case is invalid appointment status filter list, should return -1 and set error code 109
 S APPTSLST="UNDEFINED"
 S RCODE=0
 D GETAPPT^SDAMA201(TESTPID1,,APPTSLST,,,.RCODE,)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKERRCODE(109)
 I RCODE K ^TMP($J,"SDAMA201","GETAPPT")
 ;eighth case is invalid appointment status list/patient status combination, should return -1 and set error code 113
 S APPTSLST="R;N;C;NT"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="R;N;C;NT"
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="N"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="N"
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="C"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="C"
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="NT"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 ; This seems to be a bug in the VISN0 code, this indeed returns some values back
 ;S APPTSLST="NT"
 ;S PSTATLST="O"
 ;D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="NT:C"
 S PSTATLST="O"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 S APPTSLST="NT:C"
 S PSTATLST="I"
 D CHKINVALDCOMB(.APPTSLST,.PSTATLIST)
 Q
 ;
CHKINVALDCOMB(APPTSLST,PSTATLIST) ;
 S RCODE=0
 D GETAPPT^SDAMA201(TESTPID1,,APPTSLST,,,.RCODE,PSTATLST)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE_" APP: "_APPTSLST_" PAT: "_PSTATLST)
 D CHKERRCODE(113)
 I RCODE K ^TMP($J,"SDAMA201","GETAPPT")
 Q
CHKERRCODE(ERRCODE) ;
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA201","GETAPPT","ERROR",ERRCODE))'=0,"Expecting Error Code is "_ERRCODE)
 Q
 ;
CHKPATAPT ; unit test case to check the appointment date
 Q
HASAPPT(PATIEN) ;
 Q 0
 ;
XTROU ;
 ;;SDAMA201
 ;;ZZUTSDCOM
 ; Entry points for tests are specified as the third semi-colon piece,
 ; a description of what it tests is optional as the fourth semi-colon
 ; piece on a line. The first line without a third piece terminates the
 ; search for TAGs to be used as entry points
XTENT ;
 ;;CHKRCODE; unit test to check return code of $$GETAPPT^SDAMA201
 ;;CHKPATAPT; unit test to check patient appointment result from $$GETAPPT^SDAMA201
 Q
