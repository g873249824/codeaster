#@ MODIF algorith17 Messages  DATE 26/10/2009   AUTEUR SFAYOLLE S.FAYOLLE 
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
 Solveur lin�aire MUMPS distribu�, routine CRESOL.
 Le processeur de rang %(i1)d ne s'est vu attribuer aucune maille physique
 du mod�le!
"""),

2: _("""
         Comportement %(k1)s non implant� pour l'�l�ment d'interface
"""),
3: _("""
        il manque le d�placement de r�f�rence DEPL_REFE  
"""), 
4: _("""
        La formulation n'est ni en contrainte nette ni en bishop  
"""), 
5 : _("""
  Le champ posttrait� est un cham_elem, le calcul de moyenne ne fonctionne que
 sur les cham_no. Pour les cham_elem utiliser POST_ELEM mot-cl� INTEGRALE.
"""), 
6 : _("""
  Le calcul de la racine numero %(i1)d par la m�thode de la matrice compagnon a �chou�.
"""), 
}
