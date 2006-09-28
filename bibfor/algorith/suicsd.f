      SUBROUTINE SUICSD(SUIVCO,MAILLA,MOTCLE,NBOCC,NBSUIV)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MABBAS M.ABBAS

      IMPLICIT     NONE
      CHARACTER*24 SUIVCO
      CHARACTER*8  MAILLA
      CHARACTER*16 MOTCLE
      INTEGER      NBOCC
      INTEGER      NBSUIV
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : SUIINI
C ----------------------------------------------------------------------
C
C SAISIE DU MOT CLE FACTEUR "SUIVI"
C  CREATION DE LA SD SUICSD
C
C IN  SUIVCO : NOM DE LA SD CONTENANT INFOS DE SUIVIS DDL
C IN  MAILLA : NOM DU MAILLAGE
C IN  MOTCLE : MOT-CLEF POUR LIRE INFOS DANS CATALOGUE
C IN  NBOCC  : NOMBRE OCCURRENCES MOT-CLEF SUIVI
C IN  NBSUIV : NOMBRE DE SUIVIS A FAIRE
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
      INTEGER      N1,N2,N4,N5,N6,N7,N8,N9,N10,I,J,K,L,JEXTR
      INTEGER      IOCC,IOBS,KNBNC,IBID,NTCMP
      INTEGER      NCHP,NCMP,NBNC,NBNO,NBMA,NBPO
      INTEGER      JNOE,JMAI,JPOI
      INTEGER      KNCMP,KNCHP
      INTEGER      JSUINB,JSUIMA
      INTEGER      JCHAM,JCOMP,JNUCM,JNOEU,JMAIL,JPOIN
      CHARACTER*8  K8B,NOMGD
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL WKVECT(SUIVCO(1:14)//'NBSUIV'   ,'V V I'  ,1    ,JSUINB)
      CALL WKVECT(SUIVCO(1:14)//'MAILLA'   ,'V V K8' ,1    ,JSUIMA)
      ZK8(JSUIMA)= MAILLA
      ZI(JSUINB) = NBSUIV
      IF (NBSUIV.EQ.0) THEN
        GOTO 999
      ENDIF
C
      CALL WKVECT(SUIVCO(1:14)//'NOM_CHAM' ,'V V K16',NBSUIV,JCHAM)
      CALL WKVECT(SUIVCO(1:14)//'NOM_CMP ' ,'V V K8' ,NBSUIV,JCOMP)
      CALL WKVECT(SUIVCO(1:14)//'NUME_CMP' ,'V V I'  ,NBSUIV,JNUCM)
      CALL WKVECT(SUIVCO(1:14)//'NOEUD'    ,'V V K8' ,NBSUIV,JNOEU)
      CALL WKVECT(SUIVCO(1:14)//'MAILLE'   ,'V V K8' ,NBSUIV,JMAIL)
      CALL WKVECT(SUIVCO(1:14)//'POINT'    ,'V V I'  ,NBSUIV,JPOIN)
      CALL WKVECT(SUIVCO(1:14)//'EXTREMA'  ,'V V I'  ,NBSUIV,JEXTR)
C
      IOBS = 0
C
      DO 10 IOCC = 1 , NBOCC
C
C ------ LES CHAMPS ----------------------------------------------------
C
         CALL GETVTX (MOTCLE,'NOM_CHAM',IOCC,1,0,K8B,N1)
         NCHP = -N1
         CALL WKVECT ('&&SUICSD.NOM_CHAM', 'V V K16', NCHP, KNCHP )
         CALL GETVTX (MOTCLE,'NOM_CHAM',IOCC,1,NCHP,
     &                ZK16(KNCHP),N1)
         DO 12 I = 1 , NCHP
            IF ( ZK16(KNCHP+I-1)(1:4) .EQ. 'DEPL' ) THEN
               NOMGD = 'DEPL_R'
            ELSEIF ( ZK16(KNCHP+I-1)(1:4) .EQ. 'VITE' ) THEN
               NOMGD = 'DEPL_R'
            ELSEIF ( ZK16(KNCHP+I-1)(1:4) .EQ. 'ACCE' ) THEN
               NOMGD = 'DEPL_R'
            ELSEIF ( ZK16(KNCHP+I-1)(1:9) .EQ. 'VALE_CONT' ) THEN
               NOMGD = 'INFC_R'
            ELSEIF ( ZK16(KNCHP+I-1)(1:9) .EQ. 'FORC_NODA' ) THEN
               NOMGD = 'FORC_R'
            ELSEIF ( ZK16(KNCHP+I-1)(1:9) .EQ. 'SIEF_ELGA' ) THEN
               NOMGD = 'SIEF_R'
            ELSEIF ( ZK16(KNCHP+I-1)(1:9) .EQ. 'VARI_ELGA' ) THEN
               NOMGD = 'VARI_R'
            ENDIF
 12      CONTINUE
C
C ------ LES COMPOSANTES -----------------------------------------------
C
         NBNC = 0
         CALL GETVTX (MOTCLE,'NOM_CMP',IOCC,1,0,K8B,N2)
         NCMP = -N2

         NTCMP = NCMP * MAX(1,NBNC)
         CALL WKVECT ('&&SUICSD.NOM_CMP' ,'V V K8',NTCMP,KNCMP)
         CALL WKVECT ('&&SUICSD.NUME_CMP','V V I' ,NTCMP,KNBNC)
         CALL UTCMP2 (NOMGD,MOTCLE,IOCC,ZK8(KNCMP),NCMP,
     &                ZI(KNBNC),NBNC)
C
C ------ LES NOEUDS ET MAILLES -----------------------------------------
C
         CALL GETVID ( MOTCLE,'NOEUD'   , IOCC,1,0, K8B ,N4 )
         CALL GETVID ( MOTCLE,'GROUP_NO', IOCC,1,0, K8B ,N5 )
         CALL GETVID ( MOTCLE,'MAILLE'  , IOCC,1,0, K8B ,N6 )
         CALL GETVID ( MOTCLE,'GROUP_MA', IOCC,1,0, K8B ,N8 )
         CALL GETVIS ( MOTCLE,'POINT'   , IOCC,1,0, IBID,N7 )
         CALL GETVTX(MOTCLE,'VALE_MAX' ,IOCC,1,0,K8B ,N9 )
         CALL GETVTX(MOTCLE,'VALE_MIN' ,IOCC,1,0,K8B ,N10 )

         IF ( N4 .NE. 0 ) THEN
            NBNO = -N4
            CALL WKVECT ('&&SUICSD.LIST_NOEU','V V K8',NBNO,JNOE)
            CALL GETVID ( MOTCLE,'NOEUD', IOCC,1,NBNO,
     &                    ZK8(JNOE),N4)
         ENDIF
         IF ( N5 .NE. 0 ) THEN
            CALL RELIEM (' ',MAILLA,'NO_NOEUD','SUIVI_DDL',IOCC,1,
     &                'GROUP_NO','GROUP_NO','&&SUICSD.LIST_NOEU',NBNO)
            CALL JEVEUO ('&&SUICSD.LIST_NOEU','L',JNOE)
         ENDIF
         IF ( N6 .NE. 0 ) THEN
            NBMA = -N6
            CALL WKVECT ('&&SUICSD.LIST_MAIL','V V K8',NBMA,JMAI)
            CALL GETVID ( MOTCLE,'MAILLE', IOCC,1,NBMA,
     &                    ZK8(JMAI),N6)
         ENDIF
         IF ( N8 .NE. 0 ) THEN
            CALL RELIEM (' ',MAILLA,'NO_MAILLE','SUIVI_DDL',IOCC,1,
     &                'GROUP_MA','GROUP_MA','&&SUICSD.LIST_MAIL',NBMA)
            CALL JEVEUO ('&&SUICSD.LIST_MAIL','L',JMAI)
         ENDIF
         IF ( N7 .NE. 0 ) THEN
            NBPO = -N7
            CALL WKVECT ('&&SUICSD.LIST_POIN','V V I',NBPO,JPOI)
            CALL GETVIS ( MOTCLE,'POINT', IOCC,1,NBPO,
     &                    ZI(JPOI),N7)
         ENDIF
         IF ( (N9.NE.0) .OR. (N10.NE.0) ) THEN
            NBPO=1
            NBMA=1
            NBNO=1
         ENDIF
C
C ------ ON STOCKE -----------------------------------------------------
C
         DO 100 I = 1 , NCHP
C
            DO 110 J = 1 , NCMP
C
               IF (     ZK16(KNCHP+I-1)(1:4) .EQ. 'DEPL' .OR.
     &                  ZK16(KNCHP+I-1)(1:4) .EQ. 'VITE' .OR.
     &                  ZK16(KNCHP+I-1)(1:4) .EQ. 'ACCE' .OR.
     &                  ZK16(KNCHP+I-1)(1:9) .EQ. 'FORC_NODA'.OR.
     &                  ZK16(KNCHP+I-1)(1:9) .EQ. 'VALE_CONT') THEN
C
                  DO 120 K = 1 , NBNO
                     ZK16(JCHAM+IOBS) = ZK16(KNCHP+I-1)
                     ZK8 (JCOMP+IOBS) = ZK8(KNCMP+J-1)
C  ON STOCKE DANS LE VECTEUR EXTREMA LE TYPE DE VALEUR SOUHAITE
C  =0 AU NOEUD SPECIFIE
C  =1 LE MINIMUM DU CHAMP
C  =2 LE MAXIMUM DU CHAMP

                     IF (N9.NE.0) THEN
                        ZI(JEXTR+IOBS)=2
                     ELSE IF (N10.NE.0) THEN
                        ZI(JEXTR+IOBS)=1
                     ELSE
                        ZI(JEXTR+IOBS)=0
                        ZK8 (JNOEU+IOBS) = ZK8(JNOE+K-1)
                     ENDIF
                     IOBS = IOBS + 1
 120              CONTINUE
C
               ELSEIF ( ZK16(KNCHP+I-1)(1:9) .EQ. 'SIEF_ELGA' ) THEN
C
                  DO 130 K = 1 , NBMA
                     DO 132 L = 1 , NBPO
                        ZK16(JCHAM+IOBS) = ZK16(KNCHP+I-1)
                        ZK8 (JCOMP+IOBS) = ZK8(KNCMP+J-1)
C  ON STOCKE DANS LE VECTEUR EXTREMA LE TYPE DE VALEUR SOUHAITE
C  =0 AU POINT SPECIFIE
C  =1 LE MINIMUM DU CHAMP
C  =2 LE MAXIMUM DU CHAMP
                        IF (N9.NE.0) THEN
                          ZI(JEXTR+IOBS)=2
                        ELSE IF (N10.NE.0) THEN
                          ZI(JEXTR+IOBS)=1
                        ELSE
                          ZI(JEXTR+IOBS)=0
                          ZK8 (JMAIL+IOBS) = ZK8(JMAI+K-1)
                          ZI  (JPOIN+IOBS) = ZI(JPOI+L-1)
                        ENDIF
                        IOBS = IOBS + 1
 132                 CONTINUE
 130              CONTINUE
C
               ELSEIF ( ZK16(KNCHP+I-1)(1:9) .EQ. 'VARI_ELGA' ) THEN
C
                  DO 142 K = 1 , NBMA
                     DO 144 L = 1 , NBPO
                        ZK16(JCHAM+IOBS) = ZK16(KNCHP+I-1)
                        ZK8 (JCOMP+IOBS) = ZK8(KNCMP+J-1)
                        ZI  (JNUCM+IOBS) = ZI(KNBNC+J-1)
C  ON STOCKE DANS LE VECTEUR EXTREMA LE TYPE DE VALEUR SOUHAITE
C  =0 AU POINT SPECIFIE
C  =1 LE MINIMUM DU CHAMP
C  =2 LE MAXIMUM DU CHAMP
                        IF (N9.NE.0) THEN
                          ZI(JEXTR+IOBS)=2
                        ELSE IF (N10.NE.0) THEN
                          ZI(JEXTR+IOBS)=1
                        ELSE
                          ZI(JEXTR+IOBS)=0
                          ZK8 (JMAIL+IOBS) = ZK8(JMAI+K-1)
                          ZI  (JPOIN+IOBS) = ZI(JPOI+L-1)
                        ENDIF
                        IOBS = IOBS + 1
 144                 CONTINUE
 142              CONTINUE
C
               ENDIF
C
 110        CONTINUE
C
 100     CONTINUE
C
C --- NETTOYAGE
C
         CALL JEDETR( '&&SUICSD.NOM_CHAM' )
         CALL JEDETR( '&&SUICSD.NOM_CMP'  )
         CALL JEDETR( '&&SUICSD.NUME_CMP' )
         IF ( N4.NE.0 .OR. N5.NE.0 ) CALL JEDETR( '&&SUICSD.LIST_NOEU' )
         IF ( N6.NE.0 .OR. N8.NE.0 ) CALL JEDETR( '&&SUICSD.LIST_MAIL' )
         IF ( N7 .NE. 0 )    CALL JEDETR( '&&SUICSD.LIST_POIN' )
C
 10   CONTINUE
C
      IF (IOBS.NE.NBSUIV) THEN
        CALL U2MESS('F','ALGORITH3_47')
      ENDIF
C
 999  CONTINUE
      CALL JEDEMA()
C
      END
