      SUBROUTINE TRAJCA(TABLCA,MAILLA,ICABL,NBNOCA,XNOCA,YNOCA,ZNOCA)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C  DESCRIPTION : INTERPOLATION DE LA TRAJECTOIRE D'UN CABLE
C  -----------   APPELANT : OP0180 , OPERATEUR DEFI_CABLE_BP
C
C                EN SORTIE ON COMPLETE LA TABLE RESULTAT
C                LES LIGNES COMPLETEES CORRESPONDENT AU DERNIER CABLE
C                LES CASES RENSEIGNEES CORRESPONDENT AUX PARAMETRES
C                <ABSC_CURV> ET <ALPHA>
C
C  IN     : TABLCA : CHARACTER*19
C                    NOM DE LA TABLE DECRIVANT LES CABLES
C  IN     : MAILLA : CHARACTER*8 , SCALAIRE
C                    NOM DU CONCEPT MAILLAGE ASSOCIE A L'ETUDE
C  IN     : ICABL  : INTEGER , SCALAIRE
C                    NUMERO DU CABLE
C  IN     : NBNOCA : INTEGER , VECTEUR DE DIMENSION NBCABL
C                    CONTIENT LES NOMBRES DE NOEUDS DE CHAQUE CABLE
C  IN     : XNOCA  : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR DE REELS POUR STOCKAGE DES
C                    ABSCISSES X DES NOEUDS APPARTENANT AUX CABLES
C  IN     : YNOCA  : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR DE REELS POUR STOCKAGE DES
C                    ORDONNEES Y DES NOEUDS APPARTENANT AUX CABLES
C  IN     : ZNOCA  : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR DE REELS POUR STOCKAGE DES
C                    COTES Z DES NOEUDS APPARTENANT AUX CABLES
C
C  N.B. LES VECTEURS XNOCA, YNOCA ET ZNOCA SONT COMPLETES A CHAQUE
C       PASSAGE DANS LA ROUTINE TRAJCA : REAJUSTEMENT DE LEUR DIMENSION
C       PUIS REMPLISSAGE DES DERNIERS SOUS-BLOCS ALLOUES
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
      CHARACTER*19  XNOCA, YNOCA, ZNOCA, TABLCA
      INTEGER       ICABL, NBNOCA(*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER       IBID, IDECAL, INO, IPARA, IRET, ISUB, JABSC, JALPH,
     &              JCOOR, JCORD, JNOCA, JTBLP, JTBNP, JD2X, JD2Y, JD2Z,
     &              JX, JY, JZ, NBLIGN, NBNO, NBPARA, NUMNOE
      REAL*8        ABSC, ALPHA, CORDE,
     &              D1X, D1X1, D1XN, D1Y, D1Y1, D1YN, D1Z, D1Z1, D1ZN,
     &              D2X, D2Y, D2Z, DC, DC1, DCN, DET1, DET2, DET3, DU,
     &              DX, DY, DZ, NORMV2, VALPAR(2)
      COMPLEX*16    CBID
      CHARACTER*3   K3B
      CHARACTER*24  COORNO, NONOCA, NONOMA
C
      INTEGER       NBSUB
      PARAMETER    (NBSUB=5)
      CHARACTER*24  PARAM(2), PARCR
      DATA          PARAM /'ABSC_CURV               ',
     &                     'ALPHA                   '/
      DATA          PARCR /'NOEUD_CABLE             '/
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      CALL JEMARQ()
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 1   CREATION DES OBJETS DE TRAVAIL
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      NBNO = NBNOCA(ICABL)
      CALL WKVECT('&&TRAJCA.CORDE_CUMU','V V R',NBNO,JCORD)
      CALL WKVECT('&&TRAJCA.D2X'       ,'V V R',NBNO,JD2X )
      CALL WKVECT('&&TRAJCA.D2Y'       ,'V V R',NBNO,JD2Y )
      CALL WKVECT('&&TRAJCA.D2Z'       ,'V V R',NBNO,JD2Z )
      CALL WKVECT('&&TRAJCA.ABSC_CURV' ,'V V R',NBNO,JABSC)
      CALL WKVECT('&&TRAJCA.ALPHA'     ,'V V R',NBNO,JALPH)
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 2   RECUPERATION DES COORDONNEES DES NOEUDS DU CABLE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      CALL JEVEUO(TABLCA//'.TBNP','L',JTBNP)
      NBPARA = ZI(JTBNP)
      NBLIGN = ZI(JTBNP+1)
      CALL JEVEUO(TABLCA//'.TBLP','L',JTBLP)
      DO 10 IPARA = 1, NBPARA
         IF ( ZK24(JTBLP+4*(IPARA-1)).EQ.PARCR ) THEN
            NONOCA = ZK24(JTBLP+4*(IPARA-1)+2)
            CALL JEVEUO(NONOCA,'L',JNOCA)
            GO TO 20
         ENDIF
  10  CONTINUE
C
  20  CONTINUE
      IDECAL = NBLIGN - NBNO
C
      CALL JEECRA(XNOCA,'LONUTI',NBLIGN,' ')
      CALL JEVEUO(XNOCA,'E',JX)
      CALL JEECRA(YNOCA,'LONUTI',NBLIGN,' ')
      CALL JEVEUO(YNOCA,'E',JY)
      CALL JEECRA(ZNOCA,'LONUTI',NBLIGN,' ')
      CALL JEVEUO(ZNOCA,'E',JZ)
C
      NONOMA = MAILLA//'.NOMNOE'
      COORNO = MAILLA//'.COORDO    .VALE'
      CALL JEVEUO(COORNO,'L',JCOOR)
      DO 30 INO = 1, NBNO
         CALL JENONU(JEXNOM(NONOMA,ZK8(JNOCA+IDECAL+INO-1)),NUMNOE)
         ZR(JX+IDECAL+INO-1) = ZR(JCOOR+3*(NUMNOE-1)  )
         ZR(JY+IDECAL+INO-1) = ZR(JCOOR+3*(NUMNOE-1)+1)
         ZR(JZ+IDECAL+INO-1) = ZR(JCOOR+3*(NUMNOE-1)+2)
  30  CONTINUE
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 3   CALCUL DU PARAMETRE CORDE CUMULEE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      ZR(JCORD) = 0.0D0
C
C.... N.B. LE PASSAGE PREALABLE DANS LA ROUTINE TOPOCA GARANTIT NBNO > 2
C
      DO 40 INO = 2, NBNO
         DX = ZR(JX+IDECAL+INO-1) - ZR(JX+IDECAL+INO-2)
         DY = ZR(JY+IDECAL+INO-1) - ZR(JY+IDECAL+INO-2)
         DZ = ZR(JZ+IDECAL+INO-1) - ZR(JZ+IDECAL+INO-2)
         DU = DBLE ( SQRT ( DX * DX + DY * DY + DZ * DZ ) )
         IF ( DU.EQ.0.0D0 ) THEN
            WRITE(K3B,'(I3)') ICABL
            CALL UTMESS('F','TRAJCA','INTERPOLATION DE LA '//
     &                  'TRAJECTOIRE DU CABLE NO'//K3B//' : DEUX '//
     &                  'NOEUDS SONT GEOMETRIQUEMENT CONFONDUS')
         ENDIF
         ZR(JCORD+INO-1) = ZR(JCORD+INO-2) + DU
  40  CONTINUE
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 4   INTERPOLATION SPLINE CUBIQUE DE LA TRAJECTOIRE DU CABLE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      DC1 = ZR(JCORD+1) - ZR(JCORD)
      DCN = ZR(JCORD+NBNO-1) - ZR(JCORD+NBNO-2)
C
C 4.1 INTERPOLATION DE LA COORDONNEE X
C ---
      D1X1 = ( ZR(JX+IDECAL+1) - ZR(JX+IDECAL) ) / DC1
      D1XN = ( ZR(JX+IDECAL+NBNO-1) - ZR(JX+IDECAL+NBNO-2) ) / DCN
      CALL SPLINE(ZR(JCORD),ZR(JX+IDECAL),NBNO,D1X1,D1XN,ZR(JD2X),IRET)
C
C 4.2 INTERPOLATION DE LA COORDONNEE Y
C ---
      D1Y1 = ( ZR(JY+IDECAL+1) - ZR(JY+IDECAL) ) / DC1
      D1YN = ( ZR(JY+IDECAL+NBNO-1) - ZR(JY+IDECAL+NBNO-2) ) / DCN
      CALL SPLINE(ZR(JCORD),ZR(JY+IDECAL),NBNO,D1Y1,D1YN,ZR(JD2Y),IRET)
C
C 4.3 INTERPOLATION DE LA COORDONNEE Z
C ---
      D1Z1 = ( ZR(JZ+IDECAL+1) - ZR(JZ+IDECAL) ) / DC1
      D1ZN = ( ZR(JZ+IDECAL+NBNO-1) - ZR(JZ+IDECAL+NBNO-2) ) / DCN
      CALL SPLINE(ZR(JCORD),ZR(JZ+IDECAL),NBNO,D1Z1,D1ZN,ZR(JD2Z),IRET)
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 5   CALCULS DE L'ABSCISSE CURVILIGNE ET DE LA DEVIATION ANGULAIRE
C     CUMULEE LE LONG DU CABLE, PAR INTEGRATION NUMERIQUE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      ZR(JABSC) = 0.0D0
      ZR(JALPH) = 0.0D0
C
      DO 50 INO = 2, NBNO
C
         CORDE = ZR(JCORD+INO-2)
         DC = ( ZR(JCORD+INO-1) - CORDE ) / DBLE ( NBSUB )
C
C....... CONTRIBUTION DU PREMIER POINT
C
         CALL SPLIN1(ZR(JCORD),ZR(JX+IDECAL),ZR(JD2X),NBNO,CORDE,D1X,
     &               IRET)
         CALL SPLIN1(ZR(JCORD),ZR(JY+IDECAL),ZR(JD2Y),NBNO,CORDE,D1Y,
     &               IRET)
         CALL SPLIN1(ZR(JCORD),ZR(JZ+IDECAL),ZR(JD2Z),NBNO,CORDE,D1Z,
     &               IRET)
         CALL SPLIN2(ZR(JCORD),ZR(JD2X),NBNO,CORDE,D2X,IRET)
         CALL SPLIN2(ZR(JCORD),ZR(JD2Y),NBNO,CORDE,D2Y,IRET)
         CALL SPLIN2(ZR(JCORD),ZR(JD2Z),NBNO,CORDE,D2Z,IRET)
         NORMV2 = D1X * D1X + D1Y * D1Y + D1Z * D1Z
         IF ( NORMV2.EQ.0.0D0 ) THEN
            WRITE(K3B,'(I3)') ICABL
            CALL UTMESS('F','TRAJCA','INTERPOLATION DE LA '//
     &                  'TRAJECTOIRE DU CABLE NO'//K3B//' : '//
     &                  'DETECTION D UN POINT DE REBROUSSEMENT')
         ENDIF
         ABSC = DBLE ( SQRT ( NORMV2 ) ) / 2.0D0
         DET1 = D1Y * D2Z - D1Z * D2Y
         DET2 = D1Z * D2X - D1X * D2Z
         DET3 = D1X * D2Y - D1Y * D2X
         ALPHA = DBLE ( SQRT ( DET1*DET1 + DET2*DET2 + DET3*DET3 ) )
     &         / ( NORMV2 * 2.0D0 )
C
C....... CONTRIBUTION DES POINTS INTERMEDIAIRES
C
         DO 60 ISUB = 1, NBSUB-1
            CORDE = CORDE + DC
            CALL SPLIN1(ZR(JCORD),ZR(JX+IDECAL),ZR(JD2X),NBNO,CORDE,D1X,
     &                  IRET)
            CALL SPLIN1(ZR(JCORD),ZR(JY+IDECAL),ZR(JD2Y),NBNO,CORDE,D1Y,
     &                  IRET)
            CALL SPLIN1(ZR(JCORD),ZR(JZ+IDECAL),ZR(JD2Z),NBNO,CORDE,D1Z,
     &                  IRET)
            CALL SPLIN2(ZR(JCORD),ZR(JD2X),NBNO,CORDE,D2X,IRET)
            CALL SPLIN2(ZR(JCORD),ZR(JD2Y),NBNO,CORDE,D2Y,IRET)
            CALL SPLIN2(ZR(JCORD),ZR(JD2Z),NBNO,CORDE,D2Z,IRET)
            NORMV2 = D1X * D1X + D1Y * D1Y + D1Z * D1Z
            IF ( NORMV2.EQ.0.0D0 ) THEN
               WRITE(K3B,'(I3)') ICABL
               CALL UTMESS('F','TRAJCA','INTERPOLATION DE LA '//
     &                     'TRAJECTOIRE DU CABLE NO'//K3B//' : '//
     &                     'DETECTION D UN POINT DE REBROUSSEMENT')
            ENDIF
            ABSC = ABSC + DBLE ( SQRT ( NORMV2 ) )
            DET1 = D1Y * D2Z - D1Z * D2Y
            DET2 = D1Z * D2X - D1X * D2Z
            DET3 = D1X * D2Y - D1Y * D2X
            ALPHA = ALPHA + DBLE(SQRT(DET1*DET1+DET2*DET2+DET3*DET3))
     &                      / NORMV2
  60     CONTINUE
C
C....... CONTRIBUTION DU DERNIER POINT
C
         CORDE = CORDE + DC
         CALL SPLIN1(ZR(JCORD),ZR(JX+IDECAL),ZR(JD2X),NBNO,CORDE,D1X,
     &               IRET)
         CALL SPLIN1(ZR(JCORD),ZR(JY+IDECAL),ZR(JD2Y),NBNO,CORDE,D1Y,
     &               IRET)
         CALL SPLIN1(ZR(JCORD),ZR(JZ+IDECAL),ZR(JD2Z),NBNO,CORDE,D1Z,
     &               IRET)
         CALL SPLIN2(ZR(JCORD),ZR(JD2X),NBNO,CORDE,D2X,IRET)
         CALL SPLIN2(ZR(JCORD),ZR(JD2Y),NBNO,CORDE,D2Y,IRET)
         CALL SPLIN2(ZR(JCORD),ZR(JD2Z),NBNO,CORDE,D2Z,IRET)
         NORMV2 = D1X * D1X + D1Y * D1Y + D1Z * D1Z
         IF ( NORMV2.EQ.0.0D0 ) THEN
            WRITE(K3B,'(I3)') ICABL
            CALL UTMESS('F','TRAJCA','INTERPOLATION DE LA '//
     &                  'TRAJECTOIRE DU CABLE NO'//K3B//' : '//
     &                  'DETECTION D UN POINT DE REBROUSSEMENT')
         ENDIF
         ABSC = ABSC + DBLE ( SQRT ( NORMV2 ) ) / 2.0D0
         DET1 = D1Y * D2Z - D1Z * D2Y
         DET2 = D1Z * D2X - D1X * D2Z
         DET3 = D1X * D2Y - D1Y * D2X
         ALPHA = ALPHA + DBLE(SQRT(DET1*DET1+DET2*DET2+DET3*DET3))
     &                   / ( NORMV2 * 2.0D0 )
C
C....... ABSCISSE CURVILIGNE ET DEVIATION ANGULAIRE CUMULEE
C
         ABSC = ABSC * DC
         ZR(JABSC+INO-1) = ZR(JABSC+INO-2) + ABSC
         ALPHA = ALPHA * DC
         ZR(JALPH+INO-1) = ZR(JALPH+INO-2) + ALPHA
C
  50  CONTINUE
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 6   MISE A JOUR DES OBJETS DE SORTIE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      DO 70 INO = 1, NBNO
         VALPAR(1) = ZR(JABSC+INO-1)
         VALPAR(2) = ZR(JALPH+INO-1)
         CALL TBAJLI(TABLCA,2,PARAM,IBID,VALPAR,CBID,K3B,IDECAL+INO)
  70  CONTINUE
C
      CALL JEDETC('V','&&TRAJCA',1)
      CALL JEDEMA()
C
C --- FIN DE TRAJCA.
      END
