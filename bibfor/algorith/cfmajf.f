      SUBROUTINE CFMAJF(RESOCO,NEQ   ,NDIM  ,NBLIAI,NBLIAC,
     &                  LLF   ,LLF1  ,LLF2  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      CHARACTER*24 RESOCO
      INTEGER      NEQ,NDIM
      INTEGER      NBLIAI,NBLIAC
      INTEGER      LLF,LLF1,LLF2
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
C
C MISE A JOUR DU VECTEUR SOLUTION ITERATION DE CONTACT
C
C ----------------------------------------------------------------------
C
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  NEQ    : NOMBRE D'EQUATIONS
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT
C IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
C IN  LLF    : NOMBRE DE LIAISONS DE FROTTEMENT (EN 2D)
C              NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LES DEUX
C               DIRECTIONS SIMULTANEES (EN 3D)
C IN  LLF1   : NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LA
C               PREMIERE DIRECTION (EN 3D)
C IN  LLF2   : NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LA
C               SECONDE DIRECTION (EN 3D)
C
C
C
C
      INTEGER      ILIAC,ILIAI,POSIT
      INTEGER      POSNBL,POSLF0,POSLF1,POSLF2
      CHARACTER*19 MU,CM1A,LIAC
      INTEGER      JMU,JCM1A,JLIAC
      CHARACTER*19 DDELT
      INTEGER      JDDELT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      POSNBL = 0
      POSLF0 = NBLIAC
      POSLF1 = NBLIAC + (NDIM-1)*LLF
      POSLF2 = NBLIAC + (NDIM-1)*LLF + LLF1
C
C --- ACCES STRUCTURES DE DONNEES DE CONTACT
C
      MU       = RESOCO(1:14)//'.MU'
      CM1A     = RESOCO(1:14)//'.CM1A'
      LIAC     = RESOCO(1:14)//'.LIAC'
      CALL JEVEUO(MU    ,'L',JMU   )
      CALL JEVEUO(LIAC  ,'L',JLIAC )
C
C --- ACCES AUX CHAMPS DE TRAVAIL
C
      DDELT  = RESOCO(1:14)//'.DDEL'
      CALL JEVEUO(DDELT(1:19)//'.VALE'  ,'E',JDDELT)
C
C --- ON REORDONNE LE VECTEUR MU
C
      CALL CFMAJM(RESOCO,NDIM  ,NBLIAC,LLF   ,LLF1  ,
     &            LLF2  )
C
C --- CALCUL DE DDEPL0 = DDEPL0 - C-1.AT.MU
C
      DO 10 ILIAC = 1, NBLIAC + LLF + LLF1 + LLF2
        ILIAI = ZI(JLIAC-1+ILIAC)
        CALL CFTYLI(RESOCO,ILIAC,POSIT)
        GOTO (1000,2000,3000,4000) POSIT
C
C ----- LIAISON DE CONTACT
C
 1000   CONTINUE
          POSNBL = POSNBL + 1
          CALL JEVEUO(JEXNUM(CM1A,ILIAI),'L',JCM1A)
          CALL DAXPY (NEQ,-ZR(JMU-1+POSNBL),ZR(JCM1A),1,ZR(JDDELT),1)
          CALL JELIBE(JEXNUM(CM1A,ILIAI))
          GOTO 10
C
C ----- LIAISON DE FROTTEMENT - 2D OU 3D DANS LES DEUX DIRECTIONS
C
 2000   CONTINUE
          POSLF0 = POSLF0 + 1
          CALL JEVEUO(JEXNUM(CM1A,ILIAI+NBLIAI),'L',JCM1A)
          CALL DAXPY(NEQ,-ZR(JMU-1+POSLF0),ZR(JCM1A),1, ZR(JDDELT),1)
          CALL JELIBE(JEXNUM(CM1A,ILIAI+NBLIAI))
          IF (NDIM.EQ.3) THEN
             CALL JEVEUO(JEXNUM(CM1A,ILIAI+(NDIM-1)*NBLIAI),'L',JCM1A)
             CALL DAXPY (NEQ,-ZR(JMU-1+POSLF0+LLF),ZR(JCM1A),1,
     &                   ZR(JDDELT),1)
             CALL JELIBE(JEXNUM(CM1A,ILIAI+(NDIM-1)*NBLIAI))
          ENDIF
          GOTO 10
C
C ----- LIAISON DE FROTTEMENT - 3D PREMIERE DIRECTION
C
 3000   CONTINUE
          POSLF1 = POSLF1 + 1
          CALL JEVEUO(JEXNUM(CM1A,ILIAI+NBLIAI),'L',JCM1A)
          CALL DAXPY(NEQ,-ZR(JMU-1+POSLF1),ZR(JCM1A),1,ZR(JDDELT),1)
          CALL JELIBE(JEXNUM(CM1A,ILIAI+NBLIAI))
          GOTO 10
C
C ----- LIAISON DE FROTTEMENT - 3D SECONDE DIRECTION
C
 4000   CONTINUE
          POSLF2 = POSLF2 + 1
          CALL JEVEUO(JEXNUM(CM1A,ILIAI+(NDIM-1)*NBLIAI),'L',JCM1A)
          CALL DAXPY (NEQ,-ZR(JMU-1+POSLF2),ZR(JCM1A),1, ZR(JDDELT),1)
          CALL JELIBE(JEXNUM(CM1A,ILIAI+(NDIM-1)*NBLIAI))
 10   CONTINUE
C
      CALL JEDEMA ()
C
      END
