#@ MODIF ops Cata  DATE 23/08/2004   AUTEUR DURAND C.DURAND 
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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

# Modules Python
import types
import string,linecache,os,traceback,re
import pickle

# Modules Eficas
import Accas
from Accas import ASSD
from Noyau.N_FONCTION import formule

try:
   import aster
   # Si le module aster est pr�sent, on le connecte
   # au JDC
   import Build.B_CODE
   Build.B_CODE.CODE.codex=aster
except:
   pass

def DEBUT(self,PAR_LOT,CODE,**args):
   """
       Fonction sdprod de la macro DEBUT
   """
   # La commande DEBUT ne peut exister qu'au niveau jdc
   if self.jdc is not self.parent :
      raise Accas.AsException("La commande DEBUT ne peut exister qu'au niveau jdc")

   self.jdc.set_par_lot(PAR_LOT)
   if CODE!=None :
      self.jdc.fico=CODE['NOM']
   else:
      self.jdc.fico=None

def build_debut(self,**args):
   """
   Fonction ops pour la macro DEBUT
   """
   self.jdc.UserError=self.codex.error

   if self.jdc.par_lot == 'NON' :
      self.jdc._Build()
   # On execute la fonction debut pour initialiser les bases
   # Cette execution est indispensable avant toute autre action sur ASTER
   # op doit etre un entier car la fonction debut appelle GCECDU qui demande
   # le numero de l'operateur associ� (getoper)
   self.definition.op=0
   self.set_icmd(1)
   lot,ier=self.codex.debut(self,1)
   # On remet op a None juste apres pour eviter que la commande DEBUT
   # ne soit execut�e dans la phase d'execution
   self.definition.op=None
   return ier

def POURSUITE(self,PAR_LOT,CODE,**args):
   """
       Fonction sdprod de la macro POURSUITE
   """
   # La commande POURSUITE ne peut exister qu'au niveau jdc
   if self.jdc is not self.parent :
      raise Accas.AsException("La commande POURSUITE ne peut exister qu'au niveau jdc")

   self.jdc.set_par_lot(PAR_LOT)
   if CODE!=None :
      self.jdc.fico=CODE['NOM']
   else:
      self.jdc.fico=None
   if (self.codex and os.path.isfile("glob.1") or os.path.isfile("bhdf.1")):
     # Le module d'execution est accessible et glob.1 est present
     # Pour eviter de rappeler plusieurs fois la sequence d'initialisation
     # on memorise avec l'attribut fichier_init que l'initialisation
     # est r�alis�e
     if hasattr(self,'fichier_init'):return
     self.fichier_init='glob.1'
     self.jdc.initexec()
     # le sous programme fortran appel� par self.codex.poursu demande le numero
     # de l'operateur (GCECDU->getoper), on lui donne la valeur 0
     self.definition.op=0
     lot,ier,lonuti,concepts=self.codex.poursu(self,1)
     # Par la suite pour ne pas executer la commande pendant la phase
     # d'execution on le remet � None
     self.definition.op=None
     # On demande la numerotation de la commande POURSUITE avec l'incr�ment
     # lonuti pour qu'elle soit num�rot�e � la suite des commandes existantes.
     self.set_icmd(lonuti)
     pos=0
     d={}
     while pos+80 < len(concepts)+1:
       nomres=concepts[pos:pos+8]
       concep=concepts[pos+8:pos+24]
       nomcmd=concepts[pos+24:pos+40]
       statut=concepts[pos+40:pos+48]
       print nomres,concep,nomcmd,statut
       if nomres[0] not in (' ','.','&') and statut != '&DETRUIT':
          exec nomres+'='+string.lower(concep)+'()' in self.parent.g_context,d
       pos=pos+80
     for k,v in d.items():
       self.parent.NommerSdprod(v,k)
     self.g_context=d

     # Il peut exister un contexte python sauvegard� sous forme  pickled
     # On r�cup�re ces objets apr�s la restauration des concepts pour que
     # la r�cup�ration des objets pickled soit prioritaire.
     # On v�rifie que les concepts relus dans glob.1 sont bien tous
     # presents sous le meme nom et du meme type dans pick.1
     # Le contexte est ensuite updat� (surcharge) et donc enrichi des
     # variables qui ne sont pas des concepts.
     pickle_context=get_pickled_context()
     if pickle_context==None :
        self.jdc.cr.fatal("<F> Erreur a la relecture du fichier pick.1 : aucun objet sauvegard� ne sera r�cup�r�")
        return
     for elem in pickle_context.keys():
         if type(pickle_context[elem])==types.InstanceType :
            pickle_class=pickle_context[elem].__class__
            if elem in self.g_context.keys():
               poursu_class=self.g_context[elem].__class__
               if poursu_class!=pickle_class :
                  self.jdc.cr.fatal("<F> types incompatibles entre glob.1 et pick.1 pour concept de nom "+elem)
                  return
            else: 
               self.jdc.cr.fatal("<F> concept de nom "+elem+" et de type "+str(pickle_class)+" introuvable dans la base globale")
               return
     self.g_context.update(pickle_context)
     return

   else:
     # Si le module d'execution n est pas accessible ou glob.1 absent on 
     # demande un fichier (EFICAS)
     # Il faut �viter de r�interpr�ter le fichier � chaque appel de
     # POURSUITE
     if hasattr(self,'fichier_init'):
        return
     self.make_poursuite()

