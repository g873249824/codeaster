#@ MODIF E_ETAPE Execution  DATE 07/09/2009   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
# RESPONSABLE COURTOIS M.COURTOIS
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
import sys
import os
from os import times

# Modules Eficas
from Noyau.N_utils import prbanner
from Noyau.N_Exception import AsException
from Noyau.N_MACRO_ETAPE import MACRO_ETAPE
import genpy
import aster
import checksd
from E_Global import MessageLog

class ETAPE:
   """
   Cette classe impl�mente les m�thodes relatives � la phase d'execution.

   Les m�thodes principales sont:
      - Exec, realise la phase d'execution, en mode par lot
      - Execute, realise la phase d'execution, en mode commande par commande
   """

   def Exec(self):
      """
      Realise une passe d'execution sur l'operateur "fortran" associ�
      si le numero d'operateur (self.definition.op) est d�fini.

      On execute l'operateur numero self.definition.op
      en lui passant les arguments :
        - self : la commande courante
        - lot : le mode d'execution qui peut prendre comme valeur :
               -  0 = execution par lot (verification globale avant execution)
               -  1 = execution commande par commande (verification + execution commande par commande)
        - ipass : passe d'execution
               -  1 = verifications suppl�mentaires
               -  2 = execution effective
        - icmd  : num�ro d'ordre de la commande
      Retour : iertot = nombre d erreurs

      """

      if CONTEXT.debug :
           prbanner(" appel de l operateur %s numero %s " % (self.definition.nom,self.definition.op))

      # On n'execute pas les etapes qui n'ont pas de numero d'operateur associ�
      if self.definition.op is None :return 0

      assert(type(self.modexec)==int),"type(self.modexec)="+`type(self.modexec)`
      assert(type(self.definition.op)==int),"type(self.definition.op)="+`type(self.definition.op)`

      ier=0

      # Il ne faut pas executer les commandes non numerotees
      # Pour les affichages et calculs de cpu, on exclut les commandes
      # tout de suite executees (op_init) de type FORMULE. Sinon, ca
      # produit un affichage en double.
      echo_mess=[]
      if self.icmd is not None:
          # appel de la methode oper dans le module codex
          if (self.modexec == 2) and (self.definition.op_init==None):
             self.AfficheTexteCommande()
             if self.sd and self.jdc.sdveri:
                l_before = checksd.get_list_objects()

          self.jdc.timer.Stop(' . part Superviseur')
          self.jdc.timer.Start(' . part Fortran', num=1.2e6)
          ier=self.codex.oper(self,self.jdc.jxveri,self.modexec,self.icmd)
          self.jdc.timer.Stop(' . part Fortran')
          self.jdc.timer.Start(' . part Superviseur')

          # enregistrement des concepts sensibles en attente
          self.jdc.memo_sensi.register_sensi()

          if (self.modexec == 2) and (self.definition.op_init==None):
             # marque le concept comme calcul�
             if self.sd:
               self.sd.executed = 1
             # v�rification de la SD produite
             if self.sd and self.jdc.sdveri:
                # on force la v�rif si :
                     # concept r�entrant
                     # sd.nom absent du contexte (detruit ? car les nouveaux sont forc�ment v�rifi�s)
                     # pb avec macro reentrante et commande non reentrante : cf. ssnv164b ou ssll14a
                force = (self.reuse is not None) \
                     or (self.parent.get_contexte_avant(self).get(self.sd.nom) is None) \
                     or (self.parent != self.jdc)
                self.jdc.sd_checker.force(force)
                self.jdc.timer.Start('   . sdveri', num=1.15e6)
                self.jdc.sd_checker = checksd.check(self.jdc.sd_checker, self.sd, l_before, self)
                self.jdc.timer.Stop('   . sdveri')
             # pour arreter en cas d'erreur <E>
             MessageLog.reset_command()
             # affichage du texte de la commande
             self.AfficheFinCommande()
      else:
          if self.modexec == 2:
             # affichage du texte de la commande
             self.AfficheTexteCommande()

      if CONTEXT.debug :
           prbanner(" fin d execution de l operateur %s numero %s " % (self.definition.nom,
                                                                       self.definition.op))
      return ier

   def AfficheTexteCommande( self, sortie=sys.stdout ) :
      """
      Methode : ETAPE.AfficheTexteCommande
      Intention : afficher sur la sortie standard (par defaut) le cartouche de
                      la commande avant son execution.
      """
      # top d�part du chrono de la commande
      etiq = self.nom
      if (isinstance(self.parent,MACRO_ETAPE)) or \
         (self.parent.nom=='INCLUDE'         ):
         etiq = ' . ' + etiq
      self.jdc.timer.Start(id(self), name=etiq)

      # impression du fichier .code : compte rendu des commandes et
      # mots cl�s activ�s par l'ETAPE
      if self.jdc.fico!=None :
        v=genpy.genpy(defaut='avec',simp='into')
        self.accept(v)
        chaine = ' %-10s%-20s' % (self.jdc.fico, self.nom)
        for mc in v.args.keys():
            if type(v.args[mc]) in (str, unicode):
              chainec = '%s %-20s%-20s%-20s' % (chaine, '--', mc, v.args[mc])
              aster.affiche('CODE', chainec)
            elif type(v.args[mc]) == list:
              for mcs in v.args[mc]:
                 for mcf in mcs.keys():
                  chainec = '%s %-20s%-20s%s' % (chaine, mc, mcf, mcs[mcf])
                  aster.affiche('CODE', chainec)
            elif type(v.args[mc]) == dict:
                mcs = v.args[mc]
                for mcf in mcs.keys():
                  chainec = '%s %-20s%-20s%s' % (chaine, mc, mcf, mcs[mcf])
                  aster.affiche('CODE', chainec)

      if (not isinstance(self.parent,MACRO_ETAPE)) or \
         (self.parent.nom=='INCLUDE'             ) or \
         (self.jdc.impr_macro==1                 ) :
         echo_mess=[]
         decalage="  "  # blancs au debut de chaque ligne affichee
         echo_mess.append( '\n' )
         echo_mess.append(decalage + ' #  ' + '-'*90)
         echo_mess.append( '\n' )

         # Affichage numero de la commande (4 digits)
         if self.sd != None:
            type_concept = self.sd.__class__.__name__
         else:
            type_concept = ''

         if self.icmd != None:
            echo_mess.append("""   #  COMMANDE NO :  %04d            CONCEPT DE TYPE : %s
    #  -------------                  -----------------""" % (self.icmd, type_concept))
         else:
            # commande non comptabilis�e (INCLUDE)
            echo_mess.append("""   #  COMMANDE :
    #  ----------""")

         # recuperation du texte de la commande courante dans la chaine
         # commande_formatee
         v=genpy.genpy(defaut='avec')
         self.accept(v)
         echo_mess.append( '\n' )
         commande_formatee=v.formate_etape()
         echo_mess.append(commande_formatee)
         texte_final = ' '.join(echo_mess)
         aster.affiche('MESSAGE',texte_final)

      return

   def AfficheFinCommande( self, avec_temps=True, sortie=sys.stdout ) :
      """
      Methode : ETAPE.AfficheFinCommande
      Intention : afficher sur la sortie standard (par defaut) la fin du
                  cartouche de la commande apres son execution.
      """
      voir = (not isinstance(self.parent,MACRO_ETAPE)) or \
             (self.parent.nom=='INCLUDE'             ) or \
             (self.jdc.impr_macro==1                 )
      # stop pour la commande
      cpu_user, cpu_syst, elapsed = self.jdc.timer.StopAndGet(id(self), hide=not voir)
      if voir :
         decalage="  "  # blancs au debut de chaque ligne affichee
         echo_mess=[decalage]
         if avec_temps:
            rval = aster.jeinfo()
            echo_mem = """%s  #  USAGE DE LA MEMOIRE JEVEUX""" % (decalage)
            echo_mem += os.linesep +"""%s  #     - MEMOIRE DYNAMIQUE CONSOMMEE : %12.2f Mo (MAXIMUM ATTEINT : %12.2f Mo) """ % (decalage, rval[2],rval[4])
            echo_mem += os.linesep +"""%s  #     - MEMOIRE UTILISEE            : %12.2f Mo (MAXIMUM ATTEINT : %12.2f Mo) """ % (decalage, rval[0],rval[1])
            if rval[5] > 0. :
              echo_mem += os.linesep +"""%s  #  USAGE DE LA MEMOIRE POUR LE PROCESSUS""" % (decalage)
              echo_mem += os.linesep +"""%s  #     - VmData : %12.2f Mo - VmSize : %12.2f Mo """ % (decalage, rval[5]/1024,rval[6]/1024)
              echo_mem += os.linesep 
            
            echo_fin = "%s  #  FIN COMMANDE NO : %04d   USER+SYST:%12.2fs (SYST:%12.2fs, ELAPS:%12.2fs)" \
               % (decalage, self.icmd, cpu_syst+cpu_user, cpu_syst, elapsed)
            echo_mess.append(echo_mem)
         else :
            echo_fin = "%s  #  FIN COMMANDE : %s" % (decalage, self.nom)
         echo_mess.append(echo_fin)
         echo_mess.append(decalage + '  #  ' + '-'*90)
         texte_final=os.linesep.join(echo_mess)
         aster.affiche('MESSAGE', texte_final)

      return

   def Execute(self):
      """
      Cette methode realise l execution complete d une etape, en mode commande par commande :
             - construction,
             - verification,
             - execution
      en une seule passe. Utilise en mode PAR_LOT='NON'

      L'attribut d'instance executed indique que l'etape a deja ete executee
      Cette methode peut etre appelee plusieurs fois mais l'execution proprement
      dite ne doit etre realisee qu'une seule fois.
      Les seuls cas ou on appelle plusieurs fois Execute sont pour les
      commandes INCLUDE et INCLUDE_MATERIAU (appel dans op_init)
      """
      if not self.jdc or self.jdc.par_lot != "NON" :
         return

      if hasattr(self,"executed") and self.executed == 1:return
      self.executed=1

      cr=self.report()
      self.parent.cr.add(cr)
      if not cr.estvide():
        raise EOFError

      self.Build()

      self.setmode(1)
      self.Exec()
      self.setmode(2)
      try:
          self.Exec()
      except self.codex.error:
          self.detruit_sdprod()
          raise

   def detruit_sdprod(self):
      """ Cette m�thode supprime le concept produit par la commande
          du registre tenu par le JDC
      """
      try:
          del self.jdc.sds_dict[self.sd.nom]
      except:
          pass

   def BuildExec(self):
      """
      Cette methode realise l execution complete d une etape, en mode commande par commande :
             - construction,
             - execution
      en une seule passe. Utilise en mode PAR_LOT='NON'

      L'attribut d'instance executed indique que l'etape a deja ete executee
      Cette methode peut etre appelee plusieurs fois mais l'execution proprement
      dite ne doit etre realisee qu'une seule fois.
      Les seuls cas ou on appelle plusieurs fois Execute sont pour les
      commandes INCLUDE et INCLUDE_MATERIAU (appel dans op_init)
      """

      if hasattr(self,"executed") and self.executed == 1:return
      self.executed=1

      # Construction des sous-commandes
      self.Build()

      self.setmode(1)
      self.Exec()
      self.setmode(2)
      self.Exec()

   def get_liste_etapes(self,liste):
      liste.append(self.etape)

