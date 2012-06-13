      SUBROUTINE CACOCO(CHAR  ,MOTFAC,NOMA  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8  CHAR, NOMA
      CHARACTER*16 MOTFAC
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES MAILLEES - LECTURE DONNEES)
C
C LECTURE DES CARACTERISTIQUES DE COQUE
C REMPLISSAGE DE LA SD DEFICO(1:16)//'.JEUCOQ'
C      
C ----------------------------------------------------------------------
C 
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
C IN  NOMA   : NOM DU MAILLAGE
C
C
C
C
      INTEGER      IRET,NOC,NBNMA,IACNEX
      INTEGER      ICESC,ICESD,ICESL,ICESV,NPMAX
      INTEGER      INDIK8,RANGR0,RANGR1,IAD1
      INTEGER      CFDISI,NZOCO,NBMAE
      INTEGER      POSMAE,NUMMAE
      INTEGER      MMINFI,JDECME
      INTEGER      IZONE,IMAE,NMACO      
      REAL*8       EP, EXC
      LOGICAL      YA
      CHARACTER*8  K8BID,CARAEL,NOMMAE
      CHARACTER*24 DEFICO
      CHARACTER*24 CONTMA,JEUCOQ
      INTEGER      JMACO,JJCOQ
      CHARACTER*19 CARSD,CARTE
      LOGICAL      MMINFL,LDCOQ
      INTEGER      IARG
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ
C
C --- INITIALISATIONS
C
      DEFICO    = CHAR(1:8)//'.CONTACT' 
      NZOCO     = CFDISI(DEFICO,'NZOCO') 
      NMACO     = CFDISI(DEFICO,'NMACO')
C 
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C      
      CONTMA = DEFICO(1:16)//'.MAILCO'
      CALL JEVEUO(CONTMA,'L',JMACO)  
C
C --- CREATION VECTEUR
C      
      JEUCOQ = DEFICO(1:16)//'.JEUCOQ'
      CALL WKVECT(JEUCOQ,'G V R',NMACO ,JJCOQ )
C
C --- RECUPERATION DU CARA_ELEM
C
      YA = .FALSE.
      DO 10 IZONE = 1 , NZOCO
        LDCOQ  = MMINFL(DEFICO,'DIST_COQUE',IZONE )
        IF (LDCOQ) THEN
          YA = .TRUE.
          CALL GETVID(MOTFAC,'CARA_ELEM',IZONE,IARG,1,CARAEL, NOC)
          IF (NOC.EQ.0) THEN
            CALL ASSERT(.FALSE.)
          ENDIF
        ENDIF          
 10   CONTINUE
C
      IF ( .NOT. YA ) THEN
        GOTO 999
      ENDIF
C
      CARTE = CARAEL//'.CARCOQUE'
      CARSD = '&&CACOCO.CARCOQUE'
      CALL CARCES(CARTE ,'ELEM',' ','V',CARSD ,'A',IRET  )
C
C --- RECUPERATION DES GRANDEURS (EPAIS, EXCENT)  
C --- REFERENCEE PAR LA CARTE CARGEOPO            
C
      CALL JEVEUO(CARSD//'.CESC','L',ICESC)
      CALL JEVEUO(CARSD//'.CESD','L',ICESD)
      CALL JEVEUO(CARSD//'.CESL','L',ICESL)
      CALL JEVEUO(CARSD//'.CESV','L',ICESV)
C
C --- ON RECUPERE L'EPAISSEUR DE LA COQUE
C
      NPMAX  = ZI(ICESD-1+2)
      RANGR0 = INDIK8(ZK8(ICESC),'EP      ',1,NPMAX)
      RANGR1 = INDIK8(ZK8(ICESC),'EXCENT  ',1,NPMAX)
C
      DO 20 IZONE = 1 , NZOCO
        LDCOQ  = MMINFL(DEFICO,'DIST_COQUE',IZONE )
        IF (LDCOQ) THEN
C
          NBMAE  = MMINFI(DEFICO,'NBMAE' ,IZONE )
          JDECME = MMINFI(DEFICO,'JDECME',IZONE ) 
C
          DO 30 IMAE = 1 , NBMAE
C          
            POSMAE = JDECME+IMAE
            NUMMAE = ZI(JMACO+POSMAE-1)  
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAE),NOMMAE)  
C
C --- RECUPERATION EPAISSEUR
C
            CALL CESEXI('C',ICESD,ICESL,NUMMAE,1,1,RANGR0,IAD1)
            IF (IAD1.GT.0) THEN
              EP = ZR(ICESV-1+IAD1)
            ELSE
              CALL U2MESK('F','CONTACT3_39',1,NOMMAE)
            ENDIF
C
C --- RECUPERATION EXCENTRICITE
C
            CALL CESEXI('C',ICESD,ICESL,NUMMAE,1,1,RANGR1,IAD1)
            IF (IAD1.GT.0) THEN
              EXC = ZR(ICESV-1+IAD1)
              IF ( EXC .NE. 0.D0 ) THEN
                CALL U2MESK('F','CONTACT3_40',1,NOMMAE)
              ENDIF
            ELSE
              CALL U2MESK('F','CONTACT3_41',1,NOMMAE)
            ENDIF
C
C --- NOEUDS DE LA MAILLE 
C
            CALL JEVEUO(JEXNUM(NOMA//'.CONNEX',NUMMAE),'L',IACNEX)
            CALL JELIRA(JEXNUM(NOMA//'.CONNEX',NUMMAE),'LONMAX',
     &                  NBNMA ,K8BID)
C
C --- STOCKAGE
C          
            ZR(JJCOQ+POSMAE-1) = 0.5D0 * EP
 30     CONTINUE
        ENDIF
 20   CONTINUE
C
      CALL DETRSD ( 'CHAM_ELEM_S', CARSD )
C
 999  CONTINUE
C
      CALL JEDEMA
C
      END
