      SUBROUTINE NMEXTC(SDIETO,MOTFAC,IOCC  ,NOMCHA,LEXTR )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16  MOTFAC
      INTEGER       IOCC
      CHARACTER*24  NOMCHA,SDIETO
      LOGICAL       LEXTR 
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (EXTRACTION - LECTURE)
C
C LECTURE DU NOM DU CHAMP
C VERIFICATION CHAMP OK POUR PHENOMENE
C
C ----------------------------------------------------------------------
C
C
C IN  SDIETO : SD GESTION IN ET OUT
C IN  MOTFAC : MOT-FACTEUR POUR LIRE 
C IN  IOCC   : OCCURRENCE DU MOT-CLEF FACTEUR MOTFAC
C OUT NOMCHA : NOM DU CHAMP
C OUT LEXTR  : .TRUE. SI LE CHAMP EST EXTRACTABLE (COMPATIBLE AVEC
C               PHENOMENE)
C
C
C
C
      CHARACTER*8  K8BID
      INTEGER      NCHP,N1
      INTEGER      ICHAM
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      LEXTR  = .TRUE.
C
C --- LECTURE: IL FAUT UN CHAMP ET UN SEUL
C      
      CALL GETVTX(MOTFAC,'NOM_CHAM',IOCC  ,IARG,0     ,
     &            K8BID ,N1    )
      NCHP   = -N1
      CALL ASSERT(NCHP.EQ.1)
C
C --- NOM DU CHAMP
C
      CALL GETVTX(MOTFAC,'NOM_CHAM',IOCC,IARG,1,NOMCHA,NCHP)
C
C --- INDICE DU CHAMP
C
      CALL NMETOB(SDIETO,NOMCHA,ICHAM )
C 
C --- OBSERVABLE ?
C
      IF (ICHAM.EQ.0) THEN
        LEXTR = .FALSE.
      ELSE
        LEXTR = .TRUE.
      ENDIF
C
      CALL JEDEMA()
C
      END
