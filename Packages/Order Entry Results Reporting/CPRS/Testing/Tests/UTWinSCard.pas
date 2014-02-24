//---------------------------------------------------------------------------
// Copyright 2014 The Open Source Electronic Health Record Agent
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//---------------------------------------------------------------------------
unit UTWinSCard;
interface
uses UnitTest, TestFrameWork, WinSCard, SysUtils, Windows, Registry, Dialogs,
     Classes, Forms, Controls, StdCtrls, XuDsigConst;

implementation
type
UTWinSCardTests=class(TTestCase)
  private
  public
  procedure SetUp; override;
  procedure TearDown; override;

  published
    procedure TestSCardEstablishContext;
    procedure TestSCardListReaders;
    procedure TestSCardReleaseContext;
    procedure TestSCardConnectA;
    procedure TestSCardDisconnect;
    procedure TestSCardReconnect;
  end;

  procedure UTWinSCardTests.SetUp;
  begin
  end;

  procedure UTWinSCardTests.TearDown;
  begin
  end;

procedure UTWinSCardTests.TestSCardEstablishContext;
var
  result: ULONG;
  NULL : variant;
  outpointer:DWORD;
begin
  WriteLn(Output,'Start ReleaseContext');
  result := WinSCard.SCardEstablishContext(SCARD_SCOPE_USER,
            nil,nil, @outpointer);
  if(not (result = 0)) then WriteLn(Output,'SCard Establish Context' + IntToStr(GetLastError()));
  CheckEquals(result,SCARD_S_SUCCESS,'SCard Establish Context failed') ;
  WriteLn(Output,'Stop ReleaseContext');
end;


procedure UTWinSCardTests.TestSCardReleaseContext;
var
  result: ULONG;
  NULL : variant;
  outpointer:DWORD;
begin
  WriteLn(Output,'Start EstablishContext');
  result := WinSCard.SCardEstablishContext(SCARD_SCOPE_USER,
            nil,nil, @outpointer);
  result := WinSCard.SCardReleaseContext(outpointer);
  if(not (result = 0)) then WriteLn(Output,'SCard Establish Context' + IntToStr(GetLastError()));
  CheckEquals(result,SCARD_S_SUCCESS,'SCard Establish Context failed') ;
  WriteLn(Output,'Stop EstablishContext');
end;


procedure UTWinSCardTests.TestSCardListReaders;
var
  result,result2,length: ULONG;
  NULL : variant;
  outpointer:DWORD;
  readerlength : integer;
  readerList : string;
begin
  length := SCARD_AUTOALLOCATE;
  WriteLn(Output,'Start ListReaders');
  result := WinSCard.SCardEstablishContext(
            SCARD_SCOPE_USER,
            nil,nil,
            @outpointer);
  result2 := WinSCard.SCardListReadersA(outpointer,nil,nil,readerlength);
  setLength(readerList,readerLength);
  result2 := WinSCard.SCardListReadersA(outpointer,nil,pChar(readerList),readerlength);
  if(not (result2 = 0)) then WriteLn(Output,'SCard Establish Context' + IntToStr(GetLastError()));
  CheckEquals(result2,2148532270,'SCard List Readers failed.   If result is 8010002E (2148532270):'+
                                      ' No SCard readers were found on the system');
  WriteLn(Output,'Stop ListReaders');
end;

procedure UTWinSCardTests.TestSCardConnectA;
var
  length,result: ULONG;
  outpointer:  sCardContext;
  scHandle,ActiveProtocol:  longint;
  readerlength : integer;
  readerList,Str : string;
begin
  length := SCARD_AUTOALLOCATE;
  WriteLn(Output,'Start ConnectA');
  result := WinSCard.SCardEstablishContext(
            SCARD_SCOPE_USER,
            nil,nil,
            @outpointer);
  WinSCard.SCardListReadersA(outpointer,nil,nil,readerlength);
  setLength(readerList,readerLength);
  WinSCard.SCardListReadersA(outpointer,nil,pChar(readerList),readerlength);
  Str := StrPas(PChar(readerList));
  result := WinSCard.SCardConnectA(outpointer,
  pChar(Str),
  SCARD_SHARE_SHARED,
  3,
  scHandle,
  @ActiveProtocol);

  CheckEquals(result,2148532228,'SCardConnect a did not return success,2148532228' +
             'means an invalid parameter, likely due to ListReaders failing');
  WriteLn(Output,'Stop ConnectA');
end;

procedure UTWinSCardTests.TestSCardDisconnect;
var
  length,result: ULONG;
  outpointer:  sCardContext;
  scHandle,ActiveProtocol:  longint;
  readerlength : integer;
  readerList,Str : string;
begin
  length := SCARD_AUTOALLOCATE;
  WriteLn(Output,'Start Disconnect');
  result := WinSCard.SCardEstablishContext(
            SCARD_SCOPE_USER,
            nil,nil,
            @outpointer);
  WinSCard.SCardListReadersA(outpointer,nil,nil,readerlength);
  setLength(readerList,readerLength);
  WinSCard.SCardListReadersA(outpointer,nil,pChar(readerList),readerlength);
  Str := StrPas(PChar(readerList));
  result := WinSCard.SCardConnectA(outpointer,
  pChar(Str),
  SCARD_SHARE_SHARED,
  3,
  scHandle,
  @ActiveProtocol);
  result := WinSCard.SCardDisconnect(scHandle,SCARD_LEAVE_CARD);
  CheckEquals(result,6,'SCardDisconnect a did not return success, return of 6 is'+
              ' an Invalid handle message due to connect not returning success');
  WriteLn(Output,'Stop Disconnect');
end;

procedure UTWinSCardTests.TestSCardReconnect;
var
  length,result: ULONG;
  outpointer:  sCardContext;
  scHandle,ActiveProtocol:   longint;
  readerlength : integer;
  readerList,Str : string;
begin
  length := SCARD_AUTOALLOCATE;
  WriteLn(Output,'Start Reconnect');
  result := WinSCard.SCardEstablishContext(
            SCARD_SCOPE_USER,
            nil,nil,
            @outpointer);
  WinSCard.SCardListReadersA(outpointer,nil,nil,readerlength);
  setLength(readerList,readerLength);
  WinSCard.SCardListReadersA(outpointer,nil,pChar(readerList),readerlength);
  Str := StrPas(PChar(readerList));
  result := WinSCard.SCardConnectA(outpointer,
  pChar(Str),
  SCARD_SHARE_SHARED,
  3,
  scHandle,
  @ActiveProtocol);
  result := WinSCard.SCardReconnect(scHandle,
  SCARD_SHARE_SHARED,
  3,
  SCARD_LEAVE_CARD,
  ActiveProtocol);

  CheckEquals(result,6,'SCardReconnect a did not return success, return of 6 is'+
              ' an Invalid handle message due to connect not returning success');
  WriteLn(Output,'Stop Reconnect');
end;

begin
  UnitTest.addSuite(UTWinSCardTests.Suite);
end.