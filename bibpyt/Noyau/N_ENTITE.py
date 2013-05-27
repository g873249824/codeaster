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


"""
    Ce module contient la classe ENTITE qui est la classe de base
    de toutes les classes de definition d'EFICAS.
"""

import re
import types
import N_CR
import N_OPS
import N_VALIDATOR
from strfunc import ufmt

class ENTITE:
   """
      Classe de base pour tous les objets de definition : mots cles et commandes
      Cette classe ne contient que des methodes utilitaires
      Elle ne peut �tre instanciee et doit d abord �tre specialisee
   """
   CR=N_CR.CR
   factories={'validator':N_VALIDATOR.validatorFactory}

   def __init__(self,validators=None):
      """
         Initialise les deux attributs regles et entites d'une classe d�riv�e
         � : pas de r�gles et pas de sous-entit�s.

         L'attribut regles doit contenir la liste des regles qui s'appliquent
         sur ses sous-entit�s

         L'attribut entit�s doit contenir le dictionnaires des sous-entit�s
         (cl� = nom, valeur=objet)
      """
      self.regles=()
      self.entites={}
      if validators:
         self.validators=self.factories['validator'](validators)
      else:
         self.validators=validators

   def affecter_parente(self):
      """
          Cette methode a pour fonction de donner un nom et un pere aux
          sous entit�s qui n'ont aucun moyen pour atteindre leur parent
          directement
          Il s'agit principalement des mots cles
      """
      for k,v in self.entites.items():
        v.pere = self
        v.nom = k

   def verif_cata(self):
      """
          Cette methode sert � valider les attributs de l'objet de d�finition
      """
      raise NotImplementedError("La m�thode verif_cata de la classe %s doit �tre impl�ment�e"
                                % self.__class__.__name__)

   def __call__(self):
      """
          Cette methode doit retourner un objet d�riv� de la classe OBJECT
      """
      raise NotImplementedError("La m�thode __call__ de la classe %s doit �tre impl�ment�e"
                                % self.__class__.__name__)

   def report(self):
      """
         Cette m�thode construit pour tous les objets d�riv�s de ENTITE un
         rapport de validation de la d�finition port�e par cet objet
      """
      self.cr = self.CR()
      self.verif_cata()
      for k,v in self.entites.items() :
         try :
            cr = v.report()
            cr.debut = u"D�but "+v.__class__.__name__+ ' : ' + k
            cr.fin = u"Fin "+v.__class__.__name__+ ' : ' + k
            self.cr.add(cr)
         except:
            self.cr.fatal(_(u"Impossible d'obtenir le rapport de %s %s"), k,`v`)
            print "Impossible d'obtenir le rapport de %s %s" %(k,`v`)
            print "p�re =",self
      return self.cr

   def verif_cata_regles(self):
      """
         Cette m�thode v�rifie pour tous les objets d�riv�s de ENTITE que
         les objets REGLES associ�s ne portent que sur des sous-entit�s
         existantes
      """
      for regle in self.regles :
        l=[]
        for mc in regle.mcs :
          if not self.entites.has_key(mc) :
            l.append(mc)
        if l != [] :
          txt = str(regle)
          self.cr.fatal(_(u"Argument(s) non permis : %r pour la r�gle : %s"), l, txt)

   def check_definition(self, parent):
      """Verifie la definition d'un objet composite (commande, fact, bloc)."""
      args = self.entites.copy()
      mcs = set()
      for nom, val in args.items():
         if val.label == 'SIMP':
            mcs.add(nom)
            #XXX
            #if val.max != 1 and val.type == 'TXM':
                #print "#CMD", parent, nom
         elif val.label == 'FACT':
            val.check_definition(parent)
            # CALC_SPEC !
            #assert self.label != 'FACT', \
               #'Commande %s : Mot-clef facteur present sous un mot-clef facteur : interdit !' \
               #% parent
         else:
            continue
         del args[nom]
      # seuls les blocs peuvent entrer en conflit avec les mcs du plus haut niveau
      for nom, val in args.items():
         if val.label == 'BLOC':
            mcbloc = val.check_definition(parent)
            #XXX
            #print "#BLOC", parent, re.sub('\s+', ' ', val.condition)
            assert mcs.isdisjoint(mcbloc), "Commande %s : Mot(s)-clef(s) vu(s) plusieurs fois : %s" \
               % (parent, tuple(mcs.intersection(mcbloc)))
      return mcs

   def check_op(self, valmin=-9999, valmax=9999):
      """V�rifie l'attribut op."""
      if self.op is not None and \
         (type(self.op) is not int or self.op < valmin or self.op > valmax):
         self.cr.fatal(_(u"L'attribut 'op' doit �tre un entier "
                         u"compris entre %d et %d : %r"), valmin, valmax, self.op)

   def check_proc(self):
      """V�rifie l'attribut proc."""
      if self.proc is not None and not isinstance(self.proc, N_OPS.OPS):
         self.cr.fatal(_(u"L'attribut op doit �tre une instance d'OPS : %r"), self.proc)

   def check_regles(self):
      """V�rifie l'attribut regles."""
      if type(self.regles) is not tuple:
         self.cr.fatal(_(u"L'attribut 'regles' doit �tre un tuple : %r"),
            self.regles)

   def check_fr(self):
      """V�rifie l'attribut fr."""
      if type(self.fr) not in (str, unicode):
         self.cr.fatal(_(u"L'attribut 'fr' doit �tre une chaine de caract�res : %r"),
            self.fr)

   def check_docu(self):
      """V�rifie l'attribut docu."""
      if type(self.docu) not in (str, unicode):
         self.cr.fatal(_(u"L'attribut 'docu' doit �tre une chaine de caract�res : %r"),
            self.docu)

   def check_nom(self):
      """V�rifie l'attribut proc."""
      if type(self.nom) != types.StringType :
         self.cr.fatal(_(u"L'attribut 'nom' doit �tre une chaine de caract�res : %r"),
            self.nom)

   def check_reentrant(self):
      """V�rifie l'attribut reentrant."""
      if self.reentrant not in ('o', 'n', 'f'):
         self.cr.fatal(_(u"L'attribut 'reentrant' doit valoir 'o','n' ou 'f' : %r"),
            self.reentrant)

   def check_statut(self, into=('o', 'f', 'c', 'd')):
      """V�rifie l'attribut statut."""
      if self.statut not in into:
         self.cr.fatal(_(u"L'attribut 'statut' doit �tre parmi %s : %r"),
            into, self.statut)

   def check_condition(self):
      """V�rifie l'attribut condition."""
      if self.condition != None :
         if type(self.condition) != types.StringType :
            self.cr.fatal(_(u"L'attribut 'condition' doit �tre une chaine de caract�res : %r"),
                self.condition)
      else:
         self.cr.fatal(_(u"La condition ne doit pas valoir None !"))

   def check_min_max(self):
      """V�rifie les attributs min/max."""
      if type(self.min) != types.IntType :
         if self.min != '**':
            self.cr.fatal(_(u"L'attribut 'min' doit �tre un entier : %r"), self.min)
      if type(self.max) != types.IntType :
         if self.max != '**':
            self.cr.fatal(_(u"L'attribut 'max' doit �tre un entier : %r"), self.max)
      if self.min > self.max :
         self.cr.fatal(_(u"Nombres d'occurrence min et max invalides : %r %r"),
            self.min, self.max)

   def check_validators(self):
      """V�rifie les validateurs suppl�mentaires"""
      if self.validators and not self.validators.verif_cata():
         self.cr.fatal(_(u"Un des validateurs est incorrect. Raison : %s"),
            self.validators.cata_info)

   def check_homo(self):
      """V�rifie l'attribut homo."""
      if self.homo != 0 and self.homo != 1 :
          self.cr.fatal(_(u"L'attribut 'homo' doit valoir 0 ou 1 : %r"), self.homo)

   def check_into(self):
      """V�rifie l'attribut into."""
      if self.into != None :
         if type(self.into) != types.TupleType :
            self.cr.fatal(_(u"L'attribut 'into' doit �tre un tuple : %r"), self.into)

   def check_position(self):
      """V�rifie l'attribut position."""
      if self.position not in ('local', 'global', 'global_jdc'):
         self.cr.fatal(_(u"L'attribut 'position' doit valoir 'local', 'global' "
                             u"ou 'global_jdc' : %r"), self.position)
