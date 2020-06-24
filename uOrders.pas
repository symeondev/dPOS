unit uOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Provider, DBTables, DB, DBClient,
  DBLocal, DBLocalB, Grids, DBGrids, Mask, DBCtrls, uCommon, uClientTicket,
  uPrintTicket;

type
  TfrmOrders = class(TForm)
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    pMain: TPanel;
    gMain: TDBGrid;
    bClose: TButton;
    qOrdersList: TBDEClientDataSet;
    dsOrders: TDataSource;
    gDetails: TDBGrid;
    dbOrdersList: TDatabase;
    qOrdersListDetails: TBDEClientDataSet;
    dsOrderDetails: TDataSource;
    qOrdersListDetailsOrderId: TIntegerField;
    qOrdersListDetailsItemId: TIntegerField;
    qOrdersListDetailsQuantity: TIntegerField;
    qOrdersListDetailsSubTotal: TFloatField;
    eTotalAmount: TDBEdit;
    lTotalAmount: TLabel;
    qOrdersListId: TIntegerField;
    qOrdersListTotalAmount: TFloatField;
    qOrdersListPaidAmount: TFloatField;
    qOrdersListLotteryFrom: TIntegerField;
    qOrdersListLotteryTo: TIntegerField;
    qOrdersListPrintedAt: TDateTimeField;
    qOrdersListUserNickName: TStringField;
    qOrdersListTerminalCode: TStringField;
    qOrdersListOrderStatus: TStringField;
    qOrdersListUserId: TIntegerField;
    qOrdersListTerminalId: TIntegerField;
    qOrdersListTip: TFloatField;
    qOrdersListStatusId: TIntegerField;
    qOrdersListCreatedAt: TDateTimeField;
    qOrdersListDetailsItemDesc: TStringField;
    bPrint: TButton;
    procedure FormCreate(Sender: TObject);
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qOrdersListAfterScroll(DataSet: TDataSet);
    procedure bCloseClick(Sender: TObject);
    procedure bPrintClick(Sender: TObject);
  private
    function OrderDetailsText(orderId: Integer): String;
  public
    { Public declarations }
  end;


function ShowOrdersModal(AnOwner: TComponent): Integer;

var
  frmOrders: TfrmOrders;

implementation
{$R *.dfm}
uses
  udmMain, uEnv;


function ShowOrdersModal(AnOwner: TComponent): Integer;
begin
  frmOrders := TfrmOrders.Create(AnOwner);
  Result := frmOrders.ShowModal;
end;

procedure TfrmOrders.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
  dbOrdersList.Params.Append('Password=' + DB_PASSWORD);
  if not dbOrdersList.Connected then dbOrdersList.Open;
  if not qOrdersList.Active then qOrdersList.Open;
end;

procedure TfrmOrders.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOrders.lTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmOrders.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TfrmOrders.OrderDetailsText(orderId: Integer): String;
var
  select, from, where, orderBy: String;
begin
  select := ' SELECT *';
  from := ' FROM OrderDetails';
  where := ' WHERE OrderId = ' + IntToStr(orderId);
  orderBy := ' ORDER BY ItemId';
  Result := select + from + where + orderBy;
end;

procedure TfrmOrders.qOrdersListAfterScroll(DataSet: TDataSet);
begin
  qOrdersListDetails.Close;
  qOrdersListDetails.CommandText := OrderDetailsText(qOrdersList.FieldByName('Id').AsInteger);
  qOrdersListDetails.Open;
end;

procedure TfrmOrders.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOrders.bPrintClick(Sender: TObject);
var
  orderId: Integer;
  clientPages: Integer;
begin
  orderId := qOrdersList.FieldByName('Id').AsInteger;
  clientPages := 0;
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
end;

end.
