      SUBROUTINE CRICHO (NBMODE,RIGGEN,NBCHOC,PARCHO,NOECHO,INFO,
     .    FIMPO,RFIMPO,TRLOC,SOUPL,INDIC,NEQ,BMODAL,SEUIL,MARIG,
     .    NBNLI)
      IMPLICIT  REAL*8  (A-H,O-Z)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C     CALCUL DES TAUX DE RECONSTITUTION
C     ------------------------------------------------------------------
C IN  : NBMODE : NOMBRE DE MODES
C IN  : RIGGEN : RAIDEURS GENERALISES
C IN  : NBCHOC : NOMBRE DE NOEUDS DE CHOC
C IN  : PARCHO : TABLEAU DES PARAMETRES DE CHOC
C IN  : NOECHO : TABLEAU DES NOMS DES NOEUDS DE CHOC
C OUT : SEUIL  :
C ----------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------

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

C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------

      INTEGER            NBCHOC, INFO, NBMODE,IRIGI,INDIC(NBMODE)
      INTEGER            NEQ,NBNLI,NDECI,ISINGU,NPVNEG,IRET, ISTOP,IFAC
      REAL*8             RIGGEN(*),SEUIL,
     +                   PARCHO(NBNLI,*)
      CHARACTER*8        NOECHO(NBNLI,*)
      REAL*8             TRLOC(NBMODE),SOUPL(NBMODE),TRLOCJ
      REAL*8             FIMPO(NEQ),RFIMPO(NEQ)
      REAL*8             BMODAL(NEQ,NBMODE),SOUP,CEF,TX
      CHARACTER*24       MARIG
      COMPLEX*16         CBID
      INTEGER I,J,JJ,K,IA,IC,JM,IDDLX,IDDLY,IDDLZ,NUNOE
      REAL*8 CC,CS,CT,SCF,RSCF,USR,NORMX

      LOGICAL     MATUV
      INTEGER     NM, M, N, IERR, NBLIG, ICOLC
      INTEGER     NBCH1,NBCH2,NEQCH1,NEQCH2
      INTEGER     JEFLOC,JRFIMP,JNORMX,JNORMY,JA,JW,JU,JV,JRVNM
      REAL*8      MMAX,MMIN,SCOND,EPS

C
C      SEUIL=1.D0
      SEUIL=0.D0
C      EPS=1.D-50
      EPS = R8PREM( )
      IFAC = 0
      NBLIG = NEQ
      ICOLC = 0
C
      NBCH1 = 1+2*NBCHOC
      NBCH2 = 2*NBCHOC
      NEQCH1 = NEQ*NBCH1
      NEQCH2 = NEQ*NBCH2
