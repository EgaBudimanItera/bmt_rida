unit umuser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  ExtCtrls, Buttons, StdCtrls, Windows;

type

  { Tfmuser }

  Tfmuser = class(TForm)
    bagihasil: TCheckBox;
    btBatal: TBitBtn;
    btKeluar: TBitBtn;
    btSimpan: TBitBtn;
    eduser: TEdit;
    ednama: TEdit;
    edpass: TEdit;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    pendapatan: TCheckBox;
    lappembiayaan: TCheckBox;
    lapoutstanding: TCheckBox;
    lapcashflow: TCheckBox;
    transaksiangsuranpembiayaan: TCheckBox;
    lapsimpanan: TCheckBox;
    pendaftarananggota: TCheckBox;
    GroupBox2: TGroupBox;
    transaksisimpanan: TCheckBox;
    lapanggota: TCheckBox;
    settingsimpanan: TCheckBox;
    DataUser: TCheckBox;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    settingpembiayaan: TCheckBox;
    pembukaansimpanan: TCheckBox;
    pembukaanpembiayaan: TCheckBox;
    procedure btBatalClick(Sender: TObject);
    procedure btKeluarClick(Sender: TObject);
    procedure btSimpanClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure reload;
    procedure nocek;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fmuser: Tfmuser;

implementation

uses usmartbmt;

{$R *.lfm}

{ Tfmuser }

procedure Tfmuser.btKeluarClick(Sender: TObject);
begin
  fsmartbmt.pmenu1.Visible := False;
  fsmartbmt.Tag := 0;
  fsmartbmt.lheader.Caption := '>> MENU UTAMA';
  Close;
end;

