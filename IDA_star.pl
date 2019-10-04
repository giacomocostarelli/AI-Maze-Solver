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


% ###################################################
% Algoritmo IDA*.
% All'algoritmo viene fornito:
%   • S, lo stato iniziale ricavato dalla KB,
%   • SogliaIniziale, il valore iniziale della soglia
%     coincidente con il valore dell'euristica dallo stato S,
%   • [S], l'insieme di nodi visitati inizialmente,
%   • 0, il costo del percorso sino a fino ad S (0 poichè iniziale),
%   • Sol, output risultante dall'esecuzione dell'algoritmo.
% ###################################################
start:-
  ida(S),
  write(S).

ida(S):-
    iniziale(S),
    hCosto(S, SogliaIniziale),
    idastar(S, Sol, [S], 0, SogliaIniziale),!,
    write("\n"), write(Sol).

% #####################################################################
% idastar(StatoIniziale, Soluzione, Visitati, CostoCammino, Soglia)
%          input          output     output    input         input
% #####################################################################
idastar(S, Sol, Visitati, G, Soglia):-
    ida_search(S, Sol, Visitati, G, Soglia);
    findall(FS, ida_node(_, FS), ListaSoglie),
    exclude(>=(Soglia), ListaSoglie, ListaSoglieEccedenti),
    list_min(ListaSoglieEccedenti, NuovaSoglia),
    retractall(ida_node(_, _)),
    idastar(S, Sol, Visitati, 0, NuovaSoglia).

% #####################################################################
% ida_search(StatoCorrente, ListaAzioni, Visitati, CostoCammino, Soglia)
%              input          output      output    input         input
% #####################################################################
ida_search(S, [], _, G, _):-
    finale(S), write("Raggiunta soluione con costo: "), write(G).
ida_search(S, [Azioni|AltreAzioni], Visitati, G, Soglia):-
    applicabile(Azioni, S),
    trasforma(Azioni, S, SNuovo),
    \+member(SNuovo, Visitati),
    gCosto(G,CostoCamminoSNuovo),
    fCosto(SNuovo, CostoCamminoSNuovo, FNuovo),
    assert(ida_node(SNuovo, FNuovo)),
	FNuovo =< Soglia,
    ida_search(SNuovo, AltreAzioni, [SNuovo|Visitati], CostoCamminoSNuovo, Soglia).


/* * * * * * * * * * INIZIO UTILS* * * * * * * * * * */

% #####################################################################
%fCosto(StatoCorrente,CostoDiG, CostoDiF).
%           input      input      output
% #####################################################################
fCosto(Stato, G, F):-
    finale(Goal),
    distanzaManhattan(Stato,Goal,H),
    F is G + H.

% #####################################################################
%gCosto(GVecchio, GNUovo)
%        input     output
% #####################################################################
gCosto(G,G1) :-
     G1 is G+1.

% #####################################################################
%hCosto(StatoCorrente,ValoreDiH).
%          input        output
% #####################################################################
hCosto(Stato,H):-
    finale(Goal),
    distanzaManhattan(Stato,Goal,H).

% #####################################################################
%distanzaManhattan(Stato1, Stato2, DistanzaStati_1-2).
%                   input   input     output
% #####################################################################
distanzaManhattan(pos(X1,Y1),pos(X2,Y2),Distanza) :-
    Distanza is abs(X1-X2) + abs(Y1-Y2).

% #####################################################################
% list_min(ListaValori, ValoreMinimo).
%              input       output
% #####################################################################
list_min([L|Ls], Min) :-
    list_min(Ls, L, Min).
list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    list_min(Ls, Min1, Min).
