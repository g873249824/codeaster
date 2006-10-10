#@ MODIF E_Global Execution  DATE 10/10/2006   AUTEUR MCOURTOI M.COURTOIS 
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

# RESPONSABLE MCOURTOI M.COURTOIS

"""
   Module dans lequel on d�finit des fonctions pour la phase d'ex�cution.
   Ces fonctions sont ind�pendantes des �tapes (sinon elles seraient dans
   B_ETAPE/E_ETAPE) et des concepts/ASSD, et elles sont destin�es � etre
   appel�es par le fortran via astermodule.c.

   Ce module sera accessible via la variable globale `static_module`
   de astermodule.c.
"""


# ------------------------------------------------------------------------
def utprin(typmess, unite, idmess, valk, vali, valr):
   """
      Cette methode permet d'imprimer un message venu d'U2MESG
   """
   from Messages import utprin
   utprin.utprin(typmess,unite,idmess,valk,vali,valr)


