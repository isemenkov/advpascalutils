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

unit testcase_actionmanager;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, advutils.action, utils.any
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TActionManagerTestCase = class(TTestCase)
  public
    type
      TTestAction = class(TAction)
      public
        constructor Create(ActionID : TActionID; ARunStrategy : 
          TRunStrategy.TStrategy; AFreezeStrategy : TFreezeStrategy.TStrategy);
      protected
        procedure RunAction ({%H-}AData : TAnyValue); override;
      private
        FRunsCount : Cardinal;
      public  
        property Runs : Cardinal read FRunsCount;
      end;
  public
    procedure Init;
    procedure TearDown; override;

    {$IFNDEF FPC}
    procedure AssertTrue (ACondition : Boolean);
    procedure AssertFalse (ACondition: Boolean);
    procedure AssertEquals (Expected, Actual : Integer); overload;
    procedure AssertEquals (Expected, Actual : String); overload;
    {$ENDIF}

    procedure ActionNotify(AData : TAnyValue; AdditionalData : TAnyValue);
  published
    procedure RunNonExistsAction_ReturnFalse;
    
    procedure RegisterAction_ReturnTrue;
    procedure RunAction_Normal_ReturnTrue;
    procedure RegisterAndRunAction_Normal_ReturnTrue;
    procedure RunActionMultiple_Normal_ReturnTrue;
    procedure RunAction_Normal_Freeze_ReturnFalse;
    procedure RunAction_Normal_UnFreeze_ReturnTrue;
    procedure RunAction_Normal_FreezeReset_ReturnTrue;
    procedure RunAction_Normal_IsFreeze_ReturnTrue;
    procedure RunAction_Normal_SubscribeRun_ReturnTrue;

    procedure RunAction_Once_ReturnTrue;
    procedure RunAction_Once_SubscribeDelete_ReturnTrue;

    procedure RunAction_Times_ReturnTrue;

    procedure RunAction_Normal_FreezeNone_ReturnTrue;

    procedure RunAction_Normal_FreezeTimes_ReturnTrue;
  private
    FActionManager : TActionManager;
    FSubscribeValue : TAnyValue;
    FSuscribeAdditionalValue : TAnyValue;
  end;

implementation

{$IFNDEF FPC}
procedure TActionManagerTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TActionManagerTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TActionManagerTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;

procedure TActionManagerTestCase.AssertEquals(Expected, Actual : String);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TActionManagerTestCase.ActionNotify(AData : TAnyValue; 
  AdditionalData : TAnyValue);
begin
  FSubscribeValue := AData;
  FSuscribeAdditionalValue := AdditionalData;
end;

procedure TActionManagerTestCase.Init;
begin
  FActionManager := TActionManager.Create;
  FSubscribeValue := NoneValue;
  FSuscribeAdditionalValue := NoneValue;
end;

procedure TActionManagerTestCase.TearDown;
begin
  FreeAndNil(FActionManager);
end;

constructor TActionManagerTestCase.TTestAction.Create(ActionID : 
  TActionID; ARunStrategy : TRunStrategy.TStrategy; AFreezeStrategy : 
  TFreezeStrategy.TStrategy);
begin
  inherited Create(ActionID, ARunStrategy, AFreezeStrategy);
  FRunsCount := 0;
end;

procedure TActionManagerTestCase.TTestAction.RunAction (AData : TAnyValue);
begin
  Inc(FRunsCount);
end;

procedure TActionManagerTestCase.RunNonExistsAction_ReturnFalse;
begin
  Init;
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertFalse(False);
end;

procedure TActionManagerTestCase.RegisterAction_ReturnTrue;
begin
  Init;
  FActionManager.Register(TTestAction.Create(0, 
    TRunStrategy.TNormal.Create,
    TFreezeStrategy.TNormal.Create));

  AssertTrue(True);
end;

procedure TActionManagerTestCase.RunAction_Normal_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0, 
    TRunStrategy.TNormal.Create,
    TFreezeStrategy.TNormal.Create);
  
  FActionManager.Register(Action);

  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 1);
end;

procedure TActionManagerTestCase.RegisterAndRunAction_Normal_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0, 
    TRunStrategy.TNormal.Create, TFreezeStrategy.TNormal.Create);
  FActionManager.Run(Action, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 1);
end;

procedure TActionManagerTestCase.RunActionMultiple_Normal_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0, 
    TRunStrategy.TNormal.Create, TFreezeStrategy.TNormal.Create);
  
  FActionManager.Register(Action);

  FActionManager.Run(0, TIntegerValue.Create(0));
  FActionManager.Run(0, TIntegerValue.Create(1));
  FActionManager.Run(0, TIntegerValue.Create(2));

  AssertEquals(Action.Runs, 3);
end;

