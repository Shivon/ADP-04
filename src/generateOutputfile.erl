
-module(generateOutputfile).
-author("AD").

%% API
-export([ writeToFile/1, writeDigraph/0, writeEOF/0, writeSingleToFile/1]).

%%-import().
%% logFile() -> "\beispiel.dot".
%% logFile() -> "\messung.log".
logFile() -> "\avl1.dot".


%% Writes topic into "\mbeispiel.dot"
%% digraph g {
%%  node [shape = record,height=.1];
writeDigraph() ->
  file:write_file(logFile(), io_lib:fwrite("digraph avltree {  \n", []), [append]).

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

writeSingleToFile(Parent) ->
  file:write_file(logFile(), io_lib:fwrite("~p  \n",   [Parent]), [append]).

writeEOF() ->
  file:write_file(logFile(), io_lib:fwrite(" } \n", []), [append]).

%% digraph avltree
%% {
%% 6 -> 2 [label = 3];
%% 6 -> 8 [label = 2];
%% 2 -> 1 [label = 2];
%% 2 -> 4 [label = 2];
%% 1 -> 0 [label = 1];
%% 4 -> 3 [label = 1];
%% 4 -> 5 [label = 1];
%% 8 -> 7 [label = 1];
%% 8 -> 9 [label = 1];
%% }