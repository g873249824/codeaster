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

cata_msg={

1: _(u"""
 on doit donner un CHAM_NO apr�s le mot cl� CHAM_NO derri�re le mot facteur LIAISON_CHAMNO .
"""),

2: _(u"""
 il faut d�finir la valeur du second membre de la relation lin�aire apr�s le mot cl� COEF_IMPO derri�re le mot facteur LIAISON_CHAMNO .
"""),

3: _(u"""
 la premi�re liste de noeuds dont on doit faire le vis a vis n'existe pas.
"""),

4: _(u"""
 la seconde liste de noeuds dont on doit faire le vis a vis n'existe pas.
"""),

5: _(u"""
 la premi�re liste de noeuds dont on doit faire le vis a vis est vide.
"""),

6: _(u"""
 la seconde liste de noeuds dont on doit faire le vis a vis est vide.
"""),

7: _(u"""
 impossibilit� de faire le vis a vis des 2 listes de noeuds, elles n'ont pas le m�me nombre de noeuds apr�s �limination des doublons.
"""),

8: _(u"""
 Erreur utilisateur dans CREA_MAILLAGE / QUAD_LINE :
  Vous avez demand� de transformer des mailles quadratiques en mailles lin�aires.
  Mais il n'y a aucune maille quadratique � transformer.
"""),

9: _(u"""
 le mot cl� "TRAN" sous le mot cl� facteur %(k1)s  n"admet que 3 valeurs
"""),

10: _(u"""
 le mot cl� "ANGL_NAUT" sous le mot cl� facteur %(k1)s  n"admet que 3 valeurs
"""),

11: _(u"""
 le mot cl� "centre" sous le mot cl� facteur %(k1)s  n"admet que 3 valeurs
"""),

12: _(u"""
  Mot cl� LIAISON_GROUP : les mots cl�s %(k1)s et %(k2)s � mettre
  en vis-�-vis n'ont pas le m�me nombre de noeuds.

   - Nombre de noeuds pr�sent sous le mot cl� %(k1)s: %(i1)d
   - Nombre de noeuds pr�sent sous le mot cl� %(k2)s: %(i2)d

"""),

13: _(u"""
 il n'y a aucun groupe de noeuds ni aucun noeud d�fini apr�s le mot facteur  %(k1)s
"""),

14: _(u"""
 le mot cl� "TRAN" sous le mot cl� facteur  %(k1)s  n'admet que  %(k2)s  valeurs
"""),

15: _(u"""
 le mot cl� "ANGL_NAUT" sous le mot cl� facteur  %(k1)s  n'admet que  %(k2)s  valeurs
"""),

16: _(u"""
 le mot cl� "centre" sous le mot cl� facteur  %(k1)s  n'admet que  %(k2)s  valeurs
"""),

17: _(u"""
 attention, la liste des noeuds est r�duite a un seul terme et l'on ne fait aucun traitement
"""),

18: _(u"""
 la table "CARA_GEOM" n'existe pas dans le maillage
"""),

19: _(u"""
 mailles mal orient�es
"""),

20: _(u"""
 pour les segments en 3d, il faut renseigner VECT_ORIE_pou
"""),

21: _(u"""
 pas de normale pour les tria en 2d
"""),

22: _(u"""
 pas de normale pour les quadrangles en 2d
"""),

23: _(u"""
 il est impossible de calculer la tangente de la maille  %(k1)s . des noeuds doivent �tre confondus.
"""),

24: _(u"""
 il est impossible de calculer la normale de la maille  %(k1)s . des noeuds doivent �tre confondus.
"""),

25: _(u"""
 impossible de calculer la normale d un segment en 3d
"""),

26: _(u"""
 il est impossible de calculer la normale de la maille  %(k1)s . des ar�tes doivent �tre confondues.
"""),

27: _(u"""
 type d �l�ment inconnu
"""),

28: _(u"""
 la norme du vecteur normal ( ou tangentiel) moyenne est presque nulle. les facettes concourantes  au noeud  %(k1)s  ne d�finissent pas une normale moyenne fiable . il y a un probl�me dans la d�finition de vos mailles de bord .
"""),

29: _(u"""
 L'angle forme par le vecteur normal courant a 1 face et le vecteur normal moyen, au noeud  %(k1)s , est sup�rieur a 10 degr�s et vaut  %(k2)s  degr�s.
"""),

30: _(u"""
Erreur d'utilisation :
 La norme du vecteur normal (moyenne des normales des �l�ments concourants) est presque nulle.
 Les facettes concourantes au noeud  %(k1)s ne d�finissent pas une normale fiable.
 Il y a un probl�me dans la d�finition des mailles de bord .

Suggestion :
 Avez-vous pens� � r�orienter les mailles de bord avec l'op�rateur MODI_MAILLAGE
"""),

31: _(u"""
 l'angle forme par le vecteur normal courant a 1 face et le vecteur normal moyenne, au noeud  %(k1)s , est sup�rieur a 10 degr�s et vaut  %(k2)s  degr�s.
"""),

32: _(u"""
 Alarme utilisateur dans CREA_MAILLAGE/MODI_MAILLE :
  Occurrence du mot cl� facteur MODI_MAILLE : %(i1)d.
  Vous avez demand� la transformation de type %(k1)s.
  Mais il n'y a aucune maille � transformer.
"""),

35: _(u"""
 probl�me pour d�terminer le rang de la composante <n> de la grandeur <SIEF_R>
"""),

36: _(u"""
 le concept %(k1)s n'est pas un concept de type cabl_precont.
"""),

37: _(u"""
 erreur a l appel de la routine etenca pour extension de la carte  %(k1)s
"""),

40: _(u"""
 Erreur utilisateur :
 Il ne faut pas d�finir les mots cl�s GROUP_MA et TOUT en m�me temps dans AFFE_CHAR_MECA/ROTATION,
 ni les mots cl�s MAILLE et TOUT.
"""),

44: _(u"""
 Erreur utilisateur dans CREA_MAILLAGE / LINE_QUAD :
  Vous avez demand� de transformer des mailles lin�aires en mailles quadratiques.
  Mais il n'y a aucune maille lin�aire � transformer.
"""),

60: _(u"""
 on ne donne le mot facteur "CONVECTION" qu'une fois au maximum
"""),

61: _(u"""
 le type s est interdit en 3d
"""),

62: _(u"""
 les types SV ou SH sont interdits en 2d
"""),

63: _(u"""
 donner un vecteur non nul
"""),

64: _(u"""
 nombre d occurrence du mot cl� "SOUR_CALCULEE"  sup�rieur a 1
"""),


66: _(u"""
 la dimension du maillage ne correspond pas � la dimension des �l�ments
"""),

67: _(u"""
 on doit utiliser obligatoirement le mot-cl� DIST pour d�finir la demi largeur de bande.
"""),

68: _(u"""
 on doit donner une distance strictement positive pour d�finir la bande.
"""),

69: _(u"""
 on doit utiliser obligatoirement le mot-cl� ANGL_NAUT ou le mot-cl� VECT_NORMALE pour l'option bande de CREA_GROUP_MA. ce mot-cl� permet de d�finir la direction perpendiculaire au plan milieu de la bande.
"""),

70: _(u"""
 pour l'option bande de CREA_GROUP_MA, il faut  d�finir les 3 composantes du vecteur perpendiculaire au plan milieu de la  bande quand on est en 3d.
"""),

71: _(u"""
 pour l'option bande de CREA_GROUP_MA, il faut  d�finir les 2 composantes du vecteur perpendiculaire au plan milieu de la  bande quand on est en 2d.
"""),

72: _(u"""
 erreur dans la donn�e du vecteur normal au plan milieu de la  bande : ce vecteur est nul.
"""),

73: _(u"""
 l'option cylindre de CREA_GROUP_MA n'est utilisable qu'en 3d.
"""),

74: _(u"""
 on doit utiliser obligatoirement le mot-cl� rayon pour d�finir le rayon du cylindre.
"""),

75: _(u"""
 on doit donner un rayon strictement positif pour d�finir la cylindre.
"""),

76: _(u"""
 on doit utiliser obligatoirement le mot-cl� ANGL_NAUT ou le mot-cl� VECT_NORMALE pour l'option cylindre de CREA_GROUP_MA
"""),

77: _(u"""
 pour l'option cylindre de CREA_GROUP_MA, il faut  d�finir les 3 composantes du vecteur orientant l'axe du cylindre quand on utilise le mot-cl� VECT_NORMALE.
"""),

78: _(u"""
 pour l'option cylindre de CREA_GROUP_MA, il faut d�finir les 2 angles nautiques quand on utilise le mot-cl� "ANGL_NAUT".
"""),

79: _(u"""
 erreur dans la donn�e du vecteur orientant l'axe du cylindre,ce vecteur est nul.
"""),

80: _(u"""
 on doit utiliser obligatoirement le mots-cl�s ANGL_NAUT ou le mot-cl� VECT_NORMALE pour l'option FACE_NORMALE de CREA_GROUP_MA
"""),

81: _(u"""
 erreur dans la donn�e du vecteur normal selon lequel on veut s�lectionner des mailles : ce vecteur est nul.
"""),

82: _(u"""
 on doit utiliser obligatoirement le mot-cl� rayon pour d�finir le rayon de la sph�re.
"""),

83: _(u"""
 on doit donner un rayon strictement positif pour d�finir la sph�re.
"""),

84: _(u"""
 l'option ENV_CYLINDRE de CREA_GROUP_NO n'est utilisable qu'en 3d.
"""),

85: _(u"""
 on doit utiliser obligatoirement le mot-cl� ANGL_NAUT ou le mot-cl� VECT_NORMALE pour l'option ENV_CYLINDRE de CREA_GROUP_NO
"""),

86: _(u"""
 pour l'option ENV_CYLINDRE de CREA_GROUP_NO, il faut d�finir les 3 composantes du vecteur orientant l'axe du cylindre quand on utilise le mot cl� "VECT_NORMALE".
"""),

87: _(u"""
 pour l'option ENV_CYLINDRE de CREA_GROUP_NO, il faut d�finir les 2 angles nautiques quand on utilise le mot cl� "ANGL_NAUT".
"""),

88: _(u"""
 le mot-cl� pr�cision est obligatoire apr�s le mot-cl� ENV_CYLINDRE pour d�finir la tol�rance (i.e. la distance du point a l'enveloppe du cylindre) accept�e pour d�clarer l'appartenance du point a cette enveloppe.
"""),

89: _(u"""
 on doit donner une demi �paisseur strictement positive d�finir l'enveloppe du cylindre.
"""),

90: _(u"""
 le mot-cl� pr�cision est obligatoire apr�s le mot-cl� ENV_SPHERE pour d�finir la tol�rance (i.e. la distance du point a l'enveloppe de la sph�re) accept�e pour d�clarer l'appartenance du point a cette enveloppe.
"""),

91: _(u"""
 on doit donner une demi �paisseur strictement positive d�finir l'enveloppe de la sph�re.
"""),

92: _(u"""
 erreur dans la donn�e du vecteur orientant l'axe d'un segment ,ce vecteur est nul.
"""),

93: _(u"""
 on doit utiliser obligatoirement le mot-cl� ANGL_NAUT ou le mot-cl� VECT_NORMALE pour l'option plan de CREA_GROUP_NO. ce mot-cl� permet de d�finir la direction  perpendiculaire au plan ou a la droite.
"""),

94: _(u"""
 pour l'option plan de CREA_GROUP_NO, il faut  d�finir les 3 composantes du vecteur perpendiculaire au plan.
"""),

95: _(u"""
 pour l'option plan de CREA_GROUP_NO, il faut  d�finir les 2 composantes du vecteur perpendiculaire a la droite.
"""),

96: _(u"""
 erreur dans la donn�e du vecteur normal au plan ou a la droite : ce vecteur est nul.
"""),

97: _(u"""
 le mot-cl� pr�cision est obligatoire apr�s le mot-cl� plan  pour d�finir la tol�rance (i.e. la distance du point au plan ou a la droite) accept�e pour d�clarer l'appartenance du point a ce plan ou a cette droite.
"""),

98: _(u"""
 on doit donner une tol�rance strictement positive pour v�rifier l'appartenance d'un noeud au plan ou a la droite.
"""),

99: _(u"""
 il manque l'ensemble des noeuds que l'on veut ordonner, mots cl�s "noeud" et/ou "GROUP_NO"
"""),
}
