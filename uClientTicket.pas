unit uClientTicket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Provider, DBTables, jpeg, QRCtrls, QuickRpt, ExtCtrls, DB,
  DBClient, DBLocal, DBLocalB, Grids, DBGrids, uCommon, uEnv;

type
  TfrmClientTicket = class(TForm)
    dbClientPrint: TDatabase;
    qClientPrint: TBDEClientDataSet;
    qrClientTicket: TQuickRep;
    bDetail: TQRBand;
    tItem: TQRDBText;
    tQuantity: TQRDBText;
    tSubTotal: TQRDBText;
    bHeader: TQRBand;
    lEventName: TQRLabel;
    lCompanyName: TQRLabel;
    bFooter: TQRBand;
    sh1: TQRShape;
    lTerminal: TQRLabel;
    tTerminal: TQRDBText;
    lOrder: TQRLabel;
    tOrder: TQRDBText;
    lCashier: TQRLabel;
    tCashier: TQRDBText;
    lPrintedAt: TQRLabel;
    tPrintedAt: TQRDBText;
    lItem: TQRLabel;
    lQuantity: TQRLabel;
    lSubTotal: TQRLabel;
    sh2: TQRShape;
    sh3: TQRShape;
    sh4: TQRShape;
    lTotalAmount: TQRLabel;
    tTotalAmount: TQRDBText;
    lPaidAmount: TQRLabel;
    tPaidAmount: TQRDBText;
    lChange: TQRLabel;
    expChange: TQRExpr;
    lThanks: TQRLabel;
    lNoReceipt: TQRLabel;
    iAdFooter01: TQRImage;
    shBottomLine: TQRShape;
    lSponsors: TQRLabel;
    iAdHeader01: TQRImage;
    iAdFooter02: TQRImage;
    lLottery: TQRLabel;
    lLotteryNumbers: TQRLabel;
    tLotteryFrom: TQRDBText;
    tLotteryTo: TQRDBText;
    lCopy: TQRLabel;
    iInfo: TQRImage;
  private
    function qPrintCommand(orderId: Integer): String;
    procedure LotteryControls(show: Boolean);
    procedure InfoControl(infoFile: String; infoHeight: Integer);
    procedure AdControls(adFiles: TFileArray);
  public
    procedure PrepareTicketPrint(orderId: Integer; isCopy: Boolean; p: TAppParams);
    procedure PrintTicket;
    procedure PreviewTicket;
  end;

var
  frmClientTicket: TfrmClientTicket;

procedure CreateClientTicket(AnOwner: TComponent);
procedure ReleaseClientTicket;


implementation

{$R *.dfm}

procedure CreateClientTicket(AnOwner: TComponent);
begin
  frmClientTicket := TfrmClientTicket.Create(AnOwner);
  frmClientTicket.dbClientPrint.Params.Append('Password=' + DB_PASSWORD);
end;

procedure ReleaseClientTicket;
begin
  if frmClientTicket <> nil then
    frmClientTicket.Release;
end;


function TfrmClientTicket.qPrintCommand(orderId: Integer): String;
var
  select, from, where, orderBy: String;
begin
  select := ' SELECT t.Code AS TerminalCode, o.Id AS OrderId, u.NickName AS UserName, ig.Description AS ItemGroupDesc, i.Description AS ItemDesc,';
  select := select + ' od.Quantity as Quantity, od.SubTotal AS SubTotal, o.PrintedAt AS PrintedAt, o.PaidAmount AS PaidAmount, o.TotalAmount AS TotalAmount,';
  select := select + ' o.LotteryFrom AS LotteryFrom, o.LotteryTo AS LotteryTo';
  from := ' FROM Orders o, OrderDetails od, Items i, ItemGroups ig, Users u, Terminals t';
  where := ' WHERE o.Id = ' + IntToStr(orderId) + ' AND od.OrderId = o.Id AND t.Id = o.TerminalId AND u.Id = o.UserId AND od.ItemId = i.Id AND i.ItemGroupId = ig.Id';
  orderBy := ' ORDER BY o.Id, i.ItemGroupId, od.ItemId';
  Result := select + from + where + orderBy;
end;

procedure TfrmClientTicket.LotteryControls(show: Boolean);
var
  diff: Integer;
