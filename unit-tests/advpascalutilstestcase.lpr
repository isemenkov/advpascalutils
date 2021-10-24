program advpascalutilstestcase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, testcase_actionmanager,
  testcase_eventmanager;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

