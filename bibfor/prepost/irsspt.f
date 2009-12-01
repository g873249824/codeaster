      SUBROUTINE IRSSPT(CESZ,UNITE,NBMAT,NUMMAI,NBCMP,NOMCMP,
     &                  LSUP,LINF,LMAX,LMIN,BORINF,BORSUP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 08/10/2007   AUTEUR REZETTE C.REZETTE 
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
      CHARACTER*(*) CESZ,NOMCMP(*)
      INTEGER       UNITE,NBMAT,NUMMAI(*),NBCMP
      REAL*8        BORINF,BORSUP
      LOGICAL       LSUP,LINF,LMAX,LMIN
C ---------------------------------------------------------------------
C BUT: IMPRIMER LES VALEURS MIN/MAX DES COMPOSANTES D'UN CHAM_ELEM_S
C      A DES SOUS-POINTS
C ---------------------------------------------------------------------
C     ARGUMENTS:
C CESZ   IN/JXIN  K19 : SD CHAM_ELEM_S A IMPRIMER
C UNITE  IN       I   : NUMERO DE L'UNITE LOGIQUE D'IMPRESSION
C NBMAT  IN       I   : /0 : ON IMPRIME TOUTES LES MAILLES
C NBMAT  IN       I   : >0 : ON N'IMPRIME QUE LES MAILLES DE NUMMAI(*)
C                            DE 1 A NBMAT
C NUMMAI IN      V(I) : NUMEROS DES MAILLES A IMPRIMER (SI NBMAT >0)
C NBCMP  IN       I   : NOMBRE DE COMPOSANTES A IMPRIMER
C NOMCMP IN       K8  : NOMS DES COMPOSANTES A IMPRIMER
C LSUP   IN       L   : =.TRUE.  INDIQUE PRESENCE D'UNE BORNE SUPERIEURE
C BORSUP IN       R8  : VALEUR DE LA BORNE SUPERIEURE
C LINF   IN       L   : =.TRUE.  INDIQUE PRESENCE D'UNE BORNE INFERIEURE
C BORINF IN       R8  : VALEUR DE LA BORNE INFERIEURE
C LMAX   IN       L   : =.TRUE.  INDIQUE IMPRESSION VALEUR MAXIMALE
C LMIN   IN       L   : =.TRUE.  INDIQUE IMPRESSION VALEUR MINIMALE
C ---------------------------------------------------------------------
C---- COMMUNS NORMALISES  JEVEUX
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNOM,JEXNUM,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      INTEGER JCESK,JCESD,JCESC,JCESV,JCESL,NCMPC,INDIK8,ICMP,I,JCMP
      INTEGER NCMP,JMA,NBMAC,NBMA,NBPT,NBSP,J,K,IPT,ISP,IAD
      INTEGER ISPMIN,ISPMAX,ISPMI2,ISPMA2,ISPMI3,ISPMA3
      INTEGER IPTMIN,IPTMAX,IPTMI2,IPTMA2,IPTMI3,IPTMA3
      INTEGER IMAMIN,IMAMAX,IMA
      REAL*8  VSPMIN,VSPMAX,VSPMI2,VSPMA2,VSPMI3,VSPMA3,VALR,BINF,BSUP
      REAL*8  VPTMIN,VPTMAX,VPTMI2,VPTMA2,VPTMI3,VPTMA3,VMAMIN,VMAMAX
      CHARACTER*8 K8B,MA,NOMA
      CHARACTER*19 CES
      LOGICAL LMAMIN,LMAMAX,LPTMIN,LPTMAX,LSPMIN,LSPMAX
C     ------------------------------------------------------------------

      CALL JEMARQ()

C --- INITIALISATIONS
C     ---------------
      CES = CESZ

      CALL JEVEUO(CES//'.CESK','L',JCESK)
      CALL JEVEUO(CES//'.CESD','L',JCESD)
      CALL JEVEUO(CES//'.CESC','L',JCESC)
      CALL JEVEUO(CES//'.CESV','L',JCESV)
      CALL JEVEUO(CES//'.CESL','L',JCESL)
      CALL JELIRA(CES//'.CESC','LONMAX',NCMPC,K8B)
      MA = ZK8(JCESK-1+1)
      NBMAC = ZI(JCESD-1+1)

      CALL WKVECT('&&IRSSPT.NUM_CMP_CHAM','V V I',NCMPC,JCMP)
      CALL WKVECT('&&IRSSPT.NUM_MAIL_CHAM','V V I',NBMAC,JMA)

C
C --- ON RECUPERE LES COMPOSANTES AD-HOC:
C     ------------------------------------
C     SI L'UTILISATEUR A RENSEIGNE NOM_CMP
      IF (NBCMP.NE.0)THEN
         NCMP=0
         DO 10 I=1,NBCMP
            ICMP=INDIK8(ZK8(JCESC),NOMCMP(I),1,NCMPC)
            IF (ICMP.NE.0)THEN
               ZI(JCMP+NCMP)=ICMP
               NCMP=NCMP+1
            ENDIF
 10      CONTINUE
      ELSE
C       SINON TOUT_CMP='OUI'
         DO 20 I=1,NCMPC
           ZI(JCMP+I-1)=I
 20      CONTINUE
         NCMP=NCMPC
      ENDIF
C
C --- ON RECUPERE LES MAILLES AD-HOC:
C     -------------------------------
C     SI L'UTILISATEUR A RENSEIGNE MAILLE/GROUP_MA
      IF(NBMAT.NE.0)THEN
         DO 30 I=1,NBMAT
           ZI(JMA+I-1)=NUMMAI(I)
 30      CONTINUE
         NBMA=NBMAT
      ELSE
C        SINON 
         DO 40 I=1,NBMAC
           ZI(JMA+I-1)=I
 40      CONTINUE
         NBMA=NBMAC
      ENDIF

C
C --- RECUPERATION DES VALEURS MIN/MAX
C     -------------------------------
C
C     BOUCLE SUR LES COMPOSANTES
      DO 50 I=1,NCMP
        ICMP=ZI(JCMP+I-1)

C       LMAxxx : BOOLEEN INDIQUANT LE PREMIER PASSAGE
C       LORS DU DES MAILLES POUR STOCKER LES VALEURS 
        LMAMIN=.TRUE.
        LMAMAX=.TRUE.

C       BOUCLE SUR LES MAILLES
        DO 60 J=1,NBMA
          IMA=ZI(JMA+J-1)
          NBPT=ZI(JCESD-1+5+4*(IMA-1)+1)
          NBSP=ZI(JCESD-1+5+4*(IMA-1)+2)

C         LPTxxx : BOOLEEN INDIQUANT LE PREMIER PASSAGE
C         LORS DU PARCOURT DES POINTS POUR STOCKER LES VALEURS MIN/MAX
          LPTMIN=.TRUE.
          LPTMAX=.TRUE.

C         BOUCLE SUR LES POINTS
          DO 70 IPT=1,NBPT

C           VSPMA3: VALEUR MAX SUR TOUS LES SOUS-POINTS 
C           VSPMI3: VALEUR MIN SUR TOUS LES SOUS-POINTS
C           ISPMA3: NUMERO DU SOUS-POINT ASSOCIE A VSPMA3
C           ISPMI3: NUMERO DU SOUS-POINT ASSOCIE A VSPMI3

C           LSPxxx : BOOLEEN INDIQUANT LE PREMIER PASSAGE
C           LORS DU PARCOURT DES SOUS-POINTS POUR STOCKER LES VALEURS
            LSPMIN=.TRUE.
            LSPMAX=.TRUE.

C           BOUCLE SUR LES SOUS-POINTS:
            DO 80 ISP=1,NBSP
              CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,ICMP,IAD)
              IF (IAD.GT.0)THEN

                 VALR=ZR(JCESV+IAD-1)

C                SI VALE_MAX
                 IF(LMAX)THEN
C                  SI BORNE_SUP
                   IF(LSUP)THEN
                     IF((VALR-BORSUP).GT.0.D0)GOTO 80
                   ENDIF
C                  SI BORNE_INF
                   IF(LINF)THEN
                     IF((VALR-BORINF).LT.0.D0)GOTO 80
                   ENDIF
C                  PREMIER PASSAGE
                   IF(LSPMAX)THEN
                     VSPMA3=VALR
                     ISPMA3=ISP
                     LSPMAX=.FALSE.
                   ELSE
                     IF(VALR.GT.VSPMA3)THEN
                       VSPMA3=VALR
                       ISPMA3=ISP
                     ENDIF
                   ENDIF
                 ENDIF

C                SI VALE_MIN
                 IF(LMIN)THEN
C                  SI BORNE_SUP
                   IF(LSUP)THEN
                     IF((VALR-BORSUP).GT.0.D0)GOTO 80
                   ENDIF
C                  SI BORNE_INF
                   IF(LINF)THEN
                     IF((VALR-BORINF).LT.0.D0)GOTO 80
                   ENDIF
C                  PREMIER PASSAGE
                   IF(LSPMIN)THEN
                     VSPMI3=VALR
                     ISPMI3=ISP
                     LSPMIN=.FALSE.
                   ELSE
                     IF(VALR.LT.VSPMI3)THEN
                       VSPMI3=VALR
                       ISPMI3=ISP
                     ENDIF
                   ENDIF
                 ENDIF

              ENDIF

C           FIN BOUCLE SUR LES SOUS-POINTS
 80         CONTINUE

C           VPTMA2: VALEUR MAX SUR TOUS LES POINTS 
C           VPTMI2: VALEUR MIN SUR TOUS LES POINTS
C           IPTMA2: NUMERO DU POINT ASSOCIE A VPTMA2
C           IPTMI2: NUMERO DU POINT ASSOCIE A VPTMI2
C           ISPMA2: NUMERO DU SOUS-POINT ASSOCIE A IPTMA2
C           ISPMI2: NUMERO DU SOUS-POINT ASSOCIE A IPTMI2
C            
C           SI VALE_MAX
            IF(LMAX.AND..NOT.LSPMAX)THEN
C             PREMIER PASSAGE 
              IF(LPTMAX)THEN
                IPTMA2=IPT
                VPTMA2=VSPMA3
                ISPMA2=ISPMA3
                LPTMAX=.FALSE.
              ELSE
C               ON REACTUALISE LA VALEUR MAX
                IF(VPTMA2.LT.VSPMA3)THEN
                  VPTMA2=VSPMA3
                  IPTMA2=IPT
                  ISPMA2=ISPMA3
                ENDIF
              ENDIF
            ENDIF

C           SI VALE_MIN
            IF(LMIN.AND..NOT.LSPMIN)THEN 
C             PREMIER PASSAGE
              IF(LPTMIN)THEN
                IPTMI2=IPT
                VPTMI2=VSPMI3
                ISPMI2=ISPMI3
                LPTMIN=.FALSE.
              ELSE
C               ON REACTUALISE LA VALEUR MIN
                IF(VPTMI2.GT.VSPMI3)THEN
                  VPTMI2=VSPMI3
                  IPTMI2=IPT
                  ISPMI2=ISPMI3
                ENDIF
              ENDIF
            ENDIF

C         FIN BOUCLE SUR LES POINTS
 70       CONTINUE

C         VMAMAX: VALEUR MAX SUR TOUTES LES MAILLES
C         VMAMIN: VALEUR MIN SUR TOUTES LES MAILLES
C         IMAMAX: NUMERO DE LA MAILLE ASSOCIEE A VMAMAX
C         IMAMIN: NUMERO DE LA MAILLE ASSOCIEE A VMAMIN
C         IPTMAX: NUMERO DU POINT ASSOCIE A IMAMAX
C         IPTMIN: NUMERO DU POINT ASSOCIE A IMAMIN
C         ISPMAX: NUMERO DU SOUS-POINT ASSOCIE A IPTMAX
C         ISPMIN: NUMERO DU SOUS-POINT ASSOCIE A IPTMIN

C         SI VALE_MAX
          IF(LMAX.AND..NOT.LPTMAX)THEN 
C           PREMIER PASSAGE
            IF(LMAMAX)THEN
              IMAMAX=IMA
              VMAMAX=VPTMA2
              IPTMAX=IPTMA2
              ISPMAX=ISPMA2
              LMAMAX=.FALSE.
            ELSE
C             ON REACTUALISE LA VALEUR MAX
              IF(VMAMAX.LT.VPTMA2)THEN
                VMAMAX=VPTMA2
                IPTMAX=IPTMA2
                ISPMAX=ISPMA2
                IMAMAX=IMA
              ENDIF
            ENDIF
          ENDIF

C         SI VALE_MIN
          IF(LMIN.AND..NOT.LPTMIN)THEN 
C           PREMIER PASSAGE
            IF(LMAMIN)THEN
              IMAMIN=IMA
              VMAMIN=VPTMI2
              IPTMIN=IPTMI2
              ISPMIN=ISPMI2
              LMAMIN=.FALSE.
            ELSE
C             ON REACTUALISE LA VALEUR MIN
              IF(VMAMIN.GT.VPTMI2)THEN
                VMAMIN=VPTMI2
                IPTMIN=IPTMI2
                ISPMIN=ISPMI2
                IMAMIN=IMA
              ENDIF
            ENDIF
          ENDIF

C     FIN BOUCLE SUR LES MAILLES
 60   CONTINUE

C
C     IMPRESSIONS
C     -----------
C
      IF(LMAX.AND..NOT.LMAMAX)THEN
        CALL JENUNO(JEXNUM(MA//'.NOMMAI',IMAMAX),NOMA)
        WRITE(UNITE,*)' '
        WRITE(UNITE,2000)'LA VALEUR MAXIMALE DE ',ZK8(JCESC+ICMP-1),
     &    'EST: ',VMAMAX
        WRITE(UNITE,2001)'OBTENUE DANS LA MAILLE ',NOMA,
     &    'AU SOUS-POINT ',ISPMAX,' DU POINT ',IPTMAX
      ENDIF

      IF(LMIN.AND..NOT.LMAMIN)THEN
        CALL JENUNO(JEXNUM(MA//'.NOMMAI',IMAMIN),NOMA)
        WRITE(UNITE,*)' '
        WRITE(UNITE,2000)'LA VALEUR MINIMALE DE ',ZK8(JCESC+ICMP-1),
     &    'EST: ',VMAMIN
        WRITE(UNITE,2001)'OBTENUE DANS LA MAILLE ',NOMA,
     &    'AU SOUS-POINT ',ISPMIN,' DU POINT ',IPTMIN
       ENDIF

 50   CONTINUE

2000  FORMAT(3(A),E12.5)
2001  FORMAT(3(A),I3,A,I3)  

      CALL JEDETR('&&IRSSPT.NUM_CMP_CHAM')
      CALL JEDETR('&&IRSSPT.NUM_MAIL_CHAM')

      CALL JEDEMA()

      END
