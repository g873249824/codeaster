#@ MODIF N_MACRO_ETAPE Noyau  DATE 23/10/2002   AUTEUR DURAND C.DURAND 
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
    Ce module contient la classe MACRO_ETAPE qui sert � v�rifier et � ex�cuter
    une commande
"""

# Modules Python
import types,sys,string
import traceback

# Modules EFICAS
import N_MCCOMPO
import N_ETAPE
from N_Exception import AsException
import N_utils
from N_utils import AsType

class MACRO_ETAPE(N_ETAPE.ETAPE):
   """

   """
   nature = "COMMANDE"
   def __init__(self,oper=None,reuse=None,args={}):
      """
         Attributs :

          - definition : objet portant les attributs de d�finition d'une �tape 
                         de type macro-commande. Il est initialis� par 
                          l'argument oper.

          - reuse : indique le concept d'entr�e r�utilis�. Il se trouvera donc
                    en sortie si les conditions d'ex�cution de l'op�rateur 
                    l'autorise

          - valeur : arguments d'entr�e de type mot-cl�=valeur. Initialis� 
                     avec l'argument args.

      """
      self.definition=oper
      self.reuse=reuse
      self.valeur=args
      self.nettoiargs()
      self.parent=CONTEXT.get_current_step()
      self.etape = self
      self.nom=oper.nom
      self.idracine=oper.label
      self.appel=N_utils.callee_where()
      self.mc_globaux={}
      self.g_context={}
      # Contexte courant
      self.current_context={}
      self.index_etape_courante=0
      self.etapes=[]
      self.sds=[]
      #  Dans le cas d'une macro �crite en Python, l'attribut Outputs est un 
      #  dictionnaire qui contient les concepts produits de sortie 
      #  (nom : ASSD) d�clar�s dans la fonction sd_prod
      self.Outputs={}
      self.sd=None
      self.actif=1
      self.sdprods=[]
      self.make_register()

   def make_register(self):
      """
         Initialise les attributs jdc, id, niveau et r�alise les enregistrements
         n�cessaires
      """
      if self.parent :
         self.jdc = self.parent.get_jdc_root()
         self.id=self.parent.register(self)
         self.niveau=None
      else:
         self.jdc = self.parent =None
         self.id=None
         self.niveau=None

   def Build_sd(self,nom):
      """
         Construit le concept produit de l'op�rateur. Deux cas 
         peuvent se pr�senter :
        
         - le parent n'est pas d�fini. Dans ce cas, l'�tape prend en charge 
           la cr�ation et le nommage du concept.

         - le parent est d�fini. Dans ce cas, l'�tape demande au parent la 
           cr�ation et le nommage du concept.

      """
      if not self.isactif():return
      self.sdnom=nom
      try:
         # On positionne la macro self en tant que current_step pour que les 
         # �tapes cr��es lors de l'appel � sd_prod et � op_init aient la macro
         #  comme parent 
         self.set_current_step()
         if self.parent:
            sd= self.parent.create_sdprod(self,nom)
            if type(self.definition.op_init) == types.FunctionType: 
               apply(self.definition.op_init,(self,self.parent.g_context))
         else:
            sd=self.get_sd_prod()
            if sd != None and self.reuse == None:
               # On ne nomme le concept que dans le cas de non reutilisation 
               # d un concept
               sd.nom=nom
         self.reset_current_step()
         if self.jdc and self.jdc.par_lot == "NON" :
            self.Execute()
         return sd
      except AsException,e:
         self.reset_current_step()
         raise AsException("Etape ",self.nom,'ligne : ',self.appel[0],
                              'fichier : ',self.appel[1],e)
      except EOFError:
         #self.reset_current_step()
         raise
      except :
         self.reset_current_step()
         l=traceback.format_exception(sys.exc_info()[0],sys.exc_info()[1],sys.exc_info()[2])
         raise AsException("Etape ",self.nom,'ligne : ',self.appel[0],
                           'fichier : ',self.appel[1]+'\n',
                            string.join(l))

   def get_sd_prod(self):
      """
        Retourne le concept r�sultat d'une macro �tape
        La difference avec une etape ou une proc-etape tient a ce que
         le concept produit peut exister ou pas
        Si sd_prod == None le concept produit n existe pas on retourne None
        Deux cas :
         cas 1 : sd_prod  n'est pas une fonction
                 il s'agit d'une sous classe de ASSD
                 on construit le sd � partir de cette classe
                 et on le retourne
         cas 2 : sd_prod est une fonction
                  on l'�value avec les mots-cl�s de l'�tape (mc_liste)
                 on construit le sd � partir de la classe obtenue
                 et on le retourne
      """
      sd_prod=self.definition.sd_prod
      self.typret=None
      if type(self.definition.sd_prod) == types.FunctionType:
        d=self.cree_dict_valeurs(self.mc_liste)
        try:
          # la sd_prod d'une macro a l'objet macro_etape lui meme en premier argument
          # Comme sd_prod peut invoquer la m�thode type_sdprod qui ajoute
          # les concepts produits dans self.sdprods, il faut le mettre � z�ro avant de l'appeler
          self.sdprods=[]
          sd_prod= apply(sd_prod,(self,),d)
        except EOFError:
          raise
        except:
          if CONTEXT.debug: traceback.print_exc()
          l=traceback.format_exception(sys.exc_info()[0],sys.exc_info()[1],sys.exc_info()[2])
          raise AsException("impossible d affecter un type au resultat\n",string.join(l[2:]))

      # on teste maintenant si la SD est r�utilis�e ou s'il faut la cr�er
      if self.reuse:
        # Il est preferable de traiter cette erreur ult�rieurement : ce n'est pas une erreur fatale
        #if AsType(self.reuse) != sd_prod:
        #  raise AsException("type de concept reutilise incompatible avec type produit")
        self.sd=self.reuse
      else:
        if sd_prod == None:
          self.sd=None
        else:
          self.sd= sd_prod(etape=self)
          self.typret=sd_prod
        # Si reuse n'a pas ete donn�, c'est une erreur. Ne pas corriger afin de la detecter ensuite
        #if self.definition.reentrant == 'o':
        #  self.reuse = self.sd
      return self.sd

   def get_type_produit(self,force=0):
      """
           Retourne le type du concept r�sultat de l'�tape et eventuellement type
            les concepts produits "� droite" du signe �gal (en entr�e)
           Deux cas :
            cas 1 : sd_prod de oper n'est pas une fonction
                    il s'agit d'une sous classe de ASSD
                    on retourne le nom de la classe
            cas 2 : il s'agit d'une fonction
                    on l'�value avec les mots-cl�s de l'�tape (mc_liste)
                    et on retourne son r�sultat
      """
      if not force and hasattr(self,'typret'): return self.typret
      if type(self.definition.sd_prod) == types.FunctionType:
        d=self.cree_dict_valeurs(self.mc_liste)
        try:
          # Comme sd_prod peut invoquer la m�thode type_sdprod qui ajoute
          # les concepts produits dans self.sdprods, il faut le mettre � z�ro
          self.sdprods=[]
          sd_prod= apply(self.definition.sd_prod,(self,),d)
        except:
          #traceback.print_exc()
          return None
      else:
        sd_prod=self.definition.sd_prod
      return sd_prod

   def get_contexte_avant(self,etape):
      """
          Retourne le dictionnaire des concepts connus avant etape
          pour les commandes internes a la macro
          On tient compte des commandes qui modifient le contexte
          comme DETRUIRE ou les macros
      """
      # L'�tape courante pour laquelle le contexte a �t� calcul� est 
      # m�moris�e dans self.index_etape_courante
      # Si on ins�re des commandes (par ex, dans EFICAS), il faut
      # pr�alablement remettre ce pointeur � 0
      if etape:
         index_etape=self.etapes.index(etape)
      else:
         index_etape=len(self.etapes)

      if index_etape >= self.index_etape_courante:
         # On calcule le contexte en partant du contexte existant
         d=self.current_context
         liste_etapes=self.etapes[self.index_etape_courante:index_etape]
      else:
         d=self.current_context={}
         liste_etapes=self.etapes

      for e in liste_etapes:
        if e is etape:
           break
        if e.isactif():
           e.update_context(d)
      self.index_etape_courante=index_etape
      return d

   def supprime(self):
      """
         M�thode qui supprime toutes les r�f�rences arri�res afin que 
         l'objet puisse etre correctement d�truit par le garbage collector
      """
      N_MCCOMPO.MCCOMPO.supprime(self)
      self.jdc=None
      self.appel=None
      if self.sd : self.sd.supprime()
      for concept in self.sdprods:
         concept.supprime()
      for etape in self.etapes:
         etape.supprime()

   def type_sdprod(self,co,t):
      """
           Cette methode a pour fonction de typer le concept co avec le type t
            dans les conditions suivantes
            1- co est un concept produit de self
            2- co est un concept libre : on le type et on l attribue � self
           Elle enregistre egalement les concepts produits (on fait l hypothese
            que la liste sdprods a �t� correctement initialisee, vide probablement)
      """
      if not hasattr(co,'etape'):
         # Le concept vaut None probablement. On ignore l'appel
         return

      if co.etape == None:
         # le concept est libre
         co.etape=self
         co.__class__ = t
         self.sdprods.append(co)
      elif co.etape== self:
         # le concept est produit par self
         co.__class__ = t
         self.sdprods.append(co)
      elif co.etape== self.parent:
         # le concept est produit par la macro superieure
         # on transfere la propriete
         # On verifie que le type du concept existant co.__class__ est un sur type de celui attendu
         # Cette r�gle est normalement coh�rente avec les r�gles de v�rification des mots-cl�s
         if not issubclass(t,co.__class__):
            raise AsException("Le type du concept produit %s devrait etre une sur classe de %s" %(co.__class__,t))
         co.etape=self
         co.__class__ = t
         self.sdprods.append(co)
      elif self.issubstep(co.etape):
         # Le concept est propri�t� d'une sous etape de self. Il doit etre considere
         # comme produit par la macro => ajout dans self.sdprods
         self.sdprods.append(co)
      else:
         # le concept est produit par une autre �tape
         return

   def issubstep(self,etape):
      """ 
          Cette methode retourne un entier indiquant si etape est une
          sous etape de la macro self ou non
          1 = oui
          0 = non
      """
      if etape in self.etapes:return 1
      for etap in self.etapes:
        if etap.issubstep(etape):return 1
      return 0

   def register(self,etape):
      """ 
          Enregistrement de etape dans le contexte de la macro : liste etapes 
          et demande d enregistrement global aupres du JDC
      """
      self.etapes.append(etape)
      idetape=self.jdc.g_register(etape)
      return idetape

   def reg_sd(self,sd):
      """ 
           Methode appelee dans l __init__ d un ASSD a sa creation pour
           s enregistrer (reserve aux ASSD cr��s au sein d'une MACRO)
      """
      self.sds.append(sd)
      return self.jdc.o_register(sd)

   def create_sdprod(self,etape,nomsd):
      """ 
          Intention : Cette methode doit fabriquer le concept produit retourne
                  par l'etape etape et le nommer.
                  Elle est appel�e � l'initiative de l'etape
                  pendant le processus de construction de cette etape : methode __call__
                  de la classe CMD (OPER ou MACRO)
                  Ce travail est r�alis� par le contexte sup�rieur (etape.parent)
                  car dans certains cas, le concept ne doit pas etre fabriqu� mais
                  l'etape doit simplement utiliser un concept pr�existant.
                  Cas 1 : etape.reuse != None : le concept est r�utilis�
                  Cas 2 : l'�tape appartient � une macro qui a d�clar� un concept
                          de sortie qui doit etre produit par cette etape.
      """
      if self.Outputs.has_key(nomsd):
         # Il s'agit d'un concept de sortie de la macro. Il ne faut pas le cr�er
         # Il faut quand meme appeler la fonction sd_prod si elle existe.
         # get_type_produit le fait et donne le type attendu par la commande pour verification ult�rieure.
         sdprod=etape.get_type_produit()
         sd=self.Outputs[nomsd]
         # On verifie que le type du concept existant sd.__class__ est un sur type de celui attendu
         # Cette r�gle est normalement coh�rente avec les r�gles de v�rification des mots-cl�s
         if not issubclass(sdprod,sd.__class__):
            raise AsException("Le type du concept produit %s devrait etre une sur classe de %s" %(sd.__class__,sdprod))
         # La propriete du concept est transferee a l'etape avec le type attendu par l'�tape
         etape.sd=sd
         sd.etape=etape
         # On donne au concept le type produit par la sous commande.
         # Le principe est le suivant : apres avoir verifie que le type deduit par la sous commande
         # est bien coherent avec celui initialement affecte par la macro (voir ci dessus)
         # on affecte au concept ce type car il peut etre plus precis (derive, en general)
         sd.__class__=sdprod
         # On force �galement le nom stock� dans l'attribut sdnom : on lui donne le nom 
         # du concept associ� � nomsd
         etape.sdnom=sd.nom
      elif etape.reuse != None:
         # On est dans le cas d'une commande avec reutilisation d'un concept existant
         # get_sd_prod fait le necessaire : verifications, associations, etc. mais ne cree 
         # pas un nouveau concept. Il retourne le concept reutilise
         sd= etape.get_sd_prod()
         # Dans le cas d'un concept nomme automatiquement : _xxx, __xxx,
         # On force le nom stocke dans l'attribut sdnom  de l'objet etape : on lui donne le nom 
         # du concept  reutilise (sd ou etape.reuse c'est pareil)
         # Ceci est indispensable pour eviter des erreurs lors des verifications des macros
         # En effet une commande avec reutilisation d'un concept verifie que le nom de 
         # la variable a gauche du signe = est le meme que celui du concept reutilise.
         # Lorsqu'une telle commande apparait dans une macro, on supprime cette verification.
         if etape.sdnom[0] == '_':
            etape.sdnom=sd.nom
      else:
         # On est dans le cas de la creation d'un nouveau concept
         sd= etape.get_sd_prod()
         if sd != None :
            self.NommerSdprod(sd,nomsd)
      return sd

   def NommerSdprod(self,sd,sdnom,restrict='non'):
      """ 
          Cette methode est appelee par les etapes internes de la macro
          La macro appelle le JDC pour valider le nommage
          On considere que l espace de nom est unique et g�r� par le JDC
          Si le nom est deja utilise, l appel leve une exception
          Si restrict=='non', on insere le concept dans le contexte de la macro
          Si restrict=='oui', on n'insere pas le concept dans le contexte de la macro
      """
      # Normalement, lorsqu'on appelle cette methode, on ne veut nommer que des concepts nouvellement crees.
      # Le filtrage sur les concepts a creer ou a ne pas creer est fait dans la methode
      # create_sdprod. La seule chose a verifier apres conversion eventuelle du nom
      # est de verifier que le nom n'est pas deja attribue. Ceci est fait en delegant
      # au JDC par l'intermediaire du parent.

      #XXX attention inconsistence : prefix et gcncon ne sont pas 
      # d�finis dans le package Noyau. La methode NommerSdprod pour
      # les macros devrait peut etre etre d�plac�e dans Build ???

      if CONTEXT.debug : print "MACRO.NommerSdprod: ",sd,sdnom
      if hasattr(self,'prefix'):
        # Dans le cas de l'include_materiau on ajoute un prefixe au nom du concept
        if sdnom != self.prefix:sdnom=self.prefix+sdnom

      if self.Outputs.has_key(sdnom):
        # Il s'agit d'un concept de sortie de la macro produit par une sous commande
        sdnom=self.Outputs[sdnom].nom
      elif sdnom[0] == '_':
        # Si le nom du concept commence par le caractere _ on lui attribue
        # un identificateur JEVEUX construit par gcncon et respectant
        # la regle gcncon legerement adaptee ici
        # nom commencant par __ : il s'agit de concepts qui seront detruits
        # nom commencant par _ : il s'agit de concepts intermediaires qui seront gardes
        # ATTENTION : il faut traiter diff�remment les concepts dont le nom
        # commence par _ mais qui sont des concepts nomm�s automatiquement par
        # une �ventuelle sous macro.
        # Le test suivant n'est pas tres rigoureux mais permet de fonctionner pour le moment (a am�liorer)
        if sdnom[1] in string.digits:
          # Ce concept provient probablement d'une macro appelee par self
          pass
        elif sdnom[1] == '_':
          sdnom=self.gcncon('.')
        else:
          sdnom=self.gcncon('_')
      else:
        # On est dans le cas d'un nom de concept global. 
        pass

      if restrict == 'non':
         # On demande le nommage au parent mais sans ajout du concept dans le contexte du parent
         # car on va l'ajouter dans le contexte de la macro
         self.parent.NommerSdprod(sd,sdnom,restrict='oui')
         # On ajoute dans le contexte de la macro les concepts nommes
         # Ceci est indispensable pour les CO (macro) dans un INCLUDE
         self.g_context[sdnom]=sd
      else:
         # La demande de nommage vient probablement d'une macro qui a mis
         # le concept dans son contexte. On ne traite plus que le nommage (restrict="oui")
         self.parent.NommerSdprod(sd,sdnom,restrict='oui')

   def delete_concept_after_etape(self,etape,sd):
      """
          Met � jour les �tapes de la MACRO  qui sont apr�s etape suite �
          la disparition du concept sd
      """
      # Cette methode est d�finie dans le noyau mais ne sert que pendant la phase de creation
      # des etapes et des concepts. Il n'y a aucun traitement particulier � r�aliser
      # Dans d'autres conditions, il faudrait surcharger cette m�thode.
      return

   def accept(self,visitor):
      """
         Cette methode permet de parcourir l'arborescence des objets
         en utilisant le pattern VISITEUR
      """
      visitor.visitMACRO_ETAPE(self)

   def update_context(self,d):
      """
         Met � jour le contexte contenu dans le dictionnaire d
         Une MACRO_ETAPE peut ajouter plusieurs concepts dans le contexte
         Une fonction enregistree dans op_init peut egalement modifier le contexte
      """
      if type(self.definition.op_init) == types.FunctionType:
        apply(self.definition.op_init,(self,d))
      if self.sd != None:d[self.sd.nom]=self.sd
      for co in self.sdprods:
        d[co.nom]=co

   def make_include(self,unite=None):
      """
          Inclut un fichier dont l'unite logique est unite
      """
      if not unite : return
      f,text=self.get_file(unite=unite,fic_origine=self.parent.nom)
      self.fichier_init = f
      if f == None:return
      self.make_contexte(f,text)

   def make_poursuite(self):
      """
          Inclut un fichier poursuite
      """
      try:
         f,text=self.get_file(fic_origine=self.parent.nom)
      except:
         raise AsException("Impossible d'ouvrir la base pour une poursuite")
      self.fichier_init=f
      if f == None:return
      self.make_contexte(f,text)

   def make_contexte(self,f,text):
      """
          Interprete le texte fourni (text) issu du fichier f
          dans le contexte du parent.
          Cette methode est utile pour le fonctionnement des
          INCLUDE
      """
      # on execute le texte fourni dans le contexte forme par
      # le contexte de l etape pere (global au sens Python)
      # et le contexte de l etape (local au sens Python)
      code=compile(text,f,'exec')
      d={}
      self.g_context = d
      self.contexte_fichier_init = d
      globs=self.parent.get_global_contexte()
      exec code in globs,d

   def get_global_contexte(self):
      """
          Cette methode retourne le contexte global fourni
          par le parent(self) a une etape fille (l'appelant) pour
          realiser des evaluations de texte Python (INCLUDE,...)
      """
      # Le contexte global est forme par concatenation du contexte
      # du parent de self et de celui de l'etape elle meme (self)
      d=self.parent.get_global_contexte()
      d.update(self.g_context)
      return d







