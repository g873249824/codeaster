      SUBROUTINE TE0320 ( OPTION , NOMTE )
      IMPLICIT   NONE
      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/03/2004   AUTEUR CIBHHLV L.VIVAN 
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
C    - FONCTION REALISEE: INITIALISATION DU CALCUL DE Z EN 2D ET AXI
C                         OPTION :'META_INIT' ET 'META_INIT_ELNO'
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*24       NOMRES
      CHARACTER*16       COMPOR(3)
      CHARACTER*2        CODRET
      REAL*8             TPG0,ZERO,METAPG(63),MS0,ZALPHA,ZBETA
      INTEGER            NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO
      INTEGER            ICOMPO,KP,J,K,NCMP
      INTEGER            IMATE,ITEMPE,IPHASI,IPHASO,IPHASN
C     -----------------------------------------------------------------
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
C     PARAMETRES EN ENTREE
C    ---------------------
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PCOMPOR','L',ICOMPO)
      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL JEVECH('PPHASIN','L',IPHASI)

      COMPOR(1)=ZK16(ICOMPO)

C     PARAMETRES EN SORTIE
C    ----------------------
      CALL JEVECH('PPHASOU','E',IPHASO)
      IF (OPTION .EQ. 'META_INIT_ELNO') THEN
        CALL JEVECH('PPHASNOU','E',IPHASN)
      ENDIF

      ZERO=0.D0

C     MATERIAU FERRITIQUE
C    ---------------------

      IF (COMPOR(1) .EQ. 'ACIER' ) THEN

         NOMRES = 'MS0'

         CALL RCVALA(ZI(IMATE),'META_ACIER', 1,'INST',0.D0,1,NOMRES,
     &            MS0,CODRET,'FM' )
         DO 300 KP=1,NPG
           K=(KP-1)*NNO
           TPG0 = ZERO

           DO 100 J=1,NNO
             TPG0 = TPG0 + ZR(ITEMPE+J-1)*ZR(IVF+K+J-1)
 100       CONTINUE
           DO 200 J=0,4


             METAPG(1+7*(KP-1)+J)=ZR(IPHASI+5*(KP-1)+J)
200        CONTINUE
           METAPG(1+7*(KP-1)+6)=MS0
           METAPG(1+7*(KP-1)+5)=TPG0

           DO 84 J=1,7
             ZR(IPHASO+7*(KP-1)+J-1)   = METAPG(1+7*(KP-1)+J-1)
 84        CONTINUE

300      CONTINUE

      ELSEIF (COMPOR(1)(1:4) .EQ. 'ZIRC' ) THEN
          DO 305 KP=1,NPG
           K=(KP-1)*NNO
           TPG0 = ZERO
           DO 105 J=1,NNO
             TPG0 = TPG0 + ZR(ITEMPE+J-1)*ZR(IVF+K+J-1)
 105       CONTINUE
C ----------PROPORTION TOTALE DE LA PHASE ALPHA

           METAPG(1+3*(KP-1))=ZR(IPHASI+5*(KP-1))
           METAPG(1+3*(KP-1)+1)=ZR(IPHASI+5*(KP-1)+1)
           ZALPHA = METAPG(1+3*(KP-1)) +METAPG(1+3*(KP-1)+1)

C-----------DECOMPOSITION DE LA PHASE ALPHA POUR LA MECANIQUE

           ZBETA=1-ZALPHA
           IF (ZBETA .GT. 0.1D0) THEN
             METAPG(1+3*(KP-1)) =0.D0
           ELSE
             METAPG(1+3*(KP-1))= 10*(ZALPHA-0.9D0)*ZALPHA

           ENDIF
           METAPG(1+3*(KP-1)+1)=ZALPHA-METAPG(1+3*(KP-1))
C

           METAPG(1+3*(KP-1)+2)=TPG0

           DO 85 J=1,3
             ZR(IPHASO+3*(KP-1)+J-1)   = METAPG(1+3*(KP-1)+J-1)

 85        CONTINUE


305      CONTINUE
      ENDIF

C
         IF ( OPTION .EQ. 'META_INIT_ELNO' ) THEN
            IF (COMPOR(1)(1:4) .EQ. 'ZIRC') THEN
               NCMP=3
            ELSE
               NCMP = 7
            ENDIF

            CALL PPGAN2(JGANO,NCMP,ZR(IPHASO),ZR(IPHASN))
C
         ENDIF

9999  CONTINUE
      END
