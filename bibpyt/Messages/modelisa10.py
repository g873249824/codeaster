#@ MODIF modelisa10 Messages  DATE 16/08/2011   AUTEUR DESROCHE X.DESROCHES 
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
Le vecteur d�finissant l'axe de rotation a une composante non nulle suivant Ox ou Oz,
ce qui induit un chargement non axisym�trique. Avec une mod�lisation AXIS ou AXIS_FOURIER,
l'axe de rotation doit �tre dirig� suivant Oy.
"""),

2 : _("""
Les coordonn�es du centre de rotation ont au moins une composante non nulle, ce qui induit
un chargement non axisym�trique. Avec une mod�lisation AXIS ou AXIS_FOURIER,
le centre de rotation doit �tre confondu avec l'origine.
"""),

3 : _("""
Le vecteur d�finissant l'axe de rotation a une composante non nulle suivant Ox ou Oy,
ce qui induit des forces centrifuges hors plan. Avec une mod�lisation C_PLAN ou D_PLAN,
l'axe de rotation doit �tre dirig� suivant Oz.
"""),


4 : _("""
Les mailles affect�es � la mod�lisation TUYAU ne semblent pas former des lignes continues.
Il y a probablement un probl�me dans le maillage (superposition d'�l�ments par exemple).
Pour obtenir le d�tail des mailles affect�es, utilisez INFO=2. 
"""),

5 : _("""
Le quadrangle de nom %(k1)s est d�g�n�r� : les cot�s 1-2 et 1-3 sont colin�aires.
Reprenez votre maillage.
"""),

}
