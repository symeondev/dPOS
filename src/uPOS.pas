unit uPOS;

interface
{$WARN UNIT_PLATFORM OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB, DBTables, Provider, DBClient,
  DBLocal, DBLocalB, Grids, DBGrids, ExtCtrls, uLogin, udmMain, jpeg, Mask,
  DBCtrls, uPrintTicket, uPay, uStats, uClientTicket, uPrintCopy, uParams,
  uOrders, uUsers, uItems, uItemGroups, uCommon, uAdTicket;

type
  TAccessDBGrid = class(TDBGrid);
  TfrmPOS = class(TForm)
    pMain: TPanel;
    splMain: TSplitter;
    pTicket: TPanel;
    pTotal: TPanel;
    lTotal: TLabel;
    stOrderTotal: TStaticText;
    bPay: TButton;
    pButtons: TPanel;
    bRemoveItem: TButton;
    bUp: TButton;
    bDown: TButton;
    bAddItem: TButton;
    bDelete: TButton;
    bAdd10Items: TButton;
    pHeader: TPanel;
    lOrder: TLabel;
    bCancelOrder: TButton;
    eOrderId: TDBEdit;
    gOrderDetails: TDBGrid;
    pTop: TPanel;
    iLogo: TImage;
    lLogo: TLabel;
    bbtnLogout: TBitBtn;
    pAdminButtons: TPanel;
    bItems: TButton;
    bPrintCopy: TButton;
    bBackup: TButton;
    bParams: TButton;
    pBottom: TPanel;
    lUser: TLabel;
    lTerminal: TLabel;
    stUsername: TStaticText;
    stTerminal: TStaticText;
    stClock: TStaticText;
    bStats: TButton;
    bOrders: TButton;
    pFoods: TPanel;
    dbInstant: TDatabase;
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    bUsers: TButton;
    sbFoods: TScrollBox;
    bItemGroups: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure bbtnLogoutClick(Sender: TObject);
    procedure ItemClick(Sender: TObject);
    procedure bRemoveItemClick(Sender: TObject);
    procedure bUpClick(Sender: TObject);
    procedure bDownClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure bPayClick(Sender: TObject);
    procedure bAddItemClick(Sender: TObject);
    procedure bCancelOrderClick(Sender: TObject);
    procedure bAdd10ItemsClick(Sender: TObject);
    procedure bStatsClick(Sender: TObject);
    procedure bPrintCopyClick(Sender: TObject);
    procedure bBackupClick(Sender: TObject);
    procedure bLockClick(Sender: TObject);
    procedure bUnlockClick(Sender: TObject);
    procedure bParamsClick(Sender: TObject);
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bOrdersClick(Sender: TObject);
    procedure bUsersClick(Sender: TObject);
    procedure bItemsClick(Sender: TObject);
    procedure bItemGroupsClick(Sender: TObject);
  private
    userId: Integer;
    terminalId: Integer;
    username: String;
    terminal: String;
    currentOrderId: Integer;
    currentOrderTotal: Real;
    procedure InitTables;
    procedure InitParameters;
    procedure InitUI;
    procedure InitLogo;
    procedure InitFoods;
    procedure ClearFoods;
    procedure UpdateInfo;
    procedure UpdateClock(Sender: TObject);
    procedure UpdateOrderTotal(DataSet: TDataSet);
    function GetCurrentTerminalId: Integer;
    function CalcLotteryTo(amount: Real; lotteryTicketsPerEuro: Integer; lastLottery: Integer): Integer;
    procedure SetOrdersLocked(value: Integer);
    procedure LockOrdersTable;
    procedure UnlockOrdersTable;
    function GetOrdersTableLocked: Integer;
    function RoundUp(x: Real): Integer;
  public
    { Public declarations }
  end;

var
  frmPOS: TfrmPOS;


implementation
{$R *.dfm}
uses
  Registry, FileCtrl, uEnv;


procedure TfrmPOS.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
  InitTables;
  InitParameters;
  InitUI;
  userId := -1;
  terminalId := GetCurrentTerminalId;
  currentOrderId := -1;
  currentOrderTotal := 0.0;
end;

procedure TfrmPOS.InitTables;
begin
  with dmMain do
  begin
    if dbPOS.Connected then dbPOS.Close;
    if qItems.Active then qItems.Close;
    if qUsers.Active then qUsers.Close;
    if qTerminals.Active then qTerminals.Close;
    if qOrderStatus.Active then qOrderStatus.Close;
    if qUserGroups.Active then qUserGroups.Close;
    if qItemGroups.Active then qItemGroups.Close;
    dbPOS.Open;
    qItems.Open;
    qUsers.Open;
    qTerminals.Open;
    qOrderStatus.Open;
    qUserGroups.Open;
    qItemGroups.Open;
  end;
end;

procedure TfrmPOS.InitParameters;
begin
  with appParams do
  begin
    CompanyTitle := GetParamValue('CompanyTitle');
    ServerTerminalId := StrToInt(GetParamValue('ServerTerminalId'));

