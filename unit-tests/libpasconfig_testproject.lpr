program libpasconfig_testproject;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, pasconfigtestcase, libpasconfig;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

