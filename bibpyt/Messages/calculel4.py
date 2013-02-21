#@ MODIF calculel4 Messages  DATE 12/02/2013   AUTEUR PELLET J.PELLET 
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

1 : _(u"""
 Erreur utilisateur :
   Le CHAM_ELEM %(k1)s a des valeurs ind�finies.
 Conseils :
   * Si le probl�me concerne la commande CREA_CHAMP :
     1) Vous devriez imprimer le contenu du champ cr�� pour v�rifications (INFO=2) ;
     2) Vous devriez peut-�tre utiliser le mot cl� PROL_ZERO='OUI' .
"""),

2 : _(u"""
Erreur utilisateur dans la commande IMPR_RESU / RESTREINT :
  Les SD_RESULTAT que l'on veut imprimer : %(k1)s, %(k2)s
  sont associ�es � des maillages diff�rents : %(k3)s, %(k4)s
  C'est interdit.
"""),

3 : _(u"""
Erreur utilisateur dans la commande IMPR_RESU / RESTREINT :
  Seul FORMAT='MED' est autoris�.
"""),

4 : _(u"""
Erreur :
  On cherche � modifier le "type" (r�el(R), complexe(C), entier(I), fonction(K8)) d'un champ.
  C'est impossible.
  Types incrimin�s : %(k1)s et %(k2)s
Conseils :
  Il s'agit peut-�tre d'une erreur de programmation.
  S'il s'agit de la commande CREA_CHAMP, v�rifiez le mot cl� TYPE_CHAM.

"""),

5 : _(u"""
Erreur utilisateur dans la commande IMPR_RESU / RESTREINT :
  Quand on utilise le mot cl� RESTREINT, le mot cl� RESULTAT est obligatoire
  pour chaque occurrence du mot cl� facteur RESU

Conseil :
  On ne peut pas restreindre un champ "isol�".
  On ne traite que les SD_RESULTAT.
  Il faut donc au pr�alable cr�er une SD_RESULTAT avec CREA_RESU
"""),

6 : _(u"""
Erreur utilisateur (ou programmeur) :
 On veut imposer la num�rotation des ddls du CHAM_NO %(k1)s
 avec le NUME_DDL %(k2)s.
 Mais ces 2 structures de donn�es sont incompatibles.
 Par exemple :
    - ce n'est pas le m�me maillage sous-jacent
    - ce n'est pas la m�me grandeur sous-jacente.
"""),

7 : _(u"""
 La restriction du champ %(k1)s n'a pas �t� possible � tous les num�ros
 d'ordre. Il ne sera donc pas imprim� dans le fichier MED.
 Cela peut se produire lorsque le mot-cl� RESTREINT est utilis�
 et que le champ n'existe pas sur les entit�s g�om�triques sur
 lesquelles on tente de le restreindre.
"""),

8 : _(u"""
 Le r�sultat %(k1)s n'existe pas.
"""),

9 : _(u"""
Probl�me lors de la projection d'un champ aux noeuds de la grandeur (%(k1)s) sur un autre maillage.
 Pour le noeud "2" %(k2)s (et pour la composante %(k3)s) la somme des coefficients de pond�ration
 des noeuds de la maille "1" en vis � vis est tr�s faible (inf�rieure � 1.e-3).

 Cela peut arriver par exemple quand le champ � projeter ne porte pas la composante sur
 tous les noeuds de la maille "1" et que le noeud "2"  sur lequel on cherche � projeter
 se trouve tout pr�s d'un noeud "1" qui ne porte pas la composante.
 Quand cela arrive, la projection est impr�cise sur le noeud.

Risques et conseils :
 Si le champ � projeter a des composantes qui n'existent que sur les noeuds sommets des �l�ments,
 on peut faire une double projection en passant par un maillage interm�diaire lin�aire.
"""),

10 : _(u"""
 Erreur d'utilisation :
   On ne trouve pas de variables de commandes ('TEMP', 'HYDR', ...) :
   Option: %(k2)s  type_�l�ment: %(k3)s )

 Risques & conseils :
   La cause la plus fr�quente de cette erreur est d'avoir oubli� de
   renseigner AFFE_MATERIAU/AFFE_VARC.
   (Ou de n'avoir renseign� que AFFE_VARC/VALE_REF sans avoir renseign� EVOL ou CHAMP_GD)
"""),

11 : _(u"""
 Erreur d'utilisation lors de l'affectation des variables de commande (AFFE_MATERIAU/AFFE_VARC):
   Pour la variable de commande %(k1)s,
   Vous avez oubli� d'utiliser l'un des 2 mots cl�s CHAMP_GD ou EVOL.
   L'absence de ces 2 mots cl�s n'est permise que pour NOM_VARC='TEMP' (mod�lisations THM)
"""),

12 : _(u"""
 Erreur de programmation (catalogue des �l�ments finis) :
 Les �l�ments finis ayant l'attribut VF_AVEC_VOISIN='OUI' ne peuvent cr�er que des
 matrices �l�mentaires non-sym�triques.
"""),

