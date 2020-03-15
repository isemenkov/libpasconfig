(******************************************************************************)
(*                                libPasConfig                                *)
(*              object pascal wrapper around libconfig library                *)
(*                  https://github.com/hyperrealm/libconfig                   *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/libpasconfig                ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the GNU General Public License as published by the Free *)
(* Software Foundation; either version 3 of the License.                      *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for *)
(* more details.                                                              *)
(*                                                                            *)
(* A copy  of the  GNU General Public License is available  on the World Wide *)
(* Web at <http://www.gnu.org/copyleft/gpl.html>. You  can also obtain  it by *)
(* writing to the Free Software Foundation, Inc., 51  Franklin Street - Fifth *)
(* Floor, Boston, MA 02110-1335, USA.                                         *)
(*                                                                            *)
(******************************************************************************)

unit pasconfig;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}
{$DEFINE USE_EXCEPTIONS}

interface

uses
  Classes, SysUtils, libpasconfig;

type
  {$IFDEF USE_EXCEPTIONS}
  { Config file/string parse error }
  EParseException = class (Exception);

  { Can't read/write configuration file }
  EIOException = class (Exception);

  { Option type cann't present by selected type }
  ETypeMismatchException = class (Exception);

  { Option value not exists }
  EValueNotExistsException = class (Exception);
  {$ENDIF}

  { TResult class generic }
  generic TResult<ResultValue, ErrorValue> = class
  private
    FResult : ResultValue;
    FError : ErrorValue;
  public
    constructor Create (Res : ResultValue; Err : ErrorValue);

    function Ok : Boolean;{$IFNDEF DEBUG}inline;{$ENDIF}

    property Result : ResultValue read FResult write FResult;
    property Error : ErrorValue read FError write FError;
  end;

  { TConfig }
  { Configuration file }
  TConfig = class
  public
    type
      { TOptionWriter }
      { Writer for configuration option }
      TOptionWriter = class
      private
        FOption : pconfig_setting_t;
      private
        { Set option value as integer }
        procedure _SetInteger (Name : String; Value : Integer);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as int64 }
        procedure _SetInt64 (Name : String; Value : Int64);{$IFNDEF DEBUG}
          inline;{$ENDIF}

        { Set option value as double }
        procedure _SetFloat (Name : String; Value : Double);{$IFNDEF DEBUG}
          inline;{$ENDIF}

        { Set option value as boolean }
        procedure _SetBoolean (Name : String; Value : Boolean);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as string }
        procedure _SetString (Name : String; Value : String);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new option group section }
        function _CreateSection (Name : String) : TOptionWriter;{$IFNDEF DEBUG}
          inline;{$ENDIF}

        { Create new array group section }
        function _CreateArray (Name : String) : TOptionWriter;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new list group section }
        function _CreateList (Name : String) : TOptionWriter;
      public
        constructor Create (AOption : pconfig_setting_t);
        destructor Destroy; override;

        { Delete current config element }
        procedure Delete;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new config group section }
        property CreateSection [Name : String] : TOptionWriter read
          _CreateSection;

        { Create new config array group section }
        property CreateArray [Name : String] : TOptionWriter read
          _CreateArray;

        { Create new config list group section }
        property CreateList [Name : String] : TOptionWriter read
          _CreateList;

        { Add new integer value to current group }
        property SetInteger [Name : String] : Integer write _SetInteger;

        { Add new int64 value to current group }
        property SetInt64   [Name : String] : Int64 write _SetInt64;

        { Add new double value to current group }
        property SetFloat   [Name : String] : Double write _SetFloat;

        { Add new boolean value to current group }
        property SetBoolean [Name : String] : Boolean write _SetBoolean;

        { Add new string value to current group }
        property SetString  [Name : String] : String write _SetString;

        { Add custom pointer to option item }
        procedure SetPointer (ptr : Pointer);{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return custom options pointer if exists }
        function GetPointer : Pointer;{$IFNDEF DEBUG}inline;{$ENDIF}
      end;

      { TOptionReader }
      { Reader for configuration option }
      TOptionReader = class
      public
        type
          { Option value type }
          TOptionType = (
            TYPE_INTEGER,
            TYPE_INT64,
            TYPE_FLOAT,
            TYPE_STRING,
            TYPE_BOOLEAN
          );

          { TArrayEnumerator }
          { Array collection enumerator }
          TArrayEnumerator = class
          protected
            FOption : pconfig_setting_t;
            FCount : Integer;
            FPosition : Cardinal;
            function GetCurrent : TOptionReader; inline;
          public
            constructor Create (AOption : pconfig_setting_t);
            function MoveNext : Boolean; inline;
            property Current : TOptionReader read GetCurrent;
            function GetEnumerator : TArrayEnumerator; inline;
          end;

          { TListEnumerator }
          { List collection enumerator }
          TListEnumerator = class
          protected
            FOption : pconfig_setting_t;
            FCount : Integer;
            FPosition : Cardinal;
            function GetCurrent : TOptionReader; inline;
          public
            constructor Create (AOption : pconfig_setting_t);
            function MoveNext : Boolean; inline;
            property Current : TOptionReader read GetCurrent;
            function GetEnumerator : TListEnumerator; inline;
          end;
      private
        FOption : pconfig_setting_t;
      private
        { Get option value by path }
        function _GetValue (Path : String) : TOptionReader;{$IFNDEF DEBUG}
          inline;{$ENDIF}

        { Get option value as integer }
        function _GetInteger : Integer;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as int64 }
        function _GetInt64 : Int64;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as double }
        function _GetFloat : Double;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as boolean }
        function _GetBoolean : Boolean;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as string }
        function _GetString : String;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new option group section }
        function _CreateSection (Name : String) : TOptionWriter;{$IFNDEF DEBUG}
          inline;{$ENDIF}

        { Create new array group section }
        function _CreateArray (Name : String) : TOptionWriter;{$IFNDEF DEBUG}
          inline;{$ENDIF}

        { Create new list group section }
        function _CreateList (Name : String) : TOptionWriter;{$IFNDEF DEBUG}
          inline;{$ENDIF}
      public
        constructor Create (AOption : pconfig_setting_t);
        destructor Destroy; override;

        { Return true if element is root }
        function IsRoot : Boolean;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Reutrn true if element is section group }
        function IsSection : Boolean;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return true if element is array }
        function IsArray : Boolean;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return true if element is list }
        function IsList : Boolean;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option element parent }
        function GetParent : TOptionReader;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option value type }
        function GetType : TOptionType;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option name }
        function GetName : String;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option source file name }
        function GetSourceFile : String;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option source line }
        function GetSourceLine : Cardinal;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Add custom pointer to option item }
        procedure SetPointer (ptr : Pointer);{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return custom options pointer if exists }
        function GetPointer : Pointer;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Delete current config param }
        procedure Delete; {$IFNDEF DEBUG}inline{$ENDIF}

        { Return option value by path }
        property Value [Path : String] : TOptionReader read _GetValue;

        { Read option data value }
        { Present option value as integer type }
        property AsInteger : Integer read _GetInteger;

        { Present option value as int64 type }
        property AsInt64 : Int64 read _GetInt64;

        { Present option value as double type }
        property AsFloat : Double read _GetFloat;

        { Present option value as boolean type }
        property AsBoolean : Boolean read _GetBoolean;

        { Present option value as string type }
        property AsString : String read _GetString;

        { Return array group enumerator }
        function AsArray : TArrayEnumerator;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Return list group enumerator }
        function AsList : TListEnumerator;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Write option data value }
        { Create new config group section }
        property CreateSection [Name : String] : TOptionWriter read
          _CreateSection;

        { Create new config array group section }
        property CreateArray [Name : String] : TOptionWriter read
          _CreateArray;

        { Create new config list group section }
        property CreateList [Name : String] : TOptionWriter read
          _CreateList;
      end;
  private
    FConfig : config_t;
    FRootElement : pconfig_setting_t;
  private
    { Get option path }
    function _GetValue (Path : String) : TOptionReader;{$IFNDEF DEBUG}inline;
      {$ENDIF}

    { Create new values group }
    function _CreateSection (Name : String) : TOptionWriter;{$IFNDEF DEBUG}
      inline;{$ENDIF}

    { Create new array group section }
    function _CreateArray (Name : String) : TOptionWriter;{$IFNDEF DEBUG}
      inline;{$ENDIF}

    { Create new list group section }
    function _CreateList (Name : String) : TOptionWriter;{$IFNDEF DEBUG}inline;
      {$ENDIF}

    { Return include directory wich will be located for the configuration
      config }
    function GetIncludeDir : string;{$IFNDEF DEBUG}inline;{$ENDIF}

    { Set include directory }
    procedure SetIncludeDir (Path : String);{$IFNDEF DEBUG}inline;{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;

    { Load config file from file and parse it }
    procedure LoadFromFile (Filename : String);{$IFNDEF DEBUG}inline;{$ENDIF}

    { Parse configuration from string }
    procedure Parse (ConfigString : String);{$IFNDEF DEBUG}inline;{$ENDIF}

    { Save current config to filename }
    procedure SaveToFile (Filename : String);{$IFNDEF DEBUG}inline;{$ENDIF}

    { Try to read value path }
    property Value [Path : String] : TOptionReader read _GetValue;

    { Create new config group section }
    property CreateSection [Name : String] : TOptionWriter read
      _CreateSection;

    { Create new config array group section }
    property CreateArray [Name : String] : TOptionWriter read
      _CreateArray;

    { Create new config list group section }
    property CreateList [Name : String] : TOptionWriter read
      _CreateList;

    { Current config include directory }
    property IncludeDir : String read GetIncludeDir write SetIncludeDir;
  end;

implementation

{ TResult }

constructor TResult.Create(Res: ResultValue; Err: ErrorValue);
begin
  FResult := Res;
  FError := Err;
end;

function TResult.Ok: Boolean;
begin
  Result := FError <> nil;
end;

{ TConfig.TOptionWriter }

constructor TConfig.TOptionWriter.Create(AOption: pconfig_setting_t);
begin
  FOption := AOption;
end;

destructor TConfig.TOptionWriter.Destroy;
begin
  inherited Destroy;
end;

procedure TConfig.TOptionWriter.Delete;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_remove(FOption, config_setting_name(FOption)) <>
    CONFIG_TRUE then
    raise EValueNotExistsException.Create('Can''t remove element. Item not ' +
      'exists.');
  {$ENDIF}
  {$IFNDEF USE_EXCEPTIONS}
  config_setting_remove(FOption, config_setting_name(FOption));
  {$ENDIF}
end;

procedure TConfig.TOptionWriter.SetPointer(ptr: Pointer);
begin
  config_setting_set_hook(FOption, ptr);
end;

function TConfig.TOptionWriter.GetPointer: Pointer;
begin
  Result := config_setting_get_hook(FOption);
end;

procedure TConfig.TOptionWriter._SetInteger(Name: String; Value: Integer);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_INT);
  config_setting_set_int(setting, Value);
