      SUBROUTINE TE0067 ( OPTION , NOMTE )
      IMPLICIT   NONE
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2005   AUTEUR CIBHHPD L.SALMONA 
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
C
C    - FONCTION REALISEE:  CALCUL DE Z EN 2D ET AXI
C                          CHGT DE PHASE METALURGIQUE
C                          OPTION : 'META_ELGA_TEMP  ' 'META_ELNO_TEMP'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*16       COMPOR(3)
      CHARACTER*2        CODE
      REAL*8             TPG1,TPG0,TPG2,DT10,DT21
      REAL*8             TNO1,TNO0,TNO2
      REAL*8             METAPG(63),METAZI(27)
      INTEGER            KP,KN,I,J,K,IADTRC,NBCB1,NBCB2,NBLEXP,JGANO
      INTEGER            NDIM,NNO,NNOS,IPOIDS,IVF,NPG,IADEXP,ICOMPO
      INTEGER            IMATE,ITEMPE,ITEMPA,ITEMPS,ITEMPI,IPHASI,IPHASO
      INTEGER            MATOS,NBHIST,NBTRC,IADCKM,IDFDE
      INTEGER            IPFTRC,JFTRC,JTRC,IPHASN,NCMP
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      CALL JEVECH ( 'PMATERC', 'L', IMATE  )
      CALL JEVECH ( 'PCOMPOR', 'L', ICOMPO )
      CALL JEVECH ( 'PTEMPAR', 'L', ITEMPA )
      CALL JEVECH ( 'PTEMPER', 'L', ITEMPE )
      CALL JEVECH ( 'PTEMPIR', 'L', ITEMPI )
      CALL JEVECH ( 'PTEMPSR', 'L', ITEMPS )
      CALL JEVECH ( 'PPHASIN', 'L', IPHASI )

      CALL JEVECH ( 'PPHASNOU', 'E', IPHASN )
C
      COMPOR(1)=ZK16(ICOMPO)
      MATOS = ZI(IMATE)


C ON RECALCUL DIRECTEMENT A PARTIR DES TEMPERATURES AUX NOEUDS
 
 
      IF (COMPOR(1) .EQ. 'ACIER') THEN
        CALL JEVECH ( 'PFTRC'  , 'L', IPFTRC )
        JFTRC = ZI(IPFTRC)
        JTRC  = ZI(IPFTRC+1)

        CALL RCADMA ( MATOS, 'META_ACIER', 'TRC', IADTRC, CODE, 'FM' )
C
        NBCB1  = NINT( ZR(IADTRC+1) )
        NBHIST = NINT( ZR(IADTRC+2) )
        NBCB2  = NINT( ZR(IADTRC+1+2+NBCB1*NBHIST) )
        NBLEXP = NINT( ZR(IADTRC+1+2+NBCB1*NBHIST+1) )
        NBTRC  = NINT( ZR(IADTRC+1+2+NBCB1*NBHIST+2+NBCB2*NBLEXP+1) )
        IADEXP = 5 + NBCB1*NBHIST
        IADCKM = 7 + NBCB1*NBHIST + NBCB2*NBLEXP
C
        DO 102 KN=1,NNO

           TNO1 = ZR(ITEMPE+KN-1)
           TNO0 = ZR(ITEMPA+KN-1)
           TNO2 = ZR(ITEMPI+KN-1)
 
           DT10 = ZR(ITEMPS+1)
           DT21 = ZR(ITEMPS+2)


           
           CALL ZACIER(MATOS,NBHIST, ZR(JFTRC), ZR(JTRC),
     &          ZR(IADTRC+3), ZR(IADTRC+IADEXP),
     &          ZR(IADTRC+IADCKM), NBTRC,TNO0,TNO1,TNO2,
     &          DT10,DT21,ZR(IPHASI+7*(KN-1)),METAPG(1+7*(KN-1)) )


           DO 87 I=1,7
              ZR(IPHASN+7*(KN-1)+I-1) = METAPG(1+7*(KN-1)+I-1)

  87       CONTINUE
 102    CONTINUE 


      ELSEIF (COMPOR(1)(1:4).EQ. 'ZIRC') THEN
        DO 103 KN=1,NNO

           TNO1 = ZR(ITEMPE+KN-1)
           TNO2 = ZR(ITEMPI+KN-1)

           DT21 = ZR(ITEMPS+2)

           CALL ZEDGAR(MATOS,TNO1,TNO2,DT21,ZR(IPHASI+3*(KN-1)),
     &                METAZI(1+3*(KN-1)))

           DO 88 I=1,3
              ZR(IPHASN+3*(KN-1)+I-1) = METAZI(1+3*(KN-1)+I-1)
 88        CONTINUE
 103    CONTINUE
 
      ENDIF


C
C
      CALL JEDEMA()
      END
