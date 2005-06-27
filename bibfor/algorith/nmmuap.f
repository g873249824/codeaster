      SUBROUTINE NMMUAP(FONDEP,FONVIT,FONACC,MULTAP,PSIDEL)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*24 FONDEP,FONVIT,FONACC,MULTAP,PSIDEL
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/06/2005   AUTEUR NICOLAS O.NICOLAS 
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
C      COMMANDE  DYNA_ENTRAIN
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32     JEXNOM, JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*8  K8B
      CHARACTER*8  MODSTA, MAILLA
      CHARACTER*14 NUMDDL
      CHARACTER*24 DEEQ
      CHARACTER*24 KBID, MATRIC
      CHARACTER*80 TITRE
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL GETVID(' ','MODE_STAT',1,1,1,MODSTA,NBMD)
      CALL JEVEUO(MODSTA//'           .REFD','L',IADRIF)
      MATRIC =  ZK24(IADRIF)(1:8)
      CALL DISMOI('F','NOM_MAILLA'  ,MATRIC,'MATR_ASSE',IBI,MAILLA,IER)
      CALL DISMOI('F','NOM_NUME_DDL',MATRIC,'MATR_ASSE',IBI,NUMDDL,IRET)
      DEEQ = NUMDDL//'.NUME.DEEQ'
      CALL JEVEUO(DEEQ,'L',IDDEEQ)
      CALL DISMOI('F','NB_EQUA',MATRIC,'MATR_ASSE',NEQ,K8B,IRET)
C
      CALL GETFAC('EXCIT',NBEXCI)
      CALL WKVECT(FONDEP,'V V K8',NBEXCI,JNODEP)
      CALL WKVECT(FONVIT,'V V K8',NBEXCI,JNOVIT)
      CALL WKVECT(FONACC,'V V K8',NBEXCI,JNOACC)
      CALL WKVECT(MULTAP,'V V I',NBEXCI,JMLTAP)
      CALL WKVECT(PSIDEL,'V V R8',NBEXCI*NEQ,JPSDEL)
      DO 10 I=1,NBEXCI
        CALL GETVTX('EXCIT','MULT_APPUI',I,1,1,K8B,ND)
        IF (K8B.EQ.'OUI') THEN
         ZI(JMLTAP+I-1) = 1
         CALL GETVID('EXCIT','ACCE',I,1,1,KBID,NA)
         CALL GETVID('EXCIT','FONC_MULT',I,1,1,KBID,NF)
         IF (NA.NE.0) 
     &    CALL GETVID('EXCIT','ACCE',I,1,1,ZK8(JNOACC+I-1),NA)
         IF (NF.NE.0) 
     &    CALL GETVID('EXCIT','FONC_MULT',I,1,1,ZK8(JNOACC+I-1),NF)
         CALL GETVID('EXCIT','VITE',I,1,1,ZK8(JNOVIT+I-1),NV)
         CALL GETVID('EXCIT','DEPL',I,1,1,ZK8(JNODEP+I-1),ND)
         CALL TRMULT(MODSTA,I,MAILLA,NEQ,IDDEEQ,ZR(JPSDEL+(I-1)*NEQ))
C
C     --- MISE A ZERO DES DDL DE LAGRANGE
         CALL ZERLAG(ZR(JPSDEL+(I-1)*NEQ),NEQ,ZI(IDDEEQ))
        ENDIF
 10   CONTINUE
C
C
      CALL JEDEMA()
      END
