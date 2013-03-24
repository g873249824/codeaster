#@ MODIF algeline2 Messages  DATE 19/03/2013   AUTEUR BRIE N.BRIE 
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
 L'argument de "BLOC_DEBUT" doit �tre strictement positif,
 il est pris � 1
"""),

2 : _(u"""
 Calcul des modes en eau au repos :
 une des valeurs propres de la matrice n'est pas r�elle
"""),

3 : _(u"""
 Calcul des modes en eau au repos :
 une des valeurs propres obtenues est nulle
"""),

4 : _(u"""
 Erreur sur la recherche des multiplicateurs de Lagrange
"""),

5 : _(u"""
 mot-cl� facteur incorrect
"""),

6 : _(u"""
 Type de matrice " %(k1)s " inconnu.
"""),

7 : _(u"""
 On ne traite pas cette option
"""),

8 : _(u"""
 L'argument de "BLOC_FIN" est plus grand que le nombre de blocs de la matrice,
 il est ramen� � cette valeur
"""),

9 : _(u"""
 Les matrices � combiner ne sont pas construites sur le m�me maillage.
"""),

10 : _(u"""
 Erreur de programmation :
 On cherche � combiner 2 matrices qui n'ont pas les m�mes charges cin�matiques.
 Noms des 2 matrices :
    %(k1)s
    %(k2)s

 Solution :
    1) �mettre une fiche d'anomalie / �volution
    2) En attendant : ne pas utiliser de charges cin�matiques :
       remplacer AFFE_CHAR_CINE par AFFE_CHAR_MECA
"""),

11 : _(u"""
 Les matrices "%(k1)s"  et  "%(k2)s"  n'ont pas la m�me structure.
"""),

12 : _(u"""
 R�solution syst�me lin�aire m�thode de Crout.
 Attention: une dimension nulle ou nmax.lt.dmax(1,n)
"""),

13 : _(u"""
 R�solution syst�me lin�aire m�thode de Crout.
 Attention: une dimension n�gative ou nulle
"""),

14 : _(u"""
 R�solution syst�me lin�aire m�thode de Crout.
 Attention: les dimensions des tableaux ne sont pas correctes
"""),

15 : _(u"""
 Pas de charge critique  dans l'intervalle demand�
"""),

16 : _(u"""
  %(k1)s charges critiques  dans l'intervalle demand�
"""),

17 : _(u"""
 Au moins une valeur propre calcul�e est en dehors de la bande demand�e.
 Ces valeurs propres ext�rieures n'appara�tront pas dans le r�sultat de l'op�rateur.
"""),

18 : _(u"""
 Les matrices " %(k1)s " et " %(k2)s " n'ont pas le m�me domaine de d�finition
"""),

19 : _(u"""
 Probl�mes a l'allocation des descripteurs de la matrice " %(k1)s "
"""),

20 : _(u"""
 L'argument de "BLOC_DEBUT" est plus grand que le nombre de blocs de la matrice
"""),

21 : _(u"""
 L'argument de "BLOC_FIN" doit �tre strictement positif
"""),



23 : _(u"""
 On a rencontr� un probl�me � la lecture de la table %(k1)s.
 
 --> Conseil:
 V�rifiez que cette carte a bien �t� g�n�r�e pr�c�demment par un appel � INFO_MODE.
"""),

24 : _(u"""
 On a rencontr� un probl�me � la lecture de la table %(k1)s. Elle ne comporte aucune ligne
 dont les bornes sont strictement comprises entre les valeurs de la bande de test:
                                    [ %(r1)f , %(r2)f ]
 
 --> Conseil:
 V�rifiez le contenu de la table via un IMPR_TABLE et modifiez les bornes de l'option BANDE
 en cons�quence.
  
 Au pire, relancez votre calcul sans sp�cifier de nom de table. L'op�rateur effectuera alors
 l'�tape compl�te de pr�traitement de mani�re transparente.
 Mais le calcul sera un peu plus co�teux puisqu'il ne mutualisera pas cette �tape commune avec
 INFO_MODE.
"""),

25 : _(u"""
 On a rencontr� un probl�me � la lecture de la table %(k1)s. Elle comporte des trous ou des
 recouvrements par  rapport aux bornes choisies. Le solveur modal risque donc de pas calculer
 strictement tous les modes requis.
 
 --> Conseil:
 V�rifiez le contenu de la table via un IMPR_TABLE.

 Modifiez �ventuellement la valeur par d�faut du param�tre VERI_MODE/PREC_SHIFT. Elle d�termine
 l'�cartement entre les bornes de la bande de test et celles de la bande recherch�e.


 Au pire, relancez votre calcul sans sp�cifier de nom de table. L'op�rateur effectuera alors
 l'�tape compl�te de pr�traitement de mani�re transparente.
 Mais le calcul sera un plus co�teux puisqu'il ne mutualisera pas cette �tape commune avec
 INFO_MODE.
