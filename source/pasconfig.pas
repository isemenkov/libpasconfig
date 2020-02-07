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
    FRootElement : pconfig_settings_t;
  public
    constructor Create;
    constructor Create (AFilename : string);
    destructor Destroy; override;

    property Group [Name : string] : String write SetGroupName;
    property Value [Name : string] : Integer read GetIntegerValue write
      SetIntegerValue;
    property Value [Name : string] : Float read GetFloatValue write
      SetFloatValue;
    property Value [Name : string] : String read GetStringValue write
      SetStringValue;
    property Value [Name : string] : Boolean read GetBoolValue write
      SetBoolValue;
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

end.

