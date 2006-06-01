#@ MODIF macr_adap_mail_ops Macro  DATE 02/06/2006   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
def macr_adap_mail_ops ( self,
                         INFO, VERSION_HOMARD, MAILLAGE_FRONTIERE,
                         **args):
  """
     Traitement des macros MACR_ADAP_MAIL/MACR_INFO_MAIL
  """
#
#  1. args est le dictionnaire des arguments
#     args.keys() est la liste des mots-cl�s
#     args.keys()[0] est la premiere valeur de cette liste
#     args.keys()[1:] est la liste des valeurs suivantes dans cette liste
#     args.keys(mot_cle) repr�sente le contenu de la variable mot_cle dans la macro appelante.
#
###  print args
###  print args.keys()
###  if len (args.keys())>0 : print args.keys()[0]
###  print args["MAILLAGE"]
#
#  2. Les caract�ristiques d'un passage sont conserv�es dans un dictionnaire. Il y a autant de
#     dictionnaires que de sollicitations pour une s�rie d'adaptation. L'ensemble de ces dictionnaires
#     est conserv� dans la liste Liste_Passages. Cette liste est n�cessairement globale pour pouvoir
#     la retrouver � chaque nouveau passage.
#     Description du dictionnaire de passages :
#        dico["Maillage_0"]             = o ; string ; nom du concept du maillage initial de la s�rie d'adaptation
#        dico["Maillage_NP1"]           = o ; string ; nom du concept du dernier maillage adapt�
#        dico["Rep_Calc_HOMARD_global"] = o ; string ; Nom global du r�pertoire de calcul pour HOMARD
#        dico["Rep_Calc_HOMARD_local"]  = o ; string ; Nom local du r�pertoire de calcul pour HOMARD
#                                                      depuis le r�pertoire de calcul pour ASTER
#        dico["niter"]                  = o ; entier ; num�ro d'it�ration
#
#  3. Les caract�ristiques d'un maillage sont conserv�es dans un dictionnaire. Il y a autant de
#     dictionnaires que de maillages manipul�s. L'ensemble de ces dictionnaires est conserv�
#     dans la liste Liste_Maillages.
#     Description du dictionnaire de maillages :
#        dico["Type_Maillage"] = o ; string ; "MAILLAGE_N", "MAILLAGE_NP1", "MAILLAGE_NP1_ANNEXE" ou "MAILLAGE_FRONTIERE"
#        dico["Nom_ASTER"]     = o ; concept ASTER associ�
#        dico["Action"]        = o ; string ; "A_ecrire" ou "A_lire"
#        dico["NOM_MED"]       = o ; string ; Nom MED du maillage
#
#  4. Les caract�ristiques d'un champ sont conserv�es dans un dictionnaire. Il y a autant de
#     dictionnaires que de champs manipul�s. L'ensemble de ces dictionnaires est conserv�
#     dans la liste Liste_Champs.
#     Description du dictionnaire de champs :
#        dico["Type_Champ"]   = o ; string ; "INDICATEUR" ou "CHAMP_MAJ"
#        dico["RESULTAT"]     = f ; concept ASTER du r�sutat associ�
#        dico["NOM_CHAM"]     = f ; string ; Nom ASTER du champ
#        dico["CHAM_GD"]      = f ; concept ASTER du champ de grandeur associ�e
#        dico["COMPOSANTE"]   = f ; string ; Nom ASTER de la composante (dans le cas de l'indicateur)
#        dico["NUME_ORDRE"]   = f ; entier ; Num�ro d'ordre du champ
#        dico["INST"]         = f ; entier ; Instant du champ
#        dico["PRECISION"]    = f ; entier ; Pr�cision sur l'instant du champ
#        dico["CRITERE"]      = f ; entier ; Crit�re de pr�cision sur l'instant du champ
#        dico["CHAM_MAJ"]     = f ; string ; Nom ASTER du champ interpol� sur le nouveau maillage
#        dico["NOM_MED"]      = o ; string ; Nom MED du champ
#
  from Accas import _F
  from Macro import creation_donnees_homard 
  from Utilitai.Utmess     import UTMESS
  import aster 
  import string
  import os
#gn  import shutil
#
  global Liste_Passages
#
#====================================================================
# 1. Pr�alables
#====================================================================
#
# 1.1. ==> La macro compte pour 1 dans la numerotation des commandes
#
  self.set_icmd(1)
#
# 1.2. ==> Num�ro du passage dans cette macro
#
  try :
    self.jdc.indice_macro_homard = self.jdc.indice_macro_homard + 1
  except :
    self.jdc.indice_macro_homard = 1
    Liste_Passages = []
  numero_passage_fonction = self.jdc.indice_macro_homard
