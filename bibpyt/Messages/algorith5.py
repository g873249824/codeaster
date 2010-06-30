#@ MODIF algorith5 Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg = {

1 : _("""
Le type de r�sultat DYNA_TRANS ne supporte pas les donn�es complexes.
"""),

2 : _("""
Le type de r�sultat DYNA_HARMO ne supporte pas les donn�es r�elles.
"""),

3 : _("""
On ne traite pas les d�formations complexes.
"""),

4 : _("""
Le nombre de dataset de type 58 est sup�rieur � NBNOEUD * NBCMP 
"""),

5 : _("""
Erreur lors de la lecture du fichier IDEAS.
"""),

6 : _("""
Seules les donn�es de type d�placement, vitesse, acc�l�ration, d�formation
 ou contrainte sont trait�es. 
"""),

9 : _("""
On ne traite pas la red�finition des orientations pour les champs de contrainte. 
"""),

10 : _("""
On ne traite pas la red�finition des orientations pour les champs de d�formation. 
"""),

11 : _("""
La condition GAMMA/KSI <= 1 n'est pas respect�e.
"""),

12 : _("""
Incoh�rence des relations SIGMA_C, SIGMA_P1, M_PIC, A_PIC, A_E et M_E.
"""),

16 : _("""
Le profil de la matrice n'est s�rement pas plein.
On continue pour v�rifier.
"""),

17 : _("""
Le profil de la matrice n'est s�rement pas plein.
On continue pour v�rifier.
"""),

18 : _("""
Le profil de la matrice n'est pas plein.
On arr�te tout.
"""),

19 : _("""
Le d�terminant de la matrice � inverser est nul.
"""),

20 : _("""
L'inversion est posssible uniquement en dimension inf�rieure ou �gale � 3.
"""),

22 : _("""
La matrice masse est singuli�re.
"""),

23 : _("""
Le pas de temps minimal a �t� atteint. Ha !
"""),

24 : _("""
Donn�es erron�es.
"""),

25 : _("""
GAMMA nul est la valeur par d�faut. 
"""),

26 : _("""
Dispositif anti-sismique :  la distance entre les noeuds 1 et 2 est nulle.
"""),

27 : _("""
Le noeud  %(k1)s  n'est pas un noeud du maillage %(k2)s .
"""),

28 : _("""
On n'a pas trouv� le ddl DX pour le noeud  %(k1)s .
"""),

29 : _("""
On n'a pas trouv� le ddl DY pour le noeud  %(k1)s .
"""),

30 : _("""
On n'a pas trouv� le ddl DZ pour le noeud  %(k1)s .
"""),

31 : _("""
 calcul non-lin�aire par sous-structuration :
 le mot-cle SOUS_STRUC_1 est obligatoire
"""),

32 : _("""
 argument du mot-cle "SOUS_STRUC_1" n'est pas un nom de sous-structure
"""),

33 : _("""
 calcul non-lin�aire par sous-structuration entre 2 structures mobiles :
 le mot-cl� SOUS_STRUC_2 est obligatoire
"""),

34 : _("""
 l'argument du mot-cl� "SOUS_STRUC_2" n'est pas un nom de sous-structure
"""),

35 : _("""
  obstacle BI_CERC_INT : DIST_2 doit etre sup�rieur ou �gal a DIST_1
"""),

36 : _("""
 calcul non-lin�aire par sous-structuration :
 pas de dispositif anti-sismique ou de flambage possible 
"""),

37 : _("""
 le multi-appui + sous-structuration n'est pas developp� - bon courage
"""),

38 : _("""
 conflit entre choc et flambage au meme lieu de choc :
 le calcul sera de type flambage
"""),

39 : _("""
 argument du mot-cle "REPERE" inconnu
"""),

40 : _("""
 les rigidit�s de chocs doivent etre strictement positives
"""),

41 : _("""
 incoh�rence dans les donn�es de la loi de flambage :
 les caract�ristiques introduites peuvent conduire �
 un ecrasement r�siduel n�gatif 
"""),

42 : _("""
 les bases utilis�es pour la projection sont diff�rentes.
"""),

43 : _("""
 les bases utilis�es n'ont pas le meme nombre de vecteurs.
"""),

44 : _("""
 les num�rotations des matrices sont diff�rentes.
"""),

45 : _("""
 les num�rotations des vecteurs d'excitation sont diff�rentes.
"""),

46 : _("""
 on n'a pas pu trouver les d�placements initiaux 
"""),