def get_pickled_context():
    """
       Cette fonction permet de r�importer dans le contexte courant du jdc (jdc.g_context)
       les objets python qui auraient �t� sauvegard�s, sous forme pickled, lors d'une 
       pr�c�dente �tude. Un fichier pick.1 doit etre pr�sent dans le r�pertoire de travail
    """
    if os.path.isfile("pick.1"):
       file="pick.1"
    else: return None
   
    # Le fichier pick.1 est pr�sent. On essaie de r�cup�rer les objets python sauvegard�s
    context={}
    try:
       file=open(file,'r')
       # Le contexte sauvegard� a �t� pickl� en une seule fois. Il est seulement
       # possible de le r�cup�rer en bloc. Si cette op�ration echoue, on ne r�cup�re
       # aucun objet.
       context=pickle.load(file)
       file.close()
    except:
       # En cas d'erreur on ignore le contenu du fichier
       # traceback.print_exc()
       return None

    return context

def POURSUITE_context(self,d):
   """
       Fonction op_init de la macro POURSUITE
   """
   # self repr�sente la macro POURSUITE ...
   d.update(self.g_context)
   # Une commande POURSUITE n'est possible qu'au niveau le plus haut
   # On ajoute directement les concepts dans le contexte du jdc
   # XXX est ce que les concepts ne sont pas ajout�s plusieurs fois ??
   for v in self.g_context.values():
      if isinstance(v,ASSD) : self.jdc.sds.append(v)

def build_poursuite(self,**args):
   """
   Fonction ops pour la macro POURSUITE
   """
   # Pour POURSUITE on ne modifie pas la valeur initialisee dans ops.POURSUITE
   # Il n y a pas besoin d executer self.codex.poursu (c'est deja fait dans
   # la fonction sdprod de la commande (ops.POURSUITE))
   self.jdc.UserError=self.codex.error
   return 0

def INCLUDE(self,UNITE,**args):
   """ 
       Fonction sd_prod pour la macro INCLUDE
   """
   if not UNITE : return
   if hasattr(self,'unite'):return
   self.unite=UNITE

   if self.jdc and self.jdc.par_lot == 'NON':
      # On est en mode commande par commande, on appelle la methode speciale
      self.Execute_alone()

   self.make_include(unite=UNITE)

def INCLUDE_context(self,d):
   """ 
       Fonction op_init pour macro INCLUDE
   """
   for k,v in self.g_context.items():
      d[k]=v

def build_include(self,**args):
   """
   Fonction ops de la macro INCLUDE appel�e lors de la phase de Build
   """
   # Pour presque toutes les commandes (sauf FORMULE et POURSUITE)
   # le numero de la commande n est pas utile en phase de construction
   # La macro INCLUDE ne sera pas num�rot�e (incr�ment=None)
   ier=0
   self.set_icmd(None)
   icmd=0
   # On n'execute pas l'ops d'include en phase BUILD car il ne sert a rien.
   #ier=self.codex.opsexe(self,icmd,-1,1)
   return ier

