      SUBROUTINE OP0052()
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 17/01/2012   AUTEUR SELLENET N.SELLENET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE SELLENET N.SELLENET
C ----------------------------------------------------------------------
C  COMMANDE CALC_CHAMP
C ----------------------------------------------------------------------
      IMPLICIT NONE
C   ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      CHARACTER*6 NOMPRO
      PARAMETER  (NOMPRO='OP0052')
C
      INTEGER      IFM,NIV,IBID,N0,IRET,NP,NC,IARG
      INTEGER      NBORDR,NBROPT
C
      REAL*8       PREC
C
      CHARACTER*8  RESUC1,RESUCO,CRIT
      CHARACTER*16 COMPEX,K16BID,CONCEP,NOMCMD
      CHARACTER*19 LISORD,LISOPT
C
      CALL JEMARQ()
C
      LISOPT = '&&'//NOMPRO//'.LIS_OPTION'
      LISORD = '&&'//NOMPRO//'.NUME_ORDRE'
C
      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)
C
C     ON STOCKE LE COMPORTEMENT EN CAS D'ERREUR AVANT MNL : COMPEX
C     PUIS ON PASSE DANS LE MODE "VALIDATION DU CONCEPT EN CAS D'ERREUR"
      CALL ONERRF(' ',COMPEX,IBID)
      CALL ONERRF('EXCEPTION+VALID',K16BID,IBID)
C
C     RECUPERATION DES NOMS DES SD RESULTAT
      CALL GETRES(RESUC1,CONCEP,NOMCMD)
      CALL GETVID(' ','RESULTAT',1,IARG,1,RESUCO,N0)
C
      CALL GETVR8(' ','PRECISION',1,IARG,1,PREC,NP)
      CALL GETVTX(' ','CRITERE',1,IARG,1,CRIT,NC)
      CALL RSUTNU(RESUCO,' ',0,LISORD,NBORDR,PREC,CRIT,IRET)
      IF (IRET.EQ.10) THEN
        CALL U2MESK('A','CALCULEL4_8',1,RESUCO)
        GO TO 9999
      END IF
      IF (IRET.NE.0) THEN
        CALL U2MESS('A','ALGORITH3_41')
        GO TO 9999
      END IF
C
C     ON VEUT INTERDIRE LA REENTRANCE DE LA COMMANDE SI
C     ON UTILISE L'UN DES MOTS CLES : MODELE, CARAEL_ELEM,
C     CHAM_CHMATER OU EXCIT
      IF (RESUCO.EQ.RESUC1) THEN
        CALL CCVRPU(RESUCO,LISORD,NBORDR)
      ENDIF
C
C     FABRICATION DE LA LISTE DES OPTIONS
      CALL CCLOPU(RESUCO,RESUC1,LISORD,NBORDR,LISOPT,NBROPT)
C
C     APPEL A LA ROUTINE PREPARANT L'APPEL A CALCOP
      CALL CCBCOP(RESUCO,RESUC1,LISORD,NBORDR,LISOPT,NBROPT)
C
      CALL JEDETR(LISOPT)
C
      CALL CCCHUT(RESUCO,RESUC1,LISORD,NBORDR)
C
 9999 CONTINUE
C     ON REMET LE MECANISME D'EXCEPTION A SA VALEUR INITIALE
      CALL ONERRF(COMPEX,K16BID,IBID)
C
      CALL AJREFD(RESUCO,RESUC1,'COPIE')
C
      CALL JEDEMA()
C
      END