###  print "numero_passage_fonction = ",numero_passage_fonction
#
# 1.3. ==> On importe les definitions des commandes a utiliser dans la macro
#
  DEFI_FICHIER    = self.get_cmd("DEFI_FICHIER")
  IMPR_RESU       = self.get_cmd("IMPR_RESU")
  EXEC_LOGICIEL   = self.get_cmd("EXEC_LOGICIEL")
  LIRE_MAILLAGE   = self.get_cmd("LIRE_MAILLAGE")
  LIRE_CHAMP      = self.get_cmd("LIRE_CHAMP")
#
# 1.4. ==> Le nom du programme HOMARD � lancer
#
  repertoire_outils = aster.repout()
  homard            = repertoire_outils + "homard"
#
# 1.5. ==> Initialisations
#
  codret_partiel = [0]
  Rep_Calc_ASTER = os.getcwd()
#
  Liste_Maillages = []
  Liste_Champs    = []
  Liste_Zones     = []
  dico_indi = {}
#
  LISTE_ADAPTATION_LIBRE = ("RAFF_DERA" , "RAFFINEMENT" , "DERAFFINEMENT")
#
#====================================================================
# 2. D�codage des arguments de la macro-commande
#====================================================================
# 2.1. ==> Donn�es de pilotage de l'adaptation
#
  if ( self.nom == "MACR_ADAP_MAIL" ) :
#
    mode_homard = "ADAP"
#
# 2.1.1. ==> Les concepts "maillage"
#
#gn    print "\n.. Debut de 2.1.1"
#    for mot_cle in ["MAILLAGE_N" , "MAILLAGE_NP1"] :
    for mot_cle in ["MAILLAGE_N" , "MAILLAGE_NP1" , "MAILLAGE_NP1_ANNEXE"] :
#gn      print "\nmot_cle = ",mot_cle
      dico = {}
      dico["Type_Maillage"] = mot_cle
      if ( args[mot_cle] != None ) :
#gn        print "==> args[",mot_cle,"] = ",args[mot_cle]
        dico["Nom_ASTER"] = args[mot_cle]
        if ( mot_cle == "MAILLAGE_N" ) :
          dico["Action"] = "A_ecrire"
        else :
          dico["Action"] = "A_lire"
      else :
        dico["Action"] = "Rien"
#gn      print "dico = ",dico
      Liste_Maillages.append(dico)
#
# 2.1.2. ==> L'�ventuel indicateur d'erreur
#
#gn   print "\n.. Debut de 2.1.2"
    if args["ADAPTATION"] in LISTE_ADAPTATION_LIBRE :
      dico = {}
      dico["Type_Champ"] = "INDICATEUR"
      if ( args["RESULTAT_N"] != None ) :
        lresu = 1
        dico["RESULTAT"]   = args["RESULTAT_N"]
        noresu = dico["RESULTAT"].nom
        dico["NOM_CHAM"]   = args["INDICATEUR"]
        nomsym = dico["NOM_CHAM"]
        if ( args["NUME_ORDRE"] != None ) :
          dico["NUME_ORDRE"] = args["NUME_ORDRE"]
        if ( args["INST"] != None ) :
          dico["INST"] = args["INST"]
          for cle in [ "PRECISION", "CRITERE" ] :
            if ( args[cle] != None ) :
              dico[cle] = args[cle]
      else :
        lresu = 0
        dico["CHAM_GD"] = args["CHAM_GD"]
        noresu = dico["CHAM_GD"].nom
        nomsym = " "
      nopase = " "
#
###      print "Avant appel a aster.mdnoch, lresu = ",lresu,", noresu =", noresu ,", nomsym = ", nomsym ,", nopase = ", nopase
      dico["NOM_MED"] = aster.mdnoch ( lresu, noresu, nomsym, nopase )
###      print "dico[\"NOM_MED\"] = ", dico["NOM_MED"]
      dico["COMPOSANTE"] = args["NOM_CMP_INDICA"]
      Liste_Champs.append(dico)
      dico_indi = dico
###      print dico
#
# 2.1.3. ==> Les champs � mettre � jour
#
#gn     print "\n.. Debut de 2.1.3."
#
    if args.has_key("MAJ_CHAM") :
#
      if args["MAJ_CHAM"] is None :
        les_champs = []
      else :
        les_champs = args["MAJ_CHAM"]
#
      for maj_cham in les_champs :
