(******************************************************************************)
(*                                libPasConfig                                *)
(*         delphi and object pascal  wrapper around libconfig library         *)
(*                  https://github.com/hyperrealm/libconfig                   *)
(*                                                                            *)
(* Copyright (c) 2019 - 2021                                Ivan Semenkov     *)
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

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils, libpasconfig, utils.result;

type
  { Configuration file }
  TConfig = class
  public
    type
      TErrors = (
        ERROR_NONE                                                    = 0,
        ERROR_READ_FILE                                               = 1,
        ERROR_READ_STRING                                             = 2,
        ERROR_WRITE_FILE                                              = 3,
        ERROR_NULL_NODE                                               = 4,
        ERROR_DELETE                                                  = 5
      );

      { Option value type }
      TOptionType = (
        TYPE_INTEGER,
        TYPE_INT64,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_BOOLEAN
      );

      TVoidResult = {$IFDEF FPC}specialize{$ENDIF} TVoidResult<TErrors>;
      TBooleanResult = {$IFDEF FPC}specialize{$ENDIF} TResult<Boolean, TErrors>;
      TOptionTypeResult = class({$IFDEF FPC}specialize{$ENDIF} 
        TResult<TOptionType, TConfig.TErrors>);
      TStringResult = {$IFDEF FPC}specialize{$ENDIF} TResult<String, TErrors>;
      TCardinalResult = {$IFDEF FPC}specialize{$ENDIF} TResult<Cardinal, 
        TErrors>;
      TPointerResult = {$IFDEF FPC}specialize{$ENDIF} TResult<Pointer, TErrors>;
      TIntegerResult = {$IFDEF FPC}specialize{$ENDIF} TResult<Integer, TErrors>;
      TInt64Result = {$IFDEF FPC}specialize{$ENDIF} TResult<Int64, TErrors>;
      TDoubleResult = {$IFDEF FPC}specialize{$ENDIF} TResult<Double, TErrors>;
    type
      TOptionWriter = class;

      { TCollectionWriter }
      TCollectionWriter = class
      protected
        FOption : pconfig_setting_t;
      private
        { Set option value as integer }
        procedure _SetInteger (Value : Integer);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as int64 }
        procedure _SetInt64 (Value : Int64);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as double }
        procedure _SetFloat (Value : Double);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as boolean }
        procedure _SetBoolean (Value : Boolean);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as string }
        procedure _SetString (Value : String);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new option group section }
        function _CreateSection (Name : String) : TOptionWriter;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new array group section }
        function _CreateArray (Name : String) : TCollectionWriter;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new list group section }
        function _CreateList (Name : String) : TCollectionWriter;
          {$IFNDEF DEBUG}inline;{$ENDIF}
      protected
        function ConvertString (AString : String) : PAnsiChar;
      public
        constructor Create (AOption : pconfig_setting_t);
        destructor Destroy; override;

        { Add new integer value to current collection }
        property SetInteger : Integer write _SetInteger;

        { Add new int64 value to current collection }
        property SetInt64 : Int64 write _SetInt64;

        { Add new double value to current collection }
        property SetFloat : Double write _SetFloat;

        { Add new boolean value to current collection }
        property SetBoolean : Boolean write _SetBoolean;

        { Add new string value to current collection }
        property SetString : String write _SetString;

        { Create new config group section }
        property CreateSection [Name : String] : TOptionWriter read
          _CreateSection;

        { Create new config array group section }
        property CreateArray [Name : String] : TCollectionWriter read
          _CreateArray;

        { Create new config list group section }
        property CreateList [Name : String] : TCollectionWriter read
          _CreateList;

        { Add custom pointer to option item }
        procedure SetPointer (ptr : Pointer);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return custom options pointer if exists }
        function GetPointer : Pointer;
          {$IFNDEF DEBUG}inline;{$ENDIF}
      end;

      { TOptionWriter }
      { Writer for configuration option }
      TOptionWriter = class (TCollectionWriter)
      private
        { Set option value as integer }
        procedure _SetInteger (Name : String; Value : Integer);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as int64 }
        procedure _SetInt64 (Name : String; Value : Int64);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as double }
        procedure _SetFloat (Name : String; Value : Double);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as boolean }
        procedure _SetBoolean (Name : String; Value : Boolean);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Set option value as string }
        procedure _SetString (Name : String; Value : String);
          {$IFNDEF DEBUG}inline;{$ENDIF}
      public
        constructor Create (AOption : pconfig_setting_t);
        destructor Destroy; override;

        { Delete current config element }
        function Delete : TVoidResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

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
          { TArrayEnumerator }
          { Array collection enumerator }
          TArrayEnumerator = class
          protected
            FOption : pconfig_setting_t;
            FCount : Integer;
            FPosition : Integer;
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
            FPosition : Integer;
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
        function _GetValue (Path : String) : TOptionReader;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as integer }
        function _GetInteger : TIntegerResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as int64 }
        function _GetInt64 : TInt64Result;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as double }
        function _GetFloat : TDoubleResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as boolean }
        function _GetBoolean : TBooleanResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Get option value as string }
        function _GetString : TStringResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new option group section }
        function _CreateSection (Name : String) : TOptionWriter;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new array group section }
        function _CreateArray (Name : String) : TCollectionWriter;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Create new list group section }
        function _CreateList (Name : String) : TCollectionWriter;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        function ConvertString (AString : String) : PAnsiChar;
      public
        constructor Create (AOption : pconfig_setting_t);
        destructor Destroy; override;

        { Return true if element is root }
        function IsRoot : TBooleanResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Reutrn true if element is section group }
        function IsSection : TBooleanResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return true if element is array }
        function IsArray : TBooleanResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return true if element is list }
        function IsList : TBooleanResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option element parent }
        function GetParent : TOptionReader;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option value type }
        function GetType : TOptionTypeResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option name }
        function GetName : TStringResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option source file name }
        function GetSourceFile : TStringResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return option source line }
        function GetSourceLine : TCardinalResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Add custom pointer to option item }
        procedure SetPointer (ptr : Pointer);
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return custom options pointer if exists }
        function GetPointer : TPointerResult;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Delete current config param }
        function Delete : TVoidResult; 
          {$IFNDEF DEBUG}inline{$ENDIF}

        { Return option value by path }
        property Value [Path : String] : TOptionReader read _GetValue;

        { Read option data value }
        { Present option value as integer type }
        property AsInteger : TIntegerResult read _GetInteger;

        { Present option value as int64 type }
        property AsInt64 : TInt64Result read _GetInt64;

        { Present option value as double type }
        property AsFloat : TDoubleResult read _GetFloat;

        { Present option value as boolean type }
        property AsBoolean : TBooleanResult read _GetBoolean;

        { Present option value as string type }
        property AsString : TStringResult read _GetString;

        { Return array group enumerator }
        function AsArray : TArrayEnumerator;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Return list group enumerator }
        function AsList : TListEnumerator;
          {$IFNDEF DEBUG}inline;{$ENDIF}

        { Write option data value }
        { Create new config group section }
        property CreateSection [Name : String] : TOptionWriter read
          _CreateSection;

        { Create new config array group section }
        property CreateArray [Name : String] : TCollectionWriter read
          _CreateArray;

        { Create new config list group section }
        property CreateList [Name : String] : TCollectionWriter read
          _CreateList;
      end;
  private
    FConfig : config_t;
    FRootElement : pconfig_setting_t;
  private
    { Get option path }
    function _GetValue (Path : String) : TOptionReader;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Create new values group }
    function _CreateSection (Name : String) : TOptionWriter;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Create new array group section }
    function _CreateArray (Name : String) : TCollectionWriter;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Create new list group section }
    function _CreateList (Name : String) : TCollectionWriter;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return include directory wich will be located for the configuration
      config }
    function GetIncludeDir : string;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Set include directory }
    procedure SetIncludeDir (Path : String);
      {$IFNDEF DEBUG}inline;{$ENDIF}

    function ConvertString (AString : String) : PAnsiChar;
  public
    constructor Create;
    destructor Destroy; override;

    { Load config file from file and parse it }
    function LoadFromFile (Filename : String) : TVoidResult;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Parse configuration from string }
    function Parse (ConfigString : String) : TVoidResult;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Save current config to filename }
    function SaveToFile (Filename : String) : TVoidResult;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Try to read value path }
    property Value [Path : String] : TOptionReader read _GetValue;

    { Create new config group section }
    property CreateSection [Name : String] : TOptionWriter read
      _CreateSection;

    { Create new config array group section }
    property CreateArray [Name : String] : TCollectionWriter read
      _CreateArray;

    { Create new config list group section }
    property CreateList [Name : String] : TCollectionWriter read
      _CreateList;

    { Current config include directory }
    property IncludeDir : String read GetIncludeDir write SetIncludeDir;
  end;

