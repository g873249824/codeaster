# coding: utf-8

"""
Configuration for aster5

. $HOME/dev/codeaster/devtools/etc/env_stable-updates.sh

waf configure --use-config=aster5 --prefix=../install/std
waf install -p
"""

import os
ASTER_ROOT = os.environ['ASTER_ROOT']
YAMMROOT = ASTER_ROOT + '/public/v12'

import intel

def configure(self):
    opts = self.options

    intel.configure(self)

    # enable TEST_STRICT on the reference server
    self.env.append_value('DEFINES', ['TEST_STRICT'])

    self.env['ADDMEM'] = 600
    self.env.append_value('OPT_ENV', [
        '. /etc/profile.d/lmod.sh',
        'module load ifort/2013.1.046 icc/2013.1.046 mkl/2013.1.046'])

    self.env.append_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Hdf5-1814/lib',
        YAMMROOT + '/tools/Medfichier-321/lib',
        YAMMROOT + '/prerequisites/Metis-40/lib',
        YAMMROOT + '/prerequisites/Mfront_stable-TFEL202/lib',
        YAMMROOT + '/prerequisites/Mumps4-4100_aster3/SEQ/lib',
        YAMMROOT + '/prerequisites/Scotch-5111/lib'])

    self.env.append_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Hdf5-1814/include',
        YAMMROOT + '/tools/Medfichier-321/include',
        YAMMROOT + '/prerequisites/Metis-40/Lib',
        YAMMROOT + '/prerequisites/Mfront_stable-TFEL202/include',
        YAMMROOT + '/prerequisites/Scotch-5111/include'])
#
#   for using ifort/2013.0.046 icc/2013.0.046 with Mfront2.0.2, otherwise compilation aborts
    self.env.prepend_value('INCLUDES', ['/usr/include/c++/4.8','/usr/lib/gcc/x86_64-linux-gnu/4.8/include','/usr/include/x86_64-linux-gnu/c++/4.8', ])

    self.env.append_value('LIB', ('pthread', 'util'))

    # to fail if not found
    opts.enable_hdf5 = True
    opts.enable_med = True
    opts.enable_metis = True
    opts.enable_mumps = True
    opts.enable_scotch = True
    opts.enable_mfront = True

    opts.enable_petsc = False
