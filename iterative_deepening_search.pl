:- ['./labirinto.pl', 'mosse.pl'].

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