end;

procedure TConfig.TOptionWriter._SetInt64(Name: String; Value: Int64);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_INT64);
  config_setting_set_int64(setting, Value);
end;

procedure TConfig.TOptionWriter._SetFloat(Name: String; Value: Double);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_FLOAT);
  config_setting_set_float(setting, Value);
end;

procedure TConfig.TOptionWriter._SetBoolean(Name: String; Value: Boolean);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_BOOL);
  config_setting_set_bool(setting, Integer(Value));
end;

procedure TConfig.TOptionWriter._SetString(Name: String; Value: String);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_STRING);
  config_setting_set_string(setting, PChar(Value));
end;

function TConfig.TOptionWriter._CreateSection(Name: String): TOptionWriter;
begin
  Result := TOptionWriter.Create(config_setting_add(FOption, PChar(Name),
    CONFIG_TYPE_GROUP));
end;

function TConfig.TOptionWriter._CreateArray(Name : String): TOptionWriter;
begin
  Result := TOptionWriter.Create(config_setting_add(FOption, PChar(Name),
    CONFIG_TYPE_ARRAY));
end;

function TConfig.TOptionWriter._CreateList(Name: String): TOptionWriter;
begin
  Result := TOptionWriter.Create(config_setting_add(FOption, PChar(Name),
    CONFIG_TYPE_LIST));
