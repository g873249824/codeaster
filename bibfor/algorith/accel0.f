      SUBROUTINE ACCEL0( MODELE, NUMEDD, MATE,   COMPOR, CARELE,
     &                   MEMASS, MEDIRI, LISCHA, INSTAM, COMMOI,
     &                   DEPMOI, SIGMOI, ACCMOI, MAPREC, SOLVEU,
     &                   CARCRI, LGRFL,  CHGRFL, DT, DEFICO )

      IMPLICIT NONE
      REAL*8        INSTAM
      LOGICAL       LGRFL
      CHARACTER*(*) MATE
      CHARACTER*19  SOLVEU, MAPREC, LISCHA
      CHARACTER*24  MODELE,NUMEDD,COMPOR,CARELE,MEMASS,MEDIRI,CARCRI
      CHARACTER*24  COMMOI,DEPMOI,SIGMOI,ACCMOI,CHGRFL, DEFICO
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/10/2004   AUTEUR BOYERE E.BOYERE 
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
C TOLE CRP_21
C
C     D Y N A M I Q U E  N O N  L I N E A I R E
C     CALCUL DE L'ACCELERATION INITIALE
C
C     ==> ON SUPPOSE QUE LA VITESSE INITIALE EST NULLE
C                    QUE LES DEPLACEMENTS IMPOSES SONT NULS
C     ==> ON NE PREND EN COMPTE QUE LES CHARGES DYNAMIQUES, CAR LES
C         CHARGES STATIQUES SONT EQUILIBREES PAR LES FORCES INTERNES
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
      CHARACTER*32                                    ZK32, JEXNUM
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER      IERR,NEQ,LONCH,JCHMP,JCGMP,JCHTP,IMAT,IADIA,IVALE,
     &             JDIRP,JACC0,I,IRET,ISLVI,JTP,IECPCO,II,ZILSV3
      REAL*8       Z, DZ, DT, VARINT
      CHARACTER*1  K1B
      CHARACTER*19 CHASOL, MATASS
      CHARACTER*24 CINE,DEPDEL,VERESI, VEFONO,VAFONO
      CHARACTER*24 VECHMP,CNCHMP,VECGMP,CNCGMP,VECHTP,
     &              CNCHTP,VEDIRP,CNDIRP,VEBUDI,VABUDI,CRITER,
     &              VITPLU,ACCPLU, K24BID, MAESCL
C
      DATA CINE              /'                      '/
      DATA CHASOL            /'&&ACCEL0.SOLUTION'/
      DATA DEPDEL,VERESI     / '&&ACCEL0' , ' ' /
      DATA VECHMP, VECHTP    /2*' '/
      DATA VEDIRP, VECGMP    /2*' '/
      DATA VEFONO, VAFONO    /2*' '/
      DATA VEBUDI, VABUDI    /2*' '/
      DATA CNDIRP, CNCHMP    /2*' '/
      DATA CNCHTP, CNCGMP    /2*' '/
C
      CALL JEMARQ()
C
      CRITER = '&&RESGRA_GCPC'
      VITPLU = ' '
      ACCPLU = ' '
      
      MAESCL = DEFICO(1:16)//'.MAESCL'
      CALL JEEXIN(MAESCL,IECPCO)

C
C*** CALCUL ET TRIANGULARISATION DE LA MATRICE DE MASSE
C
      CALL ASASMA (MEMASS, MEDIRI, NUMEDD, MATASS,SOLVEU,LISCHA)
