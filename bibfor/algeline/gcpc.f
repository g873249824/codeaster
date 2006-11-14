      SUBROUTINE GCPC(M,IN,IP,AC,INPC,IPPC,ACPC,BF,XP,R,RR,P,IREP,
     &                NITER,EPSI,CRITER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 14/11/2006   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR   
C (AT YOUR OPTION) ANY LATER VERSION.                                 
C
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT 
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF          
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU    
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.                            
C
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE   
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,       
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================

C    -------------------------------------------------------------------
C     RESOLUTION D'UN SYSTEME LINEAIRE SYMETRIQUE PAR UNE METHODE DE
C     GRADIENT CONJUGUE PRECONDITIONNE
C               LA MATRICE EST STOCKEE SOUS FORME COMPACTE (IN,IP,AC)
C    -------------------------------------------------------------------
C    . M             -->   NOMBRE DE COLONNES DE LA MATRICE
C    . IN            -->   POINTEUR DE FIN DE COLONNE DE LA MATRICE
C    . IP            -->   TABLEAU DES NUMEROS DE LIGNE
C    . AC            -->   TABLEAU DES COEFFICIENTS DE LA MATRICE

C    . INPC          -->   IDEM IN POUR MATRICE DE PRECOND.
C    . IPPC          -->   IDEM IP POUR MATRICE DE PRECOND.
C    . ACPC          -->   IDEM AC POUR MATRICE DE PRECOND.
C    . BF            -->   VECTEUR SECOND MEMBRE
C    . R            <--    VECTEUR RESIDU
C    . RR           <--    DIRECTION DE DESCENTE AVANT CONJUGAISON
C    . P            <--    DIRECTION DE DESCENTE APRES CONJUGAISON
C    . XP           <-->   VECTEUR SOLUTION
C    -------------------------------------------------------------------
C    . ITRGCP        -->  IREP =    ( CONDITIONS INITIALES)
C                           0  XP INITIAL MIS A ZERO
C                           1  XP INITIAL DONNEE DE GCPC
C     ----------------- ------------------------------------------------
C     - PRECAUTIONS D'EMPLOI:  XP PEUT ETRE EVENTUELLEMENT CONFONDU
C                              AVEC BF SI MEME ARGUMENT
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       07/03/03 (OB): MODIF. CALCUL DE RAU, TOILETTAGE FORTRAN (IMPLI
C         CIT NONE...), MODIFS. AFFICHAGE, DESACTIVATION PREC.
C     ----------------- ------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      INTEGER M,IN(M),IP(*),INPC(M),IPPC(*),IREP,NITER
      REAL*8 AC(M),ACPC(M),BF(M),XP(M),R(M),RR(M),P(M),EPSI
      CHARACTER*24 CRITER
            
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNOM,JEXNUM,JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

C DECLARATION VARIABLES LOCALES
      REAL*8 ZERO,BNORM,DNRM2,ANORM,EPSIX,ANORMX,RRRI,GAMA,RRRIM1,
     &       PARAAF,ANORXX,RAU,DDOT
      INTEGER IFM,NIV,I,JCRI,JCRR,JCRK,ITER,INIGPC,IRET
           
      CALL MATFPE(-1)
C
C-----RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFNIV(IFM,NIV)
      
C-----PARAMETRE D'AFFICHAGE DE LA DECROISSANCE DU RESIDU
C (SI ON GAGNE PARAAF * 100%)      
      PARAAF = 0.1D0
      
C-----INITS DIVERS      
      ZERO = 0.D0
      IF (IREP.NE.0 .AND. IREP.NE.1) THEN
        CALL UTDEBM('F','GCPC_1',' ')
        CALL UTIMPI('S','INIGPC',1,INIGPC)
        CALL UTFINM()
      ENDIF
      
C-----CALCULS PRELIMINAIRES

C      ---- CALCUL DE NORME DE BF
      BNORM = DNRM2(M,BF,1)
      IF (BNORM.EQ.ZERO) THEN
        DO 10 I = 1,M
          XP(I) = ZERO
   10   CONTINUE
        WRITE (IFM,*)'>>>>>>> SECOND MEMBRE = 0 DONC SOLUTION = 0 '
        GO TO 80
      END IF

      IF (IREP.EQ.0) THEN
C       ---- INITIALISATION X1 = 0    ===>   CALCUL DE R1 = A*X0 - B
        DO 20 I = 1,M
          XP(I) = ZERO
          R(I) = -BF(I)
   20   CONTINUE
        ANORM = BNORM
        EPSIX = EPSI*ANORM
        IF (NIV.EQ.2) WRITE (IFM,1010) ANORM,EPSIX,EPSI
      ELSE
C       ---- INITIALISATION PAR X PRECEDENT: CALCUL DE R1 = A*X1 - B
        CALL GCAX(M,IN,IP,AC,XP,R)
        DO 30 I = 1,M
          R(I) = R(I) - BF(I)
   30   CONTINUE
        ANORM = DNRM2(M,R,1)
        EPSIX = EPSI*ANORM
        IF (NIV.EQ.2) WRITE (IFM,1020) ANORM,EPSIX,EPSI
      END IF

      CALL JEEXIN(CRITER(1:19)//'.CRTI',IRET)
      IF (IRET.EQ.0) THEN
        CALL WKVECT(CRITER(1:19)//'.CRTI','V V I',1,JCRI)
        CALL WKVECT(CRITER(1:19)//'.CRTR','V V R8',1,JCRR)
        CALL WKVECT(CRITER(1:19)//'.CRDE','V V K16',2,JCRK)
        ZK16(JCRK) = 'ITER_GCPC'
        ZK16(JCRK+1) = 'RESI_GCPC'
      END IF
      CALL JEVEUO(CRITER(1:19)//'.CRTI','E',JCRI)
      CALL JEVEUO(CRITER(1:19)//'.CRTR','E',JCRR)

C ---- ITERATIONS
      ANORMX = ANORM
      ANORXX = ANORM
      
      DO 70 ITER = 1,NITER
C       ---- PRECONDITIONNEMENT DU RESIDU:              
C                                             ZK = (LDLT)-1. RK
C                                                   RK <--- R()
C                                                  ZK <--- RR()
C PREC DIAGONAL DESACTIVE, IC(N) PAR DEFAUT
C        IF (PREC.EQ.'DIAG') THEN
C          DO 40 I = 1,M
C            RR(I) = R(I)*ACPC(I)
C   40     CONTINUE
C        ELSE IF (PREC.EQ.'LDLT') THEN
          CALL GCLDM1(M,INPC,IPPC,ACPC,R,RR)
C        END IF

C                                             RRRI <--- (RK,ZK)
        RRRI = DDOT(M,R,1,RR,1)
C       ---- NOUVELLE DIRECTION DE DESCENTE:
C                                    BETAK = (RK,ZK)/(RK-1,ZK-1)
C                                               BETAK <--- GAMA
C                                        PK = BETAK * PK-1 + ZK 
C                                                   PK <--- P()
        IF (ITER.GT.1) THEN
          GAMA = RRRI/RRRIM1
          DO 50 I = 1,M
            P(I) = RR(I) + GAMA*P(I)
   50     CONTINUE
        ELSE
          DO 60 I = 1,M
            P(I) = RR(I)
   60     CONTINUE
        END IF
        RRRIM1 = RRRI

C       ---- NOUVEAUX RESIDU ET DEPLACEMENT:
C                       ZZK = A.PK ET ALPHAK = -(RK,ZK)/(PK,ZZK)
C                                       XK+1 = XK + ALPHAK * PK
C                                      RK+1 = RK + ALPHAK * ZZK
C                                                 ZZK <--- RR()
C                                                 XK  <--- XP()
        CALL GCAX(M,IN,IP,AC,P,RR) 
        RAU = -RRRI/DDOT(M,P,1,RR,1)
        CALL DAXPY(M,RAU,P,1,XP,1)
        CALL DAXPY(M,RAU,RR,1,R,1)

C       ---- CALCUL TEST D'ARRET ET AFFICHAGE
        ANORM = DNRM2(M,R,1)
        IF (ANORM.LE.ANORMX*PARAAF) THEN
          IF (NIV.EQ.2) WRITE (*,1041) ITER,ANORM,ANORM/ANORXX
          ANORMX = ANORM
        END IF
        IF (NIV.EQ.3) WRITE (IFM,1041) ITER,ANORM,ANORM/ANORXX

C       --- TEST DE CONVERGENCE
        IF (ANORM.LT.EPSIX) THEN
          IF (NIV.EQ.2) WRITE (IFM,1040) ANORXX,ANORM,ANORM/ANORXX
          IF (NIV.EQ.2) WRITE (IFM,1050) ITER
          ZI(JCRI) = ITER
          ZR(JCRR) = ANORM
          GO TO 80
        END IF
   70 CONTINUE

C        ---  NON CONVERGENCE
      CALL UTDEBM('F','GCPC','NON CONVERGENCE')
      CALL UTIMPI('L','  NOMBRE D''ITERATIONS: ',1,ITER)
      CALL UTIMPR('L','  NORME DU RESIDU ABS: ',1,ANORM)
      CALL UTIMPR('L','  NORME DU RESIDU REL: ',1,ANORM/ANORXX)
      CALL UTFINM()
C    -----------
 1010 FORMAT (/'   * GCPC   NORME DU RESIDU =',D11.4,
     &       '  (INITIALISATION PAR X = ZERO)',/,
     &'   *        NORME DU RESIDU A ATTEINDRE EN ABS/RELA=',
     &D11.4,D11.4,/)
 1020 FORMAT (/'   * GCPC   NORME DU RESIDU =',D11.4,
     &       '  (INITIALISATION PAR X PRECEDENT)',/,
     & '   *        NORME DU RESIDU A ATTEINDRE EN ABS/RELA=',
     & D11.4,D11.4)
 1040 FORMAT ('   * NORME DU RESIDU INITIAL/FINAL/RELATIF=',
     &         D11.4,D11.4,D11.4)
 1041 FORMAT ('   * ITERATION',I5,' NORME DU RESIDU EN ABS/RELA =',
     &         D11.4,D11.4)     
 1050 FORMAT (1X,/,2X,32 ('*')/'  * CONVERGENCE EN ',I4,
     &       ' ITERATIONS'/2X,32 ('*'),/)
C    -----------
   80 CONTINUE
      CALL MATFPE(1)
C
      END
