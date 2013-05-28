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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

1 : _(u"""
  -> Absence de localisation de points de Gauss dans le fichier MED
     pour l'�l�ment de r�f�rence %(k1)s.
     On suppose que l'ordre des points de Gauss est celui de Code_Aster.
  -> Risque & Conseil :
     Risque de r�sultats faux.
"""),

2 : _(u"""
  -> Le nombre de points de Gauss est diff�rent entre le fichier MED et Aster:
      - nombre de points de Gauss contenu dans le fichier MED : %(i2)d
      - nombre de points de Gauss d�fini dans Aster           : %(i1)d

     Visiblement les �l�ments finis d�crits dans le fichier MED ne sont pas les
     m�mes que dans Code_Aster.
     Si vous avez choisi PROL_ZERO='OUI', le champ sera initialis� � z�ro sur
     ces �l�ments.
     Sinon, le champ ne sera pas initialis� (NaN, not a number). C'est le
     comportement par d�faut.

  -> Risque & Conseil :
      - Choisissez des �l�ments finis compatibles entre Aster et le code tiers
"""),

3 : _(u"""
  -> Les point de Gauss MED/Aster ne correspondent pas g�om�triquement.
  -> Risque & Conseil:
     Risque de r�sultats faux � cause cette incompatibilit�.
"""),

4 : _(u"""

     Point De Gauss : %(i1)d              MED               ASTER
"""),

5 : _(u"""
        %(k1)s                          %(r1)f          %(r2)f
"""),

6 : _(u"""
  -> Une ou plusieurs permutations ont �t� effectu�es sur l'ordre des points
     de Gauss pour que la localisation MED corresponde � celle de Code_Aster.
"""),

7 : _(u"""
  -> Le nom de groupe num�ro %(i1)d de la famille %(k1)s
     est trop long. Il sera tronqu� � 24 caract�res.
     Le groupe "%(k2)s" est renomm� en "%(k3)s".
"""),

8 : _(u"""
  -> Famille %(k1)s :
       Incoh�rence sur les nombres de %(k2)s, il y en a %(i1)d alors
       que la fonction MED en annonce %(i2)d.
  -> Risque & Conseil:
       Impossible de lire ce fichier.
       On peut utiliser mdump (utilitaire MED) pour voir si le probl�me
       vient du fichier MED ou de la lecture dans Code_Aster.
"""),

9 : _(u"""
  -> Vous ne pouvez pas renommer le groupe "%(k1)s" en "%(k2)s"
     car "%(k2)s" existe d�j� dans le fichier MED.
"""),

10 : _(u"""
  -> Le nom de groupe num�ro %(i1)d de la famille %(k1)s
     est contient des caract�res interdits.
     Le groupe "%(k2)s" est renomm� en "%(k3)s".
"""),

11 : _(u"""
  -> Le nom de groupe num�ro %(i1)d de la famille %(k1)s
     est vide.
"""),

12 : _(u"""
  -> Erreur lors de l'appel � EFNEMA, code retour = %(k1)s
  -> Risque & Conseil :
     V�rifier l'int�grit� du fichier MED avec medconforme/mdump.
     Si le maillage a �t� produit par un code externe, v�rifier que les
     noms de maillage, de groupes, de familles ne contiennent pas de
     blancs � la fin.
     Dans Salom�, on peut renommer ces entit�s et supprimer les espaces
     invalides.
"""),

13 : _(u"""
  -> La famille %(k1)s n'a ni groupe, ni attribut.
"""),

14 : _(u"""
  -> Lecture de la famille num�ro %(i1)4d de nom %(k1)s.
"""),

15 : _(u"""
      Groupe num�ro %(i1)6d : %(k1)s
"""),

16 : _(u"""
      Groupe num�ro %(i1)6d : %(k1)s
                renomm� en : %(k2)s
"""),

17 : _(u"""
  -> Aucune famille n'est pr�sente dans ce fichier MED.
  -> Risque & Conseil :
     V�rifier l'int�grit� du fichier MED avec medconforme/mdump.
"""),

18 : _(u"""
  -> Arr�t en raison des conflits sur les noms de groupe.
"""),

19 : _(u"""
  -> Les mailles  %(k1)s ne sont pas nomm�es dans le fichier MED.
"""),

20 : _(u"""
  -> Impossible de retrouver l'adresse associ�e au groupe  %(k1)s
"""),

21 : _(u"""
  -> Il manque les coordonn�es !
"""),

22 : _(u"""
  Le nom de groupe num�ro  %(i1)d  est en double. %(k1)s
  - premier nom MED  :  %(k2)s
  - second nom MED   :  %(k3)s
  - nom aster retenu :  %(k4)s
"""),

