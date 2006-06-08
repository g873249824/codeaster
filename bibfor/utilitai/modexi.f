      SUBROUTINE MODEXI(MODELZ, NOMODZ, IEXI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 26/05/98   AUTEUR CIBHHGB G.BERTRAND 
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
C.======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     MODEXI  -- SI LA MODELISATION NOMODZ EXISTE DANS LE MODELE
C                MODELZ ALORS IEXI = 1
C                       SINON IEXI = 0
C
C   ARGUMENT        E/S  TYPE         ROLE
C    MODELZ          IN    K*     NOM DU MODELE
C    NOMODZ          IN    K*     NOM DE LA MODELISATION
C    IEXI            OUT   R      = 1 SI LA MODELISATION EXISTE 
C                                     DANS LE MODELE
C                                 = 0 SINON
C.========================= DEBUT DES DECLARATIONS ====================
C ----- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*32     JEXNUM, JEXNOM
C -----  ARGUMENTS
      CHARACTER*(*) MODELZ, NOMODZ
C -----  VARIABLES LOCALES
      INTEGER       REPI
      CHARACTER*1   K1BID
      CHARACTER*8   MODELE
      CHARACTER*16  NOMTE, NOMODL
      CHARACTER*19  NOLIG
      CHARACTER*24  REPK
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
      CALL JEMARQ ( )
C
C --- INITIALISATIONS :
C     ---------------
      MODELE  = MODELZ
      IEXI    = 0
      REPI    = 0
      L = LEN(NOMODZ)
C
      NOLIG = MODELE//'.MODELE'
      CALL JEEXIN(NOLIG//'.LIEL',IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(NOLIG//'.LIEL','NUTIOC',NBGREL,K1BID)
        IF (NBGREL.LE.0) THEN
          CALL UTMESS('F','MODEXI','LE NOMBRE DE GRELS DU LIGREL '//
     +                'DU MODELE EST NUL.')
        ENDIF
        NOMODL=' '
        DO 10 IGREL=1,NBGREL
          CALL JEVEUO(JEXNUM(NOLIG//'.LIEL',IGREL),'L',IALIEL)
          CALL JELIRA(JEXNUM(NOLIG//'.LIEL',IGREL),'LONMAX',NEL,K1BID)
          ITYPEL= ZI(IALIEL -1 +NEL)
          CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)
          CALL DISMTE('F','MODELISATION',NOMTE,REPI,REPK,IERD)
          NOMODL=REPK(1:16)
          IF (NOMODL(1:L).EQ.NOMODZ(1:L)) THEN
            IEXI = 1 
            GO TO 20
          ENDIF
 10     CONTINUE
 20     CONTINUE
      ENDIF
      CALL JEDEMA()
      END
