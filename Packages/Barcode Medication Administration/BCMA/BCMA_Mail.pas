unit BCMA_Mail;

interface

uses
  Classes,
  TRPCB;

type TMailMessage = class(TObject)
  private
    FBroker: TRPCBroker;
    FSubject: string;
    FMsgText: TStringList;
    FRecipients: TStringList;
    FSendToSelf: Boolean;
    FMessageID: string;
    FMessageResult: string;
    FAttachment: string;
  public
    constructor Create(Broker: TRPCBroker);
    destructor Destroy; override;
    function Send: Boolean;
  published
    property Subject: string
      read FSubject write FSubject;
    property MsgText: TStringList
      read FMsgText write FMsgText;
    property Recipients: TStringList
      read FRecipients write FRecipients;
    property SendToSelf: Boolean
      read FSendToSelf write FSendToSelf default False;
    property MessageID: string
      read FMessageID;
    property MessageResult: string
      read FMessageResult;
    property Attachment: string
      read FAttachment write FAttachment;
  end;

const RPC_MAILINTERFACE = 'PSB MAIL';

function CallServer(Broker: TRPCBroker; RemoteProcedure: string; Parameters: array of string; MultList: TStringList): Boolean;

implementation

constructor TMailMessage.Create(Broker: TRPCBroker);
begin
  inherited Create;
  FBroker := Broker;
  FMessageID := '';
  FMsgText := TStringList.Create;
  FRecipients := TStringList.Create;
end;

destructor TMailMessage.Destroy;
begin
  FMsgText.Free;
  FRecipients.Free;
  inherited Destroy;
end;

function TMailMessage.Send: Boolean;
var
  MsgTextBlock: TStringList;
  i: integer;
begin
  CallServer(FBroker, RPC_MAILINTERFACE, ['CREATE'], nil);
  CallServer(FBroker, RPC_MAILINTERFACE, ['SUBJECT', FSubject], nil);

  MsgTextBlock := TStringList.Create;

  try
    while FMsgText.Count > 0 do
      begin
        i := 0;
        MsgTextBlock.Clear;
        while (i < 50) and (FMsgText.Count > 0) do
          begin
            MsgTextBlock.Add(FMsgText[0]);
            FMsgText.Delete(0);
            inc(i);
          end;
        CallServer(FBroker, RPC_MAILINTERFACE, ['APPEND'], MsgTextBlock);
      end;
    if FAttachment <> '' then
      begin
        //CallServer(FBroker, RPC_MAILINTERFACE, ['APPEND', 'Attachment: ' + FAttachment], nil);
        CallServer(FBroker, RPC_MAILINTERFACE, ['APPEND', ''], nil);
        FMsgText.Clear;
        FMsgText.LoadFromFile(FAttachment);
        while FMsgText.Count > 0 do
          begin
            i := 0;
            MsgTextBlock.Clear;
            while (i < 50) and (FMsgText.Count > 0) do
              begin
                MsgTextBlock.Add(FMsgText[0]);
                FMsgText.Delete(0);
                inc(i);
              end;
            CallServer(FBroker, RPC_MAILINTERFACE, ['APPEND'], MsgTextBlock);
          end;
      end;
  finally
    MsgTextBlock.Free;
  end;

  if FRecipients.Count > 0 then
    CallServer(FBroker, RPC_MAILINTERFACE, ['SENDTO'], FRecipients);

  if FSendToSelf then
    CallServer(FBroker, RPC_MAILINTERFACE, ['SENDTO', '@DUZ'], nil);

  CallServer(FBroker, RPC_MAILINTERFACE, ['EXECUTE'], nil);

  if FBroker.Results.Count > 0 then
    begin
      FMessageResult := 'Message Sent.  ID: ' + FBroker.Results[0];
      FMessageID := FBroker.Results[0];
      Result := True;
    end
  else
    begin
      FMessageResult := 'Error sending message.';
      FMessageID := '-1';
      Result := False;
    end;
end;

function CallServer(Broker: TRPCBroker; RemoteProcedure: string; Parameters: array of string; MultList: TStringList): Boolean;
var
  i: integer;
begin
  Broker.RemoteProcedure := RemoteProcedure;
  i := 0;
  while i <= High(Parameters) do
    if (Copy(Parameters[i], 1, 1) = '@') and (Parameters[i] <> '@') then
      begin
        Broker.Param[i].Value := Copy(Parameters[i], 2, Length(Parameters[i]));
        Broker.Param[i].PType := Reference;
        inc(i);
      end
    else
      begin
        Broker.Param[i].Value := Parameters[i];
        Broker.Param[i].PType := Literal;
        inc(i);
      end;

  if MultList <> nil then
    begin
      Broker.Param[i + 1].Mult.Assign(MultList);
      Broker.Param[i + 1].PType := List;
    end;

  try
    Broker.Call;
    Result := True;
  except
    on EBrokerError do
      begin
        Result := False;
        Broker.Results[0] := '-1^Broker Error';
      end;
  end;
end;


end.

