unit pasconfigtestcase;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, libpasconfig, pasconfig
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type

  { TLibConfigTest }

  TLibConfigTest = class(TTestCase)
  private
    FConfig : config_t;
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
    function StringConvert (AString : String) : PAnsiChar;
  published
    procedure TestCreateConfig;
    procedure TestCreateConfigArray;
    procedure TestCreateConfigFile;
    procedure TestCreateConfigReadWriteFile;
  end;

  { TConfigTest }

  TConfigTest = class(TTestCase)
  private
    FConfig : TConfig;
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure TestCreateConfig;
    procedure TestCreateConfigArray;
    procedure TestCreateConfigList;
    procedure TestCreateConfigFile;
    procedure TestCreateConfigParse;
    procedure TestConfigDeleteParam;
  end;

implementation

{ TConfigTest }
{ Create config file, write and read parameters }

{$IFNDEF FPC}
procedure TConfigTest.AssertTrue(AMessage: string; ACondition: Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TConfigTest.TestCreateConfig;
var
  Option : TConfig.TOptionReader;
  IntValue : Integer;
  Int64Value : Int64;
  StringValue : String;
  BooleanValue : Boolean;
begin
  FConfig := TConfig.Create;

  with FConfig.CreateSection['test'] do
  begin
    SetInteger['option1'] := 456;
    SetInt64['option2'] := 123456;
    SetFloat['option3'] := 0.001;
    SetString['option4'] := 'test value';
    SetBoolean['option5'] := True;
  end;

  Option := FConfig.Value['test.option1'];
  AssertTrue('Config element ''test.option1'' error', Option.AsInteger.IsOk);
  IntValue := Option.AsInteger.Value;
  AssertTrue('Config element ''test.option1'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));
  AssertTrue('Config element ''test.option1'' has incorrect name',
    Option.GetName.IsOk and (Option.GetName.Value = 'option1'));
  AssertTrue('Config element ''test.option1'' is incorrect value',
    IntValue = 456);

  Option := FConfig.Value['test.option2'];
  AssertTrue('Config element ''test.option2'' error', Option.AsInt64.IsOk);
  Int64Value := Option.AsInt64.Value;
  AssertTrue('Config element ''test.option2'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_INT64));
  AssertTrue('Config element ''test.option2'' has incorrect name',
    Option.GetName.IsOk and (Option.GetName.Value = 'option2'));
  AssertTrue('Config element ''test.option2'' is incorrect value',
    Int64Value = 123456);

  Option := FConfig.Value['test.option4'];
  AssertTrue('Config element ''test.option4'' error', Option.AsString.IsOk);
  StringValue := Option.AsString.Value;
  AssertTrue('Config element ''test.option4'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_STRING));
  AssertTrue('Config element ''test.option4'' has incorrect name',
    Option.GetName.IsOk and (Option.GetName.Value = 'option4'));
  AssertTrue('Config element ''test.option4'' is incorrect value',
    StringValue = 'test value');

  Option := FConfig.Value['test.option5'];
  AssertTrue('Config element ''test.option5'' error', Option.AsBoolean.IsOk);
  BooleanValue := Option.AsBoolean.Value;
  AssertTrue('Config element ''test.option5'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_BOOLEAN));
  AssertTrue('Config element ''test.option5'' has incorrect name',
    Option.GetName.IsOk and (Option.GetName.Value = 'option5'));
  AssertTrue('Config element ''test.option5'' is incorrect value',
    BooleanValue = True);

  FreeAndNil(FConfig);
end;

{ Create config, write/read array }
procedure TConfigTest.TestCreateConfigArray;
var
  Option : TConfig.TOptionReader;
  IntValue : Integer;
  i : Integer;
begin
  FConfig := TConfig.Create;

  with FConfig.CreateSection['test'].CreateArray['test_array'] do
  begin
    for i := 1 to 10 do
      SetInteger := i;
  end;

  i := 1;
  for Option in FConfig.Value['test.test_array'].AsArray do
  begin
    AssertTrue('Config ''array.test_array'' array element error',
      Option.AsInteger.IsOk);
    IntValue := Option.AsInteger.Value;
    AssertTrue('Config ''array.test_array'' array element has incorrect type',
      Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));
    AssertTrue('Config ''array.test_array'' array element is incorrect value',
      IntValue = i);
    Inc(i);
  end;

  FreeAndNil(FConfig);
