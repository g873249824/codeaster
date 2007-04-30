      SUBROUTINE XMCHEX(NOMA  ,NBMA  ,CHELEX)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/04/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT      NONE
      CHARACTER*19  CHELEX
      INTEGER       NBMA
      CHARACTER*8   NOMA
C               
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - CREATION CHAM_ELEM)
C
C CREATION D'UN CHAM_ELEM_S VIERGE POUR ETENDRE LE CHAM_ELEM
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NBMA   : NOMBRE DE MAILLES
C OUT CHELEX : CHAM_ELEM_S PERMETTANT DE CREER UN CHAM_ELEM "ETENDU"
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
      INTEGER       NBCMP,NBSPG
      PARAMETER     (NBCMP = 2,NBSPG = 60)
      CHARACTER*8   LICMP(NBCMP)
      CHARACTER*19  VALK(2)
      INTEGER       VALI(1)
C
      INTEGER       IAD,IMA
      INTEGER       JCESL,JCESV,JCESD   
C
      DATA LICMP    / 'NPG_DYN', 'NCMP_DYN'/    
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()       
C
C --- CREATION DU CHAM_ELEM_S VIERGE
C           
      CALL CESCRE('V',CHELEX,'ELEM',NOMA,'DCEL_I',NBCMP,LICMP,
     &            -1,-1,-NBCMP)
C     
C --- ACCES AU CHAM_ELEM_S
C     
      CALL JEVEUO(CHELEX(1:19)//'.CESD','L',JCESD)
      CALL JEVEUO(CHELEX(1:19)//'.CESL','E',JCESL)
      CALL JEVEUO(CHELEX(1:19)//'.CESV','E',JCESV)
C   
C --- AFFECTATION DES COMPOSANTES DU CHAM_ELEM_S
C   
      DO 100 IMA = 1,NBMA
        CALL CESEXI('C',JCESD,JCESL,IMA,1,1,1,IAD)
        IF (IAD.GE.0) THEN
          VALI(1) = 1
          VALK(1) = CHELEX(1:19)
          VALK(2) = 'ELEM'
          CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
        ENDIF
        ZL(JCESL-1-IAD) = .TRUE.
        ZI(JCESV-1-IAD) = NBSPG
        CALL CESEXI('C',JCESD,JCESL,IMA,1,1,2,IAD)
        IF (IAD.GE.0) THEN
          VALI(1) = 1
          VALK(1) = CHELEX(1:19)
          VALK(2) = 'ELEM'
          CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
        ENDIF
        ZL(JCESL-1-IAD) = .TRUE.
        ZI(JCESV-1-IAD) = 1
100   CONTINUE  
C
      
C
      CALL JEDEMA()
C   
      END
