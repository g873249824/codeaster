#@ MODIF algorith5 Messages  DATE 11/09/2007   AUTEUR DURAND C.DURAND 
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
 le type de r�sultat DYNA_TRANS ne supporte pas les donn�es complexes
"""),

2: _("""
 le type de r�sultat DYNA_HARMO ne supporte pas les donn�es reelles
"""),

3: _("""
 on ne traite pas actuellement les d�formations complexes
"""),

4: _("""
 nombre de dataset 58 sup�rieur � NBNOEUD * NBCMP 
"""),

5: _("""
 erreur dans la lecture du fichier IDEAS
"""),

6: _("""
 seules les donn�es de type d�placement, vitesse, acc�l�ration, d�formation
 ou contrainte sont actuellement trait�es 
"""),

7: _("""
 donn�es : complexes, incompatibles avec DYNA_TRANS
"""),

8: _("""
 donn�es : r�elles, incompatibles avec DYNA_HARMO ou HARM_GENE
"""),

9: _("""
 on ne traite pas actuellement la red�finition des orientations
 pour les champs de contrainte 
"""),

10: _("""
 on ne traite pas actuellement la red�finition des orientations
 pour les champs de d�formation 
"""),

11: _("""
 la condition GAMMA/KSI <= 1 n'est pas respect�e
"""),

12: _("""
 incoh�rence des relations SIGMA_C SIGMA_P1 M_PIC A_PIC A_E et M_E
"""),

13: _("""
 erreur d'int�gration
 - essai d'int�gration num�ro  %(k1)s
 - divergence de l'int�gration locale
 - red�coupage du pas de temps
"""),

14: _("""
  incr�ment de deformation cumul�e (dv) = - %(k1)s 
"""),

15: _("""
 type d'�l�ment fini pas trait�
"""),

16: _("""
 le profil de la matrice n est surement pas plein.
 on continue mais s'il vous arrive des probl�mes plus loin...
"""),

17: _("""
 le profil de la matrice n'est surement pas plein.
 on continue mais attention ....
"""),

18: _("""
 le profil de la matrice n'est pas plein.
 on arrete tout ....
"""),

19: _("""
 matrice singuli�re
"""),

20: _("""
 inversion seulement en dimension 3
"""),

21: _("""
 type de maille inconnu (dvlp)
"""),

22: _("""
 la matrice masse est singuli�re.
"""),

23: _("""
 pas de temps minimal atteint
"""),

24: _("""
 donn�es errone�s.
"""),

25: _("""
  GAMMA = 0 : valeur par d�faut 
"""),

26: _("""
  dispositif anti-sismique :  la distance des noeuds 1 et 2 est nulle
"""),

27: _("""
 le noeud  %(k1)s  n'est pas un noeud du maillage  %(k2)s 
"""),

28: _("""
 on n'a pas trouv� le ddl "DX" pour le noeud  %(k1)s 
"""),

29: _("""
 on n'a pas trouv� le ddl "DY" pour le noeud  %(k1)s 
"""),

30: _("""
 on n'a pas trouv� le ddl "DZ" pour le noeud  %(k1)s 
"""),

31: _("""
 calcul non-lin�aire par sous-structuration :
 le mot-cle SOUS_STRUC_1 est obligatoire
"""),

32: _("""
 argument du mot-cle "SOUS_STRUC_1" n'est pas un nom de sous-structure
"""),

33: _("""
 calcul non-lin�aire par sous-structuration entre 2 structures mobiles :
 le mot-cl� SOUS_STRUC_2 est obligatoire
"""),

34: _("""
 l'argument du mot-cl� "SOUS_STRUC_2" n'est pas un nom de sous-structure
"""),

35: _("""
  obstacle BI_CERC_INT : DIST_2 doit etre sup�rieur ou �gal a DIST_1
"""),

36: _("""
 calcul non-lin�aire par sous-structuration :
 pas de dispositif anti-sismique ou de flambage possible 
"""),

37: _("""
 le multi-appui + sous-structuration n'est pas developp� - bon courage
"""),

38: _("""
 conflit entre choc et flambage au meme lieu de choc :
 le calcul sera de type flambage
"""),

39: _("""
 argument du mot-cle "REPERE" inconnu
"""),

40: _("""
 les rigidit�s de chocs doivent etre strictement positives
"""),

41: _("""
 incoh�rence dans les donn�es de la loi de flambage :
 les caract�ristiques introduites peuvent conduire �
 un ecrasement r�siduel n�gatif 
"""),

42: _("""
 les bases utilis�es pour la projection sont diff�rentes.
"""),

43: _("""
 les bases utilis�es n'ont pas le meme nombre de vecteurs.
"""),

44: _("""
 les num�rotations des matrices sont diff�rentes.
"""),

45: _("""
 les num�rotations des vecteurs d'excitation sont diff�rentes.
"""),

46: _("""
 on n'a pas pu trouver les d�placements initiaux 
"""),

47: _("""
 on n'a pas pu trouver les vitesses initiales 
"""),

48: _("""
 on n'a pas pu trouver les variables internes initiales :
 reprise choc avec flambage 
"""),

49: _("""
 absence de terme de forcage externe.
 l'algorithme ITMI n'est pas pr�vu pour calculer la r�ponse libre
 d'une structure.
"""),

50: _("""
 abscence de non-lin�arites de choc.
 pour traiter le r�gime lin�aire, pr�ciser une non-lin�arit� de choc
 avec un jeu important.
"""),

51: _("""
 impossible de traiter le type d'obstacle choisi avec methode ITMI
 (obstacle de type  %(k1)s  au noeud  %(k2)s ).
"""),

52: _("""
 dur�e de la simulation temporelle apr�s transitoire inf�rieure �
 la dur�e demand�e (excitation temporelle trop courte)
