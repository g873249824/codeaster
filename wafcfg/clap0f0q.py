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
Configuration for clap0f0q (gfortran + openblas)

. $HOME/dev/codeaster/devtools/etc/env_unstable.sh

waf configure --use-config=clap0f0q --prefix=../install/std
waf install -p
"""

import os
ASTER_ROOT = os.environ['ASTER_ROOT']
YAMMROOT = ASTER_ROOT + '/public/default'

import official_programs


def configure(self):
    opts = self.options

    official_programs.configure(self)

    self.env['ADDMEM'] = 300

    TFELHOME = YAMMROOT + '/prerequisites/Mfront-TFEL300'
    self.env.TFELHOME = TFELHOME

    self.env.append_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Python-2710/lib',
        YAMMROOT + '/prerequisites/Hdf5-1814/lib',
        YAMMROOT + '/tools/Medfichier-331/lib',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster1/lib',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster6/SEQ/lib',
        YAMMROOT + '/prerequisites/Mumps-511_consortium_aster/SEQ/lib',
        TFELHOME + '/lib',
        # for openblas
        ASTER_ROOT + '/public/lib',
    ])

    self.env.append_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Python-2710/include/python2.7',
        YAMMROOT + '/prerequisites/Hdf5-1814/include',
        YAMMROOT + '/tools/Medfichier-331/include',
        YAMMROOT + '/prerequisites/Metis_aster-510_aster1/include',
        YAMMROOT + '/prerequisites/Scotch_aster-604_aster6/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-511_consortium_aster/SEQ/include',
        YAMMROOT + '/prerequisites/Mumps-511_consortium_aster/SEQ/include_seq',
        TFELHOME + '/include',
    ])

    # openblas from $ASTER_ROOT/public/lib embeds lapack
    opts.maths_libs = 'openblas'

    # to fail if not found
    opts.enable_hdf5 = True
    opts.enable_med = True
    opts.enable_metis = True
    opts.enable_mumps = True
    opts.enable_scotch = True
    opts.enable_mfront = True

    opts.enable_petsc = False
