object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 322
  Top = 988
  Height = 369
  Width = 620
  object dbPOS: TDatabase
    AliasName = 'pos'
    DatabaseName = 'dbdPOS'
    LoginPrompt = False
    Params.Strings = (
      '=')
    SessionName = 'Default'
    Left = 16
    Top = 16
  end
  object qItems: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM Items'#13#10'ORDER BY ItemGroupId, Id'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 56
    Top = 16
    object qItemsId: TIntegerField
      FieldName = 'Id'
    end
    object qItemsDescription: TStringField
      FieldName = 'Description'
      Size = 50
    end
    object qItemsUnit: TStringField
      FieldName = 'Unit'
    end
    object qItemsItemGroupId: TIntegerField
      FieldName = 'ItemGroupId'
    end
    object qItemsPrice: TFloatField
      FieldName = 'Price'
      DisplayFormat = '0.00'
      Precision = 2
    end
    object qItemsShow: TBooleanField
      FieldName = 'Show'
    end
  end
  object dsItems: TDataSource
    DataSet = qItems
    Left = 56
    Top = 64
  end
  object tClock: TTimer
    Interval = 500
    Left = 8
    Top = 272
  end
  object qMaxOrderId: TBDEClientDataSet
    CommandText = 'SELECT MAX(Id) as maxId'#13#10'FROM Orders'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 144
    Top = 232
  end
  object dsOrderDetails: TDataSource
    DataSet = qOrderDetails
    Left = 336
    Top = 64
  end
  object dsOrders: TDataSource
    DataSet = qOrders
    Left = 264
    Top = 64
  end
  object dsUsers: TDataSource
    DataSet = qUsers
    Left = 104
    Top = 64
  end
  object qUsers: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM Users'#13#10
    Aggregates = <>
    Filter = 'Disabled = 0'
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 104
    Top = 16
  end
  object qTerminals: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM Terminals'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 160
    Top = 16
  end
  object qOrderStatus: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM OrderStatus'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 56
    Top = 136
  end
  object qOrders: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM Orders'#13#10'WHERE Id = -1'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 264
    Top = 16
  end
  object qOrderDetails: TBDEClientDataSet
    CommandText = 
      'SELECT *'#13#10'FROM OrderDetails'#13#10'WHERE OrderId = -1'#13#10'ORDER BY OrderI' +
      'd, ItemId'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 336
    Top = 16
    object qOrderDetailsOrderId: TIntegerField
      FieldName = 'OrderId'
    end
    object qOrderDetailsItemId: TIntegerField
      FieldName = 'ItemId'
    end
    object qOrderDetailsQuantity: TIntegerField
      FieldName = 'Quantity'
    end
    object qOrderDetailsSubTotal: TFloatField
      FieldName = 'SubTotal'
      DisplayFormat = '0.00'
    end
    object qOrderDetailsItemDesc: TStringField
      FieldKind = fkLookup
      FieldName = 'ItemDesc'
      LookupDataSet = qItems
      LookupKeyFields = 'Id'
      LookupResultField = 'Description'
      KeyFields = 'ItemId'
      Lookup = True
    end
  end
  object qUserGroupLevel: TBDEClientDataSet
    CommandText = 
      'SELECT u.Id AS UserId, u.NickName AS NickName, u.UserGroupId AS ' +
      'GroupId, ug.GroupName AS GroupName, ug.GroupLevel AS UserLevel'#13#10 +
      'FROM UserGroups ug, Users u'#13#10'WHERE u.UserGroupId = ug.Id AND u.I' +
      'd = 1'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 136
    Top = 184
  end
  object qParams: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM Params'#13#10'WHERE ParamName = '#39'CompanyName'#39#13#10
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 232
    Top = 136
  end
  object qMaxLottery: TBDEClientDataSet
    CommandText = 'SELECT MAX(LotteryTo) as maxLottery'#13#10'FROM Orders'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 232
    Top = 232
  end
  object qFindLottery: TBDEClientDataSet
    CommandText = 
      'SELECT *'#13#10'FROM Orders'#13#10'WHERE LotteryFrom <= 3000127 AND LotteryT' +
      'o >=3000127'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 312
    Top = 232
  end
  object qFindOrder: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM Orders'#13#10'WHERE Id = 3608'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 384
    Top = 232
  end
  object dsTerminals: TDataSource
    DataSet = qTerminals
    Left = 160
    Top = 64
  end
  object qMaxItems: TBDEClientDataSet
    CommandText = 
      'SELECT MAX(GroupCount) AS MaxCount'#13#10'FROM'#13#10'  (SELECT ItemGroupId,' +
      ' COUNT(*) AS GroupCount'#13#10'   FROM Items'#13#10'   WHERE Show'#13#10'   GROUP ' +
      'BY ItemGroupId)'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 232
    Top = 184
  end
  object qUserGroups: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM UserGroups'
    Aggregates = <>
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 56
    Top = 184
  end
  object qItemGroups: TBDEClientDataSet
    CommandText = 'SELECT *'#13#10'FROM ItemGroups'#13#10'ORDER BY id'
    Aggregates = <>
    Filter = 'Show'
    Options = [poAllowCommandText]
    Params = <>
    DBConnection = dbPOS
    Left = 56
    Top = 232
    object qItemGroupsId: TIntegerField
      FieldName = 'Id'
    end
    object qItemGroupsDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object qItemGroupsColor: TIntegerField
      FieldName = 'Color'
    end
    object qItemGroupsShow: TBooleanField
      FieldName = 'Show'
    end
  end
end
