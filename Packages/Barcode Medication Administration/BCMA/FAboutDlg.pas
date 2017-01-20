unit FAboutDlg;
{
================================================================================
*	File:  FAboutDlg.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 18 $  $Modtime: 5/02/02 2:36p $
*	Description:  This is an About Dialog which displays data from the project
*               VersionInfo block for the application.
*
*	Notes:
*
*
================================================================================
}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

const
  VersionInfoKeys: array[1..10] of string = (
    'CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
    'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion',
    'Comments', 'ReleaseDate'
    );

  USEnglish = $040904E4;

type
  PTransBuffer = ^TTransBuffer;
  TTransBuffer = array[1..13] of smallint;

const
  CInfoStr: array[1..13] of string =
  ('FileVersion',
    'CompanyName',
    'FileDescription',
    'InternalName',
    'LegalCopyright',
    'LegalTradeMarks',
    'OriginalFileName',
    'ProductName',
    'ProductVersion',
    'Comments',
    'CurrentProgramVersion',
    'CurrentDatabaseVersion',
    'VersionDetails');

type
  TVersionInfo = class(TComponent)
    (*
      Retrieves Version Info data about a given binary file.
    *)
  private
    FFileName: string;
    FLanguageID: DWord;
    FInfo: pointer;
    FInfoSize: longint;

    FCtlCompanyName: TControl;
    FCtlFileDescription: TControl;
    FCtlFileVersion: TControl;
    FCtlInternalName: TControl;
    FCtlLegalCopyRight: TControl;
    FCtlOriginalFileName: TControl;
    FCtlProductName: TControl;
    FCtlProductVersion: TControl;
    FCtlComments: TControl;
    FCtlReleaseDate: TControl;

    procedure SetFileName(Value: string);
    procedure SetVerProp(index: integer; value: TControl);
    function GetVerProp(index: integer): TControl;
    function GetIndexKey(index: integer): string;
    function GetKey(const KName: string): string;
    procedure Refresh;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    property FileName: string read FFileName write SetFileName;
    property LanguageID: DWord read FLanguageID write FLanguageID;

    property CompanyName: string index 1 read GetIndexKey;
    property FileDescription: string index 2 read GetIndexKey;
    property FileVersion: string index 3 read GetIndexKey;
    property InternalName: string index 4 read GetIndexKey;
    property LegalCopyRight: string index 5 read GetIndexKey;
    property OriginalFileName: string index 6 read GetIndexKey;
    property ProductName: string index 7 read GetIndexKey;
    property ProductVersion: string index 8 read GetIndexKey;
    property Comments: string index 9 read GetIndexKey;
    property ReleaseDate: string index 10 read GetIndexKey;

    constructor Create(AOwner: TComponent); override;
    (*
      Allocates memory and initializes variables for the object.
    *)

    destructor Destroy; override;
    (*
      Releases all memory allocated for the object.
    *)

    procedure OpenFile(FName: string);
    (*
      Uses method GetFileVersionInfo to retrieve version information for file
      FName.  If FName is blank, version information is obtained for the
      current executable (Application.ExeName).
    *)

    procedure Close;
    (*
      Releases memory allocated and clears all storage variables.
    *)

  published
    property CtlCompanyName: TControl index 1 read GetVerProp write SetVerProp;
    property CtlFileDescription: TControl index 2 read GetVerProp write
      SetVerProp;
    property CtlFileVersion: TControl index 3 read GetVerProp write SetVerProp;
    property CtlInternalName: TControl index 4 read GetVerProp write SetVerProp;
    property CtlLegalCopyRight: TControl index 5 read GetVerProp write
      SetVerProp;
    property CtlOriginalFileName: TControl index 6 read GetVerProp write
      SetVerProp;
    property CtlProductName: TControl index 7 read GetVerProp write SetVerProp;
    property CtlProductVersion: TControl index 8 read GetVerProp write
      SetVerProp;
    property CtlComments: TControl index 9 read GetVerProp write SetVerProp;
    property CtlReleaseDate: TControl index 10 read GetVerProp write SetVerProp;
  end;

  TAboutDlg = class(TForm)
    (*
      An About dialog which displays the Version Info data for the current
      application.
    *)
    Panel1: TPanel;
    ProgramIcon: TImage;
    OKButton: TButton;
    pnl508: TPanel;
    edtProductName: TEdit;
    edtVersion: TEdit;
    edtReleaseDate: TEdit;
    edtCopyRight: TEdit;
    edtComments: TEdit;
    edtCRC: TEdit;
    RichEdit1: TRichEdit;
    edtMOBInfo: TMemo;                  // P77

    procedure FormCreate(Sender: TObject);
    (*
      Uses TVersionInfo to read the Version Info for application.ExeName into
      the form's display fields.
    *)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute;
    (*
      Creates the form and shows it modally.
    *)
  end;

