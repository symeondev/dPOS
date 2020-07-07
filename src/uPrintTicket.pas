unit uPrintTicket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls, Provider, DBTables, DB, DBClient,
  DBLocal, DBLocalB, DimDBComponents, jpeg, Grids, DBGrids, uCommon;

type
  TfrmPrintTicket = class(TForm)
    qrTicket: TQuickRep;
    bDetails: TQRBand;
    tItem: TQRDBText;
    tQuantity: TQRDBText;
    tSubTotal: TQRDBText;
    bGroup: TQRGroup;
    dbPrint: TDatabase;
    tItemGroup: TQRDBText;
    lItem: TQRLabel;
    lQuantity: TQRLabel;
    lPrice: TQRLabel;
    bHeader: TQRBand;
    lCompanyName: TQRLabel;
    qPrint: TBDEClientDataSet;
    bSummary: TQRBand;
    lThanks: TQRLabel;
    lTotalAmount: TQRLabel;
    tTotalAmount: TQRDBText;
    lNoReceipt: TQRLabel;
    lPaidAmount: TQRLabel;
    tPaidAmount: TQRDBText;
    lChange: TQRLabel;
    bGroupFooter: TQRBand;
    QRLabel21: TQRLabel;
    QRExpr1: TQRExpr;
    expChange: TQRExpr;
    lEventName: TQRLabel;
    QRLabel23: TQRLabel;
    QRDBText5: TQRDBText;
    QRLabel24: TQRLabel;
    QRDBText11: TQRDBText;
    QRLabel25: TQRLabel;
    QRDBText13: TQRDBText;
    QRLabel26: TQRLabel;
    QRDBText14: TQRDBText;
    bFooter: TQRBand;
    lPages: TQRLabel;
    sh1: TQRShape;
    sh2: TQRShape;
    sh3: TQRShape;
    sh4: TQRShape;
    sh5: TQRShape;
    sh7: TQRShape;
    sh6: TQRShape;
    lCopy: TQRLabel;
    qMaxOrderItems: TBDEClientDataSet;
    procedure tItemGroupPrint(sender: TObject; var Value: String);
    procedure bGroupFooterBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure lPagesPrint(sender: TObject; var Value: String);
    procedure qrTicketBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qPrintBeforeOpen(DataSet: TDataSet);
  private
    totalPages: Integer;
    clientPages: Integer;
    function qPrintCommand(orderId: Integer): String;
    function qMaxOrderItemsCommand(orderId: Integer): String;
    function MaxOrderItems(orderId: Integer): Integer;
  public
    procedure PrepareOrderPrint(orderId: Integer; isCopy: Boolean; p: TAppParams; clientPagesPrinted, maxItems: Integer);
    procedure PrintOrder;
    procedure PreviewOrder;
  end;

var
  frmPrintTicket: TfrmPrintTicket;

procedure CreatePrintTicket(AnOwner: TComponent);
procedure ReleasePrintTicket;


implementation
{$R *.dfm}
uses
  uEnv;

procedure CreatePrintTicket(AnOwner: TComponent);
begin
  frmPrintTicket := TfrmPrintTicket.Create(AnOwner);
end;

procedure ReleasePrintTicket;
begin
  if frmPrintTicket <> nil then
    frmPrintTicket.Release;
end;


function TfrmPrintTicket.qPrintCommand(orderId: Integer): String;
var
  select, from, where, orderBy: String;
begin
  select := ' SELECT t.Code AS TerminalCode, o.Id AS OrderId, u.NickName AS UserName, ig.Description AS ItemGroupDesc, i.Description AS ItemDesc,';
  select := select + ' od.Quantity as Quantity, od.SubTotal AS SubTotal, o.PrintedAt AS PrintedAt, o.PaidAmount AS PaidAmount, o.TotalAmount AS TotalAmount';
  from := ' FROM Orders o, OrderDetails od, Items i, ItemGroups ig, Users u, Terminals t';
  where := ' WHERE o.Id = ' + IntToStr(orderId) + ' AND od.OrderId = o.Id AND t.Id = o.TerminalId AND u.Id = o.UserId AND od.ItemId = i.Id AND i.ItemGroupId = ig.Id';
  orderBy := ' ORDER BY o.Id, i.ItemGroupId, od.ItemId';
  Result := select + from + where + orderBy;
