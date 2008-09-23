#@ MODIF compor1 Messages  DATE 22/09/2008   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
# (AT YOUR OPTION) ANY LATER VERSION.                                                  
#                                                                       
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
#                                                                       
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.        
# ======================================================================

def _(x) : return x

cata_msg={

1: _("""
 HUJPLA :: nombre de variables internes incorrect:
           NVI > NVIMAX
"""),

2: _("""
 HUJDDD :: on ne calcule pas DPSIDS pour K=4.
           - v�rifiez la programmation -
"""),

3: _("""
 CAM_CLAY :: le coefficient de poisson et ou le module d'Young ne sont pas corrects
             dans la maille %(k1)s
             
             *** v�rifiez la coh�rence des donn�es m�caniques suivantes :
                 E, nu, eO (indice des vides), kapa
                 (contrainte volumique initiale) et KCAM la compressibilit� 
                 initiale. Si PTRAC et KCAM sont nuls, il faut initialiser les contraintes 

                 il faut notamment v�rifier ceci:
               
        NU = (TROIS*((UN+E0)*SIGMMO+KAPA*KCAM)-DEUXMU*KAPA)/
     &         (SIX*((UN+E0)*SIGMMO+KAPA*KCAM)+DEUXMU*KAPA)
     
        E = DEUXMU*(UN+NU)
 ***
"""),

4: _("""
 HUJEUX :: les mod�lisations autoris�es sont 3D D_PLAN ou AXIS
"""),

5: _("""
 HUJEUX :: K diff�rent de NBMECA pour le m�canisme isotrope
           - v�rifiez la programmation -
"""),

6: _("""
 HUJEUX :: erreur inversion par pivot de Gauss
"""),

7: _("""
 HUJCRI :: EPSI_VP est trop grand:
           l'exponentielle explose
"""),

8: _("""
 HUJEUX :: m�canisme ind�termin�
           - v�rifiez la programmation -
"""),

9 : _("""
Arret suite � l'�chec de l'int�gration de la loi de comportement.
"""),

10: _("""
 HUJKSI :: mot-cl� inconnu
"""),

11: _("""
 HUJNVI :: mod�lisation inconnue
"""),

12: _("""
 HUJCI1 :: l'incr�ment de d�formation est nul:
           on ne peut pas trouver le z�ro de la fonction.
"""),

13: _("""
 HUJCI1 :: le crit�re d'existence du z�ro de la fonction est viol�:
           on recommande soit de changer les donn�es mat�riaux,
           soit de raffiner le pas de temps.
           
           Ce crit�re est :
           
           2 x P- < P0 * (P0 /K0 /TRACE(DEPS_ELA) /N)**(1-N)
"""),

14: _("""
 HUJTID :: erreur dans le calcul de la matrice tangente
"""),

16 : _("""
Arret suite � l'�chec de l'int�gration de la loi de comportement.

Erreur num�rique (overflow) : la plasticit� cumul�e devient tr�s grande.
"""),

17 : _("""
  HUJCI1 :: Soit le z�ro n'existe pas, soit il se trouve hors des
            bornes admissibles.
"""),

18 : _("""
  HUJCI1 :: Cas de traction � l'instant moins.
"""),

19 : _("""
  MONOCRISTAL :: �crouissage cinematique non trouv�.
"""),

20 : _("""
  MONOCRISTAL :: �coulement non trouv�.
"""),

21 : _("""
  MONOCRISTAL :: �crouissage isotrope non trouv�.
"""),

22 : _("""
  MONOCRISTAL :: nombre de matrice d'interaction trop grand.
"""),

23 : _("""
  MONOCRISTAL :: la matrice d'interaction est d�finie avec 
  4 coefficients. Ceci n'est applicable qu'avec 24 syst�mes de
  glissement (famille BCC24).
"""),

24 : _("""
  MONOCRISTAL :: la matrice d'interaction est d�finie avec 
  6 coefficients. Ceci n'est applicable qu'avec 12 syst�mes de
  glissement.
"""),

25 : _("""
  MONOCRISTAL :: la matrice d'interaction est d�finie avec 
  un nombre de coefficients incorrect :: il en faut 1, ou 4, ou 6.
"""),


26: _("""
 lklmat :: param�tres de la loi LETK non coh�rents 
"""),
27: _("""
 lkcomp :: R�duire le pas de temps peut dans certains cas rem�dier au probl�me.
 Le crit�re visqueux max en ce point de charge n'est 
 pas d�fini. Le calcul de la distance au crit�re n'est pas fait.
"""),
28: _("""
 lkcomp :: R�duire le pas de temps peut dans certains cas rem�dier au probl�me.
 Le crit�re visqueux en ce point de charge n'est pas d�fini. 
 Le calcul de la distance au crit�re n'est pas fait.
"""),

29: _("""
 lkdhds :: division par z�ro - entr�e rapide en plasticit� avec un d�viateur nul. 
 r�duire le pas de temps.
"""),

30: _("""
 lkds2h :: division par z�ro - entr�e rapide en plasticit� avec un d�viateur nul. 
 r�duire le pas de temps.
"""),

31: _("""
 lkcaln :: division par z�ro - entr�e rapide en plasticit� avec un d�viateur nul. 
 r�duire le pas de temps.
"""),

32: _("""
 VISC_CINx_CHAB :: pour la viscosit�, renseigner le mot-cl� LEMAITRE dans DEFI_MATERIAU. 
 Si vous voulez seulement de l'�lastoplasticit�, il faut utiliser VMIS_CINx_CHAB.
"""),

33: _("""
 NMHUJ :: ELAS/ELAS_ORTH :: erreur de lecture des propri�t�s mat�riaux.
"""),

34: _("""
 HUJTID :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

35: _("""
 HUJDP :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

36: _("""
 HUJTEL :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

37: _("""
 HUJPOT :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

38: _("""
 HUJJID :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

39: _("""
 HUJIID :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

40: _("""
 HUJELA :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),


41: _("""
 CAM_CLAY :: 
 Pour la maille <%(k1)s> une des exponentielles pose un probl�me num�rique.
 La subdivision du pas de temps au niveau global est d�clanch�e.
 Il faut pour cela l'autoriser avec le mot clef SUBD_METHODE de la commande STAT_NON_LINE.
 Info sur les bornes :
   Valeur maxi :   <%(r1)E>
   borne correspondant � <%(k2)s> : <%(r2)E>
   borne correspondant � <%(k3)s> : <%(r3)E>
"""),

42: _("""
 CAM_CLAY ::  Kcam et Ptrac doivent v�rifier la relation suivante :
 
              KCAM > -K0 * PTRAC  ou KCAM > -(1+e0)/kapa * PTRAC
"""),


43: _("""
 Le numero de loi de comportement choisi <%(i1)i> est hors des bornes 1-100
"""),


44: _("""
 Le type de d�formation choisi <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

45: _("""
 Le type de schema de resolution choisi <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

46: _("""
 Le type de matrice tangente choisi <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

47: _("""
 La modelisation choisie <%(k1)s> est incompatible avec le comportement <%(k2)s>. Pour modeliser
 des contraintes planes (ou des coques) avec ce comportement, on utilise ALGO_C_PLAN='DEBORST'
"""),

48: _("""
 La modelisation choisie <%(k1)s> est incompatible avec le comportement <%(k2)s>. Pour modeliser
 des contraintes 1D (barres, poutres) avec ce comportement, on utilise ALGO_1D='DEBORST'
"""),

49: _("""
 La modelisation choisie <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

50: _("""
 Aucun comportement n'est d�fini sur la maille <%(k1)s>. Code_Aster a d�fini par d�faut
  COMP_INCR='ELAS', DEFORMATION='PETIT'.
"""),

51: _("""
 La commande <%(k1)s> n'est pas pr�vue dans le traitement des mot-cl� COMP_INCR / COMP_ELAS.
"""),

52: _("""
 La modelisation choisie <%(k1)s> est disponible pour le comportement <%(k2)s>. Pour modeliser
 des contraintes planes (ou des coques) avec ce comportement, il est inutile d'utiliser ALGO_C_PLAN='DEBORST'
"""),

53: _("""
 La modelisation choisie <%(k1)s> est disponible pour le comportement <%(k2)s>. Pour modeliser
 des contraintes 1D (barres, poutres) avec ce comportement, il est inutile d'utiliser ALGO_1D='DEBORST'
"""),


}
