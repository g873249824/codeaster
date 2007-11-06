        SUBROUTINE HUJRES (MOD, CRIT, MATER, NVI, EPSD, DEPS, SIGD,
     &             VIND, SIGF, VINF, NITER, EPSCON, IRET, ETATF)
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/11/2007   AUTEUR KHAM M.KHAM 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C   ------------------------------------------------------------------
C   INTEGRATION PLASTIQUE DE LA LOI DE HUJEUX
C   IN  MOD    :  MODELISATION
C       CRIT   :  CRITERES DE CONVERGENCE
C       MATER  :  COEFFICIENTS MATERIAU A T+DT
C       NVI    :  NOMBRE DE VARIABLES INTERNES
C       EPSD   :  DEFORMATIONS A T
C       DEPS   :  INCREMENT DE DEFORMATION
C       SIGD   :  CONTRAINTE  A T
C       VIND   :  VARIABLES INTERNES  A T
C   VAR SIGF   :  CONTRAINTE A T+DT  (IN -> ELAS, OUT -> PLASTI)
C   OUT VINF   :  VARIABLES INTERNES A T+DT
C       NITER  :  NOMBRE D ITERATIONS POUR PLASTICITE
C                 (CUMUL DECOUPAGE)
C       NDEC   :  NOMBRE DE DECOUPAGE
C       EPSCON :  EPSILON A CONVERGENCE
C       IRET   :  CODE RETOUR DE  L'INTEGRATION DE LA LOI DE HUJEUX
C                    IRET=0 => PAS DE PROBLEME
C                    IRET=1 => ECHEC 
C       ETATF  :  ETAT PLASTIQUE OU ELASTIQUE DU POINT DE GAUSS
C   ------------------------------------------------------------------
        INTEGER       NDT, NDI, NVI, NITER, NDEC, IRET
        INTEGER       I, K, IFM, NIV, JJ, NSUBD, MAJ
        INTEGER       NVIMAX, INDMEC
        PARAMETER     (NVIMAX=32)
        REAL*8        EPSD(6), DEPS(6),VINS(NVIMAX)
        REAL*8        SIGD(6), SIGF(6), PREDIC(6)
        REAL*8        SIGD0(6), DEPS0(6), PREDI0(6)
        REAL*8        VIND(*), VINF(*), VIND0(NVIMAX), EPSCON
        REAL*8        MATER(22,2), CRIT(*), CRITR(8)
        REAL*8        SEUIL, RF, RD
        REAL*8        ZERO, VINT(NVIMAX)
        LOGICAL       CHGMEC, NOCONV, AREDEC, STOPNC, NEGMUL(8)
        LOGICAL       SUBD, RDCTPS, LOOP
        CHARACTER*8   MOD
        CHARACTER*7   ETATF
        PARAMETER     (ZERO  = 0.D0)
        INTEGER       IDEC, NITER0
        LOGICAL       DEBUG

        COMMON /TDIM/   NDT, NDI
        COMMON /MESHUJ/ DEBUG

        IF (NVI.GT.NVIMAX) CALL U2MESS('F', 'COMPOR1_1')

        LOOP = .FALSE.


        CALL INFNIV(IFM,NIV)
        
C ----  SAUVEGARDE DES GRANDEURS D ENTREE INITIALES
        CALL LCEQVE(SIGF,PREDI0)
        CALL LCEQVE(SIGD,SIGD0)
        CALL LCEQVE(DEPS,DEPS0)
        CALL LCEQVN(NVI,VIND,VIND0)
        
C  ARRET OU NON EN NON CONVERGENCE INTERNE
C  ---------------------------------------
        IF (INT(CRIT(1)).LT.0) THEN
          STOPNC = .TRUE.
        ELSE
          STOPNC = .FALSE.
        ENDIF


C  INITIALISATION DES VARIABLES DE REDECOUPAGE
C  -------------------------------------------
C  INT( CRIT(5) ) = 0  1 OU -1 ==> PAS DE REDECOUPAGE DU PAS DE TEMPS
        IF ((INT(CRIT(5)) .EQ.  0) .OR.
     &      (INT(CRIT(5)) .EQ. -1) .OR.
     &      (INT(CRIT(5)) .EQ.  1)) THEN
              NDEC   = 1
              AREDEC = .TRUE.
              NOCONV = .FALSE.


C ---- INT( CRIT(5) ) < -1 ==> REDECOUPAGE DU PAS DE TEMPS
C                              SI NON CONVERGENCE
        ELSEIF (INT(CRIT(5)) .LT. -1) THEN
              NDEC   = 1
              AREDEC = .FALSE.
              NOCONV = .FALSE.


