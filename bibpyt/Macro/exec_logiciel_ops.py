#@ MODIF exec_logiciel_ops Macro  DATE 29/08/2006   AUTEUR MCOURTOI M.COURTOIS 
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

import os.path
import traceback
import shutil
from types import ListType, TupleType
EnumTypes = (ListType, TupleType)

# ------------------------------------------------------------------------------
def exec_logiciel_ops(self, LOGICIEL, ARGUMENT, MAILLAGE, CODE_RETOUR_MAXI, INFO, **args):
   """
   Macro IMPR_FONCTION permettant d'imprimer dans un fichier des fonctions,
   colonnes de table...
   Erreurs<S> dans IMPR_FONCTION pour ne pas perdre la base.
   """
   macro='EXEC_LOGICIEL'
   import aster
   from Utilitai.Utmess     import UTMESS
   from Utilitai.System     import ExecCommand
   from Utilitai.UniteAster import UniteAster
   
   PRE_GMSH      = self.get_cmd("PRE_GMSH")
   PRE_GIBI      = self.get_cmd("PRE_GIBI")
   LIRE_MAILLAGE = self.get_cmd("LIRE_MAILLAGE")
   
   ier=0
   # La macro compte pour 1 dans la numerotation des commandes
   self.set_icmd(1)

   #----------------------------------------------
   # constantes des modes d'ex�cution
   CMD_EXTERNE = 1
   EXECFILE    = 2
   mode_lancement = None

   # param�tres n�cessaires pour �crire la ligne de commande
   # !! d_para['options'] est une liste !!
   d_para = {'prog' : '', 'options' : ''}
   
   l_args = []
   if ARGUMENT != None:
      l_args = ARGUMENT[:]
      if type(l_args) not in EnumTypes:
         l_args = [l_args,]
   
   #----------------------------------------------
   # 1. Pr�paration des donn�es
   # 1.1. EXEC_LOGICIEL standard
   if MAILLAGE == None:
      mode_lancement = CMD_EXTERNE
      cmd = '%(prog)s %(options)s'
   
   # 1.2. Cas "lancement d'un mailleur"
   else:
      mcf = MAILLAGE[0]
      dMCF = mcf.cree_dict_valeurs(mcf.mc_liste)
      d_para['fichIN']  = 'fort.%d' % dMCF['UNITE_GEOM']
      d_para['fichOUT'] = 'fort.%d' % dMCF['UNITE']
      
      if dMCF['FORMAT'] == 'GMSH':
         mode_lancement = CMD_EXTERNE
         cmd = '%(prog)s %(options)s -o %(fichOUT)s %(fichIN)s'
         d_para['prog'] = os.path.join(aster.repout(), 'gmsh')
         d_para['options'] = ('-3',)
      
      elif dMCF['FORMAT'] == 'GIBI':
         mode_lancement = CMD_EXTERNE
         cmd = '%(prog)s %(options)s %(fichIN)s %(fichOUT)s'
         d_para['prog'] = os.path.join(aster.repout(), 'gibi')
      
      elif dMCF['FORMAT'] == 'SALOME':
         mode_lancement = EXECFILE
         if len(l_args) < 1:
            UTMESS('F', macro, "FORMAT SALOME, L'ARGUMENT 1 DOIT ETRE " \
                               "LE NOM DU FICHIER MED PRODUIT PAR LE SCRIPT PYTHON.")
         else:
            d_para['fichMED'] = l_args[0]
      
      else:
         UTMESS('F', macro, "ON NE SAIT PAS TRAITER LE FORMAT '%s'" % dMCF['FORMAT'])
   
   #----------------------------------------------
   # 2. lecture des mots-cl�s
   if LOGICIEL != None:
      d_para['prog'] = LOGICIEL

   if len(l_args) > 0:
      d_para['options'] = l_args
   d_para['options'] = ' '.join(d_para['options'])
   
   #----------------------------------------------
   # 3. Ex�cution
   # 3a. Lancement d'une commande externe
   if mode_lancement == CMD_EXTERNE:
      scmd = cmd % d_para
      comment = "Lancement de la commande :\n%s" % scmd
      iret, output = ExecCommand(scmd,
                                 alt_comment=comment)
      # �crire l'output dans le .mess si demand�
      if INFO == 2:
         aster.affiche('MESSAGE', output)
      
      if CODE_RETOUR_MAXI >= 0 and iret > CODE_RETOUR_MAXI:
         UTMESS('F', macro, 'CODE RETOUR INCORRECT (MAXI %d) : %d' \
                % (CODE_RETOUR_MAXI, iret))
   
   #----------------------------------------------
   # 3b. Ex�cution d'un fichier Python
   elif mode_lancement == EXECFILE:
      if d_para['prog'] != '':
         UTMESS('A', macro, "LE MOT-CLE LOGICIEL N'EST PAS UTILISE AVEC CE FORMAT")
      context={}
      try:
         execfile(d_para['fichIN'], context)
      except:
         traceback.print_exc()
         txt = open(d_para['fichIN'], 'r').read()
         UTMESS('F', macro, """ERREURS LORS DE L'EXECUTION DU FICHIER CI-DESSOUS :
<<<<<<<<<<<<<<< DEBUT DU FICHIER >>>>>>>>>>>>>>>
%s
<<<<<<<<<<<<<<<  FIN  DU FICHIER >>>>>>>>>>>>>>>
""" % txt)
      
      if not os.path.exists(d_para['fichMED']):
         UTMESS('F', macro, "LE FICHIER %s N'EXISTE PAS" % d_para['fichMED'])
      else:
         # copie fichMED vers fichOUT pour pouvoir le r�cup�rer
         shutil.copyfile(d_para['fichMED'], d_para['fichOUT'])
   
   else:
      UTMESS('F', macro, "Mode de lancement inconnu : %s" % mode_lancement)
   
   #----------------------------------------------
   # 4. Conversion du maillage
   if MAILLAGE != None:
      UL = UniteAster()
      umail = UL.Libre(action='ASSOCIER',
                       nom='exec_logiciel.%s2mail' % dMCF['FORMAT'].lower())
      
      # d�claration du concept maillage en sortie
      self.DeclareOut('mail', dMCF['MAILLAGE'])
      
      lire_mail_opts = {}
      if dMCF['FORMAT'] == 'GMSH':
         PRE_GMSH(UNITE_GMSH     = dMCF['UNITE'],
                  UNITE_MAILLAGE = umail)

      elif dMCF['FORMAT'] == 'GIBI':
         PRE_GIBI(UNITE_GIBI     = dMCF['UNITE'],
                  UNITE_MAILLAGE = umail)

      elif dMCF['FORMAT'] == 'SALOME':
         # ici l'unit� en entr�e de LIRE_MAILLAGE ne correspond pas au .mail
         # mais au fichier MED en sortie du execfile.
         umail = dMCF['UNITE']
         etat = UL.Etat(umail, etat='O', TYPE='LIBRE', nom=d_para['fichMED'])
         lire_mail_opts['FORMAT']   = 'MED'
         lire_mail_opts['INFO_MED'] = INFO
      
      mail = LIRE_MAILLAGE(UNITE = umail,
                           INFO  = INFO,
                           **lire_mail_opts)

      UL.EtatInit()
   return ier

