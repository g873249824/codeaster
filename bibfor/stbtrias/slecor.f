      SUBROUTINE SLECOR(IUNV,DATSET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF STBTRIAS  DATE 10/05/2006   AUTEUR MCOURTOI M.COURTOIS 
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
C  ROUTINE DE TRAITEMENT DES SYSTEMES DE COORDONNEES SUPERTAB
C  LE DATASET 18 EST OBSOLETE DEPUIS 1987
C  DATSET : IN :DATASET DES SYSTEMES DE COORDONNEES
C ======================================================================
C TOLE CRS_512
      IMPLICIT NONE
C     =================
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      LOGICAL      FIRST
      CHARACTER*6  MOINS1
      CHARACTER*80 CBUF, KBID
      REAL*8       RBID
      INTEGER      DATSET,IBID,IUNV,INUS,INUM,ICOOR,JSYS,IRET,ICOL,IBID2
C
C  ------------ FIN DECLARATION -------------
C
C  -->N  D'UNITE LOGIQUE ASSOCIE AUX FICHIERS
      CALL JEMARQ()
C
      FIRST=.TRUE.
      MOINS1 = '    -1'
      INUS  = 10
      CALL JEEXIN('&&IDEAS.SYST',IRET)
      IF(IRET.NE.0) THEN
        CALL JEDETR('&&IDEAS.SYST')
        IF (DATSET.EQ.2420) THEN
        CALL UTMESS('A','SLECOR',' ATTENTION LE DATASET 2420'
     &    //' APPARAIT PLUSIEURS FOIS.')
        ELSEIF (DATSET.EQ.18) THEN
        CALL UTMESS('A','SLECOR',' ATTENTION LE DATASET 18'
     &    //' APPARAIT PLUSIEURS FOIS.')
       ENDIF
      ENDIF
      CALL WKVECT('&&IDEAS.SYST','V V I',INUS,JSYS)
C      
   1  CONTINUE
C   
      READ(IUNV,'(A)') CBUF
      IF (CBUF(1:6).NE.MOINS1) THEN
C
        IF (FIRST) THEN
          IF (DATSET.EQ.2420) THEN
            READ(IUNV,'(A)') KBID
            READ(IUNV,'(3I10)') INUM,ICOOR,ICOL
          ELSEIF (DATSET.EQ.18) THEN
            READ(CBUF,'(5I10)') INUM,ICOOR,IBID,ICOL,IBID2
          ENDIF
        ELSE
          IF (DATSET.EQ.2420) THEN
            READ(CBUF,'(3I10)') INUM,ICOOR,ICOL
          ELSEIF (DATSET.EQ.18) THEN
            READ(CBUF,'(5I10)') INUM,ICOOR,IBID,ICOL,IBID2
          ENDIF
        ENDIF
        IF (INUM.GT.INUS) THEN
          INUS  = INUM
          CALL JUVECA('&&IDEAS.SYST',INUS)
          CALL JEVEUO('&&IDEAS.SYST','E',JSYS)
        ENDIF
C
        ZI(JSYS-1+INUM) = ICOOR
C
        IF (DATSET.EQ.2420) THEN
          READ(IUNV,'(A)') KBID
          READ(IUNV,'(3(1PD25.16))') RBID
          READ(IUNV,'(3(1PD25.16))') RBID
          READ(IUNV,'(3(1PD25.16))') RBID
          READ(IUNV,'(3(1PD25.16))') RBID
        ELSE
          READ(IUNV,'(A)') KBID
          READ(IUNV,'(6(1PE13.5))') RBID
          READ(IUNV,'(3(1PE13.5))') RBID
        ENDIF
C        
        FIRST = .FALSE.
C
        GOTO 1
C        
      ENDIF
      CALL JEDEMA()
      END
