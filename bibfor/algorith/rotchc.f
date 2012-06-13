      SUBROUTINE ROTCHC(PROFNO,CVALE,TETSS,NBSS,INVSK,NBNOT,NBCMP,IAX)
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
C***********************************************************************
C    T. KERBER     DATE 16/05/93
C-----------------------------------------------------------------------
C  BUT: EFFECTUER LA ROTATION DE LA PARTIE DES CHAMNO.VALE CORRESPON-
C  -DANT A CHAQUE SOUS-STRUCTURE A PARTIR DU PROFNO GLOBAL, DU
C  MAILLAGE SQUELETTE GLOBAL, ET DU TABLEAU INV-SKELET ET DU VECTEUR
C  DES ANGLES DE ROTATION DE CHAQUE SOUS-STRUCTURE
      IMPLICIT REAL*8 (A-H,O-Z)
C
C-----------------------------------------------------------------------
C
C PROFNO   /I/: NOM K19 DU PROF_CHNO GLOBAL
C CVALE    /M/: VECTEUR CORRESPONDANT AU .VALE DU CHAMNO COURANT
C TESSS    /I/: VECTEUR DES ANGLE DE ROTATION DES SOUS-STRUCTURES
C NBSS     /I/: NOMBRE DE SOUS-STRUCTURES
C INVSK    /I/: TABLEAU INVERSE-SKELETTE
C NBNOT    /I/: NOMBRE DE NOEUDS GLOBAL
C NBCMP    /I/: NOMBRE DE COMPOSANTE MAX DE LA GRANDEUR SOUS-JACENTE
C IAX      /I/: NUMERO DE L'AXE DE ROTATION
C
C
C
      INCLUDE 'jeveux.h'
C
C
      PARAMETER(NBCMPM=10)
      CHARACTER*6  PGC
      CHARACTER*8  KBID, NOMG
      CHARACTER*19 PROFNO
      CHARACTER*24 PRNO,NUEQ
      INTEGER INVSK(NBNOT,2),IEQ(NBCMPM)
      REAL*8 TETSS(NBSS),TET0(NBCMPM,NBCMPM)
      COMPLEX*16 CVALE(*),UDEP(NBCMPM)
C
C-----------------------------------------------------------------------
      DATA PGC /'ROTCHC'/
C-----------------------------------------------------------------------
C
C------------------------RECUPERATION DU PRNO DEEQ NUEQ-----------------
C
      CALL JEMARQ()
C
C-----RECUPERATION DU NOMBRE DU NOMBRE D'ENTIERS CODES ASSOCIE A DEPL_R
C
      NOMG = 'DEPL_R'
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,KBID,IERD)
      IF (NBEC.GT.10) THEN
         CALL U2MESS('F','MODELISA_94')
      ENDIF
C
      NUEQ=PROFNO//'.NUEQ'
      PRNO=PROFNO//'.PRNO'
C
      CALL JENONU(JEXNOM(PRNO(1:19)//'.LILI','&MAILLA'),IBID)
      CALL JEVEUO(JEXNUM(PRNO,IBID),'L',LLPRNO)
      CALL JEVEUO(NUEQ,'L',LLNUEQ)
C
C----------------------ALLOCATION VECTEUR DECODAGE----------------------
C
      CALL WKVECT('&&'//PGC//'.DECODAGE','V V I',NBCMP,LTIDEC)
C
C---------------------------ROTATION------------------------------------
C
      TETCOU=TETSS(1)
      CALL INTET0(TETCOU,TET0,IAX)
C
      DO 10 I=1,NBNOT
C
        NUMSEC=INVSK(I,1)
        TETAC=TETSS(NUMSEC)
        IF(TETAC.NE.TETCOU) THEN
          TETCOU=TETAC
          CALL INTET0(TETCOU,TET0,IAX)
        ENDIF
C
        INUEQ=ZI(LLPRNO+(NBEC+2)*(I-1))
        CALL ISDECO(ZI(LLPRNO+(NBEC+2)*(I-1)+2),ZI(LTIDEC),NBCMP)
        ICOMP=0
C
        DO 20 J=1,NBCMPM
          IF(ZI(LTIDEC+J-1).GT.0) THEN
            ICOMP=ICOMP+1
            IEQ(J)=ZI(LLNUEQ+INUEQ+ICOMP-2)
            UDEP(J)=CVALE(IEQ(J))
          ELSE
            IEQ(J)=0
            UDEP(J)=0.D0
          ENDIF
 20     CONTINUE
C
        DO 30 J=1,NBCMPM
          IF(IEQ(J).GT.0) THEN
            CVALE(IEQ(J))=0.D0
            DO 40 K=1,NBCMPM
              CVALE(IEQ(J))=CVALE(IEQ(J))+TET0(J,K)*UDEP(K)
 40         CONTINUE
          ENDIF
 30     CONTINUE
C
 10   CONTINUE
C
      CALL JEDETR('&&'//PGC//'.DECODAGE')
C
      CALL JEDEMA()
      END
