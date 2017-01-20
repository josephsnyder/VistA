unit uCCOW;
{
================================================================================
*
*       Application:  Plug and Play Unit
*       Revision:     $Revision: 3 $  $Modtime: 5/01/03 9:28a $
*       Description:  Sentillion CCOW implementation
*
*       Notes:        Requires Sentillion SDK installation
*                     for ActiveX TContextorControl as well
*                     as the desktop locator.
*
*                     Developed with Sentillion SDK v 3.3
*                     Build 3.3.1.8907
*
================================================================================
}

interface

uses
  Sysutils,
  Controls,
  Dialogs,
  Classes,
  ActiveX,
  ImgList,
  OleCtrls,
  VERGENCECONTEXTORLib_TLB,
  Forms,
  ComOBJ;

const
  CCOW_PATIENT_ID_MRN = 'patient.id.MRN.CCOW';
  CCOW_PATIENT_ID_ALT = 'patient.id.ALTERNATE.CCOW';
  CCOW_PATIENT_ID_MPI = 'patient.id.MPI';
  CCOW_PATIENT_ID_NID = 'patient.id.MRN.NATIONALIDNUMBER';

  CCOW_PATIENT_CO_NAME = 'patient.co.PATIENTNAME';
  CCOW_PATIENT_CO_ALIAS = 'patient.co.ALIASNAME';
  CCOW_PATIENT_CO_DOB = 'patient.co.DATETIMEOFBIRTH';
  CCOW_PATIENT_CO_SEX = 'patient.co.SEX';
  CCOW_PATIENT_CO_DLN = 'patient.co.DLN';
  CCOW_PATIENT_CO_SSN = 'patient.co.SSN';

  CCOW_OBSERVATION_ID_PON = 'observation.id.PLACER_ORDER_NUMBER.CCOW';
  CCOW_OBSERVATION_ID_FON = 'observation.id.FILLER_ORDER_NUMBER.CCOW';

  CCOW_OBSERVATION_CO_SYSID = 'observation.co.SYSTEM_ID.CCOW';
  CCOW_OBSERVATION_CO_SVCID = 'observation.co.SERVICE_ID.CCOW';
  CCOW_OBSERVATION_CO_DATETIME = 'observation.co.DATE_TIME.CCOW';
  CCOW_OBSERVATION_CO_SVCDESC = 'observation.co.SERVICE_DESC.CCOW';

type
  TVACCOW_RejoinMode = (rmGet, rmSet);
  TVACCOW_LinkStatus = (lsNoCCOW, lsJoined, lsBroken, lsChanging);
  TVACCOW_AbleToChangeStatus = (acYes, acNo, acCannot);

  TNotifyAbleToChange = procedure(var OkayToChange: TVACCOW_AbleToChangeStatus;
    var MsgText: string; const NewID: string;
    const NewICN: string; const NewName: string; const Site: string; const
    NewProd: Boolean) of object;
  TNotifyNewPatientID = procedure(const PtID, ICN, Name, Site: string; const
    Prod: Boolean) of object;
  TNotifyNewLinkStatus = procedure(const Status: TVACCOW_LinkStatus) of object;

  TNotifyGetSite = procedure(var Site: string) of object;
  TNotifyCCOWError = procedure(const CCOWError: Exception) of object;

  TVACCOW = class(Tobject)
  private
    fContextManager: TContextorControl;
    FLinkStatus: TVACCOW_LinkStatus;
    FAbleToChangeStatus: TVACCOW_AbleToChangeStatus;
    FCCOWEnabled: Boolean;

    procedure NotifyNewPatientIDDefault(const aPtId, aICN, aName, aSite: string;
      const aProd: Boolean);
    procedure NotifyNewLinkStatusDefault(const Status: TVACCOW_LinkStatus);
    procedure NotifyAbleToChangeDefault(var OkayToChange:
      TVACCOW_AbleToChangeStatus;
      var MsgText: string; const NewID: string; const NewICN: string; const
      NewName: string;
      const Site: string; const NewProd: Boolean);

    procedure SetLinkStatus(const NewStatus: TVACCOW_LinkStatus);
    //    procedure CleanupBeforeChange;

    procedure NotifyGetSiteDefault(var Site: string);
    procedure NotifyCCOWErrorDefault(const CCOWERR: Exception);

  public
    NotifyNewPatientID: TNotifyNewPatientID;
    NotifyNewLinkStatus: TNotifyNewLinkStatus;
    NotifyAbleToChange: TNotifyAbleToChange;

    NotifyGetSite: TNotifyGetSite;
    NotifyCCOWError: TNotifyCCOWError;

    property ContextManager: TContextorControl read fContextManager write fContextManager; // rpk 3/25/2013

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    {pointers to methods of fContextManager}
    procedure OnPendingExecute(Sender: TObject; const aContextItemCollection:
      IDispatch);
    procedure OnCommitExecute(Sender: TObject);
    procedure OnCancelExecute(Sender: TObject);

    function JoinContext(ApplicationName: WideString; Passcode: WideString = '';
      Survey: Boolean = True; InitialNotificationFilter: string = '*'): Boolean;
    function SuspendContext: Boolean;
    function ResumeContext(const RejoinMode: TVACCOW_RejoinMode): Boolean;
    function SetNewPatientContext(const PtId, PtICN, PtName, PtSite: string;
      const aProd: Boolean): boolean;
  published
    property CCOWEnabled: Boolean
      read FCCOWEnabled write FCCOWEnabled;
    property LinkStatus: TVACCOW_LinkStatus
      read FLinkStatus;
  end;

