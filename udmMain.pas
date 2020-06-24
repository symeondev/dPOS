unit udmMain;

interface

uses
  SysUtils, Classes, Provider, DBTables, DB, DBClient, DBLocal, DBLocalB,
  ExtCtrls, Math, uCommon, uEnv;

type
  TdmMain = class(TDataModule)
    dbPOS: TDatabase;
    qItems: TBDEClientDataSet;
    dsItems: TDataSource;
    tClock: TTimer;
    qItemsId: TIntegerField;
    qItemsDescription: TStringField;
    qItemsUnit: TStringField;
    qItemsItemGroupId: TIntegerField;
    qItemsPrice: TFloatField;
    qItemsShow: TBooleanField;
    qMaxOrderId: TBDEClientDataSet;
    dsOrderDetails: TDataSource;
    dsOrders: TDataSource;
    dsUsers: TDataSource;
    qUsers: TBDEClientDataSet;
    qTerminals: TBDEClientDataSet;
    qOrderStatus: TBDEClientDataSet;
    qOrders: TBDEClientDataSet;
    qOrderDetails: TBDEClientDataSet;
    qOrderDetailsOrderId: TIntegerField;
    qOrderDetailsItemId: TIntegerField;
    qOrderDetailsQuantity: TIntegerField;
    qOrderDetailsSubTotal: TFloatField;
    qOrderDetailsItemDesc: TStringField;
    qUserGroupLevel: TBDEClientDataSet;
    qParams: TBDEClientDataSet;
    qMaxLottery: TBDEClientDataSet;
    qFindLottery: TBDEClientDataSet;
    qFindOrder: TBDEClientDataSet;
    dsTerminals: TDataSource;
    qMaxItems: TBDEClientDataSet;
    qUserGroups: TBDEClientDataSet;
    qItemGroups: TBDEClientDataSet;
    qItemGroupsId: TIntegerField;
    qItemGroupsDescription: TStringField;
    qItemGroupsColor: TIntegerField;
    qItemGroupsShow: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
  private
    function qOrderDetailsCommand(orderId: Integer): String;
    function qUserGroupLevelCommand(userId: Integer): String;
    function qParamCommand(paramName: String): String;
    function qFindLotteryCommand(lotteryNumber: Integer): String;
    function qFindOrderCommand(id: Integer): String;
  public
    function GetNickname(Id: Integer): String;
    function GetFullname(Id: Integer): String;
    function GetTerminalCode(Id: Integer): String;
    function GetTerminalDescription(Id: Integer): String;
    function GetFieldById(ds: TBDEClientDataSet; field: String; Id: Integer): String;
    function GetUsers: TDataSet;
    function GetMaxOrderId: Integer;
    function GetMaxLottery: Integer;
    function AppendOrder(Id, UserId, TerminalId: Integer;
      TotalAmount, PaidAmount, Tip: Real; StatusId: Integer;
      CreatedAt, PrintedAt: TDateTime): Integer;
    procedure OpenOrderDetails(orderId: Integer);
    procedure AppendOrderDetails(orderId, itemId, quantity: Integer; subTotal: Real);
    procedure ApplyOrderDetails(orderId: Integer);
    procedure AddItem(orderId, itemId, quantity: Integer);
    procedure RemoveItem(orderId, itemId: Integer);
    function GetItemPrice(id: Integer): Real;
    function GetCurrentItem: Integer;
    procedure DeleteCurrentItem;
    function GetUserLevel(userId: Integer): Integer;
    function GetParamValue(paramName: String): String;
    function GetOrderId(lotteryNumber: Integer): Integer;
    function GetOrder(id: Integer): Integer;
    function TestMode: Integer;
    function GetMaxItems: Integer;
  end;

var
  dmMain: TdmMain;



implementation

{$R *.dfm}

function TdmMain.qOrderDetailsCommand(orderId: Integer): String;
var
  select, from, where, orderBy: String;
begin
  select := ' SELECT *';
  from := ' FROM OrderDetails';
  where := ' WHERE OrderId = ' + IntToStr(orderId);
  orderBy := ' ORDER BY OrderId, ItemId';
  Result := select + from + where + orderBy;
end;

function TdmMain.qUserGroupLevelCommand(userId: Integer): String;
var
  select, from, where: String;
