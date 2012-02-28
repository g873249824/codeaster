      SUBROUTINE NMAMAB(MODELE,LAMOR)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/02/2012   AUTEUR DEVESA G.DEVESA 
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

      IMPLICIT NONE
      CHARACTER*24  MODELE
      LOGICAL       LAMOR


C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      CHARACTER*19  NOLIG, LIGREL
      CHARACTER*8   K8BID
      CHARACTER*16  NOMTE
      CHARACTER*24  REPK
      INTEGER       NBGREL, IGREL, IALIEL, NEL, ITYPEL
C ----------------------------------------------------------------------


      CALL JEMARQ()
      LIGREL = MODELE(1:8)//'.MODELE'
      NOLIG = LIGREL(1:19)

      LAMOR = .FALSE.

      CALL JELIRA(NOLIG//'.LIEL','NUTIOC',NBGREL,K8BID)
      REPK = 'NON'
      DO 10 IGREL = 1,NBGREL
        CALL JEVEUO(JEXNUM(NOLIG//'.LIEL',IGREL),'L',IALIEL)
        CALL JELIRA(JEXNUM(NOLIG//'.LIEL',IGREL),'LONMAX',NEL,K8BID)
        ITYPEL = ZI(IALIEL-1+NEL)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)
        IF ((NOMTE(1:9).EQ.'MEAB_FACE') .OR.
     &      (NOMTE(1:6).EQ.'MEPASE') .OR.
     &      (NOMTE(1:8).EQ.'MECA_DIS') .OR.
     &      (NOMTE(1:11).EQ.'MECA_2D_DIS')) THEN
          REPK = 'OUI'
          GO TO 20
        END IF
   10 CONTINUE
   20 CONTINUE
      IF (REPK.EQ.'OUI') THEN
        LAMOR = .TRUE.
      END IF
      
      CALL JEDEMA()
      END
