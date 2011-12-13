#@ MODIF cata_champs Stanley  DATE 12/12/2011   AUTEUR DELMAS J.DELMAS 
# -*- coding: iso-8859-1 -*-
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
# ======================================================================


'''Catalogue des champs de resultats Aster'''

from Cata.cata import *
from Utilitai.Utmess import UTMESS

# ----------------------------------------------------------------------

class CHAMP :

  '''Informations sur les champs'''


  def Calc_no(champ, contexte, numeros, options=None) :

    para = {
      'reuse'      : contexte.resultat,
      'RESULTAT'   : contexte.resultat,
      'OPTION'     : champ.nom,
      'CHAM_MATER' : contexte.cham_mater,
      'NUME_ORDRE' : tuple(numeros)
      }

    if contexte.cara_elem :
      para['CARA_ELEM'] = contexte.cara_elem

    if contexte.para_sensi :
      para['SENSIBILITE'] = contexte.para_sensi

    if champ.nom in ['FORC_NODA','REAC_NODA'] :  # une specificite a disparaitre
      para['MODELE'] = contexte.modele

    # Options supplementaires passees a la commande
    if options:
       for cle in options.keys():
          para[cle] = options[cle]

    # Lancement de la commande
    try:
      apply(CALC_NO,(),para)
    except aster.error,err:
      UTMESS('A','STANLEY_4',valk=[str(err)])
    except Exception,err:
      UTMESS('A','STANLEY_5',valk=[str(err)])


  def Calc_elem(champ, contexte, numeros, options=None) :

    para = {
      'reuse'      : contexte.resultat,
      'RESULTAT'   : contexte.resultat,
      'MODELE'     : contexte.modele,
      'OPTION'     : champ.nom,
      'CHAM_MATER' : contexte.cham_mater,
      'NUME_ORDRE' : tuple(numeros)
      }

    if contexte.cara_elem :
      para['CARA_ELEM'] = contexte.cara_elem

    if contexte.para_sensi :
      para['SENSIBILITE'] = contexte.para_sensi

    # Options supplementaires passees a la commande
    if options:
       for cle in options.keys():
          para[cle] = options[cle]

    # Lancement de la commande
    try:
      apply(CALC_ELEM,(),para)
    except aster.error,err:
      UTMESS('A','STANLEY_4',valk=[str(err)])
    except Exception,err:
      UTMESS('A','STANLEY_5',valk=[str(err)])


  def __init__(self, nom_cham, type_cham, heredite, comment, fonc) :

    assert type_cham in ['ELNO','ELGA','NOEU','ELEM']

    self.nom      = nom_cham
    self.type     = type_cham
    self.heredite = heredite
    self.comment  = comment

    if fonc :
      self.fonc = fonc
    else :
      if type_cham == 'NOEU' :  self.fonc = CHAMP.Calc_no
      if type_cham == 'ELNO' :  self.fonc = CHAMP.Calc_elem
      if type_cham == 'ELGA' :  self.fonc = CHAMP.Calc_elem
      if type_cham == 'ELEM' :  self.fonc = CHAMP.Calc_elem


  def Evalue(self, contexte, numeros, options=None) :
    self.fonc(self, contexte, numeros, options)



# ----------------------------------------------------------------------

