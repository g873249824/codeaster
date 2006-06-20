      SUBROUTINE MDCHOC (NBNLI,NBCHOC,NBFLAM,NBSISM,LOGCHO,DPLMOD,
     +                   PARCHO,NOECHO,INTITU,PS1DEL,PS2DEL,NUMDDL,
     +                   NBMODE,PULSAT,MASGEN,LAMOR,AMOGEN,BMODAL,NEQ,
     +                   NEXCIT,INFO,LFLU,MONMOT,IER)
      IMPLICIT  NONE
      INTEGER            NBNLI, NBCHOC,NBFLAM, NBSISM, NBMODE, NEQ
      INTEGER            LOGCHO(NBNLI,*), IER, NEXCIT, INFO
      REAL*8             PARCHO(NBNLI,*),PULSAT(*),MASGEN(*),AMOGEN(*)
      REAL*8             DPLMOD(NBNLI,NBMODE,*),BMODAL(NEQ,*)
      REAL*8             PS1DEL(NEQ,NEXCIT),PS2DEL(NBNLI,NEXCIT,*)
      CHARACTER*8        NOECHO(NBNLI,*), MAILLA, INTITU(*), MONMOT
      CHARACTER*14       NUMDDL
      LOGICAL            LAMOR, LFLU
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/06/2006   AUTEUR CIBHHLV L.VIVAN 
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
C TOLE CRP_21
C
C     STOCKAGE DES INFORMATIONS DE CHOC DANS DES TABLEAUX
C     ------------------------------------------------------------------
C IN  : NBNLI  : DIMENSION DES TABLEAUX (NBCHOC+NBSISM+NBFLAM)
C IN  : NBCHOC : NOMBRE DE POINTS DE CHOC
C IN  : NBFLAM : NOMBRE DE CHOCS AVEC FLAMBEMENT
C OUT : LOGCHO : LOGIQUE CHOC: LOGCHO(I,1) = SI ADHERENCE OU NON
C                              LOGCHO(I,2) = SI FORCE FLUIDE OU NON
C                              LOGCHO(I,3) = SI CHOC SEC + LAME FLUIDE
C                              LOGCHO(I,4) = SI DISPO ANTI S OU NON
C                              LOGCHO(I,5) = SI FLAMBEMENT OU NON
C OUT : DPLMOD : DEPL MODAUX AUX NOEUDS DE CHOC APRES ORIENTATION
C                DPLMOD(I,J,1) = DEPL DX DU NOEUD_1 DE CHOC I - MODE J
C                DPLMOD(I,J,2) = DEPL DY
C                DPLMOD(I,J,3) = DEPL DZ
C                DPLMOD(I,J,4) = DEPL DX DU NOEUD_2 DE CHOC I - MODE J
C                DPLMOD(I,J,5) = DEPL DY
C                DPLMOD(I,J,6) = DEPL DZ
C OUT : PARCHO : PARAMETRE DE CHOC:
C                PARCHO(I, 1)= JEU AU NOEUD DE CHOC I
C                PARCHO(I, 2)= RIGI NORMALE
C                PARCHO(I, 3)= AMOR NORMAL
C                PARCHO(I, 4)= RIGI TANGENTIELLE
C                PARCHO(I, 5)= AMOR TANGENTIEL
C                PARCHO(I, 6)= COULOMB
C                PARCHO(I, 7)= COOR INIT NOEUD_1 X REP GLOBAL
C                PARCHO(I, 8)= COOR INIT NOEUD_1 Y REP GLOBAL
C                PARCHO(I, 9)= COOR INIT NOEUD_1 Z REP GLOBAL
C                PARCHO(I,10)= COOR INIT NOEUD_2 X REP GLOBAL
C                PARCHO(I,11)= COOR INIT NOEUD_2 Y REP GLOBAL
C                PARCHO(I,12)= COOR INIT NOEUD_2 Z REP GLOBAL
C                PARCHO(I,13)= COOR ORIGINE OBSTACLE X REP GLOBAL
C                PARCHO(I,14)= COOR ORIGINE OBSTACLE Y REP GLOBAL
C                PARCHO(I,15)= COOR ORIGINE OBSTACLE Z REP GLOBAL
C                PARCHO(I,16)= SIN A
C                PARCHO(I,17)= COS A
C                PARCHO(I,18)= SIN B
C                PARCHO(I,19)= COS B
C                PARCHO(I,20)= SIN G
C                PARCHO(I,21)= COS G
C                PARCHO(I,22)= X AVANT ADHERENCE
C                PARCHO(I,23)= Y AVANT ADHERENCE
C                PARCHO(I,24)= Z AVANT ADHERENCE
C                PARCHO(I,25)= FT1 AVANT ADHERENCE
C                PARCHO(I,26)= FT2 AVANT ADHERENCE
C                PARCHO(I,27)= VT1 PAS PRECEDENT
C                PARCHO(I,28)= VT2 PAS PRECEDENT
C                PARCHO(I,29)= DIST_1 DU NOEUD_1
C                PARCHO(I,30)= DIST_2 DU NOEUD_2
C                PARCHO(I,31)= COEF A FORCE FLUIDE
C                PARCHO(I,32)= COEF B FORCE FLUIDE
C                PARCHO(I,33)= COEF C FORCE FLUIDE
C                PARCHO(I,34)= COEF D FORCE FLUIDE
C                PARCHO(I,35)= COUCHE LIMITE
C                PARCHO(I,36)= SIGNE DE Y20LOC-Y10LOC
C                PARCHO(I,37)= SIGNE DE Z20LOC-Z10LOC
C                PARCHO(I,38)= COEF RIGI_K1 DISPO ANTI SISMIQUE
C                PARCHO(I,39)= COEF RIGI_K2 DISPO ANTI SISMIQUE
C                PARCHO(I,40)= COEF SEUIL_FX DISPO ANTI SISMIQUE
C                PARCHO(I,41)= COEF C DISPO ANTI SISMIQUE
C                PARCHO(I,42)= COEF PUIS_ALPHA DISPO ANTI SISMIQUE
C                PARCHO(I,43)= COEF DX_MAX DISPO ANTI SISMIQUE
C                PARCHO(I,44)= NORMALE X
C                PARCHO(I,45)= NORMALE Y
C                PARCHO(I,46)= NORMALE Z
C                PARCHO(I,47)= TAUX DE RESTITUTION (CALCULE DANS CRICHO)
C                PARCHO(I,48)= TAUX DE RESTITUTION (CALCULE DANS CRICHO)
C                PARCHO(I,49)= FORCE LIMITE DE FLAMBAGE
C                PARCHO(I,50)= PALIER FORCE DE REACTION APRES FLAMBAGE
C                PARCHO(I,51)= RIGIDITE APRES FLAMBAGE
C OUT : NOECHO : NOEUD DE CHOC: NOECHO(I,1) = NOEUD_1
C                               NOECHO(I,2) = SOUS_STRUC_1
C                               NOECHO(I,3) = NUME_1
C                               NOECHO(I,4) = MAILLA_1
C                               NOECHO(I,5) = NOEUD_2
C                               NOECHO(I,6) = SOUS_STRUC_2
C                               NOECHO(I,7) = NUME_2
C                               NOECHO(I,8) = MAILLA_2
C                               NOECHO(I,9) = TYPE D'OBSTACLE
C OUT : INTITU : INTITULE DE CHOC
C IN  : PS1DEL : PSI*DELTA (MULTI-APPUI) = NOMRES//'.IPSD'
C OUT : PS2DEL : PSI*DELTA: PS2DEL(I,J,1)=  DX NOEUD_1 CHOC I - EXCIT J
C                           PS2DEL(I,J,2)=  DY NOEUD_1 CHOC I - EXCIT J
C                           PS2DEL(I,J,3)=  DZ NOEUD_1 CHOC I - EXCIT J
C                           PS2DEL(I,J,4)=  DX NOEUD_2 CHOC I - EXCIT J
C                           PS2DEL(I,J,5)=  DY NOEUD_2 CHOC I - EXCIT J
C                           PS2DEL(I,J,6)=  DZ NOEUD_2 CHOC I - EXCIT J
C IN  : NUMDDL : NOM DE LA NUMEROTATION
C IN  : NBMODE : NOMBRE DE MODES DE LA BASE DE PROJECTION
C IN  : PULSAT : PULSATIONS DES MODES
C IN  : MASGEN : MASSES GENERALISEES DES MODES
C IN  : LAMOR  : LOGIQUE POUR AMORTISSEMENTS MODAUX
C IN  : AMOGEN : MATRICE DES AMORTISSEMENTS GENERALISES
C IN  : BMODAL : VECTEURS MODAUX
C IN  : NEQ    : NOMBRE D'EQUATIONS
C IN  : NEXCIT : NOMBRE D'EXCITATIONS
C IN  : INFO   : NIVEAU D'IMPRESSION
C OUT : LFLU   : LOGIQUE INDIQUANT LA PRESENCE DE LAME FLUIDE
C OUT : IER    : CODE RETOUR
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       IMODE, IAMOR, IM, I, J, JDPL, JDDL, LREFE
      REAL*8        DPILOC(6), DPIGLO(6), DDPILO(3), ORIGOB(3), UN
      REAL*8        SINA, COSA, SINB, COSB, SING, COSG, XJEU, XMAS,
     +              CTANG
      CHARACTER*8   NOEUD(3)
      CHARACTER*16  TYPNUM
      CHARACTER*24  MDGENE, NUMERO
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      IER  = 0
      UN   = 1.D0
      LFLU = .FALSE.
      NUMERO = ' '
      MDGENE = ' '
      CALL GETTCO ( NUMDDL, TYPNUM )
      IF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
         IF (NBSISM.GT.0 .OR. NBFLAM.GT.0) THEN
            CALL UTMESS('F','MDCHOC','CALCUL NON-LINEAIRE PAR '//
     &                      'SOUS-STRUCTURATION, PAS DE DISPOSITIF'//
     &                      ' ANTI-SISMIQUE OU DE FLAMBAGE POSSIBLE ')
         ENDIF
      ENDIF
