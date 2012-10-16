      SUBROUTINE IRMASE(NOFIMD,TYPSEC,NBRCOU,NBSECT,NUMMAI,
     &                  SDCARM,NOMASE)
      IMPLICIT NONE
C
      CHARACTER*8   SDCARM
      CHARACTER*(*) NOFIMD,TYPSEC,NOMASE
      INTEGER       NBRCOU,NBSECT,NUMMAI
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 16/10/2012   AUTEUR SELLENET N.SELLENET 
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
C RESPONSABLE SELLENET N.SELLENET
C ----------------------------------------------------------------------
C  IMPR_RESU - IMPRESSION DES MAILLAGES DE SECTION
C  -    -                     --           --
C ----------------------------------------------------------------------
C
C IN  :
C   NOFIMD  K*   ENTIER LIE AU FICHIER MED OUVERT
C   TYPSEC  K*   TYPE DE DE SECTION (COQUE, TUYAU OU PMF)
C   NBRCOU  I    NOMBRE DE COUCHES (COQUE ET TUYAU)
C   NBSECT  I    NOMBRE DE TUYAU
C   NUMMAI  I    NUMERO DE LA MAILLE REFERENCE D'UNE PMF
C   SDCARM  K8   CARA_ELEM CONVERTIT EN CHAM_ELEM_S
C   NOMASE  K*   NOM MED DU MAILLAGE SECTION
C
      INCLUDE 'jeveux.h'
C
      INTEGER       IDFIMD,NBPOIN,IPOINT,JCOOPT,NBRAYO,ICOUCH,IRAYON
      INTEGER       EDLEAJ,POSTMP,CODRET,EDCART,JMASUP,JCESC,JCESD
      INTEGER       EDFUIN,NDIM,NBMASU,IMASUP,EDCAR2,JCESV,JCESL
      INTEGER       NBCMP,ISP,ICMP,IAD
      PARAMETER    (EDLEAJ = 1)
      PARAMETER    (EDCART = 0)
      PARAMETER    (EDFUIN = 0)
C
      CHARACTER*8   SAUX08
      CHARACTER*16  NOCOOR(3),UNCOOR(3),NOCOO2(3),UNCOO2(3)
      CHARACTER*64  NOMASU
      CHARACTER*200 DESMED
C
      REAL*8        XMIN,XMAX,DELTA,RMIN,RMAX,THETA,R8PI,DTHETA
C
      LOGICAL       LMSTRO
C
      DATA NOCOOR  /'X               ',
     &              'Y               ',
     &              'Z               '/
      DATA UNCOOR  /'INCONNU         ',
     &              'INCONNU         ',
     &              'INCONNU         '/
C
      DESMED = ' '
      IF ( NBRCOU.EQ.0.AND.NBSECT.EQ.0.AND.NUMMAI.EQ.0 ) GOTO 9999
