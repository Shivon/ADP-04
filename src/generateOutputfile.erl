
-module(generateOutputfile).
-author("AD").

%% API
-export([writeNodeToFile/3, writeleftChild/2, writerightChild/2,  writeDigraph/0, writeEOF/0]).

%%-import().
%% logFile() -> "\beispiel.dot".
%% logFile() -> "\messung.log".
logFile() -> "\mbeispiel.dot".


%% Writes topic into "\mbeispiel.dot"
%% digraph g {
%%  node [shape = record,height=.1];
writeDigraph() ->
  file:write_file(logFile(), io_lib:fwrite("digraph g { \n node [shape = record, height=.1]; \n", []), [append]).

%% Writes  into "\mbeispiel.dot"
writeNodeToFile(Node, WeightLeft, Weightright) ->
  file:write_file(logFile(), io_lib:fwrite("node~p[label = \"<f0> ~p |<f1> ~p |<f2> ~p\"] \n",   [Node, WeightLeft, Node, Weightright]), [append]).

%% Writes the left Child of a Parent to "\mbeispiel.dot"
writeleftChild(Parent, ChildLeft ) ->
  file:write_file(logFile(), io_lib:fwrite(" \"node~p\":f0 -> \"node~p\":f1 ; \t \n",   [Parent, ChildLeft]), [append]).

%% Writes the right Child of a Parent to "\mbeispiel.dot"
writerightChild(Parent, ChildRight ) ->
  file:write_file(logFile(), io_lib:fwrite(" \"node~p\":f2 -> \"node~p\":f1 ; \t \n",   [Parent, ChildRight]), [append]).

writeEOF() ->
  file:write_file(logFile(), io_lib:fwrite(" } \n", []), [append]).

%%
%%digraph g {
%% node [shape = record,height=.1];
%% node0[label = "<f0>3 |<f1> 8|<f2> "];
%% node1[label = "<f0> |<f1> 5 |<f2> "];
%% node2[label = "<f0> |<f1> 3|<f2> "];
%% node3[label = "<f0> |<f1> 6|<f2> "];
%% node4[label = "<f0> |<f1>12|<f2> "];
%% node5[label = "<f0> |<f1> 11|<f2> "];
%% node6[label = "<f0> |<f1> 15|<f2> "];
%% node7[label = "<f0> |<f1> 1|<f2> "];
%% node8[label = "<f0> |<f1> 4|<f2> "];
%% "node0":f2 -> "node4":f1 ;
%% "node0":f0 -> "node1":f1;
%% "node1":f0 -> "node2":f1;
%% "node1":f2 -> "node3":f1;
%% "node2":f2 -> "node8":f1;
%% "node2":f0 -> "node7":f1;
%% "node4":f2 -> "node6":f1;
%% "node4":f0 -> "node5":f1;
%%
%% }