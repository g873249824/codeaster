      SUBROUTINE TECAC2(STOPZ,NMPARZ,NVAL,ITAB,IRET)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/01/2003   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      CHARACTER*(*) NMPARZ,STOPZ
      CHARACTER*8 NOMPAR,STOP8

      INTEGER NVAL,ITAB(NVAL),IRET
C     -----------------------------------------------------------------

C     BUT:
C     ---
C     OBTENIR DES INFORMATIONS SUR LE CHAMP LOCAL ASSOCIE A UN
C     PARAMETRE DANS UNE ROUTINE TE00IJ (OU EN DESSOUS)


C     ENTREES:
C     --------
C NMPARZ  : NOM DU PARAMETRE DE L'OPTION
C NVAL    : NOMBRE DE VALEURS DESIREES DANS ITAB(*)
C STOPZ   : PERMET DE DIRE A TECAC2 DE S'ARRETER SI ...

C 1) STOPZ(1:1) : SI LE PARAMETRE N'APPARAIT PAS DANS LE CATALOGUE
C                 DU TYPE_ELEMENT (OU CELUI DE L'OPTION)
C            'O'  -> ON S'ARRETE EN ERREUR <F>
C            'N'  -> ON NE S'ARRETE PAS
C                    => IRET=1 , ITAB(1)=0

C 2) STOPZ(2:2) : SI  LE CHAMP_LOCAL ASSOCIE AU PARAMETRE N'EXISTE PAS
C        CE QUI PEUT ARRIVER POUR 2 RAISONS :
C         2-1) LE PARAMETRE N'APPARTIENT PAS A LPAIN (OU LPAOUT)
C         2-2) LE CHAMP GLOBAL (CHIN) ASSOCIE AU PARAMETRE N'EXISTE PAS
C            'O'  -> ON S'ARRETE EN ERREUR <F>
C            'N'  -> ON NE S'ARRETE PAS
C                    => IRET=2 , ITAB(1)=0

