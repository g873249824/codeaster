#@ MODIF algorith2 Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg = {

1 : _(u"""
Erreur utilisateur dans la commande CREA_RESU / AFFE :
 Le maillage associ� au mot cl� CHAM_GD           : %(k1)s
 est diff�rent de celui associ� au mot cl� MODELE : %(k2)s
"""),



3 : _(u"""
 la liste des CHAM_NO n'existe pas
"""),

4 : _(u"""
 il n'y a aucun CHAM_NO dans la liste
"""),

5 : _(u"""
 les CHAM_NO n'ont pas tous la meme longueur
"""),

6 : _(u"""
 il faut d�finir NOM_CMP
"""),

7 : _(u"""
 il faut d�finir 3 angles nautiques.
"""),

8 : _(u"""
 l'origine doit etre d�finie par 3 coordonn�es.
"""),

9 : _(u"""
 l axe z est obligatoire en 3d.
"""),

10 : _(u"""
 pour le 2d, on ne prend que 2 coordonn�es pour l'origine.
"""),

11 : _(u"""
 l axe z est n'a pas de sens en 2d.
"""),

12 : _(u"""
 le noeud se trouve sur l'axe du rep�re cylindrique.
 on prend le noeud moyen des centres g�ometriques.
"""),

13 : _(u"""
  -> Lors du passage au rep�re cylindrique, un noeud a �t� localis� sur l'axe
     du rep�re cylindrique. Code_Aster utilise dans ce cas le centre de gravit� de
     l'�l�ment pour le calcul de la matrice de passage en rep�re cylindrique.
  -> Risque & Conseil :
     Si ce centre de gravit� se trouve �galement sur l'axe du rep�re, le calcul
     s'arrete en erreur fatale.
"""),

14 : _(u"""
 champ %(k1)s non trait� par le changement de rep�re cylindrique
"""),

15 : _(u"""
 les mod�lisations autoris�es sont 3D et D_PLAN et AXIS
"""),

16 : _(u"""
 le choix des param�tres ne correspond pas � l'un des mod�les CJS
"""),

17 : _(u"""
 la loi CJS ne converge pas
"""),

18 : _(u"""
 la loi CJS ne converge pas avec le nombre maximal d'it�rations (int�gration locale)
"""),

20 : _(u"""
 mod�lisation inconnue
"""),

22 : _(u"""
 vecteur de norme nulle
"""),

23 : _(u"""
 la maille doit etre de type TETRA4, TETRA10, PYRAM5, PYRAM10, PENTA6, PENTA15, HEXA8 ou HEXA20.
 or la maille est de type :  %(k1)s .
"""),

24 : _(u"""
 la maille doit etre de type TETRA4, TETRA10, PENTA6, PENTA15, HEXA8 ou HEXA20.
 ou TRIA3-6 ou QUAD4-8
 or la maille est de type :  %(k1)s .
"""),

26 : _(u"""
  %(k1)s  groupe inexistant
"""),

27 : _(u"""
 maille  %(k1)s  de type  %(k2)s  invalide pour le contact
"""),

28 : _(u"""
 groupe de mailles de contact invalide
"""),

29 : _(u"""
 mailles de contact 2d et 3d
"""),

30 : _(u"""
 trois �l�ments
"""),

31 : _(u"""
 deux �l�ments sur la meme face
"""),

33 : _(u"""
 pas de maille de r�f�rence trouv�e
"""),

40 : _(u"""
 ! nombre de sous-domaines illicite !
"""),

41 : _(u"""
 en parall�le, il faut au moins un sous-domaine par processeur !
"""),

42 : _(u"""
 en parall�le, STOGI = OUI obligatoire pour limiter les messages !
"""),

43 : _(u"""
 pas de calcul sur le crit�re de Rice disponible
"""),

44 : _(u"""
 cette commande doit n�cessairement avoir le type EVOL_THER.
"""),

45 : _(u"""
 seuls les champs de fonctions aux noeuds sont �valuables:  %(k1)s
"""),

46 : _(u"""
 nous traitons les champs de r�els et de fonctions: . %(k1)s
"""),

47 : _(u"""
 le nom symbolique du champ � chercher n'est pas licite. %(k1)s
"""),

48 : _(u"""
 plusieurs instants correspondent � celui specifi� sous AFFE
"""),

49 : _(u"""
 NUME_FIN inf�rieur � NUME_INIT
"""),

50 : _(u"""
 CMP non trait�e
"""),

54 : _(u"""
  increment de d�formation cumul�e (dp) = - %(k1)s
"""),

55 : _(u"""
 erreur d'int�gration
 - essai d(integration  numero  %(k1)s
 - convergence vers une solution non conforme
 - incr�ment de d�formation cumul�e n�gative = - %(k2)s
 - red�coupage du pas de temps
"""),

56 : _(u"""
  erreur
  - non convergence � l'it�ration maxi  %(k1)s
  - convergence r�guli�re mais trop lente
  - erreur >  %(k2)s
  - red�coupage du pas de temps
"""),

57 : _(u"""
  erreur
  - non convergence � l'it�ration maxi  %(k1)s
  - convergence irr�guli�re & erreur >  %(k2)s
  - red�coupage du pas de temps
"""),

58 : _(u"""
  erreur
  - non convergence � l'it�ration maxi  %(k1)s
  - erreur >  %(k2)s
  - red�coupage du pas de temps
"""),

59 : _(u"""
  la transformation g�om�trique est singuli�re pour la maille : %(k1)s
  (jacobien = 0.)
"""),

60 : _(u"""
  d�riv�es secondes non �tendues au 3d
"""),

61 : _(u"""
 les listes des groupes de noeuds � fournir doivent contenir le meme nombre de groupes de noeuds
"""),

62 : _(u"""
  les listes des groupes de noeuds doivent contenir le meme nombre de noeuds
"""),

63 : _(u"""
 on n'imprime que des champs r�els
"""),

64 : _(u"""
  %(k1)s cham_no d�j� existant
"""),

65 : _(u"""
 appel erron� a RSEXCH
"""),

66 : _(u"""
 calcul du transitoire : choc en phase transitoire - pas de solution trouv�e.
 utiliser l'option ETAT_STAT = NON
"""),

79 : _(u"""
 pas de valeurs propres trouv�es
"""),


80 : _(u"""
 le champ %(k1)s associ� � la grandeur de type %(k2)s ne peut pas �tre utilis� dans une
 structure de donn�es de type %(k3)s
"""),

}
