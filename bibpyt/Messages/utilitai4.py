#@ MODIF utilitai4 Messages  DATE 31/10/2011   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

8: _(u"""
 la composante  %(k1)s  n existe pas dans le champ de la grandeur.
"""),

9: _(u"""
 les num�ros d'ordre des vitesses donnes sous le mot-cle "nume_ordre" ne sont pas valides.
"""),

10: _(u"""
 le mode demande n'est pas un mode couple.
"""),

11: _(u"""
 probleme(s) rencontre(s) lors de l'acces au resu_gene
"""),

12: _(u"""
 pb lors de l'extraction du champ
"""),

13: _(u"""
 on ne traite que le type complexe
"""),

14: _(u"""
 composante generalisee NUME_CMP_GENE non trouvee
 Conseil : verifiez que la composante generalisee demandee est bien presente dans la base modale.
"""),

15: _(u"""
 probleme(s) rencontre(s) lors de la lecture des fr�quences.
"""),

16: _(u"""
  on ne traite pas le type de modes " %(k1)s ".
"""),

17: _(u"""
 on ne traite que le type reel
"""),

19: _(u"""
 on ne traite que les champs par �l�ments de type r�el.
"""),

20: _(u"""
 on ne traite pas ce type de champ: %(k1)s
"""),

21: _(u"""
 "INTERP_NUME" interdit pour recuperer un param�tre en fonction d'une variable d'acc�s
"""),

22: _(u"""
 aucun champ trouve pour l'acces  %(k1)s
"""),

23: _(u"""
 le champ  %(k1)s  n'existe pas dans le RESU_GENE.
"""),

24: _(u"""
 probleme(s) rencontre(s) lors de la lecture des instants.
"""),

25: _(u"""
 probleme recup de ptem uniquement pour methode adapt
"""),

26: _(u"""
 acce_mono_appui est compatible uniquement avec un champ de type : acce
"""),

27: _(u"""
 manque la d�finition d'un mot cle
"""),

29: _(u"""
 nouvelle longueur invalide, < 0
"""),

30: _(u"""
 probleme dans le decodage de ( %(k1)s , %(k2)s )
"""),

31: _(u"""
 type_resultat inconnu : %(k1)s
"""),

33: _(u"""
 type scalaire inconnu :  %(k1)s
"""),

34: _(u"""
 sd  %(k1)s  inexistante
"""),

35: _(u"""
 pas de num�ro d'ordre pour  %(k1)s
"""),

36: _(u"""
 longt trop grand
"""),

37: _(u"""
  -> Le MODELE fourni par l'utilisateur est diff�rent
     de celui pr�sent dans la Structure de Donn�es R�sultat. On poursuit les calculs
     avec le MODELE fourni par l'utilisateur.
  -> Risque & Conseil : V�rifiez si le MODELE fourni dans la commande est
     bien celui que vous souhaitez. Si oui vous allez poursuivre les calculs
     (ex: calcul des contraintes: CALC_ELEM) avec un MODELE diff�rent de
     celui utilis� pour calculer les d�placements, temp�ratures,...
"""),

38: _(u"""
  -> Le concept de caract�ristiques CARA_ELEM fourni par l'utilisateur est diff�rent
     de celui pr�sent dans la Structure de Donn�es R�sultat. On poursuit les calculs
     avec le CARA_ELEM fourni par l'utilisateur.
  -> Risque & Conseil : V�rifiez si le CARA_ELEM fourni dans la commande est
     bien celui que vous souhaitez. Si oui vous allez poursuivre les calculs
     (ex: calcul des contraintes: CALC_ELEM) avec un CARA_ELEM diff�rent de
     celui utilis� pour calculer les d�placements, temp�ratures,...
"""),

39: _(u"""
  -> Le mat�riau MATER fourni par l'utilisateur est diff�rent de celui pr�sent dans
     la Structure de Donn�es R�sultat. On poursuit les calculs avec le mat�riau
     fourni par l'utilisateur.
  -> Risque & Conseil : V�rifiez si le mat�riau fourni dans la commande est
     bien celui que vous souhaitez. Si oui vous allez poursuivre les calculs
     (ex: calcul des contraintes: CALC_ELEM) avec un mat�riau diff�rent de
     celui utilis� pour calculer les d�placements, temp�ratures,...
"""),

