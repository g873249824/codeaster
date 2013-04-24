#@ MODIF utilitai Messages  DATE 22/04/2013   AUTEUR BOYERE E.BOYERE 
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

cata_msg = {

# a traduire en fran�ais par JP
1 : _(u"""
 le nombre de grels du LIGREL du mod�le est nul.
"""),

2 : _(u"""
 il ne faut pas demander 'TR' derri�re CARA si le type d'�l�ment discret ne prend pas en compte la rotation
"""),

3 : _(u"""
 La conversion d'un champ par �l�ments aux noeuds en un champ
 aux noeuds a �t� demand�.
 Or le champ par �l�ments aux noeuds contient des
 sous-points alors qu'un champ aux noeuds ne peut pas en contenir.
 Les mailles contenant des sous-points vont �tre exclues.

 Conseil :
   Si vous souhaitez convertir le champ sur les mailles ayant des
   sous-points, vous devez d'abord extraire le champ par �l�ments
   aux noeuds sur un sous-point avec la commande POST_CHAMP.
"""),

4 : _(u"""
 Vous avez demand� le calcul d'un champ aux noeuds sur des �l�ments
 de structure. Mais les rep�res locaux de certaines mailles entourant
 des noeuds sur lesquels vous avez demand�s le calcul ne sont pas
 compatibles (Au maximum, on a %(r1)g degr�s d'�cart entre les angles
 nautiques d�finissant ces rep�res).

 Risque & Conseil :
   Il se peut que vous obteniez des r�sultats incoh�rents.
   Il est donc recommand� de passer en rep�re global les champs
   utiles au calcul du champ aux noeuds.
"""),

5 : _(u"""
 vecteur axe de norme nulle
"""),

6 : _(u"""
 axe non colin�aire � v1v2
"""),

7 : _(u"""
 Probl�me norme de axe
"""),

8 : _(u"""
Cette grandeur ne peut pas accepter plus de %(i2)d composantes (%(i1)d fournies).
"""),

9 : _(u"""
 dimension  %(k1)s  inconnue.
"""),

10 : _(u"""
 maillage obligatoire.
"""),

11 : _(u"""
 on ne peut pas cr�er un champ de VARI_R avec le mot cl� facteur AFFE
 (voir u2.01.09)
"""),

12 : _(u"""
 mot cl� AFFE/NOEUD interdit ici.
"""),

13 : _(u"""
 mot cl� AFFE/GROUP_NO interdit ici.
"""),

14 : _(u"""
 type scalaire non trait� :  %(k1)s
"""),

15 : _(u"""
 incoh�rence entre nombre de composantes et nombre de valeurs
"""),

16 : _(u"""
 il faut donner un champ de fonctions
"""),

17 : _(u"""
 les param�tres doivent �tre r�els
"""),

18 : _(u"""
 maillages diff�rents
"""),

20 : _(u"""
 le champ  %(k1)s n'est pas de type r�el
"""),

21 : _(u"""
 on ne traite que des "CHAM_NO" ou des "CHAM_ELEM".
"""),

22: _(u"""
 la programmation pr�voit que les entiers sont cod�s sur plus de 32 bits
 ce qui n'est pas le cas sur votre machine
"""),

23 : _(u"""
 on ne trouve aucun champ.
"""),

24 : _(u"""
 Lors de la recopie du champ "%(k1)s" vers le champ "%(k2)s" utilisant
 le NUME_DDL "%(k3)s" certaines composantes de "%(k2)s" ont du �tre
 mises � z�ro.
 
 En effet, certaines parties attendues dans le champ "%(k2)s" n'�taient
 pas pr�sentes dans "%(k1)s", elles ont donc �t� mises � z�ros.
 
 Ce probl�me peut survenir lorsque la num�rotation du champ "%(k1)s"
 n'est pas int�gralement incluse dans celle de "%(k2)s".
"""),







26 : _(u"""
 pas la m�me num�rotation sur les CHAM_NO.
"""),

27 : _(u"""
 il faut donner un maillage.
"""),

28 : _(u"""
 Le champ : %(k1)s ne peut pas �tre assembl� en :  %(k2)s
"""),

29 : _(u"""
Erreur utilisateur :
 La structure de donn�e r�sultat %(k1)s est associ�e au maillage %(k2)s
 Mais la structure de donn�e nume_ddl %(k3)s est associ�e au maillage %(k4)s
 Il n'y a pas de coh�rence.
"""),





31 : _(u"""
 NOM_CMP2 et NOM_CMP de longueur diff�rentes.
"""),

32: _(u"""
 Grandeur incorrecte pour le champ : %(k1)s
 grandeur propos�e :  %(k2)s
 grandeur attendue :  %(k3)s
"""),

33 : _(u"""
 le mot-cl� 'COEF_C' n'est applicable que pour un champ de type complexe
"""),

34 : _(u"""
 d�veloppement non r�alis� pour les champs aux �l�ments. vraiment d�sol� !
"""),

35 : _(u"""
 le champ  %(k1)s n'est pas de type complexe
"""),

36 : _(u"""
 on ne traite que des CHAM_NO r�els ou complexes. vraiment d�sol� !
"""),

40 : _(u"""
 structure de donn�es inexistante : %(k1)s
"""),

41 : _(u"""
 duplication "maillage" du .LTNT, objet inconnu:  %(k1)s
"""),

42 : _(u"""
 type de sd. inconnu :  %(k1)s
"""),

43 : _(u"""
 num�rotation absente  probl�me dans la matrice  %(k1)s
"""),

44 : _(u"""
  erreur dans la r�cup�ration du nombre de noeuds !
"""),

45 : _(u"""
 type non connu.
"""),

46 : _(u"""
 la fonction doit s appuyer sur un maillage pour lequel une abscisse curviligne a �t� d�finie.
"""),

47 : _(u"""
  le mot cl� : %(k1)s n est pas autorise.
"""),

49 : _(u"""
  DISMOI :
  la question : " %(k1)s " est inconnue
"""),





51 : _(u"""
 il n y a pas de NUME_DDL pour ce CHAM_NO
"""),

52 : _(u"""
 type de charge inconnu
"""),


54 : _(u"""
 trop d objets
"""),

55 : _(u"""
 champ inexistant: %(k1)s
"""),


56 : _(u"""
 Le partitionneur SCOTCH a fait remonter l'erreur %(i1)d. Veuillez contacter l'�quipe de
 d�veloppement.
 Pour contourner ce probl�me, vous pouvez n�anmoins:
   - changer de partitionneur (METHODE=KMETIS ou PMETIS),
   - modifier les param�tres num�riques du partitionnement (mots-cl�s TRAITER_BORDS,
     POIDS_MAILLES, GROUPAGE...),
   - g�n�rer votre partitionnement manuellement (autant de groupes de mailles et de
     groupes de mailles bords que de sous-domaines) et les donner � l'op�rateur
     d�di�: DEFI_PART_FETI_OPS.
"""),


57 : _(u"""
  DISMOI :
  la question n'a pas de r�ponse sur une grandeur de type matrice GD_1 x GD_2
"""),

59 : _(u"""
  DISMOI :
  la question n'a pas de sens sur une grandeur de type matrice GD_1 x GD_2
"""),

60 : _(u"""
  DISMOI :
  la question n'a pas de sens sur une grandeur de type compos�e
"""),

63 : _(u"""
 ph�nom�ne inconnu :  %(k1)s
"""),

65 : _(u"""
 le type de concept : " %(k1)s " est inconnu
"""),

66 : _(u"""
 le ph�nom�ne :  %(k1)s  est inconnu.
"""),

68 : _(u"""
 type de r�sultat inconnu :  %(k1)s  pour l'objet :  %(k2)s
"""),

69 : _(u"""
 le r�sultat compos� ne contient aucun champ
"""),

70 : _(u"""
 TYPE_MAILLE inconnu.
"""),

71 : _(u"""
 mauvaise r�cup�ration de NEMA
"""),

72 : _(u"""
 on ne traite pas les noeuds tardifs
"""),

73 : _(u"""
 grandeur inexistante
"""),

74 : _(u"""
 composante de grandeur inexistante
"""),

75 : _(u"""
 probl�me avec la r�ponse  %(k1)s
"""),

76 : _(u"""
 les conditions aux limites autres que des ddls bloques ne sont pas admises
"""),

77 : _(u"""
 unit� logique  %(k1)s , probl�me lors du close
"""),

78 : _(u"""
  erreur dans la r�cup�ration du maillage
"""),

79 : _(u"""
  erreur dans la r�cup�ration du nombre de mailles
"""),

80 : _(u"""
  groupe_ma non pr�sent
"""),

81 : _(u"""
  erreur � l'appel de METIS
  plus aucune unit� logique libre
"""),

82 : _(u"""
 m�thode d'int�gration inexistante.
"""),

83 : _(u"""
 interpolation par d�faut "lin�aire"
"""),

84 : _(u"""
 interpolation  %(k1)s  non implant�e
"""),

85 : _(u"""
 recherche " %(k1)s " inconnue
"""),

86 : _(u"""
 l'intitule " %(k1)s " n'est pas correct.
"""),

87 : _(u"""
 le noeud " %(k1)s " n'est pas un noeud de choc.
"""),

88 : _(u"""
 nom de sous-structure et d'intitul� incompatible
"""),

89 : _(u"""
 le noeud " %(k1)s " n'est pas un noeud de choc de l'intitule.
"""),

90 : _(u"""
 le noeud " %(k1)s " n'est pas compatible avec le nom de la sous-structure.
"""),

91 : _(u"""
 le param�tre " %(k1)s " n'est pas un param�tre de choc.
"""),

92 : _(u"""
 le noeud " %(k1)s " n'existe pas.
"""),

93 : _(u"""
 la composante " %(k1)s " du noeud " %(k2)s " n'existe pas.
"""),

94 : _(u"""
 type de champ inconnu  %(k1)s
"""),

95 : _(u"""
 "INTERP_NUME" et ("INST" ou "LIST_INST") non compatibles
"""),

96 : _(u"""
 "INTERP_NUME" et ("FREQ" ou "LIST_FREQ") non compatibles
"""),

99 : _(u"""
 objet %(k1)s inexistant
"""),

}
