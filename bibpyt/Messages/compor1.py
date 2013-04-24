#@ MODIF compor1 Messages  DATE 23/04/2013   AUTEUR ABBAS M.ABBAS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg={

1: _(u"""
 HUJPLA :: nombre de variables internes incorrect:
           NVI > NVIMAX
"""),

2: _(u"""
 HUJDDD :: on ne calcule pas DPSIDS pour K=4.
           - v�rifiez la programmation -
"""),

3: _(u"""
 CAM_CLAY : Le coefficient de poisson et/ou le module de YOUNG ne sont pas corrects
            dans la maille %(k1)s.

             V�rifiez la coh�rence des donn�es m�caniques suivantes :
                 E, NU, eO (indice des vides), KAPA
                 (contrainte volumique initiale) et KCAM la compressibilit�
                 initiale. Si PTRAC et KCAM sont nuls, il faut initialiser les contraintes.

                 Il faut notamment v�rifier ceci:

        NU = (TROIS*((UN+E0)*SIGMMO+KAPA*KCAM)-DEUXMU*KAPA)/
     &         (SIX*((UN+E0)*SIGMMO+KAPA*KCAM)+DEUXMU*KAPA)

        E = DEUXMU*(UN+NU)
"""),

4: _(u"""
 HUJEUX :: les mod�lisations autoris�es sont 3D D_PLAN ou AXIS
"""),

5: _(u"""
 HUJEUX :: K diff�rent de NBMECA pour le m�canisme isotrope
           - v�rifiez la programmation -
"""),

6: _(u"""
 HUJEUX :: erreur inversion par pivot de Gauss
"""),

7: _(u"""
 HUJCRI :: EPSI_VP est trop grand:
           l'exponentielle explose
"""),

8: _(u"""
 HUJEUX :: m�canisme ind�termin�
           - v�rifiez la programmation -
"""),

9 : _(u"""
Arr�t suite � l'�chec de l'int�gration de la loi de comportement.
V�rifiez vos param�tres, la coh�rence des unit�s.
Essayez d'augmenter ITER_INTE_MAXI, ou de subdiviser le pas de temps
localement via ITER_INTE_PAS.
"""),

10: _(u"""
 HUJKSI :: mot-cl� inconnu
"""),

11: _(u"""
 HUJNVI :: mod�lisation inconnue
"""),

12: _(u"""
 HUJCI1 :: l'incr�ment de d�formation est nul:
           on ne peut pas trouver le z�ro de la fonction.
"""),

14: _(u"""
 HUJTID :: erreur dans le calcul de la matrice tangente
"""),

15: _(u"""
  Pour les poutres multifibres, l'utilisation de lois de comportement via
  ALGO_1D='DEBORST' n�cessite d'avoir un seul mat�riau par poutre!
 """),

16 : _(u"""
Arr�t suite � l'�chec de l'int�gration de la loi de comportement.

Erreur num�rique (overflow) : la plasticit� cumul�e devient tr�s grande.
"""),

17 : _(u"""
  HUJCI1 :: Soit le z�ro n'existe pas, soit il se trouve hors des
            bornes admissibles.
"""),

18 : _(u"""
  HUJCI1 :: Cas de traction � l'instant moins.
"""),

19 : _(u"""
  MONOCRISTAL :: �crouissage cin�matique non trouv�.
"""),

20 : _(u"""
  MONOCRISTAL :: �coulement non trouv�.
"""),

21 : _(u"""
  MONOCRISTAL :: �crouissage isotrope non trouv�.
"""),

23 : _(u"""
  MONOCRISTAL :: la matrice d'interaction est d�finie avec
  4 coefficients. Ceci n'est applicable qu'avec 24 syst�mes de
  glissement (famille BCC24).
"""),

24 : _(u"""
  MONOCRISTAL :: la matrice d'interaction est d�finie avec
  6 coefficients. Ceci n'est applicable qu'avec 12 syst�mes de
  glissement.
"""),

25 : _(u"""
  MONOCRISTAL :: la matrice d'interaction est d�finie avec
  un nombre de coefficients incorrect :: il en faut 1, ou 4, ou 6.
"""),

26: _(u"""
 LETK - lklmat :: param�tres de la loi LETK non coh�rents
"""),

27 : _(u"""
  comportement cristallin  : les coefficients mat�riau ne peuvent d�pendre de la temp�rature.
"""),

