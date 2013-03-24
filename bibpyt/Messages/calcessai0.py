#@ MODIF calcessai0 Messages  DATE 19/03/2013   AUTEUR BRIE N.BRIE 
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

# RESPONSABLE BODEL C.BODEL

cata_msg={

1: _(u"""
Le mod�le mesur� doit �tre un concept de type DYNA_HARMO ou MODE_MECA.
"""),

3: _(u"""
Calcul de MAC impossible : bases incompatibles.
"""),

4: _(u"""
Probl�me inverse impossible : probl�me de coh�rence entre les donn�es.
"""),

5: _(u"""
Probl�me de NUME_DDL dans MACRO_EXPANS : il est possible de le pr�ciser
a l'appel de la macro-commande. Cons�quence : erreur fatale possible dans les
op�rations ult�rieures (notamment l'op�rateur MAC_MODE)
"""),

6: _(u"""
Si vous n'avez pas s�lectionn� de NUME_ORDRE ou de NUME_MODE dans %(k1)s.
Il ne faut pas d�clarer de concept en sortie de type %(k2)s.
Cela risque de causer une erreur fatale par la suite.
"""),

7: _(u"""
Erreur dans MACRO_EXPANS
"""),

8: _(u"""
Impossible de trouver le mod�le associe a la base de modes %(k1)s.
Cela peut emp�cher certains calculs de se d�rouler normalement.
"""),

9: _(u"""
Les mots-cl�s MATR_RIGI et MATR_MASS n'ont pas �t� renseign�s dans OBSERVATION.
Sans ces matrices, certains calculs (par exemple : calcul d'expansion, de MAC, etc.)
ne seront pas possibles.
"""),

10: _(u"""
Le mod�le associ� aux matrices MATR_RIGI et MATR_MASS doit �tre le m�me que MODELE_2.
"""),

13: _(u"""
Le r�sultat exp�rimental est un DYNA_HARMO : il n'est pas possible d'en extraire
des num�ros d'ordre avec MACRO_EXPANS. Le mots-cl�s NUME_MODE et NUME_ORDRE
sont ignor�s.
"""),

14: _(u"""
Erreur dans le calcul de MAC : le NUME_DDL associ� � la base %(k1)s
n'existe pas. Si cette base a �t� cr��e avec PROJ_CHAMP, ne pas oublier
de mentionner explicitement le NUME_DDL de la structure de donn�es r�sultat
avec le mot-cl� NUME_DDL.
"""),


}