end;

{ Create config, write/read list }
procedure TConfigTest.TestCreateConfigList;
var
  Option : TConfig.TOptionReader;
  IntValue : Integer;
  StringValue : String;
  i : Integer;
begin
  FConfig := TConfig.Create;

  with FConfig.CreateSection['test'].CreateList['test_list'] do
  begin
    for i := 1 to 10 do
    begin
      with CreateSection['option' + IntToStr(i)] do
      begin
        SetString['string_value'] := 'Value' + IntToStr(i);
        SetInteger['integer_value'] := i + 8;
      end;
    end;
  end;

  i := 1;
  for Option in FConfig.Value['test.test_list'].AsList do
  begin
    AssertTrue('Config element ''option' + IntToStr(i) + '.string_value'' '+
      'error', Option.Value['string_value'].AsString.IsOk);
    StringValue := Option.Value['string_value'].AsString.Value;
    AssertTrue('Config element ''option' + IntToStr(i) + '.string_value'' ' +
      'is incorrect value', StringValue = 'Value' + IntToStr(i));
    AssertTrue('Config element ''option' + IntToStr(i) + '.integer_value'' ' +
      'error', Option.Value['integer_value'].AsInteger.IsOk);
    IntValue := Option.Value['integer_value'].AsInteger.Value;
    AssertTrue('Config element ''option' + IntToStr(i) + '.integer_value'' ' +
      'is incorrect value', IntValue = i + 8);
    Inc(i);
  end;

  FreeAndNil(FConfig);
end;

{ Write/read config file }
procedure TConfigTest.TestCreateConfigFile;
var
  Option : TConfig.TOptionReader;
  IntValue : Integer;
  BoolValue : Boolean;
  Int64Value : Int64;
  StringValue : String;
  i : Integer;
  Res : TConfig.TVoidResult;
