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

from Noyau.strfunc import convert, ufmt

class A_CLASSER:
   """
      La r�gle A_CLASSER v�rifie que ...

   """
   def __init__(self,*args):
      if len(args) > 2 :
        print convert(ufmt(_(u"Erreur � la cr�ation de la r�gle A_CLASSER(%s)"),
                           args))
        return
      self.args=args
      if type(args[0]) == tuple:
        self.args0 = args[0]
      elif type(args[0]) == str:
        self.args0 = (args[0],)
      else :
        print convert(ufmt(_(u"Le premier argument de : %s doit etre un "
                             u"tuple ou une chaine"), args))
      if type(args[1]) == tuple:
        self.args1 = args[1]
      elif type(args[1]) == str:
        self.args1 = (args[1],)
      else :
        print convert(ufmt(_(u"Le deuxi�me argument de :%s doit etre un "
                             u"tuple ou une chaine"), args))
      # cr�ation de la liste des mcs
      liste = []
      liste.extend(self.args0)
      liste.extend(self.args1)
      self.mcs = liste
      self.init_couples_permis()

   def init_couples_permis(self):
      """ Cr�e la liste des couples permis parmi les self.args, c�d pour chaque �l�ment
          de self.args0 cr�e tous les couples possibles avec un �l�ment de self.args1"""
      liste = []
      for arg0 in self.args0:
        for arg1 in self.args1:
          liste.append((arg0,arg1))
      self.liste_couples = liste

   def verif(self,args):
      """
          args peut etre un dictionnaire ou une liste. Les �l�ments de args
          sont soit les �l�ments de la liste soit les cl�s du dictionnaire.
      """
      # cr�ation de la liste des couples pr�sents dans le fichier de commandes
      l_couples = []
      couple = []
      text = u''
      test = 1
      for nom in args:
        if nom in self.mcs :
          couple.append(nom)
          if len(couple) == 2 :
            l_couples.append(tuple(couple))
            couple = [nom,]
      if len(couple) > 0 :
        l_couples.append(tuple(couple))
      # l_couples peut etre vide si l'on n'a pas r�ussi � trouver au moins un
      # �l�ment de self.mcs
      if len(l_couples) == 0 :
        message = ufmt(_(u"- Il faut qu'au moins un objet de la liste : %r"
                         u" soit suivi d'au moins un objet de la liste : %r"),
                       self.args0, self.args1)
        return message,0
      # A ce stade, on a trouv� des couples : il faut v�rifier qu'ils sont
      # tous licites
      num = 0
      for couple in l_couples :
        num = num+1
        if len(couple) == 1 :
          # on a un 'faux' couple
          if couple[0] not in self.args1:
            text = text + ufmt(_(u"- L'objet : %s doit �tre suivi d'un objet de la liste : %r\n"),
                               couple[0], self.args1)
            test = 0
          else :
            if num > 1 :
              # ce n'est pas le seul couple --> licite
              break
            else :
              text = text + ufmt(_(u"- L'objet : %s doit �tre pr�c�d� d'un objet de la liste : %r\n"),
                                 couple[0], self.args0)
              test = 0
        elif couple not in self.liste_couples :
          text = text + ufmt(_(u"- L'objet : %s ne peut �tre suivi de : %s\n"),
                             couple[0], couple[1])
          test = 0
      return text,test
