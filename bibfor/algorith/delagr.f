      SUBROUTINE DELAGR(MODEDE, NUMEDE, MATE,   COMREF, COMPOR,
     &                  SOLVDE, PARMET, PARCRI, CARCRI, ITERAT,
     &                  VALMOI, DEPDEL, VALPLU, CONVDE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/04/2002   AUTEUR VABHHTS J.PELLET 
C RESPONSABLE ADBHHVV V.CANO
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
      IMPLICIT NONE
      INTEGER       ITERAT
      REAL*8        PARMET(*), PARCRI(*), CONVDE(*)
      CHARACTER*(*) MATE
      CHARACTER*8   MODEDE
      CHARACTER*19  SOLVDE
      CHARACTER*24  NUMEDE, COMPOR, CARCRI
      CHARACTER*24  DEPDEL, VALMOI, VALPLU, COMREF

C ----------------------------------------------------------------------
C  ALGORITHME DE LAGRANGIEN AUGMENTE POUR LES LOIS DELOCALISEES
C ----------------------------------------------------------------------
C IN  MODEDE K8   MODELE
C IN  NUMEDE K24  NUME_DDL
C IN  MATE   K*   MATERIAU
C IN  COMREF K24  CARTE TEMPERATURE DE REFERENCE
C IN  COMPOR K24  COMPORTEMENT
C IN  SOLVDE K19  SOLVEUR
C IN  PARMET  R   PARAMETRES DE LA METHODE DE RESOLUTION
C IN  PARCRI  R   CRITERES DE CONVERGENCE GLOBAUX
C IN  CARCRI K24  CRITERES DE CONVERGENCE LOCAUX
C IN  ITERAT  I   NUMERO DE L'ITERATION DE NEWTON EN COURS
C IN  VALMOI K24  VARIABLES EN T-
C IN  DEPDEL K24  CHAM_NO INCREMENT DE DEPLACEMENT
C VAR VALPLU K24  VARIABLES EN T+
C                  IN  ESTIMATION DE VARDEP ET LAGDEP
C                  OUT RESULTAT   DE VARDEP, LAGDEP ET VARPLU
C                  VARDEP: CHAMP NON LOCAL
C                  LAGDEP: LAGRANGE NON LOCAL (/LC SUR GRAD)
C                  VARPLU: PARTIE NON LOCALE DES VARIABLES INTERNES
C OUT CONVDE  R   VALEURS DE CONVERGENCE DE L'ALGORITHME
C                  1 - RESI_DUAL_ABSO
C                  2 - RESI_PRIM_ABSO
C                  3 - NOMBRE D'ITERATIONS
C                  4 - NUMERO ITERATION BFGS
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      CHARACTER*32       JEXNUM
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------

      LOGICAL      CONVDU, CONVPR, WOLFE
      INTEGER      IBID, I, MEM, B
      INTEGER      ITEMAX, ITER, ITBFGS, IRET, ITEPRM, MCPL, ITERHO
      INTEGER      NDDL, JGRAD, JLAG, JMEM, JDES, JLAG0
      REAL*8       R, T, Q(2), DIFNRJ, R8DOT, R8NRM2, CONTEX(9)
      REAL*8       F0, FC, DC
      COMPLEX*16   CBID
      CHARACTER*1  K1BID
      CHARACTER*8  MAILLA, K8BID
      CHARACTER*19 KBID, PENCST
      CHARACTER*24 VARDEP, LAGDEP, K24BID, GRADIA, ENEREL, ENERE0
      CHARACTER*24 DESCEN, ESPMEM, LAGDP0

      DATA GRADIA             /'&&DELAGR.GRADIA'/
      DATA LAGDP0             /'&&DELAGR.LAGDP0'/
      DATA DESCEN             /'&&DELAGR.DESCEN'/
      DATA ENEREL             /'&&DELAGR.ENEREL'/
      DATA ENERE0             /'&&DELAGR.ENERE0'/
      DATA ESPMEM             /'&&DELAGR.ESPMEM'/
      DATA PENCST             /'&&DELAGR.PENCST'/

C ----------------------------------------------------------------------

C -- INITIALISATION DE L'ALGORITHME

      CALL JEMARQ()
      R = PARMET(20)
      ITEMAX = NINT( PARMET(21) )
      ITEPRM = NINT( PARMET(22) )
      MCPL =20
      WOLFE = .TRUE.
      IF (ITERAT.EQ.0) CONVDE(4) = 0
      ITBFGS = NINT( CONVDE(4) )


C -- RECUPERATION DE VARDEP ET LAGDEP

      CALL DESAGG (VALPLU, K24BID, K24BID, K24BID, K24BID,
     &                     VARDEP, LAGDEP, K24BID, K24BID)


C -- RECUPERATION DU NOMBRE DE DEGRE DE LIBERTE DU PROBLEME
C     ( SUR LAGDEP)

      CALL JELIRA(LAGDEP(1:19) // '.CELV','LONMAX',NDDL,K8BID)


C -- CREATION DE LA CARTE DE LA CONSTANTE DE PENALISATION
C      (SI NECESSAIRE)

      CALL JEEXIN(PENCST,IRET)
      IF (IRET.EQ.0) THEN
        CALL DISMOI('F','NOM_MAILLA',MODEDE,'MODELE',IBID,MAILLA,IRET)
        CALL MECACT('V',PENCST,'MAILLA',MAILLA,'VALO_R',1,'VALEUR',
     &              IBID, R, CBID, KBID)
      END IF


C -- CREATION (SI NECESSAIRE) DE LA STRUCTURE DESCEN (VECTEUR)
C     (DIRECTION DE DESCENTE)

       CALL JEEXIN(DESCEN,IRET)
       IF (IRET.EQ.0) THEN
         CALL WKVECT(DESCEN,'V V R',NDDL,JDES)
       ELSE
         CALL JEVEUO(DESCEN,'E',JDES)
       END IF


C --  CREATION (SI NECESSAIRE) DE LA STRUCTURE LAGDP0 (VECTEUR)
C      (MULTIPLCATEURS DE LAGRANGE A L'ITERATION PRECEDENTE)

       CALL JEEXIN(LAGDP0,IRET)
       IF (IRET.EQ.0) THEN
         CALL WKVECT(LAGDP0,'V V R',NDDL,JLAG0)
       ELSE
         CALL JEVEUO(LAGDP0,'E',JLAG0)
       END IF


C --  CREATION (SI NECESSAIRE) DE LA STRUCTURE ESPMEM (VECTEUR)
C      (ESPACE MEMOIRE DE TRAVAIL POUR L'ALGO BFGS)

       CALL JEEXIN(ESPMEM,IRET)
       IF (IRET.EQ.0) THEN
         MEM = NDDL * (2*MCPL + 3) + MCPL*2
         CALL WKVECT(ESPMEM,'V V R',MEM,JMEM)
       ELSE
         CALL JEVEUO(ESPMEM,'E',JMEM)
       END IF



C -- CALCUL DE LA FONCTION DUALE POUR LA PREMIERE ITERATION

        CALL DELAPR(MODEDE, NUMEDE, SOLVDE, MATE, COMREF, COMPOR,
     &      PENCST, PARCRI, CARCRI, ITEPRM, VALMOI, DEPDEL, VALPLU,
     &             VARDEP, LAGDEP, GRADIA, ENEREL, CONVDE, CONVPR)

        CALL DEDUCV(PARCRI, GRADIA, CONVDU, CONVDE)

        IF (CONVDU.AND.CONVPR) THEN
           ITER = 0
           GOTO 9000
        END IF




C -- ITERATIONS BFGS DUAL

      DO 10 ITER = 0, ITEMAX


C   -- DIRECTION DE DESCENTE PAR BFGS

        CALL JEVEUO(LAGDEP(1:19) // '.CELV', 'E', JLAG)
        CALL JEVEUO(GRADIA(1:19) // '.CELV', 'L', JGRAD)

        CALL ALBFGS(NDDL,MCPL,ITBFGS,ZR(JMEM),ZR(JLAG),ZR(JGRAD),
     &                ZR(JDES) )

        ITBFGS = ITBFGS + 1
        DO 15 I=1, NDDL
          ZR(JLAG0-1 + I) = ZR(JLAG-1 + I)
 15     CONTINUE


C   -- RECHERCHE LINEAIRE

        WOLFE = .TRUE.
        T     = 0.D0
        CALL COPISD('CHAMP_GD','V',ENEREL, ENERE0)

        DO 20 ITERHO = 1, 100

          CALL JEVEUO(GRADIA(1:19) // '.CELV', 'L', JGRAD)
          CALL DELANR(ENERE0, ENEREL, DIFNRJ)
          Q(1) =  DIFNRJ
          Q(2) =  R8DOT(NDDL, ZR(JGRAD),1, ZR(JDES),1)
          CALL ALWOLF(CONTEX, Q, WOLFE, T)
          IF (WOLFE) GOTO 100

C        REACTUALISATION DES INCONNUES
          CALL JEVEUO(LAGDEP(1:19) // '.CELV', 'E', JLAG)
          DO 30 I=1, NDDL
             ZR(JLAG-1 + I) = ZR(JLAG0-1 + I) + T*ZR(JDES-1 + I)
 30       CONTINUE


C        RESOLUTION DU PROBLEME SANS CONTRAINTES (PRIMAL)

          CALL DELAPR(MODEDE, NUMEDE, SOLVDE, MATE, COMREF, COMPOR,
     &      PENCST, PARCRI, CARCRI, ITEPRM, VALMOI, DEPDEL, VALPLU,
     &             VARDEP, LAGDEP, GRADIA, ENEREL, CONVDE, CONVPR)

          CALL DEDUCV(PARCRI, GRADIA, CONVDU, CONVDE)
          IF (CONVDU.AND.CONVPR) GOTO 9000

 20     CONTINUE
        CALL UTMESS('F','DELAGR','PROBLEME RECHERCHE LINEAIRE')

 100    CONTINUE


 10   CONTINUE
      ITER = ITEMAX

 9000 CONTINUE
      CONVDE(3) = ITER
      CONVDE(4) = ITBFGS
      CALL JEDEMA()

      END
