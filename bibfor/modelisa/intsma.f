      SUBROUTINE INTSMA(DIME  ,PRECCP,ITEMAX,
     &                  TMSC  ,WG    ,NG    ,FG    ,
     &                  SC    ,IS    ,
     &                  TM1   ,NO1   ,NN1   ,H1    ,F1    ,DF1   ,
     &                  TM2   ,NO2   ,NN2   ,H2    ,F2    ,DF2   ,
     &                  WJACG ,IRET)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C TOLE CRP_21
C
      IMPLICIT NONE
      INTEGER       NNM
      PARAMETER     (NNM = 27)
C
      INTEGER      DIME
      CHARACTER*8  TMSC
      REAL*8       SC(DIME,*)
      INTEGER      IS(DIME+1)
      INTEGER      IRET
      REAL*8       PRECCP
      INTEGER      ITEMAX
      CHARACTER*8  TM1,TM2
      REAL*8       H1,H2
      INTEGER      NN1,NN2
      INTEGER      NG
      REAL*8       NO1(DIME,*),NO2(DIME,*)
      REAL*8       FG(NG*NNM)
      REAL*8       WG(NG),WJACG(NG)
      REAL*8       F1(NG*NNM),F2(NG*NNM)
      REAL*8       DF1(3*NG*NNM),DF2(3*NG*NNM)
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CALCUL DES FNCT FORME ET DERIVEES DANS LE CAS DE
C L'INTEGRATION PAR SOUS MAILLES
C
C ----------------------------------------------------------------------
C
C
C PAR NNM    : NOMBRE MAXI DE NOEUDS PAR MAILLE
C IN  PRECCP : PRECISION POUR LE NEWTON (PROJ. SUR MAILLE REF.)
C IN  ITEMAX : NBRE. ITER. MAX. POUR LE NEWTON (PROJ. SUR MAILLE REF.)
C IN  SC     : COORDONNNEES DES NOEUDS DU TRIANGLE/TETRAEDRE
C IN  IS     : CONNECTIVITE DU TRIANGLE/TETRAEDRE
C              *** EN 2D
C              CONNECTIVITE TRIANGULATION
C                (SOMMET.1.1,SOMMET.1.2,SOMMET.1.3)
C              *** EN 3D
C              CONNECTIVITE TETRAEDRISATION
C                (SOMMET.1.1,SOMMET.1.2,SOMMET.1.3,SOMMET.1.4)
C              L'INDEX DU SOMMET SE REFERE A SC
C IN  INDTRV : INDEX DANS LES VECTEURS DE TRAVAIL
C IN  WG     : POIDS DES PTS DE GAUSS DE LA MAILLE D'INTEGRATION
C IN  TMSC   : TYPE DE LA MAILLE SUPPORT
C IN  NG     : NOMBRE DE PTS DE GAUSS DE LA MAILLE D'INTEGRATION
C IN  FG     : FCT. FORMES AUX PTS DE GAUSS DE LA MAILLE D'INTEGRATION
C IN  TM1    : TYPE DE LA PREMIERE MAILLE
C IN  NO1    : COORDONNEES DES NOEUDS DE LA PREMIERE MAILLE
C IN  NN1    : NOMBRE DE NOEUDS DE LA PREMIERE MAILLE
C IN  H1     : DIAMETRE DE LA PREMIERE MAILLE
C IN  TM2    : TYPE DE LA SECONDE MAILLE
C IN  NO2    : COORDONNEES DES NOEUDS DE LA SECONDE MAILLE
C IN  NN2    : NOMBRE DE NOEUDS DE LA SECONDE MAILLE
C IN  H2     : DIAMETRE DE LA SECONDE MAILLE
C OUT DF1    : DERIV. FCT. FORMES AUX PTS DE GAUSS DE LA MAILLE 1
C OUT DF2    : DERIV. FCT. FORMES AUX PTS DE GAUSS DE LA MAILLE 2
C OUT F1     : FCT. FORMES AUX PTS DE GAUSS DE LA MAILLE 1
C OUT F2     : FCT. FORMES AUX PTS DE GAUSS DE LA MAILLE 2
C OUT WJACG  : POIDS*JACOBIEN DES PTS DE GAUSS
C OUT IRET   : CODE RETOUR - DIFFERENT DE ZERO SI PROBLEME
C
C ----------------------------------------------------------------------
C
      REAL*8        PREC1,PREC2
      INTEGER       P0,P1,P2,P3,P4
      INTEGER       IPG,NNS
      LOGICAL       IFORM,PROJOK
      REAL*8        VOLMAI,R8BID ,DDOT,PROVE2,VECAD(3),PABAC(3)
      REAL*8        PGREEL(3*NG),PGPAR1(3),PGPAR2(3)
      REAL*8        N2DA(2),N2DB(2),N2DC(2)
      REAL*8        N3DA(3),N3DB(3),N3DC(3),N3DD(3)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      IRET  = 0
      IFORM = .TRUE.
      PREC1 = H1*PRECCP
      PREC2 = H2*PRECCP
      P0    = 1
      P1    = 1
      P2    = 1
      P3    = 1
      P4    = 1
