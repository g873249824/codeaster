#@ MODIF modelisa9 Messages  DATE 10/01/2013   AUTEUR LADIER A.LADIER 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg = {

1 : _("""
Erreur utilisateur dans la commande CREA_CHAMP / EXTR / TABLE :
   Dans la table %(k1)s, pour creer un champ de type %(k2)s,
   certains parametres sont obligatoires et d'autres sont interdits :

     NOEU :
       obligatoire : NOEUD
       interdit    : MAILLE, POINT, SOUS_POINT
     ELGA :
       obligatoire : MAILLE, POINT
       interdit    : NOEUD
     ELNO :
       obligatoire : MAILLE, NOEUD (ou POINT)
     ELEM :
       obligatoire : MAILLE
       interdit    : NOEUD, POINT
"""),

2 : _("""
Erreur utilisateur dans la commande CREA_CHAMP / EXTR / TABLE  :
   Les parametres de la table doivent être :
     - soit : MAILLE, NOEUD, POINT, SOUS_POINT
     - soit le nom d'une composante de la grandeur.

   L'une (au moins) des valeurs de la liste : %(ktout)s
   n'est pas le nom d'une composante de la grandeur.

 Conseil :
   Si la table fournie provient de la commande CREA_TABLE / RESU, il faut probablement
   utiliser la commande CALC_TABLE + OPERATION='EXTR' pour éliminer les colonnes RESULTAT, NUME_ORDRE, ....
"""),






5 : _("""
 Erreur utilisateur :
   On cherche à créer un CHAM_ELEM / ELNO à partir d'une table (%(k1)s).
   La maille  %(k2)s a %(i2)d noeuds mais dans la table,
   une ligne concerne un noeud "impossible" :
   noeud de numero local  %(i1)d  ou noeud de nom %(k3)s
"""),

6 : _("""
Erreur utilisateur :
   Plusieurs valeurs dans la table %(k1)s pour :
   Maille: %(k2)s
   Point : %(i1)d  ou Noeud : %(k3)s
   Sous_point : %(i2)d
"""),


8 : _("""
Erreur :
   On cherche à transformer un CHAM_ELEM en carte.
   cham_elem : %(k1)s  carte : %(k2)s
   Pour la maille numéro %(i3)d le nombre de points (ou de sous_points) est > 1
   ce qui est interdit.
   Point:       %(i1)d
   Sous_point : %(i2)d
"""),

9 : _("""
Erreur utilisateur :
   Pour le materiau : %(k1)s, on cherche à redéfinir un mot clé déjà défini : %(k2)s
"""),

10 : _("""
Erreur utilisateur :
   Comportement 'HUJEUX'
   Non convergence pour le calcul de la loi de comportement (NB_ITER_MAX atteint).

Conseil :
   Augmenter NB_ITER_MAX (ou diminuer la taille des incréments de charge)

"""),

11 : _("""
 mocle facteur non traite :mclf %(k1)s
"""),

15 : _("""
 pas de freq initiale definie : on prend la freq mini des modes calcules
   %(r1)f
"""),

16 : _("""
 pas de freq finale definie : on prend la freq max des modes calcules   %(r1)f
"""),

17 : _("""
 votre freq de coupure   %(r1)f
"""),

18 : _("""
 est inferieure a celle  du modele de turbulence adopte :  %(r1)f
"""),

19 : _("""
 on prend la votre.
"""),

20 : _("""
 votre freq de coupure :   %(r1)f
"""),

21 : _("""
 est superieure a celle  du modele de turbulence adopte :   %(r1)f
"""),

22 : _("""
 on prend celle du modele.
"""),

23 : _("""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
"""),

24 : _("""
 le maillage est "plan" ou "z_cst"
"""),

25 : _("""
 le maillage est "3d"
"""),

26 : _("""
 il y a  %(i1)d  valeurs pour le mot cle  %(k1)s il en faut  %(i2)d
"""),

27 : _("""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
 pour le mot cle  %(k2)s
  le noeud n'existe pas  %(k3)s
"""),

28 : _("""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
 pour le mot cle  %(k2)s
  le GROUP_NO n'existe pas  %(k3)s
"""),

29 : _("""
 trop de noeuds dans le GROUP_NO mot cle facteur  %(k1)s  occurrence  %(i1)d
   noeud utilise:  %(k2)s
"""),

31 : _("""
 poutre : occurrence %(i2)d :
 "cara" nombre de valeurs entrees:  %(i2)d
 "vale" nombre de valeurs entrees:  %(i3)d
 verifier vos donnees

"""),

32 : _("""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
"""),



35 : _("""
 il y a  %(i1)d  valeurs pour le mot cle  ANGL_NAUT il en faut  %(i2)d
"""),

36 : _("""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
"""),

39 : _("""
 il y a  %(i1)d  valeurs pour le mot cle  %(k1)s il en faut  %(i2)d
"""),

40 : _("""
 erreur dans les donnees mot cle facteur  %(k1)s  occurrence  %(i1)d
"""),

