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
"""

# Modules Python
import traceback
import sys

# Modules EFicas
from . import B_ETAPE
from Noyau.N_Exception import AsException
from Noyau import N__F
from Noyau.N_utils import AsType
from . import B_utils


class MACRO_ETAPE(B_ETAPE.ETAPE):

    """
    Cette classe implémente les méthodes relatives à la phase de construction
    d'une macro-etape.
    """
    macros = {}

    def __init__(self):
        pass

    def Build(self):
        """
        Fonction : Construction d'une étape de type MACRO

        La construction n'est à faire que pour certaines macros.
        Ensuite on boucle sur les sous étapes construites
        en leur demandant de se construire selon le meme processus
        """
        self.set_current_step()
        self.building = None
        # Chaque macro_etape doit avoir un attribut cr du type CR
        # (compte-rendu) pour stocker les erreurs eventuelles
        # et doit l'ajouter au cr de l'etape parent pour construire un
        # compte-rendu hierarchique
        self.cr = self.CR(
            debut='Etape : ' + self.nom + '    ligne : ' +
            repr(self.appel[0]) + '    fichier : ' + repr(self.appel[1]),
            fin='Fin Etape : ' + self.nom)

        try:
            ier = self._Build()
            if ier == 0 and self.jdc.par_lot == 'OUI':
                # Traitement par lot
                for e in self.etapes:
                    if not e.isactif():
                        continue
                    ier = ier + e.Build()

            if not self.cr.estvide():
                self.parent.cr.add(self.cr)
            self.reset_current_step()
            return ier
        except:
            # Si une exception a ete levee, on se contente de remettre le step courant au pere
            # et on releve l'exception
            if not self.cr.estvide():
                self.parent.cr.add(self.cr)
            self.reset_current_step()
            raise

    def Build_alone(self):
        """
            Construction d'une étape de type MACRO.

            On ne construit pas les sous commandes et le
            current step est supposé correctement initialisé
        """
        ier = self._Build()
        return ier

    def _Build(self):
        """
           Cette méthode réalise le traitement de construction pour
           l'objet lui meme
        """
        if CONTEXT.debug:
            print("MACRO_ETAPE._Build ", self.nom, self.definition.op)

        ier = 0
        try:
            if self.definition.proc is not None:
                # On est dans le cas d'une macro en Python. On evalue la fonction
                # self.definition.proc dans le contexte des valeurs de mots clés (d)
                # La fonction proc doit demander la numerotation de la commande
                # (appel de set_icmd)
                d = self.cree_dict_valeurs(self.mc_liste)
                ier = self.definition.proc(*(self,), **d)
            elif self.definition.op in self.macros:
                ier = self.macros[self.definition.op](self)
            else:
                # Pour presque toutes les commandes (sauf FORMULE et POURSUITE)
                # le numero de la commande n est pas utile en phase de construction
                # Néanmoins, on le calcule en appelant la methode set_icmd avec un
                # incrément de 1
                # un incrément de 1 indique que la commande compte pour 1 dans
                # la numérotation globale
                # un incrément de None indique que la commande ne sera pas
                # numérotée.
                self.set_icmd(1)

            if ier:
                self.cr.fatal(
                    _("Erreur dans la macro %s\nligne : %s fichier : "),
                    self.nom, self.appel[0], self.appel[1])

        except AsException as e:
            ier = 1
            self.cr.fatal(_("Erreur dans la macro %s\n%s"), self.nom, e)
        except (EOFError, self.jdc.UserError):
            raise
        except:
            ier = 1
            l = traceback.format_exception(
                sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2])
            self.cr.fatal(
                _("Erreur dans la macro %s\n%s"), self.nom, ' '.join(l))

        return ier

    def gcncon(self, typ):
        """Retourne un nom de concept non encore utilisé et unique.

        Arguments:
            typ (str): '.' : le concept sera détruit en fin de job.
                ou bien '_' : le concept ne sera pas détruit.

        Returns:
            resul (str): Nom d'un concept unique sur 8 caractères.
                Ce nom est de la forme ``typ + '9ijklmn'`` ou ``ijklmn`` est un
                nombre incrémenté à chaque appel pour garantir l'unicité
                des noms.
                Donc 1.e6 noms possibles pour les macros.
                Les noms affectés par gcncon en fortran sont de la forme
                ``typ + 'ijklmnp'``. Il n'y a pas de conflit jusqu'à 8999999.
        """
        newid = self.jdc.get_new_id()
        assert newid < 1000000, "more than 1.000.000 of temporary objects!"
        return "{0}9{1:06}".format(typ, newid)

    def DeclareOut(self, nom, concept):
        """
            Methode utilisee dans une macro lors de la construction
            de cette macro en Python (par opposition a une construction en Fortran).
            Elle a pour but de specifier le mapping entre un nom de concept local
            a la macro (nom) et le concept de sortie effectif qui existe deja
            au moment de la construction
            Cette information sera utilisee lors de la creation du concept produit
            par une sous commande créée postérieurement.
        """
        self.Outputs[nom] = concept

    def get_sd_avant_etape(self, nom, etape):
        """
            Retourne le concept de nom nom defini avant l etape etape
        """
        sd = self.parent.get_sd_avant_etape(nom, self)
        if not sd:
            d = self.get_contexte_avant(etape)
            sd = d.get(nom, None)
        return sd

    def get_sdprod_byname(self, name):
        """
            Fonction : Retourne le concept produit de la macro self dont le nom est name
                       Si aucun concept produit n'a le nom name, retourne None
        """
        sd = None
        if self.sd and self.sd.nom == name:
            sd = self.sd
        else:
            for sdprod in self.sdprods:
                if sdprod.nom == name:
                    sd = sdprod
                    break
        return sd