40: _(u"""
  -> Le chargement (mot cle: CHARGE) fourni par l'utilisateur est diff�rent de celui pr�sent dans
     la Structure de Donn�es R�sultat. On poursuit les calculs avec le chargement
     fourni par l'utilisateur.
  -> Risque & Conseil : V�rifiez si le chargement fourni dans la commande est
     bien celui que vous souhaitez. Si oui vous allez poursuivre les calculs
     (ex: calcul des contraintes: CALC_ELEM) avec un chargement diff�rent de
     celui utilis� pour calculer les d�placements, temp�ratures,...
"""),

41: _(u"""
  -> les fonctions multiplicatrices du chargement (mot cle: FONC_MULT) fournies par
     l'utilisateur sont diff�rentes de celles pr�sentes dans la Structure de Donn�es R�sultat.
     On poursuit les calculs avec les fonctions multiplicatrices fournies par l'utilisateur.
  -> Risque & Conseil : V�rifiez si les fonctions fournies dans la commande sont
     bien celles que vous souhaitez. Si oui vous allez poursuivre les calculs
     (ex: calcul des contraintes: CALC_ELEM) avec des fonctions diff�rentes de
     celles utilis�es pour calculer les d�placements, temp�ratures,...
"""),

42: _(u"""
 num�ro d'ordre trop grand.
"""),

43: _(u"""
 nom de champ interdit :  %(k1)s  pour le resultat :  %(k2)s
"""),

44: _(u"""
  pas de variables d'acces
"""),

45: _(u"""
  pas de param�tres
"""),

46: _(u"""
 cet acces est interdit pour un resultat de type "champ_gd".
"""),

47: _(u"""
 cet acces est interdit :  %(k1)s
"""),

49: _(u"""
 probleme pour recuperer les num�ros d'ordre dans la structure "resultat"  %(k1)s
"""),

50: _(u"""
 probleme pour recuperer les param�tres
"""),

51: _(u"""
 aucun num�ro d'ordre ne correspond au param�tre demande  %(k1)s
"""),

52: _(u"""
 aucun num�ro d'ordre ne correspond au champ demande  %(k1)s
"""),

53: _(u"""
 aucun num�ro d'ordre trouve. stop.
"""),

63: _(u"""
 acces inconnu  %(k1)s
"""),

64: _(u"""
 la table n'existe pas
"""),

65: _(u"""
 pas de param�tres d�finis
"""),

66: _(u"""
 pas de lignes d�finis
"""),

67: _(u"""
 mauvais num�ro de ligne
"""),

68: _(u"""
 nom de table incorrect
"""),

69: _(u"""
 nombre de valeur a ajoute superieur au nombre de ligne de la table
"""),

70: _(u"""
 num�ro de ligne negatif
"""),

71: _(u"""
 num�ro de ligne superieur aunombre de ligne de la table
"""),

72: _(u"""
 le param�tre n existe pas
"""),

73: _(u"""
 les types du param�tre ne correspondent pas entre eux.
"""),

74: _(u"""
 num�ro de ligne trop grand
"""),

75: _(u"""
 erreur pgmation le nom d'une table ne doit pas depasser 17 caracteres.
"""),

76: _(u"""
 pas de lignes d�finies
"""),

77: _(u"""
 types de param�tres diff�rents
"""),

78: _(u"""
 on n a pas trouve de ligne contenant les deux param�tres.
"""),

79: _(u"""
 table  %(k1)s  : n'existe pas
"""),

80: _(u"""
 table  %(k1)s  : aucun param�tre n'est d�fini
"""),

81: _(u"""
 pas de param�tres de type i et r
"""),

82: _(u"""
 pas de lignes selectionnees
"""),

83: _(u"""
 table non diagonalisable
"""),

84: _(u"""
 impression de la table superieure a 2000 colonnes, selectionnez vos param�tres.
"""),

85: _(u"""
 pagination supprimee, utiliser impr_table
"""),

86: _(u"""
 il faut 3 param�tres pour une impression au format "tableau"
"""),

87: _(u"""
 on ne trie que 1 ou 2 param�tres
"""),

88: _(u"""
 le tableau %(k1)s .vale" est de type  %(k2)s
"""),

89: _(u"""
 seules les 50 premieres lignes du titre sont conservees.
"""),

99: _(u"""
 et alors typesd =  %(k1)s
"""),
}
