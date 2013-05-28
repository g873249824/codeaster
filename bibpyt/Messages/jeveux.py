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
La limite m�moire demand�e de %(r1).0f octets est sup�rieure
au maximum adressable sur cette plate-forme (%(r2).0f octets).

Conseil :
    Diminuez la m�moire totale demand�e pour le calcul.
"""),

2 : _(u"""
 Pointeur de longueur externe interdit maintenant.
"""),

6 : _(u"""
 Erreur de programmation :

  Appel invalide, la marque devient n�gative
"""),

7 : _(u"""
 Destruction de  %(k1)s
"""),

8 : _(u"""
 La base  %(k1)s  a �t� constitu�e avec la version  %(k2)s
 et vous utilisez la version  %(k3)s
"""),

10 : _(u"""
 Erreur de programmation :

 Le nom demand� existe d�j� dans la base %(k1)s
"""),

11 : _(u"""
 Erreur lors de la fermeture de la base  %(k1)s
"""),

12 : _(u"""
 Fichier associ� � la base  %(k1)s  inexistant
"""),

13 : _(u"""
 Erreur de lecture du premier bloc de  %(k1)s
"""),

14 : _(u"""
 Erreur lors de la fermeture de  %(k1)s
"""),

18 : _(u"""
 Le segment de valeurs associ� � l'objet : %(k1)s, n'existe pas en m�moire et
 l'objet ne poss�de pas d'image disque.
"""),

19 : _(u"""
 Le nom d'un objet JEVEUX ne doit pas commencer par un blanc.
"""),

21 : _(u"""

     R�ouverture de la base

     Nom de la base                          :  %(k1)s
     Cr��e avec la version                   :  %(k2)s
     Nombre d'enregistrements utilis�s       :  %(i1)d
     Nombre d'enregistrements maximum        :  %(i2)d
     Longueur d'enregistrement (octets)      :  %(i3)d
     Nombre d'identificateurs utilis�s       :  %(i4)d
     Taille maximum du r�pertoire            :  %(i5)d
     Pourcentage d'utilisation du r�pertoire :  %(i6)d %%
"""),

22 : _(u"""

     Fermeture de la base

     Nom de la base                          :  %(k1)s
     Nombre d'enregistrements utilis�s       :  %(i1)d
     Nombre d'enregistrements maximum        :  %(i2)d
     Longueur d'enregistrement (octets)      :  %(i3)d
     Nombre total d'acc�s en lecture         :  %(i4)d
     Volume des acc�s en lecture             :  %(r1)12.2f Mo.
     Nombre total d'acc�s en �criture        :  %(i5)d
     Volume des acc�s en �criture            :  %(r2)12.2f Mo.
     Nombre d'identificateurs utilis�s       :  %(i6)d
     Taille maximum du r�pertoire            :  %(i7)d
     Pourcentage d'utilisation du r�pertoire :  %(i8)d %%
"""),

23 : _(u"""
     Nom de Collection ou de R�pertoire de noms inexistant :  %(k1)s
"""),

24 : _(u"""
     JENONU : Collection ou R�pertoire de noms  :  %(k1)s
     Il faut passer par JEXNOM,JEXNUM.
"""),

25 : _(u"""
     Nom de collection ou de r�pertoire inexistant : >%(k1)s<
"""),

26 : _(u"""
     Objet JEVEUX inexistant dans les bases ouvertes : >%(k1)s<
     l'objet n'a pas �t� cr�� ou il a �t� d�truit
"""),

27 : _(u"""
     Objet simple JEVEUX inexistant en m�moire et sur disque : >%(k1)s<
     le segment de valeurs est introuvable
"""),

28 : _(u"""
     Collection JEVEUX inexistant en m�moire et sur disque : >%(k1)s<
     le segment de valeurs est introuvable
"""),

29 : _(u"""
     Objet %(i1)d de collection JEVEUX inexistant en m�moire et sur disque : >%(k1)s<
