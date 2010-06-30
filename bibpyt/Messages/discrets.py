#@ MODIF discrets Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

# Messages pour les �l�ments discrets non-lin�aires
cata_msg={

1: _("""
Pour l'�l�ment discret %(k1)s .
Il n'y a pas de rotation non-lin�aire possible.
"""),

2: _("""
Pour l'�l�ment discret %(k1)s .
Il n'y a pas de comportement non-lineaire possible suivant Z
ou en rotation autour de X,Y en 2D.
"""),

3: _("""
Pour l'�l�ment discret %(k1)s .
Il n'y a pas de comportement non-lin�aire possible en rotation
ou suivant Z en 2D.
"""),

4: _("""
Pour l'�l�ment discret.
Le pas de temps est devenu trop petit : %(r1)12.5E .
"""),

5: _("""
Pour l'�l�ment discret %(k5)s .
Les caract�ristiques sont obligatoirement donn�es dans le rep�re local du discret.

Pour Info :
   Mod�le   : <%(k1)s>, Option   : <%(k2)s>
   Comport. : <%(k3)s>, Relation : <%(k4)s>
   Maille   : <%(k5)s>
"""),

6: _("""
Pour les �l�ments discrets il faut d�finir un rep�re dans AFFE_CARA_ELEM

Pour Info :
   Mod�le   : <%(k1)s>, Option   : <%(k2)s>
   Comport. : <%(k3)s>, Relation : <%(k4)s>
   Maille   : <%(k5)s>
"""),


7 : _("""
Le Comportement <%(k4)s> affect� � un DISCRET est non valide
Les comportements valides sont :
   COMP_ELAS   ELAS

   COMP_INCR   ELAS           DIS_GRICRA  DIS_VISC  DIS_ECRO_CINE
               DIS_BILI_ELAS  ASSE_CORN   ARME      DIS_CHOC
               DIS_GOUJ2E

Pour Info :
   Mod�le   : <%(k1)s>, Option   : <%(k2)s>
   Comport. : <%(k3)s>, Relation : <%(k4)s>
   Maille   : <%(k5)s>
"""),

8 : _("""
Pour les discrets, avec COMP_ELAS le seul comportement valide est ELAS.

Pour Info :
   Mod�le   : <%(k1)s>, Option   : <%(k2)s>
   Comport. : <%(k3)s>, Relation : <%(k4)s>
   Maille   : <%(k5)s>
"""),

9 : _("""
L'�l�ment DISCRET de mod�le <%(k1)s> est inconnu.

Pour Info :
   Mod�le   : <%(k1)s>, Option   : <%(k2)s>
   Maille   : <%(k5)s>
"""),

10 : _("""
Pour l'�l�ment DISCRET de mod�le <%(k1)s> la matrice de d�charge est non d�velopp�e.

Pour Info :
   Mod�le   : <%(k1)s>, Option   : <%(k2)s>
   Comport. : <%(k3)s>, Relation : <%(k4)s>
   Maille   : <%(k5)s>
"""),


11 : _("""
La loi <%(k4)s> doit etre utilis�e avec des �l�ments du type DIS_TR_L : �l�ment SEG2 + mod�lisation DIS_TR

Pour Info :
   Mod�le   : <%(k1)s>, Option   : <%(k2)s>
   Comport. : <%(k3)s>, Relation : <%(k4)s>
   Maille   : <%(k5)s>
"""),


}
