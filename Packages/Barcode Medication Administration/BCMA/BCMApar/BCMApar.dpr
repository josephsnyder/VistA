program BCMApar;

uses
  Forms,
  Windows,
  Dialogs,
  SysUtils,
  BCMAParameters in 'BCMAParameters.pas' {frmBCMAParameters},
  Debug in 'Debug.pas' {frmDebug},
  FAboutDlg in 'FAboutDlg.pas' {AboutDlg},
  VHA_Objects in 'VHA_Objects.pas',
  InputQry in 'InputQry.pas' {frmInputQry},
  Instructor in 'Instructor.pas' {frmInstructor},
  BCMA_Startup in 'BCMA_Startup.pas',
  BCMA_ParObjects in 'BCMA_ParObjects.pas',
  BCMA_Util in 'BCMA_Util.pas',
  Splash in 'Splash.pas' {frmSplash},
  fZZ_EventLog in '..\ZZZ\fZZ_EventLog.pas' {frmEventLog},
  uZZ_DescribedItem in '..\ZZZ\uZZ_DescribedItem.pas',
  uZZ_RPCEvent in '..\ZZZ\uZZ_RPCEvent.pas',
  uZZ_ChangeLog in '..\ZZZ\uZZ_ChangeLog.pas',
  uZZ_VersionInfo in '..\ZZZ\uZZ_VersionInfo.pas',
  frmALMap in '..\BCMA_Common\frmALMap.pas' {frmALMapEdit},
  fZZ_DebugEdit in '..\ZZZ\fZZ_DebugEdit.pas' {frmDebugEdit},
  uCAS_UU in '..\BCMA_Common\uCAS_UU.pas',
  uCAS_ALUtils in '..\BCMA_Common\uCAS_ALUtils.pas',
  UUCode in '..\BCMA_Common\UUCode.pas';

var
  // hwndPrev: HWND;
  appTitle: string;
  pApplication: ^TApplication;

{$R *.RES}

begin
  FrmSplash := TFrmSplash.Create(Application);
  FrmSplash.Show;
  Application.Initialize;
  Application.Title := 'BCMA Site Parameters';
  Application.HelpFile := 'BCMApar.hlp';
  pApplication := @Application;
  appTitle := pApplication^.Title;

  //hwndPrev := FindWindow('TfrmMain', pChar(appTitle));
  CreateMutex(nil,false,PChar('BCMA SITE PARAMETER'));
  //if hwndPrev = 0 then
  if GetLastError()=ERROR_SUCCESS then
    begin
      try
        if BCMA_ApplicationInit(False) then
          begin
//            Application.HelpFile := 'C:\Projects\BCMAPar_SI_VMP\BCMApar.chm';
            Application.HelpFile := 'BCMApar.chm';
            Application.CreateForm(TfrmBCMAParameters, frmBCMAParameters);
  BytesAllocated := GetHeapStatus.TotalAllocated;

            repeat
              Application.ProcessMessages;
            until FrmSplash.CloseQuery;

            application.processmessages;
            FrmSplash.Release;
            FirstPass := True;
            if UserIsLoggedOn then Application.Run;
          end;
      finally
        BCMA_ApplicationQuit;
        frmBCMAParameters.Free;
      end;
    end
  else if (GetLastError()=ERROR_ALREADY_EXISTS) then
    begin
      Application.MessageBox(
        pChar('There is already one copy of ' + #13#13 + Application.Title + #13#13 + ' running on this machine!'),
        'Open Error', MB_OK);
      Application.Terminate;
    end
  else
    begin
      Application.MessageBox(
        pChar(SysErrorMessage(GetLastError())),
        'OpenError',MB_OK);
      Application.Terminate;
    end
end.

