/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */

/* Nom du binome :    Maugenest-Quoniam-Barre    										 */

/*****************************************************************************
                  Introduction à l'Intelligence Artificielle					 
			ENSTA 1ère année - Cours INT23
*****************************************************************************/

/*****************************************************************************
* On considère le domaine de problème correspondant au jeu du taquin sur une
* grille de taille 4x4 et on décide de représenter un état par une structure 
* de la forme :
*  
*     et( A, B, C, D
*         E, F, G, H
*         I, J, K, L,
*         M, N, O, P,
*		   CV        #Case Vide
*		 )
*
* tel que : 
*
* - A,...,P représentent respectivement les contenus des 
*   différentes cases de la grille du taquin, lorsqu'elle est 
*	parcourue de haut en bas et de gauche à droite.
*   ils correspondent à des entiers tous différentes allant de 0 à 15 
*   (où 0 représente la case vide) 
*
* - CV représente le numéro de l'argument correspondant à la case vide 
*
* Exemple :  la grille suivante :
*
*				1   2   3   4  
*				5   6   7   8  
*				9  10  11  12  
*			       13  14  15   0  
*
*     sera représentée par le terme 
*		et(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,16)
*		car la position de la case vide correspond au 16e argument de la structure.
*
*  NB1  : l'information représentée par CV est redondante, mais elle évite d'avoir 
*         à parcourir la structure pour retrouver la position de la case vide
*
*  NB2  : cette représentation n'est pas optimale en terme d'espace
*		 On pourait par exemple représenter
*        la grille par un simple entier sur 64bits (4*16)	
* 		 mais elle est déjà plus économique qu'une simple liste de 16 entiers.		
*******************************************************************************/

/*****************************************************************************
 cons_etat_taquin(?Liste, ?EtatTaquin) est vrai 
				construit un  ?EtatTaquin à partir d'une grille 
				représentée par une simple liste dont les cases sont parcourues
				de gauche à droite  et de haut en bas (et inversement)
				
				mode d'appel (+,?) ou (?,+) 
				Ne vérifie pas que les cases sont bien remplies par des
				entiers entre 0 et 15
******************************************************************************/

cons_etat_taquin(Matrice, EtatTaquin) :-
	Matrice = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],
	EtatTaquin =.. [et,A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P,CV],
	arg(CV,EtatTaquin,0).

/* tests
cons_etat_taquin([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0],E).
cons_etat_taquin([0,2,3,4,5,6,7,8,9,10,11,12,13,14,15,1],E).
cons_etat_taquin([10,2,3,4,5,6,7,8,9,0,11,12,13,14,15,1],E).

cons_etat_taquin(M,et(0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1, 1)).
  ->Renvoie "M=[0,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"

*/ 

/*****************************************************************************
* operateur(?Nom,?Etat,?NEtat) qui est vrai si et seulement si Nom est le nom
*							  d'un opérateur pour le problème du taquin
*							  applicable et permettant de faire passer d'un état
*							  Etat à un nouvel état NEtat.
******************************************************************************/

/* Fonction intermédiaire : remplace(+Liste,+Index,+Valeur,-NListe). remplace la valeur de l'élément d'indice Index 
                                                                     dans Liste avec la valeur Valeur pour créer NListe
                                                                     
******************************************************************************/

remplace([_|T], 0, X, [X|T]).
remplace([H|T], I, X, [H|R]):- 
	I > 0,
	I1 is I-1, 
	remplace(T, I1, X, R).

/********************************************************************/

operateur(up,et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV),Netat):-               /*On monte la case vide */
	cons_etat_taquin(Matrice,et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV)),  /* On travaille sur une matrice par souci de simplicité */
	CV>0,
	CV>4,                                                                              /* Il faut que la case vide soit au moins sur la 2ème ligne */
	Ncv is CV-4,
	nth1(Ncv,Matrice,FutureCaseVide),                                                  /* On note FutureCaseVide la valeur de la case au dessus de la case vide */
	remplace(Matrice,CV-1,FutureCaseVide,NMatrice),                                    /* On inverse cette valeur avec le 0 de la case vide : Attention, on compte à partir de 0*/
	remplace(NMatrice,Ncv-1,0,NNMatrice),
	cons_etat_taquin(NNMatrice,Netat).	                                             /* On renvoie le nouvel état actualisé */
		

