#@ MODIF modelisa9 Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
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
Erreur utilisateur :
   Il manque le parametre  %(k1)s dans la table %(k2)s.
   Sa presence est indispensable � la  creation d'un champ elementaire. %(k3)s
"""),

2 : _(u"""
Erreur utilisateur :
   Le parametre  %(k1)s de la table %(k2)s
   est interdit pour la  creation d'un  champ elementaire constant. %(k3)s
"""),

3 : _(u"""
Erreur utilisateur :
   Il manque le parametre  %(k1)s dans la table %(k2)s.
   Sa presence est indispensable � la  creation d'un champ  %(k3)s
"""),







5 : _(u"""
 Erreur utilisateur :
   On cherche � cr�er un cham_elem / ELNO � partir d'une table (%(k1)s).
   La maille  %(k2)s a %(i2)d noeuds mais dans la table, une ligne concerne le noeud num�ro %(i1)d
"""),

6 : _(u"""
Erreur utilisateur :
   Plusieurs valeurs dans la table %(k1)s pour :
   Maille: %(k2)s
   Point : %(i1)d
   Sous_point : %(i2)d
"""),

7 : _(u"""
Erreur utilisateur :
   Plusieurs valeurs dans la table %(k1)s pour :
   Maille: %(k2)s
   Sous_point : %(i1)d
"""),

8 : _(u"""
Erreur :
   On cherche � transformer un cham_elem en carte.
   cham_elem : %(k1)s  carte : %(k2)s
   Pour la maille num�ro %(i3)d le nombre de points (ou de sous_points) est > 1
   ce qui est interdit.
   Point:       %(i1)d
   Sous_point : %(i2)d
"""),

9 : _(u"""
Erreur utilisateur :
   Pour le materiau : %(k1)s, on cherche � red�finir un mot cl� d�j� d�fini : %(k2)s
"""),

10 : _(u"""
Erreur utilisateur :
   Comportement 'HUJEUX'
   Non convergence pour le calcul de la loi de comportement (NB_ITER_MAX atteint).

Conseil :
   Augmenter NB_ITER_MAX (ou diminuer la taille des incr�ments de charge)

"""),

11 : _(u"""
 mocle facteur non traite :mclf %(k1)s
"""),

15 : _(u"""
 pas de freq initiale definie : on prend la freq mini des modes calcules
   %(r1)f
"""),

16 : _(u"""
 pas de freq finale definie : on prend la freq max des modes calcules   %(r1)f
"""),

17 : _(u"""
 votre freq de coupure   %(r1)f
"""),

18 : _(u"""
 est inferieure a celle  du modele de turbulence adopte :  %(r1)f
"""),

19 : _(u"""
 on prend la votre.
"""),

20 : _(u"""
 votre freq de coupure :   %(r1)f
"""),

21 : _(u"""
 est superieure a celle  du modele de turbulence adopte :   %(r1)f
"""),

22 : _(u"""
 on prend celle du modele.
"""),

23 : _(u"""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
"""),

24 : _(u"""
 le maillage est "plan" ou "z_cst"
"""),

25 : _(u"""
 le maillage est "3d"
"""),

26 : _(u"""
 il y a  %(i1)d  valeurs pour le mot cle  %(k1)s il en faut  %(i2)d
"""),

27 : _(u"""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
 pour le mot cle  %(k2)s
  le noeud n'existe pas  %(k3)s
"""),

28 : _(u"""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
 pour le mot cle  %(k2)s
  le GROUP_NO n'existe pas  %(k3)s
"""),

29 : _(u"""
 trop de noeuds dans le GROUP_NO mot cle facteur  %(k1)s  occurrence  %(i1)d
   noeud utilise:  %(k2)s
"""),

31 : _(u"""
 poutre : occurrence %(i2)d :
 "cara" nombre de valeurs entrees:  %(i2)d
 "vale" nombre de valeurs entrees:  %(i3)d
 verifier vos donnees

"""),

32 : _(u"""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
"""),

33 : _(u"""
Erreur utilisateur (cr�ation d'un cham_elem � partir d'une table):
   Le num�ro du point ou du SOUS_POINT est en dehors des limites autoris�es
   Table : %(k1)s
   Maille: %(k2)s
   Point : %(i1)d
   SOUS_POINT : %(i2)d
"""),

35 : _(u"""
 il y a  %(i1)d  valeurs pour le mot cle  ANGL_NAUT il en faut  %(i2)d
"""),

36 : _(u"""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
"""),

39 : _(u"""
 il y a  %(i1)d  valeurs pour le mot cle  %(k1)s il en faut  %(i2)d
"""),

40 : _(u"""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
"""),

43 : _(u"""
 il y a  %(i1)d  valeurs pour le mot cle  %(k1)s il en faut  %(i2)d
"""),

44 : _(u"""
 fichier med :  %(k1)s maillage :  %(k2)s erreur effoco numero  %(i1)d
