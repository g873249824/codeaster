      SUBROUTINE OP0102(IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 14/05/2002   AUTEUR DURAND C.DURAND 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C      OPERATEUR :     CALC_CHAR_CINE
C
C
C ----------DECLARATIONS
C
      INTEGER IN,IER,IBID
      CHARACTER*1 BASE
      CHARACTER*4 OPT
      CHARACTER*8 VCINE,NOMGD,NOMGDS,KBID
      CHARACTER*14 NOMNU
      CHARACTER*16 TYPE,OPER
C
C --------- FONCTIONS EXTERNES
C
      INTEGER NBEC
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*8  K8BID
      REAL*8       INST
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C
      CALL JEMARQ()
C
      CALL INFMAJ
C
C --- RECUPERATION DES ARGUMENTS DE LA COMMANDE
C
      CALL GETRES(VCINE,TYPE,OPER)
C
C --- INST DE CALCUL
C
      CALL GETVR8(' ','INST',0,1,1,INST,IBID)
C
C --- NUME_DDL
C
      CALL GETVID(' ','NUME_DDL',0,1,1,NOMNU,INUME)
C
C --- CHAR_CINE
C
      CALL GETVID(' ','CHAR_CINE',0,1,0,K8BID,NBCHCI)
      NBCHCI = -NBCHCI
      CALL WKVECT(VCINE//'.&&LICHCIN','V V K8',NBCHCI,ILICHC)
      CALL GETVID(' ','CHAR_CINE',0,1,NBCHCI,ZK8(ILICHC),IBID)
C
C --- VERIF SUR LES GRANDEURS  GD ASSOCIEE AU NUME_DDL, GD ASSOCIEE AU
C     VCINE
      CALL DISMOI('F','NOM_GD',NOMNU,'NUME_DDL',IBID,NOMGD,IERD)
      CALL DISMOI('F','NOM_GD_SI',NOMGD,'GRANDEUR',IBID,NOMGDS,IERD)
      IF (NOMGDS(1:6).NE.TYPE(9:15)) CALL UTMESS('F','OP0102_1','LA '
     + //'GRANDEUR ASSOCIEE AU CHAMP_NO N"EST PAS EGALE A CELLE DE LA'
     + //' NUMEROTATION ')
C
C --- CREATION DU CHAMNO ET AFFECTATION DU CHAMNO
C
      BASE = 'G'
C --- OPT = ZERO --> SURCHARGE  CUMU --> CUMULE DES VALEURS DES CHCINE
      OPT = 'ZERO'
      CALL CALVCI(VCINE,NOMNU,NBCHCI,ZK8(ILICHC),INST,BASE,OPT,0)
C
      CALL JEDETR(VCINE//'.&&LICHCIN')
C
      CALL JEDEMA()
      END
