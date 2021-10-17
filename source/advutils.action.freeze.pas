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

unit advutils.action.freeze;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses    
  SysUtils;

type
  { Action freeze strategy. }
  TFreezeStrategy = class
  type
    { Base class for  freeze strategies. }
    TStrategy = class
    public
      { Freeze action. }
      procedure Freeze; overload; virtual; abstract;

      { Unfreeze action. }
      procedure UnFreeze; overload; virtual; abstract;

      { Varranty unfreeze action. }
      procedure FreezeReset; overload; virtual; abstract;

      { Check if action is freeze. }
      function IsFreeze : Boolean; overload; virtual; abstract;
    end;

    { Action not freezed. Run every times. }
    TNone = class(TStrategy)
    public
      procedure Freeze; overload; override; {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure UnFreeze; overload; override; {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure FreezeReset; overload; override; 
        {$IFNDEF DEBUG}inline;{$ENDIF}
      function IsFreeze : Boolean; overload; override; 
        {$IFNDEF DEBUG}inline;{$ENDIF}
    end;

    { Action will freeze. Not runs while it is freeze. }
    TNormal = class(TStrategy)
    public
      constructor Create;
      procedure Freeze; overload; override; {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure UnFreeze; overload; override; {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure FreezeReset; overload; override; 
        {$IFNDEF DEBUG}inline;{$ENDIF}
      function IsFreeze : Boolean; overload; override; 
        {$IFNDEF DEBUG}inline;{$ENDIF}
    private
      FFreeze : Boolean;
    end;

    { Action will freeze many times. }
    TTimes = class(TStrategy)
    public
      constructor Create;
      procedure Freeze; overload; override; {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure UnFreeze; overload; override; {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure FreezeReset; overload; override; 
        {$IFNDEF DEBUG}inline;{$ENDIF}
      function IsFreeze : Boolean; overload; override; 
        {$IFNDEF DEBUG}inline;{$ENDIF}
    private
      FFreezeCount : Integer;
    end;
  end;

implementation

{ TFreezeStrategy.TNone }

procedure TFreezeStrategy.TNone.Freeze;
begin
  ;
end;

procedure TFreezeStrategy.TNone.UnFreeze;
begin
  ;
end;

procedure TFreezeStrategy.TNone.FreezeReset;
begin
  ;
end;

function TFreezeStrategy.TNone.IsFreeze : Boolean;
begin
  Result := False;
end;

{ TFreezeStrategy.TNormal }

constructor TFreezeStrategy.TNormal.Create;
begin
  FFreeze := False;
end;

procedure TFreezeStrategy.TNormal.Freeze;
begin
  FFreeze := True;
end;

procedure TFreezeStrategy.TNormal.UnFreeze;
begin
  FFreeze := False;
end;

procedure TFreezeStrategy.TNormal.FreezeReset;
begin
  FFreeze := False;
end;

function TFreezeStrategy.TNormal.IsFreeze : Boolean;
begin
  Result := FFreeze;
end;

{ TFreezeStrategy.TTimes }

constructor TFreezeStrategy.TTimes.Create;
begin
  FFreezeCount := 0;
end;

procedure TFreezeStrategy.TTimes.Freeze;
begin
  Inc(FFreezeCount);
end;

procedure TFreezeStrategy.TTimes.UnFreeze;
begin
  Dec(FFreezeCount);

  if FFreezeCount < 0 then
  begin
    FFreezeCount := 0;
  end;
end;

procedure TFreezeStrategy.TTimes.FreezeReset;
begin
  FFreezeCount := 0;
end;

function TFreezeStrategy.TTimes.IsFreeze : Boolean;
begin
  Result := FFreezeCount > 0;
end;

end.