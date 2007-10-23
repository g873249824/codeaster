#@ MODIF elements4 Messages  DATE 23/10/2007   AUTEUR COURTOIS M.COURTOIS 
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
  erreur dans le calcul de pres_f 
"""),

2 : _("""
 pour l'option "indic_ener", les seules relations admises sont "vmis_isot_line" et "vmis_isot_trac" .
"""),

3 : _("""
 pour l'option "indic_seuil", les seules relations admises sont "vmis_isot_line", "vmis_isot_trac"  et "vmis_cine_line" .
"""),

6 : _("""
 le type du champ de contraintes est incompatible avec l'option :  %(k1)s 
"""),

7 : _("""
 pas de contraintes dans pcontgp
"""),

8 : _("""
 pas de champ endo_elga dans ptriagp
"""),

9 : _("""
 pas de champ vari_elga dans pvarimr
"""),

10 : _("""
 pas de champ vari_elga dans pvaripr
"""),

11 : _("""
 option non trait�e  %(k1)s
 """),

15 : _("""
  deformation :  %(k1)s non implant�e sur les �l�ments "pou_d_tgm" : utiliser PETIT ou REAC_GEOM
"""),

16 : _("""
 option "vari_elno_elga" impossible actuellement
"""),

17 : _("""
 seuls comportements autorises :"elas" et "vmis_isot_trac"
"""),

20 : _("""
 pour l'�l�ment de poutre " %(k1)s " l'option " %(k2)s " est invalide
"""),

21 : _("""
 pour un �l�ment de poutre noeuds confondus :  %(k1)s 
"""),

22 : _("""
 les poutres � section variable ne sont pas trait�es.
"""),

23 : _("""
 comp_incr non disponible pour les elements enrichis avec x-fem.
"""),

31 : _("""
 dfdi mal dimensionn�e
"""),

32 : _("""
 vous utilisez le mot cl� liaison_elem avec l'option coq_pou: l'�paisseur des �l�ments de bord de coque n'a pas �t� affect�e.
"""),

33 : _("""
 l'epaisseur des �l�ments de bord de coque est negative ou nulle.
"""),

34 : _("""
 le jacobien est nul.
"""),

35 : _("""
 matns() sous-dimensionn�
"""),

36 : _("""
 pr() sous-dimensionne
"""),

37 : _("""
 nive_couche ne peut etre que "moy"
"""),

38 : _("""
 option  %(k1)s  non active pour un �l�ment de type  %(k2)s 
"""),

39 : _("""
 option  %(k1)s  : incompatibilit� des deux champs d entr�e
"""),

40 : _("""
 le nombre de ddl est trop grand
"""),

41 : _("""
 le nombre de ddl est faux
"""),

42 : _("""
 nom de type �l�ment inattendu
"""),

43 : _("""
 comp. elastique inexistant
"""),

44 : _("""
 l'option " %(k1)s " est interdite pour les tuyaux
"""),

45 : _("""
 l'option " %(k1)s " en rep�re local est interdite pour les tuyaux : utiliser le rep�re global
"""),

46 : _("""
 le nombre de couches et de secteurs doivent etre sup�rieurs a 0
"""),

47 : _("""
 composante  %(k1)s  non trait�e, on abandonne
"""),

48 : _("""
 champ  %(k1)s  non trait�, on abandonne
"""),

49 : _("""
 l'option " %(k1)s " est non pr�vue
"""),

51 : _("""
  nume_sect incorrect
"""),

52 : _("""
 mauvaise option
"""),

53 : _("""
 ep/r > 0.2 modi_metrique pas adapt�
"""),

54 : _("""
 ep/r > 0.2 modi_metrique=non pas adapt�
"""),

56 : _("""
 famille inexistante  %(k1)s 
"""),

57 : _("""
 indn = 1 (int�gration normale) ou indn = 0 (integration r�duite) obligatoirement.
"""),

58 : _("""
  le code " %(k1)s " est non pr�vu. code doit etre = "gl" ou "lg"
"""),

61 : _("""
 pr�conditions non remplies
"""),

62 : _("""
  erreur: �l�ment non 2d
"""),

63 : _("""
  l'option %(k1)s n'est pas disponible pour le comportement %(k2)s 
"""),

64 : _("""
  Il est impossible de calculer la normale au noeud %(k1)s de la maille %(k2)s.
  Des aretes doivent etre confondues.
"""),

65 : _("""
  Comportement inattendu : %(k1)s.
"""),

66 : _("""
  Il est impossible de calculer la contrainte d'arc.
  La normale � l'�l�ment et le vecteur obtenu � partir du mot-cl� ANGL_REP sont colin�aires.
"""),

68 : _("""
 Nombre d'it�rations internes insuffisant.
"""),

69 : _("""
 ! pb r�cuperation donn�e mat�riau dans thm_liqu %(k1)s !
"""),

72 : _("""
   rcvala ne trouve pas nu, qui est n�cessaire pour l'�l�ment MECA_HEXS8  
"""),

73 : _("""
   �l�ment MECA_HEXS8:COMP_ELAS non implant�, utiliser COMP_INCR RELATION='ELAS'  
"""),

74 : _("""
  Attention l'�l�ment MECA_HEXS8 ne fonctionne correctement que sur les parall�l�pip�des.
  Sur les elements quelconques on peut obtenir des r�sultats faux.   
"""),

75 : _("""
 la maille de numero:  %(i1)d appartient � plusieurs sous-domaines! %(i2)d 
"""),

76 : _("""
 la maille du mod�le de num�ro:  %(i1)d n appartient � aucun sous-domaine ! %(i2)d 
"""),

77 : _("""
 numero de couche  %(i1)d 
  trop grand par rapport au nombre de couches autoris� pour la maille  %(k1)s 
"""),

78 : _("""
 ! pb recuperation donn�e mat�riau dans thm_diffu %(k1)s !
"""),

79 : _("""
 la loi de comportement n'existe pas pour la mod�lisation dktg :  %(k1)s 
"""),

80 : _("""
 
 attention : l �l�ment de plaque quad4 d�fini sur la maille : %(k1)s n est pas plan et peut conduire a des r�sultats faux. 
  distance au plan :  %(r1)f 
"""),

81 : _("""
 manque le param�tre  %(k1)s pour la maille  %(k2)s 
"""),

83 : _("""
 utiliser "stat_non_line"  temp�rature inf:  %(r1)f   temp�rature moy:  %(r2)f 
 temp�rature sup:  %(r3)f 
"""),

84 : _("""
 famille non disponible �l�ment de r�f�rence  %(k1)s 
 famille  %(k2)s 
"""),

88 : _("""
 elrefe non disponible �l�ment de r�f�rence  %(k1)s 
"""),

90 : _("""
 elrefe mal programme maille  %(k1)s  type  %(k2)s  nb noeuds  %(i1)d 
 nb noeuds pour le gano  %(i2)d 
"""),

91 : _("""
 ! le calcul de cet estimateur !! ne tient pas compte d'�ventuelles ! %(i1)d 
 ! conditions limites non lin�aires   ! %(i2)d 
"""),

92 : _("""
 la pression doit etre nulle pour la maille  %(k1)s 
"""),

98 : _("""
 la contrainte equivalente est nulle pour la maille  %(k1)s 
"""),

}
