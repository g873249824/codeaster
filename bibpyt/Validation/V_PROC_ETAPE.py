# -*- coding: iso-8859-1 -*-
# person_in_charge: mathieu.courtois at edf.fr
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

"""
   Ce module contient la classe mixin PROC_ETAPE qui porte les m�thodes
   n�cessaires pour r�aliser la validation d'un objet de type PROC_ETAPE
   d�riv� de OBJECT.

   Une classe mixin porte principalement des traitements et est
   utilis�e par h�ritage multiple pour composer les traitements.
"""
# Modules EFICAS
import V_ETAPE
from Noyau.N_Exception import AsException
from Noyau.N_utils import AsType
from Noyau.strfunc import ufmt


class PROC_ETAPE(V_ETAPE.ETAPE):
   """
      On r�utilise les m�thodes report,verif_regles
      de ETAPE par h�ritage.
   """

   def isvalid(self,sd='oui',cr='non'):
      """
         Methode pour verifier la validit� de l'objet PROC_ETAPE. Cette m�thode
         peut etre appel�e selon plusieurs modes en fonction de la valeur
         de sd et de cr (sd n'est pas utilis�).

         Si cr vaut oui elle cr�e en plus un compte-rendu.

         Cette m�thode a plusieurs fonctions :

          - retourner un indicateur de validit� 0=non, 1=oui

          - produire un compte-rendu : self.cr

          - propager l'�ventuel changement d'�tat au parent
      """
      if CONTEXT.debug : print "ETAPE.isvalid ",self.nom
      if self.state == 'unchanged' :
        return self.valid
      else:
        valid=self.valid_child()
        valid=valid * self.valid_regles(cr)
        if self.reste_val != {}:
          if cr == 'oui' :
            self.cr.fatal(_(u"Mots cl�s inconnus : %s"), ','.join(self.reste_val.keys()))
          valid=0
        self.set_valid(valid)
        return self.valid
