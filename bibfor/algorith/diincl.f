      LOGICAL FUNCTION DIINCL(SDDISC,NOMCHZ,FORCE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/02/2011   AUTEUR ABBAS M.ABBAS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*19  SDDISC
      CHARACTER*(*) NOMCHZ
      LOGICAL       FORCE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE - DISCRETISATION)
C
C INDIQUE S'IL FAUT ARCHIVER UN CHAMP
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION
C IN  NOMCHA : NOM DU CHAMP
C IN  FORCE  : INDIQUE SI ON FORCE L'ARCHIVAGE POUR LES CHAMPS EXCLUS
C OUT DIINCL : VRAI SI LE CHAMP DOIT ETRE SAUVE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IRET, NB, I
      CHARACTER*8  K8BID
      CHARACTER*16 NOMCHA 
      CHARACTER*19 SDARCH
      CHARACTER*24 ARCEXC
      INTEGER      JAREXC    
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C      
      NOMCHA = NOMCHZ
C
C --- ACCES SD ARCHIVAGE
C    
      SDARCH = SDDISC(1:14)//'.ARCH'    
      ARCEXC = SDARCH(1:19)//'.AEXC'
C
C --- AUCUN CHAMP N'EST EXCLU
C
      CALL JEEXIN(ARCEXC,IRET)
      IF (IRET.EQ.0) THEN
        DIINCL = .TRUE.
        GOTO 9999
      END IF
C
C --- LE CHAMP EST-IL EXCLU ?
C      
      DIINCL = .FALSE.
      CALL JEVEUO(ARCEXC,'L',JAREXC)
      CALL JELIRA(ARCEXC,'LONMAX',NB    ,K8BID)
      DO 10 I = 1,NB
        IF (NOMCHA .EQ. ZK16(JAREXC-1 + I)) GOTO 9999
 10   CONTINUE
      DIINCL = .TRUE.
C
C --- ON STOCKE LES CHAMPS EXCLUS SI ON FORCE L'ARCHIVAGE
C
      IF (.NOT.DIINCL .AND. FORCE) THEN
        DIINCL = .TRUE.
      ENDIF
C
 9999 CONTINUE      
C      
      CALL JEDEMA()
      END
