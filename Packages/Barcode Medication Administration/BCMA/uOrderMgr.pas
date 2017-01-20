unit uOrderMgr;

interface
uses
  BCMA_Util;

type
  TLoadMOBProc = procedure(aConnectParams: WideString; aRunParams: WideString;
    var aResult: longBool);

var
  MOBDLLHandle: THandle = 0;

const
//  SHARE_DIR = '\VISTA\Common Files\';
//  MOBDLLName = 'BCMAOrderCom.dll';
  MOBDLLName = 'BCMAOrderCom.dll';
  MOB2DLLName = 'OrderCom.dll';
  LoadMOBProc: TLoadMOBProc = nil;

procedure ShowOneStepAdmin;

implementation
uses
  BCMA_Main, oCoverSheet, oInterfaces, BCMA_Common, BCMA_Objects, BCMA_Startup,
  VHA_Objects,
//  MFunStr,
  TRpcb, Registry, Forms, Dialogs, SysUtils, Windows;

//procedure LoadMOBDLL; forward;

//procedure UnloadMOBDLL; forward;


{ function DllVersionCheck(DllName: string; DLLVersion: string): string;
var
  tbool: Boolean;
begin
  Result := '';
//  Result := sCallV('ORUTL4 DLL', [DllName, DllVersion]);
  with BCMA_Broker do begin
    tbool := CallServer('ORUTL4 DLL', [DllName, DllVersion], nil);
    if tbool then
      if Results.Count > 0 then Result := Results[0] else Result := '';
  end;

end; }

{ function ProgramFilesDir: string;
var
  Registry: TRegistry;
begin
  Result := '';
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion');
//    if (TOSVersion.Architecture = arIntelX64) then begin
    Result := Registry.ReadString('ProgramFilesDir (x86)');
//    end else begin
//      Result := Registry.ReadString('ProgramFilesDir');
//    end;
    Registry.CloseKey;
    Result := IncludeTrailingPathDelimiter(Result);
  finally
    Registry.Free;
  end;
end; }

{ function ApplicationDirectory: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName));
end; }

{ function VistaCommonFilesDirectory: string;
begin
  Result := ProgramFilesDir + 'Vista\Common Files\';
end; }

