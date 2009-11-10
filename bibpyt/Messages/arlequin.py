#@ MODIF arlequin Messages  DATE 09/11/2009   AUTEUR MEUNIER S.MEUNIER 
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
 Pour Arlequin, la dimension topologique des mod�lisations de GROUP_MA_1 et GROUP_MA_2 doivent �tre les m�mes:
  - C_PLAN (2D)
  - ou D_PLAN (2D)
  - ou AXIS (2D)
  - ou 3D/DKT/DST/COQUE_3D/Q4G (3D)
"""),

2: _("""
 Le groupe de maille <%(k1)s> n'existe pas dans le maillage
"""),

3: _("""
 Il y a plusieurs mod�lisations dans le m�me groupe de maille
"""),

4: _("""
 Il y a plusieurs cin�matiques dans le m�me groupe de maille
 (m�lange �l�ments de structures/�l�ments de milieu continu)
"""),

5: _("""
 Aucune maille du groupe n'est utilisable dans Arlequin, on rappelle ce qui est utilisable:
  - �l�ments de d�formations planes (D_PLAN)
  - �l�ments de contraintes planes (C_PLAN)
  - �l�ments axisym�triques (AXIS)
  - �l�ments 3D
  - �l�ments de structure de type coques et plaques (DKT/DST/COQUE_3D/Q4G)
"""),

6: _("""
 La normale au noeud <%(k1)s> de la maille <%(k2)s> est nulle.
 V�rifiez votre maillage (pas de mailles aplaties par exemple)
"""),

7: _("""
 La normale moyenne sur la maille <%(k1)s> est nulle.
 V�rifiez votre maillage (orientations des mailles par exemple)
"""),

8: _("""
 Il faut renseigner le mot-clef CARA_ELEM lorsqu'on utilise des �l�ments coques
"""),

9: _("""
 Les deux domaines ne se recouvrent pas. V�rifiez vos groupes.
 """),

10: _("""
 Le groupe de mailles de collage (GROUP_MA_COLL) doit �tre un sous ensemble
 d'un des deux sous domaines GROUP_MA_1 ou GROUP_MA_2.
 """),

11: _("""
 La maille <%(k1)s> est de type %(k2)s : elle ne peut �tre mise en bo�te.
 Ce type de maille n'est pas pris en compte.
"""),

12: _("""
 Aucune maille de la zone de collage n'est appari�e
"""),

13: _("""
 Nombre de couples appari�s sous-estim�
 - Erreur avanc�e : contacter le support
"""),

14: _("""
 La zone de superposition des mod�les dans Arlequin ne contient aucune maille !
"""),

15: _("""
 Le poids de chaque mod�le doit etre compris entre 0 et 1.
 Vous avez d�fini un poids de <%(r1)s>.
"""),

16: _("""
 Pb d'assemblage pour le couple de mailles %(i1)d et %(i2)d
"""),

17: _("""
 V�rifiez votre maillage. Il est possible qu'un noeud situ� dans
 la zone de collage soit utilis� � la fois pour �tre un noeud du maillage 1 et un
 noeud du maillage 2. Veuillez donner 2 noms diff�rents pour les noeuds du maillage 1 et du
 maillage 2 situ�s dans la zone de collage et g�om�triquement au m�me endroit.
"""),

18: _("""
 Int�gration par sous-mailles - 2d : le d�coupage en tria6 ne marche pas encore
"""),

19: _("""
 El�ment de type <%(k1)s> interdit
"""),

20: _("""
 Mise en bo�tes : il est impossible de traiter le type de maille <%(k1)s>
"""),

21: _("""
 Pb lors de mise en bo�tes. La SD bo�te concern�e est <%(k1)s>. Informations :
 dimension de l'espace : %(i1)d
 nombre de mailles     : %(i2)d
 nombre de pans        : %(i3)d
 nombre de sommets     : %(i4)d
"""),

22: _("""
  Maille inconnue : %(k1)s
"""),

23: _("""
 Mauvaise intersection
"""),

24: _("""
 Nombre de composantes connexes maximal pr�vu insuffisant
"""),

25: _("""
 L'intersection de la maille <%(k1)s> avec la maille <%(k2)s> a donn� un poly�dre
 non �toil� dont la t�tra�drisation a �t� difficile. Il y a une erreur sur le volume obtenu apr�s t�tra�drisation.
  Volume initial du poly�dre de l'intersection: <%(r1)s>
  Volume apr�s d�coupe en t�tra�dres du poly�dre de l'intersection: <%(r2)s>
  Soit un �cart de <%(r3)s> %%
--> Risques & conseils :
Si cet �cart est trop important sur trop de mailles de l'intersection, les termes de couplage Arlequin seront faux et
pourront entra�ner un r�sultat faux.
Vous pouvez r�duire ce risque en raffinant le maillage ou en utilisant des mailles plus simples (t�tra�dres)

"""),

26: _("""
 Dimension incorrecte : %(i1)d
"""),

27: _("""
 Le nombre de noeuds est incoh�rent : %(i1)d
"""),

28: _("""
 Vous faites un calcul Arlequin. Le calcul de l'option %(k1)s est impossible dans ce cas.
"""),

29: _("""
 Vous faites un calcul Arlequin. Faites attention ! Le calcul de m�canique de la rupture doit
 �tre r�alis� sur un seul et unique maillage. Par exemple, pour le calcul de G, il faut �tre s�r
 que la couronne d'int�gration n'intersecte qu'un seul maillage.
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
 On a rencontr� un probl�me dans la routine <%(k1)s>.
 - Erreur avanc�e : contacter le support
"""),

}
