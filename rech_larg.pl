/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */

/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */


/* Nom du binome :    Maugenest - Quoniam-Barre 										 */

/*****************************************************************************
*			      PARTIE 4
*
* L'algorithme de recherche en profondeur s'implémente tres facilement en Prolog
* car la stratégie de preuve mise en oeuvre par le démonstrateur de Prolog
* suit elle même une stratégie en profondeur.
* 
* Le codage de l'algorithme de recherche en largeur est un peu moins direct
* car on a besoin de pouvoir connaitre tous les successeurs d'un état.
*
* Pour cela il existe un prédicat prédéfini en prolog, qui permet de trouver
* toutes les solutions d'un but. Ce prédicat s'appelle findall.
*
******************************************************************************/


/*****************************************************************************
1) lisez la documentation de ce prédicat en tapant help(findall)
     et testez le sur des exemples simples pour bien comprendre comment
     fonctionne ce prédicat.
******************************************************************************/






/*****************************************************************************
* 2) Pour connaître les tous les succeseurs d'un état E il suffira alors 
* d'utiliser :
*      	...
*       findall(NE, operateur(OP,E,NE), Successeurs)
*       ....
*
* > vérifiez cela manuellement sur quelques états des cruches et-ou du taquin
* > nb : à la place de NE, vous pouvez aussi mettre n'importe quel terme qui contient NE.
******************************************************************************/







/*****************************************************************************
* 3) Le codage de notrealgorithme de recherche en profondeur nécessite alors
* de construire le graphe de recherche et sa frontière.
* une façon simple de représenter la structure de ce graphe est de 
* représenter chaque noeud par une structure de la forme : 
*
*      nd(E, Pere) 
* 
* où - E est le état associé au noeud 
*    - Pere est le noeud parent de ce noeud (ou nil si le noeud correspond à le état initial)
* 
* On peut alors représenter la frontière simplement par une liste de noeuds.
* mais pour garantir que la exploration se effectue bien en largeur il faudra bien
* veiller à développer à chaque étape, le noeud le plus ancien parmi ceux de la frontière
* (attention à la façon dont vous rajoutez des noeuds à la frontière).
******************************************************************************/
 
 
 
 
 
 
/*****************************************************************************
* Definir le prédicat :
* rech_larg(+E,-Sol,-NNA,-NND) 
*		qui construit un chemin solution Sol depuis le état E, en construisant le graphe
*        de recherche suivant une stratégie en largeur dabord.
*		-NNA,-NND sont des entiers correspondants respectivement au nombre de noeuds
*		 apparus et développés 
*
* nb : Vous aurez besoin de définir 
*		- une procédure auxiliaire, qui explicite la frontière du graphe et les états déjà
*		- developpés et effectue la recherche
*		- une procédure auxiliaire qui reconstruit le chemin solution lorsqun état but a été atteint.
******************************************************************************/

/* fonction de reconstruction du chemin solution. 
   path(+Noeud,?Solution) renvoie le chemin depuis Noeud jusqu'au noeud initial.*/

path(nd(E,0),[E]).
path(nd(E,nd(X,Pere)),[E|NextNoeud]) :-
     path(nd(X,Pere),NextNoeud).

/* La fonction de recherche à la frontière. */

rech_larg_front([nd(E,PE)|_],nd(E,PE),_):-
     but(E),
     !.
rech_larg_front([nd(E,PE)|F],Sol,V):-
     \+ memberchk(E,V),
     findall(nd(NE, nd(E, PE)), operateur(_, E, NE), NF),
     append(F,NF,NNF),                                         /* On ajoute à la fin de la frontière */
     rech_larg_front(NNF,Sol,[E|V]).

rech_larg_front([_|Front],Sol,V):-
     rech_larg_front(Front,Sol,V).

/* Le prédicat principal.
   rech_larg(+Etat,?Solution) renvoie le chemin Solution vers l'état terminal depuis l'état Etat.
*/

rech_larg(E, [E|[]]):-
     but(E),
     !.
rech_larg(E,S):-
     findall(nd(NE,nd(E,0)), operateur(_,E,NE), F), 
     rech_larg_front(F, PS,[E]),
     path(PS,PPS),
     reverse(PPS,S). /*La fonction path ne inversant pas la suite de noeuds étant construite le
                       plus récent en premier, il faut inverser la liste des états pour avoir les coups à jouer
                       dans le ordre. */