C
      CALL MFOUVR(IDFIMD,NOFIMD,EDLEAJ,CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFOUVR'
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C     -- RELECTURE DES ELEMENTS DE STRUCTURES DEJA PRESENTS
      NBMASU = 0
      CALL MFMSNB(IDFIMD,NBMASU,CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFMSNB'
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
      LMSTRO = .FALSE.
      IF ( NBMASU.NE.0 ) THEN
        CALL WKVECT('&&IRMASE.MAIL_SUPP','V V K80',NBMASU,JMASUP)
        DO 40, IMASUP = 1, NBMASU
          CALL MFMSLE(IDFIMD,IMASUP,NOMASU,NDIM,DESMED,
     &                EDCAR2,NOCOO2,UNCOO2,CODRET)
          IF ( CODRET.NE.0 ) THEN
            SAUX08='MFMSLE'
            CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
          ENDIF
          IF ( NOMASU.EQ.NOMASE ) LMSTRO = .TRUE.
  40    CONTINUE
        CALL JEDETR('&&IRMASE.MAIL_SUPP')
        IF ( LMSTRO ) GOTO 9999
      ENDIF
C
      NDIM = 0
      IF ( TYPSEC.EQ.'COQUE' ) THEN
C
        NDIM = 1
        NBPOIN = 3*NBRCOU
        CALL WKVECT('&&IRMASE.COOR_PTS','V V R',NBPOIN,JCOOPT)
        DELTA = 2.D0/NBRCOU
        XMIN = -1.D0
        XMAX = -1.D0+DELTA
        DO 10, IPOINT = 1,NBRCOU
          ZR(JCOOPT+(IPOINT-1)*3)=XMIN
          ZR(JCOOPT+(IPOINT-1)*3+1)=(XMAX+XMIN)/2.D0
          ZR(JCOOPT+(IPOINT-1)*3+2)=XMAX
          XMIN = XMIN+DELTA
          XMAX = XMAX+DELTA
  10    CONTINUE
C
      ELSEIF ( TYPSEC.EQ.'TUYAU' ) THEN
C
        NDIM = 2
        NBRAYO = (NBSECT*2)+1
        NBPOIN = 3*NBRAYO*NBRCOU
        CALL WKVECT('&&IRMASE.COOR_PTS','V V R',2*NBPOIN,JCOOPT)
C
        DTHETA = R8PI()/NBSECT
        THETA = 0.D0
C
        RMIN = 0.5D0
        RMAX = 1.D0
        POSTMP = 0
        DO 20, ICOUCH = 1,NBRCOU
          DO 30, IRAYON = 1,NBRAYO
            ZR(JCOOPT+POSTMP) = RMIN*COS(THETA)
            ZR(JCOOPT+POSTMP+1) = RMIN*SIN(THETA)
            ZR(JCOOPT+POSTMP+2) = (RMIN+RMAX)/2.D0*COS(THETA)
            ZR(JCOOPT+POSTMP+3) = (RMIN+RMAX)/2.D0*SIN(THETA)
            ZR(JCOOPT+POSTMP+4) = RMAX*COS(THETA)
            ZR(JCOOPT+POSTMP+5) = RMAX*SIN(THETA)
            POSTMP = POSTMP+6
            THETA = THETA+DTHETA
  30      CONTINUE
          RMIN = RMIN+0.5D0
          RMAX = RMAX+0.5D0
          THETA = 0.D0
  20    CONTINUE
        CALL ASSERT(POSTMP.EQ.2*NBPOIN)
C
      ELSEIF ( TYPSEC.EQ.'PMF' ) THEN
C
        NDIM = 2
        CALL JEVEUO(SDCARM//'.CAFIBR    .CESC','L',JCESC)
        CALL JEVEUO(SDCARM//'.CAFIBR    .CESD','L',JCESD)
        CALL JEVEUO(SDCARM//'.CAFIBR    .CESV','L',JCESV)
        CALL JEVEUO(SDCARM//'.CAFIBR    .CESL','L',JCESL)
C
        CALL ASSERT(ZI(JCESD+5+4*(NUMMAI-1)).EQ.1)
        NBPOIN = ZI(JCESD+5+4*(NUMMAI-1)+1)
        CALL WKVECT('&&IRMASE.COOR_PTS','V V R',2*NBPOIN,JCOOPT)
        NBCMP = ZI(JCESD+5+4*(NUMMAI-1)+2)
        CALL ASSERT(NBCMP.EQ.3)
        CALL ASSERT(ZK8(JCESC).EQ.'XG      '.AND.
     &              ZK8(JCESC+1).EQ.'YG      ')
C
        POSTMP = 0
        DO 50, ISP = 1,NBPOIN
          DO 60, ICMP = 1,2
            CALL CESEXI('S',JCESD,JCESL,NUMMAI,1,ISP,ICMP,IAD)
            ZR(JCOOPT+POSTMP) = ZR(JCESV-1+IAD)
            POSTMP = POSTMP+1
  60      CONTINUE
  50    CONTINUE
C
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C     -- DEFINITION DU MAILLAGE SUPPORT MED
      CALL MFMSCR(IDFIMD,NOMASE,NDIM,DESMED,EDCART,
     &            NOCOOR,UNCOOR,CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFMSCR'
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C     -- DEFINITION DES NOEUDS DU MAILLAGE SUPPORT MED
      CALL MFCOOE(IDFIMD,NOMASE,ZR(JCOOPT),EDFUIN,NBPOIN,
     &            CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFCOOE'
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
      CALL MFFERM(IDFIMD,CODRET)
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFFERM'
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
      CALL JEDETR('&&IRMASE.COOR_PTS')
C
 9999 CONTINUE
C
      END
