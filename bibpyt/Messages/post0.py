#@ MODIF post0 Messages  DATE 25/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

cata_msg={
1: _(u"""
D�finition incorrecte de la ligne de coupe.
"""),

2: _(u"""
Valeurs incorrectes pour VECT_Y.
"""),

3: _(u"""
Valeurs incorrectes pour VECT_Y: X colin�aire � Y.
"""),

4: _(u"""
Le vecteur Y n'est pas orthogonal � la ligne de coupe.
Le vecteur Y a �t� orthonormalis� pour vous.
VECT_Y=(%(r1)f,%(r2)f,%(r3)f)
"""),

5: _(u"""
Le type %(k1)s n'est pas coh�rent avec le choix du rep�re (REPERE %(k2)s).
"""),

6: _(u"""
D�finition incorrecte de COOR_ORIG et CENTRE.
"""),

7: _(u"""
D�finition incorrecte de DNOR.
"""),

8: _(u"""
Attention la ligne de coupe traverse des zones sans mati�re :
 - Les coordonn�es des points sur la ligne de coupe sont :
            %(k1)s
 - Les coordonn�es des points �limin�s (car hors de la mati�re) sont:
            %(k2)s
"""),

9: _(u"""
Nom du mod�le absent dans le concept r�sultat %(k1)s.
"""),

10: _(u"""
Veuillez renseigner le MODELE si vous utilisez un CHAM_GD.
"""),

11: _(u"""
Dimensions de maillage et de coordonn�es incoh�rentes.
"""),

12: _(u"""
Le mot-cl� 'DNOR' est obligatoire en 3D pour le type 'ARC'.
"""),

13: _(u"""
Le GROUP_NO %(k1)s n'est pas dans le maillage %(k2)s.
"""),

14: _(u"""
Le GROUP_MA %(k1)s n'est pas dans le maillage %(k2)s.
"""),

15: _(u"""
le group_ma %(k1)s contient la maille %(k2)s qui n'est pas de type SEG.
"""),

16: _(u"""
On ne peut pas combiner des lignes de coupes de type ARC
avec des lignes de coupes SEGMENT ou GROUP_NO.
"""),

17: _(u"""
Le champ %(k1)s n'est pas trait� par MACR_LIGNE_COUPE en rep�re %(k2)s.
Le calcul est effectu� en rep�re global.
"""),

18: _(u"""
%(k1)s est un type de champ aux �l�ments, non trait� par PROJ_CHAMP, donc par MACR_LIGN_COUPE

Conseil : pour un champ aux points de Gauss, veuillez passer par un champ ELNO
"""),

19: _(u"""
La SD RESULTAT ne contient aucun champ pour le num�ro d'ordre %(i1)d.
On ne peut pas calculer les efforts.
"""),

21: _(u"""
Le point � l occurence %(i1)d a une c�te h= %(r1)f, donc non nulle.
Les efforts �tant int�gr�s sur la section, on n en tient pas compte.
"""),

22: _(u"""
Le point � l occurence %(i1)d n a que 3 coordonn�es. Pour le calcul
des d�formations on doit rentrer une position dans l'�paisseur.
"""),


24: _(u"""
Attention la ligne de coupe %(i1)d traverse des zones sans mati�re :
 - Les coordonn�es des points sur la ligne de coupe sont :
            %(k1)s
 - Le nombre de points �limin�s (car hors de la mati�re) est:
            %(i2)d
"""),

25: _(u"""
La SD RESULTAT ne contient aucun champ au num�ro d ordre %(i1)d.
"""),

26: _(u"""
La SD RESULTAT ne contient aucun champ � l instant %(r1)f.
"""),

33: _(u"""
Attention : le mod�le n'est pas une entr�e de la macro-commande et n'appartient pas
� la structure donn�es r�sultat.
"""),

34: _(u"""
Attention : donner un maillage 2D en entr�e
"""),

35: _(u"""
Attention : le type de champ en entr�e ne fait pas partie des champs que la macro peut traiter
"""),

36 : _(u"""
L'instant o� le "Kj critique" OU "Gp critique" est atteint a �t� obtenu par interpolation lin�aire
entre les instants %(r1)f et %(r2)f ; ce type de grandeur �tant non lin�aire, le r�sultat est d'autant plus
impr�cis que l'intervalle d'interpolation est grand.

Conseil : raffinez votre discr�tisation en temps pour votre post_traitement, et si besoin pour votre calcul.
"""),

37 : _(u"""
Le num�ro d'ordre 0 ne peut pas �tre trait� par la commande POST_GP.
"""),

38 : _(u"""
Assurez vous que :
- Votre fond d'entaille est dans un plan.
- La direction de propagation correspond bien au produit vectoriel de la direction du fond d'entaille
  et de la normale d�finis tous deux dans la commande DEFI_FOND_FISS.
"""),

39 : _(u"""
En 3D, le mot-cl� NORMALE doit �tre renseign� dans la commande DEFI_FOND_FISS.
"""),

}
