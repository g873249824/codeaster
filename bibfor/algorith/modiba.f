      SUBROUTINE MODIBA ( NOMRES,BASEMO,BASEFL,NUMVIT,NEWRES,ITYPFL,
     &                    IMASSE,NUOR,NBNUOR,NUMO,NBMFL)
      IMPLICIT NONE
      INTEGER             NUMVIT, ITYPFL, IMASSE
      INTEGER             NBNUOR, NUOR(*), NBMFL, NUMO(*)
      CHARACTER*8         NOMRES, BASEMO
      CHARACTER*19        BASEFL
      LOGICAL             NEWRES
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/06/2005   AUTEUR NICOLAS O.NICOLAS 
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
C     MODIFICATION D'UNE BASE MODALE DE TYPE MODE_MECA APRES UN CALCUL
C     DE COUPLAGE FLUIDE-STRUCTURE
C     APPELANT : OP0149, MODI_BASE_MODALE
C ----------------------------------------------------------------------
C IN  : NOMRES : NOM DU CONCEPT MODE_MECA DE SORTIE
C IN  : BASEMO : NOM DU CONCEPT MODE_MECA D'ENTREE
C IN  : BASEFL : NOM DU CONCEPT MELASFLU
C IN  : NUMVIT : NUMERO DE LA VITESSE DU FLUIDE POUR LAQUELLE ON RETIENT
C                LES NOUVELLES CARACTERISTIQUES MODALES
C IN  : NEWRES : INDICATEUR BOOLEEN
C       NEWRES = .TRUE.  CREATION D'UN NOUVEAU CONCEPT EN SORTIE
C                        => NOMRES <> BASEMO
C       NEWRES = .FALSE. MODIFICATION DU CONCEPT D'ENTREE
C                        => NOMRES =  BASEMO
C IN  : ITYPFL : INDICE CARACTERISTIQUE DE LA CONFIGURATION ETUDIEE
C       ITYPFL = 1  FAISCEAU_TRANS   ITYPFL = 2  GRAPPE
C       ITYPFL = 3  FAISCEAU_AXIAL   ITYPFL = 4  COQUE_COAX
C IN  : IMASSE : INDICE CARACTERISTIQUE LORSQUE ITYPFL = 4
C IN  : NUOR   : LISTE DES NUMEROS D'ORDRE DES MODES RETENUS POUR
C                RECONSTRUIRE LA BASE MODALE
C IN  : NBNUOR : NOMBRE DE MODES RETENUS POUR RECONSTRUIRE LA BASE
C IN  : NUMO   : LISTE DES NUMEROS D'ORDRE DES MODES PERTURBES PAR LE
C                COUPLAGE FLUIDE-STRUCTURE
C IN  : NBMFL  : NOMBRE DE MODES PERTURBES PAR LE COUPLAGE
C
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
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       IDDL(6), IFRFL, IMAFL, IFAFL, NEQ, NBMODE, J, I
      INTEGER       LMOD, IRET, IBID, IDEEQ, IVIT, NUMOD, IMAS
      INTEGER       IFAC, IFRE, IEQ, K, ICM, IPREC, IVALE, KREF, LREF
      INTEGER       LMAT(2), LDDL,  LVALI, LVALR, LVALK, LCOEF
      INTEGER       NPARI, NPARR, NPARK
      INTEGER       NBPARI, NBPARR, NBPARK, NBPARA
      PARAMETER    ( NBPARI=8 , NBPARR=16 , NBPARK=2, NBPARA=26 )
      REAL*8        FREQU, AMORT, OMEG2, MASG, RIGG, FREQOM
      REAL*8        FACTX, FACTY, FACTZ, DEPI, R8DEPI, XMASTR
      CHARACTER*1   TYPMOD
      CHARACTER*14  NUMDDL
      CHARACTER*16  NORM
      CHARACTER*19  NOMCHA
      CHARACTER*24  CHAMFL, KVEC, REFD, NOPARA(NBPARA)
      CHARACTER*24  KVALI, KVALR, KVALK
      LOGICAL       LMASIN, LNORM
C
      DATA REFD  / '                   .REFD' /
      DATA IDDL  / 1, 2, 3, 4, 5, 6 /
      DATA  NOPARA /
     +  'NUME_MODE'       , 'ITER_QR'         , 'ITER_BATHE'      ,
     +  'ITER_ARNO'       , 'ITER_JACOBI'     , 'ITER_SEPARE'     ,
     +  'ITER_AJUSTE'     , 'ITER_INVERSE'    ,
     +  'NORME'           , 'METHODE'         ,
     +  'FREQ'            , 
     +  'OMEGA2'          , 'AMOR_REDUIT'     , 'ERREUR'          ,
     +  'MASS_GENE'       , 'RIGI_GENE'       , 'AMOR_GENE'       ,
     +  'MASS_EFFE_DX'    , 'MASS_EFFE_DY'    , 'MASS_EFFE_DZ'    ,
     +  'FACT_PARTICI_DX' , 'FACT_PARTICI_DY' , 'FACT_PARTICI_DZ' ,
     +  'MASS_EFFE_UN_DX' , 'MASS_EFFE_UN_DY' , 'MASS_EFFE_UN_DZ' /
