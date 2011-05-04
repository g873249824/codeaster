#@ MODIF discrets Messages  DATE 04/05/2011   AUTEUR MACOCCO K.MACOCCO 
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

12 : _("""
La commande %(k4)s ne sait pas traiter les matrices non-sym�triques, pour l'option %(k1)s.
Message de la routine %(k3)s, pour l'�l�ment %(k2)s.
"""),

13 : _("""
L'�l�ment %(k1)s est inconnu pour la maille %(k3)s.
Message de la routine %(k2)s.
"""),

14 : _("""
L'option %(k1)s est inconnue pour l'�l�ment %(k2)s.
Message de la routine %(k3)s.
"""),

15 : _("""
L'option %(k1)s ne sait pas traiter l'�l�ment %(k2)s.
Message de la routine %(k3)s.
"""),

16 : _("""
Il est interdit d'avoir des �l�ments discrets 2D et 3D dans un mod�le.
"""),

17 : _("""
Votre mod�lisation ne comporte pas d'�l�ment discret.
"""),

20 : _("""
Votre mod�lisation doit �tre soit 2D soit 3D.
Il est interdit d'avoir des discrets sur une mod�lisation %(k1)s.
"""),

21 :_("""
AFFE_CARA_ELEM/RIGI_PARASOL
  Le nombre de valeurs fournies sous VALE ne correspond pas au nombre attendu.
  Vous devez v�rifier l'ad�quation des dimensions des �l�ments sous CARA avec le nombre de valeur sous VALE.
"""),

25 :_("""
Vous utilisez des discrets %(k1)s alors que vous n'avez pas affect� ses caract�ristiques.
Il faut v�rifier les affectations sous AFFE_CARA_ELEM/DISCRET.
"""),

26 :_("""
Vous utilisez des discrets %(k1)s pour affecter des MASSES alors que vous n'avez pas affect�
les caract�ristiques de masses. Par d�faut la masse est nulle.
Il faut v�rifier les affectations sous AFFE_CARA_ELEM/DISCRET.
"""),

27 :_("""
Vous utilisez des discrets %(k1)s pour affecter des RAIDEURS alors que vous n'avez pas affect�
les caract�ristiques de raideurs. Par d�faut la raideur est nulle.
Il faut v�rifier les affectations sous AFFE_CARA_ELEM/DISCRET.
"""),

28 :_("""
Vous utilisez des discrets %(k1)s pour affecter des AMORTISSEMENTS alors que vous n'avez pas affect�
les caract�ristiques d'amortissements. Par d�faut l'amortissement est nul.
Il faut v�rifier les affectations sous AFFE_CARA_ELEM/DISCRET.
"""),

30 :_("""Informations :
   Maille de nom %(k1)s, de %(i1)d noeud(s).
   Nom et coordonn�es des noeuds :
"""),
31 :_("""      %(k1)s   %(r1)12.5E   %(r2)12.5E   %(r3)12.5E
"""),

}
