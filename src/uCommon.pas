unit uCommon;

interface
uses
  Windows;

const
  SC_DRAGMOVE         = $F012;
  // Registry
  RG_ROOTKEY          = HKEY_LOCAL_MACHINE;
  RG_KEY              = 'SOFTWARE\dPOS';
  RG_VALUENAME        = 'TerminalId';

  // Advertisement
  AD_HEADERCOUNT        = 1;
  AD_FOOTERCOUNT        = 3;
  AD_COUNT              = AD_HEADERCOUNT + AD_FOOTERCOUNT;
  // Test mode
  TM_PRINTPREVIEW       = $01;
  TM_SHOWORDERID        = $02;
  // Printed tickets
  PT_CLIENTTICKET       = $01;
  PT_KITCHENTICKETS     = $02;
  PT_ADTICKET           = $04;
  PT_PIXELSPERMM        = 4.5;
  // User levels
  UL_ADMINISTRATOR      = 0;
  UL_CASHIERADMIN       = 3;
  UL_CASHIER            = 5;
  // UI
  // Group Caption
  GC_HEIGHT             = 10;
  // Panel Scrollbars
  PS_HORIZONTAL         = 1;
  PS_VERTICAL           = 2;
  PS_WIDTH              = 16;

type
  TFileArray = array[0..AD_COUNT - 1] of String;
  TAppParams = class(TObject)
    // Main
    CompanyTitle: String;
    ServerTerminalId: Integer;
    // UI
    LogoFile: String;
    LogoWidth,
    TitleTop,
    TitleLeft,
    TitleWidth,
    TitleHeight: Integer;
    ButtonHeight,
    ButtonWidth,
    ButtonSpace,
    BoxPadding,
    BoxColumns,
    BoxRows,
    BoxSpace,
    PanelPadding,
    PanelScrollbars: Integer;
    // Database
    ServerDatabaseFile,
    RemoteDatabaseFile,
    BackupDBPath,
    BackupDBSuffixFormat: String;
    // Printing
    CompanyName: String;
    EventName: String;
    StatisticsTimeFrom: String;
    PrintedTickets: Integer;
    BlankHeight: Integer;      // Unit: mm, Default: 125mm (567px)
    InfoFile: String;
    InfoHeight: Integer;
    // Ads
    AdFiles: TFileArray;
    // Lottery
    LotteryOffset: Integer;
    LotteryFormat: String;
    LotteryTicketsPerEuro: Integer;
    LotteryMethod: Integer;
  private
    function qParamCommand(paramName: String): String;
  public
    function GetParamValue(paramName: String): String;
  end;

var
  appParams: TAppParams;


implementation
uses
  udmMain;

function TAppParams.GetParamValue(paramName: String): String;
begin
  with dmMain.qParams do
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

function TAppParams.qParamCommand(paramName: String): String;
var
  select, from, where: String;
begin
  select := ' SELECT * ';
  from := ' FROM Params';
  where := ' WHERE ParamName = ''' + paramName + '''';
  Result := select + from + where;
end;


begin
  appParams := TAppParams.Create;
end.
