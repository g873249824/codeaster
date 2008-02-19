      SUBROUTINE FOINTN ( IPIF, NOMF, RVAR, INUME, EPSI, RESU, IER )
      IMPLICIT NONE
      INTEGER             IPIF, INUME, IER
      REAL*8              RVAR, EPSI, RESU
      CHARACTER*(*)       NOMF
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 19/02/2008   AUTEUR MACOCCO K.MACOCCO 
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
C     INTERPOLATION DANS LES NAPPES
C     ------------------------------------------------------------------
C IN  : IPIF   : ADRESSE DANS LE MATERIAU CODE DE LA NAPPE
C                = 0 , NAPPE
C IN  : NOMF   : NOM DE LA NAPPE SI IPIF=0
C IN  : RVAR   : VALEUR DE LA VARIABLE  "UTILISATEUR"
C IN  : INUME  : NUMERO DE LA FONCTION
C OUT : RESU   : RESULTAT
C OUT : IER    : CODE RETOUR
C     ------------------------------------------------------------------
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM
      INTEGER       ZI
      COMMON/IVARJE/ZI(1)
      REAL*8        ZR
      COMMON/RVARJE/ZR(1)
      COMPLEX*16    ZC
      COMMON/CVARJE/ZC(1)
      LOGICAL       ZL
      COMMON/LVARJE/ZL(1)
      CHARACTER*8   ZK8
      CHARACTER*16         ZK16
      CHARACTER*24                 ZK24
      CHARACTER*32                         ZK32
      CHARACTER*80                                 ZK80
      COMMON/KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      INTEGER       LPROL, LVAR, NBPT, JPRO, NBPCUM, I, IPT, LFON
      CHARACTER*1   K1BID, COLI
      CHARACTER*16  PROLGD
      CHARACTER*19  NOMFON
      CHARACTER*24  INTERP, CHPROL, CHVALE
C     ------------------------------------------------------------------
      CALL JEMARQ()
      NOMFON = NOMF
      IF ( IPIF .EQ. 0 ) THEN
         CHVALE = NOMFON//'.VALE'
         CHPROL = NOMFON//'.PROL'
         CALL JEVEUO(CHPROL,'L',LPROL)
         CALL FOPRO1(ZK24(LPROL),INUME,PROLGD,INTERP)
         CALL JEVEUO(JEXNUM(CHVALE,INUME),'L',LVAR)
         CALL JELIRA(JEXNUM(CHVALE,INUME),'LONMAX',NBPT,K1BID)
      ELSE
         JPRO   = ZI(IPIF+1)
         PROLGD = ZK24(JPRO+6+ (2*INUME))
         INTERP = ZK24(JPRO+6+ (2*INUME-1))
         NBPCUM = 0
         DO 10 I = 1,INUME - 1
            NBPCUM = NBPCUM + ZI(ZI(IPIF+3)+I) - ZI(ZI(IPIF+3)+I-1)
 10      CONTINUE
         NBPT = ZI(ZI(IPIF+3)+INUME) - ZI(ZI(IPIF+3)+INUME-1)
         LVAR = ZI(IPIF+2) + NBPCUM
      ENDIF
      NBPT = NBPT / 2
      LFON = LVAR + NBPT
      IPT = 1
C
      CALL FOLOCX (ZR(LVAR),NBPT,RVAR,PROLGD,IPT,EPSI,COLI,IER)
      IF ( IER .NE. 0 ) GOTO 9999
      CALL FOCOLI ( IPT,COLI,INTERP,ZR(LVAR),ZR(LFON),RVAR,RESU,IER )
      IF ( IER .NE. 0 ) GOTO 9999
C
 9999 CONTINUE
C
      CALL JEDEMA()
      END