C
C     -- DECOMPOSITION OU CALCUL DE LA MATRICE DE PRECONDITIONNEMENT
      CALL JEVEUO(SOLVEU//'.SLVI','E',ISLVI)
      ZILSV3=ZI(ISLVI-1+3)

C SI METHODE CONTINUE ON REMPLACE LES TERMES DIAGONAUX NULS PAR
C DES UNS POUR POUVOIR INVERSER LA MATRICE ASSEMBLE MATASS
     
      IF (IECPCO.NE.0) THEN
      
        CALL MTDSCR(MATASS)
        CALL JEVEUO(MATASS//'.&INT','L',IMAT) 
        NEQ= ZI(IMAT + 2)  
        CALL MTDSC2(MATASS,'ADIA','L',IADIA)   
        CALL JEVEUO(JEXNUM(MATASS//'.VALE',1),'E',IVALE)    
 
        DO 10 II=1,NEQ 
         IF (ZR(IVALE-1+ZI(IADIA-1+II)) .EQ. 0.D0) THEN
             ZR(IVALE-1+ZI(IADIA-1+II)) = 1.D0
         ENDIF
10      CONTINUE 

        ZI(ISLVI-1+3) = 2
        CALL PRERES (SOLVEU,'V',IERR,MAPREC,MATASS)
        IF (IERR.EQ.2) THEN
C NORMALEMENT ON NE DEVRAIT PAS RENTRER ICI PUISQUE LA MATRICE
C DE MASSE EST RENDUE SYSTEMATIQUEMENT INVERSIBLE
         CALL NULVEC(ACCMOI)
         CALL UTMESS('A','ACCEL0',
     &   'MATRICE MASSE NON INVERSIBLE'//
     &   ' => ACCELERATION INITIALE NULLE '//
     &   ' - AVEZ-VOUS BIEN AFFECTE UNE MASSE A TOUS LES ELEMENTS ?')
         ZI(ISLVI-1+3) = ZILSV3
         GOTO 9999
        ENDIF
        ZI(ISLVI-1+3) = ZILSV3

      ELSE 
      
C ON EVITE L'ARRET FATAL LORS DE L'INVERSION DE LA MATRICE DE MASSE
        ZI(ISLVI-1+3) = 2
        CALL PRERES (SOLVEU,'V',IERR,MAPREC,MATASS)
C SI LA MATRICE DE MASSE N'EST PAS INVERSIBLE
C ON ANNULE L'ACCELERATION INITIALE
        IF (IERR.EQ.2) THEN
         CALL NULVEC(ACCMOI)
         CALL UTMESS('A','ACCEL0',
     &   'MATRICE MASSE NON INVERSIBLE'//
     &   '=> ACCELERATION INITIALE NULLE'//
     &   'AVEZ-VOUS BIEN AFFECTE UNE MASSE A TOUS LES ELEMENTS ?')
         ZI(ISLVI-1+3) = ZILSV3
         GOTO 9999
        ENDIF
C ON REVIENT AU CODE D ARRET SOLVEUR INITIAL
        ZI(ISLVI-1+3) = ZILSV3
      
      ENDIF

C
C*** ON CREE UN CHAM_NO A VALEURS NULLES, EPHEMERE MAIS NECESSAIRE POUR
C*** ENTRER DANS LES SOUS-PROGRAMMES
C
      CALL VTCREB (DEPDEL,NUMEDD,'V','R',NEQ)
C
C*** CALCUL DE LA CHARGE A L'INSTANT INITIAL INSTAM
C
      
      CALL CHSTNL ('NON_SUIV', MODELE, NUMEDD, MATE,   CARELE,
     &             COMMOI,     DEPMOI, DEPDEL, VERESI,
     &             LISCHA,     INSTAM, INSTAM, COMPOR, CARCRI,
     &             VECHMP,     K24BID, CNCHMP, VITPLU, ACCPLU)
      CALL JEVEUO(CNCHMP(1:19)//'.VALE', 'L', JCHMP)
C
      CALL CHSTNL ('SUIVEUSE', MODELE, NUMEDD, MATE,   CARELE,
     &             COMMOI,     DEPMOI, DEPDEL, VERESI,
     &             LISCHA,     INSTAM, INSTAM, COMPOR, CARCRI,
     &             VECGMP,     K24BID, CNCGMP, VITPLU, ACCPLU)
      CALL JEVEUO(CNCGMP(1:19)//'.VALE', 'L', JCGMP)
C
      CALL CHSTNL ('DIRICHLE', MODELE, NUMEDD, MATE,   CARELE,
     &             COMMOI,     DEPMOI, DEPDEL, VERESI,
     &             LISCHA,     INSTAM, INSTAM, COMPOR, CARCRI,
     &             VEDIRP,     K24BID, CNDIRP, VITPLU, ACCPLU)
      CALL JEVEUO(CNDIRP(1:19)//'.VALE', 'L', JDIRP)
C
      CALL JEVEUO ( ACCMOI(1:19)//'.VALE', 'E', JACC0)
      CALL JELIRA ( ACCMOI(1:19)//'.VALE','LONMAX',LONCH,K1B)
C
C*** CALCUL DU CHARGEMENT INITIAL
C
      CALL CHTOTA (MODELE, NUMEDD, MATE,   COMPOR,    CARELE,
     &             COMMOI, DEPMOI, DEPMOI, DEPDEL,    SIGMOI,
     &             LISCHA, LONCH,  ZR(JACC0), VEFONO,
     &             VAFONO, VEBUDI, VABUDI, VECHTP,    CNCHTP)
      CALL JEVEUO(CNCHTP, 'L', JTP)
      CALL JEVEUO(ZK24(JTP)(1:19)//'.VALE', 'L', JCHTP)
C
C*** CALCUL DE L'ACCROISSEMENT INSTANTANE DE CHARGE AU TEMPS INSTAM
C
      DO 110 I = 0,LONCH-1
         ZR(JACC0+I) =   ZR(JCHMP+I) + ZR(JCGMP+I) + ZR(JDIRP+I)
     &                 + ZR(JCHTP+I) - ZR(JACC0+I)
110   CONTINUE
C
C*** CALCUL DE L'ACCELERATION AU TEMPS INSTAM
C
C
C- RESOLUTION AVEC ACCMOI COMME SECOND MEMBRE
C
      CALL RESOUD(MATASS,MAPREC,ACCMOI,SOLVEU,CINE,'V',CHASOL,CRITER)
C
C- RECOPIE DANS ACCMOI DU CHAMP SOLUTION CHASOL
C
      CALL COPISD('CHAMP_GD','V',CHASOL(1:19),ACCMOI(1:19))
C
C- DESTRUCTION DU CHAMP SOLUTION CHASOL
C
      CALL JEEXIN (CRITER(1:19)//'.CRTI',IRET)
      IF ( IRET .NE. 0 ) THEN
         CALL JEDETR ( CRITER(1:19)//'.CRTI' )
         CALL JEDETR ( CRITER(1:19)//'.CRTR' )
         CALL JEDETR ( CRITER(1:19)//'.CRDE' )
      ENDIF
      CALL DETRSD('CHAMP_GD',CHASOL)
      CALL DETRSD ('CHAMP_GD',DEPDEL(1:19))

      IF ( LGRFL ) THEN
C
         Z  = 0.0D0
         DZ = 0.0D0

         CALL GFACC0 ( Z, DZ, NUMEDD, ACCMOI, CHGRFL ) 

      ENDIF
C
9999  CONTINUE
C
      CALL JEDEMA()
      END
