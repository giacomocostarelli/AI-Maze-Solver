% Esempio 20 x 20
/*
num_righe(20).
occupata(pos(7,15)).
occupata(pos(8,15)).
occupata(pos(9,15)).
occupata(pos(10,15)).
occupata(pos(11,15)).
occupata(pos(12,15)).
occupata(pos(13,15)).

occupata(pos(13,6)).
occupata(pos(13,7)).
occupata(pos(13,8)).
occupata(pos(13,9)).
occupata(pos(13,10)).
occupata(pos(13,11)).
occupata(pos(13,12)).
occupata(pos(13,13)).
occupata(pos(13,14)).

occupata(pos(15,1)).
occupata(pos(15,2)).
occupata(pos(15,3)).
occupata(pos(15,4)).
occupata(pos(15,5)).
occupata(pos(15,6)).
occupata(pos(15,7)).
occupata(pos(15,8)).
occupata(pos(15,9)).
iniziale(pos(10,10)).
finale(pos(20,20)).
*/

% ############### LABIRINTO 10 x 10 #################
num_col(10). num_righe(10).
iniziale(pos(4,2)). finale(pos(7,9)).

occupata(pos(2,5)). occupata(pos(3,5)). occupata(pos(4,5)). occupata(pos(3,2)).
occupata(pos(5,5)). occupata(pos(6,5)). occupata(pos(7,5)). occupata(pos(7,1)).
occupata(pos(7,2)). occupata(pos(7,3)). occupata(pos(7,4)). occupata(pos(5,7)).
occupata(pos(6,7)). occupata(pos(7,7)). occupata(pos(8,7)). occupata(pos(4,7)).
occupata(pos(4,8)). occupata(pos(4,9)). occupata(pos(4,10)). occupata(pos(4,3)).
occupata(pos(3,3)).

%Check su applicabilità mossa.
applicabile(nord,pos(R,C)) :- R>1, R1 is R-1, \+ occupata(pos(R1,C)).
applicabile(est,pos(R,C)) :- num_col(NC), C<NC, C1 is C+1, \+ occupata(pos(R,C1)).
applicabile(sud,pos(R,C)) :- num_righe(NR), R<NR, R1 is R+1, \+ occupata(pos(R1,C)).
applicabile(ovest,pos(R,C)) :- C>1, C1 is C-1, \+ occupata(pos(R,C1)).

%Esecuzione dell'azione se applicabile.
trasforma(est,pos(R,C),pos(R,C1)) :-   C1 is C+1.
trasforma(ovest,pos(R,C),pos(R,C1)) :- C1 is C-1.
trasforma(sud,pos(R,C),pos(R1,C)) :-   R1 is R+1.
trasforma(nord,pos(R,C),pos(R1,C)) :-  R1 is R-1.

% Algoritmo Iterative Deepening a cui viene fornita una soglia iniziale di 1.
id(Soluzione):-
    id_search_aux(Soluzione, 1).

% #####################################################################
% id_search_aux(Soluzione,Soglia)
%                 output   input
% #####################################################################
id_search_aux(Soluzione,Soglia):-
    depth_limited_search(Soluzione,Soglia),!.
id_search_aux(Soluzione,Soglia):-
    NuovaSoglia is Soglia+1,
    id_search_aux(Soluzione,NuovaSoglia).

% #####################################################################
% depth_limited_search(Soluzione, Soglia)
%                       output    input
% #####################################################################
depth_limited_search(Soluzione,Soglia):-
    iniziale(S),
    dls_aux(S,Soluzione,[S],Soglia).

% #####################################################################
% dls_aux(StatoCorrente, ListaAzioni, ListaNodiVisitati,Soglia):-
%             input         output     intput            input
% #####################################################################
dls_aux(S,[],_,_):-finale(S).
dls_aux(S,[Azione|AzioniTail],Visitati,Soglia):-
    Soglia>0,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaSoglia is Soglia-1,
    dls_aux(SNuovo,AzioniTail,[SNuovo|Visitati],NuovaSoglia).
