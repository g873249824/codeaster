      SUBROUTINE SS2MME(MO,VECEL)
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
C
C     ARGUMENTS:
C     ----------
      CHARACTER*8 MO,VECEL
C ----------------------------------------------------------------------
C     BUT: TRAITER LE MOT-CLEF SOUS_STRUC DE LA COMMANDE
C          CALC_VECT_ELEM.
C
C
C     IN:     MO : NOM DU MODELE
C          VECEL : NOM DU VECT_ELEM
C
C     OUT: VECEL EST (EVENTUELLEMENT) ENRICHI DE L'OBJET .LISTE_CHAR
C
C ----------------------------------------------------------------------
C
C     FONCTIONS EXTERNES:
C     -------------------
C
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*8 MA ,KBID ,NOSMA,NOMCAS,NOMACR
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C
C
      CALL JEMARQ()
      CALL GETFAC('SOUS_STRUC',NBOC)
      IF (NBOC.EQ.0) GO TO 9999
C
      CALL DISMOI('F','NOM_MAILLA',MO,'MODELE',IBID,MA,IERD)
      CALL DISMOI('F','NB_SS_ACTI',MO,'MODELE',NBSSA,KBID,IERD)
      CALL DISMOI('F','NB_SM_MAILLA',MO,'MODELE',NBSMA,KBID,IERD)
C
      IF (NBSSA.EQ.0) THEN
        CALL UTMESS('F','SS2MME','MOT CLEF "SOUS_STRUC" INTERDIT'
     +              //' POUR CE MODELE SANS SOUS_STRUCTURES.')
      END IF
C
      CALL JEVEUO(MO//'.SSSA','L',IASSSA)
      CALL JEVEUO(MA//'.NOMACR','L',IAMACR)
C
      CALL JEVEUO(VECEL//'.REFE_RESU','E',IAREFR)
      ZK24(IAREFR-1+3)(1:3)='OUI'
C
      CALL JECREC(VECEL//'.LISTE_CHAR','G V I','NO','CONTIG',
     +             'CONSTANT',NBOC)
      CALL JEECRA(VECEL//'.LISTE_CHAR','LONMAX',NBSMA,KBID)
C
C
      CALL WKVECT('&&SS2MME.LMAI','V V K8',NBSMA,IALMAI)
C
C     -- BOUCLE SUR LES CAS_DE_CHARGE:
C     --------------------------------
      IER0=0
      DO 10, IOC= 1,NBOC
C
        CALL GETVTX('SOUS_STRUC','CAS_CHARGE',IOC,1,1,NOMCAS,N1)
        CALL JECROC(JEXNOM(VECEL//'.LISTE_CHAR',NOMCAS))
        CALL JEVEUO(JEXNOM(VECEL//'.LISTE_CHAR',NOMCAS),'E',IALSCH)
C
C       -- CAS : TOUT: 'OUI' :
C       ----------------------
        CALL GETVTX('SOUS_STRUC','TOUT',IOC,1,1,KBID,N1)
        IF (N1.EQ.1) THEN
          DO 1, I=1,NBSMA
            IF (ZI(IASSSA-1+I).EQ.1) ZI(IALSCH-1+I)=1
 1        CONTINUE
          GO TO 5
        END IF
C
C       -- CAS : MAILLE: L_MAIL
C       -----------------------
        CALL GETVID('SOUS_STRUC','MAILLE',
     +             IOC,1,0,KBID,N2)
        IF (-N2.GT.NBSMA) CALL UTMESS('F','SS2MME','LISTE DE MAILLES '
     +     //'PLUS LONGUE QUE LA LISTE DES SOUS_STRUCTURES DU MODELE.')
        CALL GETVID('SOUS_STRUC','MAILLE',
     +             IOC,1,NBSMA,ZK8(IALMAI),N2)
        DO 2, I=1,N2
          NOSMA=ZK8(IALMAI-1+I)
          CALL JENONU(JEXNOM(MA//'.SUPMAIL',NOSMA),IMAS)
          IF (IMAS.EQ.0) THEN
            CALL UTMESS('F','SS2MME','LA MAILLE : '//NOSMA
     +                //' N EXISTE PAS DANS LE MAILLAGE : '//MA)
          ELSE
            ZI(IALSCH-1+IMAS)=1
          END IF
 2      CONTINUE
C
C
C       -- ON VERIFIE QUE LES VECTEURS ELEMENTAIRES SONT CALCULES:
C       ----------------------------------------------------------
 5      CONTINUE
        DO 3, I=1,NBSMA
          IF (ZI(IALSCH-1+I).EQ.0) GO TO 3
          CALL JENUNO(JEXNUM(MA//'.SUPMAIL',I),NOSMA)
          IF (ZI(IASSSA-1+I).NE.1) CALL UTMESS('F','SS2MME',
     +     'LA MAILLE : '//NOSMA//' N''EST PAS ACTIVE DANS LE MODELE')
C
          NOMACR= ZK8(IAMACR-1+I)
          CALL JEEXIN(JEXNOM(NOMACR//'.LICA',NOMCAS),IRET)
          IF (IRET.EQ.0) THEN
            IER0=1
            CALL UTMESS('E','SS2MME','LA MAILLE : '//NOSMA
     +                //' NE CONNAIT PAS LE CHARGEMENT : '//NOMCAS)
          END IF
 3      CONTINUE
C
 10   CONTINUE
C
      IF (IER0.EQ.1) CALL UTMESS
     +    ('F','SS2MME','ARRET SUITE AUX ERREURS DETECTEES.')
C
      CALL JEEXIN('&&SS2MME.LMAI',IRET)
      IF (IRET.GT.0) CALL JEDETR('&&SS2MME.LMAI')
C
C
 9999 CONTINUE
      CALL JEDEMA()
      END
