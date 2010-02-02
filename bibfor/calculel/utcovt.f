      SUBROUTINE UTCOVT (TYPE,TBVALR,TBVALI,TBERR,RELA,TCHVAL,TCHERR)
C
      IMPLICIT   NONE
      CHARACTER*1         TYPE
      CHARACTER*4         RELA
      INTEGER             TBVALI(2)
      REAL*8              TBVALR(2),TBERR(2)
      CHARACTER*24        TCHVAL(2)
      CHARACTER*16        TCHERR(2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 01/02/2010   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------------------------------
C IN :
C    TYPE :  TYPE DES VALEURS ('R' POUR REEL, 'C' POUR COMPLEXE)
C    TBVALR : TABLEAU DES VALEURS REELS DE TEST (SI TYPE = 'R') :
C             TBVALR(1) : VALEUR DE REFERENCE
C             TBVALC(2) : VALEUR CALCULEE
C    RELA   : CRITERE 'RELATIF' OU 'ABSOLU'
C    TBVALI : SI TYPE = 'I' : IDEM TBVALR POUR LES REELS
C    TBERR  : TABLEAU DES TOLERANCE/ERREUR :
C             TBERR(1) : ERREUR
C             TBERR(2) : TOLERANCE
C OUT :
C    TCHVAL : TABLEAU DE CHAINES DE CARACTERES DES VALEURS FORMATEES 
C             TCHVAL(1) : CHAINE REPRESENTANT LA VALEUR DE REFERENCE
C             TCHVAL(2) : CHAINE REPRESENTANT LA VALEUR CALCULEE
C    TCHERR : TABLEAU DE CHAINES DES ERREUR/TOLERANCE FORMATEES 
C             TCHERR(1) : CHAINE REPRESENTANT L'ERREUR DE REFERENCE
C             TCHERR(2) : CHAINE REPRESENTANT LA TOLERANCE CALCULEE
           

C ----------------------------------------------------------------------

      INTEGER LCVREF,LCV,I,II,III,EXV,EXVREF,IRET,LXLGUT,NDEC,V
      INTEGER EXVC
      REAL*8  RTMP,RTMP1,RTMP2,SG,SGREF
      CHARACTER*24 CHV,CHVREF,CHV2,CHVRE2,CHTMP,CHV3,CHV4,CH24
      CHARACTER*7 SIV,SIVREF
      LOGICAL VALFLO,REFFLO,ERRFLO,TOLFLO

      CALL JEMARQ()
C
C
C----------------------------------------------------
C----- A) VALEUR CALCULEE & VALEUR DE REFERENCE -----
C----------------------------------------------------
C
      VALFLO=.FALSE.
      REFFLO=.FALSE.
      ERRFLO=.FALSE.
      TOLFLO=.FALSE.
C
C --- 1 . CAS REEL
C     ============
C
      IF(TYPE(1:1).EQ.'R')THEN
C
C  ---   ECRITURE AVEC OU SANS EXPOSANT
C        ------------------------------
C        VALFLO = TRUE : ECRITURE DE LA VALEUR CALCULEE SANS EXPOSANT
C        REFFLO = TRUE : ECRITURE DE LA VALEUR DE REF. SANS EXPOSANT
         IF(ABS(TBVALR(1)).GE.0.01D0 .AND. ABS(TBVALR(1)).LT.100000)THEN
              REFFLO=.TRUE.
         ENDIF
         IF(ABS(TBVALR(2)).GE.0.01D0 .AND.ABS(TBVALR(2)).LT.100000)THEN
              VALFLO=.TRUE.
         ENDIF
C
C  ---   PASSAGE : REELS => CHARACTERS:
C        ------------------------------
C        CHV    : CHAINE REPRESENTANT LA VALEUR CALCULEE
C        CHVREF : CHAINE REPRESENTANT LA VALEUR DE REFERENCE
         SG=1.0D0
         IF(TBVALR(1).LT.0.D0)SG=-1.0D0
         CALL CODREE(SG*TBVALR(1),'E',CHVREF)
         LCVREF = LXLGUT(CHVREF)

         SGREF=1.0D0
         IF(TBVALR(2).LT.0.D0)SGREF=-1.0D0
         CALL CODREE(SGREF*TBVALR(2),'E',CHV)
         LCV = LXLGUT(CHV)
C
C  ---   POUR LA VALEUR CALCULEE, ON DETERMINE :
C        --------------------------------------
C        LE SIGNE DE L'EXPOSANT : SIV
C        LA VALEUR DE L'EXPOSANT : EXV
         II=0
         DO 20 I=1,LCV
            IF(CHV(I:I).NE.'E')THEN
               II=II+1
               GOTO 20
            ENDIF
            GOTO 21
 20      CONTINUE
 21      CONTINUE
C
         IF(CHV(II+2:II+2).EQ.'-')THEN 
             SIV='NEGATIF'
         ELSE IF(CHV(II+2:II+2).EQ.'+')THEN 
             SIV='POSITIF'
         ENDIF
         CALL LXLIIS(CHV(II+3:II+4),EXV,IRET)
            
C ---    POUR LA VALEUR DE REFERENCE, ON DETERMINE :
C        -------------------------------------------
C        LE SIGNE DE L'EXPOSANT : SIVREF
C        LA VALEUR DE L'EXPOSANT : EXVREF
         II=0
         DO 30 I=1,LCVREF
            IF(CHVREF(I:I).NE.'E')THEN
               II=II+1
               GOTO 30
            ENDIF
            GOTO 31
 30      CONTINUE
 31      CONTINUE
         IF(CHVREF(II+2:II+2).EQ.'-')THEN 
             SIVREF='NEGATIF'
         ELSE IF(CHVREF(II+2:II+2).EQ.'+')THEN 
             SIVREF='POSITIF'
         ENDIF
         CALL LXLIIS(CHVREF(II+3:II+4),EXVREF,IRET)