C
C --- RECHERCHE DU MODE DE MASSE LA PLUS ELEVEE ---
C
      XMAS  = MASGEN(1)
      IMODE = 1
      DO 10 IM = 2 , NBMODE
         IF (MASGEN(IM).GT.XMAS) THEN
            XMAS = MASGEN(IM)
            IMODE = IM
         ENDIF
 10   CONTINUE
      IF ( LAMOR ) THEN
         IAMOR = IMODE
      ELSE
         IAMOR = IMODE + NBMODE*( IMODE - 1 )
      ENDIF
C
      DO 20 I = 1 , NBNLI
         DO 22 J = 1, 5
            LOGCHO(I,J) = 0
 22      CONTINUE
         DO 24 J = 1, 9
            NOECHO(I,J) = ' '
 24      CONTINUE
         DO 26 J = 1, 51
            PARCHO(I,J) = 0.D0
 26      CONTINUE
 20   CONTINUE
C
      CALL WKVECT ( '&&MDCHOC.DDLCHO', 'V V I', NBNLI*6, JDDL )
C
C --- CALCUL DIRECT
C
      IF (TYPNUM.EQ.'NUME_DDL_SDASTER') THEN
C         ----------------------------
         CALL MDCHST ( NUMDDL, TYPNUM, IMODE, IAMOR, PULSAT, MASGEN,  
     +                 AMOGEN, LFLU, NBNLI, NOECHO, LOGCHO, PARCHO,
     +                 INTITU, ZI(JDDL), IER )
