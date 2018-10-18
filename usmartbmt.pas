unit usmartbmt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, FileUtil, LR_DBSet, LR_Class, ZConnection, ZDataset,
  Forms, Controls, Graphics, Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls,
  Buttons, IniFiles;

type

  { Tfsmartbmt }

  Tfsmartbmt = class(TForm)
    btLogin: TBitBtn;
    btBatal: TBitBtn;
    dsproses: TDataSource;
    dsdata: TDataSource;
    eduser: TEdit;
    edpass: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    login: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lheader: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    bagihasil: TMenuItem;
    pendapatan: TMenuItem;
    pembukaanpembiayaan: TMenuItem;
    Timer1: TTimer;
    transaksisimpanan: TMenuItem;
    transaksiangsuranpembiayaan: TMenuItem;
    lapoutstanding: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    lapanggota: TMenuItem;
    lapsimpanan: TMenuItem;
    lappembiayaan: TMenuItem;
    datauser: TMenuItem;
    MenuItem20: TMenuItem;
    lapcashflow: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    settingsimpanan: TMenuItem;
    settingpembiayaan: TMenuItem;
    pendaftarananggota: TMenuItem;
    pembukaansimpanan: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    pmenu: TPanel;
    pmenu1: TPanel;
    StatusBar1: TStatusBar;
    ZConnection1: TZConnection;
    qproses: TZQuery;
    qdata: TZQuery;
    procedure btBatalClick(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
    procedure edpassKeyPress(Sender: TObject; var Key: char);
    procedure eduserKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure pembukaanpembiayaanClick(Sender: TObject);
    procedure pendapatanClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure transaksisimpananClick(Sender: TObject);
    procedure transaksiangsuranpembiayaanClick(Sender: TObject);
    procedure lapoutstandingClick(Sender: TObject);
    procedure lapanggotaClick(Sender: TObject);
    procedure lapsimpananClick(Sender: TObject);
    procedure lappembiayaanClick(Sender: TObject);
    procedure lapcashflowClick(Sender: TObject);
    procedure datauserClick(Sender: TObject);
    procedure bagihasilClick(Sender: TObject);
    procedure settingsimpananClick(Sender: TObject);
    procedure settingpembiayaanClick(Sender: TObject);
    procedure pendaftarananggotaClick(Sender: TObject);
    procedure pembukaansimpananClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fsmartbmt: Tfsmartbmt;

implementation

uses upendapatan, umuser, ubasil, ucashflow, uoutstandingsimbi, ulappembiayaan, utranspembiayaan, uregpembiayaan, upembiayaan, ulapsimpanan,
  ulapanggota, utranssimpanan, uregsimpanan, ureganggota, usettingsimpanan;

{$R *.lfm}

{ Tfsmartbmt }

procedure Tfsmartbmt.pendaftarananggotaClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | DATA ANGGOTA';
    freganggota.Parent := pmenu;
    freganggota.BorderStyle := bsNone;
    freganggota.Align := alClient;
    freganggota.Show;
  end;
end;

procedure Tfsmartbmt.pembukaansimpananClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | REGISTRASI SIMPANAN';
    fregsimpanan.Parent := pmenu;
    fregsimpanan.BorderStyle := bsNone;
    fregsimpanan.Align := alClient;
    fregsimpanan.Show;
  end;
end;

procedure Tfsmartbmt.FormShow(Sender: TObject);
begin
  lheader.Caption := '>> MENU UTAMA';
  pmenu1.Visible := False;

  image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'promosi/promosi.jpg');
  image2.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'background/bck.jpg');

  fsmartbmt.datauser.Enabled := False;
  fsmartbmt.settingsimpanan.Enabled := False;
  fsmartbmt.settingpembiayaan.Enabled := False;
  fsmartbmt.pendaftarananggota.Enabled := False;
  fsmartbmt.pembukaansimpanan.Enabled := False;
  fsmartbmt.pembukaanpembiayaan.Enabled := False;
  fsmartbmt.transaksisimpanan.Enabled := False;
  fsmartbmt.transaksiangsuranpembiayaan.Enabled := False;
  fsmartbmt.bagihasil.Enabled := False;
  fsmartbmt.lapanggota.Enabled := False;
  fsmartbmt.lapsimpanan.Enabled := False;
  fsmartbmt.lappembiayaan.Enabled := False;
  fsmartbmt.lapoutstanding.Enabled := False;
  fsmartbmt.pendapatan.Enabled := False;
  fsmartbmt.lapcashflow.Enabled := False;

  login.Visible := True;
  eduser.Text := '';
  edpass.Text := '';
  eduser.SetFocus;
end;

procedure Tfsmartbmt.Image1Click(Sender: TObject);
begin

end;

