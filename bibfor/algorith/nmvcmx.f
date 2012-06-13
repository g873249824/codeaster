      SUBROUTINE NMVCMX(MATE  ,MAILLA,COMREF,COMVAL)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24  MATE  ,COMREF
      CHARACTER*19  COMVAL
      CHARACTER*8   MAILLA
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C RECHERCHE DES MAXIMUM/ MIMINUM DES VARIABLES DE COMMANDES
C
C ----------------------------------------------------------------------
C
C
C IN  MATE   : CHAMP MATERIAU
C IN  COMREF : VARI_COM DE REFERENCE
C IN  COMVAL : VARI_COM
C
C
C
C
      INTEGER      NBCMP,NBCMP2
      CHARACTER*1  K1BID
      CHARACTER*8  VALK(5)
      CHARACTER*19 CHSREF,CHSCOM
      CHARACTER*24 VRCPLU,VRCREF
      INTEGER      JCESD,JCESL,JCESV,NBMA,NBPT,NBSP,ICMP
      INTEGER      JCRSD,JCRSL,JCRSV,VALI,IMA,IPT,ISP,IAD,IAD2
      INTEGER      IMAMAX,IMAMIN,JNOM,JVARC,IREF
      REAL*8       VALMIN,VALMAX,VALR(2),R8MAEM
      REAL*8       VALEUR,VALREF
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CHSCOM = '&&NMVCMX.COMVAL_SIM'
      CHSREF = '&&NMVCMX.COMREF_SIM'
C
C --- EXTRACTION DES VARIABLES DE COMMANDE
C
      CALL NMVCEX('TOUT',COMREF,VRCREF)
      CALL NMVCEX('TOUT',COMVAL,VRCPLU)
C
C --- TRANSFO. EN CHAM_NO_S
C
      CALL CELCES(VRCPLU,'V',CHSCOM)
      CALL CELCES(VRCREF,'V',CHSREF)

      CALL U2MESS('A+','MECANONLINE2_97')

C     CALCUL DU MIN / MAX

C     DESCRIPTEUR
      CALL JEVEUO(CHSCOM//'.CESD','L',JCESD)
      CALL JEVEUO(CHSREF//'.CESD','L',JCRSD)
C     PRESENCE DES CMP (R)
      CALL JEVEUO(CHSCOM//'.CESL','L',JCESL)
      CALL JEVEUO(CHSREF//'.CESL','L',JCRSL)
C     VALEUR DES CMP (R)
      CALL JEVEUO(CHSCOM//'.CESV','L',JCESV)
      CALL JEVEUO(CHSREF//'.CESV','L',JCRSV)

C     RECUPERATION DES NOMS DES VARC
      CALL JELIRA(MATE(1:8)//'.CVRCNOM','LONMAX',NBCMP2,K1BID)
      CALL JEVEUO(MATE(1:8)//'.CVRCNOM','L',JNOM)
      CALL JEVEUO(MATE(1:8)//'.CVRCVARC','L',JVARC)

      NBMA = ZI(JCESD-1+1)

      DO 10,ICMP = 1,NBCMP2
         VALMAX=-R8MAEM()
         VALMIN=R8MAEM()
         IMAMIN=0
         IREF=0
         IF (ZK8(JVARC-1+ICMP).EQ.'TEMP'
     &   .OR.ZK8(JVARC-1+ICMP).EQ.'SECH') THEN
            IREF=1
         ENDIF

         DO 40,IMA = 1,NBMA
            NBCMP = ZI(JCESD-1+5+4* (IMA-1)+3)
            IF (NBCMP.EQ.0) GOTO 40
            CALL CESEXI('C',JCRSD,JCRSL,IMA,1,1,ICMP,IAD2)
            IF (IAD2.LE.0) GOTO 40


C           VALEURS DE REFERENCE
            IF (IREF.EQ.1) THEN
               CALL CESEXI('C',JCRSD,JCRSL,IMA,1,1,ICMP,IAD2)
               VALREF = ZR(JCRSV-1+IAD2)
            ENDIF
            NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
            NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)
            DO 30,IPT = 1,NBPT
               DO 20,ISP = 1,NBSP
                  CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,ICMP,IAD)
                  IF (IAD.GT.0) THEN
                      VALEUR = ZR(JCESV-1+IAD)

                      IF (IREF.EQ.1) THEN
                         VALEUR=ABS(VALEUR-VALREF)
                      ENDIF
                      IF (VALEUR.GT.VALMAX) THEN
                         IMAMAX=IMA
                         VALMAX=VALEUR
                      ENDIF
                      IF (VALEUR.LT.VALMIN) THEN
                         IMAMIN=IMA
                         VALMIN=VALEUR
                      ENDIF
                  ENDIF
 20            CONTINUE
 30         CONTINUE
 40      CONTINUE
         VALK(2)=ZK8(JNOM-1+ICMP)
         VALK(1)=ZK8(JVARC-1+ICMP)
         VALR(1)=VALMAX
         VALR(2)=VALMIN
         CALL JENUNO(JEXNUM(MAILLA//'.NOMMAI',IMAMAX),VALK(3))
         CALL JENUNO(JEXNUM(MAILLA//'.NOMMAI',IMAMIN),VALK(4))
         IF (IREF.EQ.1) THEN
            VALK(5)=VALK(1)
            CALL U2MESG('A+','MECANONLINE2_95',5,VALK,0,VALI,2,VALR)
         ELSE
            CALL U2MESG('A+','MECANONLINE2_94',4,VALK,0,VALI,2,VALR)
         ENDIF
 10   CONTINUE
      CALL U2MESS('A','MECANONLINE2_93')
C
      CALL JEDETR(CHSCOM)
      CALL JEDETR(CHSREF)
      CALL JEDEMA()
      END