23 : _(u"""
  -> Mailles  %(k1)s
"""),

24 : _(u"""
  -> Le fichier n'a pas �t� construit avec la m�me version de MED.
  -> Risque & Conseil :
     La lecture du fichier peut �chouer !

"""),

25 : _(u"""
   Version de la biblioth�que MED utilis�e par Code_Aster:  %(i1)d %(i2)d %(i3)d
"""),

26 : _(u"""
   Version de la biblioth�que MED qui a cr�� le fichier  : < 2.1.5
"""),

27 : _(u"""
   Version de la biblioth�que MED pour cr�er le fichier  :  %(i1)d %(i2)d %(i3)d
"""),

28 : _(u"""

   Un utilitaire vous permet peut-�tre de convertir votre fichier (medimport)
"""),

29 : _(u"""
  -> Il manque les mailles !
"""),

30: _(u"""
  -> Votre mod�le semble �tre compos� de plusieurs mod�lisations, les composantes
      de %(k1)s qui n'existent pas pour une partie du mod�le ont �t�
      mises � z�ro.

     Dans certains cas, le fichier MED produit peut devenir volumineux. Dans ce
     cas, l'utilisation du mot-cl� NOM_CMP est conseill�e.
"""),

31 : _(u"""
  -> Ce champ existe d�j� dans le fichier MED avec un nombre de composantes
     diff�rent � un instant pr�c�dent. On ne peut pas le cr�er de nouveau.

     Nom MED du champ : "%(k1)s"

  -> Risque & Conseil :
     On ne peut pas imprimer un champ dont le nombre de composantes varie en
     fonction du temps. Plusieurs possibilit�s s'offrent � vous:
     - si vous souhaitez disposer d'un champ disposant des m�mes composantes
     � chaque instant, il faut renseigner derri�re le mot-cl� NOM_CMP le nom
     des composantes commun aux diff�rents instants.
     - si vous souhaitez imprimer un champ avec l'ensemble des composantes
     Aster qu'il contient, il suffit de faire plusieurs IMPR_RESU et de
     renseigner pour chaque impression une liste d'instants ad hoc.

     Pour la visualisation dans Salom� (Scalar Map par exemple),
     s�lectionner la composante dans Scalar Range/Scalar Mode.
"""),

32 : _(u"""
     Le champ %(k1)s est inconnu dans le fichier MED.
"""),

33 : _(u"""
     Il manque des composantes.
"""),

34 : _(u"""
     Aucune valeur n'est pr�sente � cet instant.
"""),

35 : _(u"""
     Aucune valeur n'est pr�sente � ce num�ro d'ordre.
"""),

36 : _(u"""
     Le nombre de valeurs n'est pas correct.
"""),

37 : _(u"""
  -> La lecture est donc impossible.
  -> Risque & Conseil :
     Veuillez v�rifier l'int�grit� du fichier MED avec medconforme/mdump.
"""),

38 : _(u"""
  -> Incoh�rence catalogue - fortran (nbtyp fortran diff�rent de nbtyp catalogue)
"""),

39 : _(u"""
  -> Incoh�rence catalogue - fortran (nomtyp fortran diff�rent de nomtyp catalogue)
"""),

40 : _(u"""
  -> Ouverture du fichier MED en mode  %(k1)s  %(k2)s
"""),

41 : _(u"""
  -> Incoh�rence de version d�tect�e.
"""),

42 : _(u"""
  -> Le type d'entit�  %(k1)s  est inconnu.
"""),

43 : _(u"""
  -> Le maillage est introuvable !
"""),

44 : _(u"""
  -> Pas d'�criture pour  %(k1)s
"""),

45 : _(u"""
     Issu de  %(k1)s
"""),

46 : _(u"""
  -> Le type de champ est inconnu :  %(k1)s
"""),

47 : _(u"""
  -> Cr�ation des tableaux de valeurs � �crire avec :
"""),

48 : _(u"""
  -> Renum�rotation impossible avec plus d'un sous-point.
"""),

49 : _(u"""
  -> V�ritable �criture des tableaux de valeurs
"""),

50 : _(u"""
  -> Pas de maillage dans  %(k1)s
"""),

51 : _(u"""
  -> Maillage  %(k1)s  inconnu dans  %(k2)s
"""),

52 : _(u"""
  ->  Instant inconnu pour ce champ et ces supports dans le fichier.
"""),

