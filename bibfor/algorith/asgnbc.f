      SUBROUTINE  ASGNBC (IBLA,BLOCA,NBTERM,INOBL,IADBL,NOMBLO,
     &                    NUMBLO,FACT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/11/2007   AUTEUR SALMONA L.SALMONA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*24 NOMBLO
      INTEGER     NBTERM,INOBL(NBTERM),IADBL(NBTERM),IBLA,NUMBLO
      REAL*8      FACT
      COMPLEX*16  BLOCA(*)

C-----------------------------------------------------------------------
C  BUT:      < ASSEMBLAGE GENERALISE BAS NIVEAU >
C
C   ASSEMBLER LES TERME D'UN BLOC ELEMENTAIRE DANS LE BLOC ASSEMBLE
C     (TOUS LES TERMES DU BLOC ELEMENTAIRES N'ONT PAS LE BLOC ASSEMBLE
C   COURANT POUR DESTINATION)
C
C-----------------------------------------------------------------------
C
C NOM----- / /:
C
C IBLA     /M/: NUMERO DU BLOC ASSEMBLE COURANT
C BLOCA    /I/: BLOC ASSEMBLE COURANT
C NBTERM   /I/: NOMBRE DE TERMES BLOC ELEMENTAIRE
C INOBL    /I/: VECTEUR NUMERO BLOC ARRIVEES TERME BLOC ELEMENTAIRE
C IADBL    /I/: VECTEUR DES ADRESSE RELATIVE DANS BLOC ASSEMBLE
C NOMBLO   /I/: NOM K24 DU OU DE LA FAMILLE DES BLOCS ELEMENTAIRES
C NUMBLO   /I/: NUMERO DU BLOC ELEMENTAIRE DANS LA FAMILLE OU 0
C FACT     /I/: FACTEUR REEL MULTIPLICATIF
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32  JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
       INTEGER LLBLO,I
       COMPLEX*16 DCMPLX

C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      IF(NUMBLO.EQ.0) THEN
        CALL JEVEUO(NOMBLO,'L',LLBLO)
        DO 10 I=1,NBTERM
          IF(INOBL(I).EQ.IBLA) THEN
            BLOCA(IADBL(I))=BLOCA(IADBL(I))+(FACT*ZC(LLBLO+I-1))
           ENDIF
10      CONTINUE
      ELSE
        CALL JEVEUO(JEXNUM(NOMBLO,NUMBLO),'L',LLBLO)
        DO 20 I=1,NBTERM
          IF(INOBL(I).EQ.IBLA) THEN
            BLOCA(IADBL(I))=BLOCA(IADBL(I))+
     &                      DCMPLX(FACT*ZR(LLBLO+I-1),0.D0)
           ENDIF
20      CONTINUE
      ENDIF
      
      CALL JEDEMA()
      END
