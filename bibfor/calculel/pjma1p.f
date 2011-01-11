      SUBROUTINE PJMA1P(MOA1,MA1P,CORRES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/01/2011   AUTEUR BERARD A.BERARD 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE BERARD A.BERARD
C
C
C
C COMMANDE:  PROJ_CHAMP
C CREATION DU MAILLAGE 1 PRIME (MA1P)
C REMPLISSAGE DU .PJEF_MP DANS LA SD CORRES
C   QUI EST LE NOM DU MAILLAGE 1 PRIME

C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
C MOA1 : MODELE1 A ECLATER
C MA1P : EST LE MAILLAGE 1 PRIME
C CORRES : STRUCTURE DE DONNEES CORRES 
 
       CHARACTER*8 MOA1, MA1P
       INTEGER IER


C
C 0.2. ==> COMMUNS
C ----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXNUM
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

      CHARACTER*32 JEXNOM


C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C

      REAL*8 SHRINK, LONMIN
      INTEGER IRET,I
      INTEGER JCORRE
      CHARACTER*8 MAIL2,MA2P
      CHARACTER*16 CORRES,LISCH(1)
      CHARACTER*19 LIGREL


      CALL JEMARQ()

      SHRINK=1.D0
      LONMIN=0.D0
      LISCH(1)='SIEF_ELGA_DEPL'
      LIGREL=' '
      I=1

      CALL ECLPGM(MA1P,MOA1,LIGREL,SHRINK,LONMIN,I,LISCH)

      CALL WKVECT(CORRES//'.PJEF_MP', 'G V K8', 1, JCORRE)
      ZK8(JCORRE+1-1)=MA1P

      CALL JEDEMA()

      END
