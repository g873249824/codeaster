      SUBROUTINE ASSMA3(LMASYM,LMESYM,TT,MAT19,NU14,
     &    MATEL,C2,IGR,IEL,C1,RANG,IFEL2,IFEL3,IFEL4,IFEL5,IFM,ILIGRP,
     &    JNUEQ,JNUMSD,JPDMS,JRESL,NBVEL,NNOE,LFETI,LLICH,
     &    LLICHD,LLICHP,LLIMO,LMUMPS,LPDMS,ILIMA,JADLI,JADNE,
     &    JPRN1,JPRN2,JNULOC,JPOSDL,ADMODL,LCMODL,MODE,NEC,
     &    NMXCMP,NCMP,NBLC,JSMHC,JSMDI,ICONX1,ICONX2,
     &    NOMLI,NOMLID,INFOFE,
     &    JTMP2,JVALM,ILINU,IDD,ELLAGR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 11/02/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PELLET J.PELLET
      IMPLICIT NONE
C-----------------------------------------------------------------------
C BUT : ASSEMBLER UN ELEMENT FINI ORDINAIRE
C-----------------------------------------------------------------------
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
C-----------------------------------------------------------------------
      LOGICAL LMASYM, LMESYM
      CHARACTER*19 MAT19
      CHARACTER*14 NU14
      CHARACTER*8 MATEL
      CHARACTER*2 TT
      REAL*8 C1,C2
      CHARACTER*24 NOMLI,NOMLID,INFOFE
      INTEGER IEL,ADMODL,RANG,COMPT,ICONX1,ICONX2,JADLI,JADNE
      INTEGER I1,I2,IAD1,IAD11,IAD2,IAD21
      INTEGER IAUX1,IAUX2,IAUX3,IDD,IFEL2,IFEL3,IFEL4,IFEL5
      INTEGER IFM,IGR,ILIGRP,ILIMA,ILINU,ITERM
      INTEGER JFEL4,JNUEQ,JNULOC,JNUMSD,JPDMS,JPOSDL,JPRN1,JPRN2
      INTEGER JRESL,JSMDI,JSMHC,JTMP2,JVALM(2)
      INTEGER LCMODL,K1,K2,N2,N3
      INTEGER MODE,N1,NBLC,NBVEL,NCMP,NDDL1,NDDL2
      INTEGER NEC,NMXCMP,NNOE,NUMA,NK2
      LOGICAL LFEL2,LFETI,LLICH,LLICHD,LLICHP,LLIMO,LMUMPS,LPDMS,ELLAGR
C-----------------------------------------------------------------------
C     FONCTIONS FORMULES :
C-----------------------------------------------------------------------
      INTEGER ZZCONX,ZZLIEL
      INTEGER ZZNEMA,ZZPRNO,POSDDL,NUMLOC
      INTEGER IMAIL,J,ILI,IGREL,NUNOEL,L,KNO,KDDL,K

      ZZCONX(IMAIL,J)=ZI(ICONX1-1+ZI(ICONX2+IMAIL-1)+J-1)
      ZZLIEL(ILI,IGREL,J)=ZI(ZI(JADLI+3*(ILI-1)+1)-1+
     &                    ZI(ZI(JADLI+3*(ILI-1)+2)+IGREL-1)+J-1)
      ZZNEMA(ILI,IEL,J)=ZI(ZI(JADNE+3*(ILI-1)+1)-1+
     &                  ZI(ZI(JADNE+3*(ILI-1)+2)+IEL-1)+J-1)
      ZZPRNO(ILI,NUNOEL,L)=ZI(JPRN1-1+ZI(JPRN2+ILI-1)+
     &                     (NUNOEL-1)*(NEC+2)+L-1)
      NUMLOC(KNO,K)=ZI(JNULOC-1+2*(KNO-1)+K)
      POSDDL(KNO,KDDL)=ZI(JPOSDL-1+NMXCMP*(KNO-1)+KDDL)
C----------------------------------------------------------------------

      ITERM=0
C     NUMA : NUMERO DE LA MAILLE
      NUMA=ZZLIEL(ILIMA,IGR,IEL)


C     -- MONITORING:
C     ----------------
      IF ((INFOFE(5:5).EQ.'T') .AND. (LFETI)) THEN
        WRITE (IFM,*)'<FETI/ASSMAM>','IDD',IDD,'LIGREL',NOMLI,'ILIMA',
     &    ILIMA
        WRITE (IFM,*)'IGR',IGR,'IEL',IEL,'NUMA',NUMA
        IF (LLIMO)WRITE (IFM,*)'.LOGI',ZI(ILIGRP+ABS(NUMA))
        IF (LLICH) THEN
          IF (LLICHD) THEN
            WRITE (IFM,*)'LIGREL DE CHARGE '//'PROJETE DE FILS ',NOMLID
          ELSE
            WRITE (IFM,*)'LIGREL DE CHARGE INITIAL'
          ENDIF
          WRITE (IFM,*)'MAILLE ET/OU NOEUD TARDIF'
        ENDIF
      ENDIF


C     -- SI FETI :
C     --------------
      IF (LFETI) THEN
C       SI ON EST DANS UN CALCUL FETI SUR UN SOUS-DOMAINE,
C       ON SE POSE LA QUESTION DE L'APPARTENANCE DE LA MAILLE NUMA
C       AU SOUS-DOMAINE IDD
        IF (NUMA.GT.0) THEN
          IF (LLICH) CALL U2MESS('F','ASSEMBLA_6')
C         ELLE APPARTIENT AU GREL IGR DU LIGREL PHYSIQUE ILIMA
          IF (ZI(ILIGRP+NUMA).NE.IDD)GOTO 150
        ELSE
C         ELLE APPARTIENT AU GREL IGR DU LIGREL TARDIF ILIMA
          IF (LLIMO) CALL U2MESS('F','ASSEMBLA_7')
        ENDIF
      ENDIF


C     -- SI MUMPS :
C     --------------
      IF (LMUMPS) THEN
C       SI ON EST DANS UN CALCUL MUMPS DISTRIBUE, ON SE POSE
C       LA QUESTION DE L'APPARTENANCE DE LA MAILLE NUMA AUX
C       DONNEES ATTRIBUEES AU PROC SI MAILLE PHYSIQUE: CHAQUE PROC
C       NE TRAITE QUE CELLES ASSOCIEES AUX SD QUI LUI SONT ATTRIBUES
C       SI MAILLE TARDIVE: ELLES SONT TRAITEES PAR LE PROC 0
        IF (NUMA.GT.0) THEN
          IF (ZI(JNUMSD+NUMA).LT.0) THEN
            GOTO 150
          ENDIF
        ELSE
          IF (RANG.NE.0) THEN
            GOTO 150
          ENDIF
        ENDIF
      ENDIF



C     ----------------------------
C     1. CALCUL DE NDDL1 ET IAD1 :
C        + MISE A JOUR DE ELLAGR
C     ----------------------------


C     1.1. MAILLE DU MAILLAGE :
C     ------------------------
      IF (NUMA.GT.0) THEN

        IF (LPDMS) THEN
          C2=C1*ZR(JPDMS-1+NUMA)
        ELSE
          C2=C1
        ENDIF

        DO 51 K1=1,NNOE
          N1=ZZCONX(NUMA,K1)
          IAD1=ZZPRNO(1,N1,1)
          CALL CORDDL(ADMODL,LCMODL,JPRN1,JPRN2,1,MODE,NEC,NCMP,N1,K1,
     &                NDDL1,ZI(JPOSDL-1+NMXCMP*(K1-1)+1))
          CALL ASSERT(NDDL1.LE.NMXCMP)
          ZI(JNULOC-1+2*(K1-1)+1)=IAD1
          ZI(JNULOC-1+2*(K1-1)+2)=NDDL1
   51   CONTINUE



C     1.2. MAILLE TARDIVE :
C     ------------------------
      ELSE
        NUMA=-NUMA

C       -- SI FETI & LIGREL TARDIF:
        IF (LLICHD) THEN
C         SI POUR FETI, MAILLE TARDIVE DUPLIQUEE, ON SE POSE
C         LA QUESTION DE L'APPARTENANCE DE CETTE MAILLE TARDIVE
C         AU SOUS-DOMAINE IDD VIA L'OBJET .FEL2 (C'EST LE PENDANT
C         DE &FETI.MAILLE.NUMSD POUR LES MAILLES DU MODELE)
C         LFEL2=.TRUE. ON ASSEMBLE LES CONTRIBUTIONS DE
C         CETTE MAILLE TARDIVE
C         LFEL2=.FALSE. ON LA SAUTE
          LFEL2=.FALSE.
          IAUX1=ZI(IFEL2+2*(NUMA-1)+1)
          IF (IAUX1.GT.0) THEN
