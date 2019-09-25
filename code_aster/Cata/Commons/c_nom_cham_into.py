# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: mathieu.courtois@edf.fr

from code_aster.Cata.Syntax import tr


class NOM_CHAM_INTO:  #COMMUN#
    """
    """
    def Tous(self):
        """ Tous les champs
        """
        self.all_phenomenes = ('CONTRAINTE', 'DEFORMATION', 'ENERGIE', 'CRITERES',
                               'VARI_INTERNE', 'HYDRAULIQUE', 'THERMIQUE',
                               'ACOUSTIQUE', 'FORCE', 'ERREUR', 'DEPLACEMENT',
                               'METALLURGIE', 'AUTRES','PROPRIETES')
        d = {}
        d['CONTRAINTE'] = {
            "EFGE_ELGA":        ( ("lin", "nonlin",),
                                 tr("Efforts généralisés aux points de Gauss"), ),
            "EFGE_ELNO":        ( ("lin", "nonlin",),
                                 tr("Efforts généralisés aux noeuds par élément"), ),
            "EFGE_NOEU":        ( ("lin", "nonlin",),
                                 tr("Efforts généralisés aux noeuds"), ),
            "SIEF_ELGA":        ( ("lin",),
                                 tr("Contraintes et efforts aux points de Gauss"), ),
            "SIEF_ELNO":        ( ("lin", "nonlin",),
                                 tr("Contraintes et efforts aux noeuds par élément"), ),
            "SIEF_NOEU":        ( ("lin", "nonlin",),
                                 tr("Contraintes et efforts aux noeuds"), ),
            "SIGM_ELGA":        ( ("lin", "nonlin",),
                                 tr("Contraintes aux points de Gauss"), ),
            "SIGM_ELNO":        ( ("lin", "nonlin",),
                                 tr("Contraintes aux noeuds par élément"), ),
            "SIGM_NOEU":        ( ("lin", "nonlin",),
                                 tr("Contraintes aux noeuds"), ),
            "SIPM_ELNO":        ( ("lin","nonlin"),
                                 tr("Contraintes aux noeuds par élément pour les éléments de poutre"), ),
            "SIPO_ELNO":        ( ("lin", "nonlin",),
                                 tr("Contraintes aux noeuds par élément pour les éléments de poutre"), ),
            "SIPO_NOEU":        ( ("lin", "nonlin",),
                                 tr("Contraintes aux noeuds pour les éléments de poutre"), ),
            "SIRO_ELEM":        ( ("lin", "nonlin",),
                                 tr("Contraintes de rosette par élément"), ),
        }
        d['DEFORMATION'] = {
            "DEGE_ELGA":        ( ("lin", "nonlin",),
                                 tr("Déformations généralisées aux points de Gauss"), ),
            "DEGE_ELNO":        ( ("lin", "nonlin",),
                                 tr("Déformations généralisées aux noeuds par élément"), ),
            "DEGE_NOEU":        ( ("lin", "nonlin",),
                                 tr("Déformations généralisées aux noeuds"), ),
            "EPFD_ELGA":        ( ("nonlin",),
                                 tr("Déformations de fluage de déssication aux points de Gauss"), ),
            "EPFD_ELNO":        ( ("nonlin",),
                                 tr("Déformations de fluage de déssication aux noeuds par élément"), ),
            "EPFD_NOEU":        ( ("nonlin",),
                                 tr("Déformations de fluage de déssication aux noeuds"), ),
            "EPFP_ELGA":        ( ("nonlin",),
                                 tr("Déformations de fluage propre aux points de Gauss"), ),
            "EPFP_ELNO":        ( ("nonlin",),
                                 tr("Déformations de fluage propre aux noeuds par élément"), ),
            "EPFP_NOEU":        ( ("nonlin",),
                                 tr("Déformations de fluage propre aux noeuds"), ),
            "EPME_ELGA":        ( ("lin", "nonlin",),
                                 tr("Déformations mécaniques en petits déplacements aux points de Gauss"), ),
            "EPME_ELNO":        ( ("lin", "nonlin",),
                                 tr("Déformations mécaniques en petits déplacements aux noeuds par élément"), ),
            "EPME_NOEU":        ( ("lin", "nonlin",),
                                 tr("Déformations mécaniques en petits déplacements aux noeuds"), ),
            "EPMG_ELGA":        ( ("nonlin",),
                                 tr("Déformations mécaniques en grands déplacements aux points de Gauss"), ),
            "EPMG_ELNO":        ( ("nonlin",),
                                 tr("Déformations mécaniques en grands déplacements aux noeuds par élément"), ),
            "EPMG_NOEU":        ( ("nonlin",),
                                 tr("Déformations mécaniques en grands déplacements aux noeuds"), ),
            "EPSG_ELGA":        ( ("lin","nonlin",),
                                 tr("Déformations de Green-Lagrange aux points de Gauss"), ),
            "EPSG_ELNO":        ( ("lin","nonlin",),
                                 tr("Déformations de Green-Lagrange aux noeuds par élément"), ),
            "EPSG_NOEU":        ( ("lin","nonlin",),
                                 tr("Déformations de Green-Lagrange aux noeuds"), ),
            "EPSI_ELGA":        ( ("lin", "nonlin",),
                                 tr("Déformations aux points de Gauss"), ),
            "EPSI_ELNO":        ( ("lin", "nonlin",),
                                 tr("Déformations aux noeuds par élément"), ),
            "EPSI_NOEU":        ( ("lin", "nonlin",),
                                 tr("Déformations aux noeuds"), ),
            "EPSP_ELGA":        ( ("nonlin",),
                                 tr("Déformations anélastique aux points de Gauss"), ),
            "EPSP_ELNO":        ( ("nonlin",),
                                 tr("Déformations anélastique aux noeuds par élément"), ),
            "EPSP_NOEU":        ( ("nonlin",),
                                 tr("Déformations anélastique aux noeuds"), ),
            "EPVC_ELGA":        ( ("lin", "nonlin",),
                                 tr("Déformations dues aux variables de commande aux points de Gauss"), ),
            "EPVC_ELNO":        ( ("lin", "nonlin",),
                                 tr("Déformations dues aux variables de commande aux noeuds par élément"), ),
            "EPVC_NOEU":        ( ("lin", "nonlin",),
                                 tr("Déformations dues aux variables de commande aux noeuds"), ),
            "EPSL_ELGA":        ( ("lin", "nonlin",),
                                 tr("Déformations logarithmiques aux points de Gauss"), ),
            "EPSL_ELNO":        ( ("lin", "nonlin",),
                                 tr("Déformations logarithmiques aux noeuds par élément"), ),
            "EPSL_NOEU":        ( ("lin", "nonlin",),
                                 tr("Déformations logarithmiques aux noeuds"), ),

        }
        d['ENERGIE'] = {
            "DISS_ELEM":        ( ("lin", "nonlin",),
                                 tr("Énergie de dissipation par élément"), ),
            "DISS_ELGA":        ( ("lin", "nonlin",),
                                 tr("Densité d'énergie de dissipation aux points de Gauss"), ),
            "DISS_ELNO":        ( ("lin", "nonlin",),
                                 tr("Densité d'énergie de dissipation aux noeuds par élément"), ),
            "DISS_NOEU":        ( ("lin", "nonlin",),
                                 tr("Densité d'énergie de dissipation aux noeuds"), ),
            "ECIN_ELEM":        ( ("lin",),
                                 tr("Énergie cinétique par élément"), ),
            "ENEL_ELEM":        ( ("lin", "nonlin",),
                                 tr("Énergie élastique par élément"), ),
            "ENEL_ELGA":        ( ("lin", "nonlin",),
                                 tr("Densité d'énergie élastique aux points de Gauss"), ),
            "ENEL_ELNO":        ( ("lin", "nonlin",),
                                 tr("Densité d'énergie élastique aux noeuds par élément"), ),
            "ENEL_NOEU":        ( ("lin", "nonlin",),
                                 tr("Densité d'énergie élastique aux noeuds"), ),
            "ENTR_ELEM":        ( ("lin", "nonlin",),
                                 tr("Énergie élastique modifiée (seulement traction) utilisée par Gp"), ),
            "EPOT_ELEM":        ( ("lin",),
                                 tr("Énergie potentielle de déformation élastique par élément"), ),
            "ETOT_ELEM":        ( ("lin", "nonlin",),
                                 tr("Incrément d'énergie de déformation totale par élément"), ),
            "ETOT_ELGA":        ( ("lin", "nonlin",),
                                 tr("Incrément de densité d'énergie de déformation totale aux points de Gauss"), ),
            "ETOT_ELNO":        ( ("lin", "nonlin",),
                                 tr("Incrément de densité d'énergie de déformation totale aux noeuds par élément"), ),
            "ETOT_NOEU":        ( ("lin", "nonlin",),
                                 tr("Incrément de densité d'énergie de déformation totale aux noeuds"), ),
        }
        d['CRITERES'] = {
            "DERA_ELGA":        ( ("nonlin",),
                                 tr("Indicateur local de décharge et de perte de radialité aux points de Gauss"), ),
            "DERA_ELNO":        ( ("nonlin",),
                                 tr("Indicateur local de décharge et de perte de radialité aux noeuds par élément"), ),
            "DERA_NOEU":        ( ("nonlin",),
                                 tr("Indicateur local de décharge et de perte de radialité aux noeuds"), ),
            "ENDO_ELGA":        ( ("nonlin",),
                                 tr("Dommage de Lemaître-Sermage aux points de Gauss"), ),
            "ENDO_ELNO":        ( ("nonlin",),
                                 tr("Dommage de Lemaître-Sermage aux noeuds par élément"), ),
            "ENDO_NOEU":        ( ("nonlin",),
                                 tr("Dommage de Lemaître-Sermage aux noeuds"), ),
            "EPEQ_ELGA":        ( ("lin", "nonlin",),
                                 tr("Déformations équivalentes aux points de Gauss"), ),
            "EPEQ_ELNO":        ( ("lin", "nonlin",),
                                 tr("Déformations équivalentes aux noeuds par élément"), ),
            "EPEQ_NOEU":        ( ("lin", "nonlin",),
                                 tr("Déformations équivalentes aux noeuds"), ),
            "EPGQ_ELGA":        ( ("lin", "nonlin",),
                                 tr("Déformations équivalentes de Green-Lagrange aux points de Gauss"), ),
            "EPGQ_ELNO":        ( ("lin", "nonlin",),
                                 tr("Déformations équivalentes de Green-Lagrange aux noeuds par élément"), ),
            "EPGQ_NOEU":        ( ("lin", "nonlin",),
                                 tr("Déformations équivalentes de Green-Lagrange aux noeuds"), ),
            "EPMQ_ELGA":        ( ("lin", "nonlin",),
                                 tr("Déformations mécaniques équivalentes aux points de Gauss"), ),
            "EPMQ_ELNO":        ( ("lin", "nonlin",),
                                 tr("Déformations mécaniques équivalentes aux noeuds par élément"), ),
            "EPMQ_NOEU":        ( ("lin", "nonlin",),
                                 tr("Déformations mécaniques équivalentes aux noeuds"), ),
            "INDL_ELGA":        ( ("nonlin",),
                                 tr("Indicateur de localisation aux points de Gauss"), ),
            "PDIL_ELGA":        ( ("nonlin",),
                                 tr("Module de rigidité de micro-dilatation"), ),
            "SIEQ_ELGA":        ( ("lin", "nonlin",),
                                 tr("Contraintes équivalentes aux points de Gauss"), ),
            "SIEQ_ELNO":        ( ("lin", "nonlin",),
                                 tr("Contraintes équivalentes aux noeuds par élément"), ),
            "SIEQ_NOEU":        ( ("lin", "nonlin",),
                                 tr("Contraintes équivalentes aux noeuds"), ),
        }
        d['VARI_INTERNE'] = {
            "VAEX_ELGA":        ( ("nonlin",),
                                 tr("Extraction d'une variable interne aux points de Gauss"), ),
            "VAEX_ELNO":        ( ("nonlin",),
                                 tr("Extraction d'une variable interne aux noeuds pas élément"), ),
            "VAEX_NOEU":        ( ("nonlin",),
                                 tr("Extraction d'une variable interne aux noeuds"), ),
            "VARC_ELGA":        ( ("lin", "nonlin",),
                                 tr("Variables de commande aux points de Gauss"), ),
            "VARI_ELNO":        ( ("nonlin",),
                                 tr("Variables internes aux noeuds pas élément"), ),
            "VARI_NOEU":        ( ("nonlin",),
                                 tr("Variables internes aux noeuds"), ),
        }
        d['HYDRAULIQUE'] = {
            "FLHN_ELGA":        ( ("nonlin",),
                                 tr("Flux hydrauliques aux points de Gauss"), ),
        }
        d['THERMIQUE'] = {
            "TEMP_ELGA":        ( (),
                                 tr("Température aux points de Gauss"), ),
            "FLUX_ELGA":        ( (),
                                 tr("Flux thermique aux points de Gauss"), ),
            "FLUX_ELNO":        ( (),
                                 tr("Flux thermique aux noeuds par élément"), ),
            "FLUX_NOEU":        ( (),
                                 tr("Flux thermique aux noeuds"), ),
            "HYDR_NOEU":        ( (),
                                 tr("Hydratation aux noeuds"), ),
            "SOUR_ELGA":        ( (),
                                 tr("Source de chaleur à partir d'un potentiel électrique"), ),
            "ETHE_ELEM":        ( (),
                                 tr("Énergie dissipée thermiquement"), ),
        }
        d['ACOUSTIQUE'] = {
            "PRAC_ELNO":        ( (),
                                 tr("Pression acoustique aux noeuds par élément"), ),
            "PRAC_NOEU":        ( (),
                                 tr("Pression acoustique aux noeuds"), ),
            "PRME_ELNO":        ( (),
                                 tr("Pression aux noeuds par élément pour les éléments FLUIDE"), ),
            "INTE_ELNO":        ( (),
                                 tr("Intensité acoustique aux noeuds par élément"), ),
            "INTE_NOEU":        ( (),
                                 tr("Intensité acoustique aux noeuds"), ),
        }
        d['FORCE'] = {
            "FORC_NODA":        ( (),
                                 tr("Forces nodales"), ),
            "REAC_NODA":        ( (),
                                 tr("Réactions nodales"), ),
        }
        d['ERREUR'] = {
            "SIZ1_NOEU":        ( (),
                                 tr("Contraintes lissées de Zhu-Zienkiewicz version 1 aux noeuds"), ),
            "ERZ1_ELEM":        ( (),
                                 tr("Indicateur d'erreur de Zhu-Zienkiewicz version 1 par élément"), ),
            "SIZ2_NOEU":        ( (),
                                 tr("Contraintes lissées de Zhu-Zienkiewicz version 2 aux noeuds"), ),
            "ERZ2_ELEM":        ( (),
                                 tr("Indicateur d'erreur de Zhu-Zienkiewicz version 2 par élément"), ),
            "ERME_ELEM":        ( (),
                                 tr("Indicateur d'erreur en résidu en mécanique par élément"), ),
            "ERME_ELNO":        ( (),
                                 tr("Indicateur d'erreur en résidu en mécanique aux noeuds par élément"), ),
            "ERME_NOEU":        ( (),
                                 tr("Indicateur d'erreur en résidu en mécanique aux noeuds"), ),
            "QIRE_ELEM":        ( (),
                                 tr("Indicateur d'erreur en quantités d'intérêt en résidu par élément"), ),
            "QIRE_ELNO":        ( (),
                                 tr("Indicateur d'erreur en quantités d'intérêt en résidu aux noeuds par élément"), ),
            "QIRE_NOEU":        ( (),
                                 tr("Indicateur d'erreur en quantités d'intérêt en résidu aux noeuds"), ),
            "QIZ1_ELEM":        ( (),
                                 tr("Indicateur d'erreur en quantités d'intérêt de Zhu-Zienkiewicz version 1 par élément"), ),
            "QIZ2_ELEM":        ( (),
                                 tr("Indicateur d'erreur en quantités d'intérêt de Zhu-Zienkiewicz version 2 par élément"), ),
            "SING_ELEM":        ( (),
                                 tr("Degré de singularité par élément"), ),
            "SING_ELNO":        ( (),
                                 tr("Degré de singularité aux noeuds par élément"), ),
            "ERTH_ELEM":        ( (),
                                 tr("Indicateur d'erreur en résidu en thermique par élément"), ),
            "ERTH_ELNO":        ( (),
                                 tr("Indicateur d'erreur en résidu en thermique aux noeuds par élément"), ),
            "ERTH_NOEU":        ( (),
                                 tr("Indicateur d'erreur en résidu en thermique aux noeuds"), ),
        }
        d['METALLURGIE'] = {
            "DURT_ELNO":        ( (),
                                 tr("Dureté aux noeuds par élément"), ),
            "DURT_NOEU":        ( (),
                                 tr("Dureté aux noeuds"), ),
            "META_ELNO":        ( (),
                                 tr("Proportion de phases métallurgiques aux noeuds par élément"), ),
            "META_NOEU":        ( (),
                                 tr("Proportion de phases métallurgiques aux noeuds"), ),
        }
        d['DEPLACEMENT'] = {
            "ACCE":             ( (),
                                 tr("Accélération aux noeuds"), ),
            "ACCE_ABSOLU":      ( (),
                                 tr("Accélération absolue aux noeuds"), ),
            "DEPL":             ( (),
                                 tr("Déplacements aux noeuds"), ),
            "DEPL_ABSOLU":      ( (),
                                 tr("Déplacements absolus aux noeuds"), ),
            "HHO_FACE":         ( (),
                                 tr("Déplacements des faces pour la modélisation HHO"), ),
            "HHO_CELL":         ( (),
                                 tr("Déplacements des cellules pour la modélisation HHO"), ),
            "STRX_ELGA":        ( (),
                                 tr("Efforts généralisés à partir des déplacements en linéaire aux points de Gauss"), ),
            "TEMP":             ( (),
                                 tr("Température aux noeuds"), ),
            "VITE":             ( (),
                                 tr("Vitesse aux noeuds"), ),
            "CONT_NOEU":        ( (),
                                 tr("Statuts de contact aux noeuds"), ),
            "CONT_ELEM":        ( (),
                                 tr("Statuts de contact aux éléments (LAC)"), ),
            "VARI_ELGA":        ( (),
                                 tr("Variables internes aux points de Gauss"), ),
            "VITE_ABSOLU":      ( (),
                                 tr("Vitesse absolue aux noeuds"), ),
        }
        d['AUTRES'] = {
            "COHE_ELEM":        ( ("nonlin",),
                                 tr("Variables internes cohésives XFEM"), ),
            "COMPORTEMENT":     ( (),
                                 tr("Carte de comportement mécanique"), ),
            "COMPORTHER":       ( (),
                                 tr("Carte de comportement thermique"), ),
            "DEPL_VIBR":        ( (),
                                 tr("Déplacement pour mode vibratoire"), ),
            "DIVU":             ( (),
                                 tr("Déformation volumique en THM"), ),
            "EPSA_ELNO":        ( (),
                                 tr("Déformations anélastique aux noeuds par élément"), ),
            "EPSA_NOEU":        ( (),
                                 tr("Déformations anélastique aux noeuds"), ),
            "FERRAILLAGE":      ( ("lin",),
                                 tr("Densité de ferraillage"), ),
            "FSUR_2D":          ( (),
                                 tr("Chargement de force surfacique en 2D"), ),
            "FSUR_3D":          ( (),
                                 tr("Chargement de force surfacique en 3D"), ),
            "FVOL_2D":          ( (),
                                 tr("Chargement de force volumique en 2D"), ),
            "FVOL_3D":          ( (),
                                 tr("Chargement de force volumique en 3D"), ),
            "COEF_H":           ( (),
                                 tr("Coefficient d'échange constant par élément"), ),
            "T_EXT":            ( (),
                                 tr("Température extérieure constante par élément"), ),
            "HYDR_ELNO":        ( (),
                                 tr("Hydratation aux noeuds par élément"), ),
            "IRRA":             ( (),
                                 tr("Irradition aux noeuds"), ),
            "MODE_FLAMB":       ( (),
                                 tr("Mode de flambement"), ),
            "MODE_STAB":        ( (),
                                 tr("Mode de stabilité"), ),
            "NEUT":             ( (),
                                 tr("Variable de commande 'neutre'"), ),
            "PRES":             ( (),
                                 tr("Chargement de pression"), ),
            "PTOT":             ( (),
                                 tr("Pression totale de fluide en THM"), ),
            "SISE_ELNO":        ( (),
                                 tr("Contraintes aux noeuds par sous-élément"), ),
            "VITE_VENT":        ( (),
                                 tr("Chargement vitesse du vent"), ),
        }
        d['PROPRIETES'] = {
            "MATE_ELGA":        ( ("lin", "nonlin",),
                                 tr("Valeurs des paramètres matériaux élastiques aux points de Gauss"), ),
            "MATE_ELEM":        ( ("lin", "nonlin",),
                                 tr("Valeurs des paramètres matériaux élastiques par élément"), ),
        }

        for typ in ('ELGA', 'ELNO', 'ELEM', 'NOEU', 'CART'):
            for i in range(1, 11):
                d['AUTRES']['UT%02d_%s' % (i, typ)]=( (),
                                 tr("Champ utilisateur numéro %02d_%s" % (i, typ)), )
        self.d_all = d
        return

    def CheckPhenom(self):
        """ Vérification de la cohérence entre les phenomènes et les clés
        """
        l_keys = list(self.d_all.keys())
        l_phen = list(self.all_phenomenes)
        uniq_keys = set(l_keys)
        uniq_phen = set(l_phen)
        if len(l_keys) != len(uniq_keys) or len(l_phen) != len(uniq_phen) :
            for i in uniq_keys :
                l_keys.remove(i)
            assert len(l_keys) == 0, 'Keys must be unique: %s' % l_keys
            for i in uniq_phen :
                l_phen.remove(i)
            assert len(l_phen) == 0, 'Phenomenon must be unique: %s' % l_phen
        if len(l_keys) > len(l_phen) :
            for i in l_phen :
                l_keys.remove(i)
            assert len(l_keys) == 0, 'Key %s not listed in the list of phenomenons' % l_keys
        if len(l_keys) < len(l_phen) :
            for i in l_keys:
                l_phen.remove(i)
            assert len(l_phen) == 0, 'Phenomenon %s not known as a key' % l_phen


    def CheckField(self):
        """ Vérification des doublons dans les noms des champs
        """
        l_cham = []
        for phen in self.all_phenomenes:
            l_cham.extend(list(self.d_all[phen].keys()))
        uniq = set(l_cham)
        if len(l_cham) != len(uniq):
            for i in uniq:
                l_cham.remove(i)
            assert len(l_cham) == 0, 'Field names must be unique: %s' % l_cham


    def InfoChamps(self, l_nom_cham):
        """ on renvoie juste les informations relatives au(x) champ(s)
        """
        d_cham = {}.fromkeys( l_nom_cham, ( '', '', '' ) )
        for nom_cham in l_nom_cham:
            for phen in self.all_phenomenes:
              for cham in list(self.d_all[phen].keys()):
                  if nom_cham == cham:
                      cate = self.d_all[phen][cham][0]
                      helptxt = self.d_all[phen][cham][1]
                      d_cham[nom_cham] = ( phen, cate, helptxt )
        return d_cham

    def Filtre(self, *l_typ_cham, **kwargs):
        """ Check des doublons
        """
        phenomene   = kwargs.get('phenomene')
        categorie   = kwargs.get('categorie')
        # Construction de la liste des champs en tenant compte des eventuels filtre (phenomene, categorie, l_typ_cham)
        # ------------------------------------------------------------------------------------------------------------
        l_cham = []
        # Filtre par phenomene
        if phenomene is None:
            l_phen = self.all_phenomenes
        else:
            l_phen = [ phenomene ]
        for phen in l_phen:
            # parcours de tous les champs
            for cham in list(self.d_all[phen].keys()):
               isok = True
               # Filtre par categorie
               if categorie is not None:
                 lcat = self.d_all[phen][cham][0]
                 if type(lcat) not in (tuple, list):
                     lcat = [lcat, ]
                 if categorie in lcat:
                     isok = True
                 else:
                     isok = False
               if isok:
                 l_cham.append(cham)
        l_cham.sort()
        # Filtre sur les types de champs
        if len(l_typ_cham) == 0:
            return tuple(l_cham)
        l_ncham = []
        for typ in l_typ_cham :
            for cham in l_cham :
                if typ in cham.split('_'):
                  l_ncham.append(cham)
        return tuple(l_ncham)

    def __init__(self):
        self.Tous()
        # check les doublons (fonctionnalite developpeur permettant de detecter les doublons dans les champs)
        if 1:
            self.CheckPhenom()
            self.CheckField()

    def __call__(self, *l_typ_cham, **kwargs):
        """Cette fonction retourne la liste des "into" possibles pour le mot-clé NOM_CHAM.
        C'est à dire les noms de champs des SD RESULTAT (DATA de la routine RSCRSD).
        l_typ_cham : rien ou un ou plusieurs parmi 'ELGA', 'ELNO', 'NOEU', 'ELEM'.
        kwargs : un dictionnaire de mot-cles, les cles parmis :
          'phenomene'  : retourne la liste des champs en filtrant par le phenomene (eventuellement mixe avec le suivant)
          'categorie'  : retourne la liste des champs en filtrant par le phenomene (eventuellement mixe avec le precedent)
          'l_nom_cham' : (une liste ou un string) retourne uniqement les informations relatives au champ precise en argument
        """
        l_nom_cham  = kwargs.get('l_nom_cham')
        if type(l_nom_cham) == str:
            l_nom_cham = [ l_nom_cham ]
        if l_nom_cham:
            return self.InfoChamps(l_nom_cham)
        else:
            return self.Filtre(*l_typ_cham, **kwargs)


C_NOM_CHAM_INTO = NOM_CHAM_INTO()