class CATA_CHAMPS :

  '''Base de connaissance sur les champs traitables'''


  def __init__(self) :

    self.cata = {}
    self('DEPL'     , 'NOEU',[],                            "D�placements aux noeuds")
    self('TEMP'     , 'NOEU',[],                            "Temp�rature aux noeuds")
    self('SIEF_ELGA', 'ELGA',['DEPL'],                      "Contraintes aux points de Gauss")
    self('SIEF_ELNO', 'ELNO',['SIEF_ELGA'],                 "Contraintes aux noeuds par �l�ment")
    self('SIEF_NOEU', 'NOEU',['SIEF_ELGA'],                 "Contraintes aux noeuds")
    self('SIGM_ELGA', 'ELGA',['SIEF_ELGA'],                 "Contraintes aux points de Gauss")
    self('SIGM_ELNO', 'ELNO',['SIEF_ELGA'],                 "Contraintes aux noeuds par �l�ment")
    self('SIGM_NOEU', 'NOEU',['SIEF_ELGA'],                 "Contraintes aux noeuds")
    self('VARI_ELGA', 'ELGA',[],                            "Variables internes aux points de Gauss")
    self('VARI_ELNO', 'ELNO',['VARI_ELGA'],                 "Variables internes aux noeuds par �l�ment")
    self('VARI_NOEU', 'NOEU',['VARI_ELNO'],                 "Variables internes aux noeuds")
    self('FLUX_ELNO', 'ELNO',['TEMP'],                      "Flux thermique aux noeuds par �l�ment")
    self('FLUX_NOEU', 'NOEU',['FLUX_ELNO'],                 "Flux thermique aux noeuds")
    self('FLUX_ELGA', 'ELGA',[],                            "Flux thermique aux points de Gauss")
    self('SIEQ_ELGA', 'ELGA',['SIEF_ELGA',],                "Invariants des contraintes aux points de Gauss")
    self('SIEQ_ELNO', 'ELNO',['SIEF_ELNO', 'SIGM_ELNO'],    "Invariants des contraintes aux noeuds par �l�ment")
    self('SIEQ_NOEU', 'NOEU',['SIEQ_ELNO'],                 "Invariants des contraintes aux noeuds")
    self('EPSI_ELGA', 'ELGA',['DEPL'],                      "D�formations aux points de Gauss")
    self('EPSI_ELNO', 'ELNO',['DEPL'],                      "D�formations aux noeuds par �l�ments")
    self('EPSI_NOEU', 'NOEU',['EPSI_ELNO'],                 "D�formations aux noeuds")
    self('EPSG_ELGA', 'ELGA',['DEPL'],                      "D�formations de Green aux points de Gauss")
    self('EPSG_ELNO', 'ELNO',['DEPL'],                      "D�formations de Green aux noeuds par �l�ments")
    self('EPSG_NOEU', 'NOEU',['EPSG_ELNO'],                 "D�formations de Green aux noeuds")
    self('EPME_ELNO', 'ELNO',['DEPL'],                      "D�formations mecaniques aux noeuds par �l�ments")
    self('EPEQ_ELGA', 'ELGA',['EPSI_ELGA'],                 "Invariants des d�formations aux points de Gauss")
    self('EPEQ_ELNO', 'ELNO',['EPSI_ELNO'],                 "Invariants des d�formations aux noeuds par �l�ment")
    self('EPEQ_NOEU', 'NOEU',['EPEQ_ELNO'],                 "Invariants des d�formations aux noeuds")

# indicateurs d erreur
    self('ERME_ELEM', 'ELEM',['SIEF_ELNO'],                 "Indicateurs d'erreur en r�sidu par �l�ment")
    self('ERME_ELNO', 'ELNO',['ERME_ELEM'],                 "Indicateurs d'erreur en r�sidu aux noeuds par �l�ment")
    self('QIRE_ELEM', 'ELEM',[],                            "Indicateurs d'erreur en quantit�s d'int�ret en r�sidu par �l�ment")
    self('QIRE_ELNO', 'ELNO',['QIRE_ELEM'],                 "Indicateurs d'erreur en quantit�s d'int�ret en r�sidu aux noeuds par �l�ment")
    self('SIZ1_ELGA', 'ELEM',['SIEF_ELGA',],                "Champ de contraintes liss�es Zhu-Zienkiewicz 1 aux noeuds")
    self('SIZ2_ELGA', 'ELEM',['SIEF_ELGA',],                "Champ de contraintes liss�es Zhu-Zienkiewicz 2 aux noeuds")
    self('ERZ1_ELEM', 'ELEM',['DEPL'],                      "Indicateurs d'erreur Zhu-Zienkiewicz 1 par �l�ment")
    self('ERZ2_ELEM', 'ELEM',['DEPL'],                      "Indicateurs d'erreur Zhu-Zienkiewicz 2 par �l�ment")
    self('QIZ1_ELEM', 'ELEM',[],                            "Indicateurs d'erreur en quantit�s d'int�ret Zhu-Zienkiewicz 1 par �l�ment")
    self('QIZ2_ELEM', 'ELEM',[],                            "Indicateurs d'erreur en quantit�s d'int�ret Zhu-Zienkiewicz 2 par �l�ment")
    self('SING_ELEM', 'ELEM',[],                            "Carte de singularit� et de taille par �l�ment")
    self('SING_ELNO', 'ELNO',['SING_ELEM'],                 "Carte de singularit� et de taille aux noeuds par �l�ment")

    self('FORC_NODA', 'NOEU',['SIEF_ELGA'],                 "Forces nodales")
    self('VALE_CONT', 'NOEU',[],                            "Informations sur l'�tat de contact")