implementation

{ TConfig.TCollectionWriter }

function TConfig.TCollectionWriter.ConvertString (AString : String) : PAnsiChar;
begin
  Result := PAnsiChar({$IFNDEF FPC}Utf8Encode{$ENDIF}(AString)); 
end;

procedure TConfig.TCollectionWriter._SetInteger(Value: Integer);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(''), CONFIG_TYPE_INT);
  if setting <> nil then
    config_setting_set_int(setting, Value);
end;

procedure TConfig.TCollectionWriter._SetInt64(Value: Int64);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(''), CONFIG_TYPE_INT64);
  if setting <> nil then
    config_setting_set_int64(setting, Value);
end;

procedure TConfig.TCollectionWriter._SetFloat(Value: Double);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(''), CONFIG_TYPE_FLOAT);
  if setting <> nil then
    config_setting_set_float(setting, Value);
end;

procedure TConfig.TCollectionWriter._SetBoolean(Value: Boolean);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(''), CONFIG_TYPE_BOOL);
  if setting <> nil then
    config_setting_set_bool(setting, Integer(Value));
end;

procedure TConfig.TCollectionWriter._SetString(Value: String);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(''), CONFIG_TYPE_STRING);
  if setting <> nil then
    config_setting_set_string(setting, ConvertString(Value));
