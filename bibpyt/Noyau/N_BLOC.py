#@ MODIF N_BLOC Noyau  DATE 29/05/2002   AUTEUR DURAND C.DURAND 
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
""" 
    Ce module contient la classe de definition BLOC
    qui permet de sp�cifier les caract�ristiques des blocs de mots cl�s 
"""

import types,string,sys
import traceback

import N_ENTITE
import N_MCBLOC
from N_Exception import AsException

class BLOC(N_ENTITE.ENTITE):
   """
    Classe pour definir un bloc de mots-cles

    Cette classe a deux attributs de classe :

    - class_instance qui indique la classe qui devra etre utilis�e 
            pour cr�er l'objet qui servira � controler la conformit� d'un 
            bloc de mots-cl�s avec sa d�finition

    - label qui indique la nature de l'objet de d�finition (ici, BLOC)

   """
   class_instance = N_MCBLOC.MCBLOC
   label = 'BLOC'

   def __init__(self,fr="",ang="",docu="",regles=(),statut='f',condition=None,
                     **args):
     
      """
          Un bloc est caract�ris� par les attributs suivants :

          - fr   : chaine de caractere commentaire pour aide en ligne (en francais)

          - ang : chaine de caractere commentaire pour aide en ligne (en anglais)

          - regles : liste d'objets de type REGLE pour v�rifier la coh�rence des sous-objets

          - statut : obligatoire ('o') ou facultatif ('f')

          - condition : chaine de caract�re evaluable par l'interpreteur Python

          - entites : dictionnaire contenant les sous-objets de self (mots-cl�s). La cl� du dictionnaire 
                     est le nom du mot-cl� et la valeur l'objet de d�finition correspondant. Cet attribut
                     est initialis� avec l'argument args de la m�thode __init__

      """
      # Initialisation des attributs
      self.fr=fr
      self.ang=ang
      self.docu=docu
      if type(regles)== types.TupleType:
          self.regles=regles
      else:
          self.regles=(regles,)
      self.statut=statut
      self.condition=condition
      self.entites=args
      self.affecter_parente()

   def __call__(self,val,nom,parent=None):
      """
          Construit un objet MCBLOC a partir de sa definition (self)
          de sa valeur (val), de son nom (nom) et de son parent dans l arboresence (parent)
      """
      return self.class_instance(nom=nom,definition=self,val=val,parent=parent)

   def verif_cata(self):
      """
         Cette m�thode v�rifie si les attributs de d�finition sont valides.
         Les �ventuels messages d'erreur sont �crits dans l'objet compte-rendu (self.cr).
      """
      if type(self.fr) != types.StringType :
        self.cr.fatal("L'attribut 'fr' doit etre une chaine de caract�res : %s" %`self.fr`)
      if type(self.docu) != types.StringType :
        self.cr.fatal("L'attribut 'docu' doit etre une chaine de caract�res : %s" %`self.docu`)
      if type(self.regles) != types.TupleType :
        self.cr.fatal("L'attribut 'regles' doit etre un tuple : %s" %`self.regles` )
      if self.statut not in ['f','o'] :
        self.cr.fatal("L'attribut 'statut' doit valoir 'o' ou 'f' : %s" %`self.statut` )
      if self.condition != None :
        if type(self.condition) != types.StringType :
          self.cr.fatal("L'attribut 'condition' doit etre une chaine de caract�res : %s" %`self.condition`)
      else:
        self.cr.fatal("La condition ne doit pas valoir None !")
      self.verif_cata_regles()

   def verif_presence(self,dict,globs):
      """
         Cette m�thode v�rifie si le dictionnaire pass� en argument (dict)
         est susceptible de contenir un bloc de mots-cl�s conforme � la 
         d�finition qu'il porte.

         Si la r�ponse est oui, la m�thode retourne 1

         Si la r�ponse est non, la m�thode retourne 0
 
         Le dictionnaire dict a pour cl�s les noms des mots-cl�s et pour valeurs
         les valeurs des mots-cl�s
      """
      # On recopie le dictionnaire pour prot�ger l'original 
      dico=dict.copy()
      if self.condition != None :
        try:
          test = eval(self.condition,globs,dico)
          return test
        except NameError:
          # erreur 'normale' : un mot-cl� n'est pas pr�sent et on veut l'�valuer dans la condition
          if CONTEXT.debug:
             l=traceback.format_exception(sys.exc_info()[0],sys.exc_info()[1],sys.exc_info()[2])
             print "WARNING : Erreur a l'evaluation de la condition "+string.join(l)
          return 0
        except SyntaxError:
          # le texte de la condition n'est pas du Python correct --> faute de catalogue
          l=traceback.format_exception(sys.exc_info()[0],sys.exc_info()[1],sys.exc_info()[2])
          raise AsException("Catalogue entite : ", self.nom,", de pere : ", self.pere.nom,
                     '\n',"Erreur dans la condition : ", self.condition,string.join(l))
        except:
          l=traceback.format_exception(sys.exc_info()[0],sys.exc_info()[1],sys.exc_info()[2])
          raise AsException("Catalogue entite : ", self.nom,", de pere : ", self.pere.nom,
                     '\n',"Erreur dans la condition : ", self.condition,string.join(l))
      else :
        return 0