43 : _("""
 il y a  %(i1)d  valeurs pour le mot cle  %(k1)s il en faut  %(i2)d
"""),

44 : _("""
 fichier med :  %(k1)s maillage :  %(k2)s erreur effoco numero  %(i1)d
"""),

51 : _("""
 fichier med :  %(k1)s maillage :  %(k2)s erreur efouvr numero  %(i1)d
"""),

52 : _("""
 fichier med :  %(k1)s maillage :  %(k2)s erreur efferm numero  %(i1)d
"""),

53 : _("""

 l'identifiant d'une maille depasse les 8 caracteres autorises:
   %(k1)s
 maille      : %(k2)s
 pref_maille : %(k3)s
"""),

54 : _("""
 l'utilisation de 'pref_nume' est recommandee.
"""),

55 : _("""
 comportement : %(k1)s non trouve
"""),

56 : _("""
 pour la maille  %(k1)s
"""),

59 : _("""
 erreur lors de la definition de la courbe de traction : %(k1)s
 le premier point de la courbe de traction %(k2)s a pour abscisse:  %(r1)f

"""),

60 : _("""
 erreur lors de la definition de la courbe de traction :%(k1)s
 le premier point de la courbe de traction %(k2)s a pour ordonnee:  %(r1)f

"""),

61 : _("""
 Erreur lors de la definition de la courbe de traction : %(k1)s

 la courbe de traction doit satisfaire les conditions suivantes :
 - les abscisses (deformations) doivent etre strictement croissantes,
 - la pente entre 2 points successifs doit etre inferieure a la pente
   elastique (module d'Young) entre 0 et le premier point de la courbe.

 pente initiale (module d'Young) :   %(r1)f
 pente courante                  :   %(r2)f
 pour l'abscisse                 :   %(r3)f

"""),

62 : _("""
 Courbe de traction : %(k1)s points presques alignés. Risque de PB dans STAT_NON_LINE
 en particulier en C_PLAN
  pente initiale :     %(r1)f
  pente courante:      %(r2)f
  precision relative:  %(r3)f
  pour l'abscisse:     %(r4)f

"""),

63 : _("""
 erreur lors de la definition de la courbe de traction %(k1)s
 le premier point de la fonction indicee par :  %(i1)d de la nappe  %(k2)s
 a pour abscisse:  %(r1)f

"""),

64 : _("""
 erreur lors de la definition de la courbe de traction %(k1)s
 le premier point de la fonction indicee par :  %(i1)d de la nappe  %(k2)s
 a pour ordonnee:  %(r1)f

"""),

65 : _("""
 erreur lors de la definition de la courbe de traction %(k1)s
 pente initiale :   %(r1)f
 pente courante:    %(r2)f
 pour l'abscisse:  %(r3)f

"""),

73 : _("""
 erreur de programmation type de fonction non valide %(k1)s
"""),

74 : _("""
 comportement :%(k1)s non trouvé
"""),

75 : _("""
 comportement %(k1)s non trouvé pour la maille  %(k2)s
"""),

77 : _("""
 manque le parametre  %(k1)s
"""),

78 : _("""
 pour la maille  %(k1)s
"""),

80 : _("""
  Noeud sur l'axe Z
"""),

81 : _("""
  La maille de nom %(k1)s n'est pas de type SEG3 ou SEG4,
  elle ne sera pas affectée par %(k2)s
"""),

82 : _("""
  GROUP_MA : %(k1)s
"""),

83 : _("""
  Erreur a l'interpolation, paramètres non trouvé.
"""),

93 : _("""
ERREUR EUROPLEXUS
   Toutes les occurrences de RIGI_PARASOL doivent avoir la même valeur pour le mot
   clef EUROPLEXUS. La valeur du mot clef EUROPLEXUS à l'occurrence %(i1)d est différente
   de sa valeur à l'occurrence numéro 1.
"""),

94 : _("""
     On ne peut pas appliquer un cisaillement 2d sur une modélisation 3D
"""),
95 : _("""
     ERREUR: l'auto-spectre est a valeurs négatives
"""),
96 : _("""
EUROPLEXUS
   EUROPLEXUS ne gère pas les MAILLES, mais seulement les POINTS.
   Le problème vient de la maille %(k1)s.
"""),

97 : _("""
ERREUR EUROPLEXUS
   Données incorrectes. Les dimensions des objets ne sont pas cohérentes (Erreur Fortran : acearp)
"""),

98 : _("""
ERREUR EUROPLEXUS
   Pour accéder aux valeurs nécessaires à EUROPLEXUS, il faut que dans la commande AFFE_CARA_ELEM,
   pour le mot clef facteur RIGI_PARASOL, la valeur du mot clef EUROPLEXUS soit 'OUI' dans
   toutes les occurrences.
"""),

99 : _("""
Le vecteur définissant l'axe de rotation a une composante nulle suivant Oz.
Avec une modélisation C_PLAN ou D_PLAN, l'axe de rotation doit être dirigé suivant Oz.
"""),

}
