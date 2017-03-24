# coding: utf-8

"""
Configuration for athosdev + Intel MPI

. $HOME/dev/codeaster/devtools/etc/env_unstable_mpi.sh

waf_mpi configure --use-config=athosdev_mpi --prefix=../install/mpi
waf_mpi install -p
"""

import eole
ASTER_ROOT = eole.ASTER_ROOT
YAMMROOT = eole.YAMMROOT 

def configure(self):
    opts = self.options

    # parallel must be set before calling intel.configure() to use MPI wrappers
    opts.parallel = True
    eole.configure(self)
    self.env['ADDMEM'] = 400

    self.env.append_value('OPT_ENV', [
        'module load impi/2016.3.068'])

    self.env.prepend_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Mumps4-4100_aster3/MPI/lib',
        YAMMROOT + '/prerequisites/Petsc_mpi-344_aster/lib'])
    self.env.prepend_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Petsc_mpi-344_aster/include'])

    opts.enable_petsc = True

    # allow to compile the elements catalog using the executable on one processor
    self.env['CATALO_CMD'] = 'I_MPI_FABRICS=shm'
    # produce an executable file with symbols for INTEL16 with mpiifort wrapper
    self.env.append_value('LINKFLAGS', ('-nostrip')) 
