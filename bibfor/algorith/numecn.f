      SUBROUTINE NUMECN(MODELE,CHAMP,NU)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/05/2004   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C RESPONSABLE VABHHTS J.PELLET
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       24/11/03 (OB): PAR ADHERENCE A NUEFFE.
C----------------------------------------------------------------------
      IMPLICIT NONE
      CHARACTER*(*) MODELE,CHAMP,NU
C ----------------------------------------------------------------------
C BUT CREER UN NUME_DDL SANS STOCKAGE (POUR CALC_NO)
C ----------------------------------------------------------------------
      CHARACTER*32 JEXNUM
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
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      CHARACTER*8 KBID,MO
      CHARACTER*24 LLIGR
      CHARACTER*19 PRFCHN,NOMLIG
      INTEGER IBID,NB1,JLLIGR,I1,I2,IRET,NB2
      CHARACTER*19 K19BID
C DEB ------------------------------------------------------------------

      CALL JEMARQ()
      K19BID = ' '
      MO=MODELE

      CALL DISMOI('F','PROF_CHNO',CHAMP,'CHAM_NO',IBID,PRFCHN,IBID)
      CALL JELIRA(PRFCHN//'.LILI','NOMMAX',NB1,KBID)

      LLIGR = '&&NUMECN.LISTE_LIGREL'
      IF (NB1.EQ.1) THEN
        CALL WKVECT(LLIGR,'V V K24',1,JLLIGR)
        ZK24(JLLIGR-1+1) = MO//'.MODELE'
      ELSE
C       ON N'AJOUTE QUE LES LIGRELS QUI EXISTENT ENCORE :
        NB2=0
        DO 10 I1 = 2,NB1
          CALL JENUNO(JEXNUM(PRFCHN//'.LILI',I1),NOMLIG)
          CALL JEEXIN(NOMLIG//'.LIEL',IRET)
          IF (IRET.NE.0) THEN
            IF (NOMLIG.NE.MO//'.MODELE' )  NB2=NB2+1
          END IF
   10   CONTINUE
        CALL WKVECT(LLIGR,'V V K24',NB2+1,JLLIGR)
        I2=1
        ZK24(JLLIGR-1+I2) = MO//'.MODELE'
        DO 11 I1 = 2,NB1
          CALL JENUNO(JEXNUM(PRFCHN//'.LILI',I1),NOMLIG)
          CALL JEEXIN(NOMLIG//'.LIEL',IRET)
          IF (IRET.NE.0) THEN
            IF (NOMLIG.NE.MO//'.MODELE' ) THEN
              I2=I2+1
              ZK24(JLLIGR-1+I2) = NOMLIG
            END IF
          END IF
   11   CONTINUE
      END IF

      CALL NUEFFE(LLIGR,'G',NU,'SANS','GCPC',' ',K19BID,IBID)
      CALL JEDETR(LLIGR)
      CALL JEDEMA()
      END
