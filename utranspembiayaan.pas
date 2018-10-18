unit utranspembiayaan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, curredit, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type

  { Tftranspembiayaan }

  Tftranspembiayaan = class(TForm)
    btBatal: TBitBtn;
    btKeluar: TBitBtn;
    btSimpan: TBitBtn;
    edalamat: TEdit;
    edketerangan: TEdit;
    edkodeanggota: TEdit;
    ednama: TEdit;
    edpokok: TCurrencyEdit;
    edbasil: TCurrencyEdit;
    ednorek: TEdit;
    edsisa: TCurrencyEdit;
    edpembiayaan: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    procedure btBatalClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btSimpanClick(Sender: TObject);
    procedure edbasilKeyPress(Sender: TObject; var Key: char);
    procedure edketeranganKeyPress(Sender: TObject; var Key: char);
    procedure ednorekKeyPress(Sender: TObject; var Key: char);
    procedure edpokokKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure kosong;
    procedure no;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ftranspembiayaan: Tftranspembiayaan;
  notrans, kodeanggota: string;

implementation

uses usmartbmt, ucariregpembiayaan;

{$R *.lfm}

{ Tftranspembiayaan }

procedure Tftranspembiayaan.ednorekKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    if ednorek.Text = '' then
    begin
      fcariregpembiayaan.Tag := 4;
      fcariregpembiayaan.ShowModal;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select pembiayaan.kodeanggota, anggota.nama, anggota.alamat, pembiayaan.norekpembiayaan, pembiayaan.kodepembiayaan, settingpembiayaan.nama, pembiayaan.sisaplapon, pembiayaan.angsuranpokok, pembiayaan.angsuranbagihasil from pembiayaan, anggota, settingpembiayaan where pembiayaan.kodeanggota=anggota.id and pembiayaan.kodepembiayaan=settingpembiayaan.kode and pembiayaan.norekpembiayaan="' + ednorek.Text + '"');
      fsmartbmt.qproses.Open;

      if fsmartbmt.qproses.IsEmpty then
      begin
        fcariregpembiayaan.Tag := 4;
        fcariregpembiayaan.ShowModal;

      end
      else
      begin
        edkodeanggota.Text := fsmartbmt.qproses.FieldByName('kodeanggota').AsString;
        ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
        edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
        edpembiayaan.Text := fsmartbmt.qproses.FieldByName('nama_1').AsString;
        edsisa.Text := fsmartbmt.qproses.FieldByName('sisaplapon').AsString;
        edpokok.Text := fsmartbmt.qproses.FieldByName('angsuranpokok').AsString;
        edbasil.Text := fsmartbmt.qproses.FieldByName('angsuranbagihasil').AsString;
        edpokok.SetFocus;
      end;
    end;
end;

procedure Tftranspembiayaan.edpokokKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edbasil.SetFocus;
end;

procedure Tftranspembiayaan.FormShow(Sender: TObject);
begin
  kosong;
end;

procedure Tftranspembiayaan.kosong;
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
    if Components[i] is tCurrencyEdit then
      tCurrencyEdit(Components[i]).Clear;
  end;
  for i := 0 to componentcount - 1 do
  begin
    if Components[i] is TComboBox then
      TComboBox(Components[i]).ItemIndex := 0;
  end;
  ednorek.SetFocus;
end;

procedure Tftranspembiayaan.no;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select count(notrans) as notrans from transpembiayaan');
  fsmartbmt.qproses.Open;

  notrans := FormatFloat('0000000', StrToInt(IntToStr(StrToInt(fsmartbmt.qproses.FieldByName('notrans').AsString) + 1)));
end;

procedure Tftranspembiayaan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tftranspembiayaan.btSimpanClick(Sender: TObject);
var
  sisa1, pokok1: double;