"""),

26 : _(u"""
 Attention, la bande s�lectionn�e dans la table %(k1)s comporte au moins une de ses bornes l�g�rement
 d�cal�e. Ce d�calage a �t� op�r� afin de ne pas perturber la m�thode de comptage (m�thode de
 Sturm). Il a �t� effectu� en se basant sur la param�trage (NMAX_ITER_SHIFT/PREC_SHIFT/SEUIL_**)
 de l'op�rateur INFO_MODE qui a g�n�rer la TABLE.
"""),

27 : _(u"""
 Op�rateur INFO_MODE + COMPTAGE/METHODE='AUTO'.
 Compte-tenu des propri�t�s des matrices fournies (nombre, type, sym�trie), on a choisi pour vous la
 m�thode de comptage: %(k1)s.
"""),

28 : _(u"""
 les "MATR_ASSE" %(k1)s "  et  " %(k2)s "  ne sont pas combinables.
"""),




31 : _(u"""
 Cas TYPE_MODE='GENERAL'.
 Compte-tenu des propri�t�s des matrices fournies (type, sym�trie), on bascule automatiquement
 en mode de fonctionnement : %(k1)s.
"""),

33 : _(u"""
 Type de mode inconnu :  %(k1)s.
 Les modes donn�s en entr�e doivent �tre de type MODE_MECA, MODE_MECA_C OU MODE_FLAMB.
"""),

34 : _(u"""
 Il n'est pas permis de modifier un objet p�re
"""),

35 : _(u"""
 Mode non calcul� � partir de matrices assembl�es
"""),

36 : _(u"""
 Normalisation impossible, le noeud n'est pas pr�sent dans le mod�le.
"""),

37 : _(u"""
 Normalisation impossible, la composante n'est pas pr�sente dans le mod�le.
"""),

38 : _(u"""
 Il manque des param�tres de type entier.
"""),

39 : _(u"""
 Il manque des param�tres de type r�el.
"""),

40 : _(u"""
 IL manque des param�tres de type caract�re.
"""),

41 : _(u"""
 Normalisation impossible : aucune composante n'est pr�sente dans le mod�le.
"""),



43 : _(u"""
 on ne tient pas compte du mot-cl� facteur MODE_SIGNE pour une base modale de type MODE_MECA_C.
"""),

44 : _(u"""
 " %(k1)s "  type de mode non trait�
"""),



46 : _(u"""
 Le calcul de flambement ne peut pas �tre men� pour un probl�me avec une matrice %(k1)s complexe.
"""),






52 : _(u"""
 Avec l'option %(k1)s, il faut au moins deux valeurs sous le mot-cl� %(k2)s.
"""),





55 : _(u"""
 Pour un probl�me g�n�ralis�, le mot-cl� AMOR_REDUIT ne peut pas �tre utilis�.
"""),

56 : _(u"""
 Pour un probl�me quadratique, si le mot-cl� AMOR_REDUIT est pr�sent,
 seule l'option 'PROCHE' est utilisable.
"""),

57 : _(u"""
 Le mot-cl� AMOR_REDUIT �tant pr�sent, le nombre de valeurs renseign�es sous ce mot-cl�
 doit �tre le m�me que celui sous le mot-cl� FREQ.
"""),

58 : _(u"""
 Les matrices "%(k1)s" et "%(k2)s" ne sont pas compatibles entre elles.
 
 --> Conseil : v�rifier la mani�re dont elles sont construites
 (elles doivent notamment reposer sur le m�me maillage, �tre calcul�es avec les m�mes conditions aux limites,
 avoir la m�me num�rotation de DDL, avoir les m�mes propri�t�s de (non) sym�trie, ...).
"""),

59 : _(u"""
 pr�sence de fr�quences n�gatives dans les donn�es.
"""),

62 : _(u"""
 pas de valeurs propres dans la bande de calcul, le concept ne peut donc pas �tre cr��.
"""),



64 : _(u"""
 La valeur de PARAM_ORTHO_SOREN n'est pas valide.
 Elle doit �tre dans l'intervalle [1,2*epsilon ; 0,83-epsilon]
 o� epsilon est la pr�cision machine.
"""),

65 : _(u"""
 La d�tection des modes de corps rigide (demand�e avec OPTION='MODE_RIGIDE')
 est utilisable uniquement avec la m�thode 'TRI_DIAG'.
"""),

66 : _(u"""
 L'option 'BANDE' n'est pas autoris�e pour un probl�me avec amortissement
 (%(k1)s complexe et/ou pr�sence du mot-cl� %(k2)s).
 
 -> Conseil :
 utiliser l'option 'CENTRE'.
"""),

67 : _(u"""
 L'approche imaginaire ou complexe n'est pas compatible avec une borne inf�rieure nulle de l'intervalle de recherche
 (par exemple, si l'option 'PLUS_PETITE' est utilis�e, c'est le cas).
"""),

68 : _(u"""
 La d�tection des modes de corps rigide (OPTION='MODE_RIGIDE') n'est pas utilisable pour un probl�me avec amortissement
 (%(k1)s complexe, et/ou pr�sence du mot-cl� %(k2)s).
"""),

69 : _(u"""
 Pour un probl�me avec matrice complexe,
 seules les m�thodes 'SORENSEN' et 'QZ' sont utilisables.
