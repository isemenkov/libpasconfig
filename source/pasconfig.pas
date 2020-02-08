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

interface

uses
  Classes, SysUtils, libpasconfig;

type

  { TConfig }

  TConfig = class
  private
    FConfig : config_t;
    FRootElement : pconfig_setting_t;
  public
    constructor Create;
    constructor Create (AFilename : string);
    destructor Destroy; override;

    function GetInt (Path : String) : Integer;
    function GetInt64 (Path : String) : Int64;
    function GetFloat (Path : String) : Double;
    function GetBool (Path : String) : Boolean;
    function GetString (Path : String) : String;
  end;

implementation

{ TConfig }

constructor TConfig.Create;
begin
  config_init(@FConfig);
end;

constructor TConfig.Create(AFilename: string);
begin
  config_init(@FConfig);
  config_read_file(@FConfig, PChar(AFilename));
end;

destructor TConfig.Destroy;
begin
  config_destroy(@FConfig);
  inherited Destroy;
end;

function TConfig.GetInt(Path: String): Integer;
begin
  config_lookup_int(@FConfig, PChar(Path), @Result);
end;

function TConfig.GetInt64(Path: String): Int64;
begin
  config_lookup_int64(@FConfig, PChar(Path), @Result);
end;

function TConfig.GetFloat(Path: String): Double;
begin
  config_lookup_float(@FConfig, PChar(Path), @Result);
end;

function TConfig.GetBool(Path: String): Boolean;
begin
  config_lookup_bool(@FConfig, PChar(Path), @Result);
end;

function TConfig.GetString(Path: String): String;
begin
  config_lookup_string(@FConfig, PChar(Path), PPChar((PChar(Result))));
end;

end.

