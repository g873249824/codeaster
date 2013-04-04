#@ MODIF utilitai3 Messages  DATE 03/04/2013   AUTEUR DESOZA T.DESOZA 
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
 seuls les param�tres de types r�el, entier ou complexe sont traites
"""),

7 : _(u"""
 erreur DPVP_2
"""),

8 : _(u"""
 code retour non nul d�tect�
"""),

9 : _(u"""
 maillage autre que SEG2                                ou POI1
"""),

10 : _(u"""
 mailles ponctuelles                           plexus POI1 ignor�es
"""),

11 : _(u"""
 le format doit �tre IDEAS
"""),

12 : _(u"""
 le maillage doit �tre issu d'IDEAS
"""),

13 : _(u"""
  maillage non issu d'IDEAS
"""),

14 : _(u"""
 avec le 2414, on ne traite pas les NUME_ORDRE
"""),

15 : _(u"""
 Probl�me lecture du fichier IDEAS
"""),

17 : _(u"""
 format  %(k1)s  inconnu.
"""),

18 : _(u"""
 NOM_CMP_IDEM est curieux :  %(k1)s
"""),

19 : _(u"""
 probl�me maillage <-> mod�le
"""),





21 : _(u"""
 maillage et mod�le incoh�rents.
"""),

22 : _(u"""
 pour TYPE_RESU:'EL..' il faut renseigner le mot cl� mod�le.
"""),

23 : _(u"""
Erreur :
  Aucun �l�ment fini du ligrel '%(k1)s' ne sait calculer le
  param�tre: %(k2)s de l'option:  %(k3)s.
  Le champ par �l�ments que l'on veut cr�er est vide. On ne peut pas continuer.
"""),

24 : _(u"""
 option=  %(k1)s  incompatible avec TYPE_CHAM=  %(k2)s
"""),

25 : _(u"""
 OPERATION=  %(k1)s  seulement TYPE_CHAM= 'NOEU_GEOM_r'
"""),

26 : _(u"""
 OPERATION=  %(k1)s  incompatible avec TYPE_CHAM=  %(k2)s
"""),

27 : _(u"""
 grandeurs diff�rentes pour : %(k1)s et : %(k2)s
"""),

28 : _(u"""
 il existe des doublons dans la liste d'instants de rupture
"""),

29 : _(u"""
 il faut donner plus d'un instant de rupture
"""),

30 : _(u"""
 il manque des temp�ratures  associ�es aux bases de r�sultats (mot-cl� tempe)
"""),

31 : _(u"""
 le param�tre m de WEIBULL doit �tre le m�me pour toutes les bases r�sultats !
"""),

32 : _(u"""
 le param�tre SIGM_REFE de WEIBULL doit �tre le m�me pour toutes les bases r�sultats !
"""),

33 : _(u"""
 aucun num�ro d'unit� logique n'est associe a  %(k1)s
"""),

34 : _(u"""
 aucun num�ro d'unit� logique n'est disponible
"""),

35 : _(u"""
 action inconnue:  %(k1)s
"""),

36 : _(u"""
 Arr�t de la proc�dure de recalage : le param�tre m est devenu trop petit (m<1),
 v�rifiez vos listes d'instants de rupture
"""),

37 : _(u"""
 les param�tres de la nappe ont �t� r�ordonn�es.
"""),

38 : _(u"""
 type de fonction non connu
"""),

39 : _(u"""
 points confondus.
"""),

40 : _(u"""
 impossibilit� : la maille  %(k1)s  doit �tre de type "SEG2" ou "SEG3"
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
 on ne traite que des probl�mes 2d.
"""),

49 : _(u"""
 la maille " %(k1)s " n'existe pas.
"""),

50 : _(u"""
 On doit donner un r�sultat de type "EVOL_THER" apr�s le mot-cl� "LAPL_PHI"
 du mot-cl� facteur "CARA_POUTRE" dans la commande POST_ELEM pour calculer
 la constante de torsion.
"""),

51 : _(u"""
 Le nombre d'ordres du r�sultat  %(k1)s  n�cessaire pour calculer la constante
 de torsion doit �tre �gal a 1.
"""),





53 : _(u"""
 La table "CARA_GEOM" n'existe pas.
"""),

54 : _(u"""
 On doit donner un r�sultat de type "EVOL_THER" apr�s le mot-cl� "LAPL_PHI_Y"
 du mot-cl� facteur "CARA_POUTRE" dans la commande POST_ELEM pour calculer les
 coefficients de cisaillement et les coordonn�es du centre de torsion.
