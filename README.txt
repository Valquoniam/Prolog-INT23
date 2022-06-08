/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */

/*****************************************************************************
		   Introduction à l'Intelligence Artificielle					 
		   			ENSTA 1ère année - Cours INT23
										
			Ce TP + Devoir est sur la plateforme eCampus 
				
			La partie TP est à     rendre au plus tard le 8/06 à 23h49
			La partie Devoir est à rendre au plus tard le 17/06 à 23h49
				
			Les rendus sont à faire sous la forme d'une archive 
			au format .tgz (exclusivment) dans les devoirs créés à cet effet.

			Les deux membres du binome doivent approuver le rendu effectué.
				
			Commande à utiliser  (sous unix et/ou MacOS)
				
			tar -cvzf  nomArchive.tgz   dossierACompresser
*****************************************************************************/
  
/*****************************************************************************
L'objet de ce TP + Devoir est de coder des algorithmes génériques, non informés 
et informés de résolution de problèmes dans des graphes d'états. 

Nous appliquerons ces algorithmes sur deux familles de problèmes différents 
vus en cours et en td : 
 - le problème des cruches
 - le problème du taquin
*****************************************************************************/


------ Partie 1 : TP Noté : Mise en oeuvre des algorithmes de recherche non informés -----

PARTIE 1.1
    Complétez le fichier "cruches.pl" correspondant à la modélisation 
    de l'univers du problème des cruches.        

PARTIE 1.2
    Complétez le fichier "rech_prof.pl" correspondant à la modélisation 
    des algorithmes de recherche en profondeur      

PARTIE 1.3
    Complétez le fichier "rech_larg.pl" correspondant à la modélisation 
    de l'algorithme de recherche en largeur      



------ Partie 2 : Devoir : Mise en oeuvre des algorithmes de recherche non informés ------

PARTIE 2.1
    Complétez le fichier "rech_A.pl" en codant l'algorithme A*.        

PARTIE 2.2
    Tester votre algorithme sur le problème abstrait vu lors du TD4          

PARTIE 2.3
	- choisir une structure pour représenter un état du taquin
	- coder les fonctions heuristique h1 et h2, correspondant respectivement 
	  au nombre de tuiles mal placées et à la somme des distances de Manhattan
	  des tuiles mal placées.
	- comparer résultats d'A* avec ces deux heuristiques sur différents états de départ,
	  en comptant le nombre noeuds développés et apparus et commentez vos résulats.


------------------------------------------------------------------------------------------
--- Vous pouvez rajouter dans ce fichier des commentaires éventuels sur votre travail ---
------------------------------------------------------------------------------------------

	  