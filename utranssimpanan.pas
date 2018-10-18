unit utranssimpanan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, curredit, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Windows;

type

  { Tftranssimpanan }

  Tftranssimpanan = class(TForm)
    btBatal: TBitBtn;
    btKeluar: TBitBtn;
    btSimpan: TBitBtn;
    cbjenis: TComboBox;
    edkodeanggota: TEdit;
    ednorek: TEdit;
    ednama: TEdit;
    edalamat: TEdit;
    ednominal: TCurrencyEdit;
    edsimpanan: TEdit;
    edsaldo: TCurrencyEdit;
    edketerangan: TEdit;
    Label1: TLabel;
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
    procedure cbjenisKeyPress(Sender: TObject; var Key: char);
    procedure edketeranganKeyPress(Sender: TObject; var Key: char);
    procedure ednominalKeyPress(Sender: TObject; var Key: char);
    procedure ednorekChange(Sender: TObject);
    procedure ednorekKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure kosong;
    procedure no;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ftranssimpanan: Tftranssimpanan;
  notrans, kodeanggota: string;

implementation

uses usmartbmt, ucariregsimpanan;

{$R *.lfm}

{ Tftranssimpanan }

procedure Tftranssimpanan.kosong;
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

procedure Tftranssimpanan.no;
begin
  fsmartbmt.qproses.Close;
  fsmartbmt.qproses.SQL.Clear;
  fsmartbmt.qproses.SQL.Add('select count(notrans) as notrans from transsimpanan');
  fsmartbmt.qproses.Open;

  notrans := FormatFloat('0000000', StrToInt(IntToStr(StrToInt(fsmartbmt.qproses.FieldByName('notrans').AsString) + 1)));
end;

procedure Tftranssimpanan.FormShow(Sender: TObject);
begin
  kosong;
end;

procedure Tftranssimpanan.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible:=False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tftranssimpanan.btSimpanClick(Sender: TObject);
var
  saldo, nominal: real;
