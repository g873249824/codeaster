      SUBROUTINE CAFMSU(IFA,CONT,TANGE,MAXFA,NFACE,
     &                  FKSS,DFKS1,DFKS2,MOBFAS,
     &                  DMOB1S,DMOB2S,FMW,FM1W,FM2W)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C  CETTE SUBROUTINE PERMET DE CALCULER D UNE MANIERE GENERIQUE LE FLUX
C  MASSIQUE QUI INTERVIENR DANS L EQUATION DE CONTINUITE POUR UNE ARETE
C  EXTERNE
C
C=======================================================================
C ****IN :
C     IFA              : ARETE EXTERNE QUE L ON CONSIDERE DANS ASSVSU
C     FKSS             : FLUX SUR L ARETE EXTERNE QUE
C                        L ON CONSIDERE DANS ASSVSU
C     DFKS1(1,IFA)     : DERIVEE DE FKS(IFA) PAR RAP A
C                        LA PREMIERE INCONNUE AU CENTRE
C     DFKS1(JFA+1,IFA) : DERIVEE DE FKS(IFA) PAR RAP A
C                         LA PREMIERE INCONNUE FACE
C     DFKS2(1,IFA)     : DERIVEE DE FKS(IFA) PAR RAP A
C                         LA DEUXIEME INCONNUE AU CENTRE
C     DFKS2(JFA+1,IFA) : DERIVEE DE FKS(IFA) PAR RAP A
C                         LA DEUXIEME INCONNUE FACE
C     MOBFAS           : MOBILITE SUR  L ARETE EXTERNE
C                        QUE L ON CONSIDERE DANS ASSVSU
C     DMOB1S           : DERIVEE DE MOBFAS PAR RAPPORT A
C                         LA PREMIERE VARIABLE
C     DMOB2S           : DERIVEE DE MOBFAS PAR RAPPORT A
C                         LA SECONDE VARIABLE
C ****IN-OUT :
C     FMW              : FLUX MASSIQUE
C     FM1W             : DERIVEE DU FLUX PAR RAPPORT
C                        A LA PREMIERE VARIABLE
C     FM2W             : DERIVEE DU FLUX PAR RAPPORT
C                        A LA SECONDE VARIABLE
C ================================================
C     FMW =  MOB * F_{K,SIGMA}
C================================================
      IMPLICIT NONE
      LOGICAL      CONT,TANGE
      INTEGER      MAXFA
      INTEGER      NFACE
      REAL*8       FMW(NFACE)
      REAL*8       FKSS
      REAL*8       MOBFAS
      REAL*8       DMOB1S,DMOB2S
      REAL*8       FM1W(1+MAXFA,NFACE),FM2W(1+MAXFA,NFACE)
      REAL*8       DFKS1(1+MAXFA,NFACE), DFKS2(1+MAXFA,NFACE)
      INTEGER      IFA,JFA
      IF ( CONT ) THEN
         FMW(IFA) = MOBFAS * FKSS
      ENDIF
      IF ( TANGE) THEN
         FM1W(1,IFA) = DMOB1S * FKSS + MOBFAS * DFKS1(1,IFA)
         FM2W(1,IFA) = DMOB2S * FKSS + MOBFAS * DFKS2(1,IFA)
         DO 4 JFA=2,NFACE+1
            FM1W(JFA,IFA) = FM1W(JFA,IFA) + MOBFAS * DFKS1(JFA,IFA)
            FM2W(JFA,IFA) = FM2W(JFA,IFA) + MOBFAS * DFKS2(JFA,IFA)
   4     CONTINUE
      ENDIF
      END