begin
  if ednama.Text = '' then
  begin
    ShowMessage('Maaf, Data Rekening Pembiayaan Belum di Isi...');
    ednorek.SetFocus;
  end
  else
  begin
    if (edsisa.Text = '0') or (edsisa.Text = '0.00') or (edsisa.Text = '0,00') or (edsisa.Text = '') then
    begin
      ShowMessage('Maaf, Sisa Pokok Sudah Nol / Lunas...');
      ednorek.SetFocus;
    end
    else
    begin
      sisa1 := strtofloat(edsisa.Text);
      pokok1 := strtofloat(edpokok.Text);

      if sisa1 < pokok1 then
      begin
        ShowMessage('Maaf, Angsuran Pokok Teralu Besar..' + chr(10) + 'Sisa Pokok ' + edsisa.Text + '');
        edpokok.SetFocus;
      end
      else
      begin
        no;
        fsmartbmt.qproses.Close;
        fsmartbmt.qproses.SQL.Clear;
        fsmartbmt.qproses.SQL.Add(
          'INSERT INTO transpembiayaan (norekening,kodeanggota,notrans,tgl,keterangan,pokok,basil,sisapokok,muser) Values (:norekening,:kodeanggota,:notrans,:tgl,:keterangan,:pokok,:basil,:sisapokok,:muser)');
        fsmartbmt.qproses.ParamByName('norekening').AsString := ednorek.Text;
        fsmartbmt.qproses.ParamByName('kodeanggota').AsString := edkodeanggota.Text;
        fsmartbmt.qproses.ParamByName('notrans').AsString := notrans;
        fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
        fsmartbmt.qproses.ParamByName('keterangan').AsString := 'Angsuran : ' + edketerangan.Text;
        fsmartbmt.qproses.ParamByName('pokok').AsFloat := strtofloat(edpokok.Text);
        fsmartbmt.qproses.ParamByName('basil').AsFloat := strtofloat(edbasil.Text);
        fsmartbmt.qproses.ParamByName('sisapokok').AsFloat := sisa1 - pokok1;
        fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
        fsmartbmt.qproses.ExecSQL;

        fsmartbmt.qproses.Close;
        fsmartbmt.qproses.SQL.Clear;
        fsmartbmt.qproses.SQL.Add(
          'INSERT INTO transaksi (tgl,uraian,nominal,ket,muser) values (:tgl,:uraian,:nominal,:ket,:muser)');
        fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
        fsmartbmt.qproses.ParamByName('uraian').AsString := 'Angsuran Pokok No Rek ' + ednorek.Text + '';
        fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(edpokok.Text);
        fsmartbmt.qproses.ParamByName('ket').AsString := 'Kas Masuk';
        fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
        fsmartbmt.qproses.ExecSQL;


        fsmartbmt.qproses.Close;
        fsmartbmt.qproses.SQL.Clear;
        fsmartbmt.qproses.SQL.Add(
          'INSERT INTO transaksi (tgl,uraian,nominal,ket,muser) values (:tgl,:uraian,:nominal,:ket,:muser)');
        fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
        fsmartbmt.qproses.ParamByName('uraian').AsString := 'Angsuran Bagi Hasil No Rek ' + ednorek.Text + '';
        fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(edbasil.Text);
        fsmartbmt.qproses.ParamByName('ket').AsString := 'Kas Masuk';
        fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
        fsmartbmt.qproses.ExecSQL;


        fsmartbmt.qproses.Close;
        fsmartbmt.qproses.SQL.Clear;
        fsmartbmt.qproses.SQL.Add(
          'INSERT INTO pendapatan (tgl,uraian,nominal,muser) values (:tgl,:uraian,:nominal,:muser)');
        fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
        fsmartbmt.qproses.ParamByName('uraian').AsString := 'Bagi Hasil No Rek ' + ednorek.Text + '';
        fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(edbasil.Text);
        fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
        fsmartbmt.qproses.ExecSQL;

        ShowMessage('Angsuran No Rekening : ' + ednorek.Text + chr(10) + 'Nama : ' + ednama.Text + chr(10) +
          'Sebesar : ' + FloattoStr(strtofloat(edpokok.Text) + strtofloat(edbasil.Text)) + Chr(10) + 'Berhasil di Simpan...');
        kosong;
      end;
    end;
  end;
end;

procedure Tftranspembiayaan.edbasilKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edketerangan.SetFocus;
end;

procedure Tftranspembiayaan.edketeranganKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btsimpan.SetFocus;
end;

procedure Tftranspembiayaan.btBatalClick(Sender: TObject);
begin
  kosong;
end;

end.
