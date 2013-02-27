#@ MODIF calculel6 Messages  DATE 26/02/2013   AUTEUR DESROCHE X.DESROCHES 
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
Erreur utilisateur (dans la commande AFFE_MATERIAU) :
  Dans le CHAM_MATER %(k1)s, vous avez affect� le mat�riau %(k2)s.
  Dans ce mat�riau, il existe un coefficient de dilatation (ELAS/ALPHA)
  qui est une fonction de la temp�rature.
  Pour pouvoir utiliser cette fonction, il est n�cessaire de transformer
  cette fonction (changement de rep�re : "TEMP_DEF_ALPHA" -> "TEMP_REF").
  Pour cela, l'utilisateur doit fournir une temp�rature de r�f�rence.

Solution :
  V�rifier que les mailles affect�es par le mat�riau %(k2)s sont bien
  toutes affect�es par une temp�rature de r�f�rence
  (mot cl� AFFE_VARC/NOM_VARC='TEMP',VALE_REF=...).
"""),

2: _(u"""
  Probl�me d'extraction : R�sultat g�n�ralis� %(k1)s
"""),

3: _(u"""
  Le param�tre n'existe pas.
"""),

4: _(u"""
  0 ligne trouv�e pour les NOM_PARA.
"""),

5: _(u"""
  Plusieurs lignes trouv�es.
"""),

6: _(u"""
  Erreur de Programmation: code retour de 'TBLIVA' inconnu.
"""),

7: _(u"""
Erreur utilisateur dans la commande TEST_TABLE :
  On n'a pas pu trouver dans la table la valeur � tester.

Conseils :
  Plusieurs raisons peuvent expliquer l'�chec du test :
    * Le param�tre test� n'existe pas dans la table
    * Les filtres utilis�s sont tels qu'aucune ligne ne les v�rifie
    * Dans une occurrence du mot cl� filtre, l'utilisateur s'est tromp� de mot cl�
      pour indiquer la valeur :
        * VALE    -> r�el
        * VALE_I  -> entier
        * VALE_K  -> cha�ne de caract�res
        * VALE_C  -> complexe

"""),

8: _(u"""
  Les types ne correspondent pas.
"""),


10: _(u"""
  L'option %(k1)s est inconnue.
"""),

11: _(u"""
  Erreur d'utilisation :
    Vous avez d�pass� une des limites de la programmation concernant les champs de mat�riaux :
    On ne pas utiliser plus de 9999 mat�riaux diff�rents
"""),

15: _(u"""
  L'�l�ment diagonal u( %(i1)d , %(i2)d ) de la factorisation est nul. %(k1)s
  la solution et les estimations d'erreurs ne peuvent �tre calcul�es. %(k2)s
"""),

17: _(u"""
 recherche nombre de composante: erreur:  %(k1)s grandeur num�ro  %(i1)d  de nom  %(k2)s
"""),

20: _(u"""
 recherche nombre de composante: erreur: grandeur ligne num�ro  %(i1)d  de nom  %(k1)s
 grandeur colonne num�ro  %(i2)d
  de nom  %(k2)s
 grandeur m�re num�ro  %(i3)d
  de nom  %(k3)s
"""),

21: _(u"""
 recherche nombre de composante: erreur: grandeur %(i1)d a un code inconnu:  %(i2)d
"""),

22: _(u"""
 recherche nombre d entiers codes  %(k1)s grandeur num�ro  %(i1)d  de nom  %(k2)s
"""),

25: _(u"""
 recherche nombre d entiers codes grandeur ligne num�ro  %(i1)d  de nom  %(k1)s
 grandeur colonne num�ro  %(i2)d de nom  %(k2)s
 grandeur m�re num�ro  %(i3)d de nom  %(k3)s
"""),

26: _(u"""
 recherche nombre d entiers codes grandeur %(i1)d a un code inconnu:  %(i2)d