begin
  select := ' SELECT u.Id AS UserId, u.NickName AS NickName, u.UserGroupId AS GroupId, ug.GroupName AS GroupName, ug.GroupLevel AS UserLevel';
  from := ' FROM UserGroups ug, Users u';
  where := ' WHERE u.UserGroupId = ug.Id AND u.Id = ' + IntToStr(userId);
  Result := select + from + where;
end;

function TdmMain.GetUserLevel(userId: Integer): Integer;
begin
  with qUserGroupLevel do
  begin
    if Active then Close;
    CommandText := qUserGroupLevelCommand(userId);
    Open;
    if Locate('UserId', userId, []) then
      Result := FieldByName('UserLevel').AsInteger
    else
      Result := -1;
  end;
end;

function TdmMain.GetNickname(Id: Integer): String;
begin
  Result := GetFieldById(qUsers, 'NickName', Id);
end;

function TdmMain.GetFullname(Id: Integer): String;
begin
  Result := GetFieldById(qUsers, 'FullName', Id);
end;

function TdmMain.GetTerminalCode(Id: Integer): String;
begin
  Result := GetFieldById(qTerminals, 'Code', Id);
end;

function TdmMain.GetTerminalDescription(Id: Integer): String;
begin
  Result := GetFieldById(qTerminals, 'Description', Id);
end;

function TdmMain.GetFieldById(ds: TBDEClientDataSet; field: String; Id: Integer): String;
begin
  if ds.Active then ds.Close;
  ds.Open;
  if ds.Locate('Id', Id, []) then
    Result := ds.FieldByName(field).asString
  else
    Result := 'Πρόβλημα κατά την εύρεση του Id: ' + IntToStr(Id);
end;

function TdmMain.GetUsers: TDataSet;
begin
  if qUsers.Active then qUsers.Close;
  qUsers.Open;
  Result := qUsers;
end;

function TdmMain.GetMaxOrderId: Integer;
begin
  if qMaxOrderId.Active then qMaxOrderId.Close;
  qMaxOrderId.Open;
  Result :=  qMaxOrderId.FieldByName('maxId').AsInteger;
end;

function TdmMain.GetMaxLottery: Integer;
begin
  if qMaxLottery.Active then qMaxLottery.Close;
  qMaxLottery.Open;
  Result :=  qMaxLottery.FieldByName('maxLottery').AsInteger;
end;

function TdmMain.AppendOrder(Id, UserId, TerminalId: Integer;
  TotalAmount, PaidAmount, Tip: Real; StatusId: Integer;
  CreatedAt, PrintedAt: TDateTime): Integer;
begin
  qOrders.Open;
  qOrders.Append;
  qOrders.FieldByName('Id').AsInteger := Id;
  qOrders.FieldByName('UserId').AsInteger := UserId;
  qOrders.FieldByName('TerminalId').AsInteger := TerminalId;
  qOrders.FieldByName('TotalAmount').AsFloat := TotalAmount;
  qOrders.FieldByName('PaidAmount').AsFloat := PaidAmount;
  qOrders.FieldByName('Tip').AsFloat := Tip;
  qOrders.FieldByName('StatusId').AsInteger := StatusId;
  qOrders.FieldByName('CreatedAt').AsDateTime := CreatedAt;
  qOrders.FieldByName('PrintedAt').AsDateTime := PrintedAt;
  qOrders.Post;
  Result := Id;
end;

procedure TdmMain.OpenOrderDetails(orderId: Integer);
begin
  if qOrderDetails.Active then qOrderDetails.Close;
  qOrderDetails.CommandText := qOrderDetailsCommand(orderId);
  qOrderDetails.Open;
end;

procedure TdmMain.AppendOrderDetails(orderId, itemId, quantity: Integer; subTotal: Real);
begin
  with qOrderDetails do
  begin
    Append;
    FieldByName('OrderId').AsInteger := orderId;
    FieldByName('ItemId').AsInteger := itemId;
    FieldByName('Quantity').AsInteger := quantity;
    FieldByName('SubTotal').AsFloat := subTotal;
    Post;
  end;
end;

procedure TdmMain.ApplyOrderDetails(orderId: Integer);
begin
  if qOrderDetails.Active then
    with qOrderDetails do
    begin
      Last;
      while not Bof do
      begin
        Edit;
        FieldByName('OrderId').AsInteger := orderId;
        Prior;
      end;
      ApplyUpdates(0);
      Close;
      CommandText := qOrderDetailsCommand(-1);
      Open;
    end;
end;