function NewCCOWContextor(aOwner: TComponent): TVACCOW;

var
  VACCOW: TVACCOW;

implementation
uses BCMA_Startup;

{ TVACCOW }

{ Procedures to instatiate new TVACCOW object}

function NewCCOWContextor(aOwner: TComponent): TVACCOW;
begin
  if NoCCOW then  // rpk 7/25/2013
    Result := nil // rpk 7/25/2013
  else  // rpk 7/25/2013
    Result := TVACCOW.Create(aOwner);
end;

constructor TVACCOW.Create(AOwner: TComponent);
begin
  try
    fContextManager := TContextorControl.Create(AOwner);
    fContextManager.OnCanceled := OnCancelExecute;
    fContextManager.OnCommitted := OnCommitExecute;
    fContextManager.OnPending := OnPendingExecute;
    FCCOWEnabled := True;
  except
//    ShowMessage('Problem with Contextor.Create'); // rpk 3/25/2013
    fContextManager.Free; // rpk 3/25/2013
    fContextManager := nil; // rpk 3/25/2013
    FCCOWEnabled := False;
  end;

  //  FCCOWEnabled := False; //to enable CCOW functionality call JoinContext
  FLinkStatus := lsNoCCOW;

  NotifyNewPatientID := NotifyNewPatientIDDefault;
  NotifyNewLinkStatus := NotifyNewLinkStatusDefault;
  NotifyAbleToChange := NotifyAbleToChangeDefault;
  NotifyGetSite := NotifyGetSiteDefault;
  NotifyCCOWError := NotifyCCOWErrorDefault;

end;

destructor TVACCOW.Destroy;
begin
  FreeAndNil(fContextManager);
  inherited;
end;

function TVACCOW.JoinContext(ApplicationName: WideString; Passcode: WideString =
  '';
  Survey: Boolean = True; InitialNotificationFilter: string = '*'): Boolean;
//var
//  CCOWState: TOleEnum;
begin
  Result := False; // rpk 4/23/2009
  try
    //    CCOWState := fContextManager.State;
    //    if fContextManager.State = csNotRunning then
    //    begin
    //      FCCOWEnabled := False;
     //     Result := False;
     //     SetLinkStatus(lsNoCCOW);
     //     exit;
    //    end;
    if FCCOWEnabled then
    begin
      fContextManager.Run(ApplicationName, Passcode, Survey,
        InitialNotificationFilter);
      FCCOWEnabled := True; // ????
      Result := True;
      SetLinkStatus(lsJoined);
    end;
  except
    on e: EOleException do
    begin
      showmessage('Problem with Contextor.Run: ' + e.message); // re-added rpk 3/25/2013
      fContextManager.Free; // rpk 3/25/2013
      fContextManager := nil; // rpk 3/25/2013
      Result := False;
      NotifyCCOWError(e);
    end;
  end;
end;

{procedures methods for responding to contextor}

procedure TVACCOW.OnCancelExecute(Sender: TObject);
begin
  // Do nothing, it was cancelled
end;

procedure TVACCOW.OnPendingExecute(Sender: TObject; const
  aContextItemCollection: IDispatch);
var
  OkayToChange: TVACCOW_AbleToChangeStatus;
  MsgText: string;
  ContextItemCollection: IContextItemCollection;
  ContextItem: IContextItem;
  NewID,
    NewICN,
    NewName,
    Site: string;
  NewProd: Boolean;