"""),

51 : _(u"""
 fichier med :  %(k1)s maillage :  %(k2)s erreur efouvr numero  %(i1)d
"""),

52 : _(u"""
 fichier med :  %(k1)s maillage :  %(k2)s erreur efferm numero  %(i1)d
"""),

53 : _(u"""

 l'identifiant d'une maille depasse les 8 caracteres autorises:
   %(k1)s
 maille      : %(k2)s
 pref_maille : %(k3)s
"""),

54 : _(u"""
 l'utilisation de 'pref_nume' est recommandee.
"""),

55 : _(u"""
 comportement : %(k1)s non trouve
"""),

56 : _(u"""
 pour la maille  %(k1)s
"""),

59 : _(u"""
 erreur lors de la definition de la courbe de traction : %(k1)s
 le premier point de la courbe de traction %(k2)s a pour abscisse:  %(r1)f

"""),

60 : _(u"""
 erreur lors de la definition de la courbe de traction :%(k1)s
 le premier point de la courbe de traction %(k2)s a pour ordonnee:  %(r1)f

"""),

61 : _(u"""
 Erreur lors de la definition de la courbe de traction : %(k1)s

 la courbe de traction doit satisfaire les conditions suivantes :
 - les abscisses (deformations) doivent etre strictement croissantes,
 - la pente entre 2 points successifs doit etre inferieure a la pente
   elastique (module d'Young) entre 0 et le premier point de la courbe.

 pente initiale (module d'Young) :   %(r1)f
 pente courante                  :   %(r2)f
 pour l'abscisse                 :   %(r3)f

"""),

62 : _(u"""
 Courbe de traction : %(k1)s points presques align�s. Risque de PB dans STAT_NON_LINE
 en particulier en C_PLAN
  pente initiale :     %(r1)f
  pente courante:      %(r2)f
  precision relative:  %(r3)f
  pour l'abscisse:     %(r4)f

"""),

63 : _(u"""
 erreur lors de la definition de la courbe de traction %(k1)s
 le premier point de la fonction indicee par :  %(i1)d de la nappe  %(k2)s
 a pour abscisse:  %(r1)f

"""),

64 : _(u"""
 erreur lors de la definition de la courbe de traction %(k1)s
 le premier point de la fonction indicee par :  %(i1)d de la nappe  %(k2)s
 a pour ordonnee:  %(r1)f

"""),

65 : _(u"""
 erreur lors de la definition de la courbe de traction %(k1)s
 pente initiale :   %(r1)f
 pente courante:    %(r2)f
 pour l'abscisse:  %(r3)f

"""),

73 : _(u"""
 erreur de programmation type de fonction non valide %(k1)s
"""),

74 : _(u"""
 comportement :%(k1)s non trouv�
"""),

75 : _(u"""
 comportement %(k1)s non trouv� pour la maille  %(k2)s
"""),

77 : _(u"""
 manque le parametre  %(k1)s
"""),

78 : _(u"""
 pour la maille  %(k1)s
"""),

80 : _(u"""
  Noeud sur l'axe Z
"""),

81 : _(u"""
  La maille de nom %(k1)s n'est pas de type SEG3 ou SEG4,
  elle ne sera pas affect�e par %(k2)s
"""),

82 : _(u"""
  GROUP_MA : %(k1)s
"""),

83 : _(u"""
  Erreur a l'interpolation, param�tres non trouv�.
"""),

93 : _(u"""
ERREUR EUROPLEXUS
   Toutes les occurrences de RIGI_PARASOL doivent avoir la m�me valeur pour le mot
   clef EUROPLEXUS. La valeur du mot clef EUROPLEXUS � l'occurrence %(i1)d est diff�rente
   de sa valeur � l'occurrence num�ro 1.
"""),

94 : _(u"""
     On ne peut pas appliquer un cisaillement 2d sur une mod�lisation 3D
"""),
95 : _(u"""
     ERREUR: l'auto-spectre est a valeurs n�gatives
"""),
96 : _(u"""
EUROPLEXUS
   EUROPLEXUS ne g�re pas les MAILLES, mais seulement les POINTS.
   Le probl�me vient de la maille %(k1)s.
"""),

97 : _(u"""
ERREUR EUROPLEXUS
   Donn�es incorrectes. Les dimensions des objets ne sont pas coh�rentes (Erreur Fortran : acearp)
"""),

98 : _(u"""
ERREUR EUROPLEXUS
   Pour acc�der aux valeurs n�cessaires � EUROPLEXUS, il faut que dans la commande AFFE_CARA_ELEM,
   pour le mot clef facteur RIGI_PARASOL, la valeur du mot clef EUROPLEXUS soit 'OUI' dans
   toutes les occurrences.
"""),

99 : _(u"""
Le vecteur d�finissant l'axe de rotation a une composante nulle suivant Oz.
Avec une mod�lisation C_PLAN ou D_PLAN, l'axe de rotation doit �tre dirig� suivant Oz.
"""),

}
