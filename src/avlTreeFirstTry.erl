%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Jan 2015 01:46
%%%-------------------------------------------------------------------
-module(avlTreeFirstTry).
-author("KamikazeOnRoad").

%% API
-export([intitTree/0, addToTree/2, isBalanced/1]).

%% leftChild(P) rightChild(P)

%% {number, height, bigger, smaller}
%%                    |
%%                {muber, height, bigger, smaller}
%% leave when bigger and smaller =:= nil.

%% intitTree() -> {nil, 0, nil, nil}.
%% initNode(Number) -> {Number, 1, nil, nil}.
%%
%% %% Empty tree => height = 0,
%% %% Tree with only root => height = 1
%% addToTree(Number, {nil, 0, nil, nil}) -> {Number, 1, nil, nil};
%% addToTree(Number, {Parent, Height, nil, nil}) when Number < Parent ->
%%     {Parent, Height + 1, initNode(Number), nil};
%% addToTree(Number, {Parent, Height, nil, nil}) when Number >= Parent ->
%%     {Parent, Height + 1, nil, initNode(Number)};
%% addToTree(Number, {Parent, Height, nil, Child2}) when Number < Parent ->
%%     {Parent, Height, initNode(Number), Child2};
%% addToTree(Number, {Parent, Height, Child1, nil}) when Number >= Parent ->
%%     {Parent, Height, Child1, initNode(Number)};
%% %% TODO balance!!
%% addToTree(Number, {Parent, Height, Child1, Child2}) when Number < Parent ->
%%     {Parent, Height + 1, addToTree(Number, Child1), Child2};
%% addToTree(Number, {Parent, Height, Child1, Child2}) when Number >= Parent ->
%%     {Parent, Height + 1, Child1, addToTree(Number, Child2)}.


%% [Depth Left, Depth Right, Number, ChildLeft, ChildRight]
intitTree() -> [0, 0, nil, nil, nil].
initNode(Number) -> [1, 1, Number, nil, nil].

%% Empty tree => HeightLeft and HeightRight = 0,
%% Tree with only root => HeightLeft and HeightRight = 1
addToTree(Number, [0, 0, nil, nil, nil]) -> [1, 1, Number, nil, nil];

addToTree(Number, [HeightLeft, HeightRight, Parent, nil, nil]) when Number < Parent ->
  balance([HeightLeft + 1, HeightRight, Parent, initNode(Number), nil]);

addToTree(Number, [HeightLeft, HeightRight, Parent, nil, nil]) when Number >= Parent ->
  balance([HeightLeft, HeightRight + 1, Parent, nil, initNode(Number)]);

addToTree(Number, [HeightLeft, HeightRight, Parent, nil, ChildRight]) when Number < Parent ->
  balance([HeightLeft + 1, HeightRight, Parent, initNode(Number), ChildRight]);

addToTree(Number, [HeightLeft, HeightRight, Parent, ChildLeft, nil]) when Number >= Parent ->
  balance([HeightLeft, HeightRight + 1, Parent, ChildLeft, initNode(Number)]);

addToTree(Number, [HeightLeft, HeightRight, Parent, ChildLeft, ChildRight]) when Number < Parent ->
  [HeightLeft + 1, HeightRight, Parent, addToTree(Number, ChildLeft), ChildRight];

addToTree(Number, [HeightLeft, HeightRight, Parent, ChildLeft, ChildRight]) when Number >= Parent ->
  [HeightLeft, HeightRight + 1, Parent, ChildLeft, addToTree(Number, ChildRight)].



%% Checks if tree is balanced and rotates if it isnt
balance([Height, Height, Parent, nil, nil]) -> [Height, Height, Parent, nil, nil];
balance([HeightLeft, HeightRight, Parent, nil, ChildRight]) ->
  Tree = [HeightLeft, HeightRight, Parent, nil, ChildRight],
  Difference = HeightRight - HeightLeft,
  if
    Difference < -1 -> rotateRight(Tree);
    Difference > 1 -> rotateLeft(Tree);
    true -> balance(ChildRight)
  end;
balance([HeightLeft, HeightRight, Parent, ChildLeft, nil]) ->
  Tree = [HeightLeft, HeightRight, Parent, ChildLeft, nil],
  Difference = HeightRight - HeightLeft,
  if
    Difference < -1 -> rotateRight(Tree);
    Difference > 1 -> rotateLeft(Tree);
    true -> balance(ChildLeft)
  end;
balance([HeightLeft, HeightRight, Parent, ChildLeft, ChildRight]) ->
  [HeightLeft, HeightRight, Parent, balance(ChildLeft), balance(ChildRight)].


%% rotateRight() ->

%% rotateLeft([HL1, HR1, P1, nil, [_, _, P2, nil, [_, _, P3, nil, nil]]]) ->
%%   [HL1+1, HR1-1, P2, initNode(P1), initNode(P3)].
rotateLeft([HL1, HR1, P1, CL1, [HL2, HR2, P2, CL2, [HL3, HR3, P3, CL3, CR3]]]) ->

  %% TODO finish and debug: count height from highest routated node to root ! (not HL1+1 like here)
  [HL1+1, HR1-1, P2, []].

%% TODO impl (just dummy)
rotateRight(_) -> true.

%% Prädikat
isBalanced([Height, Height, _, nil, nil]) -> true;
isBalanced([HeightLeft, HeightRight, _, nil, ChildRight]) ->
    Difference = HeightRight - HeightLeft,
    if
      Difference < -1 -> false;
      Difference > 1 -> false;
      true -> isBalanced(ChildRight)
    end;
isBalanced([HeightLeft, HeightRight, _, ChildLeft, nil]) ->
  Difference = HeightRight - HeightLeft,
  if
    Difference < -1 -> false;
    Difference > 1 -> false;
    true -> isBalanced(ChildLeft)
  end;
isBalanced([HeightLeft, HeightRight, _, ChildLeft, ChildRight]) ->
  Difference = HeightRight - HeightLeft,
  if
    Difference < -1 -> false;
    Difference > 1 -> false;
    true -> isBalanced(ChildLeft) and isBalanced(ChildRight)
  end.

%%isUnbalanced(Tree) -> not(isBalanced(Tree)).
