      SUBROUTINE DYARC0 ( RESUZ,NBNOSY,NBARCH,LISARC,NBCHEX,LICHEX )
      IMPLICIT   NONE
      INTEGER             NBARCH, NBCHEX, NBNOSY
      CHARACTER*(*)       RESUZ, LISARC, LICHEX
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/03/2002   AUTEUR CIBHHLV L.VIVAN 
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
C ----------------------------------------------------------------------
C     COMMANDE EXTR_RESU :
C        SAISIE DU MOT CLE FACTEUR "ARCHIVAGE"
C
C IN  : RESU   : NOM DE LA SD RESULTAT A EXTRAIRE
C IN  : NBNOSY : NOMBRE DE NOMS SYMBOLIQUES DANS LA SD
C OUT : NBARCH : NOMBRE DE NUMEROS D'ORDRE A ARCHIVER
C OUT : LISARC : NUMEROS D'ORDRE A ARCHIVER
C OUT : NBCHEX : NOMBRE DE NOMS DES CHAMPS EXCLUS
C OUT : LICHEX : NOMS DES CHAMPS EXCLUS
C ----------------------------------------------------------------------
C     --- DEBUT DECLARATIONS NORMALISEES JEVEUX ------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM
C     --- FIN DECLARATIONS NORMALISEES JEVEUX --------------------------
      INTEGER      IBID, JARCH, JCHEX, N1, NBOCC, JNUM, LNUM, K, IER,
     +             IPACH, KARCH, JORDR, NBTROU, NBORDR, IOCC, N2,NBCHAM,
     +             JCHAM, I, J, IRET, IFLAG, JTRAV, IRANG
      REAL*8       R8B, PREC
      COMPLEX*16   C16B
      CHARACTER*8  K8B, CRIT
      CHARACTER*16 MOTCLE, NOMSYM
      CHARACTER*19 NUMARC, KNUM, RESU
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      MOTCLE = 'ARCHIVAGE'
      LICHEX = '&&OP0176.LISTE.CHAM'      
      IOCC = 1
      RESU = RESUZ
      CALL RSORAC ( RESU, 'LONUTI', IBID, R8B, K8B, C16B, R8B, K8B,
     +                                               NBORDR, 1, IBID )
C
      NBCHEX = 0
      CALL WKVECT ( LISARC, 'V V I', NBORDR, JARCH )
C
C     --- LES CHAMPS EN SORTIE ---
C
      CALL GETVTX ( MOTCLE, 'CHAM_EXCLU' , IOCC,1,0, K8B, N1 )
C
      IF ( N1 .NE. 0 ) THEN
         NBCHEX = -N1
         CALL WKVECT ( LICHEX, 'V V K16', NBCHEX, JCHEX )
         CALL GETVTX ( MOTCLE, 'CHAM_EXCLU',
     +                                 IOCC,1,NBCHEX, ZK16(JCHEX), N1 )
      ELSE
         CALL WKVECT ( LICHEX, 'V V K16', 1, JCHEX )
      ENDIF
C
C
      CALL GETVTX ( MOTCLE, 'NOM_CHAM' , IOCC,1,0, K8B, N2 )
C     
C --- ON REGENERE UNE LISTE DE CHAMPS EXCLUS A PARTIR DES CHAMPS
C --- A GARDER
C
C      
      IF (N2 .NE. 0) THEN
        NBCHAM = -N2        
        NBCHEX = NBNOSY - NBCHAM
C
        CALL JEEXIN( LICHEX,IRET )
        IF (IRET .NE. 0) CALL JEDETR( LICHEX )
C        
        CALL WKVECT ( LICHEX, 'V V K16', NBCHEX, JCHEX ) 
        CALL WKVECT ( '&&DYARC0.TRAV1', 'V V K16', NBCHAM, JTRAV ) 
        CALL GETVTX ( MOTCLE,'NOM_CHAM',IOCC,1,NBCHAM,ZK16(JTRAV),
     +                IBID )
