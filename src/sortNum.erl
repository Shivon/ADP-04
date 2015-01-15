%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Nov 2014 18:48
%%%-------------------------------------------------------------------
-module(sortNum).
-author("KamikazeOnRoad").
-import(arrayS, [initA/0, setA/3, lengthA/1]).

%% API
-export([sortNum/0, sortNum/1]).

%% sortNum/0 generates per default arrays with int and size 10.
sortNum() ->
  sortNum(10).


%% Parameter of sortNum/1 defines size of the arrays.
sortNum(Quantity) ->
  %% Cleares file if it already exists
  file:write_file("\zahlen.dat", []),
  sortNum(Quantity, 80, 10, 10).

sortNum(Quantity, IteratorRandom, IteratorWorst, IteratorBest) ->
  FileName = "\zahlen.dat",
  if
    (IteratorRandom > 0) ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [generateRandom(Quantity)]), [append]),
      sortNum(Quantity, IteratorRandom-1, IteratorWorst, IteratorBest);
    (IteratorWorst > 0) ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [generateWorst(Quantity)]), [append]),
      sortNum(Quantity, IteratorRandom, IteratorWorst-1, IteratorBest);
    (IteratorBest > 0) ->
      file:write_file(FileName, io_lib:fwrite("~p.\n", [generateBest(Quantity)]), [append]),
      sortNum(Quantity, IteratorRandom, IteratorWorst, IteratorBest-1);
    true -> ok
  end.


generateRandom(Quantity) ->
  Output = initA(),
  Length = lengthA(Output),
  if
    %%  random:uniform(N) -> generates random int between 1 and N
    (Length == Quantity-1) -> setA(Output, Quantity-1, random:uniform(1000));
    (Length < Quantity) -> setA(generateRandom(Quantity-1), Quantity-1, random:uniform(1000))
  end.


generateWorst(Quantity) ->
  generateWorst(Quantity, random:uniform(1000)).

generateWorst(Quantity, Previous) ->
  Output = initA(),
  Length = lengthA(Output),
  Random = Previous + random:uniform(1000),
  if
    (Length == Quantity-1) -> setA(Output, Quantity-1, Random);
    (Length < Quantity) -> setA(generateWorst(Quantity-1, Random), Quantity-1, Random)
  end.


generateBest(Quantity) ->
  reverse(generateWorst(Quantity)).


%% Hilfsfunktion
reverse(List) -> reverse(List, {}).

reverse({}, NewList) -> NewList;
reverse({First, Rest}, NewList) -> reverse(Rest, {First,NewList}).