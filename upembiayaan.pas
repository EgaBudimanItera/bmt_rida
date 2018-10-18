unit upembiayaan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, curredit, Forms, Controls, Graphics, Dialogs,
  DBGrids, StdCtrls, ExtCtrls, Buttons, Windows;

type

  { Tfpembiayaan }

  Tfpembiayaan = class(TForm)
    btBatal: TBitBtn;
    btKeluar: TBitBtn;
    btSimpan: TBitBtn;
    DBGrid1: TDBGrid;
    edkode: TEdit;
    ednama: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    procedure btBatalClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btSimpanClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
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
  fpembiayaan: Tfpembiayaan;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tfpembiayaan }

procedure Tfpembiayaan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfpembiayaan.btBatalClick(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfpembiayaan.btSimpanClick(Sender: TObject);
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

procedure Tfpembiayaan.DBGrid1DblClick(Sender: TObject);
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
    ednama.SetFocus;
  end;
end;

procedure Tfpembiayaan.edkodeKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    ednama.SetFocus;
end;

procedure Tfpembiayaan.ednamaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btsimpan.SetFocus;
end;

procedure Tfpembiayaan.FormShow(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfpembiayaan.kosong;
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
  edkode.SetFocus;
end;

procedure Tfpembiayaan.reload;
begin
  fsmartbmt.qdata.Close;
  fsmartbmt.qdata.SQL.Clear;
  fsmartbmt.qdata.SQL.Add('select *from settingpembiayaan order by kode desc');
  fsmartbmt.qdata.Open;
end;

procedure Tfpembiayaan.simpan;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select kode from settingpembiayaan where kode = "' + edkode.Text + '"');
  fsmartbmt.qproses.Open;

  if fsmartbmt.qproses.IsEmpty then
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'INSERT INTO settingpembiayaan (kode,nama) values (:kode,:nama)');
    fsmartbmt.qproses.ParamByName('kode').AsString := edkode.Text;
    fsmartbmt.qproses.ParamByName('nama').AsString := ednama.Text;
    fsmartbmt.qproses.ExecSQL;

    reload;
    kosong;
  end
  else
  begin
    ShowMessage('Maaf, Nama Pembiayaan ' + ednama.Text + ' - ' + edkode.Text + chr(10) + 'Sudah Ada...');
    edkode.SetFocus;
  end;
end;

procedure Tfpembiayaan.edit;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select kode from settingpembiayaan where kode = "' + edkode.Text + '"');
  fsmartbmt.qproses.Open;

  if fsmartbmt.qproses.IsEmpty then
  begin

    ShowMessage('Maaf, Pembiyaan ' + ednama.Text + ' - ' + edkode.Text + chr(10) + 'Sudah Ada...');
    edkode.SetFocus;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add(
      'UPDATE settingpembiayaan SET nama=:nama where kode=:kode');
    fsmartbmt.qproses.ParamByName('nama').AsString := ednama.Text;
    fsmartbmt.qproses.ParamByName('kode').AsString := edkode.Text;
    fsmartbmt.qproses.ExecSQL;

    reload;
    kosong;
  end;
end;

end.
