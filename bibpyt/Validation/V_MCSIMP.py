#@ MODIF V_MCSIMP Validation  DATE 19/09/2005   AUTEUR DURAND C.DURAND 
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

"""
   Ce module contient la classe mixin MCSIMP qui porte les m�thodes
   n�cessaires pour r�aliser la validation d'un objet de type MCSIMP
   d�riv� de OBJECT.

   Une classe mixin porte principalement des traitements et est
   utilis�e par h�ritage multiple pour composer les traitements.
"""
# Modules Python
import string,types
import traceback

# Modules EFICAS
from Noyau import N_CR
from Noyau.N_Exception import AsException

class MCSIMP:
   """
      COMMENTAIRE CCAR
        Cette classe est quasiment identique � la classe originale d'EFICAS
        a part quelques changements cosm�tiques et des chagements pour la
        faire fonctionner de facon plus autonome par rapport � l'environnement
        EFICAS
 
        A mon avis, il faudrait aller plus loin et r�duire les d�pendances
        amont au strict n�cessaire.

        - Est il indispensable de faire l'�valuation de la valeur dans le contexte
          du jdc dans cette classe.

        - Ne pourrait on pas doter les objets en pr�sence des m�thodes suffisantes
          pour �viter les tests un peu particuliers sur GEOM, PARAMETRE et autres. J'ai
          d'ailleurs modifi� la classe pour �viter l'import de GEOM
   """

   CR=N_CR.CR
   
   def __init__(self):
      self.state='undetermined'

   def get_valid(self):
       if hasattr(self,'valid'):
          return self.valid
       else:
          self.valid=None
          return None

   def set_valid(self,valid):
       old_valid=self.get_valid()
       self.valid = valid
       self.state = 'unchanged'
       if not old_valid or old_valid != self.valid :
           self.init_modif_up()

   def isvalid(self,cr='non'):
      """
         Cette m�thode retourne un indicateur de validit� de l'objet de type MCSIMP

           - 0 si l'objet est invalide
           - 1 si l'objet est valide

         Le param�tre cr permet de param�trer le traitement. Si cr == 'oui'
         la m�thode construit �galement un comte-rendu de validation
         dans self.cr qui doit avoir �t� cr�� pr�alablement.
      """
      if self.state == 'unchanged':
        return self.valid
      else:
        valid = 1
        v=self.valeur
        #  verification presence
        if self.isoblig() and v == None :
          if cr == 'oui' :
            self.cr.fatal(string.join(("Mot-cl� : ",self.nom," obligatoire non valoris�")))
          valid = 0

        if v is None:
           valid=0
           if cr == 'oui' :
              self.cr.fatal("None n'est pas une valeur autoris�e")
        else:
           # type,into ...
           valid = self.verif_type(val=v,cr=cr)*self.verif_into(cr=cr)*self.verif_card(cr=cr)
           #
           # On verifie les validateurs s'il y en a et si necessaire (valid == 1)
           #
           if valid and self.definition.validators and not self.definition.validators.verif(self.valeur):
              if cr == 'oui' :
                 self.cr.fatal(string.join(("Mot-cl� : ",self.nom,"devrait avoir ",self.definition.validators.info())))
              valid=0
           # fin des validateurs
           #

        self.set_valid(valid)
        return self.valid

   def isoblig(self):
      """ indique si le mot-cl� est obligatoire
      """
      return self.definition.statut=='o'

   def verif_card(self,cr='non'):
      """ 
         un mot-cl� simple ne peut etre r�p�t� :
           la cardinalit� ici s'entend par la v�rification que le nombre d'arguments de self.valeur
           est bien compris entre self.min et self.max dans le cas o� il s'agit d'une liste
      """
      card = 1
      min=self.definition.min
      max=self.definition.max

      if type(self.valeur) == types.TupleType and not self.valeur[0] in ('RI','MP') or type(self.valeur) == types.ListType:
        length=len(self.valeur)
      else:
        if self.valeur == None :
           length=0
        else:
           length=1

      if length < min or length >max:
         if cr == 'oui':
            self.cr.fatal("Nombre d'arguments de %s incorrect pour %s (min = %s, max = %s)" %(`self.valeur`,self.nom,min,max))
         card = 0
      return card

   def verif_type(self,val=None,cr='non'):
      """
        FONCTION :
         Cette methode verifie que le type de l'argument val est en conformite avec celui 
         qui est declare dans la definition du mot cle simple.
         Elle a plusieurs modes de fonctionnement li�s � la valeur de cr.
         Si cr vaut 'oui' : elle remplit le compte-rendu self.cr sinon elle ne le remplit pas.
        PARAMETRE DE RETOUR :
         Cette m�thode retourne une valeur bool�enne qui vaut 1 si le type de val est correct ou 0 sinon
         
      """
      valeur = val
      if valeur == None :
        if cr == 'oui':
          self.cr.fatal("None n'est pas une valeur autoris�e")
        return 0

      if type(valeur) == types.TupleType and not valeur[0] in ('RI','MP') or type(valeur) == types.ListType:
        # Ici on a identifi� une liste de valeurs
        for val in valeur:
            if not self.verif_type(val=val,cr=cr) : return 0
        return 1

      # Ici, valeur est un scalaire ...il faut tester sur tous les types ou les valeurs possibles

      for type_permis in self.definition.type:
          if self.compare_type(valeur,type_permis) : return 1

      # si on sort de la boucle pr�c�dente par ici c'est que l'on n'a trouv� aucun type valable --> valeur refus�e
      if cr =='oui':
          self.cr.fatal("%s n'est pas d'un type autoris�" %`valeur`)
      return 0

   def verif_into(self,cr='non'):
      """
      V�rifie si la valeur de self est bien dans l'ensemble discret de valeurs
      donn� dans le catalogue derri�re l'attribut into ou v�rifie que valeur est bien compris
      entre val_min et val_max
      """
      if self.definition.into == None :
        #on est dans le cas d'un ensemble continu de valeurs possibles (intervalle)
        if self.definition.val_min == '**' and self.definition.val_max == '**':
           # L'intervalle est infini, on ne fait pas de test
           return 1
        if type(self.valeur) == types.TupleType and not self.valeur[0] in ('RI','MP') or type(self.valeur) == types.ListType:
          # Cas d'une liste de valeurs
          test = 1
          for val in self.valeur :
            if type(val) != types.StringType and type(val) != types.InstanceType:
              test = test*self.isinintervalle(val,cr=cr)
          return test
        else :
          # Cas d'un scalaire
          val = self.valeur
          if type(val)!=types.StringType and type(val)!=types.InstanceType:
            return self.isinintervalle(self.valeur,cr=cr)
          else :
            return 1
      else :
        # on est dans le cas d'un ensemble discret de valeurs possibles (into)
        if type(self.valeur) == types.TupleType and not self.valeur[0] in ('RI','MP') or type(self.valeur) == types.ListType:
          # Cas d'une liste de valeur
          for e in self.valeur:
            if e not in self.definition.into:
              if cr=='oui':
                self.cr.fatal(string.join(("La valeur :",`e`," n'est pas permise pour le mot-cl� :",self.nom)))
              return 0
        else:
          if self.valeur not in self.definition.into:
            if cr=='oui':
              self.cr.fatal(string.join(("La valeur :",`self.valeur`," n'est pas permise pour le mot-cl� :",self.nom)))
            return 0
        return 1

   def is_complexe(self,valeur):
      """ Retourne 1 si valeur est un complexe, 0 sinon """
      if type(valeur) == types.InstanceType :
        #XXX je n'y touche pas pour ne pas tout casser mais il serait
        #XXX pr�f�rable d'appeler une m�thode de valeur : return valeur.is_type('C'), par exemple
        if valeur.__class__.__name__ in ('complexe','PARAMETRE_EVAL'):
          return 1
        elif valeur.__class__.__name__ in ('PARAMETRE',):
          # il faut tester si la valeur du parametre est un complexe
          return self.is_complexe(valeur.valeur)
        else:
          return 0
      elif type(valeur) in (types.ComplexType,types.IntType,types.FloatType,types.LongType):
      # Pour permettre l'utilisation de complexes Python
        return 1
      elif type(valeur) != types.TupleType :
        # On n'autorise pas les listes pour les complexes
        return 0
      elif len(valeur) != 3:return 0
      else:
          # Un complexe doit etre un tuple de longueur 3 avec 'RI' ou 'MP' comme premiere
          # valeur suivie de 2 reels.
          try:
             if string.strip(valeur[0]) in ('RI','MP') and self.is_reel(valeur[1]) and self.is_reel(valeur[2]):
                return 1
          except:
             return 0

   def is_reel(self,valeur):
      """
      Retourne 1 si valeur est un reel, 0 sinon
      """
      if type(valeur) == types.InstanceType :
        #XXX je n'y touche pas pour ne pas tout casser mais il serait
        #XXX pr�f�rable d'appeler une m�thode de valeur : return valeur.is_type('R'), par exemple
        #XXX ou valeur.is_reel()
        #XXX ou encore valeur.compare(self.is_reel)
        if valeur.__class__.__name__ in ('reel','PARAMETRE_EVAL') :
          return 1
        elif valeur.__class__.__name__ in ('PARAMETRE',):
          # il faut tester si la valeur du parametre est un r�el
          return self.is_reel(valeur.valeur)
        else:
          return 0
      elif type(valeur) not in (types.IntType,types.FloatType,types.LongType):
        # ce n'est pas un r�el
        return 0
      else:
        return 1

   def is_entier(self,valeur):
      """ Retourne 1 si valeur est un entier, 0 sinon """
      if type(valeur) == types.InstanceType :
        #XXX je n'y touche pas pour ne pas tout casser mais il serait
        #XXX pr�f�rable d'appeler une m�thode de valeur : return valeur.is_type('I'), par exemple
        if valeur.__class__.__name__ in ('entier','PARAMETRE_EVAL') :
          return 1
        elif valeur.__class__.__name__ in ('PARAMETRE',):
          # il faut tester si la valeur du parametre est un entier
          return self.is_entier(valeur.valeur)
        else:
          return 0
      elif type(valeur) not in (types.IntType,types.LongType):
        # ce n'est pas un entier
        return 0
      else:
        return 1

   def is_shell(self,valeur):
      """ 
          Retourne 1 si valeur est un shell, 0 sinon
          Pour l'instant aucune v�rification n'est faite
          On impose juste que valeur soit une string
      """
      if type(valeur) != types.StringType:
        return 0
      else:
        return 1

   def is_object_from(self,objet,classe):
      """
           Retourne 1 si objet est une instance de la classe classe, 0 sinon
      """
      if type(objet) != types.InstanceType :
        return 0

      if isinstance(objet,classe) :
        # On accepte les instances de la classe et des classes derivees 
        return 1

      return 0

   def compare_type(self,valeur,type_permis):
      """
          Fonction bool�enne qui retourne 1 si valeur est du type type_permis, 0 sinon
      """
      if type(valeur) == types.InstanceType and valeur.__class__.__name__ == 'PARAMETRE':
        if type(valeur.valeur) == types.TupleType :
          # on a � faire � un PARAMETRE qui d�finit une liste d'items
          # --> on teste sur la premi�re car on n'accepte que les liste homog�nes
          valeur = valeur.valeur[0]
      if type_permis == 'R':
        return self.is_reel(valeur)
      elif type_permis == 'I':
        return self.is_entier(valeur)
      elif type_permis == 'C':
        return self.is_complexe(valeur)
      elif type_permis == 'shell':
        return self.is_shell(valeur)
      elif type_permis == 'TXM':
        if type(valeur) != types.InstanceType:
          return type(valeur)==types.StringType
        else:
          #XXX je n'y touche pas pour ne pas tout casser mais il serait
          #XXX pr�f�rable d'appeler une m�thode de valeur : return valeur.is_type('TXM'), par exemple
          if valeur.__class__.__name__ == 'chaine' :
            return 1
          elif valeur.__class__.__name__ == 'PARAMETRE':
            # il faut tester si la valeur du parametre est une string
            return type(valeur.valeur)==types.StringType
          else:
            return 0
      elif type(type_permis) == types.ClassType:
        # on ne teste pas certains objets de type GEOM , assd, ...
        # On appelle la m�thode de classe is_object de type_permis.
        # Comme valeur peut etre de n'importe quel type on utilise la fonction (is_object.im_func)
        # et non pas la methode (is_object) ce qui risquerait de provoquer des erreurs
        if type_permis.is_object.im_func(valeur):
          return 1
        else :
          return self.is_object_from(valeur,type_permis)
      else:
        print "Type non encore g�r� %s" %`type_permis`
        print self.nom,self.parent.nom,self.jdc.fichier

   def isinintervalle(self,valeur,cr='non'):
      """
      Bool�enne qui retourne 1 si la valeur pass�e en argument est comprise dans
      le domaine de d�finition donn� dans le catalogue, 0 sinon.
      """
      if type(valeur) not in (types.IntType,types.FloatType,types.LongType) :
        return 1
      else :
        min = self.definition.val_min
        max = self.definition.val_max
        if min == '**': min = valeur -1
        if max == '**': max = valeur +1
        if valeur < min or valeur > max :
          if cr=='oui':
            self.cr.fatal(string.join(("La valeur :",`valeur`," du mot-cl� ",self.nom,\
                                       " est en dehors du domaine de validit� [",`min`,",",`max`,"]")))
          return 0
        else :
          return 1

   def init_modif_up(self):
      """
         Propage l'�tat modifi� au parent s'il existe et n'est l'objet 
         lui-meme
      """
      if self.parent and self.parent != self :
        self.parent.state = 'modified'

   def report(self):
      """ g�n�re le rapport de validation de self """
      self.cr=self.CR()
      self.cr.debut = "Mot-cl� simple : "+self.nom
      self.cr.fin = "Fin Mot-cl� simple : "+self.nom
      self.state = 'modified'
      try:
        self.isvalid(cr='oui')
      except AsException,e:
        if CONTEXT.debug : traceback.print_exc()
        self.cr.fatal(string.join(("Mot-cl� simple : ",self.nom,str(e))))
      return self.cr