begin
  FConfig := TConfig.Create;

  with FConfig.CreateSection['section1'] do
  begin
    SetInteger['integer_value'] := 94032;
    SetBoolean['boolean_value'] := True;
  end;

  with FConfig.CreateSection['section2'].CreateArray['values'] do
  begin
    SetString := 'abc';
    SetString := 'test';
    SetString := 'another string value';
  end;

  with FConfig.CreateSection['section3'].CreateList['list'] do
  begin
    SetInt64 := 10000000002;
    SetInt64 := 10000000210;
    SetString := 'value';
  end;

  Res := FConfig.SaveToFile('config.cfg');
  AssertTrue('Config save config file error', Res.IsOk);
  FreeAndNil(FConfig);

  AssertTrue('Config file not exists', FileExists('config.cfg'));

  FConfig := TConfig.Create;
  FConfig.LoadFromFile('config.cfg');

  with FConfig.Value['section1'] do
  begin
    Option := Value['integer_value'];
    AssertTrue('Config element ''section1.integer_value'' error',
      Option.AsInteger.IsOk);
    IntValue := Option.AsInteger.Value;

    AssertTrue('Config element ''section1.integer_value'' has incorrect type',
      Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));
    AssertTrue('Config element ''section1.integer_value'' is incorrect value',
      IntValue = 94032);

    Option := Value['boolean_value'];
    AssertTrue('Config element ''section1.boolean_value'' error',
      Option.AsBoolean.IsOk);
    BoolValue := Option.AsBoolean.Value;

    AssertTrue('Config element ''section1.boolean_value'' has incorrect type',
      Option.GetType.IsOk and (Option.GetType.Value = TYPE_BOOLEAN));
    AssertTrue('Config element ''section1.boolean_value'' is incorrect value',
      BoolValue = True);
  end;

  with FConfig.Value['section2'] do
  begin
    i := 1;
    for Option in Value['values'].AsArray do
    begin
      AssertTrue('Config element ''section2.values[' + IntToStr(i) + '] '' ' +
        'has incorrect type', Option.GetType.IsOk and (Option.GetType.Value =
        TYPE_STRING));

      StringValue := Option.AsString.Value;

      case i of
        1 :
          AssertTrue('Config element ''section2.values[1]'' has incorrect type',
            StringValue = 'abc');
        2 :
          AssertTrue('Config element ''section2.values[2]'' has incorrect type',
            StringValue = 'test');
        3 :
          AssertTrue('Config element ''section2.values[3]'' has incorrect type',
            StringValue = 'another string value');
      end;

      inc(i);
    end;
  end;

  with FConfig.Value['section3'] do
  begin
    i := 1;
    for Option in Value['list'].AsList do
    begin
      case i of
        1 : begin
          AssertTrue('Config element ''section3.list[1]'' has incorrect type',
            Option.GetType.IsOk and (Option.GetType.Value = TYPE_INT64));
          AssertTrue('Config element ''section3.list[1]'' error',
            Option.AsInt64.IsOk);

          Int64Value := Option.AsInt64.Value;

          AssertTrue('Config element ''section3.list[1]'' is incorrect value',
            Int64Value = 10000000002);
        end;
        2 : begin
          AssertTrue('Config element ''section3.list[2]'' has incorrect type',
            Option.GetType.IsOk and (Option.GetType.Value = TYPE_INT64));
          AssertTrue('Config element ''section3.list[2]'' error',
            Option.AsInt64.IsOk);

          Int64Value := Option.AsInt64.Value;

          AssertTrue('Config element ''section3.list[2]'' is incorrect value',
            Int64Value = 10000000210);
        end;
        3 : begin
          AssertTrue('Config element ''section3.list[3]'' has incorrect type',
            Option.GetType.IsOk and (Option.GetType.Value = TYPE_STRING));
          AssertTrue('Config element ''section3.list[3]'' error',
            Option.AsString.IsOk);

          StringValue := Option.AsString.Value;

          AssertTrue('Config element ''section3.list[3]'' is incorrect value',
            StringValue = 'value');
        end;
      end;

      Inc(i);
    end;
  end;

  FreeAndNil(FConfig);
  DeleteFile('config.cfg');
end;

{ Parse config from string and save to file }
procedure TConfigTest.TestCreateConfigParse;
var
  Option : TConfig.TOptionReader;
  IntValue : Integer;
  BoolValue : Boolean;
  Res : TConfig.TVoidResult;
begin
  FConfig := TConfig.Create;
  Res := FConfig.Parse('section1 : { integer_value = -12; ' +
                       'boolean_value = false; };');
  AssertTrue('Config parse error', Res.IsOk);

  Option := FConfig.Value['section1.integer_value'];
  AssertTrue('Config element ''section1.integer_value'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));

  AssertTrue('Config element ''section1.integer_value'' error',
    Option.AsInteger.IsOk);
  IntValue := Option.AsInteger.Value;
  AssertTrue('Config element ''section1.integer_value'' is incorrect value',
    IntValue = -12);

  Option := FConfig.Value['section1.boolean_value'];
  AssertTrue('Config element ''section1.boolean_value'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_BOOLEAN));

  AssertTrue('Config element ''section1.boolean_value'' error',
    Option.AsBoolean.IsOk);
  BoolValue := Option.AsBoolean.Value;
  AssertTrue('Config element ''section1.boolean_value'' is incorrect value',
    BoolValue = False);

  FConfig.CreateSection['section2'].SetString['value'] := 'unknown';
  Res := FConfig.SaveToFile('config.cfg');
  AssertTrue('Config save config file error', Res.IsOk);
  AssertTrue('Config file not exists', FileExists('config.cfg'));

  FreeAndNil(FConfig);
  DeleteFile('config.cfg');
end;

{ Delete config param }
procedure TConfigTest.TestConfigDeleteParam;
var
  Option : TConfig.TOptionReader;
  IntValue : Integer;
