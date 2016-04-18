# coding: utf-8

"""
Configuration for Calibre 9

. $HOME/dev/codeaster/devtools/etc/env_unstable_mpi.sh

waf configure --use-config=calibre9_mpi --prefix=../install/mpi
waf install -p
"""

import calibre9
YAMMROOT = calibre9.YAMMROOT 

def configure(self):
    opts = self.options

    # parallel must be set before calling intel.configure() to use MPI wrappers
    opts.parallel = True
    calibre9.configure(self)
    self.env['ADDMEM'] = 400

    self.env.prepend_value('LIBPATH', [
        YAMMROOT + '/prerequisites/Mumps4-4100_aster3/MPI/lib',
        YAMMROOT + '/prerequisites/Petsc_mpi-petsc_aster/lib'])
    self.env.prepend_value('INCLUDES', [
        YAMMROOT + '/prerequisites/Petsc_mpi-petsc_aster/include'])

    opts.enable_petsc = True
