#@ MODIF utilitai3 Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

cata_msg = {

2 : _(u"""
 l'utilisation de cette commande n'est l�gitime que si
 la configuration �tudi�e est du type "FAISCEAU_TRANS"
"""),

4 : _(u"""
 le nom d'un param�tre ne peut pas d�passer 16 caract�res
"""),

5 : _(u"""
 le param�tre  %(k1)s  n'existe pas
"""),

6 : _(u"""
 seuls les parametres de types reel, entier ou complexe sont traites
"""),

7 : _(u"""
 erreur dvp_2
"""),

8 : _(u"""
 code retour non nul detecte
"""),

9 : _(u"""
 maillage autre que seg2                                ou poi1
"""),

10 : _(u"""
 mailles ponctuelles                           plexus poi1 ignorees
"""),

11 : _(u"""
 le format doit etre ideas
"""),

12 : _(u"""
 le maillage doit etre issu d'ideas
"""),

13 : _(u"""
  maillage non issu d'ideas
"""),

14 : _(u"""
 avec le 2414, on ne traite pas les nume_ordre
"""),

15 : _(u"""
 pb lecture du fichier ideas
"""),

17 : _(u"""
 format  %(k1)s  inconnu.
"""),

18 : _(u"""
 nom_cmp_idem est curieux :  %(k1)s
"""),

19 : _(u"""
 probleme maillage <-> modele
"""),

20 : _(u"""
 le champ de META_ELNO:etat_init(num_init) n'existe pas.
"""),

21 : _(u"""
 maillage et modele incoherents.
"""),

22 : _(u"""
 pour type_resu:'el..' il faut renseigner le mot cle modele.
"""),

23 : _(u"""
 option:  %(k1)s non prevue pour les elements du modele.
"""),

24 : _(u"""
 option=  %(k1)s  incompatible avec type_cham=  %(k2)s
"""),

25 : _(u"""
 operation=  %(k1)s  seulement type_cham= 'noeu_geom_r'
"""),

26 : _(u"""
 operation=  %(k1)s  incompatible avec type_cham=  %(k2)s
"""),

27 : _(u"""
 grandeurs differentes pour : %(k1)s et : %(k2)s
"""),

28 : _(u"""
 il existe des doublons dans la liste d'instants de rupture
"""),

29 : _(u"""
 il faut donner plus d'un instant de rupture
"""),

30 : _(u"""
 il manque des temperatures  associees aux bases de resultats (mot-cle tempe)
"""),

31 : _(u"""
 le parametre m de weibull doit etre le meme pour toutes les bases resultats !
"""),

32 : _(u"""
 le parametre sigm_refe de weibull doit etre le meme pour toutes les bases resultats !
"""),

33 : _(u"""
 aucun numero d'unite logique n'est associe a  %(k1)s
"""),

34 : _(u"""
 aucun numero d'unite logique n'est disponible
"""),

35 : _(u"""
 action inconnue:  %(k1)s
"""),

36 : _(u"""
 arret de la procedure de recalage : le parametre m est devenu trop petit (m<1) , verifiez vos listes d'instants de rupture
"""),

37 : _(u"""
 les parametres de la nappe ont ete reordonnees.
"""),

38 : _(u"""
 type de fonction non connu (ordonn)
"""),

39 : _(u"""
 points confondus.
"""),

40 : _(u"""
 impossibilit� : la maille  %(k1)s  doit etre de type "SEG2" ou "SEG3"
 et elle est de type :  %(k2)s
"""),

42 : _(u"""
 le contour dont on doit calculer l'aire n'est pas ferm�
"""),

43 : _(u"""
 le mot-cl� "reuse" n'existe que pour l'op�ration "ASSE"
"""),

46 : _(u"""
 le groupe de mailles " %(k1)s " n'existe pas.
"""),

47 : _(u"""
 le groupe  %(k1)s  ne contient aucune maille.
"""),

48 : _(u"""
 on ne traite que des problemes 2d.
"""),

49 : _(u"""
 la maille " %(k1)s " n'existe pas.
"""),

50 : _(u"""
 on doit donner un resultat de type "evol_ther" apres le mot-cle "lapl_phi"  du mot-facteur "cara_poutre" dans la commande post_elem pour calculer la constante de torsion.
"""),

51 : _(u"""
 le nombre d'ordres du resultat  %(k1)s  necessaire pour calculer la constante de torsion doit etre egal a 1.
"""),

52 : _(u"""
 on n'arrive pas a recuperer le champ de temperatures du resultat  %(k1)s
"""),

53 : _(u"""
 la table "cara_geom" n'existe pas.
"""),

54 : _(u"""
 on doit donner un resultat de type "evol_ther" apres le mot-cle "lapl_phi_y"  du mot-facteur "cara_poutre" dans la commande post_elem pour calculer les coefficients de cisaillement et les coordonnees du centre de torsion.
"""),

55 : _(u"""
 on doit donner un resultat de type "evol_ther" apres le mot-cle "lapl_phi_z"  du mot-facteur "cara_poutre" dans la commande post_elem pour calculer les coefficients de cisaillement et les coordonnees du centre de torsion.
"""),

56 : _(u"""
 le nombre d'ordres du resultat  %(k1)s  necessaire pour calculer les coefficients de cisaillement et les coordonnees du centre de torsion doit etre egal a 1.
"""),

57 : _(u"""
 on doit donner un resultat de type "evol_ther" apres le mot-cle "lapl_phi"  du mot-facteur "cara_poutre" dans la commande post_elem pour calculer la constante de gauchissement.
"""),

58 : _(u"""
 le nombre d'ordres du resultat  %(k1)s  necessaire pour calculer la constante de gauchissement doit etre egal a 1.
"""),

59 : _(u"""
 il faut donner le nom d'une table issue d'un premier calcul avec l'option "cara_geom" de  post_elem apres le mot-cle "cara_geom" du mot-facteur "cara_poutre".
"""),

60 : _(u"""
 il faut obligatoirement definir l'option de calcul des caracteristiques de poutre apres le mot-cle "option" du mot-facteur "cara_poutre" de la commande post_elem.
"""),

61 : _(u"""
 l'option  %(k1)s n'est pas admise apres le mot-facteur "CARA_POUTRE".
"""),

62 : _(u"""
 il faut donner le nom d'un r�sultat de type EVOL_THER
 apr�s le mot-cl� LAPL_PHI du mot-facteur "CARA_POUTRE".
"""),

63 : _(u"""
 il faut donner le nom d'un resultat de type EVOL_THER
 apres le mot-cle LAPL_PHI_Y du mot-facteur "CARA_POUTRE".
"""),

64 : _(u"""
 il faut donner le nom d'un resultat de type EVOL_THER
 apres le mot-cle LAPL_PHI_Z du mot-facteur "CARA_POUTRE".
"""),

68 : _(u"""
 on attend un concept "mode_meca" ou "evol_elas" ou "evol_ther" ou "dyna_trans" ou "evol_noli"
"""),

69 : _(u"""
 champ de vitesse donn�
"""),

70 : _(u"""
 champ de d�placement donn�
"""),

71 : _(u"""
 option masse coh�rente.
"""),

72 : _(u"""
 calcul avec masse diagonale
"""),

73 : _(u"""
 type de champ inconnu.
"""),

75 : _(u"""
 on attend un concept "mode_meca" ou "evol_elas" ou "mult_elas" ou "evol_ther" ou "dyna_trans" ou "evol_noli"
"""),

76 : _(u"""
 pour calculer les indicateurs globaux d'energie, il faut donner un resultat issu de stat_non_line .
"""),

77 : _(u"""
 on attend un resultat de type "evol_noli" .
"""),

78 : _(u"""
 le resultat  %(k1)s  doit comporter la relation de comportement au numero d'ordre  %(k2)s  .
"""),

79 : _(u"""
 le resultat  %(k1)s  doit comporter un champ de variables internes au numero d'ordre  %(k2)s  .
"""),

80 : _(u"""
 impossibilite : le volume du modele traite est nul.
"""),

81 : _(u"""
 impossibilite : le volume du group_ma  %(k1)s  est nul.
"""),

82 : _(u"""
 impossibilite : le volume de la maille  %(k1)s  est nul.
"""),

83 : _(u"""
 erreur: les options de calcul doivent etre identiques pour toutes les occurrences du mot clef facteur
"""),

84 : _(u"""
 on attend un concept "evol_noli"
"""),

85 : _(u"""
 erreur: le champ sief_elga n'existe pas
"""),

86 : _(u"""
 erreur: le champ vari_elga n'existe pas
"""),

87 : _(u"""
 erreur: le champ depl_elno n'existe pas
"""),

88 : _(u"""
 erreur: le champ EPSG_ELGA n'existe pas
"""),

89 : _(u"""
 les 2 nuages : %(k1)s  et  %(k2)s  doivent avoir le meme nombre de coordonnees.
"""),

90 : _(u"""
 les 2 nuages : %(k1)s  et  %(k2)s  doivent avoir la meme grandeur associee.
"""),

91 : _(u"""
 il manque des cmps sur :  %(k1)s
"""),



93 : _(u"""
 seuls les types "reel" et "complexe" sont autorises.
"""),

94 : _(u"""
 MINMAX est toujours calcul� sur TOUT le mod�le pour les champs aux noeuds.
"""),

}