    LogoFile := GetParamValue('LogoFile');
    LogoWidth := StrToInt(GetParamValue('LogoWidth'));
    TitleTop := StrToInt(GetParamValue('TitleTop'));
    TitleLeft := StrToInt(GetParamValue('TitleLeft'));
    TitleWidth := StrToInt(GetParamValue('TitleWidth'));
    TitleHeight := StrToInt(GetParamValue('TitleHeight'));

    ButtonHeight := StrToInt(GetParamValue('ButtonHeight'));
    ButtonWidth := StrToInt(GetParamValue('ButtonWidth'));
    ButtonSpace := StrToInt(GetParamValue('ButtonSpace'));
    BoxPadding := StrToInt(GetParamValue('BoxPadding'));
    BoxColumns := StrToInt(GetParamValue('BoxColumns'));
    BoxRows := StrToInt(GetParamValue('BoxRows'));
    BoxSpace := StrToInt(GetParamValue('BoxSpace'));
    PanelPadding := StrToInt(GetParamValue('PanelPadding'));
    PanelScrollbars := StrToInt(GetParamValue('PanelScrollbars'));

    ServerDatabaseFile := GetParamValue('ServerDatabaseFile');
    RemoteDatabaseFile := GetParamValue('RemoteDatabaseFile');
    BackupDBPath := GetParamValue('BackupDBPath');
    BackupDBSuffixFormat := GetParamValue('BackupDBSuffixFormat');

    CompanyName := GetParamValue('CompanyName');
    EventName := GetParamValue('EventName');
    StatisticsTimeFrom := GetParamValue('StatisticsTimeFrom');
    PrintedTickets := StrToInt(GetParamValue('PrintedTickets'));
    BlankHeight := StrToInt(GetParamValue('BlankHeight'));
    InfoFile := GetParamValue('InfoFile');
    InfoHeight := StrToInt(GetParamValue('InfoHeight'));

    AdFiles[0] := GetParamValue('AdHeaderFile01');
    AdFiles[1] := GetParamValue('AdFooterFile01');
    AdFiles[2] := GetParamValue('AdFooterFile02');
    AdFiles[3] := GetParamValue('AdFooterFile03');
    if AdFiles[1] = '' then
    begin
      AdFiles[1] := AdFiles[2];
      AdFiles[2] := AdFiles[3];
      AdFiles[3] := '';
    end;
    RotateAds := StrToInt(GetParamValue('RotateAds'));

    LotteryOffset := StrToInt(GetParamValue('LotteryOffset'));
    LotteryFormat := GetParamValue('LotteryFormat');
    LotteryTicketsPerEuro := StrToInt(GetParamValue('LotteryTicketsPerEuro'));
    LotteryMethod := StrToInt(GetParamValue('LotteryMethod'));
    ShuffleTicketCode := StrToInt(GetParamValue('ShuffleTicketCode'));
  end;
end;

procedure TfrmPOS.InitUI;
begin
  TAccessDBGrid(gOrderDetails).DefaultRowHeight := 40;
  TAccessDBGrid(gOrderDetails).RowHeights[0] := 40;
  InitLogo;
  InitFoods;
end;

procedure TfrmPOS.InitLogo;
begin
  if appParams.LogoFile <> '' then
    iLogo.Picture.LoadFromFile(appParams.LogoFile)
  else
    appParams.LogoWidth := 0;

  iLogo.Width := appParams.LogoWidth;

