      SUBROUTINE FONNOR ( RESU, NOMA)
      IMPLICIT NONE
      CHARACTER*8         RESU, NOMA
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 06/09/2011   AUTEUR GENIAUT S.GENIAUT 
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
C-----------------------------------------------------------------------
C FONCTION REALISEE:
C
C     CALCUL DE LA NORMALE AU FOND DE FISSURE POUR DEFI_FOND_FISS 
C     EN 2D ET 3D DE LA BASE LOCALE
C
C     ENTREES:
C        RESU   : NOM DU CONCEPT RESULTAT DE L'OPERATEUR
C        NOMA   : NOM DU MAILLAGE
C-----------------------------------------------------------------------
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
      CHARACTER*32     JEXNOM, JEXNUM,JEXATR
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       JNOE1,JBASNO,JTYP,JBASSE
      INTEGER       I,J,INA,INB,ISEG,IFL,IRET,NBNOSE,NBNOFF,INC
      INTEGER       NA,NB,NRET,NDIM,NBNOEL,NSEG,NBMAX,NBMAC
      INTEGER       INDIC(4),NOE(4,4),INDR(2),TABLEV(2)
      REAL*8        VDIR(2,3),VNOR(2,3),NORME
      CHARACTER*6   NOMPRO 
      CHARACTER*8   K8B, TYPE,TYPFON,NOEUA
      CHARACTER*16  CASFON
      CHARACTER*19  BASNOF,BASSEG,MACOFO
      PARAMETER    (NOMPRO='FONNOR')
C     -----------------------------------------------------------------
C
      CALL JEMARQ()

C     ------------------------------------------------------------------
C     INITIALISATIONS
C     ------------------------------------------------------------------

C
C     RECUPERATION DES INFORMATIONS RELATIVES AU MAILLAGE
C
C
C     RECUPERATION DU CONCEPT DU MAILLAGE
      CALL GETVID ( ' ', 'MAILLAGE', 1,1,1, NOMA , NRET )
C
C     RECUPERATION DU NOMBRE DE NOEUDS DU MAILLAGE
      CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,K8B,IRET)
