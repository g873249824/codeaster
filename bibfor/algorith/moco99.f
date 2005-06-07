      SUBROUTINE MOCO99(NOMRES,RESUL,NBMOD,LIORD,IORNE)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/04/2004   AUTEUR DURAND C.DURAND 
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
C***********************************************************************
C  P. RICHARD     DATE 20/02/91
C-----------------------------------------------------------------------
C  BUT : POINTER LES PREMIERS MODES PROPRES D'UNE STRUCTURE RESULTAT
C        DE TYPE MODE_MECA DANS UNE AUTRE STRUCTURE DE TYPE BASE_MODALE
C        DEJA EXISTANTE A PARTIR D'UN NUMERO D'ORDRE
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM UTILISATEUR DE LA STRUCTURE RESULTAT A REMPLIR
C RESUL  /I/ : NOM DE LA STRUCTURE RESULTAT A POINTER
C NBMOD  /I/ : NOMBRE DE MODES A POINTER
C LIORD  /I/ : LISTE DES ANCIENS NUMEROS D'ORDRE A POINTER
C IORNE  /M/ : NOUVEAU NUMERO D'ORDRE DU PREMIER CHAMPS 'DEPL' A POINTER
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      PARAMETER   (NBPABM=8)
      INTEGER      LIORD(NBMOD),LDPAR(NBPABM),LDPA2(NBPABM)
      COMPLEX*16   CBID
      CHARACTER*6  PGC
      CHARACTER*8  NOMRES,RESUL,KBID,MAILLA,K8BID,INTERF,TYPI
      CHARACTER*16 TYPRES,CHAM,DEPL,BMPARA(NBPABM)
      CHARACTER*19 CHAMOL,CHAMNE,MATRIX,NUMDDL
      CHARACTER*24 TYPE
      CHARACTER*80 CHAINE
C
C-----------------------------------------------------------------------
C
      DATA  BMPARA /'NUME_MODE','FREQ','NORME','NOEUD_CMP','TYPE_DEFO',
     &              'OMEGA2','MASS_GENE','RIGI_GENE'/
      DATA  PGC    /'MODCOP'/
C
C-----------------------------------------------------------------------
C
C --- CAS DE L'ABSENCE D'UN MODE_MECA
C
      IF (RESUL.EQ.'          '.OR.NBMOD.EQ.0) GOTO 9999
C
      DEPL = 'DEPL'
      CHAM = 'DEPL'
C
C --- DETERMINATION DU NOMBRE DE MODES DANS LA STRUCTURE A POINTER
C
      CALL RSORAC(RESUL,'LONUTI',IBID,BID,KBID,CBID,EBID,'ABSOLU',
     &            NBOLD,1,NBID)
C
      IF(NBMOD.GT.NBOLD) THEN
         CHAINE='NOMBRE DE MODES PROPRES CALCULES INSUFFISANT'
         CALL UTDEBM('I',PGC,CHAINE)
         CHAINE='NOMBRE DE MODES PROPRES DE LA BASE LIMITE A: '
         CALL UTIMPI('L',CHAINE,1,NBOLD)
         CALL UTFINM
         NBMOD=NBOLD
      ENDIF
      NBMOD=MIN(NBMOD,NBOLD)
C
      IF(NBMOD.EQ.0) GOTO 9999
