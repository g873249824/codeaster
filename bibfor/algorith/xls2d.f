      SUBROUTINE XLS2D(JLTSV,JLTSL,JLNSV,JLNSL,NBNO,JCOOR,
     &NBMAF,JDLIMA,NBSEF,JDLISE,JCONX1,JCONX2)
      IMPLICIT NONE
      CHARACTER*8 NOMA
      INTEGER NBNO,JCOOR,NBMAF,NBSEF,JDLIMA,JDLISE  
      INTEGER JLNSV,JLNSL,JLTSV,JLTSL,JCONX1,JCONX2
      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/12/2005   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
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
      CHARACTER*32    JEXNUM,JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER INO,IMAFIS,NMAABS,INOMA, NUNO(2)
      REAL*8 P(2),DMIN, A(2), B(2), M(2), AP(2), AB(2), NORCAB, PS, EPS
      REAL*8  D, ORIABP, XLN, PS1, XLT
      INTEGER ISEFIS, NSEABS, INOSE, NUNOSE, N1, NBNOMA, NUM, NUNOC, I
      LOGICAL MA2FF
      REAL*8 R8MAEM,DDOT,PADIST
      INTEGER IR,IR2,IR3,JMAFIT,JMAFIF,JMAORI,NUNO1,NUNO2,NUNOI,ORI
      LOGICAL FINFIS
C
      CALL JEMARQ()
C
C     REORGANISATION DES MAILLES DE LA FISSURE
C     VECTEURS INTERMEDIAIRE ET ORIENTATION DES MAILLES
      CALL WKVECT('&&XINILS.LIMFISO','V V I',NBMAF,JMAFIT)
      CALL WKVECT('&&XINILS.ORIENT','V V I',NBMAF,JMAORI)
C     INITIALISATION PREMIERE MAILLE
      ORI=1
      ZI(JMAORI)=1
      ZI(JMAFIT)=ZI(JDLIMA)
C     PARCOURS DES MAILLES CONTIGUES DANS 1 SENS
      DO 114 IR=2,NBMAF
        NUNOI=ZI(JCONX1-1+ZI(JCONX2+ZI(JMAFIT+IR-1-1)-1)+1+ORI-1)
        FINFIS=.TRUE.
        DO 113 IR2=1,NBMAF
          NUNO1=ZI(JCONX1-1+ZI(JCONX2+ZI(JDLIMA+IR2-1)-1)+1-1)
          NUNO2=ZI(JCONX1-1+ZI(JCONX2+ZI(JDLIMA+IR2-1)-1)+2-1)
          IF (ZI(JDLIMA+IR2-1).NE.ZI(JMAFIT+IR-1-1)
     &        .AND. (NUNOI.EQ.NUNO1 .OR. NUNOI.EQ.NUNO2)) THEN
            IF (NUNOI.EQ.NUNO1) ORI=1
            IF (NUNOI.EQ.NUNO2) ORI=0
            ZI(JMAORI+IR-1)=ORI
            ZI(JMAFIT+IR-1)=ZI(JDLIMA+IR2-1)
            FINFIS=.FALSE.
            GOTO 1135
          ENDIF 
 113    CONTINUE       
 1135   CONTINUE
        IF (FINFIS) GOTO 1145 
 114  CONTINUE   
 1145 CONTINUE

C     VECTEUR FINAL REORGANISE
      CALL WKVECT('&&XINILS.LIMFISOF','V V I',NBMAF,JMAFIF)
C     DECALAGE DES MAILLES TROUVEES              
      DO 115 IR3=1,IR-1
        ZI(JMAFIF+NBMAF-IR+IR3)=ZI(JMAFIT-1+IR3)
 115  CONTINUE