end;

function TConfig.TCollectionWriter._CreateSection(Name: String): TOptionWriter;
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
  begin
    Result := TOptionWriter.Create(FOption);
    Exit;
  end;

  setting := config_setting_add(FOption, ConvertString(Name), 
    CONFIG_TYPE_GROUP);
  Result := TOptionWriter.Create(setting);
end;

function TConfig.TCollectionWriter._CreateArray(Name: String) :
  TCollectionWriter;
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
  begin
    Result := TCollectionWriter.Create(FOption);
    Exit;
  end;

  setting := config_setting_add(FOption, ConvertString(Name), 
    CONFIG_TYPE_ARRAY);
  Result := TCollectionWriter.Create(setting);
end;

function TConfig.TCollectionWriter._CreateList(Name: String): TCollectionWriter;
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
  begin
    Result := TCollectionWriter.Create(FOption);
    Exit;
  end;

  setting := config_setting_add(FOption, ConvertString(Name), 
    CONFIG_TYPE_LIST);
  Result := TCollectionWriter.Create(setting);
end;

constructor TConfig.TCollectionWriter.Create(AOption: pconfig_setting_t);
begin
  FOption := AOption;
end;

destructor TConfig.TCollectionWriter.Destroy;
begin
  inherited Destroy;
end;

procedure TConfig.TCollectionWriter.SetPointer(ptr: Pointer);
begin
  config_setting_set_hook(FOption, ptr);
end;

function TConfig.TCollectionWriter.GetPointer: Pointer;
begin
  Result := config_setting_get_hook(FOption);
end;

{ TConfig.TOptionWriter }

constructor TConfig.TOptionWriter.Create(AOption: pconfig_setting_t);
begin
  inherited Create(AOption);
end;

destructor TConfig.TOptionWriter.Destroy;
begin
  inherited Destroy;
end;

function TConfig.TOptionWriter.Delete : TVoidResult;
begin
  if (FOption <> nil) and (config_setting_is_group(FOption) = CONFIG_TRUE) then
  begin
    if config_setting_remove(FOption, config_setting_name(FOption)) <> 
       CONFIG_TRUE then
      Exit(TVoidResult.CreateError(ERROR_DELETE))
    else
      Exit(TVoidResult.CreateValue);
  end else
  begin
    if config_setting_remove_elem(config_setting_parent(FOption),
       config_setting_index(FOption)) <> CONFIG_TRUE then
      Exit(TVoidResult.CreateError(ERROR_DELETE))
    else
      Exit(TVoidResult.CreateValue);
  end;

  Result := TVoidResult.CreateError(ERROR_NULL_NODE);
end;

procedure TConfig.TOptionWriter._SetInteger(Name: String; Value: Integer);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(Name), CONFIG_TYPE_INT);
  if setting <> nil then
    config_setting_set_int(setting, Value);
end;

procedure TConfig.TOptionWriter._SetInt64(Name: String; Value: Int64);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(Name), 
    CONFIG_TYPE_INT64);
  if setting <> nil then
    config_setting_set_int64(setting, Value);
end;

procedure TConfig.TOptionWriter._SetFloat(Name: String; Value: Double);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(Name), 
    CONFIG_TYPE_FLOAT);
  if setting <> nil then
    config_setting_set_float(setting, Value);
end;

procedure TConfig.TOptionWriter._SetBoolean(Name: String; Value: Boolean);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(Name), CONFIG_TYPE_BOOL);
  if setting <> nil then
    config_setting_set_bool(setting, Integer(Value));
