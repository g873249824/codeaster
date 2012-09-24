      SUBROUTINE IMMECA(TABLCA,LIRELA,MAILLA,
     &                  NBNOBE,NUNOBE,ICABL,NBNOCA,XNOCA,YNOCA,ZNOCA,
     &                  NCNCIN,NMABET)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 25/09/2012   AUTEUR CHEIGNON E.CHEIGNON 
C TOLE CRP_20
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
C-----------------------------------------------------------------------
C  DESCRIPTION : IMMERSION DES NOEUDS D'UN CABLE DANS LE MAILLAGE BETON
C  -----------   ET DETERMINATION DES RELATIONS CINEMATIQUES ENTRE LES
C                DDLS DES NOEUDS DU CABLE ET LES DDLS DES NOEUDS VOISINS
C                DE LA STRUCTURE BETON
C                APPELANT : OP0180 , OPERATEUR DEFI_CABLE_BP
C
C                EN SORTIE ON AJOUTE DES LIGNES DANS LA TABLE RESULTAT
C                LES CASES RENSEIGNEES CORRESPONDENT AUX PARAMETRES
C                <MAILLE_BETON_VOISINE>, <NOEUD_BETON_VOISIN> ET
C                <INDICE_IMMERSION>
C                LA SD DE TYPE LISTE_DE_RELATIONS EST MISE A JOUR
C
C  IN     : TABLCA : CHARACTER*19
C                    NOM DE LA TABLE DECRIVANT LES CABLES
C  IN     : LIRELA : CHARACTER*19 , SCALAIRE
C                    NOM DE LA SD DE TYPE LISTE_DE_RELATIONS
C  IN     : MAILLA : CHARACTER*8 , SCALAIRE
C                    NOM DU CONCEPT MAILLAGE ASSOCIE A L'ETUDE
C  IN     : NBNOBE : INTEGER , SCALAIRE
C                    NOMBRE DE NOEUDS APPARTENANT A LA STRUCTURE BETON
C  IN     : NUNOBE : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR D'ENTIERS POUR STOCKAGE DES
C                    NUMEROS DES NOEUDS APPARTENANT A LA STRUCTURE BETON
C  IN     : ICABL  : INTEGER , SCALAIRE
C                    NUMERO DU CABLE
C  IN     : NBNOCA : INTEGER , VECTEUR DE DIMENSION NBCABL
C                    CONTIENT LES NOMBRES DE NOEUDS DE CHAQUE CABLE
C  IN     : XNOCA  : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR DE REELS POUR STOCKAGE DES
C                    ABSCISSES X DES NOEUDS APPARTENANT AUX CABLES
C  IN     : YNOCA  : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR DE REELS POUR STOCKAGE DES
C                    ORDONNEES Y DES NOEUDS APPARTENANT AUX CABLES
C  IN     : ZNOCA  : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR DE REELS POUR STOCKAGE DES
C                    COTES Z DES NOEUDS APPARTENANT AUX CABLES
C  IN     : NCNCIN : CHARACTER*24 ,
C                    OBJET CONNECTIVITE INVERSE POUR LES MAILLES BETON
C  IN     : NMABET : CHARACTER*24 ,
C                    OBJET CONTENANT LES MAILLES BETON
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C
C ARGUMENTS
C ---------
      INCLUDE 'jeveux.h'
      CHARACTER*8   MAILLA
      CHARACTER*19  LIRELA, NUNOBE, XNOCA, YNOCA, ZNOCA, TABLCA
      INTEGER       NBNOBE, ICABL, NBNOCA(*)
      CHARACTER*24  NCNCIN, NMABET
      CHARACTER*24  VALK(2)
