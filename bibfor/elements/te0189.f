      SUBROUTINE TE0189 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/04/2002   AUTEUR CIBHHLV L.VIVAN 
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
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES NIVEAUX DE PRESSION EN DB
      IMPLICIT REAL*8 (A-H,O-Z)
C                          OU DES PRESSIONS **PARTIE REELLE**
C                          OU DES PRESSIONS **PARTIE IMAGINAIRE**
C                          ISOPARAMETRIQUES 2D
C                          OPTION : 'PRES_ELNO_DBEL'
C                          OPTION : 'PRES_ELNO_REEL'
C                          OPTION : 'PRES_ELNO_IMAG'
C    - ARGUMENTS:
C        ENTREES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      CHARACTER*8        ELREFE
      CHARACTER*16       OPTION , NOMTE
      CHARACTER*24       CARAC
      INTEGER            IDINO,ICARAC,INO,NNO
      INTEGER            IPDEB,IPREE,IPIMA,IPRES
C
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
      CALL ELREF1(ELREFE)

      CARAC='&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CARAC,'L',ICARAC)
      NNO=ZI(ICARAC)
C
      CALL JEVECH('PPRESSC','L',IPRES)
C
      IF(OPTION.EQ.'PRES_ELNO_DBEL') THEN
        CALL JEVECH('PDBEL_R','E',IPDEB)
C
C     BOUCLE SUR LES NOEUDS
C
        DO 101 INO=1,NNO
          IDINO = IPDEB +INO - 1
          ZR(IDINO) = 20.D0*LOG10(ABS(ZC(IPRES +INO-1))/2.D-5)
101     CONTINUE
      ELSEIF (OPTION.EQ.'PRES_ELNO_REEL') THEN
        CALL JEVECH('PPRESSR','E',IPREE)
C
C     BOUCLE SUR LES NOEUDS
C
        DO 201 INO=1,NNO
          IDINO = IPREE +INO - 1
          ZR(IDINO) = DBLE(ZC(IPRES +INO-1))
201     CONTINUE
      ELSE
        CALL JEVECH('PPRESSI','E',IPIMA)
C
C     BOUCLE SUR LES NOEUDS
C
        DO 301 INO=1,NNO
          IDINO = IPIMA +INO - 1
          ZR(IDINO) = DIMAG(ZC(IPRES +INO-1))
301     CONTINUE
      ENDIF
      END
