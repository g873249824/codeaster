      SUBROUTINE CHRPEL(CHAMP1, REPERE, NBCMP, ICHAM, TYPE, NOMCH)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/01/2005   AUTEUR REZETTE C.REZETTE 
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
C TOLE CRP_20
      IMPLICIT      NONE
      INTEGER       NBCMP , ICHAM
      CHARACTER*(*) CHAMP1, REPERE, TYPE, NOMCH
C ----------------------------------------------------------------------
C
C     BUT : CHANGEMENT DE REPERE DANS LE CAS D'UN CHAM_ELEM
C ----------------------------------------------------------------------
C     ARGUMENTS :
C     CHAMP1   IN  K16  : NOM DU CHAMP A TRAITER
C     REPERE   IN  K8   : TYPE DE REPERE (UTILISATEUR OU CYLINDRIQUE)
C     NBCMP    IN  I    : NOMBRE DE COMPOSANTES A TRAITER
C     ICHAM    IN  I    : NUMERO D'OCCURRENCE
C ----------------------------------------------------------------------
C ----- DEBUT COMMUNS NORMALISES  JEVEUX  ------------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNUM, JEXNOM, JEXATR
C ----- FIN COMMUNS NORMALISES  JEVEUX  -------------------------------
C ---------------------------------------------------------------------
C
      INTEGER      I     , II    , INO   , IAD   , IPT   , ISP
      INTEGER      JCESD , JCESV , JCESL , NBPT  , AXYZM , NCMP
      INTEGER      JCONX1, JCONX2, NBSP  , INEL  , JCMP  , IPT2
      INTEGER      IBID  , NBMA  , JCESK , IRET  , INOT  , INBNO
      INTEGER      NDIM  , LICMPU(6), NBM, IDMAIL, NBMAIL, IMAI
      INTEGER      INOEU , IRET0 , IGRNO , IRET1 , NBGNO , IGNO
      LOGICAL      TEST
      REAL*8       ANGNOT(3), PGL(3,3), VALER(6), VALED(6)
      REAL*8       VALET(6) , EPSI    , XNORMR  , PROSCA,  R8DGRD
      REAL*8       ORIG(3)  , AXEZ(3) , AXER(3) , AXET(3),PGL2(3,3)
      CHARACTER*1  K1B
      CHARACTER*8  MA    , K8B, TYPMCL(2)
      CHARACTER*16 OPTION,MOTCLE(2)
      CHARACTER*19 CHAMS1,CHAMS0
      CHARACTER*24 LIGREL,MESMAI
C
      CALL JEMARQ()
      EPSI = 1.0D-6
      MOTCLE(1) = 'GROUP_MA'
      TYPMCL(1) = 'GROUP_MA'
      MOTCLE(2) = 'MAILLE'
      TYPMCL(2) = 'MAILLE'

      MESMAI = '&&CHRPEL.MES_MAILLES'
C
      IF (NBCMP.GT.0) THEN
         CALL WKVECT('&&CHRPEL.NOM_CMP','V V K8',NBCMP,JCMP)
         CALL GETVTX('MODI_CHAM','NOM_CMP',ICHAM,1,NBCMP,
     +                ZK8(JCMP),IBID)
      ELSE
           CALL UTMESS('F','CHRPNO','IL FAUT DEFINIR NOM_CMP')
      ENDIF
 

