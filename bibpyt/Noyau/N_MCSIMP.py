# -*- coding: iso-8859-1 -*-
# person_in_charge: mathieu.courtois at edf.fr
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
    Ce module contient la classe MCSIMP qui sert � controler la valeur
    d'un mot-cl� simple par rapport � sa d�finition port�e par un objet
    de type ENTITE
"""

from copy import copy

from Noyau.N_ASSD import ASSD
from Noyau.N_CO import CO
import N_OBJECT
from N_CONVERT import ConversionFactory
from N_types import force_list, is_sequence

class MCSIMP(N_OBJECT.OBJECT):
   """
   """
   nature = 'MCSIMP'
   def __init__(self,val,definition,nom,parent):
      """
         Attributs :

          - val : valeur du mot cl� simple

          - definition

          - nom

          - parent

        Autres attributs :

          - valeur : valeur du mot-cl� simple en tenant compte de la valeur par d�faut

      """
      self.definition=definition
      self.nom=nom
      self.val = val
      self.parent = parent
      self.convProto = ConversionFactory('type', typ=self.definition.type)
      self.valeur = self.GETVAL(self.val)
      if parent :
         self.jdc = self.parent.jdc
         self.niveau = self.parent.niveau
         self.etape = self.parent.etape
      else:
         # Le mot cle simple a �t� cr�� sans parent
         self.jdc = None
         self.niveau = None
         self.etape = None

   def GETVAL(self,val):
      """
          Retourne la valeur effective du mot-cl� en fonction
          de la valeur donn�e. Defaut si val == None
      """
      if (val is None and hasattr(self.definition,'defaut')) :
         val = self.definition.defaut
      if self.convProto:
         val = self.convProto.convert(val)
      return val

   def get_valeur(self):
      """
          Retourne la "valeur" d'un mot-cl� simple.
          Cette valeur est utilis�e lors de la cr�ation d'un contexte
          d'�valuation d'expressions � l'aide d'un interpr�teur Python
      """
      v = self.valeur
      # Si singleton et max=1, on retourne la valeur.
      # Si une valeur simple et max='**', on retourne un singleton.
      # (si liste de longueur > 1 et max=1, on sera arr�t� plus tard)
      # Pour accepter les numpy.array, on remplace : "type(v) not in (list, tuple)"
      # par "not has_attr(v, '__iter__')".
      if v is None:
          pass
      elif is_sequence(v) and len(v) == 1 and self.definition.max == 1:
         v = v[0]
      elif not is_sequence(v) and self.definition.max != 1:
          v = (v, )
      # traitement particulier pour les complexes ('RI', r, i)
      if 'C' in self.definition.type and self.definition.max != 1 \
        and v[0] in ('RI', 'MP'):
          v = (v, )
      return v

   def get_val(self):
      """
          Une autre m�thode qui retourne une "autre" valeur du mot cl� simple.
          Elle est utilis�e par la m�thode get_mocle
      """
      return self.valeur

   def accept(self,visitor):
      """
         Cette methode permet de parcourir l'arborescence des objets
         en utilisant le pattern VISITEUR
      """
      visitor.visitMCSIMP(self)

   def copy(self):
      """ Retourne une copie de self """
      objet = self.makeobjet()
      # il faut copier les listes et les tuples mais pas les autres valeurs
      # possibles (r�el,SD,...)
      if type(self.valeur) in (list, tuple):
         objet.valeur = copy(self.valeur)
      else:
         objet.valeur = self.valeur
      objet.val = objet.valeur
      return objet

   def makeobjet(self):
      return self.definition(val = None, nom = self.nom,parent = self.parent)

   def reparent(self,parent):
      """
         Cette methode sert a reinitialiser la parente de l'objet
      """
      self.parent=parent
      self.jdc=parent.jdc
      self.etape=parent.etape

   def get_sd_utilisees(self):
      """
          Retourne une liste qui contient la ou les SD utilis�e par self si c'est le cas
          ou alors une liste vide
      """
      l=[]
      if isinstance(self.valeur, ASSD):
         l.append(self.valeur)
      elif type(self.valeur) in (list, tuple):
        for val in self.valeur :
           if isinstance(val, ASSD):
              l.append(val)
      return l

   def get_sd_mcs_utilisees(self):
      """
          Retourne la ou les SD utilis�e par self sous forme d'un dictionnaire :
            - Si aucune sd n'est utilis�e, le dictionnaire est vide.
            - Sinon, la cl� du dictionnaire est le mot-cl� simple ; la valeur est
              la liste des sd attenante.

              Exemple ::
                      { 'VALE_F': [ <Cata.cata.fonction_sdaster instance at 0x9419854>,
                                    <Cata.cata.fonction_sdaster instance at 0x941a204> ] }
      """
      l=self.get_sd_utilisees()
      dico = {}
      if len(l) > 0 :
        dico[self.nom] = l
      return dico

   def get_mcs_with_co(self,co):
      """
          Cette methode retourne l'objet MCSIMP self s'il a le concept co
          comme valeur.
      """
      if co in force_list(self.valeur):
          return [self,]
      return []

   def get_all_co(self):
      """
          Cette methode retourne la liste de tous les concepts co
          associ�s au mot cle simple
      """
      return [co for co in force_list(self.valeur) \
                 if isinstance(co, CO) and co.is_typco()]
