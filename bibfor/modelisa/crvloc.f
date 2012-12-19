      SUBROUTINE CRVLOC(DIM,ADCOM0,IATYMA,CONNEX,VGELOC,NVTOT,NVOIMA,
     &                  NSCOMA,TOUVOI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C    CRER LES DONNEES DU VOISINAGE LOCAL VGELOC D UN ELEMENT
C    A PARTIR DE TOUVOI
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      INTEGER ADCOM0,IATYMA,NVTOT,NVOIMA,NSCOMA
      INTEGER TOUVOI(1:NVOIMA,1:NSCOMA+2)
      INTEGER DIM
      INTEGER VGELOC(*)
C
      INTEGER PTVOIS,MV,ADCOMV,IRET,NBNOMV,NBSOMV,NSCO,IS,IV,TYVOI,
     &        NUSGLO,NUSLO0,NUSLOV
      CHARACTER*8 TYPEMV,K8B
      CHARACTER*24 CONNEX

C
C   IATYME  ADRESSE JEVEUX DES YEPES DE MAILLE
C  NSCO NOMBE DE SOMMETS COMMUNS
C  MV   MAILLE VOISINE
C  PTVOIS POITEUR SUR LES DONNEES DE VOISINAGE
C
C  TYVOI
C        3D PAR FACE    : F3 : 1
C        2D PAR FACE    : F2 : 2
C        3D PAR ARRETE  : A3 : 3
C        2D PAR ARRETE  : A2 : 4
C        1D PAR ARRETE  : A1 : 5
C        3D PAR SOMMET  : S3 : 6
C        2D PAR SOMMET  : S2 : 7
C        1D PAR SOMMET  : S1 : 8
C        0D PAR SOMMET  : S0 : 9

      VGELOC(1)=NVTOT
      IF (NVTOT.GE.1) THEN
        VGELOC(2)=2+NVTOT
        DO 20 IV=1,NVTOT
          PTVOIS=VGELOC(IV+1)
          MV=TOUVOI(IV,1)
C
C RECUPERAION DONNEES DE LA MAILLE MV
C
C SA CONECTIVITE
          CALL JEVEUO(JEXNUM(CONNEX,MV),'L',ADCOMV)
C  SON TYPE
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IATYMA-1+MV)),TYPEMV)
C  SON NOMBRE DE NOEUDS
          CALL DISMOI('F','NBNO_TYPMAIL',TYPEMV,'TYPE_MAILLE',NBNOMV,
     &                K8B,IRET)
C  SON NOMBRE DE SOMMETS
          CALL NBSOMM(TYPEMV,NBSOMV)
C
          NSCO=TOUVOI(IV,2)
C
C  DETERMINATION DU TYPE DE VOISINAGE
C
          IF (DIM.EQ.3) THEN
            IF (NSCO.GT.2) THEN
C VOISIN 3D PAR FACE
              TYVOI=1
            ELSEIF (NSCO.EQ.2) THEN
C VOISIN 3D PAR ARETE
              TYVOI=3
            ELSEIF (NSCO.EQ.1) THEN
C VOISIN 3D PAR SOMMET
              TYVOI=6
            ENDIF
          ELSE
            IF (NSCO.EQ.2) THEN
C VOISIN 2D PAR ARETE
              TYVOI=4
            ELSEIF (NSCO.EQ.1) THEN
C VOISIN 2D PAR SOMMET
              TYVOI=7
            ENDIF
          ENDIF
          VGELOC(PTVOIS)=TYVOI
          VGELOC(PTVOIS+1)=MV
          VGELOC(PTVOIS+2)=NBNOMV
          VGELOC(PTVOIS+3)=NSCO
          DO 10 IS=1,NSCO
            NUSLO0=TOUVOI(IV,2+IS)
            NUSGLO=ZI(ADCOM0+NUSLO0-1)
            VGELOC(PTVOIS+3+2*IS-1)=NUSLO0
            CALL SOMLOC(MV,ADCOMV,NBSOMV,NUSGLO,NUSLOV)
            VGELOC(PTVOIS+3+2*IS)=NUSLOV
   10     CONTINUE
          IF (IV.LT.NVTOT) THEN
            VGELOC(IV+2)=PTVOIS+4+2*NSCO
          ENDIF
   20   CONTINUE
      ENDIF

      END
