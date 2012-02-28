      SUBROUTINE ERGLME (JCELD,IAVALE,OPTION,IORD,LIGREL,LONGT,NBGR,
     &                   TIME ,RESUCO,RESUC1)
      IMPLICIT NONE
      INTEGER JCELD,IAVALE,IORD,LONGT,NBGR
      REAL*8 TIME
      CHARACTER*(*) RESUCO
      CHARACTER*19 RESUC1,LIGREL
      CHARACTER*(*) OPTION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 29/02/2012   AUTEUR MACOCCO K.MACOCCO 
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
C =====================================================================
C ERREUR GLOBALE AU MAILLAGE - MECANIQUE
C **     **                    **
C =====================================================================
C
C     BUT:
C         CALCUL DES ESTIMATEURS GLOBAUX POUR LA MECANIQUE
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   JCELD  : ADRESSE DU DESCRIPTEUR DU CHAMP LOCAL
C IN   IAVALE : ADRESSE DES CHAMPS LOCAUX
C IN   OPTION :    'ERZ1_ELEM' OU 'ERZ2_ELEM'
C               OU 'QIZ1_ELEM' OU 'QIZ2_ELEM'
C               OU 'ERME_ELEM' OU 'QIRE_ELEM'
C IN   IORD   : NUMERO D'ORDRE
C IN   LIGREL : NOM DU LIGREL
C IN   LONGT  : NOMBRE DE CHAMPS LOCAUX
C IN   NBGR   : NOMBRE DE GRELS
C IN   TIME   : INSTANT DE CALCUL
C IN   RESUCO : NOM DU CONCEPT ENTRANT
C IN   RESUC1 : NOM DU CONCEPT RESULTAT DE LA COMMANDE CALC_ELEM
C
C      SORTIE :
C-------------
C
C ......................................................................

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX  --------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER      NBPAR
      PARAMETER  ( NBPAR = 5 )
C
      INTEGER IFI,NBELEM,NEL
      INTEGER MODE,K,J,IRET,IAD,IDECGR
      INTEGER IUNIFI,LADPA

      REAL*8 ERR0,NORS
      REAL*8 LISTR(3),NU0,NUVO,NUSA,NUNO,TERMVO,TERMSA,TERMNO

      CHARACTER*3  TYPPAR(NBPAR)
      CHARACTER*8  K8BID
      CHARACTER*16 NOMPAR(NBPAR)
      CHARACTER*19 NOMT19

      COMPLEX*16 CBID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      IFI    = IUNIFI('RESULTAT')
C
      NU0    = 0.D0
      ERR0   = 0.D0
      NORS   = 0.D0
      TERMVO = 0.D0
      TERMSA = 0.D0
      TERMNO = 0.D0
      DO 10 ,J = 1,NBGR
        MODE = ZI(JCELD-1+ZI(JCELD-1+4+J) +2)
        IF (MODE.EQ.0) GOTO 10
        NEL = NBELEM(LIGREL,J)
        IDECGR = ZI(JCELD-1+ZI(JCELD-1+4+J)+8)
        DO 20 , K = 1,NEL
          IAD    = IAVALE-1+IDECGR+(K-1)*LONGT
          ERR0   = ERR0   + ZR(IAD+1-1)**2
          NORS   = NORS   + ZR(IAD+3-1)**2
          TERMVO = TERMVO + ZR(IAD+4-1)**2
          TERMNO = TERMNO + ZR(IAD+6-1)**2
          TERMSA = TERMSA + ZR(IAD+8-1)**2
 20     CONTINUE
 10   CONTINUE
       IF(OPTION.EQ.'QIRE_ELEM') THEN
        ERR0   = SQRT(ERR0)
        TERMVO = SQRT(TERMVO)
        TERMSA = SQRT(TERMSA)
        TERMNO = SQRT(TERMNO)
      ELSE
        IF ((ERR0+NORS).GT.0.D0) THEN
          NU0    = 100.D0*SQRT(ERR0/(ERR0+NORS))
        ELSE
          NU0    = 0.D0
        ENDIF
        ERR0   = SQRT(ERR0)
        IF ((TERMVO+NORS).GT.0.D0) THEN
          NUVO   = 100.D0*SQRT(TERMVO/(TERMVO+NORS))
        ELSE
          NUVO   = 0.D0
        ENDIF
        TERMVO = SQRT(TERMVO)
        IF ((TERMSA+NORS).GT.0.D0) THEN
          NUSA   = 100.D0*SQRT(TERMSA/(TERMSA+NORS))
        ELSE
          NUSA   = 0.D0
        ENDIF
        TERMSA = SQRT(TERMSA)
        IF ((TERMNO+NORS).GT.0.D0) THEN
          NUNO   = 100.D0*SQRT(TERMNO/(TERMNO+NORS))
        ELSE
          NUNO   = 0.D0
        ENDIF
        TERMNO = SQRT(TERMNO)
        NORS   = SQRT(NORS)
      ENDIF
