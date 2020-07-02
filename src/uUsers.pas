unit uUsers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Provider, DBTables, DB, DBClient,
  DBLocal, DBLocalB, Grids, DBGrids, udmMain, ActnList;

type
  TfrmUsers = class(TForm)
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    pMain: TPanel;
    gMain: TDBGrid;
    bSave: TButton;
    bCancel: TButton;
    bClose: TButton;
    dbAllUsers: TDatabase;
    qAllUsers: TBDEClientDataSet;
    dsAllUser: TDataSource;
    qAllUsersId: TIntegerField;
    qAllUsersNickName: TStringField;
    qAllUsersFullName: TStringField;
    qAllUsersKey: TStringField;
    qAllUsersUserGroupId: TIntegerField;
    qAllUsersDisabled: TIntegerField;
    qAllUsersUserGroup: TStringField;
    alMain: TActionList;
    aSave: TAction;
    aCancel: TAction;
    procedure iCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bCloseClick(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aCancelExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowUsersModal(AnOwner: TComponent): Integer;


var
  frmUsers: TfrmUsers;

implementation
{$R *.dfm}
uses
  uEnv;

function ShowUsersModal(AnOwner: TComponent): Integer;
begin
  frmUsers := TfrmUsers.Create(AnOwner);
  Result := frmUsers.ShowModal;
end;

procedure TfrmUsers.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUsers.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
  dbAllUsers.Params.Append('Password=' + DB_PASSWORD);
  if not qAllUsers.Active then qAllUsers.Open;
end;

procedure TfrmUsers.lTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmUsers.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmUsers.bCloseClick(Sender: TObject);
begin
  qAllUsers.CancelUpdates;
  Close;
end;

procedure TfrmUsers.aSaveExecute(Sender: TObject);
begin
  qAllUsers.ApplyUpdates(0);
end;

procedure TfrmUsers.aCancelExecute(Sender: TObject);
begin
  qAllUsers.CancelUpdates;
end;

end.