53 : _(u"""
  ->  La version de la lib MED utilis�e par Code_Aster est plus r�cente que
      celle qui a produit votre fichier MED.
  ->  Cons�quence:  On consid�re les champs aux noeuds par �l�ment
      comme des pseudo champs aux points de Gauss.
      (On utilise pour la lecture du champ %(k1)s
       contenu dans votre fichier MED, le type d'entit� MED_MAILLE au lieu
       de MED_NOEUD_MAILLE).
"""),

54 : _(u"""
  -> Le mod�le fourni � LIRE_RESU n'est pas coh�rent avec le type de structure
     de donn�es r�sultat que vous souhaitez produire.
"""),


55 : _(u"""
  -> Lecture impossible pour  %(k1)s  au format MED
"""),

56 : _(u"""
     En effet, le ph�nom�ne %(k1)s de votre mod�le n'est pas compatible avec une
     SD R�sultat de type %(k2)s.
  -> Risque & Conseil :
     Veuillez fournir � LIRE_RESU un autre mod�le ou changer de TYPE_RESU.
"""),

57 : _(u"""
  -> Le champ  %(k1)s n'existe pas dans le fichier MED.
  -> Conseils :
     V�rifier la pr�sence du champ demand� dans le fichier.
     V�rifier l'int�grit� du fichier MED avec medconforme/mdump.

  Remarque : Les champs disponibles dans ce fichier sont list�s ci-dessous :
"""),

58 : _(u"""
  -> Le nombre de type de maille pr�sent dans le fichier MED est
      diff�rent du nombre de type de maille pr�sent dans le maillage fourni.
  -> Risque & Conseil :
     Le mod�le sur lequel le r�sultat a �t� cr�� n'est pas le m�me
      que le mod�le fourni.
     V�rifiez le maillage de votre mod�le !
"""),
59 : _(u"""
     Les �l�ments du mod�le fourni ont pour support g�om�trique des
     mailles ne figurant pas dans le fichier MED.
     Par exemple, il y %(i1)d mailles de types %(k1)s dans le fichier MED,
     alors que le mod�le en contient %(i2)d.
  -> Risque & Conseil :
     Veuillez fournir un mod�le dont le maillage correspond � celui pr�sent
     dans le fichier MED.
"""),

60 : _(u"""
  -> On ne traite pas les maillages distants.
"""),

61 : _(u"""
     Le maillage contenu dans le fichier MED contient plus de mailles
     que celui associ� au maillage fourni par le mod�le.
     Par exemple, on d�nombre %(i1)d mailles de types %(k1)s dans le maillage
     MED, alors que le mod�le n'en contient que %(i2)d !
  -> Risque & Conseil :
     Veuillez v�rifier que le mod�le fourni ne r�sulte pas d'une restriction,
     ou que l'un des maillages est quadratique et l'autre lin�aire.
"""),

62 : _(u"""
  -> Impossible de d�terminer un nom de maillage MED.
"""),

63 : _(u"""
  -> Le mot cl� "INFO_MAILLAGE" est r�serv� au format MED.
"""),

64 : _(u"""
  -> Le CARA_ELEM fournit � IMPR_RESU (%(k1)s) est diff�rent de celui lu
     dans le r�sultat a imprimer (%(k2)s). Cela n'est pas autoris�.
"""),

65 : _(u"""
  -> Grandeur inconnue.
"""),

66 : _(u"""
  -> Composante inconnue pour la grandeur.
"""),

67 : _(u"""
  -> Le maillage %(k2)s est d�j� pr�sent dans le fichier MED %(k1)s.
"""),

68 : _(u"""
  -> Instant voulu :  %(r1)f
"""),

69 : _(u"""
  -> Num�ro d'ordre :  %(i1)d num�ro de pas de temps :  %(i2)d

"""),

70 : _(u"""
  -> Trop de composantes pour la grandeur.
"""),

71 : _(u"""
  -> le mot-cl� MODELE est obligatoire pour lire un CHAM_ELEM
"""),

72 : _(u"""
  -> Nom de composante tronqu� � 8 caract�res ( %(k1)s  >>>  %(k2)s )
"""),

73 : _(u"""
  -> Impossible de trouver la composante ASTER associ�e a  %(k1)s
"""),

74 : _(u"""
  -> �criture des localisations des points de gauss.
"""),

75 : _(u"""
  -> Probl�me dans la lecture du nom du champ et de ses composantes.
"""),

76 : _(u"""
  -> Probl�me dans le diagnostic.
"""),

77: _(u"""
  -> On ne peut lire aucune valeur du champ %(k1)s dans le fichier d'unit� %(i1)d.
  -> Risques et conseils:
     Ce probl�me est peut-�tre li� � une incoh�rence entre le champ � lire dans
     le fichier MED (NOEU/ELGA/ELNO/...) et le type du champ que vous avez demand�
     (mot cl� TYPE_CHAM).
"""),