  lLogo.Caption := appParams.CompanyTitle;
  lLogo.Top := appParams.TitleTop;
  lLogo.Left := appParams.TitleLeft;
  lLogo.Width := appParams.TitleWidth;
  lLogo.Height := appParams.TitleHeight;
end;

procedure TfrmPOS.InitFoods;
var
  p: TScrollBox;      // parent
  gb, prevGb: TGroupBox;
  b: TButton;
  i, j: Integer;
  w, sbWidth: Integer;
  row, col: Integer;  // 0 based
begin
  ClearFoods;
  with dmMain, appParams do
  begin
    p := sbFoods;
    prevGb := nil;
    sbWidth := 0;
    if PanelScrollbars and PS_VERTICAL = PS_VERTICAL then
      sbWidth := PS_WIDTH;
    qItems.Filtered := True;
    qItemGroups.Filtered := True;
    for i := 0 to qItemGroups.RecordCount - 1 do
    begin
      qItemGroups.RecNo := i + 1;
      gb := TGroupBox.Create(p);
      gb.Parent := p;
      gb.Caption := qItemGroups.FieldByName('Description').AsString;
      gb.Color := qItemGroups.FieldByName('Color').AsInteger;
      gb.Left := PanelPadding;
      gb.Width := p.Width - 2 * PanelPadding - sbWidth;
      w := 2 * BoxPadding + BoxColumns * ButtonWidth + (BoxColumns - 1) * ButtonSpace - sbWidth;
      if gb.Width < w then gb.Width := w;
      if BoxRows > 0 then
      begin
        gb.Height := BoxRows * ButtonHeight + 2 * BoxPadding + (BoxRows - 1) * ButtonSpace + GC_HEIGHT;
        gb.Top := PanelPadding + i * (gb.Height + BoxSpace);
      end;
      qItems.Filter := '(ItemGroupId = ' + qItemGroups.FieldByName('Id').AsString + ') AND Show';

      row := 0;
      col := 0;
      if (BoxRows = 0) and (qItems.RecordCount = 0) then        // 0: Auto and no buttons
      begin
        gb.Height := (row + 1) * ButtonHeight + 2 * BoxPadding + row * ButtonSpace + GC_HEIGHT;
        if prevGb <> nil then
          gb.Top := prevGb.Top + prevGb.Height + PanelPadding
        else
          gb.Top := PanelPadding;
      end;

      for j := 0 to qItems.RecordCount - 1 do
      begin
        if BoxRows = 0 then         // 0: Auto
        begin
          gb.Height := (row + 1) * ButtonHeight + 2 * BoxPadding + row * ButtonSpace + GC_HEIGHT;
          if prevGb <> nil then
            gb.Top := prevGb.Top + prevGb.Height + PanelPadding
          else
            gb.Top := PanelPadding;
        end;
        qItems.RecNo := j + 1;
        b := TButton.Create(gb);
        b.Parent := gb;
        b.Caption := qItems.FieldByName('Description').AsString;
        b.Tag := qItems.FieldByName('Id').AsInteger;
        b.OnClick := ItemClick;
        b.Height := ButtonHeight;
        b.Width := ButtonWidth;
        b.Left := BoxPadding + col * (ButtonWidth + ButtonSpace);
        b.Top := BoxPadding + row * (ButtonHeight + ButtonSpace) + GC_HEIGHT;
        Inc(col);
        if col mod BoxColumns = 0 then
        begin
          col := 0;
          Inc(row);
        end;
      end;

      prevGb := gb;
    end;  // for i := 0 to qItemGroups.RecordCount - 1

    qItemGroups.Filtered := False;
    qItems.Filtered := False;
  end;
end;

procedure TfrmPOS.ClearFoods;
begin
  while sbFoods.ControlCount > 0 do
    sbFoods.Controls[0].Free;
end;

procedure TfrmPOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmPOS.FormActivate(Sender: TObject);
var
  keys: TKeys;
  i: Integer;
  dstUsers: TDataSet;
  userLevel: Integer;
begin
  if (Screen.Width <= 1024) and (Screen.Height <= 768) then
  begin
    ShowCursor(False);
    frmPOS.WindowState := wsMaximized;
  end;
  if userId < 0 then
  begin
    dstUsers := dmMain.GetUsers;
    dstUsers.Filtered := True;
    SetLength(keys, dstUsers.RecordCount);
    dstUsers.First;
    for i := 0 to dstUsers.RecordCount - 1 do
    begin
      keys[i].id := dstUsers.FieldByName('Id').AsInteger;
      keys[i].key := dstUsers.FieldByName('Key').AsString;
      keys[i].level := dmMain.GetUserLevel(keys[i].id);
      dstUsers.Next;
    end;
    dstUsers.Filtered := False;
    if ShowLoginModal(Self, keys, 3, UL_ADMINISTRATOR) <> mrOk then
      Close;
    userId := selectedId;
//    terminalId := GetCurrentTerminalId;
    userLevel := dmMain.GetUserLevel(userId);

