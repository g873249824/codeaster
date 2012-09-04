      SUBROUTINE CONTEX(NOMOP,NOMPAR)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/09/2012   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE PELLET J.PELLET
      INCLUDE 'jeveux.h'
      CHARACTER*(*) NOMOP,NOMPAR
C     -----------------------------------------------------------------
C     BUT:
C     ---
C     IMPRIMER DANS LE FICHIER 'MESSAGE' DES INFORMATIONS CONCERNANT
C     LE CONTEXTE D'UNE ERREUR survenue dans un calcul elementaire  :
C     ON PEUT DONNER :
C      - LE NOM D'UNE OPTION (NOMOP)
C      - LE NOM D'UN PARAMETRE DE L'OPTION (NOMPAR)


C     ENTREES:
C     --------
C NOMOP   : NOM D'UNE OPTION DE CALCUL ELEMENTAIRE  (OU ' ')
C NOMPAR  : NOM D'UN PARAMETRE D'OPTION DE CALCUL ELEMENTAIRE (OU ' ')


      CHARACTER*8 NOMPA2,NOMAIL,NOMGD
      INTEGER JCLIBR,JDESOP,IAPARA,NBIN,NBOU,IADZI,IAZK24
      INTEGER NBLIG,INDIC,K,ITROU,INDIK8,IOPT,IGD,JDSGD
      LOGICAL LOPT,LPARA,LGD


      CALL TECAEL(IADZI,IAZK24)
      NOMAIL=ZK24(IAZK24-1+3)(1:8)

      CALL U2MESK('I','CALCULEL5_15',1,NOMAIL)

      CALL JEVEUO('&CATA.CL.COMLIBR','L',JCLIBR)

      NOMPA2=NOMPAR
      IGD=0


C   1) CONTEXTE DE l'OPTION :
C   -------------------------
C     CALCUL DE LOPT ET IOPT :
      IF (NOMOP.NE.' ') THEN
        CALL JENONU(JEXNOM('&CATA.OP.NOMOPT',NOMOP),IOPT)
      ELSE
        IOPT=0
      ENDIF
      LOPT=(IOPT.NE.0)

      IF (LOPT) THEN
        CALL U2MESK('I','CALCULEL5_16',1,NOMOP)
        CALL JEVEUO(JEXNUM('&CATA.OP.DESCOPT',IOPT),'L',JDESOP)
        CALL JEVEUO(JEXNUM('&CATA.OP.OPTPARA',IOPT),'L',IAPARA)

        NBIN=ZI(JDESOP-1+2)
        NBOU=ZI(JDESOP-1+3)
        NBLIG=ZI(JDESOP-1+4+NBIN+NBOU+1)
        INDIC=ZI(JDESOP-1+4+NBIN+NBOU+2)
        IF (NBLIG.GT.0) THEN
          DO 10,K=INDIC,INDIC-1+NBLIG
            CALL U2MESK('I','CALCULEL5_17',1,ZK80(JCLIBR-1+K))
   10     CONTINUE
        ENDIF
      ENDIF



C   2) CONTEXTE DU PARAMETRE :
C   --------------------------
C     CALCUL DE LPARA :
      LPARA=LOPT .AND. (NOMPA2.NE.' ')

      IF (LPARA) THEN
        ITROU=INDIK8(ZK8(IAPARA-1+1),NOMPA2,1,NBIN)
        IF (ITROU.GT.0) THEN
          CALL U2MESK('I','CALCULEL5_18',1,NOMPA2)
          NBLIG=ZI(JDESOP-1+6+NBIN+NBOU+2*(ITROU-1)+1)
          INDIC=ZI(JDESOP-1+6+NBIN+NBOU+2*(ITROU-1)+2)
          IGD=ZI(JDESOP-1+4+ITROU)
        ELSE
          ITROU=INDIK8(ZK8(IAPARA-1+NBIN+1),NOMPA2,1,NBOU)
          CALL ASSERT(ITROU.GT.0)
          CALL U2MESK('I','CALCULEL5_19',1,NOMPA2)
          NBLIG=ZI(JDESOP-1+6+3*NBIN+NBOU+2*(ITROU-1)+1)
          INDIC=ZI(JDESOP-1+6+3*NBIN+NBOU+2*(ITROU-1)+2)
          IGD=ZI(JDESOP-1+4+NBIN+ITROU)
        ENDIF
        IF (NBLIG.GT.0) THEN
          DO 20,K=INDIC,INDIC-1+NBLIG
            CALL U2MESK('I','CALCULEL5_17',1,ZK80(JCLIBR-1+K))
   20     CONTINUE
        ENDIF
      ENDIF



C   3) CONTEXTE DE LA GRANDEUR :
C   ----------------------------
      LGD=(IGD.NE.0)
      IF (LGD) THEN
        CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',IGD),NOMGD)
C       -- ON N'IMPRIME RIEN POUR ADRSJEVE !
        IF (NOMGD.NE.'ADRSJEVE') THEN
          CALL U2MESK('I','CALCULEL5_22',1,NOMGD)
          CALL JEVEUO(JEXNUM('&CATA.GD.DESCRIGD',IGD),'L',JDSGD)
          NBLIG=ZI(JDSGD-1+6)
          INDIC=ZI(JDSGD-1+7)
          IF (NBLIG.GT.0) THEN
            DO 30,K=INDIC,INDIC-1+NBLIG
              CALL U2MESK('I','CALCULEL5_17',1,ZK80(JCLIBR-1+K))
   30       CONTINUE
          ENDIF
        ENDIF

      ENDIF
      CALL U2MESS('I','CALCULEL5_23')

      CALL ASSERT(.FALSE.)

      END
