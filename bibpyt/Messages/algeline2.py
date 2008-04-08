#@ MODIF algeline2 Messages  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
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

cata_msg = {

1 : _("""
 L'argument de "BLOC_DEBUT" doit �tre strictement positif,
 il est pris � 1
"""),

2 : _("""
 Calcul des modes en eau au repos :
 une des valeurs propres de la matrice n'est pas r�elle
"""),

3 : _("""
 Calcul des modes en eau au repos :
 une des valeurs propres obtenues est nulle
"""),

4 : _("""
 Erreur sur la recherche des lagranges
"""),

5 : _("""
 mot cle facteur incorrect
"""),

6 : _("""
 Type de matrice " %(k1)s " inconnu.
"""),

7 : _("""
 On ne traite pas cette option
"""),

8 : _("""
 L'argument de "BLOC_FIN" est plus grand que le nombre de blocs de la matrice,
 il est ramen� � cette valeur
"""),

9 : _("""
 Les matrices � combiner ne sont pas construites sur le meme maillage.
"""),

10 : _("""
 Erreur de programmation :
 On cherche � combiner 2 matrices qui n'ont pas les memes charges cin�matiques.
 Noms des 2 matrices :
    %(k1)s
    %(k2)s

 Solution :
    1) �mettre une fiche d'anomalie / �volution
    2) En attendant : ne pas utiliser de charges cin�matiques :
       remplacer AFFE_CHAR_CINE par AFFE_CHAR_MECA
"""),

11 : _("""
 Les matrices "%(k1)s"  et  "%(k2)s"  n'ont pas la meme structure.
"""),

12 : _("""
 R�solution syst�me lin�aire m�thode de CROUT
 Attention: une dimension nulle ou nmax.lt.dmax(1,n)
"""),

13 : _("""
 R�solution syst�me lin�aire m�thode de CROUT
 Attention: une dimension negative ou nulle
"""),

14 : _("""
 R�solution syst�me lin�aire m�thode de CROUT
 Attention: les dimensions des tableaux ne sont pas correctes
"""),

15 : _("""
 Pas de charge critique  dans l'intervalle demand�
"""),

16 : _("""
  %(k1)s charges critiques  dans l'intervalle demand�
"""),

17 : _("""
 Au moins une fr�quence calcul�e ext�rieure � la bande demand�e
"""),

18 : _("""
 Les matrices " %(k1)s " et " %(k2)s " n'ont pas le meme domaine de d�finition
"""),

19 : _("""
 Probl�mes a l'allocation des descripteurs de la matrice " %(k1)s "
"""),

20 : _("""
 L'argument de "BLOC_DEBUT" est plus grand que le nombre de blocs de la matrice
"""),

21 : _("""
 L'argument de "BLOC_FIN" doit etre strictement positif
"""),

22 : _("""
 La num�rotation des inconnues est incoh�rente entre la matrice et le second membre.
"""),

23 : _("""
  %(k1)s  et  %(k2)s  n'ont pas le meme domaine de d�finition.
"""),

24 : _("""
 La matrice a des ddls elimin�s. il faut utiliser le mot cl� CHAM_CINE.
"""),

25 : _("""
 La matrice et le second membre sont de type diff�rent.
"""),

26 : _("""
 le second membre et le champ cin�matique sont de type diff�rent.
"""),

27 : _("""
 la matrice est d'un type inconnu de l'op�rateur.
"""),

28 : _("""
 les "MATR_ASSE" %(k1)s "  et  " %(k2)s "  ne sont pas combinables.
"""),

29 : _("""
 la valeur d'entr�e 'min' est sup�rieure ou �gale � la valeur d'entr�e 'sup'
"""),

30 : _("""
 les matrices  " %(k1)s "  et  " %(k2)s "  n'ont pas le meme domaine de d�finition.
"""),

31 : _("""
 trop de r�-ajustement de la borne minimale.
"""),

32 : _("""
 trop de r�-ajustement de la borne maximale.
"""),

33 : _("""
 type de mode inconnu:  %(k1)s
"""),

34 : _("""
 il n'est pas permis de modifier un objet p�re
"""),

35 : _("""
 mode non calcul� � partir de matrices assembl�es
"""),

36 : _("""
 normalisation impossible, le point n'est pas present dans le mod�le.
"""),

37 : _("""
 normalisation impossible, la composante n'est pas pr�sente dans le mod�le.
"""),

38 : _("""
 il manque des param�tres entiers
"""),

39 : _("""
 il manque des param�tres r�els
"""),

40 : _("""
 manque des parametres caracteres
"""),

41 : _("""
 normalisation impossible,  aucune composante n'est pr�sente dans le mod�le.
"""),

42 : _("""
 normalisation impossible, le noeud n'est pas pr�sent dans le mod�le.
"""),

43 : _("""
 on ne tient pas compte du mot cle facteur "MODE_SIGNE" pour des "MODE_MECA_C"
"""),

44 : _("""
 " %(k1)s "  type de mode non trait�
"""),

45 : _("""
 calcul de flambement et absence du mot cle char_crit ne sont pas compatibles
"""),

46 : _("""
 calcul de flambement et matrice d'amortissement ne sont pas compatibles
"""),

47 : _("""
 le nombre de frequences demandees est incorrect.
"""),

48 : _("""
 nmax_iter_ ajuste ou separe est negatif
"""),

49 : _("""
 nmax_iter est negatif
"""),

50 : _("""
 prec_ ajuste ou separe est irrealiste
"""),

51 : _("""
 prec est irrealiste (inferieure a 1.e-70)
"""),

52 : _("""
 pas de valeur donnee, separation impossible
"""),

53 : _("""
 une seule valeur donnee, separation impossible
"""),

54 : _("""
 la suite des valeurs donnees n'est pas croissante
"""),

55 : _("""
 mot cle AMOR_REDUIT impossible pour cas generalise
"""),

56 : _("""
 mot cle AMOR_REDUIT impossible si option differente de PROCHE
"""),

57 : _("""
 nombre different d'arguments entre les mots cles amor_reduit et freq
"""),

58 : _("""
 les matrices " %(k1)s " et  " %(k2)s "  sont incompatibles entre elles
"""),

59 : _("""
 presence de frequences negatives dans les donnees.
"""),

60 : _("""
  trop de reajustement d'une borne de l'intervalle de recherche.
"""),

61 : _("""
 erreur trop de reajustement d'une borne de l'intervalle de recherche.
"""),

62 : _("""
 pas de valeurs propres dans la bande de calcul,  le concept ne peut etre cree dans ces conditions.
"""),

63 : _("""
 " %(k1)s "   option inconnue.
"""),

64 : _("""
 le nombre PARAM_ORTHO_SOREN n'est pas valide.
"""),

65 : _("""
 detection des modes de corps rigide n'est utilisee qu'avec tri_diag
"""),

66 : _("""
 option bande non autorisee pour un probleme avec amortissement
"""),

67 : _("""
 approche imaginaire ou complexe et frequence nulle incompatible
"""),

68 : _("""
  option modes de corps rigide non utilisee avec amortissement
"""),

69 : _("""
 pour le probleme generalise ou quadratique complexe on utilise seulement l'algorithme de sorensen
"""),

70 : _("""
 probleme complexe et frequence nulle incompatible
"""),

71 : _("""
 calcul quadratique par la methode de sorensen et frequence nulle incompatible
"""),

72 : _("""
 la dimension du sous espace de travail est inferieure au nombre de modes rigides
"""),

73 : _("""
 pas de verification par STURM pour le probl�me quadratique
"""),

74 : _("""
  erreur de v�rification
"""),

75 : _("""
  le probl�me trait� �tant quadratique, on double l'espace de recherche
"""),

76 : _("""
 3 ou 6 valeurs pour le mot cle "DIRECTION"
"""),

77 : _("""
 pour le mot cle facteur  "PSEUDO_MODE", il faut donner la matrice de masse.
"""),

78 : _("""
 la direction est nulle.
"""),

79 : _("""
 base modale 1 et 2 avec numerotations de taille incompatible
"""),

80 : _("""
 base modale 1 et 2 avec numerotations incompatibles
"""),

81 : _("""
 base modale et matrice avec numerotations incompatibles
"""),

82 : _("""
 nombre de modes et d amortissements differents
"""),

83 : _("""
 nombre de modes et d amortissements de connors differents
"""),

85 : _("""
 inversion vmin <=> vmax
"""),

86 : _("""
 type de matrice inconnu
"""),

87 : _("""
  pas de produit car le cham_no  %(k1)s  existe deja.
"""),

88 : _("""
  Probl�me de programmation :
    La matrice globale %(k1)s n'existe pas.
    Elle est n�cessaire pour d�terminer les ddls bloqu�s par AFFE_CHAR_CINE.

  Solution (pour l'utilisateur) :
    1) Ne pas utiliser de charges cin�matiques (AFFE_CHAR_CINE)
    2) Emettre une fiche d'anomalie.

  Solution (pour le programmeur) :
    La matrice globale a �t� d�truite abusivement.
    Instrumenter la routine jedetr.f pour d�terminer la routine coupable.
"""),

89 : _("""
 le mot-cle MAILLAGE est obligatoire avec le mot-cle CREA_FISS.
"""),

90 : _("""
 le mot-cle MAILLAGE est obligatoire avec le mot-cle LINE_QUAD.
"""),

91 : _("""
 CREA_MAILLAGE : l'option line_quad ne traite pas les macros mailles
"""),

92 : _("""
 CREA_MAILLAGE : l'option LINE_QUAD ne traite pas les ABSC_CURV
"""),

93 : _("""
 le mot-cle MAILLAGE est obligatoire avec le mot-cle QUAD_LINE.
"""),

94 : _("""
 CREA_MAILLAGE : l'option QUAD_LINE ne traite pas les macros mailles
"""),

95 : _("""
 CREA_MAILLAGE : l'option QUAD_LINE ne traite pas les ABSC_CURV
"""),

96 : _("""
 le mot-cle MAILLAGE est obligatoire avec le mot-cle MODI_MAILLE.
"""),

97 : _("""
 une seule occurrence de "QUAD_TRIA3"
"""),

98 : _("""
 le mot-cle MAILLAGE est obligatoire avec le mot-cle COQU_VOLU.
"""),

99 : _("""
 pas de maille a modifier
"""),

}
