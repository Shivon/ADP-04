%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dez 2014 20:21
%%%-------------------------------------------------------------------
-module(myUtil).
-author("KamikazeOnRoad").

%% API
-export([swap/3, getSectorArray/3, pickRandomIndex/1, pickRandomIndex/3, pickRandomElem/1, pickRandomElem/3, getIndex/2, deleteA/2, getMinimum/1]).
-import(arrayS, [initA/0, setA/3, getA/2, lengthA/1]).
-import(liste, [delete/2]).

%% Swaps 2 elements at specified indices in array and returns array
swap({}, _, _) -> {};
swap(Array, Index, Index) -> Array;
swap(Array, Index1, Index2) ->
  Elem1 = getA(Array, Index1),
  Elem2 = getA(Array, Index2),
  setA(setA(Array, Index1, Elem2), Index2, Elem1).


%% Returns the sector of the an array
getSectorArray(Array, Von, Bis) ->
  LastIndex = lengthA(Array)-1,
  if
    (Von =:= 0) and (Bis =:= LastIndex) -> Array;
    (LastIndex < Bis) -> getSectorArray(Array, Von, LastIndex, initA(), 0);
    true -> getSectorArray(Array, Von, Bis, initA(), 0)
  end.

getSectorArray(Array, Von, Bis, Output, SetElem) ->
  LengthArray = lengthA(Array),
  ActualElem = getA(Array, Von),
  if
    LengthArray =:= 0 -> Output;
    (LengthArray > 0) and (Von =:= Bis) -> setA(Output, SetElem, ActualElem);
    (LengthArray > 0) and (Von < Bis) ->
      getSectorArray(deleteA(Array, Von), Von, Bis-1, setA(Output, SetElem, ActualElem), SetElem+1)
  end.


%% Returns random index in array
%% Returns nil if array is empty
pickRandomIndex({}) -> nil;
pickRandomIndex(Array) ->
  % random:uniform(N) generates random Integer between 1 and N
  % To get index 0, too, need to subtract 1 at the end, therefore length array as N
  random:uniform(lengthA(Array)) - 1.

%% Returns random index from specified range in array
%% Returns nil if array is empty or Left is bigger than Right
pickRandomIndex({}, _, _) -> nil;
pickRandomIndex(_, Left, Right) when Left > Right -> nil;
pickRandomIndex(Array, Left, Right) when Left < Right ->
  Length = lengthA(Array),
  if
    Right < Length -> random:uniform(Right-Left+1) + (Left-1);
    Right >= Length -> random:uniform(Length-Left) + (Left-1)
  end.


%% Returns random elem in array
%% Returns nil if array is empty
pickRandomElem({}) -> nil;
pickRandomElem(Array) ->
  % random:uniform(N) generates random Integer between 1 and N
  % To get index 0, too, need to subtract 1 at the end, therefore length array as N
  RandomIndex = random:uniform(lengthA(Array)) - 1,
  getA(Array, RandomIndex).

%% Returns random element from specified range in array
%% Returns nil if array is empty or Left is bigger than Right
pickRandomElem({}, _, _) -> nil;
pickRandomElem(_, Left, Right) when Left > Right -> nil;
pickRandomElem(Array, Left, Right) when Left < Right ->
  RandomIndex = random:uniform(Right-Left+1) + (Left-1),
  getA(Array, RandomIndex).


%% Returns index of elem in array,
%% returns false if elem is not in array
getIndex(Array, Elem) ->
  getIndex(Array, Elem, 0).

getIndex(Array, Elem, AccuIndex) ->
  ElemAccuIndex = getA(Array, AccuIndex),
  Length = lengthA(Array),
  if
    (AccuIndex < Length) andalso (ElemAccuIndex =:= Elem) -> AccuIndex;
    (AccuIndex < Length) andalso (ElemAccuIndex =/= Elem) -> getIndex(Array, Elem, AccuIndex+1);
    true -> false
  end.


%% Deletes Element at index of array and returns array
deleteA(Array, Index) ->
  delete(Array, Index+1).


%% Return minimum in array
getMinimum({}) -> false;
getMinimum({Elem, {}}) -> Elem;
getMinimum(Array) ->
  getMinimum(Array, 0, getA(Array, 0)).

getMinimum(Array, ActualIndex, Minimum) ->
  Length = lengthA(Array),
  ActualElem = getA(Array, ActualIndex),
  if
    (ActualElem =< Minimum) and (ActualIndex =:= Length-1) -> ActualElem;
    (ActualElem =< Minimum) and (ActualIndex < Length-1) -> getMinimum(Array, ActualIndex+1, ActualElem);
    (ActualElem > Minimum) and (ActualIndex =:= Length-1) -> Minimum;
    (ActualElem > Minimum) and (ActualIndex < Length-1) -> getMinimum(Array, ActualIndex+1, Minimum)
  end.