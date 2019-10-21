:- ['./labirinto.pl', 'mosse.pl'].

% ###################################################
% Algoritmo A*.
% Il nodo è rappresentato da nodo/4 e la sua struttura è:
%   • S, lo stato corrente,
%   • F, il costo di F corrente,
%   • ListaAzioniperS, l'insieme delle azioni in S,
%   • G, il costo del percorso sino a S.
% ###################################################
aStar(Soluzione) :-
    iniziale(S),
    fCosto(S, 0, F),
    aStarAux( [nodo(F,S,[], 0) ], [], Soluzione),!.

% #####################################################################
% aStarAux(NodiFrontiera, NodiEspansi, Soluzione)
%            input           input      output
% #####################################################################
aStarAux([nodo(_F, S, ListaAzioniPerS, _G)|_], _, ListaAzioniPerS) :- finale(S).
aStarAux([nodo(F, S, ListaAzioniPerS, G)|Frontiera], NodiEspansi, Soluzione) :-
    findall(Az, applicabile(Az, S), ListaAzioniApplicabili),
    generaFigli(nodo(F, S,ListaAzioniPerS, G), ListaAzioniApplicabili, NodiEspansi, ListaFigliS),
    aggiornamentoFrontiera(ListaFigliS, Frontiera, NuovaFrontiera),!,
    aStarAux(NuovaFrontiera, [S|NodiEspansi], Soluzione),!.

% #####################################################################
%  generaFigli(Nodo, ListaAzioniApplicabili, ListaStatiVisitati, ListaNodiFigli)
%              input           input            intput            output
% #####################################################################
generaFigli(_, [], _, []).
generaFigli(nodo(F, S,ListaAzioniPerS,G), [Azione|AltreAzioni], ListaStatiVisitati, [nodo(FNuovo, SNuovo, ListaAzioniNuovo ,GNuovo)|AltriFigli]) :-
    trasforma(Azione, S, SNuovo),
    \+member(SNuovo, ListaStatiVisitati),
    gCosto(G,GNuovo),
    fCosto(SNuovo, GNuovo, FNuovo),
    append(ListaAzioniPerS, [Azione], ListaAzioniNuovo),
    generaFigli(nodo(F, S, ListaAzioniPerS, G), AltreAzioni, ListaStatiVisitati, AltriFigli).
generaFigli(Nodo, [_|AltreAzioni], ListaStatiVisitati, ListaNodiFigli) :-
    generaFigli(Nodo, AltreAzioni, ListaStatiVisitati, ListaNodiFigli).

/* * * * * * * * * * INIZIO UTILS* * * * * * * * * * */

 % #####################################################################
 %   aggiornamentoFrontiera(ListaFigli,Frontiera, NuovaFrontiera)
 %                           input      input        output
 % #####################################################################
 aggiornamentoFrontiera([], FrontieraFinale, FrontieraFinale).
 aggiornamentoFrontiera([Figlio|AltriFigli], Frontiera, NuovaFrontiera) :-
   eliminaDuplicati(Figlio, Frontiera, FrontieraNoDup),
   aggiuntaOrdinataElem(Figlio, FrontieraNoDup, FrontieraNoDupConFiglio),
   aggiornamentoFrontiera(AltriFigli, FrontieraNoDupConFiglio, NuovaFrontiera), !.
 aggiornamentoFrontiera([_|AltriFigli], Frontiera, NuovaFrontiera) :-
   aggiornamentoFrontiera(AltriFigli, Frontiera, NuovaFrontiera).

% #####################################################################
% eliminaDuplicati(Nodo, Frontiera, NuovaFrontiera)
%                  input    input        output
% #####################################################################
eliminaDuplicati(_, [], []).
eliminaDuplicati(nodo(_, S,_,G), [nodo(_, S1, _, G1)|AltriNodi], AltriNodi) :-
    S == S1,
    G =< G1, !.
eliminaDuplicati(A, [N|RestoFrontiera], [N|RestoNuovaFrontiera]) :-
 eliminaDuplicati(A, RestoFrontiera, RestoNuovaFrontiera).

% #####################################################################
% aggiuntaOrdinataElem(Figlio, FrontieraSenzaDuplicati, FrontieraFinale),
%                        input    input                    output
% #####################################################################
aggiuntaOrdinataElem(Figlio, [], [Figlio]).
aggiuntaOrdinataElem(nodo(F, S,ListaAzioniPerS,G), [nodo(F1 ,S1, ListaAzioniPerS1, G1)|RestoFrontiera],
                    [nodo(F, S,ListaAzioniPerS,G)|[nodo(F1 ,S1, ListaAzioniPerS1, G1)|RestoFrontiera]]) :-
                    F < F1, !.
aggiuntaOrdinataElem(X, [Y|Resto1], [Y|Resto2]) :-
  aggiuntaOrdinataElem(X, Resto1, Resto2), !.

% #####################################################################
%fCosto(StatoCorrente,CostoDiG, CostoDiF).
%           input      input      output
% #####################################################################
fCosto(Stato, G, F):-
    finale(Goal),
    distanzaManhattan(Stato,Goal,H),
    F is G + H.

% #####################################################################
%gCosto(GCorrente, GNUovo)
%        input     output
% #####################################################################
gCosto(G,G1) :-
    G1 is G+1.

% #####################################################################
%distanzaManhattan(Stato1, Stato2, DistanzaStati_1-2).
%                   input   input     output
% #####################################################################
distanzaManhattan(pos(X1,Y1),pos(X2,Y2),Distanza) :-
    Distanza is abs(X1-X2) + abs(Y1-Y2).
