      INTEGER FUNCTION NUCALC(OPT,TE)
      IMPLICIT REAL*8 (A-H,O-Z)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 30/01/2002   AUTEUR VABHHTS J.TESELET 
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
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      INTEGER OPT,TE
C ----------------------------------------------------------------------
C     ENTREES:
C        OPT : OPTION
C         TE : TYPE_ELEMENT

C     SORTIES:
C     NUCALC : NUMERO DU CALCUL ELEMENTAIRE A LANCER

C ----------------------------------------------------------------------
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     +       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD

C     FONCTIONS EXTERNES:
C     -------------------

C     VARIABLES LOCALES:
C     ------------------
      INTEGER OPTMOD,JJ
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      INTEGER ZI

C DEB-------------------------------------------------------------------

C     JJ = IOPTTE(OPT,TE)
      JJ = ZI(IAOPTT-1+ (TE-1)*LGCO+OPT)
      IF (JJ.EQ.0) THEN
C        -- LE TYPE_ELEMENT TE NE SAURA JAMAIS CALCULER L'OPTION OPT:
        NUCALC = 0
      ELSE
        OPTMOD = IAOPMO + ZI(ILOPMO-1+JJ) - 1
        NUCALC = ZI(OPTMOD-1+1)
      END IF
   10 CONTINUE
      END
