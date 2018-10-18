unit ucaripembiayaan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, Windows;

type

  { Tfcaripembiayaan }

  Tfcaripembiayaan = class(TForm)
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
  fcaripembiayaan: Tfcaripembiayaan;

implementation

uses uregpembiayaan, usmartbmt;

{$R *.lfm}

{ Tfcaripembiayaan }

procedure Tfcaripembiayaan.reload;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select kode, nama from settingpembiayaan order by kode desc');
  fsmartbmt.qproses.Open;
end;

procedure Tfcaripembiayaan.edcariChange(Sender: TObject);
begin
  if edcari.Text = '' then
  begin
    reload;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add('Select kode, nama FROM settingpembiayaan WHERE nama Like' + QuotedStr('%' + Edcari.Text + '%') +
      ' order by kode desc');
    fsmartbmt.qproses.Open;
  end;
end;

procedure Tfcaripembiayaan.DBGrid1DblClick(Sender: TObject);
begin
  if tag = 4 then
  begin
    fregpembiayaan.edkodepembiayaan.Text := fsmartbmt.qproses.FieldByName('kode').AsString;
    fregpembiayaan.ednamapembiayaan.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
    Close;
    fregpembiayaan.edplapon.SetFocus;
  end;
end;

procedure Tfcaripembiayaan.edcariKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    dbgrid1.SetFocus;
end;

procedure Tfcaripembiayaan.FormShow(Sender: TObject);
begin
  reload;
  edcari.Text := '';
  edcari.SetFocus;
end;

end.
