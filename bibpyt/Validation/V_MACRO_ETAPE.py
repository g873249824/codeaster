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

# person_in_charge: mathieu.courtois at edf.fr


"""
   Ce module contient la classe mixin MACRO_ETAPE qui porte les méthodes
   nécessaires pour réaliser la validation d'un objet de type MACRO_ETAPE
   dérivé de OBJECT.

   Une classe mixin porte principalement des traitements et est
   utilisée par héritage multiple pour composer les traitements.
"""
# Modules Python
import types
import sys
import traceback

# Modules EFICAS
from . import V_MCCOMPO
from . import V_ETAPE
from Noyau.N_Exception import AsException
from Noyau.N_utils import AsType
from Noyau.strfunc import ufmt


class MACRO_ETAPE(V_ETAPE.ETAPE):

    """
    """

    def isvalid(self, sd='oui', cr='non'):
        """
           Methode pour verifier la validité de l'objet ETAPE. Cette méthode
           peut etre appelée selon plusieurs modes en fonction de la valeur
           de sd et de cr.

           Si cr vaut oui elle crée en plus un compte-rendu.

           Cette méthode a plusieurs fonctions :

            - mettre à jour l'état de self (update)

            - retourner un indicateur de validité 0=non, 1=oui

            - produire un compte-rendu : self.cr

        """
        if CONTEXT.debug:
            print("ETAPE.isvalid ", self.nom)
        if self.state == 'unchanged':
            return self.valid
        else:
            valid = 1
            # On marque les concepts CO pour verification ulterieure de leur
            # bonne utilisation
            l = self.get_all_co()
            # On verifie que les concepts CO sont bien passes par type_sdprod
            for c in l:
                # if c.etape is self.parent:
                if c.is_typco() != 2:
                    # le concept est propriete de l'etape parent
                    # Il n'a pas ete transforme par type_sdprod
                    # Cette situation est interdite
                    # Pb: La macro-commande a passe le concept a une commande
                    # (macro ?) mal definie
                    if cr == 'oui':
                        self.cr.fatal(_("Macro-commande mal définie : le concept n'a pas été typé par "
                                        "un appel à type_sdprod pour %s"), c.nom)
                    valid = 0

            valid = valid * self.valid_child()
            valid = valid * self.valid_regles(cr)

            # exception for FORMULE for forward compatibility
            if self.reste_val != {} and self.nom != "FORMULE":
                if cr == 'oui':
                    self.cr.fatal(
                        _("Mots clés inconnus : %s"), ','.join(list(self.reste_val.keys())))
                valid = 0

            if sd == "non":
                # Dans ce cas, on ne calcule qu'une validite partielle, on ne modifie pas l'état de self
                # on retourne simplement l'indicateur valid
                return valid

            if self.sd is not None:
                valid = valid * self.valid_sdnom(cr)

            if self.definition.reentrant[0] == 'n' and self.reuse:
                # Il ne peut y avoir de concept reutilise avec une MACRO  non
                # reentrante
                if cr == 'oui':
                    self.cr.fatal(
                        _('Macro-commande non réentrante : ne pas utiliser reuse'))
                valid = 0

            if valid:
                valid = self.update_sdprod(cr)

            # Si la macro comprend des etapes internes, on teste leur validite
            for e in self.etapes:
                if not e.isvalid():
                    valid = 0
                    break

            self.set_valid(valid)

            return self.valid

    def update_sdprod(self, cr='non'):
        """
             Cette méthode met à jour le concept produit en fonction des conditions initiales :

              1. Il n'y a pas de concept retourné (self.definition.sd_prod is None)

              2. Le concept retourné n existait pas (self.sd is None)

              3. Le concept retourné existait. On change alors son type ou on le supprime

             En cas d'erreur (exception) on retourne un indicateur de validité de 0 sinon de 1
        """
        sd_prod = self.definition.sd_prod
        # On memorise le type retourné dans l attribut typret
        self.typret = None
        if type(sd_prod) == types.FunctionType:
            # Type de concept retourné calculé
            d = self.cree_dict_valeurs(self.mc_liste)
            try:
                # la sd_prod d'une macro a l'objet lui meme en premier argument
                # contrairement à une ETAPE ou PROC_ETAPE
                # Comme sd_prod peut invoquer la méthode type_sdprod qui ajoute
                # les concepts produits dans self.sdprods, il faut le mettre à
                # zéro
                self.sdprods = []
                sd_prod = sd_prod(*(self,), **d)
            except:
                # Erreur pendant le calcul du type retourné
                if CONTEXT.debug:
                    traceback.print_exc()
                self.sd = None
                if cr == 'oui':
                    l = traceback.format_exception(sys.exc_info()[0],
                                                   sys.exc_info()[1],
                                                   sys.exc_info()[2])
                    self.cr.fatal(
                        _('Impossible d affecter un type au résultat\n%s'), ' '.join(l[2:]))
                return 0
        # on teste maintenant si la SD est r\351utilis\351e ou s'il faut la
        # cr\351er
        valid = 1
        if self.reuse:
            # Un concept reutilise a ete specifie
            if AsType(self.reuse) != sd_prod:
                if cr == 'oui':
                    self.cr.fatal(
                        _('Type de concept réutilisé incompatible avec type produit'))
                valid = 0
            if self.sdnom != '':
                if self.sdnom[0] != '_' and self.reuse.nom != self.sdnom:
                    # Le nom de la variable de retour (self.sdnom) doit etre le
                    # meme que celui du concept reutilise (self.reuse.nom)
                    if cr == 'oui':
                        self.cr.fatal(_('Concept réutilisé : le nom de la variable de '
                                        'retour devrait être %s et non %s'),
                                      self.reuse.nom, self.sdnom)
                    valid = 0
            if valid:
                self.sd = self.reuse
        else:
            # Cas d'un concept non reutilise
            if sd_prod is None:  # Pas de concept retourné
                # Que faut il faire de l eventuel ancien sd ?
                self.sd = None
            else:
                if self.sd:
                    # Un sd existe deja, on change son type
                    if CONTEXT.debug:
                        print("changement de type:", self.sd, sd_prod)
                    if self.sd.__class__ != sd_prod:
                        self.sd.change_type(sd_prod)
                    self.typret = sd_prod
                else:
                    # Le sd n existait pas , on ne le crée pas
                    self.typret = sd_prod
                    if cr == 'oui':
                        self.cr.fatal(_("Concept retourné non défini"))
                    valid = 0
            if self.definition.reentrant[0] == 'o':
                if cr == 'oui':
                    self.cr.fatal(
                        _('Commande obligatoirement réentrante : spécifier reuse=concept'))
                valid = 0
        return valid

    def report(self):
        """
            Methode pour la generation d un rapport de validation
        """
        V_ETAPE.ETAPE.report(self)
        for e in self.etapes:
            self.cr.add(e.report())
        return self.cr
