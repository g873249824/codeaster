#@ MODIF jeveux Messages  DATE 28/03/2011   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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

def _(x) : return x

cata_msg = {

2 : _("""
 Pointeur de longueur externe interdit maintenant.
"""),

3 : _("""
 Pointeur de nom externe interdit maintenant.
"""),

6 : _("""
 Erreur de programmation :
 
  Appel invalide, la marque devient n�gative
"""),

7 : _("""
 Destruction de  %(k1)s
"""),

8 : _("""
 La base  %(k1)s  a �t� constitu�e avec la version  %(k2)s
 et vous utilisez la version  %(k3)s
"""),

9 : _("""
 Suppression de la partition m�moire
"""),

10 : _("""
 Erreur de programmation :

 Le nom demand� existe d�j� dans la base %(k1)s
"""),

11 : _("""
 Erreur lors de la fermeture de la base  %(k1)s
"""),

12 : _("""
 Fichier associ� � la base  %(k1)s  inexistant
"""),

13 : _("""
 Erreur de lecture du 1er bloc de  %(k1)s
"""),

14 : _("""
 Erreur lors de la fermeture de  %(k1)s
"""),

15 : _("""
 Ecrasement amont, l'objet :< %(k1)s > est peut �tre �cras�"""),

16 : _("""
 Ecrasement aval, l'objet :< %(k1)s > est peut �tre �cras�
"""),

17 : _("""
 Chainage cass� apr�s l'objet :  %(k1)s
"""),

18 : _("""
 Le segment de valeurs associ� � l'objet : %(k1)s, n'existe pas en m�moire et
 l'objet ne poss�de pas d'image disque. 
"""),

19 : _("""
 Le nom d'un objet JEVEUX ne doit pas commencer par un blanc.
"""),

21 : _("""

     RE-OUVERTURE DE LA BASE

     NOM DE LA BASE                          :  %(k1)s
     CREEE AVEC LA VERSION                   :  %(k2)s
     NOMBRE D'ENREGISTREMENTS UTILISES       :  %(i1)d
     NOMBRE D'ENREGISTREMENTS MAXIMUM        :  %(i2)d
     LONGUEUR D'ENREGISTREMENT (OCTETS)      :  %(i3)d
     NOMBRE D'IDENTIFICATEURS UTILISES       :  %(i4)d
     TAILLE MAXIMUM DU REPERTOIRE            :  %(i5)d
     POURCENTAGE D'UTILISATION DU REPERTOIRE :  %(i6)d %%
"""),

22 : _("""

     FERMETURE DE LA BASE

     NOM DE LA BASE                          :  %(k1)s
     NOMBRE D'ENREGISTREMENTS UTILISES       :  %(i1)d
     NOMBRE D'ENREGISTREMENTS MAXIMUM        :  %(i2)d
     LONGUEUR D'ENREGISTREMENT (OCTETS)      :  %(i3)d
     NOMBRE TOTAL D'ACCES EN LECTURE         :  %(i4)d
     VOLUME DES ACCES EN LECTURE             :  %(r1).2f Mo.
     NOMBRE TOTAL D'ACCES EN ECRITURE        :  %(i5)d
     VOLUME DES ACCES EN ECRITURE            :  %(r2).2f Mo.
     NOMBRE D'IDENTIFICATEURS UTILISES       :  %(i6)d
     TAILLE MAXIMUM DU REPERTOIRE            :  %(i7)d
     POURCENTAGE D'UTILISATION DU REPERTOIRE :  %(i8)d %%
"""),

23 : _("""
     Nom de Collection ou de R�pertoire de noms inexistant :  %(k1)s
"""),

24 : _("""
     JENONU : Collection ou R�pertoire de noms  :  %(k1)s
     Il faut passer par JEXNOM,JEXNUM.
"""),

25 : _("""
     Nom de collection ou de r�pertoire inexistant : >%(k1)s<
"""),

26 : _("""
     Objet JEVEUX inexistant dans les bases ouvertes : >%(k1)s<
     l'objet n'a pas �t� cr�� ou il a �t� d�truit
"""),

27 : _("""
     Objet simple JEVEUX inexistant en m�moire et sur disque : >%(k1)s<
     le segment de valeurs est introuvable
"""),

28 : _("""
     Collection JEVEUX inexistant en m�moire et sur disque : >%(k1)s<
     le segment de valeurs est introuvable
"""),

29 : _("""
     Objet %(i1)d de collection JEVEUX inexistant en m�moire et sur disque : >%(k1)s<
"""),

30 : _("""
     Objet de collection JEVEUX inexistant : >%(k1)s<
     l'objet n'a pas �t� cr�� ou il a �t� d�truit
"""),

31 : _("""
     Erreur programmeur :
     La routine JUVECA n'a pas pr�vu de re-dimensionner l'objet :%(k1)s
     de type :%(k2)s
"""),

32 : _("""
     Erreur allocation de segment de m�moire de longueur %(i1)d (entiers).
     M�moire allou�e insuffisante. Il est impossible de trouver un espace
     de longueur suffisante dans la segmentation m�moire. Cette erreur 
     concerne la m�moire dite "statique".
     Fermeture des bases (glob.*) sur erreur
     Il faut relancer le calcul en augmentant la limite m�moire (param�tre 
     -memjeveux_stat sur la ligne de commande). 
"""),


36 : _("""  
     Le nombre d'enregistrements maximum de la base %(k1)s sera modifi�
     de %(i1)d a %(i2)d
"""),

37 : _("""
     La valeur du rapport entre partitions ne convient pas, 
     la longueur de la partition 1 doit etre au minimum de %(i1)d mots 
     soit environ %(i2)d %%
"""),

38 : _("""
     Numero d'objet invalide %(i1)d 
"""),

39 : _("""
     Taille de repertoire demand� trop grande.
     Le maximun est de %(i1)d
     La valeur reclam� est de %(i2)d 
      
"""),

40 : _("""
     Erreur �riture de l'enregistrement %(i1)s sur la base : %(k1)s %(i2)d
     code retour WRITDR : %(i3)d 
     Erreur probablement provoqu�e par une taille trop faible du r�pertoire de travail.
"""),

41 : _("""
     Erreur lecture de l'enregistrement %(i1)d sur la base : %(k1)s %(i2)d
     code retour READDR : %(i3)d 
"""),

42 : _("""
     Fichier satur�, le nombre maximum d'enregistrement %(i1)d de la base %(k1)s est atteint
     il faut relancer le calcul en passant une taille maximum de base sur la ligne de commande 
     argument "-max_base" suivi de la valeur en Mo.
"""),

43 : _("""
     Erreur d'ouverture du fichier %(k1)s , code retour OPENDR = %(i1)d 
"""),

44 : _("""
 Taille des segments de valeurs %(i1)d 
"""),

45 : _("""
 Taille de la partition principale %(r1)g 
"""),

47 : _("""
 Erreur lors de la relecture d'un enregistrement sur le fichier d'acc�s direct.
"""),

48 : _("""
 Erreur lors de l'�criture d'un enregistrement sur le fichier d'acc�s direct.
"""),

49 : _("""
 Taille de la zone � allouer invalide %(i1)d < 0 .
"""),

50 : _("""
 Allocation dynamique impossible.
"""),

51 : _("""
 Relecture au format HDF impossible.
"""),

52 : _("""
 Erreur de relecture des param�tres du dataset HDF.
"""),

53 : _("""
 Relecture au format HDF impossible.
"""),

54 : _("""
 Impossible d'ouvrir le fichier HDF %(k1)s. 
"""),

55 : _("""
 Impossible de fermer le fichier HDF %(k1)s. 
"""),

56 : _("""
 Fermeture du fichier HDF %(k1)s. 
"""),

57 : _("""
 Longueur du segment de valeurs � allouer invalide %(i1)d.
  -> Risque & Conseil :     
     Une valeur n�gative peu parfois provenir d'une valeur enti�re sup�rieure � la valeur de l'entier maximum sur
     une plate-forme 32 bits (2147483648).
"""),

58 : _("""
 Le r�pertoire est satur�.
"""),

59 : _("""
 Le nom demand� existe d�j� dans le r�pertoire %(k1)s.

"""),

60 : _("""
 Erreur lors de l'allocation dynamique. Il n'a pas �t� possible d'allouer 
 une zone m�moire de longueur %(i1)d (octets).
 La derni�re op�ration de lib�ration m�moire a permis de r�cup�rer %(i2)d (octets). 

"""),

62 : _("""
 Erreur lors de l'allocation dynamique. Il n'a pas �t� possible d'allouer 
 une zone m�moire de longueur %(i1)d Mo, on d�passe la limite maximum 
 fix�e � %(i2)d Mo et on occupe d�j� %(i3)d Mo.
 La derni�re op�ration de lib�ration m�moire a permis de r�cup�rer %(i4)d Mo. 

"""),

63 : _("""

 Crit�re de destruction du fichier (%(r2).2f %%) associ� � la base %(k1)s d�pass� %(r1).2f %%  
 Nombre d'enregistrements utilis�s : %(i1)d 
 Volume disque occup�              : %(i2)d Mo.
 Nombre maximum d'enregistrements  : %(i3)d  

"""), 
 

64 : _("""

 ATTENTION la taille de r�pertoire de noms atteint %(i1)d pour la base %(k1)s.
 Il sera impossible de l'agrandir.  
  -> Conseil :     
     Il faut r�duire le nombre de concepts sur la base GLOBALE en utilisant
     la commande DETRUIRE.     

"""), 

65 : _("""

 ATTENTION la taille de r�pertoire de noms atteint %(i1)d pour la base %(k1)s.
 Il sera impossible de l'agrandir.  
  -> Conseil :     
     Il y a trop d'objets cr��s sur la base VOLATILE, cela peut provenir d'une
     erreur dans la programmation de la commande.     

"""), 

66 : _("""

 La base au format HDF de nom %(k1)s ne peut �tre cr��e.
 La fonction HDFCRF renvoie un code retour : %(i1)d 

"""), 
 

67 : _("""

 Le nombre d'objets de la collection %(k1)s est inf�rieur ou �gal � 0  

"""), 


68 : _("""

 Le fichier associ� � la base demand�e %(k1)s n'est pas ouvert.  

"""), 

69 : _("""

 Le nom %(k1)s est deja utilise pour un objet simple.

"""), 

70 : _("""

 Le type de stockage %(k1)s de la collection est erron�.

"""), 

71 : _("""

 La longueur variable pour la collection %(k1)s est incompatible avec le genre E.

"""), 

72 : _("""

 La longueur du type caract�re n'est pas valide pour la collection %(k1)s 

"""), 

73 : _("""

 Le nom %(k1)s du pointeur de longueurs est invalide.

"""), 

74 : _("""

 Le pointeur de longueurs %(k1)s n'a pas �t� cr�� dans la bonne base.

"""), 

75 : _("""

 Le pointeur de longueurs %(k1)s n'est pas de la bonne taille.

"""), 

76 : _("""

 Le type du pointeur de longueurs %(k1)s n'est pas correct (diff�rent de I).

"""), 

77 : _("""

 Le nom du r�pertoire de noms %(k1)s est invalide.

"""), 

78 : _("""

 Le r�pertoire de noms %(k1)s n'a pas �t� cr�� dans la bonne base.

"""), 

79 : _("""

 Le r�pertoire de noms %(k1)s n'est pas de la bonne taille.

"""), 

80 : _("""

 L'objet %(k1)s n'est pas un r�pertoire de noms.

"""), 

81 : _("""

 Le type d'acc�s %(k1)s est inconnu.

"""), 

82 : _("""

 Le type d'acc�s %(k1)s de la collection est erron�.

"""), 

83 : _("""

 Le nom du pointeur d'acc�s %(k1)s est invalide.

"""), 

84 : _("""
 La longueur du nom %(k1)s est invalide (> 24 caract�res).

"""),

85 : _("""

 Le nom %(k1)s est deja utilise pour une collection.

"""), 

86 : _("""

 La longueur du type caract�re n'est pas d�finie pour l'objet %(k1)s 

"""), 

87 : _("""

 Un objet de genre r�pertoire (N) doit �tre de type caract�re (K) %(k1)s 

"""), 

88 : _("""

 La longueur du type caract�re %(k1)s n'est pas valide. 

"""), 

89 : _("""

 Un objet de genre r�pertoire doit �tre de type K de longueur multiple de 8 %(k1)s. 

"""), 

90 : _("""

 Un objet de genre r�pertoire doit �tre de type K de longueur inf�rieure ou �gale � 24 %(k1)s. 

"""), 

91 : _("""

 Le type %(k1)s est invalide.

"""), 

92 : _("""

 La longueur ou la position de la sous-cha�ne %(k1)s est invalide.

"""), 

93 : _("""

 Les longueurs des sous-cha�nes %(k1)s sont diff�rentes.

"""), 

94 : _("""

 Les sous-cha�nes %(k1)s sont identiques.

"""), 

95 : _("""

 L'appel de JECROC par JEXNOM ou JEXNUM est obligatoire.

"""), 

96 : _("""

 L'acc�s par JEXNUM est interdit %(k1)s.

"""), 

97 : _("""

 Erreur lors de l'appel � JECROC %(k1)s.

"""), 

98 : _("""

 L'attribut %(k1)s. est uniquement destin� aux collections contigues.

"""), 

99 : _("""

 L'attribut est incompatible avec le genre %(k1)s.

"""), 

}
