      SUBROUTINE DFLLD2(SDLIST,IFM  ,IECHEC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF DEBUG  DATE 19/09/2011   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT NONE
      CHARACTER*8  SDLIST
      INTEGER      IFM,IECHEC
C
C ----------------------------------------------------------------------
C
C OPERATEUR DEFI_LIST_INST
C
C IMPRESSION DEBUG - OPTIONS DE DECOUPE
C
C ----------------------------------------------------------------------
C
C IN  SDLIST : NOM DE LA SD RESULTAT
C IN  IFM    : UNITE LOGIQUE AFFICHAGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*24 LISIFR
      INTEGER      JLINR
      INTEGER      DFLLVD,LESUR
      CHARACTER*24 LISESU
      INTEGER      JESUR
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- TAILLE DES VECTEURS
C
      LESUR  = DFLLVD('LESUR') 
C
C --- ACCES SDS
C
      LISIFR = SDLIST(1:8)//'.LIST.INFOR'
      CALL JEVEUO(LISIFR,'L',JLINR )
      LISESU = SDLIST(1:8)//'.ECHE.SUBDR'
      CALL JEVEUO(LISESU,'L',JESUR )
C
C --- AFFICHAGE
C

      IF (ZR(JESUR-1+LESUR*(IECHEC-1)+1).EQ.1.D0) THEN
        WRITE(IFM,*) '<DEFILISTINST> ......... MANUEL'
        WRITE(IFM,*) '<DEFILISTINST> ............ NBRE DE'//
     &             ' SUBDIVISIONS DEMANDEES',
     &             NINT(ZR(JESUR-1+LESUR*(IECHEC-1)+2))
        IF (NINT(ZR(JESUR-1+LESUR*(IECHEC-1)+4)).EQ.0) THEN
          WRITE(IFM,*) '<DEFILISTINST> ............ ARRET'//
     &                 ' DE LA SUBDIVISION QUAND LE PAS '//
     &                 ' VAUT MOINS DE : ',
     &                  ZR(JESUR-1+LESUR*(IECHEC-1)+3) 
        ELSE
          WRITE(IFM,*) '<DEFILISTINST> ............ ARRET'//
     &                 ' DE LA SUBDIVISION QUAND LE NIVEAU'//
     &                 ' DE SUBDIVISION VAUT: ',
     &                 NINT(ZR(JESUR-1+LESUR*(IECHEC-1)+4))
        ENDIF
      ELSEIF (ZR(JESUR-1+LESUR*(IECHEC-1)+1).EQ.2.D0) THEN
        WRITE(IFM,*) '<DEFILISTINST> ......... AUTOMATIQUE'
        
        IF (ZR(JESUR-1+LESUR*(IECHEC-1)+10).EQ.2.D0) THEN
          WRITE(IFM,*) '<DEFILISTINST> ............ EXTRAPOLATION '
        ELSEIF (ZR(JESUR-1+LESUR*(IECHEC-1)+10).EQ.1.D0) THEN
          WRITE(IFM,*) '<DEFILISTINST> ............ COLLISION '
          WRITE(IFM,*) '<DEFILISTINST> ............... PRECISION'//
     &                 ' DE LA COLLISION : ',
     &                  ZR(JESUR-1+LESUR*(IECHEC-1)+5)       
        ELSE    
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF
C
      CALL JEDEMA()
      END
