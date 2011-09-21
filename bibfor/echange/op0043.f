      SUBROUTINE OP0043 ()
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ECHANGE  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GREFFET N.GREFFET
      IMPLICIT   NONE
C =====================================================================
C   - FONCTIONS REALISEES:
C       COMMANDE IMPR_MAIL_YACS
C       RECUPERATION DU MAILLAGE FLUIDE LORS D'UN COUPLAGE ASTER-SATURNE
C       VIA YACS
C
C   - OUT :
C       IERR   : NON UTILISE
C     ------------------------------------------------------------
      INTEGER      NFIS
      CHARACTER*8  TYPEMA
      CHARACTER*16 K16NOM
      INTEGER      ULISOP,N
      INTEGER      IARG
C
      CALL JEMARQ()
      CALL INFMAJ()
C
      CALL GETVIS ( ' ', 'UNITE_MAILLAGE' , 1,IARG,1, NFIS, N )
C LECTURE DU MAILLAGE FLUIDE
      K16NOM='                '
      IF ( ULISOP ( NFIS, K16NOM ) .EQ. 0 )  THEN 
        CALL ULOPEN ( NFIS,' ','FICHIER-MODELE','NEW','O')
      ENDIF 
      CALL GETVTX ( ' ', 'TYPE_MAILLAGE' , 1,IARG,1, TYPEMA, N )
      CALL PRECOU(NFIS,TYPEMA)
C
      WRITE(NFIS,*) 'FIN'
      REWIND NFIS
C
      CALL JEDEMA()
      END
