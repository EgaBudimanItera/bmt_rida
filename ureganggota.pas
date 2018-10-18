unit ureganggota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, curredit, DateTimePicker, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, Buttons, Windows;

type

  { Tfreganggota }

  Tfreganggota = class(TForm)
    btSimpan: TBitBtn;
    btBatal: TBitBtn;
    btKeluar: TBitBtn;
    cbjk: TComboBox;
    cbagama: TComboBox;
    cbpekerjaan: TComboBox;
    edadm: TCurrencyEdit;
    edcari: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Panel1: TPanel;
    tgllahir: TDateTimePicker;
    DBGrid1: TDBGrid;
    edno: TEdit;
    ednama: TEdit;
    edtlahir: TEdit;
    edayah: TEdit;
    edibu: TEdit;
    edalamat: TEdit;
    ednohp: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure btBatalClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btSimpanClick(Sender: TObject);
    procedure cbagamaKeyPress(Sender: TObject; var Key: char);
    procedure cbjkKeyPress(Sender: TObject; var Key: char);
    procedure cbpekerjaanKeyPress(Sender: TObject; var Key: char);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edadmKeyPress(Sender: TObject; var Key: char);
    procedure edalamatKeyPress(Sender: TObject; var Key: char);
    procedure edayahKeyPress(Sender: TObject; var Key: char);
    procedure edcariChange(Sender: TObject);
    procedure edcariKeyPress(Sender: TObject; var Key: char);
    procedure edibuKeyPress(Sender: TObject; var Key: char);
    procedure ednamaKeyPress(Sender: TObject; var Key: char);
    procedure ednohpKeyPress(Sender: TObject; var Key: char);
    procedure ednoKeyPress(Sender: TObject; var Key: char);
    procedure edtlahirKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure kosong;
    procedure reload;
    procedure tgllahirKeyPress(Sender: TObject; var Key: char);
    procedure simpan;
    procedure edit;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  freganggota: Tfreganggota;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tfreganggota }

procedure Tfreganggota.kosong;
var
  i: integer;
begin
  edno.ReadOnly := False;
  edno.Color := clDefault;
  btsimpan.Caption := 'Simpan';

  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is tedit then
      TEdit(Components[i]).Clear;
  end;
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is tCurrencyEdit then
      tCurrencyEdit(Components[i]).Clear;
  end;
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is TComboBox then
      TComboBox(Components[i]).Text := '';
  end;
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is TDateTimePicker then
      TDateTimePicker(Components[i]).Date := Now();
  end;
  edno.SetFocus;
end;

procedure Tfreganggota.reload;
begin
  fsmartbmt.qdata.Close;
  fsmartbmt.qdata.SQL.Clear;
  fsmartbmt.qdata.SQL.Add('select *from anggota order by id desc');
  fsmartbmt.qdata.Open;
end;

procedure Tfreganggota.tgllahirKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    cbjk.SetFocus;
end;

procedure Tfreganggota.simpan;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select id from anggota where id = "' + edno.Text + '"');
  fsmartbmt.qproses.Open;

  if fsmartbmt.qproses.IsEmpty then
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'INSERT INTO anggota (id,nama,tempat_lahir,tanggal_lahir,jenis_kelamin,agama,pekerjaan,ayah,ibu,alamat,no_hp) values (:id,:nama,:tempat_lahir,:tanggal_lahir,:jenis_kelamin,:agama,:pekerjaan,:ayah,:ibu,:alamat,:no_hp)');
    fsmartbmt.qproses.ParamByName('id').AsString := edno.Text;
    fsmartbmt.qproses.ParamByName('nama').AsString := ednama.Text;
    fsmartbmt.qproses.ParamByName('tempat_lahir').AsString := edtlahir.Text;
    fsmartbmt.qproses.ParamByName('tanggal_lahir').AsDateTime := tgllahir.Date;
    fsmartbmt.qproses.ParamByName('jenis_kelamin').AsString := cbjk.Text;
    fsmartbmt.qproses.ParamByName('agama').AsString := cbagama.Text;
    fsmartbmt.qproses.ParamByName('pekerjaan').AsString := cbpekerjaan.Text;
    fsmartbmt.qproses.ParamByName('ayah').AsString := edayah.Text;
    fsmartbmt.qproses.ParamByName('ibu').AsString := edibu.Text;
    fsmartbmt.qproses.ParamByName('alamat').AsString := edalamat.Text;
    fsmartbmt.qproses.ParamByName('no_hp').AsString := ednohp.Text;
    fsmartbmt.qproses.ExecSQL;

    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'INSERT INTO transaksi (tgl,uraian,nominal,ket,muser) values (:tgl,:uraian,:nominal,:ket,:muser)');
    fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
    fsmartbmt.qproses.ParamByName('uraian').AsString := 'Pendapatan Pendaftaran No Anggota ' + edno.Text + '';
    fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(edadm.Text);
    fsmartbmt.qproses.ParamByName('ket').AsString := 'Kas Masuk';
    fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
    fsmartbmt.qproses.ExecSQL;

    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'INSERT INTO pendapatan (tgl,uraian,nominal,muser) values (:tgl,:uraian,:nominal,:muser)');
    fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
    fsmartbmt.qproses.ParamByName('uraian').AsString := 'Pendapatan Pendaftaran No Anggota ' + edno.Text + '';
    fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(edadm.Text);
    fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
    fsmartbmt.qproses.ExecSQL;

    reload;
    kosong;
  end
  else
  begin
    ShowMessage('Maaf, Anggota ' + ednama.Text + ' - ' + edno.Text + chr(10) + 'Sudah Ada...');
    edno.SetFocus;
  end;