var
  AboutDlg: TAboutDlg;

implementation

{$R *.DFM}
uses
//  Dialogs, TypInfo, BCMA_Util;
  Dialogs, TypInfo, BCMA_Util, BCMA_Common, BCMA_Objects; // P77

(*=== TVersionInfo Methods ==================================================*)

constructor TVersionInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLanguageID := USEnglish;
  SetFileName(EmptyStr);
end;

destructor TVersionInfo.Destroy;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  inherited Destroy;
end;

procedure TVersionInfo.SetFileName(Value: string);
begin
  FFileName := Value;
  if Value = EmptyStr then              // default to self
    FFileName := ExtractFileName(Application.ExeName);
  //		FFileName := ExtractFilePath(Application.ExeName);
  if csDesigning in ComponentState then
  begin
    Refresh
  end
  else
    OpenFile(Value);
end;

procedure TVersionInfo.OpenFile(FName: string);
var
  vlen: DWord;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  if Length(FName) <= 0 then
    FName := Application.ExeName;
  FInfoSize := GetFileVersionInfoSize(pchar(fname), vlen);
  if FInfoSize > 0 then
  begin
    GetMem(FInfo, FInfoSize);
    if not GetFileVersionInfo(pchar(fname), vlen, FInfoSize, FInfo) then
      raise Exception.Create('Cannot retrieve Version Information for ' +
        fname);
    Refresh;
  end;
end;

procedure TVersionInfo.Close;
begin
  if FInfoSize > 0 then
    FreeMem(FInfo, FInfoSize);
  FInfoSize := 0;
  FFileName := EmptyStr;
end;

const
  vqvFmt = '\StringFileInfo\%8.8x\%s';

function TVersionInfo.GetKey(const KName: string): string;
var
  //vptr: pchar;
  vlen: DWord;
  //Added the following
  transStr: string;
  vptr: PTransBuffer;
  value: PChar;

