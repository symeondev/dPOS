unit uPrintStats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Provider, DBTables, DB, DBClient, DBLocal, DBLocalB, QuickRpt,
  QRCtrls, ExtCtrls, Grids, DBGrids;

type
  TfrmPrintStats = class(TForm)
    qrPrintStats: TQuickRep;
    bHeader: TQRBand;
    lEventName: TQRLabel;
    lCompanyName: TQRLabel;
    bTitle: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel23: TQRLabel;
    QRLabel25: TQRLabel;
    QRLabel26: TQRLabel;
    QRShape1: TQRShape;
    QRLabel2: TQRLabel;
    QRLabel4: TQRLabel;
    lTerminal: TQRLabel;
    lUser: TQRLabel;
    lPrintedAt: TQRLabel;
    lFrom: TQRLabel;
    lTo: TQRLabel;
    bDetails: TQRBand;
    bSummary: TQRBand;
    QRLabel3: TQRLabel;
    lOrderCount: TQRLabel;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    dbItemsCount: TDatabase;
    lItem: TQRLabel;
    lQuantity: TQRLabel;
    lPrice: TQRLabel;
    QRShape3: TQRShape;
    qItemsCount: TBDEClientDataSet;
    QRShape2: TQRShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRExpr1: TQRExpr;
    QRExpr2: TQRExpr;
    QRLabel5: TQRLabel;
  private
    function qItemsCountCommand(userId, terminalId: Integer; dateFrom, dateTo: TDateTime; allUsers, allTerminals: Boolean): String;
  public
    procedure PrepareItemsCountPrint(user, terminal, company, event: String; orderCount: Integer; totalAmount: Real; userId, terminalId: Integer; dateFrom, dateTo: TDateTime; allUsers, allTerminals: Boolean);
    procedure PrintCash;
    procedure PreviewCash;
  end;

var
  frmPrintStats: TfrmPrintStats;

implementation
{$R *.dfm}
uses
  uEnv;

function TfrmPrintStats.qItemsCountCommand(userId, terminalId: Integer; dateFrom, dateTo: TDateTime; allUsers, allTerminals: Boolean): String;
var
  select, from, where, groupBy, orderBy: String;
begin
  select := ' SELECT od.ItemId AS Id, i.Description AS Item, SUM(od.Quantity) AS ItemCount, ROUND(SUM(od.SubTotal), 2) AS ItemSubTotal';
  from := ' FROM Orders AS o, OrderDetails AS od, Items AS i';
  where := ' WHERE o.Id = od.OrderId AND od.ItemId = i.Id';
  where := where + ' AND o.StatusId = 3';
  if not allUsers then
    where := where + ' AND o.UserId = ' + IntToStr(userId);
  if not allTerminals then
    where := where + ' AND o.TerminalId = ' + IntToStr(terminalId);
  where := where + ' AND PrintedAt BETWEEN #' + FormatDateTime('mm/dd/yyyy hh.nn.ss', dateFrom) + '# AND #' + FormatDateTime('mm/dd/yyyy hh.nn.ss', dateTo) + '#';
  groupBy := ' GROUP BY od.ItemId, i.Description';
  orderBy := ' ORDER BY od.ItemId';
  Result := select + from + where + groupBy + orderBy;
end;

procedure TfrmPrintStats.PrepareItemsCountPrint(user, terminal, company, event: String; orderCount: Integer; totalAmount: Real; userId, terminalId: Integer; dateFrom, dateTo: TDateTime; allUsers, allTerminals: Boolean);
begin
  lCompanyName.Caption := company;
  lEventName.Caption := event;
  if allTerminals then
    lTerminal.Caption := 'Мыс'
  else
    lTerminal.Caption := terminal;
  if allUsers then
    lUser.Caption := 'Мыящ'
  else
    lUser.Caption := user;
  lPrintedAt.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
  lFrom.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss', dateFrom);
  lTo.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss', dateTo);
  lOrderCount.Caption := FormatFloat('#,##0', orderCount * 1.0);

  if dbItemsCount.Connected then dbItemsCount.Close;
  dbItemsCount.Params.Append('Password=' + DB_PASSWORD);
  if qItemsCount.Active then qItemsCount.Close;
  qItemsCount.CommandText := qItemsCountCommand(userId, terminalId, dateFrom, dateTo, allUsers, allTerminals);
  qItemsCount.Open;

  qrPrintStats.Height := bHeader.Height + bTitle.Height + bDetails.Height * qItemsCount.RecordCount + bSummary.Height;
end;

procedure TfrmPrintStats.PrintCash;
begin
  qrPrintStats.Print;
end;

procedure TfrmPrintStats.PreviewCash;
begin
  qrPrintStats.PreviewModal;
end;

end.
