      SUBROUTINE GILIG1 ( NFIC, NDIM, NBVAL, NBPOIN )
      IMPLICIT   NONE
      INTEGER    NFIC, NDIM, NBVAL, NBPOIN 
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 21/10/98   AUTEUR CIBHHLV L.VIVAN 
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
C     BUT: LIRE LES N LIGNES DES POINTS DU MAILLAGE GIBI :
C                 ( PROCEDURE SAUVER)
C
C     IN: NFIC   : UNITE DE LECTURE
C         NDIM   : DIMENSION DU MAILLAGE : 2D OU 3D.
C         NBVAL  : NOMBRE DE VALEURS A LIRE
C
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C
      INTEGER       IACOOR, IACOO1, NBFOIS, NBREST, ICOJ, I, J, IRET
      INTEGER       IAPTIN
      REAL*8        RBID(3)
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
C     -- ON CREE L'OBJET QUI CONTIENDRA LES COORDONNEES DES POINTS:
C        (ON CREE AUSSI UN OBJET TEMPORAIRE A CAUSE DES DENSITES)
C
      CALL WKVECT ( '&&GILIRE.COORDO','V V R',NBPOIN*NDIM    ,IACOOR )
      CALL WKVECT ( '&&GILIRE.COORD1','V V R',NBPOIN*(NDIM+1),IACOO1 )
C
C     -- ON LIT LES COORDONNEES DES NOEUDS:
C
      NBFOIS = NBVAL / 3
      NBREST = NBVAL - 3*NBFOIS
      ICOJ = 0
      DO 10 I = 1 , NBFOIS
         READ(NFIC,1000) ( RBID(J), J=1,3 )
         ZR(IACOO1-1+ ICOJ +1) = RBID(1)
         ZR(IACOO1-1+ ICOJ +2) = RBID(2)
         ZR(IACOO1-1+ ICOJ +3) = RBID(3)
         ICOJ = ICOJ + 3
 10   CONTINUE
      IF ( NBREST .GT. 0 ) THEN
         READ(NFIC,1000) ( RBID(J), J=1,NBREST )
         DO 12 I = 1 , NBREST
           ZR(IACOO1-1+ ICOJ +I) = RBID(I)
 12      CONTINUE
      ENDIF
C
C     -- ON RECOPIE LES COORDONNEES EN OTANT LES DENSITES:
      DO 20 I = 1, NBPOIN
         DO 22 J = 1 , NDIM
             ZR(IACOOR-1+NDIM*(I-1)+J)=ZR(IACOO1-1+(NDIM+1)*(I-1)+J)
 22      CONTINUE
 20   CONTINUE
      CALL JEDETR('&&GILIRE.COORD1')
C
 1000  FORMAT( 3(1X,D21.14) )
C
      CALL JEDEMA()
C
      END
