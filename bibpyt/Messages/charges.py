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

cata_msg = {

1 : _(u"""
La charge <%(k1)s> a �t� utilis�e plus d'une fois dans EXCIT: il faut la supprimer.
"""),

2 : _(u"""
Il n'y a aucune charge dans le mot-clef facteur EXCIT. Ce n'est pas possible avec STAT_NON_LINE.
"""),

22 : _(u"""
La charge <%(k1)s> n'est pas m�canique.
"""),

23 : _(u"""
La charge <%(k1)s> est de type Dirichlet :
 elle ne peut pas �tre suiveuse.
"""),

24 : _(u"""
La charge <%(k1)s> est de type cin�matique (AFFE_CHAR_CINE):
 elle ne peut pas �tre diff�rentielle.
"""),





27 : _(u"""
La charge <%(k1)s> est de type cin�matique (AFFE_CHAR_CINE):
 elle ne peut pas �tre pilot�e.
"""),

28 : _(u"""
On ne peut piloter la charge <%(k1)s> car c'est une charge fonction du temps
"""),

34 : _(u"""
La charge de type EVOL_CHAR <%(k1)s>  ne peut pas �tre pilot�e.
"""),

38 : _(u"""
La charge <%(k1)s> ne peut pas utiliser de fonction multiplicatrice FONC_MULT
 car elle est pilot�e.
"""),

39 : _(u"""
On ne peut pas piloter en l'absence de forces de type FIXE_PILO.
"""),

40 : _(u"""
On ne peut piloter plus d'une charge.
"""),

50 : _(u"""
Le chargement FORCE_SOL n'est utilisable qu'en dynamique.
"""),

51 : _(u"""
Le chargement FORCE_SOL ne peut pas �tre de type suiveur
"""),

52 : _(u"""
Le chargement FORCE_SOL ne peut pas �tre de type Dirichlet diff�rentiel.
"""),

53 : _(u"""
Le chargement FORCE_SOL ne peut pas �tre une fonction.
"""),

54 : _(u"""
Le chargement FORCE_SOL ne doit pas avoir de fonction multiplicatrice.
"""),



}
