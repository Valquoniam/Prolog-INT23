/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog       */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE                            */

/* Nom du binome :    MAUGENEST - QUONIAM-BARRE   										 */
/*           (TODO : remplacez Nom1 et Nom2 par vos noms dans l'ordre alphabétique) */

/*****************************************************************************
*              Modélisation du domaine du problème des cruches
******************************************************************************/


/*****************************************************************************
* Question 0 :  
*
* Proposer une structure permettant de représenter un état pour le problème
* des cruches (nb il n'y a pas de relation à définir - décrire juste la
* structure que vous comptez utiliser, en précisant le sens de chaque argument)
*
* Réponse : 
*	
* La structure choisie pour représenter un état est une structure cruches(P,G). On utilisera aussi
* comme opératuers : vider_P, vider_G, remplir_P, remplir_G, tranvaser_P, transvaser_G
*
* où... 
*
* p représente la quantité d eau dans la cruche P (la petite) et g la quantité 
* dans la grande cruche G. On a donc p et g compris entre 0 et P ou G.
*         (précisez le rôle des éléments de votre structure, )   
******************************************************************************/



/*****************************************************************************
* Question 1 : Définir un prédicat constructeur-accesseur, permettant de faire
* abstraction de la structure que vous avez choisie (et d'automatiser les test)

* cons_etat_cruche(?P, ?G, ?Etat)  
	qui est vrai si et seulement si Etat correspond au terme
	modélisant un état du domaine des cruches dans lequel 
	- le contenu de la petite cruche est P
	- le contenu de la grande cruche est G
******************************************************************************/
volume_P(5).
volume_G(7).


cons_etat_cruche(P,G,cruches(P,G)).

/*****************************************************************************
* Question 2 : Ecrire le code du prédicat :

* etat_cruche(+Terme)  qui est vrai si et seulement si Terme est un terme prolog
*                      qui représente bien un état pour le problème des cruches.
******************************************************************************/

etat_cruche(cruches(P,G)) :-
	integer(P),
	integer(G),
	P>=0,
	G>=0,
	volume_P(A),
	volume_G(B),
	P=<A,
	G=<B.


/*****************************************************************************
* Question 3 : Définir un prédicat :
* vider_P, vider_G, remplir_P, remplir_G, tranvaser_P, transvaser_G

* operateur(?Nom,?Etat,?NEtat)
					qui est vrai si et seulement si Nom est le nom d'un opérateur 
*					applicable pour le problème des cruches, permettant de  
					passer d'un état Etat à un successeur état NEtat.
******************************************************************************/
operateur(vider_P,cruches(P,G),cruches(0,G)) :-
	etat_cruche(cruches(P,G)),
	P > 0.

operateur(vider_G, cruches(P,G),cruches(P,0)) :-
	etat_cruche(cruches(P,G)),
	G > 0.
	
operateur(remplir_P, cruches(P,G),cruches(Pf,G)) :-
	etat_cruche(cruches(P,G)),
	volume_P(A),
	P < A,
	Pf is A.
	
operateur(remplir_G, cruches(P,G),cruches(P,Gf)) :-
	etat_cruche(cruches(P,G)),
	volume_G(B),
	G < B,
	Gf is B.
	
operateur(transvaser_P, cruches(P,G), cruches(Pf,Gf)) :-
	P>0,
	volume_G(B),
	G < B,
	Pf is max(0,P+G-B),
	Gf is min(G+P,B).
	
operateur(transvaser_G, cruches(P,G), cruches(Pf,Gf)) :-
	G>0,
	volume_P(A),
	P<A,
	Pf is min(P+G,A),
	Gf is max(0,P+G-A).

/*****************************************************************************
* Question 4 : Définir le prédicat : 
* but(?Etat)   qui est vrai si et seulement si Etat est un état but pour 
*              le problème des cruches.
******************************************************************************/
but(cruches(P,G)) :-
	volume_P(A),
	volume_G(B),
	P == A,
	G == B.