C 3) STOPZ(3:3) : SI  LE CHAMP_LOCAL ASSOCIE AU PARAMETRE EST INCOMPLET
C        (I.E. ON N'A PAS PU EXTRAIRE TOUTES LES CMPS VOULUES)
C            'O'  -> ON S'ARRETE EN ERREUR <F>
C            'N'  -> ON NE S'ARRETE PAS
C                    => IRET=3,ITAB(1)=ADRESSE DU CHAMP LOCAL INCOMPLET
C                       POUR S'EN SORTIR IL FAUT UTILISER ITAB(8)





C SORTIES:
C --------
C IRET : CODE RETOUR :
C       0 -> TOUT OK
C       1 -> LE PARAMETRE N'EXISTE PAS DANS LE CATALOGUE DE L'ELEMENT
C       2 -> LE CHAMP N'EST PAS FOURNI PAR L'APPELANT DE CALCUL
C       3 -> LE CHAMP EST INCOMPLET : IL MANQUE DES CMPS

C ITAB(1)   : ADRESSE DU CHAMP_LOCAL (DANS ZR, ZC, ....)
C             = 0  SI IL N'EXISTE PAS DE CHAMP LOCAL (IRET=1,2)


C ITAB(2)   : LONGUEUR DU CHAMP_LOCAL DANS LE CATALOGUE
C             (NE TIENT PAS COMPTE DE NCDYN ET NBSPT
C              VOIR CI-DESSOUS ITAB(6) ET ITAB(7) )
C ITAB(3)   : NOMBRE DE POINTS DE LOCALISATION DU CHAMP
C ITAB(4)   : 9999 (INUTILISE)
C ITAB(5)   : TYPE_SCALAIRE DU CHAMP :
C             1 --> REEL
C             2 --> COMPLEXE
C             3 --> ENTIER
C             4 --> K8
C             5 --> K16
C             6 --> K24
C ITAB(6)   : NCDYN : NOMBRE DE CMP POUR LA GRANDEUR VARI_R
C ITAB(7)   : NBSPT : NOMBRE DE SOUS-POINTS
C ITAB(8)   : ADRESSE (DANS ZL) D'UN VECTEUR DE BOOLEENS
C             PARALLELE AU CHAMP LOCAL PERMETTANT DE SAVOIR QUELLES
C             SONT LES CMPS PRESENTES ET ABSENTES

C     -----------------------------------------------------------------
      LOGICAL EXICHL,ETENDU
      INTEGER IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,IAOPPA
      INTEGER IAMLOC,ILMLOC,IADSGD,ISMAEM
      INTEGER NPARIO,IAWLOC,IAWTYP,NBELGR,IGR,IEL,IPARG,INDIK8
      INTEGER NPARIN,JCELD,IACHII,IACHOI,ADIEL,DEBUGR,NBSPT,NCDYN
      INTEGER LGCATA,IACHIK,IACHIX,IACHOK,DECAEL,LONCHL,IACHLO,ILCHLO
      INTEGER K,KK

      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      CHARACTER*16 OPTION,NOMTE,NOMTM
      COMMON /CAKK01/OPTION,NOMTE,NOMTM
      COMMON /CAII06/IAWLOC,IAWTYP,NBELGR,IGR
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      COMMON /CAII07/IACHOI,IACHOK
      COMMON /CAII08/IEL

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      LOGICAL STPCAT,STPEXI,STPINC

C     DEB--------------------------------------------------------------

      NOMPAR = NMPARZ
      STOP8 = STOPZ

      STPCAT = (STOP8(1:1).EQ.'O')
      STPEXI = (STOP8(2:2).EQ.'O')
      STPINC = (STOP8(3:3).EQ.'O')

      IF (NVAL.LT.1) GO TO 20
      IF (NVAL.GT.8) GO TO 20
      IRET = 0
      ITAB(1) = 0


C     1- SI LE PARAMETRE N'APPARTIENT PAS A L'OPTION :
C     -------------------------------------------------
      EXICHL = .FALSE.

      IPARG = INDIK8(ZK8(IAOPPA),NOMPAR,1,NPARIO)
      IF (IPARG.EQ.0) THEN
        IF (STPCAT) THEN
          CALL UTMESS('E','TECAC2','LE PARAMETRE:'//NOMPAR//
     &                          ' N''EST PAS UN '//
     &                          'PARAMETRE DE L''OPTION:'//OPTION)
          CALL CONTEX(OPTION,0,' ',' ',0,'STOP')
        END IF
        IRET = 1
        GO TO 20
      END IF


C     2- SI LE PARAMETRE APPARTIENT A L'OPTION :
C     -------------------------------------------------
      IACHLO = ZI(IAWLOC-1+7* (IPARG-1)+1)
      ILCHLO = ZI(IAWLOC-1+7* (IPARG-1)+2)
      LGCATA = ZI(IAWLOC-1+7* (IPARG-1)+4)

      IF (IACHLO.EQ.-1) IRET = 2
      IF (LGCATA.EQ.-1) IRET = 1


C     -- SI IACHLO=-1    : LE CHAMP N'EXISTE PAS (GLOBALEMENT)
C     -- SI LGCATA=-1 : LE PARAMETRE N'EXISTE PAS POUR LE TYPE_ELEMENT
C     -------------------------------------------------
      IF (IACHLO.EQ.-1) THEN
        IF (STPEXI) THEN
          CALL UTMESS('E','TECAC2',
     &                          'ERREUR DE PROGRAMMATION :'//
     &               'ON NE TROUVE PAS DANS LES ARGUMENTS DE LA ROUTINE'
     &                          //
     &                       ' CALCUL DE CHAMP A ASSOCIER AU PARAMETRE:'
     &                          //NOMPAR//' (OPTION:'//OPTION//
     &                          ' TYPE_ELEMENT:'//NOMTE//')')
          CALL CONTEX(OPTION,0,NOMPAR,' ',0,'STOP')
        END IF

        IF (LGCATA.EQ.-1) THEN
          IF (STPCAT) THEN
            CALL UTMESS('E','TECAC2','LE PARAMETRE:'//NOMPAR//
     &                            ' N''EST PAS UN '//
     &                            'PARAMETRE DE L''OPTION:'//OPTION//
     &                            ' POUR '//'LE TYPE_ELEMENT: '//NOMTE)
            CALL CONTEX(OPTION,0,NOMPAR,' ',0,'STOP')
          END IF
        END IF
      ELSE
        IF (LGCATA.EQ.-1) THEN
          IF (STPCAT) THEN
            CALL UTMESS('E','TECAC2','LE PARAMETRE:'//NOMPAR//
     &                            ' N''EST PAS UN '//
     &                            'PARAMETRE DE L''OPTION:'//OPTION//
     &                            ' POUR '//'LE TYPE_ELEMENT: '//NOMTE)
            CALL CONTEX(OPTION,0,NOMPAR,' ',0,'STOP')
          END IF
        ELSE
          EXICHL = .TRUE.
        END IF
      END IF


C     -------------------------------------------------

      IF (.NOT.EXICHL) THEN
        GO TO 20
      END IF


C     ITAB(1) : ADRESSE DU CHAMP LOCAL POUR L'ELEMENT IEL :
C     -----------------------------------------------------

C     -- CALCUL DE ITAB(1),LONCHL,DECAEL,NBSPT,NCDYN :
C     -------------------------------------------------
      CALL CHLOET(IPARG,ETENDU,JCELD)
      IF (ETENDU) THEN
        ADIEL = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4+4* (IEL-1)+4)
        DEBUGR = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+8)
        NBSPT = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4+4* (IEL-1)+1)
        NCDYN = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4+4* (IEL-1)+2)
        IF (LGCATA.NE.ZI(JCELD-1+ZI(JCELD-1+4+IGR)+3)) CALL UTMESS('F',
     &      'TECAC2','STOP')
        DECAEL = (ADIEL-DEBUGR)
        LONCHL = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4+4* (IEL-1)+3)
      ELSE
        DECAEL = (IEL-1)*LGCATA
        LONCHL = LGCATA
        NCDYN = 0
        NBSPT = 1
      END IF
      ITAB(1) = IACHLO + DECAEL


