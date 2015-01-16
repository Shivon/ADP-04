%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Jan 2015 01:46
%%%-------------------------------------------------------------------
-module(avlTree).
-author("KamikazeOnRoad").

%% API
-export([intitTree/0, addToTree/2]).


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
  [HeightLeft + 1, HeightRight, Parent, initNode(Number), nil];
addToTree(Number, [HeightLeft, HeightRight, Parent, nil, nil]) when Number >= Parent ->
  [HeightLeft, HeightRight + 1, Parent, nil, initNode(Number)];
addToTree(Number, [HeightLeft, HeightRight, Parent, nil, ChildRight]) when Number < Parent ->
  [HeightLeft, HeightRight, Parent, initNode(Number), ChildRight];
addToTree(Number, [HeightLeft, HeightRight, Parent, ChildLeft, nil]) when Number >= Parent ->
  [HeightLeft, HeightRight, Parent, ChildLeft, initNode(Number)];
%% TODO balance!!
addToTree(Number, [HeightLeft, HeightRight, Parent, ChildLeft, ChildRight]) when Number < Parent ->
  [HeightLeft + 1, HeightRight, Parent, addToTree(Number, ChildLeft), ChildRight];
addToTree(Number, [HeightLeft, HeightRight, Parent, ChildLeft, ChildRight]) when Number >= Parent ->
  [HeightLeft, HeightRight + 1, Parent, ChildLeft, addToTree(Number, ChildRight)].