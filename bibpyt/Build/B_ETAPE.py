#@ MODIF B_ETAPE Build  DATE 20/09/2004   AUTEUR DURAND C.DURAND 
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
"""
# Modules Python
import types,string,repr
import traceback

# Module Eficas
from Noyau.N_utils import prbanner
from Noyau.N_utils import AsType
from Noyau import N_MCSIMP,N_MCFACT,N_MCBLOC,N_MCLIST,N_ASSD
from Noyau import N_FACT,N_BLOC,N_SIMP
from Noyau.N_Exception import AsException
from Noyau.N_ASSD import ASSD
import B_utils
from B_CODE import CODE
import B_OBJECT

class ETAPE(B_OBJECT.OBJECT,CODE):
   """
   Cette classe impl�mente les m�thodes relatives � la phase de construction d'une �tape.
   """

   def affiche_cmd(self):
      """
      Permet d'afficher une information apres avoir affecte le numero de commande.
   
      N'est pas utilis�e par d�faut.
      """
      pass

   def set_icmd(self,icmd):
      """
      Demande au jdc un numero de commande unique.

      @param icmd: entier indiquant l'incr�ment de numero de commande demand� (en g�n�ral 1)
      """
      if icmd is not None:
          self.icmd=self.jdc.icmd=self.jdc.icmd+icmd
      else:
          self.icmd=None
      self.affiche_cmd()

   def Build(self):
      """ 
          Fonction : Construction d'une �tape de type OPER ou PROC
           En g�n�ral, il n'y a pas de construction � faire
      """
      ier= self._Build()
      return ier

   def _Build(self):
      """
         Cette m�thode r�alise le traitement de construction pour 
         l'objet lui meme
      """
      if CONTEXT.debug : print "ETAPE._Build ",self.nom
      # On demande d incrementer le compteur de la commande de 1
      self.set_icmd(1)
      return 0

   def setmode(self,mode):
      """
         Met le mode d execution a 1 ou 2
         1 = verification par le module Fortran correspondant a la commande
         2 = execution du module Fortran
      """
      if mode in (1,2):
         self.modexec=mode

   def getres(self):
      """
          Retourne le nom du resultat, le nom du concept
          et le nom de la commande
          Ces noms sont en majuscules et completes par des
          blancs jusqu a une longueur de 8
          Utilise par l interface C-FORTRAN
      """
      if CONTEXT.debug : prbanner("getres " + self.nom + " " + repr.repr(self))

      # self ne peut etre qu'un objet de type ETAPE

      nom_cmd=string.ljust(self.definition.nom,8)
      nom_concept=" "
      type_concept=" "
      if self.sd != None:
        nom_concept=string.ljust(self.sd.get_name(),8)
        type_concept=string.upper(self.sd.__class__.__name__)

      assert(nom_concept!=None),"getres : nom_concept est Vide (None)"
      if CONTEXT.debug :
         print "\tGETRES : nom_concept=",'"'+nom_concept+'"'
         print "\tGETRES : type_concept=",'"'+type_concept+'"'
         print "\tGETRES : nom_cmd=",'"'+nom_cmd+'"'
      return nom_concept,type_concept,nom_cmd

   def getfac(self,nom_motfac):
      """
        - Retourne le nombre d occurences du mot cle facteur nom_motfac
          dans l'objet self : on examine les fils presents sinon on recherche dans
          les defauts.
        - est utilise par l'interface C-FORTRAN.
      """
      if CONTEXT.debug : prbanner("getfac %s " %(nom_motfac,))

      nomfac=string.strip(nom_motfac)
      taille=0
      for child in self.mc_liste:
          if child.nom == nomfac :
             if isinstance(child,N_MCFACT.MCFACT) :
                taille=1
                break
             elif isinstance(child,N_MCLIST.MCList) :
                taille=len(child.data)
                break
             else :
                raise AsException( "incoherence de type dans getfac" )
          elif isinstance(child,N_MCBLOC.MCBLOC) :
             taille= child.getfac( nom_motfac )
             if taille:break

      # On cherche si un mot cle par defaut existe
      if taille == 0 :
          assert(hasattr(self,'definition'))
          assert(hasattr(self.definition,'entites'))
          if self.definition.entites.has_key(nomfac) :
                  assert(type(self.definition.entites[nomfac]) == types.InstanceType)
                  assert(hasattr(self.definition.entites[nomfac],'statut'))
                  if self.definition.entites[nomfac].statut == 'd' :
                          taille=1

      if taille == 0:
         # On verifie que la definition du mot-cle nom_motfac existe
         if self.getexm(nom_motfac,'')==0 :
            raise AsException("le mot cl� facteur "+nom_motfac+" n existe pas dans le catalogue de la commande")

      if CONTEXT.debug : print '\tGETFAC : ',"taille=",taille
      return taille

   def getexm(self,nom_motfac,nom_motcle):
      """ Fonction :
             retourne 1 si :
                   - le mot-cle de nom nom_motcle existe dans le mot-cle facteur
                     de nom nom_motfac
                   - ou si le mot-cle de nom nom_motcle existe dans l'etape
                     self, dans ce cas nom_motfac est blanc (ou vide)
                   - ou si le mot-cle de nom nom_motfac existe dans l'etape
                     self, dans cas nom_motcle est blanc (ou vide).
             dans le cas contraire getexm retourne la valeur 0.
      """
      if CONTEXT.debug : prbanner("getexm '%s' '%s' "%(nom_motfac,nom_motcle))

      nom_motfac=string.strip(nom_motfac)
      nom_motcle=string.strip(nom_motcle)
      assert(nom_motfac!="" or nom_motcle!="")

      presence=0
      if nom_motfac == "" :
        if self.definition.get_entite(nom=nom_motcle,typ=N_SIMP.SIMP) != None :
           presence=1
      else:
        if nom_motcle=="" :
           # ici on recherche nom_motfac dans l'etape courante
           if self.definition.get_entite(nom=nom_motfac,typ=N_FACT.FACT) != None :
              presence=1
        else :
           l_mot_fac = self.definition.getmcfs(nom_motfac)
           for mot_fac in l_mot_fac :
              if mot_fac.get_entite(nom=nom_motcle,typ=N_SIMP.SIMP) != None :
                 presence=1
                 break
      if CONTEXT.debug : print '\tGETEXM : ',"presence= ",presence
      assert(presence==1 or presence==0),'presence='+`presence`
      return presence

   def getvtx(self,nom_motfac,nom_motcle,iocc,iarg,mxval):
      """
         Cette m�thode retourne la valeur du mot-cl� simple nom_motcle de la commande self.
         Ce mot cl� peut etre directement sous la commande (nom_motfac == "") ou sous
         un mot cle facteur (nom_motfac != "").
         Dans ce cas iocc indique le num�ro du mot-cl� facteur � utiliser
      """
      if CONTEXT.debug : prbanner("getvtx %s %s %d %d %d" %(nom_motfac,nom_motcle,iocc,iarg,mxval))

      valeur=self.get_valeur_mc(nom_motfac,nom_motcle,iocc,iarg,mxval)
      valeur=self.Traite_DEFI_VALEUR(valeur,"TX")
      if CONTEXT.debug :
         B_utils.TraceGet( 'GETVTX',nom_motfac,iocc,nom_motcle,valeur)
         for k in valeur[1] : assert(type(k)==types.StringType)
      # il faut prendre en compte le catalogue : 'TXM' --> on retourne la chaine en majuscules,
      # 'TX' --> on la retourne telle qu'elle est
      return valeur

   def get_valeur_mc(self,nom_motfac,nom_motcle,iocc,iarg,mxval):
      """ 
          M�thode g�n�rique pour retourner la valeur de nom_motfac/nom_motcle 
      """
      nom_motfac=string.strip(nom_motfac)
      nom_motcle=string.strip(nom_motcle)

      # iocc-1 car iocc, numero fortran commencant a 1, est utilise par une m�thode python.
      # en python la numerotation commence a 0

      valeur=self.get_valeur_motcle(nom_motfac,iocc-1,nom_motcle)
      if valeur == None:
         retval=0,()
      else :
         retval=B_utils.RETLIST(valeur,mxval)

      if CONTEXT.debug : print "\tget_valeur_mc : ",retval
      return retval

   def get_valeur_motcle(self,nom_motfac,iocc,nom_motcle) :
      """
         Cette m�thode a pour but de retourner la valeur du MCS nom_motcle
         de la i�me occurrence du MCF nom_motfac, en tenant compte des valeurs par d�faut.
      """
      if self.getexm(nom_motfac,nom_motcle)==0 :
        raise AsException("le couple mcfact ="+nom_motfac+" mcsimp ="+nom_motcle+" n existe pas dans le catalogue")

      if nom_motfac != None and nom_motfac != '':
        # on doit rechercher la i�me occurrence du MCF nom_motfac
        try:
           motfac=self.get_mocle(nom_motfac)[iocc]
        except:
           if CONTEXT.debug : 
              print "\terreur � la recherche de :",nom_motfac
              traceback.print_exc()
           return None

        try:
           return motfac.get_mocle(nom_motcle)
        except:
           if CONTEXT.debug : 
              print "\terreur � la recherche de :",nom_motcle
              traceback.print_exc()
           return None

      else :
        try:
           return self.get_mocle(nom_motcle)
        except:
           if CONTEXT.debug : 
              print "\terreur � la recherche de :",nom_motcle
              traceback.print_exc()
           return None

   def get_valeur_motcle_pour_getvid(self,nom_motfac,iocc,nom_motcle) :
      """ 
          Cette m�thode a pour but de retourner la valeur du MCS nom_motcle
          de la i�me occurrence du MCF nom_motfac.
      """
      valeur=self.get_valeur_motcle(nom_motfac,iocc,nom_motcle)
      if valeur :
          return self.transforme_valeur_nom(valeur)
      else :
          return None

   def transforme_valeur_nom(self,valeur):
      """ 
          Cette m�thode a pour but de retourner soit une chaine de caract�res repr�sentant valeur
          (dans le cas ou valeur n'est pas une instance retourne la string valeur, sinon retourne valeur.nom)
          Traite le cas ou valeur est un tuple d'instances et retourne alors le tuple des strings
      """
      # utile pour getvid

      if type(valeur)==types.InstanceType :
         return valeur.nom
      elif type(valeur)==types.TupleType :
         l=[]
         for obj in valeur :
             l.append(self.transforme_valeur_nom(obj))
         return tuple(l)
      else :
         return valeur

   def Traite_DEFI_VALEUR(self,valeur,leType) :
      """
          Classe  : B_ETAPE.ETAPE
          Auteurs : CC & AY
          Methode : Traite_DEFI_VALEUR
          INTENTION : Traitement du cas ou la donnee a ete introduite par DEFI_VALEUR
                      Dans ce cas, l'objet lui-meme est retourne et non sa valeur !!!
      """

      if CONTEXT.debug : print "Traite_DEFI_VALEUR: ",valeur,leType
      assert(type(leType)==types.StringType)
      assert(leType=="IS" or leType=="R8" or leType=="TX" or leType=="C8" or leType=="LS")

      if valeur[0] == 0:return valeur

      tup_avant=valeur[1]
      list_apres=[]
      for k in tup_avant :
          if isinstance(k,N_ASSD.ASSD):
              if not k.etape:
                 # Il s'agit d'un concept issu d'une poursuite, on l'evalue
                 k=self.codex.getvectjev(k.get_name())
              else:
                 k=k.etape[leType]
             
              if CONTEXT.debug : print "valeur evaluee: ",k
          if type(k) in ( types.TupleType ,types.ListType) :
              if leType == "C8" and k[0] in ("MP","RI") :
                 # on est en presence d'un complexe isol�
                 list_apres.append( k )
              else:
                 # on est en presence d'une liste de (R8,IS,TX,LS)
                 list_apres.extend( k )
          else:
              # on est en presence d'un (R8,IS,TX,LS) isol�
              list_apres.append( k )

      if valeur[0] < 0:
         # la longueur initiale etait superieure a mxval. 
         # Elle ne peut qu'augmenter
         valeur_apres=( -len(list_apres) , tuple(list_apres) ) 
      else:
         valeur_apres=( len(list_apres) , tuple(list_apres) ) 

      return valeur_apres

   def retnom( self ) :
      """
         Methode B_ETAPE.ETAPE.retnom
         Auteur : Antoine Yessayan
         Intention : retourne au C le nom de la commande courante
      """
      return self.nom

   def getltx(self,nom_motfac,nom_motcle,iocc,iarg,mxval):
      """
         Methode B_ETAPE.ETAPE.getltx
         Auteur : Antoine Tessayan
         Intention : r�cup�rer dans un tuple la longueur des variables de type texte
                     du mocle nom_motcle
      """
      if CONTEXT.debug : prbanner("getltx %s %s %d %d %d" %(nom_motfac,nom_motcle,iocc,iarg,mxval))

      # Recuperation des chaines elles memes

      tup=self.getvtx(nom_motfac,nom_motcle,iocc,iarg,mxval) ;

      # stockage des longueurs des chaines dans un tuple
      longueurs=[]
      k=0
      for  chaine in tup[1] :
          assert(type(chaine)==types.StringType)
          longueurs.append(len(chaine))
          k = k+1
      assert(k==tup[0])
      if CONTEXT.debug : print "\tGETLTX : isval =",longueurs
      return k,tuple(longueurs)

   def getvis(self,nom_motfac,nom_motcle,iocc,iarg,mxval):
      """
         Methode B_ETAPE.ETAPE.getvis
         Auteur : Christian Car�moli
         Intention : r�cup�rer la liste des valeurs enti�res pour le mot-cle passe
                     en argument (cette fonction traite les blocs)
      """
      if CONTEXT.debug : prbanner("getvis %s %s %d %d %d" %(nom_motfac,nom_motcle,iocc,iarg,mxval))

      valeur=self.get_valeur_mc(nom_motfac,nom_motcle,iocc,iarg,mxval)
      valeur=self.Traite_DEFI_VALEUR(valeur,"IS")
      if CONTEXT.debug :
         B_utils.TraceGet( 'GETVIS',nom_motfac,iocc,nom_motcle,valeur)
         for k in valeur[1] : assert(type(k)==types.IntType),type(k)
      return valeur

   def getoper(self):
      """ Toutes classes : ETAPE, PROC_ETAPE, MACRO_ETAPE
           retourne le numero de l operateur
      """
      if self.definition.op is None : raise "Numero (attribut op) de la commande non defini"
      return self.definition.op

   def getran(self,):
      """
         Cette methode retourne un reel aleatoire
      """

      if self.jdc.alea==None :
      # le generateur n'a pas ete initialise, on l'initialise
         bidon=self.iniran(0)
      valeur=self.jdc.alea.random()
      resu=(valeur,)
      return resu

   def iniran(self,jump=0):
      """
         Cette methode initialise le generateur de nombres pseudo-aleatoires,
          et fait faire un saut de jump termes dans la suite de nombre.
      """

      from random import Random
      self.jdc.alea=Random(100)
      self.jdc.alea.jumpahead(jump)
      return None

   def fiintf(self,nom_fonction,nom_param,val):
      """
         Cette methode permet d'appeler une formule python depuis le fortran
         Elle �value les concepts FORMULE
      """
      nom_fonction=string.strip(nom_fonction)
      nom_param   =map(string.strip,nom_param)
      objet_sd    =self.parent.get_sd_avant_etape(nom_fonction,self)
      if len(nom_param)!=len(val) :
         self.cr.fatal("""<E> <FORMULE> nombre de valeurs diff�rent du nombre de param�tres""")
         return None
# appel de fonction definie dans le corps du jeu de commandes
      if self.gettco(nom_fonction)=='FORMULE':
           send_val=[]
           for param in objet_sd.nompar :
               send_val.append(val[nom_param.index(param)])
           res = objet_sd(*send_val)
      return res

   def getvr8(self,nom_motfac,nom_motcle,iocc,iarg,mxval):
      """
         Cette methode retourne la valeur du mot cle simple nom_motcle de type R8
      """
      if CONTEXT.debug : prbanner("getvr8 %s %s %d %d %d" %(nom_motfac,nom_motcle,iocc,iarg,mxval))

      valeur=self.get_valeur_mc(nom_motfac,nom_motcle,iocc,iarg,mxval)
      valeur=self.Traite_DEFI_VALEUR(valeur,"R8")
      if CONTEXT.debug :
         B_utils.TraceGet( 'GETVR8',nom_motfac,iocc,nom_motcle,valeur)
         for k in valeur[1] : assert(type(k)==types.FloatType),`k`+" n'est pas un float"
      return valeur

   def getvc8(self,nom_motfac,nom_motcle,iocc,iarg,mxval):
      """
         Methode B_ETAPE.ETAPE.getvc8
         Auteurs : FR/AY
         Intention : r�cup�rer la liste des valeurs complexes pour le mot-cle passe
                     en argument (cette fonction traite les blocs)
      """
      if CONTEXT.debug : prbanner("getvc8 %s %s %d %d %d" %(nom_motfac,nom_motcle,iocc,iarg,mxval))

      valeur=self.get_valeur_mc(nom_motfac,nom_motcle,iocc,iarg,mxval)
      valeur=self.Traite_DEFI_VALEUR(valeur,"C8")
      if CONTEXT.debug : 
         B_utils.TraceGet( 'GETVC8',nom_motfac,iocc,nom_motcle,valeur)
      return valeur

   def getvid(self,nom_motfac,nom_motcle,iocc,iarg,mxval):
      """
          Methode B_ETAPE.ETAPE.getvid
          Auteur : Christian Car�moli
          Intention : r�cup�rer la liste des valeurs pour le mot-cle passe
                      en argument (cette fonction traite les blocs)
      """
      if CONTEXT.debug : prbanner("getvid %s %s %d %d %d" %(nom_motfac,nom_motcle,iocc,iarg,mxval))

      nom_motfac=string.strip(nom_motfac)
      nom_motcle=string.strip(nom_motcle)

      # iocc-1 car iocc, numero fortran commencant a 1, est utilise par une methode python.
      # en python la numerotation commence a 0

      valeur=self.get_valeur_motcle_pour_getvid(nom_motfac,iocc-1,nom_motcle)
      if valeur == None:
         if CONTEXT.debug : print "\tGETVID : valeur =",None
         return 0,()
      valeur = B_utils.CONVID(valeur)
      valeur=B_utils.RETLIST(valeur,mxval)
      if CONTEXT.debug : print "\tGETVID : valeur =",valeur
      return valeur

   def getvls(self,nom_motfac,nom_motcle,iocc,iarg,mxval):
      """
         Methode B_ETAPE.ETAPE.getvls
         Auteur : Christian Car�moli
         Intention : r�cup�rer la liste des valeurs logiques pour le mot-cle passe
                     en argument (cette fonction traite les blocs)
      """
      if CONTEXT.debug : prbanner("getvls %s %s %d %d %d" %(nom_motfac,nom_motcle,iocc,iarg,mxval))

      valeur=self.get_valeur_mc(nom_motfac,nom_motcle,iocc,iarg,mxval)
      #XXX est ce IS ou LS ????
      valeur=self.Traite_DEFI_VALEUR(valeur,"IS")
      if CONTEXT.debug :
         B_utils.TraceGet( 'GETVLS',nom_motfac,iocc,nom_motcle,valeur)
         for k in valeur[1] : assert(type(k)==types.IntType)
      return valeur

   def gettco( self , nom_concept ) :
      """ 
          Methode : B_ETAPE.ETAPE.gettco
          Auteur : Antoine Yessayan
          Intention : retourne le type d'un concept a partir de son nom  passe
                en argument. Cette methode est a l'usage du superviseur Aster
      """
      no=string.strip(nom_concept)
      valeur=None

      try :
         # On essaie de recuperer le concept no parmi les concepts existant dans le contexte
         # avant l'�tape self
         objet_sd = self.parent.get_sd_avant_etape(no,self)
         if objet_sd == None: 
            # Si on n'a rien trouve
            if self.sd != None and self.sd.nom == no:
               # Et si l objet demande est le concept produit, on l'utilise
               objet_sd=self.sd
               #XXX Ne suffit peut etre pas a traiter completement le cas des concepts produits 
               # pour les macros. Il y a aussi ceux de self.sdprods
         assert(objet_sd != None)
         valeur=B_utils.Typast(AsType(objet_sd))
         valeur=string.upper(valeur)
      except :
         raise AsException("Probleme dans gettco: %s, %s ; Objet introuvable!" % (self.nom,nom_concept))
         valeur=' '

      return valeur

   def gettvc(self,nom):
      """
         Entrees:
           nom    nom de la constante
         Sorties:
           val    valeur de la constante
           iret   indicateur d existence de la constante
                  >0 la constante existe et a pour valeur val
                  =0 la constante n'existe pas
         Fonction:
           Indiquer si la constante nom existe dans le contexte Python
           et si elle existe retourner sa valeur
         Commentaires:
           la fonction retourne un doublet iret,val
      """
      try:
        val=eval(nom,self.jdc.const_context,self.parent.g_context)
        if val is None : 
           return 0,0
        if isinstance(val,ASSD):
           return self.getsdval(val)
        if val is not None:
           return 1,val
      except:
        if CONTEXT.debug:traceback.print_exc()
        pass
      return 0,0

   def getsdval(self,sd):
      """
        Fonction:
              Retourne la valeur d'un concept produit (sd) si il a une valeur
        Entrees:
              sd concept produit
        Sorties:
              Un tuple de longueur 2
                - 1er element : indique si le concept sd a une valeur (0=non,1=oui)
                - 2em element : la valeur du concept eventuelle
      """
      if sd.__class__.__name__ == 'reel':
         k=sd.etape['R8']
         return 1,k
      elif sd.__class__.__name__ == 'entier':
         k=sd.etape['IS']
         return 1,k
      else:
         return 0,0

   def getmjm(self,motfac,iocc,nbval):
      """
         Retourne des informations sur le mot cle facteur motfac du catalogue de la commande nomcmd
           motfac   : nom du mot cle facteur
           iocc     : numero d occurence du mot cle facteur
         Retour:
           motcle : liste des sous mots cles
           typ    : liste des types des sous mots cles
           nbarg  : nombre total d arguments du mot cle facteur(a priori ne doit etre utilise que par le superviseur)
      """
      motfac=string.strip(motfac)
      if motfac!='' :
         mcfact=self.get_mocle(motfac)
         if mcfact==None :
             return ([],[])
         else : mcfact=mcfact[iocc]
      else :
         mcfact=self
      # On a trouv� le mot cle facteur
      dico_mcsimp=mcfact.cree_dict_valeurs(mcfact.mc_liste)
      lmc=[]
      lty=[]
      for name in dico_mcsimp.keys() :
         if dico_mcsimp[name] != None :
            lmc.append(name)
            if type(dico_mcsimp[name]) in (types.ListType,types.TupleType) : obj=dico_mcsimp[name][0]
            else                                                           : obj=dico_mcsimp[name]
            if type(obj)==types.InstanceType :
               lty.append(obj.__class__.__name__)
            if type(obj)==types.FloatType        : lty.append('R8')
            if type(obj)==types.StringType       :
                if string.strip(obj) in ('RI','MP') : lty.append('C8')
                else                                : lty.append('TX')
            if type(obj)==types.IntType      :
            ### on gere le cas d un reel entre par l utilisateur sans le '.' distinctif d un entier
            ### pour ca on teste la presence de R8 dans la liste des types attendus cote catalogue
                                               child=mcfact.definition.get_entite(name)
                                               list_cata=B_utils.Typast(child.type)
                                               if ('IS ' not in list_cata) and  ('R8 ' in list_cata) :
                                                 lty.append('R8')
                                               else :
                                                 lty.append('I')
      return (lmc,lty)


   def getmat(self):
      """
          Retourne :
            la liste des noms de mots cles facteur sous l etape
      """
      liste=self.getlfact()
      return (liste,)

   def getlfact(self):
      """
          Retourne :
            la liste des noms de mots cles facteurs sous l etape
      """
      liste=[]
      for child in self.mc_liste :
        if isinstance(child,N_MCFACT.MCFACT) :
          liste.append(child.nom)
        elif isinstance(child,N_MCLIST.MCList) :
          liste.append(child[0].nom)
        elif isinstance(child,N_MCBLOC.MCBLOC) :
          liste= liste+child.getlfact()
      return liste

   def gcucon(self,icmd,resul,concep):
      """
          Entrees:
            icmd   numero d ordre de la commande
            resul  nom du concept
            concep type du concept
          Sorties:
            iexnum indicateur d existence ( 1=existe du bon type,
                                            0=n'existe pas,
                                           -1=existe d un autre type)
          Fonction:
            Retourner l indicateur d existence du concept vid avant
            la commande icmd
      """
      objet_sd = self.parent.get_sd_avant_etape(string.strip(resul),self)
      if not objet_sd:
            ret=0
      elif string.upper(B_utils.Typast(AsType(objet_sd))) == string.strip(concep):
            ret=1
      else:
            ret=-1
      return ret
