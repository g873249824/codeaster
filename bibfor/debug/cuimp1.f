      SUBROUTINE CUIMP1(DEFICU,RESOCU,IFM   )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF DEBUG  DATE 18/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 DEFICU
      CHARACTER*24 RESOCU
      INTEGER      IFM
C
C ----------------------------------------------------------------------
C
C ROUTINE LIAISON_UNILATER (DEBUG)
C
C IMPRESSION DES JEUX
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICU : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCU : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  IFM    : UNITE D'IMPRESSION DU MESSAGE
C
C
C
C
      INTEGER      ILIAC,ILIAI,ACTIF
      INTEGER      CUDISI,CUDISD
      INTEGER      NBLIAI,NBLIAC
      CHARACTER*24 LIAC  ,APJEU ,NOMNOE,NOMCMP
      INTEGER      JLIAC ,JAPJEU,JNOMNO,JNOMCM
      CHARACTER*8  CMP,NOE
      REAL*8       JEU
      CHARACTER*15 CHAIAC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()
C
C --- ACCES SD LIAISON_UNILATER
C
      LIAC   = RESOCU(1:14)//'.LIAC'
      APJEU  = RESOCU(1:14)//'.APJEU'
      NOMNOE = RESOCU(1:14)//'.NOMNOE'
      NOMCMP = RESOCU(1:14)//'.NOMCMP'
C
      CALL JEVEUO(LIAC  ,'L',JLIAC)
      CALL JEVEUO(APJEU ,'L',JAPJEU)
      CALL JEVEUO(NOMNOE,'L',JNOMNO)
      CALL JEVEUO(NOMCMP,'L',JNOMCM)
C
C --- INFORMATIONS SUR LE NOMBRE DE LIAISONS
C
      NBLIAI = CUDISI(DEFICU,'NNOCU' )
      NBLIAC = CUDISD(RESOCU,'NBLIAC')
C
C --- BOUCLE SUR LES LIAISONS
C
      DO 500 ILIAI = 1,NBLIAI
C
C --- NOEUD ET COMPOSANTE DE LA LIAISON
C
        CMP = ZK8(JNOMCM-1+ILIAI)
        NOE = ZK8(JNOMNO-1+ILIAI)
C
C --- JEU
C
        JEU = ZR(JAPJEU-1+ILIAI)
C
C --- ACTIF OU NON ?
C
        ACTIF = 0

        DO 10 ILIAC = 1,NBLIAC
          IF (ZI(JLIAC-1+ILIAC).EQ.ILIAI) THEN
            ACTIF  = 1
          ENDIF
  10    CONTINUE
C
C --- IMPRESSION
C
        IF (ACTIF.EQ.1) THEN
          CHAIAC = ' ACTIVE (JEU : '
        ELSE
          CHAIAC = ' LIBRE  (JEU : '
        ENDIF
        WRITE (IFM,1000) ILIAI,'(',NOE,' - ',CMP,') :',
     &                   CHAIAC,JEU,')'
  500 CONTINUE

 1000 FORMAT (' <LIA_UNIL> <> LIAISON ',I5,A1,A8,A3,A8,A4,A15,E10.3,A1)
C
      CALL JEDEMA()
C
      END