end;

procedure Tfreganggota.edit;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select id from anggota where id = "' + edno.Text + '"');
  fsmartbmt.qproses.Open;

  if fsmartbmt.qproses.IsEmpty then
  begin

    ShowMessage('Maaf, Anggota ' + ednama.Text + ' - ' + edno.Text + chr(10) + 'Sudah Ada...');
    edno.SetFocus;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'UPDATE anggota SET nama=:nama, tempat_lahir=:tempat_lahir,tanggal_lahir=:tanggal_lahir,jenis_kelamin=:jenis_kelamin,agama=:agama,pekerjaan=:pekerjaan,ayah=:ayah,ibu=:ibu,alamat=:alamat,no_hp=:no_hp where id=:id');
    fsmartbmt.qproses.ParamByName('nama').AsString := ednama.Text;
    fsmartbmt.qproses.ParamByName('tempat_lahir').AsString := edtlahir.Text;
    fsmartbmt.qproses.ParamByName('tanggal_lahir').AsDateTime := tgllahir.Date;
    fsmartbmt.qproses.ParamByName('jenis_kelamin').AsString := cbjk.Text;
    fsmartbmt.qproses.ParamByName('agama').AsString := cbagama.Text;
    fsmartbmt.qproses.ParamByName('pekerjaan').AsString := cbpekerjaan.Text;
    fsmartbmt.qproses.ParamByName('ayah').AsString := edayah.Text;
    fsmartbmt.qproses.ParamByName('ibu').AsString := edibu.Text;
    fsmartbmt.qproses.ParamByName('alamat').AsString := edalamat.Text;
    fsmartbmt.qproses.ParamByName('no_hp').AsString := ednohp.Text;
    fsmartbmt.qproses.ParamByName('id').AsString := edno.Text;
    fsmartbmt.qproses.ExecSQL;

    reload;
    kosong;
  end;
end;

procedure Tfreganggota.FormShow(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfreganggota.btBatalClick(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfreganggota.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfreganggota.btSimpanClick(Sender: TObject);
begin
  if (edno.Text = '') or (ednama.Text = '') then
  begin
    ShowMessage('Maaf, No Anggota atau Nama Belum di isi...');
  end
  else
  begin
    if (edno.ReadOnly = True) then
    begin
      edit;
    end
    else
    begin
      simpan;
    end;
  end;
end;

procedure Tfreganggota.cbagamaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    cbpekerjaan.SetFocus;
end;

procedure Tfreganggota.cbjkKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    cbagama.SetFocus;
end;

procedure Tfreganggota.cbpekerjaanKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edayah.SetFocus;
end;

procedure Tfreganggota.DBGrid1DblClick(Sender: TObject);
begin
  if fsmartbmt.qdata.IsEmpty then
  begin
    edcari.Text := '';
    ShowMessage('Maaf, Data Anggota Tidak Ada...');
    edno.SetFocus;
  end
  else
  begin
    btsimpan.Caption := 'Edit';
    edno.ReadOnly := True;
    edcari.Text := '';
    edno.Color := clGradientActiveCaption;
    edno.Text := fsmartbmt.qdata.FieldByName('id').AsString;
    ednama.Text := fsmartbmt.qdata.FieldByName('nama').AsString;
    edtlahir.Text := fsmartbmt.qdata.FieldByName('tempat_lahir').AsString;
    tgllahir.Date := fsmartbmt.qdata.FieldByName('tanggal_lahir').AsDateTime;
    cbjk.Text := fsmartbmt.qdata.FieldByName('jenis_kelamin').AsString;
    cbagama.Text := fsmartbmt.qdata.FieldByName('agama').AsString;
    cbpekerjaan.Text := fsmartbmt.qdata.FieldByName('pekerjaan').AsString;
    edayah.Text := fsmartbmt.qdata.FieldByName('ayah').AsString;
    edibu.Text := fsmartbmt.qdata.FieldByName('ibu').AsString;
    edalamat.Text := fsmartbmt.qdata.FieldByName('alamat').AsString;
    ednohp.Text := fsmartbmt.qdata.FieldByName('no_hp').AsString;
    ednama.SetFocus;
  end;
end;

procedure Tfreganggota.edadmKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btsimpan.SetFocus;
end;

procedure Tfreganggota.edalamatKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    ednohp.SetFocus;
end;

procedure Tfreganggota.edayahKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edibu.SetFocus;
end;

procedure Tfreganggota.edcariChange(Sender: TObject);
begin
  if edcari.Text = '' then
  begin
    reload;
  end
  else
  begin
    fsmartbmt.qdata.Close;
    fsmartbmt.qdata.SQL.Clear;
    fsmartbmt.qdata.SQL.Add('Select * FROM anggota WHERE nama Like' + QuotedStr('%' + Edcari.Text + '%') + ' order by id desc');
    fsmartbmt.qdata.Open;
  end;
end;

procedure Tfreganggota.edcariKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    dbgrid1.SetFocus;
end;

procedure Tfreganggota.edibuKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edalamat.SetFocus;
end;

procedure Tfreganggota.ednamaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edtlahir.SetFocus;
end;

procedure Tfreganggota.ednohpKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edadm.SetFocus;
end;

procedure Tfreganggota.ednoKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    ednama.SetFocus;
end;

procedure Tfreganggota.edtlahirKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    tgllahir.SetFocus;
end;

end.
