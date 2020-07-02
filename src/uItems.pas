unit uItems;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, udmMain, Provider, DBTables, DB, StdCtrls, Grids, DBGrids, jpeg,
  ExtCtrls, DBClient, DBLocal, DBLocalB, ActnList;

type
  TfrmItems = class(TForm)
    dbAllItems: TDatabase;
    qAllItems: TBDEClientDataSet;
    dsAllItems: TDataSource;
    pTitle: TPanel;
    lTitle: TLabel;
    iClose: TImage;
    pMain: TPanel;
    gMain: TDBGrid;
    bSave: TButton;
    bCancel: TButton;
    bClose: TButton;
    qAllItemsId: TIntegerField;
    qAllItemsDescription: TStringField;
    qAllItemsUnit: TStringField;
    qAllItemsItemGroupId: TIntegerField;
    qAllItemsPrice: TFloatField;
    qAllItemsShow: TBooleanField;
    qAllItemsItemGroup: TStringField;
    alMain: TActionList;
    aSave: TAction;
    aCancel: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure iCloseClick(Sender: TObject);
    procedure lTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bCloseClick(Sender: TObject);
    procedure gMainDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure gMainCellClick(Column: TColumn);
    procedure gMainColEnter(Sender: TObject);
    procedure gMainColExit(Sender: TObject);
    procedure gMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aSaveExecute(Sender: TObject);
    procedure aCancelExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowItemsModal(AnOwner: TComponent): Integer;


var
  frmItems: TfrmItems;

implementation

{$R *.dfm}

uses
  uEnv;


function ShowItemsModal(AnOwner: TComponent): Integer;
begin
  frmItems := TfrmItems.Create(AnOwner);
  Result := frmItems.ShowModal;
end;

procedure TfrmItems.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmItems.FormCreate(Sender: TObject);
begin
  lTitle.Caption := Caption;
  dbAllItems.Params.Append('Password=' + DB_PASSWORD);
  if not qAllItems.Active then qAllItems.Open;
end;

procedure TfrmItems.iCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmItems.lTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    (Sender as TLabel).Parent.Parent.Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmItems.bCloseClick(Sender: TObject);
begin
  qAllItems.CancelUpdates;
  Close;
end;

procedure TfrmItems.gMainDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
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

procedure TfrmItems.gMainCellClick(Column: TColumn);
begin
  if (Column.Field.DataType = ftBoolean) then
  begin
    Column.Grid.DataSource.DataSet.Edit;
    Column.Field.Value:= not Column.Field.AsBoolean;
  end;
end;

procedure TfrmItems.gMainColEnter(Sender: TObject);
var
  g: TDBGrid;
begin
  g := Sender as TDBGrid;
  if g.SelectedField.DataType = ftBoolean then
    g.Options := g.Options - [dgEditing];
end;

procedure TfrmItems.gMainColExit(Sender: TObject);
var
  g: TDBGrid;
begin
  g := Sender as TDBGrid;
  if g.SelectedField.DataType = ftBoolean then
    g.Options := g.Options + [dgEditing];
end;

procedure TfrmItems.gMainKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmItems.aSaveExecute(Sender: TObject);
begin
  qAllItems.ApplyUpdates(0);
end;

procedure TfrmItems.aCancelExecute(Sender: TObject);
begin
  qAllItems.CancelUpdates;
end;

end.
