# coding=utf-8
# person_in_charge: mathieu.courtois at edf.fr
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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


import UserDict

class _F(UserDict.UserDict):
   """
       Cette classe a un comportement semblable à un
       dictionnaire Python et permet de donner
       la valeur d'un mot-clé facteur avec pour les sous
       mots-clés la syntaxe motcle=valeur
   """

   def __init__(self, *pos, **args):
      if len(pos) != 0:
         raise SyntaxError("Valeur invalide pour '_F('. "\
            "On attend cette syntaxe : _F(MOTCLE=valeur, ...)")
      self.data=args

   def supprime(self):
      self.data={}

   def __cmp__(self, dict):
      if type(dict) == type(self.data):
        return cmp(self.data, dict)
      elif hasattr(dict,"data"):
        return cmp(self.data, dict.data)
      else:
        return cmp(self.data, dict)

   def __iter__(self):
      return iter(self.data)

   def copy(self):
      import copy
      c= copy.copy(self)
      c.data=self.data.copy()
      return c