C ---- INT( CRIT(5) ) > 1 ==> REDECOUPAGE IMPOSE DU PAS DE TEMPS
        ELSEIF (INT(CRIT(5)) .GT. 1) THEN
              NDEC   = INT(CRIT(5))
              AREDEC = .TRUE.
              NOCONV = .FALSE.
        ENDIF


C  POINT DE RETOUR EN CAS DE DECOUPAGE POUR DR/R > TOLE OU 
C  APRES UNE NON CONVERGENCE, POUR  INT(CRIT(5)) < -1

        SUBD = .FALSE.
        RDCTPS = .FALSE.

  500   CONTINUE
        IF (NOCONV) THEN
           NDEC   = -INT(CRIT(5))
           IRET   = 0
           AREDEC = .TRUE.
           NOCONV = .FALSE.
        ENDIF

Caf 12/06/07 Debut                
        IF (SUBD) THEN
           NDEC = NSUBD
           IRET = 0
           AREDEC = .TRUE.         
        ENDIF
        
        IF (RDCTPS) THEN
           NDEC = -INT(CRIT(5))
           IRET = 0
           AREDEC = .TRUE.         
        ENDIF
Caf 12/06/07 Fin

C   RESTAURATION DE SIGD VIND DEPS ET PREDIC ELAS SIGF
C   EN TENANT COMPTE DU DECOUPAGE EVENTUEL
        CALL LCEQVE (SIGD0, SIGD)
        CALL LCEQVN (NVI, VIND0, VIND)
        
C       DO 2 I = 1, 4
C         IF(RDCTPS(I) .NE. ZERO) THEN
C           VIND(19 + RDCTPS(I)) = UN
C           VIND(23 + RDCTPS(I)) = ZERO
C         ENDIF
C  2    CONTINUE

        DO  10 I = 1, NDT
         DEPS(I) = DEPS0(I)/NDEC
 10      CONTINUE
        CALL HUJELA(MOD,CRIT,MATER,DEPS,SIGD,SIGF,EPSD,IRET)

        IF (DEBUG) THEN

          WRITE(IFM,*)
          WRITE(IFM,'(A)') '========================================='
          WRITE(IFM,*)
          WRITE(IFM,1001) 'NDEC=',NDEC

        ENDIF
C        WRITE(IFM,1001) '""""""" NDEC=',NDEC

C  BOUCLE SUR LES DECOUPAGES
C  -------------------------

        DO 400 IDEC = 1, NDEC
         
          IF (DEBUG) THEN

            WRITE(IFM,*)
            WRITE(IFM,1001) '%% IDEC=',IDEC

          ENDIF
C          WRITE(IFM,1001) '%%%%%%%%%%%%%%% IDEC=',IDEC
Caf 18/05/07 Debut      
        MAJ = 0
        CALL LCEQVE(SIGF,PREDIC)
        
        DO 20 K = 1, 8
          NEGMUL(K)=.FALSE.
 20     CONTINUE
Caf 18/05/07 Fin 

C ---> SAUVEGARDE DES SURFACES DE CHARGE AVANT MODIFICATION
        CALL LCEQVN(NVI,VIND,VINS)
C       WRITE(6,'(A,32(1X,E16.9))')'MPOT1 --- VIND =',(VIND(I),I=1,32)
C ---> DEFINITION DU DOMAINE POTENTIEL DE MECANISMES ACTIFS
        CALL HUJPOT(MOD,MATER,VIND,DEPS,SIGD,SIGF,ETATF,
     &              RDCTPS,IRET,AREDEC) 
         IF(IRET.EQ.1)GOTO 9999
         IF ((RDCTPS) .AND. (.NOT. AREDEC)) THEN
           GOTO 500
         ELSEIF ((RDCTPS) .AND. (AREDEC)) THEN
           IRET = 1        
           GOTO 9999
         ENDIF  
        
C ---> SI ELASTICITE PASSAGE A L'ITERATION SUIVANTE        
        IF (ETATF .EQ. 'ELASTIC') THEN
          DO 30 I=1,NVI
            VINF(I)=VIND(I)  
 30       CONTINUE
          CHGMEC = .FALSE.        
          GOTO 40       
        ENDIF
        
C ---> SINON RESOLUTION VIA L'ALGORITHME DE NEWTON
        CHGMEC = .FALSE.

        CALL LCEQVN (NVI, VIND, VINF)

 100    CONTINUE
C       WRITE(6,'(A,32(1X,E16.9))')'MPOT2 --- VIND =',(VIND(I),I=1,32)
C--->   RESOLUTION EN FONCTION DES MECANISMES ACTIVES
C       MECANISMES ISOTROPE ET DEVIATOIRE
C-----------------------------------------------------

