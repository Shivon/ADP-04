%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(executeAVL).
-author("KamikazeOnRoad").

%% API
-export([buildAVLTree/0, deleteElements/1]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Building tree with 256 elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

buildAVLTree() ->
  %% Generate input file
  generateInputFile:generateInputList(),
  
  %% Read list from input file
  InputList = util:zahlenfolgeRT("\zahlen.dat"),
  
  %% Init tree
  AVLTree = avlTree:initTree(),
  
  %% Build tree
  buildAVLTree(InputList, AVLTree).


%% Input list is empty, tree is completed
buildAVLTree([], Tree) -> Tree;

%% Still elements in input list, tree not complete
buildAVLTree([First|Rest], Tree) ->
  CurrentSizeList = length([First|Rest]),
  
  if
    CurrentSizeList == 0 -> Tree;
    CurrentSizeList > 0 -> buildAVLTree(Rest, avlTree:addNode(First, Tree))
  end.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deleting 25 elements from tree
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

deleteElements(Tree) ->
  %% Generate input file
  generateInputFile:generateDeleteList(),

  %% Read list from input file
  DeleteList = util:zahlenfolgeRT("\zahlen.dat"),
  
  %% Delete elements
  deleteElements(DeleteList, Tree).


%% Delete list is empty, tree is completed
deleteElements([], Tree) -> Tree;

%% Still elements in delete list, tree not complete
deleteElements([First|Rest], Tree) ->
  CurrentSizeList = length([First|Rest]),

  if
    CurrentSizeList == 0 -> Tree;
    CurrentSizeList > 0 -> buildAVLTree(Rest, avlTree:deleteNode(First, Tree))
  end.
  