    pAdminButtons.Visible := userLevel <= UL_CASHIERADMIN;
    bParams.Visible := userLevel <= UL_ADMINISTRATOR;
    bUsers.Visible := userLevel <= UL_ADMINISTRATOR;
    iClose.Visible := userLevel <= UL_ADMINISTRATOR;
    bOrders.Visible := userLevel <= UL_CASHIERADMIN;
    if userLevel <= UL_ADMINISTRATOR then
    begin
      pAdminButtons.Width := 440;
      pAdminButtons.Left := 488;
      lTitle.OnMouseDown := lTitleMouseDown;
    end
    else
    begin
      pAdminButtons.Width := 296;
      pAdminButtons.Left := 632;
      lTitle.OnMouseDown := nil;
    end;

    InitFoods;
    UpdateInfo;
  end
end;

procedure TfrmPOS.UpdateInfo;
begin
  eOrderId.Visible := (dmMain.TestMode and TM_SHOWORDERID) = TM_SHOWORDERID;
  username := dmMain.GetNickname(userId);
  terminal := dmMain.GetTerminalCode(terminalId);
  stUsername.Caption := username;
  stTerminal.Caption := terminal;
  dmMain.tClock.OnTimer := UpdateClock;
  dmMain.qOrderDetails.AfterPost := UpdateOrderTotal;
  dmMain.qOrderDetails.AfterDelete := UpdateOrderTotal;
end;

procedure TfrmPOS.UpdateClock(Sender: TObject);
var
  nowTime: TDateTime;
  timeStr: String;
begin
  nowTime := Now;
  timeStr := DateToStr(nowTime) + ', ' + TimeToStr(nowTime);
  stClock.Caption := timeStr;
end;

procedure TfrmPOS.bbtnLogoutClick(Sender: TObject);
begin
  bCancelOrderClick(Self);
  userId := -1;
  FormActivate(Sender);
end;

procedure TfrmPOS.ItemClick(Sender: TObject);
var
  currentItemId: Integer;
begin
  if currentOrderId <= 0 then
  begin
    currentOrderId := dmMain.AppendOrder(dmMain.GetMaxOrderId + 1, userId, terminalId, 0, 0, 0, 1, Now, 0);
    dmMain.OpenOrderDetails(currentOrderId);
  end;
  currentItemId := (Sender as TComponent).Tag;
  dmMain.AddItem(currentOrderId, currentItemId, 1);
end;

procedure TfrmPOS.bRemoveItemClick(Sender: TObject);
var
  currentItemId: Integer;
begin
  currentItemId := dmMain.GetCurrentItem;
  if currentItemId > 0 then
    dmMain.RemoveItem(currentOrderId, currentItemId);
end;

procedure TfrmPOS.bUpClick(Sender: TObject);
begin
  if dmMain.qOrderDetails.Active then
    dmMain.qOrderDetails.Prior;
end;

procedure TfrmPOS.bDownClick(Sender: TObject);
begin
  if dmMain.qOrderDetails.Active then
    dmMain.qOrderDetails.Next;
end;

procedure TfrmPOS.bDeleteClick(Sender: TObject);
begin
  if dmMain.qOrderDetails.Active then
    dmMain.DeleteCurrentItem;
end;

procedure TfrmPOS.UpdateOrderTotal(DataSet: TDataSet);
var
  currentItemId: Integer;
begin
  currentOrderTotal := 0.0;
  if (DataSet.Active) and ((DataSet as TBDEClientDataSet).RecordCount > 0) then
  begin
    currentItemId := DataSet.FieldByName('ItemId').AsInteger;
    DataSet.DisableControls;
    DataSet.First;
    while not DataSet.Eof do
    begin
      currentOrderTotal := currentOrderTotal + DataSet.FieldByName('SubTotal').AsFloat;
      DataSet.Next;
    end;
    DataSet.Locate('ItemId', currentItemId, []);
    DataSet.EnableControls;
  end;
  stOrderTotal.Caption := FormatFloat('0.00', currentOrderTotal);
end;

function TfrmPOS.RoundUp(x: Real): Integer;
begin
  Result := Trunc(x);
  if Frac(x) >= 0.5 then
    Inc(Result);
end;

function TfrmPOS.CalcLotteryTo(amount: Real; lotteryTicketsPerEuro: Integer; lastLottery: Integer): Integer;
var
  count: Integer;
begin
  count := Round(amount * lotteryTicketsPerEuro);
  case appParams.LotteryMethod of
    0: count := RoundUp(amount * lotteryTicketsPerEuro);
    1: count := Round(amount * lotteryTicketsPerEuro);
    2: count := Trunc(amount * lotteryTicketsPerEuro);
  end;
  Result := lastLottery + count;
end;

// QR Code Generator: http://zxing.appspot.com/generator/
procedure TfrmPOS.bPayClick(Sender: TObject);
var
  lastStatus: Integer;
  clientPages: Integer;
  MaxLottery,
  LotteryFrom,
  LotteryTo: Integer;
  trying: Boolean;
begin
  with dmMain.qOrders do
    if Active then
    begin
      lastStatus := FieldByName('StatusId').AsInteger;
      if ShowPayModal(Self, currentOrderId, currentOrderTotal) = mrOk then
      begin
        Edit;
        FieldByName('TotalAmount').AsFloat := currentOrderTotal;
        FieldByName('PaidAmount').AsFloat := uPay.paidAmount;
        Post;

