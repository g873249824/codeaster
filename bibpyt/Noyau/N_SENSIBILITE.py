#@ MODIF N_SENSIBILITE Noyau  DATE 21/11/2006   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
   Ce module contient les r�gles n�cessaires aux commandes sensibles
   pour renseigner l'attribut etape.sd.sensi, g�rer le caract�re r�entrant
   sur pr�sence de la sensibilit�.
"""

from types import TupleType, ListType
EnumTypes = (TupleType, ListType)

from N_REGLE import REGLE

# -----------------------------------------------------------------------------
class CONCEPT_SENSIBLE(REGLE):
   """R�gle permettant de renseigner au niveau du catalogue comment sera
   rempli le concept (valeur nominale ou d�riv�e(s) ou les deux...).
   """
   def __init__(self, mode, mocle='SENSIBILITE'):
      """Constructeur.
         mode : mani�re dont la commande rempli le concept
            'ENSEMBLE' : concept nominal ET d�riv�es en une seule passe
            'SEPARE'   : concept nominal OU d�riv�e (une ou plusieurs)
         mocle : mot-cl� contenant les param�tres sensibles.
      """
      REGLE.__init__(self)
      self.mocle = mocle
      self._modes = { 'ENSEMBLE' : 0, 'SEPARE' : 1 }
      self.mode = self._modes.get(mode, self._modes['ENSEMBLE'])

   def gettext(self):
      """Pour EFICAS
      """
      return ''

   def verif(self, args):
      """Retourne texte + 1 si ok, 0 si nook.
      On stocke dans sd.sensi l'�tape courante, c'est-�-dire celle qui
      renseigne le concept si cela n'a pas d�j� �t� fait (car verif est
      appel� � chaque validation).
      """
      obj = args["self"]
      etape = obj.etape
      id_etape = '%s_%s' % (etape.id, id(etape))
      if etape.sd == None:
          return '',1
      if not hasattr(etape.sd,"sensi"):
         etape.sd.sensi = {}
      # si ENSEMBLE, la sd nominale est forc�ment produite
      if self.mode == self._modes['ENSEMBLE'] and not etape.sd.sensi.has_key('nominal'):
         etape.sd.sensi['nominal'] = id_etape
      # liste des param�tres sensibles
      valeur = obj[self.mocle]
      if valeur == None:
         # pas de sensibilit�, la sd nominale est produite
         if not etape.sd.sensi.has_key('nominal'):
            etape.sd.sensi['nominal'] = id_etape
         return '', 1
      if not type(valeur) in EnumTypes:
         valeur = [valeur,]
      for v in valeur:
         if not etape.sd.sensi.has_key(v.get_name()):
            etape.sd.sensi[v.get_name()] = id_etape
      return '', 1


# -----------------------------------------------------------------------------
class REUSE_SENSIBLE(REGLE):
   """Limite le caract�re r�entrant de la commande.
   On autorisera reuse seulement si le concept (au sens fortran) n'a pas d�j�
   �t� calcul� (d'apr�s sd.sensi). Ce sera interdit dans les cas suivants :
      - sd nominale calcul�e et SENSIBILITE absent
      - PS1 dans SENSIBILITE et sd d�riv�e par rapport � PS1 calcul�e
   """
   def __init__(self, mocle='SENSIBILITE'):
      """Constructeur.
         mocle : mot-cl� SENSIBILITE.
      """
      REGLE.__init__(self)
      self.mocle = mocle

   def gettext(self):
      """Pour EFICAS
      """
      return ''

   def verif(self,args):
      """Retourne texte + 1 si ok, 0 si nook = reuse interdit.
      Comme CONCEPT_SENSIBLE est appel� avant (et � chaque validation),
      on regarde si sd.sensi[ps] a �t� renseign� par une �tape pr�c�dente.
      """
      obj = args["self"]
      etape = obj.etape
      id_etape = '%s_%s' % (etape.id, id(etape))
      sd = etape.sd
      # si la commande n'est pas r�entrante, rien � faire
      if etape.reuse is not None:
         valeur = obj[self.mocle]
         if valeur is None:
            if not hasattr(sd, 'sensi') or sd.sensi.get('nominal', id_etape) != id_etape:
               # pas de sensibilite et concept nominal d�j� calcul� : reuse interdit
               text = "Commande non r�entrante en l'absence de sensibilit�."
               return text, 0
         else:
            if not type(valeur) in EnumTypes:
               valeur = [valeur,]
            for ps in valeur:
               if hasattr(sd, 'sensi') and sd.sensi.get(ps.nom, id_etape) != id_etape:
                  # concept d�riv� par rapport � ps d�j� calcul� : reuse interdit
                  text = "Commande non r�entrante : d�riv�e par rapport � %s d�j� calcul�e" % ps.nom
                  return text, 0
      return '', 1


# -----------------------------------------------------------------------------
class DERIVABLE(REGLE):
   """D�clare que le concept fourni derri�re un mot-cl� est d�rivable.
   Sa pr�sence ne suffit pas � le valider, il faut encore que son attribut
   '.sensi' soit coh�rent avec le contenu du mot-cl� SENSIBILITE (ou l'absence
   de celui-ci).
   """
   def __init__(self, mocle):
      """Constructeur.
         mocle : mot-cl� d�rivable.
      """
      REGLE.__init__(self)
      self.mocle = mocle

   def gettext(self):
      """Pour EFICAS
      """
      return ''

   def verif(self,args):
      """
      """
      obj = args["self"]
      try:
         concept = obj[self.mocle]
      except IndexError:
         return '', 1
      if not type(concept) in EnumTypes:
         concept = [concept,]
      l_ps = obj["SENSIBILITE"]
      for co in concept:
         if concept is None:
            text = "Concept non d�fini (None) sous le mot-cl� %s" % self.mocle
            return text, 0
         if not l_ps:
            # pas de sensibilit�
            if hasattr(co,"sensi") and not co.sensi.get('nominal'):
               text = "%s ne contient que des valeurs d�riv�es, utilisez le mot cle SENSIBILITE" %\
                     co.nom
               return text, 0
         else:
            # sensibilit� sp�cifi�e
            if not type(l_ps) in EnumTypes:
               l_ps = [l_ps,]
            for ps in l_ps:
               if not hasattr(co,"sensi") or not co.sensi.get(ps.nom):
                  text = "La d�riv�e de %s par rapport � %s n'est pas disponible." %\
                        (co.nom, ps.nom)
                  return text, 0
      return '', 1