"""),


42: _(u"""
 La prise en compte de l'erreur sur une condition aux limites
 de type ECHANGE_PAROI n'a pas �t� encore implant�e
"""),

43: _(u"""
 le mot cl� EXCIT contient plusieurs occurrences de type %(k1)s
 seule la derni�re sera prise en compte
"""),

46: _(u"""
 champ de temp�rature vide pour le num�ro d'ordre : %(i1)d
"""),

47: _(u"""
 champ FLUX_ELNO vide pour num�ro d'ordre :  %(i1)d
"""),

49: _(u"""
 erreurs donn�es composante inconnue  %(k1)s  pour la grandeur  %(k2)s
"""),








52: _(u"""
 Erreur Utilisateur :

 Variables internes initiales non coh�rentes (nombre sous-points) avec le comportement choisi.
 Pour la maille : %(k1)s
 nombre sous-points "k-1" :  %(i1)d
 nombre sous-points "k"   :  %(i2)d
"""),


54: _(u"""
 Probl�me d'utilisation du parall�lisme :
   Les fonctionnalit�s de parall�lisme utilis�es ici (calculs distribu�s) conduisent � cr�er
   des structures de donn�es "incompl�tes" (i.e. partiellement calcul�es sur chaque processeur).

   Malheureusement, dans la suite des traitements, le code a besoin que les structures de donn�es soient
   "compl�tes". On est donc oblig� d'arr�ter le calcul.

 Conseils pour l'utilisateur :
   1) Il faut �mettre une demande d'�volution du code pour que le calcul demand� aille � son terme.
   2) En attendant, il ne faut pas utiliser la "distribution" des structures de donn�e.
      Aujourd'hui, cela veut dire :
        - �viter de se retrouver avec une "partition" du mod�le dans la commande o� le probl�me a �t�
          d�tect�.
        - pour cela, juste avant l'appel � la commande probl�matique, il faut appeler la commande :
          MODI_MODELE(reuse=MO, MODELE=MO, PARTITION=_F(PARALLELISME='NON'))
"""),

55: _(u"""
 Probl�me d'utilisation du parall�lisme :
   On cherche � faire la combinaison lin�aire de plusieurs matrices. Certaines de ces matrices
   ne sont pas calcul�es compl�tement et d'autres le sont. On ne peut donc pas les combiner.

 Conseils pour l'utilisateur :
   1) Il faut �mettre une demande d'�volution du code pour que le calcul demand� aille � son terme.
      Aide pour le d�veloppeur : Noms de deux matrices incompatibles : %(k1)s  et %(k2)s
   2) En attendant, il ne faut pas utiliser la "distribution" des structures de donn�e.
      Aujourd'hui, cela veut dire :
        - �viter de se retrouver avec une "partition" du mod�le dans la commande o� le probl�me a �t�
          d�tect�.
        - pour cela, juste avant l'appel � la commande probl�matique, il faut appeler la commande :
          MODI_MODELE(reuse=MO, MODELE=MO, PARTITION=_F(PARALLELISME='NON'))
"""),


56: _(u"""
 Erreur d'utilisation (rcmaco/alfint) :
 Un des mat�riaux du CHAM_MATER %(k1)s contient un coefficient de dilatation ALPHA=f(TEMP).
 Mais la temp�rature de r�f�rence n'est pas fournie sous AFFE_MATERIAU/AFFE_VARC/VALE_REF

 Conseil :
 Renseignez la temp�rature de r�f�rence � l'aide de AFFE_MATERIAU/AFFE_VARC/NOM_VARC='TEMP' + VALE_REF
"""),

57: _(u"""
 Erreur d'utilisation (pr�paration des variables de commande) :
 Pour la variable de commande %(k1)s, il y a une incoh�rence du
 nombre de "sous-points" entre le CARA_ELEM %(k2)s
 et le CHAM_MATER %(k3)s.

 Conseil :
 N'avez-vous pas d�fini plusieurs CARA_ELEM conduisant � des nombres de
 "sous-points" diff�rents (COQUE_NCOU, TUYAU_NCOU, ...) ?
