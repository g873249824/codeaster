#@ MODIF elements2 Messages  DATE 08/02/2008   AUTEUR MACOCCO K.MACOCCO 
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

cata_msg = {

2 : _("""
 le mot cle normale doit comporter 3 composantes
"""),

3 : _("""
 le degre du polynome doit etre au plus egal a 7 
"""),

4 : _("""
 probleme dans rinf et rsup 
"""),

5 : _("""
 le mot cle DTAN_ORIG doit comporter 3 composantes
"""),

6 : _("""
 le mot cle DTAN_EXTR doit comporter 3 composantes
"""),

7 : _("""
 le mot cle VECT_GRNO_ORIG doit comporter 2 groupes de points
"""),

8 : _("""
 le mot cle VECT_GRNO_EXTR doit comporter 2 groupes de points
"""),

9 : _("""
 melang1 seg2 et seg3 : les mailles du fond de fissure doivent etre du meme type
"""),

10 : _("""
 le groupe de noeuds  %(k1)s  definissant la fissure n'est pas ordonne
"""),

11 : _("""
 arret sur erreur utilisateur: deux GROUP_NO consecutifs incoherents
"""),

12 : _("""
 les mailles du fond de fissure doivent etre du type segment
"""),

13 : _("""
 m�lange seg2 et seg3 : les mailles du fond de fissure doivent �tre du m�me type
"""),

14 : _("""
 arr�t sur erreur utilisateur: deux mailles du fond de fissure sont non cons�cutives dans la num�rotation des noeuds 
"""),

15 : _("""
 arr�t sur erreur utilisateur: 2 GROUP_MA du fond de fissure sont non cons�cutifs dans la num�rotation des noeuds
"""),

16 : _("""
 les mailles des l�vres doivent �tre du type quadrangle ou triangle
"""),

17 : _("""
 melang3 seg2 et seg3 : les mailles du fond de fissure doivent etre du meme type
"""),

18 : _("""
 la liste de noeuds definissant la fissure n'est pas ordonnee
"""),

19 : _("""
 melang4 seg2 et seg3 : les mailles du fond de fissure doivent etre du meme type
"""),

21 : _("""
 erreur : le fond de fissure possede un noeud repete 2 fois : noeud  %(k1)s . revoir les donnees
"""),

22 : _("""
 les mailles du fond_inf et du fond_sup sont de type different
"""),

24 : _("""
 le noeud  %(k1)s  n'appartient pas au fond de fissure 
"""),

25 : _("""
 le fond de fissure n'est pas complet
"""),

26 : _("""
 pb prgm
"""),

27 : _("""
 pas d'intersection trouv�
"""),

28 : _("""
 indc = 1 (complet : translation et rotation) ou indc = 0 (incomplet : translation seulement  )                    obligatoirement.
"""),

29 : _("""
 element faisceau homogeneise non prevu
"""),

31 : _("""
  elrefe non prevu
"""),

32 : _("""
 comportement non trouve: %(k1)s 
"""),

33 : _("""
 pas de dilatation thermique orthotrope pour coque_3d
"""),

34 : _("""
 les vecteurs sont au nombre de 1 ou 2
"""),

36 : _("""
 le type d'element :  %(k1)s n'est pas traite.
"""),

37 : _("""
 pas de zero, convergence impossible
"""),

38 : _("""
  ->  L'option ANGL_AXE n'est pas prise en compte en 2D mais seulement
      en 3D.
  -> Risque & Conseil :
     Ce mot cl� utilis� dans l'op�rateur AFFE_CARA_ELEM (MASSIF), permet
     de d�finir des axes locaux pour lesquels on utilise une propri�t� de
     sym�trie de r�volution, ou d'isotropie transverse. En 2D, on peut d�finir
     un rep�re d'orthotropie via ANGL_REP.
"""),

39 : _("""
 loi lema_seuil non implemente avec les poutres multi fibres
"""),

40 : _("""
 on ne sait pas integrer avec  %(k1)s  caracteristiques par fibre
"""),

41 : _("""
 cas avec inerties des fibres non programme
"""),

42 : _("""
 " %(k1)s "    nom d'element inconnu.
"""),

43 : _("""
 noeuds confondus pour la maille:  %(k1)s 
"""),

44 : _("""
  option de matrice de masse  %(k1)s  inconnue
"""),

45 : _("""
 on n'a pas trouv� de variable interne correspondante a la d�formation plastique �quivalente cumul�e 
"""),

46 : _("""
 on ne traite pas les moments
"""),

47 : _("""
 l'option " %(k1)s " est inconnue
"""),

48 : _("""
 type de poutre inconnu
"""),

49 : _("""
 charge r�partie variable non admise sur un �l�ment courbe.
"""),

50 : _("""
 charge r�partie variable non admise sur un �l�ment variable.
"""),

51 : _("""
 on ne peut pas imposer de charges r�parties suiveuses de type vitesse de vent sur les poutres courbes.
"""),

52 : _("""
 on ne peut pas imposer de charges r�parties suiveuses sur les poutres courbes.
"""),

53 : _("""
 un champ de vitesse de vent est impos� sans donner un cx d�pendant de la vitesse sur une des poutres.
"""),

54 : _("""
 le module de cisaillement G est nul mais pas le module d'Young E
"""),

55 : _("""
 section circulaire uniquement
"""),

56 : _("""
 pour l'instant on ne fait pas le calcul de la  matrice de masse d'un element de plaque q4g excentre.
"""),

57 : _("""
 pour l'instant on ne peut pas excentrer les elements q4g .
"""),

58 : _("""
 echec de convergence dans l'inversion du systeme par newton-raphson.
"""),

59 : _("""
 pb
"""),

60 : _("""
 mauvaise orientation de l element !
"""),

61 : _("""
 " %(k1)s "   nom d'option non reconnue
"""),

62 : _("""
 ! pb rcvala rhocp !
"""),

63 : _("""
 ! comportement non trouve !
"""),

64 : _("""
 ! pb rccoma rhocp !
"""),

65 : _("""
 ! deltat: div par zero !
"""),

66 : _("""
 la matrice gyroscopique n'est pas disponible pour l'�l�ment %(k1)s
"""),

67 : _("""
 option non traitee
"""),

68 : _("""
 une d�formation initiale est pr�sente dans la charge : incompatible avec la contrainte initiale SIGMA_INIT
"""),

69 : _("""
 relation de comportement non traite
"""),

70 : _("""
 option non valide
"""),

71 : _("""
 comp_elas non programme pour les modelisations dkt. il faut utiliser comp_incr.
"""),

72 : _("""
  -> La r�actualisation de la g�om�trie (DEFORMATION='PETIT_REAC' sous
     le mot cl� COMP_INCR) est d�conseill�e pour les �l�ments de type plaque. Les
     grandes rotations ne sont pas mod�lis�es correctement.
  -> Risque & Conseil :
     En pr�sence de grands d�placements et grandes rotations, il est pr�f�rable
     d'utiliser la mod�lisation COQUE_3D, avec DEFORMATION='GREEN_GR'
"""),

73 : _("""
 comportement non traite:  %(k1)s 
"""),

74 : _("""
  %(k1)s  non implante.
"""),

75 : _("""
 option "SIEF_ELNO_ELGA" non implant�e pour la d�formation "GREEN_GR"
"""),

76 : _("""
 la nature du materiau  %(k1)s  n'est pas traitee.
"""),

77 : _("""
 option :  %(k1)s  interdite
"""),

80 : _("""
 �l�ments de poutre noeuds confondus pour un �l�ment:  %(k1)s 
"""),

81 : _("""
 �l�ments de poutre section variable affine :seul une section rectangle plein est disponible.
"""),

82 : _("""
 �l�ments de poutre section variable homoth�tique : l'aire initiale est nulle.
"""),

83 : _("""
 poutre section variable/constante  passage par section homothetique avec a1 = a2 
"""),

84 : _("""
 elements de poutre l'option " %(k1)s " est inconnue
"""),

85 : _("""
 non prevu pour les sections rectangulaires
"""),

86 : _("""
 non prevu pour les sections generales
"""),

87 : _("""
 " %(k1)s "    : option non traitee
"""),

88 : _("""
 element discret " %(k1)s " inconnu.
"""),

89 : _("""
 element discret (te0044): l'option " %(k1)s " est inconnue pour le type " %(k2)s "
"""),

90 : _("""
 COMP_ELAS non valide
"""),

91 : _("""
 " %(k1)s " matrice de decharge non developpee
"""),

92 : _("""
 la loi DIS_GRICRA doit etre utilis�e avec des �l�ments du type MECA_DIS_TR_L : �l�ment SEG2 + modelisation DIS_TR
"""),

93 : _("""
 longueurs diff. pour rigi et amor
"""),

94 : _("""
 longueurs diff. pour mass et amor
"""),

95 : _("""
 option de calcul invalide
"""),

96 : _("""
 erreur calcul de texnp1
"""),

97 : _("""
 erreur calcul de texn
"""),

98 : _("""
 erreur calcul de echnp1
"""),

99 : _("""
 erreur calcul de echn
"""),

}
