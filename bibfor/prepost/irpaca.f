      SUBROUTINE IRPACA(NOMCOM,IFI,NBORDR,IOCC,ORDR,NBACC,CHACC,
     &                  NBCHCA,CHAMCA,NBK16,NIVE)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*)     NOMCOM,                     CHACC(*),CHAMCA(*)
      INTEGER           NBORDR,       IFI,IOCC,ORDR(*),NBACC,NBCHCA
      INTEGER           NBK16,              NIVE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 24/07/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     IMPRESSION DES VARIABLES D'ACCES SOUS FORME TABLE POUR CASTEM
C     ------------------------------------------------------------------
C IN  NOMCOM   : K8  : NOM DU CONCEPT
C IN  IFI      : I   : NUMERO D'UNITE DU FICHIER D'ECRITURE
C IN  NBORDR   : I   : NOMBRE DE NUMEROS D'ORDRE DU RESULTAT
C IN  IOCC     : I   : NUMERO D'OCCURENCE D'IMPRESSION DU RESULTAT
C IN  ORDR     : I   : LISTE DES NUMEROS D'ORDRE DU RESULTAT
C IN  NBACC    : I   : NOMBRE DE VARIABLES D'ACCES DE LA TABLE CASTEM
C IN  NBCHCA   : I   : NOMBRE DE CHAMPS DE LA TABLE CASTEM
C IN  CHAMCA   : I   : NOMS DES CHAMPS DE LA TABLE CASTEM
C IN  NBK16    : I   : NOMBRE DE VARIABLES D'ACCES DE TYPE K16
C IN  NIVE     : I   : NIVEAU IMPRESSION CASTEM 3 OU 10
C     ---------------------------------------------------------------
C     ------------------------------------------------------------------
      CHARACTER*4  CTYPE,TYCH
      CHARACTER*8  NOMCO,CFOR
      CHARACTER*16 TOTO
      CHARACTER*19 NOCH19
      INTEGER MAXLEN
C-----------------------------------------------------------------------
      INTEGER I ,IAD ,IBID ,IDEU ,IERD ,IOR ,IREST
      INTEGER IRET ,ISEIZE ,ITYPE ,IUN ,IZERO ,J ,JENTI
      INTEGER JLAST ,JPOSI ,JTABL ,LXLGUT ,NBOBJ ,NFOR ,NP

C-----------------------------------------------------------------------
      PARAMETER ( MAXLEN = 255)
      CHARACTER*(MAXLEN) CHAINE
      CHARACTER*72 CTMP
      INTEGER      NBCARA,IOB,IL
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      NBOBJ = NBCHCA+ NBACC + 1
      CALL WKVECT('&&IRPACA.TABL.CASTEM','V V I',NBOBJ*4,JTABL)
      CALL WKVECT('&&IRPACA.POSI.CASTEM','V V I',NBOBJ  ,JPOSI)
      NOMCO = NOMCOM
      IDEU = 2
      IZERO = 0
      IUN = 1
      CHAINE = ' '
      NBK16  = 0
C     NBCARA : LONGUEUR CUMULEE DES CLES DE LA TABLE
C     (EX : ORDR, INST, + NOMS CHAMP...)
      IOB = 1
      CHAINE(1:4) = 'ORDR'
      NBCARA = 4
      ZI(JPOSI-1+IOB) = NBCARA