begin
  if ednama.Text = '' then
  begin
    ShowMessage('Maaf, Data Rekening Simpanan Belum di Isi...');
    ednorek.SetFocus;
  end
  else
  begin
    if cbjenis.Text = '' then
    begin
      ShowMessage('Maaf, Jenis Transaksi belum di Isi...');
      cbjenis.SetFocus;
    end
    else
    begin
      if (ednominal.Text = '0,00') or (ednominal.Text = '0.00') or (ednominal.Text = '') or (ednominal.Text = '0') then
      begin
        ShowMessage('Maaf, Nominal Tidak Boleh Nol...');
        ednominal.SetFocus;
      end
      else
      begin
        saldo := strtofloat(edsaldo.Text);
        nominal := strtofloat(ednominal.Text);

        if cbjenis.ItemIndex = 0 then
        begin
          no;
          fsmartbmt.qproses.Close;
          fsmartbmt.qproses.SQL.Clear;
          fsmartbmt.qproses.SQL.Add(
            'INSERT INTO transsimpanan (norekening,kodeanggota,notrans,tgl,keterangan,debet,kredit,saldo,muser) Values (:norekening,:kodeanggota,:notrans,:tgl,:keterangan,:debet,:kredit,:saldo,:muser)');
          fsmartbmt.qproses.ParamByName('norekening').AsString := ednorek.Text;
          fsmartbmt.qproses.ParamByName('kodeanggota').AsString := edkodeanggota.Text;
          fsmartbmt.qproses.ParamByName('notrans').AsString := notrans;
          fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
          fsmartbmt.qproses.ParamByName('keterangan').AsString := 'Setoran : ' + edketerangan.Text;
          fsmartbmt.qproses.ParamByName('debet').AsFloat := strtofloat('0');
          fsmartbmt.qproses.ParamByName('kredit').AsFloat := strtofloat(ednominal.Text);
          fsmartbmt.qproses.ParamByName('saldo').AsFloat := saldo + nominal;
          fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
          fsmartbmt.qproses.ExecSQL;

            fsmartbmt.qproses.Close;
            fsmartbmt.qproses.SQL.Clear;
            fsmartbmt.qproses.SQL.Add(
              'INSERT INTO transaksi (tgl,uraian,nominal,ket,muser) values (:tgl,:uraian,:nominal,:ket,:muser)');
            fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
            fsmartbmt.qproses.ParamByName('uraian').AsString := 'Setoran Simpanan No Rek ' + ednorek.Text + '';
            fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(ednominal.Text);
            fsmartbmt.qproses.ParamByName('ket').AsString := 'Kas Masuk';
            fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
            fsmartbmt.qproses.ExecSQL;



          ShowMessage('Setoran No Rekening : ' + ednorek.Text + chr(10) + 'Nama : ' + ednama.Text + chr(10) +
            'Sebesar : ' + ednominal.Text + Chr(10) + 'Berhasil di Simpan...');
          kosong;
        end
        else
        begin
          if (cbjenis.ItemIndex = 1) and (saldo < nominal) then
          begin
            ShowMessage('Maaf, Nominal yg Akan ditarik Teralu Besar..' + chr(10) + 'Saldo Simpanan ' + edsaldo.Text + '');
            ednominal.SetFocus;
          end
          else
          begin
            if (cbjenis.ItemIndex = 1) and (saldo > nominal) then
            begin
              no;
              fsmartbmt.qproses.Close;
              fsmartbmt.qproses.SQL.Clear;
              fsmartbmt.qproses.SQL.Add(
                'INSERT INTO transsimpanan (norekening,kodeanggota,notrans,tgl,keterangan,debet,kredit,saldo,muser) Values (:norekening,:kodeanggota,:notrans,:tgl,:keterangan,:debet,:kredit,:saldo,:muser)');
              fsmartbmt.qproses.ParamByName('norekening').AsString := ednorek.Text;
              fsmartbmt.qproses.ParamByName('kodeanggota').AsString := edkodeanggota.Text;
              fsmartbmt.qproses.ParamByName('notrans').AsString := notrans;
              fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
              fsmartbmt.qproses.ParamByName('keterangan').AsString := 'Penarikan : ' + edketerangan.Text;
              fsmartbmt.qproses.ParamByName('debet').AsFloat := strtofloat(ednominal.Text);
              fsmartbmt.qproses.ParamByName('kredit').AsFloat := strtofloat('0');
              fsmartbmt.qproses.ParamByName('saldo').AsFloat := saldo - nominal;
              fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
              fsmartbmt.qproses.ExecSQL;

              fsmartbmt.qproses.Close;
            fsmartbmt.qproses.SQL.Clear;
            fsmartbmt.qproses.SQL.Add(
              'INSERT INTO transaksi (tgl,uraian,nominal,ket,muser) values (:tgl,:uraian,:nominal,:ket,:muser)');
            fsmartbmt.qproses.ParamByName('tgl').AsDate := strtodate(fsmartbmt.StatusBar1.Panels[1].Text);
            fsmartbmt.qproses.ParamByName('uraian').AsString := 'Penarikan Simpanan No Rek ' + ednorek.Text + '';
            fsmartbmt.qproses.ParamByName('nominal').AsFloat := strtofloat(ednominal.Text);
            fsmartbmt.qproses.ParamByName('ket').AsString := 'Kas Keluar';
            fsmartbmt.qproses.ParamByName('muser').AsString := fsmartbmt.StatusBar1.Panels[3].Text;
            fsmartbmt.qproses.ExecSQL;


              ShowMessage('Penarikan No Rekening : ' + ednorek.Text + chr(10) + 'Nama : ' + ednama.Text + chr(10) +
                'Sebesar : ' + ednominal.Text + Chr(10) + 'Berhasil di Simpan...');
              kosong;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure Tftranssimpanan.btBatalClick(Sender: TObject);
begin
  kosong;
end;

procedure Tftranssimpanan.cbjenisKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    ednominal.SetFocus;
end;

procedure Tftranssimpanan.edketeranganKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btsimpan.SetFocus;
end;

procedure Tftranssimpanan.ednominalKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edketerangan.SetFocus;
end;

procedure Tftranssimpanan.ednorekChange(Sender: TObject);
begin
  edkodeanggota.Text := '';
  ednama.Text := '';
  edalamat.Text := '';
  edsimpanan.Text := '';
  edsaldo.Text := '';
end;

procedure Tftranssimpanan.ednorekKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    if ednorek.Text = '' then
    begin
      fcariregsimpanan.Tag := 4;
      fcariregsimpanan.ShowModal;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add(
        'select simpanan.kodeanggota, anggota.nama, anggota.alamat, simpanan.noreksimpanan, simpanan.kodesimpanan, settingsimpanan.nama, simpanan.persentasi, simpanan.saldo from simpanan, anggota, settingsimpanan where simpanan.kodeanggota=anggota.id and simpanan.kodesimpanan=settingsimpanan.kode and noreksimpanan="' + ednorek.Text + '"');
      fsmartbmt.qproses.Open;

      if fsmartbmt.qproses.IsEmpty then
      begin
        fcariregsimpanan.Tag := 4;
        fcariregsimpanan.ShowModal;
      end
      else
      begin
        edkodeanggota.Text := fsmartbmt.qproses.FieldByName('kodeanggota').AsString;
        ednama.Text := fsmartbmt.qproses.FieldByName('nama').AsString;
        edalamat.Text := fsmartbmt.qproses.FieldByName('alamat').AsString;
        edsimpanan.Text := fsmartbmt.qproses.FieldByName('nama_1').AsString;
        edsaldo.Text := fsmartbmt.qproses.FieldByName('saldo').AsString;
        cbjenis.SetFocus;
      end;
    end;
end;

end.
