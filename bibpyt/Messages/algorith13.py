# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

8 : _(u"""
 arr�t sur maillage non squelette
"""),

10 : _(u"""
 probl�me de duplication de la matrice :  %(k1)s
"""),

11 : _(u"""
  arr�t probl�me de factorisation
  pr�sence de modes de corps rigide
"""),

17 : _(u"""
 arr�t sur probl�me base modale sans INTERF_DYNA
 base modale -->  %(k1)s
"""),

18 : _(u"""
  GAMDEV(ALPHA) < 0
  GAMDEV(ALPHA) =  %(r1)f
"""),

26 : _(u"""
 conflit de nom de groupe de maille dans le squelette
 le nom de groupe               :  %(k1)s
 provenant de la sous-structure :  %(k2)s
 et du groupe de maille         :  %(k3)s
 existe d�j�.
 %(k4)s
"""),

27 : _(u"""
 nom de groupe non trouv�
 le groupe :  %(k1)s n'existe pas  %(k2)s dans la sous-structure :  %(k3)s
"""),

28 : _(u"""
 aucun axe de rotation d�fini
"""),

29 : _(u"""
 m�thode non support�e en  sous-structuration
 m�thode demand�e   :  %(k1)s
 m�thodes support�es:  %(k2)s
"""),

30 : _(u"""
 conditions initiales non support�es en sous-structuration transitoire
"""),

31 : _(u"""
 calcul non lin�aire non support� en sous-structuration transitoire
"""),

32 : _(u"""
 RELA_EFFO_DEP non support� en sous-structuration transitoire
"""),

33 : _(u"""
 RELA_EFFO_VITE non support� en sous-structuration transitoire
"""),

34 : _(u"""
 la liste des amortissements modaux est d�finie au niveau de l'op�rateur MACR_ELEM_DYNA
"""),

35 : _(u"""
 num�ro de mode de votre liste inexistant dans les modes utilis�s:
 num�ro dans votre liste : %(i1)d
"""),

39 : _(u"""
 choc mal d�fini
 la maille d�finissant le choc  %(k1)s doit �tre de type  %(k2)s
"""),

41 : _(u"""
 trop de noeuds dans le GROUP_NO  %(k1)s
 noeud utilis�:  %(k2)s
"""),

44 : _(u"""
 incompatibilit� avec MULTI APPUI : %(k1)s
"""),

46 : _(u"""
 Il manque les modes statiques. V�rifiez que MODE_STAT est bien renseign�.
"""),

47 : _(u"""
 Il manque les modes corrig�s. V�rifiez que MODE_CORR est bien renseign�.
"""),

48 : _(u"""
 Nombre de modes propres calcules insuffisant.
 Nombre de modes propres de la base limite � : %(i1)d
"""),

49 : _(u"""
 sous-structure inexistante dans le mod�le g�n�ralis�
 mod�le g�n�ralis�       -->  %(k1)s
 sous-structure demand�e -->  %(k2)s
"""),

50 : _(u"""
 sous-structure inexistante dans le mod�le g�n�ralis�
 mod�le g�n�ralis�              -->  %(k1)s
 num�ro sous-structure demand�e -->  %(i1)d
"""),







56 : _(u"""
 probl�me interpolation volumique 3d:
 EVOL_CHAR  : %(k1)s
 instant    : %(r1)f
 code_retour: %(i1)d
"""),

57 : _(u"""
 probl�me interpolation volumique 2d:
 EVOL_CHAR  : %(k1)s
 instant    : %(r1)f
 code_retour: %(i1)d
"""),

58 : _(u"""
 probl�me charge vol2d puis surf3d:
 EVOL_CHAR: %(k1)s
 instant  : %(r1)f
"""),

59 : _(u"""
 probl�me interpolation surfacique 3d:
 EVOL_CHAR  : %(k1)s
 instant    : %(r1)f
 code_retour: %(i1)d
"""),

60 : _(u"""
 probl�me charge vol3d puis surf2d:
 EVOL_CHAR: %(k1)s
 instant  : %(r1)f
"""),

61 : _(u"""
 probl�me interpolation surfacique 2d:
 EVOL_CHAR  : %(k1)s
 instant    : %(r1)f
 code retour: %(i1)d
"""),

62 : _(u"""
 probl�me interpolation pression:
 EVOL_CHAR  : %(k1)s
 instant    : %(r1)f
 on ne sait pas extrapoler le champ  %(k2)s
 de pression par rapport au temps %(k3)s
 mais seulement l'interpoler %(k4)s
"""),

63 : _(u"""
 probl�me interpolation pression:
 EVOL_CHAR  : %(k1)s
 instant    : %(r1)f
 code_retour: %(i1)d
 contacter le support %(k2)s
"""),

68 : _(u"""
 probl�me interpolation vitesse:
 EVOL_CHAR  : %(k1)s
 instant    : %(r1)f
 code_retour: %(i1)d
"""),

69 : _(u"""
 le noeud: %(k1)s  ne peut pas �tre TYPL et TYPB
"""),



75 : _(u"""
 d�tection d'une sous-structure non connect�e
 sous-structure de nom: %(k1)s
"""),

76 : _(u"""
 arr�t sur probl�me de connexion sous-structure
"""),

78 : _(u"""
 les intervalles doivent �tre croissants
 valeur de la borne pr�c�dente :  %(i1)d
 valeur de la borne            :  %(i2)d
"""),

79 : _(u"""
 l'intervalle entre les  deux derniers instants ne sera pas �gal au pas courant :  %(i1)d
 pour l'intervalle  %(i2)d
"""),

80 : _(u"""
 le nombre de pas est trop grand :  %(i1)d , pour l'intervalle  %(i2)d
"""),

81 : _(u"""
 les valeurs doivent �tre croissantes
 valeur pr�c�dente :  %(i1)d
 valeur            :  %(i2)d
"""),

82 : _(u"""
 la distance entre les deux derniers r�els ne sera pas �gale
 au pas courant :  %(r1)f,
 pour l'intervalle  %(i1)d
"""),








91 : _(u"""
 probl�me de dimension de la matrice � multiplier
"""),

92 : _(u"""
 probl�me de dimension de la matrice r�sultat
"""),

99 : _(u"""
 matrice d'amortissement non cr��e dans le macro-�l�ment :  %(k1)s
"""),

}