C
C VARIABLES LOCALES
C -----------------
      INTEGER       NSELEC
      PARAMETER     (NSELEC=5)
      INTEGER       IDECA, IMMER, INOB1, INOB2, INOBE, INOCA, IPARA,
     &              ITETRA, JCOOR, JCXMA, JD2, JNOCA, JNOD2, JNUNOB,
     &              JTBLP, JTBNP, JXCA, JXYZMA, JYCA, JZCA, NBCNX,
     &              NBLIGN, NBNO, NBPARA, NNOMAX, NOE, NOEBE(NSELEC),
     &              NUMAIL,NBVAL,NBVAL2, IRET, IBID,NOEBEC
      REAL*8        D2, D2MIN(NSELEC), DX, DY, DZ, RBID, X3DCA(3)
      REAL*8        X3DCA2(3),AXE(3),XNORM,XNORM2,ZERO, XBAR(4)
      REAL*8        RAYON
      REAL*8        LONG,LONGCY,LONGCA,R8MAEM,D2MINC
      INTEGER       IFM,NIV
      CHARACTER*8   NNOEC2, K8B, PRESEN(2),K8VIDE, NOANCR(2), NOGRNA(2)
      COMPLEX*16    CBID
      CHARACTER*3   K3B
      CHARACTER*8   NNOECA, VOISIN(2)
      CHARACTER*24  COORNO, NOMAMA, NONOCA, NONOMA
      INTEGER        N1,IBE,JBE
C
      CHARACTER*24  PARAM(3), PARCR
      INTEGER      IARG
      DATA          PARAM /'MAILLE_BETON_VOISINE    ',
     &                     'NOEUD_BETON_VOISIN      ',
     &                     'INDICE_IMMERSION        '/
      DATA          PARCR /'NOEUD_CABLE             '/
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      CALL INFMAJ()
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

      ZERO = 0.0D0
      LONGCY  = ZERO
      LONGCA = ZERO
      K8VIDE = '        '


C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 1   ACCES AUX DONNEES
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C 1.1 OBJETS DU MAILLAGE
C ---
      COORNO = MAILLA//'.COORDO    .VALE'
      CALL JEVEUO(COORNO,'L',JCOOR)
      NOMAMA = MAILLA//'.NOMMAI'
      NONOMA = MAILLA//'.NOMNOE'


C RECUPERATION DES MOTS-CLES

C     TRAITEMENT DU MOT-CLE 'CONE'
      CALL GETVR8 ('CONE','RAYON',1,IARG,1,RAYON,NBVAL)
      CALL GETVR8 ('CONE','LONGUEUR',1,IARG,1,LONG,NBVAL2)
      IF (NBVAL .EQ. 0) THEN
        RAYON = ZERO
      ENDIF
      IF (NBVAL2 .EQ. 0) THEN
        LONG = ZERO
      ENDIF
      PRESEN(1) = K8VIDE
      PRESEN(2) = K8VIDE
      CALL GETVTX ('CONE','PRESENT',1,IARG,2,PRESEN,N1)


C     TRAITEMENT DU MOT-CLE 'NOEUD_ANCRAGE'
      NOANCR(1) = K8VIDE
      NOANCR(2) = K8VIDE
      CALL GETVTX ('DEFI_CABLE','NOEUD_ANCRAGE',ICABL,IARG,2,NOANCR,N1)

C     TRAITEMENT DU MOT-CLE 'GROUP_NO_ANCRAGE'
      IF (N1.EQ.0) THEN
         CALL GETVEM(MAILLA,'GROUP_NO','DEFI_CABLE','GROUP_NO_ANCRAGE',
     &                        ICABL,IARG,2,NOGRNA(1),IBID)
C
         CALL UTNONO(' ',MAILLA,'NOEUD',NOGRNA(1),K8B,IRET)
         IF ( IRET.EQ.10 ) THEN
            CALL U2MESK('F','ELEMENTS_67',1,NOGRNA(1))
         ELSE IF ( IRET.EQ.1 ) THEN
            VALK(1) = K8B
            CALL U2MESG('A', 'SOUSTRUC_87',1,VALK,0,0,0,0.D0)
         ENDIF
         NOANCR(1) = K8B
C
         CALL UTNONO(' ',MAILLA,'NOEUD',NOGRNA(2),K8B,IRET)
         IF ( IRET.EQ.10 ) THEN
            CALL U2MESK('F','ELEMENTS_67',1,NOGRNA(1))
         ELSE IF ( IRET.EQ.1 ) THEN
            VALK(1) = K8B
            CALL U2MESG('A', 'SOUSTRUC_87',1,VALK,0,0,0,0.D0)
         ENDIF
         NOANCR(2) = K8B
      ENDIF