#gn        print maj_cham
#gn        print type(maj_cham)
#
        dico = {}
        dico["Type_Champ"] = "CHAMP_MAJ"
        Liste_aux = [ "CHAM_MAJ", "TYPE_CHAM" ]
        if ( maj_cham["RESULTAT"] != None ) :
          lresu = 1
          Liste_aux.append("RESULTAT")
          Liste_aux.append("NOM_CHAM")
          if ( maj_cham["NUME_ORDRE"] != None ) :
            dico["NUME_ORDRE"] = maj_cham["NUME_ORDRE"]
          elif ( maj_cham["INST"] != None ) :
            dico["INST"] = maj_cham["INST"]
            for cle in [ "PRECISION", "CRITERE" ] :
              if ( maj_cham[cle] != None ) :
                dico[cle] = maj_cham[cle]
          noresu = maj_cham["RESULTAT"].nom
          nomsym = maj_cham["NOM_CHAM"]
        else :
          lresu = 0
          Liste_aux.append("CHAM_GD")
          noresu = maj_cham["CHAM_GD"].nom
          nomsym = " "
        for cle in Liste_aux :
          dico[cle] = maj_cham[cle]
        nopase = " "
###        print "Avant appel a aster.mdnoch, lresu = ",lresu,", noresu =", noresu ,", nomsym = ", nomsym ,", nopase = ", nopase
        dico["NOM_MED"] = aster.mdnoch ( lresu, noresu, nomsym, nopase )
#
###        print dico
        Liste_Champs.append(dico)
#
# 2.1.4. ==> Les zones de raffinement
#
###    print "\n.. Debut de 2.1.4."
#
    if args.has_key("ZONE") :
#
      if args["ZONE"] is None :
        les_zones = []
      else :
        les_zones = args["ZONE"]
#
      for zone in les_zones :
###        print zone
###        print type(zone)
        dico = {}
        for aux in ['X_MINI','X_MAXI','Y_MINI','Y_MAXI','Z_MINI','Z_MAXI','X_CENTRE','Y_CENTRE','Z_CENTRE','RAYON'] :
          if ( zone[aux] != None ) :
            dico[aux] = zone[aux]
###        print dico
        Liste_Zones.append(dico)
#
###    print Liste_Zones
#
# 2.2. ==> Donn�es de pilotage de l'information
#
  else :
#
    mode_homard = "INFO"
#
    dico = {}
    dico["Type_Maillage"] = "MAILLAGE_N"
    dico["Nom_ASTER"]     = args["MAILLAGE"]
    dico["Action"]        = "A_ecrire"
    Liste_Maillages.append(dico)
#
# 2.3. ==> Suivi de fronti�re
#
#gn   print "\n.. Debut de 2.3."
#
  if ( MAILLAGE_FRONTIERE != None ) :
#
    dico = {}
    dico["Type_Maillage"] = "MAILLAGE_FRONTIERE"
    dico["Nom_ASTER"]     = MAILLAGE_FRONTIERE
    dico["Action"]        = "A_ecrire"
    Liste_Maillages.append(dico)
#
# 2.4. ==> Le num�ro de version de HOMARD
#    Remarque : dans la donn�e de la version de HOMARD, il faut remplacer
#               le _ de la donnee par un ., qui est interdit dans la
#               syntaxe du langage de commandes ASTER
#    Remarque : il faut remplacer le N majuscule de la donnee par
#               un n minuscule, qui est interdit dans la syntaxe du langage
#               de commandes ASTER
#
#gn  print "\n.. Debut de 2.4. avec VERSION_HOMARD = ", VERSION_HOMARD
  VERSION_HOMARD = string.replace(VERSION_HOMARD,"_" , ".")
  VERSION_HOMARD = string.replace(VERSION_HOMARD,"N" , "n")
#
  if ( VERSION_HOMARD[-6:]==".PERSO" ):
    VERSION_HOMARD = VERSION_HOMARD[:-6]
    version_perso = 1
  else :
    version_perso = 0
#gn  print ".... VERSION_HOMARD = ", VERSION_HOMARD
#gn  print ".... version_perso  = ", version_perso
#
#====================================================================
# 3. Pr�paration du lancement des commandes
#====================================================================
#
# 3.1. ==> . Elaboration des noms MED des concepts de maillage
#          . Memorisation des noms ASTER du maillage en entr�e et en sortie (sous forme string)
#
#          On cr�e une nouvelle liste des dictionnaires d�crivant les maillages
#          et � la fin on �crase l'ancienne liste par cette nouvelle.
#
#gn  print "\n.. Debut de 3.1."
#
  Nom_Concept_Maillage_NP1_ANNEXE = None
  l_aux = []
  for dico in Liste_Maillages :
