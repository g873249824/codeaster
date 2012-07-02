      SUBROUTINE GETVEM( NOMA,TYPENT,MOTFAC, MOTCLE, IOCC, IARG,
     .                   MXVAL, VK8, NBVAL )
      IMPLICIT NONE
      CHARACTER*(*)      NOMA,TYPENT,MOTFAC, MOTCLE,VK8(*)
      INTEGER            IOCC, IARG, MXVAL,      NBVAL
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C       RECUPERATION DES VALEURS D'UNE LISTE (VOIR POINT D'ENTREE)
C     ------------------------------------------------------------------
C IN  MOTFAC : CH*(*) : MOT CLE FACTEUR
C          CONVENTION :  POUR UN MOT CLE SIMPLE   MOTFAC = ' '
C IN  MOTCLE : CH*(*) : MOT CLE
C IN  IOCC   : IS     : IOCC-IEME OCCURENCE DU MOT-CLE-FACTEUR
C IN  IARG   : IS     : IARG-IEME ARGUMENT DEMANDE
C IN  MXVAL  : IS     : TAILLE MAXIMUM DU TABLEAU PASSE
C                     :                   (RELATIVEMENT AU TYPE)
C
C OUT   VAL  : ----   : TABLEAU DES VALEURS A FOURNIR
C OUT NBVAL  : IS     : NOMBRE DE VALEUR FOURNIT
C          CONVENTION : SI NBVAL = 0 ==> IL N'Y A PAS DE VALEUR
C                       SI NBVAL < 0 ==> NOMBRE DE VALEUR DE LA LISTE
C                                        SACHANT QUE L'ON NE FOURNIT QUE
C                                        LES MXVAL PREMIERES
C     ------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER MM 
C-----------------------------------------------------------------------
      CALL GETVTX ( MOTFAC, MOTCLE, IOCC, IARG, MXVAL, VK8, NBVAL )
      IF (MXVAL.NE.0) THEN
        MM=MIN(MXVAL,ABS(NBVAL))
        CALL VERIMA ( NOMA,VK8,MM,TYPENT)
      ENDIF
      END
