#@ MODIF macr_fiab_impr_ops Macro  DATE 06/09/2004   AUTEUR MCOURTOI M.COURTOIS 
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

# -*- coding: iso-8859-1 -*-

# RESPONSABLE GNICOLAS G.NICOLAS
#
def macr_fiab_impr_ops(self, INFO,
                       TABLE_CIBLE, NOM_PARA_CIBLE, GRADIENTS, **args):
#
#
#  1. args est le dictionnaire des arguments
#    args.keys() est la liste des mots-cl�s
#    args.keys()[0] est la premiere valeur de cette liste
#    args.keys()[1:] est la liste des valeurs suivantes dans cette liste
#    args.keys(mot_cle) repr�sente le contenu de la variable mot_cle dans la macro appelante.
#
  """ Macro-commande r�alisant l'impression des valeurs pour le logiciel de fiabilite. """
#
# On charge les modules n�cessaires
  from Accas import _F
#
#____________________________________________________________________
#
# 1. Pr�alables
#____________________________________________________________________
#
  erreur = 0
#
# 1.1 ==> La macro compte pour 1 dans l'ex�cution des commandes
#
  self.set_icmd(1)
#
# 1.2 ==> On importe les d�finitions des commandes Aster utilis�es
#         dans la macro
#
  DEFI_FICHIER = self.get_cmd("DEFI_FICHIER")
  IMPR_TABLE   = self.get_cmd("IMPR_TABLE")
#
# 1.3. ==> Des constantes
#          Atention : le num�ro d'unit� utilis� ici et celui
#                     utlis� dans le python d'�change lance_aster_5
#                     doivent correspondre.
#
  Unite_Fichier_ASTER_vers_FIABILITE = 91
  Nom_Symbolique_Fichier_ASTER_vers_FIABILITE = "ASTER_vers_FIABILITE"
  FORMAT_R="1PE17.10"
#____________________________________________________________________
#
# 2. D�finition d'un fichier d'�change
#____________________________________________________________________
# 
  iunit = DEFI_FICHIER ( ACTION= "ASSOCIER",
#                         FICHIER = Nom_Symbolique_Fichier_ASTER_vers_FIABILITE,
                         UNITE = Unite_Fichier_ASTER_vers_FIABILITE,
                         TYPE = "ASCII",
                         INFO = INFO )
#____________________________________________________________________
#
# 4. Ecriture de la valeur cible
#____________________________________________________________________
#
  IMPR_TABLE ( TABLE = TABLE_CIBLE,
               NOM_PARA = NOM_PARA_CIBLE,
               UNITE = Unite_Fichier_ASTER_vers_FIABILITE,
               FORMAT_R = FORMAT_R,
               INFO = INFO )
#____________________________________________________________________
#
# 5. Ecritures des gradients
#____________________________________________________________________
#
  for val in GRADIENTS :
#
    IMPR_TABLE ( TABLE = val["TABLE"],
                 NOM_PARA = ("PAR_SENS", val["NOM_PARA"]),
                 UNITE = Unite_Fichier_ASTER_vers_FIABILITE,
                 FORMAT_R = FORMAT_R,
                 INFO = INFO )
#____________________________________________________________________
#
# 6. Lib�ration du fichier d'�change
#____________________________________________________________________
# 
  iunit = DEFI_FICHIER ( ACTION= "LIBERER",
                         UNITE = Unite_Fichier_ASTER_vers_FIABILITE,
                         INFO = INFO )
#
#--------------------------------------------------------------------
# 7. C'est fini !
#--------------------------------------------------------------------
#
  return erreur
