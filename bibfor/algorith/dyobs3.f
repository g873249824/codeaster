      SUBROUTINE DYOBS3(MOTFAC,NBOCC ,NBPAS ,LSUIVI,JOBSE ,
     &                  SDDISC,NBOBSE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/11/2009   AUTEUR DESOZA T.DESOZA 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      CHARACTER*16  MOTFAC 
      INTEGER       NBOCC
      INTEGER       NBPAS
      INTEGER       JOBSE(*)
      CHARACTER*19  SDDISC
      INTEGER       NBOBSE
      LOGICAL       LSUIVI(NBOCC)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (OBSERVATION - CREATION SD)
C
C TRAITEMENT DES INSTANTS D'OBSERVATION
C
C ----------------------------------------------------------------------
C
C
C IN  MOTFAC : MOT-CLEF FACTEUR POUR OBSERVATION
C IN  NBOCC  : NOMBRE D'OCCURENCES DU MOT-CLEF FACTEUR OBSERVATION
C IN  NBPAS  : NOMBRE DE PAS DE CALCUL
C OUT JOBSE  : NUMEROS D'ORDRE DES INSTANTS A OBSERVER
C       LE VECTEUR LISBOS CREE DANS NMCROB
C       CONTIENT 1 A CHAQUE INSTANT DE CALCUL DEVANT ETRE OBSERVE
C IN  SDDISC : SD LOCALE SUR LA GESTION DE LA LISTE D'INSTANTS
C OUT NBOBSE : NOMBRE D'OBSERVATIONS
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IOCC,N1,N2,N3,N4,I,JNUM,LNUM,JINST
      INTEGER      IPACH,NUME,IBID,NN1,IPREM
      REAL*8       EPSI,R8B
      CHARACTER*8  K8B,RELA
      CHARACTER*19 NUMOBS
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- RECUPERATION DE LIST_INST D'INCREMENT DANS STAT_NON_LINE
      CALL UTDIDT('L',SDDISC,'LIST',IBID,'JINST',R8B,JINST,K8B)
C
C --- BOUCLE SOUR LES DIFFERENTES OCCURRENCES D'OBSERVATION
C
      IPREM=0
      DO 10 IOCC = 1 , NBOCC
C
         IF(LSUIVI(IOCC))GOTO 10

         CALL GETVID(MOTFAC, 'LIST_ARCH',IOCC,1,0,K8B ,N1)
         CALL GETVID(MOTFAC, 'LIST_INST',IOCC,1,0,K8B ,N2)
         CALL GETVR8(MOTFAC, 'INST'     ,IOCC,1,0,EPSI,N3)
         CALL GETVIS(MOTFAC, 'PAS_OBSE' ,IOCC,1,0,IBID,N4)

C
         IF ( IPREM .EQ. 0 ) THEN
            IPREM=1
            IF ( N1+N2+N3+N4 .EQ. 0 ) THEN
               CALL U2MESS('F','OBSERVATION_49')
            ENDIF
         ELSE
            IF ( N1+N2+N3+N4 .NE. 0 ) THEN
               CALL U2MESS('A','OBSERVATION_50')
            ENDIF
            GOTO 10
         ENDIF
C
         CALL GETVR8(MOTFAC, 'PRECISION', IOCC,1,1,EPSI,IBID)
         CALL GETVTX(MOTFAC, 'CRITERE'  , IOCC,1,1,RELA,IBID)
C
C --- TRAITEMENT DU CAS OU ON FOURNIT LA LISTE DES NUMEROS D'OBSERVATION
C
         IF ( N1 .NE. 0 ) THEN
            CALL GETVID(MOTFAC,'LIST_ARCH',IOCC,1,1,NUMOBS,N1)
            CALL JEVEUO(NUMOBS//'.VALE', 'L', JNUM )
            CALL JELIRA(NUMOBS//'.VALE', 'LONUTI', LNUM, K8B )
            DO 20 I = 1 , LNUM
               NUME = ZI(JNUM+I-1)
               IF ( NUME .LE. 0 ) THEN
                  GOTO 20
               ELSEIF ( NUME .GT. NBPAS ) THEN
                  GOTO 22
               ELSE
                  JOBSE(NUME) = 1
               ENDIF
 20         CONTINUE
 22         CONTINUE
C --- LE DERNIER PAS DE CALCUL EST TOUJOURS OBSERVE
            JOBSE(NBPAS) = 1
            GOTO 10
         ENDIF
C
C --- TRAITEMENT DU CAS OU ON FOURNIT LA LISTE DES INSTANTS
C --- D'OBSERVATION LIST_INST
C
         IF ( N2 .NE. 0 ) THEN

           CALL GETVID(MOTFAC,'LIST_INST',IOCC,1,1,NUMOBS,N2)
           CALL JEVEUO(NUMOBS//'.VALE', 'L', JNUM )
           CALL JELIRA(NUMOBS//'.VALE', 'LONUTI', LNUM, K8B )
           NN1=LNUM-1
C ON N'OBSERVE PAS L'INSTANT INITIAL, LE NUME_ORDRE 0 N'EST PAS
C PRIS EN COMPTE
           CALL DYARC1(ZR(JINST+1), NBPAS, ZR(JNUM+1), NN1, JOBSE,
     &                   EPSI, RELA  )
           GOTO 10
         ENDIF
C
C --- TRAITEMENT DU CAS OU ON FOURNIT UN INSTANT D'OBSERVATION
C
         IF ( N3 .NE. 0 ) THEN
            CALL GETVR8 (MOTFAC,'INST', IOCC,1,0, EPSI,N3)
            LNUM = -N3
            CALL WKVECT ( '&&DYOBS3.VALE_INST', 'V V R', LNUM, JNUM )
            CALL GETVR8 (MOTFAC, 'INST', IOCC,1,LNUM,
     &                                           ZR(JNUM), N3 )
C ON NE DETECTE PAS SI L'UTILISATEUR A RENSEIGNE L'INSTANT INITIAL
C SOUS OBSERVATION/INST, ON LAISSE PLANTER PROPREMENT DANS DYARC1
            CALL DYARC1 ( ZR(JINST+1), NBPAS, ZR(JNUM), LNUM, JOBSE,
     &                    EPSI, RELA  )
            CALL JEDETR ( '&&DYOBS3.VALE_INST' )
            GOTO 10
         ENDIF
C
C --- TRAITEMENT DU CAS OU ON FOURNIT UN PAS D'OBSERVATION
C
         IF ( N4 .NE. 0 ) THEN
            CALL GETVIS (MOTFAC,'PAS_OBSE',IOCC,1,1,IPACH,N4)
         ELSE
            IPACH = 1
         ENDIF

         DO 30 I = IPACH , NBPAS , IPACH
            JOBSE(I) = 1
 30      CONTINUE
C
C --- LE DERNIER INSTANT DE CALCUL EST TOUJOURS OBSERVE
C
         JOBSE(NBPAS) = 1

 10   CONTINUE
C
C --- NOMBRE D'OBSERVATIONS TOTAL
C
      NBOBSE = 0
      DO 40 I = 1 , NBPAS
         NBOBSE = NBOBSE + JOBSE(I)
 40   CONTINUE
C
      CALL JEDEMA()
C
      END
