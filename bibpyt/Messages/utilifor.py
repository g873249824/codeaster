#@ MODIF utilifor Messages  DATE 11/09/2007   AUTEUR DURAND C.DURAND 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
 nombre de terme inf�rieur ou �gal � 0
"""),

2: _("""
 nombre de termes sup�rieur � 1000
"""),

3: _("""
 X en dehors de l'intervalle (-1,+1)
"""),

4: _("""
 X trop grand 
"""),

5: _("""
 nombre de coefficients inf�rieur � 1
"""),

6: _("""
 serie de Chebyshev trop courte pour la pr�cision
"""),

7: _("""
 probl�me dans la r�solution du syst�me sous contraint VSRSRR
"""),

8: _("""
 la programmation pr�voit que les entiers sont cod�s sur plus de 32 bits
 ce qui n'est pas le cas sur votre machine
"""),

9: _("""
 Erreur lexicale (01) %(k1)s  %(k2)s 
"""),

}
