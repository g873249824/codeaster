      SUBROUTINE ASRETI(IATMP2,IREEL,IDHCOL,IDADIA,IDABLO,IADLI,IADCO,
     +                  NUMBL)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           IATMP2,IREEL,IDHCOL,IDADIA,IDABLO,IADLI,IADCO
      INTEGER           NUMBL
C----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 02/10/95   AUTEUR GIBHHAY A.Y.PORTABILITE 
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
C     ROUTINE SERVANT A RETENIR OU S'ACCUMULENT LES TERMES ELEMENTAIRES:
C     DANS LE CAS D'UN STOCKAGE LIGN_CIEL
C----------------------------------------------------------------------
C OUT I IATMP2 : ADRESSE JEVEUX DE L'OBJET ".TMP2" MODIFIE.
C IN  I IATMP2 : ADRESSE JEVEUX DE L'OBJET ".TMP2".
C IN  I IREEL   : INDICE DU REEL A RETENIR (DANS UNE MATR_ELEM).
C IN  I IDHCOL  : ADRESSE DE ".HCOL".
C IN  I IDADIA  : ADRESSE DE ".ADIA".
C IN  I IDABLO  : ADRESSE DE ".ABLO".
C IN  I IADLI   : NUMERO GLOBAL DE LA LIGNE.
C IN  I IADCO   : NUMERO GLOBAL DE LA COLONNE.
C IN  I NUMBL   : NUMERO DU BLOC OU VA S'INJECTER LE REEL.
C----------------------------------------------------------------------
C     FONCTIONS JEVEUX
C----------------------------------------------------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C----------------------------------------------------------------------
C     COMMUNS   JEVEUX
C----------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
C
      INTEGER HCOL,ADIA
C
C---- DEBUT ---------------------------------------
      IF (IADCO.EQ. (ZI(IDABLO+NUMBL-1)+1)) THEN
         HCOL = ZI(IDHCOL+IADCO-1)
         IADLOC = IADLI - (IADCO-HCOL+1) + 1
      ELSE
         HCOL = ZI(IDHCOL+IADCO-1)
         ADIA = ZI(IDADIA+IADCO-2)
         IADLOC = ADIA + IADLI - (IADCO-HCOL+1) + 1
      END IF
C
C     -- IREEL COMPTE LES REELS TRAITES:
      IREEL = IREEL + 1
      ZI(IATMP2-1+2* (IREEL-1)+1) = NUMBL
      ZI(IATMP2-1+2* (IREEL-1)+2) = IADLOC
C
 9999 CONTINUE
      END
