unit uregpembiayaan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, curredit, DateTimePicker, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, Buttons, Spin, Windows;

type

  { Tfregpembiayaan }

  Tfregpembiayaan = class(TForm)
    btBatal: TBitBtn;
    btKeluar: TBitBtn;
    btSimpan: TBitBtn;
    edtotal: TCurrencyEdit;
    edjwaktu: TCurrencyEdit;
    edbiaya: TCurrencyEdit;
    Label12: TLabel;
    Label13: TLabel;
    tgljt: TDateTimePicker;
    DBGrid1: TDBGrid;
    edalamat: TEdit;
    edkodepembiayaan: TEdit;
    ednama: TEdit;
    ednamapembiayaan: TEdit;
    ednoanggota: TEdit;
    edplapon: TCurrencyEdit;
    edpokok: TCurrencyEdit;
    edbasil: TCurrencyEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    procedure btBatalClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btSimpanClick(Sender: TObject);
    procedure edbasilKeyPress(Sender: TObject; var Key: char);
    procedure edbiayaKeyPress(Sender: TObject; var Key: char);
    procedure edjwaktuExit(Sender: TObject);
    procedure edjwaktuKeyPress(Sender: TObject; var Key: char);
    procedure edkodepembiayaanChange(Sender: TObject);
    procedure edkodepembiayaanKeyPress(Sender: TObject; var Key: char);
    procedure ednoanggotaChange(Sender: TObject);
    procedure ednoanggotaKeyPress(Sender: TObject; var Key: char);
    procedure edplaponChange(Sender: TObject);
    procedure edplaponKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure kosong;
    procedure reload;
    procedure norek;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fregpembiayaan: Tfregpembiayaan;
  norekening: string;

implementation

uses ucaripembiayaan, usmartbmt, ucarianggota, DateUtils;

{$R *.lfm}

{ Tfregpembiayaan }

procedure Tfregpembiayaan.kosong;
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
    if Components[i] is TCurrencyEdit then
      TCurrencyEdit(Components[i]).Text := '0';
  end;
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is TDateTimePicker then
      TDateTimePicker(Components[i]).Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  end;
  ednoanggota.SetFocus;
end;

procedure Tfregpembiayaan.reload;
begin
  fsmartbmt.qdata.Close;
  fsmartbmt.qdata.SQL.Clear;
  fsmartbmt.qdata.SQL.Add(
    'select pembiayaan.kodeanggota, anggota.nama, anggota.alamat, pembiayaan.norekpembiayaan, pembiayaan.kodepembiayaan, settingpembiayaan.nama, pembiayaan.pelapon, pembiayaan.tglpembiayaan, pembiayaan.jwaktu, pembiayaan.tgljt, pembiayaan.angsuranpokok, pembiayaan.angsuranbagihasil, pembiayaan.sisaplapon from pembiayaan, anggota, settingpembiayaan where pembiayaan.kodeanggota=anggota.id and pembiayaan.kodepembiayaan=settingpembiayaan.kode and pembiayaan.kodeanggota="' + ednoanggota.Text + '"');
  fsmartbmt.qdata.Open;
end;

procedure Tfregpembiayaan.norek;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select count(kodeanggota) as kodeanggota from pembiayaan where kodepembiayaan="' + edkodepembiayaan.Text + '"');
  fsmartbmt.qproses.Open;

  norekening := '20' + edkodepembiayaan.Text + FormatFloat('0000000',
    StrToInt(IntToStr(StrToInt(fsmartbmt.qproses.FieldByName('kodeanggota').AsString) + 1)));
end;

procedure Tfregpembiayaan.ednoanggotaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    if ednoanggota.Text = '' then
    begin
      fcarianggota.Tag := 3;
      fcarianggota.ShowModal;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add('select pembiayaan.kodeanggota, pembiayaan.sisaplapon from pembiayaan where pembiayaan.kodeanggota="' +
        ednoanggota.Text + '" and pembiayaan.sisaplapon>0');
      fsmartbmt.qproses.Open;

      if not fsmartbmt.qproses.IsEmpty then
      begin
        ShowMessage('Maaf, No Anggota : ' + ednoanggota.Text + chr(10) + 'Masih Mempunya Pembiayaan...'+chr(10)+'Tidak Bisa Memiliki Lebih dari Satu Pembiayaan...');
        ednoanggota.SetFocus;
      end
      else
      begin
        fsmartbmt.qproses.Close;
        fsmartbmt.qproses.SQL.Clear;
        fsmartbmt.qproses.SQL.Add('select id, nama, alamat from anggota where id="' + ednoanggota.Text + '"');
        fsmartbmt.qproses.Open;

        if fsmartbmt.qproses.IsEmpty then
        begin
          fcarianggota.Tag := 3;
          fcarianggota.ShowModal;
        end
        else
        begin
          ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
          edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
          edkodepembiayaan.SetFocus;
        end;
      end;
    end;
