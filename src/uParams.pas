unit uParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Provider, DBTables, jpeg, ExtCtrls, StdCtrls, DB, DBClient,
  DBLocal, DBLocalB, Grids, DBGrids, ActnList;

type
  TfrmParams = class(TForm)
    pMain: TPanel;
    dbParams: TDatabase;
    qParams: TBDEClientDataSet;
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    dsParams: TDataSource;
    gMain: TDBGrid;
    bSave: TButton;
    bCancel: TButton;
    bClose: TButton;
    alMain: TActionList;
    aSave: TAction;
    aCancel: TAction;
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aCancelExecute(Sender: TObject);
    procedure aResetExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function ShowParamsModal(AnOwner: TComponent): Integer;

var
  frmParams: TfrmParams;


implementation
{$R *.dfm}
uses
  uEnv;


function ShowParamsModal(AnOwner: TComponent): Integer;
begin
  frmParams := TfrmParams.Create(AnOwner);
  Result := frmParams.ShowModal;
end;

procedure TfrmParams.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmParams.lTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmParams.bCloseClick(Sender: TObject);
begin
  qParams.CancelUpdates;
  Close;
end;

procedure TfrmParams.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmParams.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
  dbParams.Params.Append('Password=' + DB_PASSWORD);
  if not dbParams.Connected then dbParams.Open;
  if not qParams.Active then qParams.Open;
end;

procedure TfrmParams.aSaveExecute(Sender: TObject);
begin
  qParams.ApplyUpdates(0);
end;

procedure TfrmParams.aCancelExecute(Sender: TObject);
begin
  qParams.CancelUpdates;
end;

procedure TfrmParams.aResetExecute(Sender: TObject);
begin
//
end;

end.