{ function DropADir(DirName: string): string;
var
  i: integer;
begin
  Result := DirName;
  i := Length(Result) - 1;
  while (i > 0) and (Result[i] <> '\') do dec(i);
  if (i = 0) then
    Result := ''
  else
    Result := IncludeTrailingPathDelimiter(copy(Result, 1, i));
end; }

{ function RelativeCommonFilesDirectory: string;
begin
  Result := DropADir(ApplicationDirectory) + 'Common Files\';
end; }

{ function FindDllDir(DllName: string): string;
begin
  if FileExists(ApplicationDirectory + DllName) then begin
    Result := ApplicationDirectory + DllName;
  end else if FileExists(RelativeCommonFilesDirectory + DllName) then begin
    Result := RelativeCommonFilesDirectory + DllName;
  end else if FileExists(VistaCommonFilesDirectory + DllName) then begin
    Result := VistaCommonFilesDirectory + DllName;
  end else begin
    Result := '';
  end;

end; }

{ function ClientVersion(const AFileName: string): string;
var
  ASize, AHandle: DWORD;
  Buf: string;
  FileInfoPtr: Pointer;                 //PVSFixedFileInfo;
begin
  Result := '';
  ASize := GetFileVersionInfoSize(PChar(AFileName), AHandle);
  if ASize > 0 then
  begin
    SetLength(Buf, ASize);
    GetFileVersionInfo(PChar(AFileName), AHandle, ASize, Pointer(Buf));
    VerQueryValue(Pointer(Buf), '\', FileInfoPtr, ASize);
    with TVSFixedFileInfo(FileInfoPtr^) do
      Result := IntToStr(HIWORD(dwFileVersionMS)) + '.' +
        IntToStr(LOWORD(dwFileVersionMS)) + '.' +
        IntToStr(HIWORD(dwFileVersionLS)) + '.' +
        IntToStr(LOWORD(dwFileVersionLS));
  end;
end; }

//CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS

{ function IsMOBDLLVersionOK: Boolean;
var
  MOBDLLPath, MOBDLLRequiredVersion, DLLVersion, ResultStr: string;

  procedure DisplayError;
  var Msg: String;
  begin
    if MOBDLLPath = '' then
      Msg := 'A problem with the ' + MOBDLLName + ' file was detected. ' +
        'The One Step Clinic Administrion cannot be used at this time.' + #13#13 +
        '<FILE MISSING OR INVALID>'
    else
      Msg := 'A problem with the ' + MOBDLLName + ' file was detected. ' +
        'The One Step Clinic Administrion cannot be used at this time.' + #13#13 +
        'CPRS requires a minimum version of ' + MOBDLLRequiredVersion + ' but version ' +
        DLLVersion + ' was found or should be in the following path ' + MOBDLLPath;


    InfoBox(Msg, 'Unable to launch the One Step Clinic Admin DLL', MB_OK);
  end;

begin
  Result := True;

  MOBDLLPath := FindDllDir(MOBDLLName);
  if MOBDLLPath = '' then
  begin
    DisplayError;
    Result := False;
  end
  else
  begin
    DLLVersion := ClientVersion(MOBDLLPath);
    if DLLVersion = '' then DLLVersion := '<FILE MISSING OR INVALID>';
//    ResultStr := DLLVersionCheck(MOBDLLName, DLLVersion);
//    MOBDLLRequiredVersion := Piece(ResultStr, '^', 2);
//    MOBDLLRequiredVersion := RequiredMOBDLL;
//    MOBDLLRequiredVersion := RequiredMOB2DLL;
    MOBDLLRequiredVersion := MOBINFO.MOBRequiredVersion;

    if MOBDLLRequiredVersion > '' then  // rpk 3/1/2016
      if (pieces(DLLVersion, '.', 1, 3) <> pieces(MOBDLLRequiredVersion, '.', 1, 3)) or
        ((piece(DLLVersion, '.', 4) <> '*') and
        (StrToIntDef(piece(DLLVersion, '.', 4), 0) < StrToIntDef(piece(MOBDLLRequiredVersion, '.', 4), 0))) then
      begin
        DisplayError;
        Result := False;
      end;
  end;
end; }


//CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS
(* procedure LoadMOBDLL;
var
  MHPath: string;
begin
  if MOBDLLHandle = 0 then begin
//    MHPath := GetProgramFilesPath + SHARE_DIR + MOBDLLName;
    MHPath := MOBINFO.MobPath + MOBINFO.MOBDLLName;
    MOBDLLHandle := LoadLibrary(PChar(MHPath));
  end;
end;

//CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS
procedure UnloadMOBDLL;
begin
  if MOBDLLHandle <> 0 then begin
    FreeLibrary(MOBDLLHandle);
    MOBDLLHandle := 0;
  end;
end; *)

//CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS

procedure LoadMOBDLL;
var
  MHPath: string;
begin
  if MOBDLLHandle = 0 then begin
    MHPath := MOBINFO.MobPath + MOBINFO.MOBDLLName;
  //  MHPath := GetProgramFilesPath + SHARE_DIR + MOBDLLName;
    MOBDLLHandle := LoadLibrary(PChar(MHPath));
  end;
end;

//CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS

procedure UnloadMOBDLL;
begin
  if MOBDLLHandle <> 0 then begin
    FreeLibrary(MOBDLLHandle);
    MOBDLLHandle := 0;
  end;
end;


{ procedure ShowOneStepAdminOld;
var
  aAppHandle: string;
  Result: longBool;
  aConnectionParams,
    aFunctionParams: WideString;
begin
  LoadMOBDLL;
  if MOBDLLHandle <> 0 then begin
//      aAppHandle := TRPCB.GetAppHandle(RPCBrokerV);
    aAppHandle := TRPCB.GetAppHandle(BCMA_Broker);
    @LoadMOBProc := GetProcAddress(MOBDLLHandle, PAnsiChar(AnsiString('LaunchMOB')));
    if assigned(LoadMOBProc) then begin
//        aConnectionParams := aAppHandle + '^' +
//                  RPCBrokerV.Server + '^' +
//                  IntToStr(RPCBrokerV.ListenerPort) + '^' +
//                  RPCBrokerV.User.Division;
      aConnectionParams := aAppHandle + '^' +
        BCMA_Broker.Server + '^' +
        IntToStr(BCMA_Broker.ListenerPort) + '^' +
        BCMA_Broker.User.Division;

//        aFunctionParams := Patient.DFN + '^' +
//                  'CPRS' + '^' +
//                  IntToStr(User.DUZ) + '^' +
//                  '' + '^' +
//                  IntToStr(Patient.Location);
      aFunctionParams := BCMA_Patient.IEN + '^' +
        'BCMA' + '^' +
        '' + '^' +                      // ProviderIEN
        BCMA_User.InstructorDUZ + '^' +
        BCMA_Patient.HospitalLocationIEN;

//      LoadMOBProc(PWideChar(aConnectionParams), PWideChar(aFunctionParams), Result);
      LoadMOBProc(aConnectionParams, aFunctionParams, Result);
//        if result then frmFrame.mnuFileRefreshClick(Application);
      if result then begin
        if lstCurrentTab = ctCS then
          with TBaseInterfacedObject(BCMA_CoverSheet) as I_Anything do
            RebuildMe
        else
          frmMain.RebuildVirtualDueList(True)
      end;
    end
    else
//      MessageDLG('Can''t find function "'+'LaunchMOB'+'".',mtError,[mbok],0);
      DefMessageDLG('Can''t find function "' + 'LaunchMOB' + '".', mtError, [mbok], 0)
  end
  else
    DefMessageDLG('Can''t find library ' + MOBDLLName + '.', mtError, [mbok], 0);
  @LoadMOBProc := nil;
  UnloadMOBDLL;
end; }

//CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS
(* procedure ShowOneStepAdminOld2;
//const
//  TX_NOT_VALID_IMO = 'You have selected a location that has not been designated for One Step Clinic Admin; this action may not be taken for the current location. Please contact Pharmacy Service if you feel that this is not correct.';
var
  aAppHandle, jobNumber: string;
  Result: longBool;
  aConnectionParams,
    aFunctionParams: WideString;
begin
  if not IsMOBDLLVersionOK then exit;
  try
    try
      LoadMOBDLL;
      if MOBDLLHandle <> 0 then
      begin
//          aAppHandle := TRPCB.GetAppHandle(RPCBrokerV);
        aAppHandle := TRPCB.GetAppHandle(BCMA_Broker);
//          jobNumber := sCallv('ORBCMA5 JOB', [NIL]);
        @LoadMOBProc := GetProcAddress(MOBDLLHandle, PAnsiChar(AnsiString('LaunchMOB')));
        if assigned(LoadMOBProc) then
        begin
            { aConnectionParams := aAppHandle + '^' +
                      GetServerIP(RPCBrokerV.Server) + '^' +
                      IntToStr(RPCBrokerV.ListenerPort) + '^' +
                      RPCBrokerV.User.Division; }
          aConnectionParams := aAppHandle + '^' +
            BCMA_Broker.Server + '^' +
            IntToStr(BCMA_Broker.ListenerPort) + '^' +
            BCMA_Broker.User.Division;
            { aFunctionParams := Patient.DFN + '^' +
                      'CPRS' + '^' +
                      IntToStr(User.DUZ) + '^' +
                      '' + '^' +
                      IntToStr(Encounter.Location) + '^' +
                      jobNumber; }
          aFunctionParams := BCMA_Patient.IEN + '^' +
            'BCMA' + '^' +
            BCMA_User.DUZ + '^' +       // NurseIEN
            BCMA_User.InstructorDUZ + '^' +
            BCMA_Patient.HospitalLocationIEN;

//      LoadMOBProc(PWideChar(aConnectionParams), PWideChar(aFunctionParams), Result);
          LoadMOBProc(aConnectionParams, aFunctionParams, Result);
//            if result then frmFrame.mnuFileRefreshClick(Application);
//          if result then
//            frmMain.actionDueListRefreshExecute(nil);
      if result then begin
        if lstCurrentTab = ctCS then
          with TBaseInterfacedObject(BCMA_CoverSheet) as I_Anything do
            RebuildMe
        else
          frmMain.RebuildVirtualDueList(True)
      end;
        end
        else
          DefMessageDLG('Can''t find function "' + 'LaunchMOB' + '".', mtError, [mbok], 0);
      end
      else
        MessageDLG('Can''t find library ' + MOBINFO.MOBDLLName + '.', mtError, [mbok], 0);
    except
      on E: Exception do
      begin
        InfoBox('Error Executing ' + MOBDLLName + '. Error Message: ' + E.Message, 'Error Executing DLL', MB_OK);
      end;
    end;
  finally
//    ResumeTimeout;
    @LoadMOBProc := nil;
    UnloadMOBDLL;
  end;
end; *)

procedure ShowOneStepAdmin;             // P77
var
  aAppHandle: string;
  Result: longBool;
  aConnectionParams,
    aFunctionParams: WideString;
begin
  LoadMOBDLL;
  if MOBDLLHandle <> 0 then begin
//      aAppHandle := TRPCB.GetAppHandle(RPCBrokerV);
    aAppHandle := TRPCB.GetAppHandle(BCMA_Broker);
    @LoadMOBProc := GetProcAddress(MOBDLLHandle, PAnsiChar(AnsiString('LaunchMOB')));
    if assigned(LoadMOBProc) then begin
//        aConnectionParams := aAppHandle + '^' +
//                  RPCBrokerV.Server + '^' +
//                  IntToStr(RPCBrokerV.ListenerPort) + '^' +
//                  RPCBrokerV.User.Division;
      aConnectionParams := aAppHandle + '^' +
        BCMA_Broker.Server + '^' +
        IntToStr(BCMA_Broker.ListenerPort) + '^' +
        BCMA_Broker.User.Division;

//        aFunctionParams := Patient.DFN + '^' +
//                  'CPRS' + '^' +
//                  IntToStr(User.DUZ) + '^' +
//                  '' + '^' +
//                  IntToStr(Patient.Location);
      aFunctionParams := BCMA_Patient.IEN + '^' +
        'BCMA' + '^' +
        '' + '^' +                      // ProviderIEN
        BCMA_User.InstructorDUZ + '^' +
        BCMA_Patient.HospitalLocationIEN;

//      LoadMOBProc(PWideChar(aConnectionParams), PWideChar(aFunctionParams), Result);
      LoadMOBProc(aConnectionParams, aFunctionParams, Result);
//        if result then frmFrame.mnuFileRefreshClick(Application);
      if result then begin
        if lstCurrentTab = ctCS then
          with TBaseInterfacedObject(BCMA_CoverSheet) as I_Anything do
            RebuildMe
        else
          frmMain.RebuildVirtualDueList(True)
      end;
    end
    else
//      MessageDLG('Can''t find function "'+'LaunchMOB'+'".',mtError,[mbok],0);
      DefMessageDLG('Can''t find function "' + 'LaunchMOB' + '".', mtError, [mbok], 0)
  end
  else
    DefMessageDLG('Can''t find library ' + MOBINFO.MOBDLLName + '.', mtError, [mbok], 0);
  @LoadMOBProc := nil;
  UnloadMOBDLL;
end;                                    // ShowOneStepAdmin


end.

