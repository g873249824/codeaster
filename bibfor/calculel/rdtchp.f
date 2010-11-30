      SUBROUTINE RDTCHP(CORRN,CORRM,CH1,CH2,NOMA,NOMARE,LIGREL)
      IMPLICIT NONE
      CHARACTER*8 NOMA,NOMARE
      CHARACTER*24 CORRN,CORRM
      CHARACTER*19 CH1,CH2,LIGREL
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 30/06/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-------------------------------------------------------------------
C BUT: REDUIRE UNE SD_CHAMP SUR UN MAILLAGE REDUIT
C
C  CH1    : IN  : CHAMP A REDUIRE
C  CH2    : OUT : CHAMP REDUIT
C  NOMA   : IN  : MAILLAGE AVANT REDUCTION
C  NOMARE : IN  : MAILLAGE REDUIT
C  LIGREL : IN  : LIGREL REDUIT
C  CORRN  : IN  : NOM DE L'OBJET CONTENANT LA CORRESPONDANCE
C                 INO_RE -> INO
C  CORRM  : IN  : NOM DE L'OBJET CONTENANT LA CORRESPONDANCE
C                 IMA_RE -> IMA
C-------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER I,J,K,NBNO,NBNORE,NBMA,NBMARE,NBORDR,IBID
      INTEGER IRET,N1,NNCP
      REAL*8 RBID
      COMPLEX*16 CBID
      CHARACTER*1 KB
      CHARACTER*16 TYPRES,OPTION
      CHARACTER*4 TYCH
      CHARACTER*19 CH1S,CH2S
C     -----------------------------------------------------------------

      CALL JEMARQ()

      CALL ASSERT(NOMA.NE.NOMARE)
      CALL ASSERT(CH1.NE.CH2)

      CALL DISMOI('F','TYPE_CHAMP',CH1,'CHAMP',IBID,TYCH,IBID)

      CH1S='&&RDTCHP'//'.CH1S'
      CH2S='&&RDTCHP'//'.CH2S'


      IF (TYCH.EQ.'NOEU') THEN
        CALL CNOCNS(CH1,'V',CH1S)
        CALL RDTCNS(NOMARE,CORRN,CH1S,'V',CH2S)
        CALL CNSCNO(CH2S,' ','NON','V',CH2,'F',IRET)
        CALL ASSERT(IRET.EQ.0)
        CALL DETRSD('CHAM_NO_S',CH1S)
        CALL DETRSD('CHAM_NO_S',CH2S)


      ELSEIF (TYCH(1:2).EQ.'EL') THEN
        CALL CELCES(CH1,'V',CH1S)
        CALL RDTCES(NOMARE,CORRM,CH1S,'V',CH2S)
        CALL DISMOI('F','NOM_OPTION',CH1,'CHAMP',IBID,OPTION,IBID)
        CALL CESCEL(CH2S,LIGREL,OPTION,' ','OUI',NNCP,'V',CH2,'F',IRET)
        CALL ASSERT(IRET.EQ.0)
        CALL ASSERT(NNCP.EQ.0)
        CALL DETRSD('CHAM_ELEM_S',CH1S)
        CALL DETRSD('CHAM_ELEM_S',CH2S)


      ELSEIF (TYCH.EQ.'CART') THEN
        CALL CARCES(CH1,'ELEM',' ','V',CH1S,IRET)
        CALL ASSERT(IRET.EQ.0)
        CALL RDTCES(NOMARE,CORRM,CH1S,'V',CH2S)
        CALL CESCAR(CH2S,CH2,'V')
        CALL ASSERT(IRET.EQ.0)
        CALL DETRSD('CHAM_ELEM_S',CH1S)
        CALL DETRSD('CHAM_ELEM_S',CH2S)


      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF




      CALL JEDEMA()

      END