47 : _("""
 on n'a pas pu trouver les vitesses initiales 
"""),

48 : _("""
 on n'a pas pu trouver les variables internes initiales :
 reprise choc avec flambage 
"""),

49 : _("""
 absence de terme de forcage externe.
 l'algorithme ITMI n'est pas pr�vu pour calculer la r�ponse libre
 d'une structure.
"""),

50 : _("""
 abscence de non-lin�arites de choc.
 pour traiter le r�gime lin�aire, pr�ciser une non-lin�arit� de choc
 avec un jeu important.
"""),

51 : _("""
 impossible de traiter le type d'obstacle choisi avec methode ITMI
 (obstacle de type  %(k1)s  au noeud  %(k2)s ).
"""),

52 : _("""
 dur�e de la simulation temporelle apr�s transitoire inf�rieure �
 la dur�e demand�e (excitation temporelle trop courte)
"""),

53 : _("""
 variation du d�placement entre deux instants successifs sup�rieure �
 la valeur de tol�rance propos�e
"""),

54 : _("""
 le calcul de la r�ponse temporelle n'est pas possible pour le type
 de structure etudi�e.
"""),

55 : _("""
 le couplage fluide-structure n'a pas �t� pris en compte en amont.
"""),

56 : _("""
 NB_MODE est superieur au nombre de modes du concept  %(k1)s .
 on impose donc NB_MODE =  %(k2)s ,
 i.e. �gal au nombre de modes du concept  %(k3)s .
"""),

58 : _("""
 le calcul des param�tres du mode no %(k1)s  par l'op�rateur <CALC_FLUI_STRU>
 n'a pas converg� pour la vitesse no %(k2)s .
 le calcul de la r�ponse dynamique de la sructure n'est donc pas possible.
"""),

59 : _("""
 pas de mot-cle <NB_MODE_FLUI>.
 les  %(k1)s  modes du concept  %(k2)s  sont pris en compte pour le calcul
 du saut de force fluidelastique d'amortissement au cours des phases de choc.
"""),

60 : _("""
 NB_MODE_FLUI est plus grand que le nombre de modes du concept  %(k1)s .
 %(k2)s  modes sont pris en compte pour le calcul du saut de force fluidelastique
 d'amortissement au cours des phases de choc.
"""),

61 : _("""
 la matrice KTILDA est singuli�re.
"""),

62 : _("""
  instant initial non trouv�
  valeur prise : 0 
"""),

63 : _("""
 RELA_EFFO_DEPL par sous-structuration, le mot-cle SOUS_STRUC est obligatoire
"""),

64 : _("""
 l'argument du mot-cle "SOUS_STRUC" n'est pas un nom de sous-structure
"""),

65 : _("""
 type de base inconnu.
"""),

66 : _("""
 le taux de souplesse neglig�e est sup�rieur au seuil.
"""),

67 : _("""
 algorithme de DEVOGE: d�veloppement "AMOR_GENE" non implant�.
"""),

68 : _("""
 algorithme ITMI :
 il faut renseigner obligatoirement l'un ou l'autre des mots cles :
 AMOR_REDUIT, AMOR_GENE
"""),

69 : _("""
 algorithme ITMI :
 il faut renseigner obligatoirement les mots-cles
 BASE_ELAS_FLUI et NUME_VITE_FLUI
 pour d�finir une base modale sous �coulement
"""),

70 : _("""
 algorithme ITMI :
 il faut renseigner obligatoirement le mot cle PAS ,
 i.e. donner la valeur du pas de temps initial
"""),

71 : _("""
 algorithme ITMI : lorsque l'on affecte "OUI" � ETAT_STAT,
 il faut renseigner TS_REG_ETAB
"""),

72 : _("""
 calcul non-lin�aire par sous-structuration :
 option SOUS_STRUC_1 non implant�e dans la methode ITMI.
"""),

73 : _("""
  l'option NOEUD_2 n'est pas implant�e dans la methode ITMI.
"""),

74 : _("""
 calcul non-lin�aire par sous-structuration :
 option SOUS_STRUC_2 non implant�e dans la methode ITMI.
"""),

75 : _("""
 algorithme de NEWMARK: d�veloppement %(k1)s non implant�.
"""),

76 : _("""
 NUME_ORDRE plus grand que le nombre de modes de la base
"""),

78 : _("""
 mauvaise d�finition de l'excitation
 mot cl� VECT_GENE non autoris� pour ITMI
"""),

79 : _("""
 KSIB non inversible
"""),

}