end;

procedure TConfig.TOptionWriter._SetString(Name: String; Value: String);
var
  setting : pconfig_setting_t;
begin
  if FOption = nil then
    Exit;

  setting := config_setting_add(FOption, ConvertString(Name), 
    CONFIG_TYPE_STRING);
  if setting <> nil then
    config_setting_set_string(setting, ConvertString(Value));
end;

{ TConfig.TOptionReader.TArrayEnumerator }

constructor TConfig.TOptionReader.TArrayEnumerator.Create(
  AOption: pconfig_setting_t);
begin
  FOption := AOption;
  FPosition := 0;
  if FOption = nil then
    FCount := 0
  else
    FCount := config_setting_length(FOption);
end;

function TConfig.TOptionReader.TArrayEnumerator.GetCurrent: TOptionReader;
begin
  if FOption = nil then
  begin
    Result := TOptionReader.Create(FOption);
    Exit;
  end;

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
  if FOption = nil then
    FCount := 0
  else
    FCount := config_setting_length(FOption);
end;

function TConfig.TOptionReader.TListEnumerator.GetCurrent: TOptionReader;
begin
  if FOption = nil then
  begin
    Result := TOptionReader.Create(FOption);
    Exit;
  end;

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

function TConfig.TOptionReader.ConvertString (AString : String) : PAnsiChar;
begin
  Result := PAnsiChar({$IFNDEF FPC}Utf8Encode{$ENDIF}(AString));
end;

constructor TConfig.TOptionReader.Create(AOption: pconfig_setting_t);
begin
  FOption := AOption;
end;

destructor TConfig.TOptionReader.Destroy;
begin
  inherited Destroy;
end;

