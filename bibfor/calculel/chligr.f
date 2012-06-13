      SUBROUTINE CHLIGR(CHEL1Z,LIGR2Z,OPTIOZ,PARAMZ,BASE2,CHEL2Z)
      IMPLICIT NONE

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
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      CHARACTER*19 LIGR2,CHEL2,CHEL1,OPTIO,PARAM
      CHARACTER*(*) LIGR2Z,CHEL2Z,CHEL1Z,BASE2,OPTIOZ,PARAMZ
C ----------------------------------------------------------------------
C BUT :
C       "CONVERTIR" UN CHAM_ELEM (CHEL1Z) EN UN AUTRE CHAM_ELEM (CHEL2Z)
C       SUR UN AUTRE LIGREL (LIGR2Z).
C       CETTE ROUTINE DEVRAIT POUVOIR TRAITER DES RESUELEM MAIS CE N'EST
C       PAS IMPLEMENTE.

C  ATTENTION :
C  -----------
C  1) CETTE ROUTINE NE SAIT PAS TRAITER LES ELEMENTS DE LIGR2Z DONT
C     LES MAILLESSONT TARDIVES
C  2) SUR LES ELEMENTS DE LIGRE2 QUI N'ETAIENT PAS DANS LIGRE1
C     LE CHAMP EST PROLONGE PAR 0.
C  3) IL NE FAUT PAS APPELER CETTE ROUTINE AVEC LE MEME NOM POUR
C     CHEL1 ET CHEL2
C  4) SI CHEL2 EST VIDE, LA ROUTINE N'EMET AUCUN MESSAGE, C'EST A
C     L'APPELANTDE TESTER L'EXISTENCE REELLE DU CHAMP RESULTAT
C ----------------------------------------------------------------------

C ARGUMENTS :
C  CHEL1  IN/JXIN  K19 : NOM DU CHAM_ELEM A CONVERTIR
C  CHEL2  IN/JXOUT K19 : NOM DU CHAM_ELEM RESULTAT
C                        CHEL2 EST DETRUIT S'IL EXISTE DEJA
C  LIGR2  IN/JXIN  K19 : NOM DU LIGREL SUR LEQUEL ON VA CREER CHEL2
C  OPTIO  IN       K16 : NOM DE L'OPTION SERVANT A ALLOUER CHEL2
C  PARAM  IN       K8  : NOM DU PARAMETRE DE L'OPTION SERVANT
C                        A ALLOUER CHEL2
C  BASE2  IN       K1  : 'G', 'V' OU 'L' : BASE DE CREATION DE CHEL2
C ----------------------------------------------------------------------


C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*4 TYCH
      CHARACTER*24 VALK(3)
      CHARACTER*8 NOMA,MA,KBID
      CHARACTER*16 FPG1,FPG2
      CHARACTER*19 CES,CHELV
      INTEGER IBID,NBMA,IMA,J1,J2,IRET1,IRET2,IRET,NNCP


      CALL JEMARQ()
      LIGR2 = LIGR2Z
      CHEL2 = CHEL2Z
      CHEL1 = CHEL1Z
      OPTIO = OPTIOZ
      PARAM = PARAMZ

      CALL JEEXIN(CHEL1//'.DESC',IBID)
      IF (IBID.GT.0) THEN
        CALL JELIRA(CHEL1//'.DESC','DOCU',IBID,TYCH)

      ELSE
        CALL JELIRA(CHEL1//'.CELD','DOCU',IBID,TYCH)
      ENDIF

C     TEST :
C     SI TYCH='RESL' : ON NE SAIT PAS TRAITER LES RESUELEM
C     SINON          : TYPE DE CHAMP INTERDIT
      CALL ASSERT(TYCH.EQ.'CHML')

C     -- SI LE CHAM_ELEM CHEL1 EST "ELGA", ON VERIFIE LA COHERENCE
C        DES FAMILLES DE POINTS DE GAUSS :
C     ------------------------------------------------------------
      CALL CELFPG(CHEL1,'&&CHLIGR.FAPG1',IBID)
      CALL JEEXIN('&&CHLIGR.FAPG1',IRET1)
      IF (IRET1.GT.0) THEN
        CHELV = '&&CHLIGR.CHELVIDE'
        CALL ALCHML(LIGR2,OPTIO,PARAM,'V',CHELV,IRET,' ')
        IF (IRET.NE.0)  GOTO 20

        CALL CELFPG(CHELV,'&&CHLIGR.FAPG2',IBID)
        CALL JEEXIN('&&CHLIGR.FAPG2',IRET2)
        CALL ASSERT(IRET2.GT.0)
        CALL JEVEUO('&&CHLIGR.FAPG1','L',J1)
        CALL JEVEUO('&&CHLIGR.FAPG2','L',J2)
        CALL JELIRA('&&CHLIGR.FAPG1','LONMAX',NBMA,KBID)
        DO 10,IMA = 1,NBMA
          FPG1 = ZK16(J1-1+IMA)
          FPG2 = ZK16(J2-1+IMA)
          IF ((FPG1.NE.' ') .AND. (FPG2.NE.' ') .AND.
     &        (FPG2.NE.FPG1)) THEN
            CALL DISMOI('F','NOM_MAILLA',CHEL1,'CHAM_ELEM',IBID,MA,IBID)
            CALL JENUNO(JEXNUM(MA//'.NOMMAI',IMA),NOMA)
            VALK(1) = NOMA
            VALK(2) = FPG1
            VALK(3) = FPG2
            CALL U2MESK('F','CALCULEL_91',3,VALK)
          ENDIF
   10   CONTINUE
        CALL JEDETR('&&CHLIGR.FAPG2')
        CALL DETRSD('CHAM_ELEM',CHELV)
      ENDIF


C     -- ON TRANSFORME LE CHAM_ELEM CHEL1 EN CHAM_ELEM_S :
      CES = '&&CHLIGR.CES'
      CALL CELCES(CHEL1,'V',CES)


C     -- ON TRANSFORME LE CHAM_ELEM_S EN CHEL2 :
      CALL CESCEL(CES,LIGR2,OPTIO,PARAM,'CHL',NNCP,BASE2,CHEL2,'F',IBID)
      CALL DETRSD('CHAM_ELEM_S',CES)


   20 CONTINUE
      CALL JEDETR('&&CHLIGR.FAPG1')
      CALL JEDEMA()
      END