begin
  FConfig := TConfig.Create;

  with FConfig.CreateSection['Section1'] do
  begin
    SetInteger['value1'] := 1;
    SetInteger['value2'] := 2;
    SetInteger['value3'] := 3;
  end;

  Option := FConfig.Value['Section1.value1'];
  AssertTrue('Config element ''Section1.value1'' error', Option.AsInteger.IsOk);
  IntValue := Option.AsInteger.Value;
  AssertTrue('Config element ''Section1.value1'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));
  AssertTrue('Config element ''Section1.value1'' is incorrect value',
    IntValue = 1);

  Option := FConfig.Value['Section1.value2'];
  AssertTrue('Config element ''Section1.value2'' error', Option.AsInteger.IsOk);
  IntValue := Option.AsInteger.Value;
  AssertTrue('Config element ''Section1.value2'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));
  AssertTrue('Config element ''Section1.value2'' is incorrect value',
    IntValue = 2);

  Option := FConfig.Value['Section1.value3'];
  AssertTrue('Config element ''Section1.value3'' error', Option.AsInteger.IsOk);
  IntValue := Option.AsInteger.Value;
  AssertTrue('Config element ''Section1.value3'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));
  AssertTrue('Config element ''Section1.value3'' is incorrect value',
    IntValue = 3);

  FConfig.Value['Section1.value3'].Delete;

  Option := FConfig.Value['Section1.value1'];
  AssertTrue('Config element ''Section1.value1'' error', Option.AsInteger.IsOk);
  IntValue := Option.AsInteger.Value;
  AssertTrue('Config element ''Section1.value1'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));
  AssertTrue('Config element ''Section1.value1'' is incorrect value',
    IntValue = 1);

  Option := FConfig.Value['Section1.value2'];
  AssertTrue('Config element ''Section1.value2'' error', Option.AsInteger.IsOk);
  IntValue := Option.AsInteger.Value;
  AssertTrue('Config element ''Section1.value2'' has incorrect type',
    Option.GetType.IsOk and (Option.GetType.Value = TYPE_INTEGER));
  AssertTrue('Config element ''Section1.value2'' is incorrect value',
    IntValue = 2);

  Option := FConfig.Value['Section1.value3'];
  AssertTrue('Config element ''Section1.value3'' error',
    not Option.AsInteger.IsOk);

  FreeAndNil(FConfig);
end;

{ TLibConfigTest }