C
C 1.2 DONNEES RELATIVES AU CABLE
C ---
C.... NOMBRE DE NOEUDS
C
      NBNO = NBNOCA(ICABL)
C
C.... NOMS DES NOEUDS
C
      CALL JEVEUO(TABLCA//'.TBNP','L',JTBNP)
      NBPARA = ZI(JTBNP)
      NBLIGN = ZI(JTBNP+1)
      IDECA = NBLIGN - NBNO
      CALL JEVEUO(TABLCA//'.TBLP','L',JTBLP)
      DO 10 IPARA = 1, NBPARA
         IF ( ZK24(JTBLP+4*(IPARA-1)).EQ.PARCR ) THEN
            NONOCA = ZK24(JTBLP+4*(IPARA-1)+2)
            CALL JEVEUO(NONOCA,'L',JNOCA)
            GO TO 11
         ENDIF
  10  CONTINUE
  11  CONTINUE
C
C.... COORDONNEES DES NOEUDS
C
      CALL JEVEUO(XNOCA,'L',JXCA)
      CALL JEVEUO(YNOCA,'L',JYCA)
      CALL JEVEUO(ZNOCA,'L',JZCA)
C
C 1.3 NUMEROS DES NOEUDS DE LA STRUCTURE BETON
C ---
      CALL JEVEUO(NUNOBE,'L',JNUNOB)
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 2   IMMERSION DES NOEUDS DU CABLE DANS LA STRUCTURE BETON
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C 2.1 CREATION D'OBJETS DE TRAVAIL
C ---
C.... LES MAILLES APPARTENANT A LA STRUCTURE BETON SONT DES MAILLES
C.... TETRA4, TETRA10, PYRAM5, PYRAM13, PENTA6, PENTA15,
C.... HEXA8, HEXA20 OU HEXA27
C.... LA VERIFICATION A ETE EFFECTUEE EN AMONT PAR LA ROUTINE TOMABE
C.... LE NOMBRE DE NOEUDS MAXIMAL SUR UNE MAILLE VAUT DONC 27
C
      NNOMAX = 27
      CALL WKVECT('&&IMMECA.XYZ_NOEMAI','V V R',3*NNOMAX,JXYZMA)
      CALL WKVECT('&&IMMECA.CNX_MAILLE','V V I',NNOMAX  ,JCXMA )
C
      CALL WKVECT('&&IMMECA.D2_MIN_MAX','V V R',NBNOBE  ,JD2   )
      CALL WKVECT('&&IMMECA.NO_MIN_MAX','V V I',NBNOBE  ,JNOD2 )

C.... CALCUL DE LA LONGUEUR TOTALE DU CABLE

      DO 101 INOCA = 1, (NBNO-1)

        NNOECA = ZK8(JNOCA+IDECA+INOCA-1)

C       DANS LE CAS OU LE NOEUD INITIAL CORRESPOND AU NOEUD FINAL DONNE
C       PAR L'UTILISATEUR ON DOIT INVERSER LES DIRECTIVES 'PRESENT'
        IF (INOCA.EQ.1) THEN
          IF (NNOECA.EQ.NOANCR(2)) THEN
            K8B = PRESEN(2)
            PRESEN(2) = PRESEN(1)
            PRESEN(1) = K8B
          ENDIF
        ENDIF

        X3DCA(1) = ZR(JXCA+IDECA+INOCA-1)
        X3DCA(2) = ZR(JYCA+IDECA+INOCA-1)
        X3DCA(3) = ZR(JZCA+IDECA+INOCA-1)

        NNOEC2 = ZK8(JNOCA+IDECA+INOCA-1+1)
        X3DCA2(1) = ZR(JXCA+IDECA+INOCA-1+1)
        X3DCA2(2) = ZR(JYCA+IDECA+INOCA-1+1)
        X3DCA2(3) = ZR(JZCA+IDECA+INOCA-1+1)

        AXE(1) = (X3DCA2(1) - X3DCA(1))
        AXE(2) = (X3DCA2(2) - X3DCA(2))
        AXE(3) = (X3DCA2(3) - X3DCA(3))
        XNORM2 = AXE(1)*AXE(1) + AXE(2)*AXE(2) + AXE(3)*AXE(3)

        IF (XNORM2 .EQ. ZERO) THEN
          CALL U2MESS('F','MODELISA4_70')
        END IF

        XNORM = SQRT(XNORM2)
        LONGCA = LONGCA + XNORM

 101  CONTINUE

      IF (NIV.EQ.2) THEN
        WRITE(IFM,*) '------------------------------------------'
        WRITE(IFM,*) ' DEFINITION DES RELATIONS CINEMATIQUES'
        IF (RAYON .EQ. ZERO) THEN
          WRITE(IFM,*) '  CONE : PAS DE CONE'
        ELSE
          WRITE(IFM,*) '  RAYON DU CONE : ',RAYON
          WRITE(IFM,*) '  LONGUEUR DU CONE : ',LONG
        END IF
        WRITE(IFM,*) '  LONGUEUR DU CABLE : ',LONGCA
        WRITE(IFM,*) ' '
      END IF


C
C 2.2 BOUCLE SUR LE NOMBRE DE NOEUDS DU CABLE
C ---
      DO 100 INOCA = 1, NBNO
C
C
         NNOECA = ZK8(JNOCA+IDECA+INOCA-1)
         X3DCA(1) = ZR(JXCA+IDECA+INOCA-1)
         X3DCA(2) = ZR(JYCA+IDECA+INOCA-1)
         X3DCA(3) = ZR(JZCA+IDECA+INOCA-1)

         NNOEC2 = ZK8(JNOCA+IDECA+INOCA-1+1)
         X3DCA2(1) = ZR(JXCA+IDECA+INOCA-1+1)
         X3DCA2(2) = ZR(JYCA+IDECA+INOCA-1+1)
         X3DCA2(3) = ZR(JZCA+IDECA+INOCA-1+1)

         IF (NIV.EQ.2) THEN
           WRITE(IFM,*) ' '
           WRITE(IFM,*) ' '
           IF (INOCA.LT.NBNO) THEN
             WRITE(IFM,*) 'NOEUDS CABLE : ',NNOECA,' - ',NNOEC2
           ELSE
             WRITE(IFM,*) 'NOEUD CABLE : ',NNOECA
           ENDIF
         END IF

C
C 2.2.0  CREATION DU VECTEUR AXE, RELIANT DEUX NOEUDS CABLES CONSECUTIFS
C .....  POUR LE CALCUL DES DISTANCES AU CYLINDRE
C
         IF (INOCA.NE.NBNO) THEN
           AXE(1) = (X3DCA2(1) - X3DCA(1))
           AXE(2) = (X3DCA2(2) - X3DCA(2))
           AXE(3) = (X3DCA2(3) - X3DCA(3))
           XNORM2 = AXE(1)*AXE(1) + AXE(2)*AXE(2) + AXE(3)*AXE(3)
           XNORM = SQRT(XNORM2)
         ELSE
           XNORM = 0.D0
         ENDIF

C ... CHOIX DU TRAITEMENT :

C  SI LA LONGUEUR (OU LE RAYON) DU CONE EST NULLE (PAS DE CONE)
         IF ( (LONG.EQ.ZERO).OR.(RAYON.EQ.ZERO) ) GO TO 112

C  TESTE SI ON EST EN DEHORS DES ZONES DE DEFINITIONS DES TUNNELS
         IF ( (LONGCY.GT.LONG).AND.(LONGCY.LT.(LONGCA-LONG))
     &      ) GO TO 112

C  SINON TESTE SI ON A DEMANDE DES TUNNELS

         IF ((LONGCY.LT.LONG).AND.(PRESEN(1)(1:3).EQ.'NON')) GO TO 112

         IF ((LONGCY.GT.(LONGCA-LONG)).AND.(PRESEN(2)(1:3).EQ.'NON'))
     &                                                       GO TO 112

C  SINON ON DEFINI LE CONE

C     --------------------------------------------------------
C     CAS 1 : ON DEFINIT LE CONE POUR ATTACHER LES NOEUDS
C     --------------------------------------------------------
C      Note : on ne fait rien au niveau du fortran
C      (voir la macrocommande DEFI_CABLE_BP)


        IF (NIV.EQ.2) THEN
          WRITE(IFM,*) '-> ON DEFINIT LE CYLINDRE D''AXE ',
     &                     NNOECA,' - ',NNOEC2
        END IF

        LONGCY = LONGCY + XNORM
        GO TO 100


C     ---------------------------------------------------------
C     CAS 2 : ON ATTACHE UN SEUL NOEUD DU BETON AU NOEUD CABLE
C     ---------------------------------------------------------

 112    CONTINUE
        IF (NIV.EQ.2) THEN
          WRITE(IFM,*) '-> ON ATTACHE LE NOEUD OU LA MAILLE BETON '//
     &             'LA PLUS PROCHE'
        END IF

        LONGCY = LONGCY + XNORM

C
C 2.2.1  DETERMINATION DU NOEUD DE LA STRUCTURE BETON LE PLUS PROCHE
C .....  DU NOEUD CABLE COURANT
C
C ON DETERMINE LES NSELEC NOEUDS LES PLUS PROCHES

         DO 114 IBE=1,NSELEC
           D2MIN(IBE) = R8MAEM()
           NOEBE(IBE) = 0
 114     CONTINUE

         NOEBEC=0
         DO 110 INOBE = 1, NBNOBE
            NOE = ZI(JNUNOB+INOBE-1)
            DX = X3DCA(1) - ZR(JCOOR+3*(NOE-1)  )
            DY = X3DCA(2) - ZR(JCOOR+3*(NOE-1)+1)
            DZ = X3DCA(3) - ZR(JCOOR+3*(NOE-1)+2)
            D2 = DX * DX + DY * DY + DZ * DZ
            DO 111 IBE=1,NSELEC
              IF (D2.LT.D2MIN(IBE)) THEN
                DO 122 JBE=0, NSELEC-IBE-1
                  D2MIN(NSELEC-JBE)=D2MIN(NSELEC-JBE-1)
                  NOEBE(NSELEC-JBE)=NOEBE(NSELEC-JBE-1)
 122            CONTINUE
                D2MIN(IBE)=D2
                NOEBE(IBE)=NOE
                GOTO 113
              ENDIF
 111        CONTINUE
 113        CONTINUE
            ZR(JD2+INOBE-1) = D2
            ZI(JNOD2+INOBE-1) = NOE
 110     CONTINUE

         IF (NIV.EQ.2) THEN
          WRITE(IFM,*) '   INFOS : DISTANCE MINIMALE : ',SQRT(D2MIN(1))
         END IF

C
C 2.2.2  TENTATIVE D'IMMERSION DU NOEUD CABLE DANS LES MAILLES
C .....  AUXQUELLES APPARTIENT LE NOEUD BETON LE PLUS PROCHE
C
         DO 115 IBE=1,NSELEC
C          ATTENTION IL PEUT Y AVOIR MOINS QUE NSELEC NOEUDS
C          DE BETON
           IF (NOEBE(IBE).EQ.0)GOTO 116

           CALL IMMENO(NCNCIN,NMABET,MAILLA,X3DCA(1),NOEBE(IBE),
     &               NUMAIL,NBCNX,ZI(JCXMA),ZR(JXYZMA),
     &               ITETRA,XBAR(1),IMMER)
           IF ( IMMER.GE.0 ) THEN
             NOEBEC = NOEBE(IBE)
             GOTO 116
           ENDIF
 115     CONTINUE
 116     CONTINUE
C
C 2.2.3  EN CAS D'ECHEC DE LA TENTATIVE PRECEDENTE
C .....
         IF ( IMMER.LT.0 ) THEN
C
C.......... ON CREE UNE LISTE ORDONNEE DES NOEUDS DE LA STRUCTURE BETON
C.......... DU PLUS PROCHE AU PLUS ELOIGNE DU NOEUD CABLE CONSIDERE
C
            DO 120 INOB1 = 1, NBNOBE-1
               D2MINC = ZR(JD2+INOB1-1)
               NOEBEC = ZI(JNOD2+INOB1-1)
               INOBE = INOB1
               DO 121 INOB2 = INOB1+1, NBNOBE
                  IF ( ZR(JD2+INOB2-1).LT.D2MINC ) THEN
                     D2MINC = ZR(JD2+INOB2-1)
                     NOEBEC = ZI(JNOD2+INOB2-1)
                     INOBE = INOB2
                  ENDIF
 121           CONTINUE
               IF ( INOBE.GT.INOB1 ) THEN
                  D2 = ZR(JD2+INOB1-1)
                  NOE = ZI(JNOD2+INOB1-1)
                  ZR(JD2+INOB1-1) = D2MINC
                  ZI(JNOD2+INOB1-1) = NOEBEC
                  ZR(JD2+INOBE-1) = D2
                  ZI(JNOD2+INOBE-1) = NOE
               ENDIF
 120        CONTINUE

         IF (NIV.EQ.2) THEN
           WRITE(IFM,*) '   INFOS : DISTANCE MINIMALE : ',SQRT(D2)
         END IF

C
C.......... LA TENTATIVE D'IMMERSION DANS LES MAILLES AUXQUELLES
C.......... APPARTIENT LE NOEUD BETON LE PLUS PROCHE A DEJA ETE
C.......... EFFECTUEE, SANS SUCCES
C.......... ON EFFECTUE DE NOUVELLES TENTATIVES EN UTILISANT LES NOEUDS
C.......... DE LA LISTE ORDONNEE PRECEDENTE, DU SECOND JUSQU'AU DERNIER
C.......... REPETER
            DO 130 INOBE = NSELEC, NBNOBE
               NOEBEC = ZI(JNOD2+INOBE-1)
C............. TENTATIVE D'IMMERSION DU NOEUD CABLE DANS LES MAILLES
C............. AUXQUELLES APPARTIENT LE NOEUD BETON COURANT
               CALL IMMENO(NCNCIN,NMABET,MAILLA,X3DCA(1),NOEBEC,
     &                     NUMAIL,NBCNX,ZI(JCXMA),ZR(JXYZMA),
     &                     ITETRA,XBAR(1),IMMER)
C............. SORTIE DU BLOC REPETER EN CAS DE SUCCES
               IF ( IMMER.GE.0 ) GO TO 131
 130        CONTINUE
 131        CONTINUE
C
         ENDIF


C
C 2.2.4  SORTIE EN ERREUR FATALE SI ECHEC PERSISTANT
C .....
         IF ( IMMER.LT.0 ) THEN
            WRITE(K3B,'(I3)') ICABL
             VALK(1) = K3B
             VALK(2) = NNOECA
             CALL U2MESK('F','MODELISA4_71', 2 ,VALK)
         ENDIF
C
C 2.2.5  DETERMINATION DES RELATIONS CINEMATIQUES
C .....
         CALL RECI3D(LIRELA,MAILLA,NNOECA,NOEBEC,NBCNX,ZI(JCXMA),
     &               ITETRA,XBAR(1),IMMER)
C
C 2.2.6  MISE A JOUR DE LA SD TABLE
C .....
         CALL JENUNO(JEXNUM(NOMAMA,NUMAIL),VOISIN(1))
         CALL ASSERT(NOEBEC.NE.0)
         CALL JENUNO(JEXNUM(NONOMA,NOEBEC) ,VOISIN(2))
         CALL TBAJLI(TABLCA,3,PARAM,
     &               IMMER,RBID,CBID,VOISIN(1),IDECA+INOCA)

 100  CONTINUE

C  FIN BOUCLE SUR NBNO

C
C --- MENAGE
C
      CALL JEDETR('&&IMMECA.XYZ_NOEMAI')
      CALL JEDETR('&&IMMECA.CNX_MAILLE')
      CALL JEDETR('&&IMMECA.D2_MIN_MAX')
      CALL JEDETR('&&IMMECA.NO_MIN_MAX')

      CALL JEDEMA()
C
C --- FIN DE IMMECA.
      END
