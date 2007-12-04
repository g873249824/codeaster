      SUBROUTINE XMCART(NOMA,DEFICO,MODELE,RESOCO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/10/2007   AUTEUR NISTOR I.NISTOR 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*8  NOMA,MODELE
      CHARACTER*24 DEFICO,RESOCO     
C
C ----------------------------------------------------------------------
C ROUTINE APPELLEE PAR : XCONLI
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C CREATION DE LA CARTE CONTENANT LES INFOS DE CONTACT
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  MODELE   : NOM DU MODELE
C
C CONTENU DE LA CARTE
C
C 1  XPC: COORDONNEE PARAMETRIQUE X DU POINT DE CONTACT
C 2  XPR: COORDONNEE PARAMETRIQUE X DU PROJETE DU POINT DE CONTACT
C 3  YPR: COORDONNEE PARAMETRIQUE Y DU PROJETE DU POINT DE CONTACT
C 4  TAU1(1): COMPOSANTE 1 DU VECTEUR TANGENT 1
C 5  TAU1(2): COMPOSANTE 2 DU VECTEUR TANGENT 1
C 6  TAU1(3): COMPOSANTE 3 DU VECTEUR TANGENT 1
C 7  TAU2(1): COMPOSANTE 1 DU VECTEUR TANGENT 2
C 8  TAU2(2): COMPOSANTE 2 DU VECTEUR TANGENT 2
C 9  TAU2(3): COMPOSANTE 3 DU VECTEUR TANGENT 2
C 10 YPC: COORDONNEE PARAMETRIQUE Y DU POINT DE CONTACT
C 11 INDCO : ETAT DE CONTACT (0 PAS DE CONTACT)
C 12 LAMBDA: VALEUR DU SEUIL_INIT
C 13 COEFCA: COEF_REGU_CONT
C 14 COEFFA: COEF_REGU_FROT
C 15 COEFFF: COEFFICIENT DE FROTTEMENT DE COULOMB
C 16 IFROTT: FROTTEMENT (0 SI PAS, 3 SI COULOMB)
C 17 INDNOR: NOEUD EXCLU PAR PROJECTION HORS ZONE
C 18 AXIS  : MODELE AXISYMETRIQUE
C 19 HPG   : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
CC 20 INST(2) : PARAMETRE DYNAMIQUE INCREMENT DE TEMPS
C 21 IFORM   : FORMULATION (DEPLACEMENT OU VITESSE)
C 22 INDM    : NOMBRE DE NOEUDS EXCLUS PAR SANS GROUP_NO 
C 23 INI1   : NUMERO DU PREMIER NOEUD A EXCLURE
C 24 INI2   : NUMERO DU DEUXIEME NOEUD A EXCLURE
C 25 INI3   : NUMERO DU TROISIEME NOEUD A EXCLURE
C 26 XS     : INDICATEUR SI DANS ZONE ASPERITES
C 27 COMPLI : INDICATEUR DE COMPLIANCE 
C 28 ASPERI : VALEUR DE L'ASPERITE
C 29 E_N    : PARAMETRE E_N POUR LA COMPLIANCE
C 30 E_V    : PARAMETRE E_V POUR LA COMPLIANCE
CC 31 INST(4) : PARAMETRE ALPHA DE NEWMARK
CC 32 INST(5) : PARAMETRE DELTA DE NEWMARK
CC 33 JEUSUP : VALEUR DU JEU ARTIFICIEL PAR DIST_ESCL/DIST_MAIT
C 34 IMA    : NUMERO DE LA MAILLE ESCLAVE
C 35 IMABAR : NUMERO DE LA MAILLE ESCLAVE DE L'ELEMENT DE BARSOUM
C 36 INDNOB : NUMERO DU NOEUD A EXCLURE DANS LA MAILLE POUR BARSOUM
C 37 INDNOQ : NUMERO DU NOEUD EN FACE DU NOEUD A EXCLURE POUR BARSOUM
C 38 TYPBAR : NOEUDS EXCLUS PAR L'ELEMENT DE BARSOUM
C 39 INDRAC : NOEUDS EXCLUS PAR GROUP_NO_RACC
C 40 INDUSU : INDICATEUR D'USURE
C 41 K      : PARAMETRE K POUR L'USURE
C 42 H      : PARAMETRE H POUR L'USURE
C 43 INDUSU : INDICATEUR DE PIVOT NUL PROBABLE POUR LES
C             NOEUDS EXCLUS PAR DETECTION AUTOMATIQUE 
C             DES REDONDANCES
C 44 TYPALGC: TYPE D'ALGORITHME POUR LE CONTACT (1 SI LAGRANGIEN, 
C             2 SI STABILISATION, 3 SI AUGMENTATION)
C 45 COEFCS:  COEF_STAB_CONT
C 46 COEFCP:  COEF_PENA_CONT
C 47 TYPALGF: TYPE D'ALGORITHME POUR LE FROTTEMENT (1 SI LAGRANGIEN, 
C             2 SI STABILISATION, 3 SI AUGMENTATION)
C 48 COEFFS:  COEF_STAB_FROT
C 49 COEFFP:  COEF_PENA_FROT
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
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
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NCMP1,NCMP2,NCMP3,NCMP4
      PARAMETER    (NCMP1=50)
      PARAMETER    (NCMP2=36)
      PARAMETER    (NCMP3=48)
      PARAMETER    (NCMP4=30)
      INTEGER      CFMMVD,ZTABF,ZCMCF,ZECPD,IMAES,IMAMA
      INTEGER      I,J,IPC,K,IZONE,NBPC,IBID,NDIM,NPT
      INTEGER      JTABF,JECPD,JJSUP,JCMCF,JDIM
      INTEGER      JVALV1,JVALV2,JVALV3,JVALV4,IADE,IADM
      INTEGER      JNCMP1,JNCMP2,JNCMP3,JNCMP4,JCESL2,JCESL3,JCESL4
      INTEGER      JCESD2,JCESD3,JCESD4,JCESV2,JCESV3,JCESV4
      CHARACTER*2  CH2
      CHARACTER*8  KBID,CARTCF
      CHARACTER*19 LIGRCF
      CHARACTER*19 CPOINT,CPINTE,CAINTE,CCFACE,CHS2,CHS3,CHS4
      INTEGER      IFM,NIV      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C      
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> CREATION DE LA CARTE POUR LES'//
     &        ' ELEMENTS DE CONTACT X-FEM' 
      ENDIF  
