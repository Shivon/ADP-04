
-module(generateOutputfile).
-author("AD").

%% API
-export([ writeToFile/1, writeDigraph/0, writeEOF/0, cleanUp/0]).

%%-import().
%% logFile() -> "\beispiel.dot".
%% logFile() -> "\messung.log".
logFile() -> "\avl1.dot".


%% Writes topic into "\mbeispiel.dot"
%% digraph g {
%%  node [shape = record,height=.1];
writeDigraph() ->
  file:write_file(logFile(), io_lib:fwrite("digraph avltree {  \n", []), [write]).


%% Cleans up the file avl1.dot before
%% adding a node and rotate the tree
cleanUp()->
  writeDigraph().

writeToFile({{_Parent, 1}, _ChildLeft, _ChildRight}) ->
  ok;

writeToFile({{Parent, _Height}, {}, ChildRight}) ->
  {{CR1, HR1},_,_} = ChildRight,
  file:write_file(logFile(), io_lib:fwrite("~p -> ~p [label = ~p];  \n",   [Parent, CR1, HR1+1]), [append]),
  writeToFile(ChildRight);

writeToFile({{Parent, _Height}, ChildLeft, {}}) ->
  {{CL1, HL1},_,_} = ChildLeft,
  file:write_file(logFile(), io_lib:fwrite("~p -> ~p [label = ~p];  \n",   [Parent, CL1, HL1+1]), [append]),
  writeToFile(ChildLeft);

%% Writes the left Child of a Parent to "\mbeispiel.dot"
writeToFile({{Parent, _Height}, ChildLeft, ChildRight} ) ->
  {{CL1, HL1},_,_} = ChildLeft,
  {{CR1, HR1},_,_} = ChildRight,
  file:write_file(logFile(), io_lib:fwrite("~p -> ~p [label = ~p];  \n",   [Parent, CL1, HL1+1]), [append]),
  file:write_file(logFile(), io_lib:fwrite("~p -> ~p [label = ~p];  \n",   [Parent, CR1, HR1+1]), [append]),
  writeToFile(ChildLeft),
  writeToFile(ChildRight).


writeEOF() ->
  file:write_file(logFile(), io_lib:fwrite(" } \n", []), [append]).
