      SUBROUTINE SYMEMA ( GEOMI , PERP , PT )
      IMPLICIT   NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/02/2004   AUTEUR MJBHHPE J.L.FLEJOU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     BUT : SYMETRIE D'UN MAILLAGE PAR RAPPORT A UN PLAN
C
C     IN :
C            GEOMI  : CHAM_NO(GEOM_R) : CHAMP DE GEOMETRIE A SYMETRISER
C            PERP   : AXE PERPENDICULAIRE AU PLAN
C            PT     : UN POINT DU PLAN
C     OUT:
C            GEOMI  : CHAM_NO(GEOM_R) : CHAMP DE GEOMETRIE ACTUALISE
C
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      CHARACTER*24 COORJV
      CHARACTER*19 GEOMI
      CHARACTER*8  K8BID
      REAL*8       NORM,PREC,XD,PTI(3),PT(3),PERP(3),DIST,R8DOT,R8NRM2
      INTEGER      I, IADCOO, N1

C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C     RECUPERATION DE L'ADRESSE DES COORDONNEES ET DU NOMBRE DE POINTS
      COORJV=GEOMI(1:19)//'.VALE'
      CALL JEVEUO(COORJV,'E',IADCOO)
      CALL JELIRA(COORJV,'LONMAX',N1,K8BID)
      IADCOO = IADCOO - 1
      N1=N1/3

C     NORMALISATION DE PERP
      PREC=1.D-14
      NORM = R8NRM2(3,PERP,1)
      IF ( NORM .LT. PREC ) THEN
        CALL UTMESS('F','SYMEMA','VECTEUR DE NORME TROP PETITE')      
      ENDIF
      PERP(1) = PERP(1)/NORM
      PERP(2) = PERP(2)/NORM
      PERP(3) = PERP(3)/NORM
C     LE PLAN PASSE PAR "PT"
      XD = -R8DOT(3,PERP,1,PT,1)

C     BOUCLE SUR TOUS LES POINTS
      DO 10 I=1 , N1
        PTI(1) = ZR(IADCOO+3*(I-1)+1)
        PTI(2) = ZR(IADCOO+3*(I-1)+2)
        PTI(3) = ZR(IADCOO+3*(I-1)+3)
        DIST =  R8DOT(3,PERP,1,PTI,1) + XD
        ZR(IADCOO+3*(I-1)+1) = -2.0D0*DIST*PERP(1) + PTI(1)
        ZR(IADCOO+3*(I-1)+2) = -2.0D0*DIST*PERP(2) + PTI(2)
        ZR(IADCOO+3*(I-1)+3) = -2.0D0*DIST*PERP(3) + PTI(3)
 10   CONTINUE

      CALL JEDEMA()
      END
