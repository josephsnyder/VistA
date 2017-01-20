library OrderCom;

uses
  ComServ,
  OrderComIntf in '@SOURCE@\OrderComIntf.pas' {BcmaOrder: CoClass},
  uBcmaOrder in '@SOURCE@\BcmaCom-Orders\uBcmaOrder.pas',
  fOCAccept in '@SOURCE@\BcmaCom-Orders\fOCAccept.pas',
  fAutoSz in '@SOURCE@\BcmaCom-Orders\fAutoSz.pas' {frmAutoSz},
  fODMedFA in '@SOURCE@\BcmaCom-Orders\fODMedFA.pas',
  fODMedIV in '@SOURCE@\BcmaCom-Orders\fODMedIV.pas',
  fODMedOIFA in '@SOURCE@\BcmaCom-Orders\fODMedOIFA.pas',
  fODMeds in '@SOURCE@\BcmaCom-Orders\fODMeds.pas' {lst},
  rCore in '@SOURCE@\BcmaCom-Orders\rCore.pas',
  rODBase in '@SOURCE@\BcmaCom-Orders\rODBase.pas',
  rODMeds in '@SOURCE@\BcmaCom-Orders\rODMeds.pas',
  rOrders in '@SOURCE@\BcmaCom-Orders\rOrders.pas',
  uBcmaConst in '@SOURCE@\BcmaCom-Orders\uBcmaConst.pas',
  uConst in '@SOURCE@\BcmaCom-Orders\uConst.pas',
  fSignItem in '@SOURCE@\BcmaCom-Orders\fSignItem.pas' {frmSignItem},
  fOCSession in '@SOURCE@\BcmaCom-Orders\fOCSession.pas' {frmOCSession},
  fODBase in '@SOURCE@\BcmaCom-Orders\fODBase.pas' {frmODBase},
  fReview in '@SOURCE@\BcmaCom-Orders\fReview.pas' {frmReview},
  ORNet in '@SOURCE@\BcmaCom-Lib\ORNet.pas',
  uODBase in '@SOURCE@\BcmaCom-Orders\uODBase.pas',
  fBase508Form in '@SOURCE@\BcmaCom-Orders\fBase508Form.pas' {frmBase508Form},
  fHSplit in '@SOURCE@\BcmaCom-Orders\fHSplit.pas',
  fPage in '@SOURCE@\BcmaCom-Orders\fPage.pas' {frmPage},
  fODMessage in '@SOURCE@\BcmaCom-Orders\fODMessage.pas' {frmODMessage},
  fIVRoutes in '@SOURCE@\BcmaCom-Orders\fIVRoutes.pas' {frmIVRoutes},
  fOtherSchedule in '@SOURCE@\BcmaCom-Orders\fOtherSchedule.pas' {frmOtherSchedule},
  BCMA_OrderMan in '@SOURCE@\BCMA\BCMA_OrderMan.pas' {frmCPRSOrderManager},
  BCMA_Objects in '@SOURCE@\BCMA\BCMA_Objects.pas',
  VHA_Objects in '@SOURCE@\BCMA\VHA_Objects.pas',
  BCMA_Common in '@SOURCE@\BCMA\BCMA_Common.pas',
  BCMA_Util in '@SOURCE@\BCMA\BCMA_Util.pas',
  uBCMA in '@SOURCE@\BCMA\uBCMA.pas',
  MultipleOrderedDrugs in '@SOURCE@\BCMA\MultipleOrderedDrugs.pas' {frmMultipleOrderedDrugs},
  fEncnt in '@SOURCE@\fEncnt.pas' {frmEncounter},
  uCore in '@SOURCE@\BcmaCom-Orders\uCore.pas',
  uOrders in '@SOURCE@\BcmaCom-Orders\uOrders.pas',
  XuDigSigSC_TLB in '@SOURCE@\XuDigSigSC_TLB.pas',
  fOCMonograph in '@SOURCE@\BcmaCom-Orders\fOCMonograph.pas' {frmOCMonograph};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  InitMOB       name 'LaunchMOB';

{$R BCMAOrderCom.TLB}

{$R OrderCom.RES}

begin
end.
