unit uoutstandingsimbi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_View, DateTimePicker, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, Windows;

type

  { Tfoutstandingsimbi }

  Tfoutstandingsimbi = class(TForm)
    btCetak: TBitBtn;
    btKeluar: TBitBtn;
    btLihat: TBitBtn;
    cbjenis: TComboBox;
    frPreview1: TfrPreview;
    Label1: TLabel;
    Panel1: TPanel;
    procedure btCetakClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btLihatClick(Sender: TObject);
    procedure cbjenisChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  foutstandingsimbi: Tfoutstandingsimbi;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tfoutstandingsimbi }

procedure Tfoutstandingsimbi.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  frPreview1.Clear;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfoutstandingsimbi.btCetakClick(Sender: TObject);
begin
  frPreview1.Clear;
  if cbjenis.Text = '' then
  begin
    ShowMessage('Maaf, Jenis Laporan Belum di isi...');
    cbjenis.SetFocus;
  end
  else
  begin
    if cbjenis.ItemIndex = 0 then
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select simpanan.kodeanggota, anggota.nama, anggota.alamat, (simpanan.kodesimpanan) as kode, (simpanan.noreksimpanan) as norek, (settingsimpanan.nama) as namarek, (simpanan.saldo) as saldo from simpanan, anggota, settingsimpanan where simpanan.kodeanggota=anggota.id and simpanan.kodesimpanan=settingsimpanan.kode and saldo>0 order by anggota.id, simpanan.noreksimpanan asc');
      fsmartbmt.qproses.Open;

      fsmartbmt.frReport1.Preview := foutstandingsimbi.frPreview1;
      fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapoutstandingsaldo.lrf');
      fsmartbmt.frreport1.PrepareReport;
      fsmartbmt.frreport1.PrintPreparedReport('', 1);
      fsmartbmt.frreport1.ShowReport;
    end
    else
    begin
      if cbjenis.ItemIndex = 1 then
      begin
        fsmartbmt.qproses.Close;
        fsmartbmt.qproses.SQL.Clear;
        fsmartbmt.qproses.SQL.Add(
    //      'select pembiayaan.kodeanggota, anggota.nama, anggota.alamat, (pembiayaan.kodepembiayaan) as kode, (pembiayaan.norekpembiayaan) as norek, (settingpembiayaan.nama) as namarek, (pembiayaan.sisaplapon) as saldo from pembiayaan, anggota, settingpembiayaan where pembiayaan.kodeanggota=anggota.id and pembiayaan.kodepembiayaan=settingpembiayaan.kode and pembiayaan.sisaplapon>0 order by anggota.id, pembiayaan.norekpembiayaan asc');
        'select pembiayaan.kodeanggota, anggota.nama, anggota.alamat, (pembiayaan.kodepembiayaan) as kode, (pembiayaan.norekpembiayaan) as norek, (settingpembiayaan.nama) as namarek, round((pembiayaan.pelapon-pembiayaan.sisaplapon)/ pembiayaan.angsuranpokok) as angsuranmasuk, round(pembiayaan.sisaplapon/ pembiayaan.angsuranpokok) as sisaangsuran, (pembiayaan.sisaplapon) as saldo from pembiayaan, anggota, settingpembiayaan where pembiayaan.kodeanggota=anggota.id and pembiayaan.kodepembiayaan=settingpembiayaan.kode and pembiayaan.sisaplapon>0 order by anggota.id, pembiayaan.norekpembiayaan asc');
        fsmartbmt.qproses.Open;

        fsmartbmt.frReport1.Preview := foutstandingsimbi.frPreview1;
        fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapoutstandingpembiayaan.lrf.lrf');
        fsmartbmt.frreport1.PrepareReport;
        fsmartbmt.frreport1.PrintPreparedReport('', 1);
        fsmartbmt.frreport1.ShowReport;
      end;
    end;
  end;
end;

procedure Tfoutstandingsimbi.btLihatClick(Sender: TObject);
begin
  frPreview1.Clear;
  if cbjenis.Text = '' then
  begin
    ShowMessage('Maaf, Jenis Laporan Belum di isi...');
    cbjenis.SetFocus;
  end
  else
  begin
    if cbjenis.ItemIndex = 0 then
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select simpanan.kodeanggota, anggota.nama, anggota.alamat, (simpanan.kodesimpanan) as kode, (simpanan.noreksimpanan) as norek, (settingsimpanan.nama) as namarek, (simpanan.saldo) as saldo from simpanan, anggota, settingsimpanan where simpanan.kodeanggota=anggota.id and simpanan.kodesimpanan=settingsimpanan.kode and saldo>0 order by anggota.id, simpanan.noreksimpanan asc');
      fsmartbmt.qproses.Open;

      fsmartbmt.frReport1.Preview := foutstandingsimbi.frPreview1;
      fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapoutstandingsaldo.lrf');
      fsmartbmt.frreport1.ShowReport;
    end
    else
    begin
      if cbjenis.ItemIndex = 1 then
      begin
        fsmartbmt.qproses.Close;
        fsmartbmt.qproses.SQL.Clear;
        fsmartbmt.qproses.SQL.Add(
          'select pembiayaan.kodeanggota, anggota.nama, anggota.alamat, (pembiayaan.kodepembiayaan) as kode, (pembiayaan.norekpembiayaan) as norek, (settingpembiayaan.nama) as namarek, round((pembiayaan.pelapon-pembiayaan.sisaplapon)/ pembiayaan.angsuranpokok) as angsuranmasuk, round(pembiayaan.sisaplapon/ pembiayaan.angsuranpokok) as sisaangsuran, (pembiayaan.sisaplapon) as saldo from pembiayaan, anggota, settingpembiayaan where pembiayaan.kodeanggota=anggota.id and pembiayaan.kodepembiayaan=settingpembiayaan.kode and pembiayaan.sisaplapon>0 order by anggota.id, pembiayaan.norekpembiayaan asc');
        fsmartbmt.qproses.Open;

        fsmartbmt.frReport1.Preview := foutstandingsimbi.frPreview1;
        fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapoutstandingpembiayaan.lrf');
        fsmartbmt.frreport1.ShowReport;
      end;
    end;
  end;
end;

procedure Tfoutstandingsimbi.cbjenisChange(Sender: TObject);
begin
  frPreview1.Clear;
end;

procedure Tfoutstandingsimbi.FormShow(Sender: TObject);
begin
  frPreview1.Clear;
  cbjenis.ItemIndex := 0;
  btlihat.SetFocus;
end;

end.