"""),

53: _("""
 variation du d�placement entre deux instants successifs sup�rieure �
 la valeur de tol�rance propos�e
"""),

54: _("""
 le calcul de la r�ponse temporelle n'est pas possible pour le type
 de structure etudi�e.
"""),

55: _("""
 le couplage fluide-structure n'a pas �t� pris en compte en amont.
"""),

56: _("""
 NB_MODE est superieur au nombre de modes du concept  %(k1)s .
 on impose donc NB_MODE =  %(k2)s ,
 i.e. �gal au nombre de modes du concept  %(k3)s .
"""),

58: _("""
 le calcul des param�tres du mode no %(k1)s  par l'op�rateur <CALC_FLUI_STRU>
 n'a pas converg� pour la vitesse no %(k2)s .
 le calcul de la r�ponse dynamique de la sructure n'est donc pas possible.
"""),

59: _("""
 pas de mot-cle <NB_MODE_FLUI>.
 les  %(k1)s  modes du concept  %(k2)s  sont pris en compte pour le calcul
 du saut de force fluidelastique d'amortissement au cours des phases de choc.
"""),

60: _("""
 NB_MODE_FLUI est plus grand que le nombre de modes du concept  %(k1)s .
 %(k2)s  modes sont pris en compte pour le calcul du saut de force fluidelastique
 d'amortissement au cours des phases de choc.
"""),

61: _("""
 la matrice KTILDA est singuli�re.
"""),

62: _("""
  instant initial non trouv�
  valeur prise : 0 
"""),

63: _("""
 RELA_EFFO_DEPL par sous-structuration, le mot-cle SOUS_STRUC est obligatoire
"""),

64: _("""
 l'argument du mot-cle "SOUS_STRUC" n'est pas un nom de sous-structure
"""),

65: _("""
 type de base inconnu.
"""),

66: _("""
 le taux de souplesse neglig�e est sup�rieur au seuil.
"""),

67: _("""
 algorithme de DEVOGE: d�veloppement "AMOR_GENE" non implant�.
"""),

68: _("""
 algorithme ITMI :
 il faut renseigner obligatoirement l'un ou l'autre des mots cles :
 AMOR_REDUIT, AMOR_GENE
"""),

69: _("""
 algorithme ITMI :
 il faut renseigner obligatoirement les mots-cles
 BASE_ELAS_FLUI et NUME_VITE_FLUI
 pour d�finir une base modale sous �coulement
"""),

70: _("""
 algorithme ITMI :
 il faut renseigner obligatoirement le mot cle PAS ,
 i.e. donner la valeur du pas de temps initial
"""),

71: _("""
 algorithme ITMI : lorsque l'on affecte "OUI" � ETAT_STAT,
 il faut renseigner TS_REG_ETAB
"""),

72: _("""
 calcul non-lin�aire par sous-structuration :
 option SOUS_STRUC_1 non implant�e dans la methode ITMI.
"""),

73: _("""
  l'option NOEUD_2 n'est pas implant�e dans la methode ITMI.
"""),

74: _("""
 calcul non-lin�aire par sous-structuration :
 option SOUS_STRUC_2 non implant�e dans la methode ITMI.
"""),

75: _("""
 algorithme de NEWMARK: d�veloppement %(k1)s non implant�.
"""),

76: _("""
 NUME_ORDRE plus grand que le nombre de modes de la base
"""),

78: _("""
 mauvaise d�finition de l'excitation
 mot cl� VECT_GENE non autoris� pour ITMI
"""),

79: _("""
 KSIB non inversible
"""),

82: _("""
 projection nulle sur la boule unit� (dvlp)
"""),

83: _("""
 �tat de contact inconnu
"""),

84: _("""
 champ de g�ometrie introuvable (dvlp)
"""),

85: _("""
 �chec dans le traitement du contact, augmenter ITER_CONT_MAX
"""),

86: _("""
  -> Il y a convergence forc�e sur boucle contraintes actives lors du traitement
     du contact.
  -> Risque & Conseil :
     La convergence forc�e se d�clenche lorsque le probl�me a du mal � converger. Il y a des risques que le probl�me 
     soit un peu moins bien trait�. V�rifiez bien que vous n'avez pas d'interp�n�tration entre les mailles. S'il y des 
     interp�n�trations intempestives, tentez de d�couper plus finement en temps votre probl�me.
"""),

87: _("""
  -> Il y a convergence forc�e sur boucle seuil frottement lors du traitement du
     contact.
  -> Risque & Conseil :
     La convergence forc�e se d�clenche lorsque le probl�me a du mal � converger. Il y a des risques que le probl�me 
     soit un peu moins bien trait�. La condition de frottement de Coulomb est peut etre mal prise en compte. Risque de 
     r�sultats faux sur les forces d'adh�rence. Essayez de d�couper plus finement en temps votre probl�me.
"""),

88: _("""
  -> Il y a convergence forc�e sur boucle de g�om�trie lors du traitement du
     contact.
  -> Risque & Conseil :
     La convergence forc�e se d�clenche lorsque le probl�me a du mal � converger
     lors de grands glissements relatifs entre deux surfaces de contact.
     Il y a des risques que le probl�me soit un peu moins bien trait�.
     V�rifiez bien que vous n'avez pas d'interp�n�tration entre les mailles.
      S'il y des interp�n�trations intempestives, tentez de d�couper plus finement en temps votre probl�me.
"""),

89: _("""
 �l�ment de contact inconnu (dvlp)
"""),

90: _("""
 nom de l'�l�ment inconnu
"""),

91: _("""
 sch�ma d'integration non conforme
"""),

92: _("""
 �l�ment de contact non conforme (dvlp)
"""),

93: _("""
 dimension de l'espace incorrecte (dvlp)
"""),

}
