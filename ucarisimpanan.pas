unit ucarisimpanan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, Windows;

type

  { Tfcarisimpanan }

  Tfcarisimpanan = class(TForm)
    DBGrid1: TDBGrid;
    edcari: TEdit;
    Label1: TLabel;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edcariChange(Sender: TObject);
    procedure edcariKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure reload;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fcarisimpanan: Tfcarisimpanan;

implementation

uses usmartbmt, uregsimpanan;

{$R *.lfm}

{ Tfcarisimpanan }

procedure Tfcarisimpanan.reload;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select kode, nama from settingsimpanan order by kode desc');
  fsmartbmt.qproses.Open;
end;

procedure Tfcarisimpanan.edcariChange(Sender: TObject);
begin
  if edcari.Text = '' then
  begin
    reload;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add('Select kode, nama FROM settingsimpanan WHERE nama Like' +
      QuotedStr('%' + Edcari.Text + '%') + ' order by kode desc');
    fsmartbmt.qproses.Open;
  end;
end;

procedure Tfcarisimpanan.edcariKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    dbgrid1.SetFocus;
end;

procedure Tfcarisimpanan.FormShow(Sender: TObject);
begin
  reload;
  edcari.Text := '';
  edcari.SetFocus;
end;

procedure Tfcarisimpanan.DBGrid1DblClick(Sender: TObject);
begin
  if tag = 4 then
  begin
    fregsimpanan.edkodesimpanan.Text := fsmartbmt.qproses.FieldByName('kode').AsString;
    fregsimpanan.ednamasimpanan.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
    Close;
    fregsimpanan.btSimpan.SetFocus;
  end;
end;

end.
