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

unit testcase_eventmanager;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, advutils.event, utils.any
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TEventManagerTestCase = class(TTestCase)
  public
    procedure Init;
    procedure TearDown; override;

    {$IFNDEF FPC}
    procedure AssertTrue (ACondition : Boolean);
    procedure AssertFalse (ACondition: Boolean);
    procedure AssertEquals (Expected, Actual : Integer); overload;
    procedure AssertEquals (Expected, Actual : String); overload;
    {$ENDIF}

    procedure ActionNotify(AData : TAnyValue);
  published
    procedure RunNonExistsEvent_ReturnFalse;

    procedure RunEvent_ReturnTrue;
  private
    FEventManager : TEventManager;
    FSubscribeValue : TAnyValue;
  end;

implementation

{$IFNDEF FPC}
procedure TEventManagerTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TEventManagerTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TEventManagerTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;

procedure TEventManagerTestCase.AssertEquals(Expected, Actual : String);
begin
  CheckEquals(Expected, Actual);
end;

procedure TEventManagerTestCase.AssertEquals(Expected, Actual : String);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TEventManagerTestCase.ActionNotify(AData : TAnyValue);
begin
  FSubscribeValue := AData;
end;

procedure TEventManagerTestCase.Init;
begin
  FEventManager := TEventManager.Create;
  FSubscribeValue := NoneValue;
end;

procedure TEventManagerTestCase.TearDown;
begin
  FreeAndNil(FEventManager);
end;

procedure TEventManagerTestCase.RunNonExistsEvent_ReturnFalse;
begin
  Init;
  FEventManager.Run(0, TIntegerValue.Create(0));

  AssertFalse(False);
end;

procedure TEventManagerTestCase.RunEvent_ReturnTrue;
begin
  Init;
  FEventManager.Subscribe(0, {$IFDEF FPC}@{$ENDIF}ActionNotify);
  FEventManager.Run(0, TStringValue.Create('Its works!'));

  AssertEquals(TStringValue(FSubscribeValue).Value, 'Its works!');
end;

initialization
  RegisterTest(
    'TEventManager',
    TEventManagerTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.