        trying := True;
        while trying do
        begin
          Edit;
          FieldByName('StatusId').AsInteger := 3;
          FieldByName('PrintedAt').AsDateTime := Now;
          if appParams.LotteryTicketsPerEuro > 0 then
          begin
            MaxLottery := dmMain.GetMaxLottery;
            if MaxLottery < appParams.LotteryOffset then MaxLottery := appParams.LotteryOffset;
            LotteryFrom := MaxLottery + 1;
            LotteryTo := CalcLotteryTo(currentOrderTotal, appParams.LotteryTicketsPerEuro, MaxLottery);
            if LotteryFrom <= LotteryTo then
            begin
              FieldByName('LotteryFrom').AsInteger := LotteryFrom;
              FieldByName('LotteryTo').AsInteger := LotteryTo;
            end;
          end;
          Post;

          if ApplyUpdates(0) > 0 then
          begin
            currentOrderId := dmMain.GetMaxOrderId + 1;
            Edit;
            FieldByName('Id').AsInteger := currentOrderId;
            FieldByName('StatusId').AsInteger := lastStatus;
            Post;
          end
          else
            trying := False;
        end;
        Close;
        dmMain.ApplyOrderDetails(currentOrderId);

        clientPages := 0;
//        if (appParams.PrintedTickets and PT_CLIENTTICKET) = PT_CLIENTTICKET then
//        begin
//          Inc(clientPages);
//          CreateClientTicket(Self);
//          frmClientTicket.PrepareTicketPrint(currentOrderId, false, appParams);
//          if (dmMain.TestMode and TM_PRINTPREVIEW) = TM_PRINTPREVIEW then
//            frmClientTicket.PreviewTicket
//          else
//            frmClientTicket.PrintTicket;
//          ReleaseClientTicket;
//        end;

        if (appParams.PrintedTickets and PT_ADTICKET) = PT_ADTICKET then
        begin
          Inc(clientPages);
          CreateAdTicket(Self);
          frmAdTicket.PrepareTicketPrint(currentOrderId, false, appParams);
          if (dmMain.TestMode and TM_PRINTPREVIEW) = TM_PRINTPREVIEW then
            frmAdTicket.PreviewTicket
          else
            frmAdTicket.PrintTicket;
          ReleaseAdTicket;
        end;

        if (appParams.PrintedTickets and PT_KITCHENTICKETS) = PT_KITCHENTICKETS then
        begin
          CreatePrintTicket(Self);
          frmPrintTicket.PrepareOrderPrint(currentOrderId, false, appParams, clientPages, dmMain.GetMaxItems);
          if (dmMain.TestMode and TM_PRINTPREVIEW) = TM_PRINTPREVIEW then
            frmPrintTicket.PreviewOrder
          else
            frmPrintTicket.PrintOrder;
          ReleasePrintTicket;
        end;

