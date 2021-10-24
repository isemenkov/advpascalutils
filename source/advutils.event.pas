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

unit advutils.event;

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
  { Event unique id type. }
  TEventID = type Cardinal;

  { Event manager. }
  TEventManager = class
  public
    type
      { Event subscribe callback. }
      TEventCallback = procedure (AData : TAnyValue) of object;
  public
    constructor Create;
    destructor Destroy; override;

    { Run event. }
    function Run(AEventID : TEventID; AData : TAnyValue) : Boolean;

    { Subscribe for event. }
    procedure Subscribe(AEventID : TEventID; ACallback : TEventCallback);
  protected
    type
      TEventIDCompareFunctor = class
        ({$IFDEF FPC}specialize{$ENDIF} TBinaryFunctor<TEventID, Integer>)
      public
        function Call(AValue1, AValue2 : TEventID) : Integer; override;
      end;

      TSubscribersContainer = 
        {$IFDEF FPC}specialize{$ENDIF} TMultiHash<TEventID, TEventCallback, 
        TEventIDCompareFunctor, 
        {$IFDEF FPC}specialize{$ENDIF} TUnsortableFunctor<TEventCallback> >;
  protected
    FSubscribers : TSubscribersContainer;
  end;

  { Generate a hash key for TEventID value. }
  function HashEventID(AEventID : TEventID) : Cardinal;

implementation

function HashEventID(AEventID : TEventID) : Cardinal;
begin
  Result := HashInteger(Cardinal(AEventID));
end;

{ TEventManager }

function TEventManager.TEventIDCompareFunctor.Call(AValue1, AValue2 : 
  TEventID) : Integer;
begin
  if AValue1 < AValue2 then
    Result := -1
  else if AValue2 < AValue1 then
    Result := 1
  else
    Result := 0;
end;

constructor TEventManager.Create;
begin
  FSubscribers := TSubscribersContainer.Create(@HashEventID);
end;

destructor TEventManager.Destroy;
begin
  FreeAndNil(FSubscribers);
  inherited Destroy;
end;

function TEventManager.Run(AEventID : TEventID; AData : TAnyValue) : Boolean;
var
  Subscribers : TSubscribersContainer.TMultiValue;
  Callback : TEventCallback;
begin
  try
    Subscribers := FSubscribers.Search(AEventID);
  except on e : EKeyNotExistsException do
    begin
      Result := False;
      Exit;
    end;
  end;

  Result := False;

  for Callback in Subscribers do
  begin
    Callback(AData);
    Result := True;
  end;
end;

procedure TEventManager.Subscribe(AEventID : TEventID; ACallback : 
  TEventCallback);
begin
  FSubscribers.Insert(AEventID, ACallback);
end;

end.