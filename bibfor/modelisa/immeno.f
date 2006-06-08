      SUBROUTINE IMMENO(NCNCIN,NMABET,MAILLA,X3DCA,NOEBE,
     &                  NUMAIL,NBCNX,CXMA,XYZMA,
     &                  ITETRA,XBAR,IMMER)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 11/04/2002   AUTEUR DURAND C.DURAND 
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
C-----------------------------------------------------------------------
C  DESCRIPTION : TENTATIVE D'IMMERSION D'UN NOEUD CABLE DANS LES MAILLES
C  -----------   APPARTENANT A LA STRUCTURE BETON
C                APPELANT : IMMECA
C
C  IN     : NCNCIN : CHARACTER*24 ,
C                    OBJET CONTENANT LA CONNECTIVITE INVERSE POUR LE
C                    GROUP_MA BETON
C  IN     : NMABET : CHARACTER*24 ,
C                    OBJET CONTENANT LES MAILLES BETON
C  IN     : MAILLA : CHARACTER*8 , SCALAIRE
C                    NOM DU CONCEPT MAILLAGE ASSOCIE A L'ETUDE
C  IN     : X3DCA  : REAL*8 , VECTEUR DE DIMENSION 3
C                    COORDONNEES DU NOEUD CABLE CONSIDERE
C  IN     : NOEBE  : INTEGER , SCALAIRE
C                    NUMERO DU NOEUD BETON LE PLUS PROCHE DU NOEUD CABLE
C                    CONSIDERE
C  OUT    : NUMAIL : INTEGER , SCALAIRE
C                    SI IMMERSION REUSSIE : NUMERO DE LA MAILLE DANS
C                    LAQUELLE EST REALISEE L'IMMERSION
C  OUT    : NBCNX  : INTEGER , SCALAIRE
C                    SI IMMERSION REUSSIE : NOMBRE DE NOEUDS DE LA
C                    MAILLE DANS LAQUELLE EST REALISEE L'IMMERSION
C  OUT    : CXMA   : INTEGER , VECTEUR DE DIMENSION AU PLUS NNOMAX
C                    SI IMMERSION REUSSIE : NUMEROS DES NOEUDS DE LA
C                    MAILLE DANS LAQUELLE EST REALISEE L'IMMERSION
C                    (TABLE DE CONNECTIVITE)
C  OUT    : XYZMA  : REAL*8 , TABLEAU DE DIMENSIONS (3,NNOMAX)
C                    SI IMMERSION REUSSIE : TABLEAU DES COORDONNEES
C                    DES NOEUDS DE LA MAILLE DANS LAQUELLE EST REALISEE
C                    L'IMMERSION
C  OUT    : ITETRA : INTEGER , SCALAIRE
C                    SI IMMERSION REUSSIE : INDICATEUR DU SOUS-DOMAINE
C                    TETRAEDRE AUQUEL APPARTIENT LE NOEUD CABLE
C                    ITETRA = 1            SI IMMERSION DANS UNE
C                                          MAILLE TETRAEDRE
C                    ITETRA = 1 OU 2       SI IMMERSION DANS UNE
C                                          MAILLE PYRAMIDE
C                    ITETRA = 1 OU 2 OU 3  SI IMMERSION DANS UNE
C                                          MAILLE PENTAEDRE
C                    ITETRA = 1 OU 2 OU 3  SI IMMERSION DANS UNE
C                          OU 4 OU 5 OU 6  MAILLE HEXAEDRE
C  OUT    : XBAR   : REAL*8 , VECTEUR DE DIMENSION 4
C                    SI IMMERSION REUSSIE : COORDONNEES BARYCENTRIQUES
C                    DU NOEUD CABLE DANS LE SOUS-DOMAINE TETRAEDRE
C                    AUQUEL IL APPARTIENT
C  OUT    : IMMER  : INTEGER , SCALAIRE
C                    INDICE D'IMMERSION
C                    IMMER = -1  IMMERSION NON REUSSIE
C                    IMMER =  0  LE NOEUD CABLE EST A L'INTERIEUR
C                                DE LA MAILLE
C                    IMMER = 100 + 10 * NUMERO DE FACE
C                                LE NOEUD CABLE EST SUR UNE FACE
C                                DE LA MAILLE
C                    IMMER = 100 + 10 * NUMERO DE FACE + NUMERO D'ARETE
C                                LE NOEUD CABLE EST SUR UNE ARETE
C                                DE LA MAILLE
C                    IMMER =  2  LE NOEUD CABLE COINCIDE AVEC UN DES
C                                NOEUDS DE LA MAILLE
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNOM, JEXNUM, JEXATR
C     ----- FIN   COMMUNS NORMALISES  JEVEUX  --------------------------
C
C ARGUMENTS
C ---------
      CHARACTER*8   MAILLA
      CHARACTER*24  NCNCIN, NMABET
      INTEGER       NOEBE, NUMAIL, NUMAI0,NBCNX, CXMA(*), ITETRA, IMMER
      REAL*8        X3DCA(*), XYZMA(3,*), XBAR(*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER       IMAIL, INOMA, JCOOR, JCXMA,
     &              NOE, JDRVLC, JCNCIN, IADR, NBM, JLIMAB
      CHARACTER*1   K1B
      CHARACTER*24  CONXMA, COORNO
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      CALL JEMARQ()
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 1   ACCES AUX OBJETS DU CONCEPT MAILLAGE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      CONXMA = MAILLA//'.CONNEX'
      COORNO = MAILLA//'.COORDO    .VALE'
      CALL JEVEUO(COORNO,'L',JCOOR)
      CALL JEVEUO(JEXATR(NCNCIN,'LONCUM'),'L',JDRVLC)
      CALL JEVEUO(JEXNUM(NCNCIN,1)       ,'L',JCNCIN)
      CALL JEVEUO(NMABET,'L',JLIMAB)
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 2   TENTATIVE D'IMMERSION DU NOEUD CABLE CONSIDERE DANS LES MAILLES
C     APPARTENANT A LA STRUCTURE BETON
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C.... BOUCLE SUR LES MAILLES APPARTENANT A LA STRUCTURE BETON, POUR
C.... RETROUVER LE NOEUD BETON LE PLUS PROCHE DANS LES CONNECTIVITES
C
      NBM  = ZI(JDRVLC + NOEBE+1-1) - ZI(JDRVLC + NOEBE-1)
      IADR = ZI(JDRVLC + NOEBE-1)
      DO 10 IMAIL = 1, NBM
         NUMAI0 = ZI(JCNCIN+IADR-1+IMAIL-1)
         NUMAIL = ZI(JLIMAB+NUMAI0-1)
         CALL JELIRA(JEXNUM(CONXMA,NUMAIL),'LONMAX',NBCNX,K1B)
         CALL JEVEUO(JEXNUM(CONXMA,NUMAIL),'L',JCXMA)
C
C........RECUPERATION DES NUMEROS ET DES COORDONNEES DES NOEUDS
C........DE LA MAILLE
C
         DO 30 INOMA = 1, NBCNX
            NOE = ZI(JCXMA+INOMA-1)
            CXMA(INOMA) = NOE
            XYZMA(1,INOMA) = ZR(JCOOR+3*(NOE-1)  )
            XYZMA(2,INOMA) = ZR(JCOOR+3*(NOE-1)+1)
            XYZMA(3,INOMA) = ZR(JCOOR+3*(NOE-1)+2)
  30     CONTINUE
C
C........TEST D'APPARTENANCE DU NOEUD CABLE AU DOMAINE GEOMETRIQUE
C........DEFINI PAR LA MAILLE
C
         IF ( (NBCNX.EQ.4).OR.(NBCNX.EQ.10) ) THEN
            CALL IMMETT(NBCNX,XYZMA(1,1),X3DCA(1),
     &                  ITETRA,XBAR(1),IMMER)
         ELSE IF ( (NBCNX.EQ.5).OR.(NBCNX.EQ.13) ) THEN
            CALL IMMEPY(NBCNX,XYZMA(1,1),X3DCA(1),
     &                  ITETRA,XBAR(1),IMMER)
         ELSE IF ( (NBCNX.EQ.6).OR.(NBCNX.EQ.15) ) THEN
            CALL IMMEPN(NBCNX,XYZMA(1,1),X3DCA(1),
     &                  ITETRA,XBAR(1),IMMER)
         ELSE
            CALL IMMEHX(NBCNX,XYZMA(1,1),X3DCA(1),
     &                  ITETRA,XBAR(1),IMMER)
         ENDIF
C
         IF ( IMMER.GE.0 ) GO TO 9999
C
  10  CONTINUE
C
9999  CONTINUE
      CALL JEDEMA()
C
C --- FIN DE IMMENO.
      END