Caf 18/05/07 Debut

         CALL HUJMID (MOD, CRIT, MATER, NVI, EPSD, DEPS,
     &     SIGD, SIGF, VIND, VINF, NOCONV, AREDEC, STOPNC,
     &     NEGMUL, NITER0, EPSCON, IRET, SUBD, LOOP, NSUBD)
         NITER = NITER + NITER0
         
C        WRITE(6,'(A,L1,A,L1,A,L1)') 'NOCONV =',NOCONV,
C     &    ' AREDEC =', AREDEC, ' SUBD =', SUBD
         
         IF ((NOCONV .OR. SUBD) .AND. (.NOT. AREDEC)) 
     &               GOTO 500
         IF (NOCONV) GOTO 9999
         

Caf 12/06/07 Debut
C --- REPRISE A CE NIVEAU SI MECANISME SUPPOSE ELASTIQUE   
  40    CONTINUE        
Caf 12/06/07 Fin
          
Caf 05/09/2007 Debut
C --- VERIFICATION DES MECANISMES SUPPOSES ACTIFS
C                  DES MULTIPLICATEURS PLASTIQUES
C                  DES SEUILS EN DECHARGE

         CALL HUJACT(MATER, VIND, VINF, VINS, SIGD, SIGF,
     &               NEGMUL, CHGMEC,AREDEC, INDMEC)
Caf 05/09/2007 Fin
C       CALL HUJRMO(MATER, SIGD , VIND, RD)
C       CALL HUJRMO(MATER, SIGF , VINF, RF)
C       WRITE(6,'(A,E16.9,A,E16.9)')'RD =',RD,' --- RF =',RF
  
C - SI ON MODIFIE LE DOMAINE POTENTIEL DE MECANISMES ACTIVES : RETOUR
C   AVEC UNE CONDITION DE CONVERGENCE DE LA METHODE DE NEWTON
        IF (CHGMEC .AND. (.NOT. NOCONV)) THEN
          IF (.NOT. AREDEC) THEN
C --- REDECOUPAGE ACTIVE S'IL NE L'ETAIT PAS ENCORE
            CHGMEC = .FALSE.
            NOCONV = .TRUE.
            GOTO 500
          ELSE
C --- REPRISE DE L'ITERATION EN TENANT COMPTE DES MODIFICATIONS
            IF (DEBUG) WRITE (IFM,'(A)')
     &               'HUJRES :: CHANGEMENT DE MECANISME'
            CHGMEC = .FALSE.

C --- REINITIALISATION DE SIGF A LA PREDICTION ELASTIQUE PREDIC
C            CALL LCEQVE (PREDIC, SIGF)
C --- PREDICTEUR MIS A JOUR TENANT COMPTE DE L'ETAT PRECEDEMMENT OBTENU
            MAJ = MAJ + 1
            IF(MAJ.LT.5)THEN
              LOOP = .TRUE.
              CALL LCEQVN (NVI, VIND, VINF)
              GOTO 100
            ELSE        
              IF (INDMEC.EQ.8) THEN
                VINF(31) = ZERO 
                GOTO 45
              ELSE
                IRET = 1
                GOTO 9999
              ENDIF          
            ENDIF            
          ENDIF
                 
C --- S'IL N'Y A PAS DE CHANGEMENT DE MECANISME, ON POURSUIT
        ELSEIF (.NOT. CHGMEC) THEN
 45       CONTINUE
          MAJ = 0
          IF (IDEC .LT. NDEC) THEN
            CALL LCEQVE (SIGF, SIGD)
            DO 50 I = 1, NVI
              VIND(I) = VINF(I)
 50           CONTINUE
            DO 60 I = 1, NDT
              DEPS(I) = DEPS0(I)/NDEC
 60         CONTINUE
C --- APPLICATION DE L'INCREMENT DE DÉFORMATIONS, SUPPOSE ELASTIQUE  
            CALL HUJELA(MOD,CRIT,MATER,DEPS,SIGD,SIGF,EPSD,IRET)
C         WRITE(6,'(A,6(1X,E16.9))')'HUJRES -- SIGD =',(SIGD(I),I=1,6)
C         WRITE(6,*)'HUJRES -- R4 =',VINF(4)

          ENDIF
        
        ELSE
        
          IF (DEBUG) WRITE (IFM,'(A)') 'HUJRES :: CAS NON PREVU'
          IRET = 1
            WRITE (IFM,'(A)') 'HUJRES :: CAS NON PREVU'
            GOTO 9999  

        ENDIF
        
 400    CONTINUE
 
9999    CONTINUE

2000    FORMAT(A,32(1X,E12.5))
1001    FORMAT(A,I3)
        
        END
