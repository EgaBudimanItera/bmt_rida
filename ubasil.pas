unit ubasil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_View, DateTimePicker, Forms, Controls, Windows,
  Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls;

type

  { Tfbasil }

  Tfbasil = class(TForm)
    akhir: TDateTimePicker;
    awal: TDateTimePicker;
    btCetak: TBitBtn;
    btKeluar: TBitBtn;
    btLihat: TBitBtn;
    frPreview1: TfrPreview;
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
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fbasil: Tfbasil;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tfbasil }

procedure Tfbasil.FormShow(Sender: TObject);
begin
  frPreview1.Clear;
  awal.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  akhir.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  awal.SetFocus;
end;

procedure Tfbasil.awalKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    akhir.SetFocus;
end;

procedure Tfbasil.btCetakClick(Sender: TObject);
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add(
    'select simpanan.kodeanggota, anggota.nama, simpanan.noreksimpanan, settingsimpanan.nama, simpanan.saldo, settingsimpanan.basil, (select sum(pendapatan.nominal) as nominal from pendapatan where tgl>=:aa and tgl<=:bb) as pendpatan, (simpanan.saldo/(select sum(saldo) as saldo from simpanan)*(settingsimpanan.basil/100)*(select sum(pendapatan.nominal) as nominal from pendapatan where tgl>=:aa and tgl<=:bb)) as basil from simpanan, settingsimpanan, anggota where simpanan.kodeanggota=anggota.id and simpanan.kodesimpanan=settingsimpanan.kode');
  fsmartbmt.qproses.ParamByName('aa').AsDate := awal.Date;
  fsmartbmt.qproses.ParamByName('bb').AsDate := akhir.Date;
  fsmartbmt.qproses.Open;

  fsmartbmt.frReport1.Preview := fbasil.frPreview1;
  fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapbasil.lrf');
  fsmartbmt.frreport1.ShowReport;
  fsmartbmt.frreport1.PrepareReport;
  fsmartbmt.frreport1.PrintPreparedReport('', 1);

end;

procedure Tfbasil.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  frPreview1.Clear;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfbasil.btLihatClick(Sender: TObject);
begin
  frPreview1.Clear;

  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add(
    'select simpanan.kodeanggota, anggota.nama, simpanan.noreksimpanan, settingsimpanan.nama, simpanan.saldo, settingsimpanan.basil, (select sum(pendapatan.nominal) as nominal from pendapatan where tgl>=:aa and tgl<=:bb) as pendpatan, (simpanan.saldo/(select sum(saldo) as saldo from simpanan)*(settingsimpanan.basil/100)*(select sum(pendapatan.nominal) as nominal from pendapatan where tgl>=:aa and tgl<=:bb)) as basil from simpanan, settingsimpanan, anggota where simpanan.kodeanggota=anggota.id and simpanan.kodesimpanan=settingsimpanan.kode');
  fsmartbmt.qproses.ParamByName('aa').AsDate := awal.Date;
  fsmartbmt.qproses.ParamByName('bb').AsDate := akhir.Date;
  fsmartbmt.qproses.Open;

  fsmartbmt.frReport1.Preview := fbasil.frPreview1;
  fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapbasil.lrf');
  fsmartbmt.frreport1.ShowReport;
end;

procedure Tfbasil.akhirKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btlihat.SetFocus;
end;

procedure Tfbasil.akhirChange(Sender: TObject);
begin
  frPreview1.Clear;
end;

procedure Tfbasil.awalChange(Sender: TObject);
begin
  frPreview1.Clear;
end;

end.
