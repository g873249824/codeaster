      SUBROUTINE RECIEX ( INTEXC, IDEREX, NINDEX, NNOEEX, NCMPEX,
     &                    NVASEX, GRAEXC, EXCMOD, NAPEXC )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/01/2006   AUTEUR REZETTE C.REZETTE 
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
C    C. DUVAL
C-----------------------------------------------------------------------
C  BUT: RECUPERER LES INFORMATIONS DE TYPE EXCITATION POUR
      IMPLICIT REAL*8 (A-H,O-Z)
C        LE CALCUL DYNAMIQUE ALEATOIRE
C
C INTEXC   /OUT/: NOM DE L INTERSPECTRE  EXCITATION
C IDEREX   /OUT/: ORDRE DE DERIVATION
C NINDEX   /OUT/: NOMBRE  D INDICES RECUPERES
C NNOEEX   /OUT/: NOMBRE DE NOEUDS DONNES EN EXCITATION
C NCMPXC   /OUT/: NOMBRE DE CMP DONNES EN EXCITATION
C NVASEX   /OUT/: NOMBRE DE VECTEURS ASSEMBLES DONNES EN EXCITATION
C GRAEXC  /OUT/ : GRANDEUR EXCITATION
C EXCMOD  /OUT/ : TYPE MODAL
C NAPEXC  /OUT/ : NOMBRE D APPUI EXCITATION (NOEUDS OU VECTASS)
C
C-----------------------------------------------------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER       IBID, IVAL(3), IRET
      REAL*8        R8B
      COMPLEX*16    C16B
      CHARACTER*3  TYPPAR
      CHARACTER*4   EXCMOD
      CHARACTER*8   K8B, INTEXC, KVAL(4)
      CHARACTER*16  GRAEXC, NOPART(3), NOPARN(5)
      CHARACTER*19  NOMFON
      LOGICAL       TABL, LINDI, EXISP
C
      DATA NOPART / 'NUME_VITE_FLUI', 'NUME_ORDRE_I', 'NUME_ORDRE_J' /
      DATA NOPARN / 'NUME_VITE_FLUI', 'NOEUD_I'     , 'NOM_CMP_I'    ,
     +                                'NOEUD_J'     , 'NOM_CMP_J'    /
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL GETVID ( 'EXCIT', 'INTE_SPEC'    ,1,1,1, INTEXC, IBID   )
      TABL = .FALSE.
      CALL TBEXIP ( INTEXC, 'NUME_VITE_FLUI', EXISP ,TYPPAR)
      IF ( EXISP ) TABL = .TRUE.
C
      CALL GETVIS ( 'EXCIT', 'DERIVATION'   ,1,1,1, IDEREX, IBID   )
C
      CALL GETVIS ( 'EXCIT', 'NUME_ORDRE_I' ,1,1,0, IBID  , NINDEX )
      IF ( NINDEX .NE. 0 ) THEN
         LINDI = .TRUE.
         NINDEX = -NINDEX
         CALL WKVECT('&&RECIEX.INDI_I','V V I',NINDEX,ILINDI)
         CALL WKVECT('&&RECIEX.INDI_J','V V I',NINDEX,ILINDJ)
         CALL GETVIS('EXCIT','NUME_ORDRE_I',1,1,NINDEX,ZI(ILINDI),IBID)
         CALL GETVIS('EXCIT','NUME_ORDRE_J',1,1,NINDEX,ZI(ILINDJ),IBID)
      ELSE
         CALL GETVID ( 'EXCIT', 'NOEUD_I' ,1,1,0, K8B , NINDEX )
         LINDI = .FALSE.
         NINDEX = -NINDEX
         CALL WKVECT('&&RECIEX.INDI_I','V V K8',NINDEX,ILINDI)
         CALL WKVECT('&&RECIEX.INDI_J','V V K8',NINDEX,ILINDJ)
         CALL WKVECT('&&RECIEX.CMP_I' ,'V V K8',NINDEX,ILCMPI)
         CALL WKVECT('&&RECIEX.CMP_J' ,'V V K8',NINDEX,ILCMPJ)
         CALL GETVID('EXCIT','NOEUD_I'  ,1,1,NINDEX,ZK8(ILINDI),IBID)
         CALL GETVID('EXCIT','NOEUD_J'  ,1,1,NINDEX,ZK8(ILINDJ),IBID)
         CALL GETVTX('EXCIT','NOM_CMP_I',1,1,NINDEX,ZK8(ILCMPI),IBID)
         CALL GETVTX('EXCIT','NOM_CMP_J',1,1,NINDEX,ZK8(ILCMPJ),IBID)
      ENDIF
      CALL GETVIS('EXCIT','NUME_VITE_FLUI',1,1,1,IVITE,IBID)
C
C     VERIFICATIONS DES PARAMETRES DE LA TABLE 'INTEXC'
      CALL TBEXP2(INTEXC,'FONCTION')
      IF(LINDI)THEN
        CALL TBEXP2(INTEXC,'NUME_ORDRE_I')
        CALL TBEXP2(INTEXC,'NUME_ORDRE_J')
      ELSE
        CALL TBEXP2(INTEXC,'NOEUD_I')
        CALL TBEXP2(INTEXC,'NOM_CMP_I')
        CALL TBEXP2(INTEXC,'NOEUD_J')
        CALL TBEXP2(INTEXC,'NOM_CMP_J')
      ENDIF
