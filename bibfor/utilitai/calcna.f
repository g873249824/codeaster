      SUBROUTINE CALCNA ( NOMFIN, NOMFON, NBVALP, VALEP, NOPARP, 
     +                    NBVALF, VALEF, NOPARF )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      INTEGER             NBVALP, NBVALF
      REAL*8              VALEP(*), VALEF(*)
      CHARACTER*19        NOMFIN, NOMFON
      CHARACTER*24        NOPARP, NOPARF
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C
C     CREATION DU SD FONCTION A PARTIR D'UNE FORMULE (NAPPE )
C     ------------------------------------------------------------------
      INTEGER       LONT, I, IVAL, LVAL, LFON, LPROL, LPARA, IER
      INTEGER       LXLGUT
      REAL*8        VALE(2)
      CHARACTER*16  NOPARA(2)
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
C     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.VALE ---
C      
      LONT = 2*NBVALF*NBVALP
      NOPARA(1) = NOPARF
      NOPARA(2) = NOPARP
C     
      CALL JECREC ( NOMFON//'.VALE', ' G V R', 'NU', 'CONTIG',
     +                                            'VARIABLE', NBVALP )
      CALL JEECRA ( NOMFON//'.VALE', 'LONT', LONT, ' ' )
      DO 10 I = 1 , NBVALP
         CALL JECROC ( JEXNUM(NOMFON//'.VALE',I) )
         CALL JEECRA ( JEXNUM(NOMFON//'.VALE',I) , 'LONMAX',
     +                                              2*NBVALF, ' ' )
         CALL JEECRA ( JEXNUM(NOMFON//'.VALE',I) , 'LONUTI',
     +                                              2*NBVALF, ' ' )
         CALL JEVEUO ( JEXNUM(NOMFON//'.VALE',I), 'E', LVAL )
         LFON = LVAL + NBVALF
         VALE(2) = VALEP(I)
         DO 20 IVAL = 0 , NBVALF-1
            ZR(LVAL+IVAL) = VALEF(IVAL+1)
            VALE(1) = ZR(LVAL+IVAL)
            CALL FOINTE( 'F',NOMFIN, 2, NOPARA,
     +                                      VALE, ZR(LFON+IVAL), IER )
 20      CONTINUE
 10   CONTINUE
C
C     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PROL ---
C
       CALL ASSERT(LXLGUT(NOMFON).LE.24)
       CALL WKVECT ( NOMFON//'.PROL', 'G V K24', 7+2*NBVALP, LPROL )

       ZK24(LPROL)   = 'NAPPE           '
       ZK24(LPROL+1) = 'LIN LIN         '
       ZK24(LPROL+2) = NOPARP
       ZK24(LPROL+3) = 'TOUTRESU        '
       ZK24(LPROL+4) = 'EE              '
       ZK24(LPROL+5) = NOMFON
       ZK24(LPROL+6) = NOPARF
       DO 30 IVAL = 1, NBVALP
          ZK24(LPROL+6+(2*IVAL-1)) = 'LIN LIN         '
          ZK24(LPROL+6+(2*IVAL  )) = 'EE              '
 30    CONTINUE
C
C     --- CREATION ET REMPLISSAGE DE L'OBJET NOMFON.PARA ---
C
       CALL WKVECT ( NOMFON//'.PARA', 'G V R', NBVALP, LPARA )
       DO 40 IVAL = 1, NBVALP
          ZR(LPARA+IVAL-1) = VALEP(IVAL)
 40    CONTINUE
C
       CALL JEDEMA()
       END