# dyn
    self('VITE'     , 'NOEU',[],                            "Vitesses aux noeuds")
    self('ACCE'     , 'NOEU',[],                            "Acc�l�rations aux noeuds")
    self('ECIN_ELEM', 'ELEM',[],                            "Acc�l�rations aux noeuds")


# lineaire
    # contraintes
    self('SIPO_ELNO', 'ELNO',['DEPL'],                      "Contraintes aux noeuds par �l�ment pour les �l�ments Poutres")
    self('SIPM_ELNO', 'ELNO',['DEPL'],                      "Contraintes aux noeuds par element pour les elements Poutres")
    # efforts
    self('EFGE_ELNO', 'ELNO',['DEPL'],                      "Efforts generalises aux noeuds par �l�ment")
    # d�formations
    self('DEGE_ELNO', 'ELNO',[],                            "D�formation generalisee calculee a partir des d�placements pour les �l�ments de structures")


# non lineaire
    self('EPSP_ELNO', 'ELNO',['SIEF_ELGA', 'DEPL'],         "D�formations plastiques aux noeuds par �l�ment")
    self('EPSP_ELGA', 'ELGA',['SIEF_ELGA', 'DEPL'],         "D�formations plastiques aux points de Gauss")
    self('ETOT_ELGA', 'ELGA',['SIEF_ELGA', 'DEPL'],         "Densit� d'energie totale de d�formation aux points de Gauss")
    self('ETOT_ELNO', 'ELNO',['SIEF_ELGA', 'DEPL'],         "Densit� d'energie totale de d�formation aux noeuds par �l�ment")


# evol_char
    self('PRES'     , 'NOEU',[],                            "Chargement de pression aux noeuds")
    self('PRES'     , 'ELNO',[],                            "Chargement de pression par �l�ment aux noeuds")
    self('FSUR_2D'  , 'NOEU',[],                            "Chargement de bord en 2D aux noeuds")
    self('FSUR_2D'  , 'ELNO',[],                            "Chargement de bord en 2D par �l�ment aux noeuds")
    self('FSUR_3D'  , 'NOEU',[],                            "Chargement de bord en 3D aux noeuds")
    self('FSUR_3D'  , 'ELNO',[],                            "Chargement de bord en 3D par �l�ment aux noeuds")
    self('FVOL_2D'  , 'NOEU',[],                            "Chargement volumique en 2D aux noeuds")
    self('FVOL_2D'  , 'ELNO',[],                            "Chargement volumique en 2D par �l�ment aux noeuds")
    self('FVOL_3D'  , 'NOEU',[],                            "Chargement volumique en 3D aux noeuds")
    self('FVOL_3D'  , 'ELNO',[],                            "Chargement volumique en 3D par �l�ment aux noeuds")
    self('VITE_VENT', 'NOEU',[],                            "Chargement vent aux noeuds")
    self('VITE_VENT', 'ELNO',[],                            "Chargement vent par �l�ment aux noeuds")



  def __getitem__(self, nom_cham) :
    return self.cata[nom_cham]


  def __call__(self, nom_cham, type_cham, heredite, comment, fonc = None) :
    self.cata[nom_cham] = CHAMP(nom_cham, type_cham, heredite, comment, fonc)


  def Champs_presents(self, type_resu='evol_noli') :
    return self.cata.keys()


  def Ajoute_Champs(self, champ, typech='NOEU'):

    try:
      typech = champ.strip('_')[1]
      if typech in ['ELNO', 'ELGA', 'NOEU', 'ELEM']: typech = [ typech ]
      else: typech = None
    except:
      typech = None

    if typech:
      print 'Ajout de :', champ
      self(champ     , typech,[], "")



