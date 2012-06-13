      SUBROUTINE CESCNS(CESZ,CELFPZ,BASE,CNSZ,COMP,CRET)
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) CNSZ,CESZ,BASE,CELFPZ
      CHARACTER*1   COMP
      INTEGER       CRET
C ------------------------------------------------------------------
C BUT: TRANSFORMER UN CHAM_ELEM_S EN CHAM_NO_S
C ------------------------------------------------------------------
C     ARGUMENTS:
C CESZ   IN/JXIN  K19 : SD CHAM_ELEM_S A TRANSFORMER

C CELFPZ IN/JXIN  K24 :
C    NOM DE L'OBJET DECRIVANT LES FAMILLES DE P.G. DE CESZ (OU ' ')
C    CET OBJET N'EST UTILISE QUE SI CESZ EST 'ELGA'
C    CET OBJET EST OBTENU PAR LA ROUTINE CELFPG.F

C CNSZ   IN/JXOUT K19 : SD CHAM_NO_S RESULTAT
C BASE   IN       K1  : BASE DE CREATION POUR CNSZ : G/V/L
C COMP   IN           : COMPORTEMENT EN PRESENCE DE SOUS-POINTS
C    'F' : EMISSION D'UNE ERREUR <F>
C    'A' : EMISSION D'UNE ALARME POUR PREVENIR L'UTILISATEUR
C    ' ' : SILENCE => CODE RETOUR
C CRET   OUT      I   : CODE RETOUR
C    0   : SI TOUT EST OK
C    100 : EN PRESENCE D'UN CHAMP ELEM A SOUS-POINTS
C-----------------------------------------------------------------------

C  PRINCIPES RETENUS POUR LA CONVERSION :

C  1) ON NE TRAITE QUE LES CHAM_ELEM_S REELS OU COMPLEXES

C  2) ON SE RAMENE TOUJOURS A UN CHAMP ELNO
C     PUIS ON FAIT LA MOYENNE ARITHMETIQUE DES MAILLES
C     QUI CONCOURRENT EN 1 MEME NOEUD.

C  3) S'IL Y A DES SOUS POINTS, ON S'ARRETE EN ERREUR <F>

C-----------------------------------------------------------------------
C     ------------------------------------------------------------------
      INTEGER      IMA,IBID,NCMP,ICMP,JCNSL,JCNSV,ISPT
      INTEGER      JCESD,JCESV,JCESL,NBMA,IRET,NBNO
      INTEGER      INO,NUNO,NBPT,IAD1,ILCNX1,IACNX1
      INTEGER      JCESK,JCESC,NBNOT,JNBNO,IEQ,NBSP
      CHARACTER*1  KBID
      CHARACTER*3  TSCA
      CHARACTER*8  MA,NOMGD
      CHARACTER*19 CES,CNS,CES1
