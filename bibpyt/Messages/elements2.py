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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

1  : _(u"""
   Aucun champ de d�placement ni de vitesse n'est fourni
   pour le calcul de l'option %(k1)s.
"""),

27 : _(u"""
 pas d'intersection trouv�
"""),

29 : _(u"""
 �l�ment faisceau homog�n�is� non pr�vu
"""),

31 : _(u"""
  ELREFE non pr�vu
"""),

32 : _(u"""
 comportement non trouve: %(k1)s
"""),

33 : _(u"""
 pas de dilatation thermique orthotrope pour coque_3d
"""),

34 : _(u"""
 les vecteurs sont au nombre de 1 ou 2
"""),

37 : _(u"""
 pas de z�ro, convergence impossible
"""),

38 : _(u"""
  ->  L'option ANGL_AXE n'est pas prise en compte en 2D mais seulement
      en 3D.
  -> Risque & Conseil :
     Ce mot cl� utilis� dans l'op�rateur AFFE_CARA_ELEM (MASSIF), permet
     de d�finir des axes locaux pour lesquels on utilise une propri�t� de
     sym�trie de r�volution, ou d'isotropie transverse. En 2D, on peut d�finir
     un rep�re d'orthotropie via ANGL_REP.
"""),

39 : _(u"""
 loi LEMA_SEUIL non impl�ment�e avec les poutres multifibres
"""),

40 : _(u"""
 on ne sait pas int�grer avec  %(k1)s  caract�ristiques par fibre
"""),

41 : _(u"""
 cas avec inerties des fibres non programme
"""),

42 : _(u"""
 " %(k1)s "    nom d'�l�ment inconnu.
"""),

43 : _(u"""
 noeuds confondus pour la maille:  %(k1)s
"""),

44 : _(u"""
  option de matrice de masse  %(k1)s  inconnue
"""),

45 : _(u"""
 on n'a pas trouv� de variable interne correspondante a la d�formation plastique �quivalente cumul�e
"""),

46 : _(u"""
 on ne traite pas les moments
"""),

47 : _(u"""
 l'option " %(k1)s " est inconnue
"""),

48 : _(u"""
 type de poutre inconnu
"""),

49 : _(u"""
 charge r�partie variable non admise sur un �l�ment courbe.
"""),

50 : _(u"""
 charge r�partie variable non admise sur un �l�ment variable.
"""),

51 : _(u"""
 on ne peut pas imposer de charges r�parties suiveuses de type vitesse de vent sur les poutres courbes.
"""),

52 : _(u"""
 on ne peut pas imposer de charges r�parties suiveuses sur les poutres courbes.
"""),

53 : _(u"""
 un champ de vitesse de vent est impos� sans donner un Cx d�pendant de la vitesse sur une des poutres.
"""),

54 : _(u"""
 le module de cisaillement G est nul mais pas le module de Young E
"""),

55 : _(u"""
 section circulaire uniquement
"""),

56 : _(u"""
 pour l'instant on ne fait pas le calcul de la  matrice de masse d'un �l�ment de plaque q4g excentre.
"""),

57 : _(u"""
 pour l'instant on ne peut pas excentrer les �l�ments q4g .
"""),

58 : _(u"""
 �chec de convergence dans l'inversion du syst�me par Newton-Raphson.
"""),

59 : _(u"""
 Les moments r�partis ne sont autoris�s que sur les poutres droites � section constante.
"""),

61 : _(u"""
 " %(k1)s "   nom d'option non reconnue
"""),

62 : _(u"""
 ! Probl�me RCVALA rhocp !
"""),

63 : _(u"""
 ! comportement non trouve !
"""),

71 : _(u"""
 Pour les mod�lisations DKT, seules les lois de comportement sous COMP_INCR sont autoris�es.
"""),

72 : _(u"""
  -> La r�actualisation de la g�om�trie (DEFORMATION='PETIT_REAC' sous
     le mot cl� COMP_INCR) est d�conseill�e pour les �l�ments de type plaque. Les
     grandes rotations ne sont pas mod�lis�es correctement.
  -> Risque & Conseil :
     En pr�sence de grands d�placements et grandes rotations, il est pr�f�rable
     d'utiliser la mod�lisation COQUE_3D, avec DEFORMATION='GROT_GDEP'
"""),

73 : _(u"""
 Seule la loi de comportement ELAS est autoris�e avec la d�formation GROT_GDEP en mod�lisation DKT.
"""),

74 : _(u"""
  %(k1)s  non implante.
"""),

75 : _(u"""
  Les mat�riaux de coque homog�n�is�es (ELAS_COQUE ou DEFI_COQU_MULT) sont interdits en non-lin�aire.
"""),

77 : _(u"""
 option :  %(k1)s  interdite
"""),

80 : _(u"""
 �l�ments de poutre noeuds confondus pour un �l�ment:  %(k1)s
"""),

81 : _(u"""
 �l�ments de poutre section variable affine :seul une section rectangle plein est disponible.
"""),

82 : _(u"""
 �l�ments de poutre section variable homoth�tique : l'aire initiale est nulle.
"""),

84 : _(u"""
 �l�ments de poutre l'option " %(k1)s " est inconnue
"""),

90 : _(u"""
 COMP_ELAS non valide
"""),

}
