      SUBROUTINE OP0021()
C-----------------------------------------------------------------------
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
C-----------------------------------------------------------------------
C     COMMANDE:  DEFI_PART_FETI
C
C   -------------------------------------------------------------------
C     SUBROUTINES APPELLEES:
C       MESSAGE:INFNIV,INFMAJ.
C       SUPERVI:GETRES,GETVIS.
C       AUTRES: FETCRF.
C
C     FONCTIONS INTRINSEQUES:
C       NONE.
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       02/11/03 (OB): CREATION.
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRE
      
      
C DECLARATION VARIABLES LOCALES
      INCLUDE 'jeveux.h'
      INTEGER      IFM,NIV,IBID
      CHARACTER*8  RESULT
      CHARACTER*16 K16BID,NOMCMD
      INTEGER      IARG


C CORPS DU PROGRAMME
      CALL JEMARQ()

C RECUPERATION ET MAJ DU NIVEAU D'IMPRESSION
      CALL GETVIS(' ','INFO',0,IARG,1,NIV,IBID)
      CALL INFMAJ      
      CALL INFNIV(IFM,NIV)

C OBTENTION DU NOM UTILISATEUR DE L'OBJET RESULTAT
      CALL GETRES(RESULT,K16BID,NOMCMD)

C CREATION DE LA SD_FETI DU MEME NOM      
C      CALL OBTEMP(RESULT)
      CALL FETCRF(RESULT)

C MONITORING 
      IF (NIV.GE.3) 
     &  WRITE (IFM,*)'<FETI/OP0021> LECTURE NOM-USER: ',RESULT

      CALL JEDEMA()
      END      