C     ------------------------------------------------------------------
      CALL JEMARQ()

      CES = CESZ
      CNS = CNSZ

      CALL JEVEUO(CES//'.CESK','L',JCESK)

C     1- ON TRANSFORME CES EN CHAM_ELEM_S/ELNO:
C     --------------------------------------------
      CES1 = '&&CESCNS.CES1'
      CALL CESCES(CES,'ELNO',' ',' ',CELFPZ,'V',CES1)


C     2. RECUPERATION DE :
C        MA     : NOM DU MAILLAGE
C        NOMGD  : NOM DE LA GRANDEUR
C        NCMP   : NOMBRE DE CMPS DE CES1
C        TSCA   : TYPE SCALAIRE DE LA GRANDEUR : R/C
C        NBMA   : NOMBRE DE MAILLES DU MAILLAGE
C        ILCNX1,IACNX1   : ADRESSES DE LA CONNECTIVITE DU MAILLAGE
C     --------------------------------------------------------------
      CALL EXISD('CHAM_ELEM_S',CES1,IRET)
      CALL ASSERT(IRET.GT.0)
      CALL JEVEUO(CES1//'.CESK','L',JCESK)
      CALL JEVEUO(CES1//'.CESC','L',JCESC)
      CALL JEVEUO(CES1//'.CESD','L',JCESD)
      CALL JEVEUO(CES1//'.CESV','L',JCESV)
      CALL JEVEUO(CES1//'.CESL','L',JCESL)
      MA = ZK8(JCESK-1+1)
      NOMGD = ZK8(JCESK-1+2)
C     TEST SI CHAMP ELNO
      CALL ASSERT(ZK8(JCESK-1+3).EQ.'ELNO')
      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,KBID,IBID)
      CALL DISMOI('F','NB_NO_MAILLA',MA,'MAILLAGE',NBNOT,KBID,IBID)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      CALL JEVEUO(MA//'.CONNEX','L',IACNX1)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',ILCNX1)
      CALL JELIRA(CES1//'.CESC','LONMAX',NCMP,KBID)

      CRET = 0
C     EMISSION D'UN MESSAGE POUR SIGNIFIER QU'ON VA FILTRER
C     LES MAILLES CONTENANT DES SOUS-POINTS
      IF ( ZI(JCESD-1+4).GT.1 ) THEN
        IF ( COMP.NE.' ' ) THEN
          CALL U2MESS(COMP,'UTILITAI_3')
        ELSE
          CRET = 100
        ENDIF
      ENDIF

C     ON ATTEND SEULEMENT DES REELS OU DES COMPLEXES
      CALL ASSERT((TSCA.EQ.'R').OR.(TSCA.EQ.'C'))


C     3- ALLOCATION DE CNS :
C     -------------------------------------------
      IF ( NOMGD .EQ. 'VARI_R' ) NOMGD = 'VAR2_R'
      CALL CNSCRE(MA,NOMGD,NCMP,ZK8(JCESC),BASE,CNS)


C     4- REMPLISSAGE DE CNS.CNSL ET CNS.CNSV :
C     -------------------------------------------
      CALL JEVEUO(CNS//'.CNSL','E',JCNSL)
      CALL JEVEUO(CNS//'.CNSV','E',JCNSV)

      DO 40,ICMP = 1,NCMP
        CALL JEDETR('&&CESCNS.NBNO')
        CALL WKVECT('&&CESCNS.NBNO','V V I',NBNOT,JNBNO)

        DO 20,IMA = 1,NBMA
          NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
          NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)
          NBNO = ZI(ILCNX1+IMA) - ZI(ILCNX1-1+IMA)

          CALL ASSERT(NBNO.EQ.NBPT)
          IF ( NBSP.EQ.1 ) THEN
            DO 10,INO = 1,NBNO
              CALL CESEXI('C',JCESD,JCESL,IMA,INO,1,ICMP,IAD1)
              IF (IAD1.LE.0) GO TO 10

              NUNO = ZI(IACNX1+ZI(ILCNX1-1+IMA)-2+INO)
              IEQ = (NUNO-1)*NCMP + ICMP
              ZL(JCNSL-1+IEQ) = .TRUE.
              IF (TSCA.EQ.'R') THEN
                IF(ZI(JNBNO-1+NUNO).EQ.0) ZR(JCNSV-1+IEQ)=0.D0
                ZR(JCNSV-1+IEQ) = ZR(JCNSV-1+IEQ) + ZR(JCESV-1+IAD1)
              ELSEIF (TSCA.EQ.'C') THEN
                IF(ZI(JNBNO-1+NUNO).EQ.0) ZC(JCNSV-1+IEQ)=(0.D0,0.D0)
                ZC(JCNSV-1+IEQ) = ZC(JCNSV-1+IEQ) + ZC(JCESV-1+IAD1)
              ENDIF
              ZI(JNBNO-1+NUNO) = ZI(JNBNO-1+NUNO) + 1

   10       CONTINUE
          ELSE
          DO 50,INO = 1,NBNO
            DO 60,ISPT = 1,NBSP
              CALL CESEXI('C',JCESD,JCESL,IMA,INO,ISPT,ICMP,IAD1)
              IF (IAD1.LE.0) GO TO 60
              NUNO = ZI(IACNX1+ZI(ILCNX1-1+IMA)-2+INO)
              IEQ = (NUNO-1)*NCMP + ICMP
              ZL(JCNSL-1+IEQ) = .FALSE.
   60       CONTINUE
   50     CONTINUE
          ENDIF
   20   CONTINUE

        DO 30,NUNO = 1,NBNOT
          IEQ = (NUNO-1)*NCMP + ICMP
          IF (ZL(JCNSL-1+IEQ)) THEN
            IF (TSCA.EQ.'R') THEN
              ZR(JCNSV-1+IEQ) = ZR(JCNSV-1+IEQ)/ZI(JNBNO-1+NUNO)
            ELSEIF (TSCA.EQ.'C') THEN
              ZC(JCNSV-1+IEQ) = ZC(JCNSV-1+IEQ)/ZI(JNBNO-1+NUNO)
            ENDIF
          END IF
   30   CONTINUE

   40 CONTINUE


C     7- MENAGE :
C     -----------
      CALL DETRSD('CHAM_ELEM_S',CES1)
      CALL JEDETR('&&CESCNS.NBNO')

      CALL JEDEMA()
      END
