      SUBROUTINE SSDMDN ( MAG )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 16/04/99   AUTEUR CIBHHPD P.DAVID 
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
C     ARGUMENTS:
C     ----------
      CHARACTER*8 MAG
C ----------------------------------------------------------------------
C     BUT:
C        - TRAITER LE MOT CLEF "DEFI_NOEUD"
C          DE LA COMMANDE DEFI_MAILLAGE.
C        - CREER LES OBJETS :
C            BASE VOLATILE: .NOMNOE_2
C
C     IN:
C        MAG : NOM DU MAILLAGE QUE L'ON DEFINIT.
C
C ---------------- COMMUNS NORMALISES  JEVEUX  -------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*8  NOMACR,NOSMA,KBID,MAL,PREF,NOMNOL,NOMNOG
      INTEGER ZI,INDI(4)
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL JEVEUO(MAG//'.DIME','L',IADIME)
      CALL JEVEUO(MAG//'.DIME_2','L',IADIM2)
      CALL JEVEUO(MAG//'.NOEUD_CONF','L',IANCNF)
      CALL JEVEUO(MAG//'.NOMACR','L',IANMCR)
      NNNOE= ZI(IADIME-1+1)
      NBSMA= ZI(IADIME-1+4)
C
      CALL WKVECT(MAG//'.NOMNOE_2','V V K8',NNNOE,IANON2)
C
C
C     -- BOUCLE SUR LES OCCURENCES DU MOT-CLEF:
C     -----------------------------------------
      CALL GETFAC('DEFI_NOEUD',NOCC)
      DO 1, IOCC=1,NOCC
        CALL GETVTX('DEFI_NOEUD','TOUT',IOCC,1,1,KBID,N1)
        IF (N1.EQ.1) THEN
C
C       -- CAS : TOUT: 'OUI'
C       --------------------
          LPREF=0
          CALL GETLTX('DEFI_NOEUD','PREFIXE',IOCC,1,1,LPREF,N2)
          CALL GETVIS('DEFI_NOEUD','INDEX',IOCC,1,4,INDI,N3)
          LMAIL=INDI(2)-INDI(1)+1
          LNOEU=INDI(4)-INDI(3)+1
          LMAIL=MAX(LMAIL,0)
          LNOEU=MAX(LNOEU,0)
          LONGT= LPREF+LMAIL+LNOEU
          IF (LONGT.GT.8) CALL UTMESS('F','SSDMDN',
     +          'LES ARGUMENTS "PREFIXE" ET "INDEX" CONDUISENT A DES'
     +        //' NOMS DE NOEUDS TROP LONGS (8 CARACTERES MAXI).')
          IF (LPREF.GT.0)
     +    CALL GETVTX('DEFI_NOEUD','PREFIXE',IOCC,1,1,PREF,N2)
C
          DO 2 , ISMA=1,NBSMA
            CALL JEVEUO(JEXNUM(MAG//'.SUPMAIL',ISMA),'L',IASUPM)
            CALL JENUNO(JEXNUM(MAG//'.SUPMAIL',ISMA),NOSMA)
            NOMACR= ZK8(IANMCR-1+ISMA)
            CALL JEVEUO(NOMACR//'.CONX','L',IACONX)
            CALL DISMOI('F','NOM_MAILLA',NOMACR,'MACR_ELEM_STAT'
     +                    ,IBID,MAL,IED)
            NBNOE=ZI(IADIM2-1+4*(ISMA-1)+1)
            NBNOL=ZI(IADIM2-1+4*(ISMA-1)+2)
            NBNOET=NBNOE+NBNOL
            DO 3 , I=1,NBNOET
              INO= ZI(IASUPM-1+I)
              IF (INO.GT.NNNOE) GO TO 3
              INO1= ZI(IACONX-1+3*(I-1)+2)
              CALL JENUNO(JEXNUM(MAL//'.NOMNOE',INO1),NOMNOL)
              I1=1
              IF (LPREF.GT.0) ZK8(IANON2-1+INO)(I1:I1-1+LPREF)
     +                         = PREF(1:LPREF)
              I1= I1+LPREF
              IF (LMAIL.GT.0) ZK8(IANON2-1+INO)(I1:I1-1+LMAIL)
     +                         = NOSMA(INDI(1):INDI(2))
              I1= I1+LMAIL
              IF (LNOEU.GT.0) ZK8(IANON2-1+INO)(I1:I1-1+LNOEU)
     +                         = NOMNOL(INDI(3):INDI(4))
   3        CONTINUE
   2      CONTINUE
        ELSE
C
C
C       -- CAS : MAILLE, NOEUD_FIN, NOEUD_INIT :
C       ---------------------------------------
          CALL GETVID('DEFI_NOEUD','MAILLE',
     +               IOCC,1,1,NOSMA,N1)
          CALL GETVID('DEFI_NOEUD','NOEUD_FIN',
     +                  IOCC,1,1,NOMNOG,N2)
          CALL GETVID('DEFI_NOEUD','NOEUD_INIT',
     +                   IOCC,1,1,NOMNOL,N3)
          IF((N1*N2*N3).EQ.0) CALL UTMESS('F','SSDMDN',
     +        'IL FAUT : "TOUT" OU "MAILLE" POUR "DEFI_NOEUD".')
C
          CALL JENONU(JEXNOM(MAG//'.SUPMAIL',NOSMA),ISMA)
          NOMACR= ZK8(IANMCR-1+ISMA)
          CALL JEVEUO(NOMACR//'.LINO','L',IALINO)
          CALL JELIRA(NOMACR//'.LINO','LONUTI',NBNOEX,KBID)
          CALL DISMOI('F','NOM_MAILLA',NOMACR,'MACR_ELEM_STAT'
     +                    ,IBID,MAL,IED)
          CALL JENONU(JEXNOM(MAL//'.NOMNOE',NOMNOL),INOL)
          KK= INDIIS(ZI(IALINO),INOL,1,NBNOEX)
          IF (KK.EQ.0) THEN
            CALL UTMESS('A','SSDMDN',
     +       ' LE NOEUD : '//NOMNOL//' N''APPARTIENT PAS A LA MAILLE :'
     +        //NOSMA)
            GO TO 1
          END IF
C
          INO=ZI(IADIM2-1+4*(ISMA-1)+3)+KK
          IF (ZI(IANCNF-1+INO).EQ.INO) THEN
            ZK8(IANON2-1+INO)= NOMNOG
          ELSE
            CALL UTMESS('A','SSDMDN',
     +        ' LE NOEUD : '//NOMNOL//' DE LA MAILLE : '//NOSMA//
     +        ' A ETE ELIMINE (RECOLLEMENT).'//
     +        ' ON NE PEUT DONC LE RENOMMER.')
          END IF
        END IF
 1    CONTINUE
C
C
 9999 CONTINUE

      CALL JEDEMA()
      END