C           C'EST UNE MAILLE TARDIVE NON SITUEE SUR UNE INTERFACE
C           ELLE CONCERNE LE SD, ON L'ASSEMBLE
            IF (IAUX1.EQ.IDD)LFEL2=.TRUE.
          ELSEIF (IAUX1.LT.0) THEN
C           C'EST UNE MAILLE TARDIVE SITUEE SUR UNE INTERFACE,
C           DONC PARTAGEE ENTRE PLUSIEURS SOUS-DOMAINES
            COMPT=0
            IAUX2=(ZI(IFEL4)/3)-1
            DO 60 JFEL4=0,IAUX2
              IAUX3=IFEL4+3*JFEL4+3
              IF (ZI(IAUX3).EQ.NUMA) THEN
                COMPT=COMPT+1
                IF (ZI(IAUX3-1).EQ.IDD) THEN
C                 ELLE CONCERNE LE SD, ON L'ASSEMBLE
                  LFEL2=.TRUE.
                  GOTO 70
                ENDIF
C               ON A LU TOUTES LES VALEURS, ON SORT DE LA BOUCLE
                IF (COMPT.EQ.-IAUX1)GOTO 70
              ENDIF
   60       CONTINUE
   70       CONTINUE
          ENDIF
C         ON SAUTE LA CONTRIBUTION
          IF (.NOT.LFEL2)GOTO 150
        ENDIF


