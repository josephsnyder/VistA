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
unit UTWcrypt2;
interface
uses UnitTest, TestFrameWork, Wcrypt2, SysUtils, Windows, Registry, Dialogs, Classes, Forms, Controls,
  StdCtrls, XuDsigConst;

implementation
type
UTWcrypt2Tests=class(TTestCase)
  private
  public
  procedure SetUp; override;
  procedure TearDown; override;

  published
    procedure TestCryptAcquireContext;
    procedure TestCryptReleaseContext;
    procedure TestCryptCreateHash;
    procedure TestCryptDestroyHash;
    procedure TestCryptHashData;
    procedure TestCryptGetHashParam;
    procedure TestCryptMsgOpenToDecode;
    procedure TestCryptMsgOpenToEncode;
    procedure TestCryptSignMessage;
    procedure TestCryptMsgUpdate;
    procedure TestCryptMsgGetParam;
    procedure TestCryptMsgControl;
    procedure TestCryptMsgClose;
    procedure TestCryptGetProvParam;
    procedure TestCryptSetProvParam;
    procedure TestCryptVerifyMessageSignature;
    procedure TestCryptGenKey;
    procedure TestCryptDestroyKey;
    procedure TestCertOpenSystemStore;
    procedure TestCryptEnumProvidersA;
    procedure TestCryptEnumProviderTypesA;
    procedure TestCryptGetDefaultProvider;
    procedure TestCryptDecodeObject;

    procedure TestCertGetCertificateChain;
    procedure TestCertOpenStore;
    procedure TestCertCloseStore;
    procedure TestCertEnumCertificatesInStore;
    procedure TestCertCreateCertificateChainEngine;
    procedure TestCertFreeCertificateContext;
    procedure TestCertFindCertificateInStore;
    procedure TestCertGetSubjectCertificateFromStore;
    procedure TestCertFindExtension;
    procedure TestCertVerifyTimeValidity;
    procedure TestCertGetNameString;
    procedure TestCertGetIntendedKeyUsage;
    procedure TestCertVerifyRevocation;

  end;

procedure UTWcrypt2Tests.SetUp;
begin
 end;

procedure UTWcrypt2Tests.TearDown;
begin
end;

function GetLastError():DWORD; external 'Kernel32.dll' name 'GetLastError';

procedure UTWcrypt2Tests.TestCryptAcquireContext();
var
  cspHandle : HCRYPTPROV;
  return : boolean;
begin
  WriteLn(Output,'Start AcquireContext');
  return := Wcrypt2.CryptAcquireContext(@cspHandle,NIL,NIL,1,0);
  //if(return = false) then WriteLn(Output,'Acquire' + IntToStr(GetLastError()));
  CheckEquals(True,return,'Acquire Context didnt return true');
    WriteLn(Output,'Stop AcquireContext');
  Wcrypt2.CryptReleaseContext(cspHandle,0);
  
  WriteLn(Output,'Start AcquireContextA');
  return := Wcrypt2.CryptAcquireContextA(@cspHandle,NIL,NIL,1,0);
  //if(return = false) then WriteLn(Output,'Acquire' + IntToStr(GetLastError()));
  CheckEquals(True,return,'Acquire Context didnt return true');
    WriteLn(Output,'Stop AcquireContext');
  Wcrypt2.CryptReleaseContext(cspHandle,0);
end;

procedure UTWcrypt2Tests.TestCryptReleaseContext();
var
  cspHandle : Cardinal;
  return : boolean;
begin
  WriteLn(Output,'Start ReleaseContext');
  cspHandle:=0;
  Wcrypt2.CryptAcquireContext(@cspHandle,NIL,NIL,1,0);
  //if(return = false) then WriteLn(Output,'Acquire' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptReleaseContext(cspHandle,0);
  //if(return = false) then WriteLn(Output,'Release' + IntToStr(GetLastError()));
  CheckEquals(True,return,'Release Context didnt return true');
    WriteLn(Output,'Stop ReleaseContext');
end;

procedure UTWcrypt2Tests.TestCertOpenSystemStore();
var
  Null: Variant;
  certStore:integer;
begin
  certStore := 0;
  WriteLn(Output,'Start OpenSystemStore');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'CA');
  CheckNotEquals(0,certStore,'OpenSystemStore Fails');
  WriteLn(Output,'Stop OpenSystemStore');
  Wcrypt2.CertCloseStore(certStore,0);
 
  certStore := 0; 
  WriteLn(Output,'Start OpenSystemStore');
  certStore := Wcrypt2.CertOpenSystemStoreA(Null,'CA');
  CheckNotEquals(0,certStore,'OpenSystemStore Fails');
  WriteLn(Output,'Stop OpenSystemStore');
  Wcrypt2.CertCloseStore(certStore,0);
end;

procedure UTWcrypt2Tests.TestCryptSetProvParam();
var
  str : string;
  cspHandle : Cardinal;
  return: boolean;
begin
  str :='TEST';
  Wcrypt2.CryptAcquireContext(@cspHandle,NIL,NIL,1,0);
  //if(return = false) then WriteLn(Output,'SProv' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptSetProvParam(cspHandle,1,@str,0);
  //if(return2 = false) then WriteLn(Output,'SProv' + IntToStr(GetLastError()));
  Wcrypt2.CryptReleaseContext(cspHandle,0);
  CheckEquals(True,return,'Set Prov Param didnt return true');
end;

procedure UTWcrypt2Tests.TestCryptCreateHash();
var
  cspHandle : Cardinal;
  return : boolean;
  cryptHash: Cardinal;
  lasterr: UInt64;
begin
  WriteLn(Output,'Start CreateHash');
  cspHandle:=0;
  return := Wcrypt2.CryptAcquireContext(@cspHandle,PChar(''),Pchar(''),1,0);
  if(not return) then WriteLn(Output,'Create Hash Acquire Context' + IntToStr(GetLastError()));
  return:= Wcrypt2.CryptCreateHash(cspHandle,$00008004, 0, 0, @cryptHash);
  if(not return) then WriteLn(Output,'Create Hash' + IntToStr(GetLastError()));
  CheckEquals(True,return,'Create Hash didnt return true');
  Wcrypt2.CryptReleaseContext(cspHandle,0);
  Wcrypt2.CryptDestroyHash(cryptHash);
  WriteLn(Output,'Stop CreateHash');
end;

procedure UTWcrypt2Tests.TestCryptDestroyHash();
var
  cspHandle,size : Cardinal;
  return : boolean;
  cryptHash,cryptGetData: Cardinal;
  lasterr: UInt64;
