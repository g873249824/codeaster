#@ MODIF subdivise Messages  DATE 21/03/2011   AUTEUR FLEJOU J-L.FLEJOU 
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

# Pour la m�thode de subdivision

cata_msg={

# Plus de messages pour d�veloppeur ==> ASSERT

# Messages utilisateurs

1: _("""Avec PREDICTION = 'DEPL_CALCULE', la subdivision du pas de temps
n'est pas autoris�e. Or la m�thode s�lectionn�e est %(k1)s.
On force SUBD_METHODE = 'AUCUNE'.
Conseil :
   Pour ne plus avoir ce message, choisissez SUBD_METHODE = 'AUCUNE'."""),

9: _("""La subdivisition utilise la m�thode EXTRAPOLE.
Il n'y a pas eu de d�tection de convergence alors que les crit�res sont atteints.
Cela peut arriver, si vous avez du contact avec une r�actualisation g�om�trique.
Aucune subdivision n'est faite. Pour information :
   Pour l'it�ration %(i1)d, RESI_GLOB_RELA = <%(r1)E> et doit �tre inf�rieure � <%(r2)E>
   Pour l'it�ration %(i1)d, RESI_GLOB_MAXI = <%(r3)E> et doit �tre inf�rieure � <%(r4)E>"""),

10: _("""Le nombre maximal d'it�rations autoris�es ITER_GLOB_* est atteint.
La m�thode de subdivision ne peut pas faire d'extrapolation. La subdivision UNIFORME est d�clench�e.
Cela peut �tre d� � une oscillation de l'erreur ou � une divergence.
   Nombre d'intervalle             = <%(i1)d>
   Niveau de subdivision           = <%(i2)d>
   Ratio sur le premier intervalle = <%(r1)E>
   Pas de Temps actuel             = <%(r2)E>"""),

11: _("""
La m�thode de subdivision ne peut pas faire d'extrapolation.
Il n'y a pas de convergence et la m�thode de subdivision trouve un nombre
d'it�ration � convergence < au nombre donn� sous le mot cl� CONVERGENCE.
La subdivision UNIFORME est d�clanch�e.
   Nombre d'intervalle             = <%(i1)d>
   Niveau de subdivision           = <%(i2)d>
   Ratio sur le premier intervalle = <%(r1)E>
   Pas de Temps actuel             = <%(r2)E>
Pour information :
   La r�gression est faite sur <%(k1)s>
   La m�thode calcule <%(r3)d> pour <%(r4)d>"""),

12: _("""Le nombre maximal de niveau de subdivision est atteint.
   SUBD_NIVEAU doit �tre >= <%(i1)d>
   SUBD_NIVEAU est de     = <%(i2)d>
Conseil :
   Augmenter SUBD_NIVEAU. Il est �galement possible d'ajuster SUBD_PAS_MINI pour
   imposer un incr�ment de temps en-dessous duquel on ne peut plus subdiviser.
   Si les 2 mots clefs SUBD_NIVEAU et SUBD_PAS_MINI sont utilis�s la subdivision
   s'arr�te d�s que l'un des 2 crit�res est v�rifi�."""),

13: _("""M�thode de subdivision : %(k1)s"""),

15: _("""Le pas minimal de la subdivision est atteint.
   Pas de Temps actuel          = <%(r1)E>
   Pas de Temps minimum impos�  = <%(r2)E>
   Niveau de subdivision        = <%(i1)d>
   M�thode de subdivision       = <%(k1)s>
Conseil :
   Diminuer SUBD_PAS_MINI. Il est �galement possible d'ajuster SUBD_NIVEAU pour
   indiquer le nombre successif de subdivision d'un pas de temps.
   Si les 2 mots clefs SUBD_NIVEAU et SUBD_PAS_MINI sont utilis�s la subdivision
   s'arr�te d�s que l'un des 2 crit�res est v�rifi�."""),

16: _("""M�thode EXTRAPOLE, convergence pr�vue en %(i1)d it�rations pour un maximum autoris� de %(i2)d."""),

17: _("""It�ration %(i1)d, poursuite autoris�e."""),

18: _("""Subdivision du pas de temps en %(i1)d intervalles. Le ratio sur le premier intervalle est de %(r1)e.
   Niveau de subdivision = <%(i2)d>
   Pas de Temps actuel   = <%(r2)E>"""),

}
