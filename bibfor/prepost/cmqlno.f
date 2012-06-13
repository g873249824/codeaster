       SUBROUTINE CMQLNO(MAIN,MAOUT,NBNM,NUNOMI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INCLUDE 'jeveux.h'
       INTEGER NBNM,NUNOMI(NBNM)
       CHARACTER*8 MAIN,MAOUT
C-----------------------------------------------------------------------
C    - COMMANDE :  CREA_MAILLAGE / QUAD_LINE
C    - BUT DE LA COMMANDE:
C      TRANSFORMATION DES MAILLES QUADRATIQUES -> LINEAIRES
C    - BUT DE LA ROUTINE: CREATION DES OBJETS
C         '.NOMNOE' , '.COORDO', '.NOMNOE', '.GROUPENO'
C    - ROUTINE APPELEE PAR : CMQLQL
C ----------------------------------------------------------------------
C IN        MAIN   K8   NOM DU MAILLAGE INITIAL
C IN        MAOUT  K8   NOM DU MAILLAGE FINAL
C IN        NBNM    I   NOMBRE DE NOEUDS MILIEUX
C IN        NUNOMI K8   NUMEROS DES NOEUDS MILIEUX
C ----------------------------------------------------------------------
C
C
      INTEGER JDIM,NBTNO,JNON,I,INOEU,NBNO,NBTGNO,NBNOGR,JNAME,
     &     JVAL1,JVAL2,J,JGNOI,JGNOU,KK,JNOGR,JREFE,IRET,IJ
      CHARACTER*1 KBID
      CHARACTER*8 NOM,NNOI
      CHARACTER*19 COORDO,COORDI
      CHARACTER*24 NOMNOI,NOMNOE,GRPNO,DIME
C
      CALL JEMARQ()
C
      NOMNOE   = MAOUT//'.NOMNOE'
      NOMNOI   = MAIN //'.NOMNOE'
      GRPNO    = MAOUT//'.GROUPENO'
      COORDO   = MAOUT//'.COORDO'
      COORDI   = MAIN //'.COORDO'
      DIME     = MAOUT//'.DIME'
C
C     CREATION D'UN TABLEAU DIMENSIONNE AU NOMBRE DE NOEUDS DU
C     MAILLAGE INITIAL PERMETTANT DE SAVOIR SI LE NOEUD SERA
C     PRESENT OU NON DANS LA NOUVELLE SD MAILLAGE.
C     --------------------------------------------
      CALL JEVEUO(MAIN//'.DIME','L',JDIM)
      NBTNO=ZI(JDIM)
      CALL WKVECT('&&CMQLNO_NOEUD','V V I',NBTNO,JNON)
      DO 10 I=1,NBTNO
         ZI(JNON+I-1)=0
 10   CONTINUE
      DO 20 I=1,NBNM
         ZI(JNON+NUNOMI(I)-1)=1
 20   CONTINUE
C
C     RECUPERATION DES NOMS DES NOEUDS
C     --------------------------------
      J=0
      CALL WKVECT('&&CMQLNO.NOM_NOEUDS','V V K8',ZI(JDIM),JNAME)
      DO 30 I=1,NBTNO
         CALL JENUNO(JEXNUM(NOMNOI,I),NOM)
         IF(ZI(JNON+I-1).EQ.0)THEN
           J=J+1
           ZK8(JNAME+J-1)=NOM
         ENDIF
 30   CONTINUE
      NBNO=J

C     CREATION DE L'OBJET '.NOMNOE'
C     ----------------------------
      CALL JECREO(NOMNOE,'G N K8')
      CALL JEVEUO(DIME,'L',JDIM)
      CALL JEECRA(NOMNOE,'NOMMAX',NBNO,KBID)
      DO 31 I=1,NBNO
        CALL JECROC(JEXNOM(NOMNOE,ZK8(JNAME+I-1)))
 31   CONTINUE

C
C     CREATION DE L'OBJET '.COORDO'
C     ----------------------------
      CALL JEDUPO(COORDI//'.DESC' ,'G',COORDO//'.DESC',.FALSE.)
      CALL JEDUPO(COORDI//'.REFE' ,'G',COORDO//'.REFE',.FALSE.)
      CALL JEVEUO(COORDO//'.REFE','E',JREFE)
      ZK24(JREFE) = MAOUT
      CALL JECREO(COORDO//'.VALE','G V R')
      CALL JEECRA(COORDO//'.VALE','LONMAX',NBNO*3,KBID)
      CALL JEVEUO(MAIN//'.COORDO    .VALE','L',JVAL1)
      CALL JEVEUO(COORDO//'.VALE','E',JVAL2)
      DO 40 I=1,NBNO
         CALL JENUNO(JEXNUM(NOMNOE,I),NOM)
         CALL JENONU(JEXNOM(NOMNOI,NOM),INOEU)
         ZR(JVAL2+3*(I-1)  )=ZR(JVAL1+3*(INOEU-1)  )
         ZR(JVAL2+3*(I-1)+1)=ZR(JVAL1+3*(INOEU-1)+1)
         ZR(JVAL2+3*(I-1)+2)=ZR(JVAL1+3*(INOEU-1)+2)
 40   CONTINUE
C
C
C     CREATION DE L'OBJET '.GROUPENO'
C     -------------------------------
      CALL JEEXIN(MAIN//'.GROUPENO',IRET)

      IF(IRET.NE.0)THEN
         CALL JELIRA(MAIN//'.GROUPENO','NMAXOC',NBTGNO,KBID)
         CALL JECREC(GRPNO,'G V I','NO','DISPERSE','VARIABLE',NBTGNO)
         DO 50 I=1,NBTGNO

C           ON RECUPERE LES NOEUDS DU GROUPE QUI DOIVENT ETRE PRESENTS
C           DANS LA NOUVELLE SD MAILLAGE
            CALL JENUNO(JEXNUM(MAIN//'.GROUPENO',I),NOM)
            CALL JELIRA(JEXNOM(MAIN//'.GROUPENO',NOM),'LONUTI',
     &           NBNOGR,KBID)
            CALL JEVEUO(JEXNOM(MAIN//'.GROUPENO',NOM),'L',JGNOI)
            CALL WKVECT('&&CMQLNO.NOEUD_GROUP','V V I',NBNOGR,JNOGR)
            KK=0
            DO 60 J=1,NBNOGR
               IF(ZI(JNON+ZI(JGNOI+J-1)-1).EQ.0)THEN
                  KK=KK+1
                  ZI(JNOGR+KK-1)=ZI(JGNOI+J-1)
               ENDIF
 60         CONTINUE
C           NOMBRE DE NOEUDS DU NOUVEAU GROUPE
            NBNOGR=KK

C           ON AJOUTE DANS '.GROUPENO' LES NUMEROS DES NOEUDS
            IF(NBNOGR.NE.0)THEN
               CALL JECROC(JEXNOM(GRPNO,NOM))
               CALL JEECRA(JEXNOM(GRPNO,NOM),'LONMAX',
     &        MAX(1,NBNOGR),KBID)
               CALL JEECRA(JEXNOM(GRPNO,NOM),'LONUTI',NBNOGR,KBID)
               CALL JEVEUO(JEXNOM(GRPNO,NOM),'E',JGNOU)
               DO 70 J=1,NBNOGR
                IJ=ZI(JNOGR+J-1)
                CALL JENUNO(JEXNUM(NOMNOI,IJ),NNOI)
                CALL JENONU(JEXNOM(NOMNOE,NNOI),ZI(JGNOU+J-1))
 70            CONTINUE
            ENDIF

            CALL JEDETR('&&CMQLNO.NOEUD_GROUP')

 50      CONTINUE


      ENDIF
      CALL JEDETR('&&CMQLNO.NOM_NOEUD')
      CALL JEDETR('&&CMQLNO_NOEUD')
C
      CALL JEDEMA()
C
      END
