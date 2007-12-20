#@ MODIF algorith13 Messages  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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





8 : _("""
 arret sur maillage non squelette
"""),

10 : _("""
 probl�me de duplication de matrice :  %(k1)s 
"""),

11 : _("""
  arret probl�me de factorisation
  pr�sence de modes de corps rigide
"""),

13 : _("""
 ICMP dans le d�sordre
 noeud        =  %(i1)d
 sous-domaine =  %(i2)d 
"""),

14 : _("""
 syst�me (GI)T*GI probablement non inversible:
 %(i1)d pb LAPACK DGETRF:  %(i2)d 
"""),

15 : _("""
 syst�me (GI)T*GI probablement non inversible:
 %(i1)d pb LAPACK DGETRS:  %(i2)d 
"""),

17 : _("""
 arret sur probl�me base modale sans INTERF_DYNA
 base modale -->  %(k1)s 
"""),

18 : _("""
  GAMDEV(ALPHA) < 0
  GAMDEV(ALPHA) =  %(r1)f 
"""),

26 : _("""
 conflit de nom de groupe de maille dans le squelette
 le nom de groupe               :  %(k1)s 
 provenant de la sous-structure :  %(k2)s 
 et du groupe de maille         :  %(k3)s 
 existe d�j�.
 %(k4)s 
"""),

27 : _("""
 nom de groupe non trouv�
 le groupe :  %(k1)s n'existe pas  %(k2)s dans la sous-structure :  %(k3)s 
"""),

28 : _("""
 aucun axe d�fini
"""),

29 : _("""
 m�thode non support�e en  sous-structuration
 m�thode demand�e   :  %(k1)s 
 m�thodes support�es:  %(k2)s 
"""),

30 : _("""
 conditions initiales non support�es en sous-structuration transitoire
"""),

31 : _("""
 calcul non lin�aire non support� en sous-structuration transitoire
"""),

32 : _("""
 RELA_EFFO_DEP non support� en sous-structuration transitoire
"""),

33 : _("""
 RELA_EFFO_VITE non support� en sous-structuration transitoire
"""),

34 : _("""
 la liste des amortissements modaux est d�finie au niveau de l'operateur MACR_ELEM_DYNA
"""),

35 : _("""
 num�ro de mode de votre liste inexistant dans les modes utilis�s:
 num�ro ds votre liste : %(i1)d 
"""),

36 : _("""
 appel erron�
"""),

39 : _("""
 choc mal defini
 la maille d�finissant le choc  %(k1)s doit etre de type  %(k2)s 
"""),

41 : _("""
 trop de noeuds dans le GROUP_NO  %(k1)s
 noeud utilis�:  %(k2)s 
"""),

44 : _("""
 incompatibilit� avec multi APPUI : %(k1)s 
"""),

46 : _("""
 il manque les modes statiques
"""),

47 : _("""
 il manque les modes corrig�s
"""),

48 : _("""
 Nombre de modes propres calcules insuffisant.
 Nombre de modes propres de la base limite � : %(i1)d 
"""),

49 : _("""
 sous-structure inexistante dans le mod�le g�n�ralis�
 mod�le g�n�ralis�       -->  %(k1)s 
 sous-structure demand�e -->  %(k2)s 
"""),

50 : _("""
 sous-structure inexistante dans le mod�le-g�n�ralis�
 mod�le g�n�ralis�              -->  %(k1)s 
 num�ro sous-structure demand�e -->  %(i1)d 
"""),

53 : _("""
  champ inexistant
  mesure    %(k1)s
  nom_cham  %(k2)s 
"""),

56 : _("""
 probl�me interpolation volumique 3d:
 evol_char  : %(k1)s
 instant    : %(r1)f 
 code_retour: %(i1)d 
"""),

57 : _("""
 probl�me interpolation volumique 2d:
 evol_char  : %(k1)s
 instant    : %(r1)f 
 code_retour: %(i1)d 
"""),

58 : _("""
 probl�me charge vol2d puis surf3d:
 evol_char: %(k1)s
 instant  : %(r1)f 
"""),

59 : _("""
 probl�me interpolation surfacique 3d:
 evol_char  : %(k1)s
 instant    : %(r1)f 
 code_retour: %(i1)d 
"""),

60 : _("""
 probl�me charge vol3d puis surf2d:
 evol_char: %(k1)s
 instant  : %(r1)f 
"""),

61 : _("""
 probl�me interpolation surfacique 2d:
 evol_char  : %(k1)s
 instant    : %(r1)f 
 code_retour: %(i1)d 
"""),

62 : _("""
 probl�me interpolation pression:
 evol_char  : %(k1)s
 instant    : %(r1)f 
 on ne sait pas extrapoler le champ  %(k2)s 
 de pression par rapport au temps %(k3)s 
 mais seulement l'interpoler %(k4)s 
"""),

63 : _("""
 probl�me interpolation pression:
 evol_char  : %(k1)s
 instant    : %(r1)f 
 code_retour: %(i1)d 
 contacter le support %(k2)s 
"""),

64 : _("""
 interpolation temp�rature:
 evol_ther: %(k1)s
 instant  : %(r1)f
 icoret   : %(i1)d 
"""),

68 : _("""
 probl�me interpolation vitesse:
 evol_char  : %(k1)s
 instant    : %(r1)f 
 code_retour: %(i1)d 
"""),

69 : _("""
 le noeud: %(k1)s  ne peut pas etre TYPL et TYPB
"""),

70 : _("""
 impossible de coder le nombre :  %(i1)d  sur :  %(k1)s 
"""),

71 : _("""
 choix impossible pour INITPR :  %(i1)d 
"""),

74 : _("""
 composante non d�finie  dans la num�rotation :  %(k1)s 
"""),

75 : _("""
 d�tection d'une sous-structure non connect�e
 sous-structure de nom: %(k1)s 
"""),

76 : _("""
 arret sur probl�me de connexion sous-structure
"""),

78 : _("""
 les intervalles doivent etre croissants
 valeur de la borne precedente :  %(i1)d 
 valeur de la borne            :  %(i2)d 
"""),

79 : _("""
 l'intervalle entre les  deux derniers instants ne sera pas �gal au pas courant :  %(i1)d 
 pour l'intervalle  %(i2)d 
"""),

80 : _("""
 le nombre de pas est trop grand :  %(i1)d , pour l'intervalle  %(i2)d 
"""),

81 : _("""
 les valeurs doivent etre croissantes
 valeur pr�c�dente :  %(i1)d 
 valeur            :  %(i2)d 
"""),

82 : _("""
 la distance entre les deux derniers r�els ne sera pas �gale
 au pas courant :  %(r1)f,
 pour l'intervalle  %(i1)d 
"""),

84 : _("""
 mod�le amont non d�fini
"""),

85 : _("""
 champ inexistant
 r�sultat   : %(k1)s 
 nom_cham   : %(k2)s 
 nume_ordre : %(i1)d 
"""),

86 : _("""
 type de matrice inconnue
 type: %(k1)s 
"""),

91 : _("""
 probl�me de dimension de la matrice � mutiplier
"""),

92 : _("""
 probl�me de dimension de la matrice r�sultat
"""),

99 : _("""
 matrice d'amortissement non cr��e dans le macro-�l�ment :  %(k1)s 
"""),

}
