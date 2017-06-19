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
import official_programs


def configure(self):
    opts = self.options

    intel.configure(self)
    official_programs.configure(self)
    opts.with_prog_salome = True
    opts.with_prog_europlexus = True

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
