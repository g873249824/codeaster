#@ MODIF algorith11 Messages  DATE 30/04/2007   AUTEUR ABBAS M.ABBAS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1: _("""
 le sup de kmod0 est nul. on prend le sup de kmod.
"""),

2: _("""
 le sup de kmod est nul.
"""),

3: _("""
 la variable amor est nulle
"""),

4: _("""
 erreur de dimension (dvlp)
"""),

5: _("""
 force normale nulle.
"""),

6: _("""
 somme des "impacts-ecrouissage" < somme des "glissement"
"""),

7: _("""
 "nom_cas" n'est pas une variable d'acces d'un resultat de type "evol_ther".
"""),

8: _("""
 "nume_mode" n'est pas une variable d'acces d'un resultat de type "evol_ther".
"""),

9: _("""
 "nume_mode" n'est pas une variable d'acces d'un resultat de type "mult_elas".
"""),

10: _("""
 "inst" n'est pas une variable d'acces d'un resultat de type "mult_elas".
"""),

11: _("""
 "nom_cas" n'est pas une variable d'acces d'un resultat de type "fourier_elas".
"""),

12: _("""
 "inst" n'est pas une variable d'acces d'un resultat de type "fourier_elas".
"""),

13: _("""
 "nom_cas" n'est pas une variable d'acces d'un resultat de type "fourier_ther".
"""),

14: _("""
 "inst" n'est pas une variable d'acces d'un resultat de type "fourier_ther".
"""),

15: _("""
 "resu_init" est obligatoire
"""),

16: _("""
 "maillage_init" est obligatoire
"""),

17: _("""
 "resu_final" est obligatoire
"""),

18: _("""
 "maillage_final" est obligatoire
"""),

19: _("""
 3 valeurs pour "tran"
"""),

20: _("""
 typcal invalide :  %(k1)s 
"""),

24: _("""
 absence de potentiel permanent. on  arrete tout.
"""),

25: _("""
 le modele fluide n est pas thermique!!!. on  arrete tout.
"""),

26: _("""
 le modele interface n est pas thermique!!!. on  arrete tout.
"""),

27: _("""
 modele fluide incompatible avec le calcul de masse ajoutee. seules les modelisations plan ou 3d ou axis sont utilisees.
"""),

28: _("""
 on ne trouve pas de champ de temperature chtn
"""),

29: _("""
 le nombre d'amortissement modaux est different du nombre de modes dynamiques
"""),

30: _("""
 il n y a pas le meme nombre de modes retenus dans l'excitation modale et dans la base modale
"""),

31: _("""
 il faut autant d'indices en i et j
"""),

32: _("""
 avec sour_press et sour_force il faut deux points/ddls d'application
"""),

33: _("""
 mauvais accord entre nombre d'appuis et nombre de valeur dans le mot-clef: nume_ordre_i
"""),

34: _("""
 il faut autant de nom de composante que de nom de noeud
"""),

35: _("""
  vous avez oublie de preciser le mode statique
"""),

36: _("""
  mode statique non- necessaire
"""),

37: _("""
 la frequence mini doit etre etre plus faible que la frequence max
"""),

38: _("""
 trop de points dans la liste.
"""),

39: _("""
 segment nul
"""),

40: _("""
 la base locale semble fausse
"""),

41: _("""
 la discretisation du fond de fissure est grossiere par rapport a la courbure du fond de fissure. possibilite de resultats faux. il faudrait raffiner le maillage autour du fond de fissure.
"""),

42: _("""
 nombre de points d'intersection impossible.
"""),

43: _("""
 probleme de dimension :ni 2d, ni 3d
"""),


45: _("""
 inter douteuse
"""),

46: _("""
 trop de points d intersection
"""),

47: _("""
 probleme de decoupage a 3 pts
"""),

48: _("""
 probleme de decoupage a 4 pts
"""),

49: _("""
 uniquement c_plan/d_plan disponible  en xfem
"""),

51: _("""
 mailles manquantes
"""),

52: _("""
 point de fond_fiss sans maille de surfface rattachee.
"""),

53: _("""
 pb dans orientation des normales a fond_fiss. verifier la continuite des mailles de fond_fiss
"""),

54: _("""
 segment de fond_fiss sans maille de surface rattachee.
"""),

55: _("""
 augmenter nxmafi
"""),

56: _("""
  -> Lors de l'enregistrement du champ d'archivage du contact, il s'est av�r�
     que les valeurs de contact au noeud %(k1)s diff�rents selon la maille sur
     laquelle se trouve ce noeud.
  -> Risque & Conseil :
     Ce message est normal si le contact est activ� sur la fissure.