#gn     print "\ndico avant = ",dico
    if ( dico["Action"] != "Rien" ) :
      dico["NOM_MED"] = aster.mdnoma(dico["Nom_ASTER"].nom)
      l_aux.append(dico)
      if ( dico["Type_Maillage"] == "MAILLAGE_N" ) :
        Nom_Concept_Maillage_N = dico["Nom_ASTER"].nom
      elif ( dico["Type_Maillage"] == "MAILLAGE_NP1" ) :
        Nom_Concept_Maillage_NP1 = dico["Nom_ASTER"].nom
      elif ( dico["Type_Maillage"] == "MAILLAGE_NP1_ANNEXE" ) :
        Nom_Concept_Maillage_NP1_ANNEXE = dico["Nom_ASTER"].nom
#gn     print "\ndico apres = ",dico
  Liste_Maillages = l_aux
#
# 3.2. ==> Recherche du num�ro d'it�ration et du r�pertoire de travail
#
# 3.2.1. ==> Par d�faut :
#            . le num�ro d'it�ration est nul
#            . le nom du r�pertoire de lancement de HOMARD est construit sur le nom
#              du maillage en entr�e et le num�ro de passage dans la fonction
#
#gn  print "\.. Debut de 3.2.1."
#
  niter = 0
  Nom_Rep_local = Nom_Concept_Maillage_N + "_" + mode_homard + "_" + str(numero_passage_fonction)
  Rep_Calc_HOMARD_local = os.path.join(".", Nom_Rep_local)
  Rep_Calc_HOMARD_global = os.path.join(Rep_Calc_ASTER, Nom_Rep_local)
###  print "Rep_Calc_HOMARD_local  = ", Rep_Calc_HOMARD_local
###  print "Rep_Calc_HOMARD_global = ", Rep_Calc_HOMARD_global
#
# 3.2.2. ==> En adaptation : il faut repartir du r�pertoire de l'it�ration pr�c�dente
#
#gn  print "\.. Debut de 3.2.2."
#
  if ( mode_homard == "ADAP" ) :
#
# 3.2.2.1. ==> On recherche si dans les passages d�j� effectu�s, il en existe un
#              dont le maillage d'arriv�e �tait l'actuel maillage d'entr�e. Si c'est
#              le cas, cela veut dire que l'adaptation en cours est la suite d'une
#              pr�c�dente. On doit donc utiliser le meme r�pertoire. Le num�ro
#              d'it�ration est celui de l'adaptation pr�c�dente augment� de 1.
#
#gn     print "\.. Debut de 3.2.2.1."
#
    for dico in Liste_Passages :
      if ( dico["Maillage_NP1"] == Nom_Concept_Maillage_N ) :
        niter   = dico["niter"] + 1
        Rep_Calc_HOMARD_local  = dico["Rep_Calc_HOMARD_local"]
        Rep_Calc_HOMARD_global = dico["Rep_Calc_HOMARD_global"]
#
# 3.2.2.2. ==> Memorisation de ce passage
#
#gn     print "\.. Debut de 3.2.2.2."
#
# 3.2.2.2.1. ==> Enregistrement d'un nouveau cas de figure
#
    if ( niter == 0 ) :
      dico = {}
      dico["Maillage_0"]   = Nom_Concept_Maillage_N
      dico["Maillage_NP1"] = Nom_Concept_Maillage_NP1
      dico["Maillage_NP1_ANNEXE"] = Nom_Concept_Maillage_NP1_ANNEXE
      dico["Rep_Calc_HOMARD_local"]  = Rep_Calc_HOMARD_local
      dico["Rep_Calc_HOMARD_global"] = Rep_Calc_HOMARD_global
      dico["niter"]        = niter
      Liste_Passages.append(dico)
#
# 3.2.2.2.2. ==> Modification du cas en cours
#
    else :
      l_aux = []
      for dico in Liste_Passages :
        if ( dico["Maillage_NP1"] == Nom_Concept_Maillage_N ) :
          dico["Maillage_NP1"] = Nom_Concept_Maillage_NP1
          dico["Maillage_NP1_ANNEXE"] = Nom_Concept_Maillage_NP1_ANNEXE
          dico["niter"]        = niter
        l_aux.append(dico)
      Liste_Passages = l_aux
#
###  print "niter = ", niter, ", Rep_Calc_HOMARD_global = ", Rep_Calc_HOMARD_global
#
# 3.2.3. Cr�ation du r�pertoire pour homard
#        attention : on ne fait cette creation qu'une seule fois par cas
#                    d'adaptation ou d'information
#
#gn  print "\.. Debut de 3.2.3."
#
  if ( niter == 0 ) :
#
    try :
      os.mkdir(Rep_Calc_HOMARD_global)
    except os.error,codret_partiel :
      self.cr.warn("Code d'erreur de mkdir : " + str(codret_partiel[0]) + " : " + codret_partiel[1])
      UTMESS("F", self.nom, "Impossible de cr�er le r�pertoire de travail pour HOMARD : "+Rep_Calc_HOMARD_global)
