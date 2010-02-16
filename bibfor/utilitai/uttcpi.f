      SUBROUTINE UTTCPI (NOMMES,IFM,TYPIMP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 16/02/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PELLET J.PELLET
      IMPLICIT NONE
      CHARACTER *(*)  NOMMES,TYPIMP
      INTEGER IFM
C ----------------------------------------------------------------------
C BUT : IMPRIMER UNE MESURE DE TEMPS
C
C IN  NOMMES    : NOM IDENTIFIANT LA MESURE
C
C IN  IFM       : UNITE LOGIQUE POUR LES IMPRESSIONS
C IN  TYPIMP = 'CUMU' : ON IMPRIME LE "CUMUL" DE LA MESURE
C            = 'INCR' : ON IMPRIME L'INCREMENT DE LA MESURE
C
C ON APPELLE "INCREMENT" LA DIFFERENCE DE TEMPS ENTRE 2 APPELS
C SUCCESSIFS � UTTCPI(NOMMES,*,'INCR')
C ----------------------------------------------------------------------
C REMARQUE : LES VALEURS STOCKEES SONT ACCUMUEES VIA UTTCPU
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL,LJEV
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNOM
      CHARACTER*80 ZK80
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER INDI ,IBID,JVALMS,K,JNOML,NBFOIS,JVALMI
      INTEGER RANG, NBPROC,NPROMX
      PARAMETER (NPROMX=1000)
      CHARACTER*8 KBID
      CHARACTER*50 NOMMEL
      REAL*8 XTOTA,XUSER,XSYST,XELAP,MOYENN(3),ECTYPE(3)
      REAL*8 XTOTAP(NPROMX),XSYSTP(NPROMX),XELAPP(NPROMX)


C     -- COMMONS POUR MESURE DE TEMPS :
      INTEGER  MTPNIV ,INDMAX
      PARAMETER (INDMAX=5)
      CHARACTER*80 SNOLON(INDMAX)
      REAL*8 VALMES(INDMAX*7),VALMEI(INDMAX*7)
      COMMON /MESTP1/  MTPNIV
      COMMON /MESTP2/ SNOLON
      COMMON /MESTP3/ VALMES,VALMEI

C ----------------------------------------------------------------------

C     1. CALCUL DE INDI ET LJEV :
C     -------------------------------
C     -- POUR CERTAINES MESURES, ON NE PEUT PAS FAIRE DE JEVEUX :
C        ON GARDE ALORS LES INFOS DANS LES COMMON MESTPX
      IF (NOMMES.EQ.'CPU.MEMD.1') THEN
         INDI=1
      ELSEIF (NOMMES.EQ.'CPU.MEMD.2') THEN
         INDI=2
      ELSE
         LJEV=.TRUE.
         CALL JENONU(JEXNOM('&&UTTCPU.NOMMES',NOMMES),INDI)
         IF (INDI.EQ.0) GOTO 9999
         GOTO 9998
      ENDIF
      CALL ASSERT(INDI.LE.INDMAX)
      LJEV=.FALSE.


9998  CONTINUE

      IF (LJEV) THEN
        CALL JEVEUO('&&UTTCPU.VALMES','L',JVALMS)
        NBFOIS = NINT(ZR(JVALMS-1+7*(INDI-1)+2))
      ELSE
        NBFOIS = NINT(VALMES(7*(INDI-1)+2))
      ENDIF
      IF (NBFOIS.EQ.0) GOTO 9999

      IF (LJEV) THEN
        XUSER = ZR(JVALMS-1+7*(INDI-1)+5)
        XSYST = ZR(JVALMS-1+7*(INDI-1)+6)
        XELAP = ZR(JVALMS-1+7*(INDI-1)+7)
      ELSE
        XUSER = VALMES(7*(INDI-1)+5)
        XSYST = VALMES(7*(INDI-1)+6)
        XELAP = VALMES(7*(INDI-1)+7)
      ENDIF

      IF (TYPIMP.EQ.'CUMU') THEN

      ELSEIF (TYPIMP.EQ.'INCR') THEN
        IF (LJEV) THEN
          CALL JEVEUO('&&UTTCPU.VALMEI','E',JVALMI)
          XUSER = XUSER - ZR(JVALMI-1+7*(INDI-1)+5)
          XSYST = XSYST - ZR(JVALMI-1+7*(INDI-1)+6)
          XELAP = XELAP - ZR(JVALMI-1+7*(INDI-1)+7)

          DO 2,K=1,7
            ZR(JVALMI-1+7*(INDI-1)+K)=ZR(JVALMS-1+7*(INDI-1)+K)
2         CONTINUE
        ELSE
          CALL JEVEUO('&&UTTCPU.VALMEI','E',JVALMI)
          XUSER = XUSER - VALMEI(7*(INDI-1)+5)
          XSYST = XSYST - VALMEI(7*(INDI-1)+6)
          XELAP = XELAP - VALMEI(7*(INDI-1)+7)

          DO 3,K=1,7
            VALMEI(7*(INDI-1)+K)=VALMES(7*(INDI-1)+K)
3         CONTINUE
        ENDIF

      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

C     -- NOMMEL :
      IF (LJEV) THEN
        CALL JEVEUO('&&UTTCPU.NOMLON','L',JNOML)
        NOMMEL=ZK80(JNOML-1+INDI)
      ELSE
        NOMMEL=SNOLON(INDI)
      ENDIF

C     -- EN SEQUENTIEL, ON IMPRIME LES 3 NOMBRES MESURES
C     ------------------------------------------------------
      XTOTA=XUSER+XSYST
      WRITE(IFM,1003) NOMMEL,XTOTA,XSYST,XELAP


C     -- EN PARALLELE, ON IMPRIME EN PLUS LA MOYENNE ET
C        L'ECART TYPE (SUR L'ENSEMBLE DES PROCS)
C     ------------------------------------------------------
      CALL MPICM0(RANG,NBPROC)
      CALL ASSERT(RANG.GE.0)
      CALL ASSERT(RANG.LT.NBPROC)
      CALL ASSERT(NBPROC.LE.NPROMX)
      IF (NBPROC.GT.1) THEN
        DO 11,K=1,NBPROC
          XTOTAP(K)=0.D0
          XSYSTP(K)=0.D0
          XELAPP(K)=0.D0
11      CONTINUE
        XTOTAP(RANG+1)=XTOTA
        XSYSTP(RANG+1)=XSYST
        XELAPP(RANG+1)=XELAP
        CALL MPICM1('MPI_MAX','R',NBPROC,IBID,XTOTAP)
        CALL MPICM1('MPI_MAX','R',NBPROC,IBID,XSYSTP)
        CALL MPICM1('MPI_MAX','R',NBPROC,IBID,XELAPP)
        CALL STATI1(NBPROC,XTOTAP,MOYENN(1),ECTYPE(1))
        CALL STATI1(NBPROC,XSYSTP,MOYENN(2),ECTYPE(2))
        CALL STATI1(NBPROC,XELAPP,MOYENN(3),ECTYPE(3))
        NOMMEL='    (moyenne    diff. procs)'
        WRITE(IFM,1003) NOMMEL,MOYENN(1),MOYENN(2),MOYENN(3)
        NOMMEL='    (ecart-type diff. procs)'
        WRITE(IFM,1003) NOMMEL,ECTYPE(1),ECTYPE(2),ECTYPE(3)
      ENDIF



9999  CONTINUE

1003  FORMAT (A50,'CPU (USER+SYST/SYST/ELAPS):',3(F10.2))
      END
