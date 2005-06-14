      SUBROUTINE CHRPNO( CHAMP1, REPERE, NBCMP, ICHAM, TYPE)
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
      IMPLICIT       NONE
      INTEGER        NBCMP , ICHAM
      CHARACTER*(*)  CHAMP1, REPERE, TYPE
C ----------------------------------------------------------------------
C
C     BUT : CHANGEMENT DE REPERE DANS LE CAS D'UN CHAM_NO
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
      CHARACTER*32      JEXNUM, JEXNOM,JEXATR
C ----- FIN COMMUNS NORMALISES  JEVEUX  -------------------------------
C ---------------------------------------------------------------------
C
      INTEGER      I     , NBNO  , INO   , JCMP  , IBID  
      INTEGER      AXYZM , II    , NBMA  , IPT2  , IER   , INEL
      INTEGER      JCNSD , JCNSK , JCNSV , JCONX1, JCONX2, NBPT
      INTEGER      IPT   , INOT  , NDIM  , LICMPU(6), JCNSL
      INTEGER      NBN, IDNOEU, NBNOEU, INOE
      REAL*8       ANGNOT(3), PGL(3,3), VALER(6), VALED(6)
      REAL*8       ORIG(3)  , AXEZ(3) , AXER(3) , AXET(3)
      REAL*8       EPSI     , PROSCA  , XNORMR  , VALET(6)
      REAL*8       R8DGRD, PGL2(3,3)
      CHARACTER*8  MA    , K8B, TYPMCL(4)
      CHARACTER*16 MOTCLE(4)
      CHARACTER*19 CHAMS1,CHAMS0
      CHARACTER*24 MESNOE

      CALL JEMARQ()
      EPSI = 1.0D-6
      MOTCLE(1) = 'GROUP_NO'
      TYPMCL(1) = 'GROUP_NO'
      MOTCLE(2) = 'NOEUD'
      TYPMCL(2) = 'NOEUD'
      MOTCLE(3) = 'GROUP_MA'
      TYPMCL(3) = 'GROUP_MA'
      MOTCLE(4) = 'MAILLE'
      TYPMCL(4) = 'MAILLE'
      MESNOE = '&&CHRPEL.MES_NOEUDS'
C
      IF (NBCMP.GT.0) THEN
         CALL WKVECT('&&CHRPNO.NOM_CMP','V V K8',NBCMP,JCMP)
         CALL GETVTX('MODI_CHAM','NOM_CMP',ICHAM,1,NBCMP,
     +   ZK8(JCMP),IBID)
      ELSE
           CALL UTMESS('F','CHRPNO','IL FAUT DEFINIR NOM_CMP')
      ENDIF
