#@ MODIF macr_fiabilite_ops Macro  DATE 14/09/2004   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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


# RESPONSABLE GNICOLAS G.NICOLAS
#
def macr_fiabilite_ops(self, INFO,
                       LOGICIEL, VERSION,
                       UNITE_ESCL, MESS_ASTER,
                       SEUIL, SEUIL_TYPE,
                       VARIABLE,
                       **args ) :
#
#    args est le dictionnaire des arguments optionnels
#    args.keys() est la liste des mots-cl�s
#    args.keys()[0] est la premiere valeur de cette liste
#    args.keys()[1:] est la liste des valeurs suivantes dans cette liste
#    args.keys(mot_cle) repr�sente le contenu de la variable mot_cle dans la macro appelante.
###  print args
###  print args.keys()
###  if len (args.keys())>0 : print args.keys()[0]
#
  """ Macro-commande r�alisant le pilotage du logiciel de fiabilite. """
#
# On charge les modules n�cessaires
  from Accas import _F
  from Macro import fiabilite_mefisto
  import aster
  import os
  import string
  import sys
  import Numeric
#
#____________________________________________________________________
#
# 1. Pr�alables
#____________________________________________________________________
#
# 1.1 ==> La macro compte pour 1 dans l'ex�cution des commandes
#
  self.set_icmd(1)
#
# 1.2 ==> On importe les d�finitions des commandes Aster utilis�es
#         dans la macro
#
  EXEC_LOGICIEL  = self.get_cmd("EXEC_LOGICIEL")
  DEFI_LIST_REEL = self.get_cmd("DEFI_LIST_REEL")
#
# 1.3 ==> Le nom du programme de fiabilite � lancer
#
  repertoire_outils = aster.repout()
  fiabilite      = repertoire_outils + "fiabilite"
#
# 1.4 ==> Initialisations
#
  erreur = 0
  erreur_partiel = [0]
  Rep_Calc_ASTER = os.getcwd()
  Nom_Exec_ASTER = sys.executable
#
  messages_erreur = { 0 : "Tout va bien",
                      1 : "Impossible de cr�er le r�pertoire de travail pour le logiciel de fiabilit�.",
                      2 : "Probleme d'ouverture du fichier.",
                     10 : "Erreur dans le choix du logiciel de fiabilit�.",
                     11 : "Erreur dans la cr�ation des donn�es pour le logiciel de fiabilit�.",
                    100 : "Erreur." }
#
  while not erreur :
#
#____________________________________________________________________
#
# 2. R�pertoires et fichiers
#____________________________________________________________________
#
# 2.1. ==> Cr�ation du r�pertoire pour l'ex�cution du logiciel de fiabilit�
#
    Nom_Rep_local = "tmp_fiabilite"
    Rep_Calc_LOGICIEL_local = os.path.join(".",Nom_Rep_local)
    Rep_Calc_LOGICIEL_global = os.path.join(Rep_Calc_ASTER,Nom_Rep_local)
#
    try :
      os.mkdir(Rep_Calc_LOGICIEL_global)
    except os.error,erreur_partiel :
      self.cr.warn("Code d'erreur de mkdir : " + str(erreur_partiel[0]) + " : " + erreur_partiel[1])
      self.cr.fatal("Impossible de cr�er le r�pertoire de travail pour le logiciel de fiabilit� : "+Rep_Calc_LOGICIEL_global)
      erreur = erreur + 1
      break
#
# 2.2. ==> On cr�e un fichier annexe pour transmettre des donn�es � la proc�dure
#          de lancement des calculs ASTER par le LOGICIEL.
#          Ce fichier est cr�� dans le r�pertoire d'ex�cution du logiciel de fiabilit�.
#          On fait ainsi car les arguments pass�s ont du mal � transiter via l'ex�cutable.
#          On stocke :
#          1. Le niveau d'information
#          2. L'unit� logique associ�e au jeu de commandes d�terministes
#          3. La gestion des sorties ASTER
#          4. Le nom de l'ex�cutable ASTER
#          5. Le type de seuil du probl�me (maximum ou minimum)
#
    fic_Info_ASTER = os.path.join(Rep_Calc_LOGICIEL_global,"InfoExecASTER")
    try :
      f_execAster = open(fic_Info_ASTER, "w")
    except os.error,erreur_partiel :
      self.cr.warn("Fichier : "+fic_Info_ASTER)
      self.cr.warn("Code d'erreur de open : " + str(erreur_partiel[0]) + " : " + erreur_partiel[1])
      erreur = 2
      break
