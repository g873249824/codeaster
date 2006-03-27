      SUBROUTINE TE0515(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 27/03/2006   AUTEUR GENIAUT S.GENIAUT 
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
C                          DES SOUS-ELEMENTS (TETRAEDRES)
C                          (ELEMENTS 3D AVEC X-FEM)
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
      INTEGER NIT,    IT,     NSE,    ISE,    CPT
      INTEGER INO,    IPT,    IN,     IN1,    NNOP
      INTEGER NDIM,   NNO,    NNOS,   NPG,    IPOIDS
      INTEGER IVF,    IDFDE,  JGANO,  INOE,   IADZI,   IAZK24
      INTEGER IND,    IND1,   IND2,   NNI,    JBASLO

      INTEGER  KPG,KK,N,I,M,J,J1,KL,PQ,KKD,DDLT,NFE,IBID,NDDL
      INTEGER  NPGBIS,NNOM
      INTEGER  JCOOPG,JDFD2,JCOORS
      REAL*8   DEPLA(3)
      REAL*8   DEPR(3,33)
   
      CHARACTER*8 ELREFP

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
      PARAMETER    (NSEMAX=6)
      CALL JEMARQ()
      CALL TECAEL(IADZI,IAZK24)

      CALL XTEINI(NOMTE,DDLH,NFE,IBID,DDLC,NNOM,DDLT,NDDL)

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      NNOP = NNO
      CALL ELREF1(ELREFP)

C -   PARAMETRES EN ENTREE
      CALL JEVECH('PDEPLPR','L',IDEPLR)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEXFEM','E',IDXFEM)

C     PARAM�TRES PROPRES � X-FEM
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PHEAVTO','L',JHEAVT)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASLOR','L',JBASLO)
      CALL JEVECH('PLSN','L',JLSN)
      CALL JEVECH('PLST','L',JLST)

C     NOMBRE MAX DE SOUS-ELEMENTS: NSEMX
      NSEMX=0
      DO 10 I=1,ZI(JLONCH)
         NSEMX=NSEMX+ZI(JLONCH+I)
 10   CONTINUE

C     VERIFICATION QUE LA MAILLE EST DE TYPE HEXA,PENTA OU TETRA
      IF(ZK24(IAZK24+ZI(IADZI+1)+5)(1:4).EQ.'HEXA')THEN
         NBNOSO=8
      ELSEIF(ZK24(IAZK24+ZI(IADZI+1)+5)(1:5).EQ.'PENTA')THEN
         NBNOSO=6
      ELSEIF(ZK24(IAZK24+ZI(IADZI+1)+5)(1:5).EQ.'TETRA')THEN
         NBNOSO=4
      ELSE
         CALL UTMESS('F','TE0515','TYPE DE MAILLE NON VALIDE ' //
     &        'POUR LE POST-TRAITEMENT DES ELEMENTS XFEM')
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

C- R�CUP�RATION DE LA SUBDIVISION L'�L�MENT PARENT EN NIT TETRAS 
      NIT=ZI(JLONCH)

      CPT=0
      KK=0

C     BOUCLE SUR LES NIT TETRAS

      DO 100 IT=1,NIT

C        R�CUP�RATION DU D�COUPAGE EN NSE SOUS-�L�MENTS 
         NSE=ZI(JLONCH+IT)

C       BOUCLE D'INT�GRATION SUR LES NSE SOUS-�L�MENTS
        DO 110 ISE=1,NSE
          CALL LCINVN(3*NNOP,0.D0,DEPR)
          CPT=CPT+1

C         FONCTION HEAVYSIDE CSTE SUR LE SOUS-ELEMENTS
          HE=ZI(JHEAVT-1+NSEMAX*(IT-1)+ISE)

C    BOUCLE SUR LES 4 SOMMETS DU SOUS-T�TRA
          DO 120 JNO=1,4
             INO=ZI(JCNSET-1 + 4*(CPT-1)+JNO)
              CALL  XDEL3D(ELREFP,INO,NNOP,IGEOM,ZR(JPINTT),ZR(IDEPLR),
     &              HE,DDLH,NFE,DDLT,ZR(JBASLO),ZR(JLSN),ZR(JLST),DEPLA)
              IF(INO.LT.1000)THEN
                 IF(ZI(IND1+INO-1).EQ.0)THEN
                    ZR(IDXFEM+3*(INO-1))  = DEPLA(1)
                    ZR(IDXFEM+3*(INO-1)+1)= DEPLA(2)
                    ZR(IDXFEM+3*(INO-1)+2)= DEPLA(3)
                    ZI(IND1+INO-1)=INO
                 ENDIF
              ELSE
                 IF(ZI(IND2+2*(INO-1001)).EQ.0.AND.HE.LT.0)THEN
                    ZR(IDXFEM+NBNOSO*3+KK)  = DEPLA(1)
                    ZR(IDXFEM+NBNOSO*3+KK+1)= DEPLA(2)
                    ZR(IDXFEM+NBNOSO*3+KK+2)= DEPLA(3)
                    ZI(IND2+2*(INO-1001))=INO
                    KK=KK+3
                 ELSEIF(ZI(IND2+2*(INO-1001)+1).EQ.0.AND.HE.GT.0)THEN
                    ZR(IDXFEM+NBNOSO*3+KK)  = DEPLA(1)
                    ZR(IDXFEM+NBNOSO*3+KK+1)= DEPLA(2)
                    ZR(IDXFEM+NBNOSO*3+KK+2)= DEPLA(3)
                    ZI(IND2+2*(INO-1001)+1)=INO
                    KK=KK+3
                 ENDIF
              ENDIF
120       CONTINUE
110     CONTINUE
100   CONTINUE
C
      CALL JEDETR('&&TE0515.IND')
      CALL JEDETR('&&TE0515.IND1')
      IF(NNI.NE.0) CALL JEDETR('&&TE0515.IND2')
      CALL JEDETR('&&TE0515.TMP')
C
      CALL JEDEMA()
C
      END