operateur(down,et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV),Netat):-             /*On descend la case vide */
	cons_etat_taquin(Matrice,et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV)),  
	CV>0,
	CV<13,                                                                             /* Il faut que la case vide soit avant la dernière ligne */
	Ncv is CV+4,
	nth1(Ncv,Matrice,FutureCaseVide),                                                  /* On note FutureCaseVide la valeur de la case en dessous de la case vide */
	remplace(Matrice,CV-1,FutureCaseVide,NMatrice),                                    
	remplace(NMatrice,Ncv-1,0,NNMatrice),
	cons_etat_taquin(NNMatrice,Netat).	                                             
		
operateur(right,et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV),Netat):-            /* On déplace la case vide à droite */
	cons_etat_taquin(Matrice,et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV)),  
	CV>0,
	\+ CV mod 4 = 0,                                                                   /* Il faut que la case vide soit avant la dernière colonne */
	Ncv is CV+1,
	nth1(Ncv,Matrice,FutureCaseVide),                                                  /* On note FutureCaseVide la valeur de la case à droite de la case vide */
	remplace(Matrice,CV-1,FutureCaseVide,NMatrice),                                    
	remplace(NMatrice,Ncv-1,0,NNMatrice),
	cons_etat_taquin(NNMatrice,Netat).	                                             
		
operateur(left,et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV),Netat):-              /* On déplace la case vide à gauche */
	cons_etat_taquin(Matrice,et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV)),  
	CV>0,
	\+ CV mod 4 = 1,                                                                    /* Il faut que la case vide soit au moins apres la premiere colonne */
	Ncv is CV-1,
	nth1(Ncv,Matrice,FutureCaseVide),                                                   /* On note FutureCaseVide la valeur de la case à gauche de la case vide */
	remplace(Matrice,CV-1,FutureCaseVide,NMatrice),                                    
	remplace(NMatrice,Ncv-1,0,NNMatrice),
	cons_etat_taquin(NNMatrice,Netat).	
	
/*****************************************************************************
* but(Etat)	  qui est vrai si et seulement si Etat est un état but pour 
*                le problème du taquin.
******************************************************************************/

but(et(A, B, C, D, E, F, G, H, I, K ,L, M, N, O, P, Q, CV)):-
	A == 1, B==2,C==3,D==4,E==5,F==6,G==7,H==8,I==9,K==10,
	L==11,M==12,N==13,O==14,P==15,Q==0,
	CV==16.
	
	

/*****************************************************************************
*Avertissement : 
* pour tester vos algorithmes sur le problème du taquin, devez faire attention
* au fait que l'espace d'état est composé de deux parties non connectées.
* Si vous choisissez un état au hasard... il est possible qu'il ne figure pas 
* dans la même composante connexe que votre but... et dans ce cas le problème
* n'aura pas de solution.
*
* Suggestion : implémentez une relation qui à partir de l'état correspondant
* a votre but, applique au hasard des opérateurs un certain nombre de fois
* pour obtenir un état qui se trouve forcément dans la même composantte connexe 
* que votre but.
* 
******************************************************************************/


/*****************************************************************************/

/* On code ici la fonction pour "mélanger" le taquin depuis l'état final. */
/* Ceci est de l'aléatoire "fait main" pour pouvoir tester nos algos de résolution */

randomOperateurs(Etat,0,NEtat):-
	operateur(up,Etat,NEtat).

randomOperateurs(Etat,1,NEtat):-
	operateur(down,Etat,NEtat).
	
randomOperateurs(Etat,2,NEtat):-
	operateur(right,Etat,NEtat).

randomOperateurs(Etat,3,NEtat):-
	operateur(left,Etat,NEtat).
		
etatConnexe(N4Etat):-
	operateur(up,et(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,16),NEtat), /* On monte la case vide */
	operateur(left,NEtat,NNEtat),                                     /* On la déplace à gauche */
	random_member(K,[0,1,2,3]),                                      
	random_member(L,[0,3]),                                           
	randomOperateurs(NNEtat,K,NNNEtat),                               /* On la déplace dans un sens aléatoire */
	randomOperateurs(NNNEtat,L,N4Etat).                               /* On la déplace soit à gauche, soit en haut : 2 seuls sens qui sont applicables. */

/* On a alors 8 états possibles : suffisant pour les tests */

/**** Fonction pour résoludre le taquin depuis l'état connexe ***/
/* resolTaquin(?Solution,NNA,NND) mélange le taquin pseudo-aléatoirement, puis résoud le problème à partir de cet état mélangé. */

resolTaquin(Solution,NNA,NND):-
	etatConnexe(Etat),
	rech_larg(Etat,Solution,NNA,NND).		

	
	

