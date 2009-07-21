      SUBROUTINE LOBS  (SDOBSE,SDDISC,INSTAP)
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/07/2009   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      REAL*8       INSTAP
      CHARACTER*14 SDOBSE
      CHARACTER*19 SDDISC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C DOIT-ON FAIRE UNE OBSERVATION  ?
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C I/O SDOBSE : NOM DE LA SD POUR OBSERVATION
C IN  INSTAP : INSTANT DE CALCUL 
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
      CHARACTER*19 LISOBS,INFOBS
      INTEGER      JOBSE ,JOBSI
      INTEGER      JINST,IBID
      REAL*8       R8PREM,R8B
      INTEGER      NBOBSE,NUINS0,NUOBSE,LOBSER      
      CHARACTER*8  K8BID
C
C ----------------------------------------------------------------------
C      
      CALL JEMARQ()
C
C --- ACCES DE LA SD
C
      LISOBS = SDOBSE(1:14)//'.LIST' 
      INFOBS = SDOBSE(1:14)//'.INFO'       
      CALL JEVEUO(LISOBS,'L',JOBSE)
      CALL JEVEUO(INFOBS,'E',JOBSI) 
      CALL UTDIDT('L',SDDISC,'LIST',IBID,'JINST',R8B,JINST,K8BID)
C
C --- INITIALISATIONS
C             
      LOBSER = 0
      NBOBSE = ZI(JOBSI+1-1)
      NUOBSE = ZI(JOBSI+3-1)
      NUINS0 = ZI(JOBSI+4-1)
C
C --- CHOIX DE L'OBSERVATION
C
      IF (NBOBSE.NE.0) THEN         
        IF ((INSTAP+R8PREM( )).GE.ZR(JINST+NUINS0+1)) THEN
          NUINS0 = NUINS0 + 1
C          IF (ZI(JOBSE-1+NUINS0+1).EQ.1) THEN
          IF (ZI(JOBSE-1+NUINS0).EQ.1) THEN
            LOBSER = 1
            NUOBSE = NUOBSE + 1            
          ENDIF
        ENDIF
      ENDIF
C
C --- SAUVEGARDE
C
      ZI(JOBSI+4-1) = NUINS0
      ZI(JOBSI+3-1) = NUOBSE
      ZI(JOBSI+5-1) = LOBSER
C           
      CALL JEDEMA()
      
      END
