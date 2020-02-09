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

  {$ENDIF}

  { TConfig }
  { Configuration file }
  TConfig = class
  public
    type
      { TConfigOption }
      { Reading configuration option value }
      TConfigOption = class
      private
        FOption : pconfig_setting_t;
      private
        function GetInteger : Integer; {$IFNDEF DEBUG}inline;{$ENDIF}
        function GetInt64 : Int64; {$IFNDEF DEBUG}inline;{$ENDIF}
        function GetFloat : Double; {$IFNDEF DEBUG}inline;{$ENDIF}
        function GetBoolean : Boolean; {$IFNDEF DEBUG}inline;{$ENDIF}
        function GetString : String; {$IFNDEF DEBUG}inline;{$ENDIF}
      public
        constructor Create (AOption : pconfig_setting_t);
        destructor Destroy; override;

        { Present option value as integer type }
        property AsInteger : Integer read GetInteger;

        { Present option value as int64 type }
        property AsInt64 : Int64 read GetInt64;

        { Present option value as double type }
        property AsFloat : Double read GetFloat;

        { Present option value as boolean type }
        property AsBoolean : Boolean read GetBoolean;

        { Present option value as string type }
        property AsString : String read GetString;
      end;

      { Configuration group values }

      { TSectionOption }

      TSectionOption = class
      private
        FOption : pconfig_setting_t;
      private
        procedure SetOptionInteger (Name : String; Value : Integer);
          {$IFNDEF DEBUG}inline;{$ENDIF}
        procedure SetOptionInt64 (Name : String; Value : Int64);{$IFNDEF DEBUG}
          inline;{$ENDIF}
        procedure SetOptionFloat (Name : String; Value : Double);{$IFNDEF DEBUG}
          inline;{$ENDIF}
        procedure SetOptionBoolean (Name : String; Value : Boolean);
          {$IFNDEF DEBUG}inline;{$ENDIF}
        procedure SetOptionString (Name : String; Value : String);
          {$IFNDEF DEBUG}inline;{$ENDIF}
      public
        constructor Create (AOption : pconfig_setting_t);
        destructor Destroy; override;

        { Create new option group section }
        function CreateSection (Name : String) : TSectionOption;{$IFNDEF DEBUG}
          inline;{$ENDIF}

        { Add new integer value to current group }
        property SetInteger [Name : String] : Integer write SetOptionInteger;

        { Add new int64 value to current group }
        property SetInt64   [Name : String] : Int64 write SetOptionInt64;

        { Add new double value to current group }
        property SetFloat   [Name : String] : Double write SetOptionFloat;

        { Add new boolean value to current group }
        property SetBoolean [Name : String] : Boolean write SetOptionBoolean;

        { Add new string value to current group }
        property SetString  [Name : String] : String write SetOptionString;
      end;
  private
    FConfig : config_t;
    FRootElement : pconfig_setting_t;
  private
    function GetValue (Path : String) : TConfigOption;{$IFNDEF DEBUG}inline;
      {$ENDIF}
    function CreateNewSection (Name : String) : TSectionOption;{$IFNDEF DEBUG}
      inline;{$ENDIF}
    function GetRoot : TSectionOption;{$IFNDEF DEBUG}inline;{$ENDIF}
  public
    constructor Create;
    constructor Create (AFilename : string);
    destructor Destroy; override;

    { Reread config file }
    procedure Reload;

    property Root : TSectionOption read GetRoot;
    property Value [Path : String] : TConfigOption read GetValue;
    property CreateSection [Name : String] : TSectionOption read
      CreateNewSection;
  end;

implementation

{ TConfig.TSectionOption }

procedure TConfig.TSectionOption.SetOptionInteger(Name: String; Value: Integer);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_INT);
  config_setting_set_int(setting, Value);
end;

procedure TConfig.TSectionOption.SetOptionInt64(Name: String; Value: Int64);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_INT64);
  config_setting_set_int64(setting, Value);
end;

procedure TConfig.TSectionOption.SetOptionFloat(Name: String; Value: Double);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_FLOAT);
  config_setting_set_float(setting, Value);
end;

procedure TConfig.TSectionOption.SetOptionBoolean(Name: String; Value: Boolean);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_BOOL);
  config_setting_set_bool(setting, Integer(Value));
end;

procedure TConfig.TSectionOption.SetOptionString(Name: String; Value: String);
var
  setting : pconfig_setting_t;
begin
  setting := config_setting_add(FOption, PChar(Name), CONFIG_TYPE_STRING);
  config_setting_set_string(setting, PChar(Value));
end;

constructor TConfig.TSectionOption.Create(AOption: pconfig_setting_t);
begin
  FOption := AOption;
end;

destructor TConfig.TSectionOption.Destroy;
begin
  inherited Destroy;
end;

function TConfig.TSectionOption.CreateSection(Name: String): TSectionOption;
begin
  Result := TSectionOption.Create(config_setting_add(FOption, PChar(Name),
    CONFIG_TYPE_GROUP));
end;

{ TConfig.TConfigOption }

function TConfig.TConfigOption.GetInteger: Integer;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_INT then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'integer');
  {$ENDIF}
  Result := config_setting_get_int(FOption);
end;

function TConfig.TConfigOption.GetInt64: Int64;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_INT64 then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'int64');
  {$ENDIF}
  Result := config_setting_get_int64(FOption);
end;

function TConfig.TConfigOption.GetFloat: Double;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_FLOAT then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'double');
  {$ENDIF}
  Result := config_setting_get_float(FOption);
end;

function TConfig.TConfigOption.GetBoolean: Boolean;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_BOOL then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'boolean');
  {$ENDIF}
  Result := Boolean(config_setting_get_bool(FOption));
end;

function TConfig.TConfigOption.GetString: String;
begin
  {$IFDEF USE_EXCEPTIONS}
  if config_setting_type(FOption) <> CONFIG_TYPE_STRING then
    raise ETypeMismatchException.Create('Option type cann''t present as '+
      'string');
  {$ENDIF}
  Result := config_setting_get_string(FOption);
end;

constructor TConfig.TConfigOption.Create(AOption: pconfig_setting_t);
begin
  FOption := AOption;
end;

destructor TConfig.TConfigOption.Destroy;
begin
  inherited Destroy;
end;

{ TConfig }

function TConfig.GetValue(Path: String): TConfigOption;
begin
  Result := TConfigOption.Create(config_lookup(@FConfig, PChar(Path)));
end;

function TConfig.CreateNewSection(Name: String): TSectionOption;
begin
  Result := TSectionOption.Create(config_setting_add(@FConfig, PChar(Name),
    CONFIG_TYPE_GROUP));
end;

function TConfig.GetRoot: TSectionOption;
begin
  Result := TSectionOption.Create(config_root_setting(@FConfig));
end;

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

procedure TConfig.Reload;
begin
  // TODO
end;

end.

