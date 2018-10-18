unit upendapatan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, LR_View, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, Windows;

type

  { Tfpendapatan }

  Tfpendapatan = class(TForm)
    akhir: TDateTimePicker;
    awal: TDateTimePicker;
    btCetak: TBitBtn;
    btKeluar: TBitBtn;
    btLihat: TBitBtn;
    frPreview1: TfrPreview;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    procedure akhirKeyPress(Sender: TObject; var Key: char);
    procedure awalKeyPress(Sender: TObject; var Key: char);
    procedure btKeluarClick(Sender: TObject);
    procedure btLihatClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fpendapatan: Tfpendapatan;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tfpendapatan }

procedure Tfpendapatan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  frPreview1.Clear;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfpendapatan.awalKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    akhir.SetFocus;
end;

procedure Tfpendapatan.akhirKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btlihat.SetFocus;
end;

procedure Tfpendapatan.btLihatClick(Sender: TObject);
begin
  frPreview1.Clear;

  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('DELETE FROM pendapatan WHERE nominal=0');
  fsmartbmt.qproses.ExecSQL;

  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add(
    'SELECT * FROM pendapatan WHERE tgl>=:aa AND tgl<=:bb ORDER BY tgl ASC');
  fsmartbmt.qproses.ParamByName('aa').AsDate := awal.Date;
  fsmartbmt.qproses.ParamByName('bb').AsDate := akhir.Date;
  fsmartbmt.qproses.Open;

  fsmartbmt.frReport1.Preview := fpendapatan.frPreview1;
  fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lappendapatan.lrf');
  fsmartbmt.frreport1.ShowReport;
end;

procedure Tfpendapatan.FormShow(Sender: TObject);
begin
  frPreview1.Clear;
  awal.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  akhir.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  awal.SetFocus;
end;

end.
