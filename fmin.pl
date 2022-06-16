insertion(nd(E,P,G,F),[],[nd(E,P,G,F)]).
insertion(nd(E,P,G,F),[nd(E2,P2,G2,F2)|L],[nd(E,P,G,F),nd(E2,P2,G2,F2)|L]) :-
	F=<F2.
insertion(nd(E,P,G,F),[nd(E2,P2,G2,F2)|L],[nd(E2,P2,G2,F2)|L1]) :-
	F>F2,
	insertion(nd(E,P,G,F),L,L1).

tri_insertion([],[]).
tri_insertion([X|L],LT) :-
	tri_insertion(L,L1),
	insertion(X,L1,LT).

fmin([],_).
fmin([nd(E,P,G,F)|Frontiere],Min) :-
	fmin(Frontiere,_),
	append([nd(E,P,G,F)],Frontiere,[nd(E,P,G,F)|Frontiere]),
	tri_insertion([nd(E,P,G,F)|Frontiere],[Min|_]).