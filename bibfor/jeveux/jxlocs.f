      SUBROUTINE JXLOCS ( ITAB, GENR, LTYP, LONO, IADM , LDEPS, JITAB)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 10/03/98   AUTEUR VABHHTS J.PELLET 
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
C TOLE CFT_720 CFT_726 CRP_6 CRP_18 CRS_508
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER             ITAB(*),    LTYP, LONO, IADM ,        JITAB
      LOGICAL                                            LDEPS
      CHARACTER *(*)            GENR
C ----------------------------------------------------------------------
C RENVOIE L'ADRESSE DU SEGMENT DE VALEUR PAR RAPPORT A ITAB
C ROUTINE AVEC APPEL SYSTEME : LOC
C
C IN  ITAB   : TABLEAU PAR RAPPORT AUQUEL L'ADRESSE EST RENVOYEE
C IN  GENR   : GENRE DE L'OBJET ASSOCIE
C IN  LTYP   : LONGUEUR DU TYPE DE L'OBJET ASSOCIE
C IN  LONO   : LONGUEUR DU SEGMENT DE VALEUR EN OCTET
C IN  IADM   : ADRESSE MEMOIRE DU SEGMENT DE VALEUR EN OCTET
C IN  LDEPS  : .TRUE. SI ON AUTUORISE LE DEPLACEMENT EN MEMOIRE
C OUT JITAB  : ADRESSE DANS ITAB DU SEGMENT DE VALEUR
C ----------------------------------------------------------------------
      CHARACTER*1      K1ZON
      COMMON /KZONJE/  K1ZON(8)
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON , ISZON(1)
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
      EQUIVALENCE    ( ISZON(1) , K1ZON(1) )
      INTEGER          LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      INTEGER          ILOC
      COMMON /ILOCJE/  ILOC
C
      CHARACTER*75     CMESS
      INTEGER          VALLOC
C DEB-------------------------------------------------------------------
      KADM = IADM
      LADM = ISZON(JISZON + KADM - 3)
      JITAB = 0
      VALLOC = LOC(ITAB)
      IA = ILOC * LOUA + KADM * LOIS - VALLOC * LOUA
      IR = 0
      IF ( MOD(IA,LTYP) .NE. 0 .AND. GENR(1:1) .NE. 'N' ) THEN
        IR = LTYP - ABS(MOD(IA,LTYP))
      ENDIF
      IF ( LTYP .NE. LOIS .AND. GENR(1:1) .NE. 'N' ) THEN
        IF ( IR .NE. LADM ) THEN
          IF ( LDEPS ) THEN
            CALL JXDEPS ( (KADM-1)*LOIS + LADM + 1 ,
     +                    (KADM-1)*LOIS + IR   + 1 , LONO )
          ELSE
            CMESS = 'OBJET CHARACTER DEJA ALLOUE - DEPLACEMENT MEMOIRE'
     +              //' INTERDIT SANS LIBERATION'
            CALL JVMESS ( 'S' , 'JXLOCS01' , CMESS )
          ENDIF
        ENDIF
      ENDIF
      ISZON(JISZON + KADM - 3 ) = IR
      JITAB = 1 + ( IA + IR ) / LTYP
C FIN ------------------------------------------------------------------
      END
