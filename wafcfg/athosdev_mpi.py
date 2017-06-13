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
Configuration for athosdev + Intel MPI

. $HOME/dev/codeaster/devtools/etc/env_stable-updates_mpi.sh

waf_mpi configure --use-config=athosdev_mpi --prefix=../install/mpi
waf_mpi install -p
"""

import athosdev
ASTER_ROOT = athosdev.ASTER_ROOT
YAMMROOT = athosdev.YAMMROOT

def configure(self):
    opts = self.options

    # parallel must be set before calling intel.configure() to use MPI wrappers
    opts.parallel = True
    athosdev.configure(self)
    self.env['ADDMEM'] = 800

    self.env.append_value('OPT_ENV_FOOTER', [
        '. /etc/profile.d/lmod.sh',
        'module load impi/2013.1.046'])
    self.env.prepend_value('LINKFLAGS', [
        '-nostrip',
        '-L/opt/intel/2013.1.046/impi/4.1.3.048/lib64'])

    self.env.prepend_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Mumps4-4100_aster3/MPI/lib',
        YAMMROOT + '/prerequisites/Petsc_mpi-344_aster/lib'])
    self.env.prepend_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Petsc_mpi-344_aster/include'])

    opts.enable_petsc = True

    # allow to compile the elements catalog using the executable on one processor
    self.env['CATALO_CMD'] = 'I_MPI_FABRICS=shm'
