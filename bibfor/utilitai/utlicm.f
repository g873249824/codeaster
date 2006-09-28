      SUBROUTINE UTLICM ( NBCMPV, NOMCMP,
     &                    NOMGD, NCMPRF, NOMCMR,
     &                    NCMPVE, NUMCMP, NTNCMP, NTUCMP )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C     UTILITAIRE - CREATION D'UNE LISTE DE COMPOSANTES
C     --                          --       - -
C-----------------------------------------------------------------------
C     ENTREES :
C       NBCMPV : NOMBRE DE COMPOSANTES VOULUES.
C                . S'IL EST NUL, ON PREND TOUTES LES COMPOSANTES
C                . SI NON NUL, ON PREND CELLES DONNEES PAR LE TABLEAU
C                  NOMCP. ON VERIFIE QUE LES NOMS DES COMPOSANTES
C                  SONT VALIDES
C       NOMCMP : NOMS DES COMPOSANTES VOULUES, SI NBCMPV > 0
C       NOMGD  : NOM DE LA GRANDEUR ASSOCIEE AU CHAMP
C       NCMPRF : NOMBRE DE COMPOSANTES DU CHAMP DE REFERENCE
C       NOMCMR : NOMS DES COMPOSANTES DE REFERENCE
C     SORTIES :
C       NCMPVE : NOMBRE DE COMPOSANTES VALIDES.
C       NUMCMP : SD DES NUMEROS DES COMPOSANTES VALIDES
C       NTNCMP : SD DES NOMS DES COMPOSANTES VALIDES (K8)
C       NTUCMP : SD DES UNITES DES COMPOSANTES VALIDES (K16)
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NCMPRF, NBCMPV, NCMPVE
C
      CHARACTER*8 NOMGD
      CHARACTER*(*) NOMCMP(*), NOMCMR(*)
      CHARACTER*(*) NUMCMP, NTNCMP, NTUCMP
C
C 0.2. ==> COMMUNS
C
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER      ZI
      REAL*8       ZR
      COMPLEX*16   ZC
      LOGICAL      ZL
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'UTLICM' )
C
      INTEGER ADNUCM, ADNCMP, ADUCMP
      INTEGER IFM, NIVINF
C
      INTEGER IAUX, JAUX
C
C     RECUPERATION DU NIVEAU D'IMPRESSION
C     -----------------------------------
C
      CALL INFNIV ( IFM, NIVINF )
C
C====
C 1. LISTE DES NUMEROS DES COMPOSANTES VALIDES
C====
C
C 1.1. ==> ALLOCATION DE LA STRUCTURE QUI CONTIENDRA LES
C          NUMEROS DES COMPOSANTES VALIDES
C
      IF ( NBCMPV.EQ.0 ) THEN
        NCMPVE = NCMPRF
      ELSEIF ( NBCMPV.GT.0 ) THEN
        NCMPVE = NBCMPV
      ELSE
        CALL U2MESK('F','UTILITAI5_45',1,NOMGD)
      ENDIF
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,*) NOMPRO, ' : NOMBRE DE COMPOSANTES DEMANDEES : ',
     &                NCMPVE
      ENDIF
C
      CALL WKVECT ( NUMCMP, 'V V I', NCMPVE, ADNUCM )
C
C 1.2. ==> RIEN N'EST PRECISE : ON PREND TOUTES LES COMPOSANTES DANS
C          L'ORDRE DE REFERENCE
C
      IF ( NBCMPV.EQ.0 ) THEN
C
        DO 12 , IAUX = 1 , NCMPVE
          ZI(ADNUCM+IAUX-1) = IAUX
   12   CONTINUE
C
C 1.3. ==> UN EXTRAIT EST DEMANDE : ON CONTROLE LEUR EXISTENCE
C          ON RECUPERE LE NOMBRE DE COMPOSANTES ACCEPTEES ET LEURS
C          NUMEROS DANS LA LISTE OFFICIELLE
C
      ELSE
C
        CALL IRCCMP ( 'A', NOMGD, NCMPRF, NOMCMR, NBCMPV, NOMCMP,
     &                IAUX, ADNUCM )
        IF ( IAUX.NE.NBCMPV ) THEN
          CALL U2MESK('F','UTILITAI5_46',1,NOMGD)
        ENDIF
C
      ENDIF
C
C====
C 2. NOMS ET UNITES DES COMPOSANTES RETENUES
C====
C
      CALL WKVECT ( NTNCMP, 'V V K16', NCMPVE, ADNCMP )
      CALL WKVECT ( NTUCMP, 'V V K16', NCMPVE, ADUCMP )
C
      DO 25 , IAUX = 1 , NCMPVE
        JAUX = ZI(ADNUCM+IAUX-1)
C       CONVERSION DES NOMS DE COMPOSANTES DE K8 EN K16
        ZK16(ADNCMP-1+IAUX) = NOMCMR(JAUX)
C        ZK16(ADUCMP-1+IAUX) = '        '
C                              1234567890123456
        ZK16(ADUCMP-1+IAUX) = '                '
   25 CONTINUE
C
      END
