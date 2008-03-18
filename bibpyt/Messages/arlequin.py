#@ MODIF arlequin Messages  DATE 18/03/2008   AUTEUR CNGUYEN C.NGUYEN 
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

cata_msg={


1: _("""
 Pour Arlequin, la dimension topologique des modelisations de GROUP_MA_1 et GROUP_MA_2 doivent etre les memes:
  - C_PLAN (2D)
  - ou D_PLAN (2D)
  - ou AXIS (2D)
  - ou 3D/DKT/DST/COQUE_3D/Q4G (3D)
"""),

2: _("""
 Le groupe de maille <%(k1)s> n'existe pas dans le maillage
"""),

3: _("""
 Il y a plusieurs modelisations dans le meme groupe de maille
"""),

4: _("""
 Il y a plusieurs cinematiques dans le meme groupe de maille
 (melange elements de structures/elements de milieu continu)
"""),

5: _("""
 Aucune maille du groupe n'est utilisable dans Arlequin, on rappelle ce qui est utilisable:
  - elements de deformations planes (D_PLAN)
  - elements de contraintes planes (C_PLAN)
  - elements axisymetriques (AXIS)
  - elements 3D
  - elements de structure de type coques et plaques (DKT/DST/COQUE_3D/Q4G)
"""),

6: _("""
 La normale au noeud <%(k1)s> de la maille <%(k2)s> est nulle.
 Verifiez votre maillage (pas de mailles aplaties par exemple)
"""),

7: _("""
 La normale moyenne sur la maille <%(k1)s> est nulle.
 Verifiez votre maillage (orientations des mailles par exemple)
"""),

8: _("""
 Il faut renseigner le mot-clef CARA_ELEM lorsqu'on utilise des elements coques
"""),

9: _("""
 Les deux domaines ne se recouvrent pas. Verifiez vos groupes.
 """),

10: _("""
 Le groupe de mailles de collage (GROUP_MA_COLL) doit etre un sous ensemble
 d'un des deux sous domaines GROUP_MA_1 ou GROUP_MA_2
 """),

11: _("""
 La maille <%(k1)s> est de type %(k2)s : elle ne peut etre mise en boite.
 Ce type de maille n'est pas pris en compte.
"""),

12: _("""
 Aucune maille de la zone de collage n'est appari�e
"""),

13: _("""
 Nombre de couples appari�s sous-estim�
 - Erreur avanc�e: contacter le support
"""),

14: _("""
 La zone de superposition des mod�les dans Arlequin ne contient aucune maille !
"""),

15: _("""
 La question %(k1)s n'existe pas dans la m�thode Arlequin
"""),




23: _("""
 Mauvaise intersection
"""),

24: _("""
 Nombre de composantes connexes maximal pr�vu insuffisant
"""),

25: _("""
 L'intersection de la maille <%(k1)s> avec la maille <%(k2)s> a donn� un polyedre
 non �toil� dont la t�tra�drisation a �t� difficile. Il y a une erreur sur le volume obtenu apr�s tetra�drisation.
  Volume initial du polyedre de l'intersection: <%(r1)s>
  Volume apr�s d�coupe en t�tra�dres du polyedre de l'intersection: <%(r2)s>
  Soit un �cart de <%(r3)s> %%
--> Risques & conseils :
Si cet �cart est trop important sur trop de mailles de l'intersection, les termes de couplage Arlequin seront faux et
pourront entrainer un r�sultat faux.
Vous pouvez r�duire ce risque en raffinant le maillage ou en utilisant des mailles plus simples (t�tra�dres)

"""),




34: _("""
 La famille d'int�gration %(i1)d n'existe pas pour les mailles de type %(k1)s.
"""),




40: _("""
 La carte d'information %(k1)s de la charge Arlequin courante n'existe pas.
"""),

41: _("""
 On ne sait pas traiter les mailles de type %(k1)s avec la m�thode Arlequin.
"""),

99 : _("""
   Le calcul de l'option %(k1)s n'est pas pr�vue avec Arlequin.
"""),

}
