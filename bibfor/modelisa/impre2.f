      SUBROUTINE IMPRE2 (LICOEF,LIDDL,LINOEU,LIBETA,INDSUR,IPNTRL,
     +                   NBTERM,TYPCOE,TYPVAL,IRELA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INTEGER       INDSUR, IPNTRL, NBTERM, IRELA
      CHARACTER*24  LICOEF, LIDDL, LINOEU, LIBETA
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ------
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
      COMMON  / KVARJE /ZK8(1),ZK16(1),ZK24(1),ZK32(1), ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ------
C
      INTEGER       IDECAL, IDCOEF, IDNOEU, IDDL, IDBETA, IFM, IUNIFI
      INTEGER       IDCOE,  IDNOE, IDL, I
      REAL*8        DBLE, DIMAG
      CHARACTER*4   TYPVAL, TYPCOE
C
      IFM = IUNIFI('MESSAGE')
C
C --- LISTE DES COEFFICIENTS :
C     ----------------------
      CALL JEVEUO(LICOEF,'L',IDCOE)
C
C --- LISTE DES DDLS :
C     --------------
      CALL JEVEUO(LIDDL,'L',IDL)
C
C --- LISTE DES NOMS DES NOEUDS :
C     -------------------------
      CALL JEVEUO(LINOEU,'L',IDNOE)
C
C --- NATURE ET VALEUR DU SECOND MEMBRE DE LA RELATION LINEAIRE :
C     ---------------------------------------------------------
      CALL JEVEUO(LIBETA,'L',IDBETA)
C
      IDECAL = IPNTRL - NBTERM
      IDCOEF = IDCOE + IDECAL
      IDNOEU = IDNOE + IDECAL
      IDDL   = IDL   + IDECAL
C
      IF (INDSUR.EQ.1) THEN
         WRITE(IFM,*) 'RELATION LINEAIRE REDONDANTE ET DONC SUPPRIMEE: '
C
C ---   IMPRESSION DE LA RELATION DANS LE CAS OU LES COEFFICIENTS
C ---   SONT REELS :
C       ----------
         IF (TYPCOE.EQ.'REEL') THEN
           WRITE(IFM,10)
           DO 100 I=1,NBTERM-1
             WRITE(IFM,20) ZR(IDCOEF+I-1),ZK8(IDDL+I-1),ZK8(IDNOEU+I-1)
100    CONTINUE
       WRITE(IFM,90) ZR(IDCOEF+NBTERM-1),ZK8(IDDL+NBTERM-1),
     + ZK8(IDNOEU+NBTERM-1)
C
C ---   IMPRESSION DE LA RELATION DANS LE CAS OU LES COEFFICIENTS
C ---   SONT COMPLEXES :
C       --------------
         ELSEIF (TYPCOE.EQ.'COMP') THEN
           WRITE(IFM,30)
           DO 200 I=1,NBTERM-1
             WRITE(IFM,40) DBLE(ZC(IDCOEF+I-1)), DIMAG(ZC(IDCOEF+I-1)),
     +                     ZK8(IDDL+I-1),ZK8(IDNOEU+I-1)
200        CONTINUE
           WRITE(IFM,95) DBLE(ZC(IDCOEF+NBTERM-1)),
     +                   DIMAG(ZC(IDCOEF+NBTERM-1)),
     +                   ZK8(IDDL+NBTERM-1),ZK8(IDNOEU+NBTERM-1)
         ENDIF
C
        IF (TYPVAL.EQ.'REEL') THEN
          WRITE(IFM,50)  ZR(IDBETA+IRELA-1)
        ELSE IF (TYPVAL.EQ.'FONC') THEN
          WRITE(IFM,60)  ZK24(IDBETA+IRELA-1)(1:19)
        ELSE IF (TYPVAL.EQ.'COMP') THEN
          WRITE(IFM,70)  DBLE(ZC(IDBETA+IRELA-1)),
     +                   DIMAG(ZC(IDBETA+IRELA-1))
        ENDIF
      ENDIF
C
      WRITE(IFM,80)
10    FORMAT(2X,'    COEF     ','*','   DDL  ','(',' NOEUD  ',')')
30    FORMAT(13X,'    COEF     ','*','   DDL  ','(',' NOEUD  ',')')
20    FORMAT(2X,1PE12.5,' * ',2X,A6,'(',A8,')','+')
90    FORMAT(2X,1PE12.5,' * ',2X,A6,'(',A8,')')
40    FORMAT(2X,'(',1PE12.5,',',1PE12.5,')',' * ',
     +       2X,A6,'(',A8,')','+')
95    FORMAT(2X,'(',1PE12.5,',',1PE12.5,')',' * ',
     +       2X,A6,'(',A8,')')
50    FORMAT(2X,'=',1PE12.5)
60    FORMAT(2X,'=',A19)
70    FORMAT(2X,'=','(',1PE12.5,',',1PE12.5,')')
80    FORMAT(2X,'______________________________________',//)
      END
