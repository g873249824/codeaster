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
# ======================================================================


class AU_PLUS_UN:
   """
      La r�gle v�rifie que l'on trouve 1 (au plus) des mots-cl�s
      de la r�gle parmi les arguments d'un OBJECT.

      Ces arguments sont transmis � la r�gle pour validation sous la forme
      d'une liste de noms de mots-cl�s ou d'un dictionnaire dont
      les cl�s sont des noms de mots-cl�s.
   """
   def verif(self, args):
      """
          La m�thode verif v�rifie que l'on trouve 1 (au plus) des mos-cl�s
          de la liste self.mcs parmi les �l�ments de args

          args peut etre un dictionnaire ou une liste. Les �l�ments de args
          sont soit les �l�ments de la liste soit les cl�s du dictionnaire.
      """
      #  on compte le nombre de mots cles presents
      text = ''
      count = 0
      args = self.liste_to_dico(args)
      for mc in self.mcs:
         count = count + args.get(mc, 0)
      if count > 1:
         text = u"- Il ne faut qu'un mot-cl� (au plus) parmi : "+`self.mcs`+'\n'
         return text, 0
      return text, 1

   def liste_to_dico(self, args) :
      if type(args) is dict:
         return args
      elif type(args) in (list, tuple):
         dico={}
         for arg in args:
            dico[arg] = dico.get(arg, 0) + 1
         return dico
      else :
         raise Exception("Erreur ce n'est ni un dictionnaire ni une liste %s" % args)
