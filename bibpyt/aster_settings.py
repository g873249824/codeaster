# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
Conceptuellement, les objets définis ici pourraient l'être dans le module
C/Python 'aster_core' (qui est en C pour l'interface avec le fortran).
Il est plus simple et plus naturel de les écrire en Python.

Ces fonctions sont indépendantes des étapes (sinon elles seraient dans
B_ETAPE/E_ETAPE) et des concepts/ASSD.
"""

import json
import os
import os.path as osp
import platform
import re
import sys
from optparse import SUPPRESS_HELP, OptionParser
from warnings import simplefilter, warn

import aster
import aster_core
import aster_pkginfo
from Execution.i18n import localization
from Execution.strfunc import convert


RCDIR = osp.abspath(osp.join(osp.dirname(__file__), os.pardir, os.pardir,
                    'share', 'aster'))


def check_value(option, opt, value, parser):
    """Callback to check some values."""
    if opt == '--command':
        if not osp.isfile(value):
            parser.error("option '%s' expects an existing file" % opt)
    setattr(parser.values, option.dest, value)


class CoreOptions(object):

    """Classe de stockage des arguments et options de la ligne de commande
    afin de permettre une interrogation ultérieure depuis n'importe quelle
    partie du code.
    On centralise également le stockage d'informations de base comme le nom
    de la machine, la plate-forme, etc.

    """
    doc = """usage: ./%%prog %s [-h|--help] [options]""" % sys.argv[0]

    def __init__(self):
        """Initialisation."""
        self._dbg = False
        self.opts = None
        self.args = None
        self.info = {}
        self.parser = parser = OptionParser(usage=self.doc,
                                            prog=osp.basename(sys.executable))
        parser.add_option(
            '--command', dest='fort1', type='str', metavar='FILE',
            action='callback', callback=check_value,
            help="Code_Aster command file")
        parser.add_option(
            '--stage_number', dest='stage_number', type='int', metavar='NUM',
            action='store', default=1,
            help="Stage number in the Study")
        parser.add_option(
            '--memjeveux', dest='memjeveux', type='float', action='store',
            help="maximum size of the memory taken by the execution "
                 "(in Mw, prefer use --memory option)")
        parser.add_option(
            '--memory', dest='memory', type='float', action='store',
            help="maximum size of the memory taken by the execution (in MB)")
        parser.add_option(
            '--tpmax', dest='tpmax', type='float', action='store',
            help="limit of the time of the execution (in seconds)")
        parser.add_option(
            '--numthreads', dest='numthreads', type='int', action='store', default=1,
            help="maximum number of threads")
        parser.add_option(
            '--max_base', dest='maxbase', type='float', action='store',
            help="limit of the size of the results database")
        parser.add_option(
            '--dbgjeveux', dest='dbgjeveux', action='store_true',
            help="turn on some additional checkings in the memory management")
        parser.add_option(
            '--num_job', dest='jobid', action='store',
            help="job ID of the current execution")
        parser.add_option(
            '--mode', dest='mode', action='store',
            help="execution mode (interactive or batch)")
        parser.add_option(
            '--interact', dest='interact', action='store_true', default=False,
            help="as 'python -i' works, it allows to enter commands after the "
            "execution of the command file.")

        parser.add_option(
            '--rcdir', dest='rcdir', type='str', action='store', metavar='DIR',
            default=RCDIR,
            help="directory containing resources (material properties, "
                 "additional data files...). Defaults to {0}".format(RCDIR))
        # rep_outils/rep_mat/rep_dex options are deprecated, replaced by rcdir
        parser.add_option(
            '--rep_outils', dest='repout', type='str', action='store', metavar='DIR',
            help=SUPPRESS_HELP)
        parser.add_option(
            '--rep_mat', dest='repmat', type='str', action='store', metavar='DIR',
            help=SUPPRESS_HELP)
        parser.add_option(
            '--rep_dex', dest='repdex', type='str', action='store', metavar='DIR',
            help=SUPPRESS_HELP)

        parser.add_option(
            '--rep_glob', dest='repglob', type='str', action='store', metavar='DIR',
            default='.',
            help="directory of the results database")
        parser.add_option(
            '--rep_vola', dest='repvola', type='str', action='store', metavar='DIR',
            default='.',
            help="directory of the temporary database")

        parser.add_option(
            '--suivi_batch', dest='suivi_batch', action='store_true', default=False,
            help="force to flush of the output after each line")
        parser.add_option(
            '--totalview', dest='totalview', action='store_true', default=False,
            help="required to run Code_Aster through the Totalview debugger")
        parser.add_option(
            '--syntax', dest='syntax', action='store_true', default=False,
            help="only check the syntax of the command file is done")
        parser.add_option(
            '--ORBInitRef', dest='ORBInitRef', action='store', default=None,
            help="store the SALOME session to connect")

    def parse_args(self, argv):
        """Analyse les arguments de la ligne de commmande."""
        argv = _bwc_arguments(argv)
        self.opts, self.args = self.parser.parse_args(argv[1:])
        self.default_values()
        self.init_info()
        if self._dbg:
            print('options   :', self.opts)
            print('arguments :', self.args)

    def init_info(self):
        """Stocke les informations générales (machine, os...)."""
        # hostname
        self.info['hostname'] = platform.node()
        # ex. i686/x86_64
        self.info['processor'] = platform.machine()
        # ex. Linux
        self.info['system'] = platform.system()
        # ex. 32bit/64bit
        self.info['architecture'] = platform.architecture()[0]
        # ex. 2.6.32...
        self.info['osrelease'] = platform.release()
        self.info['osname'] = ' '.join(platform.linux_distribution())
        version = aster_pkginfo.version_info.version
        self.info['versionSTA'] = None
        self.info['versLabel'] = None
        keys = ('parentid', 'branch', 'date',
                'from_branch', 'changes', 'uncommitted')
        self.info.update(list(zip(keys, aster_pkginfo.version_info[1:])))
        self.info['version'] = '.'.join(str(i) for i in version)
        self.info['versMAJ'] = version[0]
        self.info['versMIN'] = version[1]
        self.info['versSUB'] = version[2]
        self.info['exploit'] = aster_pkginfo.version_info.branch.startswith('v')
        self.info['versionD0'] = '%d.%02d.%02d' % version
        self.info['versLabel'] = aster_pkginfo.get_version_desc()

    def default_values(self):
        """Définit les valeurs par défaut pour certaines options."""
        locale_dir = aster_pkginfo.locale_dir
        if locale_dir and os.path.exists(locale_dir):
            localization.set_localedir(locale_dir)
        if self.opts.tpmax is None and platform.system() == 'Linux':
            # use rlimit to set to the cpu "ulimit"
            import resource
            limcpu = resource.getrlimit(resource.RLIMIT_CPU)[0]
            if limcpu < 0:
                limcpu = int(1.e18)
            self.opts.tpmax = limcpu
        if not self.opts.memory and self.opts.memjeveux:
            self.opts.memory = self.opts.memjeveux * aster_core.ASTER_INT_SIZE

    def sub_tpmax(self, tsub):
        """Soustrait `tsub` au temps cpu maximum."""
        self.opts.tpmax = self.opts.tpmax - tsub

    def get_option(self, option, default=None):
        """Retourne la valeur d'une option ou d'une information de base."""
        assert self.opts, 'options not initialized!'
        if option.startswith("prog:"):
            value = get_program_path(re.sub('^prog:', '', option))
        elif hasattr(self.opts, option):
            value = getattr(self.opts, option)
        else:
            value = self.info.get(option, default)
        if type(value) in (str, str):
            value = convert(value)
        if self._dbg:
            print(("<CoreOptions.get_option> option={0!r} value={1!r}".format(option, value)))
        return value

    def set_option(self, option, value):
        """Définit la valeur d'une option ou d'une information de base."""
        assert hasattr(self.opts, option) or option in self.info, (
            "unexisting option or information: '{0}'".format(option))
        if hasattr(self.opts, option):
            setattr(self.opts, option, value)
        else:
            self.info[option] = value


def get_program_path(program):
    """Return the path to *program* as stored by 'waf configure'.

    Returns:
        str: Path stored during configuration or *program* itself otherwise.
    """
    if getattr(get_program_path, "_cache", None) is None:
        prog_cfg = {}
        fname = osp.join(os.environ["ASTER_DATADIR"], "external_programs.js")
        if osp.isfile(fname):
            prog_cfg = json.load(open(fname, "r"))
        get_program_path._cache = prog_cfg

    programs = get_program_path._cache
    return programs.get(program, program)


def getargs(argv=None):
    """
    Récupération des arguments passés à la ligne de commande
    """
    coreopts = CoreOptions()
    coreopts.parse_args(argv or sys.argv)
    return coreopts


def _bwc_arguments(argv):
    """Fonction de compatibilité de transition vers des options "GNU".
    """
    # DeprecationWarning are ignored in python2.7 by default
    simplefilter('default')

    inew = max([a.startswith('--command=') for a in argv])
    if inew:
        return argv
    long_opts = (
        'commandes', 'num_job', 'mode',
        'rep_mat', 'rep_dex', 'rep_vola', 'rep_glob',
        'memjeveux', 'tpmax', 'memory', 'max_base', 'ORBInitRef',
    )
    # boolean options
    long_opts_sw = (
        'suivi_batch', 'interact', 'verif', 'totalview', 'dbgjeveux',
    )
    # removed options
    long_opts_rm = ('rep', 'mem', 'mxmemdy', 'memory_stat', 'memjeveux_stat',
                    'type_alloc', 'taille', 'partition', 'rep_outils',
                    'rep_mat', 'rep_dex', 'origine', 'eficas_path')
    # renamed options
    long_opts_mv = {
        'verif': 'syntax',
        'commandes': 'command',
    }
    orig = argv[:]
    new = []
    buffer = ''
    while len(orig) > 0:
        arg = orig.pop(0)
        larg = arg.lstrip('-').split('=', 1)
        opt = larg.pop(0)
        if len(larg) > 0:
            orig.insert(0, larg.pop(0))
        opt2 = long_opts_mv.get(opt, opt)
        if opt in long_opts:
            val = orig.pop(0)
            new.append('--%s=%s' % (opt2, val))
        elif opt in long_opts_sw:
            new.append('--' + opt2)
        elif opt in long_opts_rm:
            val = orig.pop(0)
            warn("this command line option is deprecated : --%s" % opt,
                 DeprecationWarning, stacklevel=3)
        else:
            new.append(arg)
    return new
