      SUBROUTINE TE0004 ( OPTION , NOMTE )
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2002   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE  O.BOITEAU
C-----------------------------------------------------------------------
C    - FONCTION REALISEE: EXTENSION DU CHAM_ELEM ERRETEMP DES ELEMENTS
C                         AUX NOEUDS PAR ELEMENTS
C                         OPTION : 'ERTH_ELNO_ELEM'
C           (POUR PERMETTRE NOTAMMENT L'UTILISATION DE POST_RELEVE_T)
C
C IN OPTION : NOM DE L'OPTION
C IN NOMTE  : NOM DU TYPE D'ELEMENT
C
C   -------------------------------------------------------------------
C     SUBROUTINES APPELLEES:
C       JEVEUX:JEVETE,JEVECH.
C
C     FONCTIONS INTRINSEQUES:
C       AUCUN.
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       13/09/01 (OB): CREATION EN S'INSPIRANT DE TE0379.F.
C       05/02/02 (OB): EXTENSION AUX EFS LUMPES.
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      CHARACTER*16 OPTION,NOMTE

C ---------- DEBUT DECLARATIONS NORMALISEES JEVEUX --------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16               ZK16
      CHARACTER*24                         ZK24
      CHARACTER*32                                   ZK32
      CHARACTER*80                                             ZK80
      COMMON / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
      CHARACTER*32      JEXNUM , JEXNOM , JEXR8 , JEXATR
C --------- FIN DECLARATIONS NORMALISEES JEVEUX ----------------------

C DECLARATION VARIABLES LOCALES
      INTEGER       I,NNO,ICARAC,IERRG,IERRN,I1
      REAL*8        ERTABS,ERTREL,TERMNO,TERMVO,TERMV2,TERMV1,TERMSA,
     &              TERMS2,TERMS1,TERMFL,TERMF2,TERMF1,TERMEC,TERME2,
     &              TERME1
      CHARACTER*3   NOMT3
      CHARACTER*8   ELREFE
      CHARACTER*24  CARAC
      LOGICAL       L2D

C INITIALISATION DIMENSION DE L'ESPACE DE TRAVAIL
      CALL ELREF1(ELREFE)
      NOMT3 = NOMTE(5:7)
      IF ((NOMT3.EQ.'TR3').OR.(NOMT3.EQ.'QU4').OR.(NOMT3.EQ.'TR6').OR.
     &    (NOMT3.EQ.'QU8').OR.(NOMT3.EQ.'QU9').OR.(NOMT3.EQ.'TL3').OR.
     &    (NOMT3.EQ.'QL4').OR.(NOMT3.EQ.'TL6').OR.(NOMT3.EQ.'QL8').OR.
     &    (NOMT3.EQ.'QL9')) THEN
        L2D = .TRUE.
      ELSE
        L2D = .FALSE.
      ENDIF

C RECUPERATION DES ADRESSES JEVEUX DE LA GEOMETRIE
      IF (L2D) THEN
        CARAC='&INEL.'//ELREFE//'.CARAC'
        CALL JEVETE(CARAC,'L',ICARAC)
        NNO = ZI(ICARAC)
      ELSE
        CARAC = '&INEL.'//ELREFE//'.CARACTE'
        CALL JEVETE(CARAC,'L',ICARAC)
        NNO   = ZI(ICARAC+1)
      ENDIF

C RECUPERATION DE CELLES DES INPOUT (IERRG) ET DES OUTPUT (IERRN)
      CALL JEVECH('PERREUR','L',IERRG)
      CALL JEVECH('PERRENO','E',IERRN)

C LECTURE DES DONNEES PAR ELEMENT
      ERTABS = ZR(IERRG)
      ERTREL = ZR(IERRG+1)
      TERMNO = ZR(IERRG+2)
      TERMVO = ZR(IERRG+3)
      TERMV2 = ZR(IERRG+4)
      TERMV1 = ZR(IERRG+5)
      TERMSA = ZR(IERRG+6)
      TERMS2 = ZR(IERRG+7)
      TERMS1 = ZR(IERRG+8)
      TERMFL = ZR(IERRG+9)
      TERMF2 = ZR(IERRG+10)
      TERMF1 = ZR(IERRG+11)
      TERMEC = ZR(IERRG+12)
      TERME2 = ZR(IERRG+13)
      TERME1 = ZR(IERRG+14)

C ECRITURE DES DONNEES AUX NOEUDS PAR ELEMENT
      DO 10 I=1,NNO
        I1 = 15*I
        ZR(IERRN+I1-15) = ERTABS
        ZR(IERRN+I1-14) = ERTREL
        ZR(IERRN+I1-13) = TERMNO
        ZR(IERRN+I1-12) = TERMVO
        ZR(IERRN+I1-11) = TERMV2
        ZR(IERRN+I1-10) = TERMV1
        ZR(IERRN+I1- 9) = TERMSA
        ZR(IERRN+I1- 8) = TERMS2
        ZR(IERRN+I1- 7) = TERMS1
        ZR(IERRN+I1- 6) = TERMFL
        ZR(IERRN+I1- 5) = TERMF2
        ZR(IERRN+I1- 4) = TERMF1
        ZR(IERRN+I1- 3) = TERMEC
        ZR(IERRN+I1- 2) = TERME2
        ZR(IERRN+I1- 1) = TERME1
   10 CONTINUE
      END
