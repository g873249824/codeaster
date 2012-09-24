#@ MODIF algeline2 Messages  DATE 24/09/2012   AUTEUR BOITEAU O.BOITEAU 
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
 Au moins une fr�quence calcul�e ext�rieure � la bande demand�e
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





28 : _(u"""
 les "MATR_ASSE" %(k1)s "  et  " %(k2)s "  ne sont pas combinables.
"""),

29 : _(u"""
 la valeur d'entr�e 'min' est sup�rieure ou �gale � la valeur d'entr�e 'SUP'
"""),

30 : _(u"""
 les matrices  " %(k1)s "  et  " %(k2)s "  n'ont pas le m�me domaine de d�finition.
"""),

33 : _(u"""
 type de mode inconnu:  %(k1)s
"""),

34 : _(u"""
 il n'est pas permis de modifier un objet p�re
"""),

35 : _(u"""
 mode non calcul� � partir de matrices assembl�es
"""),

36 : _(u"""
 normalisation impossible, le point n'est pas pr�sent dans le mod�le.
"""),

37 : _(u"""
 normalisation impossible, la composante n'est pas pr�sente dans le mod�le.
"""),

38 : _(u"""
 il manque des param�tres entiers
"""),

39 : _(u"""
 il manque des param�tres r�els
"""),

40 : _(u"""
 manque des param�tres caract�res
"""),

41 : _(u"""
 normalisation impossible,  aucune composante n'est pr�sente dans le mod�le.
"""),

42 : _(u"""
 normalisation impossible, le noeud n'est pas pr�sent dans le mod�le.
"""),

43 : _(u"""
 on ne tient pas compte du mot-cl� facteur "MODE_SIGNE" pour des "MODE_MECA_C"
"""),

44 : _(u"""
 " %(k1)s "  type de mode non trait�
"""),

45 : _(u"""
 calcul de flambement et absence du mot-cl� CHAR_CRIT ne sont pas compatibles
"""),

46 : _(u"""
 calcul de flambement et matrice d'amortissement ne sont pas compatibles
"""),

47 : _(u"""
 le nombre de fr�quences demand�es est incorrect.
"""),

48 : _(u"""
 NMAX_ITER_AJUSTE ou NMAX_ITER_SEPARE est n�gatif
"""),

49 : _(u"""
 NMAX_ITER est n�gatif
"""),

50 : _(u"""
 PREC_AJUSTE ou PREC_SEPARE est irr�aliste
"""),

51 : _(u"""
 PREC est irr�aliste (inf�rieure a 1.e-70)
"""),

52 : _(u"""
 pas de valeur donn�e, s�paration impossible
"""),

53 : _(u"""
 une seule valeur donn�e, s�paration impossible
"""),

54 : _(u"""
 la suite des valeurs donn�es n'est pas croissante
"""),

55 : _(u"""
 mot-cl� AMOR_REDUIT impossible pour cas g�n�ralis�.
"""),

56 : _(u"""
 mot-cl� AMOR_REDUIT impossible si option diff�rente de PROCHE
"""),

57 : _(u"""
 nombre diff�rent d'arguments entre les mots-cl�s AMOR_REDUIT et FREQ
"""),

58 : _(u"""
 les matrices " %(k1)s " et  " %(k2)s "  sont incompatibles entre elles
"""),

59 : _(u"""
 pr�sence de fr�quences n�gatives dans les donn�es.
"""),

62 : _(u"""
 pas de valeurs propres dans la bande de calcul,  le concept ne peut �tre cr�� dans ces conditions.
"""),

63 : _(u"""
 " %(k1)s "   option inconnue.
"""),

64 : _(u"""
 le nombre PARAM_ORTHO_SOREN n'est pas valide.
"""),

65 : _(u"""
 d�tection des modes de corps rigide n'est utilis�e qu'avec TRI_DIAG
"""),

66 : _(u"""
 option bande non autoris�e pour un probl�me avec amortissement
"""),

67 : _(u"""
 approche imaginaire ou complexe et fr�quence nulle incompatible
"""),

68 : _(u"""
  option modes de corps rigide non utilis�e avec amortissement
"""),

69 : _(u"""
 pour le probl�me g�n�ralis� ou quadratique complexe on utilise seulement
 METHODE='SORENSEN' ou 'QZ'
"""),

70 : _(u"""
 probl�me complexe et fr�quence nulle incompatible
"""),

71 : _(u"""
 calcul quadratique par la m�thode de SORENSEN et fr�quence nulle incompatible
"""),

72 : _(u"""
 la dimension du sous espace de travail est inf�rieure au nombre de modes rigides
"""),

73 : _(u"""
 Attention : pour l'instant, il n'y a pas de v�rification de type STURM
 (comptage du bon nombre des valeurs propres calcul�es) lorsqu'on est
 dans le plan complexe :
            modal g�n�ralis� avec K complexe,
            modal g�n�ralis� avec K et/ou M non sym�trique(s),
            modal quadratique.
"""),

74 : _(u"""
  erreur de v�rification
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
 Les NUME_DDL associ�s aux matrices MATR_A et MATR_B sont diff�rents.
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