C
C ----- DEFINITION ET CREATION DU CHAM_NO SIMPLE CHAMS1
C ----- A PARTIR DU CHAM_NO CHAMP1
C
      CHAMS0='&&CHRPNO.CHAMS0'
      CHAMS1='&&CHRPNO.CHAMS1'
      CALL CNOCNS(CHAMP1,'V',CHAMS0)
      CALL CNSRED(CHAMS0,0,0,NBCMP,ZK8(JCMP),'V',CHAMS1)
      CALL DETRSD('CHAM_NO_S',CHAMS0)
      CALL JEVEUO(CHAMS1//'.CNSK','L',JCNSK)
      CALL JEVEUO(CHAMS1//'.CNSD','L',JCNSD)
      MA    = ZK8(JCNSK-1+1)
      NBNO  = ZI(JCNSD-1+1)
      CALL JEVEUO(CHAMS1//'.CNSV','E',JCNSV)
      CALL JEVEUO(CHAMS1//'.CNSL','E',JCNSL)
      CALL DISMOI ('F','Z_CST',MA,'MAILLAGE',NDIM,K8B,IER)
      NDIM = 3
      IF (K8B.EQ.'OUI') NDIM = 2
      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,K8B,IER)
C

      CALL RELIEM(' ',MA,'NU_NOEUD','MODI_CHAM',ICHAM,4,MOTCLE,TYPMCL,
     +                                                  MESNOE,NBN)

      IF (NBN.GT.0) THEN
        NBNOEU = NBN
        CALL JEVEUO(MESNOE,'L',IDNOEU)
      ELSE
        NBNOEU = NBNO
      ENDIF
C
C    SI UNE DES COMPOSANTES EST ABSENTE SUR UN NOEUD 
C    IL EST IGNORE
C
      DO 110 INO=1,NBNOEU
         IF (NBN.NE.0) THEN
            INOE = ZI(IDNOEU+INO-1)
         ELSE
            INOE = INO
         ENDIF
         DO 111 II=1,NBCMP
            IF (.NOT.ZL(JCNSL-1+(INOE-1)*NBCMP+II)) GOTO 112
111      CONTINUE
         GOTO 110
112      CONTINUE
         DO 114 II=1,NBCMP
            ZL(JCNSL-1+(INOE-1)*NBCMP+II)=.FALSE.
114      CONTINUE
110   CONTINUE
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
               CALL UTMESS('F','CHRPNO','IL FAUT DEFINIR 3 ANGLES'//
     +                     ' NAUTIQUES.')
            ENDIF
         ELSE
            CALL GETVR8('DEFI_REPERE','ANGL_NAUT',1,1,1,ANGNOT(1),IBID)
            IF (IBID.NE.1) THEN
               CALL UTDEBM('A','CHRPNO','ETUDE 2D')
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
            DO 10 INO=1,NBNOEU
               IF (NBN.NE.0) THEN
                 INOE = ZI(IDNOEU+INO-1)
               ELSE
                 INOE = INO
               ENDIF
               IF (.NOT.ZL(JCNSL-1+(INOE-1)*NBCMP+1)) GOTO 10
               DO 11 II=1,NBCMP
                  VALET(II)=ZR(JCNSV-1+(INOE-1)*NBCMP+II)
 11            CONTINUE
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
               DO 12 II=1,NBCMP
                  ZR(JCNSV-1+(INOE-1)*NBCMP+II) = VALER(II)
 12            CONTINUE
 
 10         CONTINUE
         ELSE
C VECTEUR
            DO 13 INO=1,NBNOEU
               IF (NBN.NE.0) THEN
                 INOE = ZI(IDNOEU+INO-1)
               ELSE
                 INOE = INO
               ENDIF
               IF (.NOT.ZL(JCNSL-1+(INOE-1)*NBCMP+1)) GOTO 13
               DO 14 II=1,NBCMP
                  VALED(II)=ZR(JCNSV-1+(INOE-1)*NBCMP+II)
 14            CONTINUE
               IF (NDIM.EQ.3) THEN
                  CALL UTPVGL(1,NBCMP,PGL,VALED,VALER)
               ELSE
                  CALL UT2VGL(1,NBCMP,PGL,VALED,VALER)
               ENDIF
               DO 15 II=1,NBCMP
                  ZR(JCNSV-1+(INOE-1)*NBCMP+II) = VALER(II)
 15            CONTINUE
 13         CONTINUE
         ENDIF
      ELSE
C REPERE CYLINDRIQUE
         IF (NDIM.EQ.3) THEN
            CALL GETVR8('DEFI_REPERE','ORIGINE',1,1,3,ORIG,IBID)
            IF (IBID.NE.3) THEN
               CALL UTMESS('F','CHRPNO','L ORIGINE DOIT ETRE'//
     +                     ' DEFINIE PAR 3 COORDONNEES.')
            ENDIF
            CALL GETVR8('DEFI_REPERE','AXE_Z',1,1,3,AXEZ,IBID)
            IF (IBID.EQ.0) THEN
               CALL UTMESS('F','CHRPNO','L AXE Z EST OBLIGATOIRE'//
     +                     ' EN 3D.')
            ENDIF
         ELSE
            CALL GETVR8('DEFI_REPERE','ORIGINE',1,1,2,ORIG,IBID)
            IF (IBID.NE.2) THEN
               CALL UTMESS('A','CHRPNO','POUR LE 2D ON NE PREND'//
     +                     ' QUE 2 COORDONNEES POUR L ORIGINE.')
            ENDIF
            CALL GETVR8('DEFI_REPERE','AXE_Z',1,1,0,AXEZ,IBID)
            IF (IBID.NE.0) THEN
               CALL UTMESS('A','CHRPNO','L AXE Z EST N A PAS'//
     +                     ' DE SENS EN 2D.')
            ENDIF
            AXEZ(1) = 0.0D0
            AXEZ(2) = 0.0D0
            AXEZ(3) = 1.0D0
         ENDIF
         XNORMR = 0.0D0
         CALL NORMEV(AXEZ,XNORMR)
         CALL JEVEUO ( MA//'.COORDO    .VALE', 'L', AXYZM )
         IF (TYPE(1:4).EQ.'TENS') THEN
            IF (NDIM.EQ.2) THEN
               LICMPU(1)=1
               LICMPU(2)=2
               LICMPU(3)=3
               LICMPU(4)=5
            ENDIF
  
            DO 16 INO = 1 , NBNOEU
               IF (NBN.NE.0) THEN
                 INOE = ZI(IDNOEU+INO-1)
               ELSE
                 INOE = INO
               ENDIF
               AXER(1) = ZR(AXYZM+3*(INOE-1)  ) - ORIG(1)
               AXER(2) = ZR(AXYZM+3*(INOE-1)+1) - ORIG(2)
               IF (NDIM.EQ.3) THEN
                  AXER(3) = ZR(AXYZM+3*(INOE-1)+2) - ORIG(3)
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
                  CALL JENUNO(JEXNUM(MA//'.NOMNOE',INOE),K8B)
                  CALL UTMESS('A',K8B,'LE NOEUD SE TROUVE SUR L AXE'
     +            //' DU REPERE CYLINDRIQUE. ON PREND LE NOEUD'
     +            //' MOYEN DE L ELEMENT.')
                  CALL JEVEUO(MA//'.CONNEX','L',JCONX1)
                  CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',JCONX2)
                  IPT2=0
                  DO 17 INEL = 1,NBMA
                     NBPT = ZI(JCONX2-1+INEL+1)-ZI(JCONX2-1+INEL)
                     DO 18 IPT = 1, NBPT
                        INOT = ZI(JCONX1-1+ZI(JCONX2-1+INEL)+IPT-1)
                        IF (INOT.EQ.INOE) THEN
                           AXER(1) = 0.0D0
                           AXER(2) = 0.0D0
                           AXER(3) = 0.0D0
                           DO 19 IPT2 = 1,NBPT
                              INOT = ZI(JCONX1-1 +
     +                                ZI(JCONX2-1+INEL)+IPT2-1)
                              AXER(1) = AXER(1) + ZR(AXYZM+3*(INOT-1)  )
                              AXER(2) = AXER(2) + ZR(AXYZM+3*(INOT-1)+1)
                              IF (NDIM.EQ.3) THEN
                                 AXER(3) = AXER(3) +
     +                                     ZR(AXYZM+3*(INOT-1)+2)
                              ENDIF
 19                        CONTINUE
                           AXER(1) = AXER(1)/NBPT
                           AXER(2) = AXER(2)/NBPT
                           AXER(3) = AXER(3)/NBPT
                           GOTO 17
                        ENDIF
 18                  CONTINUE
 17               CONTINUE
 
C                LE NOEUD SUR L'AXE N'APPARTIENT A AUCUNE MAILLE
                  IF (IPT2.EQ.0) THEN
                     DO 117 II=1,NBCMP
                        ZL(JCNSL-1+(INOE-1)*NBCMP+II)=.FALSE.
117                  CONTINUE
                     GOTO 16
                  ENDIF
                  
                  AXER(1) = AXER(1) - ORIG(1)
                  AXER(2) = AXER(2) - ORIG(2)
                  AXER(3) = AXER(3) - ORIG(3)
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
                     CALL JENUNO(JEXNUM(MA//'.NOMNOE',INOE),K8B)
                     CALL UTDEBM('F','CHRPNO','NOEUD SUR L''AXE_Z')
                     CALL UTIMPK('L',' NOEUD : ',1,K8B)
                     CALL UTFINM()
                  ENDIF
               ENDIF
               CALL PROVEC(AXEZ,AXER,AXET)
               XNORMR = 0.0D0
               CALL NORMEV(AXET,XNORMR)
               DO 20 I = 1,3
                  PGL(1,I) = AXER(I)
                  PGL(2,I) = AXEZ(I)
                  PGL(3,I) = AXET(I)
 20            CONTINUE
               IF (.NOT.ZL(JCNSL-1+(INOE-1)*NBCMP+1)) GOTO 16
               DO 21 II=1,NBCMP
                  VALET(II)=ZR(JCNSV-1+(INOE-1)*NBCMP+II)
 21            CONTINUE
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
               DO 22 II=1,NBCMP
                  ZR(JCNSV-1+(INOE-1)*NBCMP+II)=VALER(LICMPU(II))
 22            CONTINUE
 16         CONTINUE
         ELSE
C VECTEUR
            IF (NDIM.EQ.2) THEN
               LICMPU(1)=1
               LICMPU(2)=3
               LICMPU(3)=2
            ENDIF

              DO 23 INO = 1 , NBNOEU
               IF (NBN.NE.0) THEN
                 INOE = ZI(IDNOEU+INO-1)
               ELSE
                 INOE = INO
               ENDIF
               AXER(1) = ZR(AXYZM+3*(INOE-1)  ) - ORIG(1)
               AXER(2) = ZR(AXYZM+3*(INOE-1)+1) - ORIG(2)
               IF (NDIM.EQ.3) THEN
                  AXER(3) = ZR(AXYZM+3*(INOE-1)+2) - ORIG(3)
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
                  CALL JENUNO(JEXNUM(MA//'.NOMNOE',INOE),K8B)
                  CALL UTMESS('A',K8B,'LE NOEUD SE TROUVE SUR L AXE'
     +            //' DU REPERE CYLINDRIQUE. ON PREND LE NOEUD'
     +            //' MOYEN DE L ELEMENT.')
                  CALL JEVEUO(MA//'.CONNEX','L',JCONX1)
                  CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',JCONX2)
                  IPT2=0
                  DO 24 INEL = 1,NBMA
                     NBPT = ZI(JCONX2-1+INEL+1)-ZI(JCONX2-1+INEL)
                     DO 25 IPT = 1, NBPT
                        INOT = ZI(JCONX1-1+ZI(JCONX2-1+INEL)+IPT-1)
                        IF (INOT.EQ.INOE) THEN
                           AXER(1) = 0.0D0
                           AXER(2) = 0.0D0
                           AXER(3) = 0.0D0
                           DO 26 IPT2 = 1,NBPT
                              INOT = ZI(JCONX1-1 +
     +                               ZI(JCONX2-1+INEL)+IPT2-1)
                              AXER(1) = AXER(1) + ZR(AXYZM+3*(INOT-1)  )
                              AXER(2) = AXER(2) + ZR(AXYZM+3*(INOT-1)+1)
                              IF (NDIM.EQ.3) THEN
                                 AXER(3) = AXER(3) +
     +                                     ZR(AXYZM+3*(INOT-1)+2)
                              ENDIF
 26                        CONTINUE
                           AXER(1) = AXER(1)/NBPT
                           AXER(2) = AXER(2)/NBPT
                           AXER(3) = AXER(3)/NBPT
                           GOTO 24
                        ENDIF
 25                  CONTINUE
 24               CONTINUE
C                LE NOEUD SUR L'AXE N'APPARTIENT A AUCUNE MAILLE
                  IF (IPT2.EQ.0) THEN
                     DO 124 II=1,NBCMP
                        ZL(JCNSL-1+(INOE-1)*NBCMP+II)=.FALSE.
124                  CONTINUE
                     GOTO 23
                  ENDIF
                  AXER(1) = AXER(1) - ORIG(1)
                  AXER(2) = AXER(2) - ORIG(2)
                  AXER(3) = AXER(3) - ORIG(3)
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
                     CALL JENUNO(JEXNUM(MA//'.NOMNOE',INOE),K8B)
                     CALL UTDEBM('F','CHRPNO','NOEUD SUR L''AXE_Z')
                     CALL UTIMPK('L',' NOEUD : ',1,K8B)
                     CALL UTFINM()
                  ENDIF
               ENDIF
               CALL PROVEC(AXEZ,AXER,AXET)
               DO 27 I = 1,3
                  PGL(1,I) = AXER(I)
                  PGL(2,I) = AXEZ(I)
                  PGL(3,I) = AXET(I)
 27            CONTINUE
               IF (.NOT.ZL(JCNSL-1+(INOE-1)*NBCMP+1)) GOTO 23
               DO 28 II=1,NBCMP
                  VALED(II)=ZR(JCNSV-1+(INOE-1)*NBCMP+II)
 28            CONTINUE
               IF (NDIM.EQ.3) THEN
                  CALL UTPVGL(1,NBCMP,PGL,VALED,VALER)
               ELSE
                  CALL UT2VGL(1,NBCMP,PGL,VALED,VALER)
               ENDIF
               DO 29 II=1,NBCMP
                  ZR(JCNSV-1+(INOE-1)*NBCMP+II)=VALER(LICMPU(II))
 29            CONTINUE
 23         CONTINUE
         ENDIF
      ENDIF
      CALL CNSCNO(CHAMS1,' ','G',CHAMP1)
      CALL DETRSD('CHAM_NO_S',CHAMS1)
      CALL JEDETR('&&CHRPNO.NOM_CMP')
      CALL JEDETR(MESNOE)
 9999 CONTINUE
      CALL JEDEMA( )
C
      END
