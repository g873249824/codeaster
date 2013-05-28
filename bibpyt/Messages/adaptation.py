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

# Pour la m�thode d'adaptation du pas de temps

cata_msg={

1: _(u"""
  Adaptation du pas de temps.
"""),

2: _(u"""
    Pour la m�thode d'adaptation de type <%(k1)s>, le pas de temps calcul� vaut <%(r1)19.12e>.
"""),

3: _(u"""
    Pour la m�thode d'adaptation de type <%(k1)s>, le crit�re n'est pas v�rifi�. Le pas de temps n'est pas adapt�.
"""),

4: _(u"""
    Aucun crit�re d'adaptation n'est v�rifi�. On garde le pas de temps <%(r1)19.12e>.
"""),

5: _(u"""
    Sur tous les crit�res d'adaptation, le plus petit pas de temps vaut <%(r1)19.12e>.
"""),

6: _(u"""
    Apr�s ajustement sur les points de passage obligatoires, le plus petit pas de temps vaut <%(r1)19.12e>.
"""),

10 : _(u"""
    On maintient la d�coupe du pas de temps � <%(r1)19.12e>.
"""),

11 : _(u"""
    La valeur du pas de temps retenu <%(r1)19.12e> est inf�rieure � PAS_MINI.
"""),

12 : _(u"""
    La valeur du pas de temps <%(r1)19.12e> est sup�rieure � PAS_MAXI <%(r2)19.12e>.
    On limite le pas de temps � PAS_MAXI <%(r2)19.12e>.
"""),

13 : _(u"""
 On a d�pass� le nombre maximal de pas de temps autoris�.
"""),
}
