      SUBROUTINE CTETGD(BASMOD,NUMD,NUMG,NBSEC,TETA,NBTET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    P. RICHARD     DATE 11/03/91
C-----------------------------------------------------------------------
C  BUT:     < CALCUL DE LA MATRICE TETA GAUCHE-DROITE >
C
C   CALCUL DE LA MATRICE TETA PERMETTANT DE PASSER DES  DDL DE
C  L'INTERFACE DROITE A CEUX DE L'INTERFACE GAUCHE
C
C-----------------------------------------------------------------------
C
C BASMOD   /I/: NOM UTLISATEUR DE LA BASE MODALE
C NUMD     /I/: NUMERO DE L'INTERFACE DROITE
C NUMG     /I/: NUMERO DE L'INTERFACE GAUCHE
C NBSEC    /I/: NOMBRE DE SECTEURS
C TETA     /O/: MATRICE CARREE DE CHANGEMENT DE REPERE RECHERCHE
C NBTET    /I/: DIMENSION DELA MATRICE TETA
C
C
C
C
C
      INCLUDE 'jeveux.h'
      PARAMETER   (NBCPMX=300)
      CHARACTER*1 K1BID
      CHARACTER*24 VALK(2)
      CHARACTER*8 BASMOD,MAILLA,TYPDDL(10),NOMNOE,TYD,INTF,KBID
      REAL*8      XD(10),XG(10),XTD(10),XTG(10),TET0(10,10)
      REAL*8      TETA(NBTET,NBTET)
      LOGICAL     NOOK
      INTEGER     IDECD(NBCPMX),IDECG(NBCPMX)
      INTEGER VALI(2)
C
C-----------------------------------------------------------------------
C
      DATA TYPDDL /'DX','DY','DZ','DRX','DRY','DRZ',
     &              '?','?','PRES','PHI'/
      DATA NOOK /.FALSE./
C
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      PI=R8PI()
C
C-----------------RECUPERATION DES CONCEPTS AMONT-----------------------
C
      CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
      INTF=ZK24(LLREF+4)
      CALL DISMOI('F','NOM_MAILLA',INTF,'INTERF_DYNA',IBID,
     &            MAILLA,IRET)
C
C----------------RECUPERATION DU NOMBRE D'ENTIERS CODES-----------------
C
      CALL DISMOI('F','NB_CMP_MAX',INTF,'INTERF_DYNA',NBCMP,KBID,IER)
      CALL DISMOI('F','NB_EC',INTF,'INTERF_DYNA',NBEC,KBID,IER)
      IF (NBEC.GT.10) THEN
        CALL U2MESS('F','MODELISA_94')
      ENDIF
C
C
C
C-------------------REQUETTE DESCRIPTEUR DES DEFORMEES STATIQUES--------
C
      CALL JEVEUO(INTF//'.IDC_DEFO','L',LLDESC)
      CALL JELIRA(INTF//'.IDC_DEFO','LONMAX',NBNOT,K1BID)
C**************************************************************
      NBNOT = NBNOT/(2+NBEC)
C      NBNOT=NBNOT/3
C**************************************************************
C
C-----------REQUETTE SUR DEFINITION INTERFACES DROITE ET GAUCHE---------
C
      CALL JEVEUO(JEXNUM(INTF//'.IDC_LINO',NUMD),'L',LLNOD)
      CALL JEVEUO(JEXNUM(INTF//'.IDC_LINO',NUMG),'L',LLNOG)
C
C
C--------------RECUPERATION NOMBRE DE NOEUDS AUX INTERFACES-------------
C
       CALL JELIRA(JEXNUM(INTF//'.IDC_LINO',NUMD),'LONMAX',
     &NBNOD,K1BID)
C
       CALL JELIRA(JEXNUM(INTF//'.IDC_LINO',NUMG),'LONMAX',
     &NBNOG,K1BID)
C
      IF(NBNOD.NE.NBNOG) THEN
        VALI (1) = NBNOD
        VALI (2) = NBNOG
        CALL U2MESG('F','ALGORITH14_99',0,' ',2,VALI,0,0.D0)
      ENDIF
C
C
C--------------RECUPERATION NOMBRE DE DDL AUX INTERFACES----------------
C
      KBID=' '
      CALL BMNODI(BASMOD,KBID,'          ',NUMD,0,IBID,NBDDR)
      KBID=' '
      CALL BMNODI(BASMOD,KBID,'          ',NUMG,0,IBID,NBDGA)
      IF(NBDGA.NE.NBDDR) THEN
        VALI (1) = NBDDR
        VALI (2) = NBDGA
        CALL U2MESG('F','ALGORITH15_1',0,' ',2,VALI,0,0.D0)
      ENDIF
C
C
      IF(NBDDR.NE.NBTET) THEN
        VALI (1) = NBDDR
        VALI (2) = NBTET
        CALL U2MESG('F','ALGORITH15_2',0,' ',2,VALI,0,0.D0)
      ENDIF
C
C----------------------CALCUL DU TETA ELEMENTAIRE-----------------------
C
      ANGLE=2*PI/NBSEC
      CALL INTET0(ANGLE,TET0,3)
C
C
      NBDCOU=0
      DO 10 I=1,NBNOD
        INOD=ZI(LLNOD+I-1)
C******************************************************************
C        ICODD=ZI(LLDESC+2*NBNOT+INOD-1)
        INOG=ZI(LLNOG+I-1)
C        ICODG=ZI(LLDESC+2*NBNOT+INOG-1)
        CALL ISDECO(ZI(LLDESC+2*NBNOT+(INOD-1)*NBEC+1-1),IDECD,10)
        CALL ISDECO(ZI(LLDESC+2*NBNOT+(INOG-1)*NBEC+1-1),IDECG,10)
C******************************************************************
        DO 20 J=1,10
          IF(IDECD(J).EQ.1) THEN
            XD(J)=1.D0
          ELSE
            XD(J)=0.D0
          ENDIF
C
          IF(IDECG(J).EQ.1) THEN
            XG(J)=1.D0
          ELSE
            XG(J)=0.D0
          ENDIF
 20     CONTINUE
C
C
        DO 30 J=1,10
          XTD(J)=0.D0
          XTG(J)=0.D0
          DO 40 K=1,10
            XTD(J)=XTD(J)+ABS(TET0(J,K))*XD(K)
            XTG(J)=XTG(J)+ABS(TET0(K,J))*XG(K)
 40       CONTINUE
 30     CONTINUE
C
C
C    VERIFICATION SUR COHERENCE DES DDL INTERFACES
C
        DO 50 J=1,10
          IF(XTD(J).GT.0.D0.AND.XG(J).EQ.0.D0) THEN
            NOER=ZI(LLDESC+INOG-1)
            CALL JENUNO(JEXNUM(MAILLA//'.NOMNOE',NOER),NOMNOE)
            TYD=TYPDDL(J)
            CALL U2MESG('E','ALGORITH15_3',0,' ',0,0,0,0.D0)
            VALK (1) = TYD
            VALK (2) = NOMNOE
            CALL U2MESG('E','ALGORITH15_4',2,VALK,0,0,0,0.D0)
            NOOK=.TRUE.
          ENDIF
          IF(XTG(J).GT.0.D0.AND.XD(J).EQ.0.D0) THEN
            NOER=ZI(LLDESC+INOD-1)
            CALL JENUNO(JEXNUM(MAILLA//'.NOMNOE',NOER),NOMNOE)
            TYD=TYPDDL(J)
            CALL U2MESG('E','ALGORITH15_3',0,' ',0,0,0,0.D0)
            VALK (1) = TYD
            VALK (2) = NOMNOE
            CALL U2MESG('E','ALGORITH15_6',2,VALK,0,0,0,0.D0)
            NOOK=.TRUE.
          ENDIF
C
 50     CONTINUE
C
        IF(NOOK) THEN
          CALL U2MESG('F','ALGORITH15_7',0,' ',0,0,0,0.D0)
        ENDIF
C
        ILOCI=0
        ICOMP=0
        DO 60 J=1,10
          IF(IDECG(J).GT.0) THEN
            ILOCI=ILOCI+1
            ILOCJ=0
            ICOMP=ICOMP+1
            DO 70 K=1,10
              IF(IDECD(K).GT.0) THEN
                ILOCJ=ILOCJ+1
                X=TET0(J,K)
                CALL AMPPR(TETA,NBDDR,NBDDR,X,1,1,NBDCOU+ILOCI,
     &                     NBDCOU+ILOCJ)
              ENDIF
 70         CONTINUE
          ENDIF
 60     CONTINUE
C
        NBDCOU=NBDCOU+ICOMP
C
 10   CONTINUE
C
      CALL JEDEMA()
      END
