      SUBROUTINE COCALI (LIS1Z, LIS2Z, TYPZ)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)      LIS1Z, LIS2Z, TYPZ
C ---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 20/04/99   AUTEUR CIBHHGB G.BERTRAND 
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
C
C     BUT :  CONCATENATION DES LISTES DE K8 LIS1 ET LIS2
C            ON AFFECTE TOUS LES ELEMENTS DE LA LISTE LIS2
C            A LA LISTE LIS1 APRES LE DERNIER ELEMENT DE LA LISTE
C            LIS1
C            SI LIS1 N'EXISTE PAS , ON LA CREE ET ON LUI AFFECTE
C            LA LONGUEUR ET LES ELEMENTS DE LIS2
C            SI LIS2 N'EXISTE PAS ON SORT EN ERREUR FATALE
C
C IN/OUT  LIS1   K24  : NOM DE LA LISTE A ENRICHIR
C IN      LIS2   K24  : NOM DE LA LISTE QUE L'ON CONCATENE A LA
C                       LISTE LIS1
C IN      TYPE   K1   : TYPE DE LA LISTE, POUR L'INSTANT SONT PREVUES
C                        'I'   LISTE D'ENTIERS
C                        'R'   LISTE DE REELS
C                        'K8'  LISTE DE K8
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
C
      CHARACTER*1        K1BID
      CHARACTER*2        TYPE
      CHARACTER*24       LIS1, LIS2
C
      CALL JEMARQ()
      LIS1   = LIS1Z
      LIS2   = LIS2Z
      TYPE   = TYPZ
C
      CALL JEEXIN(LIS2, IRET)
      IF (IRET.EQ.0) THEN
          CALL UTMESS('F','COCALI',' LA LISTE :'//LIS2//
     +                ' A CONCATENER AVEC LA LISTE '//LIS1//
     +                ' DOIT EXISTER ')
      ELSE
          CALL JEVEUO(LIS2, 'L', IDLIS2)
          CALL JELIRA(LIS2, 'LONMAX', LONLI2, K1BID)
      ENDIF
C
      CALL JEEXIN(LIS1, IRET)
      IF (IRET.EQ.0) THEN
         IF (LONLI2.EQ.0) THEN
             CALL UTMESS('F','COCALI',' ON NE PEUT PAS AFFECTER '
     +                 //'LA LISTE DE LONGUEUR NULLE'//LIS2//
     +                ' A LA LISTE '//LIS1//' QUI N''EXISTE PAS')
         ELSE
           IF (TYPE.EQ.'K8') THEN
             CALL WKVECT(LIS1, 'V V K8', LONLI2, IDLIS1)
             LONLI1 = 0
           ELSEIF (TYPE(1:1).EQ.'R') THEN
             CALL WKVECT(LIS1, 'V V R', LONLI2, IDLIS1)
             LONLI1 = 0
           ELSEIF (TYPE(1:1).EQ.'I') THEN
             CALL WKVECT(LIS1, 'V V I', LONLI2, IDLIS1)
             LONLI1 = 0
           ELSE
             CALL UTMESS('F','COCALI','LA CONCATENATION DE LISTES '//
     +              'DE TYPE '//TYPE//' N''EST PAS ENCORE PREVUE.')
           ENDIF
C
         ENDIF
      ELSE
         CALL JEVEUO(LIS1, 'E', IDLIS1)
         CALL JELIRA(LIS1, 'LONMAX', LONLI1, K1BID)
         CALL JUVECA(LIS1, LONLI1+LONLI2)
         CALL JEVEUO(LIS1,'E', IDLIS1)
      ENDIF
C
      IF (TYPE.EQ.'K8') THEN
        DO 10 I = 1, LONLI2
            ZK8(IDLIS1+LONLI1+I-1) = ZK8(IDLIS2+I-1)
  10    CONTINUE
      ELSEIF (TYPE(1:1).EQ.'R') THEN
        DO 20 I = 1, LONLI2
            ZR(IDLIS1+LONLI1+I-1) = ZR(IDLIS2+I-1)
  20    CONTINUE
      ELSEIF (TYPE(1:1).EQ.'I') THEN
        DO 30 I = 1, LONLI2
            ZI(IDLIS1+LONLI1+I-1) = ZI(IDLIS2+I-1)
  30    CONTINUE
      ELSE
        CALL UTMESS('F','COCALI','LA CONCATENATION DE LISTES '//
     +              'DE TYPE '//TYPE//' N''EST PAS ENCORE PREVUE.')
      ENDIF
C
C FIN -----------------------------------------------------------------
      CALL JEDEMA()
      END
