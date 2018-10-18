unit usettingsimpanan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, curredit, LSControls, DateTimePicker, Forms,
  Controls, Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, Buttons, Windows;

type

  { Tfsettingsimpanan }

  Tfsettingsimpanan = class(TForm)
    btBatal: TBitBtn;
    btKeluar: TBitBtn;
    btSimpan: TBitBtn;
    DBGrid1: TDBGrid;
    ednama: TEdit;
    edkode: TEdit;
    edbasil: TCurrencyEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    procedure btBatalClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btSimpanClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edbasilKeyPress(Sender: TObject; var Key: char);
    procedure edkodeKeyPress(Sender: TObject; var Key: char);
    procedure ednamaKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure kosong;
    procedure reload;
    procedure simpan;
    procedure edit;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fsettingsimpanan: Tfsettingsimpanan;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tfsettingsimpanan }

procedure Tfsettingsimpanan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfsettingsimpanan.btBatalClick(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfsettingsimpanan.btSimpanClick(Sender: TObject);
begin
  if (edkode.Text = '') or (ednama.Text = '') then
  begin
    ShowMessage('Maaf, Kode atau Nama Simpanan Belum di isi...');
  end
  else
  begin
    if (edkode.ReadOnly = True) then
    begin
      edit;
    end
    else
    begin
      simpan;
    end;
  end;
end;

procedure Tfsettingsimpanan.DBGrid1DblClick(Sender: TObject);
begin
  if fsmartbmt.qdata.IsEmpty then
  begin
    ShowMessage('Maaf, Data Simpanan Tidak Ada...');
    edkode.SetFocus;
  end
  else
  begin
    btsimpan.Caption := 'Edit';
    edkode.ReadOnly := True;
    edkode.Color := clGradientActiveCaption;
    edkode.Text := fsmartbmt.qdata.FieldByName('kode').AsString;
    ednama.Text := fsmartbmt.qdata.FieldByName('nama').AsString;
    edbasil.Text := fsmartbmt.qdata.FieldByName('basil').AsString;
    ednama.SetFocus;
  end;
end;

procedure Tfsettingsimpanan.edbasilKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btsimpan.SetFocus;
end;

procedure Tfsettingsimpanan.edkodeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    ednama.SetFocus;
end;

procedure Tfsettingsimpanan.ednamaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edbasil.SetFocus;
end;

procedure Tfsettingsimpanan.FormShow(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfsettingsimpanan.kosong;
var
  i: integer;
begin
  edkode.ReadOnly := False;
  edkode.Color := clDefault;
  btsimpan.Caption := 'Simpan';

  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is tedit then
      TEdit(Components[i]).Clear;
  end;
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is TCurrencyEdit then
      TCurrencyEdit(Components[i]).Clear;
  end;
  edkode.SetFocus;
end;

procedure Tfsettingsimpanan.reload;
begin
  fsmartbmt.qdata.Close;
  fsmartbmt.qdata.SQL.Clear;
  fsmartbmt.qdata.SQL.Add('select *from settingsimpanan order by kode desc');
  fsmartbmt.qdata.Open;
end;

procedure Tfsettingsimpanan.simpan;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select kode from settingsimpanan where kode = "' + edkode.Text + '"');
  fsmartbmt.qproses.Open;

  if fsmartbmt.qproses.IsEmpty then
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'INSERT INTO settingsimpanan (kode,nama,basil) values (:kode,:nama,:basil)');
    fsmartbmt.qproses.ParamByName('kode').AsString := edkode.Text;
    fsmartbmt.qproses.ParamByName('nama').AsString := ednama.Text;
    fsmartbmt.qproses.ParamByName('basil').AsFloat := StrToFloat(edbasil.Text);
    fsmartbmt.qproses.ExecSQL;

    reload;
    kosong;
  end
  else
  begin
    ShowMessage('Maaf, Nama Simpanan ' + ednama.Text + ' - ' + edkode.Text + chr(10) + 'Sudah Ada...');
    edkode.SetFocus;
  end;
end;

procedure Tfsettingsimpanan.edit;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select kode from settingsimpanan where kode = "' + edkode.Text + '"');
  fsmartbmt.qproses.Open;

  if fsmartbmt.qproses.IsEmpty then
  begin

    ShowMessage('Maaf, Simpanan ' + ednama.Text + ' - ' + edkode.Text + chr(10) + 'Sudah Ada...');
    edkode.SetFocus;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'UPDATE settingsimpanan SET nama=:nama, basil=:basil where kode=:kode');
    fsmartbmt.qproses.ParamByName('nama').AsString := ednama.Text;
    fsmartbmt.qproses.ParamByName('kode').AsString := edkode.Text;
    fsmartbmt.qproses.ParamByName('basil').AsFloat := StrToFloat(edbasil.Text);
    fsmartbmt.qproses.ExecSQL;

    reload;
    kosong;
  end;
end;


end.