begin
  diff := iInfo.Top - lLottery.Top;
  lLottery.Enabled := show;
  lLotteryNumbers.Enabled := show;
  tLotteryFrom.Enabled := show;
  tLotteryTo.Enabled := show;
  if not show then
  begin
    iInfo.Top := iInfo.Top - diff;
    lSponsors.Top := lSponsors.Top - diff;
    iAdFooter01.Top := iAdFooter01.Top - diff;
    iAdFooter02.Top := iAdFooter02.Top - diff;
    lThanks.Top := lThanks.Top - diff;
    lNoReceipt.Top := lNoReceipt.Top - diff;
    shBottomLine.Top := shBottomLine.Top - diff;
    bFooter.Height := bFooter.Height - diff;
  end;
end;

procedure TfrmClientTicket.InfoControl(infoFile: String; infoHeight: Integer);
var
  diff: Integer;
begin
  iInfo.Height := infoHeight;
  diff := lSponsors.Top - iInfo.Top - infoHeight;
  if (infoFile <> '') and (infoHeight > 0) then
    iInfo.Picture.LoadFromFile(infoFile)
  else
    iInfo.Enabled := False;

  lSponsors.Top := lSponsors.Top - diff;
  iAdFooter01.Top := iAdFooter01.Top - diff;
  iAdFooter02.Top := iAdFooter02.Top - diff;
  lThanks.Top := lThanks.Top - diff;
  lNoReceipt.Top := lNoReceipt.Top - diff;
  shBottomLine.Top := shBottomLine.Top - diff;
  bFooter.Height := bFooter.Height - diff;
end;

procedure TfrmClientTicket.AdControls(adFiles: TFileArray);
var
  i,
  diff: Integer;
begin
  diff := iAdHeader01.Height;
  if adFiles[0] <> '' then
    iAdHeader01.Picture.LoadFromFile(adFiles[0])
  else
  begin
    iAdHeader01.Enabled := False;
    for i := 0 to bHeader.ControlCount - 1 do
      bHeader.Controls[i].Top := bHeader.Controls[i].Top - diff;
    bHeader.Height := bHeader.Height - diff;
  end;
  diff := lThanks.Top - iAdFooter02.Top;
  if adFiles[2] <> '' then
    iAdFooter02.Picture.LoadFromFile(adFiles[2])
  else
  begin
    iAdFooter02.Enabled := False;
    lThanks.Top := lThanks.Top - diff;
    lNoReceipt.Top := lNoReceipt.Top - diff;
    shBottomLine.Top := shBottomLine.Top - diff;
    bFooter.Height := bFooter.Height - diff;
  end;

  diff := lThanks.Top - lSponsors.Top;
  if adFiles[1] <> '' then
    iAdFooter01.Picture.LoadFromFile(adFiles[1])
  else
  begin
    iAdFooter01.Enabled := False;
    lThanks.Top := lThanks.Top - diff;
    lNoReceipt.Top := lNoReceipt.Top - diff;
    shBottomLine.Top := shBottomLine.Top - diff;
    bFooter.Height := bFooter.Height - diff;
  end;
  lSponsors.Enabled := iAdFooter01.Enabled or iAdFooter02.Enabled;
end;

procedure TfrmClientTicket.PrepareTicketPrint(orderId: Integer; isCopy: Boolean; p: TAppParams);
begin
  if qClientPrint.Active then qClientPrint.Close;
  if dbClientPrint.Connected then dbClientPrint.Close;
  qClientPrint.CommandText := qPrintCommand(orderId);
  dbClientPrint.Open;
  qClientPrint.Open;

  lCopy.Enabled := isCopy;
  lCompanyName.Caption := p.CompanyName;
  lEventName.Caption := p.EventName;
  tLotteryFrom.Mask := p.LotteryFormat;
  tLotteryTo.Mask := p.LotteryFormat;

  AdControls(p.AdFiles);
  InfoControl(p.InfoFile, p.InfoHeight);
  LotteryControls((qClientPrint.FieldByName('LotteryFrom').AsInteger <> 0) or (qClientPrint.FieldByName('LotteryTo').AsInteger <> 0));

  qrClientTicket.Height := bHeader.Height + bDetail.Height * qClientPrint.RecordCount + bFooter.Height;
end;

procedure TfrmClientTicket.PrintTicket;
begin
  qrClientTicket.Print;
end;

procedure TfrmClientTicket.PreviewTicket;
begin
  qrClientTicket.PreviewModal;
end;

end.
