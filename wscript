# coding=utf-8

"""
Build script for Code_Aster


Note:
- All defines conditionning the compilation must be set using `conf.define()`.
  They will be exported into `asterc_config.h`/`asterf_config.h`.

- If some of them are also required during the build step, another variable
  must be passed using `env` (ex. BUILD_MED)
"""

top = '.'
out = 'build'

import os
import os.path as osp
import zlib
import base64
from functools import partial
from itertools import chain
from waflib import Configure, Logs, Utils, Build


def options(self):
    ori_get_usage = self.parser.get_usage
    def _usage():
        return ori_get_usage() + os.linesep.join((
        '',
        'Environment variables:',
        '  CC             : C compiler',
        '  FC             : Fortran compiler',
        '  CXX            : C++ compiler',
        '  INCLUDES       : extra include paths',
        '  DEFINES        : extra preprocessor defines',
        '  LINKFLAGS      : extra linker options',
        '  LIBPATH        : extra paths where to find libraries',
        '  LIB            : extra libraries to link with',
        '  STLIB          : extra static libraries to link with',
        '  OPTLIB_FLAGS   : extra linker flags appended at the end of link commands '
        '(for example when -Wl,start-group options are necessary). '
        'OPTLIB_FLAGS will be added for all links. Usually, you should prefer '
        'to define more specific variable as OPTLIB_FLAGS_MATH (or OPTLIB_FLAGS_HDF5...)',
        '  CFLAGS         : extra C compilation options',
        '  FCFLAGS        : extra Fortran compilation options',
        '  PREFIX         : default installation prefix to be used, '
        'if no --prefix option is given.',
        '  BLAS_INT_SIZE  : kind of integers to use in the fortran blas/lapack '
        'calls (4 or 8, default is 4)',
        '  MUMPS_INT_SIZE : kind of integers to use in the fortran mumps calls '
        ' (4 or 8, default is 4)',
        '  CATALO_CMD     : command line used to build the elements catalog. '
        'It is just inserted before the executable '
        '(may define additional environment variables or a wrapper that takes '
        'all arguments, see catalo/wscript)',
        '',))
    self.parser.get_usage = _usage

    self.load('use_config')
    self.load('gnu_dirs')

    # change default value for '--prefix'
    default_prefix = '../install/std'
    # see waflib/Tools/gnu_dirs.py for the group name
    group = self.get_option_group('Installation prefix')
    descr = group.get_description() or ""
    # replace path in description
    new_descr = descr.replace('/usr/local', default_prefix)
    new_descr += ". Using 'waf_variant', 'std' will be automatically replaced "\
                 "by 'variant'."
    group.set_description(new_descr)
    # reset --prefix option
    option = group.get_option('--prefix')
    if option:
        group.remove_option('--prefix')
    group.add_option('--prefix', dest='prefix', default=None,
                     help='installation prefix [default: %r]' % default_prefix)

    group = self.add_option_group('Code_Aster options')

    self.load('parallel', tooldir='waftools')
    self.load('python_cfg', tooldir='waftools')
    self.load('mathematics', tooldir='waftools')
    self.load('med', tooldir='waftools')
    self.load('metis', tooldir='waftools')
    self.load('mumps', tooldir='waftools')
    self.load('scotch', tooldir='waftools')
    self.load('petsc', tooldir='waftools')
    self.load('runtest', tooldir='waftools')

    group.add_option('-E', '--embed-all', dest='embed_all',
                    action='store_true', default=False,
                    help='activate all embed-* options (except embed-python)')
    group.add_option('--install-tests', dest='install_tests',
                    action='store_true', default=False,
                    help='install the testcases files')
    group.add_option('--install-as', dest='astervers',
                    action='store', default='',
                    help='install as this version name, used for '
        'subdirectories (example: X.Y will use aster/X.Y/...), '
        "[Default: '']")
    self.recurse('bibfor')
    self.recurse('bibcxx')
    self.recurse('bibc')
    self.recurse('mfront')
    self.recurse('i18n')
    self.recurse('data')

