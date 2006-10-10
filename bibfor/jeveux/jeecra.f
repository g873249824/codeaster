      SUBROUTINE JEECRA ( NOMLU , CATR , IVAL , CVAL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 10/10/2006   AUTEUR VABHHTS J.PELLET 
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
C TOLE CFT_726 CFT_720 CRP_18 CRS_508
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER *(*)      NOMLU , CATR        , CVAL
      INTEGER                            IVAL
C ----------------------------------------------------------------------
C ROUTINE UTILISATEUR D'AFFECTATION D'UN ATTRIBUT
C
C IN  NOMLU  : NOM DE L'OBJET JEVEUX
C IN  CATR   : NOM DE L'ATTRIBUT
C IN  IVAL   : VALEUR EN ENTIER DE L'ATTRIBUT
C IN  CVAL   : VALEUR EN CARACTERE DE L'ATTRIBUT
C
C ----------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
C     ------------------------------------------------------------------
      INTEGER          ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
      COMMON /IATCJE/  ICLAS ,ICLAOS , ICLACO , IDATOS , IDATCO , IDATOC
C     ------------------------------------------------------------------
      PARAMETER  ( N = 5 )
      INTEGER          LTYP    , LONG    , DATE    , IADD    , IADM    ,
     &                 LONO    , HCOD    , CARA    , LUTI    , IMARQ
      COMMON /IATRJE/  LTYP(1) , LONG(1) , DATE(1) , IADD(1) , IADM(1) ,
     &                 LONO(1) , HCOD(1) , CARA(1) , LUTI(1) , IMARQ(1)
      COMMON /JIATJE/  JLTYP(N), JLONG(N), JDATE(N), JIADD(N), JIADM(N),
     &                 JLONO(N), JHCOD(N), JCARA(N), JLUTI(N), JMARQ(N)
C
      CHARACTER*1      GENR    , TYPE
      CHARACTER*4      DOCU
      CHARACTER*8      ORIG
      CHARACTER*32     RNOM
      COMMON /KATRJE/  GENR(8) , TYPE(8) , DOCU(2) , ORIG(1) , RNOM(1)
      COMMON /JKATJE/  JGENR(N), JTYPE(N), JDOCU(N), JORIG(N), JRNOM(N)
C
      INTEGER          LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
C     ------------------------------------------------------------------
      CHARACTER *75   CMESS
      CHARACTER *32   NOML32
      CHARACTER *1    GENRI , TYPEI
      CHARACTER *8    CATRLU
      LOGICAL         LCONST , LCONTI , LLONG , LLUTI
      INTEGER         ICRE , IRET , ITAB(1) , JTAB
      INTEGER         IBACOL , IXIADD , IXDESO , IXLONG
C     ------------------------------------------------------------------
      INTEGER        IVNMAX     , IDDESO     ,IDIADD     ,
     &               IDLONG     ,
     &               IDLONO     , IDLUTI
      PARAMETER    ( IVNMAX = 0 , IDDESO = 1 ,IDIADD = 2 ,
     &               IDLONG = 7 ,
     &               IDLONO = 8 , IDLUTI = 9 )
      INTEGER          ILOREP , IDENO , ILNOM , ILMAX , ILUTI , IDEHC
      PARAMETER      ( ILOREP=1,IDENO=2,ILNOM=3,ILMAX=4,ILUTI=5,IDEHC=6)
C DEB ------------------------------------------------------------------
            IF ( IGUARD .EQ. 0 ) THEN
               IGUARD = 1
            ELSE
               IGUARD = IGUARD + 1
            END IF
      CATRLU = CATR
      NOML32 = NOMLU
C
C --- CAS GENERAL
C
      ICRE = 0
      CALL JJVERN ( NOML32 , ICRE , IRET )
C
      IF ( IRET .EQ. 0 ) THEN
        CMESS = 'OBJET INEXISTANT DANS LES BASES OUVERTES'
        CALL U2MESK('F','JEVEUX_01',1,CMESS)
      ELSE IF ( IRET .EQ. 1 ) THEN
        IC     = ICLAOS
        ID     = IDATOS
        LCONST = .TRUE.
        LCONTI = .FALSE.
        IXLONG = ID
        IXLONO = ID
        IXLUTI = ID
      ELSE
        IC     = ICLACO
        ID     = IDATCO
        CALL JJALLC (IC , ID , 'E' , IBACOL)
        IF ( NOML32(25:32) .NE. '        ' ) THEN
           IRET = 3
           CALL JJCROC ( NOML32(25:32) , ICRE )
        ENDIF
        IXDESO  = ISZON ( JISZON + IBACOL + IDDESO )
        ID      = IXDESO
        IXIADD  = ISZON ( JISZON + IBACOL + IDIADD )
        LCONTI  = ( IXIADD .EQ. 0 )
        IXLONG  = ISZON ( JISZON + IBACOL + IDLONG )
        IXLONO  = ISZON ( JISZON + IBACOL + IDLONO )
        IXLUTI  = ISZON ( JISZON + IBACOL + IDLUTI )
        LCONST  = (IXLONG .EQ. 0 )
        NMAXI   = ISZON (JISZON + IBACOL + IVNMAX )
      ENDIF
C
      GENRI = GENR ( JGENR(IC) + ID )
      TYPEI = TYPE ( JTYPE(IC) + ID )
      IF ( CATRLU .EQ. 'LONT    ' ) THEN
         IF ( .NOT. LCONTI ) THEN
           CMESS= 'ATTRIBUT '//CATRLU//
     &            ' UNIQUEMENT POUR COLLECTION CONTIGUE'
           CALL U2MESK('F','JEVEUX_01',1,CMESS)
         ELSE
           LLONG = .FALSE.
           LLUTI = .FALSE.
         ENDIF
      ELSE
         LLONG = ( CATRLU(4:6) .EQ. 'MAX' )
         LLUTI = ( CATRLU(4:6) .EQ. 'UTI' )
         IF((GENRI .NE. 'N'          .AND. CATRLU(1:3).EQ. 'NOM')  .OR.
     &      (GENRI .EQ. 'N'          .AND. CATRLU(1:4).EQ. 'NOMU')  .OR.
     &      (GENRI .NE. 'V'          .AND. CATRLU(1:4).EQ. 'LONM') .OR.
     &      (GENRI .NE. 'V'          .AND. CATRLU(1:4).EQ. 'LONU')) THEN
             CMESS= 'NOM D''ATTRIBUT '//CATRLU//
     &             ' INCOMPATIBLE AVEC LE GENRE '//GENRI
             CALL U2MESK('F','JEVEUX_01',1,CMESS)
         ENDIF
      ENDIF
C
      IF ( CATRLU .EQ. 'LONT    '  .AND. LCONTI ) THEN
        LONO( JLONO(IC) + ID ) = IVAL
        IF ( LCONST ) LONG( JLONG(IC) + ID ) = IVAL / NMAXI
      ELSE IF ( CATRLU .EQ. 'DATE    ' ) THEN
        DATE ( JDATE(IC) + ID ) = IVAL
      ELSE IF ( CATRLU .EQ. 'DOCU    ' ) THEN
        DOCU ( JDOCU(IC) + ID ) = CVAL
      ELSE IF ( CATRLU .EQ. 'ORIG    ' ) THEN
        ORIG ( JORIG(IC) + ID ) = CVAL
      ELSE IF ( LCONST ) THEN
        IF ( LLONG ) THEN
          LONOI = LONO ( JLONO(IC) + ID )
          IF ( CATRLU.EQ.'LONMAX  ' .OR. CATRLU.EQ.'NOMMAX  ' ) THEN
            LONGI = LONG ( JLONG(IC) + ID )
            LONGJ = IVAL
          ENDIF
          IF ( LONGI .NE. 0 ) THEN
            CMESS = 'ATTRIBUT '//CATRLU//
     &              ' NON MODIFIABLE OU DEJA DEFINI'
            CALL U2MESK('F','JEVEUX_01',1,CMESS)
          ELSE
            LONG ( JLONG(IC) + ID ) = LONGJ
            IF ( LONOI .NE. 0 .AND. IRET .EQ. 1 ) THEN
              CMESS = 'ATTRIBUT '//CATRLU//
     &                ' NON MODIFIABLE OU DEJA DEFINI POUR UN O.S.'
              CALL U2MESK('F','JEVEUX_01',1,CMESS)
            ELSE
              IF ( GENRI .EQ. 'V' ) THEN
                LONO ( JLONO(IC) + ID ) = LONGJ
              ELSE IF ( GENRI .EQ. 'N' ) THEN
                LTYPI = LTYP ( JLTYP(IC) + ID )
                LONOK = (IDEHC + JJPREM(LONGJ))*LOIS + (LONGJ+1)*LTYPI
                IF ( MOD(LONOK,LTYPI) .GT. 0 ) THEN
                   LONOK = (LONOK/LTYPI + 1 )
                ELSE
                   LONOK = LONOK/LTYPI
                ENDIF
                LONO ( JLONO(IC) + ID ) = LONOK
                LUTI ( JLUTI(IC) + ID ) = 0
                IF ( IADM(JIADM(IC)+ID) .EQ. 0 ) THEN
                  NBL = LONOK*LTYPI
                  CALL JJALLS(NBL,GENRI,TYPEI,LTYPI,'INIT',
     &                        ITAB,JTAB,IADMI)
                  IADM(JIADM(IC)+ID) = IADMI
                  CALL JJECRS(IADMI,IC,ID,0,'E',IMARQ(JMARQ(IC)+2*ID-1))
                  NHC = JJPREM(IVAL)
                  JITAB = JISZON + IADMI - 1
                  ISZON(JITAB + ILOREP ) = NHC
                  ISZON(JITAB + IDENO  ) = (IDEHC+NHC)*LOIS
                  ISZON(JITAB + ILNOM  ) = LTYPI
                  ISZON(JITAB + ILMAX  ) = IVAL
                  ISZON(JITAB + ILUTI  ) = 0
                  ISZON(JITAB + IDEHC  ) = IDEHC
                END IF
              ENDIF
              IF ( LCONTI ) THEN
                IF(LONOI.NE.0.AND.LONOI.LT.NMAXI*LONO(JLONO(IC)+ID))THEN
                  CMESS = 'ATTRIBUT '//CATRLU//
     &                    ' NON COMPATIBLE AVEC VALEUR DE LONT'
                  CALL U2MESK('F','JEVEUX_01',1,CMESS)
                ELSE
                  LONO (JLONO(IC)+ID) = NMAXI * LONO ( JLONO(IC) + ID )
                ENDIF
              ENDIF
            ENDIF
          ENDIF
        ELSE IF ( LLUTI ) THEN
          IF ( CATRLU.EQ.'LONUTI  ' ) THEN
            LUTI ( JLUTI(IC) + ID ) = IVAL
          ENDIF
        ELSE
          CMESS = 'NOM D''ATTRIBUT '//CATRLU//' NON ACCESSIBLE'
          CALL U2MESK('F','JEVEUX_01',1,CMESS)
        ENDIF
      ELSE IF ( IRET .EQ. 3 ) THEN
        IF ( LLONG .AND. .NOT. LCONST ) THEN
          IBLONG = IADM ( JIADM(IC) + IXLONG )
          IBLONO = IADM ( JIADM(IC) + IXLONO )
          IF ( LCONTI ) THEN
            IF ( IDATOC .EQ. 1 ) THEN
              IF ( ISZON (JISZON+IBLONO-1+IDATOC) .EQ. 0 ) THEN
                ISZON (JISZON+IBLONO-1+IDATOC) = 1
              ENDIF
            ENDIF
            IL1 = JISZON + IBLONO - 1 + IDATOC + 1
            IL0 = JISZON + IBLONO - 1 + IDATOC
            IF ( ISZON(IL0) .EQ. 0 ) THEN
               CMESS = 'COLLECTION CONTIG: DEFINIR '//CATRLU//
     &                 ' DANS L''ORDRE D''INSERTION DES OBJETS'
               CALL U2MESK('F','JEVEUX_01',1,CMESS)
            ELSE
              LONTI = ISZON(IL0)
              LONOI = 0
              IF ( ISZON(IL1) .NE. 0 ) THEN
                LONTI = MAX ( ISZON(IL1) , ISZON(IL0) )
                LONOI = MAX ( ISZON ( IL1 ) - ISZON(IL0) , 0 )
              ENDIF
            ENDIF
          ELSE
            LONOI  = ISZON ( JISZON + IBLONO - 1 + IDATOC )
          ENDIF
          IF ( LONOI .NE. 0 ) THEN
            CMESS = 'ATTRIBUT '//CATRLU//
     &              ' NON MODIFIABLE OU DEJA DEFINI LONO NON NUL'
            CALL U2MESK('F','JEVEUX_01',1,CMESS)
          ENDIF
          IF ( CATRLU.EQ.'LONMAX  ' ) THEN
            LONGI = ISZON ( JISZON + IBLONG - 1 + IDATOC )
            LONGJ  = IVAL
            LONOJ = LONGJ
          ENDIF
          IF ( LONGI .NE. 0 ) THEN
            CMESS ='ATTRIBUT '//CATRLU//' NON MODIFIABLE OU DEJA DEFINI'
            CALL U2MESK('F','JEVEUX_01',1,CMESS)
          ELSE
            IF ( LCONTI ) THEN
              IF ( LONOI .NE. 0 .AND. LONTI + LONOJ .GT. LONOI ) THEN
                CMESS = 'ATTRIBUT '//CATRLU//' INCOMPATIBLE AVEC VALEUR'
     &                  //' INITIALE DE LONT'
                CALL U2MESK('F','JEVEUX_01',1,CMESS)
              ELSE
                ISZON(JISZON+IBLONO-1+IDATOC+1) = LONTI + LONOJ
              ENDIF
            ELSE
              ISZON(JISZON+IBLONO-1+IDATOC) = LONOJ
            ENDIF
            ISZON(JISZON+IBLONG-1+IDATOC) = LONGJ
C           IF ( LONOJ .NE. 0 ) THEN
              LUTI ( JLUTI(IC)+IXLONO ) = 1 + LUTI( JLUTI(IC)+IXLONO )
C           ENDIF
          ENDIF
        ELSE IF ( LLUTI ) THEN
          IBLUTI = IADM ( JIADM(IC) + IXLUTI )
          IF ( CATRLU.EQ.'LONUTI  ' ) THEN
            ISZON ( JISZON + IBLUTI - 1 + IDATOC ) = IVAL
          ENDIF
        ENDIF
      ELSE
        CMESS = 'NOM D''ATTRIBUT '//CATRLU//' NON ACCESSIBLE'
        CALL U2MESK('F','JEVEUX_01',1,CMESS)
      ENDIF
C FIN ------------------------------------------------------------------
            IF ( IGUARD .EQ. 1 ) THEN
               IGUARD = 0
            ELSE
               IGUARD = IGUARD - 1
            END IF
      END
