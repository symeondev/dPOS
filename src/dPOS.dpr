program dPOS;

uses
  Forms,
  uPOS in 'uPOS.pas' {frmPOS},
  udmMain in 'udmMain.pas' {dmMain: TDataModule},
  uLogin in 'uLogin.pas' {frmLogin},
  uPay in 'uPay.pas' {frmPay},
  uAdTicket in 'uAdTicket.pas' {frmAdTicket},
  uPrintTicket in 'uPrintTicket.pas' {frmPrintTicket},
  uStats in 'uStats.pas' {frmStats},
  uPrintStats in 'uPrintStats.pas' {frmPrintStats},
  uPrintCopy in 'uPrintCopy.pas' {frmPrintCopy},
  uOrders in 'uOrders.pas' {frmOrders},
  uParams in 'uParams.pas' {frmParams},
  uUsers in 'uUsers.pas' {frmUsers},
  uItems in 'uItems.pas' {frmItems},
  uItemGroups in 'uItemGroups.pas' {frmItemGroups},
  uCommon in 'uCommon.pas',
  uEnv in 'uEnv.pas',
  uEnvDev in 'uEnvDev.pas',
  uClientTicket in 'uClientTicket.pas' {frmClientTicket};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'dPOS - Point Of Sales System';
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmPOS, frmPOS);
  Application.CreateForm(TfrmClientTicket, frmClientTicket);
  Application.Run;
end.
