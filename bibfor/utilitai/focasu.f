      SUBROUTINE FOCASU( NBFON , NOMFON , COEF , COEFZ,
     .           CCPLX,FCPLX,NOMPAR, SORTIE, BASE, TYPE)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER                    NBFON
      CHARACTER*(*)      SORTIE,         NOMFON(*), NOMPAR,TYPE
      REAL*8                              COEF(*)
      COMPLEX*16 COEFZ(*)
      LOGICAL CCPLX(*),FCPLX(*)
      CHARACTER*1                                                BASE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 17/12/2002   AUTEUR CIBHHGB G.BERTRAND 
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
C     MEDISIS:  COMBINAISON LINEAIRE DE FONCTIONS
C                            OU DE NAPPE DE MEME VALEUR DE PARAMETRES
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*8   CBID
      CHARACTER*16  PROREF, TYPREF, VARREF
      CHARACTER*16 NOMCMD
      CHARACTER*24 PROL, PARA
C     ----------------------------------------------------------------
C
C     ------------------------------------------------------------------
C     --- VERIFICATION DE COHERENCE DU NOM_PARA                      ---
C     --- VERIFICATION QUE L'ON A QUE DES NAPPES OU DES FONCTIONS    ---
C     --- SI NAPPE VERIFICATION QUE L'ON A BIEN LES MEMES VARIABLES  ---
C     ------------------------------------------------------------------
      CALL JEMARQ()
      PARA(20:24) = '.PARA'
      PROL(20:24) = '.PROL'
C
      PROL( 1:19) = NOMFON(1)
      PARA( 1:19) = NOMFON(1)
      CALL JEVEUO(PROL,'L',LPRO)
      TYPREF =  ZK16(LPRO)
      PROREF =  ZK16(LPRO+2)
      FCPLX(1)=ZK16(LPRO).EQ.'FONCT_C'
      IF ( TYPREF .EQ. 'NAPPE' ) THEN
         VARREF = ZK16(LPRO+5)
         CALL JELIRA(PARA,'LONMAX',NBPARF,CBID)
         CALL JEVEUO(PARA,'L',LPAREF)
      ENDIF
      CALL JELIBE(PROL)
      IER = 0
      DO 100 IOCC = 2, NBFON
         PROL(1:19) = NOMFON(IOCC)
         CALL JEVEUO(PROL,'L',LPRO)
         IF ( ZK16(LPRO+2) .NE. PROREF ) THEN
            IER = IER + 1
            CALL GETRES(CBID,CBID,NOMCMD)
            CALL UTMESS('E',NOMCMD//'.FOCASU',
     +                      'LA FONCTION "'//PROL(1:19)//'" A POUR '//
     +                      '"NOM_PARA": "'//ZK16(LPRO+2)//'" ALORS '//
     +                      'QUE L''ON ATTENDAIT "'//PROREF//'".   ')
         ENDIF
         FCPLX(IOCC)=ZK16(LPRO).EQ.'FONCT_C'
         IF ( ZK16(LPRO)(:5) .NE. TYPREF(:5) ) THEN
            IER = IER + 1
            CALL GETRES(CBID,CBID,NOMCMD)
            CALL UTMESS('E',NOMCMD//'.FOCASU',
     +                      'LA FONCTION "'//PROL(1:19)//'" A POUR '//
     +                      '"TYPE": "'//ZK16(LPRO)//'" ALORS '//
     +                'QUE L''ON ATTENDAIT "'//TYPREF(:5)//'...".   ')
         ENDIF
         IF ( TYPREF .EQ. 'NAPPE' ) THEN
            IF ( ZK16(LPRO+5) .NE. VARREF ) THEN
               IER = IER + 1
               CALL GETRES(CBID,CBID,NOMCMD)
               CALL UTMESS('E',NOMCMD//'.FOCASU',
     +                      'LA FONCTION "'//PROL(1:19)//'" A POUR '//
     +                      '"VARIABLE": "'//ZK16(LPRO+5)//'" ALORS '//
     +                      'QUE L''ON ATTENDAIT "'//VARREF//'".   ')
            ENDIF
            PARA( 1:19) = NOMFON(1)
            CALL JELIRA(PARA,'LONMAX',NBPAR,CBID)
            CALL JEVEUO(PARA,'L',LPARA)
            IF ( NBPAR .NE. NBPARF ) THEN
               IER = IER + 1
               CALL GETRES(CBID,CBID,NOMCMD)
               CALL UTDEBM('E',NOMCMD//'.FOCASU',
     +                     'LA FONCTION "'//PROL(1:19)//'" A ')
               CALL UTIMPI('S',' ',1,NBPAR)
               CALL UTIMPI('S','VALEUR(S) DE "VARIABLE" ALORS QUE '
     +                       //'L''ON EN ATTENDAIT ',1,NBPARF)
               CALL UTFINM()
            ENDIF
            DO 130 I = 0,MIN(NBPARF,NBPAR)-1
               IF ( ZR(LPAREF+I) .NE. ZR(LPARA+I) ) THEN
                  IER = IER + 1
                  CALL GETRES(CBID,CBID,NOMCMD)
                  CALL UTDEBM('E',NOMCMD//'.FOCASU',
     +                      'LA FONCTION "'//PROL(1:19)//'" A POUR '//
     +                      'VALEUR DE "VARIABLE" ' )
                  CALL UTIMPR('S',' ',1,ZR(LPARA+I) )
                  CALL UTIMPR('S','ALORS QUE  L''ON ATTENDAIT '//
     +                            'LA VALEUR ',1,ZR(LPAREF+I)  )
                  CALL UTFINM()
               ENDIF
 130        CONTINUE
            CALL JELIBE(PARA)
         ENDIF
         CALL JELIBE(PROL)
 100  CONTINUE
      PARA( 1:19) = NOMFON(1)
      IF ( TYPREF .EQ. 'NAPPE' ) CALL JELIBE(PARA)
C
      IF (IER .GT. 0 )
     +      CALL UTMESS('F',NOMCMD//'.FOCASU',' CORRIGEZ VOS ERREURS.')
C
C     --- COMBINAISON LINEAIRE SELON LE SOUS-TYPE ---
      IF (TYPREF (:5).EQ. 'FONCT' ) THEN
         CALL FOC1SU ( SORTIE, NBFON, NOMFON, COEF, COEFZ,TYPE,
     .   CCPLX, FCPLX, NOMPAR, BASE )
      ELSEIF (TYPREF .EQ. 'NAPPE' ) THEN
         CALL FOC2SU (SORTIE, NBPARF, NBFON, NOMFON, COEF,NOMPAR, BASE)
      ENDIF
      CALL JEDEMA()
      END
