      SUBROUTINE ASEXCI (MASSE,PARMOD,AMORT,NBMODE,CORFRE,IMPR, NDIR,
     +                   MONOAP, KSPECT, KASYSP,
     +                   NBSUP,NSUPP, KNOEU )
      IMPLICIT  REAL*8  (A-H,O-Z)
      INTEGER            NDIR(*), NSUPP(*)
      REAL*8             PARMOD(NBMODE,*), AMORT(*)
      CHARACTER*(*)      MASSE, KSPECT, KASYSP, KNOEU
      LOGICAL            MONOAP, CORFRE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/06/2000   AUTEUR ACBHHCD G.DEVESA 
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
C     ------------------------------------------------------------------
C     COMMANDE : COMB_SISM_MODAL
C                TRAITEMENT DU MOT-CLE "EXCIT"
C                INTERPOLATION DES SPECTRES
C                CALCUL DES ASYMPTOTES DES SPECTRES
C     ------------------------------------------------------------------
C IN  : MASSE  : MATRICE DE MASSE ASSEMBLEE
C IN  : PARMOD : VECTEUR DES PARAMETRES MODAUX
C IN  : AMORT  : VECTEUR DES AMORTISSEMENTS MODAUX
C IN  : NBMODE : NOMBRE DE MODES
C IN  : CORFRE : = .TRUE.  , CORRECTION FREQUENCE
C IN  : IMPR   : NIVEAU D'IMPRESSION
C OUT : NDIR   : VECTEUR DES DIRECTIONS
C OUT : MONOAP : = .TRUE.  , STRUCTURE MONO-APPUI
C                = .FALSE. , STRUCTURE MULTI-APPUI
C IN  : KSPECT : NOM DU VECTEUR DES INTERPOLATIONS SPECTRALES
C IN  : KASYSP : NOM DU VECTEUR DES VALEURS ASYMPTOTIQUES DES SPECTRES
C OUT : NBSUP  : SUP DES NOMBRES DE SUPPORTS PAR DIRECTION
C OUT : NSUPP  : NOMBRE DE SUPPORTS PAR DIRECTION
C IN  : KNOEU  : NOM DU VECTEUR DES NOMS DES SUPPORTS
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16               ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                 ZK32
      CHARACTER*80                                          ZK80
      COMMON  / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*5  MOTFAC
      CHARACTER*8  K8B, NOMA
      CHARACTER*14 NUME
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      IER = 0
      MONOAP = .FALSE.
      MOTFAC = 'EXCIT'
      CALL GETFAC(MOTFAC,NBOCC)
C
C     --- EST-ON EN MONO-APPUI OU MULTI-APPUI ? ---
      DO 10 IOC = 1,NBOCC
C
         CALL GETVTX(MOTFAC,'MONO_APPUI',IOC,1,0,K8B,NM)
         IF (NM.NE.0) MONOAP = .TRUE.
C
         CALL GETVID(MOTFAC,'NOEUD',IOC,1,0,K8B,NN)
         IF ( NN.NE.0 .AND. MONOAP ) THEN
            IER = IER + 1
            CALL UTMESS('E',MOTFAC,'ON NE PEUT PAS TRAITER DU MONO-'//
     +                        'APPUI ET DU MULTI-APPUI SIMULTANEMENT.')
         ENDIF
C
         CALL GETVID(MOTFAC,'GROUP_NO',IOC,1,0,K8B,NG)
         IF ( NG.NE.0 .AND. MONOAP ) THEN
            IER = IER + 1
            CALL UTMESS('E',MOTFAC,'ON NE PEUT PAS TRAITER DU MONO-'//
     +                        'APPUI ET DU MULTI-APPUI SIMULTANEMENT.')
         ENDIF
 10   CONTINUE
C
      IF (IER.NE.0) THEN
         CALL UTMESS('F',MOTFAC,' ERREUR(S) RENCONTREE(S) LORS DE LA '//
     +                                          'LECTURE DES SUPPORTS.')
      ENDIF
C
      IF ( MONOAP ) THEN
         NBSUP = 1
         CALL WKVECT( KSPECT ,'V V R' ,NBMODE*3,JSPE)
         CALL WKVECT( KASYSP ,'V V R' ,3       ,JASY)
         CALL ASEXC1( MOTFAC, NBOCC, NBMODE, PARMOD, AMORT, CORFRE,
     +                IMPR, NDIR, ZR(JSPE), ZR(JASY) )
      ELSE
         CALL DISMOI('F','NOM_NUME_DDL',MASSE,'MATR_ASSE',IBID,NUME,IE)
         CALL DISMOI('F','NOM_MAILLA'  ,MASSE,'MATR_ASSE',IBID,NOMA,IE)
         CALL DISMOI('F','NB_EQUA'     ,MASSE,'MATR_ASSE',NEQ ,K8B ,IE)
         CALL WKVECT('&&ASEXCI.POSITION.DDL1','V V I',NEQ,JDDL1)
         CALL TYPDDL('BLOQ',NUME,NEQ,ZI(JDDL1),NBA,NBBLOQ,NBL,NBLIAI)
         CALL WKVECT('&&ASEXCI.NOM_NOEUD'  ,'V V K8',3*NBBLOQ,JNNO)
         CALL WKVECT('&&ASEXCI.NOM_SPECTRE','V V K8',3*NBBLOQ,JNSP)
         CALL WKVECT('&&ASEXCI.DIR_SPECTRE','V V R' ,3*NBBLOQ,JDSP)
         CALL WKVECT('&&ASEXCI.ECH_SPECTRE','V V R' ,3*NBBLOQ,JESP)
         CALL WKVECT('&&ASEXCI.NAT_SPECTRE','V V I' ,3*NBBLOQ,JNAS)
         CALL ASEXC2(MOTFAC,NBOCC,NBMODE,PARMOD,AMORT,CORFRE,NOMA,
     +               IMPR,NDIR,ZK8(JNNO),ZK8(JNSP),ZR(JDSP),ZR(JESP),
     +               ZI(JNAS), NBSUP,NSUPP, KNOEU,KSPECT, KASYSP )
         CALL JEDETR('&&ASEXCI.POSITION.DDL1')
         CALL JEDETR('&&ASEXCI.NOM_NOEUD'    )
         CALL JEDETR('&&ASEXCI.NOM_SPECTRE'  )
         CALL JEDETR('&&ASEXCI.DIR_SPECTRE'  )
         CALL JEDETR('&&ASEXCI.ECH_SPECTRE'  )
         CALL JEDETR('&&ASEXCI.NAT_SPECTRE'  )
      ENDIF
C
      CALL JEDEMA()
      END
