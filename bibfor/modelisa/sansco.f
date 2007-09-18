      SUBROUTINE SANSCO(CHAR  ,MOTFAC ,NOMA  ,NZOCO ,NNOCO ,NMACO ,
     &                  FORM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 17/09/2007   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C REPONSABLE
C
      IMPLICIT      NONE
      CHARACTER*8   CHAR
      CHARACTER*16  MOTFAC
      CHARACTER*8   NOMA
      INTEGER       NZOCO
      INTEGER       NNOCO,NMACO
      INTEGER       FORM
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES MAILLEES - LECTURE DONNEES)
C
C LECTURE: DES NOEUDS DANS LE MOT-CLEF SANS_GROUP_NO
C          DES MAILLES DANS LE MOT-CLEF SANS_GROUP_MA (METHODE='VERIF')
C      
C ----------------------------------------------------------------------
C
C
C NB: - ON ELIMINE LES NOEUDS N'APPARTENANT PAS AUX SURFACES DE CONTACT
C     - ON ELIMINE LES NOEUDS DU FOND DE FISSURE POUR LA METHODE 'VERIF'
C 
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
C IN  NOMA   : NOM DU MAILLAGE
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C IN  NNOCO  : NOMBRE TOTAL DE NOEUDS DES SURFACES
C IN  NMACO  : NOMBRE TOTAL DE MAILLES DES SURFACES
C IN  FORM   : TYPE DE FORMULATION (DISCRET/CONTINUE/XFEM)
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
      CHARACTER*32 JEXNUM
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------

      CHARACTER*24 SANSN,PSANS,BARSMA,PBARM
      CHARACTER*8  K8B
      INTEGER      NUMSUR,ZMETH,JMETH,I,IZOCOV,NZVERI,CFMMVD,JSANSN
      INTEGER      NSANSN
C
C ----------------------------------------------------------------------
C
C
C --- INITIALISATIONS
C
      IF (FORM.EQ.1) THEN
        NUMSUR = 2
      ELSEIF (FORM.EQ.2) THEN
        NUMSUR = 1 
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF   
      NUMSUR = 0
C
C --- TRAITEMENT MOT-CLEF SANS_GROUP_NO/SANS_NOEUD
C
      SANSN  = CHAR(1:8)//'.CONTACT.SSNOCO'
      PSANS  = CHAR(1:8)//'.CONTACT.PSSNOCO'
      CALL SANSNO(CHAR  ,MOTFAC ,NOMA  ,NZOCO ,NNOCO ,
     &            'SANS_GROUP_NO','SANS_NOEUD',
     &            SANSN,PSANS,NUMSUR) 
C
C
C --- TRAITEMENT MOT-CLEF GROUP_MA_FOND/MAILLE_FOND (METHODE 'VERIF')
C
C     ON VERIFIE QUE TOUTES LES ZONES ONT LA METHODE 'VERIF'
      ZMETH=CFMMVD('ZMETH')
      CALL JEVEUO(CHAR(1:8)//'.CONTACT.METHCO','L',JMETH)
      NZVERI=0
      DO 10 I=1,NZOCO
        IF(ZI(JMETH+ZMETH*(I-1)+6).EQ.-2)THEN
           NZVERI=NZVERI+1
        ENDIF
 10   CONTINUE
C
      IF(NZVERI.GT.0)THEN
        CALL ASSERT(NZVERI.EQ.NZOCO)
        CALL SANSNM(CHAR  ,MOTFAC ,NOMA  ,NZOCO ,NNOCO ,
     &            'GROUP_MA_FOND',SANSN,PSANS,NUMSUR) 
      ENDIF



      END
