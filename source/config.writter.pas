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
  Classes, SysUtils, libpasconfig, utils.api.cstring, config.datatype;

type
  { TCollectionWriter }
  TCollectionWriter = class
  protected
    FOption : pconfig_setting_t;

  public
    constructor Create (AOption : pconfig_setting_t);
    destructor Destroy; override;

    

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

implementation

{ TCollectionWriter }

constructor TCollectionWriter.Create (AOption : pconfig_setting_t);
begin
  FOption := AOption;
end;

destructor TCollectionWriter.Destroy;
begin
  inherited Destroy;
end;



end.