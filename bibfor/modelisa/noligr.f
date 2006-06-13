      SUBROUTINE NOLIGR(LIGRZ,IGREL,NUMEL,NB,LI,LK,CODE,IREPE,
     &                  INEMA,NBNO,TYPLAZ)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) LIGRZ, LK(*), TYPLAZ
      CHARACTER*8   TYPLAG
      CHARACTER*19  LIGR
      INTEGER      IGREL,NUMEL,NB,LI(*),CODE,IREPE,INEMA,NBNO(*)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 02/09/96   AUTEUR CIBHHGB G.BERTRAND 
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
C
C     BUT: REMPLIR LIGR
C      1.  ADJONCTION DU GREL DANS LE LIGR
C      2.  STOCKAGE DES MAILLES ET NOEUDS SUPPLEMENTAIRES:
C        2.1 STOCKAGE DES MAILLES SUPPLEMENTAIRES DANS .NEMA
C        2.2 STOCKAGE DES NUMEROS DES MAILLES SUPPLEMENTAIRES DANS .LIEL
C
C ARGUMENTS D'ENTREE:
C      LIGR : NOM DU LIGREL
C      IGREL: NUMERO DU GREL
C      NUMEL:NUMERO DU TYPE_ELEMENT
C      NB   :NOMBRE DE NOEUDS DE LA LISTE
C      LI   :LISTE DE NUMEROS DE NOEUDS (AU NOMBRE DE NB)
C      LK   :LISTE DE NOMS DE NOEUDS (AU NOMBRE DE -NB)
C      CODE : 1 ==> UNE MAILLE "POI1" PAR NOEUD
C                   (TYPIQUEMENT: FORCE_NODALE)
C           : 2 ==> UNE MAILLE "SEG2" ET UN NOEUD TARDIF PAR NOEUD
C                   (TYPIQUEMENT: DDL_IMPO    )
C           : 3 ==> UNE MAILLE "SEG2" PAR NOEUD, ET UN SEUL NOEUD TARDIF
C                   SON NUMERO EST INCREMENTE PAR LA ROUTINE APPELANTE
C                   (TYPIQUEMENT: LIAISON_DDL )
C   ALTERATION : 2 DDL DE LAGRANGE =>
C           : 2 ==> UNE MAILLE "SEG3" ET 2 NOEUDS TARDIFS PAR NOEUD
C                   (TYPIQUEMENT: DDL_IMPO    )
C           : 3 ==> UNE MAILLE "SEG3" PAR NOEUD, ET 2 NOEUDS TARDIFS
C                   PAR LIAISON
C                   SON NUMERO EST INCREMENTE PAR LA ROUTINE APPELANTE
C                   (TYPIQUEMENT: LIAISON_DDL )
C           : 4 ==> UNE MAILLE "SEG3" PAR NOEUD, ET 2 NOEUDS TARDIFS
C                   PAR LIAISON SUR NB LIAISONS DU MEME TYPE
C                   LES NUMERO DES NOEUDS TARDIFS SONT GERES PAR LA
C                   ROUTINE APPELANTE ( POUR RELATION I NOEUD TARDIF 1
C                   DE NUM : -NBNO(I)+1 ET NOEUD TARDIF 2 -NBNO(I) )
C                   (TYPIQUEMENT: LIAISON_DDL_GROUP )
C      IREPE:NOMBRE DE REPETITIONS DE LA BOUCLE PAR NOEUD
C      INEMA:NUMERO  DE LA DERNIERE MAILLE TARDIVE DANS LIGR
C      NBNO :NUMERO  DU  DERNIER NOEUD TARDIF DANS LIGR OU LISTE DE NUME
C            RO DE NOEUDS TARDIFS(CODE 4)
C      TYPLAG:TYPE DES MULTIPLICATEURS DE LAGRANGE ASSOCIES A LA 
C             RELATION
C          : '12'  ==>  LE PREMIER LAGRANGE EST AVANT LE NOEUD PHYSIQUE
C                       LE SECOND LAGRANGE EST APRES
C          : '22'  ==>  LE PREMIER LAGRANGE EST APRES LE NOEUD PHYSIQUE
C                       LE SECOND LAGRANGE EST APRES
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32      JEXNOM, JEXNUM
C     ------- FIN COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ABSNB
      CHARACTER*24 LIEL,NEMA
      CHARACTER*8 NOMA