C
      CALL MTDSCR(MARIG)
      CALL JEVEUO(MARIG(1:19)//'.&INT','E',IRIGI)
C
      CALL WKVECT('&&CRICHO.EFLOC','V V R',NBMODE,JEFLOC)
      CALL WKVECT('&&CRICHO.RFIMPOX','V V R',NEQCH2,JRFIMP)
      CALL WKVECT('&&CRICHO.NORMXX','V V R',NBCH2,JNORMX)
      CALL WKVECT('&&CRICHO.NORMY','V V R',NBMODE,JNORMY)
      CALL WKVECT('&&CRICHO.A','V V R',NEQCH1,JA)
      CALL WKVECT('&&CRICHO.W','V V R',NBCH1,JW)
      CALL WKVECT('&&CRICHO.U','V V R',NEQCH1,JU)
      CALL WKVECT('&&CRICHO.V','V V R',NEQCH1,JV)
      CALL WKVECT('&&CRICHO.RVNM','V V R',NEQ,JRVNM)
C
      IF ( NBCHOC.GT.0 ) THEN
        DO 20 I = 1,NBCHOC
          JM=1
          IF (NOECHO(I,9)(1:2).EQ.'BI') JM=2
          DO 21 JJ=1,JM
            ICOLC = ICOLC+1
            CT=0.D0
            CEF=0.D0
            IC=4*JJ-3
            CALL UTDEBM('I','CRICHO','  ')
            IF (INFO.GE.2)
     +      CALL UTIMPK('L','--- AU NOEUD DE CHOC :',1,NOECHO(I,IC))
C     CREATION DE FIMPO : FORCE UNITAIRE AU NOEUD DE CHOC (N)
            CALL UTFINM()
            DO 11 K=1,NEQ
              FIMPO(K)=0.D0
   11       CONTINUE
            CALL POSDDL('NUME_DDL',NOECHO(I,IC+2),NOECHO(I,IC),
     .                  'DX',NUNOE,IDDLX)
            CALL POSDDL('NUME_DDL',NOECHO(I,IC+2),NOECHO(I,IC),
     .                  'DY',NUNOE,IDDLY)
            CALL POSDDL('NUME_DDL',NOECHO(I,IC+2),NOECHO(I,IC),
     .                  'DZ',NUNOE,IDDLZ)
            FIMPO(IDDLX)=PARCHO(I,44)
            FIMPO(IDDLY)=PARCHO(I,45)
            FIMPO(IDDLZ)=PARCHO(I,46)
C           
C     CALCUL DE RFIMPO : K*N
            CALL MRMULT('ZERO',IRIGI,FIMPO,'R',RFIMPO,1)
C
C     ISTOP MIS A 2 POUR NE PAS ARRETER L'EXECUTION EN CAS DE MATRICE
C     SINGULIERE (MODES STATIQUES)
            ISTOP = 2
            IF (IFAC.EQ.0) THEN
              CALL TLDLGG(ISTOP,IRIGI,1,NEQ,0,NDECI,ISINGU,
     &                  NPVNEG,IRET)
                IF (IRET.EQ.2) THEN
                  CALL UTMESS('A','CRICHO',
     & 'MATRICE DE RIGIDITE NON INVERSIBLE (MODES RIGIDES ???)' //
     & ' - ATTENTION : CRITERES DE CHOC NON CALCULES')
                  GOTO 9999
                ELSE IF (IRET.EQ.1) THEN
                  CALL UTMESS('A','CRICHO',
     & 'MATRICE DE RIGIDITE : PIVOT QUASI-NUL (MODES RIGIDES ???)' //
     & ' - ATTENTION : CRITERES DE CHOC NON CALCULES')
                  GOTO 9999
                ENDIF
            ENDIF
C FIMPO : DEFORMEE STATIQUE (K-1*N)
            CALL RLDLGG(IRIGI,FIMPO,CBID,1)
C NORMX : NORME K-1*N
            CALL MDSCAL(FIMPO,FIMPO,NORMX,NEQ)
            ZR(JNORMX-1+ICOLC)=NORMX
C RFIMPOX : K-1*N (SAUVEGARDE DEFORMEE STATIQUE)
            DO 41 K=1,NEQ
              ZR(JRFIMP-1+K+NEQ*(ICOLC-1))=FIMPO(K)
   41       CONTINUE
C
C     CALCUL DE SOUP : TN*K-1*N
            SOUP = PARCHO(I,44)*FIMPO(IDDLX)
            SOUP = SOUP + PARCHO(I,45)*FIMPO(IDDLY)
            SOUP = SOUP + PARCHO(I,46)*FIMPO(IDDLZ)
            DO 12 K=1,NEQ
              FIMPO(K)=0.D0
   12       CONTINUE
            FIMPO(IDDLX)=PARCHO(I,44)
            FIMPO(IDDLY)=PARCHO(I,45)
            FIMPO(IDDLZ)=PARCHO(I,46)
            DO 22 J = 1,NBMODE
               IF (RIGGEN(J).LE.0.D0) THEN
                 USR=0.D0
               ELSE
                 USR=1.D0/RIGGEN(J)
               ENDIF
C     RSCF : TYNU*K*N
C     SCF : TYNU*N
               CALL MDSCAL(BMODAL(1,J),RFIMPO,RSCF,NEQ)
               CALL MDSCAL(BMODAL(1,J), FIMPO, SCF,NEQ)
               CC=SCF*RSCF*USR
               CS=SCF**2*USR
               IF (INFO.GE.2) THEN
                 SOUPL(J)=CS
                 IF (SOUP.NE.0.D0) THEN
                   TRLOC(J)=CS/SOUP
                 ELSE
                   TRLOC(J)=0.D0
                 ENDIF
                 INDIC(J)=J
                 TRLOCJ=TRLOC(J)
               ELSE
                 IF (SOUP.NE.0.D0) THEN
                   TRLOCJ=CS/SOUP
                 ELSE
                   TRLOCJ=0.D0
                 ENDIF
               ENDIF
               CT=CT+TRLOCJ
               ZR(JEFLOC-1+J)=CC
               CEF = CEF + CC
 22         CONTINUE
            PARCHO(I,47+JJ-1)=CT
C            IF (CT.NE.0.D0) SEUIL=MIN(SEUIL,CT)
C
            IF (INFO.GE.2) THEN
C      ON ORDONNE SELON LES SOUPLESSES DECROISSANTES
               CALL MDTRIB (INDIC,SOUPL,NBMODE)
               DO 32 J = 1,NBMODE
                  CALL UTDEBM('I','CRICHO','  ')
                  CALL UTIMPI('L',' POUR LE MODE NO :',1,INDIC(J))
                  CALL UTIMPR('L','TAUX DE FLEXIBILITE LOCALE   : ',
     .                             1,TRLOC(INDIC(J)))
                  CALL UTIMPR('L','SOUPLESSE LOCALE             : ',
     .                             1,SOUPL(INDIC(J)))
                  CALL UTIMPR('L','TAUX EFFORT TRANCHANT LOCAL  : ',
     .                             1,ZR(JEFLOC-1+INDIC(J)))
                  CALL UTFINM()
 32            CONTINUE
            ENDIF
            CALL UTDEBM('I','CRICHO','  ')
            CALL UTIMPK('L','-- BILAN NOEUD DE CHOC :',1,NOECHO(I,IC))
            CALL UTIMPR('L',' TAUX DE RESTIT FLEXIBILITE      : ',
     .                             1,CT)
            CALL UTIMPR('L',' TAUX DE RESTIT EFFORT TRANCHANT : ',
     .                             1,CEF)

            TX = SOUP*PARCHO(I,2)*(1.D0-CT)
            CALL UTIMPR('L',' ( SOUPLESSE STATIQUE - SOUPLESSE LOCALE )
     ./ SOUPLESSE CHOC : ', 1,TX)
            SEUIL=MAX(SEUIL,TX)
            TX = SOUP*CT*PARCHO(I,2)
            CALL UTIMPR('L',' SOUPLESSE LOCALE / SOUPLESSE CHOC : ',
     .                             1,TX)
            CALL UTFINM()
 21       CONTINUE
C
 20     CONTINUE

        IF (INFO.GE.2) THEN
          CALL UTDEBM('I','CRICHO','  ')
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 1   DECOMPOSITION AUX VALEURS SINGULIERES DE LA MATRICE A
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
          MATUV = .FALSE.
          NM = NBLIG
          M = NEQ
C
C LA MATRICE A CONTIENT LES DEFORMEES STATIQUES
C ICOLC : NB DE CHOC A CONSIDERER
          N = ICOLC
          DO 80 K = 1,NEQ
            DO 82 IA = 1,ICOLC
             IF (ZR(JNORMX-1+IA).GT.EPS) THEN
              ZR(JA-1+K+NEQ*(IA-1)) = 
     .             ZR(JRFIMP-1+K+NEQ*(IA-1))/SQRT(ZR(JNORMX-1+IA))
             ELSE
              ZR(JA-1+K+NEQ*(IA-1)) = 0.D0
             ENDIF
82          CONTINUE
80        CONTINUE
C
          CALL CALSVD(NM,M,N,ZR(JA),ZR(JW),
     &            MATUV,ZR(JU),MATUV,ZR(JV),IERR,ZR(JRVNM))
          IF ( IERR.NE.0 ) GO TO 9999
          MMAX = 0.D0
          MMIN = 1.D10
          DO 83 IA = 1,N
            MMAX = MAX(MMAX,ZR(JW-1+IA))
            MMIN = MIN(MMIN,ZR(JW-1+IA))
83        CONTINUE
C CONDITIONNEMENT
          IF ( MMIN .LE. EPS ) THEN
            CALL UTIMPR('L','!! ATTENTION 
     .             PLUS PETITE VAL SING DEF STAT : ',1,MMIN)
            CALL UTIMPR('L','!! NOUS LA FORCONS A : ',
     .                             1,EPS)
            MMIN = EPS
          ENDIF
          SCOND = MMAX/MMIN
C
          CALL UTIMPR('L','---- CONDITIONNEMENT DEF STAT : ',
     .                             1,SCOND)
C
C     NORMY : TYN*YN 
          DO 51 JJ = 1,NBMODE
            CALL MDSCAL(BMODAL(1,JJ),BMODAL(1,JJ),ZR(JNORMY-1+JJ),NEQ)
51        CONTINUE
C
          N = ICOLC+1
          DO 42 J = 1,NBMODE
C
C LA MATRICE A CONTIENT LES DEFORMEES STATIQUES ET MODE
            DO 60 K = 1,NEQ
              DO 62 IA = 1,ICOLC
               IF (ZR(JNORMX-1+IA).GT.EPS) THEN
                ZR(JA-1+K+NEQ*(IA-1)) = 
     .               ZR(JRFIMP-1+K+NEQ*(IA-1))/SQRT(ZR(JNORMX-1+IA))
               ELSE
                ZR(JA-1+K+NEQ*(IA-1)) = 0.D0
               ENDIF
62            CONTINUE
              ZR(JA-1+K+NEQ*(ICOLC+1-1)) = 
     .               BMODAL(K,J)/SQRT(ZR(JNORMY-1+J))
60          CONTINUE
C
            CALL CALSVD(NM,M,N,ZR(JA),ZR(JW),
     &            MATUV,ZR(JU),MATUV,ZR(JV),IERR,ZR(JRVNM))
            IF ( IERR.NE.0 ) GO TO 9999
            MMAX = 0.D0
            MMIN = 1.D10
            DO 53 IA = 1,N
              MMAX = MAX(MMAX,ZR(JW-1+IA))
              MMIN = MIN(MMIN,ZR(JW-1+IA))
53          CONTINUE
C CONDITIONNEMENT
            IF ( MMIN .LE. EPS ) THEN
              CALL UTIMPI('L',' !!! MODE NO :',1,J)
              CALL UTIMPR('L','   LINEAIREMENT DEPENDANT A DEF. STATIQUE
     .  VAL SING MIN : ',1,MMIN)
              CALL UTIMPR('L','   !! NOUS LA FORCONS A : ',
     .                             1,EPS)
              MMIN = EPS
            ENDIF
            ZR(JEFLOC-1+J) = MMAX/MMIN
C NORMALISATION PAR RAPPORT DEF STATIQUE
            IF ( SCOND .LE. EPS ) SCOND = EPS
            ZR(JEFLOC-1+J) = ZR(JEFLOC-1+J)/SCOND
C
            INDIC(J)=J
 42       CONTINUE
C
C      ON ORDONNE SELON LA PARTICIPATION DECROISSANTE
          CALL MDTRIB (INDIC,ZR(JEFLOC),NBMODE)
          DO 72 J = 1,NBMODE
            CALL UTIMPI('L',' POUR LE MODE NO :',1,INDIC(J))
            CALL UTIMPR('L','PARTICIPATION : ',
     .                             1,ZR(JEFLOC-1+INDIC(J)))
 72       CONTINUE
C
          CALL UTFINM()
        ENDIF

C
      ENDIF
C
 9999 CONTINUE
      CALL JEDETC('V','.&VDI',20)
      CALL JEDETC('V','&&CRICHO',1)
      END