def configure(self):
    self.setenv('default')

    # compute default prefix
    if not self.env.PREFIX:
        suffix = osp.basename(self.options.out)
        if not suffix:
            suffix = 'std'
        default_prefix = '../install/%s' % suffix
        self.env.PREFIX = osp.abspath(default_prefix)
    self.msg('Setting prefix to', self.env.PREFIX)

    self.load('ext_aster', tooldir='waftools')
    if not self.options.use_config and os.environ.get('DEVTOOLS_COMPUTER_ID'):
        suffix= osp.basename(self.options.out)
        if suffix:
            suffix = '_' + suffix
        self.options.use_config = os.environ['DEVTOOLS_COMPUTER_ID'] + suffix
    self.load('use_config')
    self.load('gnu_dirs')
    self.env['BIBPYTPATH'] = self.path.find_dir('bibpyt').abspath()

    self.env.ASTER_EMBEDS = []

    # add environment variables into `self.env`
    self.add_os_flags('CFLAGS')
    self.add_os_flags('CXXFLAGS')
    self.add_os_flags('FCFLAGS')
    self.add_os_flags('LINKFLAGS')
    self.add_os_flags('LIB')
    self.add_os_flags('LIBPATH')
    self.add_os_flags('STLIB')
    self.add_os_flags('STLIBPATH')
    self.add_os_flags('INCLUDES')
    self.add_os_flags('DEFINES')
    self.add_os_flags('OPTLIB_FLAGS')

    # Add *LIBPATH paths to LD_LIBRARY_PATH
    libpaths = list(chain(*[Utils.to_list(self.env[key]) for key in self.env.table
                            if 'libpath' in key.lower()]))
    ldpaths = [p for p in os.environ.get('LD_LIBRARY_PATH', '').split(os.pathsep)]
    paths =  libpaths + ldpaths
    os.environ['LD_LIBRARY_PATH'] = os.pathsep.join(p for p in paths if p)

    self.set_installdirs()
    self.load('parallel', tooldir='waftools')
    self.load('python_cfg', tooldir='waftools')
    self.check_platform()

    self.load('mathematics', tooldir='waftools')

    self.env.append_value('FCFLAGS', ['-fPIC'])
    self.env.append_value('CFLAGS', ['-fPIC'])
    self.env.append_value('CXXFLAGS', ['-fPIC'])

    self.load('med', tooldir='waftools')
    self.load('metis', tooldir='waftools')
    self.load('mumps', tooldir='waftools')
    self.load('scotch', tooldir='waftools')
    self.load('petsc', tooldir='waftools')
    self.load('runtest', tooldir='waftools')

    paths = self.srcnode.ant_glob('bibc/include', src=True, dir=True)
    paths = [d.abspath() for d in paths]
    self.env.append_value('INCLUDES', paths)
    paths = self.srcnode.ant_glob('bibcxx/include', src=True, dir=True)
    paths = [d.abspath() for d in paths]
    self.env.append_value('INCLUDES', paths)

    self.recurse('bibfor')
    self.recurse('bibcxx')
    self.recurse('bibc')
    self.recurse('bibpyt')
    self.recurse('code_aster')
    self.recurse('mfront')
    self.recurse('i18n')
    self.recurse('data')
    # keep compatibility for as_run
    if self.get_define('HAVE_MPI'):
        self.env.ASRUN_MPI_VERSION = 1
    # variants
    self.check_optimization_options()
    # only install tests during release install
    self.setenv('release')
    self.env.install_tests = self.options.install_tests
    self.write_config_headers()

