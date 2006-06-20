      SUBROUTINE MDCHRE ( MOTFAC, IOC, ILIAI, MDGENE, TYPNUM, REPERE,
     +                    NBNLI, PARCHO, LNOUE2 )
      IMPLICIT  NONE
      INTEGER             IOC, ILIAI, NBNLI
      REAL*8              PARCHO(NBNLI,*)
      LOGICAL             LNOUE2
      CHARACTER*8         REPERE
      CHARACTER*10        MOTFAC
      CHARACTER*16        TYPNUM
      CHARACTER*24        MDGENE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/06/2006   AUTEUR CIBHHLV L.VIVAN 
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
C
C     ROUTINE APPELEE PAR MDCHOC
C     TRAITEMENT DU REPERE
C
C IN  : MOTFAC : 'CHOC', 'FLAMBAGE', 'ANTI_SISM'
C IN  : IOC    : NUMERO D'OCCURENCE
C IN  : ILIAI  : NUMERO DE LA LIAISON TRAITEE
C IN  : MDGENE : MODELE GENERALISE
C IN  : TYPNUM : TYPE DE LA NUMEROTATION
C OUT : REPERE : REPERE DU NOEUD DE CHOC = 'GLOBAL' OU 'LOCAL'
C IN  : NBNLI  : DIMENSION DES TABLEAUX (NBCHOC+NBSISM+NBFLAM)
C OUT : PARCHO : PARAMETRE DE CHOC:
C                PARCHO(ILIAI,13)= COOR ORIGINE OBSTACLE X REP GLOBAL
C                PARCHO(ILIAI,14)= COOR ORIGINE OBSTACLE Y REP GLOBAL
C                PARCHO(ILIAI,15)= COOR ORIGINE OBSTACLE Z REP GLOBAL
C                PARCHO(ILIAI,44)= NORMALE X
C                PARCHO(ILIAI,45)= NORMALE Y
C                PARCHO(ILIAI,46)= NORMALE Z
C IN  : LNOUE2 : CHOC DEFINIT ENTRE 2 NOEUDS
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      INTEGER       N1, IRET, JCOORD
      REAL*8        TEMPO(3), DIRCHO(3), COORD(3), TXNO
      CHARACTER*24  MDSSNO
C     ------------------------------------------------------------------
C
      N1 = 0
      REPERE = '????????'
C
      IF ( MOTFAC.EQ.'CHOC' .OR. MOTFAC.EQ.'FLAMBAGE' ) THEN
C          ------------------------------------------      
         CALL GETVTX ( MOTFAC, 'REPERE', IOC,1,0, REPERE, N1 )
         IF (N1.EQ.0) THEN
            REPERE = 'GLOBAL'
         ELSE
            CALL GETVTX ( MOTFAC, 'REPERE', IOC,1,1, REPERE, N1 )
         ENDIF
         CALL GETVR8 ( MOTFAC, 'ORIG_OBST', IOC,1,1, TEMPO, N1 )
      ENDIF
C
      N1 = -N1
      IF (N1.EQ.3) THEN
          CALL GETVR8 ( MOTFAC, 'ORIG_OBST', IOC,1,3, TEMPO, N1 )
          IF (TYPNUM.EQ.'NUME_DDL_SDASTER') THEN
             PARCHO(ILIAI,13) = TEMPO(1)
             PARCHO(ILIAI,14) = TEMPO(2)
             PARCHO(ILIAI,15) = TEMPO(3)
          ELSE
             MDSSNO = MDGENE(1:14)//'.MODG.SSNO'
             IF (REPERE.EQ.'GLOBAL') THEN
                PARCHO(ILIAI,13) = TEMPO(1)
                PARCHO(ILIAI,14) = TEMPO(2)
                PARCHO(ILIAI,15) = TEMPO(3)
             ELSE
                CALL JENONU(JEXNOM(MDSSNO,REPERE),IRET)
                IF (IRET.EQ.0) THEN
                   CALL UTMESS('F','MDCHOC','ARGUMENT DU MOT-CLE'//
     &                                   ' "REPERE" INCONNU')
                ENDIF
                CALL WKVECT ('&&MDCHOC.COORDO', 'V V R', 3, JCOORD )
                ZR(JCOORD)   = TEMPO(1)
                ZR(JCOORD+1) = TEMPO(2)
                ZR(JCOORD+2) = TEMPO(3)
                CALL ORIENT ( MDGENE, REPERE, JCOORD, 1, COORD, 1 )
                PARCHO(ILIAI,13) = COORD(1)
                PARCHO(ILIAI,14) = COORD(2)
                PARCHO(ILIAI,15) = COORD(3)
                CALL JEDETR ( '&&MDCHOC.COORDO' )
             ENDIF
          ENDIF
      ELSE
         PARCHO(ILIAI,13) = (PARCHO(ILIAI,7)+PARCHO(ILIAI,10))/2.D0
         PARCHO(ILIAI,14) = (PARCHO(ILIAI,8)+PARCHO(ILIAI,11))/2.D0
         PARCHO(ILIAI,15) = (PARCHO(ILIAI,9)+PARCHO(ILIAI,12))/2.D0
      ENDIF
C
      IF ( LNOUE2 ) THEN
         DIRCHO(1) = PARCHO(ILIAI,7)-PARCHO(ILIAI,10)
         DIRCHO(2) = PARCHO(ILIAI,8)-PARCHO(ILIAI,11)
         DIRCHO(3) = PARCHO(ILIAI,9)-PARCHO(ILIAI,12)
      ELSE
         DIRCHO(1) = PARCHO(ILIAI,7)-PARCHO(ILIAI,13)
         DIRCHO(2) = PARCHO(ILIAI,8)-PARCHO(ILIAI,14)
         DIRCHO(3) = PARCHO(ILIAI,9)-PARCHO(ILIAI,15)
      ENDIF
C
      TXNO = SQRT(DIRCHO(1)**2+DIRCHO(2)**2+DIRCHO(3)**2)
      IF (TXNO.EQ.0.D0) TXNO = 1.D0
C
C --- DEBUG : UN TRAVAIL DOIT ETRE FAIT SI TXNO = 0.
C 
      PARCHO(ILIAI,44) = DIRCHO(1)/TXNO
      PARCHO(ILIAI,45) = DIRCHO(2)/TXNO
      PARCHO(ILIAI,46) = DIRCHO(3)/TXNO
C
      END