"""),

30 : _(u"""
     Objet de collection JEVEUX inexistant : >%(k1)s<
     l'objet n'a pas �t� cr�� ou il a �t� d�truit
"""),

31 : _(u"""
     Erreur programmeur :
     La routine JUVECA n'a pas pr�vu de redimensionner l'objet :%(k1)s
     de type :%(k2)s
"""),

36 : _(u"""
     Le nombre d'enregistrements maximum de la base %(k1)s sera modifi�
     de %(i1)d a %(i2)d
"""),

38 : _(u"""
     Num�ro d'objet invalide %(i1)d
"""),

39 : _(u"""
     Taille de r�pertoire demand� trop grande.
     Le maximum est de %(i1)d
     La valeur r�clam�e est de %(i2)d

"""),

40 : _(u"""
     Erreur �criture de l'enregistrement %(i1)d sur la base : %(k1)s %(i2)d
     code retour WRITDR : %(i3)d
     Erreur probablement provoqu�e par une taille trop faible du r�pertoire de travail.
"""),

41 : _(u"""
     Erreur lecture de l'enregistrement %(i1)d sur la base : %(k1)s %(i2)d
     code retour READDR : %(i3)d
"""),

42 : _(u"""
     Fichier satur�, le nombre maximum d'enregistrement %(i1)d de la base %(k1)s est atteint
     il faut relancer le calcul en passant une taille maximum de base sur la ligne de commande
     argument "-max_base" suivi de la valeur en Mo.
"""),

43 : _(u"""
     Erreur d'ouverture du fichier %(k1)s , code retour OPENDR = %(i1)d
"""),

47 : _(u"""
 Erreur lors de la relecture d'un enregistrement sur le fichier d'acc�s direct.
"""),

48 : _(u"""
 Erreur lors de l'�criture d'un enregistrement sur le fichier d'acc�s direct.
"""),

51 : _(u"""
 Relecture au format HDF impossible.
"""),

52 : _(u"""
 Erreur de relecture des param�tres du DATASET HDF.
"""),

53 : _(u"""
 Relecture au format HDF impossible.
"""),

54 : _(u"""
 Impossible d'ouvrir le fichier HDF %(k1)s.
"""),

55 : _(u"""
 Impossible de fermer le fichier HDF %(k1)s.
"""),

56 : _(u"""
 Fermeture du fichier HDF %(k1)s.
"""),

58 : _(u"""
 Le r�pertoire est satur�.
"""),

59 : _(u"""
 Le nom demand� existe d�j� dans le r�pertoire %(k1)s.

"""),

60 : _(u"""
 Erreur lors de l'allocation dynamique. Il n'a pas �t� possible d'allouer
 une zone m�moire de longueur %(i1)d (octets).
 La derni�re op�ration de lib�ration m�moire a permis de r�cup�rer %(i2)d (octets).

"""),

62 : _(u"""
 Erreur lors de l'allocation dynamique. Il n'a pas �t� possible d'allouer
 une zone m�moire de longueur %(i1)d Mo, on d�passe la limite maximum
 fix�e � %(i2)d Mo et on occupe d�j� %(i3)d Mo.
 La derni�re op�ration de lib�ration m�moire a permis de r�cup�rer %(i4)d Mo.

"""),

63 : _(u"""

 Crit�re de destruction du fichier (%(r2).2f %%) associ� � la base %(k1)s d�pass� %(r1).2f %%
 Nombre d'enregistrements utilis�s : %(i1)d
 Volume disque occup�              : %(i2)d Mo.
 Nombre maximum d'enregistrements  : %(i3)d

"""),


64 : _(u"""

 ATTENTION la taille de r�pertoire de noms atteint %(i1)d pour la base %(k1)s.
 Il sera impossible de l'agrandir.
  -> Conseil :
     Il faut r�duire le nombre de concepts sur la base GLOBALE en utilisant
     la commande DETRUIRE.

