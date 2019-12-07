(******************************************************************************)
(*                                libPasConfig                                *)
(*              object pascal wrapper around libconfig library                *)
(*                  https://github.com/hyperrealm/libconfig                   *)
(*                                                                            *)
(* Copyright (c) 2019                                       Ivan Semenkov     *)
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

unit libpasconfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

{$IFDEF FPC}
  {$PACKRECORDS C}
{$ENDIF}

{$IFDEF WINDOWS}
  const libConfig = 'libconfig.dll';
{$ENDIF}
{$IFDEF LINUX}
  const libConfig = 'libconfig.so';
{$ENDIF}

{$IFNDEF LIBCONFIG_VER_MAJOR}
  {$DEFINE LIBCONFIG_VER_MAJOR 1}
{$ENDIF}
{$IFNDEF LIBCONFIG_VER_MINOR}
  {$DEFINE LIBCONFIG_VER_MINOR 5}
{$ENDIF}
{$IFNDEF LIBCONFIG_VER_REVISION}
  {$DEFINE LIBCONFIG_VER_REVISION 0}
{$ENDIF}

const
  CONFIG_TYPE_NONE                                                      = 0;
  CONFIG_TYPE_GROUP                                                     = 1;
  CONFIG_TYPE_INT                                                       = 2;
  CONFIG_TYPE_INT64                                                     = 3;
  CONFIG_TYPE_FLOAT                                                     = 4;
  CONFIG_TYPE_STRING                                                    = 5;
  CONFIG_TYPE_BOOL                                                      = 6;
  CONFIG_TYPE_ARRAY                                                     = 7;
  CONFIG_TYPE_LIST                                                      = 8;

  CONFIG_FORMAT_DEFAULT                                                 = 0;
  CONFIG_FORMAT_HEX                                                     = 1;

  CONFIG_OPTION_AUTOCONVERT                                             = $0001;
  CONFIG_OPTION_SEMICOLON_SEPARATORS                                    = $0002;
  CONFIG_OPTION_COLON_ASSIGNMENT_FOR_GROUPS                             = $0004;
  CONFIG_OPTION_COLON_ASSIGNMENT_FOR_NON_GROUPS                         = $0008;
  CONFIG_OPTION_OPEN_BRACE_ON_SEPARATE_LINE                             = $0010;
  {$IFDEF LIBCONFIG_VER_MAJOR    >= 1 AND
          LIBCONFIG_VER_MINOR    >= 7 AND
          LIBCONFIG_VER_REVISION >= 0}
  CONFIG_OPTION_ALLOW_SCIENTIFIC_NOTATION                               = $0020;
  CONFIG_OPTION_FSYNC                                                   = $0040;
  {$ENDIF}

type
  pconfig_error_t = ^config_error_t;
  config_error_t = (
    CONFIG_ERR_NONE                                                     = 0,
    CONFIG_ERR_FILE_IO                                                  = 1,
    CONFIG_ERR_PARSE                                                    = 2
  );

  pconfig_list_t = ^config_list_t;

  pconfig_value_t = ^config_value_t;
  config_value_t = record
    case byte of
    1 : (ival : Integer);
    2 : (llval : Int64);
    3 : (fval : Double);
    4 : (sval : PChar);
    5 : (list : pconfig_list_t);
  end;

  pconfig_t = ^config_t;

  ppconfig_settings_t = ^pconfig_settings_t;
  pconfig_settings_t = ^config_settings_t;
  config_settings_t = record
    name : PChar;
    settings_type : Smallint;
    format : Smallint;
    value : config_value_t;
    parent : pconfig_settings_t;
    config : pconfig_t;
    hook : Pointer;
    line : Cardinal;
    file_name : PChar;
  end;

  config_list_t = record
    length : Cardinal;
    elements : ppconfig_settings_t;
  end;

  PPChar = ^PChar;

  destructor_fn_t = procedure (obj : Pointer) of object;
  {$IFDEF LIBCONFIG_VER_MAJOR    >= 1 AND
          LIBCONFIG_VER_MINOR    >= 7 AND
          LIBCONFIG_VER_REVISION >= 0}
  config_include_fn_t = function (config : pconfig_t; const include_dir : PChar;
    const path : PChar; const error : PPChar) : PPChar of object;
  {$ENDIF}

  config_t = record
    root : pconfig_settings_t;
    destructor_callback : destructor_fn_t;
    options : Integer;
    tab_width : Word;
    {$IFDEF LIBCONFIG_VER_MAJOR    <= 1 AND
            LIBCONFIG_VER_MINOR    <= 5 AND
            LIBCONFIG_VER_REVISION <= 0}
    default_format : Smallint;
    {$ENDIF}
    {$IFDEF LIBCONFIG_VER_MAJOR    >= 1 AND
            LIBCONFIG_VER_MINOR    >= 7 AND
            LIBCONFIG_VER_REVISION >= 0}
    float_precision : Word;
    default_format : Word;
    {$ENDIF}
    include_dir : PChar;
    {$IFDEF LIBCONFIG_VER_MAJOR    >= 1 AND
            LIBCONFIG_VER_MINOR    >= 7 AND
            LIBCONFIG_VER_REVISION >= 0}
    include_fn : config_include_fn_t;
    {$ENDIF}
    error_text : PChar;
    error_file : PChar;
    eror_line : Integer;
    error_type : config_error_t;
    filenames : PPChar;
    num_filenames : Cardinal;
    {$IFDEF LIBCONFIG_VER_MAJOR    >= 1 AND
            LIBCONFIG_VER_MINOR    >= 7 AND
            LIBCONFIG_VER_REVISION >= 0}
    hook : Pointer;
    {$ENDIF}
  end;

{ Initializes the config_t structure pointed to by config as a new, empty
  configuration. }
procedure config_init (config : pconfig_t); cdecl; external libConfig;

{ Destroys the configuration config, deallocating all memory associated with the
  configuration, but does not attempt to deallocate the config_t structure
  itself. }
procedure config_destroy (config : pconfig_t); cdecl; external libConfig;

{$IFDEF LIBCONFIG_VER_MAJOR    >= 1 AND
        LIBCONFIG_VER_MINOR    >= 7 AND
        LIBCONFIG_VER_REVISION >= 0}
{ This function clears the configuration config. All child settings of the root
  setting are recursively destroyed. All other attributes of the configuration
  are left unchanged. }
procedure config_clear (config : pconfig_t); cdecl; external libConfig;
{$ENDIF}

//function config_read (config : pconfig_t;

implementation

end.

