      SUBROUTINE RITZ99(NOMRES)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/09/98   AUTEUR ACBHHCD G.DEVESA 
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
C***********************************************************************
C  P. RICHARD     DATE 10/02/92
C-----------------------------------------------------------------------
C  BUT : CREATION D'UNE BASE MODALE DE TYPE RITZ (C A D QUELCONQUE)
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM K8 DU RESULTAT
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C-----  FIN  COMMUNS NORMALISES  JEVEUX  -------------------------------
C
      COMPLEX*16   CBID
      CHARACTER*6  PGC
      CHARACTER*8  NOMRES,RESUL1,RESUL2,K8B,INTF
      CHARACTER*19 NUMREF
      CHARACTER*24 TEMOR1,TEMOR2,TEMPOR
C
C-----------------------------------------------------------------------
      DATA PGC /'RITZ99'/
C-----------------------------------------------------------------------
C
C --- RECUPERATION NUMEROTATION DE REFERENCE
C
      CALL JEMARQ()
      CALL JEVEUO(NOMRES//'           .REFE','L',LLREF)
      NUMREF=ZK24(LLREF+1)
C
C --- DETERMINATION DU NOMBRE DE CONCEPT(S) MODE_* (RESUL2)
C
      CALL GETVID('RITZ','MODE_MECA',2,1,1,RESUL2,IBI1)
      IF (IBI1.EQ.0) THEN
       CALL GETVID('RITZ','MODE_STAT',2,1,1,RESUL2,IBI2)
       IF (IBI2.EQ.0) THEN
        CALL GETVID('RITZ','MULT_ELAS',2,1,1,RESUL2,IBI3)
       ENDIF
      ENDIF
      CALL GETVID('RITZ','BASE_MODALE',1,1,1,RESUL1,IBMO)
      IF (IBMO.EQ.0) GOTO 30
      CALL GETVIS('RITZ','NMAX_MODE',2,1,1,NBMOD2,NBID)
      CALL RSORAC(RESUL2,'LONUTI',IBID,BID,K8B,CBID,EBID,'ABSOLU',
     &            NBOLD,1,NBID)
      NBMODN = MIN(NBMOD2,NBOLD)
C
      TEMOR1='&&'//PGC//'.NUME.ORD1'
      TEMOR2='&&'//PGC//'.NUME.ORD2'
      CALL BMNBMD(RESUL1,'TOUT',NBMOD1)
      CALL BMNBMD(RESUL1,'DEFORMEE',NBDEF)
C
C --- DETERMINATION NOMBRE TOTAL
C
      NBTOT=NBMOD1+NBMODN
      CALL JEEXIN(NOMRES//'           .UTIL',IRET)
      IF (IRET.NE.0) CALL JEDETR(NOMRES//'           .UTIL')
      CALL WKVECT(NOMRES//'           .UTIL','G V I',4,LDUTI)
      ZI(LDUTI)=3
C
C --- ALLOCATION DE LA STRUCTURE DE DONNEES BASE_MODALE
C
      IF (NOMRES.NE.RESUL1) THEN
        CALL RSCRSD(NOMRES,'BASE_MODALE',NBTOT)
      ELSE
        CALL RSORAC(RESUL1,'LONUTI',IBID,BID,K8B,CBID,EBID,'ABSOLU',
     &            NBOLD,1,NBID)
        IF (NBTOT.GT.NBOLD) CALL RSAGSD(NOMRES,NBTOT)
        CALL JEVEUO(NOMRES//'           .REFE','E',LDREF)
        CALL GETVID('    ','NUME_REF',1,1,1,NUMREF,IBID)
        NUMREF(15:19)='.NUME'
        CALL GETVID('  ','INTERF_DYNA',1,1,0,INTF,IOCI)
        IF(IOCI.LT.0) THEN
          CALL GETVID('  ','INTERF_DYNA',1,1,1,INTF,IOCI)
        ELSE
          INTF=' '
        ENDIF
        ZK24(LDREF)   = INTF
        ZK24(LDREF+1) = NUMREF
        ZK24(LDREF+2) = ' '
        ZK24(LDREF+3) = ' '
      ENDIF
      CALL WKVECT(TEMOR1,'V V I',NBMOD1,LTORD1)
      CALL WKVECT(TEMOR2,'V V I',NBMOD2,LTORD2)
      DO 31 II=1,NBMOD1
        ZI(LTORD1+II-1)=II
 31   CONTINUE
      DO 32 II=1,NBMOD2
        ZI(LTORD2+II-1)=II
 32   CONTINUE
      INORD=1
      CALL MOCO99(NOMRES,RESUL1,NUMREF,NBMOD1,ZI(LTORD1),INORD)
      IF (NBMOD1.GT.0) CALL JEDETR(TEMOR1)
      CALL MOCO99(NOMRES,RESUL2,NUMREF,NBMOD2,ZI(LTORD2),INORD)
      IF(NBMOD2.GT.0) CALL JEDETR(TEMOR2)
      NBMOD1 = NBMOD1 - NBDEF
      NBMOD2 = NBMOD2 + NBDEF
      GOTO 40
 30   CONTINUE 
C
C --- DETERMINATION DU NOMBRE DE CONCEPT(S) MODE_MECA
C
      CALL GETVID('RITZ','MODE_MECA',1,1,0,K8B,NBGL)
      NBGL = -NBGL
      IF (NBGL.EQ.0) THEN
         CALL UTDEBM('F','RITZ99','IL FAUT UN MODE_MECA A LA 1ERE 
     &    OCCURENCE DE RITZ')
         CALL UTFINM
      ENDIF
      IF (NBGL.EQ.1) 
     & CALL GETVID('RITZ','MODE_MECA',1,1,1,RESUL1,IBID)
      IF (NBGL.GT.1) THEN
       TEMPOR = '&&RITZ99.GLOBAL'
       CALL WKVECT(TEMPOR,'V V K8',NBGL,IDGL)
       CALL GETVID('RITZ','MODE_MECA',1,1,NBGL,ZK8(IDGL),NBG)
      ENDIF
C
C --- DETERMINATION NOMBRE ET NUMERO ORDRE MODE
C
      CALL GETVIS('RITZ','NMAX_MODE',1,1,1,NBMOD1,NBID)
      CALL GETVIS('RITZ','NMAX_MODE',2,1,1,NBMOD2,NBID)
      NBMODA = NBMOD1
      IF (NBGL.EQ.1) THEN
        CALL RSORAC(RESUL1,'LONUTI',IBID,BID,K8B,CBID,EBID,'ABSOLU',
     &            NBOLD,1,NBID)
        NBMODA = MIN(NBMOD1,NBOLD)  
      ENDIF
      CALL RSORAC(RESUL2,'LONUTI',IBID,BID,K8B,CBID,EBID,'ABSOLU',
     &            NBOLD,1,NBID)
      NBMODB = MIN(NBMOD2,NBOLD)
C
      TEMOR1='&&'//PGC//'.NUME.ORD1'
      TEMOR2='&&'//PGC//'.NUME.ORD2'
      IF (NBMOD1.EQ.0) THEN 
         CALL WKVECT(TEMOR1,'V V I',1,LTORD1)
      ELSE
         CALL WKVECT(TEMOR1,'V V I',NBMOD1,LTORD1)
      ENDIF
      IF (NBMOD2.EQ.0) THEN 
         CALL WKVECT(TEMOR2,'V V I',1,LTORD2)
      ELSE
         CALL WKVECT(TEMOR2,'V V I',NBMOD2,LTORD2)
      ENDIF
      DO 10 II=1,NBMOD1
        ZI(LTORD1+II-1)=II
 10   CONTINUE
      DO 11 II=1,NBMOD2
        ZI(LTORD2+II-1)=II
 11   CONTINUE
C
C --- DETERMINATION NOMBRE TOTAL
C
      NBTOT=NBMODA+NBMODB
      CALL WKVECT(NOMRES//'           .UTIL','G V I',4,LDUTI)
      ZI(LDUTI)=3
C
C --- ALLOCATION DE LA STRUCTURE DE DONNEES BASE_MODALE
C
      CALL RSCRSD(NOMRES,'BASE_MODALE',NBTOT)
C
C --- COPIE DES MODES DYNAMIQUES
C
      INORD=1
      IF (NBGL.EQ.1) THEN
        CALL MOCO99(NOMRES,RESUL1,NUMREF,NBMOD1,ZI(LTORD1),INORD)
      ELSE
        DO 20 I =1,NBGL
         CALL MGCO99(NOMRES,ZK8(IDGL+I-1),NUMREF,NBMOD1,
     +     ZI(LTORD1),INORD)
 20     CONTINUE
        INORD = INORD + NBMOD1
      ENDIF
      IF (NBMOD1.GE.0) CALL JEDETR(TEMOR1)
C
      CALL MOCO99(NOMRES,RESUL2,NUMREF,NBMOD2,ZI(LTORD2),INORD)
      IF (NBMOD2.GE.0) CALL JEDETR(TEMOR2)
 40   CONTINUE
      ZI(LDUTI+2)=NBMOD1
      ZI(LDUTI+3)=NBMOD2
      NBTOT=NBMOD1+NBMOD2
      ZI(LDUTI+1)=NBTOT
      IF (NBGL.NE.0) CALL JEDETR(TEMPOR)
C
 9999 CONTINUE
      CALL JEDEMA()
      END