"""),

58: _(u"""
 Erreur de programmation :
 Pour la variable de commande %(k1)s, on cherche � utiliser la famille
 de points de Gauss '%(k2)s'.
 Mais cette famille n'est pas pr�vue dans la famille "liste" (MATER).

 Contexte de l'erreur :
    option       : %(k3)s
    type_�l�ment : %(k4)s

 Conseil :
 �mettez une fiche d'anomalie
"""),

59: _(u"""
 Erreur d'utilisation (pr�paration des variables de commande) :
 Dans le CHAM_MATER %(k1)s et pour la variable de commande %(k2)s,
 on a trouv� la composante 'TEMP_INF'.
 Cela veut sans doute dire que vous avez oubli� de "pr�parer"
 la variable de commande 'TEMP' avec   CREA_RESU / OPERATION='PREP_VRC2'
"""),

61:_(u"""
 Erreur de programmation (fointa) :
    Le type de la fonction est invalide : %(k1)s
"""),

62: _(u"""
 Erreur de programmation (fointa) :
    Pour l'interpolation de la fonction %(k1)s sur la maille %(k3)s,
    il manque le param�tre %(k2)s
"""),


63: _(u"""
 Erreur lors de l'interpolation (fointa) de la fonction %(k1)s :
 Code retour: %(i1)d
"""),

64: _(u"""
 Variables internes en nombre diff�rent aux instants '+' et '-' pour la maille %(k1)s
 Instant '-' : %(i1)d
 Instant '+' : %(i2)d
"""),

65: _(u"""
 Vous avez fourni %(i1)d charges alors qu'il n'y a %(i2)d dans la SD r�sultat.

 Risque & Conseil :
   Vous pouvez obtenir des r�sultats faux si les charges sont diff�rentes.
   V�rifiez que vous n'avez pas oubli� de charge ou que vous n'en avez pas ajout�.
"""),

66: _(u"""
 Le couple (charge, fonction) fourni par l'utilisateur n'est pas pr�sent dans la
 structure de donn�es r�sultat.
 On poursuit le calcul avec le chargement fourni par l'utilisateur.
   Charge   (utilisateur) : %(k1)s
   Fonction (utilisateur) : %(k2)s
   Charge   (r�sultat)    : %(k3)s
   Fonction (r�sultat)    : %(k4)s

"""),

67: _(u"""
 Erreur utilisateur :
   Un calcul �l�mentaire n�cessite une ou plusieurs variables de commande (CVRC).
   Sur la maille : %(k1)s, on ne trouve pas le bon nombre de "CVRC" :
   On attend : %(i2)d "CVRC",  mais on n'en trouve que : %(i1)d

 Conseil :
   V�rifier les occurrences de AFFE_MATERIAU/AFFE_VARC pour la maille concern�e.
"""),

68: _(u"""
 la liste des composantes fournies � NOCART est incorrecte.
 composantes dans catalogue:
"""),

69: _(u"""
   %(k1)s
"""),

70: _(u"""
 composantes dans EDITGD:
"""),

71: _(u"""
   %(k1)s
"""),

73: _(u"""
  Le jacobien est n�gatif.
"""),

74: _(u"""
 �l�ment  :  %(i1)d
 jacobien :  %(r1)f
 Attention, le calcul d'erreur est faux si la maille n'est pas correctement orient�e.
"""),

75: _(u"""
  Probl�me de parall�lisation des calculs �l�mentaires avec FETI.
  Incompatibilit� entre LIGRELs dans la routine CALCUL.

  Risques & conseils :
  Essayez de passer en s�quentiel ou de changer de solveur lin�aire.
