#@ MODIF E_JDC Execution  DATE 06/09/2004   AUTEUR MCOURTOI M.COURTOIS 
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

# -*- coding: iso-8859-1 -*-

"""
"""
# Modules Python
import sys, types,os
import pickle

# Modules Eficas
from Noyau.N_Exception import AsException
from Noyau.N_ASSD import ASSD
from Noyau.N_ENTITE import ENTITE

class JDC:
   """
   """
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
           if e.isactif(): e.Exec()
        except EOFError:
           # L'exception EOFError a ete levee par l'operateur FIN
           raise

   def BuildExec(self):
      """
         Cette methode realise les passes de Build et d'Execution en mode par_lot="NON"
         Elle est utilisee par le superviseur dans le cadre d'une execution par lot (voir ParLotMixte)
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

      ret=self._Build()
      if ret != 0:
        CONTEXT.unset_current_step()
        return ret

      self.g_context={}
      ier=0

      try:
         for e in self.etapes:
             if CONTEXT.debug : print e,e.nom,e.isactif()
             if e.isactif(): e.BuildExec()

      except self.codex.error,exc_val:
         self.traiter_user_exception(exc_val)
         self.traiter_fin_exec("par_lot",e)

      except EOFError:
         # L'exception EOFError a ete levee par l'operateur FIN
         self.traiter_fin_exec("par_lot",e)
         pass

      CONTEXT.unset_current_step()
      return ier

   def traiter_fin_exec(self,mode,etape=None):
       """ Cette methode realise un traitement final lorsque la derniere commande
           a �t� ex�cut�e. L'argument etape indique la derniere etape executee en traitement 
           par lot (si mode == 'par_lot').

           Le traitement r�alis� est la sauvegarde du contexte courant : concepts produits
           plus autres variables python.
           Cette sauvegarde est r�alis�e par un pickle du dictionnaire python contenant 
           ce contexte.
       """
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

       # On �limine du contexte courant les objets qui ne supportent pas 
       # le pickle (version 2.2)
       context=self.filter_context(context,mode)
       # Sauvegarde du pickle dans le fichier pick.1 du repertoire de travail
       file=open('pick.1','w')
       pickle.dump(context,file)

   def filter_context(self,context,mode):
       """
          Cette methode construit un dictionnaire a partir du dictionnaire context 
          pass� en argument en supprimant tous les objets python que l'on ne veut pas 
          ou ne peut pas sauvegarder pour une poursuite ult�rieure
          Le dictionnaire r�sultat est retourn� par la m�thode
       """
       d={}
       for key,value in context.items():
           if key in ('aster','__builtins__') :continue
           if type(value) in (types.ModuleType,types.ClassType,types.FunctionType) :continue
           if isinstance(value,ENTITE) :continue
           #if type(value) == types.ClassType and issubclass(value,ASSD) :continue
           #if type(value) == types.ClassType and issubclass(value,ENTITE) :continue
           # Enfin on conserve seulement les objets que l'on peut pickler individuellement.
           try:
              pickle.dumps(value)
              d[key]=value
           except:
              # Si on ne peut pas pickler value on ne le met pas dans le contexte filtr�
              pass
       return d

   def traiter_user_exception(self,exc_val):
       """ Cette methode traite les exceptions en provenance du module d'execution
           codex.FatalError et codex.error.
       """
       if isinstance(exc_val,self.codex.FatalError):
          # erreur fatale levee et pas trappee, on ne ferme pas les bases
          # on sort en erreur
          raison=exc_val.__class__.__name__+" : "+str(exc_val)
          self.cr.exception("Exception utilisateur levee mais pas interceptee.\n"
                            "On ne ferme pas les bases et on sort en erreur.\n"+raison)

       elif isinstance(exc_val,self.codex.error):
          # erreur utilisateur levee et pas trappee, on ferme les bases en appelant la commande FIN
          raison=exc_val.__class__.__name__+" : "+str(exc_val)
          self.codex.impers()
          self.cr.exception("<S> Exception utilisateur levee mais pas interceptee.\n"
                            "Les bases sont fermees.\n"+raison)
          self.fini_jdc()


   def abort_jdc(self):
      """ Cette methode termine le JDC par un abort
      """
      print ">> JDC.py : DEBUT RAPPORT"
      print self.cr
      print ">> JDC.py : FIN RAPPORT"
      os.abort()

   def fini_jdc(self):
      """ Cette methode execute la commande FIN du catalogue 
          pour terminer proprement le JDC
      """
      self.set_par_lot("NON")
      fin_cmd=self.get_cmd("FIN")
      try:
             fin_cmd()
      except:
             pass
