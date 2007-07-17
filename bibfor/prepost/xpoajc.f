      SUBROUTINE XPOAJC(NNM,INM,INMTOT,NBMAC,NSEMAX,IT,ISE,
     &                  JCESD1,JCESD2,JCVID1,JCVID2,
     &                  IMA,NDIM,NDIME,IADC,IADV,
     &                  JCESV1,JCESL2,JCESV2,JCVIV1,JCVIL2,JCVIV2)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 17/07/2007   AUTEUR GENIAUT S.GENIAUT 
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
C RESPONSABLE GENIAUT S.GENIAUT
C TOLE CRP_21

      IMPLICIT NONE

      INTEGER       NNM,INM,INMTOT,NBMAC,NSEMAX,IT,ISE,NDIME
      INTEGER       JCESD1,JCESD2,IMA,NDIM,IADC,JCESV1,JCESL2,JCESV2
      INTEGER       JCVID1,JCVID2,JCVIV1,JCVIL2,JCVIV2,IDCALV,IADV
C
C   ON AJOUTE UN CHAMP DE CONTRAINTES AU NOUVEAU RESU X-FEM
C
C   IN
C     NNM    : NOMBRE DE NOUVELLES MAILLES A CREER SUR LA MAILLE PARENT
C     NBMAC  : NOMBRE DE MAILLES CLASSIQUES DU MAILLAGE FISSURE
C     NSEMAX : NOMBRE DE SOUS-ELEMENT MAX SUR UN TETRA
C     IT     : INCIDE DU TETRA
C     ISE    : INCIDE DU SOUS-ELEMENT
C     IMA    : NUM�RO DE LA MAILLE PARENT
C     NDIM   : DIMENSION DU MAILLAGE
C     NDIME  : DIMENSION TOPOLOGIQUE DE LA MAILLE
C     IADC   : DECALAGE DUE A IMA DANS LE CHAMP DE CONTRAINTES 1
C     JCESV1 : ADRESSE DU .CESV DU CHAM_ELEM_S DE CONTRAINTES ENTREE
C
C   OUT
C     INM    : COMPTEUR LOCAL DU NOMBRE DE NOUVELLES MAILLES CREEES
C     INMTOT : COMPTEUR TOTAL DU NOMBRE DE NOUVELLES MAILLES CREEES
C     JCESL2 : ADRESSE DU .CESL DU CHAM_ELEM_S DE CONTRAINTES SORTIE
C     JCESV2 : ADRESSE DU .CESV DU CHAM_ELEM_S DE CONTRAINTES SORTIE


C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
      CHARACTER*32 JEXNOM,JEXNUM,JEXATR
C---------------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------

      REAL*8           VAL
      INTEGER       IACON2,J,NNOSE,INO1,INO2,NDOUBL,IDECAL
      INTEGER       NCMP1,NCMP2,NPG1,NPG2,IPG,ICMP,IAD2,IAD1
      INTEGER       NCMV1,NCMV2,NPGV1,NPGV2
      CHARACTER*8   VALK(2),K8B
      CHARACTER*19  MA2CON
      DATA          VALK /'MAILLES','XPOAJM'/
      
      
      CALL JEMARQ()

      IF (INMTOT.GE.999999) CALL U2MESK('F','XFEM_8',1,VALK)

      INM    = INM    + 1
      INMTOT = INMTOT + 1
      IF (INM.GT.NNM) CALL U2MESK('F','XFEM_9',2,VALK)

      IF (NDIM.EQ.3) NPG1  = 15
      IF (NDIM.EQ.2) NPG1  = 3

      NCMP1 = ZI(JCESD1-1+5+4* (IMA-1)+3)
      NPG2  = ZI(JCESD2-1+5+4* (NBMAC +INMTOT-1)+1)

C     PAS DE CONTRAINTES POUR LES ELEMENTS DE BORD
      IF (NDIME.NE.NDIM) THEN
        CALL ASSERT(NPG2.EQ.0)
        GOTO 999
      ENDIF
      
      IF (NPG2.NE.1) CALL U2MESS('F','XFEM_10')

      NCMP2 = ZI(JCESD2-1+5+4* (NBMAC +INMTOT-1)+3)
      CALL ASSERT(NCMP1.EQ.NCMP2)

      IF((JCVID1 .NE. 0) .AND. (JCVID2 .NE. 0)) THEN
        NCMV1 = ZI(JCVID1-1+5+4* (IMA-1)+3)
        NPGV2 = ZI(JCVID2-1+5+4* (NBMAC +INMTOT-1)+1)
        NCMV2 = ZI(JCVID2-1+5+4* (NBMAC +INMTOT-1)+3)

        IF (NPGV2.NE.1) CALL U2MESS('F','XFEM_10')
        CALL ASSERT(NPG2.EQ.NPGV2)
        CALL ASSERT(NCMV1.LE.NCMV2)        
      ELSE
        NCMV1 = 0
        NCMV2 = 0
        NPGV2 = 0
      ENDIF
      
      
C     DECALAGE DANS LE CESV DU CHAMP DE CONTRAINTES 1 DU 
C     AU FAIT QUE L'ON EST SUR LE SOUS-TETRA (IT,ISE)
C     COMME DANS XMEL3D
C     CE DECALAGE EN PEUT PAS ETRE DONNE PAR CESEXI !!
      IDECAL = (NSEMAX*NPG1*(IT-1)+NPG1*(ISE-1))*NCMP1
      IDCALV = (NSEMAX*NPG1*(IT-1)+NPG1*(ISE-1))*NCMV1

      DO 30 ICMP = 1,NCMP1
C       VAL : MOYENNE SUR LES POINTS DE GAUSS DU CHAMP 1
        VAL=0.D0
        DO 20 IPG = 1,NPG1
          VAL =VAL + ZR(JCESV1-1+IADC-1+IDECAL+NCMP1*(IPG-1)+ICMP)
 20     CONTINUE
        CALL CESEXI('C',JCESD2,JCESL2,NBMAC +INMTOT,1,1,ICMP,IAD2)
        CALL ASSERT(IAD2.GT.0) 
        ZL(JCESL2-1+IAD2) = .TRUE.
        ZR(JCESV2-1+IAD2) = VAL
 30   CONTINUE
 
      IF(NCMV1 .NE. 0) THEN
        DO 50 ICMP = 1,NCMV1
C         VAL : MOYENNE SUR LES POINTS DE GAUSS DU CHAMP 1
          VAL=0.D0
          DO 40 IPG = 1,NPG1
            VAL =VAL + ZR(JCVIV1-1+IADV-1+IDCALV+NCMV1*(IPG-1)+ICMP)
 40       CONTINUE
          CALL CESEXI('C',JCVID2,JCVIL2,NBMAC +INMTOT,1,1,ICMP,IAD2)
          CALL ASSERT(IAD2.LT.0) 
          IAD2 = -IAD2
          ZL(JCVIL2-1+IAD2) = .TRUE.
          ZR(JCVIV2-1+IAD2) = VAL
 50     CONTINUE
      ENDIF

 999  CONTINUE      
      CALL JEDEMA()
      END