"""),

70 : _(u"""
 Pour un probl�me avec matrice complexe, le calcul ne peut pas �tre fait si la borne inf�rieure de l'intervalle de recherche est nulle
 (par exemple, si l'option 'PLUS_PETITE' est utilis�e, c'est le cas ; conseil : utiliser l'option 'CENTRE').
"""),

71 : _(u"""
 Pour un probl�me quadratique, la m�thode de 'SORENSEN' n'est pas utilisable si la borne inf�rieure de l'intervalle de recherche est nulle
 (par exemple, si l'option 'PLUS_PETITE' est utilis�e, c'est le cas ; conseil : utiliser l'option 'CENTRE').
"""),

72 : _(u"""
 La dimension du sous-espace de travail (mot-cl� DIM_SOUS_ESPACE)
 est inf�rieure au nombre de modes de corps rigide.
"""),

73 : _(u"""
 Attention : pour l'instant, il n'y a pas de v�rification de type STURM (comptage du bon nombre des valeurs propres calcul�es)
 lorsqu'on est dans le plan complexe :
       probl�me modal g�n�ralis� avec %(k1)s complexe,
    ou probl�me modal g�n�ralis� avec matrice(s) non sym�trique(s),
    ou probl�me modal quadratique (pr�sence du mot-cl� %(k2)s).
   """),

74 : _(u"""
 Erreur de v�rification des modes calcul�s : au moins un des crit�res de validation renseign�s sous le mot-cl� facteur VERI_MODE n'est pas respect�.
 
 Conseils :
 Si vous voulez tout de m�me utiliser les modes calcul�s (� vos risques et p�rils !), relancez le calcul en modifiant les mots-cl�s situ�s sous le mot-cl� facteur VERI_MODE,
   - soit en utilisant des valeurs moins contraignantes sur les crit�res de qualit�,
   - soit en utilisant l'option STOP_ERREUR='NON'.
"""),

75 : _(u"""
  le probl�me trait� �tant quadratique, on double l'espace de recherche
"""),

76 : _(u"""
 3 ou 6 valeurs pour le mot-cl� "DIRECTION"
"""),

77 : _(u"""
 pour le mot-cl� facteur  "PSEUDO_MODE", il faut donner la matrice de masse.
"""),

78 : _(u"""
 la direction est nulle.
"""),

79 : _(u"""
 Les NUME_DDL associ�s aux matrices MATR_RIGI et MATR_MASS sont diff�rents.
"""),

80 : _(u"""
 bases modales BASE_1 et BASE_2 avec num�rotations incompatibles
"""),

81 : _(u"""
 bases modales et matrice MATR_ASSE avec num�rotations incompatibles
"""),

82 : _(u"""
 nombre de modes et d amortissements diff�rents
"""),

83 : _(u"""
 nombre de modes et d amortissements de CONNORS diff�rents
"""),

85 : _(u"""
 inversion valeur min <=> valeur max
"""),

86 : _(u"""
 type de matrice inconnu
"""),

87 : _(u"""
  pas de produit car le champ aux noeuds  %(k1)s  existe d�j�.
"""),

88 : _(u"""
  Probl�me de programmation :
    La matrice globale %(k1)s n'existe pas.
    Elle est n�cessaire pour d�terminer les degr�s de libert� bloqu�s par AFFE_CHAR_CINE.

  Solution (pour l'utilisateur) :
    1) Ne pas utiliser de charges cin�matiques (AFFE_CHAR_CINE)
    2) �mettre une fiche d'anomalie.

  Solution (pour le programmeur) :
    La matrice globale a �t� d�truite abusivement.
    Instrumenter la routine de destruction pour d�terminer la routine coupable.
"""),

89 : _(u"""
 le mot-cl� MAILLAGE est obligatoire avec le mot-cl� CREA_FISS.
"""),

90 : _(u"""
 le mot-cl� MAILLAGE est obligatoire avec le mot-cl� LINE_QUAD.
"""),

91 : _(u"""
 CREA_MAILLAGE : l'option LINE_QUAD ne traite pas les macro-commandes mailles
"""),

92 : _(u"""
 CREA_MAILLAGE : l'option LINE_QUAD ne traite pas les ABSC_CURV
"""),

93 : _(u"""
 le mot-cl� MAILLAGE est obligatoire avec le mot-cl� QUAD_LINE.
"""),

94 : _(u"""
 CREA_MAILLAGE : l'option QUAD_LINE ne traite pas les macro-commandes mailles
"""),

95 : _(u"""
 CREA_MAILLAGE : l'option QUAD_LINE ne traite pas les ABSC_CURV
"""),

96 : _(u"""
 le mot-cl� MAILLAGE est obligatoire avec le mot-cl� MODI_MAILLE.
"""),

97 : _(u"""
 une seule occurrence de "QUAD_TRIA3"
"""),

98 : _(u"""
 le mot-cl� MAILLAGE est obligatoire avec le mot-cl� COQU_VOLU.
"""),

99 : _(u"""
 pas de maille a modifier
"""),

}