end;

{ TConfig.TOptionReader.TArrayEnumerator }

constructor TConfig.TOptionReader.TArrayEnumerator.Create(
  AOption: pconfig_setting_t);
begin
  FOption := AOption;
  FPosition := 0;
  FCount := config_setting_length(FOption);
end;

function TConfig.TOptionReader.TArrayEnumerator.GetCurrent: TOptionReader;
begin
  Result := TOptionReader.Create(config_setting_get_elem(FOption, FPosition));
  Inc(FPosition);
end;

function TConfig.TOptionReader.TArrayEnumerator.MoveNext: Boolean;
begin
  Result := FPosition < FCount;
end;

function TConfig.TOptionReader.TArrayEnumerator.GetEnumerator: TArrayEnumerator;
begin
  Result := Self;
end;

{ TConfig.TOptionReader.TListEnumerator }

constructor TConfig.TOptionReader.TListEnumerator.Create(
  AOption: pconfig_setting_t);
begin
  FOption := AOption;
  FPosition := 0;
  FCount := config_setting_length(FOption);
end;

function TConfig.TOptionReader.TListEnumerator.GetCurrent: TOptionReader;
begin
  Result := TOptionReader.Create(config_setting_get_elem(FOption, FPosition));
  Inc(FPosition);
end;

