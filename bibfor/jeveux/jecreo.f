      SUBROUTINE JECREO ( NOMLU , LISTAT )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER *(*)      NOMLU , LISTAT
C     ==================================================================
      PARAMETER  ( N = 5 )
C
      CHARACTER*2      DN2
      CHARACTER*5      CLASSE
      CHARACTER*8                  NOMFIC    , KSTOUT    , KSTINI
      COMMON /KFICJE/  CLASSE    , NOMFIC(N) , KSTOUT(N) , KSTINI(N) ,
     &                 DN2(N)
C     ------------------------------------------------------------------
      INTEGER          LTYP    , LONG    , DATE    , IADD    , IADM    ,
     &                 LONO    , HCOD    , CARA    , LUTI    , IMARQ
      COMMON /IATRJE/  LTYP(1) , LONG(1) , DATE(1) , IADD(1) , IADM(1) ,
     &                 LONO(1) , HCOD(1) , CARA(1) , LUTI(1) , IMARQ(1)
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     &                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
      CHARACTER*1      GENR    , TYPE
      CHARACTER*4      DOCU
      CHARACTER*8      ORIG
      CHARACTER*32     RNOM
      COMMON /KATRJE/  GENR(8) , TYPE(8) , DOCU(2) , ORIG(1) , RNOM(1)
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)
C     ------------------------------------------------------------------
      INTEGER          ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      COMMON /IATCJE/  ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
C     ------------------------------------------------------------------
      INTEGER          LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
C     ------------------------------------------------------------------
      CHARACTER *75    CMESS
      CHARACTER *1     TYPEI , GENRI
      INTEGER          NV , ICRE , IRET
      PARAMETER      ( NV = 3 )
      INTEGER          LVAL(NV)
      CHARACTER *8     CVAL(NV)
      CHARACTER *32    NOML32
      CHARACTER *4     IFMT
C     ------------------------------------------------------------------
      IF ( LEN(NOMLU) .GT. 24 ) THEN
         CMESS = 'NOM D''OBJET SIMPLE > 24 CARACTERES'
         CALL U2MESK('S','JEVEUX_01',1,CMESS)
      ENDIF
      NOML32 = NOMLU(1:MIN(24,LEN(NOMLU)))
C
      CALL JJANAL (  LISTAT  , NV , NV , LVAL , CVAL )
      ICLAS  = INDEX ( CLASSE , CVAL(1)(1:1) )
      IF ( ICLAS .EQ. 0 ) THEN
        CMESS  = ' LA BASE DEMANDEE '//CVAL(1)(1:1)//
     &           ' N''EST PAS OUVERTE'
        CALL U2MESK('S','JEVEUX_01',1,CMESS)
      END IF
C
      ICRE = 1
      CALL JJVERN ( NOML32 , ICRE , IRET )
C
      IF ( IRET .EQ. 2 ) THEN
         CMESS = 'NOM DEJA UTILISE POUR UNE COLLECTION'
         CALL U2MESK('S','JEVEUX_01',1,CMESS)
      ELSE
         GENR(JGENR(ICLAOS)+IDATOS) = CVAL(2)(1:1)
         TYPE(JTYPE(ICLAOS)+IDATOS) = CVAL(3)(1:1)
         IF ( CVAL(3)(1:1) .EQ. 'K' .AND. LVAL(3) .EQ. 1 ) THEN
           CMESS  = ' LTYP D''UN OBJET DE TYPE K NON DEFINI'
           CALL U2MESK('S','JEVEUX_01',1,CMESS)
         ELSE
           GENRI = GENR ( JGENR(ICLAOS) + IDATOS )
           TYPEI = TYPE ( JTYPE(ICLAOS) + IDATOS )
           IF ( GENRI .EQ. 'N' .AND. TYPEI .NE. 'K' ) THEN
             CMESS = 'UN OBJET REPERTOIRE DOIT ETRE DE TYPE K'
             CALL U2MESK('S','JEVEUX_01',1,CMESS)
           ENDIF
           IF      ( TYPEI .EQ. 'K' ) THEN
             WRITE(IFMT,'(''(I'',I1,'')'')') LVAL(3) - 1
             READ ( CVAL(3)(2:LVAL(3)) , IFMT ) IV
             IF ( IV .LE. 0 .OR. IV .GT. 512 ) THEN
               CMESS = 'LTYP D'' OBJET DE TYPE K INVALIDE >'//
     &                  CVAL(3)(1:LVAL(3)-1)
               CALL U2MESK('S','JEVEUX_01',1,CMESS)
             ENDIF
             IF ( GENRI .EQ. 'N' ) THEN
               IF ( MOD ( IV , LOIS ) .NE. 0 ) THEN
                 CMESS = 'LTYP D'' OBJET REPERTOIRE NON MULTIPLE DE K8'
                 CALL U2MESK('S','JEVEUX_01',1,CMESS)
               ENDIF
               IF ( IV .GT. 24 ) THEN
                 CMESS = 'LTYP D''OBJET REPERTOIRE > 24'
                 CALL U2MESK('S','JEVEUX_01',1,CMESS)
               ENDIF
             ENDIF
           ELSE IF ( TYPEI .EQ. 'I' ) THEN
             IV = LOIS
           ELSE IF ( TYPEI .EQ. 'R' ) THEN
             IV = LOR8
           ELSE IF ( TYPEI .EQ. 'C' ) THEN
             IV = LOC8
           ELSE IF ( TYPEI .EQ. 'L' ) THEN
             IV = LOLS
           ELSE IF ( TYPEI .EQ. 'S' ) THEN
             IV = LOR8/2
           ELSE
             CMESS = 'TYPE INVALIDE '//CVAL(3)(1:LVAL(3))
             CALL U2MESK('S','JEVEUX_01',1,CMESS)
           ENDIF
           LTYP ( JLTYP(ICLAOS) + IDATOS ) = IV
         ENDIF
         IF ( CVAL(2)(1:1) .EQ. 'E' ) THEN
            LONG(JLONG(ICLAOS)+IDATOS) = 1
            LONO(JLONO(ICLAOS)+IDATOS) = 1
         ENDIF
      ENDIF
C
      END