begin
  Result := EmptyStr;
  if FInfoSize <= 0 then
    exit;

  //  If VerQueryValue(FInfo, pchar(Format(vqvFmt, [FLanguageID, KName])), pointer(vptr), vlen) Then
  if VerQueryValue(FInfo, PChar('\VarFileInfo\Translation'), Pointer(vptr), vlen)
    then
  begin
    //Added the following two lines:
    transStr := IntToHex(vptr^[1], 4) + IntToHex(vptr^[2], 4);
    if VerQueryValue(FInfo, pchar('StringFileInfo\' + transStr + '\' + KName),
      pointer(value), vlen) then
      //Result := vptr;
      Result := Value;
  end;
end;

function TVersionInfo.GetIndexKey(index: integer): string;
begin
  Result := GetKey(VersionInfoKeys[index]);
end;

function TVersionInfo.GetVerProp(index: integer): TControl;
begin
  case index of
    1: Result := FCtlCompanyName;
    2: Result := FCtlFileDescription;
    3: Result := FCtlFileVersion;
    4: Result := FCtlInternalName;
    5: Result := FCtlLegalCopyRight;
    6: Result := FCtlOriginalFileName;
    7: Result := FCtlProductName;
    8: Result := FCtlProductVersion;
    9: Result := FCtlComments;
    10: Result := FCtlReleaseDate;
  else
    Result := nil;
  end;
end;

procedure TVersionInfo.SetVerProp(index: integer; value: TControl);
begin
  case index of
    1: FCtlCompanyName := Value;
    2: FCtlFileDescription := Value;
    3: FCtlFileVersion := Value;
    4: FCtlInternalName := Value;
    5: FCtlLegalCopyRight := Value;
    6: FCtlOriginalFileName := Value;
    7: FCtlProductName := Value;
    8: FCtlProductVersion := Value;
    9: FCtlComments := Value;
    10: FCtlReleaseDate := Value;
  end;
  Refresh;
end;

procedure TVersionInfo.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  if Operation = opRemove then
  begin
    if AComponent = FCtlCompanyName then
      FCtlCompanyName := nil
    else if AComponent = FCtlFileDescription then
      FCtlFileDescription := nil
    else if AComponent = FCtlFileVersion then
      FCtlFileVersion := nil
    else if AComponent = FCtlInternalName then
      FCtlInternalName := nil
    else if AComponent = FCtlLegalCopyRight then
      FCtlLegalCopyRight := nil
    else if AComponent = FCtlOriginalFileName then
      FCtlOriginalFileName := nil
    else if AComponent = FCtlProductName then
      FCtlProductName := nil
    else if AComponent = FCtlProductVersion then
      FCtlProductVersion := nil
    else if AComponent = FCtlComments then
      FCtlComments := nil
    else if AComponent = FCtlReleaseDate then
      FCtlReleaseDate := nil;
  end;
end;

procedure TVersionInfo.Refresh;
var
  PropInfo: PPropInfo;

  procedure AssignText(Actl: TComponent; txt: string);
  begin
    if Assigned(ACtl) then
    begin
      PropInfo := GetPropInfo(ACtl.ClassInfo, 'Caption');
      if PropInfo <> nil then
        SetStrProp(ACtl, PropInfo, txt)
      else
      begin
        PropInfo := GetPropInfo(ACtl.ClassInfo, 'Text');
        if PropInfo <> nil then
          SetStrProp(ACtl, PropInfo, txt)
      end;
    end;
  end;

begin
  if csDesigning in ComponentState then
  begin
    AssignText(FCtlCompanyName, VersionInfoKeys[1]);
    AssignText(FCtlFileDescription, VersionInfoKeys[2]);
    AssignText(FCtlFileVersion, VersionInfoKeys[3]);
    AssignText(FCtlInternalName, VersionInfoKeys[4]);
    AssignText(FCtlLegalCopyRight, VersionInfoKeys[5]);
    AssignText(FCtlOriginalFileName, VersionInfoKeys[6]);
    AssignText(FCtlProductName, VersionInfoKeys[7]);
    AssignText(FCtlProductVersion, VersionInfoKeys[8]);
    AssignText(FCtlComments, VersionInfoKeys[9]);
    AssignText(FCtlReleaseDate, VersionInfoKeys[10]);
  end
  else
  begin
    AssignText(FCtlCompanyName, CompanyName);
    AssignText(FCtlFileDescription, FileDescription);
    AssignText(FCtlFileVersion, FileVersion);
    AssignText(FCtlInternalName, InternalName);
    AssignText(FCtlLegalCopyRight, LegalCopyRight);
    AssignText(FCtlOriginalFileName, OriginalFileName);
    AssignText(FCtlProductName, ProductName);
    AssignText(FCtlProductVersion, ProductVersion);
    AssignText(FCtlComments, Comments);
    AssignText(FCtlReleaseDate, ReleaseDate);
  end;
end;

(*=== AboutDlg Methods ======================================================*)

procedure TAboutDlg.Execute;
begin

  with TAboutDlg.create(self) do
//  with TAboutDlg.create(Application) do
  try
    showModal;
  finally
//    free;
    Release;                            // rpk 6/18/2013
  end;
end;

procedure TAboutDlg.FormCreate(Sender: TObject);
begin
  ProgramIcon.Picture.assign(application.icon);

  with TVersionInfo.Create(self) do
  try
    edtProductName.Text := ProductName;
    edtVersion.Text := 'Version: ' + FileVersion;
    edtReleaseDate.Text := 'Release Date: ' + ReleaseDate;
    edtCopyright.Text := 'Copyright: ' + LegalCopyRight;
    edtComments.Text := Comments;
    edtCRC.Text := 'CRC: ' + IntToHex(CRCForFile(Application.ExeName), 8);

    //Load the MOB information; P77
    edtMOBInfo.Clear;
    edtMOBInfo.Lines.Add('MOB DLL Information');
//    edtMOBInfo.Lines.Add(MOBinfo.MobPath);
    edtMOBInfo.Lines.Add(MOBinfo.MobPath + MOBInfo.MobDllName);  // rpk 4/19/2016
    edtMOBInfo.Lines.Add('Your Version: ' + MOBINFO.MobVersion);
    edtMOBInfo.Lines.Add('Required Version: ' + MOBINFO.MOBRequiredVersion);

  finally
    free;
  end;
end;

end.