"""),

76: _(u"""
  Probl�me de parall�lisation des calculs �l�mentaires avec FETI.
  Incompatibilit� LIGREL/num�ro de maille dans la routine CALCUL.

  Risques & conseils :
  Essayez de passer en s�quentiel ou de changer de solveur lin�aire.
"""),

77: _(u"""
Probl�me lors de la cr�ation du champ par �l�ments (%(k1)s).
  Ce champ est associ� au param�tre %(k3)s de l'option: '%(k2)s'
  Certaines valeurs fournies par l'utilisateur n'ont pas �t� recopi�es dans le champ final.

  Le probl�me a 2 causes possibles :
   * L'affectation est faite de fa�on trop "large", par exemple en utilisant le mot cl� TOUT='OUI'.
   * Certains �l�ments ne supportent pas l'affectation demand�e.

Risques et conseils :
  Si le probl�me se produit dans la commande CREA_CHAMP :
    * Il est conseill� de v�rifier le champ produit avec le mot cl� INFO=2.
    * Les mots cl�s OPTION et NOM_PARA peuvent avoir une influence sur le r�sultat.

"""),

78: _(u"""
  Probl�me lors du calcul de la pesanteur sur un �l�ment de "c�ble poulie" :
  Le chargement doit �tre d�clar� "suiveur".
  Il faut utiliser le mot cl� : EXCIT / TYPE_CHARGE='SUIV'
"""),


79: _(u"""
  Probl�me lors du calcul de l'option %(k1)s pour les �l�ments X-FEM :
  le champ produit est incomplet sur les �l�ments X-FEM.

  Risque & Conseils :
  Ce champ ne pourra pas �tre utilis� sur des �l�ments non X-FEM.
  Il vaut mieux utiliser les commandes de post-traitement sp�cifique
  POST_MAIL_XFEM et POST_CHAM_XFEM avant la commande CALC_CHAMP.
"""),

80 : _(u"""
  L'amortissement du MACR_ELEM %(k1)s n'a pas encore �t� calcul�.
 """),

81 : _(u"""
  Il manque des amortissements.
  """),

82: _(u"""
  Le groupe de noeuds %(k1)s n'appartient pas au maillage %(k2)s.
"""),

83 : _(u"""
  L'option %(k1)s n'est pas trait�e pour un r�sultat de type FOURIER_ELAS
(produit par MACRO_ELAS_MULT). Il faut faire apr�s MACRO_ELAS_MULT une
 recombinaison de Fourier par l'op�rateur COMB_FOURIER.
"""),

84: _(u"""
  Le mot-cl� MODELE est obligatoire quand RESULTAT est absent
"""),

85: _(u"""
  Param�tre %(k1)s inexistant dans la table.
"""),

86: _(u"""
  Objet %(k1)s inexistant.
"""),

87: _(u"""
  Objet %(k1)s non testable.
"""),

88: _(u"""
  La composante %(k1)s n'existe pas pour ce champ.
"""),

89: _(u"""
  Le champ %(k1)s est � valeurs de type %(k2)s et la valeur de r�f�rence de
  type %(k3)s.
"""),

90: _(u"""
  Le champ de type %(k1)s sont interdits.
"""),

91: _(u"""
  Le ddl %(k1)s n'existe pas dans la grandeur %(k2)s.
"""),

92: _(u"""
  On ne trouve pas le noeud %(k1)s.
"""),

93: _(u"""
  On ne trouve pas le ddl.
"""),

94: _(u"""
  Pas d'acc�s au r�sultat.
"""),

95: _(u"""
  Type de la valeur de r�f�rence incompatible avec le type des valeurs du champ.
"""),






97: _(u"""
  Mot-cl� POINT interdit pour le champ au noeud issu de %(k1)s � l'ordre %(i1)d:
    -> champ : %(k2)s %(k3)s
"""),

98: _(u"""
  Composante g�n�ralis�e non trouv�e.
"""),

99: _(u"""
  Pas d'acc�s au r�sultat g�n�ralis� %(k1)s
"""),

}
