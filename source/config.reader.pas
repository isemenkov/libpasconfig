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

unit collection.writter;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils, libpasconfig, utils.api.cstring 
  {$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  EValueNotExistsException = class(Exception);
  {$ENDIF}

  TOptionReader = class  
  public
    type
      {$IFDEF USE_OPTIONAL}
      TOptionalInteger = TOptional<Integer>;
      {$ENDIF}
  public
    constructor Create (AOption : pconfig_setting_t);
    destructor Destroy; override;

    function HasValue : Boolean;

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
  private
    FOption : pconfig_setting_t;
  end;

implementation



end.