C       MISE A JOUR DE ELLAGR :
C          .TRUE. : IL EXISTE DES ELEMENTS DE LAGRANGE
C       LA MAILLE EST UN ELEMENT DE DUALISATION DE CL (LAGRANGE) SI:
C         - TRIA3 TARDIF (NNOE=3, NUMA <0)
C         - N1 EST UN NOEUD PHYSIQUE (>0)
C         - N2 ET N3 SONT DES NOEUDS TARDIFS PORTANT 1 CMP: 'LAGR'
C       --------------------------------------------------------------
        IF ((.NOT.ELLAGR).AND.(NNOE.EQ.3)) THEN
          N1=ZZNEMA(ILIMA,NUMA,1)
          N2=ZZNEMA(ILIMA,NUMA,2)
          N3=ZZNEMA(ILIMA,NUMA,3)
          IF ((N1.GT.0).AND.(N2.LT.0).AND.(N3.LT.0)) THEN
C           -- POUR L'INSTANT ON NE VERIFIE PAS QUE N2 ET N3 NE
C              PORTENT QUE LA CMP 'LAGR'
            ELLAGR=.TRUE.
          ENDIF
        ENDIF


        DO 141 K1=1,NNOE
C         N1 : INDICE DU NOEUDS DS LE .NEMA DU LIGREL
C              DE CHARGE GLOBAL OU LOCAL
          N1=ZZNEMA(ILIMA,NUMA,K1)
          IF (N1.LT.0) THEN
C           NOEUD TARDIF
            N1=-N1

            IF (LLICHP) THEN