28 : _(u"""
  comportement cristallin homog�n�is� : les coefficients mat�riau ne peuvent d�pendre de la temp�rature.
"""),

29: _(u"""
 LETK - lkdhds :: division par z�ro - entr�e en plasticit� avec un d�viateur  nul.
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le d�viateur.
"""),

30: _(u"""
 LETK - lkds2h :: division par z�ro - entr�e en plasticit� avec un d�viateur nul.
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le d�viateur.
"""),

31: _(u"""
 LETK - lkcaln :: division par z�ro - entr�e en plasticit� avec un d�viateur nul.
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le d�viateur.
"""),

32: _(u"""
 VISC_CINx_CHAB :: pour la viscosit�, renseigner le mot-cl� LEMAITRE dans DEFI_MATERIAU.
 Si vous voulez seulement de l'�lastoplasticit�, il faut utiliser VMIS_CINx_CHAB.
"""),

33: _(u"""
 NMHUJ :: ELAS/ELAS_ORTH :: erreur de lecture des propri�t�s mat�riaux.
"""),

34: _(u"""
 HUJTID :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

35: _(u"""
 HUJDP :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

36: _(u"""
 HUJTEL :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

37: _(u"""
 HUJPOT :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

38: _(u"""
 HUJJID :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

39: _(u"""
 HUJIID :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),

40: _(u"""
 HUJELA :: ELAS/ELAS_ORTH :: cas non pr�vu.
"""),


41: _(u"""
 CAM_CLAY ::
 Pour la maille <%(k1)s> une des exponentielles pose un probl�me num�rique.
 La subdivision du pas de temps au niveau global est d�clench�e.
 Il faut pour cela l'autoriser avec la commande DEFI_LIST_INST.
 Information sur les bornes :
   Valeur max :   <%(r1)E>
   borne correspondant � <%(k2)s> : <%(r2)E>
   borne correspondant � <%(k3)s> : <%(r3)E>
"""),

42: _(u"""
 CAM_CLAY ::  KCAM et PTRAC doivent v�rifier la relation suivante :

              KCAM > -K0 * PTRAC  ou KCAM > -(1+e0)/KAPA * PTRAC
"""),


43: _(u"""
 Le num�ro de loi de comportement choisi <%(i1)i> est hors des bornes 1-100
"""),


44: _(u"""
 Le type de d�formation choisi <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

45: _(u"""
 Le type d'algorithme d'int�gration choisi : <%(k1)s> (sous COMP_INCR/%(k2)s) est incompatible avec le comportement <%(k3)s>.

Conseil :
Ne renseignez pas le mot-cl� COMP_INCR/%(k2)s, afin de s�lectionner l'algorithme par d�faut.
"""),

46: _(u"""
 Le type de matrice tangente choisi <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

47: _(u"""
 La mod�lisation choisie <%(k1)s> est incompatible avec le comportement <%(k2)s>. Pour mod�liser
 des contraintes planes (ou des coques) avec ce comportement, on utilise ALGO_C_PLAN='DEBORST'
"""),

48: _(u"""
 La mod�lisation choisie <%(k1)s> est incompatible avec le comportement <%(k2)s>. Pour mod�liser
 des contraintes 1D (barres, poutres) avec ce comportement, on utilise ALGO_1D='DEBORST'
"""),

49: _(u"""
 La mod�lisation choisie <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

50: _(u"""
 Aucun comportement n'est d�fini sur la maille <%(k1)s>. Code_Aster a d�fini par d�faut
  COMP_INCR='ELAS', DEFORMATION='PETIT'.
"""),

52: _(u"""
 La mod�lisation choisie <%(k1)s> sur la maille <%(k2)s> est incompatible avec les d�formations <%(k3)s>.
 Utilisez un autre type de d�formations (cf. U4.51.11 et les documents R).
"""),

54: _(u"""
 ECRO_LINE : la pente d'�crouissage H et/ou le module de YOUNG E ne sont pas compatibles :
             H doit �tre strictement inf�rieur � E. Ici H=<%(r1)E>, et E=<%(r2)E>.
             Pour mod�liser l'�lasticit� lin�aire, il suffit de choisir SY grand, et H < E.
"""),

55: _(u"""
La <%(k1)s> dichotomie pour la loi IRRAD3M n'a pas trouv� de solution pour
le nombre d'it�ration donn� <%(i1)d>.\n
Information pour le d�bogage
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

56: _(u"""
L'irradiation diminue au cours du temps. C'EST PHYSIQUEMENT IMPOSSIBLE.
Grandeurs au point de Gauss :
   Irradiation a t- : <%(r1).15E>
   Irradiation a t+ : <%(r2).15E>
"""),

57: _(u"""
Pour information
   Temp�rature a t- : <%(r1)E>
   Temp�rature a t+ : <%(r2)E>
"""),

58: _(u"""
Le franchissement du seuil de fluage ne se fait pas dans la tol�rance donn�e dans DEFI_MATERIAU
pour la loi IRRAD3M, par le mot clef TOLER_ET.
   Tol�rance sur le franchissement du seuil : <%(r1)E>
   Erreur sur le franchissement du seuil    : <%(r2)E>
La subdivision du pas de temps est d�clench�e.
Il faut pour cela l'autoriser avec le mot clef SUBD_METHODE de la commande STAT_NON_LINE.
"""),

59: _(u"""
 Attention: pas de couplage avec le coefficient de couplage CHI = 0, on retrouve la loi UMLV
"""),

60: _(u"""
Couplage: on ne fait pas d�pendre E, MU et ALPHA de la temp�rature T, on prend T=0 comme pour ENDO_ISOT_BETON
"""),

61: _(u"""
Couplage: on fait d�pendre E, MU et ALPHA de la temp�rature maximale Tmax, comme pour MAZARS
"""),

63 : _(u"""
   ATTENTION SR > 1    SR = %(r1)f
   SECHM %(r2)f    SECHP %(r3)f    W0 %(r4)f
"""),

64 : _(u"""
   ATTENTION SR < 0    SR = %(r1)f
   SECHM %(r2)f    SECHP %(r3)f    W0 %(r4)f
"""),

65 : _(u"""
   Attention dans la routine majpad la pression d'air dissous devient
   n�gative � la maille %(k1)s.
"""),

66 : _(u"""
La loi de comportement ENDO_SCALAIRE n'est disponible que pour la formulation
non locale GRAD_VARI, assurez vous que votre mod�lisation soit l'une des trois
suivantes : - D_PLAN_GRAD_VARI
            - AXIS_GRAD_VARI
            - 3D_GRAD_VARI
"""),
67 : _(u"""
Dans la d�finition du mat�riau RUPT_DUCT les coefficients de forme de la loi CZM_TRA_MIX doivent v�rifier : COEF_EXTR <= COEF_PLAS
"""),

69 : _(u"""
Le type de d�formations %(k1)s n'est pas compatible avec les mod�lisations SHB. Utilisez PETIT ou GROT_GDEP.
"""),

70 : _(u"""
Probl�me lors du traitement de l'occurrence num�ro %(i1)d du mot-cl� facteur %(k2)s :
  La donn�e du mot-cl� %(k1)s n'est pas coh�rente avec le reste des donn�es (MODELISATION, RELATION).
  Le mot-cl� %(k1)s sera ignor�.
"""),

71 : _(u"""
Erreur dans le calcul du tenseur �quivalent au sens de HILL.
"""),

72: _(u"""
 Le nombre de variables internes initiales est incorrect : %(i1)d ; il devrait valoir %(i2)d
"""),

73: _(u"""
Lors d'un calcul avec des poutres multifibres, il est n�cessaire de renseigner le mot-cl� 
AFFE_COMPOR dans AFFE_MATERIAU.
"""),

75 : _(u""" == Param�tres de la loi %(k1)s ==
 Partie �lasticit� :
   %(k2)s
 Partie non-lin�aire :
   %(k3)s
 Pour information :
   %(k4)s
 =================================================="""),

76 : _(u"""
Pour le comportement %(k1)s les param�tres %(k2)s et %(k3)s sont obligatoires.
"""),

77 : _(u"""
Le calcul de ENEL_ELGA  n'est pas possible avec DEFORMATION= %(k1)s.
"""),

78 : _(u"""
Le calcul de ENER_TOTALE  n'est pas possible avec DEFORMATION= %(k1)s.
"""),

79 : _(u"""
Le calcul de ETOT_ELGA  n'est pas possible avec DEFORMATION= %(k1)s.
"""),

80 : _(u"""
DELTA1 = %(r1)f doit toujours rester entre 0 et 1. 
"""),

81 : _(u"""
DELTA2 = %(r1)f doit toujours rester entre 0 et 1.
"""),

82 : _(u"""
La temp�rature est obligatoire pour le comportement cristallin %(k1)s.
"""),
}
