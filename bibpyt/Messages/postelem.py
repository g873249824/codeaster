#@ MODIF postelem Messages  DATE 02/04/2012   AUTEUR BARGELLI R.BARGELLINI 
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
# RESPONSABLE DELMAS


cata_msg={

1: _(u"""
 Un instant demand� dans POST_ELEM, option CHAR_LIMITE n'est pas pr�sent dans le r�sultat <%(k1)s>.
"""),

2: _(u"""
 Impossible de trouver les d�placements de num�ro d'ordre %(i1)d dans POST_ELEM, option CHAR_LIMITE.
"""),

3: _(u"""
 Le r�sultat <%(k1)s> utilis� dans POST_ELEM, option CHAR_LIMITE n'a pas �t� produit par un STAT_NON_LINE avec pilotage.
 V�rifiez que vous utilisez le bon r�sultat.
"""),

4: _(u"""
 Avec le mot-cl� RESULTAT, il faut renseigner NOM_CHAM pour identifier le champ sur lequel r�aliser le post-traitement.
"""),

5: _(u"""
 En pr�sence de d�formation thermique, le calcul de l'�nergie �lastique de SIMO_MIEHE est interdit. Voir R5.03.21
"""),

11: _(u"""
 Un instant demand� dans POST_ELEM, option TRAV_EXT n'est pas pr�sent dans le r�sultat <%(k1)s>.
"""),

12: _(u"""
 Impossible de trouver les d�placements <DEPL> de num�ro d'ordre %(i1)d dans POST_ELEM, option TRAV_EXT.
"""),

13: _(u"""
 Impossible de trouver les forces nodales <FORC_NODA> de num�ro d'ordre %(i1)d dans POST_ELEM, option TRAV_EXT.
"""),


}

