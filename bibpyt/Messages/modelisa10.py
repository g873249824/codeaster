#@ MODIF modelisa10 Messages  DATE 29/04/2013   AUTEUR SFAYOLLE S.FAYOLLE 
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg = {

1 : _(u"""
Le vecteur d�finissant l'axe de rotation a une composante non nulle suivant Ox ou Oz,
ce qui induit un chargement non axisym�trique. Avec une mod�lisation AXIS ou AXIS_FOURIER,
l'axe de rotation doit �tre dirig� suivant Oy.
"""),

2 : _(u"""
Les coordonn�es du centre de rotation ont au moins une composante non nulle, ce qui induit
un chargement non axisym�trique. Avec une mod�lisation AXIS ou AXIS_FOURIER,
le centre de rotation doit �tre confondu avec l'origine.
"""),

3 : _(u"""
Le vecteur d�finissant l'axe de rotation a une composante non nulle suivant Ox ou Oy,
ce qui induit des forces centrifuges hors plan. Avec une mod�lisation C_PLAN ou D_PLAN,
l'axe de rotation doit �tre dirig� suivant Oz.
"""),


4 : _(u"""
Les mailles affect�es � la mod�lisation TUYAU ne semblent pas former des lignes continues.
Il y a probablement un probl�me dans le maillage (superposition d'�l�ments par exemple).
Pour obtenir le d�tail des mailles affect�es, utilisez INFO=2.
"""),

5 : _(u"""
Le quadrangle de nom %(k1)s est d�g�n�r� : les cot�s 1-2 et 1-3 sont colin�aires.
Reprenez votre maillage.
"""),

6 : _(u"""
Le mod�le est de dimension %(i1)d . ARETE_IMPO s'applique sur des ar�tes d'�l�ments 3D,
donc un mod�le de dimension 3. Pour les ar�tes d'�l�ments 2D utiliser FACE_IMPO.
"""),
7 : _(u"""
Il faut au moins un noeud esclave.
"""),

8 : _(u"""
Le groupe d'esclaves %(k1)s est vide.
"""),

9 : _(u"""
Le groupe du noeud ma�tre %(k1)s contient %(i1)d noeuds alors qu'il en faut un seul.
"""),

10 : _(u"""
Arguments incompatibles : il y a %(i1)d degr�s de libert� esclaves mais %(i2)d noeuds esclaves.
"""),

11 : _(u"""
Le degr� de libert�  %(k1)s est invalide.
"""),

12 : _(u"""
Arguments incompatibles : il y a %(i1)d degr�s de libert� esclaves mais %(i2)d coefficients esclaves.
"""),

13 : _(u"""
Arguments incompatibles : il y a %(i1)d degr�s de libert� esclaves mais %(i2)d noeuds esclaves.
"""),

14 : _(u"""
Pour un spectre de type SPEC_CORR_CONV_3, il faut donner le nom du
MODELE_INTERFACE dans PROJ_SPEC_BASE
"""),

15 : _(u"""
La g�om�trie de la section utilis�e n'est pas pr�vue par l'op�rande SECTION = 'RECTANGLE' de AFFE_CARA_ELEM.
L'un des bords est trop fin. 
Utilisez l'op�rande SECTION = 'GENERALE'.
"""),

16 : _(u"""
Il est obligatoire de fournir au moins un comportement pour d�finir le mat�riau.
"""),

17 : _(u"""
La valeur du mot cl� DEFORMATION='%(k1)s' et incompatible avec la mod�lisation.
"""),

}