def detruire(self,d):
   """
       Cette fonction est la fonction op_init de la PROC DETRUIRE
   """
   if self["CONCEPT"]!=None:
     sd=[]
     for mc in self["CONCEPT"]:
       mcs=mc["NOM"]
       if type(mcs) == types.ListType or type(mcs) == types.TupleType:
         for e in mcs:
           if isinstance(e,ASSD):
             sd.append(e)
             e=e.nom
       # traitement particulier pour les listes de concepts, on va mettre � None
       # le terme de l'indice demand� dans la liste :
       # nomconcept_i est supprim�, nomconcept[i]=None
           indice=e[e.rfind('_')+1:]
           concept_racine=e[:e.rfind('_')]
           if indice!='' and d.has_key(concept_racine) and type(d[concept_racine])==types.ListType:
              try               :
                                  indici=int(indice)
                                  d[concept_racine][indici]=None
              except ValueError : pass
       # pour tous les concepts :
           if d.has_key(e):del d[e]
           if self.jdc.sds_dict.has_key(e):del self.jdc.sds_dict[e]
       else:
         if isinstance(mcs,ASSD):
           sd.append(mcs)
           mcs=mcs.nom
       # traitement particulier pour les listes de concepts, on va mettre � None
       # le terme de l'indice demand� dans la liste :
       # nomconcept_i est supprim�, nomconcept[i]=None
         indice=mcs[mcs.rfind('_')+1:]
         concept_racine=mcs[:mcs.rfind('_')]
         if indice!='' and d.has_key(concept_racine) and type(d[concept_racine])==types.ListType:
            try               :
                                indici=int(indice)
                                d[concept_racine][indici]=None
            except ValueError : pass
       # pour tous les concepts :
         if d.has_key(mcs):del d[mcs]
         if self.jdc.sds_dict.has_key(mcs):del self.jdc.sds_dict[mcs]
     for s in sd:
       # On signale au parent que le concept s n'existe plus apres l'�tape self 
       self.parent.delete_concept_after_etape(self,s)

def subst_materiau(text,NOM_MATER,EXTRACTION,UNITE_LONGUEUR):
   """
       Cette fonction retourne un texte obtenu � partir du texte pass� en argument (text)
       en substituant le nom du materiau par NOM_MATER 
       et en r�alisant les extractions sp�ciif�es dans EXTRACTION
   """
   lines=string.split(text,'\n')

##### traitement de UNIT : facteur multiplicatif puissance de 10
   regmcsu=re.compile(r" *(.*) *= *([^ ,]*) *## +([^ ]*) *([^ ]*)")
   ll_u=[]
   for l in lines:
       m=regmcsu.match(l)
       if m:
          if m.group(3) == "UNIT":
             if   UNITE_LONGUEUR=='M'  : coef = '0'
             elif UNITE_LONGUEUR=='MM' : coef = m.group(4)
             print ' UNITE_LONGUEUR = BINGO'
             print ' UNITE_LONGUEUR = ',m.group(4),type(m.group(4))
             ll_u.append('   '+m.group(1)+" = "+m.group(2)+coef)
          else : ll_u.append(l)
       else : ll_u.append(l)

##### traitement de EXTRACTION
   if EXTRACTION:
     regmcf=re.compile(r" *(.*) *= *_F\( *## +(.*) +(.*)")
     regmcs=re.compile(r" *(.*) *= *([^ ,]*) *, *## +([^ ]*) *([^ ]*)")
     regfin=re.compile(r" *\) *")
     ll=[]
     temps={};lmcf=[]
     for e in EXTRACTION:
       mcf=e['COMPOR']
       lmcf.append(mcf)
       temps[mcf]=e['TEMP_EVAL']
     FLAG=0
     for l in ll_u:
       m=regmcf.match(l)
       if m: # On a trouve un mot cle facteur "commentarise"
         if m.group(2) == "SUBST": # il est de plus substituable
           if temps.has_key(m.group(3)): # Il est a substituer
             ll.append(" "+m.group(3)+"=_F(")
             mcf=m.group(3)
             TEMP=temps[mcf]
             FLAG=1 # Indique que l'on est en cours de substitution
           else: # Il n est pas a substituer car il n est pas dans la liste demandee
             ll.append(l)
         else: # Mot cle facteur commentarise non substituable
           ll.append(l)
       else:  # La ligne ne contient pas un mot cle facteur commentarise
         if FLAG == 0: # On n est pas en cours de substitution
           ll.append(l)
         else: # On est en cours de substitution. On cherche les mots cles simples commentarises
           m=regmcs.match(l)
           if m: # On a trouve un mot cle simple commentarise
             if m.group(3) == "EVAL":
               ll.append("  "+m.group(1)+' = EVAL("'+m.group(4)+"("+str(TEMP)+')"),')
             elif m.group(3) == "SUPPR":
               pass
             else:
               ll.append(l)
           else: # On cherche la fin du mot cle facteur en cours de substitution
             m=regfin.match(l)
             if m: # On l a trouve. On le supprime de la liste
               FLAG=0
               del temps[mcf]
             ll.append(l)
   else:
     ll=ll_u

   for l in ll:
     print l
   lines=ll
   ll=[]
   for l in lines:
     l=re.sub(" *MAT *= *",NOM_MATER+" = ",l,1)
     ll.append(l)
   text=string.join(ll,'\n')
   return text