C --- DEBUT
      CALL JEMARQ()
      TYPLAG = TYPLAZ
      CALL POSLAG(TYPLAG,ILAG1,ILAG2)
      LIGR=LIGRZ
      LIEL=LIGR//'.LIEL'
      NEMA=LIGR//'.NEMA'
      ABSNB=ABS(NB)
      IF (CODE.EQ.1) THEN
         CALL JENONU (JEXNOM('&CATA.TM.NBNO','POI1'),NUMPOI)
      ELSE IF (CODE.EQ.2) THEN
         CALL JENONU (JEXNOM('&CATA.TM.NBNO','SEG3'),NUMSEG)
      ELSE IF ((CODE.EQ.3).OR.(CODE.EQ.4)) THEN
         CALL JENONU (JEXNOM('&CATA.TM.NBNO','SEG3'),NUMSEG)
      ELSE
         CALL UTDEBM('F','NOLIGR','LE CODE:' )
         CALL UTIMPI('S',' ',1,CODE)
         CALL UTIMPK('S',' ',1,'EST INCONNU ')
         CALL UTFINM()
      END IF
      LONIGR = ABSNB*IREPE + 1
      CALL JECROC (JEXNUM(LIEL,IGREL))
      CALL JEECRA (JEXNUM(LIEL,IGREL),'LONMAX',LONIGR,' ')
      CALL JEVEUO (JEXNUM(LIEL,IGREL),'E',JLIGR)
      CALL JEVEUO (LIGR//'.LGNS', 'E', JDLGNS)
      CALL JEVEUO (LIGR//'.NOMA', 'E', JNOMA)
      NOMA=ZK8(JNOMA)
      KLIGR = 0
      DO 130 IC = 1, IREPE
         DO 110 K = 1, ABSNB
            IF (NB.LT.0) THEN
               CALL JENONU (JEXNOM(NOMA//'.NOMNOE',LK(K)),NUNOEU)
            ELSE
               NUNOEU=LI(K)
            END IF
            IF (CODE.EQ.1) THEN
               INEMA = INEMA + 1
               CALL JECROC (JEXNUM(NEMA,INEMA))
               CALL JEECRA (JEXNUM(NEMA,INEMA),'LONMAX',2,' ')
               CALL JEVEUO (JEXNUM(NEMA,INEMA),'E',JNEMA)
               ZI(JNEMA-1+1) = NUNOEU
               ZI(JNEMA-1+2) = NUMPOI
               KLIGR = KLIGR + 1
               ZI(JLIGR-1+KLIGR) = -INEMA
            ELSE IF (CODE.EQ.2) THEN
               INEMA = INEMA + 1
               CALL JECROC (JEXNUM(NEMA,INEMA))
               CALL JEECRA (JEXNUM(NEMA,INEMA),'LONMAX',4,' ')
               CALL JEVEUO (JEXNUM(NEMA,INEMA),'E',JNEMA)
               ZI(JNEMA-1+1) = NUNOEU
               NBNO(1) = NBNO(1) + 1
               ZI(JNEMA-1+2) = -NBNO(1)
               NBNO(1) = NBNO(1) + 1
               ZI(JNEMA-1+3) = -NBNO(1)
               ZI(JNEMA-1+4) = NUMSEG
               KLIGR = KLIGR + 1
               ZI(JLIGR-1+KLIGR) = -INEMA
            ELSE IF (CODE.EQ.3) THEN
               INEMA = INEMA + 1
               CALL JECROC (JEXNUM(NEMA,INEMA))
               CALL JEECRA (JEXNUM(NEMA,INEMA),'LONMAX',4,' ')
               CALL JEVEUO (JEXNUM(NEMA,INEMA),'E',JNEMA)
               ZI(JNEMA-1+1) = NUNOEU
               ZI(JNEMA-1+2) = -NBNO(1)+1
               ZI(JNEMA-1+3) = -NBNO(1)
               ZI(JNEMA-1+4) = NUMSEG
               KLIGR = KLIGR + 1
               ZI(JLIGR-1+KLIGR) = -INEMA
               ZI(JDLGNS+NBNO(1)-2) = ILAG1
               ZI(JDLGNS+NBNO(1)-1) = ILAG2
            ELSE IF (CODE.EQ.4) THEN
               INEMA = INEMA + 1
               CALL JECROC (JEXNUM(NEMA,INEMA))
               CALL JEECRA (JEXNUM(NEMA,INEMA),'LONMAX',4,' ')
               CALL JEVEUO (JEXNUM(NEMA,INEMA),'E',JNEMA)
               ZI(JNEMA-1+1) = NUNOEU
               ZI(JNEMA-1+2) = -NBNO(K)+1
               ZI(JNEMA-1+3) = -NBNO(K)
               ZI(JNEMA-1+4) = NUMSEG
               KLIGR = KLIGR + 1
               ZI(JLIGR-1+KLIGR) = -INEMA
            END IF
  110    CONTINUE
  130 CONTINUE
      ZI(JLIGR-1+KLIGR+1) = NUMEL
      CALL JEDEMA()
      END