function TConfig.TOptionReader.TListEnumerator.MoveNext: Boolean;
begin
  Result := FPosition < FCount;
end;

function TConfig.TOptionReader.TListEnumerator.GetEnumerator: TListEnumerator;
begin
  Result := Self;
end;

{ TConfig.TOptionReader }

constructor TConfig.TOptionReader.Create(AOption: pconfig_setting_t);
begin
  FOption := AOption;
end;

destructor TConfig.TOptionReader.Destroy;
begin
  inherited Destroy;
end;

function TConfig.TOptionReader.IsRoot: Boolean;
begin
  Result := (config_setting_is_root(FOption) = CONFIG_TRUE);
end;

function TConfig.TOptionReader.IsSection: Boolean;
begin
  Result := (config_setting_is_group(FOption) = CONFIG_TRUE);
end;

function TConfig.TOptionReader.IsArray: Boolean;
begin
  Result := (config_setting_is_array(FOption) = CONFIG_TRUE);
end;

function TConfig.TOptionReader.IsList: Boolean;
begin
  Result := (config_setting_is_list(FOption) = CONFIG_TRUE);
end;

procedure TConfig.TOptionReader.Delete;
begin
  if config_setting_is_group(FOption) = CONFIG_TRUE then
  begin
    {$IFDEF USE_EXCEPTIONS}
    if config_setting_remove(FOption, config_setting_name(FOption)) <>
      CONFIG_TRUE then
      raise EValueNotExistsException.Create('Can''t remove element. Item not ' +
        'exists.');
    {$ELSE}
    config_setting_remove(FOption, config_setting_name(FOption));
    {$ENDIF}
  end else
  begin
    {$IFDEF USE_EXCEPTIONS}
    if config_setting_remove_elem(config_setting_parent(FOption),
      config_setting_index(FOption)) <> CONFIG_TRUE then
      raise EValueNotExistsException.Create('Can''t remove element. Item not ' +
        'exists.');
    {$ELSE}
    config_setting_remove_elem(config_setting_parent(FOption),
      config_setting_index(FOption));
    {$ENDIF}
  end;
end;

function TConfig.TOptionReader.AsArray: TArrayEnumerator;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_ARRAY then
    raise ETypeMismatchException.Create('Option type can''t present as array');
  {$ENDIF}
  Result := TArrayEnumerator.Create(FOption);
end;

function TConfig.TOptionReader.AsList: TListEnumerator;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_LIST then
    raise ETypeMismatchException.Create('Option type can''t present as list');
  {$ENDIF}
  Result := TListEnumerator.Create(FOption);
end;

function TConfig.TOptionReader.GetParent : TOptionReader;
begin
  Result := TOptionReader.Create(config_setting_parent(FOption));
end;

function TConfig.TOptionReader.GetType : TOptionType;
begin
  Result := TOptionType(config_setting_type(FOption) - 2);
end;

function TConfig.TOptionReader.GetName : String;
begin
  Result := config_setting_name(FOption);
end;

function TConfig.TOptionReader.GetSourceFile: String;
begin
  Result := config_setting_source_file(FOption);
end;

function TConfig.TOptionReader.GetSourceLine: Cardinal;
begin
  Result := config_setting_source_line(FOption);
end;

procedure TConfig.TOptionReader.SetPointer(ptr: Pointer);
begin
  TOptionWriter.Create(FOption).SetPointer(ptr);
end;

function TConfig.TOptionReader.GetPointer: Pointer;
begin
  Result := TOptionWriter.Create(FOption).GetPointer;
end;

