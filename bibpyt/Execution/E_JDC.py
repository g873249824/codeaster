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
# Modules Python
import os
import os.path as osp
import types
import pickle
import traceback
PICKLE_PROTOCOL = 0

# Modules Eficas
from Noyau.N_Exception import AsException
from Noyau.N_ASSD import ASSD
from Noyau.N_ENTITE import ENTITE
from Noyau.N_JDC import MemoryErrorMsg
from Noyau.N_info import message, SUPERV
from Noyau import basetype

from .strfunc import convert, ufmt
from .concept_dependency import ConceptDependenciesVisitor

import aster


class JDC:

    """
    """
    # attributs accessibles depuis le fortran par les méthodes génériques
    # get_jdc_attr et set_jdc_attr
    l_jdc_attr = ('jxveri', 'sdveri', 'impr_macro',
                  'jeveux', 'jeveux_sysaddr', 'icode')

    # attributs du jdc "picklés" (ceux qui contiennent des infos de l'exécution).
    # nsd/tmpsd : compteurs de concepts (totaux/temporaires dans les macros)
    l_pick_attr = ('catalc', 'nsd', 'tmpsd', 'jeveux_sysaddr')

    def __init__(self):
        self.info_level = 1
        self.timer_fin = None
        self.ctree = None
        for attr in self.l_jdc_attr:
            setattr(self, attr, 0)
        # à part car pas de type entier
        self._sign = None
        self._syntax_check = None
        self._poursuite = False

    def Exec(self):
        """
            Execution en fonction du mode d execution
        """
        # initexec est defini dans le package Build et cette fonction (Exec)
        # ne peut etre utilisee que si le module E_JDC est assemble avec le
        # Build.
        self.initexec()
        for e in self.etapes:
            if CONTEXT.debug:
                print(e, e.nom, e.isactif())
            try:
                if e.isactif():
                    # message.debug(SUPERV, "call etape.Exec : %s %s", e.nom,
                    # e)
                    e.Exec()
            except EOFError:
                # L'exception EOFError a ete levee par l'operateur FIN
                raise

    def BuildExec(self):
        """
           Cette methode realise les passes de Build et d'Execution en mode par_lot="OUI"
           Elle est utilisee par le superviseur (voir ParLotMixte)
        """
        # initexec est defini dans le package Build et cette fonction (Exec)
        # ne peut etre utilisee que si le module E_JDC est assemble avec le
        # package Build
        self.initexec()

        # Pour etre sur de ne pas se planter sur l appel a set_context on le
        # met d abord a blanc
        CONTEXT.unset_current_step()
        CONTEXT.set_current_step(self)

        # On reinitialise le compte-rendu self.cr
        self.cr = self.CR(debut=_("CR d'execution de JDC en MIXTE"),
                          fin=_("fin CR d'execution de JDC en MIXTE"))

        self.timer.Start(" . build")
        ret = self._Build()
        self.timer.Stop(" . build")
        if ret != 0:
            CONTEXT.unset_current_step()
            return ret

        self.g_context = {}
        ier = 0
        try:
            for e in self.etapes:
                if CONTEXT.debug:
                    print(e, e.nom, e.isactif())
                if e.isactif():
                    e.BuildExec()

        except self.codex.error as exc_val:
            self.traiter_user_exception(exc_val)
            self.affiche_fin_exec()
            e = self.get_derniere_etape()
            self.traiter_fin_exec("par_lot", e)

        except MemoryError as e:
            self.cr.exception(MemoryErrorMsg)

        except EOFError:
            # L'exception EOFError a ete levee par l'operateur FIN
            self.affiche_fin_exec()
            e = self.get_derniere_etape()
            self.traiter_fin_exec("par_lot", e)

        if self.info_level > 1:
            print(self.timer_fin)
        CONTEXT.unset_current_step()
        return ier

    def get_derniere_etape(self):
        """ Cette méthode sert à récupérer la dernière étape exécutée
            Elle sert essentiellement en cas de plantage
        """
        numMax = -1
        etapeMax = None
        for e in self.etapes:
            if numMax < self.index_etapes[e]:
                numMax = self.index_etapes[e]
                etapeMax = e
        return etapeMax

    def affiche_fin_exec(self):
        """ Cette methode affiche les statistiques de temps finales.
        """
        from Utilitai.Utmess import UTMESS
        import aster_core
        #
        # impression des statistiques de temps d'execution des commandes
        #

        # recuperation du temps de la derniere commande :
        # soit c'est FIN si arret normal, soit la commande courante si levee
        # d'exception de type <S>
        # en effet, on est arrive ici par une levee d'exception, et on n'a alors
        # pas affiche l'echo de la commande FIN dans le fichier de message

        l_etapes = self.get_liste_etapes()
        l_etapes.reverse()
        for e in l_etapes:
            if id(e) in self.timer.timers:
                e.AfficheFinCommande()
                break

        # affiche le récapitulatif du timer
        cpu_total_user, cpu_total_syst, elapsed_total = self.timer.StopAndGetTotal(
        )

        tpmax = aster_core.get_option("tpmax")
        if tpmax is not None:
            cpu_restant = tpmax - elapsed_total
        else:
            cpu_restant = 0.

        texte_final = _("""

  <I> Informations sur les temps d'exécution
      Temps cpu user total              %10.2f s
      Temps cpu systeme total           %10.2f s
      Temps elapsed total               %10.2f s
      Temps restant                     %10.2f s
""") % (cpu_total_user, cpu_total_syst, elapsed_total, cpu_restant)

        aster.affiche('MESSAGE', convert(texte_final))

        repglob = aster_core.get_option("repglob")
        base = osp.join(repglob, 'glob.1')
        sign = self.signature(base)
        UTMESS('I', 'SUPERVIS_68', valk=sign, vali=self.jeveux_sysaddr)


        aster.affiche('MESSAGE', convert(repr(self.timer)))
        if self.ctree:
            txt = self.ctree.get_stats(level=2)
            aster.affiche('MESSAGE', convert(txt))
            cnt = self.ctree.write('fort.2')

        aster.fclose(6)
        # fichier d'info
        txt = "%10.2f %10.2f %10.2f %10.2f\n" \
            % (elapsed_total, cpu_total_user, cpu_total_syst, cpu_restant)
        with open('info_cpu', 'w') as f:
            f.write(txt)

    def traiter_fin_exec(self, mode, etape=None):
        """ Cette methode realise un traitement final lorsque la derniere commande
            a été exécutée. L'argument etape indique la derniere etape executee en traitement
            par lot (si mode == 'par_lot').

            Le traitement réalisé est la sauvegarde du contexte courant : concepts produits
            plus autres variables python.
            Cette sauvegarde est réalisée par un pickle du dictionnaire python contenant
            ce contexte.
        """
        if self.info_level > 1:
            from Utilitai.as_timer import ASTER_TIMER
            self.timer_fin = ASTER_TIMER(format='aster')
            self.timer_fin.Start("pickle")

        #
        # sauvegarde du pickle
        #

        if mode == 'commande':
            # En mode commande par commande
            # Le contexte courant est donné par l'attribut g_context
            context = self.g_context
        else:
            # En mode par lot
            # Le contexte courant est obtenu à partir du contexte des constantes
            # et du contexte des concepts

            # On retire du contexte des constantes les concepts produits
            # par les commandes (exécutées et non exécutées)
            context = self.const_context
            for key, value in list(context.items()):
                if isinstance(value, ASSD):
                    del context[key]

            # On ajoute a ce contexte les concepts produits par les commandes
            # qui ont été réellement exécutées (du début jusqu'à etape)
            context.update(self.get_contexte_avant(etape))

        if CONTEXT.debug:
            print('<DBG> (traiter_fin_exec) context.keys(assd) =', end=' ')
            for key, value in list(context.items()):
                if isinstance(value, ASSD):
                    print(key, end=' ')
            print()

        # On élimine du contexte courant les objets qui ne supportent pas
        # le pickle (version 2.2)
        if self.info_level > 1:
            self.timer_fin.Start(" . filter")
        context = self.filter_context(context)
        if self.info_level > 1:
            self.timer_fin.Stop(" . filter")
        # Sauvegarde du pickle dans le fichier pick.1 du repertoire de travail

        with open('pick.1', 'wb') as f:
            pickle.dump(context, f, protocol=PICKLE_PROTOCOL)
        if self.info_level > 1:
            self.timer_fin.Stop("pickle")

    def filter_context(self, context):
        """
           Cette methode construit un dictionnaire a partir du dictionnaire context
           passé en argument en supprimant tous les objets python que l'on ne veut pas
           ou ne peut pas sauvegarder pour une poursuite ultérieure
           + en ajoutant un dictionnaire pour pickler certains attributs du jdc.
           Le dictionnaire résultat est retourné par la méthode.
        """
        d = {}
        for key, value in list(context.items()):
            if key in ('aster', 'aster_core', '__builtins__', 'jdc'):
                continue
            if type(value) in (types.ModuleType, type, types.FunctionType):
                continue
            if issubclass(type(value), basetype.MetaType):
                continue
            if issubclass(type(value), type):
                continue
            if isinstance(value, ENTITE):
                continue
            # Enfin on conserve seulement les objets que l'on peut pickler
            # individuellement.
            try:
                # supprimer le maximum de références arrières (notamment pour les formules)
                # pour accélérer, on supprime le catalogue de SD devenu
                # inutile.
                if isinstance(value, ASSD):
                    value.supprime(force=True)
                    value.supprime_sd()
                pickle.dumps(value, protocol=PICKLE_PROTOCOL)
                d[key] = value
            except:
                # Si on ne peut pas pickler value on ne le met pas dans le
                # contexte filtré
                print("WARNING: can not pickle object: {0} {1}"
                      .format(key, type(value)))
                pass
        self.save_pickled_attrs(d)
        if self.info_level > 1:
            keys = list(d.keys())
            keys.sort()
            for key in keys:
                try:
                    value = str(d[key])
                    if len(value) > 1000:
                        value = value[:1000] + '...'
                    valk = key, value
                except:
                    valk = key, '...'
                # on ne peut plus appeler UTMESS
                print('pickle: %s = %s' % valk)
        return d

    def traiter_user_exception(self, exc_val):
        """ Cette methode traite les exceptions en provenance du module d'execution
            (qui derive de codex.error).
        """
        if isinstance(exc_val, self.codex.error):
            # erreur utilisateur levee et pas trappee, on ferme les bases en
            # appelant la commande FIN
            self.codex.impers()
            self.cr.exception(ufmt(_("<S> Exception utilisateur levee mais pas interceptee.\n"
                                     "Les bases sont fermees.\n"
                                     "Type de l'exception : %s\n%s"),
                                   exc_val.__class__.__name__, exc_val))
            self.fini_jdc(exc_val)

    def abort_jdc(self):
        """ Cette methode termine le JDC par un abort
        """
        print(convert(_(">> JDC.py : DEBUT RAPPORT")))
        print(self.cr)
        print(convert(_(">> JDC.py : FIN RAPPORT")))
        os.abort()

    def fini_jdc(self, exc_val):
        """ Cette methode execute la commande FIN du JDC
            pour terminer proprement le JDC
        """
        fin_etape = None
        for e in self.etapes:
            if e.nom == 'FIN':
                fin_etape = e
                break
        if fin_etape is None:
            # au moins en PAR_LOT='NON', FIN n'est pas dans la liste des étapes
            self.set_par_lot("NON")
            fin_cmd = self.get_cmd("FIN")
            try:
                fin_cmd(STATUT=1)
            except:
                pass
        else:
            # insertion de l'étape FIN du jdc juste après l'étape courante
            self.etapes.insert(self.index_etape_courante + 1, fin_etape)
            fin_etape.valeur.update({'STATUT': 1})
            # si ArretCPUError, on supprime tout ce qui peut coûter
            if isinstance(exc_val, self.codex.ArretCPUError):
                # faire évoluer avec fin.capy
                fin_etape.valeur.update({
                                        'FORMAT_HDF': 'NON',
                                        'RETASSAGE': 'NON',
                                        'INFO_RESU': 'NON',
                                        })
                fin_etape.McBuild()
            try:
                # raise EOFError op9999 > jefini > xfini(19)
                fin_etape.BuildExec()
            except EOFError:
                pass

    def init_ctree(self):
        """Initialise l'arbre de dépendances."""
        self.ctree = ConceptDependenciesVisitor()

    def get_liste_etapes(self):
        liste = []
        for e in self.etapes:
            e.get_liste_etapes(liste)
        return liste

    def get_jdc_attr(self, attr):
        """
           Retourne la valeur d'un des attributs "aster"
        """
        if attr not in self.l_jdc_attr:
            raise aster.error(ufmt(_("Erreur de programmation :\n"
                                     "attribut '%s' non autorisé"), attr))
        return getattr(self, attr)

    def set_jdc_attr(self, attr, value):
        """
           Positionne un des attributs "aster"
        """
        if attr not in self.l_jdc_attr:
            raise aster.error(ufmt(_("Erreur de programmation :\n"
                                     "attribut '%s' non autorisé"), attr))
        if type(value) not in (int, int):
            raise aster.error(ufmt(_("Erreur de programmation :\n"
                                     "valeur non entière : %s"), value))
        setattr(self, attr, value)

    def save_pickled_attrs(self, context):
        """Ajoute le dictionnaire des attributs du jdc à "pickler" dans le contexte.
        """
        d = {}
        for attr in self.l_pick_attr:
            d[attr] = getattr(self, attr)
        d['_sign'] = self._sign
        context['jdc_pickled_attributes'] = d

    def restore_pickled_attrs(self, context):
        """Restaure les attributs du jdc qui ont été "picklés" via le contexte.
        """
        d = context.pop('jdc_pickled_attributes', {})
        for attr, value in list(d.items()):
            # assert attr in self.l_pick_attr
            setattr(self, attr, value)
        self._sign = getattr(self, '_sign') or '?'

    def signature(self, base):
        """Retourne une signature de l'exécution.
        La base ne doit pas être ouverte."""
        from hashlib import sha1
        bufsize = 100000 * 8 * 10    # 10 enregistrements de taille standard
        if base.endswith('bhdf.1'):
            self.jeveux_sysaddr = 0
        self._sign = 'not available'
        try:
            with open(base, 'rb') as fobj:
                fobj.seek(self.jeveux_sysaddr, 0)
                self._sign = sha1(fobj.read(bufsize)).hexdigest()
        except (IOError, OSError):
            traceback.print_exc()
        return self._sign

    def set_syntax_check(self, value):
        """Positionne le booléen qui dit si on est en mode vérification
        de syntaxe"""
        self._syntax_check = value

    def syntax_check(self):
        """Retourne True si on est en mode vérification de syntaxe"""
        return self._syntax_check

    def set_poursuite(self, value):
        """Positionne le booléen qui dit si on est en poursuite ou non"""
        self._poursuite = value

    def is_poursuite(self):
        """Retourne True si on est en poursuite, False sinon"""
        return self._poursuite