C
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      DEPI   = R8DEPI()
      LMAT(1) = 0
      LMAT(2) = 0
      LMASIN = .FALSE.
      LNORM  = .FALSE.
      XMASTR = 1.D0
C
C     --- CREATION DU CONCEPT MODE_MECA DE SORTIE LE CAS ECHEANT ---
C
      IF ( NEWRES ) THEN
         CALL RSCRSD(NOMRES,'MODE_MECA',NBNUOR)
         REFD(1:8) = BASEMO
         CALL JEVEUO ( REFD , 'L', KREF )
         REFD(1:8) = NOMRES
         CALL WKVECT ( REFD, 'G V K24', 6, LREF )
         ZK24(LREF  ) = ZK24(KREF  )
         ZK24(LREF+1) = ZK24(KREF+1)
         ZK24(LREF+2) = ZK24(KREF+2)
         ZK24(LREF+3) = ZK24(KREF+3)
         ZK24(LREF+4) = ZK24(KREF+4)
         ZK24(LREF+5) = ZK24(KREF+5)
      ENDIF
C
C     --- PARAMETRES SOUS ECOULEMENT ---
C
      CALL JEVEUO ( BASEFL//'.FREQ' , 'L' , IFRFL )
      CALL JEVEUO ( BASEFL//'.MASG' , 'L' , IMAFL )
      CALL JEVEUO ( BASEFL//'.FACT' , 'L' , IFAFL )
C
      TYPMOD = 'R'
      KVEC  = '&&MODIBA.VECT'
      KVALI = '&&MODIBA.PARA_I'
      KVALR = '&&MODIBA.PARA_R'
      KVALK = '&&MODIBA.PARA_K'
      CALL VPRECU ( BASEMO, 'DEPL', NBNUOR, NUOR, KVEC, 
     +              NBPARA, NOPARA, KVALI, KVALR, KVALK,
     +              NEQ, NBMODE, TYPMOD, NPARI, NPARR, NPARK )
      IF (NPARI.NE.NBPARI) CALL UTMESS('F','MODIBA','Y A UN BUG')
      IF (NPARR.NE.NBPARR) CALL UTMESS('F','MODIBA','Y A UN BUG')
      IF (NPARK.NE.NBPARK) CALL UTMESS('F','MODIBA','Y A UN BUG')
      CALL JEVEUO ( KVEC , 'E', LMOD )
      CALL JEVEUO ( KVALI, 'E', LVALI )
      CALL JEVEUO ( KVALR, 'E', LVALR )
      CALL JEVEUO ( KVALK, 'E', LVALK )
C
C     --- ON RECUPERE UN NUME_DDL ---
C
      CALL RSEXCH ( BASEMO,'DEPL',NUOR(1),NOMCHA,IRET)
      CALL DISMOI('F','NOM_NUME_DDL',NOMCHA,'CHAM_NO',IBID,NUMDDL,IRET)
      CALL JEVEUO ( NUMDDL//'.NUME.DEEQ', 'L', IDEEQ )
C
C     --- CAS DU COUPLAGE ---
C
      IVIT = 1
      IF (ITYPFL.EQ.3) IVIT = NUMVIT
      CHAMFL(1:13) = BASEFL(1:8)//'.C01.'
C
      DO 10 J = 1,NBMFL
        DO 20 I = 1,NBNUOR
          NUMOD = NUOR(I)
C
          IF ( NUMO(J) .EQ. NUMOD ) THEN
            IMAS  = NBMFL*(IVIT-1) + J
            IFAC  = NBMFL*(IVIT-1) + 3*(J-1)
            IFRE  = 2*NBMFL*(NUMVIT-1) + 2*(J-1)
            FREQU = ZR(IFRFL+IFRE)
            AMORT = ZR(IFRFL+IFRE+1)
            OMEG2 = ( DEPI * FREQU ) ** 2
            MASG  = ZR(IMAFL-1+IMAS)
            RIGG  = OMEG2 * MASG
            FACTX = ZR(IFAFL-1+IFAC+1)
            FACTY = ZR(IFAFL-1+IFAC+2)
            FACTZ = ZR(IFAFL-1+IFAC+3)
            IF (AMORT .LE. 0.D0) AMORT = 1.D-06
C
C           --- FREQUENCE ---
            ZR(LVALR+I-1) = FREQOM( OMEG2 )
C           --- OMEGA2 ---
            ZR(LVALR+NBNUOR+I-1) = OMEG2
C           --- AMOR_REDUIT ---
            ZR(LVALR+NBNUOR*2 +I-1) = AMORT
C           --- MASS_GENE , RIGI_GENE ---
            ZR(LVALR+NBNUOR*4 +I-1) = MASG
            ZR(LVALR+NBNUOR*5 +I-1) = RIGG
C           --- MASS_EFFE_D... ---
            ZR(LVALR+NBNUOR*( 6+1)+I-1) = FACTX * FACTX / MASG
            ZR(LVALR+NBNUOR*( 6+2)+I-1) = FACTY * FACTY / MASG
            ZR(LVALR+NBNUOR*( 6+3)+I-1) = FACTZ * FACTZ / MASG
C           --- FACT_PARTICI_D... ---
            ZR(LVALR+NBNUOR*(9+1)+I-1) = FACTX / MASG
            ZR(LVALR+NBNUOR*(9+2)+I-1) = FACTY / MASG
            ZR(LVALR+NBNUOR*(9+3)+I-1) = FACTZ / MASG
C
            IF ( ITYPFL.EQ.3  .OR.
     &          (ITYPFL.EQ.4 .AND. IMASSE.NE.0)  ) THEN
              LNORM  = .TRUE.
              ZK24(LVALK+I-1) = 'SANS_CMP: LAGR'
              WRITE(CHAMFL(14:19),'(2I3.3)') NUMOD,NUMVIT
              CALL JEVEUO(CHAMFL(1:19)//'.VALE','L',IVALE)
              ICM = 0
              DO 30 IEQ = 1,NEQ
                DO 32 K = 1,6
                  IF (ZI(IDEEQ+(2*IEQ)-1) .EQ. IDDL(K)) THEN
                    ICM = ICM + 1
                    ZR(LMOD+NEQ*(I-1)+IEQ-1) = ZR(IVALE+ICM-1)
                    GOTO 30
                  ENDIF
 32             CONTINUE
 30           CONTINUE
            ENDIF
          ENDIF
 20     CONTINUE
 10   CONTINUE
C
C     --- ON NORMALISE 'SANS_CMP: LAGR'
C
      IPREC = 0
      IF ( LNORM ) THEN
         NORM = 'AVEC_CMP'
         CALL WKVECT('&&MODIBA.POSITION.DDL','V V I',NEQ,LDDL)
         CALL PTEDDL('NUME_DDL', NUMDDL , 1, 'LAGR    ', NEQ, ZI(LDDL))
         DO 40 IEQ = 0,NEQ-1
            ZI(LDDL+IEQ)= 1 - ZI(LDDL+IEQ)
 40      CONTINUE
         CALL WKVECT('&&MODIBA.COEF_MODE','V V R',NBMODE,LCOEF)
C        --- ON NORMALISE LES DEFORMEES
         CALL VPNORM ( NORM, 'OUI', LMAT, NEQ, NBMODE, ZI(LDDL),
     +           ZR(LMOD), ZR(LVALR), LMASIN, XMASTR, 0, 0, ZR(LCOEF) )
C        --- ON STOCKE LES DEFORMEES
         CALL VPSTOR ( -1, TYPMOD, NOMRES, NBNUOR, NEQ, ZR(LMOD), ZC(1),
     +                 NBNUOR, NBPARI, NBPARR, NBPARK, NOPARA,
     +                 ZI(LVALI), ZR(LVALR), ZK24(LVALK), IPREC )
C        --- ON NORMALISE LES AUTRES CHAMPS
         CALL VPNOR2 ( NOMRES, NBMODE, NUOR, ZR(LCOEF) )
         CALL JEDETR('&&MODIBA.COEF_MODE')
      ELSE
C        --- ON STOCKE LES DEFORMEES
         CALL VPSTOR ( -1, TYPMOD, NOMRES, NBNUOR, NEQ, ZR(LMOD), ZC(1),
     +                 NBNUOR, NBPARI, NBPARR, NBPARK, NOPARA,
     +                 ZI(LVALI), ZR(LVALR), ZK24(LVALK), IPREC )
      ENDIF
C
C     --- TITRE ASSOCIE AU CONCEPT ---
C
      CALL TITRE
C
      CALL JEDETC('V','&&MODIBA',1)
      CALL JEDEMA()
      END
