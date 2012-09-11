!
!  This file is part of MUMPS 4.10.0, built on Tue May 10 12:56:32 UTC 2011
!
!
!  This version of MUMPS is provided to you free of charge. It is public
!  domain, based on public domain software developed during the Esprit IV
!  European project PARASOL (1996-1999). Since this first public domain
!  version in 1999, research and developments have been supported by the
!  following institutions: CERFACS, CNRS, ENS Lyon, INPT(ENSEEIHT)-IRIT,
!  INRIA, and University of Bordeaux.
!
!  The MUMPS team at the moment of releasing this version includes
!  Patrick Amestoy, Maurice Bremond, Alfredo Buttari, Abdou Guermouche,
!  Guillaume Joslin, Jean-Yves L'Excellent, Francois-Henry Rouet, Bora
!  Ucar and Clement Weisbecker.
!
!  We are also grateful to Emmanuel Agullo, Caroline Bousquet, Indranil
!  Chowdhury, Philippe Combes, Christophe Daniel, Iain Duff, Vincent Espirat,
!  Aurelia Fevre, Jacko Koster, Stephane Pralet, Chiara Puglisi, Gregoire
!  Richard, Tzvetomila Slavova, Miroslav Tuma and Christophe Voemel who
!  have been contributing to this project.
!
!  Up-to-date copies of the MUMPS package can be obtained
!  from the Web pages:
!  http://mumps.enseeiht.fr/  or  http://graal.ens-lyon.fr/MUMPS
!
!
!   THIS MATERIAL IS PROVIDED AS IS, WITH ABSOLUTELY NO WARRANTY
!   EXPRESSED OR IMPLIED. ANY USE IS AT YOUR OWN RISK.
!
!
!  User documentation of any code that uses this software can
!  include this complete notice. You can acknowledge (using
!  references [1] and [2]) the contribution of this package
!  in any scientific publication dependent upon the use of the
!  package. You shall use reasonable endeavours to notify
!  the authors of the package of this publication.
!
!   [1] P. R. Amestoy, I. S. Duff, J. Koster and  J.-Y. L'Excellent,
!   A fully asynchronous multifrontal solver using distributed dynamic
!   scheduling, SIAM Journal of Matrix Analysis and Applications,
!   Vol 23, No 1, pp 15-41 (2001).
!
!   [2] P. R. Amestoy and A. Guermouche and J.-Y. L'Excellent and
!   S. Pralet, Hybrid scheduling for the parallel solution of linear
!   systems. Parallel Computing Vol 32 (2), pp 136-156 (2006).
!
      TYPE ZMUMPS_ROOT_STRUC
        SEQUENCE
        INTEGER*4 :: MBLOCK, NBLOCK, NPROW, NPCOL
        INTEGER*4 :: MYROW, MYCOL
        INTEGER*4 :: SCHUR_MLOC, SCHUR_NLOC, SCHUR_LLD
        INTEGER*4 :: RHS_NLOC
        INTEGER*4 :: ROOT_SIZE, TOT_ROOT_SIZE
!       descriptor for scalapack
        INTEGER*4, DIMENSION( 9 ) :: DESCRIPTOR
        INTEGER*4 :: CNTXT_BLACS, LPIV, rootpad0
        INTEGER*4, DIMENSION(:), POINTER :: RG2L_ROW
        INTEGER*4, DIMENSION(:), POINTER :: RG2L_COL
        INTEGER*4 , DIMENSION(:), POINTER :: IPIV, rootpad1
!       Centralized master of root
        COMPLEX(kind=8), DIMENSION(:), POINTER :: RHS_CNTR_MASTER_ROOT
!       Used to access Schur easily from root structure
        COMPLEX(kind=8), DIMENSION(:), POINTER :: SCHUR_POINTER
!       for try_null_space preprocessing constant only:
        COMPLEX(kind=8), DIMENSION(:), POINTER :: QR_TAU, rootpad2
!       Fwd in facto: 
!           case of scalapack root: to store RHS in 2D block cyclic
!           format compatible with root distribution
        COMPLEX(kind=8), DIMENSION(:,:), POINTER :: RHS_ROOT, rootpad
!       for try_nullspace preprocessing constant only:
        DOUBLE PRECISION :: QR_RCOND, rootpad3
        LOGICAL*4 yes, gridinit_done
!
      END TYPE ZMUMPS_ROOT_STRUC