#
    f_execAster.write(str(INFO)+"\n")
    f_execAster.write(str(UNITE_ESCL)+"\n")
    f_execAster.write(str(MESS_ASTER)+"\n")
    f_execAster.write(str(Nom_Exec_ASTER)+"\n")
    f_execAster.write(str(SEUIL_TYPE))
    f_execAster.close()
    fichier = open (fic_Info_ASTER,"r")
#
    if INFO >= 2 :
      print "\nContenu du fichier " + fic_Info_ASTER," :"
      les_lignes = fichier.readlines()
      fichier.close()
      print les_lignes, "\n"
#
#____________________________________________________________________
#
# 3. Les variables par defaut
#____________________________________________________________________
#
# 3.1. ==> Dictionnaire des valeurs physiques et li�es � la loi
#
    valeurs_lois = { }
#
    for m in VARIABLE :
#
      v_moy_physique = None
      v_moy_loi = None
      v_min_loi = None
      v_max_loi = None
      sigma_loi = None
#
# 3.1.1. ==> loi uniforme : transfert des min et max
#            on d�finit une moyennne comme �tant la m�diane des extremes.
#
      if m["LOI"] == "UNIFORME" :
        v_moy_physique = 0.5 * ( m["VALE_MIN"] + m["VALE_MAX"] )
        v_min_loi = m["VALE_MIN"]
        v_max_loi = m["VALE_MAX"]
#
# 3.1.2. ==> loi normale : transfert des moyennne et �cart-type.
#
      elif m["LOI"] == "NORMALE" :
        v_moy_loi = m["VALE_MOY"]
        v_moy_physique = v_moy_loi
        sigma_loi = m["ECART_TYPE"]
#
# 3.1.3. ==> loi lognormale : identit� du min, conversion pour le reste
#
      elif m["LOI"] == "LOGNORMALE" :
        v_min_loi = m["VALE_MIN"]
        if m["VALE_MOY_PHY"] is None :
          v_moy_loi = m["VALE_MOY"]
          sigma_loi = m["ECART_TYPE"]
          aux = Numeric.exp(0.5*sigma_loi*sigma_loi+v_moy_loi)
          v_moy_physique = v_min_loi + aux
        else :
          v_moy_physique = m["VALE_MOY_PHY"]
          aux = m["ECART_TYPE_PHY"]/(m["VALE_MOY_PHY"]-m["VALE_MIN"])
          aux1 = 1. + aux*aux
          aux2 = Numeric.sqrt(aux1)
          v_moy_loi = Numeric.log((m["VALE_MOY_PHY"]-m["VALE_MIN"])/aux2)
          aux2 = Numeric.log(aux1)
          sigma_loi = Numeric.sqrt(aux2)
#
# 3.1.4. ==> loi normale tronqu�e : transfert des moyenne, mini/maxi et �cart-type
#            on d�finit une moyennne comme �tant la m�diane des extremes.
#
      else :
        v_moy_loi = m["VALE_MOY"]
        v_min_loi = m["VALE_MIN"]
        v_max_loi = m["VALE_MAX"]
        sigma_loi = m["ECART_TYPE"]
        v_moy_physique = 0.5 * ( m["VALE_MIN"] + m["VALE_MAX"] )
#
      d = { }
      d["v_moy_physique"] = v_moy_physique
      d["v_moy_loi"] = v_moy_loi
      d["v_min_loi"] = v_min_loi
      d["v_max_loi"] = v_max_loi
      d["sigma_loi"] = sigma_loi
      valeurs_lois[m] = d
