      SUBROUTINE IRGNAL ( IFI, NBORDR, COORD, CONNEX, POINT,
     +                    NOCMP, NBCMP,
     +                    NUMEL, NOBJ, NBEL, CNSC, CNSL, CNSV, CNSD )
      IMPLICIT NONE
C
      INTEGER        NUMEL, NBEL, IFI, NBORDR, NBCMP
      INTEGER        CONNEX(*), POINT(*),
     +               CNSC(*), CNSL(*), CNSV(*), CNSD(*) 
      REAL*8         COORD(*)
      CHARACTER*(*)  NOBJ
      CHARACTER*8    NOCMP(NBCMP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/02/2004   AUTEUR MCOURTOI M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     IMPRESSION D'UN CHAM_NO AU FORMAT GMSH :
C     NUMEL   : NUMERO DE L'ELEMENT DANS TYPE_MAILLE__.CATA
C     NBEL    : NBRE D'ELEMENTS DE CE TYPE
C     CHAMP   : VECTORIEL SI NBCMP=3
C               SCALAIRE  SI NBCMP=1
C     NOCMP   : NOMS DES NBCMP COMPOSANTES
C
C     REMPLACE IRGN.1 ET 2 (OU .=PSTQEYRH)
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32 JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER      IEL, IMA, IPOIN, LISTNO(99), J, JCNSC, JCNSL, JCNSV,
     +             JCNSD, NCMP, K, JEL, IOR, INOE, NBNO, L, JNO
      REAL*8       VAL(NBCMP)
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- VERIF QU'ON N'EST PAS HORS SCOPE D'UTILISATION
C     (CHAMP SCALAIRE OU VECTEUR)
      IF(NBCMP.NE.1.AND.NBCMP.NE.3)
     +   CALL UTMESS('F','IRGNAL','ERREUR DE PROGRAMMATION : '//
     +               'NBCMP DIFFERENT DE 1 OU 3.')
C
      CALL JEVEUO ( NOBJ, 'L', JEL )
      CALL JEVEUO(JEXNUM('&CATA.TM.NBNO',NUMEL),'L',JNO)
      NBNO=ZI(JNO)
C
      IF(NBNO.GT.99)
     +   CALL UTMESS('F','IRGNAL','ON NE PEUT PAS TRAITER DES ELEMENTS'
     +                   //' A PLUS DE 99 NOEUDS !')
C
C     BOUCLE SUR LES ELEMENTS
      DO 10 IEL = 1 , NBEL
         IMA = ZI(JEL-1+IEL)
         IPOIN = POINT(IMA)

         DO 100 J=1,NBNO
            LISTNO(J) = CONNEX(IPOIN-1+J)
 100     CONTINUE

C        COORDONNEES DES NOEUDS
         DO 110 J=1,3
            WRITE(IFI,1099) (COORD(3*(LISTNO(INOE)-1)+J),INOE=1,NBNO)
 110     CONTINUE
C
C        POUR CHAQUE INSTANT...
         DO 120 IOR = 1 , NBORDR
            JCNSC = CNSC(IOR)
            JCNSL = CNSL(IOR)
            JCNSV = CNSV(IOR)
            JCNSD = CNSD(IOR)
            NCMP  = ZI(JCNSD-1+2)        

C           ...EN CHAQUE NOEUD...
            DO 1210 INOE = 1 , NBNO

               DO 1215 L = 1, NBCMP
                  VAL(L) = 0.D0
 1215          CONTINUE

C              ...ON CHERCHE LES COMPOSANTES A ECRIRE...
               DO 1220 K = 1 , NCMP
                  
                  DO 1230 L = 1, NBCMP
                     IF ( ZK8(JCNSC-1+K) .EQ. NOCMP(L)) THEN
                        IF (ZL(JCNSL-1+(LISTNO(INOE)-1)*NCMP+K)) THEN
                           VAL(L) = ZR(JCNSV-1+(LISTNO(INOE)-1)*NCMP+K)
                           IF (ABS(VAL(L)).LE.1.D-99) VAL(L)=0.D0
                        ENDIF
                     ENDIF
 1230             CONTINUE

 1220          CONTINUE

C              ...ET ON IMPRIME LES VALEURS DES COMPOSANTES DE NOCMP
               WRITE(IFI,1099) (VAL(L),L=1,NBCMP)

 1210       CONTINUE

 120     CONTINUE
                 
 10   CONTINUE
C
      CALL JELIBE ( NOBJ )
      CALL JEDEMA()
C
 1099 FORMAT(1P,4(E15.8,1X))
C
      END