C
      NDIM = NINDEX * ( NINDEX + 1 ) / 2
      CALL WKVECT('&&OP0131.LIADRFEX1','V V I',NDIM,ILFEX)
      CALL WKVECT('&&OP0131.LIADRLEX1','V V I',NDIM,ILLEX)
C
      IF ( TABL ) THEN
         NBI = 3
         IP = 1
         IVAL(1) = IVITE
         II = 2
         JJ = 3
      ELSE
         NBI = 2
         IP = 2
         II = 1
         JJ = 2
      ENDIF
      IF ( .NOT. LINDI ) NBI = NBI + 2
      DO 103 I1 = 1,NINDEX
         IF ( LINDI ) THEN
            IVAL(II) = ZI(ILINDI+I1-1)
         ELSE
            KVAL(1) = ZK8(ILINDI+I1-1)
            KVAL(2) = ZK8(ILCMPI+I1-1)
         ENDIF
         DO 108 I2 = I1 , NINDEX
            IJ2 = (I2*(I2-1))/2+I1
            IF ( LINDI ) THEN
               IVAL(JJ) = ZI(ILINDJ+I2-1)
               CALL TBLIVA ( INTEXC, NBI, NOPART(IP), IVAL, R8B, C16B,
     +                       K8B, K8B, R8B, 'FONCTION',
     +                       K8B, IBID, R8B, C16B, NOMFON, IRET )
               IF (IRET.NE.0) CALL UTMESS('F','RECIEX','Y A UN BUG 2' )
            ELSE
               KVAL(3) = ZK8(ILINDJ+I2-1)
               KVAL(4) = ZK8(ILCMPJ+I2-1)
               CALL TBLIVA ( INTEXC, NBI, NOPARN(IP), IVAL, R8B, C16B,
     +                       KVAL, K8B, R8B, 'FONCTION',
     +                       K8B, IBID, R8B, C16B, NOMFON, IRET )
               IF (IRET.NE.0) CALL UTMESS('F','RECIEX','Y A UN BUG 2' )
            ENDIF
            CALL JELIRA( NOMFON//'.VALE', 'LONMAX', ZI(ILLEX-1+IJ2),K8B)
            CALL JEVEUT( NOMFON//'.VALE','L', ZI(ILFEX-1+IJ2) )
 108     CONTINUE
 103  CONTINUE
C
C----TYPE MODAL ('NON' PAR DEFAUT)
C
      CALL GETVTX ( 'EXCIT', 'MODAL', 1,1,1, EXCMOD, IBID )
      IF ( EXCMOD .EQ. 'OUI' ) NAPEXC = NINDEX
C
C----GRANDEUR   (DEPL_R PAR DEFAUT)
C
      CALL GETVTX ( 'EXCIT', 'GRANDEUR', 1,1,1, GRAEXC, IBID )
C
C---NOEUDS APPUIS
C
      CALL GETVID ( 'EXCIT', 'NOEUD', 1,1,0, K8B, NNOEEX )
      NNOEEX=-NNOEEX
      IF(NNOEEX.NE.0)THEN
         NAPEXC = NNOEEX
         CALL WKVECT('&&OP0131.LISTENOEEXC','V V K8',NNOEEX,ILNOEX)
         CALL GETVID('EXCIT','NOEUD',1,1,NNOEEX,ZK8(ILNOEX),IBID)
      ENDIF
C
C---CMP APPUIS
C
      CALL GETVTX('EXCIT','NOM_CMP',1,1,0,K8B,NCMPEX)
      NCMPEX=-NCMPEX
      IF(NCMPEX.NE.0)THEN
          CALL WKVECT('&&OP0131.LISTECMPEXC','V V K8',NCMPEX,ILCPEX)
          CALL GETVTX('EXCIT','NOM_CMP',1,1,NCMPEX,ZK8(ILCPEX),IBID)
      ENDIF
C
C---VECTEURS ASSEMBLES
C
      CALL GETVID('EXCIT','CHAM_NO',1,1,0,K8B,NVASEX)
      NVASEX=-NVASEX
      IF ( NVASEX .NE. 0 ) THEN
         NAPEXC = NVASEX
         GRAEXC = 'EFFO'
         CALL WKVECT('&&OP0131.LVECTASSEXC','V V K8',NVASEX,ILVAEX)
         CALL GETVID('EXCIT','CHAM_NO',1,1,NVASEX,ZK8(ILVAEX),IBID1)
      ENDIF
C
      IF (GRAEXC.EQ.'EFFO') IDEREX = 0
C
      CALL JEDETR ( '&&RECIEX.INDI_I' )
      CALL JEDETR ( '&&RECIEX.INDI_J' )
      CALL JEEXIN ( '&&RECIEX.CMP_I' , IRET )
      IF ( IRET .NE. 0 ) THEN
         CALL JEDETR ( '&&RECIEX.CMP_I' )
         CALL JEDETR ( '&&RECIEX.CMP_J' )
      ENDIF
C
      CALL JEDEMA()
      END