begin
  NewProd := True;
  NotifyGetSite(Site);
  ContextItemCollection := IContextItemCollection(aContextItemCollection);
  //  ContextItemCollection := fContextManager.CurrentContext;
  //  ContextItem := ContextItemCollection.Present(CCOW_PATIENT_ID_MRN);
  //  ContextItem := ContextItemCollection.Present('Patient.ID.MRN.DFN_500');
  ContextItem := ContextItemCollection.Present('Patient.ID.MRN.DFN_' + Site);
  if ContextItem = nil then
  begin
    ContextItem := ContextItemCollection.Present('Patient.ID.MRN.DFN_' + Site +
      '_test');
    if ContextItem <> nil then
      NewProd := False;
  end;

  if ContextItem <> nil then
    NewID := ContextItem.Get_Value()
  else
    NewID := '';

  ContextItem := ContextItemCollection.Present(CCOW_PATIENT_CO_NAME);
  if ContextItem <> nil then
    NewName := ContextItem.Get_Value()
  else
    NewName := '';

  ContextItem := ContextItemCollection.Present(CCOW_PATIENT_ID_NID);
  if ContextItem = nil then
  begin
    ContextItem :=
      ContextItemCollection.Present('patient.id.MRN.NATIONALIDNUMBER_test');
    if Contextitem <> nil then
      NewProd := false;
  end;

  if ContextItem <> nil then
    NewICN := ContextItem.Get_Value()
  else
    NewICN := '';

  NotifyAbleToChange(OkayToChange, MsgText, NewID, NewICN, NewName, Site,
    NewProd);
  FAbleToChangeStatus := OkayToChange;

  case FAbleToChangeStatus of
    acNo: fContextManager.SetSurveyResponse(MsgText);
    acCannot: fContextManager.SetSurveyResponse(MsgText);
  end;
end;

procedure TVACCOW.OnCommitExecute(Sender: TObject);
var
  ContextItemCollection: IContextItemCollection;
  ContextItem: IContextItem;
  NewID,
    NewICN,
    NewName,
    Site: string;
  NewProd: Boolean;
begin
  if not VACCOW.CCOWEnabled then
    exit;
  NotifyGetSite(Site);
  if FAbleToChangeStatus = acCannot then
    SuspendContext // Status set in OnPendingExecute
  else
  begin
    //CleanupBeforeChange;
    NewProd := True;
    ContextItemCollection := fContextManager.CurrentContext;
    //ContextItem := ContextItemCollection.Present(CCOW_PATIENT_ID_MRN);
    ContextItem := ContextItemCollection.Present('Patient.ID.MRN.DFN_' + Site);
    if ContextItem = nil then
    begin
      ContextItem := ContextItemCollection.Present('Patient.ID.MRN.DFN_' + Site +
        '_test');
      if ContextItem <> nil then
        NewProd := False;
    end;

    if ContextItem <> nil then
      NewID := ContextItem.Value
    else
      NewID := '';

    ContextItem := ContextItemCollection.Present(CCOW_PATIENT_CO_NAME);
    if ContextItem <> nil then
      NewName := ContextItem.Get_Value()
    else
      NewName := '';

    ContextItem := ContextItemCollection.Present(CCOW_PATIENT_ID_NID);
    if ContextItem = nil then
    begin
      ContextItem :=
        ContextItemCollection.Present('patient.id.MRN.NATIONALIDNUMBER_test');
      if Contextitem <> nil then
        NewProd := false;
    end;

    if ContextItem <> nil then
      NewICN := ContextItem.Get_Value()
    else
      NewICN := '';
    // procedure = SetCurrentPtIEN
    NotifyNewPatientID(NewID, NewICN, NewName, Site, NewProd);
  end;
end;

(* procedure TVACCOW.CleanupBeforeChange;
var
  index: integer;
begin
  { TODO 1  -cUrgent :
  Future research needed for this one. Could kill off parent of non-modal
  window which could be very very bad. This also need to be wrapped in
  a TNotifyEvent to allow the application to perform the cleanup if desired.}
  for index := 0 to Screen.FormCount - 1 do
  begin
    if fsModal in Screen.Forms[index].FormState then
      Screen.Forms[index].ModalResult := mrCancel
    else
      Break;
  end;
end; *)

{ Public functions to manage the connection and context }

function TVACCOW.SuspendContext: Boolean;
begin
  if not CCOWEnabled then
  begin
    Result := False;
    Exit;
  end;
  try
    if fContextManager.State = csParticipating then
      fContextManager.Suspend;
    Result := True;
    SetLinkStatus(lsBroken);
  except
    on e: Exception do
    begin
      SetLinkStatus(lsBroken);
      CCOWEnabled := False;
      NotifyCCOWError(e);
      Result := False;
    end
  end;
