program BCMA;
{
================================================================================
*	File:  BCMA.dpr
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 32 $  $Modtime: 7/20/99 4:53p $
*
*	Description:  This is the Project File for the application.
================================================================================

{%ToDo 'BCMA.todo'}

{%TogetherDiagram 'ModelSupport_BCMA\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Objects\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fPrint\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fEdtMedLogAdminSelect\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\WardStock\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fDateTimePicker\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fPRNMedLog\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fMedTherapyMedSelection\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fDspMemo\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\Instructor\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\MultipleDrugs\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\Report\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\mVitals\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_IV\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\InputQry\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\VHA_Objects\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fFractional\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fPrintPtSelect\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fScanWristband\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fCoverSheet\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\MedLog\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\FAboutDlg\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\oReport\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fEditMedLog\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fUnableToScan\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\Options\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fPtSelect\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\ReportRequest\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\uCCOW\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\uIVUtilities\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Util\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\MultipleOrderedDrugs\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\ScanIV\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Startup\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\MissingDose\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\stabSort\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fPtConfirmation\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\Splash\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fGivenMRRs\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\Debug\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Timeout\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\PRNEffectiveness\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_OrderMan\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Common\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\uFiveRights\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\oInterfaces\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\SelectReason\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\oCoverSheet\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\MultOrder\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA\default.txvpck'}
{%ToDo 'BCMA.todo'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Main\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Objects\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BCMA\BCMA_Common\default.txvpck'}
{%TogetherDiagram 'ModelSupport_BCMA\fLegend\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fSelectInjection\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fWitness\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_BCMA\fPrtClinicSel\default.txaPackage'}

uses
  SysUtils,
  Forms,
  Windows,
  Dialogs,
  SplVista,
  VHA_Objects in 'VHA_Objects.pas',
  BCMA_Common in 'BCMA_Common.pas',
  BCMA_Objects in 'BCMA_Objects.pas',
  BCMA_Main in 'BCMA_Main.pas' {frmMain},
  Debug in 'Debug.pas' {frmDebug},
  Report in 'Report.pas' {frmReport},
  ReportRequest in 'ReportRequest.pas' {frmReportRequest},
  FAboutDlg in 'FAboutDlg.pas' {AboutDlg},
  MultipleDrugs in 'MultipleDrugs.pas' {frmMultipleDrugs},
  PRNEffectiveness in 'PRNEffectiveness.pas' {frmPRNEffectiveness},
  MultOrder in 'MultOrder.pas' {frmMultOrder},
  MissingDose in 'MissingDose.pas' {frmMissingDose},
  Instructor in 'Instructor.pas' {frmInstructor},
  MultipleOrderedDrugs in 'MultipleOrderedDrugs.pas' {frmMultipleOrderedDrugs},
  MedLog in 'MedLog.pas' {frmMedLog},
  SelectReason in 'SelectReason.pas' {frmSelectReason},
  InputQry in 'InputQry.pas' {frmInputQry},
  BCMA_Startup in 'BCMA_Startup.pas',
  BCMA_Util in 'BCMA_Util.pas',
  Splash in 'Splash.pas' {frmSplash},
  BCMA_IV in 'BCMA_IV.pas' {fraIV: TFrame},
  WardStock in 'WardStock.pas' {frmWardStock},
  Options in 'Options.pas' {frmOptions},
  BCMA_OrderMan in 'BCMA_OrderMan.pas' {frmCPRSOrderManager},
  BCMA_Timeout in 'BCMA_Timeout.pas' {frmTimeOut},
  fPrint in 'fPrint.pas' {frmPrint},
  fFractional in 'fFractional.pas' {frmFractional},
  fPRNMedLog in 'fPRNMedLog.pas' {frmPRNMedLog},
  uIVUtilities in 'uIVUtilities.pas',
  uCCOW in 'uCCOW.pas',
  fPrintPtSelect in 'fPrintPtSelect.pas' {frmPrintPtSelect},
  fPtConfirmation in 'fPtConfirmation.pas' {frmPtConfirmation},
  fEdtMedLogAdminSelect in 'fEdtMedLogAdminSelect.pas' {frmEditMedLogAdminSelect},
  fEditMedLog in 'fEditMedLog.pas' {frmEditMedLog},
  fDateTimePicker in 'fDateTimePicker.pas' {frmDateTimePicker},
  fCoverSheet in 'fCoverSheet.pas' {frmCoverSheet},
  oCoverSheet in 'oCoverSheet.pas',
  oInterfaces in 'oInterfaces.pas',
  stabSort in 'stabSort.pas',
  fGivenMRRs in 'fGivenMRRs.pas' {frmGivenMRRs},
  fScanWristband in 'fScanWristband.pas' {frmScanWristband},
  fPtSelect in 'fPtSelect.pas' {frmPtSelect},
  fUnableToScan in 'fUnableToScan.pas' {frmUnableToScan},
  fMedTherapyMedSelection in 'fMedTherapyMedSelection.pas' {frmMedTherapyMedSelection},
  oReport in 'oReport.pas',
  uFiveRights in 'uFiveRights.pas' {frmFiveRights},
  fDspMemo in 'fDspMemo.pas' {frmDspMemo},
  fLegend in 'fLegend.pas' {frmLegend},
  ScanIV in 'ScanIV.pas' {frmScanIV},
  fSelectInjection in 'fSelectInjection.pas' {frmSelectInjection},
  fWitness in 'fWitness.pas' {frmWitness},
  fPrtClinicSel in 'fPrtClinicSel.pas' {frmPrtClinicSel},
  BcmaOrderCom_TLB in 'c:\d2006\Imports\BcmaOrderCom_TLB.pas',
  uOrderMgr in 'uOrderMgr.pas',
  fZZ_EventLog in '..\ZZZ\fZZ_EventLog.pas' {frmEventLog},
  uZZ_DescribedItem in '..\ZZZ\uZZ_DescribedItem.pas',
  uZZ_RPCEvent in '..\ZZZ\uZZ_RPCEvent.pas',
  uZZ_ChangeLog in '..\ZZZ\uZZ_ChangeLog.pas',
  uZZ_VersionInfo in '..\ZZZ\uZZ_VersionInfo.pas',
  mVitals in 'mVitals.pas' {fraVitals: TFrame},
  fCAS_Log in 'CAS_DDPE\fCAS_Log.pas' {frmCAS_Log},
  uCASC_Log in 'CAS_DDPE\uCASC_Log.pas',
  frmALMap in '..\BCMA_Common\frmALMap.pas' {frmALMapEdit},
  uCAS_UU in '..\BCMA_Common\uCAS_UU.pas',
  uCAS_ALUtils in '..\BCMA_Common\uCAS_ALUtils.pas',
  fInfo in '..\ZZZ\fInfo.pas' {frmInfo},
  uCAS_Utils in '..\BCMA_Common\uCAS_Utils.pas';

const
  aTitle = 'Bar Code Medication Administration';

var
  appTitle: string;
  pApplication: ^TApplication;

{$R *.RES}

begin
  FrmSplash := TFrmSplash.Create(Application);
  // try
  FrmSplash.Show;
  Application.Initialize;
  Application.Title := 'Bar Code Medication Administration';
  pApplication := @Application;
  appTitle := pApplication^.Title;
  CreateMutex(nil, false, PChar('BCMA V2 GUI APP'));
  frmMain := nil;                       // rpk 6/11/2013

  if (GetLastError() = ERROR_SUCCESS) or
    ((GetLastError() = ERROR_ALREADY_EXISTS) and (AllowMultCopies)) then begin
    try
      if BCMA_ApplicationInit(True) then begin
        Application.HelpFile := 'BCMA.chm';
        Application.CreateForm(TfrmMain, frmMain);
        BytesAllocated := GetHeapStatus.TotalAllocated;

        repeat
          Application.ProcessMessages;
        until FrmSplash.CloseQuery;

        application.processmessages;
        FrmSplash.Release;
        FirstPass := True;
        if UserIsLoggedOn then
          Application.Run;
      end;
    finally
      BCMA_ApplicationQuit;
//      frmMain.Free;
    end;
  end
  else if (GetLastError() = ERROR_ALREADY_EXISTS) then begin
    Application.MessageBox(
      pChar('There is already one copy of ' + #13#13 + Application.Title + #13#13 +
      ' running on this machine!'), 'Open Error', MB_OK);
    Application.Terminate;
  end
  else begin
    Application.MessageBox(
      pChar(SysErrorMessage(GetLastError())), 'Open Error', MB_OK);
    Application.Terminate;
  end
  // finaly
  // frmsplash.free
  // end
end.

