#@ MODIF modelisa5 Messages  DATE 09/04/2013   AUTEUR PELLET J.PELLET 
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
 erreur fortran de dimensionnement de tableau (nbmmai>nbmmax)
"""),

2 : _(u"""
 lecture 1 : il manque les coordonn�es !
"""),

3 : _(u"""
 lecture 1 : il manque les mailles !
"""),

4 : _(u"""
 transcodage : le noeud  %(k1)s  d�clar� dans la connectivit� de la maille  %(k2)s  n existe pas dans les coordonn�es
"""),

5 : _(u"""
 transcodage : le noeud  %(k1)s  d�clare dans le GROUP_NO:  %(k2)s  n'existe pas dans les coordonn�es
"""),

6 : _(u"""
 le noeud :  %(k1)s  est en double dans le GROUP_NO:  %(k2)s . on �limine les doublons
"""),

7 : _(u"""
 transcodage : la maille  %(k1)s  d�clar� dans le GROUP_MA:  %(k2)s  n'existe pas dans les connectivit�s
"""),

8 : _(u"""
 la maille :  %(k1)s  est en double dans le GROUP_MA:  %(k2)s . on �limine les doublons
"""),

9 : _(u"""
 transcodage : une incoh�rence a �t� d�tect�e entre les d�clarations de noms de noeuds ou de mailles lors du transcodage des objets groupes et connectivit�s
"""),

10 : _(u"""
 Erreur utilisateur dans CREA_CHAMP / COMB :
   Les champs que l'on cherche � combiner doivent tous �tre des champs aux noeuds.
"""),

11 : _(u"""
 Erreur utilisateur dans CREA_CHAMP / COMB :
   Les champs que l'on cherche � combiner doivent tous avoir la m�me grandeur (DEPL_R, ...).
   Ce doit �tre la m�me que celle donn�e dans TYPE_CHAM).
"""),

12 : _(u"""
 Erreur utilisateur dans CREA_CHAMP / COMB :
   Les champs que l'on cherche � combiner doivent tous avoir la m�me num�rotation.
"""),

13 : _(u"""
 Erreur utilisateur dans CREA_CHAMP / COMB :
   Les champs que l'on cherche � combiner doivent tous s'appuyer sur le m�me maillage.
"""),

32 : _(u"""
 il faut fournir des mailles
"""),

33 : _(u"""
 on attend 1 et 1 seule maille
"""),

34 : _(u"""
 on n'a pas trouve la maille
"""),

35 : _(u"""
 que des mailles de type "SEG"
"""),

36 : _(u"""
 un GROUP_MA n'a pas de nom, suppression de ce groupe.
"""),

37 : _(u"""
 un GROUP_NO n'a pas de nom, suppression de ce groupe.
"""),

40 : _(u"""
 absence de convergence j
"""),

41 : _(u"""
 absence de convergence i
"""),

42 : _(u"""
 pas de convergence
"""),

43 : _(u"""
 erreur programmeur. type de maille inconnu
"""),

44 : _(u"""
 param�tre b�ta non trouve
"""),

45 : _(u"""
 param�tre lambda non trouve
"""),

47 : _(u"""
 param�tre AFFINITE non trouve
"""),

48 : _(u"""
  option calcul de l ABSC_CURV sur  un GROUP_MA non implant�e.
"""),

49 : _(u"""
  -> La phase de v�rification du maillage a �t� volontairement d�sactiv�e.

  -> Risque & Conseil :
     Soyez sur de votre maillage. Si des mailles d�g�n�r�es sont pr�sentes elles
     ne seront pas d�tect�es. Cela pourra nuire � la qualit� des r�sultats.
"""),

50 : _(u"""
 la grandeur associ�e au mot cl� :  %(k1)s  doit �tre:  %(k2)s  mais elle est:  %(k3)s
"""),

51 : _(u"""
 pour affecter une liste de mod�lisations, il faut qu'elles soient de m�me dimension topologique.
"""),

52 : _(u"""
 aucune maille n a �tes affect�e par des �l�ments finis pour le maillage  %(k1)s
"""),

53 : _(u"""
  -> Le maillage est 3D (tous les noeuds ne sont pas dans le m�me plan Z = constante),
     mais les �l�ments du mod�le sont de dimension 2.

  -> Risque & Conseil :
     Si les facettes supportant les �l�ments ne sont pas dans un plan Z = constante,
     les r�sultats seront faux.
     Assurez-vous de la coh�rence entre les mailles � affecter et la
     mod�lisation souhait�e dans la commande AFFE_MODELE.
"""),

54 : _(u"""
 il est interdit d'avoir ,pour un mod�le donne, a la fois des �l�ments discrets 2d et 3d .
"""),

55 : _(u"""
 VERIF : 2 arguments max
"""),

56 : _(u"""
 il manque le mot cl� facteur POUTRE.
"""),

57 : _(u"""
 erreur(s) rencontr�e(s) lors de la v�rification des affectations.
"""),

58 : _(u"""
 -> Bizarre :
     Les �l�ments du mod�le sont de dimension 2.
     Mais les noeuds du maillage sont un m�me plan Z = a avec a != 0.,

 -> Risque & Conseil :
     Il est d'usage d'utiliser un maillage Z=0. pour les mod�lisations planes ou Axis.
"""),

59 : _(u"""
 une erreur d affectation a �t� d�tect�e : certaines mailles demand�es poss�dent un type �l�ment incompatible avec les donn�es a affecter
"""),

60 : _(u"""
 des poutres ne sont pas affect�es
"""),

61 : _(u"""
 des barres ne sont pas affect�es
"""),

62 : _(u"""
 des c�bles ne sont pas affectes
"""),

63 : _(u"""
 le param�tre "RHO" n'est pas d�fini pour toutes les couches.
