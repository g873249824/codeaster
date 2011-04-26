      SUBROUTINE CALCIN(OPTION,MAX,MAY,MAZ,MODEL,VEPRJ,MODX,
     &                  MODY,MODZ,I,J,MIJ)
C-------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-------------------------------------------------------------------
        IMPLICIT REAL*8 (A-H,O-Z)
C
C ROUTINE CALCULANT LA MASSE AJOUTEE SUR LE MODELE THERMIQUE
C  D INTERFACE AINSI QUE LE PREMIER COEFFICIENT D AMORTISSEMENT
C  AJOUTE
C IN :MAX,MAY,MAZ : MATRICES AX ET AY ET AZ
C IN: VEPRJ: PRESSION PROJETEE DUE AU MODE OU CHAMNO J
C IN: MODEL: K2 : CHAINE DISTINGUANT LE TYPE DE MODELISATION
C IN: MODX,MODY,MODZ : DEPLACEMENTS PROJETES
C OUT : MIJ : MASSE AJOUTEE
C-------------------------------------------------------------------
C---------- DEBUT DES COMMUNS JEVEUX -------------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16           ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C----------- FIN DES COMMUNS JEVEUX -------------------------------
      INTEGER       IPRES,I,J
      REAL*8        MIJ
      CHARACTER*(*) MODEL,OPTION
      CHARACTER*19  MODX,MODY,MODZ,VEPRJ,MAX,MAY,MAZ
      CHARACTER*1 K1BID
C--------------------------------------------------------------------

      CALL JEMARQ()
           CALL JEVEUO(MODX//'.VALE','L',IMODX)
           CALL JEVEUO(MODY//'.VALE','L',IMODY)

           CALL JEVEUO(VEPRJ//'.VALE','L',IPRES)
           CALL JELIRA(VEPRJ//'.VALE','LONMAX',NBPRES,K1BID)

           CALL WKVECT('&&CALCIN.VECTX','V V R',NBPRES,IVECX)
           CALL WKVECT('&&CALCIN.VECTY','V V R',NBPRES,IVECY)

C --- RECUPERATION DES DESCRIPTEURS DE MATRICES ASSEMBLEES MAX ET MAY

           CALL MTDSCR(MAX)
           CALL JEVEUO(MAX(1:19)//'.&INT','E',IMATX)
           CALL MTDSCR(MAY)
           CALL JEVEUO(MAY(1:19)//'.&INT','E',IMATY)

C------MULTIPLICATIONS MATRICE MAX * CHAMNO MODX---------------------
C----------ET MATRICE MAY * CHAMNO MODY------------------------------

           CALL MRMULT('ZERO',IMATX,ZR(IMODX),'R',ZR(IVECX),1)
           CALL MRMULT('ZERO',IMATY,ZR(IMODY),'R',ZR(IVECY),1)

C--PRODUITS SCALAIRES VECTEURS PRESSION PAR MAX*MODX ET MAY*MODY

           RX= DDOT(NBPRES,ZR(IPRES), 1,ZR(IVECX),1)
           RY= DDOT(NBPRES,ZR(IPRES), 1,ZR(IVECY),1)

C
C---------------- MENAGE SUR LA VOLATILE ---------------------------
C

           CALL JEDETR('&&CALCIN.VECTX')
           CALL JEDETR('&&CALCIN.VECTY')

           CALL JEDETC('V',MODX,1)
           CALL JEDETC('V',MODY,1)





C------ MASSE AJOUTEE = PRESSION*MAX*MODX + PRESSION*MAY*MODY-------
C--------------------------+ PRESSION*MAZ*MODZ  EN 3D---------------
           IF (MODEL.EQ.'3D') THEN

             CALL JEVEUO(MODZ//'.VALE','L',IMODZ)
             CALL WKVECT('&&CALCIN.VECTZ','V V R',NBPRES,IVECZ)
             CALL MTDSCR(MAZ)
             CALL JEVEUO(MAZ(1:19)//'.&INT','E',IMATZ)
             CALL MRMULT('ZERO',IMATZ,ZR(IMODZ),'R',ZR(IVECZ),1)
             RZ= DDOT(NBPRES,ZR(IPRES), 1,ZR(IVECZ),1)
             CALL JEDETR('&&CALCIN.VECTZ')
             CALL JEDETC('V',MODZ,1)
             MIJ = RX+RY+RZ

           ELSE
             MIJ = RX+RY
           ENDIF

        IF ((I.EQ.J).AND.(MIJ.LT.0).AND.(OPTION.EQ.'MASS_AJOU')) THEN
       CALL U2MESS('A','ALGORITH_60')
        ENDIF
        IF ((I.EQ.J).AND.(MIJ.LT.0).AND.(OPTION.EQ.'AMOR_AJOU')) THEN
       CALL U2MESS('A','ALGORITH_61')
        ENDIF

        CALL JEDETC('V',VEPRJ,1)

C-----------------------------------------------------------------
      CALL JEDEMA()
           END
