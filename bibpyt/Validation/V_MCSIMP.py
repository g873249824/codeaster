#@ MODIF V_MCSIMP Validation  DATE 20/01/2003   AUTEUR DURAND C.DURAND 
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

   def isvalid(self,cr='non'):
      """
         Cette m�thode retourne un indicateur de validit� de l'objet
         de type MCSIMP 
         
         - 0 si l'objet est invalide
 
         - 1 si l'objet est valide

         Le pram�tre cr permet de param�trer le traitement. Si cr == 'oui'
         la m�thode construit �galement un comte-rendu de validation
         dans self.cr qui doit avoir �t� cr�� pr�alablement.
      """
      if self.state == 'unchanged':
        return self.valid
      else:
        valid = 1
        if hasattr(self,'valid'):
          old_valid = self.valid
        else:
          old_valid = None
        v=self.valeur
        #  presence
        if self.isoblig() and v == None :
          if cr == 'oui' :
            self.cr.fatal(string.join(("Mot-cl� : ",self.nom," obligatoire non valoris�")))
          valid = 0
        # type,into ...
        valid = self.verif_type(cr=cr)*self.verif_into(cr=cr)*self.verif_card(cr=cr)
        self.valid = valid
        self.state = 'unchanged'
        # Si la validit� du mot cl� a chang�, on le signale � l'objet parent
        if old_valid:
          if old_valid != self.valid : self.init_modif_up()
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
      if type(self.valeur) in (types.ListType,types.TupleType) and 'C' not in self.definition.type :
        if len(self.valeur) < min or len(self.valeur)>max:
          if cr == 'oui':
            self.cr.fatal("Nombre d'arguments %s incorrects pour %s (min = %s, max = %s)" %(`self.valeur`,self.nom,min,max))
          card = 0
      else:
        if self.valeur == None :
          if min >= 1 :
            # on n'a pas d'objet et on en attend au moins un
            card=0
        else :
          if min > 1:
            # on n'a qu'un objet et on en attend plus d'1
            card = 0
      return card

   def verif_type(self,val=None,cr='non'):
      """
        FONCTION :
         Cette m�thode a plusieurs modes de fonctionnement li�s � la valeur de val et de cr.
         Si cr ne vaut pas 'oui' : elle ne remplit pas le compte-rendu self.cr
         Si val vaut None, elle v�rifie le type de self.valeur
         Si val ne vaut pas None, elle v�rifie le type de val
        PARAMETRE DE RETOUR :
         Cette m�thode retourne une valeur bool�enne qui vaut 1 si le type est correct ou 0 sinon
         
      """
      if val != None:
        valeur = val
      else:
        valeur = self.valeur
      if valeur == None :
        if cr == 'oui':
          self.cr.fatal("None n'est pas une valeur autoris�e")
        return 0
      if type(valeur) == types.TupleType:
        # on peut avoir � faire � un complexe ou une liste de valeurs ...
        if self.is_complexe(valeur) : return 1
        else:
          for val in valeur:
            if not self.verif_type(val=val,cr=cr) : return 0
          return 1
      elif type(valeur) == types.ListType:
        for val in valeur:
            if not self.verif_type(val=val,cr=cr) : return 0
        return 1
      else:
        # on n'a pas de tuple ...il faut tester sur tous les types ou les valeurs possibles
        # XXX Pourquoi into est il trait� ici et pas seulement dans verif_into ???
        if self.definition.into != None :
          try:
            if valeur in self.definition.into :
              return 1
            else:
              if cr == 'oui':
                self.cr.fatal("%s n'est pas une valeur autoris�e" %valeur)
              return 0
          except:
            print "probl�me avec :",self.nom
            print 'valeur =',valeur
            return 0
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
        if type(self.valeur)==types.TupleType :
          test = 1
          for val in self.valeur :
            if type(val)!=types.StringType and type(val)!=types.InstanceType:
              test = test*self.isinintervalle(val,cr=cr)
          return test
        else :
          val = self.valeur
          if type(val)!=types.StringType and type(val)!=types.InstanceType:
            return self.isinintervalle(self.valeur,cr=cr)
          else :
            return 1
      else :
        # on est dans le cas d'un ensemble discret de valeurs possibles (into)
        if type(self.valeur) == types.TupleType :
          for e in self.valeur:
            if e not in self.definition.into:
              if cr=='oui':
                self.cr.fatal(string.join(("La valeur :",`e`," n'est pas permise pour le mot-cl� :",self.nom)))
              return 0
        else:
          if self.valeur == None or self.valeur not in self.definition.into:
            if cr=='oui':
              self.cr.fatal(string.join(("La valeur :",`self.valeur`," n'est pas permise pour le mot-cl� :",self.nom)))
            return 0
        return 1

   def is_complexe(self,valeur):
      """ Retourne 1 si valeur est un complexe, 0 sinon """
      if type(valeur) == types.StringType :
        # on teste une valeur issue d'une entry (valeur saisie depuis EFICAS)
        #XXX Il serait peut etre plus judicieux d'appeler une m�thode de self.jdc
        #XXX qui retournerait l'objet r�sultat de l'�valuation
        #XXX ou meme de faire cette evaluation a l'exterieur de cette classe ??
        if not self.jdc :return 0
        try :
          valeur = eval(valeur,self.jdc.g_context)
        except:
          return 0
      if type(valeur) == types.InstanceType :
        #XXX je n'y touche pas pour ne pas tout casser mais il serait
        #XXX pr�f�rable d'appeler une m�thode de valeur : return valeur.is_type('C'), par exemple
        if valeur.__class__.__name__ in ('EVAL','complexe'):
          return 1
        elif valeur.__class__.__name__ in ('PARAMETRE','PARAMETRE_EVAL'):
          # il faut tester si la valeur du parametre est un entier
          #XXX ne serait ce pas plutot complexe ???? sinon expliquer
          return self.is_entier(valeur.valeur)
        else:
          print "Objet non reconnu dans is_complexe %s" %`valeur`
          return 0
      # Pour permettre l'utilisation de complexes Python
      #elif type(valeur) == types.ComplexType:
        #return 1
      elif type(valeur) != types.TupleType :
        return 0
      else:
        if len(valeur) != 3 :
          return 0
        else:
          if type(valeur[0]) != types.StringType : return 0
          if string.strip(valeur[0]) not in ('RI','MP'):
            return 0
          else:
            if not self.is_reel(valeur[1]) or not self.is_reel(valeur[2]) : return 0
            else: return 1

   def is_reel(self,valeur):
      """
      Retourne 1 si valeur est un reel, 0 sinon
      """
      if type(valeur) == types.StringType :
        # on teste une valeur issue d'une entry (valeur saisie depuis EFICAS)
        if not self.jdc :return 0
        try :
          valeur = eval(valeur,self.jdc.g_context)
        except:
          return 0
      if type(valeur) == types.InstanceType :
        #XXX je n'y touche pas pour ne pas tout casser mais il serait
        #XXX pr�f�rable d'appeler une m�thode de valeur : return valeur.is_type('R'), par exemple
        #XXX ou valeur.is_reel()
        #XXX ou encore valeur.compare(self.is_reel)
        if valeur.__class__.__name__ in ('EVAL','reel') :
          return 1
        elif valeur.__class__.__name__ in ('PARAMETRE','PARAMETRE_EVAL'):
          # il faut tester si la valeur du parametre est un r�el
          return self.is_reel(valeur.valeur)
        else:
          print "Objet non reconnu dans is_reel %s" %`valeur`
          return 0
      elif type(valeur) not in (types.IntType,types.FloatType,types.LongType):
        # ce n'est pas un r�el
        return 0
      else:
        return 1

   def is_entier(self,valeur):
      """ Retourne 1 si valeur est un entier, 0 sinon """
      if type(valeur) == types.StringType :
        # on teste une valeur issue d'une entry (valeur saisie depuis EFICAS)
        if not self.jdc :return 0
        try :
          valeur = eval(valeur,self.jdc.g_context)
        except:
          return 0
      if type(valeur) == types.InstanceType :
        #XXX je n'y touche pas pour ne pas tout casser mais il serait
        #XXX pr�f�rable d'appeler une m�thode de valeur : return valeur.is_type('I'), par exemple
        if valeur.__class__.__name__ in ('EVAL','entier') :
          return 1
        elif valeur.__class__.__name__ in ('PARAMETRE','PARAMETRE_EVAL'):
          # il faut tester si la valeur du parametre est un entier
          return self.is_entier(valeur.valeur)
        else:
          print "Objet non reconnu dans is_reel %s" %`valeur`
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
           Retourne 1 si valeur est un objet de la classe classe ou d'une sous-classe de classe,
           0 sinon 
      """
      if type(objet) != types.InstanceType :
        if type(objet) == types.StringType:
          if not self.jdc :return 0
          try :
            objet = eval(objet,self.jdc.g_context)
            if type(objet) != types.InstanceType : return 0
          except:
            return 0
        else:
          return 0
      if not objet.__class__ == classe and not issubclass(objet.__class__,classe):
        return 0
      else:
        return 1

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