C
C ECRITURE DE ENREGISTREMENT 27
C
      CALL JEVEUO('&&OP0039.LAST','E',JLAST)
      DO 34 I = 1,NBACC
         TOTO   = CHACC(I)
         IL     = LXLGUT(TOTO)
         IF(NBCARA+IL.GT.MAXLEN)
     &      CALL U2MESS('F','PREPOST3_5')
         CHAINE(NBCARA+1:NBCARA+IL) = TOTO(1:IL)
         NBCARA = NBCARA + IL
         IOB    = IOB + 1
         ZI(JPOSI-1+IOB) = NBCARA
  34  CONTINUE
      J=0
      DO 33 I=1,NBCHCA
         CALL RSEXCH(' ',NOMCO,CHAMCA(I),ORDR(IOCC),NOCH19,IRET)
         IF (IRET.EQ.0) THEN
            J=J+1
            CALL DISMOI('C','TYPE_CHAMP',NOCH19,'CHAMP',IBID,TYCH,IERD)
            IF(TYCH(1:4).EQ.'NOEU') THEN
               ZI(JTABL-1+(NBACC+1)*4+(J-1)*4+1) = 27
               ZI(JTABL-1+(NBACC+1)*4+(J-1)*4+2)=ZI(JLAST-1+8)+I+NBACC+1
               ZI(JTABL-1+(NBACC+1)*4+(J-1)*4+3) = 2
               ZI(JLAST-1+4) = ZI(JLAST-1+4) + 1
               ZI(JTABL-1+(NBACC+1)*4+(J-1)*4+4) = ZI(JLAST-1+4)
            ELSEIF(TYCH(1:4).EQ.'ELNO') THEN
               ZI(JTABL-1+(NBACC+1)*4+(J-1)*4+1) = 27
               ZI(JTABL-1+(NBACC+1)*4+(J-1)*4+2)=ZI(JLAST-1+8)+I+NBACC+1
               ZI(JTABL-1+(NBACC+1)*4+(J-1)*4+3) = 39
               ZI(JLAST-1+5) = ZI(JLAST-1+5) + 1
               ZI(JTABL-1+(NBACC+1)*4+(J-1)*4+4) = ZI(JLAST-1+5)
            ENDIF
         ENDIF
         TOTO   = CHAMCA(I)
         IL     = LXLGUT(TOTO)
         IF(NBCARA+IL.GT.MAXLEN)
     &      CALL U2MESS('F','PREPOST3_5')
         CHAINE(NBCARA+1:NBCARA+IL) = TOTO(1:IL)
         NBCARA = NBCARA + IL
         IOB    = IOB + 1
         ZI(JPOSI-1+IOB) = NBCARA
  33  CONTINUE
      ITYPE = 27
      IF (IOCC.EQ.1) THEN
         WRITE (IFI,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IDEU
         IF(NIVE.EQ.3) THEN
            WRITE (IFI,'(A,I4,A,I4,A,I4)')  ' PILE NUMERO',ITYPE,
     &            'NBRE OBJETS NOMMES ',IZERO,'NBRE OBJETS ',NBOBJ
         ELSE IF (NIVE.EQ.10) THEN
            WRITE (IFI,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',ITYPE,
     &            'NBRE OBJETS NOMMES',IZERO,'NBRE OBJETS',NBOBJ
         ENDIF
         IF(NIVE.EQ.3) WRITE (IFI,'(2I5)') NBCARA,NBOBJ
         IF(NIVE.EQ.10) WRITE (IFI,'(2I8)') NBCARA,NBOBJ
C        IMPRESSION DES CLES DE LA TABLE PAR TRONCON DE 71 CARACTERES
         IREST=NBCARA
         NFOR=71
         NP=NBCARA/NFOR+1
         CALL CODENT(NFOR,'G',CTMP)
         CFOR='(1X,A'//CTMP(1:2)//')'
         DO 101 I=1,NP
            IF(IREST.GT.0)THEN
               IF(IREST.GT.NFOR)THEN
                  CTMP(1:NFOR)=CHAINE(NBCARA-IREST+1:NBCARA-IREST+NFOR)
                  WRITE(IFI,CFOR) CTMP(1:NFOR)
                  IREST=IREST-NFOR
               ELSE
                  CTMP(1:IREST)=CHAINE(NBCARA-IREST+1:NBCARA)
                  WRITE(IFI,CFOR) CTMP(1:IREST)
                  IREST=0
               ENDIF
            ENDIF
 101     CONTINUE
C
         IF(NIVE.EQ.3) WRITE(IFI,'(12I5)') (ZI(JPOSI-1+I),I=1,NBOBJ)
         IF(NIVE.EQ.10) WRITE(IFI,'(10I8)') (ZI(JPOSI-1+I),I=1,NBOBJ)
C
C ECRITURE DE ENREGISTREMENT ASSOCIE A TOUS LES NUMEROS D'ORDRE
C
         CALL WKVECT('&&IRPACA.ENTIER','V V I',IDEU*NBORDR,JENTI)
         DO 45 IOR = 1,NBORDR
            ZI(JENTI-1+(IOR-1)*2+1) = IOR
            ZI(JENTI-1+(IOR-1)*2+2) = ORDR(IOR)
 45      CONTINUE
         ITYPE = 26
         WRITE (IFI,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IDEU
         IF(NIVE.EQ.3) THEN
            WRITE (IFI,'(A,I4,A,I4,A,I4)')  ' PILE NUMERO',ITYPE,
     &         'NBRE OBJETS NOMMES ',IZERO,'NBRE OBJETS ',2*NBORDR
            WRITE(IFI,'(I5)')  2*NBORDR
         ELSEIF (NIVE.EQ.10) THEN
            WRITE (IFI,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',ITYPE,
     &         'NBRE OBJETS NOMMES',IZERO,'NBRE OBJETS',2*NBORDR
            WRITE(IFI,'(I8)')  2*NBORDR
         ENDIF
         WRITE(IFI,'(7I11)') (ZI(JENTI-1+IOR),IOR=1,2*NBORDR)
         ZI(JLAST-1+1) = ZI(JLAST-1+1)+2*NBORDR
      ENDIF
      ZI(JTABL-1+1) = 27
      ZI(JTABL-1+2) = ZI(JLAST-1+8)+IUN
      ZI(JTABL-1+3) = 26
      ZI(JTABL-1+4) = ZI(JLAST-1+7)+IOCC*2
C
C ECRITURE DES ENREGISTREMENTS ASSOCIES AUX VARIABLES ACCES
C
      DO 55 I=1,NBACC
         CALL RSADPA(NOMCO,'L',1,CHACC(I),ORDR(IOCC),1,IAD,CTYPE)
         IF(CTYPE(1:1).EQ.'R') THEN
            ITYPE = 25
            WRITE (IFI,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IDEU
            IF(NIVE.EQ.3) THEN
               WRITE (IFI,'(A,I4,A,I4,A,I4)')  ' PILE NUMERO',ITYPE,
     &            'NBRE OBJETS NOMMES ',IZERO,'NBRE OBJETS ',IUN
               WRITE(IFI,'(I5)') IUN
            ELSEIF(NIVE.EQ.10) THEN
               WRITE (IFI,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',ITYPE,
     &            'NBRE OBJETS NOMMES',IZERO,'NBRE OBJETS',IUN
               WRITE(IFI,'(I8)') IUN
            ENDIF
            WRITE(IFI,'(1X,1PE21.14)')  ZR(IAD)
            ZI(JTABL-1+(I-1)*4+5) = 27
            ZI(JTABL-1+(I-1)*4+6) = ZI(JLAST-1+8)+I+1
            ZI(JTABL-1+(I-1)*4+7) = 25
            ZI(JLAST-1+2) = ZI(JLAST-1+2) + 1
            ZI(JTABL-1+(I-1)*4+8) = ZI(JLAST-1+2)
         ELSEIF (CTYPE(1:1).EQ.'I') THEN
            ITYPE = 26
            WRITE (IFI,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IDEU
            IF(NIVE.EQ.3) THEN
               WRITE (IFI,'(A,I4,A,I4,A,I4)')  ' PILE NUMERO',ITYPE,
     &            'NBRE OBJETS NOMMES ',IZERO,'NBRE OBJETS ',IUN
               WRITE(IFI,'(I5)') IUN
            ELSEIF(NIVE.EQ.10) THEN
               WRITE (IFI,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',ITYPE,
     &            'NBRE OBJETS NOMMES',IZERO,'NBRE OBJETS',IUN
               WRITE(IFI,'(I8)') IUN
            ENDIF
            WRITE(IFI,'(2I11)') ZI(IAD)
            ZI(JLAST-1+1) = ZI(JLAST-1+1)+1
            ZI(JTABL-1+(I-1)*4+5) = 27
            ZI(JTABL-1+(I-1)*4+6) = ZI(JLAST-1+8)+I+1
            ZI(JTABL-1+(I-1)*4+7) = 26
            ZI(JTABL-1+(I-1)*4+8) = ZI(JLAST-1+1)
         ELSEIF (CTYPE(1:3).EQ.'K16') THEN
            ITYPE = 27
            ISEIZE = 16
            WRITE (IFI,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IDEU
            IF(NIVE.EQ.3) THEN
               WRITE (IFI,'(A,I4,A,I4,A,I4)')  ' PILE NUMERO',ITYPE,
     &            'NBRE OBJETS NOMMES ',IZERO,'NBRE OBJETS ',IUN
              WRITE(IFI,'(I5,I5)') ISEIZE,IUN
               WRITE(IFI,'(A72)')   ZK16(IAD)
               WRITE(IFI,'(I5)') ISEIZE
            ELSEIF (NIVE.EQ.10) THEN
               WRITE (IFI,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',ITYPE,
     &            'NBRE OBJETS NOMMES',IZERO,'NBRE OBJETS',IUN
               WRITE(IFI,'(I8,I8)') ISEIZE,IUN
               WRITE(IFI,'(A72)')   ZK16(IAD)
               WRITE(IFI,'(I8)') ISEIZE
            ENDIF
            ZI(JTABL-1+(I-1)*4+5) = 27
            ZI(JTABL-1+(I-1)*4+6) = ZI(JLAST-1+8)+I+1
            ZI(JTABL-1+(I-1)*4+7) = 27
            ZI(JLAST-1+3) = ZI(JLAST-1+3)+1
            ZI(JTABL-1+(I-1)*4+8) = ZI(JLAST-1+3)+NBOBJ
            NBK16 = NBK16 + 1
         ENDIF
 55   CONTINUE
      CALL JEDETR('&&IRPACA.POSI.CASTEM')
      CALL JEDETR('&&IRPACA.ENTIER')
      CALL JEDEMA()
      END
