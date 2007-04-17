#@ MODIF context_info Messages  DATE 17/04/2007   AUTEUR COURTOIS M.COURTOIS 
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
# RESPONSABLE COURTOIS M.COURTOIS

"""
   Ensemble de fonctions permettant de r�cup�rer des infos sur le contexte
   dans lequel se produit une erreur.
   L'objectif est :
      - d'aider � la compr�hension du message,
      - de fournir, si possible, des pistes de solution.
"""

__all__ = ['context_concept', 'message_context_concept']

# -----------------------------------------------------------------------------
def context_concept(nom_concept):
   """Retourne le nom de la commande ayant produit le concept `nom_concept`
   et la liste des (commande, [mot-cl� facteur,] mot-cl�) o� il est utilis�.
   """
   dico = { 'concept' : nom_concept, 'cmde_prod' : '', 'cmde_use' : [] }
   jdc = CONTEXT.get_current_step()
   co = jdc.sds_dict.get(nom_concept)
   if co == None:
      return dico
   dico['cmde_prod'] = co.etape
   # �tape utilisant `nom_concept`
   l_etape = jdc.get_liste_etapes()
   l_cmde = []
   for etape in l_etape:
      pass
   if len(l_cmde) == 0:
      l_cmde.append('?')
   dico['cmde_use'] = ', '.join(l_cmde)
   return dico

# -----------------------------------------------------------------------------
def message_context_concept(*args, **kwargs):
   """Appel context_concept et formatte le message.
   """
   fmt_concept = """Le concept '%(nom_concept)s' a �t� produit par %(nom_cmde_prod)s."""
   dico = context_concept(*args, **kwargs)
   d = {
      'nom_concept'   : dico['concept'],
      'nom_cmde_prod' : dico['cmde_prod'].nom,
   }
   return fmt_concept % d

# -----------------------------------------------------------------------------
if __name__ == '__main__':
   pass
