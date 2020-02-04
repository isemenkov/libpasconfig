unit pasconfigtestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, libpasconfig;

type

  { TLibConfigTest }

  TLibConfigTest = class(TTestCase)
  private
    FConfig : config_t;
  published
    procedure TestCreateConfig;
    procedure TestCreateConfigArray;
    procedure TestCreateConfigFile;
    procedure TestCreateConfigStream;
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

  setting := config_setting_add(group, 'option1', CONFIG_TYPE_INT);
  AssertTrue('Added ''option1'' option type ''INT'' is nil', setting <> nil);
  config_setting_set_int(setting, 456);

  setting := config_setting_add(group, 'option2', CONFIG_TYPE_INT64);
  AssertTrue('Added ''option2'' option type ''INT64'' is nil', setting <> nil);
  config_setting_set_int(setting, 123456);

  setting := config_setting_add(group, 'option3', CONFIG_TYPE_FLOAT);
  AssertTrue('Added ''option3'' option type ''FLOAT'' is nil', setting <> nil);
  config_setting_set_float(setting, 0.001);

  setting := config_setting_add(group, 'option4', CONFIG_TYPE_STRING);
  AssertTrue('Added ''option4'' option type ''STRING'' is nil', setting <> nil);
  config_setting_set_string(setting, PChar('test value'));

  setting := config_setting_add(group, 'option5', CONFIG_TYPE_BOOL);
  AssertTrue('Added ''option5'' option type ''BOOL'' is nil', setting <> nil);
  config_setting_set_bool(setting, 1);

  config_destroy(@FConfig);
end;

procedure TLibConfigTest.TestCreateConfigArray;
var
  root, arr, setting, group : pconfig_setting_t;
  i : Integer;
begin
  config_init(@FConfig);
  root := config_root_setting(@FConfig);
  AssertTrue('Root config element is nil', root <> nil);

  group := config_setting_add(root, 'test', CONFIG_TYPE_GROUP);
  AssertTrue('Group config element is nil', group <> nil);

  arr := config_setting_add(group, 'array_options', CONFIG_TYPE_ARRAY);
  AssertTrue('Added ''array_options'' option type ''ARRAY'' is nil', arr <>
    nil);

  for i := 1 to 10 do
  begin
    setting := config_setting_add(arr, nil, CONFIG_TYPE_INT);
    AssertTrue('Added new array element is nil', setting <> nil);
    config_setting_set_int(setting, i);
  end;

  config_destroy(@FConfig);
end;

procedure TLibConfigTest.TestCreateConfigFile;
var
  root, setting, group : pconfig_setting_t;
  write_result : Integer;
begin
  config_init(@FConfig);
  root := config_root_setting(@FConfig);
  AssertTrue('Root config element is nil', root <> nil);

  group := config_setting_add(root, 'test', CONFIG_TYPE_GROUP);
  AssertTrue('Group config element is nil', group <> nil);

  setting := config_setting_add(group, 'option1', CONFIG_TYPE_STRING);
  AssertTrue('Added ''option1'' option type ''STRING'' is nil', setting <> nil);
  config_setting_set_string(setting, PChar('option value'));

  setting := config_setting_add(group, 'option2', CONFIG_TYPE_INT);
  AssertTrue('Added ''option2'' option type ''INT'' is nil', setting <> nil);
  config_setting_set_int(setting, -5);

  write_result := config_write_file(@FConfig, 'test.cfg');
  AssertTrue('Write config file is error', write_result <> 0);
  AssertTrue('Config file is not exists', FileExists('test.cfg'));

  DeleteFile('test.cfg');
  config_destroy(@FConfig);
end;

procedure TLibConfigTest.TestCreateConfigStream;
var
  root, setting, group : pconfig_setting_t;
  write_result : Integer;
  //f : PFile;
begin
  config_init(@FConfig);
  root := config_root_setting(@FConfig);
  AssertTrue('Root config element is nil', root <> nil);

  group := config_setting_add(root, 'test', CONFIG_TYPE_GROUP);
  AssertTrue('Group config element is nil', group <> nil);

  setting := config_setting_add(group, 'option1', CONFIG_TYPE_STRING);
  AssertTrue('Added ''option1'' option type ''STRING'' is nil', setting <> nil);
  config_setting_set_string(setting, PChar('option value'));

  setting := config_setting_add(group, 'option2', CONFIG_TYPE_INT);
  AssertTrue('Added ''option2'' option type ''INT'' is nil', setting <> nil);
  config_setting_set_int(setting, -5);



  config_write(@FConfig, f);
  AssertTrue('Config file is not exists', FileExists('test.cfg'));


  DeleteFile('test.cfg');
  config_destroy(@FConfig);
end;

initialization
  RegisterTest(TLibConfigTest);
end.