C
C --- CALCUL PAR SOUS-STRUCTURATION
C
      ELSEIF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
C             ------------------------------
         CALL MDCHGE ( NUMDDL, TYPNUM, IMODE, IAMOR, PULSAT, MASGEN,
     +                 AMOGEN, LFLU, NBNLI, NOECHO, LOGCHO, PARCHO,
     +                 INTITU, ZI(JDDL), IER )
C
      ENDIF
C
      DO 100 I = 1,NBNLI
C
        CTANG = PARCHO(I,5)
C
        ORIGOB(1) = PARCHO(I,13)
        ORIGOB(2) = PARCHO(I,14)
        ORIGOB(3) = PARCHO(I,15)
C
        SINA = PARCHO(I,16)
        COSA = PARCHO(I,17)
        SINB = PARCHO(I,18)
        COSB = PARCHO(I,19)
        SING = PARCHO(I,20)
        COSG = PARCHO(I,21)
C
        IF (INFO.EQ.2) THEN
          CALL UTDEBM('I','MDCHOC',' INFOS NOEUDS DE CHOC')
          CALL UTIMPI('L','LIEU DE CHOC  : ',1,I)
          CALL UTIMPK('L','NOEUD DE CHOC  : ',1,NOECHO(I,1))
          IF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
            CALL UTIMPK('L','SOUS-STRUCTURE : ',1,NOECHO(I,2))
          ENDIF
          CALL UTIMPR('L','COORDONNEES    : X : ',1,PARCHO(I,7))
          CALL UTIMPR('L','                 Y : ',1,PARCHO(I,8))
          CALL UTIMPR('L','                 Z : ',1,PARCHO(I,9))
          IF ( NOECHO(I,9)(1:2).EQ.'BI') THEN
            CALL UTIMPK('L','NOEUD DE CHOC  : ',1,NOECHO(I,5))
            IF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
              CALL UTIMPK('L','SOUS-STRUCTURE : ',1,NOECHO(I,6))
            ENDIF
            CALL UTIMPR('L','COORDONNEES    : X : ',1,PARCHO(I,10))
            CALL UTIMPR('L','                 Y : ',1,PARCHO(I,11))
            CALL UTIMPR('L','                 Z : ',1,PARCHO(I,12))
          ENDIF
          CALL UTIMPR('L','AMORTISSEMENT TANGENT UTILISE : ',1,CTANG)
          CALL UTIMPR('L','ORIGINE CHOC X : ',1,PARCHO(I,13))
          CALL UTIMPR('L','             Y : ',1,PARCHO(I,14))
          CALL UTIMPR('L','             Z : ',1,PARCHO(I,15))
          CALL UTIMPR('L','NORM_OBST SIN(ALPHA) : ',1,PARCHO(I,16))
          CALL UTIMPR('L','          COS(ALPHA) : ',1,PARCHO(I,17))
          CALL UTIMPR('L','          SIN(BETA)  : ',1,PARCHO(I,18))
          CALL UTIMPR('L','          COS(BETA)  : ',1,PARCHO(I,19))
          CALL UTIMPR('L','ANGL_VRILLE : SIN(GAMMA) : ',1,PARCHO(I,20))
          CALL UTIMPR('L','              COS(GAMMA) : ',1,PARCHO(I,21))
          IF ( NOECHO(I,9)(1:2).EQ.'BI') THEN
             XJEU = (PARCHO(I,10)-PARCHO(I,7))**2 + 
     &              (PARCHO(I,11)-PARCHO(I,8))**2 +
     &              (PARCHO(I,12)-PARCHO(I,9))**2
             IF (I.LE.NBCHOC) THEN
                XJEU = SQRT(XJEU) - (PARCHO(I,29)+PARCHO(I,30))
             ELSE
                XJEU = SQRT(XJEU)
             ENDIF
             CALL UTIMPR('L','JEU INITIAL : ',1,XJEU)
          ENDIF
          CALL UTFINM( )
        ENDIF