procedure Tfsmartbmt.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin

  Ini := TIniFile.Create(Extractfilepath(Application.exename) + 'koneksi.ini');

  try
    ZConnection1.Connected := False;
    ZConnection1.Hostname := Ini.ReadString('koneksi', 'server', '');
    ZConnection1.user := Ini.ReadString('koneksi', 'username', '');
    ZConnection1.Password := Ini.ReadString('koneksi', 'pass', '');
    ZConnection1.Port := Ini.ReadInteger('koneksi', 'port', 0);
    ZConnection1.Database := Ini.ReadString('koneksi', 'dbname', '');
    ZConnection1.LibraryLocation := Extractfilepath(Application.exename) + 'libmysql.dll';
    ZConnection1.Protocol := 'mysql';
    ZConnection1.Connected := True;
  except
    ShowMessage('Maaf, Koneksi Gagal...' + chr(10) + 'Silahkan Setting Koneksi Database...' + chr(10) + 'Application Akan di Tutup...');
    Application.Terminate;
    ini.Free;
  end;
end;

procedure Tfsmartbmt.btBatalClick(Sender: TObject);
begin
  eduser.Text := '';
  edpass.Text := '';
  eduser.SetFocus;
end;

procedure Tfsmartbmt.btLoginClick(Sender: TObject);
begin
  if eduser.Text = '' then
  begin
    ShowMessage('Maaf, USER ID Belum di isi...');
    eduser.SetFocus;
  end
  else
  begin
    if edpass.Text = '' then
    begin
      ShowMessage('Maaf, Password Belum di isi...');
      edpass.SetFocus;
    end
    else
    begin
      fsmartbmt.qproses.Close;
      fsmartbmt.qproses.SQL.Clear;
      fsmartbmt.qproses.SQL.Add('select * from muser where userid="' + eduser.Text + '" and password="' + edpass.Text + '"');
      fsmartbmt.qproses.Open;

      if fsmartbmt.qproses.IsEmpty then
      begin
        ShowMessage('Maaf, User ID atau Password Anda Tidak Sesuai...');
        eduser.SetFocus;
      end
      else
      begin
        if fsmartbmt.qproses.FieldByName('datauser').AsInteger = 1 then
          datauser.Enabled := True
        else
          datauser.Enabled := False;


        if fsmartbmt.qproses.FieldByName('settingsimpanan').AsInteger = 1 then
          settingsimpanan.Enabled := True
        else
          settingsimpanan.Enabled := False;


        if fsmartbmt.qproses.FieldByName('settingpembiayaan').AsInteger = 1 then
          settingpembiayaan.Enabled := True
        else
          settingpembiayaan.Enabled := False;


        if fsmartbmt.qproses.FieldByName('pendaftarananggota').AsInteger = 1 then
          pendaftarananggota.Enabled := True
        else
          pendaftarananggota.Enabled := False;



        if fsmartbmt.qproses.FieldByName('pembukaansimpanan').AsInteger = 1 then
          pembukaansimpanan.Enabled := True
        else
          pembukaansimpanan.Enabled := False;


        if fsmartbmt.qproses.FieldByName('pembukaanpembiayaan').AsInteger = 1 then
          pembukaanpembiayaan.Enabled := True
        else
          pembukaanpembiayaan.Enabled := False;


        if fsmartbmt.qproses.FieldByName('transaksisimpanan').AsInteger = 1 then
          transaksisimpanan.Enabled := True
        else
          transaksisimpanan.Enabled := False;


        if fsmartbmt.qproses.FieldByName('transaksiangsuranpembiayaan').AsInteger = 1 then
          transaksiangsuranpembiayaan.Enabled := True
        else
          transaksiangsuranpembiayaan.Enabled := False;


        if fsmartbmt.qproses.FieldByName('bagihasil').AsInteger = 1 then
          bagihasil.Enabled := True
        else
          bagihasil.Enabled := False;


        if fsmartbmt.qproses.FieldByName('lapanggota').AsInteger = 1 then
          lapanggota.Enabled := True
        else
          lapanggota.Enabled := False;


        if fsmartbmt.qproses.FieldByName('lapsimpanan').AsInteger = 1 then
          lapsimpanan.Enabled := True
        else
          lapsimpanan.Enabled := False;


        if fsmartbmt.qproses.FieldByName('lappembiayaan').AsInteger = 1 then
          lappembiayaan.Enabled := True
        else
          lappembiayaan.Enabled := False;


        if fsmartbmt.qproses.FieldByName('lapoutstanding').AsInteger = 1 then
          lapoutstanding.Enabled := True
        else
          lapoutstanding.Enabled := False;

        if fsmartbmt.qproses.FieldByName('pendapatan').AsInteger = 1 then
          pendapatan.Enabled := True
        else
          pendapatan.Enabled := False;

        if fsmartbmt.qproses.FieldByName('lapcashflow').AsInteger = 1 then
          lapcashflow.Enabled := True
        else
          lapcashflow.Enabled := False;

        ShowMessage('Login Berhasil...');
        login.Visible := False;
      end;
    end;
  end;
