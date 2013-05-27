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
   Ce module contient la classe mixin MCList qui porte les m�thodes
   n�cessaires pour r�aliser la validation d'un objet de type MCList
   d�riv� de OBJECT.

   Une classe mixin porte principalement des traitements et est
   utilis�e par h�ritage multiple pour composer les traitements.
"""
# Modules Python
import traceback

# Modules EFICAS
from Noyau import N_CR
from Noyau.N_Exception import AsException
from Noyau.strfunc import ufmt

class MCList:
   """
      Cette classe a deux attributs de classe :

      - CR qui sert � construire l'objet compte-rendu

      - txt_nat qui sert pour les comptes-rendus li�s � cette classe
   """

   CR = N_CR.CR
   txt_nat = u"Mot cl� Facteur Multiple :"

   def isvalid(self,cr='non'):
      """
         Methode pour verifier la validit� du MCList. Cette m�thode
         peut etre appel�e selon plusieurs modes en fonction de la valeur
         de cr.

         Si cr vaut oui elle cr�e en plus un compte-rendu.

         On n'utilise pas d'attribut pour stocker l'�tat et on ne remonte pas
         le changement d'�tat au parent (pourquoi ??)
         MCLIST est une liste de MCFACT. Les MCFACT ont le meme parent
         que le MCLIST qui les contient. Il n'est donc pas necessaire de
         remonter le changement d'etat au parent. C'est deja fait
         par les MCFACT.
      """
      if len(self.data) == 0 : return 0

      valid= 1
      definition=self.data[0].definition
      # Verification du nombre des mots cles facteurs
      if definition.min is not None and len(self.data) < definition.min :
         valid=0
         if cr == 'oui' :
            self.cr.fatal(_(u"Nombre de mots cl�s facteurs insuffisant minimum : %s"),
                definition.min)

      if definition.max is not None and len(self.data) > definition.max :
         valid=0
         if cr == 'oui' :
            self.cr.fatal(_(u"Nombre de mots cl�s facteurs trop grand maximum : %s"),
                definition.max)
      num = 0
      for i in self.data:
        num = num+1
        if not i.isvalid():
          valid = 0
          if cr=='oui' and len(self) > 1:
            self.cr.fatal(_(u"L'occurrence num�ro %d du mot-cl� facteur : %s n'est pas valide"),
                num, self.nom)
      return valid

   def report(self):
      """
          G�n�re le rapport de validation de self
      """
      if len(self) > 1:
         # Mot cle facteur multiple
         self.cr=self.CR( debut = u"Mot-cl� facteur multiple : "+self.nom,
                  fin = u"Fin Mot-cl� facteur multiple : "+self.nom)
         for i in self.data:
           self.cr.add(i.report())
      elif len(self) == 1:
         # Mot cle facteur non multiple
         self.cr=self.data[0].report()
      else:
         self.cr=self.CR( debut = u"Mot-cl� facteur : "+self.nom,
                  fin = u"Fin Mot-cl� facteur : "+self.nom)

      try :
        self.isvalid(cr='oui')
      except AsException,e:
        if CONTEXT.debug : traceback.print_exc()
        self.cr.fatal(_(u"Mot-cl� facteur multiple : %s, %s"), self.nom, e)
      return self.cr
