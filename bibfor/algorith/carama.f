      SUBROUTINE CARAMA(NOMA,DEFICO,NEWGEO,POSMA,IZONE,
     &                  POSNO,
     &                  MATYP,COORDP,NBNO,COOR,
     &                  MOYEN,LISSA,TANGDF,TOLEIN,TOLEOU,DIAGNO)
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

      IMPLICIT     NONE
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO
      CHARACTER*24 NEWGEO
      INTEGER      POSMA
      INTEGER      IZONE  
      INTEGER      POSNO(10)      
      CHARACTER*4  MATYP
      REAL*8       COORDP(3)
      INTEGER      NBNO
      REAL*8       COOR(27)
      INTEGER      MOYEN
      INTEGER      LISSA
      INTEGER      TANGDF
      REAL*8       TOLEIN
      REAL*8       TOLEOU
      INTEGER      DIAGNO
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : PROJEC
C ----------------------------------------------------------------------
C
C CARACTERISTIQUES DU NOEUD MAITRE
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE CONTACT (DEFINITION)
C IN  NEWGEO : COORDONNEES REACTUALISEES DES NOEUDS DU MAILLAGE
C IN  POSMA  : INDICE DE LA MAILLE MAITRE
C IN  IZONE  : REPERAGE ZONE DE CONTACT
C I/O POSNO  : INDICES DANS CONTNO DES NOEUDS ESCLAVE ET MAITRES
C OUT MATYP  : TYPE DE LA MAILLE
C OUT COORDP : COORDONNEES DU NOEUD ESCLAVE
C OUT NBNO   : NOMBRE DE NOEUDS DE LA MAILLE
C OUT COOR   : COORDONNEES DES NOEUDS DE LA MAILLE
C OUT TANGDF : INDICATEUR DE PRESENCE D'UN VECT_Y DEFINI PAR 
C              L'UTILISATEUR
C               0 PAS DE VECT_Y
C               1 UN VECT_Y EST DEFINI
C OUT MOYEN  : NORMALES D'APPARIEMENT
C               0 MAIT 
C               1 MAIT_ESCL 
C OUT LISSA  : LISSAGE DES NORMALES 
C               0 PAS DE LISSAGE 
C               1 LISSAGE 
C OUT TOLEIN : TOLERANCE <IN> POUR LA PROJECTION GEOMETRIQUE
C              DETERMINE SI PROJECTION SUR ARETE OU NOEUD
C OUT TOLEOU : TOLERANCE <OUT> POUR LA PROJECTION GEOMETRIQUE
C              DETERMINE SI PROJECTION EN DEHORS ELEMENT
C OUT DIAGNO : DRAPEAU POUR DIAGNOSTIC GEOMETRIQUE
C               VERIF DE LA PROJECTION SUR NOEUDS/ARETES/DIAGONALES
C               AVEC LA TOLERANCE TOLEIN
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
      INTEGER      ZMETH
      PARAMETER    (ZMETH=8)
      INTEGER      ZTOLE
      PARAMETER    (ZTOLE=2)
      INTEGER      NUMA,JDEC,INO,NO(9),NUMNO,PRONOR,NUTYP
      CHARACTER*24 CONTMA,PNOMA,NOMACO,CONTNO
      INTEGER      JMACO,JPONO,JNOMA,JNOCO,JCOOR
      CHARACTER*24 METHCO,TOLECO,NORLIS
      INTEGER      JMETH,JTOLE,JNORLI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()
C
      CONTMA = DEFICO(1:16)//'.MAILCO'
      PNOMA  = DEFICO(1:16)//'.PNOMACO'
      NOMACO = DEFICO(1:16)//'.NOMACO'
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      METHCO = DEFICO(1:16)//'.METHCO'
      TOLECO = DEFICO(1:16)//'.TOLECO' 
      NORLIS = DEFICO(1:16)//'.NORLIS'