        currentOrderId := -1;
        UpdateOrderTotal(dmMain.qOrderDetails);
      end;      // if ShowPayModal(Self, currentOrderId, currentOrderTotal) = mrOk
    end;      // if Active
end;

procedure TfrmPOS.bAddItemClick(Sender: TObject);
var
  currentItemId: Integer;
begin
  currentItemId := dmMain.GetCurrentItem;
  if currentItemId > 0 then
    dmMain.AddItem(currentOrderId, currentItemId, 1);
end;

function TfrmPOS.GetCurrentTerminalId: Integer;
var
  reg: TRegistry;
begin
  Result := -1;
  Reg := TRegistry.Create($20019 or $0100); // for Windows 7 x64
  Reg.RootKey := RG_ROOTKEY;
  if Reg.OpenKey(RG_KEY, False) then
    Result := Reg.ReadInteger(RG_VALUENAME);
end;

procedure TfrmPOS.bCancelOrderClick(Sender: TObject);
begin
  if dmMain.qOrderDetails.Active then dmMain.qOrderDetails.CancelUpdates;
  if dmMain.qOrders.Active then
  begin
    dmMain.qOrders.CancelUpdates;
    dmMain.qOrders.Close;
  end;
  currentOrderId := -1;
  UpdateOrderTotal(dmMain.qOrderDetails);
end;

procedure TfrmPOS.bAdd10ItemsClick(Sender: TObject);
var
  currentItemId: Integer;
begin
  currentItemId := dmMain.GetCurrentItem;
  if currentItemId > 0 then
    dmMain.AddItem(currentOrderId, currentItemId, 10);
end;

procedure TfrmPOS.bStatsClick(Sender: TObject);
begin
  ShowStatsModal(Self, userId, terminalId);
end;

procedure TfrmPOS.bPrintCopyClick(Sender: TObject);
begin
  ShowPrintCopyModal(Self);
end;

procedure TfrmPOS.bBackupClick(Sender: TObject);
var
  f, e, fp, bp, t, b: String;
begin
  if terminalId = appParams.ServerTerminalId then
    f := appParams.ServerDatabaseFile
  else
    f := appParams.RemoteDatabaseFile;

  fp := ExtractFilePath(f);
  e := ExtractFileExt(f);
  bp := appParams.BackupDBPath;
  t := FormatDateTime(appParams.BackupDBSuffixFormat, Now);
  b := fp + bp + ChangeFileExt(ExtractFileName(f), '') + t + e;

  if CopyFile(PChar(f), PChar(b), false) then
    MessageDlg('Το αντίγραφο ασφαλείας της βάσης δεδομένων δημιουργήθηκε με επιτυχία', mtInformation, [mbOk], 0)
  else
    MessageDlg('Υπήρξε κάποιο πρόβλημα κατά τη δημιουργία του αντιγράφου ασφαλείας της βάσης δεδομένων', mtError, [mbOk], 0);
end;

procedure TfrmPOS.bLockClick(Sender: TObject);
begin
  LockOrdersTable;
end;

procedure TfrmPOS.bUnlockClick(Sender: TObject);
begin
  UnlockOrdersTable;
end;

procedure TfrmPOS.SetOrdersLocked(value: Integer);
var
  sql: String;
begin
  sql := 'UPDATE Params SET ParamValue = ' + IntToStr(value) + ' WHERE ParamName = ''OrdersTableLocked''';
  dbInstant.Close;
  dbInstant.Params.Append('Password=' + DB_PASSWORD);
  dbInstant.Open;
  dbInstant.Execute(sql);
  dbInstant.Close;
end;

procedure TfrmPOS.LockOrdersTable;
var
  p: Integer;
begin
  p := GetOrdersTableLocked;
  if p = 0 then
    SetOrdersLocked(terminalId)
  else
    MessageDlg('Value = ' + IntToStr(p), mtInformation, [mbOk], 0)
end;

procedure TfrmPOS.UnlockOrdersTable;
begin
  SetOrdersLocked(0);
end;

function TfrmPOS.GetOrdersTableLocked: Integer;
begin
  Result := StrToInt(dmMain.GetParamValue('OrdersTableLocked'));
end;


procedure TfrmPOS.bParamsClick(Sender: TObject);
begin
  ShowParamsModal(Self);
  InitParameters;
  InitUI;
  UpdateInfo;
end;

procedure TfrmPOS.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPOS.lTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmPOS.bOrdersClick(Sender: TObject);
begin
  ShowOrdersModal(Self);
end;

procedure TfrmPOS.bUsersClick(Sender: TObject);
begin
  ShowUsersModal(Self);
  InitTables;
end;

procedure TfrmPOS.bItemsClick(Sender: TObject);
begin
  ShowItemsModal(Self);
  InitTables;
  InitFoods;
  UpdateInfo;
end;

procedure TfrmPOS.bItemGroupsClick(Sender: TObject);
begin
  ShowItemGroupsModal(Self);
  InitTables;
  InitFoods;
  UpdateInfo;
end;

end.
