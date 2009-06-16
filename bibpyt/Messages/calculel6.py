#@ MODIF calculel6 Messages  DATE 16/06/2009   AUTEUR PELLET J.PELLET 
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
Erreur utilisateur (dans la commande AFFE_MATERIAU) :
  Dans le CHAM_MATER %(k1)s, vous avez affect� le mat�riau %(k2)s.
  Dans ce mat�riau, il existe un coefficient de dilatation (ELAS/ALPHA)
  qui est une fonction de la temp�rature.
  Pour pouvoir utiliser cette fonction, il est n�cessaire de transformer
  cette fonction (changement de rep�re : TEMP_DEF_ALPHA -> TEMP_REF).
  Pour cela, l'utilisateur doit fournir une temp�rature de r�f�rence.

Solution :
  V�rifier que les mailles affect�es par le mat�riau %(k2)s sont bien
  toutes affect�es par une temp�rature de r�f�rence
  (AFFE/TEMP_REF ou AFFE_VARC/NOM_VARC='TEMP',VALE_REF).
"""),



10: _("""
  Option inconnue %(k1)s
"""),

11: _("""
  Erreur d'utilisation :
    Vous avez d�pass� une des limites de la programmation concernant les champs de mat�riaux :
    On ne pas utiliser plus de 9999 mat�riaux diff�rents
"""),

13: _("""
 interpolation d�formations an�lastiques :
 evol_noli: %(k1)s
 instant  : %(r1)f
 icoret   : %(i1)d
"""),

15: _("""
  l'element diagonal u( %(i1)d , %(i2)d ) de la factorisation est nul. %(k1)s
  la solution et les estimations d' erreurs ne peuvent etre calculees. %(k2)s
"""),

17: _("""
 recherche nbre de cmp: erreur:  %(k1)s grandeur numero  %(i1)d  de nom  %(k2)s
"""),

20: _("""
 recherche nbre de cmp: erreur: grandeur ligne numero  %(i1)d  de nom  %(k1)s
 grandeur colonne numero  %(i2)d
  de nom  %(k2)s
 grandeur mere numero  %(i3)d
  de nom  %(k3)s
"""),

21: _("""
 recherche nbre de cmp: erreur: grandeur %(i1)d a un code inconnu:  %(i2)d
"""),

22: _("""
 recherche nbre d entiers codes  %(k1)s grandeur numero  %(i1)d  de nom  %(k2)s
"""),

25: _("""
 recherche nbre d entiers codes grandeur ligne numero  %(i1)d  de nom  %(k1)s
 grandeur colonne numero  %(i2)d de nom  %(k2)s
 grandeur mere numero  %(i3)d de nom  %(k3)s
"""),

26: _("""
 recherche nbre d entiers codes grandeur %(i1)d a un code inconnu:  %(i2)d
"""),


42: _("""
 La prise en compte de l'erreur sur une condition aux limites
 de type ECHANGE_PAROI n'a pas �t� encore implant�e
"""),

43: _("""
 le mot cle EXCIT contient plusieurs occurences de type %(k1)s
 seule la derni�re sera prise en compte
"""),

46: _("""
 champ de temp�rature vide pour le num�ro d'ordre : %(i1)d
"""),

47: _("""
 champ FLUX_ELNO_TEMP vide pour num�ro d'ordre :  %(i1)d
"""),

49: _("""
 erreurs donn�es composante inconnue  %(k1)s  pour la grandeur  %(k2)s
"""),

50: _("""
 Pr�paration des variables de commande :
 Dans le CHAM_MATER %(k1)s et pour la variable de commande %(k2)s,
 on ignore la composante %(k3)s
"""),

51: _("""
 erreurs donnees composante inconnue  %(k1)s
"""),

52: _("""
 Erreur Utilisateur :

 Variables internes initiales non coh�rentes (nb sous-points) avec le comportement choisi.
 Pour la maille : %(k1)s
 nb sous-points "k-1" :  %(i1)d
 nb sous-points "k"   :  %(i2)d
"""),

53: _("""
 Erreur utilisateur :
   On cherche � "poursuivre" un calcul non lin�aire mais les variables internes de l'�tat
   initial ne sont pas compatibles avec le comportement choisi pour la suite du calcul.
   Pour la maille  : %(k1)s
     Nombre de variables pour l'�tat initial         :  %(i1)d
     Nombre de variables attendu par le comportement :  %(i2)d

 Risques & conseils :
   V�rifier que vous n'avez pas chang� de relation de comportement (mot cl� RELATION).
"""),

54: _("""
 Probl�me d'utilisation du parall�lisme :
   Les fonctionnalit�s de parall�lisme utilis�es ici (calculs distribu�s) conduisent � cr�er
   des structures de donn�es "incompl�tes" (i.e. partiellement calcul�es sur chaque processeur).

   Malheureusement, dans la suite des traitements, le code a besoin que les structures de donn�es soient
   "compl�tes". On est donc oblig� d'arreter le calcul.

 Conseils pour l'utilisateur :
   1) Il faut �mettre une demande d'�volution du code pour que le calcul demand� aille � son terme.
   2) En attendant, il ne faut pas utiliser la "distribution" des structures de donn�e.
      Aujourd'hui, cela veut dire :
        - �viter de se retrouver avec une "partition" du mod�le dans la commande o� le probl�me a �t�
          d�tect�.
        - pour cela, juste avant l'appel � la commande probl�matique, il faut appeler la commande :
          MODI_MODELE(reuse=MO, MODELE=MO, PARTITION=_F(PARALLELISME='NON'))
"""),

55: _("""
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


