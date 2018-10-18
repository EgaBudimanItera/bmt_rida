program smartbmt;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  Windows,
  Dialogs,
  pl_zeosdbo,
  lz_datetimectrls,
  ubasil,
  ucarianggota,
  ucaripembiayaan,
  ucariregpembiayaan,
  ucariregsimpanan,
  ucarisimpanan,
  ucashflow,
  ulapanggota,
  ulappembiayaan,
  ulapsimpanan,
  uoutstandingsimbi,
  upembiayaan,
  ureganggota,
  uregpembiayaan,
  uregsimpanan,
  uscreen,
  usettingsimpanan,
  usmartbmt,
  utranspembiayaan,
  utranssimpanan, umuser, upendapatan { you can add units after this };

{$R *.res}

begin
  CreateMutex(nil, True, 'SMART BMT');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    MessageDlg('Maaf, Program SMART BMT Sudah Runing...' + chr(10) + 'Silahkan Cek Kembali...', mtError, [mbOK], 0);   // tidak bisa Runing 2 kali
    Halt;
  end;
  Application.Title := 'SMART BMT';
  RequireDerivedFormResource := True;
  Application.Initialize;
  fScreen := Tfscreen.Create(application);
  fScreen.Show;
  fScreen.Update;
  application.ProcessMessages;
  fscreen.progress1.Progress := 0;
  Application.CreateForm(Tfsmartbmt, fsmartbmt);
  Application.CreateForm(Tfbasil, fbasil);
  fscreen.progress1.Progress := 5;
  Application.CreateForm(Tfcarianggota, fcarianggota);
  fscreen.progress1.Progress := 10;
  Application.CreateForm(Tfcaripembiayaan, fcaripembiayaan);
  Application.CreateForm(Tfcariregpembiayaan, fcariregpembiayaan);
  fscreen.progress1.Progress := 25;
  Application.CreateForm(Tfcariregsimpanan, fcariregsimpanan);
  fscreen.progress1.Progress := 35;
  Application.CreateForm(Tfcarisimpanan, fcarisimpanan);
  fscreen.progress1.Progress := 40;
  Application.CreateForm(Tfcashflow, fcashflow);
  Application.CreateForm(Tflapanggota, flapanggota);
  fscreen.progress1.Progress := 45;
  Application.CreateForm(Tflappembiayaan, flappembiayaan);
  fscreen.progress1.Progress := 50;
  Application.CreateForm(Tflapsimpanan, flapsimpanan);
  Application.CreateForm(Tfoutstandingsimbi, foutstandingsimbi);
  fscreen.progress1.Progress := 55;
  Application.CreateForm(Tfpembiayaan, fpembiayaan);
  fscreen.progress1.Progress := 60;
  Application.CreateForm(Tfreganggota, freganggota);
  Application.CreateForm(Tfregpembiayaan, fregpembiayaan);
  fscreen.progress1.Progress := 65;
  Application.CreateForm(Tfregsimpanan, fregsimpanan);
  fscreen.progress1.Progress := 70;
  Application.CreateForm(Tfsettingsimpanan, fsettingsimpanan);
  fscreen.progress1.Progress := 80;
  Application.CreateForm(Tftranspembiayaan, ftranspembiayaan);
  fscreen.progress1.Progress := 100;
  Application.CreateForm(Tftranssimpanan, ftranssimpanan);
  fscreen.Close;
  fscreen.Release;
  Application.CreateForm(Tfmuser, fmuser);
  Application.CreateForm(Tfpendapatan, fpendapatan);
  Application.Run;
end.
