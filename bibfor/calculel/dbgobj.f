      SUBROUTINE DBGOBJ(OJBZ,PERM,IUNIT,MESS)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/01/2005   AUTEUR VABHHTS J.PELLET 
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
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET
C ----------------------------------------------------------------------
C     BUT : IMPRIMER SUR LE FICHIER "IUNIT"
C           QUELQUES VALEURS QUI "RESUMENT" UN OBJET JEVEUX (OJB)
C           (SIMPLE OU COLLECTION)
C     ARGUMENTS :
C       IN  OJB    (K24) : NOM DE L'OBJET A IMPRIMER
C       IN  IUNIT  (I)   : NUMERO DE L'UNITE LOGIQUE D'IMPRESSION
C       IN  MESS   (K*)  : "MESSAGE" PREFIXANT LA LIGNE IMPRIMEE
C       IN  PERM    K3 : /OUI/NON
C           NON : ON FAIT LA SOMME BETE DES ELEMENTS DU VECTEUR
C                 => UNE PERMUTATION DU VECTEUR NE SE VOIT PAS !
C           OUI : ON FAIT UNE "SOMME" QUI DONNE UN RESULTAT
C                 DEPENDANT UN PEU DE L'ORDRE DES ELEMENTS DU VECTEUR
C ----------------------------------------------------------------------
      INTEGER IUNIT,NI
      CHARACTER*24 OJB
      CHARACTER*3 TYPE
      CHARACTER*(*) MESS,OJBZ,PERM
      INTEGER SOMMI,RESUME,LONMAX,LONUTI,I,IRET
      REAL*8 SOMMR

C DEB-------------------------------------------------------------------
        OJB=OJBZ
        CALL TSTOBJ(OJB,PERM,RESUME,SOMMI,SOMMR,LONUTI,LONMAX,TYPE,
     &              IRET,NI)
        IF (TYPE(1:1).EQ.'K') THEN
           WRITE (IUNIT,1002) MESS,OJB,LONMAX,LONUTI,TYPE,IRET,SOMMI
        ELSE IF (TYPE(1:1).EQ.'I') THEN
           WRITE (IUNIT,1002) MESS,OJB,LONMAX,LONUTI,TYPE,IRET,SOMMI
        ELSE IF (TYPE(1:1).EQ.'L') THEN
           WRITE (IUNIT,1002) MESS,OJB,LONMAX,LONUTI,TYPE,IRET,SOMMI
        ELSE IF (TYPE(1:1).EQ.'R') THEN
           WRITE (IUNIT,1003) MESS,OJB,LONMAX,LONUTI,TYPE,IRET,NI,SOMMR
        ELSE IF (TYPE(1:1).EQ.'C') THEN
           WRITE (IUNIT,1003) MESS,OJB,LONMAX,LONUTI,TYPE,IRET,NI,SOMMR
        ELSE IF (TYPE(1:1).EQ.'?') THEN
           IF (IRET.NE.0) THEN
              WRITE (IUNIT,1004) MESS,OJB,TYPE,IRET
           ELSE
              CALL ASSERT(.FALSE.)
           END IF
        ELSE
           CALL ASSERT(.FALSE.)
        END IF


 1001 FORMAT (A,' | ',A24,' | LONMAX=',I8,' | LONUTI=',I8,
     &        ' | TYPE=',A4,' | IRET=',I7 )

 1002 FORMAT (A,' | ',A24,' | LONMAX=',I8,' | LONUTI=',I8,
     &        ' | TYPE=',A4,' | IRET=',I7, ' | SOMMI=',I24 )

 1003 FORMAT (A,' | ',A24,' | LONMAX=',I8,' | LONUTI=',I8,
     &        ' | TYPE=',A4,' | IRET=',I7,' | IGNORE=',I7,
     &        ' | SOMMR=',E17.8)

 1004 FORMAT (A,' | ',A24, ' | TYPE=',A4,' | IRET=',I7)

      END