"""),

55 : _(u"""
 On doit donner un r�sultat de type "EVOL_THER" apr�s le mot-cl� "LAPL_PHI_Z"
 du mot-cl� facteur "CARA_POUTRE" dans la commande POST_ELEM pour calculer les
 coefficients de cisaillement et les coordonn�es du centre de torsion.
"""),

56 : _(u"""
 Le nombre d'ordres du r�sultat  %(k1)s  n�cessaire pour calculer les coefficients
 de cisaillement et les coordonn�es du centre de torsion doit �tre �gal a 1.
"""),

57 : _(u"""
 On doit donner un r�sultat de type "EVOL_THER" apr�s le mot-cl� "LAPL_PHI"
 du mot-cl� facteur "CARA_POUTRE" dans la commande POST_ELEM pour calculer la
 constante de gauchissement.
"""),

58 : _(u"""
 Le nombre d'ordres du r�sultat  %(k1)s  n�cessaire pour calculer la constante de
 gauchissement doit �tre �gal a 1.
"""),

59 : _(u"""
 Il faut donner le nom d'une table issue d'un premier calcul avec l'option "CARA_GEOM"
 de  POST_ELEM apr�s le mot-cl� "CARA_GEOM" du mot-cl� facteur "CARA_POUTRE".
"""),

60 : _(u"""
 Il faut obligatoirement d�finir l'option de calcul des caract�ristiques de poutre
 apr�s le mot-cl� "option" du mot-cl� facteur "CARA_POUTRE" de la commande POST_ELEM.
"""),

61 : _(u"""
 l'option  %(k1)s n'est pas admise apr�s le mot-cl� facteur "CARA_POUTRE".
"""),

62 : _(u"""
 il faut donner le nom d'un r�sultat de type EVOL_THER
 apr�s le mot-cl� LAPL_PHI du mot-cl� facteur "CARA_POUTRE".
"""),

63 : _(u"""
 il faut donner le nom d'un r�sultat de type EVOL_THER
 apr�s le mot-cl� LAPL_PHI_Y du mot-cl� facteur "CARA_POUTRE".
"""),

64 : _(u"""
 il faut donner le nom d'un r�sultat de type EVOL_THER
 apr�s le mot-cl� LAPL_PHI_Z du mot-cl� facteur "CARA_POUTRE".
"""),

68 : _(u"""
 On attend un concept "MODE_MECA" ou "EVOL_ELAS" ou "EVOL_THER" ou "DYNA_TRANS"
 ou "EVOL_NOLI"
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
 On attend un concept "MODE_MECA" ou "EVOL_ELAS" ou "MULT_ELAS" ou "EVOL_THER"
 ou "DYNA_TRANS" ou "EVOL_NOLI"
"""),

76 : _(u"""
 Pour calculer les indicateurs globaux d'�nergie, il faut donner un r�sultat
 issu de STAT_NON_LINE .
"""),

77 : _(u"""
 on attend un r�sultat de type "EVOL_NOLI" ou "EVOL_ELAS".
"""),






79 : _(u"""
 Le r�sultat  %(k1)s  doit comporter un champ de variables internes au num�ro
 d'ordre  %(k2)s  .
"""),

80 : _(u"""
 Impossibilit� : le volume du mod�le traite est nul.
"""),

81 : _(u"""
 impossibilit� : le volume du GROUP_MA  %(k1)s  est nul.
"""),

82 : _(u"""
 impossibilit� : le volume de la maille  %(k1)s  est nul.
"""),

83 : _(u"""
 Erreur: les options de calcul doivent �tre identiques pour toutes les occurrences
 du mot clef facteur
"""),

84 : _(u"""
 on attend un concept "EVOL_NOLI"
"""),

















89 : _(u"""
 les 2 nuages : %(k1)s  et  %(k2)s  doivent avoir le m�me nombre de coordonn�es.
"""),

90 : _(u"""
 les 2 nuages : %(k1)s  et  %(k2)s  doivent avoir la m�me grandeur associ�e.
"""),

91 : _(u"""
 il manque des composantes sur :  %(k1)s
"""),



93 : _(u"""
 seuls les types "r�el" et "complexe" sont autorises.
"""),

94 : _(u"""
 MINMAX est toujours calcul� sur TOUT le mod�le pour les champs aux noeuds.
"""),

}