procedure TActionManagerTestCase.RunAction_Normal_Freeze_ReturnFalse;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0, TRunStrategy.TNormal.Create,
    TFreezeStrategy.TNormal.Create);
  
  FActionManager.Register(Action);

  FActionManager.Freeze(0);
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 0);
end;

procedure TActionManagerTestCase.RunAction_Normal_UnFreeze_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0, TRunStrategy.TNormal.Create,
    TFreezeStrategy.TNormal.Create);
  
  FActionManager.Register(Action);

  FActionManager.Freeze(0);
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 0);

  FActionManager.UnFreeze(0);
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 1);
end;

procedure TActionManagerTestCase.RunAction_Normal_FreezeReset_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0, TRunStrategy.TNormal.Create,
    TFreezeStrategy.TNormal.Create);

  FActionManager.Register(Action);

  FActionManager.Freeze(0);
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 0);

  FActionManager.FreezeReset(0);
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 1);
end;

procedure TActionManagerTestCase.RunAction_Normal_IsFreeze_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0, TRunStrategy.TNormal.Create,
    TFreezeStrategy.TNormal.Create);
  
  FActionManager.Register(Action);
  FActionManager.Freeze(0);

  AssertTrue(FActionManager.IsFreeze(0));
end;

procedure TActionManagerTestCase.RunAction_Normal_SubscribeRun_ReturnTrue;
begin
  Init;
  FActionManager.Register(TTestAction.Create(0,
    TRunStrategy.TNormal.Create, TFreezeStrategy.TNormal.Create));

  FActionManager.Subscribe(0, ACTION_RUN, {$IFDEF FPC}@{$ENDIF}ActionNotify,
    TStringValue.Create('ACTION_RUN'));

  FActionManager.Run(0, TIntegerValue.Create(7));

  AssertEquals(TIntegerValue(FSubscribeValue).Value, 7);
  AssertEquals(TStringValue(FSuscribeAdditionalValue).Value, 'ACTION_RUN');
end;

procedure TActionManagerTestCase.RunAction_Once_ReturnTrue;
var 
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0,
    TRunStrategy.TOnce.Create, TFreezeStrategy.TNormal.Create);
  
  FActionManager.Register(Action);
  
  FActionManager.Run(0, TIntegerValue.Create(0));
  FActionManager.Run(0, TIntegerValue.Create(-2));
  
  AssertEquals(Action.Runs, 1);
end;

procedure TActionManagerTestCase.RunAction_Once_SubscribeDelete_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0,
    TRunStrategy.TOnce.Create, TFreezeStrategy.TNormal.Create);
  
  FActionManager.Register(Action);
  
  FActionManager.Subscribe(0, ACTION_RUN, {$IFDEF FPC}@{$ENDIF}ActionNotify,
    TStringValue.Create('ACTION_RUN'));
  FActionManager.Subscribe(0, ACTION_DELETE, {$IFDEF FPC}@{$ENDIF}ActionNotify,
    TStringValue.Create('ACTION_DELETE'));
  FActionManager.Run(0, TIntegerValue.Create(11));
  FActionManager.Run(0, TIntegerValue.Create(-4));

  AssertEquals(Action.Runs, 1);
  AssertEquals(TIntegerValue(FSubscribeValue).Value, 11);
  AssertEquals(TStringValue(FSuscribeAdditionalValue).Value, 'ACTION_DELETE');
end;

procedure TActionManagerTestCase.RunAction_Times_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0,
    TRunStrategy.TTimes.Create(2), TFreezeStrategy.TNormal.Create);
  
  FActionManager.Register(Action);
  FActionManager.Subscribe(0, ACTION_RUN, {$IFDEF FPC}@{$ENDIF}ActionNotify);

  FActionManager.Run(0, TIntegerValue.Create(0));
  FActionManager.Run(0, TIntegerValue.Create(-1));
  FActionManager.Run(0, TIntegerValue.Create(-2));

  AssertEquals(TIntegerValue(FSubscribeValue).Value, -1);
  AssertEquals(Action.Runs, 2);
end;

procedure TActionManagerTestCase.RunAction_Normal_FreezeNone_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0,
    TRunStrategy.TNormal.Create, TFreezeStrategy.TNone.Create);
  
  FActionManager.Register(Action);
  FActionManager.Freeze(0);
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 1);
end;

procedure TActionManagerTestCase.RunAction_Normal_FreezeTimes_ReturnTrue;
var
  Action : TTestAction;
begin
  Init;
  Action := TTestAction.Create(0,
    TRunStrategy.TNormal.Create, TFreezeStrategy.TTimes.Create);
  FActionManager.Register(Action);
  FActionManager.Freeze(0);
  FActionManager.Freeze(0);
  FActionManager.UnFreeze(0);
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 0);

  FActionManager.UnFreeze(0);
  FActionManager.Run(0, TIntegerValue.Create(0));

  AssertEquals(Action.Runs, 1);
end;

initialization
  RegisterTest(
    'TActionManager',
    TActionManagerTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.

