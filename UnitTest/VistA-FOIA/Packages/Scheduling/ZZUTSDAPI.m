ZZUTSDAPI ;kitware/JNL - code for a unit test SDAPI tag;07/10/12  11:15
 ;;1.0;UNIT TEST;;JUL 10, 2012;Build 1
 ; makes it easy to run tests simply by running this routine and
 ; insures that XTMUNIT will be run only where it is present
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZUTSDAPI")
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
CHKRCODE   ; Unit test to test the return code of $$SDAPI^SDAMA301
 ;
 ;first case is invalid date/time format, this should just return -1
 S SDARRAY(1)=INVLDDT
 S SDARRAY("FLDS")="ALL"
 S SDARRAY(2)=TESTCID1
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 S ERRMSG="Expected rcode is -1"
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",115))'=0,"Expecting Error Code is 115")
 I RCODE K ^TMP($J,"SDAMA301")
 ;second case is invalid patient id -1, this should just return -1
 K SDARRAY
 S RCODE=0
 S SDARRAY(1)=TESTDRANG1
 S SDARRAY("FLDS")="ALL"
 S SDARRAY(4)=INVLDPID
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",115))'=0,"Expecting Error Code is 115")
 I RCODE K ^TMP($J,"SDAMA301")
 ;third case is invalid clinic id -1, this should just return -1
 K SDARRAY
 S RCODE=0
 S SDARRAY(1)=TESTDRANG1
 S SDARRAY("FLDS")="ALL"
 S SDARRAY(2)=INVLDCID
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKEQ^XTMUNIT(RCODE,-1,ERRMSG_" real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301",115))'=0,"Expecting Error Code is 115")
 I RCODE K ^TMP($J,"SDAMA301")
 Q
 ;fourth case is valid patient and valid clinic
 K SDARRAY
 S RCODE=0
 S SDARRAY(1)=TESTDRANG2
 S SDARRAY(2)=TESTCID1
 S SDARRAY(4)=TESTPID1
 S SDARRAY("FLD")="ALL"
 S RCODE=$$SDAPI^SDAMA301(.SDARRAY)
 D CHKEQ^XTMUNIT(RCODE,0,"Expected rcode 0, real: "_RCODE)
 D CHKTF^XTMUNIT($D(^TMP($J,"SDAMA301"))=0, "^TMP global should be empty")
 I RCODE K ^TMP($J,"SDAMA301")
XTROU ;
 ;;SDAMA301
 ;;ZZUTSDCOM
 ; Entry points for tests are specified as the third semi-colon piece,
 ; a description of what it tests is optional as the fourth semi-colon
 ; piece on a line. The first line without a third piece terminates the
 ; search for TAGs to be used as entry points
XTENT ;
 ;;CHKRCODE; unit test to check return code of $$SDAPI^SDAMA301
 Q
