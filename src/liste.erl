%%%-------------------------------------------------------------------
%%% @author Louisa
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Okt 2014 21:22
%%%-------------------------------------------------------------------
-module(liste).
-author("Louisa").

%% API
-export([create/0, isEmpty/1, laenge/1, insert/3, reverse/1, delete/2, find/2, retrieve/2, concat/2]).


%% create: leere Menge -> list
%% Initialisiert und erzeugt eine Liste und liefert diese zurück
%% Implementierung via Tupel gemäß Anforderung
create() ->
  {}.


%% isEmpty: list -> bool
%% Prüft, ob die Liste leer ist
isEmpty(List) ->
  Laenge = laenge(List),
  if
    (Laenge == 0) -> true;
    true -> false
  end.


%% laenge: list -> int
%% Gibt die Länge der übergebenen Liste zurück
laenge(List) ->
  laenge_(List,0).

%% Abbruchbedingung: Wenn Liste leer ist, wird Accumulator zurückgegeben
laenge_({},Accu)  ->
  Accu;
%% Rekusiv duch Liste gehen und dabei Accumulator immer um eins erhöhen
laenge_({_First,Rest}, Accu) ->
  laenge_(Rest, Accu + 1 ).


%% insert: list x pos x elem -> list
%% Fügt der übergebenen Lise an der übergebenen Position das
%% übergebene Element hinzu und gibt die modifizierte Liste zurück
insert(List, Pos, Elem) ->
   insert_(List, Pos, Elem, {}).

insert_(List, 1, Elem, NewList) ->
  NewList1 = {Elem, NewList},
  insert_(List, 0, Elem, NewList1);

insert_({}, _Pos, _Elem, NewList) ->
  reverse(NewList);

%% Position ist noch nicht erreicht, in die neue Liste wird das erste Element hinzugefügt
%% Funktion wird rekursiv mit dem Rest aufgerufen & Position um 1 verringert
insert_({First, Rest}, Pos, Elem, NewList) ->
    NewList1 = {First, NewList},
    insert_( Rest, Pos - 1, Elem, NewList1).

%% Hilfsfunktion
reverse(List) ->
  reverse_(List, {}).

reverse_({}, NewList) ->
  NewList;
reverse_({First, Rest}, NewList) ->
  NewList1 = {First,NewList},
  reverse_(Rest, NewList1).


%% delete: list x pos -> list
%% Entfernt das übergebene Element an der übergebenen Position (falls vorhanden)
%% in der übergebenen Liste und gibt die modifizierte Liste zurück
delete(List, Pos) ->
  delete_(List, Pos, {}).

delete_({_First,Rest}, 1, NewList) ->
  delete_(Rest, 0,  NewList);

delete_({}, _Pos,  NewList) ->
  reverse(NewList);

delete_({First,Rest}, Pos, NewList) ->
  %% in die Neue Liste wird das Erste Element hinzugefügt
  NewList1 = {First, NewList},
  delete_( Rest, Pos - 1, NewList1).


%% find: list x elem -> pos
%% Sucht nach einem übergebenen Element in der übergebenen Liste
%% und gibt die Position dessen zurück (falls gefunden)
find(List, Elem) ->
  find_(List, Elem, 1).

find_({First, _Rest}, Elem, Pos) when First == Elem -> Pos;
find_({First, Rest}, Elem, Pos)  when First /= Elem -> find_(Rest, Elem, Pos + 1);
%% gesuchtes Element existiert nicht -> nil (not in list) wird zurückgegeben.
find_({}, _Elem, _Pos) -> nil.


%% retrieve: list x pos -> elem
%% Gibt das Element an der übergebenen Position in der übergebenen Liste zurück (falls vorhanden)
%% Position erreicht, liefert Element an der Stelle
retrieve({First, _Rest}, 1) ->
  First;
%% Richtige Position noch nicht erreicht, suche weiter
retrieve({_First, Rest}, Pos) ->
  retrieve(Rest, Pos - 1);
%% Position existiert nicht, liefert leere Liste zurück
retrieve({}, _Pos) ->
  {}.


%% concat: list x list -> list
%% Konkatiniert die übergebenen Listen und gibt die neue Liste zurück
concat(List1, List2) ->
  concat_(List1, List2, {}).

%% Sind beide Listen leer, wird die neu erstellte Liste zurückgegeben
concat_({}, {}, NewList) ->
  reverse(NewList);

%% 1. Liste leer - entweder von Anfang an oder alle Elemente schon komplett in neue Liste hinzugefügt
%% => Elemente 2. Liste in neue Liste hinzufügen
concat_({}, {First, Rest}, NewList) ->
  NewList1 = {First,NewList},
  concat_({}, Rest, NewList1);

%% Elemente 1. Liste in neue Liste hinzugefügt
concat_({First, Rest}, List2, NewList) ->
  NewList1 = {First,NewList},
  concat_(Rest, List2, NewList1).