C
C --- TYPE DE MAILLE SUPPORT: NBRE NOEUDS NNS
C
      IF (TMSC(1:5).EQ.'TRIA3') THEN
        IF (DIME.EQ.3) THEN
          CALL ASSERT(.FALSE.)
        ELSE
          NNS = 3
        ENDIF
      ELSEIF (TMSC(1:6).EQ.'TETRA4') THEN
        IF (DIME.EQ.2) THEN
          CALL ASSERT(.FALSE.)
        ELSE
          NNS = 4
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- CALCUL DU VOLUME DU TRIANGLE OU TETRAEDRE
C
      IF (DIME.EQ.2) THEN
        N2DA(1)  = SC(1,IS(1))
        N2DB(1)  = SC(1,IS(2))
        N2DC(1)  = SC(1,IS(3))
        N2DA(2)  = SC(2,IS(1))
        N2DB(2)  = SC(2,IS(2))
        N2DC(2)  = SC(2,IS(3))
        VOLMAI   = ABS(PROVE2(N2DA,N2DB,N2DC))
      ELSE
        N3DA(1)  = SC(1,IS(1))
        N3DB(1)  = SC(1,IS(2))
        N3DC(1)  = SC(1,IS(3))
        N3DD(1)  = SC(1,IS(4))
        N3DA(2)  = SC(2,IS(1))
        N3DB(2)  = SC(2,IS(2))
        N3DC(2)  = SC(2,IS(3))
        N3DD(2)  = SC(2,IS(4))
        N3DA(3)  = SC(3,IS(1))
        N3DB(3)  = SC(3,IS(2))
        N3DC(3)  = SC(3,IS(3))
        N3DD(3)  = SC(3,IS(4))
        VECAD(1) = N3DD(1) - N3DA(1)
        VECAD(2) = N3DD(2) - N3DA(2)
        VECAD(3) = N3DD(3) - N3DA(3)
        CALL PROVE3(N3DA,N3DB,N3DC,PABAC)
        VOLMAI = ABS(DDOT(3,VECAD,1,PABAC,1))
      ENDIF
C
C --- CALCUL DES FNCT FORME ET DERIVEES POUR LES DEUX MAILLES
C
      DO 100 IPG = 1, NG

C
C --- PGREEL: COORD PT GAUSS DS ESPACE REEL
C
        CALL MTPROD(SC    ,DIME  ,0,DIME,IS    ,NNS   ,
     &              FG(P0),1     ,0,1   ,0     ,
     &              PGREEL)
C
        WJACG(IPG) = WG(IPG) * VOLMAI
C
C --- PGPAR1: COORD PT GAUSS DS ESPACE PARAMETRIQUE MAILLE 1
C --- F1    : FCT. FORME SUR MAILLE 1 EN PGPAR1
C
        CALL REFERE(PGREEL,NO1   ,DIME  ,TM1   ,PREC1,
     &              ITEMAX,IFORM ,PGPAR1,PROJOK,F1(P1))
        IF (.NOT.PROJOK) THEN
          IRET = 1
          GOTO 140
        ENDIF
C
C --- PGPAR2: COORD PT GAUSS DS ESPACE PARAMETRIQUE MAILLE 2
C --- F2    : FCT. FORME SUR MAILLE 2 EN PGPAR2
C
        CALL REFERE(PGREEL     ,NO2   ,DIME  ,TM2   ,PREC2,
     &              ITEMAX,IFORM ,PGPAR2    ,PROJOK,F2(P2))
C
        IF (.NOT.PROJOK) THEN
          IRET = 1
          GOTO 140
        ENDIF
C
C --- DF1   : DERIV./PARAM FCT. FORME SUR MAILLE 1 EN PGPAR1
C
        CALL FORME1(PGPAR1 ,TM1   ,DF1(P3),NN1   ,DIME)
C
C --- CALCUL DU JACOBIEN DE LA MAILLE 1
C
        CALL MTPROD(NO1    ,DIME  ,0      ,DIME  ,0,NN1,
     &              DF1(P3),DIME  ,0      ,DIME  ,0,
     &              PGREEL)
C
C --- DF1   : DERIV./REEL FCT. FORMES AUX PTS DE GAUSS DE LA MAILLE 1
C
        CALL MGAUSS('TFVP' ,PGREEL    ,DF1(P3),DIME,DIME,
     &              NN1    ,R8BID,IRET)
C
C --- DF2   : DERIV./PARAM FCT. FORME SUR MAILLE 2 EN PGPAR2
C
        CALL FORME1(PGPAR2 ,TM2   ,DF2(P4),NN2   ,DIME)
C
C --- CALCUL DU JACOBIEN DE LA MAILLE 2
C
        CALL MTPROD(NO2    ,DIME  ,0      ,DIME  ,0,NN2,
     &              DF2(P4),DIME  ,0      ,DIME  ,0,
     &              PGREEL)
C
C --- DF2   : DERIV./REEL FCT. FORMES AUX PTS DE GAUSS DE LA MAILLE 2
C
        CALL MGAUSS('TFVP' ,PGREEL    ,DF2(P4),DIME,DIME,
     &              NN2    ,R8BID,IRET)
C
        P0 = P0 + NNS
        P1 = P1 + NN1
        P2 = P2 + NN2
        P3 = P3 + DIME*NN1
        P4 = P4 + DIME*NN2
 100  CONTINUE
C
 140  CONTINUE
C
      CALL JEDEMA()

      END
