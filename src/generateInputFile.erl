%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(generateInputFile).
-author("KamikazeOnRoad").

%% API
-export([generateInputList/0, generateDeleteList/0]).



%% Generate list with 256 random integers and write to file
generateInputList() ->
  util:zahlenfolgeWT("\zahlen.dat", 256, 0, 10000).



%% Generate list with randomly picked 25 elements of the earlier generated list in "\zahlen.dat"
%% Overwrites file with this list
generateDeleteList() ->
  List = util:aTl(generateDeleteList(25), 0),
  file:write_file("\zahlen.dat", io_lib:format("~p",[List])).

%% Quantity = number of elements of input list in "\zahlen.dat" to be deleted in AVL tree
generateDeleteList(Quantity) ->
  Output = arrayS:initA(),
  LengthOutput = arrayS:lengthA(Output),
  
  InputList = util:zahlenfolgeRT("\zahlen.dat"),
  InputArray = util:zTa(InputList),
  RandomElem = myUtil:pickRandomElem(InputArray),
  
  if
    LengthOutput == Quantity-1 -> arrayS:setA(Output, Quantity-1, RandomElem);
    LengthOutput < Quantity -> arrayS:setA(generateDeleteList(Quantity-1), Quantity-1, RandomElem)
  end.