def build(self):
    self.env.install_tests = self.options.install_tests or self.env.install_tests
    # shared the list of dependencies between bibc/bibfor
    # the order may be important
    self.env['all_dependencies'] = [
        'MED', 'HDF5','PETSC','MUMPS', 'METIS', 'SCOTCH', 'MFRONT',
        'MATH', 'MPI', 'OPENMP', 'CLIB', 'SYS']
    get_srcs = self.path.get_src().ant_glob
    if not self.variant:
        self.fatal('Call "waf build_debug" or "waf build_release", and read ' \
                   'the comments in the wscript file!')
    if self.cmd.startswith('install'):
        # because we can't know which files are obsolete `rm *.py{,c,o}`
        instdir = self.root.find_node(self.env.ASTERLIBDIR)
        if instdir and instdir.abspath().startswith(osp.abspath(self.env['PREFIX'])):
            files = instdir.ant_glob('**/*.py')
            files.extend(instdir.ant_glob('**/*.pyc'))
            files.extend(instdir.ant_glob('**/*.pyo'))
            for i in [i.abspath() for i in files]:
                os.remove(i)

    self.load('ext_aster', tooldir='waftools')
    self.recurse('bibfor')
    self.recurse('bibcxx')
    self.recurse('bibc')
    self.recurse('bibpyt')
    self.recurse('code_aster')
    self.recurse('mfront')
    self.recurse('i18n')
    lsub = ['materiau', 'datg', 'catalo']
    if self.env.install_tests:
        lsub.extend(['astest', '../validation/astest'])
    for optional in lsub:
        if osp.exists(osp.join(optional, 'wscript')):
            self.recurse(optional)
    self.recurse('data')

def build_elements(self):
    self.recurse('catalo')

def init(self):
    from waflib.Build import BuildContext, CleanContext, InstallContext, UninstallContext
    _all = (BuildContext, CleanContext, InstallContext, UninstallContext, TestContext, I18NContext)
    for x in ['debug', 'release']:
        for y in _all:
            name = y.__name__.replace('Context','').lower()
            class tmp(y):
                cmd = name + '_' + x
                variant = x
    # default to release
    for y in _all:
       class tmp(y):
           variant = 'release'

def all(self):
    from waflib import Options
    lst = ['install_release', 'install_debug']
    Options.commands = lst + Options.commands

class BuildElementContext(Build.BuildContext):
    """execute the build for elements catalog only using an installed Aster (also performed at install, for internal use only)"""
    cmd = '_buildelem'
    fun = 'build_elements'

def runtest(self):
    self.load('runtest', tooldir='waftools')

class TestContext(Build.BuildContext):
    """facility to execute a testcase"""
    cmd = 'test'
    fun = 'runtest'

def update_i18n(self):
    self.recurse('i18n')

class I18NContext(Build.BuildContext):
    """build the i18n files"""
    cmd = 'i18n'
    fun = 'update_i18n'

@Configure.conf
def set_installdirs(self):
    # set the installation subdirectories
    vers = self.options.astervers
    if vers is None:
        try:
            vers = str(self.env.ASTER_VERSION[0][0]) + '-dev'
        except (TypeError, IndexError):
            vers = 'N-dev'
    self.env.astervers = vers
    norm = lambda path : osp.normpath(osp.join(path, 'aster', vers))
    self.env['ASTERBINOPT'] = 'aster' + vers
    self.env['ASTERBINDBG'] = 'asterd' + vers
    self.env['ASTERLIBDIR'] = norm(self.env.LIBDIR)
    self.env['ASTERINCLUDEDIR'] = norm(self.env.INCLUDEDIR)
    self.env['ASTERDATADIR'] = norm(self.env.DATADIR)
    if not self.env.LOCALEDIR:
        self.env.LOCALEDIR = osp.join(self.env.PREFIX, 'share', 'locale')
    self.env['ASTERLOCALEDIR'] = norm(self.env.LOCALEDIR)

@Configure.conf
def uncompress64(self, compressed):
    return zlib.decompress(base64.decodestring(compressed))

