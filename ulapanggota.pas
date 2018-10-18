unit ulapanggota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DBSet, LR_View, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, Windows;

type

  { Tflapanggota }

  Tflapanggota = class(TForm)
    btLihat: TBitBtn;
    btKeluar: TBitBtn;
    btCetak: TBitBtn;
    frPreview1: TfrPreview;
    Panel1: TPanel;
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
  flapanggota: Tflapanggota;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tflapanggota }

procedure Tflapanggota.btLihatClick(Sender: TObject);
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select * from anggota order by id asc');
  fsmartbmt.qproses.Open;

  fsmartbmt.frReport1.Preview := flapanggota.frPreview1;
  frPreview1.Clear;
  fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapanggota.lrf');
  //frreport1.PrepareReport;
  //frreport1.PrintPreparedReport('', 1);
  fsmartbmt.frreport1.ShowReport;
end;

procedure Tflapanggota.FormShow(Sender: TObject);
begin
   frPreview1.Clear;
   btlihat.SetFocus;
end;

procedure Tflapanggota.btCetakClick(Sender: TObject);
begin
  frPreview1.Clear;
  btlihat.Click;
  fsmartbmt.frreport1.PrepareReport;
  fsmartbmt.frreport1.PrintPreparedReport('', 1);
end;

procedure Tflapanggota.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible:=False;
  frPreview1.Clear;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

end.