C
C       POSITION INITIALE DU NOEUD 1 DANS LE REPERE GLOBAL
        DPIGLO(1) = PARCHO(I,7)
        DPIGLO(2) = PARCHO(I,8)
        DPIGLO(3) = PARCHO(I,9)
C       --- PASSAGE DANS LE REPERE LOCAL --- POUR LE NOEUD 1
        CALL GLOLOC(DPIGLO,ORIGOB,SINA,COSA,SINB,COSB,SING,COSG,DPILOC)
C       POSITON INITIALE DIFFERENTIELLE = DPILOC SI 1 NOEUD
        DDPILO(1) = DPILOC(1)
        DDPILO(2) = DPILOC(2)
        DDPILO(3) = DPILOC(3)
C
        IF ( NOECHO(I,9)(1:2).EQ.'BI') THEN
C          POSITION INITIALE DU NOEUD 2 DANS LE REPERE GLOBAL
           DPIGLO(4) = PARCHO(I,10)
           DPIGLO(5) = PARCHO(I,11)
           DPIGLO(6) = PARCHO(I,12)
C          --- PASSAGE DANS LE REPERE LOCAL --- POUR LE NOEUD 2
           CALL GLOLOC(DPIGLO(4),ORIGOB,SINA,COSA,SINB,COSB,SING,COSG,
     +                 DPILOC(4))