#
#____________________________________________________________________
#
# 4. Cr�ation des fichiers pour le logiciel de fiabilite
#____________________________________________________________________
#
    if ( LOGICIEL == "MEFISTO" ) :
#
# 4.1. ==> MEFISTO
#
      erreur = fiabilite_mefisto.fiabilite_mefisto ( self, Rep_Calc_LOGICIEL_global,
                                                     INFO, VERSION,
                                                     SEUIL, SEUIL_TYPE,
                                                     VARIABLE,
                                                     valeurs_lois,
                                                     **args )
#
# 4.2. ==> Erreur si autre logiciel
#
    else :
#
     self.cr.warn("Logiciel de fiabilit� : "+LOGICIEL)
     erreur = 10
#
# 4.3. ==> Arret en cas d'erreur
#
    if erreur :
      break
#
#____________________________________________________________________
#
# 5. Ecriture de la commande d"ex�cution du logiciel de fiabilit�
#
#   Remarque : dans la donn�e de la version du logiciel de fiabilit�, il faut remplacer
#              le _ de la donn�e par un ., qui
#              est interdit dans la syntaxe du langage de commandes ASTER
#   Remarque : il faut remplacer le N majuscule de la donnee par
#              un n minuscule, qui est interdit dans la syntaxe du langage
#              de commandes ASTER
#____________________________________________________________________
#
#
    VERSION=string.replace(VERSION,"_",".")
    VERSION=string.replace(VERSION,"N","n")
#
    EXEC_LOGICIEL ( ARGUMENT = (_F(NOM_PARA=Rep_Calc_LOGICIEL_global), # nom du repertoire
                                _F(NOM_PARA=LOGICIEL),             # nom du logiciel de fiabilit�
                                _F(NOM_PARA=VERSION),         # version du logiciel de fiabilit�
                               ),
                    LOGICIEL = fiabilite
                   )
#
#--------------------------------------------------------------------
# 6. C'est fini !
#--------------------------------------------------------------------
#
    break
#
# 6.1. ==> Arret en cas d'erreur
#
  if erreur :
    if not messages_erreur.has_key(erreur) :
      erreur = 100
    self.cr.fatal(messages_erreur[erreur])
#
# 6.2. ==> Si tout va bien, on cr�e une liste de r�els pour le retour
#          A terme, il serait int�ressant d'y mettre les r�sultats
#          de l'analyse fiabiliste. Pour le moment, on se contente de
#          mettre une valeur nulle qui permet de faire un test dans
#          les commandes appelantes.
#
  aux = [float(erreur)]
#
  self.DeclareOut("nomres",self.sd)
  nomres = DEFI_LIST_REEL( VALE = aux , INFO = 1 )
#
  return
#
##########################  Fin de la fonction##################################
#
##########################   Auto-test##################################
#
if __name__ == "__main__" :
#
  import os
  import sys
  import tempfile
#
  Rep_Calc_LOGICIEL_global = tempfile.mktemp()
  os.mkdir(Rep_Calc_LOGICIEL_global)
#
  classe = None
  INFO = 2
  LOGICIEL = "MEFISTO"
  VERSION = "V3_2"
  UNITE_ESCL = 38
  MESS_ASTER = "DERNIER"
  SEUIL = 1789.
  SEUIL_TYPE = "MAXIMUM"
  VARIABLE = []
  args = {}
#
  lr8 = macr_fiabilite_ops(classe, INFO,
                       LOGICIEL, VERSION,
                       UNITE_ESCL, MESS_ASTER,
                       SEUIL, SEUIL_TYPE,
                       VARIABLE,
                       **args )
###  print "lr8 = ", lr8
  Liste = os.listdir(Rep_Calc_LOGICIEL_global)
#
  for nomfic in Liste :
    fic_total = os.path.join(Rep_Calc_LOGICIEL_global,nomfic)
    os.chmod  (fic_total,0755)
    os.remove (fic_total)
  os.rmdir (Rep_Calc_LOGICIEL_global)
#
  sys.exit("blabla")