"""),

65 : _(u"""

 ATTENTION la taille de r�pertoire de noms atteint %(i1)d pour la base %(k1)s.
 Il sera impossible de l'agrandir.
  -> Conseil :
     Il y a trop d'objets cr��s sur la base VOLATILE, cela peut provenir d'une
     erreur dans la programmation de la commande.

"""),

66 : _(u"""

 La base au format HDF de nom %(k1)s ne peut �tre cr��e.
 La fonction HDFCRF renvoie un code retour : %(i1)d

"""),


67 : _(u"""

 Le nombre d'objets de la collection %(k1)s est inf�rieur ou �gal � 0

"""),


68 : _(u"""

 Le fichier associ� � la base demand�e %(k1)s n'est pas ouvert.

"""),

69 : _(u"""

 Le nom %(k1)s est d�j� utilise pour un objet simple.

"""),

70 : _(u"""

 Le type de stockage %(k1)s de la collection est erron�.

"""),

71 : _(u"""

 La longueur variable pour la collection %(k1)s est incompatible avec le genre E.

"""),

72 : _(u"""

 La longueur du type caract�re n'est pas valide pour la collection %(k1)s

"""),

73 : _(u"""

 Le nom %(k1)s du pointeur de longueurs est invalide.

"""),

74 : _(u"""

 Le pointeur de longueurs %(k1)s n'a pas �t� cr�� dans la bonne base.

"""),

75 : _(u"""

 Le pointeur de longueurs %(k1)s n'est pas de la bonne taille.

"""),

76 : _(u"""

 Le type du pointeur de longueurs %(k1)s n'est pas correct (diff�rent de I).

"""),

77 : _(u"""

 Le nom du r�pertoire de noms %(k1)s est invalide.

"""),

78 : _(u"""

 Le r�pertoire de noms %(k1)s n'a pas �t� cr�� dans la bonne base.

"""),

79 : _(u"""

 Le r�pertoire de noms %(k1)s n'est pas de la bonne taille.

"""),

80 : _(u"""

 L'objet %(k1)s n'est pas un r�pertoire de noms.

"""),

81 : _(u"""

 Le type d'acc�s %(k1)s est inconnu.

"""),

82 : _(u"""

 Le type d'acc�s %(k1)s de la collection est erron�.

"""),

83 : _(u"""

 Le nom du pointeur d'acc�s %(k1)s est invalide.

"""),

84 : _(u"""
 La longueur du nom %(k1)s est invalide (> 24 caract�res).

"""),

85 : _(u"""

 Le nom %(k1)s est d�j� utilise pour une collection.

"""),

86 : _(u"""

 La longueur du type caract�re n'est pas d�finie pour l'objet %(k1)s

"""),

87 : _(u"""

 Un objet de genre r�pertoire (N) doit �tre de type caract�re (K) %(k1)s

"""),

88 : _(u"""

 La longueur du type caract�re %(k1)s n'est pas valide.

"""),

89 : _(u"""

 Un objet de genre r�pertoire doit �tre de type K de longueur multiple de 8 %(k1)s.

"""),

90 : _(u"""

 Un objet de genre r�pertoire doit �tre de type K de longueur inf�rieure ou �gale � 24 %(k1)s.

"""),

91 : _(u"""

 Le type %(k1)s est invalide.

"""),

92 : _(u"""

 La longueur ou la position de la sous cha�ne %(k1)s est invalide.

"""),

93 : _(u"""

 Les longueurs des sous cha�nes %(k1)s sont diff�rentes.

"""),

94 : _(u"""

 Les sous cha�nes %(k1)s sont identiques.

"""),

95 : _(u"""

 L'appel de JECROC par JEXNOM ou JEXNUM est obligatoire.

"""),

96 : _(u"""

 L'acc�s par JEXNUM est interdit %(k1)s.

"""),

97 : _(u"""

 Erreur lors de l'appel � JECROC %(k1)s.

"""),

98 : _(u"""

 L'attribut %(k1)s. est uniquement destin� aux collections contigu�s.

"""),

99 : _(u"""

 L'attribut est incompatible avec le genre %(k1)s.

"""),

}
