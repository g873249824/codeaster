      SUBROUTINE DISMZC(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER             REPI, IERD
      CHARACTER*(*) QUESTI,NOMOBZ,REPKZ
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     --     DISMOI( 'Z_CST', MODELE, ... )
C    IN:
C       QUESTI : 'Z_CST'
C       NOMOBZ : NOM D'UN OBJET DE TYPE LIGREL
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C ----------------------------------------------------------------------
C
      CHARACTER*1   K1BID
      CHARACTER*8   MA, TYPMA
      CHARACTER*19  NOLIG
      CHARACTER*24 NEMA
      CHARACTER*32  REPK
      INTEGER IADIME ,IAMACO ,IANBNO ,IANOMA ,IATYPM ,IDNEMA ,IER
      INTEGER II ,ILMACO ,IMA ,INO ,IOCC ,ITYPM ,JCOOR
      INTEGER JIMA ,JNBNO ,NBMA ,NBNOMA ,NBNOT ,NBPT ,NUMAIL
      INTEGER NUNOEL ,NUNOTA ,NUTIOC,NUMGLM
      REAL*8 Z1
C -----  FONCTIONS FORMULES
C     NUMGLM(IMA,INO)=NUMERO GLOBAL DU NOEUD INO DE LA MAILLE IMA
C                     IMA ETANT UNE MAILLE DU MAILLAGE.
      NUMGLM(NUMAIL,INO)=ZI(IAMACO-1+ZI(ILMACO+NUMAIL-1)+INO-1)
C --------------------------------------------------------------------
      CALL JEMARQ()
      NOLIG = NOMOBZ
      REPK = ' '
      REPI = 0
      IERD = 0
C
C --- LE MODELE
C
      CALL JEVEUO(NOLIG//'.LGRF','L',IANOMA)
      CALL JELIRA(NOLIG//'.LIEL','NUTIOC',NUTIOC,K1BID)
      NEMA = NOLIG//'.NEMA'
      CALL JEEXIN(NEMA,IER)
C
C --- LE MAILLAGE
C
      MA = ZK8(IANOMA-1+1)
      CALL JEVEUO(MA//'.CONNEX','L',IAMACO)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',ILMACO)
      CALL JEVEUO(MA//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO(MA//'.DIME','L',IADIME)
      NBNOMA = ZI(IADIME-1+1)
C
C --- ON CREE UN TABLEAU DONT LA COMPOSANTE I VAUDRA 1 SI LE NOEUD I
C     APPARTIENT AU MODELE
C
      CALL WKVECT('&&DISMZC.TRAV.NOEUDS','V V I',NBNOMA,JNBNO)
C
      CALL JEVEUO ('&CATA.TE.TYPEMA','L', IATYPM )
      CALL JEVEUO ('&CATA.TM.NBNO'  ,'L', IANBNO )
C
      DO 10 IOCC=1,NUTIOC
C
         CALL JELIRA(JEXNUM(NOLIG//'.LIEL',IOCC),'LONMAX',NBMA,K1BID)
         CALL JEVEUO(JEXNUM(NOLIG//'.LIEL',IOCC),'L',JIMA)
         TYPMA = ZK8(IATYPM-1+ZI(JIMA+NBMA-1))
         CALL JENONU(JEXNOM('&CATA.TM.NOMTM',TYPMA),ITYPM)
         NBPT = ZI(IANBNO-1+ITYPM)
         NBMA = NBMA - 1
C
         DO 15 II = 1,NBMA
C
            NUMAIL = ZI(JIMA+II-1)
C
            IF ( NUMAIL .LT. 0 ) THEN
C --------- MAILLE TARDIVE: ON RECUPERE NEMA
               IF (IER.EQ.0) CALL U2MESS('F','UTILITAI_71')
               IMA = -NUMAIL
               CALL JEVEUO(JEXNUM(NEMA,IMA),'L',IDNEMA)
               CALL JELIRA(JEXNUM(NEMA,IMA),'LONMAX',NBNOT,K1BID)
C --------- NEMA NOUS DONNE DIRECTEMENT LE NUMERO DU NOEUD
               NBNOT = NBNOT-1
               DO 22 INO = 1,NBNOT
                  NUNOTA = ZI(IDNEMA+INO-1)
                  IF (NUNOTA.LT.0) THEN
                     CALL U2MESS('F','UTILITAI_72')
                  ENDIF
                  ZI(JNBNO+NUNOTA-1) = 1
   22          CONTINUE
            ELSE
C
C --------- RECUPERATION DU NOMBRE DE NOEUDS ET DE LA LISTE
C           DES NOEUDS DE LA MAILLE NUMAIL
C
               DO 20 INO = 1,NBPT
                  NUNOEL = NUMGLM(NUMAIL,INO)
                  ZI(JNBNO+NUNOEL-1) = 1
   20          CONTINUE
            ENDIF
   15    CONTINUE
   10 CONTINUE
C
C --- ON RECUPERE LA COORDONNEE Z DU PREMIER NOEUD DU MAILLAGE
C     CONTENU DANS LE MODELE POUR TESTER LES Z SUIVANTS
C
      DO 24 INO = 1,NBNOMA
         IF ( ZI(JNBNO+INO-1) .NE. 0 ) THEN
            Z1 = ZR(JCOOR-1+3*(INO-1)+3)
            GOTO 26
         ENDIF
 24   CONTINUE
 26   CONTINUE
C
      DO 25 INO = 1,NBNOMA
         IF ( ZI(JNBNO+INO-1) .NE. 0 ) THEN
            IF ( ZR(JCOOR-1+3*(INO-1)+3) .NE. Z1 ) GOTO 30
         ENDIF
 25   CONTINUE
      REPK = 'OUI'
      GO TO 9999
 30   CONTINUE
      REPK = 'NON'
C
 9999 CONTINUE
      REPKZ=REPK
      CALL JEDETR('&&DISMZC.TRAV.NOEUDS')
      CALL JEDEMA()
      END