function TdmMain.GetItemPrice(id: Integer): Real;
begin
  if not qItems.Active then qItems.Open;
  if qItems.Locate('Id', id, []) then
    Result := RoundTo(qItems.FieldByName('Price').AsFloat, -2)
  else
    Result := -1;
end;

procedure TdmMain.AddItem(orderId, itemId, quantity: Integer);
var
  newQuantity: Integer;
  newSubTotal: Real;
begin
  with qOrderDetails do
  begin
    if Locate('ItemId', itemId, []) then
    begin
      newQuantity := FieldByName('Quantity').AsInteger + quantity;
      newSubTotal := newQuantity * GetItemPrice(itemId);
      Edit;
      FieldByName('OrderId').AsInteger := orderId;
      FieldByName('ItemId').AsInteger := itemId;
      FieldByName('Quantity').AsInteger := newQuantity;
      FieldByName('SubTotal').AsFloat := newSubTotal;
      Post;
    end
    else
      AppendOrderDetails(orderId, itemId, 1, dmMain.GetItemPrice(itemId));
  end;
end;

procedure TdmMain.RemoveItem(orderId, itemId: Integer);
var
  newQuantity: Integer;
  newSubTotal: Real;
begin
  with qOrderDetails do
    if Locate('ItemId', itemId, []) then
    begin
      newQuantity := FieldByName('Quantity').AsInteger;
      if newQuantity > 1 then
      begin
        newQuantity := newQuantity - 1;
        newSubTotal := newQuantity * GetItemPrice(itemId);
        Edit;
        FieldByName('Quantity').AsInteger := newQuantity;
        FieldByName('SubTotal').AsFloat := newSubTotal;
        Post;
      end
      else
        Delete;
    end;
end;

function TdmMain.GetCurrentItem: Integer;
begin
  Result := -1;
  if (qOrderDetails.Active) and (qOrderDetails.RecordCount > 0) then
    Result := qOrderDetails.FieldByName('ItemId').AsInteger;
end;

procedure TdmMain.DeleteCurrentItem;
begin
  if qOrderDetails.RecordCount > 0 then
    qOrderDetails.Delete;
end;

function TdmMain.GetParamValue(paramName: String): String;
begin
  with qParams do
  begin
    if Active then Close;
    CommandText := qParamCommand(paramName);
    Open;
    if Locate('ParamName', paramName, []) then
      Result := FieldByName('ParamValue').AsString
    else
      Result := '';
  end;
end;

function TdmMain.qParamCommand(paramName: String): String;
var
  select, from, where: String;
begin
  select := ' SELECT * ';
  from := ' FROM Params';
  where := ' WHERE ParamName = ''' + paramName + '''';
  Result := select + from + where;
end;

function TdmMain.GetOrderId(lotteryNumber: Integer): Integer;
begin
  with qFindLottery do
  begin
    if Active then Close;
    CommandText := qFindLotteryCommand(lotteryNumber);
    Open;
    Result := FieldByName('Id').AsInteger;
  end;
end;

function TdmMain.qFindLotteryCommand(lotteryNumber: Integer): String;
var
  select, from, where: String;
  lotteryStr: String;
begin
  lotteryStr := IntToStr(lotteryNumber);
  select := ' SELECT * ';
  from := ' FROM Orders';
  where := ' WHERE LotteryFrom <= ' + lotteryStr + ' AND LotteryTo >= ' + lotteryStr;
  Result := select + from + where;
end;

function TdmMain.GetOrder(id: Integer): Integer;
begin
  with qFindLottery do
  begin
    if Active then Close;
    CommandText := qFindOrderCommand(id);
    Open;
    Result := FieldByName('Id').AsInteger;
  end;
end;

function TdmMain.qFindOrderCommand(id: Integer): String;
var
  select, from, where: String;
begin
  select := ' SELECT * ';
  from := ' FROM Orders';
  where := ' WHERE Id = ' + IntToStr(id);
  Result := select + from + where;
end;

function TdmMain.TestMode: Integer;
begin
  Result := StrToInt(GetParamValue('TestMode'));
end;

function TdmMain.GetMaxItems: Integer;
begin
  if qMaxItems.Active then qMaxItems.Close;
  qMaxItems.Open;
  Result := qMaxItems.FieldByName('MaxCount').AsInteger;
end;



procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  dbPOS.Params.Append('Password=' + DB_PASSWORD);
end;

end.
