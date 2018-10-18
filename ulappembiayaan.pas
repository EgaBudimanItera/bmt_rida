unit ulappembiayaan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_View, DateTimePicker, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, Windows;

type

  { Tflappembiayaan }

  Tflappembiayaan = class(TForm)
    btCetak: TBitBtn;
    btKeluar: TBitBtn;
    btLihat: TBitBtn;
    edalamat: TEdit;
    ednama: TEdit;
    ednorek: TEdit;
    frPreview1: TfrPreview;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    procedure btCetakClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btLihatClick(Sender: TObject);
    procedure ednorekChange(Sender: TObject);
    procedure ednorekKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure reload;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  flappembiayaan: Tflappembiayaan;

implementation

uses usmartbmt, ucariregpembiayaan;

{$R *.lfm}

{ Tflappembiayaan }

procedure Tflappembiayaan.FormShow(Sender: TObject);
begin
  reload;
end;

procedure Tflappembiayaan.ednorekChange(Sender: TObject);
begin
  frPreview1.Clear;
  ednama.Text := '';
  edalamat.Text := '';
end;

procedure Tflappembiayaan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  frPreview1.Clear;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tflappembiayaan.btCetakClick(Sender: TObject);
begin
  frPreview1.Clear;
  if ednama.Text = '' then
  begin
    ShowMessage('Maaf, Data Rekening Pembiayaan Belum di isi...');
    ednorek.SetFocus;
  end
  else
  begin

    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'select norekening, tgl from transpembiayaan where norekening="' + ednorek.Text + '"');
    fsmartbmt.qproses.Open;


    if fsmartbmt.qproses.IsEmpty then
    begin
      ShowMessage('Maaf, No Rek Pembiayaan : ' + ednorek.Text + chr(10) + 'Nama : ' + ednama.Text + chr(10) + 'Belum Ada Transaksi Simpanan...');
      ednorek.SetFocus;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select transpembiayaan.norekening, pembiayaan.kodepembiayaan, settingpembiayaan.nama, pembiayaan.pelapon, pembiayaan.tglpembiayaan, pembiayaan.jwaktu, pembiayaan.tgljt, pembiayaan.pelapon, pembiayaan.angsuranpokok, pembiayaan.angsuranbagihasil, transpembiayaan.kodeanggota, anggota.nama, anggota.alamat, transpembiayaan.notrans, transpembiayaan.tgl, transpembiayaan.keterangan, transpembiayaan.pokok, transpembiayaan.basil, (transpembiayaan.pokok+transpembiayaan.basil) as totalangsuran, transpembiayaan.sisapokok, transpembiayaan.muser from transpembiayaan, anggota, pembiayaan, settingpembiayaan where transpembiayaan.kodeanggota=anggota.id and transpembiayaan.norekening=pembiayaan.norekpembiayaan and pembiayaan.kodepembiayaan=settingpembiayaan.kode and transpembiayaan.norekening="' + ednorek.Text + '" order by transpembiayaan.notrans asc ');
      fsmartbmt.qproses.Open;

      fsmartbmt.frReport1.Preview := flappembiayaan.frPreview1;
      fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lappembiayaan.lrf');
      fsmartbmt.frreport1.PrepareReport;
      fsmartbmt.frreport1.PrintPreparedReport('', 1);
      fsmartbmt.frreport1.ShowReport;
    end;
  end;
end;

procedure Tflappembiayaan.btLihatClick(Sender: TObject);
begin
  frPreview1.Clear;
  if ednama.Text = '' then
  begin
    ShowMessage('Maaf, Data Rekening Pembiayaan Belum di isi...');
    ednorek.SetFocus;
  end
  else
  begin

    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'select norekening, tgl from transpembiayaan where norekening="' + ednorek.Text + '" ');
    fsmartbmt.qproses.Open;


    if fsmartbmt.qproses.IsEmpty then
    begin
      ShowMessage('Maaf, No Rek Pembiayaan : ' + ednorek.Text + chr(10) + 'Nama : ' + ednama.Text + chr(10) + 'Belum Ada Transaksi Simpanan...');
      ednorek.SetFocus;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select transpembiayaan.norekening, pembiayaan.kodepembiayaan, settingpembiayaan.nama, pembiayaan.pelapon, pembiayaan.tglpembiayaan, pembiayaan.jwaktu, pembiayaan.tgljt, pembiayaan.pelapon, pembiayaan.angsuranpokok, pembiayaan.angsuranbagihasil, transpembiayaan.kodeanggota, anggota.nama, anggota.alamat, transpembiayaan.notrans, transpembiayaan.tgl, transpembiayaan.keterangan, transpembiayaan.pokok, transpembiayaan.basil, (transpembiayaan.pokok+transpembiayaan.basil) as totalangsuran, transpembiayaan.sisapokok, transpembiayaan.muser from transpembiayaan, anggota, pembiayaan, settingpembiayaan where transpembiayaan.kodeanggota=anggota.id and transpembiayaan.norekening=pembiayaan.norekpembiayaan and pembiayaan.kodepembiayaan=settingpembiayaan.kode and transpembiayaan.norekening="' + ednorek.Text + '" order by transpembiayaan.notrans asc ');
      fsmartbmt.qproses.Open;

      fsmartbmt.frReport1.Preview := flappembiayaan.frPreview1;
      fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lappembiayaan.lrf');
      fsmartbmt.frreport1.ShowReport;
    end;
  end;
end;

procedure Tflappembiayaan.ednorekKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    if ednorek.Text = '' then
    begin
      fcariregpembiayaan.Tag := 5;
      fcariregpembiayaan.ShowModal;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select pembiayaan.kodeanggota, anggota.nama, anggota.alamat, pembiayaan.norekpembiayaan, pembiayaan.kodepembiayaan, settingpembiayaan.nama, pembiayaan.sisaplapon, pembiayaan.angsuranpokok, pembiayaan.angsuranbagihasil from pembiayaan, anggota, settingpembiayaan where pembiayaan.kodeanggota=anggota.id and pembiayaan.kodepembiayaan=settingpembiayaan.kode and sisaplapon>0 pembiayaan.norekpembiayaan="' + ednorek.Text + '" order by pembiayaan.norekpembiayaan desc');
      fsmartbmt.qproses.Open;

      if fsmartbmt.qproses.IsEmpty then
      begin
        fcariregpembiayaan.Tag := 5;
        fcariregpembiayaan.ShowModal;
      end
      else
      begin
        ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
        edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
        btlihat.SetFocus;
      end;
    end;
end;

procedure Tflappembiayaan.reload;
var
  i: integer;
begin
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is tedit then
      TEdit(Components[i]).Clear;
  end;
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is TDateTimePicker then
      TDateTimePicker(Components[i]).Date := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
  end;
  frPreview1.Clear;
  ednorek.SetFocus;
end;

end.
