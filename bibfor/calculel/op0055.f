      SUBROUTINE OP0055 ( IER )
      IMPLICIT   NONE
      INTEGER             IER
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/03/2003   AUTEUR ASSIRE A.ASSIRE 
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
C      OPERATEUR :     DEFI_FOND_FISS
C
C-----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
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
      CHARACTER*8        KBID
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER       NBV, IFM, IRET, IRETEX, IRETNO, IRETOR, JEXTR,
     +              JNORM, JORIG, NIV, N1, N2, IOC
      REAL*8        PS1, PS2, R8PREM, ZERO
      LOGICAL       CODE, LBID
      CHARACTER*8   K8B, RESU, NOMA, ENTIT1, ENTIT2
      CHARACTER*16  TYPE, OPER, TYPFON, MOTCLE(2), TYPMCL(2)
C DEB-------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL INFMAJ
      CALL INFNIV ( IFM, NIV )
C
C ---  RECUPERATION DES ARGUMENTS DE LA COMMANDE
C
      CALL GETRES (RESU,TYPE,OPER)
C
C ---  MAILLAGE
C      --------
C
      CALL GETVID (' ', 'MAILLAGE', 0, 1, 1, NOMA, NBV)
C
C ---  MOTS CLES FACTEUR : FOND ET FOND_FERME
C      ------------------------------------
C
      CALL GETFAC ( 'FOND', NBV )
      IF (NBV.GT.0) TYPFON = 'FOND'
      CALL GETFAC ( 'FOND_FERME', NBV )
      IF (NBV.GT.0) TYPFON = 'FOND_FERME'
      ENTIT1 = 'NOEUD'
      ENTIT2 = 'MAILLE'
      CALL GETVID ( TYPFON, 'NOEUD_ORIG'   , 1,1,0, K8B, N1 )
      CALL GETVID ( TYPFON, 'GROUP_NO_ORIG', 1,1,0, K8B, N2 )
      IF ( N1+N2 .EQ. 0 ) THEN
         CALL GVERIF ( RESU, NOMA, TYPFON, ENTIT2, CODE )
      ELSE
         IOC = 1
         MOTCLE(1) = 'GROUP_MA'
         MOTCLE(2) = 'MAILLE'
         TYPMCL(1) = 'GROUP_MA'
         TYPMCL(2) = 'MAILLE'
         CALL FONFIS ( RESU, NOMA, TYPFON, IOC,  
     +                    2, MOTCLE, TYPMCL, 'G' )
      ENDIF
      CALL GVERIF(RESU,NOMA,TYPFON,ENTIT1,CODE)
C
C
C ---  MOT CLE FACTEUR : LEVRE_SUP
C      ---------------------------
C
      CALL GVERIF(RESU,NOMA,'LEVRE_SUP',ENTIT2,CODE)
C
C ---  MOT CLE FACTEUR : LEVRE_INF
C      ---------------------------
C
      CALL GVERIF(RESU,NOMA,'LEVRE_INF',ENTIT2,CODE)
C
C ---  MOT CLE FACTEUR : NORMALE
C      -------------------------
C
      CALL GVERIF(RESU,NOMA,'NORMALE',KBID,LBID)
C
C ---  MOT CLE FACTEUR : DTAN_ORIG
C      ------------------------------
C
      CALL GVERIF(RESU,NOMA,'DTAN_ORIG'   ,KBID,LBID)
C
C ---  MOT CLE FACTEUR : DTAN_EXTR
C      --------------------------------
C
      CALL GVERIF(RESU,NOMA,'DTAN_EXTR'     ,KBID,LBID)
C
C ---  MOT CLE FACTEUR : VECT_GRNO_ORIG
C      --------------------------------
C
      CALL GVERIF(RESU,NOMA,'VECT_GRNO_ORIG',KBID,LBID)
C
C ---  MOT CLE FACTEUR : VECT_GRNO_EXTR
C      --------------------------------
C
      CALL GVERIF(RESU,NOMA,'VECT_GRNO_EXTR',KBID,LBID)
C
C VERIFICATION DE L'ORTHOGONALITE DE LA NORMALE AU PLAN DES LEVRES
C  ET DES 2 DIRECTIONS TANGENTES
C
        CALL JEEXIN(RESU//'.NORMALE',IRETNO)
        CALL JEEXIN(RESU//'.DTAN_ORIGINE',IRETOR)
        CALL JEEXIN(RESU//'.DTAN_EXTREMITE',IRETEX)
        IF(IRETOR.NE.0.AND.IRETEX.NE.0) THEN
          CALL JEVEUO(RESU//'.DTAN_ORIGINE','L',JORIG)
          CALL JEVEUO(RESU//'.DTAN_EXTREMITE','L',JEXTR)
        ENDIF
        IF(IRETNO.NE.0.AND.IRETOR.NE.0.AND.IRETEX.NE.0) THEN
          CALL JEVEUO(RESU//'.NORMALE','L',JNORM)
          CALL JEVEUO(RESU//'.DTAN_ORIGINE','L',JORIG)
          CALL JEVEUO(RESU//'.DTAN_EXTREMITE','L',JEXTR)
          CALL PSCAL(3,ZR(JNORM),ZR(JORIG),PS1)
          CALL PSCAL(3,ZR(JNORM),ZR(JEXTR),PS2)
          ZERO = R8PREM()
          IF(ABS(PS1).GT.ZERO) THEN
             CALL UTMESS('E','OP0055','LA NORMALE N''EST PAS ORTHO'
     &        //  'GONALE A LA TANGENTE A L''ORIGINE' )
          ENDIF
          IF(ABS(PS2).GT.ZERO) THEN
             CALL UTMESS('E','OP0055','LA NORMALE N''EST PAS ORTHO'
     &        //  'GONALE A LA TANGENTE A L''EXTREMITE' )
          ENDIF
        ENDIF
C
C IMPRESSION DES OBJETS
C
      IF ( NIV .GT. 1 ) THEN
        CALL JEIMPO('MESSAGE',RESU//'.FOND      .NOEU',' ',
     &                'OBJET POUR LE MOT CLE FOND')
C
        CALL JEEXIN(RESU//'.LEVRESUP  .MAIL',IRET)
C
        IF(IRET.NE.0) THEN
          CALL JEIMPO('MESSAGE',RESU//'.LEVRESUP  .MAIL',' ',
     &                  'OBJET POUR LE MOT CLE LEVRE_SUP')
C
        ENDIF
C
        IF (CODE) THEN
            CALL JEIMPO('MESSAGE',RESU//'.LEVREINF  .MAIL',' ',
     &                'OBJET POUR LE MOT CLE LEVRE_INF')
        ENDIF
C
        IF(IRETNO.NE.0) THEN
          CALL JEIMPO('MESSAGE',RESU//'.NORMALE',' ',
     &                  'OBJET POUR LE MOT CLE NORMALE')
        ENDIF
C
        IF(IRETOR.NE.0) THEN
          CALL JEIMPO('MESSAGE',RESU//'.DTAN_ORIGINE',' ',
     &                  'OBJET POUR LE MOT CLE DTAN_ORIG')
        ENDIF
C
        IF(IRETEX.NE.0) THEN
          CALL JEIMPO('MESSAGE',RESU//'.DTAN_EXTREMITE',' ',
     &                  'OBJET POUR LE MOT CLE DTAN_EXTR')
        ENDIF
      ENDIF
C
      CALL JEDEMA()
      END
