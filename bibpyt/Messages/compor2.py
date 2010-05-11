#@ MODIF compor2 Messages  DATE 10/05/2010   AUTEUR PROIX J-M.PROIX 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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

1 : _("""
   SIMU_POINT_MAT : Le type de DEFORMATION choisi,  <%(k1)s>, est actuellement incompatible avec SUPPORT=POINT.
    On utilise donc SUPPORT=ELEMENT.
"""),

2 : _("""
   SIMU_POINT_MAT : Erreur, on ne peut avoir � la fois SIGM et EPSI impos�s sur la composante <%(k1)s>
"""),

3 : _("""
   SIMU_POINT_MAT : Erreur, on doit avoir une seule composante donn�e parmi  <%(k1)s>
"""),

4 : _("""
   SIMU_POINT_MAT : Probl�me a l'inversion de la matrice jacobienne. 
   On tente de subdiviser le pas de temps
"""),

5 : _("""
   SIMU_POINT_MAT : nombre d'iterations maximum atteint.
   On tente de subdiviser le pas de temps
"""),

6 : _("""
   SIMU_POINT_MAT : nombre de variables internes trop grand pour la table.
   On ne stocke que les 99 premi�res. Utiliser NB_VARI_TABLE pour limiter leur nombre.
"""),

7 : _("""
   SIMU_POINT_MAT : le nombre de variables internes d�passe le maximum : <%(i1)i>
   Faire une demande d'�volution ou modifier NBVIMAX dans OP0033.
"""),

8 : _("""
   DEFI_COMPOR : la somme des fractions volumiques est tr�s diff�rente de 1.0 : <%(r1).15E>
   V�rifiez FRAC_VOL pour toutes les occurrences du mot cl� POLYCRISTAL.
"""),

}
