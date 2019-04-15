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
"""
import os
# Modules Python
import sys
import time
from os import times

import aster
import aster_core
from . import checksd
from .code_file import CodeVisitor
from .command_text import CommandTextVisitor
from Noyau.N_Exception import AsException
from Noyau.N_info import SUPERV, message
from Noyau.N_MACRO_ETAPE import MACRO_ETAPE
# Modules Eficas
from Noyau.N_utils import prbanner
from .strfunc import convert


class ETAPE:

    """
    Cette classe implémente les méthodes relatives à la phase d'execution.

    Les méthodes principales sont:
       - Exec, realise la phase d'execution, en mode par lot
       - Execute, realise la phase d'execution, en mode commande par commande
    """
    def __init__(self, oper=None, reuse=None, args={}):
        self._stage_number = aster_core.get_option('stage_number')

    def Exec(self):
        """
        Realise une passe d'execution sur l'operateur "fortran" associé
        si le numero d'operateur (self.definition.op) est défini.

        On execute l'operateur numero self.definition.op
        en lui passant les arguments :
          - self : la commande courante
          - lot : le mode d'execution qui peut prendre comme valeur :
                 -  0 = execution par lot (verification globale avant execution)
                 -  1 = execution commande par commande (verification + execution commande par commande)
          - ipass : passe d'execution
                 -  1 = verifications supplémentaires
                 -  2 = execution effective
          - icmd  : numéro d'ordre de la commande
        Retour : iertot = nombre d erreurs
        """
        from Utilitai.Utmess import UTMESS, MessageLog
        if CONTEXT.debug:
            prbanner(" appel de l operateur %s numero %s " %
                     (self.definition.nom, self.definition.op))

        # On n'execute pas les etapes qui n'ont pas de numero d'operateur
        # associé
        if self.definition.op is None:
            return 0

        assert(type(self.definition.op) == int), "type(self.definition.op)=" + \
            repr(type(self.definition.op))

        ier = 0

        # Il ne faut pas executer les commandes non numerotees
        # Pour les affichages et calculs de cpu, on exclut les commandes
        # tout de suite executees (op_init) de type FORMULE. Sinon, ca
        # produit un affichage en double.
        if self.icmd is not None:
            # appel de la methode oper dans le module codex
            if self.definition.op_init is None:
                self.AfficheTexteCommande()
                if self.sd and self.jdc.sdveri:
                    l_before = checksd.get_list_objects()

            self.jdc.timer.Stop(' . part Superviseur')
            self.jdc.timer.Start(' . part Fortran', num=1.2e6)
            astype = type(self.sd).__name__.upper()
            if self.sd:
                self.codex.register_type(self.sd.nom, astype)
            self.codex.oper(self, self.jdc.jxveri)
            self.jdc.timer.Stop(' . part Fortran')
            self.jdc.timer.Start(' . part Superviseur')
            for co in self.get_created_sd():
                co.executed = 1

            if self.definition.op_init is None:
                # vérification de la SD produite
                if self.sd and self.jdc.sdveri:
                    # on force la vérif si :
                        # concept réentrant
                        # sd.nom absent du contexte (detruit ? car les nouveaux sont forcément vérifiés)
                        # pb avec macro reentrante et commande non reentrante :
                        # cf. ssnv164b ou ssll14a
                    force = (self.reuse is not None) \
                        or (self.parent.get_contexte_avant(self).get(self.sd.nom) is None) \
                        or (self.parent != self.jdc)
                    self.jdc.sd_checker.force(force)
                    self.jdc.timer.Start('   . sdveri', num=1.15e6)
                    self.jdc.sd_checker = checksd.check(
                        self.jdc.sd_checker, self.sd, l_before, self)
                    self.jdc.timer.Stop('   . sdveri')
                # pour arreter en cas d'erreur <E>
                MessageLog.reset_command()
                # affichage du texte de la commande
                self.AfficheFinCommande()
        else:
            self.AfficheTexteCommande()

        if CONTEXT.debug:
            prbanner(
                " fin d execution de l operateur %s numero %s " % (self.definition.nom,
                                                                   self.definition.op))
        return ier

    def AfficheTexteCommande(self, sortie=sys.stdout):
        """
        Methode : ETAPE.AfficheTexteCommande
        Intention : afficher sur la sortie standard (par defaut) le cartouche de
                        la commande avant son execution.
        """
        from Utilitai.Utmess import UTMESS
        voir = not isinstance(self.parent, MACRO_ETAPE) or \
            self.jdc.impr_macro == 1 or self.parent.show_children
        # top départ du chrono de la commande
        etiq = self.nom
        # id unique pour l'étape. L'attribut n'est pas déclaré dans
        # l'__init__...
        count = (self.icmd or 0)
        self.id_timer = str(time.time() + count)
        if isinstance(self.parent, MACRO_ETAPE):
            etiq = ' . ' + etiq
        if voir:
            self.jdc.timer.Start(self.id_timer, name=etiq)

        # impression du fichier .code : compte rendu des commandes et
        # mots clés activés par l'ETAPE
        if self.jdc.fico is not None:
            fcode = CodeVisitor(self.jdc.fico)
            self.accept(fcode)
            aster.affiche('CODE', fcode.get_text())

        if voir:
            # Affichage numero de la commande (4 digits)
            if self.sd is not None:
                type_concept = self.sd.__class__.__name__
            else:
                type_concept = '-'

            UTMESS('I', 'VIDE_1')
            UTMESS('I', 'SUPERVIS2_69',
                   valk="_stg{0}_{1}".format(self._stage_number,
                                             self._identifier))

            UTMESS('I', 'SUPERVIS2_70')
            if self.icmd is not None:
                UTMESS('I', 'SUPERVIS2_71', vali=self.icmd, valk=type_concept)
                UTMESS('I', 'SUPERVIS2_70')
            else:
                # commande non comptabilisée (INCLUDE)
                UTMESS('I', 'SUPERVIS2_72', valk=type_concept)

            # recuperation du texte de la commande courante
            if self.jdc.ctree:
                self.accept(self.jdc.ctree)
            cmdtext = CommandTextVisitor()
            self.accept(cmdtext)
            aster.affiche('MESSAGE', convert(cmdtext.get_text()))

        return

    def AfficheFinCommande(self, avec_temps=True, sortie=sys.stdout):
        """
        Methode : ETAPE.AfficheFinCommande
        Intention : afficher sur la sortie standard (par defaut) la fin du
                    cartouche de la commande apres son execution.
        """
        from Utilitai.Utmess import UTMESS
        voir = not isinstance(self.parent, MACRO_ETAPE) or \
            self.jdc.impr_macro == 1 or self.parent.show_children
        if not voir:
            return
        # stop pour la commande
        cpu_user, cpu_syst, elapsed = self.jdc.timer.StopAndGet(
            self.id_timer, hide=not voir)
        if avec_temps and self.icmd is not None:
            rval, iret = aster_core.get_mem_stat(
                'VMPEAK', 'VMSIZE', 'CMAX_JV', 'CMXU_JV')
            if iret == 0:
                if rval[0] > 0.:
                    UTMESS('I', 'SUPERVIS2_73', valr=rval)
                else:
                    UTMESS('I', 'SUPERVIS2_74', valr=rval)
            UTMESS('I', 'SUPERVIS2_75', vali=self.icmd,
                   valr=(cpu_syst + cpu_user, cpu_syst, elapsed))
        else:
            UTMESS('I', 'SUPERVIS2_76', valk=self.nom)
        UTMESS('I', 'SUPERVIS2_70')

        if cpu_user > 60. and cpu_syst > 0.5 * cpu_user:
            UTMESS('A', 'SUPERVIS_95', valr=(cpu_syst, cpu_user), vali=50)
        return

    def Execute(self):
        """
        Cette methode realise l execution complete d une etape, en mode commande par commande :
               - construction,
               - verification,
               - execution
        en une seule passe. Utilise en mode PAR_LOT='NON'

        L'attribut d'instance executed indique que l'etape a deja ete executee
        Cette methode peut etre appelee plusieurs fois mais l'execution proprement
        dite ne doit etre realisee qu'une seule fois.
        Le seul cas ou on appelle plusieurs fois Execute est pour la
        commande INCLUDE (appel dans op_init)
        """
        # message.debug(SUPERV, "%s par_lot=%s", self.nom, self.jdc and
        # self.jdc.par_lot)
        if not self.jdc or self.jdc.par_lot != "NON":
            return

        if hasattr(self, "executed") and self.executed == 1:
            return
        self.executed = 1

        cr = self.report()
        if not cr.estvide():
            self.parent.cr.add(cr)
            raise EOFError

        if self.jdc.syntax_check():
            return
        self.Build()
        try:
            self.Exec()
            self.parent.clean(1)
        except self.codex.error:
            self.detruit_sdprod()
            raise

    def detruit_sdprod(self):
        """ Cette méthode supprime le concept produit par la commande
            du registre tenu par le JDC
        """
        if self.sd is not None:
            self.jdc.del_concept(self.sd.nom)

    def BuildExec(self):
        """
        Cette methode realise l execution complete d une etape, en mode commande par commande :
               - construction,
               - execution
        en une seule passe. Utilise en mode PAR_LOT='OUI'

        L'attribut d'instance executed indique que l'etape a deja ete executee
        Cette methode peut etre appelee plusieurs fois mais l'execution proprement
        dite ne doit etre realisee qu'une seule fois.
        Le seuls cas ou on appelle plusieurs fois Execute est pour la
        commande INCLUDE (appel dans op_init)
        """
        # message.debug(SUPERV, "BuildExec %s", self.nom)
        if hasattr(self, "executed") and self.executed == 1:
            return
        self.executed = 1

        # Construction des sous-commandes
        self.Build()
        self.Exec()

    def get_liste_etapes(self, liste):
        liste.append(self.etape)
