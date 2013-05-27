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

cata_msg = {

1 : _(u"""
Aucun noeud n'est appari�.
La d�finition de vos surfaces ou de vos param�tres d'appariement est incorrecte.
V�rifier TOLE_PROJ_EXT et/ou la d�finition de vos surfaces.
V�rifier les d�placements induits par votre mod�lisation.
Cette alarme peut entra�ner des r�sultats faux si elle appara�t dans la r�solution du contact en Newton g�n�ralis�.
"""),

13 : _(u"""
L'algorithme de Newton a �chou� lors de la projection du point de coordonn�es
  (%(r1)f,%(r2)f,%(r3)f)
sur la maille %(k1)s.
Erreur de d�finition de la maille ou projection difficile.
"""),

14 : _(u"""
Les vecteurs tangents sont nuls au niveau du projet� du noeud %(k2)s sur la maille %(k1)s.
Erreur de d�finition de la maille ou projection difficile.
"""),

15 : _(u"""
Le vecteur normal est nul au niveau du noeud %(k2)s sur la maille %(k1)s.
Erreur de d�finition de la maille ou projection difficile.
"""),

16 : _(u"""
Le vecteur normal r�sultant est nul au niveau du noeud %(k1)s.
Erreur de d�finition de la maille ou projection difficile.
"""),

17 : _(u"""
Les vecteurs tangents r�sultants sont nuls au niveau du noeud %(k1)s.
Erreur de d�finition de la maille ou projection difficile.
"""),

34 : _(u"""
�chec de l'orthogonalisation du rep�re tangent construit au niveau du projet� du point de coordonn�es
  (%(r1)f,%(r2)f,%(r3)f)
sur la maille %(k1)s,
Erreur de d�finition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.
"""),

36 : _(u"""
La maille %(k1)s est de type 'POI1', ce n'est pas autoris� sur une maille ma�tre dans le cas d'un appariement MAIT_ESCL.
"""),

38 : _(u"""
La maille %(k1)s est de type poutre et sa tangente est nulle.
V�rifiez votre maillage.
"""),

61 : _(u"""
La maille %(k1)s est de type poutre, elle n�cessite la d�finition d'une base locale.
"""),

62 : _(u"""
La maille %(k1)s est de type 'POI1', elle n�cessite la d�finition explicite de sa normale.
"""),

63 : _(u"""
La maille %(k1)s est de type 'POI1', elle n�cessite la d�finition explicite d'une normale non nulle.
"""),

75 : _(u"""
Un �l�ment de type POI1 ne peut pas �tre une maille ma�tre.
"""),


}
