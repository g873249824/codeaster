# coding: utf-8

"""
Configuration for Calibre 7 + Intel MPI

. $HOME/dev/codeaster/devtools/etc/env_unstable_mpi.sh

waf configure --use-config=calibre7_mpi --prefix=../install/mpi
waf install -p
"""

import calibre7
YAMMROOT = calibre7.YAMMROOT

def configure(self):
    from Options import options as opts
    
    calibre7.configure(self)
    self.env['ADDMEM'] = 400
    self.env['OPTLIB_FLAGS'] = [
        '-Wl,-Bstatic', '-Wl,--start-group',
        '-lmkl_intel_lp64', '-lmkl_sequential', '-lmkl_core',
        '-lmkl_scalapack_lp64', '-lmkl_blacs_intelmpi_lp64',
        '-Wl,--end-group']

    self.env.append_unique('LINKFLAGS', ['-static-intel', '-static_mpi'])

    self.env.append_value('OPT_ENV', [
        '. /home/aster/etc/codeaster/profile_impi.sh'])

    self.env['FC'] = 'mpiifort'
    self.env['CC'] = 'mpiicc'
    self.env['CXX'] = 'mpiicpc'

    self.env.prepend_value('LIBPATH', [
        YAMMROOT + 'prerequisites/Mumps_mpi_for_aster/lib',
        YAMMROOT + 'prerequisites/Petsc_mpi_petsc_aster/lib'])
    self.env.prepend_value('INCLUDES', [
        YAMMROOT + 'prerequisites/Petsc_mpi_petsc_aster/include'])

    opts.parallel = True
    
    opts.enable_petsc = True
    opts.embed_petsc = True
    opts.petsc_libs='petsc ml HYPRE'
