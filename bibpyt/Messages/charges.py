#@ MODIF charges Messages  DATE 14/03/2011   AUTEUR ABBAS M.ABBAS 
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

cata_msg = {

1 : _("""
La charge <%(k1)s> a �t� utilis�e plus d'une fois dans EXCIT: il faut la supprimer.
"""),

2 : _("""
Il n'y a aucune charge dans le mot-clef facteur EXCIT. Ce n'est pas possible avec STAT_NON_LINE.
"""),

22 : _("""
La charge <%(k1)s> n'est pas m�canique.
"""),

23 : _("""
La charge <%(k1)s> est de type Dirichlet :
 elle ne peut pas etre suiveuse.
"""),

24 : _("""
La charge <%(k1)s> est de type cin�matique (AFFE_CHAR_CINE):
 elle ne peut pas etre diff�rentielle.
"""),





27 : _("""
La charge <%(k1)s> est de type cin�matique (AFFE_CHAR_CINE):
 elle ne peut pas etre pilot�e.
"""),

28 : _("""
On ne peut piloter la charge <%(k1)s> car c'est une charge fonction du temps
"""),

34 : _("""
La charge de type EVOL_CHAR <%(k1)s>  ne peut pas etre pilot�e.
"""),

38 : _("""
La charge <%(k1)s> ne peut pas utiliser de fonction multiplicative FONC_MULT
 car elle est pilot�e.
"""),

39 : _("""
On ne peut pas piloter en l'absence de forces de type "FIXE_PILO"
"""),

40 : _("""
On ne peut piloter plus d'une charge.
"""),
}
