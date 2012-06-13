      SUBROUTINE JJLIHD (IDTS,NBVAL,LONOI,GENRI,TYPEI,LTYPI,
     &                   IC,IDO,IDC,IMARQ,IADMI,IADYN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
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
C TOLE CRP_18 CRP_4 CRS_508 CRS_513 CRS_505
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER            IDTS,NBVAL,LONOI,LTYPI,IC,IDO,IDC,IMARQ,IADMI
      CHARACTER*(*)      GENRI,TYPEI
C ----------------------------------------------------------------------
C RELIT UN SEGMENT DE VALEURS DANS UN FICHIER HDF EN FONCTION DU TYPE
C ASSOCIE : SIMPLE DEBRANCHEMENT POUR FAIRE TOUJOURS PASSER UN TABLEAU
C DE TYPE INTEGER EN ARGUMENT.
C LE TYPE INTEGER EST TRAITE DE FACON PARTICULIERE POUR S'AJUSTER
C A LA PLATE-FORME
C L'ETAT ET LE STATUT DU SEGMENT DE VALEURS SONT ACTUALISES
C
C IN  IDTS  : IDENTIFICATEUR DU DATASET HDF
C IN  NBVAL  : NOMBRE DE VALEURS DU DATASET
C IN  LONOI  : LONGEUR EN OCTET DU SEGMENT DE VALEURS
C IN  GENRI  : GENRE DE L'OBJET
C IN  TYPEI  : TYPE DE L'OBJET
C IN  LTYPI  : LONGUEUR DU TYPE
C IN  ID0    : IDENTIFICATEUR DE L'OBJET JEVEUX
C IN  IDC    : IDENTIFICATEUR DE COLLECTION JEVEUX
C IN  IC     : CLASSE DE L'OBJET JEVEUX
C IN  IMARQ  : ADRESSE DE LA MARQUE JEVEUX
C OUT IADMI  : ADRESSE JEVEUX DU SEGMENT DE VALEURS
C OUT IADYN  : ADRESSE DYNAMIQUE DU SEGMENT DE VALEURS
C ----------------------------------------------------------------------
C
C ----------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
      INTEGER          LBIS , LOIS , LOLS , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOR8 , LOC8
      INTEGER          ISTAT
      COMMON /ISTAJE/  ISTAT(4)
      REAL *8          SVUSE,SMXUSE   
      COMMON /STATJE/  SVUSE,SMXUSE  
      CHARACTER*1      TYPEB
      INTEGER          HDFRSV,HDFTSD,ICONV,IADYN,KDYN
      INTEGER          IRET,JADR,KITAB,NBV,IR,LON,KADM,K,IBID,LTYPB
      INTEGER         IZR,IZC,IZL,IZK8,IZK16,IZK24,IZK32,IZK80,IZI4
      EQUIVALENCE    (IZR,ZR),(IZC,ZC),(IZL,ZL),(IZK8,ZK8),(IZK16,ZK16),
     &               (IZK24,ZK24),(IZK32,ZK32),(IZK80,ZK80),(IZI4,ZI4)
C DEB ------------------------------------------------------------------
      IRET = -1
      ICONV = 0
      NBV = NBVAL
      IF ( TYPEI .EQ. 'I' ) THEN
        CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',ZI ,JADR,IADMI,
     &              IADYN)
      ELSE IF ( TYPEI .EQ. 'S' ) THEN
        CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',IZI4,JADR,IADMI,
     &              IADYN)
      ELSE IF ( TYPEI .EQ. 'R' ) THEN
        CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',IZR,JADR,IADMI,
     &              IADYN)
      ELSE IF ( TYPEI .EQ. 'C' ) THEN
        CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',IZC,JADR,IADMI,
     &              IADYN)
        NBV = 2*NBVAL
      ELSE IF ( TYPEI .EQ. 'K' ) THEN
        IF ( LTYPI .EQ. 8 ) THEN
          CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',
     &                IZK8 ,JADR,IADMI,IADYN)
        ELSE IF ( LTYPI .EQ. 16 ) THEN
          CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',
     &                IZK16,JADR,IADMI,IADYN)
        ELSE IF ( LTYPI .EQ. 24 ) THEN
          CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',
     &                IZK24,JADR,IADMI,IADYN)
        ELSE IF ( LTYPI .EQ. 32 ) THEN
          CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',
     &                IZK32,JADR,IADMI,IADYN)
        ELSE IF ( LTYPI .EQ. 80 ) THEN
          CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',
     &                IZK80,JADR,IADMI,IADYN)
        ENDIF
      ELSE IF ( TYPEI .EQ. 'L' ) THEN
        CALL JJALLS(LONOI,IC,GENRI,TYPEI,LTYPI,'INIT',IZL,JADR,IADMI,
     &              IADYN)
      ENDIF
      CALL JJECRS (IADMI,IADYN,IC,IDO,IDC,'E',IMARQ)
      IF ( TYPEI .EQ. 'I' ) THEN
        ICONV = 1
        IRET = HDFTSD(IDTS,TYPEB,LTYPB,IBID)
        IF ( LOIS .LT. LTYPB ) THEN
          LON = NBVAL*LTYPB
          CALL JJALLS(LON,IC,'V',TYPEI,LOIS,'INIT',ZI,JADR,KADM,KDYN)
          ISZON(JISZON+KADM-1) = ISTAT(2)
          ISZON(JISZON+ISZON(JISZON+KADM-4)-4) = ISTAT(4)
          SVUSE = SVUSE + (ISZON(JISZON+KADM-4) - KADM + 4)
          SMXUSE = MAX(SMXUSE,SVUSE)
          IR = ISZON(JISZON + KADM - 3 )
          KITAB = JK1ZON+(KADM-1)*LOIS+IR+1
          IRET = HDFRSV(IDTS,NBV,K1ZON(KITAB),ICONV)
          DO 1 K=1,NBV
            ISZON(JISZON+IADMI-1+K)=ISZON(JISZON+KADM-1+K)
 1        CONTINUE
          CALL JJLIDY ( KDYN , KADM )
        ELSE
          IR = ISZON(JISZON + IADMI - 3 )
          KITAB = JK1ZON+(IADMI-1)*LOIS+IR+1
          IRET = HDFRSV(IDTS,NBV,K1ZON(KITAB),ICONV)
        ENDIF
      ELSE IF ( TYPEI .EQ. 'S' ) THEN
        IR = ISZON(JISZON + IADMI - 3 )
        KITAB = JK1ZON+(IADMI-1)*LOIS+IR+1
        IRET = HDFRSV(IDTS,NBV,K1ZON(KITAB),ICONV)
      ELSE
        IR = ISZON(JISZON + IADMI - 3 )
        KITAB = JK1ZON+(IADMI-1)*LOIS+IR+1
        IRET = HDFRSV(IDTS,NBV,K1ZON(KITAB),ICONV)
      ENDIF
      IF (IRET .NE. 0) THEN
        CALL U2MESS('F','JEVEUX_51')
      ENDIF
C FIN ------------------------------------------------------------------
      END
