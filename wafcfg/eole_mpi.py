# coding: utf-8

"""
Configuration for eole + Intel MPI

. $HOME/dev/codeaster/devtools/etc/env_stable-updates_mpi.sh

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
    self.env['ADDMEM'] = 800

    self.env.append_value('OPT_ENV', [
               '. /etc/profile.d/lmod.sh','module load impi/2013.1.046'])
# produce an executable file with symbols for INTEL16 with mpiifort wrapper
    self.env.prepend_value('LINKFLAGS', [
        '-nostrip',
        '-L/opt/intel/2013.1.046/impi/4.1.3.048/lib64'])

    self.env.prepend_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Mumps4-4100_aster3/MPI/lib',
        YAMMROOT + '/prerequisites/Petsc_mpi-344_aster/lib'])
    self.env.prepend_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Petsc_mpi-344_aster/include'])

#   for using ifort/2013.0.046 icc/2013.0.046 with Mfront2.0.2, otherwise compilation aborts
    self.env.prepend_value('INCLUDES', ['/usr/include/c++/4.8','/usr/lib/gcc/x86_64-linux-gnu/4.8/include','/usr/include/x86_64-linux-gnu/c++/4.8', ])

    opts.enable_petsc = True

    # allow to compile the elements catalog using the executable on one processor
    self.env['CATALO_CMD'] = 'I_MPI_FABRICS=shm'
