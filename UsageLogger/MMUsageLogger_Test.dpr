program MMUsageLogger_Test;

uses
  MMUsageLogger in 'MMUsageLogger.pas',
  Vcl.Forms,
  MMUsageLogger_TestFrm in 'MMUsageLogger_TestFrm.pas' {MMUsageLogger_TestForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMMUsageLogger_TestForm, MMUsageLogger_TestForm);
  Application.Run;
end.
