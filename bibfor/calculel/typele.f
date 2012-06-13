      INTEGER FUNCTION TYPELE(LIGREZ,IGREL)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      CHARACTER*(*) LIGREZ
      INTEGER IGREL
C ----------------------------------------------------------------------
C     ENTREES:
C       LIGREL : NOM D'1 LIGREL
C       IGREL  : NUMERO D'1 GREL

C     SORTIES:
C       TYPELE : TYPE_ELEMENT ASSOCIE AU GREL
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*19 LIGREL
      INTEGER LIEL,N1
      CHARACTER*1 K1BID
C ----------------------------------------------------------------------
C     COMMONS DE CALCUL.F :
      INTEGER NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
      COMMON /CAII11/NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG

      INTEGER IAMACO,ILMACO,IAMSCO,ILMSCO,IALIEL,ILLIEL
      COMMON /CAII03/IAMACO,ILMACO,IAMSCO,ILMSCO,IALIEL,ILLIEL
C ----------------------------------------------------------------------
      LIGREL = LIGREZ

C     -- SI ON EST "SOUS" CALCUL, ON PEUT ALLER PLUS VITE :
      IF (IACTIF.EQ.1) THEN
        N1=ZI(ILLIEL-1+IGREL+1)-ZI(ILLIEL-1+IGREL)
        TYPELE=ZI(IALIEL-1+ZI(ILLIEL-1+IGREL)-1+N1)
      ELSE
        CALL JEMARQ()
        CALL JEVEUO(JEXNUM(LIGREL//'.LIEL',IGREL),'L',LIEL)
        CALL JELIRA(JEXNUM(LIGREL//'.LIEL',IGREL),'LONMAX',N1,K1BID)
        TYPELE = ZI(LIEL-1+N1)
        CALL JEDEMA()
      ENDIF
      END