C
C
C ---    DETERMINATION DU NOMBRE DE DECIMALES A PRENDRE EN COMPTE:
C        ---------------------------------------------------------
C
C    --  TRAITEMENT DES CAS PARTICULIERS :
C        
C       - SI LES SIGNES DES EXPOSANTS DIFFERENT,ON CONSIDERE 6 DECIMALES
         IF(SIVREF(1:1).NE.SIV(1:1))THEN
            NDEC=6
            GOTO 555
         ENDIF
C
C       - SI LES SIGNES DIFFERENT, ON PREND EN COMPTE 6 DECIMALES
         IF(SG*SGREF.LT.0.D0)THEN
            NDEC=6
            GOTO 555
         ENDIF
C
C        - SI LES EXPOSANTS DIFFERENT, ON PREND EN COMPTE 6 DECIMALES
         IF(EXV.NE.EXVREF)THEN
            NDEC=6
            GOTO 555
         ENDIF
         

C    --  POSITION DE LA 1ERE DECIMALE DIFFERENTE (REFERENCE/CALCULEE): V
C
         II=0
         DO 10 I=1,LCV
            IF(CHV(I:I).EQ.CHVREF(I:I))THEN
               II=II+1
               GOTO 10
            ENDIF
            GOTO 11
 10      CONTINUE
 11      CONTINUE

C        SI LE PREMIER CHIFFRE DIFFERE, ON PREND EN COMPTE 6 DECIMALES
         IF(II.EQ.0)THEN 
            NDEC=6
            GOTO 555
         ENDIF
         V=II-1
C
C
C    --  NOMBRE DE DECIMALES A PRENDRE EN COMPTE: NDEC
C
C       - SI L'EXPOSANT EST POSITIF:
C         IF(SIV.EQ.'POSITIF')THEN
C            NDEC=MIN(12,MAX(V,EXV)+2)

C       - SI L'EXPOSANT EST NEGATIF:
C         ELSEIF(SIV.EQ.'NEGATIF')THEN
C           NDEC=MIN(12,V+2)
C
C         ENDIF
         NDEC=MIN(14,V+2)

555      CONTINUE
C
C
C  ---   TRONCATURES:
C        ------------
C
C   --   POUR LA VALEUR CALCULEE:
         CHV3=' '
         IF(SG.LT.0.D0)THEN 
             CALL UTROUN('-'//CHV(1:23),NDEC,CHV3)
         ELSE
             CALL UTROUN(CHV,NDEC,CHV3)
         ENDIF

C   --   POUR LA VALEUR DE REFERENCE:
         CHV4=' '
         IF(SGREF.LT.0.D0)THEN 
             CALL UTROUN('-'//CHVREF(1:23),NDEC,CHV4)
         ELSE
             CALL UTROUN(CHVREF,NDEC,CHV4)
         ENDIF
C
C
C  ---   ECRITURE EVENTUELLE SANS EXPOSANT:
C        ----------------------------------
C
C   --   POUR LA VALEUR DE REFERENCE:
         CALL UTFLOA(REFFLO,CHV4,TCHVAL(1))

C   --   POUR LA VALEUR CALCULEE:
         CALL UTFLOA(VALFLO,CHV3,TCHVAL(2))
C
C
C --- 2 . CAS ENTIER
C     ==============
C
      ELSEIF(TYPE(1:1).EQ.'I')THEN
C
           CALL CODENT(TBVALI(1),'G',TCHVAL(1))
           CALL CODENT(TBVALI(2),'G',TCHVAL(2))
C
      ENDIF
C
C
C----------------------------------------------
C----- B) ERREUR & TOLERANCE -----------------
C----------------------------------------------

C
C --- ECRITURE AVEC OU SANS EXPOSANT
C     ------------------------------
C     ERRFLO = TRUE : ECRITURE DE L'ERREUR SANS EXPOSANT
C     TOLFLO = TRUE : ECRITURE DE LA TOLERANCE SANS EXPOSANT
      IF(ABS(TBERR(1)).GE.0.01D0 .AND.ABS(TBERR(1)).LT.100000)THEN
           ERRFLO=.TRUE.
      ENDIF
      IF(ABS(TBERR(2)).GE.0.01D0 .AND.ABS(TBERR(2)).LT.100000)THEN
           TOLFLO=.TRUE.
      ENDIF
C
C --- POUR L'ERREUR CALCULEE:
      CH24=' '
      CALL CODREE(ABS(TBERR(1)),'E',CHV3)
      CALL UTROUN(CHV3,1,CHV4)
      CALL UTFLOA(ERRFLO,CHV4,CH24)

      IF(RELA.EQ.'RELA')THEN
         LCV = LXLGUT(CH24)
         TCHERR(1)=CH24(1:LCV)//'%'
      ELSE
         TCHERR(1)=CH24(1:16)
      ENDIF

C --- POUR LA TOLERANCE:
      CALL CODREE(ABS(TBERR(2)),'E',CHV3)
      CALL UTROUN(CHV3,1,CHV4)
      CALL UTFLOA(TOLFLO,CHV4,CH24)

      IF(RELA.EQ.'RELA')THEN
         LCV = LXLGUT(CH24)
         TCHERR(2)=CH24(1:LCV)//'%'
      ELSE
         TCHERR(2)=CH24(1:16)
      ENDIF

C
      CALL JEDEMA()
C
      END
