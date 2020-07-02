unit uLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, DB, DBTables, jpeg;

type
  TKey = record
    id: Integer;
    key: String;
    level: Integer;
  end;

  TKeys = array of TKey;

  TfrmLogin = class(TForm)
    pMain: TPanel;
    pBottom: TPanel;
    bOk: TButton;
    bCancel: TButton;
    pClient: TPanel;
    lMessage: TLabel;
    eKey: TEdit;
    bSeven: TButton;
    bEight: TButton;
    bNine: TButton;
    bZero: TButton;
    bDelete: TButton;
    bClear: TButton;
    bFour: TButton;
    bFive: TButton;
    bSix: TButton;
    bOne: TButton;
    bTwo: TButton;
    bThree: TButton;
    pTop: TPanel;
    lTypeKey: TLabel;
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    procedure ButtonClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure bClearClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    terminalLocked: Boolean;
    loginAttempts: Integer;
    MaxAttempts: Integer;
    AdminLevel: Integer;
    allKeys: TKeys;
    function KeyId(s: String): Integer;
    function KeyIndex(id: Integer): Integer;
  public
    { Public declarations }
  end;

function ShowLoginModal(AnOwner: TComponent; keys: TKeys; pMaxAttempts, pAdminLevel: Integer): Integer;

var
  frmLogin: TfrmLogin;
  selectedId: Integer;


implementation

{$R *.dfm}

function ShowLoginModal(AnOwner: TComponent; keys: TKeys; pMaxAttempts, pAdminLevel: Integer): Integer;
begin
  frmLogin := TfrmLogin.Create(AnOwner);
  frmLogin.loginAttempts := 0;
  frmLogin.allKeys := keys;
  frmLogin.MaxAttempts := pMaxAttempts;
  frmLogin.AdminLevel := pAdminLevel;
  frmLogin.terminalLocked := False;
  Result := frmLogin.ShowModal;
end;

procedure TfrmLogin.ButtonClick(Sender: TObject);
begin
  eKey.Text := eKey.Text + TButton(Sender).Caption;
end;

procedure TfrmLogin.bDeleteClick(Sender: TObject);
begin
  eKey.Text := Copy(eKey.Text, 1, Length(eKey.Text) - 1);
end;

procedure TfrmLogin.bClearClick(Sender: TObject);
begin
  eKey.Text := '';
end;

procedure TfrmLogin.bOkClick(Sender: TObject);
begin
  if not terminalLocked then
  begin
    Inc(loginAttempts);
    selectedId := KeyId(eKey.Text);
    if selectedId <= 0 then
    begin
      if (loginAttempts < MaxAttempts) then
      begin
        eKey.Text := '';
        lMessage.Caption := 'Λάθος κωδικός! Προσπάθειες που απομένουν: ' + IntToStr(MaxAttempts - loginAttempts);
      end
      else
      begin
//        ModalResult := mrCancel;
        lMessage.Caption := 'Παρακαλώ, επικοινωνήστε με το διαχειριστή.';
        terminalLocked := True;
    end;
    end
    else
      ModalResult := mrOk;
  end
  else
  begin
    selectedId := KeyId(eKey.Text);
    if (selectedId > 0) and (allKeys[KeyIndex(selectedId)].level = AdminLevel) then
      ModalResult := mrOk;
  end;
end;

function TfrmLogin.KeyId(s: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Length(frmLogin.allKeys) - 1 do
    if allKeys[i].key = trim(s) then Result := allKeys[i].id;
end;

function TfrmLogin.KeyIndex(id: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Length(frmLogin.allKeys) - 1 do
    if allKeys[i].id = id then Result := i;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  eKey.SetFocus;
end;

procedure TfrmLogin.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogin.lTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
end;

end.
