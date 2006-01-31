      SUBROUTINE OP0104 ( IER )
      IMPLICIT   NONE
      INTEGER             IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 30/01/2006   AUTEUR LEBOUVIE F.LEBOUVIER 
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
C     OPERATEUR: DEFI_GROUP
C     ------------------------------------------------------------------
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER       NCI, N1, N2, NBGRMA, NBGMIN, IRET, NBGMA, NBGRMN, 
     +              I, J, NBMA, JGG, JVG, NBOCC, NBGRNO, IOCC, NBGNIN,
     +              NBGNO, NBGRNN, NBNO
      CHARACTER*8   K8B, MA, MA2, NOMG
      CHARACTER*16  NOMCMD, TYPCON
      CHARACTER*24  GRPMAI, GRPNOE, GRPMAV, GRPNOV, NCNCIN
C     ------------------------------------------------------------------
C
      CALL JEMARQ ( )
C
      CALL INFMAJ()
C
      CALL GETRES ( MA2, TYPCON, NOMCMD )
      CALL GETVID(' ','MAILLAGE',1,1,1,MA,N1)
      IF ( MA .NE. MA2 ) THEN
       CALL UTMESS('F','OP0104','CET OPERATEUR MODIFIE UN MAILLAGE '//
     +               'EXISTANT. LE RESULTAT DOIT ETRE IDENTIQUE AU '//
     +               'CONCEPT DONNE DANS L''ARGUMENT MAILLAGE.')
      ENDIF
C
C     --- ON REGARDE S'IL Y A DES GROUPES A DETRUIRE ---
C
      CALL GETFAC('DETR_GROUP_MA',N1)
      CALL GETFAC('DETR_GROUP_NO',N2)
      IF(N1.NE.0 .OR. N2.NE.0)THEN
         CALL DETGNM(MA)
      ENDIF

      GRPMAI  = MA//'.GROUPEMA       '
      GRPNOE  = MA//'.GROUPENO       '
      GRPMAV  = '&&OP0104'//'.GROUPEMA       '
      GRPNOV  = '&&OP0104'//'.GROUPENO       '
C
C     --- ON COMPTE LE NOMBRE DE NOUVEAUX GROUP_MA ---
C
      CALL GETFAC ( 'CREA_GROUP_MA' , NBGRMA )
C
C     --- ON AGRANDIT LA COLLECTION ---
C
      NBGMIN = 0
      CALL JEEXIN(GRPMAI,IRET)
      IF ( IRET .EQ. 0  .AND.  NBGRMA .NE. 0 ) THEN
         CALL JECREC(GRPMAI,'G V I','NOM','DISPERSE','VARIABLE',NBGRMA)
      ELSEIF ( IRET .EQ. 0  .AND.  NBGRMA .EQ. 0 ) THEN
      ELSE
         CALL JELIRA(GRPMAI,'NOMUTI',NBGMA,K8B)
         NBGMIN = NBGMA
         NBGRMN = NBGMA + NBGRMA
         CALL JEDUPO( GRPMAI, 'V', GRPMAV, .FALSE. )
         CALL JEDETR ( GRPMAI )
         CALL JECREC(GRPMAI,'G V I','NOM','DISPERSE','VARIABLE',NBGRMN)
         DO 100 I = 1 , NBGMA
            CALL JENUNO(JEXNUM(GRPMAV,I),NOMG)
            CALL JECROC(JEXNOM(GRPMAI,NOMG))
            CALL JEVEUO(JEXNUM(GRPMAV,I),'L',JVG)
            CALL JELIRA(JEXNUM(GRPMAV,I),'LONMAX',NBMA,K8B)
            CALL JEECRA(JEXNOM(GRPMAI,NOMG),'LONMAX',NBMA,' ')
            CALL JEVEUO(JEXNOM(GRPMAI,NOMG),'E',JGG)
            DO 102 J = 0 , NBMA-1
               ZI(JGG+J) = ZI(JVG+J)
 102        CONTINUE
 100     CONTINUE
      ENDIF
C
C     --- ON COMPTE LE NOMBRE DE NOUVEAUX GROUP_NO ---
C
      CALL GETFAC ( 'CREA_GROUP_NO' , NBOCC )
      NBGRNO = 0
      DO 10 IOCC = 1 , NBOCC
         CALL GETVTX('CREA_GROUP_NO','TOUT_GROUP_MA',IOCC,1,0,K8B,N1)
         IF ( N1 .NE. 0 ) THEN
            CALL JELIRA(GRPMAI,'NMAXOC',NBGMA,K8B)
            NBGRNO = NBGRNO + NBGMA
            GOTO 10
         ENDIF
         CALL GETVEM(MA,'GROUP_MA','CREA_GROUP_NO','GROUP_MA',
     +                   IOCC,1,0,K8B,N2)
         IF ( N2 .NE. 0 ) THEN
            NBGRNO = NBGRNO - N2
            GOTO 10
         ENDIF
C        -- ON CREE UN GROUP_NO PAR MOT CLE FACTEUR --
         NBGRNO = NBGRNO + 1
10    CONTINUE
C
C     --- ON AGRANDIT LA COLLECTION ---
C
      CALL JEEXIN(GRPNOE,IRET)
      NBGNIN = 0
      IF ( IRET .EQ. 0  .AND.  NBGRNO .NE. 0 ) THEN
         CALL JECREC(GRPNOE,'G V I','NOM','DISPERSE','VARIABLE',NBGRNO)
      ELSEIF ( IRET .EQ. 0  .AND.  NBGRNO .EQ. 0 ) THEN
      ELSE
         CALL JELIRA(GRPNOE,'NOMUTI',NBGNO,K8B)
         NBGRNN = NBGNO + NBGRNO
         NBGNIN = NBGNO
         CALL JEDUPO( GRPNOE, 'V', GRPNOV, .FALSE. )
         CALL JEDETR ( GRPNOE )
         CALL JECREC(GRPNOE,'G V I','NOM','DISPERSE','VARIABLE',NBGRNN)
         DO 200 I = 1 , NBGNO
            CALL JENUNO(JEXNUM(GRPNOV,I),NOMG)
            CALL JECROC(JEXNOM(GRPNOE,NOMG))
            CALL JEVEUO(JEXNUM(GRPNOV,I),'L',JVG)
            CALL JELIRA(JEXNUM(GRPNOV,I),'LONMAX',NBNO,K8B)
            CALL JEECRA(JEXNOM(GRPNOE,NOMG),'LONMAX',NBNO,' ')
            CALL JEVEUO(JEXNOM(GRPNOE,NOMG),'E',JGG)
            DO 202 J = 0 , NBNO-1
               ZI(JGG+J) = ZI(JVG+J)
 202        CONTINUE
 200     CONTINUE
      ENDIF
C
C     --- TRAITEMENT DU MOT CLEF CREA_GROUP_MA ---
C
      IF ( NBGRMA .GT. 0 ) CALL SSCGMA ( MA , NBGRMA , NBGMIN )
C
C     --- TRAITEMENT DU MOT CLEF CREA_GROUP_NO ---
C
      IF ( NBGRNO .GT. 0 ) CALL SSCGNO ( MA , NBGNIN )
C
C
      CALL JEDEMA ( )
C
      END