C     --- ON RECUPERE LE TYPE D'INTERFACE ---
C
      CALL JEVEUO(NOMRES//'           .REFE','L',JREF)
      INTERF = ZK24(JREF) (1:8)
      IF (INTERF.NE.' ') THEN
       TYPE = INTERF//'      .INTD.TYPE'
       CALL JEVEUO(TYPE,'L',JTYP)
       TYPI = ZK8(JTYP)
      ENDIF
C
C --- RECHERCHE DE L'ADRESSE DES ANCIENNES VALEURS PROPRES
C
      CALL DISMOI('F','TYPE_RESU',RESUL,'RESULTAT',IBID,TYPRES,IRE)
      IF (TYPRES.EQ.'MODE_MECA')
     + CALL RSADPA(RESUL,'L',1,'FREQ',1,0,LLVALO,K8BID)
C
      DO 10 I=1,NBMOD
C
        IOROL=LIORD(I)
C
C ----- REQUETE NOM ET ADRESSE ANCIEN CHAMNO
C
        CALL RSEXCH(RESUL,CHAM,IOROL,CHAMOL,IER)
        IF (TYPRES.NE.'MODE_MECA') GOTO 11
C
C ----- RECUPERATION DES VALEURS GENERALISEES ET PULSATION CARREE
C
        CALL RSADPA(RESUL,'L',1,'RIGI_GENE',IOROL,0,LLKGE,K8BID)
        GENEK=ZR(LLKGE)
        CALL RSADPA(RESUL,'L',1,'MASS_GENE',IOROL,0,LLMGE,K8BID)
        GENEM=ZR(LLMGE)
        CALL RSADPA(RESUL,'L',1,'OMEGA2',IOROL,0,LLOM2,K8BID)
        OMEG2=ZR(LLOM2)
C
C
C ----- CONFIRMATION DU NOM DE CHAMNO AUPRES DU RESULTAT COMPOSE
C
11      CONTINUE
        CALL RSNOCH(NOMRES,DEPL,IORNE,CHAMOL)
C
C ----- ECRITURE DES NOUVEAUX PARAMETRES
C
        CALL RSADPA(NOMRES,'E',NBPABM,BMPARA,IORNE,0,LDPAR,K8BID)
        ZI(LDPAR(1))=IORNE
        IF (TYPRES.NE.'MODE_MECA') THEN
           IF (TYPRES.EQ.'BASE_MODALE') THEN
            CALL RSADPA(RESUL,'L',NBPABM,BMPARA,IOROL,0,LDPA2,K8BID)
            ZR(LDPAR(2)) = ZR(LDPA2(2))
            ZK24(LDPAR(3)) = ZK24(LDPA2(3))
            ZK16(LDPAR(4)) = ZK16(LDPA2(4))
            ZK16(LDPAR(5)) = ZK16(LDPA2(5))
            ZR(LDPAR(6)) = ZR(LDPA2(6))
            ZR(LDPAR(7)) = ZR(LDPA2(7))
            ZR(LDPAR(8)) = ZR(LDPA2(8))
            GO TO 12
           ENDIF
           ZR(LDPAR(2))=0.D0
           ZK24(LDPAR(3))='                       '
           ZK16(LDPAR(4))='                       '
           ZK16(LDPAR(5))='                       '
           IF (TYPRES.EQ.'MODE_STAT') THEN
            CALL RSADPA(RESUL,'L',1,'NOEUD_CMP',
     &         IOROL,0,LLNCP,K8BID)
            ZK16(LDPAR(4)) = ZK16(LLNCP)
            ZK16(LDPAR(5)) = 'STATIQUE'
            IF (INTERF.NE.' ') THEN
             IF (TYPI.EQ.'CRAIGB') ZK16(LDPAR(5)) = 'CONTRAINT'
             IF (TYPI.EQ.'MNEAL') ZK16(LDPAR(5)) = 'ATTACHE'
            ENDIF
           ENDIF
           ZR(LDPAR(6))=0.D0
           ZR(LDPAR(7))=0.D0
           ZR(LDPAR(8))=0.D0
           GO TO 12
        ENDIF
        ZR(LDPAR(2))=ZR(LLVALO+IOROL-1)
        ZK24(LDPAR(3))='                       '
        ZK16(LDPAR(4))='                       '
        ZK16(LDPAR(5))='PROPRE '
        ZR(LDPAR(6))=OMEG2
        ZR(LDPAR(7))=GENEM
        ZR(LDPAR(8))=GENEK
C
12      CONTINUE
C
C ----- INCREMENTATION DU NUMERO ORDRE
C
        IORNE=IORNE+1
C
10    CONTINUE
C
C
 9999 CONTINUE
      END
