      SUBROUTINE EXCHEM(MODLOC,TCMP,NBC,NBSP,TVALE,VALCMP,TABERR)
      IMPLICIT NONE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      INTEGER MODLOC(*),TCMP(*),NBC,TABERR(*),NBSP
      REAL*8  TVALE(*),VALCMP(*)
C
C*********************************************************************
C
C     OPERATION REALISEE
C     ------------------
C
C       EXTRACTION DES VALEURS D' UN ENSEMBLE DE COMPOSANTES SUR LES
C       NOEUDS D' UNE MAILLE DANS UN CHAM_ELEM
C
C     ARGUMENTS EN ENTREES
C     --------------------
C
C       MODLOC : VECTEUR MODE LOCALE DU TYPE D' ELEMENT DEFINI
C                SUR LA MAILLE
C
C                  (1) --> CODE (ICI TJS 3 : CAS DU CHAM_ELEM)
C
C                  (2) --> NUMERO DE LA GRANDEUR
C
C                  (3) --> NBR DE SCALAIRES UTILISES POUR DECRIRE
C                          LE CHAM_ELEM DE LA GRANDEUR SUR LA MAILLE
C
C                  (4) --> ACCES AU NBR DE POINTS UTILISES POUR LA
C                          DESCRIPTION
C
C                  (5) --> DEBUT DES DESCRIPTEURS PAR ENTIERS CODES
C
C
C       TCMP   : TABLE DES NUMEROS DES CMP ACTIVES POUR L' EXTRACTION
C       NBC    : NBR DE CMP ACTIVES
C       NBSP   : NBR DE SOUS-POINTS
C       TAVLE  : TABLE DES VALEURS DU CHAM_ELEM SUR LA MAILLE
C
C     ARGUMENTS EN SORTIE
C     -------------------
C
C       VALCMP : TABLE DES VALEURS DES CMP EXTRAITES
C
C*********************************************************************
C
      INTEGER GD,NBPT,NBNMAI,ACPACT,NBEC,ADESGD
      INTEGER NBRCPA,ADRND,ASGTND,APOSCP,POSCMP,I,J,K
C
C   FONCTIONS EXTERNES
C   ------------------
C
C
C   -------------------------
C
C
C======================================================================
C
C-----------------------------------------------------------------------
      INTEGER IPOSDG
      REAL*8 R8VIDE
C-----------------------------------------------------------------------
      CALL JEMARQ()
      GD = MODLOC(2)
C
      CALL JEVEUO(JEXNUM('&CATA.GD.DESCRIGD',GD),'L',ADESGD)
C
      NBEC   = ZI(ADESGD + 3-1)
      NBPT   = MODLOC(4)
C
C     /* PAR HYP. D' APPEL : LE CHAMP EST REPRESENTE AUX NOEUDS */
C     /* DONC, MODLOC(4) < 0                                    */
C
      CALL NCPACT(MODLOC(5),NBEC,NBRCPA)
C
      IF ( NBPT .GT. 10000 ) THEN
C
C        /* CAS D' UNE REPRESENTATION VARIANT AVEC  LES NOEUDS */
C
         NBNMAI =  NBPT - 10000
C
         CALL WKVECT('&&EXCHEM.NBRCMPACTIVE','V V I',NBNMAI,    ACPACT)
         CALL WKVECT('&&EXCHEM.ADRSGTNOEUD' ,'V V I',NBNMAI,    ASGTND)
         CALL WKVECT('&&EXCHEM.POSCMP'      ,'V V I',NBC*NBNMAI,APOSCP)
C
         ZI(ASGTND + 1-1) = 1
         ZI(ACPACT + 1-1) = NBRCPA
C
         DO 5, K = 1, NBC, 1
            I=1
            ZI(APOSCP+K-1) = IPOSDG(MODLOC(5+(I-1)*NBEC),TCMP(K))
C
5        CONTINUE
C
         DO 10, I = 2, NBNMAI, 1
C
            CALL NCPACT(MODLOC(5 + NBEC*(I-1)),NBEC,NBRCPA)
C
            ZI(ASGTND + I-1) = ZI(ASGTND + I-1-1) + NBRCPA*NBSP
            ZI(ACPACT + I-1) = NBRCPA
C
            ADRND = (I-1)*NBC
C
            DO 11, K = 1, NBC, 1
C
               ZI(APOSCP+ADRND+K-1)=IPOSDG(MODLOC(5+(I-1)*NBEC),TCMP(K))
C
11          CONTINUE
C
10       CONTINUE
C
      ELSE
C
C        /* CAS D' UNE REPRESENTATION CONSTANTES SUR LES NOEUDS */
C
         NBNMAI =  NBPT
C
         CALL WKVECT('&&EXCHEM.NBRCMPACTIVE','V V I',NBNMAI,    ACPACT)
         CALL WKVECT('&&EXCHEM.ADRSGTNOEUD' ,'V V I',NBNMAI,    ASGTND)
         CALL WKVECT('&&EXCHEM.POSCMP'      ,'V V I',NBC*NBNMAI,APOSCP)
C
         DO 20, I = 1, NBNMAI, 1
C
            ZI(ASGTND + I-1) = (I-1)*NBRCPA*NBSP + 1
            ZI(ACPACT + I-1) = NBRCPA
C
            ADRND = (I-1)*NBC
C
            DO 21, K = 1, NBC, 1
C
               ZI(APOSCP + ADRND + K-1) = IPOSDG(MODLOC(5),TCMP(K))
C
21          CONTINUE
C
20       CONTINUE
C
      ENDIF
C
      DO 100, I = 1, NBNMAI, 1
C
         ADRND  = ZI(ASGTND + I-1)
         NBRCPA = ZI(ACPACT + I-1)
C
         DO 110, J = 1, NBSP, 1
C
            DO 120, K = 1, NBC, 1
C
               POSCMP = ZI(APOSCP + (I-1)*NBC + K-1)
C
               IF ( POSCMP .GT. 0 ) THEN
C
                  VALCMP(((I-1)*NBSP + J-1)*NBC+K) =
     +                            TVALE(ADRND + (J-1)*NBRCPA + POSCMP-1)
C
                  TABERR(K) = 1
C
               ELSE
C
                  VALCMP(((I-1)*NBSP + J-1)*NBC+K) = R8VIDE()
C
                  TABERR(K) = 0
C
               ENDIF
C
120         CONTINUE
C
110      CONTINUE
C
100   CONTINUE
C
      CALL JEDETR('&&EXCHEM.NBRCMPACTIVE')
      CALL JEDETR('&&EXCHEM.ADRSGTNOEUD' )
      CALL JEDETR('&&EXCHEM.POSCMP'      )
C
      CALL JEDEMA()
      END
