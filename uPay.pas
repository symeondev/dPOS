unit uPay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, uCommon;

type
  TfrmPay = class(TForm)
    pMain: TPanel;
    lOrder: TLabel;
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
    bDot: TButton;
    bDelete: TButton;
    stOrderId: TStaticText;
    bPrint: TButton;
    bCancel: TButton;
    bClear: TButton;
    gbAmounts: TGroupBox;
    lTotal: TLabel;
    lPaidAmount: TLabel;
    lChange: TLabel;
    stOrderTotal: TStaticText;
    stPaidAmount: TStaticText;
    stChange: TStaticText;
    bTotal: TButton;
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    procedure FormCreate(Sender: TObject);
    procedure NumberClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure bDotClick(Sender: TObject);
    procedure bClearClick(Sender: TObject);
    procedure bTotalClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure UpdateAmounts;
    function CalcAmount(number, decimals: Integer): Real;
  public
    { Public declarations }
  end;


function ShowPayModal(AnOwner: TComponent; pOrderId: Integer; pTotalAmount: Real): Integer;

var
  frmPay: TfrmPay;
  orderId: Integer;
  totalAmount,
  paidAmount,
  change: Real;
  typedNumber,
  decimals: Integer;
  dotTyped: Boolean;

implementation

{$R *.dfm}
uses
  Math, udmMain;


function ShowPayModal(AnOwner: TComponent; pOrderId: Integer; pTotalAmount: Real): Integer;
begin
  orderId := pOrderId;
  typedNumber := 0;
  decimals := 0;
  dotTyped := False;
  totalAmount := pTotalAmount;
  paidAmount := 0.0;
  change := 0.0;
  frmPay := TfrmPay.Create(AnOwner);
  Result := frmPay.ShowModal;
end;

procedure TfrmPay.UpdateAmounts;
begin
  change := paidAmount - totalAmount;
  stOrderId.Caption := IntToStr(orderId);
  stOrderTotal.Caption := FormatFloat('0.00', totalAmount);
  stPaidAmount.Caption := FormatFloat('0.00', paidAmount);
  stChange.Caption := FormatFloat('0.00', change);
  bDot.Enabled := not dotTyped;
end;

function TfrmPay.CalcAmount(number, decimals: Integer): Real;
begin
  Result := number / Power(10, decimals);
end;

procedure TfrmPay.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
  lOrder.Visible := (dmMain.TestMode and TM_SHOWORDERID) = TM_SHOWORDERID;
  stOrderId.Visible := lOrder.Visible;
  UpdateAmounts;
end;

procedure TfrmPay.NumberClick(Sender: TObject);
begin
  if decimals < 2 then
  begin
    typedNumber := typedNumber * 10 + (Sender as TButton).Tag;
    if dotTyped then Inc(decimals);
    paidAmount := CalcAmount(typedNumber, decimals);
    UpdateAmounts;
  end;
end;

procedure TfrmPay.bDeleteClick(Sender: TObject);
begin
  if dotTyped and (decimals = 0) then
    dotTyped := false
  else
  begin
    typedNumber := Trunc(typedNumber / 10);
    if dotTyped and (decimals > 0) then
      Dec(decimals);
    paidAmount := CalcAmount(typedNumber, decimals);
  end;
  UpdateAmounts;
end;

procedure TfrmPay.bDotClick(Sender: TObject);
begin
  if not dotTyped then
  begin
    dotTyped := true;
    UpdateAmounts;
  end;
end;

procedure TfrmPay.bClearClick(Sender: TObject);
begin
  typedNumber := 0;
  decimals := 0;
  dotTyped := False;
  paidAmount := CalcAmount(typedNumber, decimals);
  UpdateAmounts;
end;

procedure TfrmPay.bTotalClick(Sender: TObject);
begin
  typedNumber := Trunc(totalAmount * 100);
  decimals := 2;
  dotTyped := True;
  paidAmount := CalcAmount(typedNumber, decimals);
  UpdateAmounts;
end;

procedure TfrmPay.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmPay.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPay.lTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

end.
