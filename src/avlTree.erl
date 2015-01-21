%%%-------------------------------------------------------------------
%%% @author KamikazeOnRoad
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(avlTree).
-author("KamikazeOnRoad").

%% API
-export([initTree/0, initNode/0, initNode/1, addNode/2, deleteNode/2, getHeight/1, getNode/2, getMinimum/1, getMaximum/1]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Init empty tree
initTree() -> generateOutputfile:writeDigraph(), {}.

%% Init node with pattern {{Parent, Height}, {ChildLeft, Height}, {ChildRight, Height}}
initNode() -> {{}, {}, {}}.
initNode(Number) -> {{Number,1}, {}, {}}.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Add nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Add node to empty tree
addNode(Number, {}) -> initNode(Number);
%% Add node to existing tree
%% Numbers > parent always are settled on right side for initialization
%% Numbers == parent are ignored
addNode(Number, {{Parent, Height}, {}, {}}) when Number < Parent ->
  Tree = {{Parent, Height+1}, initNode(Number), {}},
  generateOutputfile:cleanUp(),
  generateOutputfile:writeToFile(Tree),
  Tree;

addNode(Number, {{Parent, Height}, {}, {}}) when Number > Parent ->
  Tree = {{Parent, Height+1}, {}, initNode(Number)},
  generateOutputfile:cleanUp(),
  generateOutputfile:writeToFile(Tree),
  Tree;

addNode(Number, {{Parent, Height}, {}, ChildRight}) when Number < Parent ->
  Tree = {{Parent, Height}, initNode(Number), ChildRight},
  generateOutputfile:cleanUp(),
  generateOutputfile:writeToFile(Tree),
  Tree;

addNode(Number, {{Parent, Height}, ChildLeft, {}}) when Number > Parent ->
  Tree = {{Parent, Height}, ChildLeft, initNode(Number)},
  generateOutputfile:cleanUp(),
  generateOutputfile:writeToFile(Tree),
  Tree;

addNode(Number, {{Parent, Height}, ChildLeft, ChildRight}) when Number == Parent ->
  {{Parent, Height}, ChildLeft, ChildRight};

addNode(Number, {{Parent, _}, ChildLeft, ChildRight}) ->

  %% Tree maybe comes back unbalanced from recursion
  if
    Number < Parent -> 
      NewChildLeft = addNode(Number, ChildLeft),
      UnbalancedTree = {{Parent, getMaxHeight(NewChildLeft, ChildRight) + 1}, NewChildLeft, ChildRight};
    Number > Parent -> 
      NewChildRight = addNode(Number, ChildRight),
      UnbalancedTree = {{Parent, getMaxHeight(ChildLeft, NewChildRight) + 1}, ChildLeft, NewChildRight}
  end,
  
  %% Check balance and rotate if necessary
  Tree = balance(UnbalancedTree),
  generateOutputfile:cleanUp(),
  generateOutputfile:writeToFile(Tree),
  Tree.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Delete nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Delete node when it is a leaf
deleteNode(Number, {{Number, 1}, {}, {}}) -> {};

%% Delete node when it only has sub-tree on left side
deleteNode(Number, {{Number, _}, ChildLeft, {}}) ->
  %% Find and delete max value in ChildLeft
  MaximumLeft = getMaximum(ChildLeft),
  NewChildLeft = deleteNode(MaximumLeft, ChildLeft),
  
  %% Generate new tree and balance it
  UnbalancedTree = {{MaximumLeft, getHeight(NewChildLeft) + 1}, NewChildLeft, {}},
  balance(UnbalancedTree);

%% Delete node when it only has sub-tree on right side
deleteNode(Number, {{Number, _}, {}, ChildRight}) ->
  %% Find and delete min value in ChildRight
  MinimumRight = getMinimum(ChildRight),
  NewChildRight = deleteNode(MinimumRight, ChildRight),

  %% Generate new tree and balance it
  UnbalancedTree = {{MinimumRight, getHeight(NewChildRight) + 1}, {}, NewChildRight},
  balance(UnbalancedTree);
  
%% Delete node when it has sub-trees on both sides
deleteNode(Number, {{Number, _}, ChildLeft, ChildRight}) ->
  %% Find and delete min value in ChildRight
  MinimumRight = getMinimum(ChildRight),
  NewChildRight = deleteNode(MinimumRight, ChildRight),

  %% Generate new tree and balance it
  UnbalancedTree = {{MinimumRight, getMaxHeight(ChildLeft, NewChildRight) + 1}, ChildLeft, NewChildRight},
  balance(UnbalancedTree);

%% Delete node when it is smaller than root of tree
deleteNode(Number, {{Parent, _}, ChildLeft, ChildRight}) when Number < Parent ->
  NewChildLeft = deleteNode(Number, ChildLeft),
  UnbalancedTree = {{Parent, getMaxHeight(NewChildLeft, ChildRight) + 1}, NewChildLeft, ChildRight},
  balance(UnbalancedTree);

%% Delete node when it is bigger than root of tree
deleteNode(Number, {{Parent, _}, ChildLeft, ChildRight}) when Number > Parent ->
  NewChildRight = deleteNode(Number, ChildRight),
  UnbalancedTree = {{Parent, getMaxHeight(ChildLeft, NewChildRight) + 1}, ChildLeft, NewChildRight},
  balance(UnbalancedTree);

%% Node is not in tree, tree gets returned
deleteNode(_, Tree) ->
  Tree.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Balancing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

balance(UnbalancedTree) ->
  %% Checking for balance with HeightLeft - HeightRight
  %% Balanced: -1 || 0 || 1
  %% Unbalanced: -2 || 2
  DiffHeight = getDiffHeight(UnbalancedTree),
  if
    %% Tree is already balanced
    (DiffHeight == 0) or (DiffHeight == -1) or (DiffHeight == 1) -> UnbalancedTree;

    %% Tree needs left or doubleLeft rotation
    DiffHeight =< -2 ->
      CurrChildRight = getNode(UnbalancedTree, right),
      DiffHeightRight = getDiffHeight(CurrChildRight),
      if
        DiffHeightRight < 0 -> rotateLeft(UnbalancedTree);
        DiffHeightRight > 0 -> doubleRotateLeft(UnbalancedTree)
      end;

    %% Tree needs right or doubleRight rotation
    DiffHeight >= 2 ->
      CurrChildLeft = getNode(UnbalancedTree, left),
      DiffHeightLeft = getDiffHeight(CurrChildLeft),
      if
        DiffHeightLeft > 0 -> rotateRight(UnbalancedTree);
        DiffHeightLeft < 0 -> doubleRotateRight(UnbalancedTree)
      end
  end.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rotations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rotateLeft({{P1, _}, CL1, {{P2, _}, CL2, CR2}}) ->
  %% Update height P1 and P2 (all others remain the same)
  HeightP1 = getMaxHeight(CL1, CL2) + 1,
  HeightP2 = erlang:max(getHeight(CR2), HeightP1) + 1,
  {{P2, HeightP2}, {{P1, HeightP1}, CL1, CL2}, CR2}.

rotateRight({{P1, _}, {{P2, _}, CL2, CR2}, CR1}) ->
  %% Update height P1 and P2 (all others remain the same)
  HeightP1 = getMaxHeight(CR1, CR2) + 1,
  HeightP2 = erlang:max(getHeight(CL2), HeightP1) + 1,
  {{P2, HeightP2}, CL2, {{P1, HeightP1}, CR2, CR1}}.

doubleRotateLeft({P1, CL1, CR1}) ->
  FirstRotated = {P1, CL1, rotateRight(CR1)},
  rotateLeft(FirstRotated).

doubleRotateRight({P1, CL1, CR1}) ->
  FirstRotated = {P1, rotateLeft(CL1), CR1},
  rotateRight(FirstRotated).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Helper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get height from one specific node
getHeight({}) -> 0;
getHeight({{_, H}, _, _}) -> H.


%% Get max. height of the two child nodes
getMaxHeight({}, {}) -> 0;
getMaxHeight(ChildLeft, ChildRight) ->
  erlang:max(getHeight(ChildLeft), getHeight(ChildRight)).


%% Get left or right node from tree
getNode({_, CL, _}, left) -> CL;
getNode({_, _, CR}, right) -> CR.


%% Get difference in height for balance
getDiffHeight({}) -> 0;
getDiffHeight(Tree) ->
  %% Checking for balance with HeightLeft - HeightRight
  %% Balanced: -1 || 0 || 1
  %% Unbalanced: -2 || 2
  getHeight(getNode(Tree, left)) - getHeight(getNode(Tree, right)).


%% Find minimum value in tree
%% No sub-tree on left side of parent => parent already minimum
getMinimum({{Parent, _Height}, {}, _ChildRight}) ->
  Parent;

%% Still sub-tree on left side of parent => parent not minimum
getMinimum({_Parent, ChildLeft, _ChildRight}) ->
  getMinimum(ChildLeft).


%% Find maximum value in tree
%% No sub-tree on right side of parent => parent already maximum
getMaximum({{Parent, _Height}, _ChildLeft, {}}) ->
  Parent;

%% Still sub-tree on right side of parent => parent not maximum
getMaximum({_Parent, _ChildLeft, ChildRight}) ->
  getMaximum(ChildRight).