C     PARCOURS DANS L'AUTRE SENS A PARTIR DE LA PREMIERE MAILLE      
      ORI=0
      DO 117 IR2=IR,NBMAF+1
        NUNOI=ZI(JCONX1-1+ZI(JCONX2+ZI(JMAFIF+NBMAF-IR2+1)-1)+1+ORI-1)
        FINFIS=.TRUE.
        DO 116 IR3=1,NBMAF
          NUNO1=ZI(JCONX1-1+ZI(JCONX2+ZI(JDLIMA+IR3-1)-1)+1-1)
          NUNO2=ZI(JCONX1-1+ZI(JCONX2+ZI(JDLIMA+IR3-1)-1)+2-1)
          IF (ZI(JDLIMA+IR3-1).NE.ZI(JMAFIF+NBMAF-IR2+1)
     &     .AND. (NUNOI.EQ.NUNO1 .OR. NUNOI.EQ.NUNO2)) THEN
            IF (NUNOI.EQ.NUNO1) ORI=1
            IF (NUNOI.EQ.NUNO2) ORI=0
            ZI(JMAORI+NBMAF-IR2)=ORI
            ZI(JMAFIF+NBMAF-IR2)=ZI(JDLIMA+IR3-1)
            FINFIS=.FALSE.
            GOTO 1165
          ENDIF  
 116    CONTINUE       
 1165   CONTINUE
        IF (FINFIS) GOTO 1175 
 117  CONTINUE
 1175 CONTINUE
 
C      DO 118 IR3=1,NBMAF
C      WRITE (6,*) IR3, ZI(JCONX1-1+ZI(JCONX2+ZI(JDLIMA+IR3-1)-1)+1-1)
C     & , ZI(JCONX1-1+ZI(JCONX2+ZI(JDLIMA+IR3-1)-1)+2-1)
C 118  CONTINUE 
C      DO 1182 IR3=1,NBMAF
C      WRITE (6,*) IR3, ZI(JCONX1-1+ZI(JCONX2+ZI(JMAFIF+IR3-1)-1)+1-1)
C     & , ZI(JCONX1-1+ZI(JCONX2+ZI(JMAFIF+IR3-1)-1)+2-1)
C     & , ZI(JMAORI-1+IR3)
C 1182 CONTINUE 
 
      IF (IR2-1.NE.NBMAF) THEN
      WRITE (6,*) IR,IR2,NBMAF
      CALL UTMESS('F','XLS2D','MAILLES MANQUANTES')        
      ENDIF      
C
C     BOUCLE SUR LES NOEUDS P DU MAILLAGE
      DO 11 INO=1,NBNO
          P(1)=ZR(JCOOR-1+3*(INO-1)+1)
          P(2)=ZR(JCOOR-1+3*(INO-1)+2)
C
C     CALCUL DE LSN
C     -------------
          DMIN=R8MAEM()
C         RECHERCHE DE LA MAILLE LA PLUS PROCHE : 
C         BOUCLE SUR NOEUDS DE MAFIS
          DO 2 IMAFIS=1,NBMAF
            NMAABS=ZI(JMAFIF-1+(IMAFIS-1)+1)    
            INOMA=1
            NUNO(INOMA)=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+INOMA-1)
            A(1)=ZR(JCOOR-1+3*(NUNO(INOMA)-1)+1)
            A(2)=ZR(JCOOR-1+3*(NUNO(INOMA)-1)+2)
            
            INOMA=2
            NUNO(INOMA)=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+INOMA-1)
            B(1)=ZR(JCOOR-1+3*(NUNO(INOMA)-1)+1)
            B(2)=ZR(JCOOR-1+3*(NUNO(INOMA)-1)+2)
                        
            DO 211 I=1,2
              AB(I)=B(I)-A(I)
              AP(I)=P(I)-A(I)
 211        CONTINUE
 
C           CALCUL DE EPS TEL QUE AM=EPS*AB             
            NORCAB=AB(1)*AB(1)+AB(2)*AB(2) 
            PS=DDOT(2,AP,1,AB,1)
            EPS=PS/NORCAB
            
C           ON RAMENE LES POINTS EN DEHORS DU SEGMENT             
            IF (EPS.LT.0.D0) EPS=0.D0
            IF (EPS.GT.1.D0) EPS=1.D0
            
            DO 212 I=1,2
              M(I)=A(I)+EPS*AB(I)
 212        CONTINUE                       
                        