C
C ON ECRIT LES TERMES DANS LES PARAMETRES DE LA SD RESULTAT
C
      IF     (OPTION.EQ.'ERME_ELEM') THEN
        CALL RSADPA(RESUC1,'E',1,'ERREUR_ERRE',IORD,0,LADPA,K8BID)
       ELSEIF (OPTION.EQ.'ERZ1_ELEM') THEN
        CALL RSADPA(RESUC1,'E',1,'ERREUR_ERZ1',IORD,0,LADPA,K8BID)
       ELSEIF (OPTION.EQ.'ERZ2_ELEM') THEN
        CALL RSADPA(RESUC1,'E',1,'ERREUR_ERZ2',IORD,0,LADPA,K8BID)
       ELSEIF (OPTION.EQ.'QIRE_ELEM') THEN
        CALL RSADPA(RESUC1,'E',1,'ERREUR_QIRE',IORD,0,LADPA,K8BID)
       ELSEIF (OPTION.EQ.'QIZ1_ELEM') THEN
        CALL RSADPA(RESUC1,'E',1,'ERREUR_QIZ1',IORD,0,LADPA,K8BID)
       ELSEIF (OPTION.EQ.'QIZ2_ELEM') THEN
        CALL RSADPA(RESUC1,'E',1,'ERREUR_QIZ2',IORD,0,LADPA,K8BID)
      ENDIF
      ZR(LADPA)=ERR0
C
C ON CREE LA TABLE DES RESULTATS
C
      NOMPAR(1)='NUME_ORDR'
      NOMPAR(2)='OPTION'
      NOMPAR(3)='ERRE_RELA'
      NOMPAR(4)='ERRE_ABSO'
      NOMPAR(5)='NORM_SIGM'
      TYPPAR(1)='I'
      TYPPAR(2)='K16'
      TYPPAR(3)='R'
      TYPPAR(4)='R'
      TYPPAR(5)='R'      
C
      CALL JEEXIN(RESUC1//'.LTNT',IRET)
      IF (IRET.EQ.0) CALL LTCRSD(RESUC1,'G')
C
      NOMT19 = ' '
      CALL LTNOTB(RESUC1,'ESTI_GLOB',NOMT19)
      CALL JEEXIN(NOMT19//'.TBBA',IRET)
      IF (IRET.EQ.0) THEN
        CALL TBCRSD(NOMT19,'G')
        CALL TBAJPA (NOMT19,NBPAR,NOMPAR,TYPPAR)
      ENDIF

      LISTR(1) = NU0
      LISTR(2) = ERR0
      LISTR(3) = NORS

      CALL TBAJLI (NOMT19,NBPAR,NOMPAR,IORD,LISTR,CBID,OPTION,0)

      WRITE(IFI,*) ' '
      WRITE(IFI,*) '***************************************************'
       IF(OPTION.EQ.'ERZ1_ELEM') THEN
        WRITE(IFI,*) ' MECANIQUE : ESTIMATEUR D''ERREUR ZZ1'
       ELSEIF(OPTION.EQ.'ERZ2_ELEM') THEN
        WRITE(IFI,*) ' MECANIQUE : ESTIMATEUR D''ERREUR ZZ2'
      ELSEIF(OPTION.EQ.'ERME_ELEM') THEN
        WRITE(IFI,*) ' MECANIQUE : ESTIMATEUR D''ERREUR EN RESIDU '
     &                 //'EXPLICITE'
       ELSEIF(OPTION.EQ.'QIRE_ELEM') THEN
        WRITE(IFI,*) ' MECANIQUE : ESTIMATEUR D''ERREUR EN QUANTITE '
     &                 //'D''INTERET'
        WRITE(IFI,*) '             - METHODE RESIDU EXPLICITE -'
       ELSEIF(OPTION.EQ.'QIZ1_ELEM') THEN
        WRITE(IFI,*) ' MECANIQUE : ESTIMATEUR D''ERREUR EN QUANTITE '
     &                 //'D''INTERET'
        WRITE(IFI,*) '             - METHODE ZZ1 -'
       ELSEIF(OPTION.EQ.'QIZ2_ELEM') THEN
        WRITE(IFI,*) ' MECANIQUE : ESTIMATEUR D''ERREUR EN QUANTITE '
     &                 //'D''INTERET'
        WRITE(IFI,*) '             - METHODE ZZ2 -'
      ENDIF
      WRITE(IFI,*) '***************************************************'

      WRITE(IFI,111)'SD RESULTAT: ',RESUCO
      WRITE(IFI,110)' NUMERO D''ORDRE: ',IORD
      WRITE(IFI,109)' INSTANT: ',TIME

       IF(OPTION.EQ.'QIRE_ELEM') THEN
        WRITE(IFI,*)'ERREUR            ABSOLUE'
        WRITE(IFI,108)' TOTALE          ',ERR0
        WRITE(IFI,108)' TERME VOLUMIQUE ',TERMVO
        WRITE(IFI,108)' TERME SAUT      ',TERMSA
        WRITE(IFI,108)' TERME NORMAL    ',TERMNO
       ELSE IF ((OPTION.EQ.'ERZ1_ELEM').OR.
     &         (OPTION.EQ.'ERZ2_ELEM')) THEN
        WRITE(IFI,*)'ERREUR            ABSOLUE'//
     &            '         RELATIVE   NORME DE SIGMA'
        WRITE(IFI,108)' TOTALE          ',ERR0,NU0,NORS
      ELSE
        WRITE(IFI,*)'ERREUR            ABSOLUE'//
     &            '         RELATIVE   NORME DE SIGMA'
        WRITE(IFI,108)' TOTALE          ',ERR0,NU0,NORS
        WRITE(IFI,108)' TERME VOLUMIQUE ',TERMVO,NUVO
        WRITE(IFI,108)' TERME SAUT      ',TERMSA,NUSA
        WRITE(IFI,108)' TERME NORMAL    ',TERMNO,NUNO
      ENDIF
C
108   FORMAT(A17,1P,D16.8,1X,0P,F7.3,' %',1X,1P,D16.8)
109   FORMAT(1P,A17,D16.8)
110   FORMAT(1P,A17,I5)
111   FORMAT(A17,A8)
C
      CALL JEDEMA()
      END
