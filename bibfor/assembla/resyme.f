      SUBROUTINE RESYME(RESU1Z,BASEZ,RESU2Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 11/09/2002   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C.======================================================================
      IMPLICIT NONE

C      RESYME -- A PARTIR DU MATR_ELEM NON-SYMETRIQUE RESU1Z,
C                ON CREE SUR LA BASE BASEZ LE  MATR_ELEM SYMETRIQUE
C                RESU2Z.
C                LES MATRICES ELEMENTAIRES MAT2 DE RESU2Z
C                SONT OBTENUES A PARTIR DES MATRICES ELEMENTAIRES
C                DE RESU1Z DE LA MANIERE SUIVANTE :
C                 MAT2 = 1/2*(MAT1 + MAT1_T)


C   ARGUMENT        E/S  TYPE         ROLE
C    RESU1Z          IN    K*     NOM DU MATR_ELEM NON-SYMETRIQUE
C    BASEZ           IN    K*     NOM DE LA BASE SUR-LAQUELLE ON
C                                 ON VA CREER LE MATR_ELEM SYMETRIQUE
C                                 RESU2Z
C    RESU2Z          OUT   K*     NOM DU MATR_ELEM SYMETRIQUE
C                                 QUI VA ETRE CREE SUR LA
C                                 BASE BASEZ ET DONT LES MATRICES
C                                 ELEMENTAIRES MAT2 SONT OBTENUES A
C                                 PARTIR DES MATRICES ELEMENTAIRES MAT1
C                                 DE RESU1Z PAR LA RELATION DE
C                                 SYMETRISATION :
C                                  MAT2 = 1/2*(MAT1 + MAT1_T)
C.========================= DEBUT DES DECLARATIONS ====================
C ----- COMMUNS NORMALISES  JEVEUX
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM
C -----  ARGUMENTS
      CHARACTER*(*) RESU1Z,BASEZ,RESU2Z
C -----  VARIABLES LOCALES
      CHARACTER*1 BASE
      CHARACTER*8 RESUL1,RESUL2,SYMEL
      CHARACTER*8 MODELE,RESU,K8BID
      CHARACTER*16 PHENOM,OPTION
      CHARACTER*19 RESL1,RESL2
      CHARACTER*24 LIGRMO
      INTEGER IBID,IER,NBRESU,IDLRE1,IDLRE2,IRESU,IRET
C.========================= DEBUT DU CODE EXECUTABLE ==================

      CALL JEMARQ()
      BASE = BASEZ
      RESUL1 = RESU1Z
      RESUL2 = RESU2Z
      CALL DISMOI('F','NOM_MODELE',RESUL1,'MATR_ELEM',IBID,MODELE,IER)
      LIGRMO = MODELE//'.MODELE'


C --- QUELLE OPTION APPELER ?
C     -------------------------------------------
      CALL DISMOI('F','PHENOMENE',MODELE,'MODELE',IBID,PHENOM,IER)
      IF (PHENOM.EQ.'MECANIQUE') THEN
        OPTION = 'SYME_MDNS_R'
      ELSE IF (PHENOM.EQ.'THERMIQUE') THEN
        OPTION = 'SYME_MTNS_R'
      ELSE
        CALL UTMESS('F','RESYME','LE PHENOME '//PHENOM//' N''EST PAS'//
     &              ' ADMIS POUR LA SYMETRISATION DES MATRICES.'//
     &              'SEULS SONT ADMIS LES PHENOMENES "MECANIQUE"'//
     &              ' ET "THERMIQUE" .')
      END IF


C --- CREATION DU RESUELEM SYMETRIQUE :
C     -------------------------------------------
      CALL JEDETR(RESUL2//'.LISTE_RESU')
      CALL JEDETR(RESUL2//'.REFE_RESU')
      CALL JEDUPC(' ',RESUL1//'.REFE_RESU',1,'V',RESUL2//'.REFE_RESU',
     &            .FALSE.)
      CALL JELIRA(RESUL1//'.LISTE_RESU','LONUTI',NBRESU,K8BID)
      CALL WKVECT(RESUL2//'.LISTE_RESU',BASE//' V K24',NBRESU,IDLRE2)
      CALL JEVEUO(RESUL1//'.LISTE_RESU','L',IDLRE1)


C --- BOUCLE SUR LES CHAMPS DES RESUELEMS :
C     -----------------------------------
      DO 10 IRESU = 1,NBRESU
        CALL GCNCON('.',RESU)
        ZK24(IDLRE2+IRESU-1) = RESU
   10 CONTINUE


C --- CALCUL DES MATRICES ELEMENTAIRES SYMETRIQUES MAT2 A PARTIR
C --- DES MATRICES ELEMENTAIRES NON-SYMETRIQUES MAT1 PAR
C --- SYMETRISATION DE CES DERNIERES
C --- (I.E. MAT2 = 1/2*(MAT1 + MAT1_T) :
C       --------------------------------

      DO 20 IRESU = 1,NBRESU
        RESL1 = ZK24(IDLRE1+IRESU-1)
        CALL JEEXIN(RESL1//'.RESL',IRET)
        IF (IRET.NE.0) THEN
          CALL GCNCON('.',RESL2)
          CALL DISMOI('F','TYPE_MATRICE',RESL1,'RESUELEM',IBID,SYMEL,
     &                IER)
          IF (SYMEL.EQ.'NON_SYM') THEN
            CALL CALCUL('S',OPTION,LIGRMO,1,RESL1,'PNOSYM',1,RESL2,
     &                  'PSYM',BASE)
          ELSE
            CALL COPISD('CHAMP_GD',BASE,RESL1,RESL2)
          END IF
          ZK24(IDLRE2+IRESU-1) = RESL2
        END IF
   20 CONTINUE


      CALL JEDEMA()
      END
