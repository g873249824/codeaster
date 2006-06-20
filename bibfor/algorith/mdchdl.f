      SUBROUTINE MDCHDL ( NBNLI, NOECHO, LNOUE2, ILIAI, DDLCHO, IER )
      IMPLICIT  NONE
      INTEGER             NBNLI, ILIAI, DDLCHO(*), IER
      LOGICAL             LNOUE2
      CHARACTER*8         NOECHO(NBNLI,*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/06/2006   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ROUTINE APPELEE PAR MDCHOC
C     TRAITEMENT DES DDL
C
C IN  : NBNLI  : DIMENSION DES TABLEAUX (NBCHOC+NBSISM+NBFLAM)
C IN  : NOECHO : DEFINITION DES NOEUDS DE CHOC
C IN  : LNOUE2 : CHOC DEFINIT ENTRE 2 NOEUDS
C IN  : ILIAI  : NUMERO DE LA LIAISON TRAITEE
C OUT : DDLCHO : TABLEAU DES NUMEROTATIONS DES NOEUDS DE CHOC
C OUT : IER    : NIVEAU D'ERREUR
C     ------------------------------------------------------------------
      INTEGER       NUNOE, NUDDL
      CHARACTER*8   NUME1, NOEU1, NUME2, NOEU2
C     ------------------------------------------------------------------
C
      NUME1 = NOECHO(ILIAI,3)
      NOEU1 = NOECHO(ILIAI,1)
      NUME2 = NOECHO(ILIAI,7)
      NOEU2 = NOECHO(ILIAI,5)
C
      CALL POSDDL ('NUME_DDL',NUME1,NOEU1,'DX',NUNOE,NUDDL)
      IF (NUNOE.EQ.0) THEN
         IER = IER + 1
         CALL UTMESS('E','MDCHOC','LE NOEUD '//NOEU1//
     +           ' N''EST PAS UN NOEUD DU MAILLAGE '//NOECHO(ILIAI,4))
      ENDIF
      IF (NUDDL.EQ.0) THEN
         IER = IER + 1
         CALL UTMESS('E','MDCHOC','ON N''A PAS TROUVE LE DDL "DX" '//
     +                           'POUR LE NOEUD '//NOEU1)
      ENDIF
      DDLCHO(6*(ILIAI-1)+1) = NUDDL
C
      CALL POSDDL ('NUME_DDL',NUME1,NOEU1,'DY',NUNOE,NUDDL)
      IF (NUDDL.EQ.0) THEN
         IER = IER + 1
         CALL UTMESS('E','MDCHOC','ON N''A PAS TROUVE LE DDL "DY" '//
     +                           'POUR LE NOEUD '//NOEU1)
      ENDIF
      DDLCHO(6*(ILIAI-1)+2) = NUDDL
C
      CALL POSDDL ('NUME_DDL',NUME1,NOEU1,'DZ',NUNOE,NUDDL)
      IF (NUDDL.EQ.0) THEN
         IER = IER + 1
         CALL UTMESS('E','MDCHOC','ON N''A PAS TROUVE LE DDL "DZ" '//
     +                           'POUR LE NOEUD '//NOEU1)
      ENDIF
      DDLCHO(6*(ILIAI-1)+3) = NUDDL
C
      IF ( LNOUE2 ) THEN
         CALL POSDDL ('NUME_DDL',NUME2,NOEU2,'DX',NUNOE,NUDDL)
         IF (NUNOE.EQ.0) THEN
            IER = IER + 1
            CALL UTMESS('E','MDCHOC','LE NOEUD '//NOEU2//
     +            ' N''EST PAS UN NOEUD DU MAILLAGE '//NOECHO(ILIAI,8))
         ENDIF
         IF (NUDDL.EQ.0) THEN
            IER = IER + 1
            CALL UTMESS('E','MDCHOC','ON N''A PAS TROUVE LE DDL '//
     +                         '"DX" POUR LE NOEUD '//NOEU2)
         ENDIF
         DDLCHO(6*(ILIAI-1)+4) = NUDDL
C
         CALL POSDDL ('NUME_DDL',NUME2,NOEU2,'DY',NUNOE,NUDDL)
         IF (NUDDL.EQ.0) THEN
            IER = IER + 1
            CALL UTMESS('E','MDCHOC','ON N''A PAS TROUVE LE DDL '//
     +                         '"DY" POUR LE NOEUD '//NOEU2)
         ENDIF
         DDLCHO(6*(ILIAI-1)+5) = NUDDL
C
         CALL POSDDL ('NUME_DDL',NUME2,NOEU2,'DZ',NUNOE,NUDDL)
         IF (NUDDL.EQ.0) THEN
            IER = IER + 1
            CALL UTMESS('E','MDCHOC','ON N''A PAS TROUVE LE DDL '//
     +                         '"DZ" POUR LE NOEUD '//NOEU2)
         ENDIF
         DDLCHO(6*(ILIAI-1)+6) = NUDDL
      ELSE
          DDLCHO(6*(ILIAI-1)+4) = DDLCHO(6*(ILIAI-1)+1)
          DDLCHO(6*(ILIAI-1)+5) = DDLCHO(6*(ILIAI-1)+2)
          DDLCHO(6*(ILIAI-1)+6) = DDLCHO(6*(ILIAI-1)+3)
      ENDIF
C
      END
