unit ulapsimpanan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, LR_View, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, Windows;

type

  { Tflapsimpanan }

  Tflapsimpanan = class(TForm)
    btCetak: TBitBtn;
    btKeluar: TBitBtn;
    btLihat: TBitBtn;
    awal: TDateTimePicker;
    akhir: TDateTimePicker;
    ednama: TEdit;
    edalamat: TEdit;
    ednorek: TEdit;
    frPreview1: TfrPreview;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    procedure akhirChange(Sender: TObject);
    procedure akhirKeyPress(Sender: TObject; var Key: char);
    procedure awalChange(Sender: TObject);
    procedure awalKeyPress(Sender: TObject; var Key: char);
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
  flapsimpanan: Tflapsimpanan;

implementation

uses ucariregsimpanan, usmartbmt;

{$R *.lfm}

{ Tflapsimpanan }

procedure Tflapsimpanan.FormShow(Sender: TObject);
begin
  reload;
end;

procedure Tflapsimpanan.reload;
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

procedure Tflapsimpanan.ednorekChange(Sender: TObject);
begin
  frPreview1.Clear;
  ednama.Text := '';
  edalamat.Text := '';
  awal.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  akhir.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
end;

procedure Tflapsimpanan.ednorekKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    if ednorek.Text = '' then
    begin
      fcariregsimpanan.Tag := 5;
      fcariregsimpanan.ShowModal;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select simpanan.noreksimpanan, anggota.nama, anggota.alamat from simpanan, anggota where simpanan.kodeanggota=anggota.id and simpanan.noreksimpanan="'
        + ednorek.Text + '"');
      fsmartbmt.qproses.Open;

      if fsmartbmt.qproses.IsEmpty then
      begin
        fcariregsimpanan.Tag := 5;
        fcariregsimpanan.ShowModal;
      end
      else
      begin
        ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
        edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
        awal.SetFocus;
      end;
    end;
end;

procedure Tflapsimpanan.btLihatClick(Sender: TObject);
begin
  frPreview1.Clear;
  if ednama.Text = '' then
  begin
    ShowMessage('Maaf, Data Rekening Simpanan Belum di isi...');
    ednorek.SetFocus;
  end
  else
  begin

    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'select norekening, tgl from transsimpanan where norekening="' + ednorek.Text + '" and tgl>=:aa and tgl<=:bb');
    fsmartbmt.qproses.ParamByName('aa').AsDate := awal.Date;
    fsmartbmt.qproses.ParamByName('bb').AsDate := akhir.Date;
    fsmartbmt.qproses.Open;


    if fsmartbmt.qproses.IsEmpty then
    begin
      ShowMessage('Maaf, No Rek : ' + ednorek.Text + chr(10) + 'Nama : ' + ednama.Text + chr(10) + 'Belum Ada Transaksi Simpanan...');
      ednorek.SetFocus;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select simpanan.noreksimpanan, simpanan.kodeanggota, settingsimpanan.nama, anggota.nama, anggota.alamat, transsimpanan.tgl, transsimpanan.keterangan, transsimpanan.debet, transsimpanan.kredit, transsimpanan.saldo, transsimpanan.muser from  simpanan left join anggota on simpanan.kodeanggota=anggota.id left join transsimpanan on simpanan.noreksimpanan=transsimpanan.norekening left join settingsimpanan on simpanan.kodesimpanan= settingsimpanan.kode where transsimpanan.norekening="' + ednorek.Text + '" and transsimpanan.tgl>=:aa and transsimpanan.tgl<=:bb order by transsimpanan.notrans asc');
      fsmartbmt.qproses.ParamByName('aa').AsDate := awal.Date;
      fsmartbmt.qproses.ParamByName('bb').AsDate := akhir.Date;
      fsmartbmt.qproses.Open;

      fsmartbmt.frReport1.Preview := flapsimpanan.frPreview1;
      fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapsimpanan.lrf');
      fsmartbmt.frreport1.ShowReport;
    end;
  end;
end;

procedure Tflapsimpanan.awalKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    akhir.SetFocus;
end;

procedure Tflapsimpanan.btCetakClick(Sender: TObject);
begin
  frPreview1.Clear;
  if ednama.Text = '' then
  begin
    ShowMessage('Maaf, Data Rekening Belum di isi...');
    ednorek.SetFocus;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'select norekening, tgl from transsimpanan where norekening="' + ednorek.Text + '" and tgl>=:aa and tgl<=:bb');
    fsmartbmt.qproses.ParamByName('aa').AsDate := awal.Date;
    fsmartbmt.qproses.ParamByName('bb').AsDate := akhir.Date;
    fsmartbmt.qproses.Open;

    if fsmartbmt.qproses.IsEmpty then
    begin
      ShowMessage('Maaf, No Rek : ' + ednorek.Text + chr(10) + 'Nama : ' + ednama.Text + chr(10) + 'Belum Ada Transaksi Simpanan...');
      ednorek.SetFocus;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select simpanan.noreksimpanan, simpanan.kodeanggota, settingsimpanan.nama, anggota.nama, anggota.alamat, transsimpanan.tgl, transsimpanan.keterangan, transsimpanan.debet, transsimpanan.kredit, transsimpanan.saldo, transsimpanan.muser from  simpanan left join anggota on simpanan.kodeanggota=anggota.id left join transsimpanan on simpanan.noreksimpanan=transsimpanan.norekening left join settingsimpanan on simpanan.kodesimpanan= settingsimpanan.kode where transsimpanan.norekening="' + ednorek.Text + '" and transsimpanan.tgl>=:aa and transsimpanan.tgl<=:bb');
      fsmartbmt.qproses.ParamByName('aa').AsDate := awal.Date;
      fsmartbmt.qproses.ParamByName('bb').AsDate := akhir.Date;
      fsmartbmt.qproses.Open;

      fsmartbmt.frReport1.Preview := flapsimpanan.frPreview1;
      fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapsimpanan.lrf');
      fsmartbmt.frreport1.ShowReport;
      fsmartbmt.frreport1.PrepareReport;
      fsmartbmt.frreport1.PrintPreparedReport('', 1);
    end;
  end;
end;

procedure Tflapsimpanan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible:=False;
  frPreview1.Clear;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tflapsimpanan.akhirKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btlihat.SetFocus;
end;

procedure Tflapsimpanan.akhirChange(Sender: TObject);
begin
  frPreview1.Clear;
end;

procedure Tflapsimpanan.awalChange(Sender: TObject);
begin
  frPreview1.Clear;
  akhir.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
end;

end.
