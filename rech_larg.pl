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
* 3) Le codage de notre algorithme de recherche en largeur nécessite alors
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
   path(+Noeud,?Chemin,-NNA,-NND) renvoie le chemin depuis Noeud jusqu'au noeud initial.*/
 
path(nd(Etat,0),[Etat]).                                      /* Cas où on est le noeud initial */
path(nd(Etat,nd(X,Pere)),[Etat|NoeudSuivant]) :-              /* On ajoute le père dans le chemin solution sinon */
     path(nd(X,Pere),NoeudSuivant).                           /* On repète le processus pour arriver à NoeudSuivant = 0 */

/*****************************************************************************/

/* La fonction de recherche à la frontière. */
/* rech_larg_aux(+Frontière,-NoeudSolution,+DejaDev,-NNA,-NND) correspond à l'algorithme de recherche en largeur sans cycle, on fera un appel initial ensuite.  */

rech_larg_aux([nd(Etat,Père)|_],nd(Etat,Père),_,NNA,NND):-
	NNA is 0,
	NND is 0,                                                                              /* Si le 1er noeud de la frontière (celui qui est étudié) est le noeud solution, on a atteint le but */
	but(Etat).
	
rech_larg_aux([nd(Etat,Père)|ResteFrontière],NoeudSolution,DejaDev,NNA,NND):-
	\+ memberchk(Etat,DejaDev),                                                            /* On vérifie que le noeud étudié ne soit pas déjà visité */
	findall(nd(NEtat, nd(Etat, Père)), operateur(_, Etat, NEtat), NoeudsSuivants),         /* On regarde tous les prochains noeuds, en appliquant tous les opérateurs possibles au noeud actuel */
	length(NoeudsSuivants,L),
	append(ResteFrontière,NoeudsSuivants,NFrontière),                                      /* On actualise la frontière en rajoutant ces nouveaux éléments */
	rech_larg_aux(NFrontière,NoeudSolution,[Etat|DejaDev],NNA2,NND2),                      /* On répète le processus avec les nouveaux Frontière et DejaDev  */	
	NNA is NNA2+L,                                                                         /* On actualise le nombre de noeuds apparus */
	NND is NND2+1.                                                                         /* On actualise le nombre de noeuds développé */
                    
	
rech_larg_aux([_|Frontière],Solution,DejaDev,NNA,NND):-                                        /* Cas important : si on a pas de noeud en début de frontière : On ignore et on passe au noeud suivant */
     rech_larg_aux(Frontière,Solution,DejaDev,NNA,NND).                                        /* Sans ce cas, on a tout le temps "false" */

/******************************************************************************************************************/

/* Le prédicat principal.
   rech_larg(+Etat,-CheminSolution,-NNA,-NND) renvoie le chemin Solution vers l'état terminal depuis l'état Etat.
*/

	
rech_larg(Etat,CheminSolution,NNA,NND):-           
     rech_larg_aux([nd(Etat,0)], NoeudSolution,[],NNA,NND),          /* On applique la recherche avec comme frontière le noeud initial */
     path(NoeudSolution,CheminSolutionReverse),                      /* Une fois la solution trouvée, on remonte le chemin
     reverse(CheminSolutionReverse,CheminSolution).                  /* Path renvoie le chemin dans le mauvais ordre : il faut inverser. */
                       


