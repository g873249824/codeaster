#@ MODIF compor1 Messages  DATE 23/03/2010   AUTEUR ANGELINI O.ANGELINI 
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
Verifiez vos param�tres, la coh�rence des unit�s.
Essayez d'augmenter ITER_INTE_MAXI, ou de subdiviser le pas de temps 
localement via ITER_INTE_PAS.
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
 LETK - lklmat :: param�tres de la loi LETK non coh�rents 
"""),
27: _("""
 LETK - lkcomp :: R�duire le pas de temps peut dans certains cas rem�dier au probl�me.
 Le crit�re visqueux max en ce point de charge n'est 
 pas d�fini. Le calcul de la distance au crit�re n'est pas fait.
"""),
28: _("""
 LETK - lkcomp :: R�duire le pas de temps peut dans certains cas rem�dier au probl�me.
 Le crit�re visqueux en ce point de charge n'est pas d�fini. 
 Le calcul de la distance au crit�re n'est pas fait.
"""),

29: _("""
 LETK - lkdhds :: division par z�ro - entr�e en plasticit� avec un d�viateur  nul. 
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le d�viateur.
"""),

30: _("""
 LETK - lkds2h :: division par z�ro - entr�e en plasticit� avec un d�viateur nul. 
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le d�viateur.
"""),

31: _("""
 LETK - lkcaln :: division par z�ro - entr�e en plasticit� avec un d�viateur nul. 
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le d�viateur.
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

54: _("""
 ECRO_LINE : la pente d'�crouissage H et/ou le module d'Young E ne sont pas compatibles :
             H doit �tre strictement inf�rieur � E. Ici H=<%(r1)E>, et E=<%(r2)E>.
             Pour mod�liser de l'elasticit� lin�aire, il suffit de choisir SY grand, et H < E.
"""),

55: _("""
La <%(k1)s> dichotomie pour la loi IRRAD3M n'a pas trouv�e de solution pour
le nombre d'it�ration donn� <%(i1)d>.\n
Info pour le debug
   Borne 0                 : <%(r1).15E>
   Borne 1                 : <%(r2).15E>
   Puissance N             : <%(r3).15E>
   Pas pour la recherche   : <%(r4).15E>
   RM                      : <%(r5).15E>
   EU                      : <%(r6).15E>
   R02                     : <%(r7).15E>
   Pr�cision demand�e      : <%(r8).15E>
Valeurs initiales
   N0                      : <%(r9).15E>
   Borne 0                 : <%(r10).15E>
   Borne 1                 : <%(r11).15E>
   Borne E                 : <%(r12).15E>
"""),

56: _("""
L'irradiation diminue au cours du temps. C'EST PHYSIQUEMENT IMPOSSIBLE.
Grandeurs au point de Gauss :
   Irradiation a t- : <%(r1).15E>
   Irradiation a t+ : <%(r2).15E>
"""),

57: _("""
Pour info
   Temp�rature a t- : <%(r1)E>
   Temp�rature a t+ : <%(r2)E>
"""),

58: _("""
Le franchissement du seuil de fluage ne se fait pas dans la tol�rence donn�e dans DEFI_MATERIAU
pour la loi IRRAD3M, par le mot clef TOLER_ET.
   Tol�rence sur le franchissement du seuil : <%(r1)E>
   Erreur sur le franchissement du seuil    : <%(r2)E>
La subdivision du pas de temps au niveau global est d�clanch�e.
Il faut pour cela l'autoriser avec le mot clef SUBD_METHODE de la commande STAT_NON_LINE.
"""),

59: _("""
 Attention: pas de couplage avec le coefficient de couplage CHI = 0, on retrouve la loi UMLV
"""),

60: _("""
Couplage: on ne fait pas dependre E, MU et ALPHA de la temperature T, on prend T=0 comme pour ENDO_ISOT_BETON
"""),

61: _("""
Couplage: on fait dependre E, MU et ALPHA de la temperature maximale Tmax, comme pour MAZARS
"""),

62: _("""
L'orthotropie pour le comportement LMARC n'est disponible que pour la mod�lisation AXIS.
(cf. R5.03.10). Or la modelisation choisie est <%(k1)s> .\n
Les coefficients de la matrice d'anisotropie sont :
   M(1,1)  : <%(r1).15E>
   M(2,2)  : <%(r2).15E>
   M(3,3)  : <%(r3).15E>
   M(6,6)  : <%(r4).15E>
L'orthotropie est � utiliser seulement en axi, si et seulement si les 
coefficients sont donn�s dans l'ordre (R,Z,T) et non (R,T,Z).
"""),

63 : _("""
   ATTENTION SR > 1    SR = %(r1)f
   SECHM %(r2)f    SECHP %(r3)f    W0 %(r4)f
"""),

64 : _("""
   ATTENTION SR < 0    SR = %(r1)f
   SECHM %(r2)f    SECHP %(r3)f    W0 %(r4)f
"""),

65 : _("""
   Attention dans la routine majpad la pression d'air dissous devient 
   negative a la maille %(k1)f
"""),
}
