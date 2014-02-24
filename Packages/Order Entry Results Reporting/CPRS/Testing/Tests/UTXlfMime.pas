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
unit UTXlfMime;
interface
uses UnitTest, TestFrameWork, XlfMime,SysUtils, Windows, Registry, Dialogs, Classes, Forms, Controls,
  StdCtrls;

implementation
type
UTXlfMimeTests=class(TTestCase)
  private
  public
  procedure SetUp; override;
  procedure TearDown; override;

  published
    procedure TestMimeEncodedSize;
    procedure TestMimeEncode;
    procedure TestMimeEncodeString;
    procedure TestMimeDecode;
    procedure TestMimeDecodeString;
  end;

procedure UTXlfMimeTests.SetUp;
begin
 end;

procedure UTXlfMimeTests.TearDown;
begin
end;

procedure UTXlfMimeTests.TestMimeEncodedSize;
var 
  test : integer;
  blah : Cardinal;
begin
  test:=10;
  blah := XlfMime.MimeEncodedSize(test);
  CheckEquals(16,blah,'MimeFunction for value'+ IntToStr(test) +' hasnt returned correctly');

  test:=15;
  blah := XlfMime.MimeEncodedSize(test);
  CheckEquals(20,blah,'MimeFunction for value'+ IntToStr(test) +' hasnt returned correctly');
 
  test:=500;
  blah := XlfMime.MimeEncodedSize(test);
  CheckEquals(668,blah,'MimeFunction for value'+ IntToStr(test) +' hasnt returned correctly');
end;
procedure UTXlfMimeTests.TestMimeEncode;
var 
  hashVal: array of byte;
  hashStr: string;
  dwlen :  Cardinal;
  i  : integer;
begin
  dwlen   :=10;
  hashStr :='';
  SetLength(hashVal,dwlen);
  SetLength(hashStr, XlfMime.MimeEncodedSize(dwlen));
  for i := 0 to dwLen - 1 do
  begin
    hashVal[i] :=i;
  end;
  XlfMime.MimeEncode(PChar(hashVal)^,dwlen,  PChar(hashStr)^);
  CheckEquals('AAECAwQFBgcICQ==',hashStr,'MimeEncode hasnt returned correctly1');

  dwlen   :=10;
  hashStr :='';
  SetLength(hashVal,dwlen);
  SetLength(hashStr, XlfMime.MimeEncodedSize(dwlen));
  for i := 0 to dwLen - 1 do hashVal[i] :=i*2;
  XlfMime.MimeEncode(PChar(hashVal)^,dwlen,  PChar(hashStr)^);
  CheckEquals('AAIEBggKDA4QEg==',hashStr,'MimeEncode hasnt returned correctly2');

  dwlen   :=10;
  hashStr :='';
  SetLength(hashVal,dwlen);
  SetLength(hashStr, XlfMime.MimeEncodedSize(dwlen));
  for i := 0 to dwLen - 1 do hashVal[i] :=i*3;
  XlfMime.MimeEncode(PChar(hashVal)^,dwlen,  PChar(hashStr)^);
  CheckEquals('AAMGCQwPEhUYGw==',hashStr,'MimeEncode hasnt returned correctly3');

  dwlen   :=15;
  hashStr :='';
  SetLength(hashVal,dwlen);
  SetLength(hashStr, XlfMime.MimeEncodedSize(dwlen));
  for i :=  0 to dwlen-1  do hashVal[i] :=i;
  XlfMime.MimeEncode(PChar(hashVal)^,dwlen,  PChar(hashStr)^);
  CheckEquals('AAECAwQFBgcICQoLDA0O',hashStr,'MimeEncode hasnt returned correctly4');

  dwlen   :=15;
  hashStr :='';
  SetLength(hashVal,dwlen);
  SetLength(hashStr, XlfMime.MimeEncodedSize(dwlen));
  for i := 0 to dwlen-1  do hashVal[i] :=(i+2)*12;
  XlfMime.MimeEncode(PChar(hashVal)^,dwlen,  PChar(hashStr)^);
  CheckEquals('GCQwPEhUYGx4hJCcqLTA',hashStr,'MimeEncode hasnt returned correctly5');

  dwlen   :=100;
  hashStr :='';
  SetLength(hashVal,dwlen);
  SetLength(hashStr, XlfMime.MimeEncodedSize(dwlen));
  for i := 0 to dwlen-1  do hashVal[i] :=(i+2)*2;
  XlfMime.MimeEncode(PChar(hashVal)^,dwlen,  PChar(hashStr)^);
  CheckEquals('BAYICgwOEBIUFhgaHB4gIiQmKCosLjAyNDY4Ojw+QEJERkhKTE5QUlRWWFpcXmBiZGZoamxucHJ0dnh6fH6AgoSGiIqMjpCSlJaYmpyeoKKkpqiqrK6wsrS2uLq8vsDCxMbIyg=='
  ,hashStr,'MimeEncode hasnt returned correctly6');
end;

procedure UTXlfMimeTests.TestMimeEncodeString;
  var
    outstring:string;
  const
    test = 'blah';
  begin
    outstring := XlfMime.MimeEncodeString(test);
    CheckEquals('YmxhaA==',outstring,'Mime Encode String didnt return correctly');

    outstring := XlfMime.MimeEncodeString('This is a longer string');
    CheckEquals('VGhpcyBpcyBhIGxvbmdlciBzdHJpbmc=',outstring,'Mime Encode String didnt return correctly');
  end;


procedure UTXlfMimeTests.TestMimeDecode;
  var
    outstring:string;
  begin
     outstring := XlfMime.MimeDecode('YmxhaA==');
     CheckEquals('blah',outstring,'Mime Decode didt return correcly');

     outstring := XlfMime.MimeDecode('VGhpcyBpcyBhIGxvbmdlciBzdHJpbmc=');
     CheckEquals('This is a longer string',outstring,'Mime Decode didt return correcly');

  end;


procedure UTXlfMimeTests.TestMimeDecodeString;
  var
    outstring,instring:string;
  begin
     outstring := XlfMime.MimeDecodeString('YmxhaA==');
     CheckEquals('blah',outstring,'Mime Decode didt return correcly');

     outstring := XlfMime.MimeDecodeString('VGhpcyBpcyBhIGxvbmdlciBzdHJpbmc=');
     CheckEquals('This is a longer string',outstring,'Mime Decode didt return correcly');
  end;

begin
UnitTest.addSuite(UTXlfMimeTests.Suite);
end.