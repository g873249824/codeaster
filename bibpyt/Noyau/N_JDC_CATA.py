# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois at edf.fr


"""
    Ce module contient la classe de definition JDC_CATA
    qui permet de spécifier les caractéristiques d'un JDC
"""

import types
import string
import traceback

from . import N_ENTITE
from . import N_JDC
from .strfunc import ufmt


class JDC_CATA(N_ENTITE.ENTITE):

    """
     Classe pour definir un jeu de commandes

     Attributs de classe :

     - class_instance qui indique la classe qui devra etre utilisée
             pour créer l'objet qui servira à controler la conformité
             du jeu de commandes avec sa définition

     - label qui indique la nature de l'objet de définition (ici, JDC)

    """
    class_instance = N_JDC.JDC
    label = 'JDC'

    def __init__(self, code='', execmodul=None, regles=(), niveaux=(), **args):
        """
        """
        self.code = code
        self.execmodul = execmodul
        if type(regles) == tuple:
            self.regles = regles
        else:
            self.regles = (regles,)
        # Tous les arguments supplémentaires sont stockés dans l'attribut args
        # et seront passés au JDC pour initialiser ses paramètres propres
        self.args = args
        self.d_niveaux = {}
        self.l_niveaux = niveaux
        self.commandes = []
        for niveau in niveaux:
            self.d_niveaux[niveau.nom] = niveau
        # On change d'objet catalogue. Il faut d'abord mettre le catalogue
        # courant à None
        CONTEXT.unset_current_cata()
        CONTEXT.set_current_cata(self)

    def __call__(self, procedure=None, cata=None, cata_ord_dico=None,
                 nom='SansNom', parent=None, **args):
        """
            Construit l'objet JDC a partir de sa definition (self),
        """
        return self.class_instance(definition=self, procedure=procedure,
                                   cata=cata, cata_ord_dico=cata_ord_dico,
                                   nom=nom,
                                   parent=parent,
                                   **args
                                   )

    def enregistre(self, commande):
        """
           Methode qui permet aux definitions de commandes de s'enregistrer aupres
           d'un JDC_CATA
        """
        self.commandes.append(commande)

    def verif_cata(self):
        """
            Méthode de vérification des attributs de définition
        """
        self.check_regles()
        self.verif_cata_regles()

    def verif_cata_regles(self):
        """
           Cette méthode vérifie pour tous les objets stockés dans la liste entités
           respectent les REGLES associés  à self
        """
        # A FAIRE

    def report(self):
        """
           Methode pour produire un compte-rendu de validation d'un catalogue de commandes
        """
        self.cr = self.CR(
            debut="Compte-rendu de validation du catalogue " + self.code,
            fin="Fin Compte-rendu de validation du catalogue " + self.code)
        self.verif_cata()
        for commande in self.commandes:
            cr = commande.report()
            cr.debut = "Début Commande :" + commande.nom
            cr.fin = "Fin commande :" + commande.nom
            self.cr.add(cr)
        return self.cr

    def supprime(self):
        """
            Méthode pour supprimer les références arrières susceptibles de provoquer
            des cycles de références
        """
        for commande in self.commandes:
            commande.supprime()

    def get_niveau(self, nom_niveau):
        """
             Retourne l'objet de type NIVEAU de nom nom_niveau
             ou None s'il n'existe pas
        """
        return self.d_niveaux.get(nom_niveau, None)