end;

procedure Tfregpembiayaan.edplaponChange(Sender: TObject);
begin
  edjwaktu.Text := '';
  tgljt.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  edpokok.Text := '';
  edbasil.Text := '';
  edtotal.Text := '';
  edbiaya.Text := '';
end;

procedure Tfregpembiayaan.edplaponKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edjwaktu.SetFocus;
end;

procedure Tfregpembiayaan.FormShow(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfregpembiayaan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfregpembiayaan.btSimpanClick(Sender: TObject);
begin
  if ednama.Text = '' then
  begin
    ShowMessage('Maaf, Data Anggota Belum di Isi...');
    ednoanggota.SetFocus;
  end
  else
  begin
    if ednamapembiayaan.Text = '' then
    begin
      ShowMessage('Maaf, Data Pembiayaan Belum di Isi...');
      edkodepembiayaan.SetFocus;
    end
    else
    begin
      if (edplapon.Text = '0') or (edplapon.Text = '0.00') or (edplapon.Text = '0,00') or (edplapon.Text = '') then
      begin
        ShowMessage('Maaf, Plapon Pembiayaan Belum di isi...');
        edplapon.SetFocus;
      end
      else
      begin
        if (edjwaktu.Text = '0') or (edjwaktu.Text = '0.00') or (edjwaktu.Text = '0,00') or (edjwaktu.Text = '') then
        begin
          ShowMessage('Maaf jangka Waktu Pembiyaan Minimal 1 Bulan...');
          edjwaktu.SetFocus;
        end
        else
        begin
          if (edbasil.Text = '0') or (edbasil.Text = '0.00') or (edbasil.Text = '0,00') or (edbasil.Text = '') then
          begin
            ShowMessage('Maaf, Angsuran Bagi Hasil Tidak Boleh kosong...');
            edbasil.SetFocus;
          end
          else
          begin
            norek;
            fsmartbmt.qproses.Close;
            fsmartbmt.qproses.SQL.Clear;
            fsmartbmt.qproses.SQL.Add(
              'INSERT INTO pembiayaan (kodeanggota,norekpembiayaan,kodepembiayaan,pelapon,tglpembiayaan,jwaktu,tgljt,angsuranpokok,angsuranbagihasil,biayaadm,sisaplapon) Values (:kodeanggota,:norekpembiayaan,:kodepembiayaan,:pelapon,:tglpembiayaan,:jwaktu,:tgljt,:angsuranpokok,:angsuranbagihasil,:biayaadm,:sisaplapon)');
            fsmartbmt.qproses.ParamByName('kodeanggota').AsString := ednoanggota.Text;
            fsmartbmt.qproses.ParamByName('norekpembiayaan').AsString := norekening;
            fsmartbmt.qproses.ParamByName('kodepembiayaan').AsString := edkodepembiayaan.Text;
            fsmartbmt.qproses.ParamByName('pelapon').AsFloat := StrToFloat(edplapon.Text);
            fsmartbmt.qproses.ParamByName('tglpembiayaan').AsDate := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
            fsmartbmt.qproses.ParamByName('jwaktu').AsString := edjwaktu.Text;
            fsmartbmt.qproses.ParamByName('tgljt').AsDate := tgljt.Date;
            fsmartbmt.qproses.ParamByName('angsuranpokok').AsFloat := StrToFloat(edpokok.Text);
            fsmartbmt.qproses.ParamByName('angsuranbagihasil').AsFloat := StrToFloat(edbasil.Text);
            fsmartbmt.qproses.ParamByName('biayaadm').AsFloat := StrToFloat(edbiaya.Text);
            fsmartbmt.qproses.ParamByName('sisaplapon').AsFloat := StrToFloat(edplapon.Text);
            fsmartbmt.qproses.ExecSQL;

            fsmartbmt.qproses.Close;
            fsmartbmt.qproses.SQL.Clear;
            fsmartbmt.qproses.SQL.Add(
              'INSERT INTO transaksi (tgl,uraian,nominal,ket,muser) values (:tgl,:uraian,:nominal,:ket,:muser)');
            fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
            fsmartbmt.qproses.ParamByName('uraian').AsString := 'Pencairan Pembiayaan No Rek ' + norekening + '';
            fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(edplapon.Text);
            fsmartbmt.qproses.ParamByName('ket').AsString := 'Kas Keluar';
            fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
            fsmartbmt.qproses.ExecSQL;

            fsmartbmt.qproses.Close;
            fsmartbmt.qproses.SQL.Clear;
            fsmartbmt.qproses.SQL.Add(
              'INSERT INTO transaksi (tgl,uraian,nominal,ket,muser) values (:tgl,:uraian,:nominal,:ket,:muser)');
            fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
            fsmartbmt.qproses.ParamByName('uraian').AsString := 'Pendapatan ADM Pembiayaan No Rek ' + norekening + '';
            fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(edbiaya.Text);
            fsmartbmt.qproses.ParamByName('ket').AsString := 'Kas Masuk';
            fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
            fsmartbmt.qproses.ExecSQL;

            fsmartbmt.qproses.Close;
            fsmartbmt.qproses.SQL.Clear;
            fsmartbmt.qproses.SQL.Add(
              'INSERT INTO pendapatan (tgl,uraian,nominal,muser) values (:tgl,:uraian,:nominal,:muser)');
            fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
            fsmartbmt.qproses.ParamByName('uraian').AsString := 'Pendapatan ADM Pembiayaan No Rek ' + norekening + '';
            fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(edbiaya.Text);
            fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
            fsmartbmt.qproses.ExecSQL;

            reload;
            edkodepembiayaan.Text := '';
            edkodepembiayaan.SetFocus;
          end;
        end;
      end;
    end;
  end;
end;

procedure Tfregpembiayaan.edbasilKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edbiaya.SetFocus;
end;

procedure Tfregpembiayaan.edbiayaKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btsimpan.SetFocus;
end;

procedure Tfregpembiayaan.edjwaktuExit(Sender: TObject);
var
  myDate: TDateTime;
begin
  myDate := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  myDate := IncMonth(myDate, StrToInt(edjwaktu.Text));
  tgljt.Date := myDate;

  edpokok.Text := FloatToStr(StrToFloat(edplapon.Text) / strtofloat(edjwaktu.Text));
  edbasil.Text := FloatToStr(StrToFloat(edplapon.Text) * (strtofloat('2,5') / strtofloat('100')));
  edtotal.Text := FloatToStr(StrToFloat(edpokok.Text) + strtofloat(edbasil.Text));
end;

procedure Tfregpembiayaan.edjwaktuKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edbiaya.SetFocus;
end;

procedure Tfregpembiayaan.btBatalClick(Sender: TObject);
begin
  reload;
  kosong;
end;

procedure Tfregpembiayaan.edkodepembiayaanChange(Sender: TObject);
begin
  ednamapembiayaan.Text := '';
  edplapon.Text := '';
  edjwaktu.Text := '';
  tgljt.Date := StrToDate(fsmartbmt.StatusBar1.Panels[1].Text);
  edpokok.Text := '';
  edbasil.Text := '';
  edbiaya.Text := '';
end;

procedure Tfregpembiayaan.edkodepembiayaanKeyPress(Sender: TObject; var Key: char);

begin
  if key = #13 then
    if edkodepembiayaan.Text = '' then
    begin
      fcaripembiayaan.Tag := 4;
      fcaripembiayaan.ShowModal;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add('select kode, nama from settingpembiayaan where kode="' + edkodepembiayaan.Text + '"');
      fsmartbmt.qproses.Open;

      if fsmartbmt.qproses.IsEmpty then
      begin
        fcaripembiayaan.Tag := 4;
        fcaripembiayaan.ShowModal;
      end
      else
      begin
        ednamapembiayaan.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
        edplapon.SetFocus;
      end;
    end;
end;

procedure Tfregpembiayaan.ednoanggotaChange(Sender: TObject);
begin
  reload;
  ednama.Text := '';
  edalamat.Text := '';
  edkodepembiayaan.Text := '';
end;

end.
