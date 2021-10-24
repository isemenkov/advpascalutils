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
  SysUtils, utils.any, container.hashtable, container.multihash, utils.functor;

type
  TActionState = (
    ACTION_RUN,
    ACTION_FREEZE,
    ACTION_UNFREEZE,
    ACTION_DELETE,
    ACTION_ANY
  );

  { Action run strategies. }
  TRunStrategy = class
  type
    { Base run strategy class. }
    TStrategy = class
    public
      function After : TActionState; virtual; abstract;
    end;

    { Runs normal. }
    TNormal = class(TStrategy)
    public
      function After : TActionState; override;
    end;

    { Runs only one times. }
    TOnce = class(TStrategy)
    public
      function After : TActionState; override;
    end;

    { Runs a specific number of times. }
    TTimes = class(TStrategy)
    public
      constructor Create(ATimes : Cardinal);
      function After : TActionState; override;
    protected
      FTimes : Cardinal;
      FRunsCount : Cardinal;
    end;
  end;

  { Action freeze strategies. }
  TFreezeStrategy = class
  type
    { Base freeze strategy class. }
    TStrategy = class
      { Freeze action. }
      procedure Freeze; virtual; abstract;

      { Unfreeze action. }
      procedure UnFreeze; virtual; abstract;

      { Reset freeze counter. }
      procedure FreezeReset; virtual; abstract;

      { Check if action is freeze. }
      function IsFreeze : Boolean; virtual; abstract;
    end;

    { Action cann't freeze. }
    TNone = class(TStrategy)
    public
      procedure Freeze; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure UnFreeze; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure FreezeReset; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      function IsFreeze : Boolean; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
    end;

    { Action can be freeze and unfreeze regular. }
    TNormal = class(TStrategy)
    public
      constructor Create;
      procedure Freeze; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure UnFreeze; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure FreezeReset; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      function IsFreeze : Boolean; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
    protected
      FFreeze : Boolean;
    end;

    TTimes = class(TStrategy)
    public
      constructor Create;
      procedure Freeze; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure UnFreeze; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      procedure FreezeReset; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
      function IsFreeze : Boolean; override;
        {$IFNDEF DEBUG}inline;{$ENDIF}
    protected
      FFreezeCount : Integer;
    end;
  end;

  { Action unique ID type. }
  TActionID = type Cardinal;

  { Action base class. }
  TAction = class
  public
    constructor Create(ActionID : TActionID; ARunStrategy : 
      TRunStrategy.TStrategy; AFreezeStrategy : TFreezeStrategy.TStrategy);
    destructor Destroy; override;

    { Run action. }
    function Run : TActionState;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Freeze action. }
    procedure Freeze;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Unfreeze action. }
    procedure UnFreeze;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Action varranty unfreeze. }
    procedure FreezeReset;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Check if action is freeze. }
    function IsFreeze : Boolean;
  protected
    { Do something. }
    procedure RunAction; virtual; abstract;
  protected
    FActionID : TActionID;
    FRunStrategy : TRunStrategy.TStrategy;
    FFreezeStrategy : TFreezeStrategy.TStrategy;
  public
    property ID : TActionID read FActionID;
  end;

  { Action manager. }
  TActionManager = class
  public
    type
      { Action subscribe callback. }
      TActionCallback = procedure (AData : TAnyValue; AdditionalData : 
        TAnyValue) of object;
  public
    constructor Create;
    destructor Destroy; override;

    { Register action. }
    procedure Register(Action : TAction);
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Run action. }
    function Run(ActionID : TActionID; AData : TAnyValue = nil) : Boolean; 
      overload;

    { Register action and run it. }
    function Run(Action : TAction; AData : TAnyValue = nil) : Boolean; overload;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Freeze action. }
    procedure Freeze(ActionID : TActionID);
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Unfreeze action. }
    procedure UnFreeze(ActionID : TActionID);
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Action varranty unfreeze. }
    procedure FreezeReset(ActionID : TActionID);
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Check if action is freeze. }
    function IsFreeze(ActionID : TActionID) : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Subscribe for action state. }
    procedure Subscribe(ActionID : TActionID; AState : TActionState; ACallback :
      TActionCallback; AdditionalData : TAnyValue = nil);
  protected
    type
      TActionIDCompareFunctor = class
        ({$IFDEF FPC}specialize{$ENDIF} TBinaryFunctor<TActionID, Integer>)
      public
        function Call(AValue1, AValue2 : TActionID) : Integer; override;
      end;
      
      TActionsContainer = {$IFDEF FPC}specialize{$ENDIF} THashTable<TActionID, 
        TAction, TActionIDCompareFunctor>;
      
      TSubscribeItem = record
        State : TActionState;
        AdditionalData : TAnyValue;
        Callback : TActionCallback;
      end;
      
      TSubscribeItemUnsortableFunctor = class
        ({$IFDEF FPC}specialize{$ENDIF} TUnsortableFunctor<TSubscribeItem>);
      TSubscribersContainer = {$IFDEF FPC}specialize{$ENDIF} 
        TMultiHash<TActionID, TSubscribeItem, TActionIDCompareFunctor, 
        {$IFDEF FPC}specialize{$ENDIF} TUnsortableFunctor<TSubscribeItem> >;
  protected
    { Search action. }
    function SearchAction(ActionID : TActionID) : TAction;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    procedure NotifySubscribers(ActionID : TActionID; AState : TActionState; 
      AData : TAnyValue);
  protected
    FActions : TActionsContainer;
    FSubscribers : TSubscribersContainer;
  end;

  { Generate a hash key for TActionID value. }
  function HashActionID(ActionID : TActionID) : Cardinal;

implementation