procedure Tfmuser.btSimpanClick(Sender: TObject);
begin
  if (eduser.Text = '') or (ednama.Text = '') or (edpass.Text = '') then
  begin
    ShowMessage('Maaf, Data User ID / Nama / Passsword Belum di Isi...');
    eduser.SetFocus;
  end
  else
  begin
    fsmartbmt.qproses.Close;
    fsmartbmt.qproses.SQL.Clear;
    fsmartbmt.qproses.SQL.Text := 'select *from muser';
    fsmartbmt.qproses.Open;

    if (eduser.ReadOnly = True) and fsmartbmt.qproses.locate('userid', eduser.Text, []) then
    begin
      fsmartbmt.qproses.Edit;
      fsmartbmt.qproses.FieldByName('nama').AsString := ednama.Text;
      fsmartbmt.qproses.FieldByName('userid').AsString := eduser.Text;
      fsmartbmt.qproses.FieldByName('password').AsString := edpass.Text;

      if fmuser.DataUser.Checked = True then
        fsmartbmt.qproses.FieldValues['datauser'] := '1'
      else
        fsmartbmt.qproses.FieldValues['datauser'] := '0';

      if fmuser.settingsimpanan.Checked = True then
        fsmartbmt.qproses.FieldValues['settingsimpanan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['settingsimpanan'] := '0';

      if fmuser.settingpembiayaan.Checked = True then
        fsmartbmt.qproses.FieldValues['settingpembiayaan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['settingpembiayaan'] := '0';

      if fmuser.pendaftarananggota.Checked = True then
        fsmartbmt.qproses.FieldValues['pendaftarananggota'] := '1'
      else
        fsmartbmt.qproses.FieldValues['pendaftarananggota'] := '0';

      if fmuser.pembukaansimpanan.Checked = True then
        fsmartbmt.qproses.FieldValues['pembukaansimpanan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['pembukaansimpanan'] := '0';


      if fmuser.pembukaanpembiayaan.Checked = True then
        fsmartbmt.qproses.FieldValues['pembukaanpembiayaan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['pembukaanpembiayaan'] := '0';

      if fmuser.transaksisimpanan.Checked = True then
        fsmartbmt.qproses.FieldValues['transaksisimpanan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['transaksisimpanan'] := '0';

      if fmuser.transaksiangsuranpembiayaan.Checked = True then
        fsmartbmt.qproses.FieldValues['transaksiangsuranpembiayaan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['transaksiangsuranpembiayaan'] := '0';

      if fmuser.bagihasil.Checked = True then
        fsmartbmt.qproses.FieldValues['bagihasil'] := '1'
      else
        fsmartbmt.qproses.FieldValues['bagihasil'] := '0';

      if fmuser.lapanggota.Checked = True then
        fsmartbmt.qproses.FieldValues['lapanggota'] := '1'
      else
        fsmartbmt.qproses.FieldValues['lapanggota'] := '0';

      if fmuser.lapsimpanan.Checked = True then
        fsmartbmt.qproses.FieldValues['lapsimpanan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['lapsimpanan'] := '0';

      if fmuser.lappembiayaan.Checked = True then
        fsmartbmt.qproses.FieldValues['lappembiayaan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['lappembiayaan'] := '0';

      if fmuser.lapoutstanding.Checked = True then
        fsmartbmt.qproses.FieldValues['lapoutstanding'] := '1'
      else
        fsmartbmt.qproses.FieldValues['lapoutstanding'] := '0';

      if fmuser.pendapatan.Checked = True then
        fsmartbmt.qproses.FieldValues['pendapatan'] := '1'
      else
        fsmartbmt.qproses.FieldValues['pendapatan'] := '0';


      if fmuser.lapcashflow.Checked = True then
        fsmartbmt.qproses.FieldValues['lapcashflow'] := '1'
      else
        fsmartbmt.qproses.FieldValues['lapcashflow'] := '0';

      reload;
      fsmartbmt.qproses.Post;
      ShowMessage('Sucess...' + chr(10) + 'Data User Sudah Di Edit...');
      Formshow(Sender);
    end
    else
    begin
      if (eduser.ReadOnly = False) and fsmartbmt.qproses.locate('userid', eduser.Text, []) then
      begin
        messagedlg('Maaf User Name Sudah Ada...', mtError, [mbOK], 0);
        eduser.SetFocus;
      end
      else
      begin
        fsmartbmt.qproses.Append;
        fsmartbmt.qproses.FieldByName('nama').AsString := ednama.Text;
        fsmartbmt.qproses.FieldByName('userid').AsString := eduser.Text;
        fsmartbmt.qproses.FieldByName('password').AsString := edpass.Text;

        if fmuser.DataUser.Checked = True then
          fsmartbmt.qproses.FieldValues['datauser'] := '1'
        else
          fsmartbmt.qproses.FieldValues['datauser'] := '0';

        if fmuser.settingsimpanan.Checked = True then
          fsmartbmt.qproses.FieldValues['settingsimpanan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['settingsimpanan'] := '0';

        if fmuser.settingpembiayaan.Checked = True then
          fsmartbmt.qproses.FieldValues['settingpembiayaan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['settingpembiayaan'] := '0';

        if fmuser.pendaftarananggota.Checked = True then
          fsmartbmt.qproses.FieldValues['pendaftarananggota'] := '1'
        else
          fsmartbmt.qproses.FieldValues['pendaftarananggota'] := '0';

        if fmuser.pembukaansimpanan.Checked = True then
          fsmartbmt.qproses.FieldValues['pembukaansimpanan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['pembukaansimpanan'] := '0';


        if fmuser.pembukaanpembiayaan.Checked = True then
          fsmartbmt.qproses.FieldValues['pembukaanpembiayaan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['pembukaanpembiayaan'] := '0';

        if fmuser.transaksisimpanan.Checked = True then
          fsmartbmt.qproses.FieldValues['transaksisimpanan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['transaksisimpanan'] := '0';

        if fmuser.transaksiangsuranpembiayaan.Checked = True then
          fsmartbmt.qproses.FieldValues['transaksiangsuranpembiayaan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['transaksiangsuranpembiayaan'] := '0';

        if fmuser.bagihasil.Checked = True then
          fsmartbmt.qproses.FieldValues['bagihasil'] := '1'
        else
          fsmartbmt.qproses.FieldValues['bagihasil'] := '0';

        if fmuser.lapanggota.Checked = True then
          fsmartbmt.qproses.FieldValues['lapanggota'] := '1'
        else
          fsmartbmt.qproses.FieldValues['lapanggota'] := '0';

        if fmuser.lapsimpanan.Checked = True then
          fsmartbmt.qproses.FieldValues['lapsimpanan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['lapsimpanan'] := '0';

        if fmuser.lappembiayaan.Checked = True then
          fsmartbmt.qproses.FieldValues['lappembiayaan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['lappembiayaan'] := '0';

        if fmuser.lapoutstanding.Checked = True then
          fsmartbmt.qproses.FieldValues['lapoutstanding'] := '1'
        else
          fsmartbmt.qproses.FieldValues['lapoutstanding'] := '0';


        if fmuser.pendapatan.Checked = True then
          fsmartbmt.qproses.FieldValues['pendapatan'] := '1'
        else
          fsmartbmt.qproses.FieldValues['pendapatan'] := '0';


        if fmuser.lapcashflow.Checked = True then
          fsmartbmt.qproses.FieldValues['lapcashflow'] := '1'
        else
          fsmartbmt.qproses.FieldValues['lapcashflow'] := '0';


        reload;
        fsmartbmt.qproses.Post;
        ShowMessage('Sucess...' + chr(10) + 'Data User Sudah Di Simpan...');
        Formshow(Sender);
      end;
    end;
  end;
end;

procedure Tfmuser.DBGrid1DblClick(Sender: TObject);
begin
  if fsmartbmt.qdata.EOF then
  begin
    ShowMessage('Maaf, Tidak Ada Data User...');
    btbatal.SetFocus;
  end
  else
  begin
    eduser.ReadOnly := True;
    eduser.Color := clGradientActiveCaption;
    eduser.Text := fsmartbmt.qdata.FieldByName('userid').AsString;
    ednama.Text := fsmartbmt.qdata.FieldByName('nama').AsString;
    edpass.Text := fsmartbmt.qdata.FieldByName('password').AsString;

    if fsmartbmt.qdata.FieldByName('datauser').AsString = '1' then
      datauser.Checked := True
    else
      datauser.Checked := False;

    if fsmartbmt.qdata.FieldByName('settingsimpanan').AsString = '1' then
      settingsimpanan.Checked := True
    else
      settingsimpanan.Checked := False;

    if fsmartbmt.qdata.FieldByName('settingpembiayaan').AsString = '1' then
      settingpembiayaan.Checked := True
    else
      settingpembiayaan.Checked := False;


    if fsmartbmt.qdata.FieldByName('pendaftarananggota').AsString = '1' then
      pendaftarananggota.Checked := True
    else
      pendaftarananggota.Checked := False;


    if fsmartbmt.qdata.FieldByName('pembukaansimpanan').AsString = '1' then
      pembukaansimpanan.Checked := True
    else
      pembukaansimpanan.Checked := False;


    if fsmartbmt.qdata.FieldByName('pembukaanpembiayaan').AsString = '1' then
      pembukaanpembiayaan.Checked := True
    else
      pembukaanpembiayaan.Checked := False;


    if fsmartbmt.qdata.FieldByName('transaksisimpanan').AsString = '1' then
      transaksisimpanan.Checked := True
    else
      transaksisimpanan.Checked := False;


    if fsmartbmt.qdata.FieldByName('transaksiangsuranpembiayaan').AsString = '1' then
      transaksiangsuranpembiayaan.Checked := True
    else
      transaksiangsuranpembiayaan.Checked := False;


    if fsmartbmt.qdata.FieldByName('bagihasil').AsString = '1' then
      bagihasil.Checked := True
    else
      bagihasil.Checked := False;


    if fsmartbmt.qdata.FieldByName('lapanggota').AsString = '1' then
      lapanggota.Checked := True
    else
      lapanggota.Checked := False;



    if fsmartbmt.qdata.FieldByName('lapsimpanan').AsString = '1' then
      lapsimpanan.Checked := True
    else
      lapsimpanan.Checked := False;



    if fsmartbmt.qdata.FieldByName('lappembiayaan').AsString = '1' then
      lappembiayaan.Checked := True
    else
      lappembiayaan.Checked := False;


    if fsmartbmt.qdata.FieldByName('lapoutstanding').AsString = '1' then
      lapoutstanding.Checked := True
    else
      lapoutstanding.Checked := False;

    if fsmartbmt.qdata.FieldByName('pendapatan').AsString = '1' then
      pendapatan.Checked := True
    else
      pendapatan.Checked := False;

    if fsmartbmt.qdata.FieldByName('lapcashflow').AsString = '1' then
      lapcashflow.Checked := True
    else
      lapcashflow.Checked := False;

  end;
end;

procedure Tfmuser.FormShow(Sender: TObject);
begin
  reload;
  nocek;
end;

procedure Tfmuser.reload;
begin
  fsmartbmt.qdata.Close;
  fsmartbmt.qdata.SQL.Clear;
  fsmartbmt.qdata.SQL.Add('select * from muser order by nama asc');
  fsmartbmt.qdata.Open;
end;

procedure Tfmuser.btBatalClick(Sender: TObject);
begin
  reload;
  nocek;
end;

procedure Tfmuser.nocek;
begin
  eduser.ReadOnly := False;
  eduser.Color := clDefault;

  eduser.Text := '';
  ednama.Text := '';
  edpass.Text := '';

  fmuser.DataUser.Checked := False;
  fmuser.settingsimpanan.Checked := False;
  fmuser.settingpembiayaan.Checked := False;

  fmuser.pendaftarananggota.Checked := False;
  fmuser.pembukaansimpanan.Checked := False;
  fmuser.pembukaanpembiayaan.Checked := False;

  fmuser.transaksisimpanan.Checked := False;
  fmuser.transaksiangsuranpembiayaan.Checked := False;
  fmuser.bagihasil.Checked := False;

  fmuser.lapanggota.Checked := False;
  fmuser.lapsimpanan.Checked := False;
  fmuser.lappembiayaan.Checked := False;
  fmuser.lapoutstanding.Checked := False;
  fmuser.pendapatan.Checked := False;
  fmuser.lapcashflow.Checked := False;

  eduser.SetFocus;
end;

end.