13 : _(u"""
 Erreur d'utilisation (AFFE_MATERIAU/AFFE_VARC) :
  Le maillage associ� au calcul (%(k1)s) est diff�rent de celui associ�
  aux champs (ou EVOL_XXXX) affect�s dans AFFE_MATERIAU/AFFE_VARC (%(k2)s).

 Conseil :
  Il faut corriger AFFE_MATERIAU.
"""),

14 : _(u"""
 Erreur d'utilisation de la commande CREA_RESU / PREP_VRC[1|2] :
    Le CARA_ELEM (%(k1)s) ne contient pas d'�l�ments � "couches"
 Il n'y a aucune raison d'utiliser l'option PREP_VRC[1|2]
"""),

15 : _(u"""
 Erreur d'utilisation (CREA_RESU/PREP_VRC.) :
   Le mod�le associ� au CARA_ELEM (%(k1)s) est diff�rent de celui fourni � la commande.
"""),

16 : _(u"""
 Erreur d'utilisation :
   L'option %(k1)s est n�cessaire pour le calcul de l'option %(k2)s.
   Or %(k1)s est un champ qui ne contient que des sous-points, ce cas n'est pas trait�.
   Vous devez d'abord extraire %(k1)s sur un sous-point avec la commande POST_CHAMP.
"""),










21 : _(u"""
 Erreur utilisateur :
   La commande CREA_RESU / ASSE concat�ne des structures de donn�es r�sultat.
   Mais il faut que les instants cons�cutifs soient croissants (en tenant compte de TRANSLATION).
   Ce n'est pas le cas ici pour les instants : %(r1)f  et %(r2)f
"""),

22 : _(u"""
 Information utilisateur :
   La commande CREA_RESU / ASSE concat�ne des structures de donn�es r�sultat.
   Mais il faut que les instants cons�cutifs soient croissants (en tenant compte de TRANSLATION).
   Ici, l'instant %(r1)f  est affect� plusieurs fois.
   Pour cet instant, les champs sont �cras�s.
"""),

23 : _(u"""
 Erreur utilisateur :
   Incoh�rence du MODELE et du CHAM_MATER :
     Le MODELE de calcul est associ� au maillage %(k1)s
     Le CHAM_MATER de calcul est associ� au maillage %(k2)s
"""),

24 : _(u"""
 Alarme utilisateur :
   IMPR_RESU / CONCEPT / FORMAT='MED'
     Le format MED n'accepte pas plus de 80 composantes pour un champ.
     Le champ %(k1)s ayant plus de 80 composantes, on n'imprime
     que les 80 premi�res.
"""),










43 : _(u"""
 le NOM_PARA n'existe pas
"""),

44 : _(u"""
 0 ligne trouv�e pour le NOM_PARA
"""),

45 : _(u"""
 plusieurs lignes trouv�es
"""),

46 : _(u"""
 code retour de "tbliva" inconnu
"""),

47 : _(u"""
 TYPE_RESU inconnu:  %(k1)s
"""),

53 : _(u"""
 longueurs des modes locaux incompatibles entre eux.
"""),

54 : _(u"""
 aucuns noeuds sur lesquels projeter.
"""),

55 : _(u"""
 pas de mailles a projeter.
"""),

56 : _(u"""
  %(k1)s  pas trouve.
"""),

57 : _(u"""
 il n'y a pas de mailles a projeter.
"""),

58 : _(u"""
 les maillages a projeter sont ponctuels.
"""),

59 : _(u"""
Erreur utilisateur :
 Les maillages associ�s aux concepts %(k1)s et %(k2)s sont diff�rents : %(k3)s et %(k4)s.
"""),

60 : _(u"""
 maillages 2 diff�rents.
"""),

61 : _(u"""
 probl�me dans l'examen de  %(k1)s
"""),

62 : _(u"""
 aucun num�ro d'ordre dans  %(k1)s
"""),

63 : _(u"""
 On n'a pas pu projeter le champ %(k1)s de la SD_RESULTAT %(k2)s
 vers la SD_RESULTAT %(k3)s pour le num�ro d'ordre %(i1)d
"""),

64 : _(u"""
 Aucun champ projet�.
"""),

65 : _(u"""
  maillages non identiques :  %(k1)s  et  %(k2)s
"""),

66 : _(u"""
 pas de champ de mat�riau
"""),

67 : _(u"""
 erreur dans etanca pour le probl�me primal
"""),

68 : _(u"""
 erreur dans etenca pour le probl�me dual
"""),

69 : _(u"""
 Erreur utilisateur :
    On ne trouve pas la variable de commande :  %(k1)s
    pour la maille                : %(k2)s
    pour l'instant de calcul      : '%(k3)s'

 Conseils :
    Les variables de commande sont des variables connues a priori qui influencent
    le calcul du comportement des mat�riaux (exemple : la temp�rature).

    Lorsque le comportement m�canique d�pend d'une variable de commande, il faut que l'utilisateur
    la fournisse au calcul.
    Cela se fait via la commande AFFE_MATERIAU / AFFE_VARC.

    Les variables de commande les plus utilis�es sont :
      'TEMP'  : la temp�rature
      'HYDR'  : l'hydratation
      'SECH'  : le s�chage
      'CORR'  : la corrosion
      'IRRA'  : l'irradiation

    Attention au fait que les variables de commandes doivent pouvoir �tre calcul�es pour TOUS
    les instants du calcul. Pour cela, si on utilise une structure de donn�es EVOL_XXX pour
    renseigner une variable de commande (AFFE_MATERIAU/AFFE_VARC/EVOL), il faut faire attention
    � utiliser �ventuellement les mots cl�s PROL_GAUCHE et PROL_DROIT.
"""),