{$IFNDEF FPC}
procedure TLibConfigTest.AssertTrue(AMessage: string; ACondition: Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

function TLibConfigTest.StringConvert (AString : String) : PAnsiChar;
begin
  Result := PAnsiChar({$IFNDEF FPC}Utf8Encode{$ENDIF}(AString));
end;

{ Create new config and setup test options values }
procedure TLibConfigTest.TestCreateConfig;
var
  root, setting, group : pconfig_setting_t;
begin
  config_init(@FConfig);
  root := config_root_setting(@FConfig);
  AssertTrue('Root config element is nil', root <> nil);

  group := config_setting_add(root, StringConvert('test'), CONFIG_TYPE_GROUP);
  AssertTrue('Group config element is nil', group <> nil);

  setting := config_setting_add(group, StringConvert('option1'),
    CONFIG_TYPE_INT);
  AssertTrue('Added ''option1'' option type ''INT'' is nil', setting <> nil);
  config_setting_set_int(setting, 456);

  setting := config_setting_add(group, StringConvert('option2'),
    CONFIG_TYPE_INT64);
  AssertTrue('Added ''option2'' option type ''INT64'' is nil', setting <> nil);
  config_setting_set_int(setting, 123456);

  setting := config_setting_add(group, StringConvert('option3'),
    CONFIG_TYPE_FLOAT);
  AssertTrue('Added ''option3'' option type ''FLOAT'' is nil', setting <> nil);
  config_setting_set_float(setting, 0.001);

  setting := config_setting_add(group, StringConvert('option4'),
    CONFIG_TYPE_STRING);
  AssertTrue('Added ''option4'' option type ''STRING'' is nil', setting <> nil);
  config_setting_set_string(setting, StringConvert('test value'));

  setting := config_setting_add(group, StringConvert('option5'),
    CONFIG_TYPE_BOOL);
  AssertTrue('Added ''option5'' option type ''BOOL'' is nil', setting <> nil);
  config_setting_set_bool(setting, 1);

  config_destroy(@FConfig);
end;

{ Create config and add array option }
procedure TLibConfigTest.TestCreateConfigArray;
var
  root, arr, setting, group : pconfig_setting_t;
  i : Integer;
begin
  config_init(@FConfig);
  root := config_root_setting(@FConfig);
  AssertTrue('Root config element is nil', root <> nil);

  group := config_setting_add(root, StringConvert('test'), CONFIG_TYPE_GROUP);
  AssertTrue('Group config element is nil', group <> nil);

  arr := config_setting_add(group, StringConvert('array_options'),
    CONFIG_TYPE_ARRAY);
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

{ Create config, add some test values and write to file }
procedure TLibConfigTest.TestCreateConfigFile;
var
  root, setting, group : pconfig_setting_t;
  write_result : Integer;
begin
  config_init(@FConfig);
  root := config_root_setting(@FConfig);
  AssertTrue('Root config element is nil', root <> nil);

  group := config_setting_add(root, StringConvert('test'), CONFIG_TYPE_GROUP);
  AssertTrue('Group config element is nil', group <> nil);

  setting := config_setting_add(group, StringConvert('option1'),
    CONFIG_TYPE_STRING);
  AssertTrue('Added ''option1'' option type ''STRING'' is nil', setting <> nil);
  config_setting_set_string(setting, StringConvert('option value'));

  setting := config_setting_add(group, StringConvert('option2'),
    CONFIG_TYPE_INT);
  AssertTrue('Added ''option2'' option type ''INT'' is nil', setting <> nil);
  config_setting_set_int(setting, -5);

  write_result := config_write_file(@FConfig, StringConvert('test.cfg'));
  AssertTrue('Write config file is error', write_result <> 0);
  AssertTrue('Config file is not exists', FileExists('test.cfg'));

  DeleteFile(StringConvert('test.cfg'));
  config_destroy(@FConfig);
end;

{ Create config, add some test values, write to file and after try to open file
  and read the tests values }
procedure TLibConfigTest.TestCreateConfigReadWriteFile;
var
  root, setting, group : pconfig_setting_t;
  write_result, read_result : Integer;
  Value : PAnsiChar;
begin
  config_init(@FConfig);
  root := config_root_setting(@FConfig);
  AssertTrue('Root config element is nil', root <> nil);

  group := config_setting_add(root, StringConvert('Group'), CONFIG_TYPE_GROUP);
  AssertTrue('Config group element is nil', group <> nil);

  setting := config_setting_add(group, StringConvert('option1'),
    CONFIG_TYPE_STRING);
  AssertTrue('Added ''option1'' option type ''STRING'' is nil', setting <> nil);
  config_setting_set_string(setting, StringConvert('test value'));

  setting := config_setting_add(group, StringConvert('option2'), CONFIG_TYPE_INT);
  AssertTrue('Added ''option2'' option type ''INT'' is nil', setting <> nil);
  config_setting_set_int(setting, 1001);

  write_result := config_write_file(@FConfig, StringConvert('test.cfg'));
  AssertTrue('Write config file is error', write_result <> 0);
  AssertTrue('Config file is not exists', FileExists('test.cfg'));

  config_destroy(@FConfig);
  config_init(@FConfig);

  read_result := config_read_file(@FConfig, StringConvert('test.cfg'));
  AssertTrue('Read config file is error', read_result <> 0);

  config_lookup_string(@FConfig, StringConvert('Group.option1'), @Value);
  AssertTrue(' ''Group.option1'' config option is not find', Value <> nil);
  AssertTrue('Option value is not corect', Value = 'test value');

  DeleteFile('test.cfg');
  config_destroy(@FConfig);
end;

initialization
  RegisterTest(TLibConfigTest{$IFNDEF FPC}.Suite{$ENDIF});
  RegisterTest(TConfigTest{$IFNDEF FPC}.Suite{$ENDIF});
end.

