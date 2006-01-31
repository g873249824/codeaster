      SUBROUTINE OP0076( IERR )
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/01/2006   AUTEUR LEBOUVIE F.LEBOUVIER 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C     RECUPERE LES CHAMPS GENERALISES (DEPL, VITE, ACCE) D'UN CONCEPT
C     TRAN_GENE.
C-----------------------------------------------------------------------
C      ----DEBUT DES COMMUNS JEVEUX--------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C      ----FIN DES COMMUNS JEVEUX----------
C-----------------------------------------------------------------------
      REAL*8        TEMPS, PREC
      CHARACTER*8   NOMRES, TRANGE, BASEMO, NOMCHA, INTERP, CRIT
      CHARACTER*16  CONCEP, NOMCMD
      CHARACTER*1 K1BID
C-----------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()
C
      CALL GETRES(NOMRES,CONCEP,NOMCMD)
C
C     --- RECUPERATION DES ARGUMENTS DE LA COMMANDE ---
C
      CALL GETVID(' ','RESU_GENE',0,1,1,TRANGE,N1)
      CALL GETVTX(' ','NOM_CHAM' ,0,1,1,NOMCHA,N1)
      CALL GETVR8(' ','INST'     ,0,1,1,TEMPS ,N1)
      CALL GETVTX(' ','INTERPOL',0,1,1,INTERP,N1)
      CALL GETVTX(' ','CRITERE'  ,0,1,1,CRIT  ,N1)
      CALL GETVR8(' ','PRECISION',0,1,1,PREC  ,N1)
C
C     --- RECUPERATION DES INFORMATIONS MODALES ---
C
      CALL JEVEUO(TRANGE//'           .DESC','L',IADESC)
      CALL JEVEUO(TRANGE//'           .REFD','L',IAREFE)
      CALL JEVEUO(TRANGE//'           .INST','L',IDINST)
      CALL JELIRA(TRANGE//'           .INST','LONMAX',NBINST,K1BID)
      CALL JEVEUO(TRANGE//'           .'//NOMCHA(1:4),'L',IDCHAM)
      BASEMO = ZK24(IAREFE+5)(1:8)
      NBMODE = ZI(IADESC+1)
C
C     --- CREATION DU VECT_ASSE_GENE RESULTAT ---
C
      CALL WKVECT(NOMRES//'           .VALE','G V R'  ,NBMODE,IDVECG)
      CALL WKVECT(NOMRES//'           .REFE','G V K24',2     ,IDREFE)
      CALL WKVECT(NOMRES//'           .DESC','G V I'  ,2     ,IDDESC)
C
      ZI(IDDESC)     = 1
      ZI(IDDESC+1)   = NBMODE
      ZK24(IDREFE)   = BASEMO
      ZK24(IDREFE+1) = '$TRAN_GENE'
C
C     --- RECUPERATION DU CHAMP ---
C
      CALL EXTRAC(INTERP,PREC,CRIT,NBINST,ZR(IDINST),TEMPS,ZR(IDCHAM),
     +                                           NBMODE,ZR(IDVECG),IERD)
      IF ( IERD.NE.0) THEN
       CALL UTMESS('E','OP0076','L''INSTANT DE RECUPERATION EST EN '//
     +                                  'DEHORS DU DOMAINE DE CALCUL.')
      ENDIF
C
      CALL JEDEMA()
      END
