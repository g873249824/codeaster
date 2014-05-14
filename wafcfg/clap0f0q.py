# encoding: utf-8

"""
Configuration for clap0f0q (gfortran + openblas)

. $HOME/dev/codeaster/devtools/etc/env_unstable.sh

waf configure --use-config=clap0f0q --prefix=../install/std
waf install -p
"""

import os
ASTER_ROOT = os.environ['ASTER_ROOT']
YAMMROOT = ASTER_ROOT + '/yamm/V7_3_0_201402'

def configure(self):
    opts = self.options
    self.env['ADDMEM'] = 300
    self.env.append_value('OPT_ENV', [
        '. ' + ASTER_ROOT + '/etc/codeaster/profile.sh',
        '. ' + ASTER_ROOT + '/etc/codeaster/profile_gcc47.sh'])

    self.env.append_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Python_273/lib',
        YAMMROOT + '/prerequisites/Hdf5_1810/lib',
        YAMMROOT + '/tools/Medfichier_307/lib',
        YAMMROOT + '/prerequisites/Mumps_20141/lib',
        YAMMROOT + '/prerequisites/Mumps_20141/libseq',
        YAMMROOT + '/prerequisites/Metis_40/lib',
        YAMMROOT + '/prerequisites/Scotch_5111/lib',
        ASTER_ROOT + '/public/lib',])

    self.env.append_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Python_273/include/python2.7',
        YAMMROOT + '/prerequisites/Hdf5_1810/include',
        YAMMROOT + '/tools/Medfichier_307/include',
        YAMMROOT + '/prerequisites/Metis_40/Lib',
        YAMMROOT + '/prerequisites/Scotch_5111/include'])

    opts.enable_petsc = False