C          POSITION INITIALE DU NOEUD1 PAR RAPPORT AU NOEUD2
           DDPILO(1) = DPILOC(1)-DPILOC(4)
           DDPILO(2) = DPILOC(2)-DPILOC(5)
           DDPILO(3) = DPILOC(3)-DPILOC(6)
        ENDIF
        PARCHO(I,36)= -SIGN(UN,DDPILO(2))
        PARCHO(I,37)= -SIGN(UN,DDPILO(3))

 100  CONTINUE
C
C --- REMPLISSAGE DE DPLMOD(I,J,K) ---
C
      IF (TYPNUM.EQ.'NUME_DDL_SDASTER') THEN
C         ----------------------------
         DO 200 I=1,NBNLI
            DO 210 J=1,NBMODE
               DPLMOD(I,J,1) = BMODAL(ZI(JDDL-1+6*(I-1)+1),J)
               DPLMOD(I,J,2) = BMODAL(ZI(JDDL-1+6*(I-1)+2),J)
               DPLMOD(I,J,3) = BMODAL(ZI(JDDL-1+6*(I-1)+3),J)
               IF (NOECHO(I,9)(1:2).EQ.'BI') THEN
                  DPLMOD(I,J,4) = BMODAL(ZI(JDDL-1+6*(I-1)+4),J)
                  DPLMOD(I,J,5) = BMODAL(ZI(JDDL-1+6*(I-1)+5),J)
                  DPLMOD(I,J,6) = BMODAL(ZI(JDDL-1+6*(I-1)+6),J)
               ELSE
                  DPLMOD(I,J,4) = 0.D0
                  DPLMOD(I,J,5) = 0.D0
                  DPLMOD(I,J,6) = 0.D0
               ENDIF
 210        CONTINUE
 200     CONTINUE
C
      ELSEIF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
