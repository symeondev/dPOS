unit uEnvDev;

interface
uses
  DBLocalB;

const
  DB_PASSWORD = 'password';


function ProduceUniqueCode(ds: TBDEClientDataSet): String;
function SeparateString(s, sep: String; count: Integer): String;
function PrintedCode(code, separator: String; digits: Integer = 4; suffle: boolean = false): String;


implementation

uses
  SysUtils;

const
  CODE_LENGTH = 28;
  translate: array[1..CODE_LENGTH] of Integer =
    (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28);


function Digits(s: String): String;
var
  i: Integer;
  temp: String;
begin
  temp := '';
  for i := 1 to Length(s) do
    if (s[i] >= '0') and (s[i] <= '9') then
      temp := temp + s[i];
  Result := temp;
end;

function DigitsSum(s: String): Integer;
var
  i, sum: Integer;
begin
  sum := 0;
  for i := 1 to Length(s) do
    if (s[i] >= '0') and (s[i] <= '9') then
      sum := sum + StrToInt(s[i]);
  Result := sum;
end;

function ProduceUniqueCode(ds: TBDEClientDataSet): String;
begin
  Result := '1234567890123456789012345678';
end;

function SeparateString(s, sep: String; count: Integer): String;
var
  i: Integer;
begin
  Result := '';
  i := 1;
  while i <= Length(s) do
  begin
    Result := Result + Copy(s, i, count) + sep;
    i := i + count;
  end;
  Delete(Result, Length(Result) - Length(sep) + 1, Length(sep));
end;

function PrintedCode(code, separator: String; digits: Integer = 4; suffle: Boolean = False): String;
var
  i: Integer;
  temp: String;
begin
  if suffle then
  begin
    temp := '';
    for i := 1 to CODE_LENGTH do
      temp := temp + code[translate[i]];
  end
  else
    temp := code;
  Result := SeparateString(temp, separator, digits);
end;

end.
