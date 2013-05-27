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



class PRESENT_PRESENT:
   """
      La r�gle v�rifie que si le premier mot-cl� de self.mcs est present 
          parmi les elements de args les autres doivent l'etre aussi

      Ces arguments sont transmis � la r�gle pour validation sous la forme 
      d'une liste de noms de mots-cl�s ou d'un dictionnaire dont 
      les cl�s sont des noms de mots-cl�s.
   """
   def verif(self,args):
      """
          La methode verif effectue la verification specifique � la r�gle.
          args peut etre un dictionnaire ou une liste. Les �l�ments de args
          sont soit les �l�ments de la liste soit les cl�s du dictionnaire.
      """
      #  on verifie que si le premier de la liste est present, 
      #    les autres le sont aussi
      mc0=self.mcs[0]
      text=''
      test = 1
      args = self.liste_to_dico(args)
      if args.has_key(mc0):
        for mc in self.mcs[1:len(self.mcs)]:
          if not args.has_key(mc):
            text = text + u"- Le mot cl� "+`mc0`+ u" �tant pr�sent, il faut que : "+mc+ u" soit pr�sent"+'\n'
            test = 0
      return text,test
