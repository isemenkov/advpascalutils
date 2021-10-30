program advpascalutilstestcase;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  advutils.action in '..\source\advutils.action.pas',
  testcase_actionmanager in '..\unit-tests\src\testcase_actionmanager.pas',
  testcase_eventmanager in '..\unit-tests\src\testcase_eventmanager.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.