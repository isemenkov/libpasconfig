unit pasconfigtestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, libpasconfig;

type

  { TLibConfigTest }

  TLibConfigTest = class(TTestCase)
  private
    FConfig : pconfig_t;
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
  config_init(FConfig);
  root := config_root_setting(FConfig);
  group := config_setting_add(group, 'test', CONFIG_TYPE_GROUP);

  setting := config_setting_add(group, 'option 1', CONFIG_TYPE_STRING);
  config_setting_set_string(setting, 'option test value');

  setting := config_setting_add(group, 'option 2', CONFIG_TYPE_INT);
  config_setting_set_int(setting, 123);


end;

initialization

  RegisterTest(TLibConfigTest);
end.