end;

procedure Tfsmartbmt.edpassKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    btlogin.SetFocus;
end;

procedure Tfsmartbmt.eduserKeyPress(Sender: TObject; var Key: char);
begin
  if key = #13 then
    edpass.SetFocus;
end;

procedure Tfsmartbmt.pembukaanpembiayaanClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | REGPEMBIAYAAN';
    fregpembiayaan.Parent := pmenu;
    fregpembiayaan.BorderStyle := bsNone;
    fregpembiayaan.Align := alClient;
    fregpembiayaan.Show;
  end;
end;

procedure Tfsmartbmt.pendapatanClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | LAPORAN PENDAPATAN';
    fpendapatan.Parent := pmenu;
    fpendapatan.BorderStyle := bsNone;
    fpendapatan.Align := alClient;
    fpendapatan.Show;
  end;
end;

procedure Tfsmartbmt.Timer1Timer(Sender: TObject);
begin
  fsmartbmt.StatusBar1.Panels[1].Text := Datetostr(now());
  fsmartbmt.StatusBar1.Panels[2].Text := Timetostr(now());
end;

procedure Tfsmartbmt.transaksisimpananClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | TRNSAKSI SIMPANAN';
    ftranssimpanan.Parent := pmenu;
    ftranssimpanan.BorderStyle := bsNone;
    ftranssimpanan.Align := alClient;
    ftranssimpanan.Show;
  end;
end;

procedure Tfsmartbmt.transaksiangsuranpembiayaanClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | TRANSAKSI ANGSURAN PEMBIAYAAN';
    ftranspembiayaan.Parent := pmenu;
    ftranspembiayaan.BorderStyle := bsNone;
    ftranspembiayaan.Align := alClient;
    ftranspembiayaan.Show;
  end;
end;

procedure Tfsmartbmt.lapoutstandingClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | LAPORAN OUTSTANDING SIMPANAN DAN PEMBIAYAAN';
    foutstandingsimbi.Parent := pmenu;
    foutstandingsimbi.BorderStyle := bsNone;
    foutstandingsimbi.Align := alClient;
    foutstandingsimbi.Show;
  end;
end;

procedure Tfsmartbmt.lapanggotaClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | LAPORAN DATA ANGGOTA';
    flapanggota.Parent := pmenu;
    flapanggota.BorderStyle := bsNone;
    flapanggota.Align := alClient;
    flapanggota.Show;
  end;
end;

procedure Tfsmartbmt.lapsimpananClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | LAPORAN SIMPANAN';
    flapsimpanan.Parent := pmenu;
    flapsimpanan.BorderStyle := bsNone;
    flapsimpanan.Align := alClient;
    flapsimpanan.Show;
  end;
end;

procedure Tfsmartbmt.lappembiayaanClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | LAPORAN ANGSURAN PEMBIAYAAN';
    flappembiayaan.Parent := pmenu;
    flappembiayaan.BorderStyle := bsNone;
    flappembiayaan.Align := alClient;
    flappembiayaan.Show;
  end;
end;

procedure Tfsmartbmt.lapcashflowClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | LAPORAN CASH FLOW';
    fcashflow.Parent := pmenu;
    fcashflow.BorderStyle := bsNone;
    fcashflow.Align := alClient;
    fcashflow.Show;
  end;
end;

procedure Tfsmartbmt.datauserClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | DATA USER';
    fmuser.Parent := pmenu;
    fmuser.BorderStyle := bsNone;
    fmuser.Align := alClient;
    fmuser.Show;
  end;
end;

procedure Tfsmartbmt.bagihasilClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | LAPORAN BAGI HASIL ANGGOTA';
    fbasil.Parent := pmenu;
    fbasil.BorderStyle := bsNone;
    fbasil.Align := alClient;
    fbasil.Show;
  end;
end;

procedure Tfsmartbmt.settingsimpananClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | SETTING SIMPANAN';
    fsettingsimpanan.Parent := pmenu;
    fsettingsimpanan.BorderStyle := bsNone;
    fsettingsimpanan.Align := alClient;
    fsettingsimpanan.Show;
  end;
end;

procedure Tfsmartbmt.settingpembiayaanClick(Sender: TObject);
begin
  if tag = 1 then
  begin
    ShowMessage('Maaf, Form Belum Di Tutup...');
  end
  else
  begin
    tag := 1;
    pmenu1.Visible := True;
    lheader.Caption := '>> MENU UTAMA | SETTING PEMBIAYAAN';
    fpembiayaan.Parent := pmenu;
    fpembiayaan.BorderStyle := bsNone;
    fpembiayaan.Align := alClient;
    fpembiayaan.Show;
  end;
end;

{ Tfsmartbmt }


end.
