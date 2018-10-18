unit ucarianggota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, Windows;

type

  { Tfcarianggota }

  Tfcarianggota = class(TForm)
    DBGrid1: TDBGrid;
    edcari: TEdit;
    Label1: TLabel;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edcariChange(Sender: TObject);
    procedure edcariKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure reload;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fcarianggota: Tfcarianggota;

implementation

uses usmartbmt, uregsimpanan, uregpembiayaan;

{$R *.lfm}

{ Tfcarianggota }

procedure Tfcarianggota.reload;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select id, nama, alamat from anggota order by id desc');
  fsmartbmt.qproses.Open;
end;

procedure Tfcarianggota.edcariChange(Sender: TObject);
begin
  if edcari.Text = '' then
  begin
    reload;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Add('Select id, nama, alamat FROM anggota WHERE nama Like' + QuotedStr('%' + Edcari.Text + '%') + ' order by id desc');
    fsmartbmt.qproses.Open;
  end;
end;

procedure Tfcarianggota.DBGrid1DblClick(Sender: TObject);
begin
  if tag = 4 then
  begin
    fregsimpanan.ednoanggota.Text := fsmartbmt.qproses.FieldByName('id').AsString;
    fregsimpanan.ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
    fregsimpanan.edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
    Close;
    fregsimpanan.edkodesimpanan.SetFocus;
  end
  else
  begin
    if tag = 3 then
    begin
      fsmartbmt.qdata.Close;
      fsmartbmt.qdata.SQL.Clear;
      fsmartbmt.qdata.SQL.Add('select pembiayaan.kodeanggota, pembiayaan.sisaplapon from pembiayaan where pembiayaan.kodeanggota="' +
        fsmartbmt.qproses.FieldByName('id').AsString + '" and pembiayaan.sisaplapon>0');
      fsmartbmt.qdata.Open;

      if not fsmartbmt.qdata.IsEmpty then
      begin
        ShowMessage('Maaf, No Anggota : ' + fsmartbmt.qproses.FieldByName('id').AsString + chr(10) + 'Masih Mempunya Pembiayaan...'+chr(10)+'Tidak Bisa Memiliki Lebih dari Satu Pembiayaan...');
        edcari.SetFocus;
      end
      else
      begin
        fregpembiayaan.ednoanggota.Text := fsmartbmt.qproses.FieldByName('id').AsString;
        fregpembiayaan.ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
        fregpembiayaan.edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
        Close;
        fregpembiayaan.edkodepembiayaan.SetFocus;
      end;
    end;
  end;
end;

procedure Tfcarianggota.edcariKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    dbgrid1.SetFocus;
end;

procedure Tfcarianggota.FormShow(Sender: TObject);
begin
  reload;
  edcari.Text := '';
  edcari.SetFocus;
end;

end.