70 : _(u"""
Erreur utilisateur dans CREA_CHAMP :
  Vous avez demand� la cr�ation d'un champ '%(k1)s' (mot cl� TYPE_CHAM)
  Mais le code a cr�� un champ '%(k2)s'.
Conseil :
  Il faut sans doute modifier la valeur de TYPE_CHAM
"""),

71 : _(u"""
Erreur utilisateur dans CREA_CHAMP :
  Vous avez demand� la cr�ation d'un champ de %(k1)s (mot cl� TYPE_CHAM)
  Mais le code a cr�� un champ de %(k2)s.
Conseil :
  Il faut sans doute modifier la valeur de TYPE_CHAM
"""),

72 : _(u"""
Erreur utilisateur dans la commande PROJ_CHAMP :
 Le mot cl� MODELE_2 a �t� utilis�. Le maillage associ� � ce mod�le (%(k1)s)
 est diff�rent du maillage "2" (%(k1)s)  qui a servi � fabriquer la matrice de projection.
"""),

73 : _(u"""
Erreur utilisateur dans la commande PROJ_CHAMP :
   On veut projeter des champs aux �l�ments (CHAM_ELEM), le mot cl� MODELE_2
   est alors obligatoire.
"""),





78 : _(u"""
Erreur utilisateur dans CREA_CHAMP :
  Le maillage associ� au champ cr�� par la commande (%(k1)s) est diff�rent
  de celui qui est fourni par l'utilisateur via les mots cl�s MAILLAGE ou MODELE (%(k2)s).
Conseil :
  Il faut v�rifier les mots cl�s MAILLAGE ou MODELE.
  Remarque : ces mots cl�s sont peut �tre inutiles pour cette utilisation de CREA_CHAMP.
"""),

79 : _(u"""
 La grandeur :  %(k1)s  n'existe pas dans le catalogue des grandeurs.
"""),

80 : _(u"""
 le nom de la grandeur  %(k1)s  ne respecte pas le format XXXX_c
"""),

81 : _(u"""
 probl�me dans le catalogue des grandeurs simples, la grandeur complexe %(k1)s
 ne poss�de pas le m�me nombre de composantes que son homologue r�elle %(k2)s
"""),

82 : _(u"""
 Probl�me dans le catalogue des grandeurs simples, la grandeur %(k1)s
 ne poss�de pas les m�mes champs que son homologue r�elle %(k2)s
"""),

83 : _(u"""
 erreur: le calcul des contraintes ne fonctionne que pour le ph�nom�ne m�canique
"""),

84 : _(u"""
 erreur num�ros des noeuds bords
"""),

85 : _(u"""
 erreur: les �l�ments supportes sont tria3 ou tria6
"""),

86 : _(u"""
 erreur: les �l�ments supportes sont QUAD4 ou QUAD8 ou QUAD9
"""),

87 : _(u"""
 maillage mixte TRIA-QUAD non supporte pour l estimateur ZZ2
"""),

88 : _(u"""
 erreur: les mailles support�es sont tria ou QUAD
"""),

89 : _(u"""
 Erreur: un �l�ment du maillage poss�de tous ses sommets sur une fronti�re.
 Il faut au moins un sommet interne.
 Pour pouvoir utiliser ZZ2 il faut remailler le coin de telle fa�on que
 tous les triangles aient au moins un sommet int�rieur.
"""),

91 : _(u"""
 On ne trouve pas de routine te0NPQ.
 NPQ doit �tre compris entre 1 et 600 ici : NPQ = %(k1)s
"""),

92 : _(u"""
  relation :  %(k1)s  non implant�e sur les poulies
"""),

93 : _(u"""
  d�formation :  %(k1)s  non implant�e sur les poulies
"""),

94 : _(u"""
 l'attribut:  %(k1)s  n'existe pas pour le type:  %(k2)s
"""),

95 : _(u"""
 Erreur de programmation ou d'utilisation :
   On ne trouve pas dans les arguments de la routine calcul de champ a associer
   au param�tre: %(k1)s  (option: %(k2)s  type_�l�ment: %(k3)s )
"""),

96 : _(u"""
 Erreur de programmation :
 on n'a pas pu extraire toutes les composantes voulues du champ global associe
 au param�tre: %(k1)s  (option: %(k2)s  type_�l�ment: %(k3)s )
"""),

98 : _(u"""
 on n'a pas pu r�cup�rer le param�tre THETA dans le r�sultat  %(k1)s
 valeur prise pour THETA: 0.57
"""),

}
