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
-export([initTree/0, initNode/0, initNode/1, addNode/2, deleteNode/2, getHeight/1, getNode/2, getMinOfChildRight/1]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Init empty tree
initTree() ->  {}.

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
  {{Parent, Height+1}, initNode(Number), {}};

addNode(Number, {{Parent, Height}, {}, {}}) when Number > Parent -> 
  {{Parent, Height+1}, {}, initNode(Number)};

addNode(Number, {{Parent, Height}, {}, ChildRight}) when Number < Parent ->
  {{Parent, Height}, initNode(Number), ChildRight};

addNode(Number, {{Parent, Height}, ChildLeft, {}}) when Number > Parent ->
  {{Parent, Height}, ChildLeft, initNode(Number)};

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
  balance(UnbalancedTree).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Delete nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Delete node when only node itself is in tree
deleteNode(Number, {{Number, 1}, {}, {}}) -> {};

%% Delete node when node is only child
deleteNode(Number, {{Parent, 2}, {{Number, 1}, {}, {}}, {}}) ->
  {{Parent, 1}, {}, {}};
deleteNode(Number, {{Parent, 2}, {}, {{Number, 1}, {}, {}}}) ->
  {{Parent, 1}, {}, {}};

%% Delete node when node is one of the only two leaves  

%% TODO unnötige Fallunterscheidung, abstrahieren!! 3 fälle (blatt, halbwurzel, wurzel)
%% suchen und finden vllt besser trennen
%% beim runterlaufen für Min/ Max kopieren und ggf direkt löschen:
%% 2 möglichkeiten hier: blatt oder halbwurzel
deleteNode(Number, {{Parent, 2}, {{Number, 1}, {}, {}}, ChildRight}) ->
  {{Parent, 2}, {}, ChildRight};
deleteNode(Number, {{Parent, 2}, ChildLeft, {{Number, 1}, {}, {}}}) ->
  {{Parent, 2}, ChildLeft, {}}.
%% TODO delete nodes and balance when deeper AND when root or similar is going to be deleted

getMinOfChildRight({{Parent, _Height}, {}, _ChildRight}) ->
  Parent;

getMinOfChildRight({_Parent, ChildLeft, _ChildRight}) ->
  getMinOfChildRight(ChildLeft).



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