unit uPrintCopy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uCommon, jpeg, ExtCtrls;

type
  TfrmPrintCopy = class(TForm)
    pMain: TPanel;
    lMaxLottery: TLabel;
    lMaxOrder: TLabel;
    lUser: TLabel;
    Label1: TLabel;
    eOrderId: TEdit;
    bSeven: TButton;
    bEight: TButton;
    bNine: TButton;
    bFour: TButton;
    bFive: TButton;
    bSix: TButton;
    bOne: TButton;
    bTwo: TButton;
    bThree: TButton;
    bZero: TButton;
    bDelete: TButton;
    bPrint: TButton;
    bClear: TButton;
    eLotteryNumber: TEdit;
    bClose: TButton;
    stMessage: TStaticText;
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    procedure NumberClick(Sender: TObject);
    procedure EnterClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bClearClick(Sender: TObject);
    procedure bPrintClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    InputControl: TCustomEdit;
  public
    { Public declarations }
  end;


function ShowPrintCopyModal(AnOwner: TComponent): Integer;

var
  frmPrintCopy: TfrmPrintCopy;

implementation
{$R *.dfm}

uses
  uClientTicket, uPrintTicket, udmMain;


function ShowPrintCopyModal(AnOwner: TComponent): Integer;
begin
  frmPrintCopy := TfrmPrintCopy.Create(AnOwner);
  Result := frmPrintCopy.ShowModal;
end;

procedure TfrmPrintCopy.NumberClick(Sender: TObject);
begin
  if InputControl <> nil then
    InputControl.Text := InputControl.Text + IntToStr((Sender as TButton).Tag);
end;


procedure TfrmPrintCopy.EnterClick(Sender: TObject);
begin
  If InputControl <> nil then
    InputControl.Clear;
  InputControl := (Sender as TCustomEdit);
  stMessage.Caption := '';
end;

procedure TfrmPrintCopy.bDeleteClick(Sender: TObject);
begin
  InputControl.Text := Copy(InputControl.Text, 1, Length(InputControl.Text) - 1);
end;

procedure TfrmPrintCopy.FormShow(Sender: TObject);
begin
  lMaxOrder.Caption := 'Max: ' + IntToStr(dmMain.GetMaxOrderId);
  lMaxLottery.Caption := 'Max: ' + IntToStr(dmMain.GetMaxLottery);
  eOrderId.SetFocus;
end;

procedure TfrmPrintCopy.bClearClick(Sender: TObject);
begin
  InputControl.Clear;
end;

procedure TfrmPrintCopy.bPrintClick(Sender: TObject);
var
  orderId: Integer;
  clientPages: Integer;
begin
  if InputControl.Text <> '' then
  begin
    if InputControl = eOrderId then
      orderId := dmMain.GetOrder(StrToInt(InputControl.Text))
    else
      orderId := dmMain.GetOrderId(StrToInt(InputControl.Text));

    if orderId > 0 then
    begin
      clientPages := 1;
      if (appParams.PrintedTickets and PT_CLIENTTICKET) = PT_CLIENTTICKET then
      begin
        clientPages := 1;
        CreateClientTicket(Self);
        frmClientTicket.PrepareTicketPrint(orderId, true, appParams);
        if (dmMain.TestMode and TM_PRINTPREVIEW) = TM_PRINTPREVIEW then
          frmClientTicket.PreviewTicket
        else
          frmClientTicket.PrintTicket;
        ReleaseClientTicket;
      end;
      if (appParams.PrintedTickets and PT_KITCHENTICKETS) = PT_KITCHENTICKETS then
      begin
        CreatePrintTicket(Self);
        frmPrintTicket.PrepareOrderPrint(orderId, true, appParams, clientPages, dmMain.GetMaxItems);
        if (dmMain.TestMode and TM_PRINTPREVIEW) = TM_PRINTPREVIEW then
          frmPrintTicket.PreviewOrder
        else
          frmPrintTicket.PrintOrder;
        ReleasePrintTicket;
      end;
    end
    else
      stMessage.Caption := 'Η παραγγελία δεν υπάρχει';
  end;
end;

procedure TfrmPrintCopy.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmPrintCopy.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrintCopy.lTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmPrintCopy.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
end;

end.
