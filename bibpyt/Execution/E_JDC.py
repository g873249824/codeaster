#@ MODIF E_JDC Execution  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
# RESPONSABLE COURTOIS M.COURTOIS
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
import sys, types,os, string, fpformat
from os import times
import cPickle as pickle
PICKLE_PROTOCOL = 0

# Modules Eficas
from Noyau.N_Exception import AsException
from Noyau.N_ASSD import ASSD
from Noyau.N_ENTITE import ENTITE
from Noyau.N_JDC    import MemoryErrorMsg
from Noyau.N_info import message, SUPERV
import aster
from strfunc import convert

from Noyau import basetype

class JDC:
   """
   """
   # attributs accessibles depuis le fortran par les m�thodes g�n�riques
   # get_jdc_attr et set_jdc_attr
   l_jdc_attr = ('jxveri', 'sdveri', 'impr_macro')

   # attributs du jdc "pickl�s" (ceux qui contiennent des infos de l'ex�cution).
   l_pick_attr = ('memo_sensi', 'catalc')

   def __init__(self):
      self.info_level = 1
      self.timer_fin = None

   def Exec(self):
      """
          Execution en fonction du mode d execution
      """
      # initexec est defini dans le package Build et cette fonction (Exec)
      # ne peut etre utilisee que si le module E_JDC est assemble avec le
      # Build.
      self.initexec()
      for e in self.etapes:
        if CONTEXT.debug :
          print e,e.nom,e.isactif()
        try:
           if e.isactif():
               message.debug(SUPERV, "call etape.Exec : %s %s", e.nom, e)
               e.Exec()
        except EOFError:
           # L'exception EOFError a ete levee par l'operateur FIN
           raise

   def BuildExec(self):
      """
         Cette methode realise les passes de Build et d'Execution en mode par_lot="OUI"
         Elle est utilisee par le superviseur (voir ParLotMixte)
      """
      # initexec est defini dans le package Build et cette fonction (Exec)
      # ne peut etre utilisee que si le module E_JDC est assemble avec le package Build
      self.initexec()

      # Pour etre sur de ne pas se planter sur l appel a set_context on le met d abord a blanc
      CONTEXT.unset_current_step()
      CONTEXT.set_current_step(self)

      # On reinitialise le compte-rendu self.cr
      self.cr=self.CR(debut="CR d'execution de JDC en MIXTE",
                     fin  ="fin CR d'execution de JDC en MIXTE")

      self.timer.Start(" . build")
      ret=self._Build()
      self.timer.Stop(" . build")
      if ret != 0:
        CONTEXT.unset_current_step()
        return ret

      self.g_context={}
      ier=0

      try:
         for e in self.etapes:
             if CONTEXT.debug : print e,e.nom,e.isactif()
             if e.isactif():
                 e.BuildExec()

      except self.codex.error,exc_val:
         self.traiter_user_exception(exc_val)
         self.affiche_fin_exec()
         e = self.get_derniere_etape()
         self.traiter_fin_exec("par_lot",e)

      except MemoryError, e:
         self.cr.exception(MemoryErrorMsg)

      except EOFError:
         # L'exception EOFError a ete levee par l'operateur FIN
         self.affiche_fin_exec()
         e = self.get_derniere_etape()
         self.traiter_fin_exec("par_lot",e)

      if self.info_level > 1:
         print self.timer_fin
      CONTEXT.unset_current_step()
      return ier

   def get_derniere_etape(self):
       """ Cette m�thode sert � r�cup�rer la derni�re �tape ex�cut�e
           Elle sert essentiellement en cas de plantage
       """
       numMax = -1
       etapeMax = None
       for e in self.etapes:
          if numMax < self.index_etapes[e]:
             numMax = self.index_etapes[e]
             etapeMax = e
       return etapeMax

   def affiche_fin_exec(self):
       """ Cette methode affiche les statistiques de temps finales.
       """

       ###############################################################
       #impression des statistiques de temps d'execution des commandes
       ###############################################################

       #recuperation du temps de la derniere commande :
       #soit c'est FIN si arret normal, soit la commande courante si levee
       #d'exception de type <S>
       #en effet, on est arrive ici par une levee d'exception, et on n'a alors
       #pas affiche l'echo de la commande FIN dans le fichier de message

       l_etapes=self.get_liste_etapes()
       l_etapes.reverse()
       for e in l_etapes :
           if self.timer.timers.has_key(id(e)):
              e.AfficheFinCommande()
              break

       # affiche le r�capitulatif du timer
       cpu_total_user, cpu_total_syst, elapsed_total = self.timer.StopAndGetTotal()

       aster.affiche('RESULTAT', convert(repr(self.timer)))
       aster.fclose(8)

       tempsMax = self.args.get("tempsMax")
       if tempsMax != None:
          cpu_restant = tempsMax - cpu_total_syst - cpu_total_user
       else:
          cpu_restant = 0.

       texte_final = _(u"""

  <I> Informations sur les temps d'ex�cution
      Temps cpu total ..............    %10.2f s
      Temps cpu user total .........    %10.2f s
      Temps cpu systeme total ......    %10.2f s
      Temps cpu restant ............    %10.2f s
""") % (cpu_total_user+cpu_total_syst, cpu_total_user, cpu_total_syst, cpu_restant)

       aster.affiche('MESSAGE', convert(texte_final))
       if self.fico is None:
           aster.affiche('MESSAGE', convert(repr(self.timer)))
       aster.fclose(6)
       # fichier d'info
       txt = "%10.2f %10.2f %10.2f %10.2f\n" \
         % (cpu_total_user+cpu_total_syst, cpu_total_user, cpu_total_syst, cpu_restant)
       open('info_cpu', 'w').write(txt)

   def traiter_fin_exec(self,mode,etape=None):
       """ Cette methode realise un traitement final lorsque la derniere commande
           a �t� ex�cut�e. L'argument etape indique la derniere etape executee en traitement
           par lot (si mode == 'par_lot').

           Le traitement r�alis� est la sauvegarde du contexte courant : concepts produits
           plus autres variables python.
           Cette sauvegarde est r�alis�e par un pickle du dictionnaire python contenant
           ce contexte.
       """
       if self.info_level > 1:
          from Utilitai.as_timer import ASTER_TIMER
          self.timer_fin = ASTER_TIMER(format='aster')
          self.timer_fin.Start("pickle")

       ###############################################################
       #sauvegarde du pickle
       ###############################################################

       if mode == 'commande':
          # En mode commande par commande
          # Le contexte courant est donn� par l'attribut g_context
          context=self.g_context
       else:
          # En mode par lot
          # Le contexte courant est obtenu � partir du contexte des constantes
          # et du contexte des concepts

          # On retire du contexte des constantes les concepts produits
          # par les commandes (ex�cut�es et non ex�cut�es)
          context=self.const_context
          for key,value in context.items():
              if isinstance(value,ASSD) :
                 del context[key]

          # On ajoute a ce contexte les concepts produits par les commandes
          # qui ont �t� r�ellement ex�cut�es (du d�but jusqu'� etape)
          context.update(self.get_contexte_avant(etape))

       if CONTEXT.debug:
          print '<DBG> (traiter_fin_exec) context.keys(assd) =',
          for key,value in context.items():
             if isinstance(value,ASSD) :
                print key,
          print

       # On �limine du contexte courant les objets qui ne supportent pas
       # le pickle (version 2.2)
       if self.info_level > 1:
          self.timer_fin.Start(" . filter")
       context=self.filter_context(context,mode)
       if self.info_level > 1:
          self.timer_fin.Stop(" . filter")
       # Sauvegarde du pickle dans le fichier pick.1 du repertoire de travail

       file=open('pick.1','w')
       pickle.dump(context, file, protocol=PICKLE_PROTOCOL)
       if self.info_level > 1:
          self.timer_fin.Stop("pickle")

   def filter_context(self,context,mode):
       """
          Cette methode construit un dictionnaire a partir du dictionnaire context
          pass� en argument en supprimant tous les objets python que l'on ne veut pas
          ou ne peut pas sauvegarder pour une poursuite ult�rieure
          + en ajoutant un dictionnaire pour pickler certains attributs du jdc.
          Le dictionnaire r�sultat est retourn� par la m�thode.
       """
       d={}
       for key,value in context.items():
           if key in ('aster','__builtins__') :continue
           if type(value) in (types.ModuleType,types.ClassType,types.FunctionType) :
              continue
           if issubclass(type(value), basetype.MetaType):
              continue
           if issubclass(type(value), types.TypeType):
              continue
           if isinstance(value,ENTITE) :continue
           # Enfin on conserve seulement les objets que l'on peut pickler individuellement.
           try:
              # pour acc�l�rer, on supprime le catalogue de SD devenu inutile.
              if isinstance(value, ASSD):
                  value.supprime_sd()
              pickle.dumps(value, protocol=PICKLE_PROTOCOL)
              d[key]=value
           except:
              # Si on ne peut pas pickler value on ne le met pas dans le contexte filtr�
              pass
       self.save_pickled_attrs(d)
       return d

   def traiter_user_exception(self,exc_val):
       """ Cette methode traite les exceptions en provenance du module d'execution
           (qui derive de codex.error).
       """
       if isinstance(exc_val, self.codex.error):
          # erreur utilisateur levee et pas trappee, on ferme les bases en appelant la commande FIN
          self.codex.impers()
          self.cr.exception("<S> Exception utilisateur levee mais pas interceptee.\n"
                            "Les bases sont fermees.\n"
                            "Type de l'exception : " + exc_val.__class__.__name__ + "\n" \
                            + str(exc_val))
          self.fini_jdc(exc_val)


   def abort_jdc(self):
      """ Cette methode termine le JDC par un abort
      """
      print ">> JDC.py : DEBUT RAPPORT"
      print self.cr
      print ">> JDC.py : FIN RAPPORT"
      os.abort()


   def fini_jdc(self, exc_val):
      """ Cette methode execute la commande FIN du JDC
          pour terminer proprement le JDC
      """
      fin_etape = None
      for e in self.etapes:
         if e.nom == 'FIN':
            fin_etape = e
            break
      if fin_etape is None:
         # au moins en PAR_LOT='NON', FIN n'est pas dans la liste des �tapes
         self.set_par_lot("NON")
         fin_cmd = self.get_cmd("FIN")
         try:
            fin_cmd()
         except:
            pass
      else:
         # insertion de l'�tape FIN du jdc juste apr�s l'�tape courante
         self.etapes.insert(self.index_etape_courante + 1, fin_etape)
         # si ArretCPUError, on supprime tout ce qui peut co�ter
         if isinstance(exc_val, self.codex.ArretCPUError):
            # faire �voluer avec fin.capy
            fin_etape.valeur.update({
               'FORMAT_HDF'  : 'NON',
               'RETASSAGE'   : 'NON',
               'INFO_RESU'   : 'NON',
            })
            fin_etape.McBuild()
         try:
            # raise EOFError op9999 > jefini > xfini(19)
            fin_etape.BuildExec()
         except EOFError:
            pass


   def get_liste_etapes(self):
      liste=[]
      for e in self.etapes : e.get_liste_etapes(liste)
      return liste

   def get_jdc_attr(self, attr):
      """
         Retourne la valeur d'un des attributs "aster"
      """
      if attr not in self.l_jdc_attr:
         self.cr.exception("Erreur de programmation :\n"\
                           "attribut '%s' non autoris�" % attr)
      return getattr(self, attr)

   def set_jdc_attr(self, attr, value):
      """
         Positionne un des attributs "aster"
      """
      if attr not in self.l_jdc_attr:
         self.cr.exception("Erreur de programmation :\n"\
                           "attribut '%s' non autoris�" % attr)
      if type(value) not in (int, long):
         self.cr.exception("Erreur de programmation :\n"\
                           "valeur non enti�re : %s" % str(value))
      setattr(self, attr, value)


   def save_pickled_attrs(self, context):
      """Ajoute le dictionnaire des attributs du jdc � "pickler" dans le contexte.
      """
      d = {}
      for attr in self.l_pick_attr:
         d[attr] = getattr(self, attr)
      context['jdc_pickled_attributes'] = d


   def restore_pickled_attrs(self, context):
      """Restaure les attributs du jdc qui ont �t� "pickl�s" via le contexte.
      """
      d = context.get('jdc_pickled_attributes', {})
      for attr, value in d.items():
         #assert attr in self.l_pick_attr
         setattr(self, attr, value)