C
C ---   ON TESTE SI LES NOM_CHAM EXISTENT DANS LA SD
C ---
        DO 70 I = 1,NBCHAM  
          IFLAG = 0       
          DO 80 J = 1,NBNOSY 
            CALL JENUNO(JEXNUM(RESU//'.DESC',J),NOMSYM)
            IF (ZK16(JTRAV +I-1) .EQ. NOMSYM ) THEN
              IFLAG = 1
              GO TO 70  
            ENDIF
 80       CONTINUE        
          IF (IFLAG .EQ. 0) THEN
             CALL UTMESS('F','OP0176-DYARC0','LE NOM_CHAM '//
     +            ZK16(JTRAV+I-1)//'N''APPARTIENT PAS A LA SD' )
          ENDIF 
 70     CONTINUE 
C    
        K = 1
        DO 50 I = 1 , NBNOSY
          CALL JENUNO(JEXNUM(RESU//'.DESC',I),NOMSYM)        
          DO 60 J = 1,NBCHAM                 
            IF (NOMSYM .EQ. ZK16(JTRAV +J-1) ) THEN
              GOTO 50
            ENDIF   
  60      CONTINUE  
          ZK16( JCHEX+K-1 )= NOMSYM
          K = K + 1 
  50    CONTINUE                      
      ENDIF     
C      
C
      CALL GETFAC ( MOTCLE , NBOCC )
      IF ( NBOCC .EQ. 0 ) GOTO 9999
C
C     --- LES NUMEROS D'ORDRE EN SORTIE ---
C
      CALL GETVID ( MOTCLE, 'LIST_ARCH', IOCC,1,1, NUMARC, N1 )
      IF ( N1 .NE. 0 ) THEN
         CALL JEVEUO ( NUMARC//'.VALE', 'L', JNUM )
         CALL JELIRA ( NUMARC//'.VALE', 'LONUTI', LNUM, K8B )
         DO 10 K = 1 , LNUM
            KARCH = ZI(JNUM+K-1)
            IF ( KARCH .LE. 0 ) THEN
               GOTO 10
            ELSEIF ( KARCH .GT. NBORDR ) THEN
               GOTO 12
            ELSE
               ZI(JARCH+KARCH-1) = 1
            ENDIF
 10      CONTINUE
 12      CONTINUE
         GOTO 9999
      ENDIF
C
      CALL GETVIS ( MOTCLE, 'PAS_ARCH', IOCC,1,1, IPACH, N1 )
      IF ( N1 .NE. 0 ) THEN
         IPACH = 1
         DO 20 K = IPACH , NBORDR , IPACH
            ZI(JARCH+K-1) = 1
 20      CONTINUE
         GOTO 9999
      ENDIF
C
      CALL GETVTX ( MOTCLE, 'CRITERE'  , IOCC,1,1, CRIT, N1 )
      CALL GETVR8 ( MOTCLE, 'PRECISION', IOCC,1,1, PREC, N1 )
      KNUM = '&&DYARC0.NUME_ORDRE'
      CALL RSUTNU ( RESU, MOTCLE, IOCC, KNUM, NBTROU, PREC, CRIT, IER )
      IF ( IER .NE. 0 ) THEN
         CALL UTMESS ( 'F', 'DYARC0', 'ERREUR(S) DANS LES DONNEES' )
      ENDIF
      CALL JEVEUO ( KNUM, 'L', JORDR )
      DO 30 K = 1 , NBTROU
         KARCH = ZI(JORDR+K-1)
         CALL RSUTRG ( RESU, KARCH, IRANG )
         ZI(JARCH+IRANG-1) = 1
 30   CONTINUE
      CALL JEDETR ( KNUM )
C
 9999 CONTINUE
C
      NBARCH = 0
      DO 40 K = 1 , NBORDR
         NBARCH = NBARCH + ZI(JARCH+K-1)
 40   CONTINUE
C
      CALL JEDETR('&&DYARC0.TRAV1')
C      
      CALL JEDEMA()
C
      END