"""),







61: _("""
  -> Lors de l'orientation des points du fond de fissure, le point du fond de
     fissure initial (PFON_INI) est trop loin du fond de fissure.
  -> Risque & Conseil :
     Le point initial qui en r�sulte am�ne surement � une orientation du fond
     de fissure erron�e.
     Veuillez red�finir le point du fond de fissure initial (mot cl� PFON_INI).

"""),

62: _("""
 pfon_ini = pt_origine
"""),

63: _("""
 probleme dans l orientation du fond de fissure : pt_origin mal choisi.
"""),

64: _("""
 tous les points du fond de fissure sont des points de bord. assurez-vous du bon choix des parametres d'orientation de fissure et de pfon_ini.
"""),

65: _("""
 pfon_ini semble etre un point de fin de fissure selon l'orientation choisie. assurez-vous du bon choix de pfon_ini.
"""),

66: _("""
 la methode "upwind" est en cours d'implementation.
"""),

67: _("""
 les aretes de la maille  %(k1)s  ( %(k2)s ) ont  %(k3)s  points d'intersection avec l'isozero de  %(k4)s  !!!
"""),

68: _("""
 probleme pour  recuperer ar_min dans la table "cara_geom"
"""),

69: _("""
 armin negatif ou nul
"""),

70: _("""
 augmenter nxptff
"""),

71: _("""
 le critere de modification de l'enrichissement heaviside servant a eviter les pivots nuls a abouti a un cas de figure qui semble bizarre. normalement, on doit avoir un hexaedre coupe dans un coin (3 points d'intersection), or la, on a un  %(k1)s avec  %(k2)s  points d'intersetion.
"""),

72: _("""
 aucune arete sur laquelle lsn s annule
"""),

73: _("""
 taille limite d10 non defini
"""),

74: _("""
 echec de la recherche de zero (niter)
"""),

75: _("""
 echec de la recherche de zero (bornes)
"""),

76: _("""
 f(xmin) non negative
"""),

77: _("""
 f=0 : augmenter iter_inte_maxi
"""),

78: _("""
 polynome non resolu
"""),

79: _("""
 pas d'interpolation possible.
"""),

81: _("""
 STOP_SINGULIER=DECOUPE n�cessite la subdivision automatique du pas de temps (SUBD_PAS).
"""),
82: _("""
 nmvpir erreur dir grandissement. Angle ALPHA %(k1)s. Angle BETA %(k2)s.
"""),
83: _("""
 Arret par manque de temps CPU.
"""),

85: _("""
 On veut affecter un comportement %(k1)s avec la relation %(k2)s sur une maille deja affectee par un autre comportement %(k3)s %(k4)s
"""),
86: _("""
 Perturbation trop petite, calcul impossible
"""),
87: _("""
 *** Champ d�j� existant ***
 Le champ %(k1)s � l'instant %(r1)g est remplac� par le champ %(k2)s � l'instant %(r2)g avec la pr�cision %(r3)g.
"""),

88: _("""
 &arret debordement assemblage:ligne 
"""),

90: _("""
 &arret debordement assemblage:colonne 
"""),

92: _("""
 arret nombre de sous-structure invalide il en faut au minimum: %(i1)d 
 vous en avez defini: %(i2)d 
"""),

93: _("""
 arret nombre de nom de sous-structure invalide il en faut exactement: %(i1)d 
 vous en avez defini: %(i2)d 
"""),

94: _("""
 nombre de macr_elem invalide sous_structure %(k1)s vous en avez defini: %(i1)d 
 il en faut exactement: %(i2)d 
"""),

95: _("""
 nombre d'angles nautiques invalide sous_structure %(k1)s 
 vous en avez defini: %(i1)d 
 il en faut exactement:  %(i2)d 
"""),

96: _("""
 nombre de translation invalide sous_structure %(k1)s vous en avez defini: %(i1)d 
 il en faut exactement:  %(i2)d 
"""),

97: _("""
 nombre de liaison definies invalide vous en avez defini: %(i1)d 
 il en faut au minimum: %(i2)d 
"""),

98: _("""
 nombre de mot-cle invalide numero liaison: %(i1)d mot-cle: %(k1)s 
 vous en avez defini: %(i2)d 
 il en faut exactement: %(i3)d 
"""),

99: _("""
 sous-structure indefinie numero liaison: %(i1)d nom sous-structure: %(k1)s 
"""),

}
