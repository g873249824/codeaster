#@ MODIF modelisa7 Messages  DATE 30/04/2013   AUTEUR CHEIGNON E.CHEIGNON 
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
 pas fr�quentiel n�gatif ou nul
"""),

2: _(u"""
  la m�thode est de CORCOS. on a  besoin des vecteurs directeurs VECT_X et VECT_Y de la plaque
"""),

3: _(u"""
  la m�thode est de AU-YANG
  on a besoin du  vecteur de l'axe VECT_X et de l'origine ORIG_AXE du cylindre
"""),

4: _(u"""
 le type de spectre est incompatible avec la configuration �tudi�e
"""),

5: _(u"""
 probl�me rencontr� lors de l'interpolation d'un interspectre
"""),

6: _(u"""
 nombre de noeuds insuffisant sur le maillage
"""),

7: _(u"""
 l'int�grale double pour le calcul de la longueur de corr�lation ne converge pas.
 JM,IM  = %(i1)d , %(i2)d
 valeur finale = %(r1)f
 valeur au pas pr�c�dent = %(r2)f
 erreur relative = %(r3)f
"""),

8: _(u"""
 la liste de noms doit �tre de m�me longueur que la liste de GROUP_MA
"""),

9: _(u"""
 le GROUP_NO :  %(k1)s  existe d�j�, on ne le cr�e donc pas.
"""),

10: _(u"""
 le nom  %(k1)s  existe d�j�
"""),

11: _(u"""
 le groupe  %(k1)s  existe d�j�
"""),

12: _(u"""
 Vous avez demand� l'affectation d'un mod�le sur un %(k1)s,
 or le maillage %(k2)s n'en contient aucun.
 L'affectation du mod�le n'est donc pas possible.
"""),

13: _(u"""
 L'interpolation par spline cubique du c�ble num�ro %(i1)d renseign� dans
 DEFI_CABLE_BP a �chou�.
 Le nombre de changements de signe de la d�riv�e seconde en X,Y ou Z de
 la trajectoire du c�ble par rapport � l'abscisse curviligne est : %(i2)d.
 Alors que le nombre de variations de la d�riv�e premi�re est : %(i3)d.

 Ceci est certainement d� � des irr�gularit�s dans le maillage.

 L'interpolation est donc faite par une m�thode discr�te.
"""),

15: _(u"""
 FAISCEAU_AXIAL : il y a plus de types de grilles que de grilles
"""),

16: _(u"""
 FAISCEAU_AXIAL : il faut autant d'arguments pour les op�randes <TYPE_GRILLE> et <COOR_GRILLE>
"""),

17: _(u"""
 FAISCEAU_AXIAL, op�rande <TYPE_GRILLE> : d�tection d'une valeur illicite
"""),

18: _(u"""
 FAISCEAU_AXIAL : il faut autant d'arguments pour les op�randes <LONG_TYPG>, <LARG_TYPG>, <EPAI_TYPG>, <RUGO_TYPG>, <COEF_TRAI_TYPG> et <COEF_DPOR_TYPG>
"""),

19: _(u"""
 <FAISCEAU_TRANS> le mot cl� <COUPLAGE> doit �tre renseign� au moins une fois sous l'une des occurrence du mot-cl� facteur <FAISCEAU_TRANS>
"""),

20: _(u"""
 <FAISCEAU_TRANS> : si couplage <TYPE_PAS> , <TYPE_RESEAU> et <PAS> mots-cl�s obligatoires dans au moins l une des occurrences du mot-cl� facteur
"""),

21: _(u"""
 FAISCEAU_TRANS : si pas de couplage <COEF_MASS_AJOU> mot-cl� obligatoire dans au moins l une des occurrences du mot cl� facteur <FAISCEAU_TRANS>
"""),

22: _(u"""
 <FAISCEAU_TRANS> : le mot-cl� <CARA_ELEM> doit �tre renseigne au moins une fois dans l une des occurrences du mot-cl� facteur <FAISCEAU_TRANS>
"""),

23: _(u"""
 <FAISCEAU_TRANS> : le mot-cl� <PROF_RHO_F_INT> doit �tre renseigne au moins une fois dans l une des occurrences du mot-cl� facteur <FAISCEAU_TRANS>