#
#====================================================================
# 4. Ecriture des commandes de creation des donnees MED
#====================================================================
#
#gn  print "\.. Debut de 4."
#
#  On doit �crire : le maillage,
#                   le champ d'indicateur d'erreur
#                   les champs � convertir
#  Remarque : on met tout dans le meme fichier
#
#  Chacune de ces �critures est optionnelle selon le contexte.
#
  if ( INFO > 1 ) :
    infomail = "OUI"
  else :
    infomail = "NON"
#
# 4.1. ==> Noms des fichiers d'ASTER vers HOMARD et �ventuellement de HOMARD vers ASTER
#          Remarque : aujourd'hui, les �critures ou les lectures au format MED se font obligatoirement sur
#                     un fichier de nom fort.n, plac� dans le r�pertoire de calcul
##
# 4.1.1. ==> D'ASTER vers HOMARD
#
  Unite_Fichier_ASTER_vers_HOMARD = 1787 + 2*numero_passage_fonction
  Fichier_ASTER_vers_HOMARD = os.path.join(Rep_Calc_ASTER,"fort." + str(Unite_Fichier_ASTER_vers_HOMARD))
###  print "Fichier_ASTER_vers_HOMARD = ",Fichier_ASTER_vers_HOMARD
#
# 4.1.2. ==> De HOMARD vers ASTER
#  
  if ( mode_homard == "ADAP" ) :
    Unite_Fichier_HOMARD_vers_ASTER = Unite_Fichier_ASTER_vers_HOMARD + 1
    Fichier_HOMARD_vers_ASTER = os.path.join(Rep_Calc_ASTER,"fort." + str(Unite_Fichier_HOMARD_vers_ASTER))
###    print "Fichier_HOMARD_vers_ASTER = ",Fichier_HOMARD_vers_ASTER
#
# 4.2. La d�finition du fichier de ASTER vers HOMARD
# 
  DEFI_FICHIER ( ACTION= "ASSOCIER",
                 UNITE = Unite_Fichier_ASTER_vers_HOMARD,
                 TYPE = "LIBRE",
                 INFO = INFO )
#
# 4.3. Le(s) maillage(s)
# Le maillage de calcul et l'�ventuel maillage de la frontiere sont �crits
# dans le meme fichier MED
# En fait, on pourrait s'en passer au dela de la 1�re it�ration
# car HOMARD a m�moris�. Mais d�s que l'on �crit un champ,
# les conventions MED imposent la pr�sence du maillage dans le fichier.
# Donc on va toujours �crire.
#
  for dico in Liste_Maillages :
    if ( dico["Action"] == "A_ecrire" ) :
      motscsi = {}
      motscsi["MAILLAGE"] = dico["Nom_ASTER"]
      motscfa = {}
      motscfa["RESU"] = _F( INFO_MAILLAGE=infomail,
                          **motscsi )
#
      IMPR_RESU ( INFO = INFO, 
                  FORMAT ='MED', UNITE = Unite_Fichier_ASTER_vers_HOMARD,
                  **motscfa )
#
# 4.4. Le(s) champ(s)
#        Attention : il se peut que l'on demande la mise � jour du champ qui a servi comme
#                    indicateur d'erreur. Si c'est le cas, il ne faut pas demander son
#                    impression sinon il y a plantage d'IMPR_RESU qui ne sait pas substituer
#                    deux champs. D'ailleurs, c'est plus �conomique ainsi !
#        Remarque : pour l'adaptation, on ne demande a priori qu'une composante du champ d'indicateur.
#                   s'il y a demande de mise � jour, toutes les composantes sont concern�es. Il faut
#                   donc dans ce cas imprimer le champ total.
#        dico["Type_Champ"]   = o ; string ; "INDICATEUR" ou "CHAMP_MAJ"
#        dico["RESULTAT"]     = f ; concept ASTER du r�sutat associ�
#        dico["NOM_CHAM"]     = f ; string ; Nom ASTER du champ
#        dico["CHAM_GD"]      = f ; concept ASTER du champ de grandeur associ�e
#        dico["COMPOSANTE"]   = f ; string ; Nom ASTER de la composante (dans le cas de l'indicateur)
#        dico["NUME_ORDRE"]   = f ; entier ; Num�ro d'ordre du champ
#        dico["INST"]         = f ; entier ; Instant du champ
#        dico["PRECISION"]    = f ; entier ; Pr�cision sur l'instant du champ
#        dico["CRITERE"]      = f ; entier ; Crit�re de pr�cision sur l'instant du champ
#        dico["CHAM_MAJ"]     = f ; string ; Nom ASTER du champ interpol� sur le nouveau maillage
#        dico["NOM_MED"]      = o ; string ; Nom MED du champ
#
# 4.4.1. Recherche d'un doublon �ventuel sur le champ d'indicateur d'erreur
#
###  print "dico_indi = ",dico_indi
  if len(dico_indi) > 0 :
    indic_est_deja_imprime = 0
    if dico_indi.has_key("RESULTAT") :
      Liste_aux = [ "RESULTAT", "NOM_CHAM" ]
    else :
      Liste_aux = [ "CHAM_GD" ]
  else :
    indic_est_deja_imprime = 1
    Liste_aux = [ ]
