#@ MODIF algorith2 Messages  DATE 22/09/2008   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
# (AT YOUR OPTION) ANY LATER VERSION.                                                  
#                                                                       
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
#                                                                       
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.        
# ======================================================================

def _(x) : return x

cata_msg = {

3 : _("""
 la liste des CHAM_NO n'existe pas
"""),

4 : _("""
 il n'y a aucun CHAM_NO dans la liste
"""),

5 : _("""
 les CHAM_NO n'ont pas tous la meme longueur
"""),

6 : _("""
 il faut d�finir NOM_CMP
"""),

7 : _("""
 il faut d�finir 3 angles nautiques.
"""),

8 : _("""
 l'origine doit etre d�finie par 3 coordonn�es.
"""),

9 : _("""
 l axe z est obligatoire en 3d.
"""),

10 : _("""
 pour le 2d, on ne prend que 2 coordonn�es pour l'origine.
"""),

11 : _("""
 l axe z est n'a pas de sens en 2d.
"""),

12 : _("""
 le noeud se trouve sur l'axe du rep�re cylindrique.
 on prend le noeud moyen des centres g�ometriques.
"""),

13 : _("""
  -> Lors du passage au rep�re cylindrique, un noeud a �t� localis� sur l'axe
     du rep�re cylindrique. Code_Aster utilise dans ce cas le centre de gravit� de
     l'�l�ment pour le calcul de la matrice de passage en rep�re cylindrique.
  -> Risque & Conseil :
     Si ce centre de gravit� se trouve �galement sur l'axe du rep�re, le calcul
     s'arrete en erreur fatale.
"""),

15 : _("""
 les mod�lisations autoris�es sont 3D et D_PLAN et AXIS
"""),

16 : _("""
 le choix des param�tres ne correspond pas � l'un des mod�les CJS
"""),

17 : _("""
 la loi CJS ne converge pas
"""),

18 : _("""
 la loi CJS ne converge pas avec le nombre maximal d'it�rations (int�gration locale)
"""),

20 : _("""
 mod�lisation inconnue
"""),

22 : _("""
 vecteur de norme nulle
"""),

23 : _("""
 la maille doit etre de type TETRA4, TETRA10, PENTA6, PENTA15, HEXA8 ou HEXA20.
 or la maille est de type :  %(k1)s .
"""),

24 : _("""
 la maille doit etre de type TETRA4, TETRA10, PENTA6, PENTA15, HEXA8 ou HEXA20.
 ou TRIA3-6 ou QUAD4-8
 or la maille est de type :  %(k1)s .
"""),

26 : _("""
  %(k1)s  groupe inexistant
"""),

27 : _("""
 maille  %(k1)s  de type  %(k2)s  invalide pour le contact
"""),

28 : _("""
 groupe de mailles de contact invalide
"""),

29 : _("""
 mailles de contact 2d et 3d
"""),

30 : _("""
 trois �l�ments
"""),

31 : _("""
 deux �l�ments sur la meme face
"""),

33 : _("""
 pas de maille de r�f�rence trouv�e
"""),

35 : _("""
 la m�thode  %(k1)s  est inad�quate pour une r�solution de type "LDLT"
"""),

36 : _("""
 la m�thode  %(k1)s  est inad�quate pour une r�solution de type "GCPC"
"""),

37 : _("""
 la methode  %(k1)s  est inad�quate pour une r�solution de type "MULT_FRONT"
"""),

38 : _("""
 la m�thode  %(k1)s  est inad�quate pour une r�solution de type "FETI"
"""),

39 : _("""
 le solveur FETI requiert un concept produit de type SD_FETI en entr�e du mot-cl� PARTITION
"""),

40 : _("""
 ! nombre de sous-domaines illicite !
"""),

41 : _("""
 en parall�le, il faut au moins un sous-domaine par processeur !
"""),

42 : _("""
 en parall�le, STOGI = OUI obligatoire pour limiter les messages !
"""),

43 : _("""
 pas de calcul sur le crit�re de Rice disponible
"""),

44 : _("""
 cette commande doit n�cessairement avoir le type EVOL_THER.
"""),

45 : _("""
 seuls les champs de fonctions aux noeuds sont �valuables:  %(k1)s
"""),

46 : _("""
 nous traitons les champs de r�els et de fonctions: . %(k1)s
"""),

47 : _("""
 le nom symbolique du champ � chercher n'est pas licite. %(k1)s
"""),

48 : _("""
 plusieurs instants correspondent � celui specifi� sous AFFE
"""),

49 : _("""
 NUME_FIN inf�rieur � NUME_INIT
"""),

50 : _("""
 CMP non trait�e
"""),

54 : _("""
  increment de d�formation cumul�e (dp) = - %(k1)s
"""),

55 : _("""
 erreur d'int�gration
 - essai d(integration  numero  %(k1)s 
 - convergence vers une solution non conforme
 - incr�ment de d�formation cumul�e n�gative = - %(k2)s
 - red�coupage du pas de temps
"""),

56 : _("""
  erreur 
  - non convergence � l'it�ration maxi  %(k1)s  
  - convergence r�guli�re mais trop lente 
  - erreur >  %(k2)s 
  - red�coupage du pas de temps
"""),

57 : _("""
  erreur
  - non convergence � l'it�ration maxi  %(k1)s 
  - convergence irr�guli�re & erreur >  %(k2)s 
  - red�coupage du pas de temps
"""),

58 : _("""
  erreur
  - non convergence � l'it�ration maxi  %(k1)s 
  - erreur >  %(k2)s 
  - red�coupage du pas de temps
"""),

59 : _("""
  la transformation g�om�trique est singuli�re pour la maille : %(k1)s
  (jacobien = 0.)
"""),

60 : _("""
  d�riv�es secondes non �tendues au 3d
"""),

61 : _("""
 les listes des groupes de noeuds � fournir doivent contenir le meme nombre de groupes de noeuds
"""),

62 : _("""
  les listes des groupes de noeuds doivent contenir le meme nombre de noeuds
"""),

63 : _("""
 on n'imprime que des champs r�els
"""),

64 : _("""
  %(k1)s cham_no d�j� existant
"""),

65 : _("""
 appel erron� a RSEXCH
"""),

66 : _("""
 calcul du transitoire : choc en phase transitoire - pas de solution trouv�e.
 utiliser l'option ETAT_STAT = NON
"""),

79 : _("""
 pas de valeurs propres trouv�es
"""),

}