56: _("""
 Erreur d'utilisation (rcmaco/alfint) :
 Un des mat�riaux du CHAM_MATER %(k1)s contient un coefficient de dilation ALPHA=f(TEMP).
 Mais la temp�rature de r�f�rence n'est pas fournie sous AFFE_MATERIAU/AFFE_VARC/VALE_REF

 Conseil :
 Renseignez la temp�rature de r�f�rence � l'aide de AFFE_MATERIAU/AFFE_VARC/NOM_VARC='TEMP' + VALE_REF
"""),

57: _("""
 Erreur d'utilisation (pr�paration des variables de commande) :
 Pour la variable de commande %(k1)s, il y a une incoh�rence du
 nombre de "sous-points" entre le CARA_ELEM %(k2)s
 et le CHAM_MATER %(k3)s.

 Conseil :
 N'avez-vous pas d�fini plusieurs CARA_ELEM conduisant � des nombres de
 "sous-points" diff�rents (COQUE_NCOU, TUYAU_NCOU, ...) ?
"""),

58: _("""
 Erreur de programmation :
 Pour la variable de commande %(k1)s, on cherche � utiliser la famille
 de points de Gauss '%(k2)s'.
 Mais cette famille n'est pas pr�vue dans la famille "liste" (MATER).

 Contexte de l'erreur :
    option       : %(k3)s
    type_element : %(k4)s

 Conseil :
 Emettez une fiche d'anomalie
"""),

59: _("""
 Erreur d'utilisation (pr�paration des variables de commande) :
 Dans le CHAM_MATER %(k1)s et pour la variable de commande %(k2)s,
 on a trouv� la composante 'TEMP_INF'.
 Cela veut sans doute dire que vous avez oubli� de "pr�parer"
 la variable de commande 'TEMP' avec   CREA_RESU / OPERATION='PREP_VRC2'
"""),

60: _("""
 Erreur d'utilisation (pr�paration des variables de commande) :
 Dans le CHAM_MATER %(k1)s et pour la variable de commande %(k2)s,
 la liste donn�e pour le mot cl� VALE_REF n'a pas la bonne longueur.
"""),


61:_("""
 Erreur de programmation (fointa) :
    Le type de la fonction est invalide : %(k1)s
"""),

62: _("""
 Erreur de programmation (fointa) :
    Pour l'interpolation de la fonction %(k1)s sur la maille %(k3)s,
    il manque le param�tre %(k2)s
"""),


63: _("""
 Erreur lors de l'interpolation (fointa) de la fonction %(k1)s :
 Code retour: %(i1)d
"""),

64: _("""
 Variables internes en nombre diff�rent aux instants '+' et '-' pour la maille %(k1)s
 Instant '-' : %(i1)d
 Instant '+' : %(i2)d
"""),

65: _("""
 Le nombre de charges fourni par l'utilisateur %(i1)d est diff�rent du
 nombre de charges trouv�es dans la SD_resultat %(i2)d
"""),

66: _("""
 Le couple (charge-fonction) fourni par l'utilisateur n'est pas pr�sent dans la SD_resultat.
 On poursuit le calcul avec le chargement fourni par l'utilisateur.
   Charge   (utilisateur) : %(k1)s
   Fonction (utilisateur) : %(k2)s
   Charge   (SD_resultat) : %(k3)s
   Fonction (SD_resultat) : %(k4)s

"""),

67: _("""
 Erreur utilisateur :
   Un calcul �l�mentaire n�cessite une ou plusieurs variables de commande (CVRC).
   Sur la maille : %(k1)s, on ne trouve pas le bon nombre de "CVRC" :
   On attend : %(i2)d "CVRC",  mais on n'en trouve que : %(i1)d

 Conseil :
   V�rifier les occurences de AFFE_MATERIAU/AFFE_VARC pour la maille concern�e.
"""),

68: _("""
 la liste des composantes fournies � NOCART est incorrecte.
 composantes dans catalogue:
"""),

69: _("""
   %(k1)s
"""),

70: _("""
 composantes dans EDITGD:
"""),

71: _("""
   %(k1)s
"""),

72: _("""

"""),

73: _("""
 ! jacobien negatif en 3d !
"""),

74: _("""
 �l�ment  :  %(i1)d
 jacobien :  %(r1)f
 attention le calcul d'erreur est faux si la maille n est pas correctement orient�e
"""),

75: _("""
 Probleme de parall�lisation des calculs �l�mentaires avec FETI. Imcompatiblit�
 entre LIGRELs dans la routine CALCUL.
--> Risques & conseils :
 Essayer de passer en s�quentiel ou de changer de solveur lin�aire.
"""),

76: _("""
 Probl�me de parall�lisation des calculs �l�mentaires avec FETI. Imcompatiblit�
 LIGREL/num�ro de maille dans la routine CALCUL.
--> Risques & conseils :
 Essayer de passer en s�quentiel ou de changer de solveur lin�aire.
"""),

77: _("""
 probl�me lors de l'affectation du champ: %(k1)s
 des valeurs n'ont pas ete recopi�es dans le CHAM_ELEM final (perte d'information ?)
 ce probl�me peut �tre du a l'utilisation du mot cle TOUT='OUI'.
 on peut v�rifier le champ produit avec info=2

"""),

79: _("""
 Probl�me lors du calcul de l'option %(k1)s pour les �l�ments X-FEM :
 le champ produit est incomplet sur les �l�ments X-FEM.
--> Risque : ce champ ne pourra �tre utilis� sur des �l�ments non X-FEM.
--> Conseils : il vaut mieux utiliser les commandes de post-traitement
sp�cifique POST_MAIL_XFEM et POST_CHAM_XFEM avant le CALC_ELEM.
"""),

80 : _("""
 l'amortissement du MACR_ELEM : %(k1)s  n'a pas encore ete calcul�.
 """),

81 : _("""
  il manque des amortissements.
  """),

}