C
      CALL JEVEUO (CONTMA,'L',JMACO)
      CALL JEVEUO (PNOMA, 'L',JPONO)
      CALL JEVEUO (NOMACO,'L',JNOMA)
      CALL JEVEUO (CONTNO,'L',JNOCO)
      CALL JEVEUO (NEWGEO(1:19)//'.VALE','L',JCOOR)
      CALL JEVEUO (METHCO,'L',JMETH)
      CALL JEVEUO (TOLECO,'L',JTOLE)
      CALL JEVEUO (NORLIS,'L',JNORLI) 
C
C --- NUMERO ABSOLU DE LA MAILLE MAITRE ET NOMBRE DE NOEUDS
C
      NUMA = ZI(JMACO+POSMA-1)
      NBNO = ZI(JPONO+POSMA) - ZI(JPONO+POSMA-1)

      IF (NBNO.GT.9) THEN
        CALL UTMESS ('F','CARAMA','ERREUR DE DIMENSIONNEMENT : '
     &               //'LE NOMBRE DE NOEUDS EST SUPERIEUR A 9')
      END IF
C
C --- TYPE DE LA MAILLE MAITRE DE NUMERO ABSOLU NUMA
C
      CALL TYPEMA(NOMA,NUMA,NUTYP,MATYP) 
      IF ( MATYP .EQ. 'POI1' ) THEN
        CALL UTMESS ('F','CARAMA','UN POI1 NE PEUT PAS ETRE '
     &               //'UNE MAILLE MAITRE')
      END IF
C
C --- INDICE DANS CONTMA ET NUMERO ABSOLU DES NOEUDS DE LA MAILLE MAITRE
C
      JDEC = ZI(JPONO+POSMA-1)
      DO 60 INO = 1,NBNO
        POSNO(INO+1) = ZI(JNOMA+JDEC+INO-1)
        NO(INO)      = ZI(JNOCO+POSNO(INO+1)-1)
 60   CONTINUE
C
C --- COORDONNEES DES NOEUDS DE LA MAILLE MAITRE
C
      DO 70 INO = 1,NBNO
        COOR(3*(INO-1)+1) = ZR(JCOOR+3*(NO(INO)-1))
        COOR(3*(INO-1)+2) = ZR(JCOOR+3*(NO(INO)-1)+1)
        COOR(3*(INO-1)+3) = ZR(JCOOR+3*(NO(INO)-1)+2)
  70  CONTINUE
C
C --- NUMERO ABSOLU DU NOEUD ESCLAVE
C
      NUMNO     = ZI(JNOCO+POSNO(1)-1)
C
C --- COORDONNEES DU NOEUD ESCLAVE
C
      COORDP(1) = ZR(JCOOR+3*(NUMNO-1))
      COORDP(2) = ZR(JCOOR+3*(NUMNO-1)+1)
      COORDP(3) = ZR(JCOOR+3*(NUMNO-1)+2)
C
C --- PROPRIETES DES NORMALES
C
      PRONOR = ZI(JMETH+ZMETH*(IZONE-1)+8)
      PRONOR = PRONOR + 2 * ZI(JNORLI+1)

      LISSA = 0
      MOYEN = 0
  
      IF (PRONOR.EQ.1) THEN
         MOYEN = 1
      ENDIF    
      IF (PRONOR.GE.2) THEN
        LISSA = 1
        IF (PRONOR.EQ.3) THEN
          MOYEN = 1
        ENDIF
      ENDIF
C
C --- TANGDF : INDICATEUR DE PRESENCE D'UN VECT_Y DEFINI PAR L'USER
C
      TANGDF = ZI(JMETH+ZMETH*(IZONE-1)+2)
C
C --- TOLEIN/TOLEOU : TOLERANCES GEOMETRIQUES
C
      TOLEOU = ZR(JTOLE+ZTOLE*(IZONE-1))
      TOLEIN = ZR(JTOLE+ZTOLE*(IZONE-1)+1)
C 
C --- DIAGNO: DIAGNOSTIC FIN
C --- DIAGNOSTIC FIN ACTIVE POUR:
C      1/ POUR LES QUADRANGLES DECOUPES EN TRIANGLES
C      2/ POUR LES ZONES DE CONTACT SYMETRIQUES
C      3/ SUR ACTIVATION DE L'UTILISATEUR (PAS FAIT)
C
      DIAGNO = 0
C
      CALL JEDEMA()
C ----------------------------------------------------------------------
      END
