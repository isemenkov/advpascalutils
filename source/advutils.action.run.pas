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

unit advutils.action.run;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses    
  SysUtils, advutils.action.state;

type
  { Action run strategy. }
  TRunStrategy = class
  type
    { Base class for run strategies. }
    TStrategy = class
    public
      { Run after action and return actual action state. }
        function After: TActionState; overload; virtual; abstract;
    end;

    { Do nothing after action run. }
    TNormal = class(TStrategy)
    public
      function After: TActionState; override; {$IFNDEF DEBUG}inline;{$ENDIF}
    end;

    { Action deleted after run. }
    TOnce = class(TStrategy)
    public
      function After: TActionState; override; {$IFNDEF DEBUG}inline;{$ENDIF}
    end;

    { Action run ATimes times and after will deleted. }
    TTimes = class(TStrategy)
    public
      constructor Create (ATimes: Cardinal);
      function After: TActionState; override; {$IFNDEF DEBUG}inline;{$ENDIF}
    private
      FRunsCount: Cardinal;
      FTimes: Cardinal;
    end;
  end;

implementation

{ TRunStrategy.TNormal }

function TRunStrategy.TNormal.After : TActionState;
begin
  Result := ACTION_RUN;
end;

{ TRunStrategy.TOnce }

function TRunStrategy.TOnce.After : TActionState;
begin
  Result := ACTION_DELETE;
end;

{ TRunStrategy.TTimes }

constructor TRunStrategy.TTimes.Create(ATimes : Cardinal);
begin
  FTimes := ATimes;
  FRunsCount := 0;
end;

function TRunStrategy.TTimes.After : TActionState;
begin
  Inc(FRunsCount);

  if FRunsCount >= FTimes then
  begin
    Exit(ACTION_DELETE);
  end;

  Result := ACTION_RUN;
end;

end.