end;


procedure TfrmPrintTicket.PrepareOrderPrint(orderId: Integer; isCopy: Boolean; p: TAppParams; clientPagesPrinted, maxItems: Integer);
var
  maxItemsCount: Integer;
begin
  if qPrint.Active then qPrint.Close;
  if dbPrint.Connected then dbPrint.Close;
  dbPrint.Params.Append('Password=' + DB_PASSWORD);
  qPrint.CommandText := qPrintCommand(orderId);
  dbPrint.Open;
  qPrint.Open;

  lCompanyName.Caption := p.CompanyName;
  lEventName.Caption := p.EventName;
  lCopy.Enabled := isCopy;
  clientPages := clientPagesPrinted;
//  bSummary.Enabled := clientPages <= 0;
  bSummary.Enabled := (p.PrintedTickets and PT_CLIENTTICKET) <> PT_CLIENTTICKET;
  maxItemsCount := MaxOrderItems(orderId);
  if maxItemsCount < maxItems then
    maxItemsCount := maxItems;
  qrTicket.Height := bHeader.Height + bGroup.Height + bDetails.Height * maxItemsCount +
    bGroupFooter.Height + bFooter.Height + Round(p.BlankHeight * PT_PIXELSPERMM);
  if bSummary.Enabled then
    qrTicket.Height := qrTicket.Height + bSummary.Height;
end;

procedure TfrmPrintTicket.tItemGroupPrint(sender: TObject; var Value: String);
begin
//  Value := '*** ' + Value + ' ***';
end;

procedure TfrmPrintTicket.bGroupFooterBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
//   lSeparator.Enabled := true;
end;

procedure TfrmPrintTicket.lPagesPrint(sender: TObject; var Value: String);
begin
  Value := IntToStr(qrTicket.QRPrinter.PageCount + clientPages) + '/' + IntToStr(totalPages + clientPages);
end;

procedure TfrmPrintTicket.qrTicketBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
//  Sender.QRPrinter.Canvas.Font.Size := 10;
end;

procedure TfrmPrintTicket.qPrintBeforeOpen(DataSet: TDataSet);
begin
  if not dbPrint.Connected then dbPrint.Open;
end;

procedure TfrmPrintTicket.PrintOrder;
var
  i: Integer;
begin
  with qrTicket do
  begin
    Prepare;
    totalPages := QRPrinter.PageCount;
    for i := 1 to totalPages do
    begin
      PrinterSettings.FirstPage := i;
      PrinterSettings.LastPage := i;
      Print;
    end;
  end;
end;

procedure TfrmPrintTicket.PreviewOrder;
begin
  qrTicket.Prepare;
  totalPages := qrTicket.QRPrinter.PageCount;
  qrTicket.PreviewModal;
end;

function TfrmPrintTicket.qMaxOrderItemsCommand(orderId: Integer): String;
var
  select, from,
  f_query, f_select, f_from, f_where, f_groupBy: String;
begin
  f_select := 'SELECT COUNT(*) AS GroupCount, i.ItemGroupId';
  f_from := ' FROM OrderDetails od, Items i';
  f_where := ' WHERE od.ItemId = i.Id AND od.OrderId = ' + IntToStr(orderId);
  f_groupBy := ' GROUP BY i.ItemGroupId';
  f_query := ' (' + f_select + f_from + f_where + f_groupBy + ')';
  select := 'SELECT MAX(GroupCount) AS MaxCount';
  from := ' FROM ' + f_query;
  Result := select + from;
end;

function TfrmPrintTicket.MaxOrderItems(orderId: Integer): Integer;
begin
  with qMaxOrderItems do
  begin
    if Active then Close;
    CommandText := qMaxOrderItemsCommand(orderId);
    Open;
    Result := FieldByName('MaxCount').AsInteger;
  end;
end;

end.
