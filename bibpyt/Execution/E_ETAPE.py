#@ MODIF E_ETAPE Execution  DATE 10/10/2006   AUTEUR MCOURTOI M.COURTOIS 
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
import types,sys,os
from os import times

# Modules Eficas
from Noyau.N_utils import prbanner
from Noyau.N_Exception import AsException
from Noyau.N_MACRO_ETAPE import MACRO_ETAPE
import genpy
import aster

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

      assert(type(self.modexec)==types.IntType),"type(self.modexec)="+`type(self.modexec)`
      assert(type(self.definition.op)==types.IntType),"type(self.definition.op)="+`type(self.definition.op)`

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
          ier=self.codex.oper(self,self.jdc.jxveri,self.modexec,self.icmd)
          if (self.modexec == 2) and (self.definition.op_init==None):
             self.cpu_user=times()[0]-self.cpu_user_0
             self.cpu_syst=times()[1]-self.cpu_syst_0
             # affichage du texte de la commande
             self.AfficheFinCommande(self.cpu_user,self.cpu_syst)       
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
      # impression du fichier .code : compte rendu des commandes et
      # mots cl�s activ�s par l'ETAPE
      if self.jdc.fico!=None :
        ficode=open('ficode', 'a')
        v=genpy.genpy(defaut='avec',simp='into')
        self.accept(v)
        chaine = ' %-10s%-20s' % (self.jdc.fico, self.nom)
        for mc in v.args.keys():
            if type(v.args[mc]) in types.StringTypes:
              chainec = '%s %-20s%-20s%-20s\n' % (chaine, '--', mc, v.args[mc])
              ficode.write(chainec)
            elif type(v.args[mc]) == types.ListType:
              for mcs in v.args[mc]:
                 for mcf in mcs.keys():
                  chainec = '%s%-20s%-20s%s\n' % (chaine, mc, mcf, mcs[mcf])
                  ficode.write(chainec)
            elif type(v.args[mc]) == types.DictType:
                mcs = v.args[mc]
                for mcf in mcs.keys():
                  chainec = '%s%-20s%-20s%s\n' % (chaine, mc, mcf, mcs[mcf])
                  ficode.write(chainec)
        ficode.close()

      if (not isinstance(self.parent,MACRO_ETAPE)) or \
         (self.parent.nom=='INCLUDE'             ) or \
         (self.jdc.impr_macro=='OUI'             ) :
         echo_mess=[]
         decalage="  "  # blancs au debut de chaque ligne affichee
         echo_mess.append( '\n' )
         echo_mess.append( decalage )
         echo_mess.append("#  ---------------------------------------------------------------------------")
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

   def AfficheFinCommande( self , cpu_user, cpu_syst, sortie=sys.stdout ) :
      """ 
      Methode : ETAPE.AfficheFinCommande
      Intention : afficher sur la sortie standard (par defaut) la fin du 
                  cartouche de la commande apres son execution.
      """
      if (not isinstance(self.parent,MACRO_ETAPE)) or \
         (self.parent.nom=='INCLUDE'             ) or \
         (self.jdc.impr_macro=='OUI'             ) :
         decalage="  "  # blancs au debut de chaque ligne affichee
         echo_mess=[decalage]
         if cpu_user != None :
            echo_fin = "%s  #  FIN COMMANDE NO : %04d   DUREE TOTALE:%12.2fs (SYST:%12.2fs)" \
               % (decalage, self.icmd, cpu_syst+cpu_user, cpu_syst)
         else :
            echo_fin = "%s  #  FIN COMMANDE : %s" % (decalage, self.nom)
         echo_mess.append(echo_fin)
         echo_mess.append(decalage + '  #  ' + '-'*75)
         texte_final=os.linesep.join(echo_mess)
         aster.affiche('MESSAGE', texte_final)

      return

   def Execute(self):
      """ 
      Cette methode realise l execution complete d une etape, en mode commande par commande : 
             - construction, 
             - verification, 
             - execution
      en une seule passe. Utilise en mode par_lot='NON'

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
      en une seule passe. Utilise en mode par_lot='NON'

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