C     -- ON VERIFIE QUE L'EXTRACTION EST COMPLETE SUR L'ELEMENT:
C     ----------------------------------------------------------
      IF (ILCHLO.NE.-1) THEN
        DO 10,K = 1,LONCHL
          IF (.NOT.ZL(ILCHLO+DECAEL-1+K)) THEN
            IF (STPINC) THEN
              WRITE (6,*) 'ERREUR TECAC2 ZL :',NOMPAR,
     &          (ZL(ILCHLO+DECAEL-1+KK),KK=1,LONCHL)
              CALL UTMESS('E','TECAC2','ERREUR DE PROGRAMMATION :'//
     &                'ON N''A PAS PU EXTRAIRE TOUTES LES CMPS VOULUES '
     &                    //'DU CHAMP GLOBAL ASSOCIE AU PARAMETRE:'//
     &                    NOMPAR//' (OPTION:'//OPTION//
     &                    ' TYPE_ELEMENT:'//NOMTE//')')
              CALL CONTEX(OPTION,0,NOMPAR,' ',0,'STOP')
            ELSE
              IRET = 3
            END IF
          END IF
   10   CONTINUE
      END IF

      IF (NVAL.LT.2) GO TO 20


C     ITAB(2) : LONGUEUR DU CHAMP LOCAL (CATALOGUE) :
C     -----------------------------------------------------
      ITAB(2) = LGCATA
      IF (NVAL.LT.3) GO TO 20


C     ITAB(3) : NOMBRE DE POINTS (CATALOGUE) :
C     -----------------------------------------------------
      ITAB(3) = ZI(IAWLOC-1+7* (IPARG-1)+6)
      IF (NVAL.LT.4) GO TO 20
      ITAB(4) = 9999
      IF (NVAL.LT.5) GO TO 20


C     ITAB(5) : TYPE DU CHAMP LOCAL  :
C           R/C/I/K8/K16/K24
C           1/2/3/4 /5  /6
C     -----------------------------------------------------
      IF (ZK8(IAWTYP-1+IPARG) (1:1).EQ.'R') THEN
        ITAB(5) = 1
      ELSE IF (ZK8(IAWTYP-1+IPARG) (1:1).EQ.'C') THEN
        ITAB(5) = 2
      ELSE IF (ZK8(IAWTYP-1+IPARG) (1:1).EQ.'I') THEN
        ITAB(5) = 3
      ELSE IF (ZK8(IAWTYP-1+IPARG) (1:3).EQ.'K8 ') THEN
        ITAB(5) = 4
      ELSE IF (ZK8(IAWTYP-1+IPARG) (1:3).EQ.'K16') THEN
        ITAB(5) = 5
      ELSE IF (ZK8(IAWTYP-1+IPARG) (1:3).EQ.'K24') THEN
        ITAB(5) = 6
      ELSE
        CALL UTMESS('F','TECAC2','MESSAGE VIDE ')
      END IF
      IF (NVAL.LT.6) GO TO 20


C     ITAB(6) : NCDYN : NOMBRE DE CMP POUR LA GRANDEUR VARI_R (IEL)
C     -------------------------------------------------------
      ITAB(6) = NCDYN
      IF (NVAL.LT.7) GO TO 20


C     ITAB(7) : NBSPT : NOMBRE DE SOUS-POINTS POUR IEL
C     -----------------------------------------------------
      ITAB(7) = NBSPT
      IF (NVAL.LT.8) GO TO 20


C     ITAB(8) : ADRESSE DU VECTEUR DE BOOLEENS :
C     -----------------------------------------------------
      ITAB(8) = ILCHLO + DECAEL
      IF (NVAL.LT.9) GO TO 20



   20 CONTINUE

      END
