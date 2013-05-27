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
D�finition d'une liaison unilat�rale.
 -> Cette fonctionnalit� suppose la sym�trie de la matrice obtenue apr�s assemblage.
    Si votre mod�lisation produit une matrice non-sym�trique, on force donc sa sym�trie pour r�soudre
    le contact.
 -> Risque & Conseil :
    Ce changement peut conduire � des difficult�s de convergence dans le processus de Newton mais en
    aucun cas il ne produit des r�sultats faux.

    Si la matrice de rigidit� de votre structure est sym�trique, vous pouvez ignorer ce qui pr�c�de.
    Enfin, il est possible de supprimer l'affichage de cette alarme en renseignant SYME='OUI'
    sous le mot-cl� facteur SOLVEUR.
"""),

42: _(u"""
D�finition d'une liaison unilat�rale.
Le nombre de COEF_MULT n'est pas �gal au nombre de grandeurs contenus dans
le vecteur NOM_CMP
"""),

43: _(u"""
D�finition d'une liaison unilat�rale.
Il y a trop de grandeurs dans le vecteur NOM_CMP (limit� � 30)
"""),

48 : _(u"""
D�finition d'une liaison unilat�rale.
Aucun noeud n'est affect� par une liaison unilat�rale.
"""),

58: _(u"""
D�finition d'une liaison unilat�rale.
La composante %(k2)s existe sur le noeud %(k1)s
"""),


75: _(u"""
D�finition d'une liaison unilat�rale.
La composante %(k2)s est inexistante sur le noeud %(k1)s
"""),

}
