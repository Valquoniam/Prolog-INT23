/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */


/*****************************************************************************
* rech_A(+Etat,-Solution,H,NNA,NND)	  qui est vrai si et seulement si Solution est 
*			une suite (sans cycle) d'états, caractérisant un chemin solution depuis
*			Etat vers un état du But, renvoyé par l'algorithme A* en utilisant
* 			la fonction heuristique H. NNA et NND représentent respectivement le `
* 			nombre total de noeuds apparus (i.e. la taille du graphe de recherche)
* 			et le nombre de noeuds développés.
******************************************************************************/

/********************* Etape 1 : Définition de l'état ************************
*
*       nd(Etat, Pere,G,F) 
* 
* où - Etat est l'état associé au noeud 
*    - Pere est le noeud du père ( =0 si nous sommes le noeud 1 , aka le noeud initial)
*    - Cout est le coût pour aller du noeud Pere au noeud actuel.
*    - G est le cout "courant" du noeud, susceptible d'être actualisé
*    - F est la fonction de recherche évaluée en ce noeud, soit G+H. Un Etat peut avoir plusieurs F différents selons les chemins choisis
******************************************************************************/

/******************* Etape 2 : Reconstruction du chemin solution **************

path(+Noeud,?Solution) renvoie le chemin depuis Noeud jusqu'au noeud initial.*/

path(nd(Etat,0,_,_),[Etat]).                                  /* Cas où on est le noeud initial */
path(nd(Etat,nd(X,Pere,G,H),_,_),[Etat|NoeudSuivants]) :-     /* On ajoute le père dans le chemin solution sinon */
     path(nd(X,Pere,G,H),NoeudSuivants).                      /* On repète le processus pour arriver à NoeudSuivant = 0 */


/*******************************Etape 3 : Fonctions de calcul intermédiaires **************************/

/*calcul_f(+GPere,+H,+Noeud,-NoeudAvecF) calcule F et renvoie le noeud complété */

calcul_f(GPere,H,nd(Etat,nd(EPere,A,B,C),_,_),Noeud):-
	h(H,Etat,HFils),
	operateur(_,EPere,Etat,Cout),
        GFils is GPere + Cout,
        F is GFils + HFils,
        append([nd(Etat,nd(EPere,A,B,C),GFils,F)],[],[Noeud]).

/* calcul_f_liste applique calcule_f a toute une liste de noeud pour laquelle aucun F n'est calculé */

calcul_f_liste(_,_,[],[]).     
calcul_f_liste(GPere, H,[X|ListeNoeuds],[L|NoeudsAvecF]):-
	calcul_f(GPere,H,X,L),
	calcul_f_liste(GPere,H,ListeNoeuds,NoeudsAvecF).

/* calcul_g fonctionne quasiment de la même façon que calcul_f */
	
calcul_g(nd(E1,nd(EPere,GrdPere,GPere,FPere),_,F),Noeud):-
	operateur(_,EPere,E1,Cout),
	GFils is GPere + Cout,
	append([nd(E1,nd(EPere,GrdPere,GPere,FPere),GFils,F)],[],[Noeud]).

/* De même pour calcul_g_liste) */

calcul_g_liste([],[]).
calcul_g_liste([X|ListeNoeuds],[L|NoeudsAvecG]):-
	calcul_g(X,L),
	calcul_g_liste(ListeNoeuds,NoeudsAvecG).

/* complete_liste calcule g et f pour une liste de noeuds pas encore actualisés */

complete_liste(GPere,H,Liste,NSAvecF):-
	calcul_g_liste(Liste,NSAvecG),
	calcul_f_liste(GPere,H,NSAvecG,NSAvecF).
		
/**************Etape 4 : Trouver Fmin dans une liste**************************/

/* Fonctions auxiliaires pour trier uniquement selon la taille croissante de F */

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

/*fmin(+Frontière,-ListeTriée) renvoie les éléments de la frontière triés par valeur croissante de F dans ListeTriée */

fmin([],[]).
fmin([nd(E,P,G,F)|Frontiere],LT) :-
	fmin(Frontiere,_),
	append([nd(E,P,G,F)],Frontiere,[nd(E,P,G,F)|Frontiere]),
	tri_insertion([nd(E,P,G,F)|Frontiere],LT).
	
/************************* **Etape : Algorithme A* *************************
 
rech_A_aux(+Frontière,-NoeudSolution,-DejaDev,+H,-NNA,-NND) correspond à l'algorithme de recherche A sans cycle, on fera un appel initial ensuite. */                                                               

rech_A_aux([nd(Etat,A,B,_)|_],nd(Etat,A,B,_),_,_,NNA,NND,_):-
	NNA is 0,
	NND is 0,                                                                                   /* Si le 1er noeud de la frontière (celui qui est étudié) est le noeud solution, on a atteint le but */
	but(Etat).

