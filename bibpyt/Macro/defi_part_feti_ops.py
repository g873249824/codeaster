#@ MODIF defi_part_feti_ops Macro  DATE 14/06/2005   AUTEUR DURAND C.DURAND 
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
# RESPONSABLE ASSIRE A.ASSIRE


# ===========================================================================
#           CORPS DE LA MACRO "DEFI_PART_FETI"
#           -------------------------------------
# USAGE :
#  MAILLAGE        maillage a partitionner
#  MODELE          modele (facultatif)
#  NB_PART         nb de sous-domaines
#  EXCIT           liste des chargements
#  METHODE         PMETIS, KMETIS ou AUTRE
#  LOGICIEL        si AUTRE alors on attend un chemin complet vers executable
#  NOM_GROUP_MA    Un nom de base pour les group_ma contenant les SD
#  INFO            1,2
#  
# ===========================================================================
# script PYTHON : appel a Metis et lancement de DEFI_PART_OPS


def defi_part_feti_ops(self,MAILLAGE,MODELE,NB_PART,EXCIT,METHODE,NOM_GROUP_MA,INFO,**args):

  import aster, string

  from Accas           import _F
  from Noyau.N_utils   import AsType
  from Utilitai.Utmess import UTMESS
  from Utilitai        import partition

  # DEBUT DE LA MACRO

  # La macro compte pour 1 dans la numerotation des commandes
  self.set_icmd(1)
  ier=0

  # On importe les definitions des commandes a utiliser dans la macro
  DEFI_PART_OPS   = self.get_cmd('DEFI_PART_OPS')
  INFO_EXEC_ASTER = self.get_cmd('INFO_EXEC_ASTER')
  DEFI_FICHIER    = self.get_cmd('DEFI_FICHIER')
  DETRUIRE        = self.get_cmd('DETRUIRE')

  nompro='DEFI_PART_FETI'

  INCLUSE='NON'  # On cree des GROUP_MA pour les mailles de bords (pour developpeur)

  # Nom des GROUP_MA g�n�r�s
  NOM_GROUP_MA = string.strip(NOM_GROUP_MA)
  NOM_GROUP_MA_BORD = '_' + NOM_GROUP_MA

  # Test sur le nombre de caract�res de NOM_GROUP_MA
  if ( len(NOM_GROUP_MA)+len(str(NB_PART)) > 7 ):
    ln=7-len(str(NB_PART))
    UTMESS('F', nompro, 'Afin de pouvoir g�n�rer les GROUP_MA, r�duisez le nombre '\
                        'de caract�res de NOM_GROUP_MA � un maximum de : %i' %ln)

  # Verification que des GROUP_MA ne portent pas deja les memes noms
  _lst = []
  for i in MAILLAGE.LIST_GROUP_MA():
    _lst.append( string.strip(i[0]) )
  for i in range(NB_PART):
    if ( NOM_GROUP_MA+str(i) in _lst ):
      ngrma=NOM_GROUP_MA+str(i)
      UTMESS('F', nompro, "Il existe d�j� un GROUP_MA nomm� : %s" %ngrma)
    if ( NOM_GROUP_MA_BORD+str(i) in _lst ):
      ngrma=NOM_GROUP_MA_BORD+str(i)
      UTMESS('F', nompro, "Il existe d�j� un GROUP_MA nomm� : %s" %ngrma)

  # Executable du partitionneur
  if METHODE=="AUTRE":
    exe_metis = arg['LOGICIEL']
  else:
    exe_metis = aster.repout() + string.lower(METHODE)

  # Le concept sortant dans le contexte de la macro
  self.DeclareOut('_SDFETI',self.sd)

  # Debut :

  # Objet Partition
  _part = partition.PARTITION(jdc=self);

  # Recuperation de deux UL libres
  _UL=INFO_EXEC_ASTER(LISTE_INFO='UNITE_LIBRE')
  ul1=_UL['UNITE_LIBRE',1]
  DETRUIRE(CONCEPT=(_F(NOM=_UL),), INFO=1)
  DEFI_FICHIER(UNITE=ul1)
  _UL=INFO_EXEC_ASTER(LISTE_INFO='UNITE_LIBRE')
  ul2=_UL['UNITE_LIBRE',1]
  DEFI_FICHIER(ACTION='LIBERER',UNITE=ul1)

  fichier_in  = 'fort.' + str(ul1)
  fichier_out = 'fort.' + str(ul2)

  # Options de la classe Partition
  _part.OPTIONS['exe_metis']   = exe_metis
  _part.OPTIONS['fichier_in']  = fichier_in
  _part.OPTIONS['fichier_out'] = fichier_out


  # Partitionnement
  if MODELE:
    _part.Partitionne_Aster(
                       MAILLAGE = MAILLAGE,
                       MODELE   = MODELE,
                       NB_PART  = NB_PART,
                       INFO     = INFO,
                       );

  elif MAILLAGE:
    _part.Partitionne_Aster(
                       MAILLAGE = MAILLAGE,
                       NB_PART  = NB_PART,
                       INFO     = INFO,
                       );


  # Creation des group_ma dans le maillage Aster
  _part.Creation_Group_ma_Aster_par_SD(NOM=NOM_GROUP_MA, NOM2=NOM_GROUP_MA_BORD, INCLUSE=INCLUSE)


  # Creation de la SDFETI
  if MODELE:
    _tmp  = []
    for i in range(NB_PART):
      txt = { 'GROUP_MA': NOM_GROUP_MA + str(i) }
      if ( NOM_GROUP_MA_BORD+str(i) in _part.ASTER['GROUP_MA_BORD'] ):
        txt['GROUP_MA_BORD'] = NOM_GROUP_MA_BORD + str(i)
      _tmp.append( txt )
  
    motscle2= {'DEFI': _tmp }
  
    # Regeneration des mots-cles EXCIT pass�s en argument de la macro
    if EXCIT:
      dExcit=[]
      for j in EXCIT :
        dExcit.append(j.cree_dict_valeurs(j.mc_liste))
        for i in dExcit[-1].keys():
          if dExcit[-1][i]==None : del dExcit[-1][i]
      motscle2['EXCIT']=dExcit
  
    _SDFETI=DEFI_PART_OPS(NOM='SDD',
                          MODELE=MODELE,
                          INFO=1,
                          **motscle2
                          );
  else:
    _SDFETI=None


  # Fin :

  return ier
