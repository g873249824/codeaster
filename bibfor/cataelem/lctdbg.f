      SUBROUTINE LCTDBG(ICLASS,IVAL,RVAL,CVAL,IRTETI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CATAELEM  DATE 26/11/97   AUTEUR D6BHHBQ B.QUINNEZ 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     A TOUT MOMENT ON PEUT AJOUTER DANS LES DONNEES :
C
C     DEBUG IDEBUG
C     -----
C        DUMP  IPASSE NOM_OBJET TYPE
C        ----
C        DUMP  IPASSE NOM_OBJET TYPE
C        ----
C    ..........
C
C     ENDDEBUG
C     --------
C
C  AVEC : IDEBUG 0 1 OU 2
C         IPASSE : 1 2 3 OU 10 (= FIN)
C         TYPE : SIMPLE
C              : CNOM : COLLEC NOMMEE
C              : CNUM : COLLEC NUMEROTEE
C
C  EXEMPLE :
C  DEBUG 0
C   DUMP 10  '&CATA.GD.NOMGD' SIMPLE
C   DUMP 10  '&CATA.GD.NOMCMP' CNOM
C   DUMP 10  '&CATA.GD.TYPEGD' SIMPLE
C   DUMP 10  '&CATA.GD.DESCRIGD' CNOM
C  ENDDEBUG
C
C     INCLUDE($CIMPERR)
C
      COMMON /CIMP/IMP,IULMES,IULIST,IULVIG
C
C     EXCLUDE($CIMPERR)
C
C
C DEBUG = 0 AUCUN DEBUG ET MINIMUM CALL JEVEU
C DEBUG = -1  DEBUG ET MINIMUM CALL JEVEU
C DEBUG = 1 APPEL A JEVEUO DANS TOUTES LES FONCTIONS D ACCES ID...
C                     + LIVRE DE BORD
C DEBUG = 2 DEBUG = 1 + DEBUG JEVEUX
C
C
      INTEGER LIRMOT
C
      CHARACTER*(*) CVAL
      REAL*8 RVAL
C     INCLUDE($CDEBUG)
      CHARACTER*8 CLEDBG
      CHARACTER*24 OBJDMP
      INTEGER PASDMP,TYOBDM
      COMMON /CMODBG/CLEDBG
      COMMON /CDEBUG/ICCDBG
      COMMON /CBDMPC/OBJDMP(30)
      COMMON /CBDMPN/NDMP,PASDMP(30),TYOBDM(30)
C
C       NDMP : NOMBRE D OBJETS A DUMPER
C       PASDMP(IDMP)  : PASSE OU ON DUMPE L OBJET IDMP
C       OBJDMP(IDMP)  : NOM DE L OBJET IDMP
C       TYOBDM(IDMP)  : GENRE DE L OBJET IDMP :  0 OBJET SIMPLE
C                                                1 COLLECTION NUMEROTEE
C                                                2 COLLECTION NOMME
C
C     EXCLUDE($CDEBUG)
C
      IRTETI = 0
      ASSIGN 100 TO LIRMOT
C
      NDMP = 0
      DO 10 IDMP = 1,30
        PASDMP(IDMP) = -1
        OBJDMP(IDMP) = '&                       '
   10 CONTINUE
C
C PAR DEFAUT PAS DE LIVRE DE BORD
C
      CALL JEDBUG(0)
C
      CALL SNLIRE(ICLASS,IVAL,RVAL,CVAL)
      IF (ICLASS.NE.1) THEN
        CALL UTMESS('F','LCTDBG','PB. LECTURE CATALOGUES.')
        IRTETI = 1
        GOTO 9999

      ELSE
        ICCDBG = IVAL
        IF (ICCDBG.EQ.1) THEN
C
C EN DEBUG 1 LIVRE DE BORD
C
          IMP = IULMES
          CALL JEDBUG(1)

        ELSE IF ((ICCDBG.EQ.2) .OR. (ICCDBG.EQ.-1)) THEN
C
C EN DEBUG 2 OU -1 LIVRE DE BORD ET DEBUG JEVEUX
C
          IMP = IULMES
          CALL JEDBUG(2)
        END IF

        GO TO LIRMOT

      END IF
C
C LIRMOT
C
  100 CONTINUE
      CALL SNLIRE(ICLASS,IVAL,RVAL,CVAL)
      IF (ICLASS.NE.3) THEN
        WRITE (IULMES,*) ' DEF DUMP ON LIT AUTRE CHOSE QU UN MOT'
        CALL UTMESS('F','LCTDBG','PB. LECTURE CATALOGUES.')
        IRTETI = 1
        GOTO 9999

      END IF

      IF (CVAL(1:IVAL).EQ.'ENDDEBUG') THEN
        IRTETI = 0
        GOTO 9999

      ELSE IF (CVAL(1:IVAL).NE.'DUMP') THEN
        WRITE (IULMES,*) ' DEF DUMP ERREUR '
        WRITE (IULMES,*) ' ON LIT AUTRE CHOSE QUE DUMP  '
        CALL UTMESS('F','LCTDBG','PB. LECTURE CATALOGUES.')
        IRTETI = 1
        GOTO 9999

      END IF

      NDMP = NDMP + 1
      IF (NDMP.GT.30) THEN
        WRITE (IULMES,*) ' DEF DUMP NOMBRE DE DUMP > 30 '
        CALL UTMESS('F','LCTDBG','PB. LECTURE CATALOGUES.')
        IRTETI = 1
        GOTO 9999

      END IF

      CALL SNLIRE(ICLASS,IVAL,RVAL,CVAL)
      IF (ICLASS.NE.1) THEN
        WRITE (IULMES,*) ' DEF DUMP ON LIT AUTRE CHOSE QUE ENTIER'
        CALL UTMESS('F','LCTDBG','PB. LECTURE CATALOGUES.')
        IRTETI = 1
        GOTO 9999

      ELSE
        PASDMP(NDMP) = IVAL
      END IF

      CALL SNLIRE(ICLASS,IVAL,RVAL,CVAL)
      IF (ICLASS.NE.4) THEN
        WRITE (IULMES,*) ' DEF DUMP ERREUR '
        WRITE (IULMES,*) ' ON LIT AUTRE CHOSE QU UNE CHAINE '
        CALL UTMESS('F','LCTDBG','PB. LECTURE CATALOGUES.')
        IRTETI = 1
        GOTO 9999

      ELSE
        OBJDMP(NDMP) (1:IVAL) = CVAL(1:IVAL)
      END IF

      CALL SNLIRE(ICLASS,IVAL,RVAL,CVAL)
      IF (ICLASS.NE.3) THEN
        WRITE (IULMES,*) ' DEF DUMP ERREUR '
        WRITE (IULMES,*) ' ON LIT AUTRE CHOSE QU UN MOT  '
        CALL UTMESS('F','LCTDBG','PB. LECTURE CATALOGUES.')
        IRTETI = 1
        GOTO 9999

      ELSE
        IF (CVAL(1:IVAL).EQ.'SIMPLE') THEN
          TYOBDM(NDMP) = 0
          GO TO LIRMOT

        ELSE IF (CVAL(1:IVAL).EQ.'CNUM') THEN
          TYOBDM(NDMP) = 1
          GO TO LIRMOT

        ELSE IF (CVAL(1:IVAL).EQ.'CNOM') THEN
          TYOBDM(NDMP) = 2
          GO TO LIRMOT

        ELSE
          WRITE (IULMES,*) ' DEF DUMP ERREUR '
          WRITE (IULMES,*) ' ON LIT AUTRE CHOSE QUE :      '
          WRITE (IULMES,*) ' SIULMESLE OU CNUM OU CNOM '
          WRITE (IMP,*) ' ------    ----    ---- '
          CALL UTMESS('F','LCTDBG','PB. LECTURE CATALOGUES.')
          IRTETI = 1
          GOTO 9999

        END IF

      END IF

 9999 CONTINUE
      END
