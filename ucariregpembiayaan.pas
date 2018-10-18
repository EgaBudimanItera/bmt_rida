unit ucariregpembiayaan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, Windows;

type

  { Tfcariregpembiayaan }

  Tfcariregpembiayaan = class(TForm)
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
  fcariregpembiayaan: Tfcariregpembiayaan;

implementation

uses ulappembiayaan, utranspembiayaan, usmartbmt;

{$R *.lfm}

{ Tfcariregpembiayaan }

procedure Tfcariregpembiayaan.edcariKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    dbgrid1.SetFocus;
end;

procedure Tfcariregpembiayaan.FormShow(Sender: TObject);
begin
  reload;
  edcari.Text := '';
  edcari.SetFocus;
end;

procedure Tfcariregpembiayaan.reload;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add(
    'select pembiayaan.kodeanggota, anggota.nama, anggota.alamat, pembiayaan.norekpembiayaan, pembiayaan.kodepembiayaan, settingpembiayaan.nama, pembiayaan.sisaplapon, pembiayaan.angsuranpokok, pembiayaan.angsuranbagihasil from pembiayaan, anggota, settingpembiayaan where pembiayaan.kodeanggota=anggota.id and pembiayaan.kodepembiayaan=settingpembiayaan.kode and sisaplapon>0 order by pembiayaan.norekpembiayaan desc');
  fsmartbmt.qproses.Open;
end;

procedure Tfcariregpembiayaan.edcariChange(Sender: TObject);
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
      'select pembiayaan.kodeanggota, anggota.nama, anggota.alamat, pembiayaan.norekpembiayaan, pembiayaan.kodepembiayaan, settingpembiayaan.nama, pembiayaan.sisaplapon, pembiayaan.angsuranpokok, pembiayaan.angsuranbagihasil from pembiayaan, anggota, settingpembiayaan where pembiayaan.kodeanggota=anggota.id and pembiayaan.kodepembiayaan=settingpembiayaan.kode and sisaplapon>0  and anggota.nama Like' + QuotedStr('%' + Edcari.Text + '%') + ' order by pembiayaan.norekpembiayaan desc');
    fsmartbmt.qproses.Open;
  end;
end;

procedure Tfcariregpembiayaan.DBGrid1DblClick(Sender: TObject);
begin
  if tag = 4 then
  begin
    ftranspembiayaan.ednorek.Text := fsmartbmt.qproses.FieldByName('norekpembiayaan').AsString;
    ftranspembiayaan.edkodeanggota.Text := fsmartbmt.qproses.FieldByName('kodeanggota').AsString;
    ftranspembiayaan.ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
    ftranspembiayaan.edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
    ftranspembiayaan.edpembiayaan.Text := fsmartbmt.qproses.FieldByName('nama_1').AsString;
    ftranspembiayaan.edsisa.Text := fsmartbmt.qproses.FieldByName('sisaplapon').AsString;
    ftranspembiayaan.edpokok.Text := fsmartbmt.qproses.FieldByName('angsuranpokok').AsString;
    ftranspembiayaan.edbasil.Text := fsmartbmt.qproses.FieldByName('angsuranbagihasil').AsString;
    Close;
    ftranspembiayaan.edpokok.SetFocus;
  end
  else
  begin
    if tag = 5 then
    begin
      flappembiayaan.ednorek.Text := fsmartbmt.qproses.FieldByName('norekpembiayaan').AsString;
      flappembiayaan.ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
      flappembiayaan.edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
      Close;
      flappembiayaan.btLihat.SetFocus;
    end;
  end;
end;

end.
