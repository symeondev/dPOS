unit uAdTicket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Provider, DBTables, jpeg, QRCtrls, QuickRpt, ExtCtrls, DB,
  DBClient, DBLocal, DBLocalB, Grids, DBGrids, uCommon, uEnv;

type
  TfrmAdTicket = class(TForm)
    qAdTicket: TBDEClientDataSet;
    qrAdTicket: TQuickRep;
    bHeader: TQRBand;
    lEventName: TQRLabel;
    lCompanyName: TQRLabel;
    bFooter: TQRBand;
    sh1: TQRShape;
    lThanks: TQRLabel;
    lCode: TQRLabel;
    iAdFooter01: TQRImage;
    shBottomLine: TQRShape;
    lSponsors: TQRLabel;
    iAdHeader01: TQRImage;
    iAdFooter02: TQRImage;
    iAdFooter03: TQRImage;
    lLottery: TQRLabel;
    lLotteryNumbers: TQRLabel;
    tLotteryFrom: TQRDBText;
    tLotteryTo: TQRDBText;
    lCopy: TQRLabel;
    iInfo: TQRImage;
    dbAdTicket: TDatabase;
    bDetail: TQRBand;
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
  frmAdTicket: TfrmAdTicket;

procedure CreateAdTicket(AnOwner: TComponent);
procedure ReleaseAdTicket;


implementation

{$R *.dfm}


procedure CreateAdTicket(AnOwner: TComponent);
begin
  frmAdTicket := TfrmAdTicket.Create(AnOwner);
  frmAdTicket.dbAdTicket.Params.Append('Password=' + DB_PASSWORD);
end;

procedure ReleaseAdTicket;
begin
  if frmAdTicket <> nil then
    frmAdTicket.Release;
end;


function TfrmAdTicket.qPrintCommand(orderId: Integer): String;
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

procedure TfrmAdTicket.LotteryControls(show: Boolean);
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
    iAdFooter03.Top := iAdFooter03.Top - diff;
    lThanks.Top := lThanks.Top - diff;
    lCode.Top := lCode.Top - diff;
    shBottomLine.Top := shBottomLine.Top - diff;
    bFooter.Height := bFooter.Height - diff;
  end;
end;

procedure TfrmAdTicket.InfoControl(infoFile: String; infoHeight: Integer);
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
  iAdFooter03.Top := iAdFooter03.Top - diff;
  lThanks.Top := lThanks.Top - diff;
  lCode.Top := lCode.Top - diff;
  shBottomLine.Top := shBottomLine.Top - diff;
  bFooter.Height := bFooter.Height - diff;
end;

procedure TfrmAdTicket.AdControls(adFiles: TFileArray);
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

  diff := lThanks.Top - iAdFooter03.Top;
  if adFiles[3] <> '' then
    iAdFooter03.Picture.LoadFromFile(adFiles[3])
  else
  begin
    iAdFooter03.Enabled := False;
    lThanks.Top := lThanks.Top - diff;
    lCode.Top := lCode.Top - diff;
    shBottomLine.Top := shBottomLine.Top - diff;
    bFooter.Height := bFooter.Height - diff;
  end;

  diff := lThanks.Top - iAdFooter02.Top;
  if adFiles[2] <> '' then
    iAdFooter02.Picture.LoadFromFile(adFiles[2])
  else
  begin
    iAdFooter02.Enabled := False;
    lThanks.Top := lThanks.Top - diff;
    lCode.Top := lCode.Top - diff;
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
    lCode.Top := lCode.Top - diff;
    shBottomLine.Top := shBottomLine.Top - diff;
    bFooter.Height := bFooter.Height - diff;
  end;
  lSponsors.Enabled := iAdFooter01.Enabled or iAdFooter02.Enabled or iAdFooter03.Enabled;
end;

procedure TfrmAdTicket.PrepareTicketPrint(orderId: Integer; isCopy: Boolean; p: TAppParams);
begin
  if qAdTicket.Active then qAdTicket.Close;
  if dbAdTicket.Connected then dbAdTicket.Close;
  qAdTicket.CommandText := qPrintCommand(orderId);
  dbAdTicket.Open;
  qAdTicket.Open;

  lCopy.Enabled := isCopy;
  lCompanyName.Caption := p.CompanyName;
  lEventName.Caption := p.EventName;
  lCode.Caption := PrintedCode(ProduceUniqueCode(qAdTicket), ' ', 4, p.ShuffleTicketCode <> 0);
  tLotteryFrom.Mask := p.LotteryFormat;
  tLotteryTo.Mask := p.LotteryFormat;

  AdControls(p.AdFiles);
  InfoControl(p.InfoFile, p.InfoHeight);
  LotteryControls((qAdTicket.FieldByName('LotteryFrom').AsInteger <> 0) or (qAdTicket.FieldByName('LotteryTo').AsInteger <> 0));

  qrAdTicket.Height := bHeader.Height + bDetail.Height * qAdTicket.RecordCount + bFooter.Height;
end;

procedure TfrmAdTicket.PrintTicket;
begin
  qrAdTicket.Print;
end;

procedure TfrmAdTicket.PreviewTicket;
begin
  qrAdTicket.PreviewModal;
end;

end.