"""),

24: _(u"""
 <FAISCEAU_TRANS> : le mot-cl� <PROF_RHO_F_EXT> doit �tre renseigne au moins une fois dans l une des occurrences du mot-cl� facteur <FAISCEAU_TRANS>
"""),

25: _(u"""
 <FAISCEAU_TRANS> : le mot-cl� <NOM_CMP> doit �tre renseigne au moins une fois dans l une des occurrences du mot-cl� facteur <FAISCEAU_TRANS>
"""),

26: _(u"""
 grappe : si prise en compte du couplage, les mots-cl�s <grappe_2>, <noeud>, <CARA_ELEM>, <MODELE> et <RHO_FLUI> doivent �tre renseignes
"""),

27: _(u"""
 FAISCEAU_AXIAL : plusieurs occurrences pour le mot-cl� facteur => faisceau �quivalent => mots-cl�s <RAYON_TUBE> et <COOR_TUBE> obligatoires a chaque occurrence
"""),

28: _(u"""
 FAISCEAU_AXIAL : on attend un nombre pair d arguments pour le mot-cl� <COOR_TUBE>. il faut fournir deux coordonn�es pour d�finir la position de chacun des tubes du faisceau r�el
"""),

29: _(u"""
 FAISCEAU_AXIAL : il faut trois composantes pour <VECT_X>
"""),

30: _(u"""
 FAISCEAU_AXIAL : le vecteur directeur du faisceau doit �tre l un des vecteurs unitaires de la base li�e au rep�re global
"""),

31: _(u"""
 FAISCEAU_AXIAL : il faut 4 donn�es pour le mot-cl� <pesanteur> : la norme du vecteur et ses composantes dans le rep�re global, dans cet ordre
"""),

32: _(u"""
 FAISCEAU_AXIAL : il faut 3 ou 4 donn�es pour le mot-cl� <CARA_PAROI> : 3 pour une enceinte circulaire : <YC>,<ZC>,<r>. 4 pour une enceinte rectangulaire : <YC>,<ZC>,<HY>,<HZ>
"""),

33: _(u"""
 FAISCEAU_AXIAL : pour d�finir une enceinte, il faut autant d arguments pour les mots-cl�s <CARA_PAROI> et <VALE_PAROI>
"""),

34: _(u"""
 FAISCEAU_AXIAL : mot-cl� <CARA_PAROI>. donn�es incoh�rentes pour une enceinte circulaire
"""),

35: _(u"""
 FAISCEAU_AXIAL : valeur inacceptable pour le rayon de l enceinte circulaire
"""),

36: _(u"""
 FAISCEAU_AXIAL : mot-cl� <CARA_PAROI>. donn�es incoh�rentes pour une enceinte rectangulaire
"""),

37: _(u"""
 FAISCEAU_AXIAL : valeur(s) inacceptable(s) pour l une ou(et) l autre des dimensions de l enceinte rectangulaire
"""),

38: _(u"""
 FAISCEAU_AXIAL : le mot-cl� <ANGL_VRIL> est obligatoire quand on d�finit une enceinte rectangulaire
"""),

39: _(u"""
 FAISCEAU_AXIAL : le mot-cl� <VECT_X> est obligatoire si il n y a qu'une seule occurrence pour le mot-cl� facteur. sinon, il doit appara�tre dans au moins une des occurrences
"""),

40: _(u"""
 FAISCEAU_AXIAL : le mot-cl� <PROF_RHO_FLUI> est obligatoire si il n y a qu'une seule occurrence pour le mot-cl� facteur. sinon, il doit appara�tre dans au moins une des occurrences
"""),

41: _(u"""
 FAISCEAU_AXIAL : le mot-cl� <PROF_VISC_CINE> est obligatoire si il n y a qu'une seule occurrence pour le mot-cl� facteur. sinon, il doit appara�tre dans au moins une des occurrences
"""),

42: _(u"""
 FAISCEAU_AXIAL : le mot-cl� <RUGO_TUBE> est obligatoire si il n y a qu'une seule occurrence pour le mot-cl� facteur. sinon, il doit appara�tre dans au moins une des occurrences
