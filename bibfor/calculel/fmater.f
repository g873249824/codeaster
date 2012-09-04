      SUBROUTINE FMATER(NBFMAX , NFTAB, TAB)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE PELLET J.PELLET
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER NBFMAX, NFTAB
      CHARACTER*8 TAB(*)
C ----------------------------------------------------------------------
C
C BUT : RECUPERER LE FAMILLE DE POINTS DE GAUSS DE LA LISTE MATER
C
C ----------------------------------------------------------------------
      INTEGER NFPGMX,I
      PARAMETER (NFPGMX=10)
      INTEGER NFPG,JFPGL,DECALA(NFPGMX),KM,KP,KR,IREDEC
      COMMON /CAII17/NFPG,JFPGL,DECALA,KM,KP,KR,IREDEC
C ----------------------------------------------------------------------

      CALL ASSERT( NBFMAX .GE. NFPG )
      NFTAB=NFPG
      DO 10, I=1, NFPG
        TAB(I)=ZK8(JFPGL+I-1)
 10   CONTINUE

      END