def post_INCLUDE(self):
  """
      Cette fonction est execut�e apres toutes les commandes d'un INCLUDE (RETOUR)
      Elle sert principalement pour les INCLUDE_MATERIAU : remise a blanc du prefixe Fortran
  """
  self.codex.opsexe(self,0,-1,2)

def INCLUDE_MATERIAU(self,NOM_AFNOR,TYPE_MODELE,VARIANTE,TYPE_VALE,NOM_MATER,
                    EXTRACTION,UNITE_LONGUEUR,INFO,**args):
  """ 
      Fonction sd_prod pour la macro INCLUDE_MATERIAU
  """
  mat=string.join((NOM_AFNOR,'_',TYPE_MODELE,'_',VARIANTE,'.',TYPE_VALE),'')
  if not hasattr(self,'mat') or self.mat != mat or self.nom_mater != NOM_MATER :
    # On r�cup�re le r�pertoire des mat�riaux dans les arguments 
    # suppl�mentaires du JDC
    rep_mat=self.jdc.args.get("rep_mat","NOrep_mat")
    f=os.path.join(rep_mat,mat)
    self.mat=mat
    self.nom_mater=NOM_MATER
    if not os.path.isfile(f):
       del self.mat
       self.make_contexte(f,"#Texte sans effet pour reinitialiser le contexte a vide\n")
       raise "Erreur sur le fichier materiau: "+f
    # Les materiaux sont uniquement disponibles en syntaxe Python
    # On lit le fichier et on supprime les �ventuels \r
    text=string.replace(open(f).read(),'\r\n','\n')
    # On effectue les substitutions necessaires
    self.prefix=NOM_MATER
    self.text= subst_materiau(text,NOM_MATER,EXTRACTION,UNITE_LONGUEUR)
    if INFO == 2:
      print "INCLUDE_MATERIAU: ", self.mat,' ',NOM_MATER,'\n'
      print self.text
    # on execute le texte fourni dans le contexte forme par
    # le contexte de l etape pere (global au sens Python)
    # et le contexte de l etape (local au sens Python)
    # Il faut auparavant l'enregistrer aupres du module linecache (utile pour nommage.py)
    linecache.cache[f]=0,0,string.split(self.text,'\n'),f

    self.postexec=post_INCLUDE

    if self.jdc.par_lot == 'NON':
      # On est en mode commande par commande, on appelle la methode speciale
      self.Execute_alone()

    self.make_contexte(f,self.text)

def build_formule(self,**args):
  """
  Fonction ops de la macro FORMULE appel�e lors de la phase de Build
  """
  from Build import B_utils
  for mc in self.mc_liste:
###    if mc.nom in ('REEL','ENTIER','COMPLEXE'):
    if mc.nom in ('REEL','COMPLEXE'):
      texte= self.sd.get_name()+ string.strip(mc.valeur)
      mc.valeur=B_utils.ReorganisationDe(texte,80)
  # ATTENTION : FORMULE est une des rares commandes qui a besoin de
  # connaitre son numero d execution avant d etre construite
  self.set_icmd(1)
  # La macro formule doit etre executee. Seules les macros qui ont
  # un numero d'op sont executees lors des phases suivantes
  self.definition.op = -5
  ier=self.codex.opsexe(self,self.icmd,-1,-self.definition.op)
  return ier

def build_procedure(self,**args):
    """
    Fonction ops de la macro PROCEDURE appel�e lors de la phase de Build
    """
    ier=0
    # Pour presque toutes les commandes (sauf FORMULE et POURSUITE)
    # le numero de la commande n est pas utile en phase de construction
    # On ne num�rote pas une macro PROCEDURE (incr�ment=None)
    self.set_icmd(None)
    icmd=0
    #ier=self.codex.opsexe(self,icmd,-1,3)
    return ier

def build_retour(self,**args):
    """
    Fonction ops de la macro RETOUR appel�e lors de la phase de Build
    """
    ier=0
    # Pour presque toutes les commandes (sauf FORMULE et POURSUITE)
    # le numero de la commande n est pas utile en phase de construction
    # On ne num�rote pas une macro RETOUR (incr�ment=None)
    self.set_icmd(None)
    icmd=0
    #ier=self.codex.opsexe(self,icmd,-1,2)
    return ier

