#@ MODIF xfem Messages  DATE 28/09/2010   AUTEUR MASSIN P.MASSIN 
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
# RESPONSABLE DELMAS J.DELMAS


def _(x) : return x

cata_msg={

1: _("""
  -> Les fissures X-FEM sont surement trop proches.
     Il faut au minimum 2 mailles entre les fissures.
  -> Risque & Conseil:
     Veuillez raffiner le maillage entre les fissures
     (ou �carter les fissures). 
"""),

2: _("""
  -> Le calcul de la distance d'un noeud � l'ellipse n'a pas converg� 
     avec le nombre d'it�rations maximal fix� (10). Cela est d� � une
     ellipse tr�s allong�e.
  -> Conseil:
     Contacter les d�veloppeurs.
     Dans la mesure du possible, d�finissez une ellipse moins allong�e.
"""),


3: _("""
  -> Le mod�le %(k1)s est incompatible avec la m�thode X-FEM.
  -> Risque & Conseil:
     V�rifier qu'il a bien �t� cr�� par l'op�rateur MODI_MODELE_XFEM. 
"""),

4: _("""
  -> Il est interdit de m�langer dans un mod�le les fissures X-FEM 
     avec et sans contact. 
  -> Risque & Conseil:
     Veuillez rajouter les mots cl�s CONTACT manquants 
     dans DEFI_FISS_XFEM.
"""),

5: _("""
  -> Attention, vous avez d�fini un enrichissement g�om�trique sur %(i1)d
     couches d'�l�ments autour du fond de fissure. 
  -> Risque :
     Au del� de 7 couches, il y a des risques de pivots nuls lors de la 
     r�solution dans STAT_NON_LINE.
  -> Conseils :
     Pour �viter ces risques de pivots nuls, il est conseill� de ne pas 
     d�passer NB_COUCHES = 7.
     Vous pouvez aussi laisser NB_COUCHES = %(i1)d, mais il pourra s'av�rer
     n�cessaire d'augmenter le nombre maximales de d�cimales perdues dans 
     STAT_NON_LINE (mot-cl� NPREC de SOLVEUR pour les m�thodes LDLT, MULT_FRONT
     ou FETI.
"""),

6: _("""
  -> Le rayon d'enrichissement RAYON_ENRI doit �tre un r�el strictement 
     sup�rieur � 0.
"""),

7: _("""
     Il y a %(i1)s mailles %(k1)s 
"""),

8: _("""
     Le nombre de %(k1)s X-FEM est limit� � 10E6. 
     Risque & Conseil:
     Veuillez r�duire la taille du maillage.
"""),

9: _("""
     L'option K_G_MODA n'est pas autoris�e avec une fissure d�finie 
     par la commande DEFI_FISS_XFEM (m�thode X-FEM).
"""),

10: _("""
     La direction du champ theta n'a pas �t� donn�e. La direction automatique
     est une direction variable, bas�e sur le grandient de la level set tangente.
"""),

11: _("""
  -> On a trouv� plus de 2 points de fond de fissure, ce qui est impossible en 2D.
  -> Risque & Conseil:
     Cela est normalement caus� par une mauvaise d�finition des level sets.

     Si les level set ont �t� d�finies par DEFI_FISS_XFEM, veuillez revoir leur
     d�finition.

     Si les level sets ont �t� calcul�es par PROPA_FISS, vous pouvez essayer
     d'utiliser un maillage plus raffin� dans toute la zone de propagation ou bien
     une grille auxiliaire.
     Si vous avez utilis� la m�thode simplexe avec restriction de la zone de mise �
     jour des level sets (ZONA_MAJ='TORE'), vous pouvez sp�cifier un rayon plus �lev�
     de celui qui a �t� utilis� (�crit dans le fichier .mess) en utilisant l'op�rande
     RAYON_TORE ou vous pouvez d�activer la restriction de la zone de mise � jour
     (ZONE_MAJ='TOUT').
     Sinon vous pouvez changer la m�thode utilis�e par PROPA_FISS (op�rande
     METHODE_PROPA).
"""),

12: _("""
  Le gradient de la level set tangente est nul au noeud %(k1)s.
  Ceci est certainement du � un point singulier dans la d�finition de la levet set.
  Il vaut veuiller � ce que ce point singulier ne soit pas inclus dans la couronne
  d'int�gration du champ theta. 
  Conseil : r�duisez la taille de la couronne du champ theta : (mot-cl�s RSUP et RINF).
"""),

13: _("""
     Dans le mod�le, des mailles SEG2 ou SEG3 poss�dent des noeuds enrichis par X-FEM.
     Ceci n'est pas encore possible en 3D.
     Conseils : si ces mailles sont importantes pour le calcul (charge lin�ique...), il faut
     les mettre loin de de la fissure.
     Si ces mailles ne servent pas pour le calcul, il vaut mieux ne pas les affecter dans le mod�le,
     ou bien les supprimer du maillage.
"""),

14: _("""
     On ne peut pas appliquer un cisaillement 2d sur les l�vres d'une fissure X-FEM.
"""),

15: _("""
  -> Cette option n'a pas encore �t� programm�e.
  -> Risque & Conseil:
     Veuillez utiliser un autre chargement (en pression) ou contacter votre
     correspondant.
"""),

16: _("""
  -> Il n'y a aucun �l�ment enrichi.
  -> Risque & Conseil:
     - Si vous souhaitez d�finir du contact sur les l�vres de la fissure, il est pr�f�rable
       d'utiliser les mod�lisations 3D, C_PLAN ou D_PLAN afin de b�n�ficier des derni�res 
       avanc�es concernant le contact avec X-FEM.
     - Les mod�lisations 3D_XFEM_CONT, C_PLAN_XFEM_CONT ou D_PLAN_XFEM_CONT sont r�serv�s �
       l'ancienne formulation qui stocke des inconnues de contact aux ar�tes.
       Si vous souhaitez tout de m�me utiliser l'ancienne formulation, le maillage doit �tre
       quadratique afin de stocker les inconnues de contact aux noeuds milieux. Le probl�me
       sera alors trait� avec une interpolation lin�aire.
     - Vous pouvez utilisez l'op�rateur LINE_QUAD pour rendre le maillage quadratique.
"""),

17: _("""
     il ne faut qu'un mot-cl� parmi RAYON_ENRI et NB_COUCHES.
"""),

18: _("""
     Dimension de l'espace incorrecte. 
     Le mod�le doit etre 2D ou 3D et ne pas comporter de sous-structures.
"""),

19: _("""
     Il y a %(i1)s mailles dans la zone fissure. 
"""),

20: _("""
   Le mot-clef ORIE_FOND est indispensable en 3D si vous n'utilisez pas 
   le catalogue des formes de fissure pr�d�finies : FORM_FISS pour d�finir
   les level-sets.
"""),

21: _("""
     Le mot-clef ORIE_FOND n'est pas n�cessaire en 2D.
"""),

22: _("""
     Plus d'une occurrence du mot-clef ORIE_FOND.
"""),

23: _("""
     Erreur dans le choix de la m�thode de calcul des level-sets.
     Vous souhaitez d�finir une %(k1)s.
     Or la forme que vous avez s�lectionn�e < %(k2)s >
     correspond � une %(k3)s.
     Conseil :
     S�lectionnez une forme de %(k1)s.
"""),

24: _("""
     Erreur dans le choix de la m�thode de calcul des level-sets.
     Vous souhaitez d�finir une fissure.
     Pour cela il est n�cessaire de d�finir 2 level sets : LT et LN.
     Conseil :
     Veuillez renseignez %(k1)s.
"""),

25: _("""
     Erreur dans le choix de la m�thode de calcul des level-sets.
     Vous souhaitez d�finir une interface.
     Pour cela il ne faut est pas d�finir la level set normale LT.
     %(k1)s ne sera pas consid�r�.
     Conseil :
     Pour ne plus obtenir ce message, ne renseignez pas %(k1)s.
"""),

26: _("""
     Numeros des mailles de la zone fissure. 
"""),

27: _("""
     Si vous �tes en 3D pour l'approche de contact <<Grands glissements avec XFEM>>,
     seule la formulation aux noeuds sommets est possible.
     Vous pouvez activer cette formulation en commentant LINE_QUAD afin que les mailles
     soient de type HEXA8, PENTA6, PYRAM5 ou TETRA4.
"""),

28: _("""
     Pour un mod�le XFEM avec contact utilisant l'approche Lagranges aux noeuds,
     il est indispensable d'utiliser ALGO_LAG='VERSION1' ou 'VERSION2'. On
     passe outre ALGO_LAG='NON' dans ce cas, et on utilise la version 2.
"""),

29: _("""
     Nombre de mailles contenant le fond de fissure : %(i1)s  
"""),

30: _("""
     Nombre de mailles de type Heaviside : %(i1)s  
"""),

31: _("""
     Nombre de mailles de type Crack-tip : %(i1)s  
"""),

32: _("""
     Nombre de mailles de type Heaviside Crack-tip : %(i1)s  
"""),

33: _("""
     Nombre de points du fond de fissure : %(i1)s  
"""),

34: _("""
     Nombre de fonds de fissure : %(i1)s  
"""),

35: _("""
     Coordonn�es des points des fonds de fissure
"""),

36: _("""
     fond de fissure : %(i1)s  
"""),

37: _("""
     Nombre de level-sets r�ajust�es : %(i1)s  
"""),

38: _("""
     Si vous �tes en 2D pour l'approche de contact <<Grands glissements avec XFEM>>,
     seule la formulation aux noeuds sommets est possible si la fissure poss�de un fond. 
     Vous pouvez activer cette formulation en commentant LINE_QUAD afin que les mailles
     soient de type QUAD4 ou TRIA3.
     
"""),

39: _("""
     Erreur utilisateur : incoh�rence entre les mot-cl�s FISSURE et MODELE_IN.
     Il faut que les (ou la) fissure sous le mot-cl� FISSURE soient toutes d�finies � 
     partir du m�me mod�le.
     Or : 
     - la fissure %(k1)s est d�finie � partir du mod�le %(k2)s
     - le mod�le renseign� sous MODELE_IN est %(k3)s.
     Conseil :
     Veuillez revoir la d�finition de la fissure %(k1)s ou bien changer MODELE_IN.
"""),

40: _("""
      Le mod�le est 3D et la maille %(k1)s est connect�e � 2 fissures,
      le multi-Heaviside n'a pas �t� g�n�ralis� en 3D.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles 
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
 """),


41: _("""
      La maille %(k1)s est quadratique et elle est connect�e � 2 fissures,
      le multi-Heaviside n'a �t� g�n�ralis� en quadratique.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles 
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

42: _("""
      La maille %(k1)s est connect�e � 3 fissures,
      le multi-Heaviside n'a pas �t� g�n�ralis� � plus de 2 fissures.  
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles 
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

43: _("""
      Le contact autre que P1P1 est actif et la maille %(k1)s est connect�e � 2 fissures,
      le multi-Heaviside ne peut pas �tre pris en compte si le contact autre que P1P1 est utilis�.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles 
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

44: _("""
      La maille %(k1)s est connect�e � 2 fissures, or il s'agit d'une maille poss�dant des
      enrichissements de fond de fissure.
      Le multi-Heaviside ne peut pas �tre pris en compte en fond de fissure.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles 
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

45: _("""
      Le contact est normalement actif sur la maille %(k1)s, or cette maille est connect�e �
       2 fissures. Le multi-Heaviside n'a pas �t� g�n�ralis� au contact.
      On d�sactive le contact sur cette maille, ce qui peut conduire � des r�sultats faux.
      Pour ne pas activer le multi-Heaviside, les fissures doivent �tre s�par�es de 2 mailles 
      minimum. Veuillez raffiner le maillage entre les fissures (ou �carter les fissures).
"""),

46: _("""
      Un sous-�l�ment de la maille %(k1)s est d�coup� par 2 fissures diff�rentes,
      L'intersection entre 2 fissures n'a pas encore �t� programm�.
"""),

57: _("""
  -> Aucune maille de fissure n'a �t� trouv�e. 
  -> Risque & Conseil :
     Suite des calculs risqu�e.
"""),

58: _("""
  -> Aucun point du fond de fissure n'a �t� trouv� !
     Cela signifie que le fond de fissure se trouve en dehors de la structure.

  -> Risque & Conseil :
     - Si vous souhaitiez d�finir une interface, il faut choisir TYPE_DISCONTINUITE = 'INTERFACE'
        pour ne plus avoir ce message.
     -  Si vous souhaitiez d�finir une fissure, il doit y avoir une erreur lors de la d�finition 
        de la level set tangente V�rifier la d�finition des level sets.
"""),

59: _("""
     Ne pas utiliser le mot-clef RAYON_ENRI lorsque le fond de fissure
     est en dehors de la structure.
"""),

60: _("""
  -> Le point initial de fissure n'est pas un point de bord de fissure,
     bien que la fissure soit d�bouchante
  -> Risque & Conseil:
     Assurez-vous de la bonne d�finition de PFON_INI.
"""),

61: _("""
  -> Une face contient au moins 3 points d'intersection avec l'iso-z�ro du champ
     de level-set car la valeur des level-sets aux noeuds de la maille a probablement �t�
     mal reactualis�e lors de la phase de r�initialisation ou � la propagation pr�c�dente.
  -> Risque & Conseil:
     Vous pouvez utiliser un maillage plus raffin� ou bien une grille auxiliaire plus
     raffin� du maillage actuel.
     Vous pouvez v�rifier que la zone de mise � jour des level sets est localis� autour du
     fond de la fissure (il ne faut pas utiliser ZONE_MAJ='TOUT' dans PROPA_FISS). Dans ce
     cas, si vous utilisez la m�thode simplexe (METHODE='SIMPLEXE'), vous pouvez essayer
     d'utiliser un rayon de localisation plus �lev� (op�rande RAYON_TORE).
     Si vous utilisez la m�thode simplexe, vous pouvez essayer d'utiliser la m�thode upwind
     qui est plus robuste, stable et performante (METHODE='UPWIND').

     Dans tout le cas, il faut v�rifier que l'angle de propagation de la fissure calcul�e
     par CALC_G a sens physique pour le probl�me � r�soudre.
"""),

63: _("""
  -> ---El�ments XFEM quadratiques 2D---
       Un sous �l�ment est intersect� par l'iso-z�ro de la level set normale en deux endroits
       sur une ar�te.
       Cette configuration est proscrite.
"""),

64: _("""
  -> ---El�ments XFEM quadratiques 2D---
     Le calcul ne peut aboutir pour l'une des raisons suivante :
     - les calculs des coordonn�es des points d'intersection entre un �l�ment et la fissure
       se sont mal d�roul�s
     - l'�l�ment ne peut �tre d�coup� selon la configuration de fissure qui le traverse
"""),

65: _("""
  -> ---El�ments XFEM quadratiques 2D---
     On recherche un point de l'iso-z�ro de la level set normale intersectant l'ar�te
     d'un sous �l�ment qui n'existe pas.
"""),

66: _("""
  -> ---El�ments XFEM quadratiques 2D---
     Le calcul d'abscisse curviligne sur une ar�te quadratique ne peut aboutir pour l'une des
     raisons suivante :
     - les trois points qui d�finissent l'ar�te quadratique sont identiques
     - l'ar�te est "trop" arrondie
"""),

67: _("""
  -> ---El�ments XFEM quadratiques 2D---
     Newton : nombre d'it�rations maximal atteint
"""),

}
