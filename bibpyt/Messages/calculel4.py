#@ MODIF calculel4 Messages  DATE 01/03/2011   AUTEUR PELLET J.PELLET 
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

def _(x) : return x

cata_msg = {

1 : _("""
 Erreur utilisateur :
   Le cham_elem %(k1)s a des valeurs ind�finies.
 Conseils :
   * Si le probl�me concerne la commande CREA_CHAMP :
     1) Vous devriez imprimer le contenu du champ cr�� pour v�rifications (INFO=2)
     2) Vous devriez peut-etre utiliser le mot cl� PROL_ZERO='OUI'

"""),

2 : _("""
Erreur utilisateur dans la commande IMPR_RESU / RESTREINT :
  Les sd_resultat que l'on veut imprimer : %(k1)s, %(k2)s
  sont associ�es � des maillages diff�rents : %(k3)s, %(k4)s
  C'est interdit.
"""),

3 : _("""
Erreur utilisateur dans la commande IMPR_RESU / RESTREINT :
  Seul FORMAT='MED' est autoris�
"""),

4 : _("""
Erreur :
  On cherche � modifier le "type" (r�el(R), complexe(C), entier(I), fonction(K8)) d'un champ.
  C'est impossible.
  Types incrimin�s : %(k1)s et %(k2)s
Conseils :
  Il s'agit peut-etre d'une erreur de programmation.
  S'il s'agit de la commande CREA_CHAMP, v�rifiez le mot cl� TYPE_CHAM.

"""),

5 : _("""
Erreur utilisateur dans la commande IMPR_RESU / RESTREINT :
  Quand on utilise le mot cl� RESTREINT, le mot cl� RESULTAT est obligatoire
  pour chaque occurence du mot cl� facteur RESU

Conseil :
  On ne peut pas restreindre un champ "isol�".
  On ne traite que les sd_resultat.
  Il faut donc au pr�alable cr�er une sd_resultat avec CREA_RESU
"""),

6 : _("""
Erreur utilisateur (ou programmeur) :
 On veut imposer la num�rotation des ddls du cham_no %(k1)s
 avec le nume_ddl %(k2)s.
 Mais ces 2 structures de donn�es sont incompatibles.
 Par exemple :
    - ce n'est pas le meme maillage sous-jacent
    - ce n'est pas la meme grandeur sous-jacente.
"""),


8 : _("""
 le resultat  %(k1)s  n'existe pas
"""),

10 : _("""
 Erreur d'utilisation :
   On ne trouve pas de variables de commandes ('TEMP', 'HYDR', ...) :
   Option: %(k2)s  type_element: %(k3)s )

 Risques & conseils :
   La cause la plus fr�quente de cette erreur est d'avoir oubli� de
   renseigner AFFE_MATERIAU/AFFE_VARC.
   (Ou de n'avoir renseign� que AFFE_VARC/VALE_REF sans avoir renseign� EVOL ou CHAMP_GD)
"""),

11 : _("""
 Erreur d'utilisation lors de l'affectation des variables de commande (AFFE_MATERIAU/AFFE_VARC):
   Pour la variable de commande %(k1)s,
   Vous avez oubli� d'utiliser l'un des 2 mots cl�s CHAMP_GD ou EVOL.
   L'abscence de ces 2 mots cl�s n'est permise que pour NOM_VARC='TEMP' (mod�lisations THM)
"""),

12 : _("""
 Erreur de programmation (catalogue des �l�ments finis) :
 Les �l�ments finis ayant l'attribut VF_AVEC_VOISIN='OUI' ne peuvent cr�er que des
 matrices �l�mentaires non-sym�triques.
"""),

13 : _("""
 Erreur d'utilisation (AFFE_MATERIAU/AFFE_VARC) :
  Le maillage associ� au calcul (%(k1)s) est diff�rent de celui associ�
  aux champs (ou evol_xxxx) affect�s dans AFFE_MATERIAU/AFFE_VARC (%(k2)s).

 Conseil :
  Il faut corriger AFFE_MATERIAU.
"""),

14 : _("""
 Erreur d'utilisation (CREA_RESU/PREP_VRC.) :
  Le CARA_ELEM (%(k1)s) ne contient pas de "couches"

 Conseil :
  Le CARA_ELEM qu'il faut fournir � la commande CREA_RESU doit etre
  celui associ� au mod�le "m�canique".
"""),

15 : _("""
 Erreur d'utilisation (CREA_RESU/PREP_VRC.) :
   Le mod�le associ� au CARA_ELEM (%(k1)s) est diff�rent de celui fourni � la commande.
"""),




41 : _("""
 erreur_01
"""),

42 : _("""
 erreur_02
"""),

43 : _("""
 le nom_para n'existe pas
"""),

44 : _("""
 0 ligne trouvee pour le nom_para
"""),

45 : _("""
 plusieurs lignes trouvees
"""),

46 : _("""
 code retour de "tbliva" inconnu
"""),

47 : _("""
 type_resu inconnu:  %(k1)s
"""),

53 : _("""
 longueurs des modes locaux incompatibles entre eux.
"""),

54 : _("""
 aucuns noeuds sur lesquels projeter.
"""),

55 : _("""
 pas de mailles a projeter.
"""),

56 : _("""
  %(k1)s  pas trouve.
"""),

57 : _("""
 il n'y a pas de mailles a projeter.
"""),

58 : _("""
 les maillages a projeter sont ponctuels.
"""),

59 : _("""
Erreur utilisateur :
 Les maillages associ�s aux concepts %(k1)s et %(k2)s sont diff�rents : %(k3)s et %(k4)s.
"""),

60 : _("""
 maillages 2 differents.
"""),

61 : _("""
 probleme dans l'examen de  %(k1)s
"""),

62 : _("""
 aucun numero d'ordre dans  %(k1)s
"""),

63 : _("""
 On n'a pas pu projeter le champ %(k1)s de la sd_resultat %(k2)s
 vers la sd_resultat %(k3)s pour le num�ro d'ordre %(i1)d
"""),

64 : _("""
 Aucun champ projete.
"""),

65 : _("""
  maillages non identiques :  %(k1)s  et  %(k2)s
"""),

66 : _("""
 pas de chmate
"""),

67 : _("""
 erreur dans etanca pour le probleme primal
"""),

68 : _("""
 erreur dans etenca pour le probleme dual
"""),

69 : _("""
 Erreur utilisateur :
    On ne trouve pas la variable de commande :  %(k1)s
    pour la maille                : %(k2)s
    pour l'instant de calcul      : '%(k3)s'
    valeur de l'instant de calcul : %(r1)g  (sans signification pour l'instant 'REF')

 Conseils :
    Les variables de commande sont des variables connues a priori qui influencent
    le calcul du comportement m�canique (exemple : la temp�rature).

    Lorsque le comportement m�canique d�pend d'une variable de commande, il faut que l'utilisateur
    la fournisse au calcul m�canique.
    Cela se fait via la commande AFFE_MATERIAU / AFFE_VARC.

    Les variables de commande les plus utilis�es sont :
      'TEMP'  : la temp�rature
      'HYDR'  : l'hydratation
      'SECH'  : le s�chage
      'CORR'  : la corrosion
      'IRRA'  : l'irradiation

    Attention au fait que les variables de commandes doivent pouvoir etre calcul�es pour TOUS
    les instants du calcul. Pour cela, si on utilise une structure de donn�es evol_xxx pour
    renseigner une variable de commande (AFFE_MATERIAU/AFFE_VARC/EVOL), il faut faire attention
    � utiliser �ventuellement les mots cl�s PROL_GAUCHE et PROL_DROIT.
"""),

70 : _("""
Erreur utilisateur dans CREA_CHAMP :
  Vous avez demand� la cr�ation d'un champ '%(k1)s' (mot cl� TYPE_CHAM)
  Mais le code a cr�� un champ '%(k2)s'.
Conseil :
  Il faut sans doute modifier la valeur de TYPE_CHAM
"""),

71 : _("""
Erreur utilisateur dans CREA_CHAMP :
  Vous avez demand� la cr�ation d'un champ de %(k1)s (mot cl� TYPE_CHAM)
  Mais le code a cr�� un champ de %(k2)s.
Conseil :
  Il faut sans doute modifier la valeur de TYPE_CHAM
"""),






78 : _("""
Erreur utilisateur dans CREA_CHAMP :
  Le maillage associ� au champ cr�� par la commande (%(k1)s) est diff�rent
  de celui qui est fourni par l'utilisateur via les mots cl�s MAILLAGE ou MODELE (%(k2)s).
Conseil :
  Il faut v�rifier les mots cl�s MAILLAGE ou MODELE.
  Remarque : ces mots cl�s sont peut etre inutiles pour cette utilisation de CREA_CHAMP.
"""),

79 : _("""
 La grandeur :  %(k1)s  n'existe pas dans le catalogue des grandeurs.
"""),

80 : _("""
 le nom de la grandeur  %(k1)s  ne respecte pas le format xxxx_c
"""),

81 : _("""
 probleme dans le catalogue des grandeurs simples, la grandeur complexe %(k1)s
 ne possede pas le meme nombre de composantes que son homologue r�elle %(k2)s
"""),

82 : _("""
 Probleme dans le catalogue des grandeurs simples, la grandeur %(k1)s
 ne possede pas les memes champs que son homologue reelle %(k2)s
"""),

83 : _("""
 erreur: le calcul des contraintes ne fonctionne que pour le phenomene mecanique
"""),

84 : _("""
 erreur numeros des noeuds bords
"""),

85 : _("""
 erreur: les elements supportes sont tria3 ou tria6
"""),

86 : _("""
 erreur: les elements supportes sont quad4 ou quad8 ou quad9
"""),

87 : _("""
 maillage mixte tria-quad non supporte pour l estimateur zz2
"""),

88 : _("""
 erreur: les mailles supportees sont tria ou quad
"""),

89 : _("""
 Erreur: un element du maillage possede tous ses sommets sur une frontiere.
 Il faut au moins un sommet interne.
 Pour pouvoir utiliser ZZ2 il faut remailler le coin de telle facon que
 tous les trg aient au moins un sommet interieur.
"""),

91 : _("""
 On ne trouve pas de routine te0npq.
 npq doit etre compris entre 1 et 600 ici : npq = %(k1)s
"""),

92 : _("""
  relation :  %(k1)s  non implantee sur les poulies
"""),

93 : _("""
  deformation :  %(k1)s  non implantee sur les poulies
"""),

94 : _("""
 l'attribut:  %(k1)s  n'existe pas pour le type:  %(k2)s
"""),

95 : _("""
 Erreur de programmation ou d'utilisation :
   On ne trouve pas dans les arguments de la routine calcul de champ a associer
   au parametre: %(k1)s  (option: %(k2)s  type_element: %(k3)s )
"""),

96 : _("""
 Erreur de programmation :
 on n'a pas pu extraire toutes les cmps voulues du champ global associe
 au parametre: %(k1)s  (option: %(k2)s  type_element: %(k3)s )
"""),

97 : _("""
 TOUT = OUI obligatoire avec  %(k1)s
"""),

98 : _("""
 on n'a pas pu r�cup�rer le param�tre THETA dans le r�sultat  %(k1)s
 valeur prise pour THETA: 0.57
"""),

}
