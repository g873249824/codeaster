      SUBROUTINE EXLIMA ( MOTFAZ, BASE, MODELZ, LIGREL )
      IMPLICIT   NONE
      CHARACTER*(*)       MOTFAZ, BASE, MODELZ, LIGREL
C     -----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 30/06/2008   AUTEUR PELLET J.PELLET 
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
C BUT  :  SCRUTER LES MOTS CLE TOUT/GROUP_MA/MAILLE POUR CREER
C         UN LIGREL "REDUIT" A PARTIR DU LIGREL DU MODELE MODELZ
C
C IN  : MODELZ : NOM DU MODELE
C
C OUT/JXOUT   : LIGREL  : LIGREL REDUIT
C     ATTENTION :
C          - LE NOM DE LIGREL EST TOUJOURS "OUT"
C          - PARFOIS ON REND LIGREL=LIGREL(MODELE) :
C             - ON NE TIENT DONC PAS COMPTE DE 'BASE'
C             - IL NE FAUT PAS LE DETRUIRE !
C          - PARFOIS ON EN CREE UN NOUVEAU SUR LA BASE 'BASE'
C             - LE NOM DU LIGREL EST OBTENU PAR GNOMSD
C     -----------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  -------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL,GETEXM
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  -------------------------
C
      INTEGER         I, IB, NMOFAC, N1, N2, JMA, NBMA, INUM, IRET
      CHARACTER*6     KNUM
      CHARACTER*8     MODELE, NOMA, K8BID
      CHARACTER*16    MOTFAC, MOTCLE(2), TYPMCL(2)
      CHARACTER*19    LIGRMO
      CHARACTER*24    LISMAI,NOOJB
C     -----------------------------------------------------------------
C
      MOTFAC = MOTFAZ
      MODELE = MODELZ
      CALL ASSERT(MODELE.NE.' ')

      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IB,LIGRMO,IB)
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IB,NOMA  ,IB)
      LISMAI = '&&EXLIMA.LISTE_MAILLES'


C     --  SI ON DOIT TOUT PRENDRE , LIGREL=LIGRMO
C     ------------------------------------------------------
      IF ( MOTFAC .NE. ' ' ) THEN
         CALL GETFAC( MOTFAC, NMOFAC )
         IF ( NMOFAC .EQ. 0 )  GOTO 9998
            DO 10 I = 1 , NMOFAC
               IF (GETEXM(MOTFAC,'TOUT')) THEN
                 CALL GETVTX ( MOTFAC, 'TOUT' , I,1,0, K8BID, N1 )
                 IF ( N1 .NE. 0 )  GOTO 9998
               ENDIF
 10         CONTINUE
      ELSE
         CALL GETVTX ( ' ', 'TOUT' , 1,1,0, K8BID, N1 )
         IF (N1.NE.0)  GOTO 9998
      ENDIF



      MOTCLE(1) = 'GROUP_MA'
      MOTCLE(2) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
C
C --- CREATION ET AFFECTATION DU VECTEUR DE K8 DE NOM LISMAI
C     CONTENANT LES NOMS DES MAILLES FORMANT LE LIGREL A CREER
C     --------------------------------------------------------
      CALL RELIEM ( MODELE, NOMA, 'NU_MAILLE', MOTFAC,1, 2, MOTCLE(1),
     &              TYPMCL(1), LISMAI, NBMA )

C     -- SI LES MOTS CLES GROUP_MA ET MAILLE N'ONT PAS ETE UTILISES:
      IF (NBMA.EQ.0) GOTO 9998


C
C --- CREATION DU LIGREL
C     ---------------------------------
      NOOJB='12345678.LIGR000000.LIEL'
      CALL GNOMSD(NOOJB,14,19)
      LIGREL=NOOJB(1:19)
C     -- POUR LE CAS D'UNE COMMANDE SANS CONCEPT "OUT" :
      IF (LIGREL(1:8).EQ.' ') LIGREL(1:8)='&&EXLIMA'
      CALL JEVEUO ( LISMAI, 'L', JMA )
      CALL EXLIM1 ( ZI(JMA), NBMA, MODELE, BASE, LIGREL)
      CALL JEDETR ( LISMAI )
      GOTO 9999


 9998 CONTINUE
      LIGREL = LIGRMO

 9999 CONTINUE

C
      END