"""),

43: _(u"""
 FAISCEAU_AXIAL : les mots-cl�s <CARA_PAROI> et <VALE_PAROI> sont obligatoires si il n y a qu'une seule occurrence pour le mot-cl� facteur. sinon, ils doivent appara�tre ensemble dans au moins une des occurrences. le mot-cl� <ANGL_VRIL> doit �galement �tre pr�sent si l on d�finit une enceinte rectangulaire
"""),

44: _(u"""
 COQUE_COAX : il faut trois composantes pour <VECT_X>
"""),

45: _(u"""
 COQUE_COAX : l axe de r�volution des coques doit avoir pour vecteur directeur l un des vecteurs unitaires de la base li�e au rep�re global
"""),

46: _(u"""
 caract�risation de la topologie de la structure b�ton : le groupe de mailles associe ne doit contenir que des mailles 2d ou que des mailles 3d
"""),

47: _(u"""
 r�cup�ration du mat�riau b�ton : les caract�ristiques mat�rielles n ont pas �t� affect�es a la maille no %(k1)s  appartenant au groupe de mailles                                 associe a la structure b�ton
"""),

48: _(u"""
 r�cup�ration des caract�ristiques du mat�riau b�ton : absence de relation de comportement de type <BPEL_BETON> ou <ETCC_BETON>
"""),

49: _(u"""
 le calcul de la tension est fait selon BPEL. il ne peut y avoir qu'un seule jeu de donn�es. v�rifiez la coh�rence du param�tre PERT_FLUA  dans les DEFI_MATERIAU
"""),

51: _(u"""
 le calcul de la tension est fait selon BPEL. il ne peut y avoir qu'un seule jeu de donn�es. v�rifiez la coh�rence du param�tre PERT_RETR dans les DEFI_MATERIAU
"""),

52: _(u"""
 r�cup�ration des caract�ristique du mat�riau b�ton, relation de comportement <BPEL_BETON> : au moins un param�tre ind�fini
"""),

53: _(u"""
 r�cup�ration des caract�ristiques du mat�riau b�ton, relation de comportement <BPEL_BETON> : au moins une valeur de param�tre invalide
"""),

54: _(u"""
 caract�risations de la topologie du c�ble no %(k1)s  : on a trouve une maille d un type non acceptable
"""),

55: _(u"""
 caract�risation de la topologie du c�ble no %(k1)s  : il existe plus de deux chemins possibles au d�part du noeud  %(k2)s
"""),

56: _(u"""
 caract�risation de la topologie du c�ble no %(k1)s  : il n existe aucun chemin possible au d�part du noeud  %(k2)s
"""),

57: _(u"""
 caract�risation de la topologie du c�ble no %(k1)s  : deux chemins continus possibles de  %(k2)s  a  %(k3)s  : ambigu�t�
"""),

58: _(u"""
 caract�risation de la topologie du c�ble no %(k1)s  : aucun chemin continu valide
"""),

59: _(u"""
 interpolation de la trajectoire du c�ble no %(k1)s  : deux noeuds sont g�om�triquement confondus
"""),

60: _(u"""
 interpolation de la trajectoire du c�ble no %(k1)s  : d�tection d un point de rebroussement
"""),

61: _(u"""
Erreur utilisateur :
 Vous devez fournir le mot cl� MAILLAGE pour un champ aux noeuds ou une carte.
"""),

62: _(u"""
Erreur utilisateur :
 vous devez fournir les mots cl�s MODELE et OPTION pour un champ �l�mentaire
"""),

63: _(u"""
 occurrence  %(k1)s  de  %(k2)s : impossible d affecter les valeurs demand�es sur le(la) %(k3)s  qui n a pas �t� affecte(e) par un �l�ment
"""),

64: _(u"""
 occurrence  %(k1)s  de  %(k2)s : impossible d affecter les valeurs demand�es sur le(la)  %(k3)s  qui ne supporte pas un �l�ment du bon type