end;

function TVACCOW.ResumeContext(const RejoinMode: TVACCOW_RejoinMode): Boolean;
begin
  Result := False; // rpk 4/23/2009

  if not CCOWEnabled then
  begin
    Result := False;
    Exit;
  end;

  //the following allows us to JOIN the existing context if we are currently already
  //in context, but have closed the patient.
  if fContextManager.State = csParticipating then
    SuspendContext;

  if fContextManager.State <> csParticipating then
  try
    FAbleToChangeStatus := acYes;
    fContextManager.Resume;
    case RejoinMode of
      rmGet:
        begin
          SetLinkStatus(lsJoined);
          OnCommitExecute(nil);
        end;
      rmSet:
        begin
          SetLinkStatus(lsJoined);
          //OnCommitExecute(nil);
        end;
    end;
    Result := True;
  except
    on e: Exception do
    begin
      SetLinkStatus(lsBroken);
      CCOWEnabled := False;
      NotifyCCOWError(e);
      Result := False;
    end
  end;
end;

function TVACCOW.SetNewPatientContext(const PtId, PtICN, PtName, PtSite: string;
  const aProd: Boolean): Boolean;
var
  NewContextData: IContextItemCollection;
  NewContextItem: IContextItem;
  Response: UserResponse;
begin
  { TODO 3 -cNormal : Complete this to do any context subject not just patient.id.mrn }
  Result := False; // rpk 4/23/2009

  if not CCOWEnabled then
  begin
    Result := False;
    Exit;
  end;
  try
    if fContextManager.State = csParticipating then
    begin
      SetLinkStatus(lsChanging);
      fContextManager.StartContextChange;

      NewContextData := CoContextItemCollection.Create;

      NewContextItem := CoContextItem.Create;
      //NewContextItem.Name := CCOW_PATIENT_ID_MRN;
      if aProd then
        NewContextItem.Name := 'Patient.ID.MRN.DFN_' + PtSite
      else
        NewContextItem.Name := 'Patient.ID.MRN.DFN_' + PtSite + '_test';
      NewContextItem.Value := PtId;
      NewContextData.Add(NewContextItem);

      NewContextItem := CoContextItem.Create;

      if aProd then
        NewContextItem.Name := CCOW_PATIENT_ID_NID
      else
        NewContextItem.Name := 'patient.id.MRN.NATIONALIDNUMBER_test';
      NewContextItem.Value := PtICN;

      NewContextData.Add(NewContextItem);
      NewContextItem := CoContextItem.Create;
      NewContextItem.Name := CCOW_PATIENT_CO_NAME;
      NewContextItem.Value := PtName;
      NewContextData.Add(NewContextItem);

      Response := fContextManager.EndContextChange(True, NewContextData);

      case Response of
        urCommit:
          begin
            SetLinkStatus(lsJoined);
            //NotifyNewPatientID(PtId);
            Result := True;
          end;
        urCancel:
          begin
            if CCOWEnabled <> False then
              SetLinkStatus(lsJoined);
            Result := False;
          end;
        urBreak:
          begin
            SuspendContext;
            Result := True;
          end;
      else
        Result := False;
      end;
    end
    else
    begin
      //NotifyNewPatientID(PtId);
      Result := True;
    end;
  except
    on e: Exception do
    begin
      SetLinkStatus(lsBroken);
      CCOWEnabled := False;
      NotifyCCOWError(e);
    end;
  end;
end;

procedure TVACCOW.SetLinkStatus(const NewStatus: TVACCOW_LinkStatus);
begin
  if NewStatus = FLinkStatus then
    Exit;
  FLinkStatus := NewStatus;
  NotifyNewLinkStatus(NewStatus);
end;

{ Default procedures for methods }

procedure TVACCOW.NotifyNewPatientIDDefault(const aPtId, aICN, aName, aSite:
  string; const aProd: Boolean);
begin
end;

procedure TVACCOW.NotifyNewLinkStatusDefault(const Status: TVACCOW_LinkStatus);
begin
end;

procedure TVACCOW.NotifyAbleToChangeDefault(var OkayToChange:
  TVACCOW_AbleToChangeStatus;
  var MsgText: string; const NewID: string; const NewICN, NewName, Site: string;
  const NewProd: Boolean);
begin
  OkayToChange := acYes;
end;

procedure TVACCOW.NotifyGetSiteDefault(var Site: string);
begin
end;

procedure TVACCOW.NotifyCCOWErrorDefault(const CCOWErr: Exception);
begin
  SetLinkStatus(lsNoCCOW);
  FCCOWEnabled := False;
end;
end.

