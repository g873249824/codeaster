      SUBROUTINE TE0515(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 20/02/2007   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES DEPLACEMENTS REELS AUX NOEUDS
C                          DES SOUS-ELEMENTS (TRIANGLES,TETRAEDRES)
C                          (ELEMENTS 2D 3D AVEC X-FEM)
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C
C    - OPTION CALCULEE : DEPL_POST_XFEM
C ......................................................................
C
      INTEGER JPINTT, JCNSET, JHEAVT, JLONCH, JLSN, JLST
      INTEGER IDEPLR, IGEOM,  IDXFEM, NSEMAX, NBNOSO, NSEMX
      INTEGER DDLH,   DDLE,   DDLC,   JNO,    HE
      INTEGER NIT,    IT,     NSE,    ISE,    CPT,  CPT2
      INTEGER INO,    IPT,    IN,     IN1,    NNOP
      INTEGER NDIM,   NNO,    NNOS,   NPG,    IPOIDS
      INTEGER IVF,    IDFDE,  JGANO,  INOE,   IADZI,   IAZK24
      INTEGER IND,    IND1,   IND2,   NNI,    JBASLO

      INTEGER  KPG,KK,I,M,J,J1,KL,PQ,KKD,DDLT,NFE,IBID,NDDL,IE
      INTEGER  NPGBIS,NNOM, NTET,NBCMP,NDIME,JDIM
      INTEGER  JCOOPG,JDFD2,JCOORS,JCOR2D,IGEO2D
      REAL*8   DEPLA(3),A(3),B(3),C(3),AB(3),AC(3),Y(3),R,T,LSN,LST
      REAL*8   N(3),AN(3),DDOT,XE(3),FF(4),FE(4)
      REAL*8   ND(3),NORME,NAB,RBID,GLOC(2)

      CHARACTER*8 ELREFP,NOMA
      CHARACTER*24 COORSE,COOR2D,GEOM2D

      LOGICAL L2D3D

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CALL JEMARQ()
      CALL TECAEL(IADZI,IAZK24)

C     DIMENTION DE L'ESPACE : NDIM
      NOMA=ZK24(IAZK24)
      CALL JEVEUO(NOMA//'.DIME','L',JDIM)
      NDIM=ZI(JDIM-1+6)

C     DIMENSION DE L'ELEMENT FINI : NDIME
      CALL ELREF4(' ','RIGI',NDIME,NNOP,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
C     POUR LES ELEMENTS DE BORD 2D, L2D3D=.TRUE.
      L2D3D=.FALSE.
      IF(NDIM.NE.NDIME)L2D3D=.TRUE.
C
      IF(NDIM.EQ.3)THEN
        NTET=4
        NBCMP=3
        NSEMAX=6
      ELSE
        NTET=3
        NBCMP=2
        NSEMAX=3
      ENDIF

      IF(NOMTE(1:12).EQ.'MECA_XH_FACE')THEN
        NTET=3
        NSEMAX=3
        DDLH=3
        NFE=0
      ELSEIF(NOMTE(1:13).EQ.'MECA_XHT_FACE') THEN
        NTET=3
        NSEMAX=3
        DDLH=3
        NFE=4
      ELSEIF(NOMTE(1:12).EQ.'MECA_XT_FACE')THEN
        NTET=3
        NSEMAX=3
        DDLH=0
        NFE=4
      ENDIF
      DDLT=3+DDLH+NFE*3    

C
      CALL ELREF1(ELREFP)

C -   PARAMETRES :
      CALL JEVECH('PLSN','L',JLSN)
      CALL JEVECH('PLST','L',JLST)
      CALL JEVECH('PDEPLPR','L',IDEPLR)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PHEAVTO','L',JHEAVT)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PDEXFEM','E',IDXFEM)

C     NOMBRE MAX DE SOUS-ELEMENTS: NSEMX
      NSEMX=0
      DO 10 I=1,ZI(JLONCH)
         NSEMX=NSEMX+ZI(JLONCH+I)
 10   CONTINUE

C     VERIFICATION QUE LA MAILLE EST DE TYPE HEXA,PENTA OU TETRA ..
      IF(ZK24(IAZK24+ZI(IADZI+1)+5)(1:4).EQ.'HEXA')THEN
         NBNOSO=8
      ELSEIF(ZK24(IAZK24+ZI(IADZI+1)+5)(1:5).EQ.'PENTA')THEN
         NBNOSO=6
      ELSEIF(ZK24(IAZK24+ZI(IADZI+1)+5)(1:5).EQ.'TETRA')THEN
         NBNOSO=4
      ELSEIF(ZK24(IAZK24+ZI(IADZI+1)+5)(1:4).EQ.'TRIA')THEN
         NBNOSO=3
      ELSEIF(ZK24(IAZK24+ZI(IADZI+1)+5)(1:4).EQ.'QUAD')THEN
         NBNOSO=4
      ELSE
         CALL U2MESS('F','ELEMENTS4_14')
      ENDIF
C     NOMBRE DE NOEUDS D'INTERSECTION: NNI
      NNI=ZI(JLONCH+ZI(JLONCH)+1)
C
      CALL WKVECT('&&TE0515.IND','V V I', NSEMX,IND)
      CALL WKVECT('&&TE0515.IND1','V V I',NBNOSO,IND1)
      IF (NNI.NE.0) THEN
         CALL WKVECT('&&TE0515.IND2','V V I',NNI*2,IND2)
      ENDIF
      DO 18 I=1,NBNOSO
         ZI(IND1+I-1)=0
 18   CONTINUE



C --- CAS 1 : ELEMENTS VOLUMIQUE OU SURFACIQUE (DIME=DIM)
C     ===================================================
      IF(.NOT.L2D3D)THEN

      CALL JEVECH('PBASLOR','L',JBASLO)

C     R�CUP�RATION DE LA SUBDIVISION L'�L�MENT PARENT EN NIT TETRAS
C     (OU TRIANGLES).
      NIT=ZI(JLONCH)

      CPT=0
      KK=0

C     BOUCLE SUR LES NIT TETRAS

C     INITIALISATION
      CALL XTEINI(NOMTE,DDLH,NFE,IBID,DDLC,NNOM,DDLT,NDDL)

      DO 100 IT=1,NIT

C        R�CUP�RATION DU D�COUPAGE EN NSE SOUS-�L�MENTS
         NSE=ZI(JLONCH+IT)

C       BOUCLE D'INT�GRATION SUR LES NSE SOUS-�L�MENTS
        DO 110 ISE=1,NSE

          CPT=CPT+1

C         FONCTION HEAVYSIDE CSTE SUR LE SOUS-ELEMENTS
          HE=ZI(JHEAVT-1+NSEMAX*(IT-1)+ISE)

C    BOUCLE SUR LES 4 (OU 3) SOMMETS DU SOUS-T�TRA (OU TRIANGLE)
          DO 120 JNO=1,NTET
             INO=ZI(JCNSET-1 + NTET*(CPT-1)+JNO)
              CALL  XDEPLA(NDIM,ELREFP,INO,NNOP,IGEOM,ZR(JPINTT),
     &                     ZR(IDEPLR),HE,DDLH,NFE,DDLT,ZR(JBASLO),
     &                     ZR(JLSN),ZR(JLST),DEPLA)
              IF(INO.LT.1000)THEN
                 IF(ZI(IND1+INO-1).EQ.0)THEN
                    ZR(IDXFEM+NBCMP*(INO-1))  = DEPLA(1)
                    ZR(IDXFEM+NBCMP*(INO-1)+1)= DEPLA(2)
                    IF(NDIM.EQ.3)ZR(IDXFEM+NBCMP*(INO-1)+2)= DEPLA(3)
                    ZI(IND1+INO-1)=INO
                 ENDIF
              ELSE
                 IF(ZI(IND2+2*(INO-1001)).EQ.0.AND.HE.LT.0)THEN
                    ZR(IDXFEM+NBNOSO*NBCMP+KK)  = DEPLA(1)
                    ZR(IDXFEM+NBNOSO*NBCMP+KK+1)= DEPLA(2)
                    IF(NDIM.EQ.3)ZR(IDXFEM+NBNOSO*NBCMP+KK+2)= DEPLA(3)
                    ZI(IND2+2*(INO-1001))=INO
                    KK=KK+NBCMP
                 ELSEIF(ZI(IND2+2*(INO-1001)+1).EQ.0.AND.HE.GT.0)THEN
                    ZR(IDXFEM+NBNOSO*NBCMP+KK)  = DEPLA(1)
                    ZR(IDXFEM+NBNOSO*NBCMP+KK+1)= DEPLA(2)
                    IF(NDIM.EQ.3)ZR(IDXFEM+NBNOSO*NBCMP+KK+2)= DEPLA(3)
                    ZI(IND2+2*(INO-1001)+1)=INO
                    KK=KK+NBCMP
                 ENDIF
              ENDIF
120       CONTINUE
110     CONTINUE
100   CONTINUE
C
C --- CAS 2 : ELEMENTS DE BORD 2D (DIME=2,DIM=3)
C     ==========================================
      ELSE

      CPT=0
      KK=0
      COORSE='&&TE0515.COORSE'
      COOR2D='&&TE0515.COOR2D'
      GEOM2D='&&TE0036.GEOM2D'

C     R�CUP�RATION DE LA SUBDIVISION L'�L�MENT PARENT EN NIT TRIANGLES
      NIT=ZI(JLONCH)

C     BOUCLE SUR LES NIT TRIANGLES
      DO 200 IT=1,NIT

C        R�CUP�RATION DU D�COUPAGE EN NSE SOUS-�L�MENTS
         NSE=ZI(JLONCH+IT)

C       BOUCLE D'INT�GRATION SUR LES NSE SOUS-�L�MENTS

        DO 210 ISE=1,NSE
          CPT=CPT+1

C         COORD DU SOUS-ELT EN QUESTION
          CALL WKVECT(COORSE,'V V R',NDIM*NTET,JCOORS)
          DO 212 JNO=1,NTET
           INO=ZI(JCNSET-1 + NTET*(CPT-1)+JNO)
C
           IF (INO.LT.1000) THEN
            ZR(JCOORS-1+NDIM*(JNO-1)+1)=ZR(IGEOM-1+NDIM*(INO-1)+1)
            ZR(JCOORS-1+NDIM*(JNO-1)+2)=ZR(IGEOM-1+NDIM*(INO-1)+2)
            ZR(JCOORS-1+NDIM*(JNO-1)+3)=ZR(IGEOM-1+NDIM*(INO-1)+3)
           ELSE
            ZR(JCOORS-1+NDIM*(JNO-1)+1)=ZR(JPINTT-1+NDIM*(INO-1000-1)+1)
            ZR(JCOORS-1+NDIM*(JNO-1)+2)=ZR(JPINTT-1+NDIM*(INO-1000-1)+2)
            ZR(JCOORS-1+NDIM*(JNO-1)+3)=ZR(JPINTT-1+NDIM*(INO-1000-1)+3)
          ENDIF
212      CONTINUE

C         ON RENOMME LES SOMMETS DU SOUS-TRIA : A, B ET C
          DO 213 J=1,NDIM
            A(J)=ZR(JCOORS-1+J)
            B(J)=ZR(JCOORS-1+NDIM+J)
            C(J)=ZR(JCOORS-1+2*NDIM+J)
            AB(J)=B(J)-A(J)
            AC(J)=C(J)-A(J)
 213      CONTINUE

C         CREATION DU REPERE LOCAL 2D : (AB,Y)
          CALL PROVEC(AB,AC,ND)
          CALL NORMEV(ND,NORME)
          CALL NORMEV(AB,NAB)
          CALL PROVEC(ND,AB,Y)

C         COORDONN�ES DES SOMMETS DE LA FACETTE DANS LE REP�RE LOCAL 2D
          CALL WKVECT(COOR2D,'V V R',NTET*NDIME,JCOR2D)
          ZR(JCOR2D-1+1)=0.D0
          ZR(JCOR2D-1+2)=0.D0
          ZR(JCOR2D-1+3)=NAB
          ZR(JCOR2D-1+4)=0.D0
          ZR(JCOR2D-1+5)=DDOT(3,AC,1,AB,1)
          ZR(JCOR2D-1+6)=DDOT(3,AC,1,Y ,1)

C         COORDONN�ES DES NOEUDS DE L'ELREFP DANS LE REP�RE LOCAL 2D
          CALL WKVECT(GEOM2D,'V V R',NNOP*NDIME,IGEO2D)
          DO 214 JNO=1,NNOP
            DO 215 J=1,NDIM
              N(J)=ZR(IGEOM-1+NDIM*(JNO-1)+J)
              AN(J)=N(J)-A(J)
 215        CONTINUE
            ZR(IGEO2D-1+2*(JNO-1)+1)=DDOT(NDIM,AN,1,AB,1)
            ZR(IGEO2D-1+2*(JNO-1)+2)=DDOT(NDIM,AN,1,Y ,1)
 214      CONTINUE

C         FONCTION HEAVYSIDE CSTE SUR LE SOUS-ELEMENTS
          HE=ZI(JHEAVT-1+NSEMAX*(IT-1)+ISE)

C         BOUCLE SUR LES 3 SOMMETS DU SOUS-TRIANGLE
          DO 220 JNO=1,NTET

            INO=ZI(JCNSET-1 + NTET*(CPT-1)+JNO)
            CALL LCINVN(NTET,0.D0,DEPLA)

C           FF AUX NOEUDS DE L'ELREFP DANS LE REPERE LOCAL
            GLOC(1)=ZR(JCOR2D+2*JNO-2)
            GLOC(2)=ZR(JCOR2D+2*JNO-1)
            CALL REEREF(ELREFP,NNOP,IGEO2D,GLOC,RBID,.FALSE.,NDIME,RBID,
     &       IBID,IBID,IBID,RBID,RBID,'NON',XE,FF,RBID,RBID,RBID,RBID)

            IF (NFE.GT.0) THEN
C             LEVEL SETS AU SOMMET
              LSN = 0.D0
              LST = 0.D0
              DO 222 IN=1,NNOP
                LSN = LSN + ZR(JLSN-1+IN) * FF(IN)
                LST = LST + ZR(JLST-1+IN) * FF(IN)
 222          CONTINUE

C             COORDONN�ES POLAIRES DU SOMMET
              R = SQRT(LSN**2+LST**2)
              T = HE * ABS(ATAN2(LSN,LST))
C
C             FONCTIONS D'ENRICHISSEMENT
              FE(1)=SQRT(R)*SIN(T/2.D0)
              FE(2)=SQRT(R)*COS(T/2.D0)
              FE(3)=SQRT(R)*SIN(T/2.D0)*SIN(T)
              FE(4)=SQRT(R)*COS(T/2.D0)*SIN(T)
            ENDIF

              DO 300 IN=1,NNOP
                CPT2=0
C               DDLS CLASSIQUES
                DO 301 I=1,NDIM
                  CPT2=CPT2+1
                  DEPLA(I) = DEPLA(I) +
     &                       FF(IN) * ZR(IDEPLR-1+DDLT*(IN-1)+CPT2)
 301            CONTINUE

C               DDLS HEAVISIDE
                DO 302 I=1,DDLH
                  CPT2=CPT2+1
                  DEPLA(I) = DEPLA(I) +
     &                       HE * FF(IN) * ZR(IDEPLR-1+DDLT*(IN-1)+CPT2)
 302            CONTINUE

C               DDLS SINGULIER
                DO 303 IE=1,NFE
                  DO 304 J=1,NDIM
                    CPT2=CPT2+1
                    DEPLA(I) = DEPLA(I) +
     &                   FE(IE) * FF(IN) * ZR(IDEPLR-1+DDLT*(IN-1)+CPT2)
 304              CONTINUE
 303            CONTINUE
 300          CONTINUE
C
              IF(INO.LT.1000)THEN
                 IF(ZI(IND1+INO-1).EQ.0)THEN
                    ZR(IDXFEM+NBCMP*(INO-1))  = DEPLA(1)
                    ZR(IDXFEM+NBCMP*(INO-1)+1)= DEPLA(2)
                    ZR(IDXFEM+NBCMP*(INO-1)+2)= DEPLA(3)
                    ZI(IND1+INO-1)=INO
                 ENDIF
              ELSE
                 IF(ZI(IND2+2*(INO-1001)).EQ.0.AND.HE.LT.0)THEN
                    ZR(IDXFEM+NBNOSO*NBCMP+KK)  = DEPLA(1)
                    ZR(IDXFEM+NBNOSO*NBCMP+KK+1)= DEPLA(2)
                    ZR(IDXFEM+NBNOSO*NBCMP+KK+2)= DEPLA(3)
                    ZI(IND2+2*(INO-1001))=INO
                    KK=KK+NBCMP
                 ELSEIF(ZI(IND2+2*(INO-1001)+1).EQ.0.AND.HE.GT.0)THEN
                    ZR(IDXFEM+NBNOSO*NBCMP+KK)  = DEPLA(1)
                    ZR(IDXFEM+NBNOSO*NBCMP+KK+1)= DEPLA(2)
                    ZR(IDXFEM+NBNOSO*NBCMP+KK+2)= DEPLA(3)
                    ZI(IND2+2*(INO-1001)+1)=INO
                    KK=KK+NBCMP
                 ENDIF
              ENDIF
220       CONTINUE
          CALL JEDETR(COORSE)
          CALL JEDETR(GEOM2D)
          CALL JEDETR(COOR2D)
210     CONTINUE
200   CONTINUE
      ENDIF
C
      CALL JEDETR('&&TE0515.IND')
      CALL JEDETR('&&TE0515.IND1')
      IF(NNI.NE.0) CALL JEDETR('&&TE0515.IND2')
      CALL JEDETR('&&TE0515.TMP')
C
      CALL JEDEMA()
C
      END
