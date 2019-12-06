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

type




implementation

end.

