unit uscreen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TplGaugeUnit, Forms, Controls, Graphics, Dialogs,
  ExtCtrls;

type

  { Tfscreen }

  Tfscreen = class(TForm)
    Image1: TImage;
    Image2: TImage;
    progress1: TplGauge;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fscreen: Tfscreen;

implementation

{$R *.lfm}

end.