###  print ".. Au debut de la boucle, Liste_aux = ",Liste_aux
###  print ".. Au debut de la boucle, indic_est_deja_imprime = ",indic_est_deja_imprime
#
  Liste_Champs_imprime = []
  for dico in Liste_Champs :
###    print "\n.... dico = ",dico
#   Pour un champ � mettre � jour, on a toujours impression
    if ( dico["Type_Champ"] == "CHAMP_MAJ" ) :
      Liste_Champs_imprime.append(dico)
#     Si le champ d'indicateur n'a toujours pas �t� rep�r� comme champ � mettre � jour :
      if not indic_est_deja_imprime :
#       Est-ce le meme champ ?
        on_a_le_champ = 1
        for cle in Liste_aux :
          if ( dico.has_key(cle) ) :
###            print "...... dico_indi[cle] = ",dico_indi[cle]
###            print "...... dico[cle]      = ",dico[cle]
            if ( dico_indi[cle] != dico[cle] ) :
              on_a_le_champ = 0
              break
          else :
            on_a_le_champ = 0
            break
#       Si oui, est-ce au meme moment ? (remarque : si rien n'est d�sign�, c'est qu'il n'y a qu'un
#       seul instant ... donc c'est le meme ! En revanche, on ne sait pas comparer une donn�e
#       en num�ro d'ordre et une donn�e en instant. On croise les doigts.)
        if on_a_le_champ :
          for cle in [ "NUME_ORDRE", "INST" ] :
            if dico.has_key(cle) :
              if ( dico[cle] != None ) :
                if dico_indi.has_key(cle) :
                  if ( dico_indi[cle] != dico[cle] ) :
                    on_a_le_champ = 0
                    break
        if on_a_le_champ :
          indic_est_deja_imprime = 1
###  print "\n\nFin de la boucle .. indic_est_deja_imprime = ",indic_est_deja_imprime
#   Si le champ d'indicateur n'a pas �t� rep�r� comme champ � mettre � jour, il faut
#   l'inclure dans les champs � imprimer
  if not indic_est_deja_imprime :
    Liste_Champs_imprime.append(dico_indi)
#
# 4.4.2. Impressions apr�s le filtrage pr�c�dent
#gn  print "\n.... Debut de 4.2.4.2."
#
  for dico in Liste_Champs_imprime :
    motscsi = {}
    for cle in [ "RESULTAT", "NOM_CHAM", "CHAM_GD", "NUME_ORDRE", "INST", "PRECISION", "CRITERE" ] :
      if dico.has_key(cle) :
        if ( dico[cle] != None ) :
          motscsi[cle] = dico[cle]
    if dico.has_key("COMPOSANTE") :
      motscsi["NOM_CMP"] = dico["COMPOSANTE"]
    motscfa = {}
    motscfa["RESU"] = _F( INFO_MAILLAGE=infomail,
                        **motscsi
                      )
###    print ".. motscfa = ",motscfa
#
    IMPR_RESU ( INFO = INFO, 
                FORMAT ='MED', UNITE = Unite_Fichier_ASTER_vers_HOMARD,
                **motscfa )
#
#====================================================================
# 5. ==> Cr�ation des fichiers de donn�es pour HOMARD
#====================================================================
#
#gn  print "\.. Debut de 5."
#
  dico_configuration = {}
#
# 5.1. ==> Les g�n�ralit�s
#
  dico_configuration["INFO"] = INFO
#
  dico_configuration["Rep_Calc_HOMARD_global"] = Rep_Calc_HOMARD_global
  dico_configuration["VERSION_HOMARD"] = VERSION_HOMARD
  dico_configuration["version_perso"] = version_perso
#
  dico_configuration["niter"] = niter
  dico_configuration["Fichier_ASTER_vers_HOMARD"] = Fichier_ASTER_vers_HOMARD
  if ( mode_homard == "ADAP" ) :
    dico_configuration["Fichier_HOMARD_vers_ASTER"] = Fichier_HOMARD_vers_ASTER
