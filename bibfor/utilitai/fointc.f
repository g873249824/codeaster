      SUBROUTINE FOINTC ( NOMF, NBPU, NOMPU, VALPU, RESURE, RESUIM, IER)
      IMPLICIT  NONE
      INTEGER             NBPU, IER
      REAL*8              VALPU(*), RESURE, RESUIM
      CHARACTER*(*)       NOMF,       NOMPU(*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 23/08/2004   AUTEUR CIBHHLV L.VIVAN 
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
C     INTERPOLATION POUR FONCTION COMPLEXE A VARIABLE REELLE
C
C     CETTE ROUTINE EST DUPLIQUEE,AVEC QUELQUES LIGNES EN MOINS
C     DANS FITABU. VEILLER A GARDER LA CONCORDANCE EN CAS DE
C     MODIFICATION.
C     ------------------------------------------------------------------
C IN  NOMF   : NOM DE LA FONCTION OU DE LA NAPPE
C IN  NBPU   : NOMBRE DE PARAMETRES DANS NOMPU ET VALPU
C IN  NOMPU  : NOMS DES PARAMETRES "UTILISATEUR"
C IN  VALPU  : VALEURS DES PARAMETRES "UTILISATEUR"
C OUT RESURE : RESULTAT DE L'INTERPOLATION (PARTIE REELLE)
C OUT RESUIM : RESULTAT DE L'INTERPOLATION (PARTIE IMAGINAIRE)
C OUT IER    : CODE RETOUR
C     ------------------------------------------------------------------
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER       ZI
      COMMON/IVARJE/ZI(1)
      REAL*8        ZR
      COMMON/RVARJE/ZR(1)
      COMPLEX*16    ZC
      COMMON/CVARJE/ZC(1)
      LOGICAL       ZL
      COMMON/LVARJE/ZL(1)
      CHARACTER*8   ZK8
      CHARACTER*16         ZK16
      CHARACTER*24                 ZK24
      CHARACTER*32                         ZK32
      CHARACTER*80                                 ZK80
      COMMON/KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      INTEGER      LPROL, NUPAR, MXPARA, NBPF, I, I1, I2, LVALE,
     +             LFONC, NBVALE
      REAL*8       LINLIN, LINLOG, LOGLOG, LOGLIN, X, X1, Y1, X2, Y2
      REAL*8       RESU(2), EPSI, TOLE, R8PREM, R8VIDE, VALR
      CHARACTER*1  COLI, K1BID, BL
      CHARACTER*16 INTERP, PROLGD
      CHARACTER*19 NOMFON
      CHARACTER*24 CHPROL, CHVALE
C     ------------------------------------------------------------------
      INTEGER      IPAR(10)
      CHARACTER*16 NOMP(10)
C     ------------------------------------------------------------------
      INTEGER      MXSAVE
      PARAMETER   (MXSAVE=4)
      INTEGER      ISVNXT,NEXTSV(MXSAVE),ISVIND,ISAVE
      CHARACTER*2  SVPRGD(MXSAVE)
      CHARACTER*16 SVINTE(MXSAVE)
      CHARACTER*19 SVNOMF(MXSAVE)
      SAVE         SVNOMF,SVPRGD,SVINTE
      SAVE         ISVNXT,ISVIND
      DATA         SVNOMF/MXSAVE*'????????'/
      DATA         ISVNXT/MXSAVE/
      DATA         NEXTSV/2,3,4,1/,ISVIND/1/
C     ------------------------------------------------------------------
C     FONCTION EN LIGNE
C
      LINLIN(X,X1,Y1,X2,Y2)= Y1+(X-X1)*(Y2-Y1)/(X2-X1)
      LINLOG(X,X1,Y1,X2,Y2)=EXP(LOG(Y1)+(X-X1)*(LOG(Y2)-LOG(Y1))
     +                                        /(X2-X1))
      LOGLOG(X,X1,Y1,X2,Y2)=EXP(LOG(Y1)+(LOG(X)-LOG(X1))*(LOG(Y2)
     +                                     -LOG(Y1))/(LOG(X2)-LOG(X1)))
      LOGLIN(X,X1,Y1,X2,Y2)=Y1+(LOG(X)-LOG(X1))*(Y2-Y1)
     +                                         /(LOG(X2)-LOG(X1))
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      IER    = 0
      EPSI   = SQRT ( R8PREM() )
      RESURE = R8VIDE()
      RESUIM = R8VIDE()
      NOMFON = NOMF
      CHPROL = NOMFON//'.PROL'
      CHVALE = NOMFON//'.VALE'
      CALL JEVEUO ( CHPROL, 'L', LPROL )
C
C --- CALCUL DE LA FONCTION INTERPRETEE ---
C
      IF ( ZK16(LPROL) .EQ. 'INTERPRE' ) THEN
         CALL FONBPA ( NOMFON, ZK16(LPROL), K1BID, MXPARA, NBPF, NOMP )
         DO 70 I1 = 1,NBPF
            IPAR(I1) = 0
            DO 72 NUPAR = 1,NBPU
               IF (NOMPU(NUPAR).EQ.NOMP(I1)) THEN
                  IF (IPAR(I1).EQ.0) THEN
                     IPAR(I1) = NUPAR
                  ELSE
                     IER = 120
                   CALL UTDEBM('F','FOINTC','ERREUR A L''INTERPOLATION')
                     CALL UTIMPK('S',' FONCTION ',1,NOMFON)
                     CALL UTIMPK('L',' PARAMETRE ',NBPU,NOMPU)
                     CALL UTIMPK('S',' EN DOUBLE',0,BL)
                     CALL UTFINM()
                     GOTO 9999
                  ENDIF
               ENDIF
 72         CONTINUE
            IF (IPAR(I1).EQ.0) THEN
               IER = 130
               CALL UTDEBM('F','FOINTC','ERREUR A L''INTERPOLATION')
               CALL UTIMPK('S',' FONCTION ',1,NOMFON)
               CALL UTIMPK('L',' PARAMETRES ATTENDUS ',NBPF,NOMP)
               CALL UTIMPK('L',' PARAMETRES RECUS    ',NBPU,NOMPU)
               CALL UTFINM()
               GOTO 9999
            ENDIF
 70      CONTINUE
         CALL FIINTC ( 'F', NOMF, NBPF, IPAR, VALPU, RESU, IER )
         RESURE = RESU(1)
         RESUIM = RESU(2)
C
         GOTO 9999
C
      ENDIF
C
C --- LES AUTRES TYPES DE FONCTION ---
C
      VALR = VALPU(1)
C
      DO 10 I = 1, MXSAVE
        IF ( NOMFON .EQ. SVNOMF(I) ) THEN
          ISAVE = I
          GOTO 11
        ENDIF
   10 CONTINUE
C
C --- MEMORISATION DES INFORMATIONS NOUVELLES
C
      ISVNXT = NEXTSV(ISVNXT)
      ISAVE  = ISVNXT
      CALL JEVEUO(CHPROL,'L',LPROL)
      SVINTE(ISAVE) = ZK16(LPROL+1)
      SVPRGD(ISAVE) = ZK16(LPROL+4)
C
   11 CONTINUE
      INTERP   = SVINTE(ISAVE)
      PROLGD   = SVPRGD(ISAVE)
C
      CALL JEVEUO(CHVALE,'L',LVALE)
      CALL JELIRA(CHVALE,'LONUTI',NBVALE,K1BID)
      NBVALE = NBVALE / 3
      LFONC = LVALE + NBVALE - 1
C
      I = ISVIND
      CALL FOLOCX(ZR(LVALE),NBVALE,VALR,PROLGD,I,EPSI,COLI,IER)
      IF (IER.NE.0) GOTO 9999
C
      IF (COLI.EQ.'C') THEN
         I1 = 1 + 2 * ( I - 1 )
         RESURE = ZR(LFONC+I1)
         RESUIM = ZR(LFONC+I1+1)
C
      ELSE IF (COLI.EQ.'I') THEN
        IF (INTERP(1:3).EQ.'NON') THEN
          I1 = 1 + 2 * ( I - 1 )
          I2 = 1 + 2 * I
          TOLE = EPSI * ABS( ZR(LVALE+I-1) - ZR(LVALE+I) )
          IF ( ABS(ZR(LVALE+I-1)-VALR) .LE. TOLE ) THEN
            RESURE = ZR(LFONC+I1)
            RESUIM = ZR(LFONC+I1+1)
          ELSEIF ( ABS(ZR(LVALE+I)-VALR) .LE. TOLE ) THEN
            RESURE = ZR(LFONC+I2)
            RESUIM = ZR(LFONC+I2+1)
          ELSE
            IER = 200
            CALL UTMESS('A','FOINTC','INTERPOLATION NON PERMISE')
            GOTO 9999
          ENDIF
        ELSE IF (INTERP.EQ.'LIN LIN ') THEN
          I1 = 1 + 2 * ( I - 1 )
          I2 = 1 + 2 * I
          RESURE = LINLIN(VALR,ZR(LVALE+I-1),ZR(LFONC+I1),
     +                                      ZR(LVALE+I),ZR(LFONC+I2))
          RESUIM = LINLIN(VALR,ZR(LVALE+I-1),ZR(LFONC+I1+1),
     +                                    ZR(LVALE+I),ZR(LFONC+I2+1))
        ELSE IF (INTERP.EQ.'LIN LOG ') THEN
          I1 = 1 + 2 * ( I - 1 )
          I2 = 1 + 2 * I
          RESURE = LINLOG(VALR,ZR(LVALE+I-1),ZR(LFONC+I1),
     +                                      ZR(LVALE+I),ZR(LFONC+I2))
          RESUIM = LINLOG(VALR,ZR(LVALE+I-1),ZR(LFONC+I1+1),
     +                                    ZR(LVALE+I),ZR(LFONC+I2+1))
        ELSE IF (INTERP.EQ.'LOG LOG ') THEN
          I1 = 1 + 2 * ( I - 1 )
          I2 = 1 + 2 * I
          RESURE = LOGLOG(VALR,ZR(LVALE+I-1),ZR(LFONC+I1),
     +                                      ZR(LVALE+I),ZR(LFONC+I2))
          RESUIM = LOGLOG(VALR,ZR(LVALE+I-1),ZR(LFONC+I1+1),
     +                                    ZR(LVALE+I),ZR(LFONC+I2+1))
        ELSE IF (INTERP.EQ.'LOG LIN ') THEN
          I1 = 1 + 2 * ( I - 1 )
          I2 = 1 + 2 * I
          RESURE = LOGLIN(VALR,ZR(LVALE+I-1),ZR(LFONC+I1),
     +                                      ZR(LVALE+I),ZR(LFONC+I2))
          RESUIM = LOGLIN(VALR,ZR(LVALE+I-1),ZR(LFONC+I1+1),
     +                                    ZR(LVALE+I),ZR(LFONC+I2+1))
        ELSE
          IER = 230
          CALL UTMESS('A','FOINTC','ON NE CONNAIT PAS CE'//
     +                             ' TYPE D''INTERPOLATION: '//INTERP)
          GOTO 9999
        ENDIF
C
      ELSE IF (COLI.EQ.'E') THEN
        I1 = 1 + 2 * ( I - 1 )
        I2 = 1 + 2 * I
        RESURE = LINLIN(VALR,ZR(LVALE+I-1),ZR(LFONC+I1),
     +                                       ZR(LVALE+I),ZR(LFONC+I2))
        RESUIM = LINLIN(VALR,ZR(LVALE+I-1),ZR(LFONC+I1+1),
     +                                     ZR(LVALE+I),ZR(LFONC+I2+1))
C
      ELSE
        IER = 240
        CALL UTMESS('A','FOINTC','TYPE INCONNU '//COLI)
      ENDIF
C
9999  CONTINUE
      CALL JEDEMA()
      END
