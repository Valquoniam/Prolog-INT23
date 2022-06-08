/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */


/* Nom du binome :    Maugenest - Quoniam-Barre  										 */

/*****************************************************************************
* On suppose que l'on dispose d'un domaine de problème, caractérisé par 
*
*  - une relation operateur
*  - une relation but
*
* On souhaite coder un algorithme de recherche de chemin solution ne faisant 
* aucune autre hypothèse que celle de la modélisation du domaine du problème
* a l'aide des relations précédentes.
*
* Définir les relations suivantes : 
******************************************************************************/

/*****************************************************************************
* rprof(+Etat,-Solution)	 qui est vrai si et seulement si Solution est une suite
*				   d'états caractérisant un chemin solution depuis Etat
*				                                   vers un état du But.
*/

rprof(Etat,[Etat]):-               /* Si un noeud est terminal, on le renvoie dans but */
	but(Etat). 
rprof(Etat,[Etat|L]):-             /*Si non, il faut aller au noeud suivant : on applique un opérateur*/
	operateur(_,Etat,NEtat),   
	rprof(NEtat,L).            /* On applique la recherche en profondeur au nouvel état */
	
/*******************************************************************************/




/*****************************************************************************
* rprof_ss_cycle(+Etat,-Solution)	           est vrai si et seulement si Solution est 
*		     une suite d'états sans cycle, caractérisant un chemin solution depuis
*		                          Etat vers un état du But. C'est l'appel initial !
*
* rprof_ss_cycle_aux(+Etat,-Solution,+DejaDev)   correspond à l'algorithme de recherche sans cycle, on fera un appel initial ensuite.

******************************************************************************/

rprof_ss_cycle_aux(Etat,[Etat],_):- 
	but(Etat).                                                   /* Si le noeud est terminal, on le renvoie dans but */
rprof_ss_cycle_aux(Etat,[Etat|L],DejaDev):-
	operateur(_,Etat,NEtat),                                     /* Si non, on regarde le successeur */
	\+ memberchk(NEtat,DejaDev),                                 /* On vérifie que NEtat ne soit pas dans DejaDev */   
	rprof_ss_cycle_aux(NEtat, L, [Etat|DejaDev]).        /* On ré-applique la recherche en profondeur en réactualisant DejaDev */
	

rprof_ss_cycle(Etat,Solution):-                                      /* On fait un appel initial */
	rprof_ss_cycle_aux(Etat,Solution,[]).
	
/*****************************************************************************
* Une nouvelle version de ce prédicat permettant de limiter
* la profondeur de recherche.
*  
* rprof_bornee(+Etat,-Solution,+ProfMax)
*       qui est vrai si et seulement si Solution est une suite d'au plus ProfMax
*	  états caractérisant un chemin solution depuis Etat vers un état du But.
******************************************************************************/

/*On raisonne de la meme façon : */

rprof_bornee_aux(Etat,[Etat],_,ProfMax):- 
	ProfMax>0,
	but(Etat).
rprof_bornee_aux(Etat,[Etat|L],DejaDev,ProfMax):-
	ProfMax>0,
	operateur(_,Etat,NEtat),
	\+memberchk(NEtat,DejaDev),
	rprof_bornee_aux(NEtat,L,[Etat|DejaDev],ProfMax-1).
	 

rprof_bornee(Etat,Solution,ProfMax):-
	rprof_bornee_aux(Etat,Solution,[],ProfMax).


/*****************************************************************************
* rprof_incr(+Etat,-Solution,+ProfMax)
*     qui est vrai si et seulement si Solution est une suite d'au plus ProfMax
*	  états caractérisant recherchée suivant une stratégie de recherche itérative
*     à profondeur incrémentale.
******************************************************************************/

/*On raisonne de la meme façon : */

rprof_incr_aux(Etat,Solution,Prof,_) :-                    
	rprof_bornee(Etat,Solution,Prof).              /* On applique rprof_bornée à chaque itération */
rprof_incr_aux(Etat,Solution,Prof,ProfMax) :-
	Prof < ProfMax,
	rprof_incr_aux(Etat,Solution,Prof+1,ProfMax).  /* On utilise un procédé récursif pour répéter les itérations */

rprof_incr(Etat,Solution,ProfMax) :-
	rprof_incr_aux(Etat,Solution,0,ProfMax).       /* On part de la profondeur nulle */
	