C
C ----- DEFINITION ET CREATION DU CHAM_NO SIMPLE CHAMS1
C ----- A PARTIR DU CHAM_NO CHAMP1
C
      CHAMS0='&&CHRPEL.CHAMS0'
      CHAMS1='&&CHRPEL.CHAMS1'
      CALL CELCES(CHAMP1,'V',CHAMS0)
      CALL CESRED(CHAMS0,0,0,NBCMP,ZK8(JCMP),'V',CHAMS1)
      CALL DETRSD('CHAM_ELEM_S',CHAMS0)
      CALL JEVEUO(CHAMS1//'.CESK','L',JCESK)
      CALL JEVEUO(CHAMS1//'.CESD','L',JCESD)
      MA     = ZK8(JCESK-1+1)
C
C     ON EXCLUT LES MOT-CLES 'NOEUD' ET 'GROUP_NO'
      CALL JEVEUO(MA//'.DIME   ','L',INBNO)
      CALL JELIRA(MA//'.GROUPENO','NMAXOC',NBGNO,K1B)
      CALL WKVECT('&&CHRPEL.NOEUDS','V V K8',ZI(INBNO),INOEU)
      CALL WKVECT('&&CHRPEL.GROUP_NO','V V K8',NBGNO,IGNO)
      CALL GETVTX('MODI_CHAM','NOEUD',ICHAM,1,0,ZK8(INOEU),IRET0)
      CALL GETVTX('MODI_CHAM','GROUP_NO',ICHAM,1,0,ZK8(IGNO),IRET1)
      IF(IRET0.LT.0)THEN
           K8B='NOEUD   '
      ELSE IF(IRET1.LT.0)THEN
           K8B='GROUP_NO'
      ELSE 
        GOTO 100
      ENDIF
      CALL UTDEBM('F','CHRPEL','LE ')
      CALL UTIMPK('S','MOT-CLE ',1,K8B)
      CALL UTIMPK('S','EST INCOMPATIBLE AVEC LE CHAMP',1,NOMCH)
      CALL UTIMPK('S','. UTILISER ''GROUP_MA'' OU ''MAILLE'''
     +   //' POUR RESTREINDRE LE CHANGEMENT DE REPERE A CERTAINES' 
     +   //' MAILLES.',0,' ')
      CALL UTFINM()
      CALL JEDETR('&&CHRPEL.NOEUDS')
      CALL JEDETR('&&CHRPEL.GROUP_NO')
 100  CONTINUE
C
      NBMA   = ZI(JCESD-1+1)
      NCMP   = ZI(JCESD-1+2)
      CALL DISMOI ('F','Z_CST',MA,'MAILLAGE',NDIM,K8B,IRET)
      NDIM = 3
      IF (K8B.EQ.'OUI') NDIM = 2

      CALL RELIEM(' ',MA,'NU_MAILLE','MODI_CHAM',ICHAM,2,MOTCLE,TYPMCL,
     +                                                   MESMAI,NBM)
      
      IF (NBM.GT.0) THEN
        NBMAIL = NBM
        CALL JEVEUO(MESMAI,'L',IDMAIL)
      ELSE
        NBMAIL = NBMA
      ENDIF

      CALL JEEXIN(MA//'.CONNEX',IRET)
      IF (IRET.EQ.0) CALL UTMESS('F','CHRPEL','STOP')
      CALL JEVEUO(MA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',JCONX2)
      CALL JEVEUO(CHAMS1//'.CESV','E',JCESV)
      CALL JEVEUO(CHAMS1//'.CESL','L',JCESL)
C
      DO 1 I = 1,6
         VALED(I) = 0.0D0
         VALER(I) = 0.0D0
         VALET(I) = 0.0D0
 1    CONTINUE
      DO 2 I = 1,3
         AXER(I)   = 0.0D0
         AXET(I)   = 0.0D0
         AXEZ(I)   = 0.0D0
         ORIG(I)   = 0.0D0
         ANGNOT(I) = 0.0D0
 2    CONTINUE
      LICMPU(1) = 1
      LICMPU(2) = 2
      LICMPU(3) = 3
      LICMPU(4) = 4
      LICMPU(5) = 5
      LICMPU(6) = 6
C
C ----- CHANGEMENT DE REPERE SUIVANT LE CHOIX UTILISATEUR
C
      IF (REPERE.EQ.'UTILISAT') THEN
         IF (NDIM.EQ.3) THEN
            CALL GETVR8('DEFI_REPERE','ANGL_NAUT',1,1,3,ANGNOT,IBID)
            IF (IBID.NE.3) THEN
               CALL UTMESS('F','CHRPEL','IL FAUT DEFINIR 3 ANGLES'//
     +                     ' NAUTIQUES.')
            ENDIF
         ELSE
            CALL GETVR8('DEFI_REPERE','ANGL_NAUT',1,1,1,ANGNOT(1),IBID)
            IF (IBID.NE.1) THEN
               CALL UTDEBM('A','CHRPEL','ETUDE 2D')
               CALL UTIMPR('L','ANGLE NAUTIQUE UNIQUE : ',1,
     +                                  ANGNOT(1))
               CALL UTFINM()
            ENDIF
         ENDIF
         ANGNOT(1) = ANGNOT(1)*R8DGRD()
         ANGNOT(2) = ANGNOT(2)*R8DGRD()
         ANGNOT(3) = ANGNOT(3)*R8DGRD()
         CALL MATROT(ANGNOT,PGL)
         IF (TYPE(1:4).EQ.'TENS') THEN
            DO 10 INEL=1,NBMAIL
               IF (NBM.NE.0) THEN
                 IMAI = ZI(IDMAIL+INEL-1)
               ELSE
                 IMAI = INEL
               ENDIF
               NBPT = ZI(JCESD-1+5+4* (IMAI-1)+1)
               NBSP = ZI(JCESD-1+5+4* (IMAI-1)+2)
               DO 11,IPT = 1,NBPT
                  DO 12,ISP = 1,NBSP
                     DO 13 II=1,NCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,II,IAD)
                        IF (IAD.GT.0) THEN
                           VALET(II)=ZR(JCESV-1+IAD)
                        ELSE
                           GOTO 10
                        ENDIF
 13                  CONTINUE
                     VALED(1) = VALET(1)
                     VALED(2) = VALET(4)
                     VALED(3) = VALET(2)
                     VALED(4) = VALET(5)
                     VALED(5) = VALET(6)
                     VALED(6) = VALET(3)
                     CALL UTPSGL(1,3,PGL,VALED,VALET)
                     VALER(1) = VALET(1)
                     VALER(2) = VALET(3)
                     VALER(3) = VALET(6)
                     VALER(4) = VALET(2)
                     VALER(5) = VALET(4)
                     VALER(6) = VALET(5)
                     DO 14 II=1,NBCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,
     +                              II,IAD)
                        IF (IAD.GT.0) THEN
                           ZR(JCESV-1+IAD) = VALER(II)
                        ELSE
                           GOTO 10
                        ENDIF
 14                  CONTINUE
 12               CONTINUE
 11            CONTINUE
 10         CONTINUE
         ELSE
            DO 15 INEL=1,NBMAIL
               IF (NBM.NE.0) THEN
                 IMAI = ZI(IDMAIL+INEL-1)
               ELSE
                 IMAI = INEL
               ENDIF
               NBPT = ZI(JCESD-1+5+4* (IMAI-1)+1)
               NBSP = ZI(JCESD-1+5+4* (IMAI-1)+2)
               DO 16,IPT = 1,NBPT
                  DO 17,ISP = 1,NBSP
                     DO 18 II=1,NCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,II,IAD)
                        IF (IAD.GT.0) THEN
                           VALED(II) = ZR(JCESV-1+IAD)
                        ELSE
                           GOTO 15
                        ENDIF
 18                  CONTINUE
                     IF (NDIM.EQ.3) THEN
                        CALL UTPVGL(1,NCMP,PGL,VALED,VALER)
                     ELSE
                        CALL UT2VGL(1,NCMP,PGL,VALED,VALER)
                     ENDIF
                     DO 19 II=1,NBCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,II,IAD)
                        IF (IAD.GT.0) THEN
                           ZR(JCESV-1+IAD) = VALER(II)
                        ELSE
                           GOTO 15
                        ENDIF
 19                  CONTINUE
 17               CONTINUE
 16            CONTINUE
 15         CONTINUE
         ENDIF
      ELSE
         IF (NDIM.EQ.3) THEN
            CALL GETVR8('DEFI_REPERE','ORIGINE',1,1,3,ORIG,IBID)
            IF (IBID.NE.3) THEN
               CALL UTMESS('F','CHRPEL','L ORIGINE DOIT ETRE'//
     +                     ' DEFINIE PAR 3 COORDONNEES.')
            ENDIF
            CALL GETVR8('DEFI_REPERE','AXE_Z',1,1,3,AXEZ,IBID)
            IF (IBID.EQ.0) THEN
               CALL UTMESS('F','CHRPEL','L AXE Z EST OBLIGATOIRE'//
     +                     ' EN 3D.')
            ENDIF
         ELSE
            CALL GETVR8('DEFI_REPERE','ORIGINE',1,1,2,ORIG,IBID)
            IF (IBID.NE.2) THEN
               CALL UTMESS('A','CHRPEL','POUR LE 2D ON NE PREND'//
     +                     ' QUE 2 COORDONNEES POUR L ORIGINE.')
            ENDIF
            CALL GETVR8('DEFI_REPERE','AXE_Z',1,1,0,AXEZ,IBID)
            IF (IBID.NE.0) THEN
               CALL UTMESS('A','CHRPEL','L AXE Z EST N A PAS'//
     +                     ' DE SENS EN 2D.')
            ENDIF
            AXEZ(1) = 0.0D0
            AXEZ(2) = 0.0D0
            AXEZ(3) = 1.0D0
         ENDIF
         XNORMR = 0.0D0
         CALL NORMEV(AXEZ,XNORMR)
         CALL JEVEUO ( MA//'.COORDO    .VALE', 'L', AXYZM )
C
C ----- TYPE DE COMPOSANTES
C
         IF (TYPE(1:4).EQ.'TENS') THEN
            IF (NDIM.EQ.2) THEN
               LICMPU(1)=1
               LICMPU(2)=2
               LICMPU(3)=3
               LICMPU(4)=5
            ENDIF
            DO 20 INEL = 1, NBMAIL
               IF (NBM.NE.0) THEN
                 IMAI = ZI(IDMAIL+INEL-1)
               ELSE
                 IMAI = INEL
               ENDIF
               NBPT = ZI(JCESD-1+5+4* (IMAI-1)+1)
               NBSP = ZI(JCESD-1+5+4* (IMAI-1)+2)
               DO 21,IPT = 1,NBPT
                  DO 22,ISP = 1,NBSP
                     TEST = .TRUE.
                     DO 23 II=1,NCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,II,IAD)
                        IF (IAD.GT.0) THEN
                           TEST = .FALSE.
                        ENDIF
 23                  CONTINUE
                     IF(TEST) GOTO 20
                     INO = ZI(JCONX1-1+ZI(JCONX2+IMAI-1)+IPT-1)
                     AXER(1) = ZR(AXYZM+3*(INO-1)  ) - ORIG(1)
                     AXER(2) = ZR(AXYZM+3*(INO-1)+1) - ORIG(2)
                     IF (NDIM.EQ.3) THEN
                        AXER(3) = ZR(AXYZM+3*(INO-1)+2) - ORIG(3)
                     ELSE
                        AXER(3) = 0.0D0
                     ENDIF
                     CALL PSCAL(3,AXER,AXEZ,PROSCA)
                     AXER(1) = AXER(1) - PROSCA*AXEZ(1)
                     AXER(2) = AXER(2) - PROSCA*AXEZ(2)
                     IF (NDIM.EQ.3) THEN
                        AXER(3) = AXER(3) - PROSCA*AXEZ(3)
                     ELSE
                        AXER(3) = 0.0D0
                     ENDIF
                     XNORMR = 0.0D0
                     CALL NORMEV(AXER,XNORMR)
                     IF (XNORMR .LT. EPSI) THEN
                        CALL JENUNO(JEXNUM(MA//'.NOMNOE',INO),K8B)
                        CALL UTMESS('A',K8B,'LE NOEUD SE TROUVE SUR L'
     +                  //' AXE DU REPERE CYLINDRIQUE. ON PREND LE'
     +                  //' NOEUD MOYEN DES CENTRES GEOMETRIQUES.')
                        AXER(1) = 0.0D0
                        AXER(2) = 0.0D0
                        AXER(3) = 0.0D0
                        DO 24 IPT2 = 1,NBPT
                           INOT = ZI(JCONX1-1+ZI(JCONX2+IMAI-1)+IPT2-1)
                           AXER(1) = AXER(1) + ZR(AXYZM+3*(INOT-1)  )
                           AXER(2) = AXER(2) + ZR(AXYZM+3*(INOT-1)+1)
                           IF (NDIM.EQ.3) THEN
                              AXER(3) = AXER(3) +
     +                                  ZR(AXYZM+3*(INOT-1)+2)
                           ENDIF
 24                     CONTINUE
                        AXER(1) = AXER(1)/NBPT - ORIG(1)
                        AXER(2) = AXER(2)/NBPT - ORIG(2)
                        AXER(3) = AXER(3)/NBPT - ORIG(3)
                        CALL PSCAL(3,AXER,AXEZ,PROSCA)
                        AXER(1) = AXER(1) - PROSCA*AXEZ(1)
                        AXER(2) = AXER(2) - PROSCA*AXEZ(2)
                        IF (NDIM.EQ.3) THEN
                           AXER(3) = AXER(3) - PROSCA*AXEZ(3)
                        ELSE
                           AXER(3) = 0.0D0
                        ENDIF
                        XNORMR = 0.0D0
                        CALL NORMEV(AXER,XNORMR)
                        IF (XNORMR .LT. EPSI) THEN
                           CALL JENUNO(JEXNUM(MA//'.NOMNOE',INO),K8B)
                           CALL UTDEBM('F','CHRPEL','NOEUD SUR L AXE_Z')
                           CALL UTIMPK('L',' NOEUD : ',1,K8B)
                           CALL UTFINM()
                        ENDIF
                     ENDIF
                     CALL PROVEC(AXEZ,AXER,AXET)
                     XNORMR = 0.0D0
                     CALL NORMEV(AXET,XNORMR)
                     DO 26 I = 1,3
                        PGL(1,I) = AXER(I)
                        PGL(2,I) = AXEZ(I)
                        PGL(3,I) = AXET(I)
 26                  CONTINUE
                     DO 27 II=1,NCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,II,IAD)
                        IF (IAD.GT.0) THEN
                           VALET(II)=ZR(JCESV-1+IAD)
                        ELSE
                           GO TO 20
                        ENDIF
 27                  CONTINUE
                     VALED(1) = VALET(1)
                     VALED(2) = VALET(4)
                     VALED(3) = VALET(2)
                     VALED(4) = VALET(5)
                     VALED(5) = VALET(6)
                     VALED(6) = VALET(3)
                     CALL UTPSGL(1,3,PGL,VALED,VALET)
                     VALER(1) = VALET(1)
                     VALER(2) = VALET(3)
                     VALER(3) = VALET(6)
                     VALER(4) = VALET(2)
                     VALER(5) = VALET(4)
                     VALER(6) = VALET(5)
                     DO 28 II=1,NBCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,
     +                              II,IAD)
                        IF (IAD.GT.0) THEN
                           ZR(JCESV-1+IAD) = VALER(LICMPU(II))
                        ELSE
                           GOTO 20
                        ENDIF
 28                  CONTINUE
 22               CONTINUE
 21            CONTINUE
 20         CONTINUE
         ELSE
            IF (NDIM.EQ.2) THEN
               LICMPU(1)=1
               LICMPU(2)=3
               LICMPU(3)=2
            ENDIF
            DO 29 INEL=1,NBMAIL
               IF (NBM.NE.0) THEN
                 IMAI = ZI(IDMAIL+INEL-1)
               ELSE
                 IMAI = INEL
               ENDIF
               NBPT = ZI(JCESD-1+5+4* (IMAI-1)+1)
               NBSP = ZI(JCESD-1+5+4* (IMAI-1)+2)
               DO 30,IPT = 1,NBPT
                  DO 31,ISP = 1,NBSP
                     TEST = .TRUE.
                     DO 32 II=1,NCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,II,IAD)
                        IF (IAD.GT.0) THEN
                           TEST = .FALSE.
                        ENDIF
 32                  CONTINUE
                     IF(TEST) GOTO 29
                     INO = ZI(JCONX1-1+ZI(JCONX2+IMAI-1)+IPT-1)
                     AXER(1) = ZR(AXYZM+3*(INO-1)  ) - ORIG(1)
                     AXER(2) = ZR(AXYZM+3*(INO-1)+1) - ORIG(2)
                     IF (NDIM.EQ.3) THEN
                        AXER(3) = ZR(AXYZM+3*(INO-1)+2) - ORIG(3)
                     ELSE
                        AXER(3) = 0.0D0
                     ENDIF
                     CALL PSCAL(3,AXER,AXEZ,PROSCA)
                     AXER(1) = AXER(1) - PROSCA*AXEZ(1)
                     AXER(2) = AXER(2) - PROSCA*AXEZ(2)
                     IF (NDIM.EQ.3) THEN
                        AXER(3) = AXER(3) - PROSCA*AXEZ(3)
                     ELSE
                        AXER(3) = 0.0D0
                     ENDIF
                     XNORMR = 0.0D0
                     CALL NORMEV(AXER,XNORMR)
                     IF (XNORMR .LT. EPSI) THEN
                        CALL JENUNO(JEXNUM(MA//'.NOMNOE',INO),K8B)
                        CALL UTMESS('A',K8B,'LE NOEUD SE TROUVE SUR L'
     +                  //' AXE DU REPERE CYLINDRIQUE. ON PREND LE'
     +                  //' NOEUD MOYEN DES CENTRES GEOMETRIQUES.')
                        AXER(1) = 0.0D0
                        AXER(2) = 0.0D0
                        AXER(3) = 0.0D0
                        DO 33 IPT2 = 1,NBPT
                           INOT = ZI(JCONX1-1+ZI(JCONX2+IMAI-1)+IPT2-1)
                           AXER(1) = AXER(1) + ZR(AXYZM+3*(INOT-1)  )
                           AXER(2) = AXER(2) + ZR(AXYZM+3*(INOT-1)+1)
                           IF (NDIM.EQ.3) THEN
                              AXER(3) = AXER(3) +
     +                                  ZR(AXYZM+3*(INOT-1)+2)
                           ENDIF
 33                     CONTINUE
                        AXER(1) = AXER(1)/NBPT - ORIG(1)
                        AXER(2) = AXER(2)/NBPT - ORIG(2)
                        AXER(3) = AXER(3)/NBPT - ORIG(3)
                        CALL PSCAL(3,AXER,AXEZ,PROSCA)
                        AXER(1) = AXER(1) - PROSCA*AXEZ(1)
                        AXER(2) = AXER(2) - PROSCA*AXEZ(2)
                        IF (NDIM.EQ.3) THEN
                           AXER(3) = AXER(3) - PROSCA*AXEZ(3)
                        ELSE
                           AXER(3) = 0.0D0
                        ENDIF
                        XNORMR = 0.0D0
                        CALL NORMEV(AXER,XNORMR)
                        IF (XNORMR .LT. EPSI) THEN
                           CALL JENUNO(JEXNUM(MA//'.NOMNOE',INO),K8B)
                           CALL UTDEBM('F','CHRPEL','NOEUD SUR L AXE_Z')
                           CALL UTIMPK('L',' NOEUD : ',1,K8B)
                           CALL UTFINM()
                        ENDIF
                     ENDIF
                     CALL PROVEC(AXEZ,AXER,AXET)
                     XNORMR = 0.0D0
                     CALL NORMEV(AXET,XNORMR)
                     DO 35 I = 1,3
                        PGL(1,I) = AXER(I)
                        PGL(2,I) = AXEZ(I)
                        PGL(3,I) = AXET(I)
 35                  CONTINUE
                     DO 36 II=1,NCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,II,IAD)
                        IF (IAD.GT.0) THEN
                           VALED(II)=ZR(JCESV-1+IAD)
                        ELSE
                           GOTO 29
                        ENDIF
 36                  CONTINUE
                     IF (NDIM.EQ.3) THEN
                        CALL UTPVGL(1,3,PGL,VALED,VALER)
                     ELSE
                        CALL UT2VGL(1,3,PGL,VALED,VALER)
                     ENDIF
                     DO 37 II=1,NBCMP
                        CALL CESEXI('C',JCESD,JCESL,IMAI,IPT,ISP,
     +                              II,IAD)
                        IF (IAD.GT.0) THEN
                           ZR(JCESV-1+IAD) = VALER(LICMPU(II))
                        ELSE
                           GOTO 29
                        ENDIF
 37                  CONTINUE
 31               CONTINUE
 30            CONTINUE
 29         CONTINUE
         ENDIF
      ENDIF
      CALL DISMOI ( 'F', 'NOM_LIGREL', CHAMP1, 'CHAM_ELEM',
     +              IBID, LIGREL, IBID )
      CALL DISMOI ( 'F', 'NOM_OPTION', CHAMP1, 'CHAM_ELEM',
     +              IBID, OPTION, IBID )
      CALL CESCEL(CHAMS1,LIGREL,OPTION,' ','OUI','G',CHAMP1)
      CALL DETRSD('CHAM_ELEM_S',CHAMS1)
      CALL JEDETR('&&CHRPEL.NOM_CMP')
      CALL JEDETR(MESMAI)
 9999 CONTINUE
      CALL JEDEMA( )
C
      END