@Configure.conf
def check_platform(self):
    self.start_msg('Getting platform')
    # convert to Code_Aster terminology
    os_name = self.env.DEST_OS
    if os_name == 'cygwin':
        os_name = 'linux'
    elif os_name == 'sunos':
        os_name = 'solaris'
    if self.env.DEST_CPU.endswith('64'):
        os_name += '64'
        self.define('_USE_64_BITS', 1)
    os_name = os_name.upper()
    if not os_name.startswith('win'):
        self.define('_POSIX', 1)
        self.undefine('_WINDOWS')
        self.define(os_name, 1)
    else:
        self.define('_WINDOWS', 1)
        self.undefine('_POSIX')
    self.end_msg(os_name)

@Configure.conf
def check_optimization_options(self):
    # adapt the environment of the build variants
    self.setenv('debug', env=self.all_envs['default'])
    self.setenv('release', env=self.all_envs['default'])
    # these functions must switch between each environment
    self.check_optimization_cflags()
    self.check_optimization_cxxflags()
    self.check_optimization_fcflags()
    self.check_optimization_python()
    self.check_variant_vars()

@Configure.conf
def check_variant_vars(self):
    self.setenv('debug')
    self.env['_ASTERBEHAVIOUR'] = 'AsterMFrOfficialDebug'
    self.define('ASTERBEHAVIOUR', self.env['_ASTERBEHAVIOUR'])

    self.setenv('release')
    self.env['_ASTERBEHAVIOUR'] = 'AsterMFrOfficial'
    self.define('ASTERBEHAVIOUR', self.env['_ASTERBEHAVIOUR'])

# same idea than waflib.Tools.c_config.write_config_header
# but defines are not removed from `env`
# XXX see write_config_header(remove=True/False) + format Fortran ?
from waflib.Tools.c_config import DEFKEYS
CMT = { 'C' : '/* %s */', 'Fortran' : '! %s' }

@Configure.conf
def write_config_headers(self):
    # Write both xxxx_config.h files for C and Fortran,
    # then remove entries from DEFINES
    for variant in ('debug', 'release'):
        self.setenv(variant)
        self.write_config_h('Fortran', variant)
        self.write_config_h('C', variant)
        for key in self.env[DEFKEYS]:
            self.undefine(key)
        self.env[DEFKEYS] = []

@Configure.conf
def write_config_h(self, language, variant, configfile=None, env=None):
    # Write a configuration header containing defines
    # ASTERC defines will be used if language='C', not 'Fortran'.
    self.start_msg('Write config file')
    assert language in ('C', 'Fortran')
    cmt = CMT[language]
    configfile = configfile or 'aster%s_config.h' % language[0].lower()
    env = env or self.env
    guard = Utils.quote_define_name(configfile)
    lst = [
        cmt % "WARNING! Automatically generated by `waf configure`!",
        "", "",
        "#ifndef %s" % guard, "#define %s" % guard, "",
        self.get_config_h(language),
        "", "#endif", "",
    ]
    node = self.bldnode or self.path.get_bld()
    node = node.make_node(osp.join(variant, configfile))
    node.parent.mkdir()
    node.write('\n'.join(lst))
    self.env.append_unique('INCLUDES', node.parent.abspath())
    # config files are not removed on "waf clean"
    env.append_unique(Build.CFG_FILES, [node.abspath()])
    self.end_msg(node.bldpath())

@Configure.conf
def get_config_h(self, language):
    # Create the contents of a ``config.h`` file from the defines
    # set in conf.env.define_key / conf.env.include_key. No include guards are added.
    cmt = CMT[language]
    lst = []
    for x in self.env[DEFKEYS]:
        if language != 'C' and x.startswith('ASTERC'):
            continue
        if self.is_defined(x):
            val = self.get_define(x)
            lst.append('#define %s %s' % (x, val))
        else:
            lst.append(cmt % '#undef %s' % x)
    return "\n".join(lst)
