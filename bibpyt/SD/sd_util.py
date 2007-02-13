#@ MODIF sd_util SD  DATE 13/02/2007   AUTEUR PELLET J.PELLET 
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

"""
   Utilitaires pour la v�rification des SD
"""

# pour utilisation dans eficas
try:
   import aster
except:
   pass


def compare(ojb, checker, val1, comp, val2, comment=''):
    # V�rifie que la relation de comparaison entre val1 et val2 est respect�e :
    #   comp= '==' / '!=' / '>=' / '>' / '<=' / '<'
    if comp == "==" :
       ok = val1 == val2
    elif comp == "!=" :
       ok = val1 != val2
    elif comp == ">=" :
       ok = val1 >= val2
    elif comp == "<=" :
       ok = val1 <= val2
    elif comp == ">" :
       ok = val1 > val2
    elif comp == "<" :
       ok = val1 < val2
    else :
       assert 0, comp

    if not ok :
            checker.err(ojb, "condition non respect�e : %s  %s  %s (%s)" % (val1,comp,val2,comment))


def affirme(ojb, checker, bool,comment=''):
    # V�rifie que le bool�en (bool) est vrai
    #   �met un mesage d'erreur sinon
    if not bool :
            checker.err(ojb, "condition non respect�e :  (%s)" % (comment,))


def nom_gd(numgd) :
    # retourne le nom de la grandeur de num�ro (numgd)
    ptn=aster.getvectjev('&CATA.GD.NOMGD')
    return ptn[numgd-1].strip()
