unit ucashflow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_View, DateTimePicker, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls;

type

  { Tfcashflow }

  Tfcashflow = class(TForm)
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
    procedure awalChange(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btLihatClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure kosong;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fcashflow: Tfcashflow;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tfcashflow }

procedure Tfcashflow.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfcashflow.btLihatClick(Sender: TObject);
begin
  frPreview1.Clear;

  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add(
  'select ("") as tgl, ("KAS MASUK") as uraian, (0) as nominal, ("") as ket, ("") as muser from transaksi union select ("'+FormatDateTime('dd mmmmmm yyyy',awal.Date)+'") as tgl, ("Saldo Awal") as uraian, sum(if(ket="Kas Masuk",nominal,-nominal)) as nominal, ("") as ket, ("System") as muser from transaksi where tgl<:aa union select  DATE_FORMAT(transaksi.tgl,"%d %M %Y") as tgl, transaksi.uraian, transaksi.nominal, transaksi.ket, transaksi.muser from transaksi where ket="Kas Masuk"  and tgl>=:aa and tgl<=:bb union select ("") as tgl, ("    Total Kas Masuk (A)") as uraian, sum(transaksi.nominal) as nominal, ("") as ket, ("System") as muser from transaksi where ket="Kas Masuk"  and tgl>=:aa and tgl<=:bb union select ("") as tgl, ("KAS KELUAR") as uraian, (0) as nominal, ("") as ket, ("") as muser from transaksi union select DATE_FORMAT(transaksi.tgl,"%d %M %Y") as tgl, transaksi.uraian, transaksi.nominal, transaksi.ket, transaksi.muser from transaksi where ket="Kas Keluar" and tgl>=:aa and tgl<=:bb union select ("") as tgl, ("    Total Kas Keluar (B)") as uraian, sum(transaksi.nominal) as nominal, ("") as ket, ("System") as muser from transaksi where ket="Kas Keluar" and tgl>=:aa and tgl<=:bb union select ("") as tgl, ("    Total  (A - B)") as uraian, sum(if(ket="Kas Masuk",nominal,-nominal)) as nominal, ("") as ket, ("System") as muser from transaksi  where tgl<=:bb');
  fsmartbmt.qproses.ParamByName('aa').AsDate := awal.Date;
  fsmartbmt.qproses.ParamByName('bb').AsDate := akhir.Date;
  fsmartbmt.qproses.Open;

  fsmartbmt.frReport1.Preview := fcashflow.frPreview1;
  fsmartbmt.frreport1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'report\lapcashflow.lrf');
  fsmartbmt.frreport1.ShowReport;
end;


procedure Tfcashflow.awalChange(Sender: TObject);
begin
  frPreview1.Clear;
end;

procedure Tfcashflow.akhirChange(Sender: TObject);
begin
  frPreview1.Clear;
end;

procedure Tfcashflow.FormShow(Sender: TObject);
begin
  kosong;
end;

procedure Tfcashflow.kosong;
var
  i: integer;
begin
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is TDateTimePicker then
      TDateTimePicker(Components[i]).Date := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
  end;
  frPreview1.Clear;
  awal.SetFocus;
end;

end.