function TConfig.TOptionReader.IsRoot: TBooleanResult;
begin
  if FOption = nil then
  begin
    Exit(TBooleanResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TBooleanResult.CreateValue(config_setting_is_root(FOption) = 
    CONFIG_TRUE);
end;

function TConfig.TOptionReader.IsSection: TBooleanResult;
begin
  if FOption = nil then
  begin
    Exit(TBooleanResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TBooleanResult.CreateValue(config_setting_is_group(FOption) =
    CONFIG_TRUE);
end;

function TConfig.TOptionReader.IsArray: TBooleanResult;
begin
  if FOption = nil then
  begin
    Exit(TBooleanResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TBooleanResult.CreateValue(config_setting_is_array(FOption) =
    CONFIG_TRUE);
end;

function TConfig.TOptionReader.IsList: TBooleanResult;
begin
  if FOption = nil then
  begin
    Exit(TBooleanResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TBooleanResult.CreateValue(config_setting_is_list(FOption) = 
    CONFIG_TRUE);
end;

function TConfig.TOptionReader.Delete : TVoidResult;
begin
  Result := TOptionWriter.Create(FOption).Delete;
end;

function TConfig.TOptionReader.AsArray: TArrayEnumerator;
begin
  Result := TArrayEnumerator.Create(FOption);
end;

function TConfig.TOptionReader.AsList: TListEnumerator;
begin
  Result := TListEnumerator.Create(FOption);
end;

function TConfig.TOptionReader.GetParent : TOptionReader;
begin
  Result := TOptionReader.Create(config_setting_parent(FOption));
end;

function TConfig.TOptionReader.GetType : TOptionTypeResult;
begin
  if FOption = nil then
  begin
    Exit(TOptionTypeResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TOptionTypeResult.CreateValue(
    TOptionType(config_setting_type(FOption) - 2));
end;

function TConfig.TOptionReader.GetName : TStringResult;
begin
  if FOption = nil then
  begin
    Exit(TStringResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TStringResult.CreateValue(String(Utf8ToString(config_setting_name(
    FOption))));
end;

function TConfig.TOptionReader.GetSourceFile: TStringResult;
begin
  if FOption = nil then
  begin
    Exit(TStringResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TStringResult.CreateValue(String(Utf8ToString(
    config_setting_source_file(FOption))));
end;

function TConfig.TOptionReader.GetSourceLine: TCardinalResult;
begin
  if FOption = nil then
  begin
    Exit(TCardinalResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TCardinalResult.CreateValue(config_setting_source_line(FOption));
end;

procedure TConfig.TOptionReader.SetPointer(ptr: Pointer);
begin
  TOptionWriter.Create(FOption).SetPointer(ptr);
end;

function TConfig.TOptionReader.GetPointer: TPointerResult;
begin
  if FOption = nil then
  begin
    Exit(TPointerResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TPointerResult.CreateValue(TOptionWriter.Create(FOption)
    .GetPointer);
end;

function TConfig.TOptionReader._GetValue(Path: String): TOptionReader;
begin
  Result := TOptionReader.Create(config_setting_lookup(FOption, 
    ConvertString(Path)));
end;

function TConfig.TOptionReader._GetInteger: TIntegerResult;
begin
  if FOption = nil then
  begin
    Exit(TIntegerResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TIntegerResult.CreateValue(config_setting_get_int(FOption));
end;

function TConfig.TOptionReader._GetInt64: TInt64Result;
begin
  if FOption = nil then
  begin
    Exit(TInt64Result.CreateError(ERROR_NULL_NODE));
  end;

  Result := TInt64Result.CreateValue(config_setting_get_int64(FOption));
end;

function TConfig.TOptionReader._GetFloat: TDoubleResult;
begin
  if FOption = nil then
  begin
    Exit(TDoubleResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TDoubleResult.CreateValue(config_setting_get_float(FOption));
end;

function TConfig.TOptionReader._GetBoolean: TBooleanResult;
begin
  if FOption = nil then
  begin
    Exit(TBooleanResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TBooleanResult.CreateValue(Boolean(config_setting_get_bool(
    FOption)));
end;

function TConfig.TOptionReader._GetString: TStringResult;
begin
  if FOption = nil then
  begin
    Exit(TStringResult.CreateError(ERROR_NULL_NODE));
  end;

  Result := TStringResult.CreateValue(String(Utf8ToString(
    config_setting_get_string(FOption))));
end;

function TConfig.TOptionReader._CreateSection(Name: String): TOptionWriter;
begin
  Result := TOptionWriter.Create(FOption)._CreateSection(ConvertString(Name));
end;

function TConfig.TOptionReader._CreateArray(Name : String): TCollectionWriter;
begin
  Result := TOptionWriter.Create(FOption)._CreateArray(ConvertString(Name));
end;

function TConfig.TOptionReader._CreateList(Name: String): TCollectionWriter;
begin
  Result := TOptionWriter.Create(FOption)._CreateList(ConvertString(Name));
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

function TConfig.ConvertString (AString : String) : PAnsiChar;
begin
  Result := PAnsiChar({$IFNDEF FPC}Utf8Encode{$ENDIF}(AString));
end;

function TConfig.LoadFromFile(Filename : String) : TVoidResult;
begin
  config_init(@FConfig);

  if config_read_file(@FConfig, ConvertString(Filename)) <> CONFIG_TRUE then
  begin
    Result := TVoidResult.CreateError(ERROR_READ_FILE);
    Exit;
  end;

  Result := TVoidResult.CreateValue;
  FRootElement := config_root_setting(@FConfig);
end;

function TConfig.Parse(ConfigString: String) : TVoidResult;
begin
  config_init(@FConfig);

  if config_read_string(@FConfig, ConvertString(ConfigString)) <> CONFIG_TRUE 
  then
  begin
    Result := TVoidResult.CreateError(ERROR_READ_STRING);
    Exit;
  end;

  Result := TVoidResult.CreateValue;
  FRootElement := config_root_setting(@FConfig);
end;

function TConfig.SaveToFile(Filename: String) : TVoidResult;
begin
  if config_write_file(@FConfig, ConvertString(Filename)) <> CONFIG_TRUE then
  begin
    Result := TVoidResult.CreateError(ERROR_WRITE_FILE);
    Exit;
  end;
  Result := TVoidResult.CreateValue;
end;

function TConfig._GetValue(Path: String): TOptionReader;
begin
  Result := TOptionReader.Create(FRootElement)._GetValue(ConvertString(Path));
end;

function TConfig._CreateSection(Name: String): TOptionWriter;
begin
  Result := TOptionWriter.Create(FRootElement)._CreateSection(ConvertString(
    Name));
end;

function TConfig._CreateArray(Name : String): TCollectionWriter;
begin
  Result := TOptionWriter.Create(FRootElement)._CreateArray(ConvertString(
    Name));
end;

function TConfig._CreateList(Name: String): TCollectionWriter;
begin
  Result := TOptionWriter.Create(FRootElement)._CreateList(ConvertString(Name));
end;

function TConfig.GetIncludeDir: string;
begin
  Result := config_get_include_dir(@FConfig);
end;

procedure TConfig.SetIncludeDir(Path: String);
begin
  config_set_include_dir(@FConfig, ConvertString(Path));
end;

end.

