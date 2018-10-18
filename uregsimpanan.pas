unit uregsimpanan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, curredit, DateTimePicker, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, Buttons, Windows;

type

  { Tfregsimpanan }

  Tfregsimpanan = class(TForm)
    btBatal: TBitBtn;
    btKeluar: TBitBtn;
    btSimpan: TBitBtn;
    DBGrid1: TDBGrid;
    edalamat: TEdit;
    edkodesimpanan: TEdit;
    ednamasimpanan: TEdit;
    ednama: TEdit;
    ednoanggota: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    procedure btBatalClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btSimpanClick(Sender: TObject);
    procedure edkodesimpananChange(Sender: TObject);
    procedure ednoanggotaChange(Sender: TObject);
    procedure edpersentasiKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure kosong;
    procedure norek;
    procedure reload;
    procedure edkodesimpananKeyPress(Sender: TObject; var Key: char);
    procedure ednoanggotaKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fregsimpanan: Tfregsimpanan;
  norekening: string;

implementation

uses usmartbmt, ucarianggota, ucarisimpanan;

{$R *.lfm}

{ Tfregsimpanan }

procedure Tfregsimpanan.ednoanggotaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    if ednoanggota.Text = '' then
    begin
      fcarianggota.Tag := 4;
      fcarianggota.ShowModal;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add('select id, nama, alamat from anggota where id="' + ednoanggota.Text + '"');
      fsmartbmt.qproses.Open;

      if fsmartbmt.qproses.IsEmpty then
      begin
        fcarianggota.Tag := 4;
        fcarianggota.ShowModal;
      end
      else
      begin
        ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
        edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
        edkodesimpanan.SetFocus;
      end;
    end;
end;

procedure Tfregsimpanan.kosong;
var
  i: integer;
begin
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is tedit then
      TEdit(Components[i]).Clear;
  end;
  ednoanggota.SetFocus;
end;

procedure Tfregsimpanan.norek;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select count(kodeanggota) as kodeanggota from simpanan where kodesimpanan="' + edkodesimpanan.Text + '"');
  fsmartbmt.qproses.Open;

  norekening := '10' + edkodesimpanan.Text + FormatFloat('0000000',
    StrToInt(IntToStr(StrToInt(fsmartbmt.qproses.FieldByName('kodeanggota').AsString) + 1)));
end;

procedure Tfregsimpanan.reload;
begin
  fsmartbmt.qdata.Close;
  fsmartbmt.qdata.SQL.Clear;
  fsmartbmt.qdata.SQL.Add(
    'select simpanan.kodeanggota, anggota.nama, simpanan.noreksimpanan, simpanan.kodesimpanan, settingsimpanan.nama, simpanan.saldo from simpanan, anggota, settingsimpanan where simpanan.kodeanggota=anggota.id and simpanan.kodesimpanan=settingsimpanan.kode and simpanan.kodeanggota="' + ednoanggota.Text + '"');
  fsmartbmt.qdata.Open;
end;

procedure Tfregsimpanan.FormShow(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfregsimpanan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfregsimpanan.btSimpanClick(Sender: TObject);
begin
  if ednama.Text = '' then
  begin
    ShowMessage('Maaf, Data Anggota Belum di Isi...');
    ednoanggota.SetFocus;
  end
  else
  begin
    if ednamasimpanan.Text = '' then
    begin
      ShowMessage('Maaf, Data Simpanan Belum di Isi...');
      edkodesimpanan.SetFocus;
    end
    else
    begin
      norek;
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'INSERT INTO simpanan (kodeanggota,noreksimpanan,kodesimpanan) Values (:kodeanggota,:noreksimpanan,:kodesimpanan)');
      fsmartbmt.qproses.ParamByName('kodeanggota').AsString := ednoanggota.Text;
      fsmartbmt.qproses.ParamByName('noreksimpanan').AsString := norekening;
      fsmartbmt.qproses.ParamByName('kodesimpanan').AsString := edkodesimpanan.Text;
      fsmartbmt.qproses.ExecSQL;

      reload;
      edkodesimpanan.Text := '';
      edkodesimpanan.SetFocus;
    end;
  end;
end;

procedure Tfregsimpanan.edkodesimpananChange(Sender: TObject);
begin
  reload;
  ednamasimpanan.Text := '';
end;

procedure Tfregsimpanan.ednoanggotaChange(Sender: TObject);
begin
  reload;
  ednama.Text := '';
  edalamat.Text := '';
  edkodesimpanan.Text := '';
end;

procedure Tfregsimpanan.edpersentasiKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btsimpan.SetFocus;
end;

procedure Tfregsimpanan.btBatalClick(Sender: TObject);
begin
  kosong;
end;

procedure Tfregsimpanan.edkodesimpananKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    if edkodesimpanan.Text = '' then
    begin
      fcarisimpanan.Tag := 4;
      fcarisimpanan.ShowModal;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add('select kode, nama from settingsimpanan where kode="' + edkodesimpanan.Text + '"');
      fsmartbmt.qproses.Open;

      if fsmartbmt.qproses.IsEmpty then
      begin
        fcarisimpanan.Tag := 4;
        fcarisimpanan.ShowModal;
      end
      else
      begin
        ednamasimpanan.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
        btsimpan.SetFocus;
      end;
    end;
end;

end.