78: _(u"""
  Probl�me � l'ouverture du fichier MED sur l'unit� %(k1)s
  -> Conseil :
     V�rifier la pr�sence de ce fichier dans le r�pertoire de lancement de l'�tude.
"""),

79 : _(u"""
  -> Attention le maillage n'est pas de type non structur�
"""),

80 : _(u"""
  -> Le maillage ' %(k1)s ' est inconnu dans le fichier.
"""),

81 : _(u"""
  -> Attention, il s'agit d'un maillage structur�
"""),

82 : _(u"""
  -> Le champ %(k1)s n'est associ� � aucun mod�le.
  -> Conseil :
     Veuillez renseigner le mod�le.
"""),

83 : _(u"""
Le nombre de valeurs lues dans le fichier MED est diff�rent du nombre de valeurs r�ellement
 affect�es dans le champ :
  - valeurs lues dans le fichier        : %(i1)d
  - valeurs non affect�es dans le champ : %(i2)d

Risques :
  Soit le mod�le n'est pas adapt� au champ que vous souhaitez lire, auquel cas vous risquez
   d'obtenir des r�sultats faux. Soit le mod�le est constitu� d'un m�lange de mod�lisations
   qui ne portent pas les m�mes composantes sur les diff�rents �l�ments du maillage auquel
   cas, cette alarme n'est pas l�gitime.

Conseil :
  V�rifiez la coh�rence du mod�le et du fichier MED.
"""),

84 : _(u"""
  -> Type incorrect  %(i1)d
"""),

85 : _(u"""
  -> Maillage pr�sent :  %(k1)s
"""),

86 : _(u"""
  -> champ � lire :  %(k1)s typent :  %(i1)d typgeo :  %(i2)d
     instant voulu :  %(r1)f
     --> num�ro d'ordre :  %(i3)d
     --> num�ro de pas de temps :  %(i4)d

"""),

87 : _(u"""
  Le num�ro d'ordre %(i1)d que vous avez renseign� ne figure pas
  dans la liste des num�ros d'ordre du r�sultat MED.
  Cons�quence: le champ correspondant ne figurera pas dans la
  SD R�sultat %(k1)s
"""),


88 : _(u"""
  -> Fichier MED :  %(k1)s, nombre de maillages pr�sents : %(i1)d
"""),

89 : _(u"""
  -> �criture impossible pour  %(k1)s  au format MED.
"""),

90 : _(u"""
     D�but de l'�criture MED de  %(k1)s
"""),

91 : _(u"""
  -> Impossible de d�terminer un nom de champ MED.
  -> Risque & Conseil:
"""),

92 : _(u"""
  -> Le type de champ  %(k1)s  est inconnu pour MED.
  -> Risque & Conseil:
     Veuillez v�rifier la mise en donn�es du mot-cl� NOM_CHAM_MED
     (LIRE_RESU) ou NOM_MED (LIRE_CHAMP).
"""),

93 : _(u"""
     Fin de l'�criture MED de  %(k1)s
"""),

94 : _(u"""
  Vous imprimez un champ dont le maillage change au cours du temps.
  Ce type de champ n'est pas autoris�.
  -> Conseil :
     Si la structure de donn�es r�sultat a �t� produite par
     CREA_RESU, v�rifiez que les champs fournis � cette commande
     reposent sur un seul et m�me maillage.
"""),

95 : _(u"""
  -> Le champ MED %(k1)s est introuvable.
  -> Risque & Conseil:
     Veuillez v�rifier la mise en donn�es du mot-cl� NOM_CHAM_MED
     ainsi que le fichier MED fourni � l'op�rateur.
"""),

96 : _(u"""
  -> NOM_MED absent !
  -> Risque & Conseil:
     Veuillez renseigner le mot-cl� NOM_MED de l'op�rateur LIRE_CHAMP.
"""),

97 : _(u"""
  -> Fichier MED :  %(k1)s, Champ :  %(k2)s, Instant voulu :  %(r1)f
     - typent :  %(i1)d
     - typgeo :  %(i2)d

"""),

98 : _(u"""
  -> Fichier MED :  %(k1)s champ :  %(k2)s
"""),

99 : _(u"""
  Le nombre de composantes � imprimer est trop grand pour le champ %(k1)s.
  Le format MED accepte au maximum 80 composantes dans un champ.
  
  Le champ ne sera donc pas imprim� au format MED.
"""),

}
