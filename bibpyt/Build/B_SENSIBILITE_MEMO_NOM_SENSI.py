#@ MODIF B_SENSIBILITE_MEMO_NOM_SENSI Build  DATE 18/12/2007   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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

"""
Classe pour la m�morisation des param�tres n�cessaires � la d�rivation du jdc.
"""

from sets import Set

# protection pour eficas
try:
   import aster
   from Utilitai.Utmess import  UTMESS
except:
   pass

#-------------------------------------------------------------------------------
_VIDE_ = '????????'

def addto(liste, obj):
   """Ajoute un �l�ment ou une s�quence en tant qu'�l�ment de 'liste'.
   """
   if type(obj) in (list, tuple):
      liste.extend(obj)
   else:
      liste.append(obj)


#-------------------------------------------------------------------------------
class MEMORISATION_SENSIBILITE:
   """Classe pour la m�morisation des concepts sensibles et leurs d�riv�es.
   """
   def __init__(self, jdc=None, debug=False):
      """Initialisation de la structure
      """
      self.jdc = jdc
      self._debug = debug
      # dictionnaire de correspondance : (sd_nominale, para_sensi) : sd_derivee
      self.d_sd_deriv = {}
      # dictionnaire inverse : sd_derivee : (sd_nominale, para_sensi)
      self.d_acces = {}
      
      # dictionnaire pour ne pas passer par le jdc.sds_dict par exemple : nom : sd
      self.d_sd = {}
      
      # dictionnaire : (sd_nominale, para_sensi) : 3 tuples ((mcsimp...), (valeur...), (mcfact...))
      #                l'ordre n'est pas le plus naturel mais on garde le m�me que dans le fortran
      self.d_mcle = {}
      # idem juste avec les noms : c'est celui-ci qu'on utilise car on ne peut pas pickler les mcfact/mcsimp
      self.d_nom_mcle = {}
      
      # liste des sd produites (par les commandes de calcul) qui doivent �tre stock�es dans la base jeveux
      self.l_regjv = []
      
      # liste de tous les para_sensi (m�me ceux qui ne sont pas utilis�s par la suite)
      self._all_para_sensi = Set()
      # dictionnaire : para_sensi : Set(commande1, commande2, ...)
      self.d_para_cmde = {}
      # dictionnaire : para_autre : Set()       (pour les theta geom)
      self.d_para_autre = {}
      

   def reparent(self, parent):
      """On a besoin du jdc p�re pour NommerSdprod.
      """
      self.jdc = parent      


   def add_commande(self, para, nom_cmde):
      """Ajoute une commande concern� par le param�tre sensible donn�.
      """
      if self.d_para_cmde.get(para) is None:
         self.d_para_cmde[para] = Set()
      if nom_cmde is not None:
         self.d_para_cmde[para].add(nom_cmde)
      if self._debug:
         print '#memo_sensi# add_commande : ', para, nom_cmde

   
   def add_para_sensi(self, para):
      """Ajoute un param�tre sensible. On verra plus tard si on l'utilise dans le jdc.
      """
      self._all_para_sensi.add(para)

   
   def used_para_sensi(self, para):
      """Ajoute un param�tre sensible utilis�.
      """
      self.add_commande(para, None)
      if self._debug:
         print '#memo_sensi# used_para_sensi : ', para, self.d_para_cmde[para]

   
   def add_para_autre(self, para):
      """Ajoute un param�tre autre (champ theta).
      """
      if self.d_para_autre.get(para) is None:
         self.d_para_autre[para] = Set()
      if self._debug:
         print '#memo_sensi# add_para_autre : ', para

   
   def memo_para_sensi(self, mc_liste, mc_sensi='SENSIBILITE'):
      """Cherche dans la liste des mots-cl�s le mot-cl� 'mc_sensi'
      et stocke le para_sensi."""
      is_sensi = 0
      for child in mc_liste:
         assert hasattr(child, 'get_sd_mcs_utilisees'), '%s (type %s)' % (child.nom, child.__class__.__name__)
         d_sd_mcs = child.get_sd_mcs_utilisees()
         # r�cup�re les param�tres pr�sents derri�re 'mc_sensi'
         liste = d_sd_mcs.get(mc_sensi,  [])
         if len(liste) > 0:
            is_sensi = 1
            # Un argument peut etre de deux types :
            # . soit c'est un param�tre sensible stricto sensu car il est dans la liste
            #   et alors on le marque comme 'utilis�'
            # . soit c'est un autre type de param�tre de d�rivation (champ theta par exemple)
            for argu in liste:
               if self._debug:
                  print '... Param�tre sensible :', argu.nom
               if self.is_para_sensi(argu):
                  self.used_para_sensi(argu)
               else:
                  self.add_para_autre(argu)
      return is_sensi


   def get_l_para_sensi(self):
      """Retourne la liste des para_sensi.
      """
      return self.d_para_cmde.keys()


   def get_l_para_autre(self):
      """Retourne la liste des param�tres autres.
      """
      return self.d_para_autre.keys()


   def get_l_commandes(self, para):
      """Retourne la liste des commandes concern�es par le para_sensi.
      """
      return list(self.d_para_cmde.get(para, []))


   def is_para_sensi(self, obj):
      """Retourne True si obj est dans la liste des para_sensi.
      """
      return obj in self._all_para_sensi

   
   def is_para_sensi_used(self, obj):
      """Retourne True si obj est un para_sensi utilis� pour la d�rivation du jdc.
      """
      return obj in self.get_l_para_sensi()


   def register(self, sd_nomi, para_sensi, sd_deriv=None, l_mcf_mcs_val=None, new_etape=None):
      """Enregistrement de la d�riv�e de 'sd_nomi' par rapport � 'para_sensi' dans 'sd_deriv'.
      """
      # mots-cl�s
      limofa, limocl, livale = [], [],  []
      if l_mcf_mcs_val:
         for mcf, mcs, val in l_mcf_mcs_val:
            addto(limofa, mcf)
            addto(limocl, mcs)
            addto(livale, val)
      limofa = tuple(limofa)
      limocl = tuple(limocl)
      livale = tuple(livale)

      if self._debug:
         print '#memo_sensi#register ', sd_nomi, para_sensi, sd_deriv, new_etape, limofa, limocl, livale
      # on demande l'enregistrement de la sd_deriv
      if new_etape is not None:
         sdnom = sd_deriv
         type_sd_deriv = new_etape.sd.__class__.__name__
         assert type(sd_deriv) == str
         sd_deriv = new_etape.sd.__class__(etape=new_etape)
         self.jdc.NommerSdprod(sd_deriv, sdnom)
         # enregistrement dans le tableau des concepts jeveux
         self.l_regjv.append(sd_deriv)
      
      # structure de m�morisation
      key = (sd_nomi, para_sensi)
      self.d_sd_deriv[key]   = sd_deriv
      self.d_acces[sd_deriv] = key
      self.d_mcle[key]       = (limocl, livale, limofa)
      self.d_nom_mcle[key]   = self.just_nom((limocl, livale, limofa))
      # sd
      for sd in (sd_nomi, para_sensi, sd_deriv):
         self.d_sd[sd.nom.strip()] = sd


   # appel� par SENSIBILITE_JDC.new_jdc
   def get_nom_compose(self, sd_nomi, para_sensi):
      """On r�cup�re la sd d�riv�e de sd_nomi par rapport � para_sensi.
      """
      key = (sd_nomi, para_sensi)
      sd_deriv = self.d_sd_deriv.get(key)
      return sd_deriv


   # appel� par SENSIBILITE_JDC.new_jdc
   def get_d_nom_s_c(self, para) :
      """Retourne un dictionnaire : sd_nomi : sd_deriv par rapport � ce param�tre sensible.
      """
      d = {}
      l_sd = [sd_nomi for sd_nomi, para_sensi in self.d_sd_deriv.keys() if para_sensi == para]
      for sd_nomi in l_sd:
         d[sd_nomi] = self.d_sd_deriv[(sd_nomi, para)]
      if self._debug:
         print '#memo_sensi#get_d_nom_s_c', d
      return d


   # appel� par psgenc (astermodule.c)
   def get_nocomp(self, nosimp, nopase):
      """On r�cup�re le nom compos� associ� � un nom simple et un para_sensi
      """
      key = self._key_(nosimp, nopase)
      sd_deriv   = self.get_nom_compose(*key)
      nocomp = _VIDE_
      if hasattr(sd_deriv, 'nom'):
         nocomp = sd_deriv.nom
      if self._debug:
         print '#memo_sensi#get_nocomp', nosimp, nopase, nocomp
      return nocomp


   # appel� par psgemc (astermodule.c)
   def get_mcle(self, nosimp, nopase):
      """On r�cup�re les mots-cl�s associ�s � un couple ('nom concept', 'nom para_sensi')
      """
      key = self._key_(nosimp, nopase)
      t_res = self.d_nom_mcle.get(key, ((), (), ()) )
      if self._debug:
         print '#memo_sensi#get_mcle ', nosimp, nopase, t_res
      return t_res


   # appel� par psinfo (astermodule.c)
   def psinfo(self, nom_co):
      """Pendant de l'ex-routine psnosd : retour selon le type de `nosimp`.
      Si nom_co est une d�riv�e, on retourne : 1, (sd_nomi, para_sensi).
      Si nom_co est une sd nominale, on retourne : 0, (deriv1, para1, deriv2, para2, ...)
      """
      sd = self.d_sd.get(nom_co.strip())
      # On n'a jamais vu nom_co (cas si pas de sensibilit�)
      if sd is None:
         return 0, ()
      # est-ce une structure d�riv�e ?
      if self.d_acces.get(sd) is not None:
         t_couples = self.d_acces[sd]
         ideriv = 1
      else:
         t_der = self.get_deriv(sd)
         # on met le tuple des couples � plat : un tuple de longueur double
         t_couples = []
         for l_obj in t_der:
            t_couples.extend(l_obj)
         t_couples = tuple(t_couples)
         ideriv = 0
      t_res = self.just_nom(t_couples)
      if self._debug:
         print '#memo_sensi#psinfo', nom_co, ideriv, t_res
      return ideriv, t_res


   # appel� par psinfo ici
   def get_deriv(self, sd):
      """On r�cup�re la liste des couples (sd_deriv, para_sensi) associ� � une sd nominale.
      """
      res = []
      # liste des para_sensi par rapport auxquels sd a �t� d�riv�e
      l_ps = [para_sensi for sd_nomi, para_sensi in self.d_sd_deriv.keys() if sd_nomi == sd]
      for para_sensi in l_ps:
         key = (sd, para_sensi)
         res.append((self.d_sd_deriv[key], para_sensi))
      return tuple(res)


   # appel� par regsen (astermodule.c)
   def register_sensi(self):
      """Enregistre les sd d�riv�es produites par les commandes principales pour qu'elles
      soient enregistr�es dans la base jeveux.
      """
      while len(self.l_regjv) > 0:
         sd = self.l_regjv.pop(0)
         typsd = sd.__class__.__name__
         icmdt = aster.co_register_jev(sd.nom, typsd.upper(), 'MEMO_NOM_SENSI')


   def _key_(self, nosimp, nopase):
      """Retourne la cl� (sd_nomi, para_sensi) � partir des noms.
      """
      return self.d_sd.get(nosimp.strip()), self.d_sd.get(nopase.strip())


   def just_nom(self, obj):
      """Retourne le nom de obj ou de chaque �l�ment de obj si c'est une
      list ou tuple ou tuple(tuple) ou...
      """
      in_type = type(obj)
      if in_type in (tuple, list):
         res = []
         for o in obj:
            res.append(self.just_nom(o))
         return in_type(res)
      else:
         return obj.nom


   def print_memo(self):
      """Affichage des correspondances sd_nomi, para_sensi, sd_deriv.
      """
      from pprint import pprint
      pprint(self.d_sd)
      pprint(self.d_sd_deriv)


   def __getstate__(self):
      """M�thode permettant de pickler les instances de MEMORISATION_SENSIBILITE.
      """
      d=self.__dict__.copy()
      # pourquoi d_mcle ? parce que mcsimp et mcfact ne sont pas pickables
      for key in ('jdc', 'd_mcle'):
         if d.has_key(key):
            del d[key]
      return d


   def __setstate__(self, state):
      """M�thode pour restaurer les attributs lors d'un unpickle.
      """
      self.__dict__.update(state)                  # update attributes
      self.jdc    = None
      self.d_mcle = {}