C           CALCUL DE LA DISTANCE PM
            D=PADIST(2,P,M)              
                                              
C           MISE EN M�MOIRE DE LSN POUR LA MAILLE LA PLUS PROCHE
C           EN VERIFIANT DE QUEL COTE DE LA FISSURE SE TROUVE P
            IF (D.LT.DMIN) THEN
              DMIN=D             
              ORIABP=AB(1)*AP(2)-AB(2)*AP(1)
              DO 213 I=1,2
              M(I)=A(I)+PS/NORCAB*AB(I)
 213          CONTINUE   
              D=PADIST(2,P,M)
              IF (ORIABP .GT. 0.D0) THEN
                XLN=D
              ELSE
                XLN=-1.D0*D
              END IF
              IF (ZI(JMAORI-1+IMAFIS) .EQ. 0) THEN
                XLN=-1.D0*XLN
              END IF
            END IF 

 2       CONTINUE
       
         ZR(JLNSV-1+(INO-1)+1)=XLN
         ZL(JLNSL-1+(INO-1)+1)=.TRUE.
      
C        CALCUL DE LST
C        -------------   
          DMIN=R8MAEM()

C         RECHERCHE DU POINT LE PLUS PROCHE : BOUCLE SUR POINT DE FONFIS
          DO 3 ISEFIS=1,NBSEF     

            NSEABS=ZI(JDLISE-1+(ISEFIS-1)+1)
            INOSE=1
            NUNOSE=ZI(JCONX1-1+ZI(JCONX2+NSEABS-1)+INOSE-1)

C           BOUCLE SUR LES MAILLES DE MAFIS POUR TROUVER LA BONNE MAILLE
            MA2FF=.FALSE.
            DO 31 IMAFIS=1,NBMAF

              NMAABS=ZI(JMAFIF-1+(IMAFIS-1)+1)
              NBNOMA=ZI(JCONX2+NMAABS) - ZI(JCONX2+NMAABS-1)
C             ON R�CUP�RE LES NUMEROS DS NOEUDS DE LA MAILLE ET ON TESTE
              N1=0

              DO 32 INOMA=1,NBNOMA                
                NUM=ZI(JCONX1-1+ZI(JCONX2+NMAABS-1)+INOMA-1)
                IF (NUNOSE.EQ.NUM) N1=1
C               POUR R�CUP�RER UN 2EME POINT DE LA MAILLE QUI NE SOIT 
C               PAS SUR LE FOND
                IF ((NUNOSE.NE.NUM)) NUNOC=NUM
 32           CONTINUE

              IF (N1.EQ.1) THEN

                MA2FF=.TRUE.
                DO 33 I=1,2
                  A(I)=ZR(JCOOR-1+3*(NUNOSE-1)+I)              
                  B(I)=ZR(JCOOR-1+3*(NUNOC-1)+I)
                  AB(I)=B(I)-A(I)
                  AP(I)=P(I)-A(I)
 33             CONTINUE
 
C               PROJECTION SUR LE SEGMENT
                PS=DDOT(2,AP,1,AB,1)
                PS1=DDOT(2,AB,1,AB,1)
                EPS=PS/PS1
           
C               CALCUL DE LA DISTANCE PA
                D=PADIST(2,P,A)
C               MISE EN M�MOIRE DE LSN=PA.N POUR LE SEG LE PLUS PROCHE
                IF (D.LT.DMIN) THEN
                  DMIN=D
                  XLT=-1.D0*EPS*SQRT(AB(1)*AB(1)+AB(2)*AB(2))
                END IF

              END IF

 31         CONTINUE 
 
            IF (.NOT.MA2FF) CALL UTMESS('F','XLS2D','POINT '//
     &              'DE FOND_FISS SANS MAILLE DE SURFFACE RATTACHEE.')
 3        CONTINUE

         ZR(JLTSV-1+(INO-1)+1)=XLT
         ZL(JLTSL-1+(INO-1)+1)=.TRUE.
      
 11     CONTINUE
      
      CALL JEDEMA()
      
      END
