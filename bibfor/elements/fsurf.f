      SUBROUTINE FSURF(OPTION,NOMTE,XI,NB1,VECL,VECTPT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 24/09/2001   AUTEUR JMBHH01 J.M.PROIX 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16  OPTION , NOMTE
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C
      INTEGER      NB1
      REAL*8       PRESS,RNORMC,F1, PR
      REAL*8       XI(3,*),VECTPT(9,3,3)
C     REAL*8       VECTC(3),VECPTX(3,3)
      REAL*8       VECL(51),VECL1(42)
      REAL*8       VECTN(9,3),CHGSRG(6,8),CHGSRL(6),CHG(6)
      REAL*8       KIJKM1(40,2),PGL(3,3)
      LOGICAL      GLOBAL, LOCAPR
      REAL*8       VALPAR(4)
      CHARACTER*8  NOMPAR(4)
C
C
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESI',' ', LZI )
      NB1  =ZI(LZI-1+1)
      NB2  =ZI(LZI-1+2)
      NPGSN=ZI(LZI-1+4)
C
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESR',' ', LZR )
C
      CALL R8INIR(42,0.D0,VECL1,1)
C
C
C --- CAS DES CHARGEMENTS DE FORME REEL
      IF (OPTION .EQ. 'CHAR_MECA_FRCO3D') THEN
         CALL JEVECH ('PFRCO3D','E',JPRES)
         GLOBAL=ABS(ZR(JPRES-1+7)).LT.1.D-3
         IF (GLOBAL) THEN
            DO 20 J=1,NB1
               DO 10 I=1,6
                  CHGSRG(I,J)=ZR(JPRES-1+7*(J-1)+I)
 10            CONTINUE
 20         CONTINUE
         ELSE
            DO 70 J=1,NB1
               DO 30 I=1,5
                  CHGSRL(I)=ZR(JPRES-1+7*(J-1)+I)
 30            CONTINUE
               CHGSRL(I)=0.D0
               DO 50 JP=1,3
                  DO 40 IP=1,3
                     PGL(JP,IP)=VECTPT(J,JP,IP)
 40               CONTINUE
 50            CONTINUE
               CALL UTPVLG(1,6,PGL,CHGSRL,CHG)
               DO 60 I=1,6
                  CHGSRG(I,J)=CHG(I)
 60            CONTINUE
 70         CONTINUE
         ENDIF
C
C
C --- CAS DES CHARGEMENTS DE FORME FONCTION
      ELSE IF (OPTION .EQ. 'CHAR_MECA_FFCO3D') THEN
         CALL JEVECH ('PFFCO3D', 'E', JPRES)
         CALL JEVECH ('PTEMPSR', 'E', ITEMPS)
         VALPAR(4) = ZR(ITEMPS)
         NOMPAR(4) = 'INST'
         NOMPAR(1) = 'X'
         NOMPAR(2) = 'Y'
         NOMPAR(3) = 'Z'
         GLOBAL = ZK8(JPRES+6) .EQ. 'GLOBAL'
         LOCAPR = ZK8(JPRES+6) .EQ. 'LOCAL_PR'
C
         IF ( GLOBAL ) THEN
C --        LECTURE DES INTERPOLATIONS DE FX, FY, FZ, MX, MY, MZ
            DO 100 J = 1, NB1
              VALPAR(1) = XI(1,J)
              VALPAR(2) = XI(2,J)
              VALPAR(3) = XI(3,J)
          CALL FOINTE('FM',ZK8(JPRES  ),4,NOMPAR,VALPAR,CHGSRG(1,J),IER)
          CALL FOINTE('FM',ZK8(JPRES+1),4,NOMPAR,VALPAR,CHGSRG(2,J),IER)
          CALL FOINTE('FM',ZK8(JPRES+2),4,NOMPAR,VALPAR,CHGSRG(3,J),IER)
          CALL FOINTE('FM',ZK8(JPRES+3),4,NOMPAR,VALPAR,CHGSRG(4,J),IER)
          CALL FOINTE('FM',ZK8(JPRES+4),4,NOMPAR,VALPAR,CHGSRG(5,J),IER)
          CALL FOINTE('FM',ZK8(JPRES+5),4,NOMPAR,VALPAR,CHGSRG(6,J),IER)
  100       CONTINUE
C
         ELSE IF ( LOCAPR ) THEN
C --        BASE LOCALE - CAS D UNE PRESSION
C --        LECTURE DES INTERPOLATIONS DE LA PRESSION PRES
            DO 140 J = 1, NB1
              VALPAR(1) = XI(1,J)
              VALPAR(2) = XI(2,J)
              VALPAR(3) = XI(3,J)
               CALL FOINTE('FM',ZK8(JPRES+2),4,NOMPAR,VALPAR,PR,IER)
               CHGSRL(3) = -1 * PR
               CHGSRL(1) = 0.D0
               CHGSRL(2) = 0.D0
               CHGSRL(4) = 0.D0
               CHGSRL(5) = 0.D0
               CHGSRL(6) = 0.D0
C --           CHANGEMENT DE BASE LOCAL --> GLOBAL
               DO 120 JP=1,3
                  DO 110 IP=1,3
                     PGL(JP,IP)=VECTPT(J,JP,IP)
  110             CONTINUE
  120          CONTINUE
               CALL UTPVLG(1,6,PGL,CHGSRL,CHG)
               DO 130 I=1,6
                  CHGSRG(I,J)=CHG(I)
  130          CONTINUE
  140       CONTINUE
         ELSE
C
C --        BASE LOCALE - CAS DE F1, F2, F3, MF1, MF2
C --        LECTURE DES INTERPOLATIONS DE F1, F2, F3, MF1, MF2
            DO 180 J = 1, NB1
              VALPAR(1) = XI(1,J)
              VALPAR(2) = XI(2,J)
              VALPAR(3) = XI(3,J)
            CALL FOINTE('FM',ZK8(JPRES  ),4,NOMPAR,VALPAR,CHGSRL(1),IER)
            CALL FOINTE('FM',ZK8(JPRES+1),4,NOMPAR,VALPAR,CHGSRL(2),IER)
            CALL FOINTE('FM',ZK8(JPRES+2),4,NOMPAR,VALPAR,CHGSRL(3),IER)
            CALL FOINTE('FM',ZK8(JPRES+3),4,NOMPAR,VALPAR,CHGSRL(4),IER)
            CALL FOINTE('FM',ZK8(JPRES+4),4,NOMPAR,VALPAR,CHGSRL(5),IER)
               CHGSRL(6) = 0.D0
C --           CHANGEMENT DE BASE LOCAL --> GLOBAL
               DO 160 JP=1,3
                  DO 150 IP=1,3
                     PGL(JP,IP)=VECTPT(J,JP,IP)
  150             CONTINUE
  160          CONTINUE
               CALL UTPVLG(1,6,PGL,CHGSRL,CHG)
               DO 170 I=1,6
                  CHGSRG(I,J)=CHG(I)
  170          CONTINUE
  180       CONTINUE
         ENDIF
C
      ENDIF
C
C
      DO 200 INTSN=1,NPGSN
         CALL VECTCI(INTSN,NB1,XI,ZR(LZR),RNORMC)
C
         CALL FORSRG(INTSN,NB1,NB2,ZR(LZR),CHGSRG,RNORMC,VECTPT,VECL1)
 200  CONTINUE
C
C     RESTITUTION DE KIJKM1 POUR CONDENSER LES FORCES
C     ATTENTION LA ROUTINE N'EST PAS UTILISEE DANS LE CAS DES
C     EFFORTS SUIVANTS (MOMENTS SURFACIQUES)
      I1=5*NB1
      DO 220 J=1,2
      DO 210 I=1,I1
         K=(J-1)*I1+I
         KIJKM1(I,J)=ZR(LZR-1+1000+K)
 210  CONTINUE
 220  CONTINUE
C
      DO 240 I=1,I1
         F1=0.D0
         DO 230 K=1,2
            F1=F1+KIJKM1(I,K)*VECL1(I1+K)
 230     CONTINUE
         VECL1(I)=VECL1(I)-F1
 240  CONTINUE
C
C     EXPANSION DU VECTEUR VECL1 : DUE A L'AJOUT DE LA ROTATION FICTIVE
C
      CALL VEXPAN(NB1,VECL1,VECL)
      DO 90 I=1,3
         VECL(6*NB1+I)=0.D0
 90   CONTINUE
C
      END