C             SI FETI & LIGREL TARDIF
C             SI POUR FETI, NOEUD TARDIF DUPLIQUE,
C             VERITABLE N1 DANS LE LIGREL DUPL
              IAUX1=ZI(IFEL3+2*(N1-1)+1)
              IF (IAUX1.GT.0) THEN
C               C'EST UN NOEUD TARDIF LIE A UN DDL PHYSIQUE
C               NON SUR L'INTERFACE
                N1=-ZI(IFEL3+2*(N1-1))

              ELSEIF (IAUX1.LT.0) THEN
C               C'EST UN NOEUD TARDIF LIE A UN DDL PHYSIQUE
C               DE L'INTERFACE
                IAUX2=(ZI(IFEL5)/3)-1
                DO 80 JFEL4=0,IAUX2
                  IAUX3=IFEL5+3*JFEL4+3
                  IF (ZI(IAUX3).EQ.N1) THEN
                    IF (ZI(IAUX3-1).EQ.IDD) THEN
C                     VOICI SON NUMERO LOCAL CONCERNANT LE SD
                      N1=-ZI(IAUX3-2)
                    ENDIF
                  ENDIF
   80           CONTINUE
   90           CONTINUE
              ENDIF
            ENDIF


C           -- NUMERO D'EQUATION DU PREMIER DDL DE N1
            IAD1=ZZPRNO(ILINU,N1,1)
            CALL CORDDL(ADMODL,LCMODL,JPRN1,JPRN2,ILINU,MODE,NEC,NCMP,
     &                  N1,K1,NDDL1,ZI(JPOSDL-1+NMXCMP*(K1-1)+1))

          ELSE
C           -- NOEUD PHYSIQUE
            IAD1=ZZPRNO(1,N1,1)
            CALL CORDDL(ADMODL,LCMODL,JPRN1,JPRN2,1,MODE,NEC,NCMP,N1,K1,
     &                  NDDL1,ZI(JPOSDL-1+NMXCMP*(K1-1)+1))
          ENDIF

          ZI(JNULOC-1+2*(K1-1)+1)=IAD1
          ZI(JNULOC-1+2*(K1-1)+2)=NDDL1
 141    CONTINUE
      ENDIF



C     -----------------------------------------------------------
C     2. ON BOUCLE SUR LES TERMES DE LA MATRICE ELEMENTAIRE
C        POUR NOTER OU ILS DOIVENT ETRE RECOPIES
C     -----------------------------------------------------------

      DO 50 K1=1,NNOE
        IAD1=NUMLOC(K1,1)
        NDDL1=NUMLOC(K1,2)
        IF (LMESYM) THEN
           NK2=K1
        ELSE
           NK2=NNOE
        ENDIF
        DO 40 I1=1,NDDL1
          DO 20 K2=1,NK2
            IAD2=NUMLOC(K2,1)
            NDDL2=NUMLOC(K2,2)
            IF (LMESYM.AND.(K2.EQ.K1)) NDDL2=I1
            DO 10 I2=1,NDDL2
              IAD11=ZI(JNUEQ-1+IAD1+POSDDL(K1,I1)-1)
              IAD21=ZI(JNUEQ-1+IAD2+POSDDL(K2,I2)-1)
              CALL ASRETM(LMASYM,JTMP2,ITERM,JSMHC,JSMDI,IAD11,IAD21)
   10       CONTINUE
   20     CONTINUE
   40   CONTINUE
   50 CONTINUE



C     -----------------------------------------------------------
C     3. ON RECOPIE EFFECTIVEMENT LES TERMES:
C        (ITERM CONTIENT LE NOMBRE DE TERMES (R/C) A TRAITER)
C     -----------------------------------------------------------
      CALL ASCOPR(LMASYM,LMESYM,TT,JTMP2,ITERM,JRESL+NBVEL*(IEL-1),
     &              C2,JVALM)


  150 CONTINUE
      END