function TConfig.TOptionReader._GetValue(Path: String): TOptionReader;
begin
  Result := TOptionReader.Create(config_setting_lookup(FOption, PChar(Path)));
  {$IFDEF USE_EXCEPTIONS}
  if Result.FOption = nil then
    raise EValueNotExistsException.Create('Value ''' + Path + ''' not exists');
  {$ENDIF}
end;

function TConfig.TOptionReader._GetInteger: Integer;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_INT then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'integer');
  {$ENDIF}
  Result := config_setting_get_int(FOption);
end;

function TConfig.TOptionReader._GetInt64: Int64;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_INT64 then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'int64');
  {$ENDIF}
  Result := config_setting_get_int64(FOption);
end;

function TConfig.TOptionReader._GetFloat: Double;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_FLOAT then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'double');
  {$ENDIF}
  Result := config_setting_get_float(FOption);
end;

function TConfig.TOptionReader._GetBoolean: Boolean;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_BOOL then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'boolean');
  {$ENDIF}
  Result := Boolean(config_setting_get_bool(FOption));
end;

function TConfig.TOptionReader._GetString: String;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_STRING then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'string');
  {$ENDIF}
  Result := config_setting_get_string(FOption);
end;

function TConfig.TOptionReader._CreateSection(Name: String): TOptionWriter;
begin
  Result := TOptionWriter.Create(FOption)._CreateSection(Name);
end;

function TConfig.TOptionReader._CreateArray(Name : String): TOptionWriter;
begin
  Result := TOptionWriter.Create(FOption)._CreateArray(Name);
end;

function TConfig.TOptionReader._CreateList(Name: String): TOptionWriter;
begin
  Result := TOptionWriter.Create(FOption)._CreateList(Name);
end;

{ TConfig }

constructor TConfig.Create;
begin
  config_init(@FConfig);
  FRootElement := config_root_setting(@FConfig);
end;

destructor TConfig.Destroy;
begin
  config_destroy(@FConfig);
  inherited Destroy;
end;

procedure TConfig.LoadFromFile(Filename : String);
begin
  config_init(@FConfig);
  {$IFDEF USE_EXCEPTIONS}
  if config_read_file(@FConfig, PChar(Filename)) <> CONFIG_TRUE then
    raise EParseException.Create(Format('%s:%d - %s',
      [config_error_file(@FConfig), config_error_line(@FConfig),
      config_error_text(@FConfig)]));
  {$ELSE}
  config_read_file(@FConfig, PChar(Filename));
  {$ENDIF}
  FRootElement := config_root_setting(@FConfig);
end;

procedure TConfig.Parse(ConfigString: String);
begin
  config_init(@FConfig);
  {$IFDEF USE_EXCEPTIONS}
  if config_read_string(@FConfig, PChar(ConfigString)) <> CONFIG_TRUE then
    raise EParseException.Create(Format('%s:%d - %s',
      [config_error_file(@FConfig), config_error_line(@FConfig),
      config_error_text(@FConfig)]));
  {$ELSE}
  config_read_string(@FConfig, PChar(ConfigString));
  {$ENDIF}
  FRootElement := config_root_setting(@FConfig);
end;

procedure TConfig.SaveToFile(Filename: String);
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_write_file(@FConfig, PChar(Filename)) <> CONFIG_TRUE then
    raise EIOException.Create('Can''t write file: ' + Filename);
  {$ELSE}
  config_write_file(@FConfig, PChar(Filename));
  {$ENDIF}
end;

function TConfig._GetValue(Path: String): TOptionReader;
begin
  Result := TOptionReader.Create(FRootElement)._GetValue(Path);
end;

function TConfig._CreateSection(Name: String): TOptionWriter;
begin
  Result := TOptionWriter.Create(FRootElement)._CreateSection(Name);
end;

function TConfig._CreateArray(Name : String): TOptionWriter;
begin
  Result := TOptionWriter.Create(FRootElement)._CreateArray(Name);
end;

function TConfig._CreateList(Name: String): TOptionWriter;
begin
  Result := TOptionWriter.Create(FRootElement)._CreateList(Name);
end;

function TConfig.GetIncludeDir: string;
begin
  Result := config_get_include_dir(@FConfig);
end;

procedure TConfig.SetIncludeDir(Path: String);
begin
  config_set_include_dir(@FConfig, PChar(Path));
end;

end.

