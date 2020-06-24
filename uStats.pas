unit uStats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Provider, DBTables, DB, DBClient, uCommon,
  DBLocal, DBLocalB, ExtCtrls, jpeg;

type
  TfrmStats = class(TForm)
    dbStats: TDatabase;
    qTotals: TBDEClientDataSet;
    pMain: TPanel;
    lUser: TLabel;
    lTerminal: TLabel;
    stFullname: TStaticText;
    stTerminal: TStaticText;
    bPrint: TButton;
    bCancel: TButton;
    gbFromTo: TGroupBox;
    lFrom: TLabel;
    lTo: TLabel;
    dtDateFrom: TDateTimePicker;
    dtTimeFrom: TDateTimePicker;
    dtDateTo: TDateTimePicker;
    dtTimeTo: TDateTimePicker;
    cbAllUsers: TCheckBox;
    cbAllTerminals: TCheckBox;
    pTitle: TPanel;
    iClose: TImage;
    lTitle: TLabel;
    procedure bPrintClick(Sender: TObject);
    procedure dtDateFromChange(Sender: TObject);
    procedure dtTimeFromChange(Sender: TObject);
    procedure dtDateToChange(Sender: TObject);
    procedure dtTimeToChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function qTotalsCommand(userId, terminalId: Integer; dateFrom, dateTo: TDateTime; allUsers, allTerminals: Boolean): String;
  end;

function ShowStatsModal(AnOwner: TComponent; pUserId, pTerminalId: Integer): Integer;

var
  frmStats: TfrmStats;

implementation

{$R *.dfm}

uses
  DateUtils, uPrintStats, udmMain, uEnv;

var
  userId,
  terminalId: Integer;
  dateFrom,
  dateTo: TDateTime;

function ShowStatsModal(AnOwner: TComponent; pUserId, pTerminalId: Integer): Integer;
begin
  userId := pUserId;
  terminalId := pTerminalId;
  frmStats := TfrmStats.Create(AnOwner);
  frmStats.stFullname.Caption := dmMain.GetNickname(userId);
  frmStats.stTerminal.Caption := dmMain.GetTerminalCode(terminalId);
  dateTo := Now;
//  dateTo := IncMinute(dateTo, 22);
  dateFrom := dateTo;
  ReplaceTime(dateFrom, StrToTime(appParams.StatisticsTimeFrom));
  if dateTo <= dateFrom then
    dateFrom := IncDay(dateFrom, -1);
  frmStats.dtDateFrom.DateTime := dateFrom;
  frmStats.dtTimeFrom.DateTime := dateFrom;
  frmStats.dtDateTo.DateTime := dateTo;
  frmStats.dtTimeTo.DateTime := dateTo;
  Result := frmStats.ShowModal;
end;

function TfrmStats.qTotalsCommand(userId, terminalId: Integer; dateFrom, dateTo: TDateTime; allUsers, allTerminals: Boolean): String;
var
  select, from, where: String;
begin
  select := ' SELECT SUM(TotalAmount) AS CashAmount, COUNT(Id) AS OrderCount';
  from := ' FROM Orders';
  where := ' WHERE StatusId = 3';
  if not allUsers then
    where := where + ' AND UserId = ' + IntToStr(userId);
  if not allTerminals then
    where := where + ' AND TerminalId = ' + IntToStr(terminalId);
  where := where + ' AND PrintedAt BETWEEN #' + FormatDateTime('mm/dd/yyyy hh.nn.ss', dateFrom) + '# AND #' + FormatDateTime('mm/dd/yyyy hh.nn.ss', dateTo) + '#';
  Result := select + from + where;
end;


procedure TfrmStats.bPrintClick(Sender: TObject);
begin
  frmPrintStats := TfrmPrintStats.Create(Self);
  dateFrom := dtDateFrom.DateTime;
  dateTo := dtDateTo.DateTime;
  if dbStats.Connected then dbStats.Close;
  dbStats.Params.Append('Password=' + DB_PASSWORD);
  if qTotals.Active then qTotals.Close;
  qTotals.CommandText := qTotalsCommand(userId, terminalId, dateFrom, dateTo, cbAllUsers.Checked, cbAllTerminals.Checked);
  qTotals.Open;
  frmPrintStats.PrepareItemsCountPrint(stFullname.Caption, stTerminal.Caption,
    appParams.CompanyName, appParams.EventName,
    qTotals.FieldByName('OrderCount').AsInteger, qTotals.FieldByName('CashAmount').AsFloat,
    userId, terminalId, dateFrom, dateTo, cbAllUsers.Checked, cbAllTerminals.Checked);

  if (dmMain.TestMode and TM_PRINTPREVIEW) = TM_PRINTPREVIEW then
    frmPrintStats.PreviewCash
  else
    frmPrintStats.PrintCash;

  qTotals.Close;
  dbStats.Close;
  frmPrintStats.Release;
end;

procedure TfrmStats.dtDateFromChange(Sender: TObject);
begin
  dtTimeFrom.Date := dtDateFrom.Date;
end;

procedure TfrmStats.dtTimeFromChange(Sender: TObject);
begin
  dtDateFrom.Time := dtTimeFrom.Time;
end;

procedure TfrmStats.dtDateToChange(Sender: TObject);
begin
  dtTimeTo.Date := dtDateTo.Date;
end;

procedure TfrmStats.dtTimeToChange(Sender: TObject);
begin
  dtDateTo.Time := dtTimeTo.Time;
end;

procedure TfrmStats.FormShow(Sender: TObject);
begin
  cbAllUsers.Visible := dmMain.GetUserLevel(userId) <= UL_CASHIERADMIN;
  cbAllUsers.Checked := cbAllUsers.Visible;
end;

procedure TfrmStats.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmStats.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmStats.lTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmStats.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
end;

end.
