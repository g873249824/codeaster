# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {
1 : _(u"""
Erreur utilisateur dans la commande CREA_CHAMP / EXTR / TABLE :
   Dans la table %(k1)s, pour cr�er un champ de type %(k2)s,
   certains param�tres sont obligatoires et d'autres sont interdits :

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

2 : _(u"""
 Erreur utilisateur dans la commande CREA_CHAMP / EXTR / TABLE  :
   Les param�tres de la table doivent �tre :
     - soit : MAILLE, NOEUD, POINT, SOUS_POINT
     - soit le nom d'une composante de la grandeur.

   L'une (au moins) des valeurs de la liste : %(ktout)s
   n'est pas le nom d'une composante de la grandeur.

 Conseil :
   Si la table fournie provient de la commande CREA_TABLE / RESU, il faut probablement
   utiliser la commande CALC_TABLE + OPERATION='EXTR' pour �liminer les colonnes RESULTAT, NUME_ORDRE, ....
"""),







5 : _(u"""
 Erreur utilisateur :
   On cherche � cr�er un CHAM_ELEM / ELNO � partir d'une table (%(k1)s).
   La maille  %(k2)s a %(i2)d noeuds mais dans la table,
   une ligne concerne un noeud "impossible" :
   noeud de num�ro local  %(i1)d  ou noeud de nom %(k3)s
"""),

6 : _(u"""
Erreur utilisateur :
   Plusieurs valeurs dans la table %(k1)s pour :
   Maille: %(k2)s
   Point : %(i1)d  ou Noeud : %(k3)s
   Sous-point : %(i2)d
"""),




8 : _(u"""
Erreur :
   On cherche � transformer un CHAM_ELEM en carte.
   CHAM_ELEM : %(k1)s  carte : %(k2)s
   Pour la maille num�ro %(i3)d le nombre de points (ou de sous-points) est > 1
   ce qui est interdit.
   Point:       %(i1)d
   Sous-point : %(i2)d
"""),

9 : _(u"""
Erreur utilisateur :
   Pour le mat�riau : %(k1)s, on cherche � red�finir un mot cl� d�j� d�fini : %(k2)s
"""),

10 : _(u"""
Erreur utilisateur :
   Comportement 'HUJEUX'
   Non convergence pour le calcul de la loi de comportement (NB_ITER_MAX atteint).

Conseil :
   Augmenter NB_ITER_MAX (ou diminuer la taille des incr�ments de charge)

"""),

11 : _(u"""
 mot-cl� facteur non traite :  %(k1)s
"""),

15 : _(u"""
 pas de FREQ initiale d�finie : on prend la fr�quence mini des modes calcules
   %(r1)f
"""),

16 : _(u"""
 pas de fr�quence finale d�finie : on prend la fr�quence max des modes calcules   %(r1)f
"""),

17 : _(u"""
 votre fr�quence de coupure   %(r1)f
"""),

18 : _(u"""
 est inf�rieure a celle  du mod�le de turbulence adopte :  %(r1)f
"""),

19 : _(u"""
 on prend la votre.
"""),

20 : _(u"""
 votre fr�quence de coupure :   %(r1)f
"""),

21 : _(u"""
 est sup�rieure a celle  du mod�le de turbulence adopte :   %(r1)f
"""),

22 : _(u"""
 on prend celle du mod�le.
"""),

23 : _(u"""
 erreur dans les donn�es mot cl� facteur  %(k1)s  occurrence  %(i1)d
"""),

24 : _(u"""
 le maillage est "plan" ou "z_CSTE"
"""),

25 : _(u"""
 le maillage est "3d"
"""),

26 : _(u"""
 il y a  %(i1)d  valeurs pour le mot cl�  %(k1)s il en faut  %(i2)d
"""),

27 : _(u"""
 erreur dans les donn�es mot cl� facteur  %(k1)s  occurrence  %(i1)d
 pour le mot cl�  %(k2)s
  le noeud n'existe pas  %(k3)s
"""),

28 : _(u"""
 erreur dans les donn�es mot cl� facteur  %(k1)s  occurrence  %(i1)d
 pour le mot cl�  %(k2)s
  le GROUP_NO n'existe pas  %(k3)s
"""),

29 : _(u"""
 trop de noeuds dans le GROUP_NO mot cl� facteur  %(k1)s  occurrence  %(i1)d
   noeud utilise:  %(k2)s
"""),

31 : _(u"""
 poutre : occurrence %(i2)d :
 "CARA" nombre de valeurs entr�es:  %(i2)d
 "VALE" nombre de valeurs entr�es:  %(i3)d
 v�rifiez vos donn�es

"""),

32 : _(u"""
 erreur dans les donn�es mot cl� facteur  %(k1)s  occurrence  %(i1)d
"""),





35 : _(u"""
 il y a  %(i1)d  valeurs pour le mot cl�  ANGL_NAUT il en faut  %(i2)d
"""),

36 : _(u"""
 erreur dans les donn�es mot cl� facteur  %(k1)s  occurrence  %(i1)d
"""),

39 : _(u"""
 il y a  %(i1)d  valeurs pour le mot cl�  %(k1)s il en faut  %(i2)d
"""),

40 : _(u"""
 erreur dans les donn�es mot cl� facteur  %(k1)s  occurrence  %(i1)d
"""),

43 : _(u"""
 il y a  %(i1)d  valeurs pour le mot cl�  %(k1)s il en faut  %(i2)d
"""),

44 : _(u"""
 fichier MED :  %(k1)s maillage :  %(k2)s erreur effoco num�ro  %(i1)d
"""),

51 : _(u"""
 fichier MED :  %(k1)s maillage :  %(k2)s erreur efouvr num�ro  %(i1)d
"""),

52 : _(u"""
 fichier MED :  %(k1)s maillage :  %(k2)s erreur efferm num�ro  %(i1)d
"""),

53 : _(u"""

 l'identifiant d'une maille d�passe les 8 caract�res autoris�s:
   %(k1)s
 maille      : %(k2)s
 PREF_MAILLE : %(k3)s
"""),

54 : _(u"""
 l'utilisation de 'PREF_NUME' est recommand�e.
"""),

55 : _(u"""
 comportement : %(k1)s non trouve
"""),

56 : _(u"""
 pour la maille  %(k1)s
"""),

59 : _(u"""
 erreur lors de la d�finition de la courbe de traction : %(k1)s
 le premier point de la courbe de traction %(k2)s a pour abscisse:  %(r1)f

"""),

60 : _(u"""
 erreur lors de la d�finition de la courbe de traction :%(k1)s
 le premier point de la courbe de traction %(k2)s a pour ordonn�e:  %(r1)f

"""),

61 : _(u"""
 Erreur lors de la d�finition de la courbe de traction : %(k1)s

 la courbe de traction doit satisfaire les conditions suivantes :
 - les abscisses (d�formations) doivent �tre strictement croissantes,
 - la pente entre 2 points successifs doit �tre inf�rieure a la pente
   �lastique (module de Young) entre 0 et le premier point de la courbe.

 pente initiale (module de Young) :   %(r1)f
 pente courante                  :   %(r2)f
 pour l'abscisse                 :   %(r3)f

"""),

62 : _(u"""
 Courbe de traction : %(k1)s points presque align�s. Risque de PB dans STAT_NON_LINE
 en particulier en C_PLAN
  pente initiale :     %(r1)f
  pente courante:      %(r2)f
  pr�cision relative:  %(r3)f
  pour l'abscisse:     %(r4)f

"""),

63 : _(u"""
 erreur lors de la d�finition de la courbe de traction %(k1)s
 le premier point de la fonction indic�e par :  %(i1)d de la nappe  %(k2)s
 a pour abscisse:  %(r1)f

"""),

64 : _(u"""
 erreur lors de la d�finition de la courbe de traction %(k1)s
 le premier point de la fonction indic�e par :  %(i1)d de la nappe  %(k2)s
 a pour ordonn�e:  %(r1)f

"""),

65 : _(u"""
 erreur lors de la d�finition de la courbe de traction %(k1)s
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
 manque le param�tre  %(k1)s
"""),

78 : _(u"""
 pour la maille  %(k1)s
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
Erreur Europlexus
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
Erreur Europlexus
   Europlexus ne g�re pas les MAILLES, mais seulement les POINTS.
   Le probl�me vient de la maille %(k1)s.
"""),

97 : _(u"""
Erreur Europlexus
   Donn�es incorrectes. Les dimensions des objets ne sont pas coh�rentes (Erreur Fortran : acearp)
"""),

98 : _(u"""
Erreur Europlexus
   Pour acc�der aux valeurs n�cessaires � Europlexus, il faut que dans la commande AFFE_CARA_ELEM,
   pour le mot clef facteur RIGI_PARASOL, la valeur du mot clef EUROPLEXUS soit 'OUI' dans
   toutes les occurrences.
"""),

99 : _(u"""
Le vecteur d�finissant l'axe de rotation a une composante nulle suivant Oz.
Avec une mod�lisation C_PLAN ou D_PLAN, l'axe de rotation doit �tre dirig� suivant Oz.
"""),

}
