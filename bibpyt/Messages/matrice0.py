#@ MODIF matrice0 Messages  DATE 17/07/2007   AUTEUR REZETTE C.REZETTE 
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
 Cas fluides multiples : pr�cisez le GROUP_MA dans lequel vous affectez la masse volumique RHO.
"""),

2: _("""
 PRES_FLUIDE obligatoire une fois.
"""),

3: _("""
 Amortissement ajout� sur mod�le generalis� non encore implant�.
"""),

4: _("""
 Rigidit� ajout� sur modele g�n�ralis� non encore implant�.
"""),

5: _("""
 Avec m�thode LDLT, RENUM doit etre SANS ou RCMK.
"""),

6: _("""
 Avec m�thode MULT_FRONT, RENUM doit etre MDA, MD ou RCMK.
"""),

7: _("""
 Avec m�thode MUMPS, RENUM doit etre SANS.
"""),

8: _("""
 Avec m�thode GCPC, RENUM doit etre SANS ou RCMK.
"""),

9: _("""
 Une des options doit etre RIGI_MECA ou RIGI_THER ou RIGI_ACOU ou RIGI_MECA_LAGR.
"""),

10: _("""
 Pour calculer RIGI_MECA_HYST, il faut avoir calcul� RIGI_MECA auparavant (dans le meme appel).
"""),

11: _("""
 Pour calculer AMOR_MECA, il faut avoir calcul� RIGI_MECA et MASS_MECA auparavant (dans le meme appel).
"""),

}