rech_A_aux([nd(Etat,Pere,G,F)|ResteFrontière],NoeudSolution,DejaDev,H,NNA,NND,GPere):-                                                       
	\+ memberchk(Etat,DejaDev),
	findall(nd(NEtat, nd(Etat, Pere,G,F),_,_), operateur(_, Etat, NEtat,_), NoeudsSuivants),     /* 1) On cherche tous les sucesseurs du noeud actuel */
	length(NoeudsSuivants,L),
	complete_liste(GPere,H,NoeudsSuivants,NoeudsCompletes),                                      /* 2) On actualise les valeurs de G et F pour ces noeuds */                     
	append(ResteFrontière,NoeudsCompletes,NFrontière),                                           /* 3) On ajoute ces noeuds à la frontière */
	fmin(NFrontière,NFrontièreTriée),                                                            /* 4) On trie la frontière pour avoir le noeud de F minimum en 1er */
	nth1(1,NFrontièreTriée,nd(A,_,_,_)),                                                         /* On récupère son état. */
	operateur(_,Etat,A,Cout),                                                                    /* On regarde si un arc relie ce "meilleur noeud" et notre noeud actuel */
	!,                                                                                           /* 1er cas : si le meilleur noeud et le noeud actuel sont lies */
	NGPere is GPere + Cout, 
	write(NGPere),nl,                                                                    /* Dans ce cas, on actualise le G "courant" avec le nouveau cout */
	rech_A_aux(NFrontièreTriée,NoeudSolution,[Etat|DejaDev],H,NNA2,NND2,NGPere),                 /* Et on recommence la procédure  */      	
	NNA is NNA2+L,                                                                      
	NND is NND2+1.                                                                             /* Tout en actualisant les noeuds apparus et développes  */

rech_A_aux([nd(Etat,Pere,G,F)|ResteFrontière],NoeudSolution,DejaDev,H,NNA,NND,GPere):-                                                       
	\+memberchk(Etat,DejaDev),
	findall(nd(NEtat, nd(Etat, Pere,G,F),_,_), operateur(_, Etat, NEtat,_), NoeudsSuivants),
	length(NoeudsSuivants,L),
	complete_liste(GPere,H,NoeudsSuivants,NoeudsCompletes),
	append(ResteFrontière,NoeudsCompletes,NFrontière),
	fmin(NFrontière,NFrontièreTriée),
	nth1(1,NFrontièreTriée,nd(_,_,Gfils,_)),                                                   /*2eme cas : si on a pas de lien entre le noeud actuel et le futur meilleur noeud */
	NGPere is Gfils,
	write(NGPere),nl,                                                                           /* Alors on actualise le G "courant" en le remplacant par le G du meilleur noeud */
	rech_A_aux(NFrontièreTriée,NoeudSolution,[Etat|DejaDev],H,NNA2,NND2,NGPere),                /* Et on recommence */     	
	NNA is NNA2+L,                                                                      
	NND is NND2+1.

rech_A_aux([_|Frontière],Solution,DejaDev,H,NNA,NND,G):-                                        /* Cas important : si on a pas de noeud en début de frontière : On ignore et on passe au noeud suivant */
     rech_A_aux(Frontière,Solution,DejaDev,H,NNA,NND,G).                                      

/* Fonction test qui a servi maintes fois, sous plusieurs formes durant ce tp... nous lui rendons hommage */
	
/*test(nd(Etat,Pere,Cout,F),GPere,H,NFrontièreTriée,NGPere):-
	findall(nd(NEtat, nd(Etat, Pere,Cout,F),_,_), operateur(_, Etat, NEtat,_), NoeudsSuivants),
	complete_liste(GPere,H,NoeudsSuivants,NoeudsCompletes),
	fmin(NoeudsCompletes,NFrontièreTriée), 
	nth1(1,NFrontièreTriée,nd(_,_,C,_)),
	NGPere is GPere + C.
	
                                               
******************************************************************************************************************/

/* Le prédicat principal.
   rech_A(+Etat,-CheminSolution,-H,-NNA,-NND) renvoie le chemin Solution vers l'état terminal depuis l'état Etat selon l'algorithme A avec l'heuristique H.
*/



rech_A(Etat,CheminSolution,H,NNA,NND):-           
	h(H,Etat,FDepart),                                                      /* On calcule H pour le noeud initial */
	rech_A_aux([nd(Etat,0,0,FDepart)], NoeudSolution,[],H,NNA,NND,0),       /* On applique la recherche avec comme frontière le noeud initial */
     	path(NoeudSolution,CheminSolutionReverse),                              /* Une fois la solution trouvée, on remonte le chemin */
    	reverse(CheminSolutionReverse,CheminSolution).                          /* Path renvoie le chemin dans le mauvais ordre : il faut inverser. */

