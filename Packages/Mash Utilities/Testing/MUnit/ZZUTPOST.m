ut01POST ;VEN-SMH/JLI - post install for M-Unit Test software ;08/23/14  09:52
 ;;0.1;MASH UTILITIES
 D RENAME
 N $ETRAP S $ETRAP="D ERROR^ZZUTPOST"
 ; Local Modification(OSEHRA/JPS):Comment out lines that run tests after renaming
 ; W !,"Running unit tests to confirm renaming of ut* to %ut*",!,"(5 failures and 1 error are intentional in these tests)",!
 ; D EN^%ut("%utt1")
 ; W !!,"Again, 5 failures and 1 error are intentional in these tests."
 ; End local modification
 Q
 ;
RENAME ;
 N %S,%D ; Source destination
 S U="^"
 ;
 ; Local Modification(OSEHRA/JPS):Only rename the test routines
 S %S="utt1^utt2^utt3^utt4^utt5^utt6^uttcovr"  ;ut^ut1^
 S %D="%utt1^%utt2^%utt3^%utt4^%utt5^%utt6^%uttcovr" ;%ut^%ut1^
 ; End local modification
 ;
MOVE ; rename % routines
 N %,X,Y,M
 F %=1:1:$L(%D,"^") D  D MES(M)
 . S M="",X=$P(%S,U,%) ; from
 . S Y=$P(%D,U,%) ; to
 . Q:X=""
 . S M="Routine: "_$J(X,8)
 . Q:Y=""  I $T(^@X)=""  S M=M_"  Missing" Q
 . S M=M_" Loaded, "
 . D COPY(X,Y)
 . S M=M_"Saved as "_$J(Y,8)
 ;
 QUIT  ; END
 ;
COPY(FROM,TO) ;
 N XVAL
 I +$SYSTEM=0 S XVAL="ZL @FROM ZS @TO" X XVAL QUIT
 I +$SYSTEM=47 DO  QUIT
 . S FROM=$$PATH(FROM)
 . S TO=$$PATH(TO,"WRITE")
 . N CMD S CMD="cp "_FROM_" "_TO
 . O "cp":(shell="/bin/sh":command=CMD:WRITEONLY)::"PIPE"
 . U "cp" C "cp"
 QUIT
 ;
PATH(ROUTINE,MODE) ; for GT.M return source file with path for a routine
 ;input: ROUTINE=Name of routine
 ;       MODE="READ" or "WRITE" defaults to READ
 ;output: Full filename
 ;
 S MODE=$G(MODE,"READ") ;set MODE to default value
 N FILE S FILE=$TR(ROUTINE,"%","_")_".m" ;convert rtn name to filename
 N ZRO S ZRO=$ZRO
 ;
 ; Get source routine
 N %ZR
 I MODE="READ" D SILENT^%RSEL(ROUTINE,"SRC") Q %ZR(ROUTINE)_FILE
 ;
 ; We are writing. Parse directories and get 1st routine directory
 N DIRS
 D PARSEZRO(.DIRS,ZRO)
 N PATH S PATH=$$ZRO1ST(.DIRS)
 ;
 QUIT PATH_FILE ;end of PATH return directory and filename
 ;
 ;
PARSEZRO(DIRS,ZRO) ; Parse $zroutines properly into an array
 N PIECE
 N I
 F I=1:1:$L(ZRO," ") S PIECE(I)=$P(ZRO," ",I)
 N CNT S CNT=1
 F I=0:0 S I=$O(PIECE(I)) Q:'I  D
 . S DIRS(CNT)=$G(DIRS(CNT))_PIECE(I)
 . I DIRS(CNT)["("&(DIRS(CNT)[")") S CNT=CNT+1 QUIT
 . I DIRS(CNT)'["("&(DIRS(CNT)'[")") S CNT=CNT+1 QUIT
 . S DIRS(CNT)=DIRS(CNT)_" " ; prep for next piece
 QUIT
 ;
ZRO1ST(DIRS) ; $$ Get first routine directory
 N OUT ; $$ return
 N %1 S %1=DIRS(1) ; 1st directory
 ; Parse with (...)
 I %1["(" DO
 . S OUT=$P(%1,"(",2)
 . I OUT[" " S OUT=$P(OUT," ")
 . E  S OUT=$P(OUT,")")
 ; no parens
 E  S OUT=%1
 ;
 ; Add trailing slash
 I $E(OUT,$L(OUT))'="/" S OUT=OUT_"/"
 QUIT OUT
 ;
MES(T,B) ;Write message.
 S B=$G(B)
 I $L($T(BMES^XPDUTL)) D BMES^XPDUTL(T):B,MES^XPDUTL(T):'B Q
 W:B ! W !,T
 Q
 ;
TEST ; @TEST - TESTING TESTING
 N ZR S ZR="o(p r) /var/abc(/var/abc/r/) /abc/def $gtm_dist/libgtmutl.so vista.so"
 N DIRS D PARSEZRO(.DIRS,ZR)
 N FIRSTDIR S FIRSTDIR=$$ZRO1ST(.DIRS)
 I FIRSTDIR'="p" S $EC=",U1,"
 ;
 N ZR S ZR="/var/abc(/var/abc/r/) o(p r) /abc/def $gtm_dist/libgtmutl.so vista.so"
 N DIRS D PARSEZRO(.DIRS,ZR)
 N FIRSTDIR S FIRSTDIR=$$ZRO1ST(.DIRS)
 I FIRSTDIR'="/var/abc/r/" S $EC=",U1,"
 ;
 N ZR S ZR="/abc/def /var/abc(/var/abc/r/) o(p r) $gtm_dist/libgtmutl.so vista.so"
 N DIRS D PARSEZRO(.DIRS,ZR)
 N FIRSTDIR S FIRSTDIR=$$ZRO1ST(.DIRS)
 I FIRSTDIR'="/abc/def" S $EC=",U1,"
 ;
 WRITE "All tests have successfully!",!
 QUIT
 ;
ERROR ; come here in case of error trying to run unit tests - checks whether renaming worked
 N X
 W !!,"*** An error occurred after renaming of routines to %ut."
 W !,"*** The renaming has been seen to fail on one type of Linux system."
 W !,"*** In this case, at the Linux command line copy each ut routine"
 W !,"*** (ut, ut1, utt1, utt2, utt3, utt4, utt5, utt6, and uttcovr)"
 W !,"*** to _ut (e.g., 'cp ut _ut', 'cp ut1 _ut1', etc. to 'cp uttcovr _uttcovr')."
 W !,"*** Then in GT.M use the command  'ZLINK %ut', then 'ZLINK %ut1', etc., these"
 W !,"*** may indicate an undefined local variable error, but continue doing it."
 W !,"*** When complete, use the M command 'DO ^%utt1' to run the unit tests on"
 W !,"*** the %ut and %ut1 routines to confirm they are working"
 R !!,"Press Enter to continue: ",X:$G(DTIME,300)
 Q