#  
# 5.2. ==> Les noms med des maillages
#
  for dico in Liste_Maillages :
#gn    print "Nom MED de " + dico["Type_Maillage"] + " = " + dico["NOM_MED"]
    dico_configuration[ "NOM_MED_"+dico["Type_Maillage"] ] = dico["NOM_MED"]
#
# 5.3. ==> Les caracteristiques de l'�ventuel indicateur d'erreur
#
  for dico in Liste_Champs :
    dico_aux = {}
    if ( dico["Type_Champ"] == "INDICATEUR" ) :
      Liste_aux = [ "NOM_MED", "COMPOSANTE" ]
      if dico.has_key("NUME_ORDRE") :
        Liste_aux.append("NUME_ORDRE")
      for cle in Liste_aux :
        if ( dico[cle] != None ) :
          dico_aux[cle] = dico[cle]
      dico_configuration["Indicateur"] = dico_aux
#gn  if dico_configuration.has_key("Indicateur") :
#gn    print "dico_configuration[Indicateur] = ", dico_configuration["Indicateur"]
#
# 5.4. ==> Les zones de raffinement
#
  prem = 1
  for dico in Liste_Zones :
    if prem :
      l_aux = [dico]
      prem = 0
    else :
      l_aux = dico_configuration["Zones"]
      l_aux.append(dico)
    dico_configuration["Zones"] = l_aux
###  if dico_configuration.has_key("Zones") :
###    print "dico_configuration[Zones] = ", dico_configuration["Zones"]
#
# 5.5. ==> La mise � jour de champs
#
  prem = 1
  for dico in Liste_Champs :
    dico_aux = {}
    if ( dico["Type_Champ"] == "CHAMP_MAJ" ) :
      Liste_aux = [ "NOM_MED", "COMPOSANTE" ]
      if dico.has_key("NUME_ORDRE") :
        Liste_aux.append("NUME_ORDRE")
      else :
        for cle in [ "RESULTAT", "NOM_CHAM", "INST", "PRECISION", "CRITERE" ] :
          Liste_aux.append(cle)
      for cle in Liste_aux :
        if dico.has_key(cle) :
          if ( dico[cle] != None ) :
            dico_aux[cle] = dico[cle]
#gn      print dico_aux
      if prem :
        l_aux = [dico_aux]
        prem = 0
      else :
        l_aux = dico_configuration["Champs"]
        l_aux.append(dico_aux)
      dico_configuration["Champs"] = l_aux
#gn  if dico_configuration.has_key("Champs") :
#gn   print "dico_configuration[Champs] = ", dico_configuration["Champs"]
#
# 5.6. ==> Appel de la fonction de cr�ation
#
  donnees_homard = creation_donnees_homard.creation_donnees_homard ( self.nom, args, dico_configuration )
  if ( INFO > 1 ) :
    donnees_homard.quel_mode ( )
  fic_homard_niter = donnees_homard.creation_configuration ( )
  donnees_homard.ecrire_fichier_configuration ( )
  if ( mode_homard == "INFO" ) :
    Nom_Fichier_Donnees = donnees_homard.ecrire_fichier_donnees ( )
  else :
    Nom_Fichier_Donnees = "0"
#
# 5.7. ==> Impression eventuelle des fichiers cr��s
#
#gn  print "R�pertoire ",Rep_Calc_HOMARD_global
#gn  os.system("ls -la "+Rep_Calc_HOMARD_global)
  if ( INFO > 1 ) :
    L_aux = ["HOMARD.Donnees" , "HOMARD.Configuration"]
  else :
    L_aux = [ ]
  for nomfic in L_aux :
    fic = os.path.join(Rep_Calc_HOMARD_global, nomfic)
    if os.path.isfile (fic) :
      print "\n\n=============================================================="
      print "Contenu de", nomfic
      fichier = open (fic,"r")
      les_lignes = fichier.readlines()
      fichier.close()
      for ligne in les_lignes :
        print ligne[:-1]
      print "==============================================================\n"
#gn  if ( mode_homard == "ADAP" ) :
#gn    if args.has_key("MAJ_CHAM") :
#gn      if args["MAJ_CHAM"] is not None :
#gn        os.system("sleep 1000")
#
#====================================================================
# 6. Ecriture de la commande d'ex�cution de homard
#====================================================================
#
#
#gn  print "\.. Debut de 7."
###  Fichier_ASTER_vers_HOMARD_2 = os.path.join("/home/gnicolas" , "fort." + str(Unite_Fichier_ASTER_vers_HOMARD))
###  shutil.copyfile(Fichier_ASTER_vers_HOMARD,Fichier_ASTER_vers_HOMARD_2)
#
  EXEC_LOGICIEL ( ARGUMENT = (_F(NOM_PARA=Rep_Calc_HOMARD_global), # nom du repertoire
                              _F(NOM_PARA=VERSION_HOMARD),  # version de homard
                              _F(NOM_PARA=str(INFO)),       # niveau d information
                              _F(NOM_PARA=Nom_Fichier_Donnees), # fichier de donn�es HOMARD
                             ),
                  LOGICIEL = homard
                )