function HashActionID(ActionID : TActionID) : Cardinal;
begin
  Result := HashInteger(Cardinal(ActionID));
end;

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
  FRunsCount := 1;
end;

function TRunStrategy.TTimes.After : TActionState;
begin
  Inc(FRunsCount);

  if FRunsCount > FTimes then
  begin
    Result := ACTION_DELETE;
    Exit;
  end;

  Result := ACTION_RUN;
end;

{ TFreezeStrategy.TNone }

procedure TFreezeStrategy.TNone.Freeze;
begin
end;

procedure TFreezeStrategy.TNone.UnFreeze;
begin
end;

procedure TFreezeStrategy.TNone.FreezeReset;
begin
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
  Result := FFreezeCount <> 0;
end;

{ TAction }

constructor TAction.Create(ActionID : TActionID; ARunStrategy : 
  TRunStrategy.TStrategy; AFreezeStrategy : TFreezeStrategy.TStrategy);
begin
  FActionID := ActionID;
  FRunStrategy := ARunStrategy;
  FFreezeStrategy := AFreezeStrategy;
end;

destructor TAction.Destroy;
begin
  FreeAndNil(FRunStrategy);
  FreeAndNil(FFreezeStrategy);
  inherited Destroy;
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

function TAction.IsFreeze : Boolean;
begin
  Result := FFreezeStrategy.IsFreeze;
end;

function TAction.Run : TActionState;
begin
  if not FFreezeStrategy.IsFreeze then
  begin
    RunAction;
    Result := FRunStrategy.After;
    Exit;
  end;

  Result := ACTION_RUN;
end;

{ TActionManager }

function TActionManager.TActionIDCompareFunctor.Call(AValue1, AValue2 : 
  TActionID) : Integer;
begin
  if AValue1 < AValue2 then
    Result := -1
  else if AValue2 < AValue1 then
    Result := 1
  else
    Result := 0;
end;

constructor TActionManager.Create;
begin
  FActions := TActionsContainer.Create(@HashActionID);
  FSubscribers := TSubscribersContainer.Create(@HashActionID);
end;

destructor TActionManager.Destroy;
begin
  FreeAndNil(FActions);
  FreeAndNil(FSubscribers);
  inherited Destroy;
end;

function TActionManager.SearchAction(ActionID : TActionID) : TAction;
begin
  try
    Result := FActions.Search(ActionID);
  except on e : EKeyNotExistsException do
    begin
      Result := nil;
    end;
  end;
end;

procedure TActionManager.Register(Action : TAction);
begin
  FActions.Insert(Action.ID, Action);
end;

function TActionManager.Run(ActionID : TActionID; AData : TAnyValue) : Boolean;
var
  Action : TAction;
  State : TActionState;
begin
  Action := SearchAction(ActionID);

  if (Action <> nil) and (not Action.IsFreeze) then
  begin
    State := Action.Run;

    case State of
      ACTION_RUN : 
        begin
          NotifySubscribers(ActionID, ACTION_RUN, AData);
          Result := True;
          Exit;
        end;
      ACTION_DELETE :
        begin
          NotifySubscribers(ActionID, ACTION_RUN, AData);
          FActions.Remove(ActionID);
          NotifySubscribers(ActionID, ACTION_DELETE, AData);
          Result := True;
          Exit;
        end;
      ACTION_FREEZE,
      ACTION_UNFREEZE,
      ACTION_ANY :
        begin
          raise Exception.Create('Impossible action state.');
        end;
    end;
  end;

  Result := False;
end;

function TActionManager.Run(Action: TAction; AData : TAnyValue) : Boolean;
begin
  Register(Action);
  Result := Run(Action.ID, AData);
end;

procedure TActionManager.Freeze(ActionID : TActionID);
var
  Action : TAction;
begin
  Action := SearchAction(ActionID);

  if Action <> nil then
  begin
    Action.Freeze;
  end;
end;

procedure TActionManager.UnFreeze(ActionID : TActionID);
var
  Action : TAction;
begin
  Action := SearchAction(ActionID);
  
  if Action <> nil then
  begin
    Action.UnFreeze;
  end;
end;

procedure TActionManager.FreezeReset(ActionID : TActionID);
var
  Action : TAction;
begin
  Action := SearchAction(ActionID);

  if Action <> nil then
  begin
    Action.FreezeReset;
  end;
end;

function TActionManager.IsFreeze(ActionID : TActionID) : Boolean;
var 
  Action : TAction;
begin
  Action := SearchAction(ActionID);

  if Action <> nil then
  begin
    Result := Action.IsFreeze;
    Exit;
  end;

  Result := False;
end;

procedure TActionManager.Subscribe(ActionID : TActionID; AState : TActionState;
  ACallback : TActionCallback; AdditionalData : TAnyValue);
var
  SubscribeItem : TSubscribeItem;
begin
  SubscribeItem.State := AState;
  SubscribeItem.Callback := ACallback;
  SubscribeItem.AdditionalData := AdditionalData;
  FSubscribers.Insert(ActionID, SubscribeItem);
end;

procedure TActionManager.NotifySubscribers(ActionID : TActionID; AState :
  TActionState; AData : TAnyValue);
var
  Subscribers : TSubscribersContainer.TMultiValue;
  SubscribeItem : TSubscribeItem;
begin
  try
    Subscribers := FSubscribers.Search(ActionID);    
  except
    on e: EKeyNotExistsException do
    begin
      Exit;
    end;
  end;

  for SubscribeItem in Subscribers do
  begin
    if SubscribeItem.State = AState then
    begin
      SubscribeItem.Callback(AData, SubscribeItem.AdditionalData);
    end;
  end;
end;

end.