C             -------------------------------
         NUMERO(1:14) = NUMDDL
         CALL JEVEUO(NUMDDL//'.NUME.REFN','L',LREFE)
         MDGENE = ZK24(LREFE)
         DO 220 I=1,NBNLI
            CALL WKVECT('&&MDCHOC.DPLCHO','V V R8',NBMODE*6,JDPL)
            NOEUD(1) = NOECHO(I,1)
            NOEUD(2) = NOECHO(I,2)
            NOEUD(3) = NOECHO(I,3)
            CALL RESMOD(BMODAL,NBMODE,NEQ,NUMERO,MDGENE,NOEUD,ZR(JDPL))
            DO 230 J=1,NBMODE
               DPLMOD(I,J,1) = ZR(JDPL-1+J)
               DPLMOD(I,J,2) = ZR(JDPL-1+J+NBMODE)
               DPLMOD(I,J,3) = ZR(JDPL-1+J+2*NBMODE)
 230        CONTINUE
            IF (NOECHO(I,9)(1:2).EQ.'BI') THEN
               NOEUD(1) = NOECHO(I,5)
               NOEUD(2) = NOECHO(I,6)
               NOEUD(3) = NOECHO(I,7)
             CALL RESMOD(BMODAL,NBMODE,NEQ,NUMERO,MDGENE,NOEUD,ZR(JDPL))
               DO 240 J=1,NBMODE
                  DPLMOD(I,J,4) = ZR(JDPL-1+J)
                  DPLMOD(I,J,5) = ZR(JDPL-1+J+NBMODE)
                  DPLMOD(I,J,6) = ZR(JDPL-1+J+2*NBMODE)
 240           CONTINUE
            ELSE
               DO 250 J=1,NBMODE
                  DPLMOD(I,J,4) = 0.D0
                  DPLMOD(I,J,5) = 0.D0
                  DPLMOD(I,J,6) = 0.D0
 250           CONTINUE
            ENDIF
            CALL JEDETR('&&MDCHOC.DPLCHO')
 220     CONTINUE
      ENDIF
C
C --- REMPLISSAGE DE PS2DEL(I,J,K) ---
C
      IF (MONMOT(1:3).EQ.'OUI') THEN
         IF (TYPNUM.EQ.'NUME_DDL_SDASTER') THEN
            DO 300 I=1,NBNLI
               DO 310 J=1,NEXCIT
                  PS2DEL(I,J,1) = PS1DEL(ZI(JDDL-1+6*(I-1)+1),J)
                  PS2DEL(I,J,2) = PS1DEL(ZI(JDDL-1+6*(I-1)+2),J)
                  PS2DEL(I,J,3) = PS1DEL(ZI(JDDL-1+6*(I-1)+3),J)
                  IF (NOECHO(I,9)(1:2).EQ.'BI') THEN
                    PS2DEL(I,J,4) = PS1DEL(ZI(JDDL-1+6*(I-1)+4),J)
                    PS2DEL(I,J,5) = PS1DEL(ZI(JDDL-1+6*(I-1)+5),J)
                    PS2DEL(I,J,6) = PS1DEL(ZI(JDDL-1+6*(I-1)+6),J)
                  ELSE
                    PS2DEL(I,J,4) = 0.D0
                    PS2DEL(I,J,5) = 0.D0
                    PS2DEL(I,J,6) = 0.D0
                  ENDIF
 310           CONTINUE
 300        CONTINUE
         ELSEIF (TYPNUM(1:13).EQ.'NUME_DDL_GENE') THEN
            IER = IER + 1
            CALL UTMESS('E','MDCHOC','LE MULTI-APPUI + SOUS-'//
     +              'STRUCTURATION N''EST PAS DEVELOPPE - BON COURAGE')
         ENDIF
      ENDIF
C
C --- VERIFICATION DE COHERENCE ENTRE CHOC ET FLAMBAGE ---
C
      IF (NBCHOC.NE.0 .AND. NBFLAM.NE.0) THEN
         DO 140 I=1,NBCHOC
            J = NBCHOC+NBSISM
 130        CONTINUE
            J = J + 1
            IF (J.LE. NBNLI) THEN
               IF (NOECHO(I,1).NE.NOECHO(J,1)) GOTO 130
               IF (NOECHO(I,5).NE.NOECHO(J,5)) GOTO 130
               CALL UTMESS('A','MDCHOC','CONFLIT ENTRE CHOC ET '//
     &                    'FLAMBAGE AU MEME LIEU DE CHOC : LE '//
     &                    'CALCUL SERA DE TYPE FLAMBAGE')
               PARCHO(I,2) = 0.D0
               PARCHO(I,4) = 0.D0
            ENDIF
 140     CONTINUE
      ENDIF
C
      CALL JEDETR('&&MDCHOC.DDLCHO')
C
      CALL JEDEMA()
      END
