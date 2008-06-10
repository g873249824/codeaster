#@ MODIF A_MACRO_ETAPE Accas  DATE 14/09/2004   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
#                                                                       
#                                                                       
# ======================================================================


from Noyau import N_MACRO_ETAPE
from Validation import V_MACRO_ETAPE
from Build import B_MACRO_ETAPE
from Execution import E_MACRO_ETAPE

class MACRO_ETAPE(E_MACRO_ETAPE.MACRO_ETAPE,
                  B_MACRO_ETAPE.MACRO_ETAPE,V_MACRO_ETAPE.MACRO_ETAPE,
                  N_MACRO_ETAPE.MACRO_ETAPE):
   def __init__(self,oper=None,reuse=None,args={}):
      N_MACRO_ETAPE.MACRO_ETAPE.__init__(self,oper,reuse,args)
      V_MACRO_ETAPE.MACRO_ETAPE.__init__(self)
      B_MACRO_ETAPE.MACRO_ETAPE.__init__(self)
