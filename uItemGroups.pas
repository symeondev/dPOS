unit uItemGroups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Provider, DBTables, StdCtrls, Grids, DBGrids, jpeg, ExtCtrls,
  DB, DBClient, DBLocal, DBLocalB, ActnList;

type
  TfrmItemGroups = class(TForm)
    alMain: TActionList;
    aSave: TAction;
    aCancel: TAction;
    dsItemGroups: TDataSource;
    qItemGroups: TBDEClientDataSet;
    dbItemGroups: TDatabase;
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    pMain: TPanel;
    gMain: TDBGrid;
    bSave: TButton;
    bCancel: TButton;
    bClose: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bCloseClick(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aCancelExecute(Sender: TObject);
    procedure gMainCellClick(Column: TColumn);
    procedure gMainColEnter(Sender: TObject);
    procedure gMainColExit(Sender: TObject);
    procedure gMainDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure gMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowItemGroupsModal(AnOwner: TComponent): Integer;


var
  frmItemGroups: TfrmItemGroups;

implementation

{$R *.dfm}

uses
  uEnv;

function ShowItemGroupsModal(AnOwner: TComponent): Integer;
begin
  frmItemGroups := TfrmItemGroups.Create(AnOwner);
  Result := frmItemGroups.ShowModal;
end;


procedure TfrmItemGroups.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmItemGroups.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
  dbItemGroups.Params.Append('Password=' + DB_PASSWORD);
  if not qItemGroups.Active then qItemGroups.Open;
end;

procedure TfrmItemGroups.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmItemGroups.lTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmItemGroups.bCloseClick(Sender: TObject);
begin
  qItemGroups.CancelUpdates;
  Close;
end;

procedure TfrmItemGroups.aSaveExecute(Sender: TObject);
begin
  qItemGroups.ApplyUpdates(0);
end;

procedure TfrmItemGroups.aCancelExecute(Sender: TObject);
begin
  qItemGroups.CancelUpdates;
end;

procedure TfrmItemGroups.gMainCellClick(Column: TColumn);
begin
  if (Column.Field.DataType = ftBoolean) then
  begin
    Column.Grid.DataSource.DataSet.Edit;
    Column.Field.Value:= not Column.Field.AsBoolean;
  end;
end;

procedure TfrmItemGroups.gMainColEnter(Sender: TObject);
var
  g: TDBGrid;
begin
  g := Sender as TDBGrid;
  if g.SelectedField.DataType = ftBoolean then
    g.Options := g.Options - [dgEditing];
end;

procedure TfrmItemGroups.gMainColExit(Sender: TObject);
var
  g: TDBGrid;
begin
  g := Sender as TDBGrid;
  if g.SelectedField.DataType = ftBoolean then
    g.Options := g.Options + [dgEditing];
end;

procedure TfrmItemGroups.gMainDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
const
  CtrlState: array[Boolean] of integer = (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED) ;
var
  g: TDBGrid;
begin
  if (Column.Field.DataType = ftBoolean) then
  begin
    g := Sender as TDBGrid;
    g.Canvas.FillRect(Rect) ;
    if VarIsNull(Column.Field.Value) then
      DrawFrameControl(g.Canvas.Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_INACTIVE) {grayed}
    else
      DrawFrameControl(g.Canvas.Handle, Rect, DFC_BUTTON, CtrlState[Column.Field.AsBoolean]); {checked or unchecked}
  end;
end;

procedure TfrmItemGroups.gMainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  g: TDBGrid;
begin
  g := Sender as TDBGrid;
  if (g.SelectedField.DataType = ftBoolean) and (Key = VK_SPACE) then
  begin
    g.DataSource.DataSet.Edit;
    g.SelectedField.Value:= not g.SelectedField.AsBoolean;
  end;
end;

end.
