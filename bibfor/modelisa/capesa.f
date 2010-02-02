      SUBROUTINE CAPESA(CHAR,NOMA,IPESA, NDIM, LIGRMO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 02/02/2010   AUTEUR IDOUX L.IDOUX 
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
C BUT : STOCKAGE DE LA PESANTEUR DANS UNE CARTE ALLOUEE SUR LE
C       LIGREL DU MODELE
C
C ARGUMENTS D'ENTREE:
C      CHAR  : NOM UTILISATEUR DU RESULTAT DE CHARGE
C      NOMA  : NOM DU MAILLAGE
C      IPESA : OCCURENCE DU MOT-CLE FACTEUR PESANTEUR
C      NDIM  : DIMENSIOn DU PROBLEME 
C      LIGRMO: NOM DU LIGREL DE MODELE
C
      REAL*8 PESA(4),R8MIEM, NORME, PES(3)
      COMPLEX*16 CBID
      CHARACTER*8  CHAR,NOMA,LICMP(4)
      CHARACTER*19 CARTE
      INTEGER IOCC, IPESA, NBMAIL, NBGPMA
      INTEGER IBID, IER, JMA, JNCMP, JVALV
      INTEGER NBMA, NCMP, NDIM, NPESA 
      CHARACTER*8   K8B
      CHARACTER*24  MESMAI
      CHARACTER*(*) LIGRMO
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNOM, JEXNUM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      CHARACTER*8  TYPMCL(2)
      CHARACTER*16 MOTCLE(2)
C
      DO 10 IOCC = 1, IPESA
        CALL GETVR8 ('PESANTEUR','GRAVITE',IOCC,1,1,PESA(1),NPESA)
        CALL GETVR8 ('PESANTEUR','DIRECTION',IOCC,1,3,PES,NPESA)
C
        NORME=SQRT( PES(1)*PES(1)+PES(2)*PES(2)+PES(3)*PES(3) )
        IF (NORME.GT.R8MIEM()) THEN
           PESA(2)=PES(1)/NORME
           PESA(3)=PES(2)/NORME
           PESA(4)=PES(3)/NORME
        ELSE
           CALL U2MESS('F','MODELISA3_63')
        END IF
C       
        CALL GETVTX ('PESANTEUR','MAILLE', IOCC,1,1,K8B,NBMAIL)
        CALL GETVTX ('PESANTEUR','GROUP_MA', IOCC,1,1,K8B,NBGPMA)      
        NBMA=NBMAIL+NBGPMA
C
C   SI NBMA = 0, ALORS IL N'Y A AUCUN MOT CLE GROUP_MA OU MAILLE,
C   DONC LA PESANTEUR S'APPLIQUE A TOUT LE MODELE (VALEUR PAR DEFAUT)
C
        IF (NBMA.EQ.0) THEN
C
C   UTILISATION DE LA ROUTINE MECACT (PAS DE CHANGEMENT PAR RAPPORT
C   A LA PRECEDENTE FACON DE PRENDRE EN COMPTE LA PESANTEUR)
C
          CARTE=CHAR//'.CHME.PESAN'
          LICMP(1)='G'
          LICMP(2)='AG'
          LICMP(3)='BG'
          LICMP(4)='CG'
          CALL MECACT('G',CARTE,'MAILLA',NOMA,'PESA_R',4,LICMP,0,PESA,
     +            CBID,' ')
        ELSE
C
C   APPLICATION DE LA PESANTEUR AUX MAILLES OU GROUPES DE MAILLES
C   MENTIONNES. ROUTINE MODIFIEE ET CALQUEE SUR LA PRISE EN COMPTE 
C   D'UNE PRESSION (CBPRES ET CAPRES)
C
          CARTE=CHAR//'.CHME.PESAN'
          CALL ALCART ( 'G', CARTE, NOMA, 'PESA_R')
          CALL JEVEUO ( CARTE//'.NCMP', 'E', JNCMP )
          CALL JEVEUO ( CARTE//'.VALV', 'E', JVALV )
C
C --- STOCKAGE DE FORCES NULLES SUR TOUT LE MAILLAGE
C
          NCMP = 4
          ZK8(JNCMP)   = 'G'
          ZK8(JNCMP+1) = 'AG'
          ZK8(JNCMP+2) = 'BG'
          ZK8(JNCMP+3) = 'CG'
C
          ZR(JVALV)   = 0.D0
          ZR(JVALV+1) = 0.D0
          ZR(JVALV+2) = 0.D0
          ZR(JVALV+3) = 0.D0
          CALL NOCART (CARTE,1,' ','NOM',0,' ',0,' ',NCMP)
C
          MESMAI = '&&CAPESA.MES_MAILLES'
          MOTCLE(1) = 'GROUP_MA'
          MOTCLE(2) = 'MAILLE'
          TYPMCL(1) = 'GROUP_MA'
          TYPMCL(2) = 'MAILLE'

C
C --- STOCKAGE DANS LA CARTE
C
          ZR(JVALV)   = PESA(1)
          ZR(JVALV+1) = PESA(2)
          ZR(JVALV+2) = PESA(3)
          ZR(JVALV+3) = PESA(4)
C
          CALL RELIEM(LIGRMO, NOMA, 'NO_MAILLE', 'PESANTEUR', IOCC, 2,
     &                                  MOTCLE, TYPMCL, MESMAI, NBMA )
          CALL JEVEUO ( MESMAI, 'L', JMA )
          CALL VETYMA ( NOMA,ZK8(JMA),NBMA,K8B,0,'PESANTEUR',NDIM,IER)
          CALL NOCART (CARTE,3,K8B,'NOM',NBMA,ZK8(JMA),IBID,' ',NCMP)
          CALL JEDETR ( MESMAI )
        ENDIF
 10   CONTINUE
      END
