unit pasconfigtestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, libpasconfig;

type

  { TLibConfigTest }

  TLibConfigTest = class(TTestCase)
  private
    FConfig : config_t;
    FSettings : pconfig_setting_t;
  published
    procedure TestCreateConfig;
  end;

implementation

{ TLibConfigTest }


procedure TLibConfigTest.TestCreateConfig;
var
  root, setting, group : pconfig_setting_t;
begin
  config_init(@FConfig);
  root := config_root_setting(@FConfig);
  AssertTrue('Root config element is nil', root <> nil);

  group := config_setting_add(root, 'test', CONFIG_TYPE_GROUP);
  AssertTrue('Group config element is nil', group <> nil);

  setting := config_setting_add(group, 'option 1', CONFIG_TYPE_INT);
  AssertTrue('Added ''option 1'' option is nil', setting <> nil);
  if setting <> nil then
    config_setting_set_int(setting, 456);

  setting := config_setting_add(group, 'option 2', CONFIG_TYPE_INT);
  AssertTrue('Added ''option 2'' option is nil', setting <> nil);
  if setting <> nil then
    config_setting_set_int(setting, 123);


end;

initialization

  RegisterTest(TLibConfigTest);
end.