C
C     RECUPERATION DES NOEUDS DU FOND DE FISSURE
C
      CALL JEEXIN(RESU//'.FOND      .NOEU',IRET)
      IF (IRET.NE.0) THEN
C       RECUPERATION DE L'ADRESSE DES NOEUDS DE FOND DE FISSURE
        CALL JEVEUO (RESU//'.FOND      .NOEU', 'L', JNOE1 )     
C       RECUPERATION DU NOMBRE DE NOEUD
        CALL JELIRA (RESU//'.FOND      .NOEU' , 'LONUTI', NBNOFF, K8B)
      ELSE
C       RECUPERATION DE L'ADRESSE DES NOEUDS DE FOND DE FISSURE
        CALL JEVEUO (RESU//'.FOND_SUP  .NOEU', 'L', JNOE1 )     
C       RECUPERATION DU NOMBRE DE NOEUD
        CALL JELIRA (RESU//'.FOND_SUP  .NOEU' , 'LONUTI', NBNOFF, K8B)
      ENDIF
C
C     RECUPERATION DU TYPE DE MAILLE EN FOND DE FISSURE EN 3D
      IF (NDIM.EQ.3) THEN
        CALL JEVEUO (RESU//'.FOND      .TYPE', 'L', JTYP )
        TYPFON = ZK8(JTYP)
C       SUIVANT LE CAS QUADRATIQUE/LINEAIRE EN 3D DEUX MAILLES SONT 
C       CONNECTEES SI ELLES ONT AU MOINS NBMAX NOEUDS EN COMMUN
C       NBNOSE : NOMBRE DE NOEUDS PAR "SEGMENT" DE FOND DE FISSURE 
        IF (TYPFON.EQ.'NOE2'.OR.TYPFON.EQ.'SEG2') THEN
          CASFON = 'LINEAIRE'
          NBNOSE = 2
          NBMAX  = 3
        ELSEIF (TYPFON.EQ.'NOE3'.OR.TYPFON.EQ.'SEG3') THEN
          CASFON = 'QUADRATIQUE'
          NBNOSE = 3
          NBMAX  = 6
        ELSE
          NBNOSE = 2
          NBMAX  = 3

        ENDIF
      ELSE
          NBNOSE = 2
          NBMAX  = 3
      ENDIF
      IF (NDIM.EQ.2) CASFON = '2D'
C     
C
C     ALLOCATION DU VECTEUR DES BASES LOCALES PAR NOEUD DU FOND  :
C           - VECTEUR DIRECTION DE PROPA
C           - VECTEUR NORMAL (A LA SURFACE)
      BASNOF = RESU//'.BASEFOND'
      CALL WKVECT (BASNOF,'G V R',6*NBNOFF,JBASNO)
C
C
C     NSEG : NOMBRE DE "SEGMENTS" DU FOND A TRAITER
      IF (NDIM.EQ.2) THEN
        CALL ASSERT(NBNOFF.EQ.1)
        NSEG = 1
      ELSEIF (NDIM.EQ.3) THEN
        CALL ASSERT(NBNOFF.GT.1)
        IF (CASFON.EQ.'LINEAIRE')    NSEG =  NBNOFF-1
        IF (CASFON.EQ.'QUADRATIQUE') NSEG = (NBNOFF-1)/2
      ENDIF      

C     VECTEUR TEMPORAIRE DES BASES LOCALES PAR SEGMENT DU FOND
      BASSEG = '&&'//NOMPRO//'.BASSEG'
      CALL WKVECT(BASSEG,'V V R',6*NSEG,JBASSE)
C
C     INDICE DE LA FACE A CONSIDERER (FACE DE LA LEVRE, VOIR FONNO6)
      IFL = 0
C
C     ------------------------------------------------------------------
C     BOUCLE SUR LES "SEGMENTS" DU FOND DE FISSURE
C     ------------------------------------------------------------------
C
      DO 100 ISEG=1,NSEG
        
C       INDICES DES NOEUDS DU SEGMENT :
C       NOEUDS SOMMETS (INA ET INB), NOEUD MILIEU (INC)
        IF (CASFON.EQ.'2D') THEN
          INA = ISEG
        ELSEIF (CASFON.EQ.'LINEAIRE') THEN
          INA = ISEG
          INB = ISEG+1
        ELSEIF (CASFON.EQ.'QUADRATIQUE') THEN
          INA = 2*ISEG-1
          INB = 2*ISEG+1
          INC = 2*ISEG
        ENDIF

C       NUMEROS (ABSOLUS) DES NOEUDS SOMMETS DU SEGMENT : NA ET NB
        NOEUA = ZK8(JNOE1-1+INA)
        CALL JENONU (JEXNOM(NOMA//'.NOMNOE',NOEUA),NA)
        IF (NDIM.EQ.3) THEN
          CALL JENONU (JEXNOM(NOMA//'.NOMNOE',ZK8(JNOE1-1+INB)),NB)
        ENDIF

C
C       1) RECUP DES NUMEROS DES MAILLES CONNECTEES AU SEGMENT DU FOND
C          -> REMPLISSAGE DE MACOFO
C       --------------------------------------------------------------
C
C       VECTEUR DES MAILLES CONNECTEES AU SEGMENT DU FOND
        MACOFO = '&&'//'NOMPRO'//'.MACOFOND'
        CALL FONNO1 (NOMA,NDIM,NA,NB,NBMAC,MACOFO)
C
C
C       2) PARMI LES MAILLES CONNECTEES AU SEGMENT DU FOND, FILTRAGE DES
C          MAILLES CONNECTEES A 1 LEVRE (CAD AYANT UNE FACE LIBRE) 
C          -> REMPLISSAGE DE TABLEV
C       ----------------------------------------------------------------
C
        CALL FONNO2 (MACOFO,NOMA,NBMAC,NBNOFF,NBNOSE,
     &               NBMAX,NOEUA,TABLEV)
C     
C
C       3) RECUP DES FACES CONNECTEES AU FOND 
C          POUR CHACUNE DES 2 MAILLES
C          -> REMPLISSAGE DE NOE
C       ----------------------------------------------------

        CALL FONNO3 (NOMA,TABLEV,NDIM,NA,NB,NOE)
C
C
C       4) FILTRE DES FACES LIBRES
C          -> REMPLISSAGE DE INDIC
C       ----------------------------------------------------
C
        CALL FONNO4 (MACOFO,NOMA,NBMAC,TABLEV,NOE,NBNOFF,INDIC)
        CALL JEDETR (MACOFO)

C       5) CALCUL DES VECTEURS DE LA BASE LOCALE : 
C          -> REMPLISSAGE DE VDIR ET VNOR
C            VNOR : VECTEUR NORMAL A LA SURFACE DE LA FISSURE
C            VDIR : VECTEUR DANS LA DIRECTION DE PROPAGATION
C        RQ : CHACUN CONTIENT EN FAIT 2 VECTEURS (UN PAR LEVRE)
C       --------------------------------------------------------
C
        CALL FONNO5 (NOMA,INDIC,NBNOFF,NOE,NA,NB,NDIM,
     &               NBNOEL,INDR, VNOR,VDIR)
C
C
C       6) DETERMINATION DU VRAI VECTEUR ET BASE PAR SEGMENT
C          -> REMPLISSAGE DE BASSEG
C       ----------------------------------------------------
C
        CALL FONNO6 (RESU,NOMA,NDIM,INA,NBNOSE,ISEG,NSEG,
     &               NOE,INDR,NBNOEL,IFL,VNOR,VDIR,BASSEG)
     
C
C
C       7) EN 3D : BASE LOCALE : PASSAGE SEGMENTS -> NOEUDS
C          -> REMPLISSAGE DE BASNOF
C       ---------------------------------------------------

        IF (NDIM.EQ.3) THEN
         
C         MOYENNE POUR LES NOEUDS SOMMENTS INA ET INB
C         DIRECT POUR LE NOEUD MILIEU INC
          DO 110 J=1,6

            ZR(JBASNO-1+6*(INA-1)+J)=( ZR(JBASNO-1+6*(INA -1)+J)
     &                                +ZR(JBASSE-1+6*(ISEG-1)+J) )/2.D0

            ZR(JBASNO-1+6*(INB-1)+J)=( ZR(JBASNO-1+6*(INB -1)+J)
     &                                +ZR(JBASSE-1+6*(ISEG-1)+J) )/2.D0

            IF (CASFON.EQ.'QUADRATIQUE') 
     &        ZR(JBASNO-1+6*(INC-1)+J) = ZR(JBASSE-1+6*(ISEG-1)+J)

 110      CONTINUE     

C         NORMALISATIONS
          CALL NORMEV(ZR(JBASNO-1+6*(INA-1)+1),NORME)
          CALL NORMEV(ZR(JBASNO-1+6*(INB-1)+1),NORME)

        ELSEIF (NDIM.EQ.2) THEN
         
          DO 120 J=1,6
            ZR(JBASNO-1+6*(INA-1)+J) = ZR(JBASSE-1+6*(ISEG-1)+J)        
 120      CONTINUE     
        
        ENDIF  

 100  CONTINUE

C     MENAGE
      CALL JEDETR(BASSEG)     

      CALL JEDEMA()
      END
