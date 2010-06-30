      SUBROUTINE OP0040()
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
C OPERATEUR : INFO_RESU
C BUT       : FOURNIR LES COMPOSANTES DES CHAMPS PRESENTS DANS UNE SD
C             DE DONNEES RESULTAT
C ----------------------------------------------------------------------
C RESPONSABLE SELLENET N.SELLENET
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER       ZI
      COMMON/IVARJE/ZI(1)
      REAL*8        ZR
      COMMON/RVARJE/ZR(1)
      COMPLEX*16    ZC
      COMMON/CVARJE/ZC(1)
      LOGICAL       ZL
      COMMON/LVARJE/ZL(1)
      CHARACTER*8   ZK8
      CHARACTER*16         ZK16
      CHARACTER*24                 ZK24
      CHARACTER*32                         ZK32
      CHARACTER*80                                 ZK80
      COMMON/KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32   JEXNUM, JEXNOM
C     ----------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------
      INTEGER      IFM,NIV,IBID,NCMP1,NCMPMX,ICMP,JATACH,JDESC,NBCHAM
      INTEGER      JNOCMP,IUNIFI,ISY,IORD,IRET,IFI,N2
      CHARACTER*8  K8B
      CHARACTER*16 NOMSYM,TYPSD,NOMFI
      CHARACTER*19 RESUIN,NOMSY2
      LOGICAL      ULEXIS
C
      CALL INFNIV(IFM,NIV)
C
      IFI = 0
      NOMFI = ' '
      CALL GETVIS ( ' ', 'UNITE'  , 1,1,1, IFI  , N2 )
      IF ( .NOT. ULEXIS( IFI ) ) THEN
         CALL ULOPEN ( IFI, ' ', NOMFI, 'NEW', 'O' )
      ENDIF
C
      CALL JEMARQ()
C
C     RECUPERATION DU NOM DU RESULTAT
      CALL GETVID (' ', 'RESULTAT', 1,1,1, RESUIN, IBID)
C
      WRITE(IFI,*) '-----------------------------------------------',
     &                '------------'
      WRITE(IFI,*) 
     & 'COMPOSANTES DES CHAMPS PRESENTS DANS LE RESULTAT : ',RESUIN
C
C     LECTURE DU NOMBRE DE CHAMPS PRESENTS ET DU NOMBRE D'ORDRE
      CALL JELIRA(RESUIN//'.DESC','NOMMAX',NBCHAM,K8B)
C
      DO 10 ISY = 1,NBCHAM
         CALL JENUNO(JEXNUM(RESUIN//'.DESC',ISY),NOMSYM)
         CALL JENONU(JEXNOM(RESUIN//'.DESC',NOMSYM),IBID)
         CALL JEVEUO(JEXNUM(RESUIN//'.TACH',IBID),'L',JATACH)
         IORD = 1
         IF ( ZK24(JATACH-1+IORD)(1:1) .NE. ' ' ) THEN
            WRITE(IFI,*) '   - CHAMP ',NOMSYM,' :'
            NOMSY2 = ZK24(JATACH-1+IORD)
            CALL CMPCHA(NOMSY2,'&&OP0040.TMP_NOCMP',
     &                  '&&OP0040.TMP_NUCMP',NCMP1,NCMPMX)
            CALL JEVEUO('&&OP0040.TMP_NOCMP','L',JNOCMP)
            DO 30,ICMP = 1,NCMP1
               WRITE(IFI,*) '      * ',ZK8(JNOCMP-1+ICMP)
  30        CONTINUE
            CALL JEDETR('&&OP0040.TMP_NOCMP')
            CALL JEDETR('&&OP0040.TMP_NUCMP')
         ENDIF
  10  CONTINUE
C
      WRITE(IFI,*) '-----------------------------------------------',
     &                '------------'
C
      CALL JEDEMA()
      END