"""),

64 : _(u"""
 un seul ELAS svp
"""),

65 : _(u"""
 <FAISCEAU_TRANS> deux zones d excitation du fluide ont m�me nom
"""),

66 : _(u"""
 SPEC_EXCI_POINT : si INTE_SPEC alors autant d arguments pour nature, ANGLE et noeud
"""),

67 : _(u"""
 SPEC_EXCI_POINT : si grappe_2 alors un seul noeud
"""),

68 : _(u"""
 SPEC_FONC_FORME : le nombre de fonctions fournies doit �tre �gal a la dimension de la matrice interspectrale
"""),

69 : _(u"""
 SPEC_EXCI_POINT : le nombre d arguments pour nature, ANGLE et noeud doit �tre �gal a la dimension de la matrice interspectrale
"""),

70 : _(u"""
 mauvaise d�finition de la plage  de fr�quence.
"""),

71 : _(u"""
 mauvaise d�finition de la plage de fr�quence. les mod�les ne tol�rent pas des valeurs n�gatives ou nulles.
"""),

72 : _(u"""
 le nombre de points pour la discr�tisation fr�quentielle doit �tre une puissance de 2.
"""),

73 : _(u"""
 les spectres de type "longueur de corr�lation"  ne peuvent �tre combines avec des spectres d un autre type.
"""),

74 : _(u"""
 le spectre de nom  %(k1)s  est associe a la zone  %(k2)s  qui n existe pas dans le concept  %(k3)s
"""),

75 : _(u"""
 le spectre de nom  %(k1)s  est associe a la zone de nom  %(k2)s
"""),

76 : _(u"""
 deux spectres sont identiques
"""),

77 : _(u"""
 les spectres de noms  %(k1)s  et  %(k2)s  sont associes au m�me profil de vitesse, de nom  %(k3)s
"""),

78 : _(u"""
 pas le bon num�ro de mode
"""),

79 : _(u"""
 le calcul de tous les interspectres de r�ponse modale n est pas possible car seuls les auto spectres d excitation ont �t� calcules.
"""),

80 : _(u"""
 la composante s�lectionn�e pour la restitution en base physique des interspectres est diff�rente de celle choisie pour le couplage fluide-structure.
"""),

81 : _(u"""
 la TABL_INTSP de r�ponse modale ne contient que des auto spectres. le calcul demande n est donc pas r�alisable.
"""),





83 : _(u"""
 mot-cl� <DEFI_CABLE>, occurrence no  %(k1)s , op�rande <NOEUD_ANCRAGE> : il faut d�finir 2 noeuds d'ancrage
"""),

84 : _(u"""
 mot-cl� <DEFI_CABLE>, occurrence no  %(k1)s , op�rande <GROUP_NO_ANCRAGE> : il faut d�finir 2 GROUP_NO d'ancrage
"""),

85 : _(u"""
 mot-cl� <DEFI_CABLE>, occurrence no  %(k1)s , op�rande <NOEUD_ANCRAGE> : les 2 noeuds d'ancrage doivent �tre distincts
"""),

86 : _(u"""
 mot-cl� <DEFI_CABLE>, occurrence no  %(k1)s , op�rande <GROUP_NO_ANCRAGE> : les 2 GROUP_NO d'ancrage doivent �tre distincts
"""),

87 : _(u"""
 mot-cl� <DEFI_CABLE>, occurrence no  %(k1)s , op�rande type ancrage : les 2 extr�mit�s sont passives -> armature passive
"""),

88 : _(u"""
 mot-cl� <DEFI_CABLE>, occurrence no  %(k1)s , op�rande type ancrage : les 2 extr�mit�s sont passives et la tension que vous voulez imposer est non nulle : impossible !
"""),

89 : _(u"""
 la carte des caract�ristiques mat�rielles des �l�ments n existe pas. il faut pr�alablement affecter ces caract�ristiques en utilisant la commande <AFFE_MATERIAU>
"""),

90 : _(u"""
 la carte des caract�ristiques g�om�triques des �l�ments de barre de section g�n�rale n existe pas. il faut pr�alablement affecter ces caract�ristiques en utilisant la commande <AFFE_CARA_ELEM>
"""),

91 : _(u"""
 probl�me pour d�terminer le rang de la composante <a1> de la grandeur <cagnba>
"""),

92 : _(u"""
 probl�me sur une relation : les coefficients sont trop petits
"""),

94 : _(u"""
 impossibilit�, la maille  %(k1)s  doit �tre une maille de peau, i.e. de type "QUAD" ou "tria" en 3d ou de type "SEG" en 2d, et elle est de type :  %(k2)s
"""),

95 : _(u"""
 vous avez utilise le mot cl� ORIE_PEAU_2d alors que le probl�me est 3d. utilisez ORIE_PEAU_3d
"""),

96 : _(u"""
 vous avez utilise le mot cl� ORIE_PEAU_3d alors que le probl�me est 2d. utilisez ORIE_PEAU_2d
"""),

97 : _(u"""
 erreur donn�es : le noeud  %(k1)s  n'existe pas
"""),

98 : _(u"""
 impossibilit� de m�langer des "SEG" et des "tria" ou "QUAD" !
"""),

99 : _(u"""
 Lors de la v�rification automatique de l'orientation des mailles de bord, une erreur a �t� rencontr�e : les groupes de mailles de bord ne forment pas un ensemble connexe.

 Conseils :
 - Commencez par v�rifier que les groupes de mailles de bord fournies sont correctement d�finis.
 - Si ces groupes de mailles ont des raisons d'�tre non connexes, vous pouvez d�sactiver la v�rification automatique en renseignant VERI_NORM='NON'.
"""),

}
