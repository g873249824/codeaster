#@ MODIF post0 Messages  DATE 16/11/2009   AUTEUR DURAND C.DURAND 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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

def _(x) : return x

cata_msg={
1: _("""
D�finition incorrecte de la ligne de coupe.
"""),

2: _("""
Valeurs incorrectes pour VECT_Y.
"""),

3: _("""
Valeurs incorrectes pour VECT_Y: X colin�aire � Y.
"""),

4: _("""
Le vecteur Y n'est pas orthogonal � la ligne de coupe.
Le vecteur Y a �t� orthonormalis� pour vous.
VECT_Y=(%(r1)f,%(r2)f,%(r3)f)
"""),

5: _("""
Le type %(k1)s n'est pas coh�rent avec le choix du rep�re (REPERE %(k2)s).
"""),

6: _("""
D�finition incorrecte de COOR_ORIG et CENTRE.
"""),

7: _("""
D�finition incorrecte de DNOR.
"""),

8: _("""
Attention la ligne de coupe traverse des zones sans mati�re :
 - Les coordonn�es des points sur la ligne de coupe sont :
            %(k1)s
 - Les coordonn�es des points �limin�s (car hors de la mati�re) sont:
            %(k2)s
"""),

9: _("""
Nom du mod�le absent dans le concept r�sultat %(k1)s.
"""),

10: _("""
Veuillez renseigner le MODELE si vous utilisez un CHAM_GD.
"""),

11: _("""
Dimensions de maillage et de coordonn�es incoh�rentes.
"""),

12: _("""
Le mot-cl� 'DNOR' est obligatoire en 3D pour le type 'ARC'.
"""),

13: _("""
Le GROUP_NO %(k1)s n'est pas dans le maillage %(k2)s.
"""),

14: _("""
Le GROUP_MA %(k1)s n'est pas dans le maillage %(k2)s.
"""),

15: _("""
le group_ma %(k1)s contient la maille %(k2)s qui n'est pas de type SEG.
"""),

16: _("""
On ne peut pas combiner des lignes de coupes de type ARC
avec des lignes de coupes SEGMENT ou GROUP_NO.
"""),

17: _("""
Le champ %(k1)s n'est pas trait� par MACR_LIGNE_COUPE en rep�re %(k2)s.
Le calcul est effectu� en rep�re global.
"""),

18: _("""
%(k1)s est un type de champ aux �l�ments, non trait� par PROJ_CHAMP, donc par MACR_LIGN_COUPE

Conseil : pour un champ aux points de Gauss, veuillez passer par un champ ELNO
"""),

}
