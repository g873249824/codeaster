      SUBROUTINE RLTFR8(NOMMAT,NEQ,NBBLOC,XSOL,NBSOL,TYPSYM)
      IMPLICIT NONE
      INTEGER NEQ,NBBLOC,NBSOL,TYPSYM,J
C
      CHARACTER*(*) NOMMAT
      REAL*8 XSOL(NEQ,*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 07/01/2002   AUTEUR JFBHHUC C.ROSE 
C RESPONSABLE JFBHHUC C.ROSE
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
C     ------------------------------------------------------------------
C     RESOLUTION DU SYSTEME A COEFFICIENTS REELS:  A * X = B
C     LA MATRICE EST SYMETRIQUE ET A ETE FACTORISEE SOUS FORME L*D*LT
C     LA RESOLUTION EST EN PLACE
C
C     ON PEUT RESOUDRE SUR UNE SOUS-MATRICE DE A :
C     ON PREND LES NEQ PREMIERES LIGNES ET COLONNES (NEQ PEUT ETRE
C     INFERIEUR A LA DIMENSION DE LA MATRICE).
C
C     ON PEUT RESOUDRE NBSOL SYSTEMES D'UN COUP A CONDITION
C     QUE LES VECETURS SOIENT CONSECUTIFS EN MEMOIRE :
C     XSOL EST UN VECTEUR DE NBSOL*NEQ REELS
C     ------------------------------------------------------------------
C
C IN  NOMMAT  :    : NOM UTILISATEUR DE LA MATRICE A FACTORISER
C IN  NEQ     : IS : NOMBRE D'EQUATIONS PRISES EN COMPTE
C                    C'EST AUSSI LA DIMENSION DES VECTEURS XSOL.
C IN  NBBLOC  : IS : NOMBRE DE BLOC DE LA MATRICE
C VAR XSOL    : R8 : EN ENTREE LES SECONDS MEMBRES
C                    EN ENTREE LES SOLUTIONS
C IN  NBSOL   : IS : NOMBRE DE SOLUTIONS / SECONDS MEMBRES
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
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
      CHARACTER*6 PGC,PGCANC
      COMMON /NOMAJE/PGC
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C     ------------------------------------------------------------------
      CHARACTER*32 JEXNOM
      CHARACTER*24 FACTOL,FACTOU
      CHARACTER*24 NOMP01,NOMP02,NOMP03,NOMP04,NOMP05,
     %NOMP06,NOMP07,NOMP08,NOMP09,NOMP10,NOMP11,NOMP12,NOMP13,NOMP14,
     %NOMP15,NOMP16,NOMP17,NOMP18,NOMP19,NOMP20
C     -------------------------------------------------- POINTEURS
      INTEGER POINTR,DESC
      INTEGER DIAG,NOUV,ANC,SUPND,ADPILE,PARENT
      INTEGER SEQ,FILS,FRERE,ADRESS,LFRONT,NBLIGN,LGSN,DEBFAC
      INTEGER DEBFSN,NBASS,DECAL,GLOBAL
      INTEGER NCBLOC,LGBLOC,NBLOC,NBSN,AD,TRAV
      INTEGER LGBLMA,POINTS
      INTEGER IBID,IERD,I
      CHARACTER*8 NOMGD
      CHARACTER*14 NU
C
C     ------------------------------------------------------------------
      DATA FACTOL/'                   .VALF'/
      DATA FACTOU/'                   .WALF'/
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL DISMOI('F','NOM_NUME_DDL',NOMMAT,'MATR_ASSE',IBID,NU,IERD)
      PGC = 'RLTFR8'
      FACTOL(1:19) = NOMMAT
      FACTOU(1:19) = NOMMAT
      CALL MLNMIN(NU,NOMP01,NOMP02,NOMP03,NOMP04,NOMP05,
     %NOMP06,NOMP07,NOMP08,NOMP09,NOMP10,NOMP11,NOMP12,NOMP13,NOMP14,
     %NOMP15,NOMP16,NOMP17,NOMP18,NOMP19,NOMP20)
C                                ALLOCATION DES POINTEURS ENTIERS
      CALL JEVEUO(NOMP01,'L',DESC)
      CALL JEVEUO(NOMP03 ,'L',ADRESS)
      CALL JEVEUO(NOMP04 ,'L',SUPND)
      CALL JEVEUO(NOMP20 ,'L',SEQ)
      CALL JEVEUO(NOMP16 ,'L',LGBLOC)
      CALL JEVEUO(NOMP17 ,'L',NCBLOC)
      CALL JEVEUO(NOMP18 ,'L',DECAL)
      CALL JEVEUO(NOMP08 ,'L',LGSN)
      CALL JEVEUO(NOMP14,'L',ANC)
      CALL JEVEUO(NOMP19,'L',NOUV)
      NBSN = ZI(DESC+1)
      NBLOC= ZI(DESC+2)
      LGBLMA=0
      DO  1 I=0,NBLOC-1
         IF(ZI(LGBLOC+I).GT.LGBLMA) LGBLMA = ZI(LGBLOC+I)
 1    CONTINUE
      CALL WKVECT('&&RLTFR8.ALLEUR.VALF ',' V V R ',LGBLMA,POINTS)

C                                ALLOCATION TABLEAU REEL PROVISOIRE
      CALL WKVECT('&&RLTFR8.POINTER.REELS ',' V V R ',NEQ,POINTR)
      CALL WKVECT('&&RLTFR8.POINTER.ADRESSE','V V I',NEQ,AD)
      CALL WKVECT('&&RLTFR8.POINTER.TRAVAIL','V V R',NEQ,TRAV)

      CALL JEVEUO(NU//'.MLTF.GLOB','L',GLOBAL)
C
      CALL JEDETR('&&RLTFR8.ALLEUR.VALF ')
      DO 110 I = 1,NBSOL
          CALL MLTDRA(NBLOC,ZI(LGBLOC),ZI(NCBLOC),ZI(DECAL),ZI(SEQ),
     +                NBSN,NEQ,ZI(SUPND),ZI(ADRESS),ZI(GLOBAL),ZI(LGSN),
     +                FACTOL,FACTOU,XSOL(1,I),ZR(POINTR),
     +                ZI(NOUV),ZI(ANC),ZI(AD),ZR(TRAV),TYPSYM )
  110 CONTINUE

      CALL JEDETR('&&RLTFR8.POINTER.ADRESSE')
      CALL JEDETR('&&RLTFR8.POINTER.TRAVAIL')
      CALL JEDETR('&&RLTFR8.POINTER.REELS ')
      CALL JEDETR('&&RLTFR8.POINTEUR.SUPN')
      CALL JEDETR('&&RLTFR8.POINTEUR.ANC ')
      CALL JEDETR('&&RLTFR8.POINTEUR.NOUV')
      CALL JEDETR('&&RLTFR8.POINTEUR.SEQ ')
      CALL JEDETR('&&RLTFR8.POINTEUR.LGSN')
      CALL JEDETR('&&RLTFR8.POINTEUR.ADRE')
      CALL JEDETR('&&RLTFR8.POINTEUR.LGBL')
      CALL JEDETR('&&RLTFR8.POINTEUR.NCBL')
      CALL JEDETR('&&RLTFR8.POINTEUR.DECA')
      CALL JEDEMA()
      END
