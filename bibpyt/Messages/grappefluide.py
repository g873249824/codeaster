#@ MODIF grappefluide Messages  DATE 06/11/2007   AUTEUR BOYERE E.BOYERE 
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
# ======================================================================


def _(x) : return x

cata_msg={

1: _("""
 Carter/M�canisme de lev�e : LAMEQI ou LAMML n'ont pas converg� � l'it�ration %(i1)d (altitude %(r1)f m).
"""),

2: _("""
 Manche thermique adaptateur : LAMEQM ou LAMA n'ont pas converg� � l'it�ration %(i1)d (altitude %(r1)f m).
"""),

3: _("""
 M�canisme - erreur r�siduelle dans le calcul du m�canisme de commande %(r1)f > %(k1)s (altitude %(r2)f).
"""),

4: _("""
 r�solution mal termin�e - code retour  %(i1)d  pour l'it�ration %(i2)d  (altitude %(r1)f m)
"""),

5: _("""
 erreur r�siduelle dans la r�solution du mod�le du dashpot
  somme(f) > 1.0d-3 , somme(f) =  %(r1)f (altitude %(r8)% m)
  f =  %(r2)f + %(r3)f + %(r4)f + %(r5)f + %(r6)f + %(r7)f
"""),

6: _("""
 erreur r�siduelle dans la r�solution du mod�le du tube guide
  somme(f) > 1.0d-3 , somme(f) =  %(r1)f (altitude %(r7)% m)
  f =  %(r2)f + %(r3)f + %(r4)f + %(r5)f + %(r6)f
"""),

7: _("""
 lameq n'a pas converg� (altitude %(r1)f m)
"""),

8: _("""
 aucun noeud n'est present dans la zone consideree 2  (altitude %(r1)f m)
"""),

9: _("""
 aucun noeud n'est pr�sent dans la zone consid�r�e 1  (altitude %(r1)f m)
"""),

10: _("""
 aucun noeud n'est pr�sent dans la zone consid�r�e 3  (altitude %(r1)f m)
"""),

11: _("""
 Force fluide, arrivee de la grappe en butee, fin du calcul de chute de grappe
  - iteration  %(i1)d , z =  %(r1)f    it�ration  %(i2)d  , z =  %(r2)f 
    temps de chute total T5 + T6 compris entre  %(r3)f et  %(r4)f 
"""),

12: _("""
 R�sidu dans la manchette : %(r1)f  (altitude %(r2)f m)
"""),

13: _("""
 CALCUL GRAPPE FLUIDE : C1 nul (altitude %(r1)f m)
"""),

14: _("""
 Force fluide, grappe a l'entree du retreint
  - iteration  %(i1)d , z =  %(r1)f    it�ration  %(i2)d  , z =  %(r2)f 
    temps de chute T5 compris entre  %(r3)f et  %(r4)f 
"""),

15: _("""
 Force fluide, attention grappe bloquee
  - iteration  %(i1)d , z =  %(r1)f    it�ration  %(i2)d  , z =  %(r2)f 
    attention temps de chute compris entre  %(r3)f et  %(r4)f 
"""),

16: _("""
 Force fluide, pression maximale dans le retreint
  - iteration  %(i1)d , z =  %(r1)f    it�ration  %(i2)d  , z =  %(r2)f 
    pression maximale  %(r4)f Pa dans le retreint
"""),

}