C
C --- ACCES OBJETS
C
      CALL JEVEUO(DEFICO(1:16)//'.TABFIN','L',JTABF)      
      CALL JEVEUO(DEFICO(1:16)//'.NDIMCO','L',JDIM)
C
C --- LIGREL DES ELEMENTS TARDIFS DE CONTACT/FROTTEMENT    
C
      LIGRCF = RESOCO(1:14)//'.LIGR'
C      
C --- CARTE POUR ELEMENTS TARDIFS DE CONTACT/FROTTEMENT    
C
      CARTCF = RESOCO(1:14)//'.CART'
C
      CHS2 = '&&XMCART.CHS2'
      CHS3 = '&&XMCART.CHS3'
      CHS4 = '&&XMCART.CHS4'
C
      CALL CELCES(MODELE//'.TOPOFAC.PI','V',CHS2)
      CALL CELCES(MODELE//'.TOPOFAC.AI','V',CHS3)
      CALL CELCES(MODELE//'.TOPOFAC.CF','V',CHS4)
C
      CALL JEVEUO(CHS2//'.CESD','L',JCESD2)
      CALL JEVEUO(CHS3//'.CESD','L',JCESD3)
      CALL JEVEUO(CHS4//'.CESD','L',JCESD4)
      CALL JEVEUO(CHS2//'.CESV','L',JCESV2)
      CALL JEVEUO(CHS3//'.CESV','L',JCESV3)
      CALL JEVEUO(CHS4//'.CESV','L',JCESV4)
      CALL JEVEUO(CHS2//'.CESL','L',JCESL2)
      CALL JEVEUO(CHS3//'.CESL','L',JCESL3)
      CALL JEVEUO(CHS4//'.CESL','L',JCESL4)
C
      ZTABF = CFMMVD('ZTABF')
      ZCMCF = CFMMVD('ZCMCF')
C      ZECPD = CFMMVD('ZECPD')  
C
      NDIM = ZI(JDIM)
C
C --- DESTRUCTION DE LA CARTE SI ELLE EXISTE
C
      CPOINT=CARTCF//'.POINT'
      CPINTE=CARTCF//'.PINTER'
      CAINTE=CARTCF//'.AINTER'
      CCFACE=CARTCF//'.CFACE'
C
      CALL DETRSD('CARTE',CPOINT)
      CALL DETRSD('CARTE',CPINTE)
      CALL DETRSD('CARTE',CAINTE)
      CALL DETRSD('CARTE',CCFACE)
C
      CALL ALCART('V',CPOINT,NOMA,'NEUT_R')
      CALL JEVEUO(CPOINT//'.NCMP','E',JNCMP1)
      CALL JEVEUO(CPOINT//'.VALV','E',JVALV1)
C
      CALL ALCART('V',CPINTE,NOMA,'NEUT_R')
      CALL JEVEUO(CPINTE//'.NCMP','E',JNCMP2)
      CALL JEVEUO(CPINTE//'.VALV','E',JVALV2)
C
      CALL ALCART('V',CAINTE,NOMA,'NEUT_R')
      CALL JEVEUO(CAINTE//'.NCMP','E',JNCMP3)
      CALL JEVEUO(CAINTE//'.VALV','E',JVALV3)
C
      CALL ALCART('V',CCFACE,NOMA,'NEUT_R')
      CALL JEVEUO(CCFACE//'.NCMP','E',JNCMP4)
      CALL JEVEUO(CCFACE//'.VALV','E',JVALV4)
C
      DO 101,K = 1,NCMP1
        CALL CODENT(K,'G',CH2)
        ZK8(JNCMP1-1+K) = 'X'//CH2
  101 CONTINUE
C
      DO 102,K = 1,NCMP2
        CALL CODENT(K,'G',CH2)
        ZK8(JNCMP2-1+K) = 'X'//CH2
  102 CONTINUE
C
      DO 103,K = 1,NCMP3
        CALL CODENT(K,'G',CH2)
        ZK8(JNCMP3-1+K) = 'X'//CH2
  103 CONTINUE
C
      DO 104,K = 1,NCMP4
        CALL CODENT(K,'G',CH2)
        ZK8(JNCMP4-1+K) = 'X'//CH2
  104 CONTINUE 
C
      NBPC = NINT(ZR(JTABF-1+1)) 
C
      CALL JEVEUO(DEFICO(1:16)//'.CARACF','L',JCMCF)
C
C --- REMPLISSAGE DE LA CARTE 
C     
      DO 110,IPC = 1,NBPC
        IZONE = NINT(ZR(JTABF+ZTABF*(IPC-1)+15))
C ------ON RECUPERE LES NUMEROS DES MAILLES ESCLAVE ET MAITRE
        IMAES= ZR(JTABF+ZTABF*(IPC-1)+1)
        IMAMA= ZR(JTABF+ZTABF*(IPC-1)+2)
C-------NOMBRE DES POINTS D'INTERSECTION DES MAILLES ESCLAVE ET MAITRE
C-------POUR L'INSTANT, EN 2D, NPT=2
        NPT=2
C
C------REMPLISSAGE DE LA CARTE CARTCF.POINT
C
        ZR(JVALV1-1+1)  = ZR(JTABF+ZTABF*(IPC-1)+3)
        ZR(JVALV1-1+2)  = ZR(JTABF+ZTABF*(IPC-1)+4)
        ZR(JVALV1-1+3)  = ZR(JTABF+ZTABF*(IPC-1)+5)
        ZR(JVALV1-1+4)  = ZR(JTABF+ZTABF*(IPC-1)+6)
        ZR(JVALV1-1+5)  = ZR(JTABF+ZTABF*(IPC-1)+7)
        ZR(JVALV1-1+6)  = ZR(JTABF+ZTABF*(IPC-1)+8)
        ZR(JVALV1-1+7)  = ZR(JTABF+ZTABF*(IPC-1)+9)
        ZR(JVALV1-1+8)  = ZR(JTABF+ZTABF*(IPC-1)+10)
        ZR(JVALV1-1+9)  = ZR(JTABF+ZTABF*(IPC-1)+11)
        ZR(JVALV1-1+10) = ZR(JTABF+ZTABF*(IPC-1)+12)
        ZR(JVALV1-1+11) = ZR(JTABF+ZTABF*(IPC-1)+13)
        ZR(JVALV1-1+12) = ZR(JTABF+ZTABF*(IPC-1)+14)
        ZR(JVALV1-1+13) = ZR(JCMCF+ZCMCF*(IZONE-1)+2)
        ZR(JVALV1-1+14) = ZR(JCMCF+ZCMCF*(IZONE-1)+3)
        ZR(JVALV1-1+15) = ZR(JCMCF+ZCMCF*(IZONE-1)+4)
        ZR(JVALV1-1+16) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+5))
        ZR(JVALV1-1+17) = ZR(JTABF+ZTABF*(IPC-1)+22)
C        ZR(JVALV1-1+18) = ZI(JECPD+ZECPD*(IZONE-1)+1)
        ZR(JVALV1-1+18) = 0
        ZR(JVALV1-1+19) = ZR(JTABF+ZTABF*(IPC-1)+16)
C        ZR(JVALV1-1+20) = INST(2)
        ZR(JVALV1-1+20) = 0.D0
C        ZR(JVALV1-1+21) = ZI(JECPD+ZECPD*(IZONE-1)+6)
        ZR(JVALV1-1+21) = 0
C        ZR(JVALV1-1+22) = ZR(JTABF+ZTABF*(IPC-1)+17)
        ZR(JVALV1-1+22) = 0.D0
C        ZR(JVALV1-1+23) = ZR(JTABF+ZTABF*(IPC-1)+18)
        ZR(JVALV1-1+23) = 0.D0
C        ZR(JVALV1-1+24) = ZR(JTABF+ZTABF*(IPC-1)+19)
        ZR(JVALV1-1+24) = 0.D0
C        ZR(JVALV1-1+25) = ZR(JTABF+ZTABF*(IPC-1)+20)
        ZR(JVALV1-1+25) = 0.D0
C        ZR(JVALV1-1+26) = ZR(JTABF+ZTABF*(IPC-1)+21)
        ZR(JVALV1-1+26) = 0.D0
C        ZR(JVALV1-1+27) = NINT(ZR(JCMCF+ZCMCF* (IZONE-1)+7))
        ZR(JVALV1-1+27) = 0.D0
C        ZR(JVALV1-1+28) = ZR(JCMCF+ZCMCF*(IZONE-1)+8)
        ZR(JVALV1-1+28) = 0.D0
C ---- CONTACT GLISSIERE	
C        ZR(JVALV1-1+29) = ZR(JCMCF+ZCMCF*(IZONE-1)+9)
        ZR(JVALV1-1+29) = ZR(JTABF+ZTABF*(IPC-1)+29)
C ---- MEMOIRE DE CONTACT	
C        ZR(JVALV1-1+30) = ZR(JCMCF+ZCMCF*(IZONE-1)+10)
        ZR(JVALV1-1+30) = ZR(JTABF+ZTABF*(IPC-1)+28)
C-----LES NUMEROS DES FACETTES (ESCLAVE ET MAITRE)
C        ZR(JVALV1-1+31) = INST(4)
        ZR(JVALV1-1+31) = ZR(JTABF+ZTABF*(IPC-1)+25)
C        ZR(JVALV1-1+32) = INST(5)
        ZR(JVALV1-1+32) = ZR(JTABF+ZTABF*(IPC-1)+26)
C        ZR(JVALV1-1+33) = ZR(JJSUP+IZONE-1)
        ZR(JVALV1-1+33) = 0.D0
        ZR(JVALV1-1+34) = ZR(JTABF+ZTABF*(IPC-1)+23)
C        ZR(JVALV1-1+35) = ZR(JTABF+ZTABF*(IPC-1)+24)
        ZR(JVALV1-1+35) =0.D0
C        ZR(JVALV1-1+36) = ZR(JTABF+ZTABF*(IPC-1)+25)
        ZR(JVALV1-1+36) =0.D0
C        ZR(JVALV1-1+37) = ZR(JTABF+ZTABF*(IPC-1)+26)
        ZR(JVALV1-1+37) = 0.D0
C        ZR(JVALV1-1+38) = ZR(JTABF+ZTABF*(IPC-1)+27)
        ZR(JVALV1-1+38) = 0.D0
C        ZR(JVALV1-1+39) = ZR(JTABF+ZTABF*(IPC-1)+28)
        ZR(JVALV1-1+39) = 0.D0
C        ZR(JVALV1-1+40) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+13))
        ZR(JVALV1-1+40) = 0
C        ZR(JVALV1-1+41) = ZR(JCMCF+ZCMCF*(IZONE-1)+14)
        ZR(JVALV1-1+41) = 0.D0
C        ZR(JVALV1-1+42) = ZR(JCMCF+ZCMCF*(IZONE-1)+15)
        ZR(JVALV1-1+42) = 0.D0
C        ZR(JVALV1-1+43) = ZR(JTABF+ZTABF*(IPC-1)+29)
        ZR(JVALV1-1+43) = 0.D0
C        ZR(JVALV1-1+44) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+16))
        ZR(JVALV1-1+44) = 0
C        ZR(JVALV1-1+45) = ZR(JCMCF+ZCMCF*(IZONE-1)+17)
        ZR(JVALV1-1+45) = 0.D0
C        ZR(JVALV1-1+46) = ZR(JCMCF+ZCMCF*(IZONE-1)+18)
        ZR(JVALV1-1+46) = 0.D0
C        ZR(JVALV1-1+47) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+19))
        ZR(JVALV1-1+47) = 0
C        ZR(JVALV1-1+48) = ZR(JCMCF+ZCMCF*(IZONE-1)+20)
        ZR(JVALV1-1+48) = 0.D0
C        ZR(JVALV1-1+49) = ZR(JCMCF+ZCMCF*(IZONE-1)+21)
        ZR(JVALV1-1+49) = 0.D0
C        ZR(JVALV1-1+50) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+22))
        ZR(JVALV1-1+50) = 0
C
        CALL NOCART(CPOINT,-3,KBID,'NUM',1,KBID,-IPC,LIGRCF,NCMP1)
C
C-----REMPLISSAGE DE LA CARTE CARTCF.PINTER
        DO 10 I=1,NPT
          DO 20 J=1,NDIM
            CALL CESEXI('S',JCESD2,JCESL2,IMAES,1,1,NDIM*(I-1)+J,IADE)
            CALL ASSERT(IADE.GT.0)
            ZR(JVALV2-1+NDIM*(I-1)+J)=ZR(JCESV2-1+IADE)
            CALL CESEXI('S',JCESD2,JCESL2,IMAMA,1,1,NDIM*(I-1)+J,IADM)
            CALL ASSERT(IADM.GT.0)
            ZR(JVALV2-1+18+NDIM*(I-1)+J)=ZR(JCESV2-1+IADM)
 20       CONTINUE
 10     CONTINUE

       CALL NOCART(CPINTE,-3,KBID,'NUM',1,KBID,-IPC,LIGRCF,NCMP2)

C-----REMPLISSAGE DE LA CARTE CARTCF.AINTER
        DO 30 I=1,NPT
          DO 40 J=1,4
            CALL CESEXI('S',JCESD3,JCESL3,IMAES,1,1,4*(I-1)+J,IADE)
            CALL ASSERT(IADE.GT.0)
            ZR(JVALV3-1+4*(I-1)+J)=ZR(JCESV3-1+IADE)
            CALL CESEXI('S',JCESD3,JCESL3,IMAMA,1,1,4*(I-1)+J,IADM)
            CALL ASSERT(IADM.GT.0)
            ZR(JVALV3-1+24+4*(I-1)+J)=ZR(JCESV3-1+IADM)
 40       CONTINUE
 30     CONTINUE
 
       CALL NOCART(CAINTE,-3,KBID,'NUM',1,KBID,-IPC,LIGRCF,NCMP3)

C-----REMPLISSAGE DE LA CARTE CARTCF.CCFACE	
        IF (NDIM.EQ.2) THEN
          DO 60 J=1,2
            CALL CESEXI('S',JCESD4,JCESL4,IMAES,1,1,J,IADE)
            CALL ASSERT(IADE.GT.0)
            ZR(JVALV4-1+J)=ZI(JCESV4-1+IADE)
            CALL CESEXI('S',JCESD4,JCESL4,IMAMA,1,1,J,IADM)
            CALL ASSERT(IADM.GT.0)
            ZR(JVALV4-1+15+J)=ZI(JCESV4-1+IADM)
 60       CONTINUE
       ELSE
         DO 70 I=1,5
            DO 80 J=1,3
              CALL CESEXI('S',JCESD4,JCESL4,IMAES,1,1,3*(I-1)+J,IADE)
              CALL ASSERT(IADE.GT.0)
              ZR(JVALV4-1+3*(I-1)+J)=ZI(JCESV4-1+IADE)
              CALL CESEXI('S',JCESD4,JCESL4,IMAMA,1,1,3*(I-1)+J,IADM)
              CALL ASSERT(IADM.GT.0)
              ZR(JVALV4-1+15+3*(I-1)+J)=ZI(JCESV4-1+IADM)    
 80         CONTINUE
 70       CONTINUE
       ENDIF

       CALL NOCART(CCFACE,-3,KBID,'NUM',1,KBID,-IPC,LIGRCF,NCMP4)

        IF (NIV.GE.2) THEN
          CALL MMIMP3(IFM,NOMA,LIGRCF,IPC,JVALV1,JTABF,IBID)
        ENDIF

  110 CONTINUE       
C
C --- MENAGE 
C
      CALL JEDETR(CPOINT//'.NCMP')
      CALL JEDETR(CPOINT//'.VALV')     
      CALL JEDETR(CPINTE//'.NCMP')
      CALL JEDETR(CPINTE//'.VALV')
      CALL JEDETR(CAINTE//'.NCMP')
      CALL JEDETR(CAINTE//'.VALV') 
      CALL JEDETR(CCFACE//'.NCMP')
      CALL JEDETR(CCFACE//'.VALV')           
C
      CALL JEDEMA()      
      END
