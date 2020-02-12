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
  { Option type cann't present by selected type }
  ETypeMismatchException = class (Exception);

  { Option value not exists }
  EValueNotExistsException = class (Exception);
  {$ENDIF}

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
        { Get option element parent }
        function _GetParent : TOptionReader;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value type }
        function _GetType : TOptionType;{$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option name }
        function _GetName : String;{$IFNDEF DEBUG}inline;{$ENDIF}

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

        { Return option element parent }
        property OptionParent : TOptionReader read _GetParent;

        { Return option value type }
        property OptionType : TOptionType read _GetType;

        { Return option name }
        property OptionName : String read _GetName;

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
  public
    constructor Create;
    constructor Create (AFilename : string); { Create config and load data  }
                                             { from file }
    destructor Destroy; override;

    { Reload config data from file }
    procedure Reload;

    { Try to read value path }
    property Value [Path : String] : TOptionReader read _GetValue;

    { Create new config group section }
    property CreateSection [Name : String] : TOptionWriter read
      _CreateSection;

    { Create new config array group section }
    property CreateArray [Name : String] : TOptionWriter read
      _CreateArray;
  end;

implementation

{ TConfig.TOptionWriter }

constructor TConfig.TOptionWriter.Create(AOption: pconfig_setting_t);
begin
  FOption := AOption;
end;

destructor TConfig.TOptionWriter.Destroy;
begin
  inherited Destroy;
end;

procedure TConfig.TOptionWriter._SetInteger(Name: String; Value: Integer);
var
  setting : pconfig_setting_t;
begin
  if config_setting_type(FOption) = CONFIG_TYPE_ARRAY then
  begin
    setting := config_setting_add(FOption, nil, CONFIG_TYPE_INT);
    config_setting_set_int(setting, Value);
    Exit;
  end;

  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_INT);
  config_setting_set_int(setting, Value);
end;

procedure TConfig.TOptionWriter._SetInt64(Name: String; Value: Int64);
var
  setting : pconfig_setting_t;
begin
  if config_setting_type(FOption) = CONFIG_TYPE_ARRAY then
  begin
    setting := config_setting_add(FOption, nil, CONFIG_TYPE_INT64);
    config_setting_set_int64(setting, Value);
    Exit;
  end;

  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_INT64);
  config_setting_set_int64(setting, Value);
end;

procedure TConfig.TOptionWriter._SetFloat(Name: String; Value: Double);
var
  setting : pconfig_setting_t;
begin
  if config_setting_type(FOption) = CONFIG_TYPE_ARRAY then
  begin
    setting := config_setting_add(FOption, nil, CONFIG_TYPE_FLOAT);
    config_setting_set_float(setting, Value);
    Exit;
  end;

  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_FLOAT);
  config_setting_set_float(setting, Value);
end;

procedure TConfig.TOptionWriter._SetBoolean(Name: String; Value: Boolean);
var
  setting : pconfig_setting_t;
begin
  if config_setting_type(FOption) = CONFIG_TYPE_ARRAY then
  begin
    setting := config_setting_add(FOption, nil, CONFIG_TYPE_BOOL);
    config_setting_set_bool(setting, Integer(Value));
    Exit;
  end;

  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_BOOL);
  config_setting_set_bool(setting, Integer(Value));
end;

procedure TConfig.TOptionWriter._SetString(Name: String; Value: String);
var
  setting : pconfig_setting_t;
begin
  if config_setting_type(FOption) = CONFIG_TYPE_ARRAY then
  begin
    setting := config_setting_add(FOption, nil, CONFIG_TYPE_STRING);
    config_setting_set_string(setting, PChar(Value));
    Exit;
  end;

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

end;

function TConfig.TOptionReader._GetParent: TOptionReader;
begin
  Result := TOptionReader.Create(config_setting_parent(FOption));
end;

function TConfig.TOptionReader._GetType: TOptionType;
begin
  Result := TOptionType(config_setting_type(FOption) - 2);
end;

function TConfig.TOptionReader._GetName: String;
begin
  Result := config_setting_name(FOption);
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

constructor TConfig.Create(AFilename: string);
begin
  config_init(@FConfig);
  config_read_file(@FConfig, PChar(AFilename));
  FRootElement := config_root_setting(@FConfig);
end;

destructor TConfig.Destroy;
begin
  config_destroy(@FConfig);
  inherited Destroy;
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

procedure TConfig.Reload;
begin
  // TODO
end;

end.

