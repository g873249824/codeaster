#@ MODIF subdivise Messages  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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
# RESPONSABLE DELMAS J.DELMAS

# Pour la m�thode de subdivision

cata_msg={


1: _(u"""
 <Action> On tente de d�couper le pas de temps (m�thode manuelle).
"""),

2: _(u"""
 <Action> On tente de d�couper le pas de temps (m�thode automatique).
"""),

3: _(u"""
 <Erreur> On ne peut pas d�couper le pas de temps car la fonctionnalit� n'est pas activ�e.
          Pour activer la d�coupe du pas de temps, utilisez la commande DEFI_LIST_INST.
"""),



10: _(u"""
          D�coupe uniforme � partir de l'instant <%(r1)19.12e> en <%(i1)d> pas de temps.
          (soit un incr�ment constant de <%(r2)19.12e>)
   """),

11: _(u"""
          D�coupe non uniforme � partir de l'instant <%(r1)19.12e> en <%(i1)d> pas de temps.
          (avec un incr�ment initial de <%(r2)19.12e>, puis des incr�ments de <%(r3)19.12e>)
   """),


12: _(u"""
          D�coupe non uniforme � partir de l'instant <%(r1)19.12e> en <%(i1)d> pas de temps.
          (avec des incr�ments de <%(r2)19.12e>, puis un incr�ment final de <%(r3)19.12e>)
   """),

50: _(u"""
 <Erreur> Le pas de temps minimum <%(r1)19.12e> (SUBD_PAS_MINI) est atteint.
"""),

51: _(u"""
 <Erreur> Le nombre maximal <%(i1)d> de niveaux de subdivision est atteint.
"""),

60: _(u"""
 <Erreur> �chec dans la tentative de d�couper le pas de temps.
"""),

61: _(u"""
 <Action> On d�coupe le pas de temps.
"""),

62: _(u"""
 <Action> On ne d�coupe pas le pas de temps.
"""),

69: _(u"""
 <Action> On tente de d�couper les pas de temps au del� de l'instant <%(r1)19.12e>, pendant une dur�e de <%(r2)19.12e>.
"""),

70: _(u"""
 <Erreur> �chec dans la tentative de d�couper les pas de temps au del� de l'instant <%(r1)19.12e>.
"""),

71: _(u"""
 <Action> On a d�coup� les pas de temps jusqu'� l'instant <%(r1)19.12e>.
"""),

72: _(u"""
 <Action> On ne d�coupe pas les pas de temps au del� de l'instant <%(r1)19.12e>.
          Les incr�ments de temps au del� de cet instant sont tous plus petits que SUBD_INST.
"""),

75: _(u"""
 <Action> La d�coupe sera maintenue au del� de l'instant <%(r1)19.12e>, pendant une dur�e de <%(r2)19.12e>.
"""),

99: _(u"""Avec PREDICTION = 'DEPL_CALCULE', la subdivision du pas de temps
n'est pas autoris�e. """),


}
