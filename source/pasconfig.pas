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
  public
    type
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

        property AsInteger : Integer read GetInteger;
        property AsInt64 : Int64 read GetInt64;
        property AsFloat : Double read GetFloat;
        property AsBoolean : Boolean read GetBoolean;
        property AsString : String read GetString;
      end;

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

        property SetInteger [Name : String] : Integer write SetOptionInteger;
        property SetInt64 [Name : String] : Int64 write SetOptionInt64;
        property SetFloat [Name : String] : Double write SetOptionFloat;
        property SetBoolean [Name : String] : Boolean write SetOptionBoolean;
        property SetString [Name : String] : String write SetOptionString;
      end;
  private
    FConfig : config_t;
    FRootElement : pconfig_setting_t;
  private
    function GetValue (Path : String) : TConfigOption;{$IFNDEF DEBUG}inline;
      {$ENDIF}
    function CreateNewSection (Name : String) : TSectionOption; {$IFNDEF DEBUG}
      inline;{$ENDIF}
  public
    constructor Create;
    constructor Create (AFilename : string);
    constructor Create (AData : String);
    destructor Destroy; override;

    procedure Reload;

    property Value [Path : String] : TConfigOption read GetValue;
    property CreateSection [Name : String] : TSectionOption read
      CreateNewSection;
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

