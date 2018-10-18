unit ucariregsimpanan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls;

type

  { Tfcariregsimpanan }

  Tfcariregsimpanan = class(TForm)
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
  fcariregsimpanan: Tfcariregsimpanan;

implementation

uses ulapsimpanan, usmartbmt, utranssimpanan;

{$R *.lfm}

{ Tfcariregsimpanan }

procedure Tfcariregsimpanan.edcariKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    dbgrid1.SetFocus;
end;

procedure Tfcariregsimpanan.edcariChange(Sender: TObject);
begin
  if edcari.Text = '' then
  begin
    reload;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'select simpanan.kodeanggota, anggota.nama, anggota.alamat, simpanan.noreksimpanan, simpanan.kodesimpanan, settingsimpanan.nama, simpanan.saldo from simpanan, anggota, settingsimpanan where simpanan.kodeanggota=anggota.id and simpanan.kodesimpanan=settingsimpanan.kode and anggota.nama Like' + QuotedStr('%' + Edcari.Text + '%') + ' order by simpanan.noreksimpanan desc');
    fsmartbmt.qproses.Open;
  end;
end;

procedure Tfcariregsimpanan.DBGrid1DblClick(Sender: TObject);
begin
  if tag = 4 then
  begin
    ftranssimpanan.ednorek.Text := fsmartbmt.qproses.FieldByName('noreksimpanan').AsString;
    ftranssimpanan.edkodeanggota.Text := fsmartbmt.qproses.FieldByName('kodeanggota').AsString;
    ftranssimpanan.ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
    ftranssimpanan.edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
    ftranssimpanan.edsimpanan.Text := fsmartbmt.qproses.FieldByName('nama_1').AsString;
    ftranssimpanan.edsaldo.Text := fsmartbmt.qproses.FieldByName('saldo').AsString;
    Close;
    ftranssimpanan.cbjenis.SetFocus;
  end
  else
  begin
    if tag = 5 then
    begin
      flapsimpanan.ednorek.Text := fsmartbmt.qproses.FieldByName('noreksimpanan').AsString;
      flapsimpanan.ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
      flapsimpanan.edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
      Close;
      flapsimpanan.awal.SetFocus;
    end;
  end;
end;

procedure Tfcariregsimpanan.FormShow(Sender: TObject);
begin
  reload;
  edcari.Text := '';
  edcari.SetFocus;
end;

procedure Tfcariregsimpanan.reload;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add(
    'select simpanan.kodeanggota, anggota.nama, anggota.alamat, simpanan.noreksimpanan, simpanan.kodesimpanan, settingsimpanan.nama, simpanan.saldo from simpanan, anggota, settingsimpanan where simpanan.kodeanggota=anggota.id and simpanan.kodesimpanan=settingsimpanan.kode order by simpanan.noreksimpanan desc');
  fsmartbmt.qproses.Open;
end;

end.
