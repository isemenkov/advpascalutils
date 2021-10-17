(******************************************************************************)
(*                               AdvPascalUtils                               *)
(*          delphi and object pascal library of utils data structures         *)
(*                                                                            *)
(* Copyright (c) 2021                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/advpascalutils              ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* Permission is hereby  granted, free of  charge, to any  person obtaining a *)
(* copy of this software and associated documentation files (the "Software"), *)
(* to deal in the Software without  restriction, including without limitation *)
(* the rights  to use, copy,  modify, merge, publish, distribute, sublicense, *)
(* and/or  sell copies of  the Software,  and to permit  persons to  whom the *)
(* Software  is  furnished  to  do so, subject  to the following  conditions: *)
(*                                                                            *)
(* The above copyright notice and this permission notice shall be included in *)
(* all copies or substantial portions of the Software.                        *)
(*                                                                            *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *)
(* IMPLIED, INCLUDING BUT NOT  LIMITED TO THE WARRANTIES  OF MERCHANTABILITY, *)
(* FITNESS FOR A  PARTICULAR PURPOSE AND  NONINFRINGEMENT. IN NO  EVENT SHALL *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *)
(* LIABILITY,  WHETHER IN AN ACTION OF  CONTRACT, TORT OR  OTHERWISE, ARISING *)
(* FROM,  OUT OF OR  IN  CONNECTION WITH THE  SOFTWARE OR  THE  USE  OR OTHER *)
(* DEALINGS IN THE SOFTWARE.                                                  *)
(*                                                                            *)
(******************************************************************************)

unit advutils.action;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses    
  SysUtils, advutils.action.state, advutils.action.run, advutils.action.freeze,
  utils.any;

type
  { Action empty additional data. }
  TActionEmptyData = {$IFDEF FPC}specialize{$ENDIF} TAny<Pointer>;

  { Action ID. }
  TActionID = type Integer;

  TAction = class
  public
    constructor Create (ActionID : TActionID; ARunStrategy : TRunStrategy;
      AFreezeStrategy : TFreezeStrategy; AData : TAnyValue);
    
    { Run action. }
    function Run : TActionState; {$IFNDEF DEBUG}inline;{$ENDIF}

    { Freeze action. }
    procedure Freeze; {$IFNDEF DEBUG}inline;{$ENDIF}

    { Unfreeze action. }
    procedure UnFreeze; {$IFNDEF DEBUG}inline;{$ENDIF}

    { Reset action freeze counter. }
    procedure FreezeReset; {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    FActionID : TActionID;
    FRunStrategy : TRunStrategy;
    FFreezeStrategy : TFreezeStrategy;
    FActionData : TAnyValue;
  public
    { Get action ID. }
    property ID : TActionID read FActionId;

    { Get action data. }
    property Data : TAnyValue read FActionData;
  end;

implementation

{ TAction }

constructor TAction.Create(ActionID : TActionID; ARunStrategy : TRunStrategy;
  AFreezeStrategy : TFreezeStrategy; AData : TAnyValue);
begin
  FActionID := ActionID;
  FRunStrategy := ARunStrategy;
  FFreezeStrategy := AFreezeStrategy;
  FActionData := AData;
end;

function TAction.Run : TActionState;
begin
  if not FFreezeStrategy.IsFreeze then
  begin
    Result := FRunStrategy.After;
  end else
  begin
    Result := ACTION_FREEZE;
  end;
end;

procedure TAction.Freeze;
begin
  FFreezeStrategy.Freeze;
end;

procedure TAction.UnFreeze;
begin
  FFreezeStrategy.UnFreeze;
end;

procedure TAction.FreezeReset;
begin
  FFreezeStrategy.FreezeReset;
end;

end.