"""),

65: _(u"""
 occurrence  %(k1)s  de  %(k2)s  : le(la) %(k3)s  ne supporte pas un �l�ment compatible avec la caract�ristique  %(k4)s
"""),

66: _(u"""
  %(k1)s  item attendu en d�but de ligne
"""),

67: _(u"""
  La table des fonctions de forme fournie pour le mode no. %(i1)d n'est pas valide.
"""),

68: _(u"""
  La table fournie pour le mode no. %(i1)d n'est pas une table_fonction.
"""),

69: _(u"""
  Les fonctions de forme pour le mode no. %(i1)d ne sont pas d�finies � partir de l'abscisse 0.
"""),

70: _(u"""
  Les fonctions de forme pour le mode no. %(i1)d ne sont pas d�finies sur le m�me intervalle.
"""),

71: _(u"""
 Les discr�tisations des fonctions de forme pour les diff�rents modes ne sont pas coh�rentes.
 Le domaine de d�finition 0,L doivent �tre communs � toutes les fonctions.
"""),

72: _(u"""
 Les discr�tisations des fonctions de forme pour les diff�rents modes ne sont pas coh�rentes.
 Le nombre de points de discr�tisation doivent �tre communs � toutes les fonctions.
"""),

75: _(u"""
 le GROUP_NO  %(k1)s  ne fait pas partie du maillage :  %(k2)s
"""),

76: _(u"""
 le noeud  %(k1)s  ne fait pas partie du maillage :  %(k2)s
"""),

77: _(u"""
 le GROUP_MA  %(k1)s  ne fait pas partie du maillage :  %(k2)s
"""),

79: _(u"""
 le type  %(k1)s d'objets a v�rifier n'est pas correct : il ne peut �tre �gal qu'a GROUP_NO ou noeud ou GROUP_MA ou maille
"""),

80: _(u"""
 d�faut de plan�it�
 l angle entre les normales aux mailles: %(k1)s  et  %(k2)s  est sup�rieur � ANGL_MAX.
"""),

81: _(u"""
  %(k1)s  un identificateur est attendu : " %(k2)s " n'en est pas un
"""),

82: _(u"""
  %(k1)s  un identificateur d�passe 8 caract�res
"""),

83: _(u"""
  %(k1)s  le mot cl� FIN n'est pas attendu
"""),

84: _(u"""
  %(k1)s  le mot cl� FINSF n est pas attendu
"""),

85: _(u"""
  %(k1)s  un nombre est attendu
"""),

86: _(u"""
 la maille de nom :  %(k1)s  n'est pas de type SEGMENT
 elle ne sera pas affect�e par  %(k2)s
"""),

87: _(u"""
 la maille de nom :  %(k1)s  n'est pas de type TRIA ou QUAD
 elle ne sera pas affect�e par  %(k2)s
"""),

88: _(u"""
  -> Erreur dans les mailles du mot-cl� facteur %(k1)s :
     aucune maille n'est du bon type. Elles sont toutes ignor�es.
"""),

89: _(u"""
 la maille de num�ro :  %(k1)s  n'est pas de type SEGMENT
 elle ne sera pas affect�e par  %(k2)s
"""),

90: _(u"""
 la maille de num�ro :  %(k1)s  n'est pas de type TRIA ou QUAD
 elle ne sera pas affect�e par  %(k2)s
"""),

91: _(u"""
 erreur dans les noms de maille du GROUP_MA:  %(k1)s  du mot-cl� facteur  %(k2)s
 aucune maille n'est du bon type
"""),

92: _(u"""
 la maille de nom :  %(k1)s  n'est pas une maille 3d, elle ne sera pas affect�e par  %(k2)s
"""),

93: _(u"""
 la maille de num�ro :  %(k1)s  n'est pas une maille 3d, elle ne sera pas affect�e par  %(k2)s
"""),

97: _(u"""
  -> Le GROUP_MA %(k1)s du maillage %(k2)s se retrouve vide du fait
     de l'�limination des mailles servant au collage.
     Il n'est donc pas recr�� dans le maillage assembl�.
"""),

99: _(u"""
 Aucun groupe de fibres n'a de comportement.
"""),

}
