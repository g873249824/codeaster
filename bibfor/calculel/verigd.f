      SUBROUTINE VERIGD(NOMGDZ,LCMP,NCMP,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE VABHHTS J.PELLET
C A_UTIL
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER NCMP,IRET
      CHARACTER*(*) NOMGDZ,LCMP(NCMP)
C ---------------------------------------------------------------------
C BUT: VERIFIER LA COHERENCE D'UNE LISTE DE CMPS D'UNE GRANDEUR.
C ---------------------------------------------------------------------
C     ARGUMENTS:
C LCMP   IN   V(K8) : LISTE DES CMPS A VERIFIER
C NCMP   IN   I     : LONGUEUR DE LA LISTE LCMP
C IRET   OUT  I     : CODE RETOUR :
C                     /0 : OK
C                     /1 : NOMGDZ N'EST PAS UNE GRANDEUR.
C                     /2 : UNE CMP (AU MOINS) EST EN DOUBLE DANS LCMP
C                     /3 : UNE CMP (AU MOINS) DE LCMP N'EST PAS UNE
C                          CMP DE NOMGDZ

C  SI IRET>0 : ON EMET SYSTEMATIQUEMENT UNE ALARME.
C              C'EST A L'APPELANT D'ARRETER LE CODE SI NECESSAIRE.
C----------------------------------------------------------------------
      CHARACTER*24 VALK(2)
C     ------------------------------------------------------------------
      INTEGER GD,JCMPGD,NCMPMX,I1,K,IBID
      CHARACTER*8 KBID,LCMP2(3000),NOMGD
C DEB
      CALL JEMARQ()
      IRET = 0
      NOMGD = NOMGDZ


C     1. NOMGD EST BIEN LE NOM D'UNE GRANDEUR :
C     -----------------------------------------
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),GD)
      IF (GD.EQ.0) THEN
        CALL U2MESK('A','POSTRELE_57',1,NOMGD)
        IRET = 1
        GO TO 30
      END IF
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',GD),'L',JCMPGD)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',GD),'LONMAX',NCMPMX,KBID)


C     2. ON RECOPIE LCMP DANS LCMP2 (K8) :
C     -------------------------------------------
      IF (NCMP.GT.3000) CALL U2MESS('F','POSTRELE_13')
      DO 10,K = 1,NCMP
        LCMP2(K) = LCMP(K)
   10 CONTINUE


C     3. LCMP2 N'A PAS DE DOUBLONS :
C     -----------------------------
      CALL KNDOUB(8,LCMP2,NCMP,I1)
      IF (I1.GT.0) THEN
        CALL U2MESK('A','POSTRELE_55',1,LCMP2(I1))
        IRET = 2
        GO TO 30
      END IF


C     3. LCMP2 EST INCLUSE DANS LA LISTE DES CMPS DE LA GRANDEUR :
C     -----------------------------------------------------------
      IF (NOMGD(1:5).NE.'VARI_') THEN
        CALL KNINCL(8,LCMP2,NCMP,ZK8(JCMPGD),NCMPMX,I1)
        IF (I1.GT.0) THEN
           VALK(1) = LCMP2(I1)
           VALK(2) = NOMGD
           CALL U2MESK('A','POSTRELE_56', 2 ,VALK)
          IRET = 3
          GO TO 30
        END IF
      ELSE
C       -- POUR NOMGD=VARI_* : CMP='V1','V2',..,'V999'
        DO 20,K = 1,NCMP
          CALL LXLIIS(LCMP2(K) (2:8),IBID,I1)
          IF ((LCMP2(K) (1:1).NE.'V') .OR. (I1.GT.0)) THEN
             VALK(1) = LCMP2(K)
             VALK(2) = NOMGD
             CALL U2MESK('A','POSTRELE_56', 2 ,VALK)
            IRET = 3
            GO TO 30
          END IF
   20   CONTINUE
      END IF


   30 CONTINUE
      CALL JEDEMA()

      END