begin
  WriteLn(Output,'Start DestroyHash');
  cspHandle:=0;
  size:=100;
  return := Wcrypt2.CryptAcquireContext(@cspHandle,PChar(''),Pchar(''),1,0);
   if(not return) then WriteLn(Output,'Destroy Hash: Acquire Context ' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptCreateHash(cspHandle,$00008004, 0, 0, @cryptHash);
  if(not return) then WriteLn(Output,'Destroy Hash: Create Hash' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptDestroyHash(cryptHash);
  if(not return) then WriteLn(Output,'Destroy Hash' + IntToStr(GetLastError()));
  Wcrypt2.CryptReleaseContext(cspHandle,0);
  CheckEquals(True,return,'Destroy Hash didnt return true');
    WriteLn(Output,'Stop DestroyHash');
end;

procedure UTWcrypt2Tests.TestCryptGetHashParam();
var
  cspHandle,size : Cardinal;
  return: boolean;
  cryptHash,cryptGetData: Cardinal;
  lasterr: UInt64;
begin
  WriteLn(Output,'Start GetHashParam');
  cspHandle:=0;
  size:=100;
  return := CryptAcquireContext(@cspHandle,PChar(''),Pchar(''),1,0);
  if(not return) then WriteLn(Output,'GetHashParam: Acquire Context' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptCreateHash(cspHandle,$00008004, 0, 0, @cryptHash);
  if(not return) then WriteLn(Output,'GetHashParam: Create Hash' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptGetHashParam(cryptHash,$0001, @cryptGetData,@size,0);
  if(not return) then WriteLn(Output,'GetHashParam' + IntToStr(GetLastError()));
  CheckEquals(True,return,'Get Hash Param didnt return true');
  Wcrypt2.CryptReleaseContext(cspHandle,0);
  Wcrypt2.CryptDestroyHash(cryptHash);
  WriteLn(Output,'StopHashParam');
end;

procedure UTWcrypt2Tests.TestCryptHashData();
var
  cspHandle,size : Cardinal;
  return : boolean;
  cryptHash,cryptGetData: Cardinal;
  lasterr: UInt64;
begin
  WriteLn(Output,'Start CryptHashData');
  cspHandle:=0;
  size:=100;
  return := CryptAcquireContext(@cspHandle,PChar(''),Pchar(''),1,0);
  if(not return) then WriteLn(Output,'HashData: Acquire Context' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptCreateHash(cspHandle,$00008004, 0, 0, @cryptHash);
  if(not return) then WriteLn(Output,'HashData : CreateHash' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptHashData(cryptHash,@size,1,0);
  if(not return) then WriteLn(Output,'HashData' + IntToStr(GetLastError()));
  CheckEquals(True,return,'HashData didnt return true');
  Wcrypt2.CryptReleaseContext(cspHandle,0);
  Wcrypt2.CryptDestroyHash(cryptHash);
    WriteLn(Output,'Stop CryptHashData');
end;

procedure UTWcrypt2Tests.TestCryptGetProvParam();
var
  Null: Variant;
  cspHandle : Cardinal;
  return : boolean;
  name :array [0..1023] of char;
  blah : string;
  lasterr,length: DWORD;
begin
  WriteLn(Output,'Start GetProvParam');
  length := sizeof(name);
  return := Wcrypt2.CryptAcquireContext(@cspHandle,NIL,NIL,1,0);
  //if(return = false) then WriteLn(Output,'GProv 1 ' + IntToStr(GetLastError()));
  return := Wcrypt2.CryptGetProvParam(cspHandle,$5, @name,@length,0);
  //if(return = false) then WriteLn(Output,'GProv 3 ' + IntToStr(GetLastError()));
  CheckEquals(return,True,'GetProv didnt return true');
  Wcrypt2.CryptReleaseContext(cspHandle,0);
    WriteLn(Output,'Stop GetProvParam');
end;

procedure UTWcrypt2Tests.TestCryptMsgOpenToDecode();
var
  Null : Variant;
  foutput : HCRYPTMSG;
begin
  WriteLn(Output,'Start MsgOpentoDecode');
  foutput :=Wcrypt2.CryptMsgOpenToDecode(c_ENCODING_TYPE,0,0,Null,Nil,Nil);
  //if(output = Nil) then WriteLn(Output,'GProv 3 ' + IntToStr(GetLastError()));
  Check(Addr(foutput) <> nil, 'Msg Open to decode failed');
  CryptMsgClose(foutput);
  WriteLn(Output,'Stop MsgOpenoDecode');
end;

procedure UTWcrypt2Tests.TestCryptMsgOpenToEncode();
var
  Null : Variant;
  foutput : HCRYPTMSG;
begin
  WriteLn(Output,'Start MsgOpentoEncode');
  foutput :=Wcrypt2.CryptMsgOpenToEncode(c_ENCODING_TYPE,0,1, nil,Nil,Nil);
  //if(output = Nil) then WriteLn(Output,'GProv 3 ' + IntToStr(GetLastError()));
  Check(Addr(foutput) <> nil, 'Msg Open to Encode failed');
  CryptMsgClose(foutput);
  WriteLn(Output,'Stop MsgOpentoEncode');
end;

procedure UTWcrypt2Tests.TestCryptMsgClose();
var
  Null : Variant;
  foutput : HCRYPTMSG;
  result : boolean;
begin
  WriteLn(Output,'Start MsgClose');
  foutput :=Wcrypt2.CryptMsgOpenToDecode(c_ENCODING_TYPE,0,0,Null,Nil,Nil);
  //if(output = Nil) then WriteLn(Output,'Open Msg : ' + IntToStr(GetLastError()));
  result := Wcrypt2.CryptMsgClose(foutput);
  //if(result = false) then WriteLn(Output,'Close Msg:  ' + IntToStr(GetLastError()));
  CheckEquals(True,result,'Msg Close failed');
  WriteLn(Output,'Stop MsgClose');
end;

procedure UTWcrypt2Tests.TestCryptSignMessage();
var
  Null : Variant;
  foutput : HCRYPTMSG;
  result,keyout : boolean;
  para : CRYPT_SIGN_MESSAGE_PARA;
  CertContext: PCCERT_CONTEXT;
  lasterr,size: DWORD;
  certStore: HCERTSTORE;
  pSignerCert : PCCERT_CONTEXT;
  encodedblob : pCRYPT_DATA_BLOB;
  CryptProv :HCRYPTPROV;
  pbEncodedblob : array of byte;
  text  : string;
  pszNameString: pAnsiChar;
  pbContent :pByte;
  cbContent,keyspec : DWORD;
  rgpbToBeSigned : ppCharArray;
  rgcbToBeSigned : pDwordArray;

begin
  New(encodedblob);
  New(rgpbToBeSigned);
  New(rgcbToBeSigned);

  WriteLn(Output,'Start SignMessage');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  text := 'The quick brown fox jumps over the lazy dog.';
  pbContent := pByte(text);
  cbContent := length(text) + 1;
  
  foutput :=Wcrypt2.CryptMsgOpenToEncode(c_ENCODING_TYPE,0,
              1, nil,  Nil,  Nil);

  if(foutput = Nil) then WriteLn(Output,'Open Msg : ' + IntToStr(GetLastError()));
  //Set parameters for message signing, taken from XuDsigS.pas Line 884+

  para.cbSize :=sizeof(para);
  para.HashAlgorithm.pszObjId := szOID_RSA_SHA1RSA;

  para.pSigningCert := certContext;
  para.dwMsgEncodingType := c_ENCODING_TYPE;
  para.cMsgCert := 1;
  para.rgpMsgCert := @certContext;


  para.pvHashAuxInfo := nil;
  para.cMsgCrl := 0;
  para.rgpMsgCrl := nil;
  para.cAuthAttr := 0;
  para.rgAuthAttr := nil;
  para.cUnauthAttr := 0;
  para.rgUnauthAttr := nil;
  para.dwFlags := 0;
  para.dwInnerContentType:=0;
  para.HashAlgorithm.Parameters.cbData:=0;

  rgpbToBeSigned[0] := pbContent;
  rgcbToBeSigned[0] := cbContent;

  // The first call for the function passes a nil pointer to only acquire the
  // size of the blob that will contain the encoded message
  result := Wcrypt2.CryptSignMessage(
              @para,
              False,
              1,
              rgpbToBeSigned,
              rgcbToBeSigned,
              Nil,
              @encodedblob.cbData);
  if(result = false) then begin
      WriteLn(Output,'Sign Msg:  ' + IntToStr(GetLastError()));
  end;
  CheckEquals(True,result,'Msg Signing failed during size acquisition');
  setlength(pbEncodedBlob, encodedblob.cbData);
  //The second call actually performs the signing using the size from the
  // previous call of the function.
  result := Wcrypt2.CryptSignMessage(
             @para,
             False,
             1,
             rgpbToBeSigned,
             rgcbToBeSigned,
             pointer(pbEncodedBlob),
             @encodedblob.cbData);

  result := Wcrypt2.CryptMsgUpdate(foutput,pointer(pbEncodedblob),encodedblob.cbData,True);
  if(result = false) then begin
      WriteLn(Output,'Sign Msg:  ' + IntToStr(GetLastError()));
  end;
  CheckEquals(True,result,'Msg Signing failed during signing');
  Wcrypt2.CryptMsgClose(foutput);
  Wcrypt2.CertCloseStore(certStore,0);
  Wcrypt2.CertFreeCertificateContext(Certcontext);
  WriteLn(Output,'Stop SignMessage');
end;


procedure UTWcrypt2Tests.TestCryptMsgControl();
var
  Null : Variant;
  foutput : HCRYPTMSG;
  result : boolean;
  certStore: HCERTSTORE;
  CertContext: PCCERT_CONTEXT;
  lasterr: DWORD;
  blah : CRYPT_BIT_BLOB;
  pbContent :pByte;
  cbContent : DWORD;
  text : string;
  para : CRYPT_SIGN_MESSAGE_PARA;
  encodedBlob:PCRYPT_DATA_BLOB;
  pbEncodedBlob: array of byte;
  rgpbToBeSigned : ppCharArray;
  rgcbToBeSigned : pDwordArray;

begin
  WriteLn(Output,'Start MsgControl');
  New(encodedblob);
  New(rgpbToBeSigned);
  New(rgcbToBeSigned);

  WriteLn(Output,'Start MsgUpdate');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  text := 'The quick brown fox jumps over the lazy dog.';
  pbContent := pByte(text);
  cbContent := length(text) + 1;

  foutput :=Wcrypt2.CryptMsgOpenToDecode(c_ENCODING_TYPE,0,0,0,nil,nil) ;
  if(foutput = Nil) then WriteLn(Output,'Open Msg : ' + IntToStr(GetLastError()));

  //Set parameters for message signing, taken from XuDsigS.pas Line 884+
  para.cbSize :=sizeof(para);
  para.HashAlgorithm.pszObjId := szOID_RSA_SHA1RSA;
  para.pSigningCert := CertContext;
  para.dwMsgEncodingType := c_ENCODING_TYPE;
  para.cMsgCert := 1;
  para.rgpMsgCert := @CertContext;
  para.pvHashAuxInfo := nil;
  para.cMsgCrl := 0;
  para.rgpMsgCrl := nil;
  para.cAuthAttr := 0;
  para.rgAuthAttr := nil;
  para.cUnauthAttr := 0;
  para.rgUnauthAttr := nil;
  para.dwFlags := 0;
  para.dwInnerContentType:=0;
  para.HashAlgorithm.Parameters.cbData:=0;
  encodedblob.cbData := cbContent;
  rgpbToBeSigned[0] := pbContent;
  rgcbToBeSigned[0] := cbContent;


  // The first call for the function passes a nil pointer to only acquire the
  // size of the blob that will contain the encoded message
  result := Wcrypt2.CryptSignMessage(
              @para,
              False,
              1,
              rgpbToBeSigned,
              rgcbToBeSigned,
              Nil,
              @encodedblob.cbData);
   setlength(pbEncodedBlob, encodedblob.cbData);
  //The second call actually performs the signing using the size from the
  // previous call of the function.
 result := Wcrypt2.CryptSignMessage(
             @para,
             False,
             1,
             rgpbToBeSigned,
             rgcbToBeSigned,
             pointer(pbEncodedBlob),
             @encodedblob.cbData);

  result := Wcrypt2.CryptMsgUpdate(foutput,pointer(pbEncodedblob),encodedblob.cbData,True);

  result := Wcrypt2.CryptMsgControl(foutput,0, CMSG_CTRL_VERIFY_SIGNATURE ,CertContext.pCertInfo);
  if(result = false) then WriteLn(Output,'Msg Control:  ' + IntToStr(GetLastError()));
  CheckEquals(True,result,'Msg Control failed');
  Wcrypt2.CryptMsgClose(foutput);
  Wcrypt2.CertCloseStore(certStore,0);
  Wcrypt2.CertFreeCertificateContext(Certcontext);
  WriteLn(Output,'Stop MsgControl');
end;

 procedure UTWcrypt2Tests.TestCryptVerifyMessageSignature();
var

  Null : Variant;
  result,result1: boolean;
  para : CRYPT_SIGN_MESSAGE_PARA;
  CertContext: PCCERT_CONTEXT;
  lasterr,size,keySize: DWORD;
  certStore: HCERTSTORE;
  pSignerCert : PCCERT_CONTEXT;
  encodedblob : pCRYPT_DATA_BLOB;
  decodedblob : pCRYPT_DATA_BLOB;
  pbEncodedBlob: array of byte;
  pbDecodedBlob: array of byte;
  verifyPara  : CRYPT_VERIFY_MESSAGE_PARA;

  StoreArray: array of HCERTSTORE;
  text  : string;
  pszNameString: pAnsiChar;
  pbContent :pByte;
  cbContent,keyspec : DWORD;
  rgpbToBeSigned : ppCharArray;
  rgcbToBeSigned : pDwordArray;


begin
  New(encodedblob);
  New(decodedblob);
  New(rgpbToBeSigned);
  New(rgcbToBeSigned);

  WriteLn(Output,'Start Decrypt Message');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  text := 'The quick brown fox jumps over the lazy dog.';
  pbContent := pByte(text);
  cbContent := length(text) + 1;
  //Set parameters for message signing, taken from XuDsigS.pas Line 884+

  para.cbSize :=sizeof(para);
  para.HashAlgorithm.pszObjId := szOID_RSA_SHA1RSA;
  para.pSigningCert := CertContext;
  para.dwMsgEncodingType := c_ENCODING_TYPE;
  para.cMsgCert := 1;
  para.rgpMsgCert := @CertContext;
  para.pvHashAuxInfo := nil;
  para.cMsgCrl := 0;
  para.rgpMsgCrl := nil;
  para.cAuthAttr := 0;
  para.rgAuthAttr := nil;
  para.cUnauthAttr := 0;
  para.rgUnauthAttr := nil;
  para.dwFlags := 0;
  para.dwInnerContentType:=0;
  para.HashAlgorithm.Parameters.cbData:=0;

  rgpbToBeSigned[0] := pbContent;
  rgcbToBeSigned[0] := cbContent;


  // The first call for the function passes a nil pointer to only acquire the
  // size of the blob that will contain the encoded message
  result := Wcrypt2.CryptSignMessage(
              @para,
              False,
              1,
              rgpbToBeSigned,
              rgcbToBeSigned,
              Nil,
              @encodedblob.cbData);
  if(result = false) then begin
      WriteLn(Output,'Sign Msg:  ' + IntToStr(GetLastError()));
    end;
  CheckEquals(True,result,'Msg Signing failed during size acquisition');
  setlength(pbEncodedBlob, encodedblob.cbData);

  //The second call actually performs the signing using the size from the
  // previous call of the function.
 result := Wcrypt2.CryptSignMessage(
             @para,
             False,
             1,
             rgpbToBeSigned,
             rgcbToBeSigned,
             pointer(pbEncodedBlob),
             @encodedblob.cbData);
  if(result = false) then begin
      WriteLn(Output,'Sign Msg:  ' + IntToStr(GetLastError()));
    end;
  CheckEquals(True,result,' failed during signing');

  decodedblob.cbData:=0;
  verifyPara.cbSize :=sizeof(CRYPT_VERIFY_MESSAGE_PARA);
  verifyPara.dwMsgAndCertEncodingType := c_ENCODING_TYPE;
  verifyPara.hCryptProv := 0;
  verifyPara.pfnGetSignerCertificate:=nil;
  verifyPara.pvGetArg:=nil;

  result := Wcrypt2.CryptVerifyMessageSignature(@verifyPara,0,pointer(pbEncodedBlob),encodedblob.cbData,nil,@decodedblob.cbData,nil);
  if(result = false) then begin
      WriteLn(Output,'Decrypt Message:  ' + IntToStr(GetLastError()));
    end;
  setlength(pbDecodedBlob, decodedblob.cbData);
  result := Wcrypt2.CryptVerifyMessageSignature(
             @verifyPara,
             0,
             pointer(pbEncodedBlob),
             encodedblob.cbData,
             pointer(pbDecodedBlob),
             @decodedblob.cbData,
             nil);
  if(result = false) then begin
      WriteLn(Output,'Decrypt Message:  ' + IntToStr(GetLastError()));
  end;
  CheckEquals(text,pChar(pbDecodedblob),'Message decode did not return start string');
  Wcrypt2.CertFreeCertificateContext(Certcontext);
  Wcrypt2.CertCloseStore(Certstore,0);
  WriteLn(Output,'Start Decrypt Message');

end;
procedure UTWcrypt2Tests.TestCryptMsgUpdate();
var
  Null : Variant;
  foutput : HCRYPTMSG;
  result,keyout : boolean;
  para : CRYPT_SIGN_MESSAGE_PARA;
  CertContext: PCCERT_CONTEXT;
  lasterr,size: DWORD;
  certStore: HCERTSTORE;
  pSignerCert : PCCERT_CONTEXT;
  encodedblob : pCRYPT_DATA_BLOB;
  CryptProv :HCRYPTPROV;
  pbEncodedBlob: array of byte;

  text  : string;
  pszNameString: pAnsiChar;
  pbContent :pByte;
  cbContent,keyspec : DWORD;
  rgpbToBeSigned : ppCharArray;
  rgcbToBeSigned : pDwordArray;

begin
  New(encodedblob);
  New(rgpbToBeSigned);
  New(rgcbToBeSigned);

  WriteLn(Output,'Start MsgUpdate');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  text := 'The quick brown fox jumps over the lazy dog.';
  pbContent := pByte(text);
  cbContent := length(text) + 1;

  foutput :=Wcrypt2.CryptMsgOpenToEncode(c_ENCODING_TYPE,0,
              1, nil,  Nil,  Nil);

  if(foutput = Nil) then WriteLn(Output,'Open Msg : ' + IntToStr(GetLastError()));
  //Set parameters for message signing, taken from XuDsigS.pas Line 884+
   para.cbSize :=sizeof(para);
  para.HashAlgorithm.pszObjId := szOID_RSA_SHA1RSA;
  para.pSigningCert := CertContext;
  para.dwMsgEncodingType := c_ENCODING_TYPE;
  para.cMsgCert := 1;
  para.rgpMsgCert := @CertContext;
  para.pvHashAuxInfo := nil;
  para.cMsgCrl := 0;
  para.rgpMsgCrl := nil;
  para.cAuthAttr := 0;
  para.rgAuthAttr := nil;
  para.cUnauthAttr := 0;
  para.rgUnauthAttr := nil;
  para.dwFlags := 0;
  para.dwInnerContentType:=0;
  para.HashAlgorithm.Parameters.cbData:=0;
  encodedblob.cbData := cbContent;
  rgpbToBeSigned[0] := pbContent;
  rgcbToBeSigned[0] := cbContent;


  // The first call for the function passes a nil pointer to only acquire the
  // size of the blob that will contain the encoded message
  result := Wcrypt2.CryptSignMessage(
              @para,
              False,
              1,
              rgpbToBeSigned,
              rgcbToBeSigned,
              Nil,
              @encodedblob.cbData);
  setLength(pbEncodedblob,encodedblob.cbData);
  //The second call actually performs the signing using the size from the
  // previous call of the function.
 result := Wcrypt2.CryptSignMessage(
             @para,
             False,
             1,
             rgpbToBeSigned,
             rgcbToBeSigned,
             pointer(pbEncodedBlob),
             @encodedblob.cbData);

  result := Wcrypt2.CryptMsgUpdate(foutput,pointer(pbEncodedBlob),encodedblob.cbData,True);
  if(result = false) then begin
    WriteLn(Output,'Msg Update:  ' + IntToStr(GetLastError()));
  end;
  CheckEquals(True,result,'Msg Update Failed');
  Wcrypt2.CertFreeCertificateContext(Certcontext);
  Wcrypt2.CryptMsgClose(foutput);
  Wcrypt2.CertCloseStore(Certstore,0);
  WriteLn(Output,'Stop MsgUpdate');
end;

procedure UTWcrypt2Tests.TestCryptMsgGetParam();
var
  Null : Variant;
  foutput : HCRYPTMSG;
  result : boolean;
  decoded : DWORD;
  returnarray : array of byte;
  para : CRYPT_SIGN_MESSAGE_PARA;
  CertContext: PCCERT_CONTEXT;
  certStore: HCERTSTORE;
  pSignerCert : PCCERT_CONTEXT;
  encodedblob : pCRYPT_DATA_BLOB;
  CryptProv :HCRYPTPROV;
  pbEncodedBlob: array of byte;

  text  : string;
  pszNameString: pAnsiChar;
  pbContent :pByte;
  cbContent,numsigners : DWORD;
  rgpbToBeSigned : ppCharArray;
  rgcbToBeSigned : pDwordArray;

begin
  New(encodedblob);
  New(rgpbToBeSigned);
  New(rgcbToBeSigned);
  WriteLn(Output,'Start MsgGetParam');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  text := 'The quick brown fox jumps over the lazy dog.';
  pbContent := pByte(text);
  cbContent := length(text) + 1;

  foutput :=Wcrypt2.CryptMsgOpenToDecode(c_ENCODING_TYPE,0,
              0, 0,  Nil,  Nil);

  if(foutput = Nil) then WriteLn(Output,'Open Msg : ' + IntToStr(GetLastError()));
  //Set parameters for message signing, taken from XuDsigS.pas Line 884+
  para.cbSize :=sizeof(para);
  para.HashAlgorithm.pszObjId := szOID_RSA_SHA1RSA;
  para.pSigningCert := CertContext;
  para.dwMsgEncodingType := c_ENCODING_TYPE;
  para.cMsgCert := 1;
  para.rgpMsgCert := @CertContext;
  para.pvHashAuxInfo := nil;
  para.cMsgCrl := 0;
  para.rgpMsgCrl := nil;
  para.cAuthAttr := 0;
  para.rgAuthAttr := nil;
  para.cUnauthAttr := 0;
  para.rgUnauthAttr := nil;
  para.dwFlags := 0;
  para.dwInnerContentType:=0;
  para.HashAlgorithm.Parameters.cbData:=0;
  encodedblob.cbData := cbContent;
  rgpbToBeSigned[0] := pbContent;
  rgcbToBeSigned[0] := cbContent;


  // The first call for the function passes a nil pointer to only acquire the
  // size of the blob that will contain the encoded message
  result := Wcrypt2.CryptSignMessage(
              @para,
              False,
              1,
              rgpbToBeSigned,
              rgcbToBeSigned,
              Nil,
              @encodedblob.cbData);
  setLength(pbEncodedblob,encodedblob.cbData);
  //The second call actually performs the signing using the size from the
  // previous call of the function.
 result := Wcrypt2.CryptSignMessage(
             @para,
             False,
             1,
             rgpbToBeSigned,
             rgcbToBeSigned,
             pointer(pbEncodedBlob),
             @encodedblob.cbData);

  result := Wcrypt2.CryptMsgUpdate(foutput,pointer(pbEncodedBlob),encodedblob.cbData,True);
  if(result = false) then begin
    WriteLn(Output,'Msg Update:  ' + IntToStr(GetLastError()));
  end;
  CheckEquals(True,result,'Msg Update Failed');

  result := Wcrypt2.CryptMsgGetParam(foutput,CMSG_CONTENT_PARAM,0,nil,@decoded);
  if(result = false) then WriteLn(Output,'MSGGetParam2:  ' + IntToStr(GetLastError()));
  SetLength(returnarray,decoded);
  result := Wcrypt2.CryptMsgGetParam(foutput,CMSG_CONTENT_PARAM,0,pointer(returnarray),@decoded);
  if(result = false) then WriteLn(Output,'MSGGetParam2:  ' + IntToStr(GetLastError()));
  CheckEquals(pChar(returnarray),text,'Msg Get content Param failed');


  result := Wcrypt2.CryptMsgGetParam(foutput,CMSG_SIGNER_COUNT_PARAM,0,nil,@decoded);
  if(result = false) then WriteLn(Output,'MSGGetParam2:  ' + IntToStr(GetLastError()));
  SetLength(returnarray,decoded);
  result := Wcrypt2.CryptMsgGetParam(foutput,CMSG_SIGNER_COUNT_PARAM,0,@numsigners,@decoded);
  if(result = false) then WriteLn(Output,'MSGGetParam2:  ' + IntToStr(GetLastError()));
  CheckEquals(numsigners,1,'Msg Get number of signers Param failed');
  
  Wcrypt2.CertFreeCertificateContext(Certcontext);
  Wcrypt2.CryptMsgClose(foutput);
  Wcrypt2.CertCloseStore(Certstore,0);
  WriteLn(Output,'Stop MsgGetParam');
end;


procedure UTWcrypt2Tests.TestCryptGenKey();
var
  inkey: HKEY;
  result: boolean;
  cspHandle : HCRYPTPROV;
begin
  WriteLn(Output,'Start CryptGenKey');
  result := Wcrypt2.CryptAcquireContext(@cspHandle,PChar(''),Pchar(''),1,0);
  result := Wcrypt2.CryptGenKey(cspHandle, $00002400,0,@inkey);
  if(result = false) then WriteLn(Output,'Crypt GenKey1:  ' + IntToStr(GetLastError()));
  CheckEquals(True, result, 'CryptGenKey was Unsuccessful');
  WriteLn(Output,'Stop CryptGenerateKey');
  Wcrypt2.CryptDestroyKey(inkey);
end;


procedure UTWcrypt2Tests.TestCryptDestroyKey();
var
  inkey: HKEY;
  result: boolean;
  cspHandle : HCRYPTPROV;
begin
  WriteLn(Output,'Start CryptDestroyKey');
  result := Wcrypt2.CryptAcquireContext(@cspHandle,PChar(''),Pchar(''),1,0);
  result := Wcrypt2.CryptGenKey(cspHandle, $00002400,0,@inkey);
  if(result = false) then WriteLn(Output,'Crypt Destroy Key1:  ' + IntToStr(GetLastError()));
  result := Wcrypt2.CryptDestroyKey(inkey);
  if(result = false) then WriteLn(Output,'Crypt Destroy Key2:  ' + IntToStr(GetLastError()));
  CheckEquals(True, result, 'CryptDestroyKey was Unsuccessful');
  WriteLn(Output,'Stop CryptDestroyKey');
end;

procedure UTWcrypt2Tests.TestCryptDecodeObject();
var
 Null : Variant;
  foutput : HCRYPTMSG;
  result : boolean;
  decoded : DWORD;
  returnarray : array of byte;
  para : CRYPT_SIGN_MESSAGE_PARA;
  CertContext: PCCERT_CONTEXT;
  certStore: HCERTSTORE;
  pSignerCert : PCCERT_CONTEXT;
  encodedblob : pCRYPT_DATA_BLOB;
  decodedblob : pCRYPT_DATA_BLOB;
  CryptProv :HCRYPTPROV;
  pbEncodedBlob: array of byte;
  pbDecodedBlob: array of byte;

  text  : string;
  pszNameString: pAnsiChar;
  pbContent :pByte;
  cbContent,numsigners : DWORD;
  rgpbToBeSigned : ppCharArray;
  rgcbToBeSigned : pDwordArray;
  MsgContent : array of byte;

begin
  New(encodedblob);
  New(decodedblob);
  New(rgpbToBeSigned);
  New(rgcbToBeSigned);
  WriteLn(Output,'Start MsgGetParam');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  text := 'The quick brown fox jumps over the lazy dog.';
  pbContent := pByte(text);
  cbContent := length(text) + 1;

  foutput :=Wcrypt2.CryptMsgOpenToDecode(c_ENCODING_TYPE,0,
              0, 0,  Nil,  Nil);

  if(foutput = Nil) then WriteLn(Output,'Open Msg : ' + IntToStr(GetLastError()));
  //Set parameters for message signing, taken from XuDsigS.pas Line 884+
  para.cbSize :=sizeof(para);
  para.HashAlgorithm.pszObjId := szOID_RSA_SHA1RSA;
  para.pSigningCert := CertContext;
  para.dwMsgEncodingType := c_ENCODING_TYPE;
  para.cMsgCert := 1;
  para.rgpMsgCert := @CertContext;
  para.pvHashAuxInfo := nil;
  para.cMsgCrl := 0;
  para.rgpMsgCrl := nil;
  para.cAuthAttr := 0;
  para.rgAuthAttr := nil;
  para.cUnauthAttr := 0;
  para.rgUnauthAttr := nil;
  para.dwFlags := 0;
  para.dwInnerContentType:=0;
  para.HashAlgorithm.Parameters.cbData:=0;
  encodedblob.cbData := cbContent;
  rgpbToBeSigned[0] := pbContent;
  rgcbToBeSigned[0] := cbContent;


  // The first call for the function passes a nil pointer to only acquire the
  // size of the blob that will contain the encoded message
  result := Wcrypt2.CryptSignMessage(
              @para,
              False,
              1,
              rgpbToBeSigned,
              rgcbToBeSigned,
              Nil,
              @encodedblob.cbData);
  setLength(pbEncodedblob,encodedblob.cbData);
  //The second call actually performs the signing using the size from the
  // previous call of the function.
 result := Wcrypt2.CryptSignMessage(
             @para,
             False,
             1,
             rgpbToBeSigned,
             rgcbToBeSigned,
             pointer(pbEncodedBlob),
             @encodedblob.cbData);

  result := Wcrypt2.CryptDecodeObject(
  c_ENCODING_TYPE,
  PKCS_CONTENT_INFO	,
  pointer(pbEncodedBlob),
  encodedblob.cbData,
  CRYPT_DECODE_NOCOPY_FLAG,
  nil,
  @decoded);
  if(result = false) then
     WriteLn(Output,'CryptDecodeObject1:  ' + IntToStr(GetLastError()));
  SetLength(MsgContent,decoded);
  result := Wcrypt2.CryptDecodeObject(c_ENCODING_TYPE,
  PKCS_CONTENT_INFO,
  pointer(pbEncodedBlob),
  encodedblob.cbData,
  CRYPT_DECODE_NOCOPY_FLAG,
  pointer(MsgContent),
  @decoded );
  if(result = false) then
     WriteLn(Output,'CryptDecodeObject2:  ' + IntToStr(GetLastError()));
//  Check
  Wcrypt2.CertFreeCertificateContext(Certcontext);
  Wcrypt2.CryptMsgClose(foutput);
  Wcrypt2.CertCloseStore(Certstore,0);
end;


procedure UTWcrypt2Tests.TestCryptGetDefaultProvider();
var
  null :variant;
  cBName:DWORD;
  dwType:DWORD;
  result: boolean;
  proName: array of Char;
begin
  WriteLn(Output,'Start GetDefaultProvider');
  result := Wcrypt2.CryptGetDefaultProviderA(PROV_RSA_FULL,null,$00000001,nil,@cbName);
  if(result = false) then WriteLn(Output,'CryptGetDefaultProvider 1:  ' + IntToStr(GetLastError()));
  setLength(proName,cbName);
  result := Wcrypt2.CryptGetDefaultProviderA(PROV_RSA_FULL,null,$00000001,pointer(proName),@cbName);
  if(result = false) then WriteLn(Output,'CryptGetDefaultProvider 2:  ' + IntToStr(GetLastError()));
  CheckEquals(pChar(proName),'Microsoft Strong Cryptographic Provider',
             'EnumGetDefaultProvider returned a different provider');
  WriteLn(Output,'Stop CryptGetDefaultProvider');
end;

procedure UTWcrypt2Tests.TestCryptEnumProvidersA();
var
  cBName:DWORD;
  dwType:DWORD;
  dwIndex:DWORD;
  result: boolean;
  proName: array of Char;
begin
  WriteLn(Output,'Start EnumProviders');
  dwIndex:=0;
  result := Wcrypt2.CryptEnumProvidersA(dwIndex,nil,0, @dwType,nil,@cbName);
  if(result = false) then WriteLn(Output,'CryptEnumProviders 1:  ' + IntToStr(GetLastError()));
  setLength(proName,cbName);
  result := Wcrypt2.CryptEnumProvidersA(dwIndex,nil,0, @dwType,pointer(proName),@cbName);
  if(result = false) then WriteLn(Output,'CryptEnumProviders 2:  ' + IntToStr(GetLastError()));
  CheckEquals(pChar(proName),'Microsoft Base Cryptographic Provider v1.0',
             'EnumProvidersA returned a different provider');
  WriteLn(Output,'Stop EnumProviders');
end;

procedure UTWcrypt2Tests.TestCryptEnumProviderTypesA();
var
  cBName:DWORD;
  dwType:DWORD;
  dwIndex:DWORD;
  result: boolean;
  proType: array of Char;
begin
  WriteLn(Output,'Start EnumProviderTypes');
  dwIndex:=0;
  result := Wcrypt2.CryptEnumProviderTypesA(dwIndex,nil,0, @dwType,nil,@cbName);
  if(result = false) then WriteLn(Output,'CryptEnumProviderType 1:  ' + IntToStr(GetLastError()));
    setLength(proType,cbName);
  result := Wcrypt2.CryptEnumProviderTypesA(dwIndex,nil,0, @dwType,pointer(proType),@cbName);
  if(result = false) then WriteLn(Output,'CryptEnumProviderType 2: ' + IntToStr(GetLastError()));
  CheckEquals(pChar(proType),'RSA Full (Signature and Key Exchange)',
             'EnunProviderTypesA returned a different provider type');
  WriteLn(Output,'Stop EnumProviderTypes');
end;

procedure UTWcrypt2Tests.TestCertCreateCertificateChainEngine();
var
  config: CERT_CHAIN_ENGINE_CONFIG;
  engine: HCERTCHAINENGINE;
  result: boolean;
begin
  WriteLn(Output,'Start CreateCertificateChainEngine');
  config.cbSize := sizeof(CERT_CHAIN_ENGINE_CONFIG);
  config.hRestrictedRoot := 0;
  config.hRestrictedTrust := 0;
  config.hRestrictedOther := 0;
  config.cAdditionalStore := 0;
  config.rghAdditionalStore := 0;
  config.dwFlags := CERT_CHAIN_REVOCATION_CHECK_CHAIN;
  config.dwUrlRetrievalTimeout := 30000;
  config.MaximumCachedCertificates := 0;
  config.CycleDetectionModulus := 0;
  result := Wcrypt2.CertCreateCertificateChainEngine(@config,engine);
  if(result= false) then WriteLn(Output,'Certificate Create  ' + IntToStr(GetLastError()));
  CheckEquals(True,result,'CreateCertificateChainEngine failed');
  Wcrypt2.CertFreeCertificateChainEngine(engine);
    WriteLn(Output,'Stop CreateCertificateChainEngine');
end;

procedure UTwcrypt2Tests.TestCertFreeCertificateContext();
var
  Null : Variant;
  certStore: HCERTSTORE;
  context: PCCERT_CONTEXT;
  result: boolean;
begin
  WriteLn(Output,'Start Free Certificate Context');
  certStore := Wcrypt2.CertOpenSystemStore(Null, 'MY');
  context := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  result := Wcrypt2.CertFreeCertificateContext(context);
  if(result = false) then WriteLn(Output,'CertFreeCertificateContext' + IntToStr(GetLastError()));
  WriteLn(Output,'Stop Free Certificate Context');
  Wcrypt2.CertCloseStore(certStore,0);
end;

procedure UTWcrypt2Tests.TestCertGetCertificateChain();
var
  null: Variant;
  config: CERT_CHAIN_ENGINE_CONFIG;
  engine: HCERTCHAINENGINE;
  certStore: HCERTSTORE;
  CertContext: PCCERT_CONTEXT;
  chaincontext : PCCERT_CHAIN_CONTEXT;
  result: boolean;
  EnhkeyUsage: CERT_ENHKEY_USAGE;
  CertUsage: CERT_USAGE_MATCH;
  ChainPara: CERT_CHAIN_PARA;
begin

  WriteLn(Output,'Start GetCertficateChain');
  EnhkeyUsage.cUsageIdentifier := 0;
  EnhkeyUsage.rgpszUsageIdentifier := nil;
  CertUsage.dwType := USAGE_MATCH_TYPE_AND;
  CertUsage.Usage := EnhkeyUsage;
  ZeroMemory(@chainPara, sizeof(CERT_CHAIN_PARA));
  ChainPara.cbSize := sizeof(CERT_CHAIN_PARA);
  ChainPara.RequestedUsage := CertUsage;

  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');

  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);

  config.cbSize := sizeof(CERT_CHAIN_ENGINE_CONFIG);
  config.hRestrictedRoot := 0;
  config.hRestrictedTrust := 0;
  config.hRestrictedOther := 0;
  config.cAdditionalStore := 0;
  config.rghAdditionalStore := 0;
  config.dwFlags := CERT_CHAIN_REVOCATION_CHECK_CHAIN;
  config.dwUrlRetrievalTimeout := 30000;
  config.MaximumCachedCertificates := 0;
  config.CycleDetectionModulus := 0;

  result := Wcrypt2.CertCreateCertificateChainEngine(@config,engine);

  if(result= false) then WriteLn(Output,'Certificate Chain Engine Create  ' + IntToStr(GetLastError()));

  result := Wcrypt2.CertGetCertificateChain(engine,
  CertContext,
  nil,
  null,
  @ChainPara,
  CERT_CHAIN_CACHE_END_CERT,
  nil,
  chaincontext);


  if(result= false) then WriteLn(Output,'Certificate Get  ' + IntToStr(GetLastError()));
  CheckEquals(True,result,'GetCertificateChain failed');
  WriteLn(Output,'Stop GetCertificateChain');
  
  wCrypt2.CertFreeCertificateContext(CertContext);
  Wcrypt2.CertFreeCertificateChain(chainContext);
  Wcrypt2.CertCloseStore(certStore,0);

end;

procedure UTWcrypt2Tests.TestCertGetNameString();
var
  null:variant;
  result:LongBool;
  certStore:HCERTSTORE;
  CertContext:PCCERT_CONTEXT;
  outname:string ;
  pbDecoded: array of byte;
begin
  WriteLn(Output,'Start CertGetNameString');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  result := Wcrypt2.CertGetNameString(CertContext,CERT_NAME_SIMPLE_DISPLAY_TYPE,0,0,pointer(outname),256);
  if(result) then WriteLn(Output,'CertGetNameString ' + IntToStr(GetLastError()));
  Check(result,'CertGetNameString returned zero');
  Wcrypt2.CertCloseStore(certStore,0);
  WriteLn(Output,'Stop CertGetNameString');
end;

procedure UTWcrypt2Tests.TestCertFindCertificateInStore();
var
 CertStore:HCERTSTORE;
 null: variant;
 context,result: PCCERT_CONTEXT;
begin
  WriteLn(Output,'Start FindCertificateInStore');
  context:=nil;
  certStore := Wcrypt2.CertOpenSystemStore(Null,'CA');
  result := Wcrypt2.CertFindCertificateInStore(certStore,c_ENCODING_TYPE,0,CERT_FIND_ANY,nil,context) ;
  if(result= nil) then WriteLn(Output,'CertFindCertificate ' + IntToStr(GetLastError()));
  Check(result <> nil,'Cert Find Certificate in store returned nothing');
  WriteLn(Output,'Stop FindCertificateInStore');
  Wcrypt2.CertCloseStore(certStore,0);
end;

procedure UTWcrypt2Tests.TestCertVerifyTimeValidity();
var
  null:variant;
  result:ShortInt;
  certStore:HCERTSTORE;
  CertContext:PCCERT_CONTEXT;
  Ftime:FILETIME;

begin
  WriteLn(Output,'Start CertVerifyTimeValidity');
  {
  * For a Human readable date for each value,
  * Add to var:  Stime:SYSTEMTIME;
  * then use the following function to convert the FTime variable
  *
  *      FileTimeToSystemTime(Ftime,Stime);
  }

  certStore := Wcrypt2.CertOpenSystemStore(Null,'CA');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  //Change the "filetime" to be just before the NotAfter time
  Ftime.dwLowDateTime:=CertContext.pCertInfo.NotAfter.dwLowDateTime div 2  ;
  Ftime.dwHighDateTime:=CertContext.pCertInfo.NotAfter.dwHighDateTime ;
  result := Wcrypt2.CertVerifyTimeValidity(@Ftime,CertContext.pCertInfo);

  CheckEquals(result,0,'CertVerifyTime did not return as exected: 0 (Expected)');

    //Change the "filetime" to be before the NotBefore time
  Ftime.dwLowDateTime:=CertContext.pCertInfo.NotAfter.dwLowDateTime ;
  Ftime.dwHighDateTime:=CertContext.pCertInfo.NotAfter.dwHighDateTime div 2  ;
  result := Wcrypt2.CertVerifyTimeValidity(@Ftime,CertContext.pCertInfo);

  CheckEquals(result,-1,'CertVerifyTime did not return as exected: -1 (Expected)');

    //Change the "filetime" to be far after the NotAfter  time
  Ftime.dwLowDateTime:=CertContext.pCertInfo.NotAfter.dwLowDateTime;
  Ftime.dwHighDateTime:=CertContext.pCertInfo.NotAfter.dwHighDateTime * 2  ;
  result := Wcrypt2.CertVerifyTimeValidity(@Ftime,CertContext.pCertInfo);
  CheckEquals(result,1,'CertVerifyTime did not return as expected: 1 (Expected)');
  WriteLn(Output,'Stop CertVerifyTimeValidity');
  Wcrypt2.CertCloseStore(certStore,0);
end;

procedure UTWcrypt2Tests.TestCertFindExtension();
var
  null:variant;
  result:ShortInt;
  certStore:HCERTSTORE;
  CertContext:PCCERT_CONTEXT;
  extension : PCERT_EXTENSION;
begin
  WriteLn(Output,'Start CertFindExtension');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'CA');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);

  extension := Wcrypt2.CertFindExtension(PChar('2.5.29.31'),
                        CertContext.pCertInfo.cExtension,
                        CertContext.pCertInfo.rgExtension);

 if(CertContext.pCertInfo.cExtension > 0) then
   begin
     Check(extension <> nil , 'CertEnumCertificates failed');
   end
 else
   begin
     Check(extension = nil , 'CertEnumCertificates failed');
   end;


  WriteLn(Output,'Stop CertFindExtension');
end;

procedure UTWcrypt2Tests.TestCertGetSubjectCertificateFromStore();
var
  null:variant;
  certStore:HCERTSTORE;
  CertContext: PCCERT_CONTEXT;
  subjectInfo : array of DWORD;
  newContext : PCCERT_CONTEXT;
  foutput : HCRYPTMSG;
  result,keyout : boolean;
  para : CRYPT_SIGN_MESSAGE_PARA;
  lasterr,size: DWORD;
  pSignerCert : PCCERT_CONTEXT;
  encodedblob : pCRYPT_DATA_BLOB;
  CryptProv :HCRYPTPROV;
  pbEncodedblob : array of byte;
  text  : string;
  pszNameString: pAnsiChar;
  pbContent :pByte;
  cbContent,keyspec : DWORD;
  rgpbToBeSigned : ppCharArray;
  rgcbToBeSigned : pDwordArray;

begin
  New(encodedblob);
  New(rgpbToBeSigned);
  New(rgcbToBeSigned);

  WriteLn(Output,'Start SignMessage');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'MY');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  text := 'The quick brown fox jumps over the lazy dog.';
  pbContent := pByte(text);
  cbContent := length(text) + 1;
  
  foutput :=Wcrypt2.CryptMsgOpenToDecode(c_ENCODING_TYPE,0,
              0, 0,  Nil,  Nil);

  if(foutput = Nil) then WriteLn(Output,'Open Msg : ' + IntToStr(GetLastError()));
  //Set parameters for message signing, taken from XuDsigS.pas Line 884+

  para.cbSize :=sizeof(para);
  para.HashAlgorithm.pszObjId := szOID_RSA_SHA1RSA;

  para.pSigningCert := certContext;
  para.dwMsgEncodingType := c_ENCODING_TYPE;
  para.cMsgCert := 1;
  para.rgpMsgCert := @certContext;


  para.pvHashAuxInfo := nil;
  para.cMsgCrl := 0;
  para.rgpMsgCrl := nil;
  para.cAuthAttr := 0;
  para.rgAuthAttr := nil;
  para.cUnauthAttr := 0;
  para.rgUnauthAttr := nil;
  para.dwFlags := 0;
  para.dwInnerContentType:=0;
  para.HashAlgorithm.Parameters.cbData:=0;

  rgpbToBeSigned[0] := pbContent;
  rgcbToBeSigned[0] := cbContent;

  // The first call for the function passes a nil pointer to only acquire the
  // size of the blob that will contain the encoded message
  result := Wcrypt2.CryptSignMessage(
              @para,
              False,
              1,
              rgpbToBeSigned,
              rgcbToBeSigned,
              Nil,
              @encodedblob.cbData);
  if(result = false) then begin
      WriteLn(Output,'Sign Msg:  ' + IntToStr(GetLastError()));
  end;
  CheckEquals(True,result,'Msg Signing failed during size acquisition');
  setlength(pbEncodedBlob, encodedblob.cbData);
  //The second call actually performs the signing using the size from the
  // previous call of the function.
  result := Wcrypt2.CryptSignMessage(
             @para,
             False,
             1,
             rgpbToBeSigned,
             rgcbToBeSigned,
             pointer(pbEncodedBlob),
             @encodedblob.cbData);

  result := Wcrypt2.CryptMsgUpdate(foutput,pointer(pbEncodedblob),encodedblob.cbData,True);
  result := Wcrypt2.CryptMsgGetParam(foutput,CMSG_SIGNER_CERT_INFO_PARAM,0,nil,@size);
  if(result = False) then WriteLn(Output,'CertFindCertificate ' + IntToStr(GetLastError()));
  setLength(subjectInfo,size);  
  result := Wcrypt2.CryptMsgGetParam(foutput,CMSG_SIGNER_CERT_INFO_PARAM,0,subjectInfo,@size);

  if(result = False) then WriteLn(Output,'CertFindCertificate ' + IntToStr(GetLastError()));

  newContext := Wcrypt2.CertGetSubjectCertificateFromStore(certStore,c_ENCODING_TYPE,pointer(subjectInfo)) ;
  if(newContext = nil) then WriteLn(Output,'CertFindCertificate ' + IntToStr(GetLastError()));
  Check(newContext <> nil,'The found context doesnt match the one used to sign');
  Wcrypt2.CertFreeCertificateContext(CertContext);
  Wcrypt2.CertFreeCertificateContext(newContext);
  Wcrypt2.CryptMsgClose(foutput);
  Wcrypt2.CertCloseStore(Certstore,0);
end;

procedure UTWcrypt2Tests.TestCertVerifyRevocation();
var
  null:variant;
  Result : boolean;
  RevStatus: CERT_REVOCATION_STATUS;
  RevPara: CERT_REVOCATION_PARA;
  rgpvContext: array[0..3] of pointer;
  i: integer;
  prgp: PPVOID;
  cContext: DWORD;
  certStore:HCERTSTORE;
  CertContext: PCCERT_CONTEXT;

  //taken from Lines 462-520 of XuDSigS.pas
begin
  certStore := Wcrypt2.CertOpenSystemStore(null,pCHar('MY'));
  CertContext := Wcrypt2.CertEnumCertificatesInStore(CertStore, nil);
  ZeroMemory(@RevPara,sizeof(CERT_REVOCATION_PARA));
  Zeromemory(@RevStatus,sizeof(CERT_REVOCATION_STATUS));
  RevPara.cbSize := sizeof(RevPara);
  RevStatus.cbSize := sizeof(RevStatus);
  RevStatus.dwIndex := 0;
  RevStatus.dwError := 0;
  for i := 0 to 3 do
    rgpvContext[i] := nil;
  rgpvContext[0] := CertContext;
  cContext := 1;
  prgp := @(rgpvContext[0]);
  Result := CertVerifyRevocation( c_ENCODING_TYPE,
                                  CERT_CONTEXT_REVOCATION_TYPE,
                                  cContext,
                                  prgp,
                                  CERT_VERIFY_REV_SERVER_OCSP_FLAG,  // was CERT_VERIFY_REV_CHAIN_FLAG,
                                  nil,
                                  @RevStatus);
  if(result = False) then WriteLn(Output,'CertVerifyRevocation ' +
                                      IntToStr(GetLastError()));
  CheckEquals(RevStatus.dwError, 2148081684, 'The test did not return that the certificate' +
                                             'was not found in the revocation data');

end;

procedure UTWcrypt2Tests.TestCertEnumCertificatesInStore();
var
  Null: Variant;
  certStore: HCERTSTORE;
  CertContext: PCCERT_CONTEXT;
  lasterr: DWORD;
begin
  WriteLn(Output,'Start CertEnumCertificates');
  certStore := Wcrypt2.CertOpenSystemStore(Null,'CA');
  CertContext := Wcrypt2.CertEnumCertificatesInStore(certStore,NIL);
  Check(CertContext.pCertInfo <> nil , 'CertEnumCertificates failed');
  WriteLn(Output,'Stop CertEnumCertificates');
  Wcrypt2.CertCloseStore(certStore,0);
end;

procedure UTWcrypt2Tests.TestCertGetIntendedKeyUsage();
var
  Null: Variant;
  certStore: HCERTSTORE;
  CertContext: PCCERT_CONTEXT;
  return:bool;
  by : byte;
begin
  WriteLn(Output,'Start GetIntendedKeyUsage');
  certStore := Wcrypt2.CertOpenSystemStore(0,'CA');
  Certcontext := Wcrypt2.CertEnumCertificatesInStore(certStore,nil);
  return := Wcrypt2.CertGetIntendedKeyUsage(c_ENCODING_TYPE,certcontext.pCertInfo, @by, 1);
  if(return= false) then WriteLn(Output,'CertGetIntendedKeyUsage  ' + IntToStr(GetLastError()));
  CheckEquals(by,134,'Get Intended Usage failed');
  return := Wcrypt2.CertCloseStore(certStore,0);
  WriteLn(Output,'Stop GetIntendedKeyUsage');
end;

procedure UTWcrypt2Tests.TestCertOpenStore();
var
    Null: Variant;
    result :HCERTSTORE;
    foutput: HCRYPTMSG;
begin
  WriteLn(Output,'Start OpenStore');
  result := Wcrypt2.CertOpenStore(CERT_STORE_PROV_MEMORY,0,Null, CERT_STORE_READONLY_FLAG ,nil);
  if(result = 0)  then WriteLn(Output,'Cert OS ' + IntToStr(GetLastError()));
  CheckNotEquals(result,0,'OpenStore didnt return true');

  WriteLn(Output,'Stop OpenStore');
  Wcrypt2.CertCloseStore(result,0);
end;
procedure UTWcrypt2Tests.TestCertCloseStore();
var
  Null: Variant;
  result :HCERTSTORE;
  return:boolean;
begin
  WriteLn(Output,'Start CloseStore');
  result := Wcrypt2.CertOpenStore(CERT_STORE_PROV_MEMORY,0,Null, CERT_STORE_READONLY_FLAG ,nil);
  //if(result = Null)  then WriteLn(Output,'Cert CS open ' + IntToStr(GetLastError()));
  return := Wcrypt2.CertCloseStore(result,0);
  //if(not return1) then WriteLn(Output,'CertCS close' + IntToStr(GetLastError()));
  CheckEquals(True,return,'CloseStore didnt return true');
  
 
  result := Wcrypt2.CertOpenSystemStore(Null,'CA');
  return := Wcrypt2.CertCloseStore(result,0);
  CheckEquals(True,return,'CertCloseStore failed');

  WriteLn(Output,'Stop CloseStore');
end;

begin
UnitTest.addSuite(UTWcrypt2Tests.Suite);
end.