#
###  if ( mode_homard == "ADAP" ) :
###    Fichier_HOMARD_vers_ASTER_2 = os.path.join("/home/gnicolas" , "fort." + str(Unite_Fichier_HOMARD_vers_ASTER))
###    shutil.copyfile(Fichier_HOMARD_vers_ASTER,Fichier_HOMARD_vers_ASTER_2)
#
#====================================================================
# 7. ==> Ecriture de la commande de lecture des resultats med
#        Remarque :
#        La fonction self.DeclareOut(a,b) fonctionne ainsi :
#        a est une chaine de caracteres
#        b est la variable d�clar�e dans la commande
#        le but est de associer le contenu de b � la variable locale qui sera d�sign�e par a
#        Exemple :
#        self.DeclareOut("maillage_a_lire",args["MAILLAGE_NP1"])
#        ==> la variable maillage_a_lire est identifi�e � l'argument "MAILLAGE_NP1"
#====================================================================
#
  if ( mode_homard == "ADAP" ) :
#
# 7.1. ==> Le maillage
#
#gn    print "args = ",args
    for dico in Liste_Maillages :
#gn      print dico
      if ( dico["Action"] == "A_lire" ) :
        self.DeclareOut("maillage_a_lire", dico["Nom_ASTER"])
        maillage_a_lire = LIRE_MAILLAGE ( UNITE = Unite_Fichier_HOMARD_vers_ASTER,
                                       FORMAT = "MED",
                                       NOM_MED = dico["NOM_MED"],
                                       VERI_MAIL = _F(VERIF="NON"), INFO_MED = INFO, INFO = INFO )
        if ( dico["Type_Maillage"] == "MAILLAGE_NP1" ) :
          maillage_np1 = maillage_a_lire
#
# 7.2. ==> Les champs
#
    for dico in Liste_Champs :
      if ( dico["Type_Champ"] == "CHAMP_MAJ" ) :
#gn        print dico
        self.DeclareOut("champ_maj", dico["CHAM_MAJ"])
        motscsi = {}
        for cle in [ "NUME_ORDRE", "INST", "PRECISION", "CRITERE" ] :
          if dico.has_key(cle) :
            if ( dico[cle] != None ) :
              motscsi[cle] = dico[cle]
        if dico.has_key("NUME_ORDRE") :
          motscsi["NUME_PT"] = dico["NUME_ORDRE"]
        champ_maj = LIRE_CHAMP ( UNITE = Unite_Fichier_HOMARD_vers_ASTER, FORMAT = "MED",
                                 MAILLAGE = maillage_np1,
                                 NOM_MED = dico["NOM_MED"], NOM_CMP_IDEM = "OUI", TYPE_CHAM = dico["TYPE_CHAM"],
                                 INFO = INFO, **motscsi )
#
#====================================================================
# 8. Menage des fichiers MED et HOMARD devenus inutiles
#====================================================================
#
  Liste_aux = [ Fichier_ASTER_vers_HOMARD ]
  if ( mode_homard == "ADAP" ) :
    Liste_aux.append(Fichier_HOMARD_vers_ASTER)
    fic = os.path.join(Rep_Calc_HOMARD_global, fic_homard_niter)
    Liste_aux.append(fic)
#gn  print "Liste_aux = ",Liste_aux
#
  for fic in Liste_aux :
    if ( INFO > 1 ) :
      print "Destruction du fichier ", fic
    if os.path.isfile(fic) :
      try :
        os.remove(fic)
      except os.error,codret_partiel :
        self.cr.warn("Code d'erreur de remove : " + str(codret_partiel[0]) + " : " + codret_partiel[1])
        UTMESS("F", self.nom, "Impossible de d�truire le fichier : "+fic)
#gn  print "R�pertoire ",Rep_Calc_HOMARD_global
#gn  os.system("ls -la "+Rep_Calc_HOMARD_global)
#gn  print "R�pertoire ",Rep_Calc_ASTER
#gn  os.system("ls -la "+Rep_Calc_ASTER)
#
#====================================================================
#  C'est fini !
#====================================================================
#
#gn  if ( mode_homard == "ADAP" ) :
#gn    os.system("sleep 1")
#
  return
