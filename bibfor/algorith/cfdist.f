      SUBROUTINE CFDIST(IZONE,POSNOE,INST,
     &                  JNOCO,JCOOR,JJFO1,JJFO2,JJFO3,JJSUP,
     &                  DIST3)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/10/2004   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      INTEGER      IZONE
      INTEGER      POSNOE
      REAL*8       INST
      INTEGER      JNOCO
      INTEGER      JCOOR
      INTEGER      JJFO1
      INTEGER      JJFO2
      INTEGER      JJFO3
      INTEGER      JJSUP
      REAL*8       DIST3
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : RECHCO/PROJCO
C ----------------------------------------------------------------------
C
C CALCUL DU JEU SUPPLEMENTAIRE SI C'EST UNE "FONCTION" D'ESPACE
C
C IN  IZONE  : ZONE DE CONTACT
C IN  POSNOE : INDICE DU NOEUD ESCLAVE DANS CONTNO
C IN  INST   : VALEUR DE L'INSTANT DE CALCUL

C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IER
      CHARACTER*8  JEUF1,JEUF2,JEUF3
      CHARACTER*8  NOMPAR(3)
      REAL*8       X,Y,Z,VALPAR(3),DIST1,DIST2
      INTEGER      NUMNOE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()
C
C --- EN VUE DE L'INTERPOLATION DU JEU PAR DES VARIABLES D'ESPACE
C
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(3) = 'Z'
C
C --- NUMERO DU NOEUD ESCLAVE COURANT
C
      NUMNOE = ZI(JNOCO+POSNOE-1)
C
C --- COORDONNEES DU NOEUD ESCLAVE COURANT
C
      X = ZR(JCOOR+3*(NUMNOE-1))
      Y = ZR(JCOOR+3*(NUMNOE-1)+1)
      Z = ZR(JCOOR+3*(NUMNOE-1)+2)
C
      VALPAR(1) = X
      VALPAR(2) = Y
      VALPAR(3) = Z
C
C --- VALEUR DU JEU SUPPLEMENTAIRE SI C'EST UNE "FONCTION" D'ESPACE
C
      DIST1 = 0.D0
      DIST2 = 0.D0


      JEUF1 = ZK8(JJFO1+IZONE-1)
      JEUF2 = ZK8(JJFO2+IZONE-1)
      JEUF3 = ZK8(JJFO3+IZONE-1)

      IF ((JEUF1.NE.' ').OR.(JEUF2.NE.' ')) THEN
        IF (JEUF1.NE.' ') THEN
          CALL FOINTE ('F',JEUF1,3,NOMPAR,VALPAR,DIST1,IER)
        ENDIF
        IF (JEUF2.NE.' ') THEN
          CALL FOINTE ('F',JEUF2,3,NOMPAR,VALPAR,DIST2,IER)
        ENDIF
        ZR(JJSUP+IZONE-1) = DIST1 + DIST2
      ENDIF
      IF (JEUF3.NE.' ') THEN
        CALL FOINTE ('F',JEUF3,1,'INST',INST,DIST3,IER)
      ENDIF

C
      CALL JEDEMA ()
      END
