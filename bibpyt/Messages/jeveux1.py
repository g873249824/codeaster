#@ MODIF jeveux1 Messages  DATE 07/09/2010   AUTEUR LEFEBVRE J-P.LEFEBVRE 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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

 L'attribut %(k1)s est non modifiable ou d�j� d�fini.

"""),

2 : _("""

 L'attribut %(k1)s est non modifiable ou d�j� d�fini pour un objet simple.

"""),

3 : _("""

 L'attribut %(k1)s n'est pas compatible avec la valeur de LONT.

"""),

4 : _("""

 L'attribut %(k1)s n'est pas accessible ou non modifiable.

"""),

5 : _("""

 Pour une collection contig�e, il faut d�finit %(k1)s dans l'ordre de cr�ation des objets.

"""),

6 : _("""

 L'attribut %(k1)s n'est pas modifiable ou d�j� d�fini (attribut LONO non nul).

"""),

7 : _("""

 L'attribut %(k1)s est incompatible avec la valeur initiale de LONT.

"""),

8 : _("""

 Le premier argument %(k1)s n'est pas du bon type (diff�rent de CHARACTER).

"""),

9 : _("""

 L'appel est invalide pour l'objet simple "%(k1)s".

"""),

10 : _("""

 Le nom de l'attribut est incompatible avec le genre %(k1)s.

"""),

11 : _("""

 La longueur ou la position de la sous-cha�ne %(k1)s est invalide.

"""),

12 : _("""

 L'objet %(k1)s n'est pas de genre "N" r�pertoire de noms, la requ�te JENUNO est invalide.

"""),

13 : _("""

 Le r�pertoire de noms %(k1)s contient %(i1)d points d'entr�e, la requ�te JENUNO sur le num�ro (%i2)d est invalide.

"""),

14 : _("""

 La collection %(k1)s ne poss�de pas de pointeur de noms, la requ�te JENUNO est invalide.

"""),

15 : _("""

 Nom de classe %(k1)s invalide.

"""),

16 : _("""

 Nom d'objet attribut %(k1)s invalide.

"""),

17 : _("""

 Nom d'attribut %(k1)s invalide.

"""),

18 : _("""

 L'impression de l'attribut %(k1)s est invalide. L'objet %(k2)s n'est pas une collection.

"""),

19 : _("""

 Le segment de valeurs associ� � l'attribut %(k1)s n'est pas accessible en m�moire (adresse nulle).

"""),

20 : _("""

 L'acc�s au r�pertoire de noms %(k1)s est invalide.

"""),

21 : _("""

 L'acc�s � la collection dispers�e %(k1)s n'est pas valide en bloc, il faut y acc�der avec un nom ou un 
 num�ro d'objet de collection.

"""),

22 : _("""

 L'objet de la collection %(k1)s contigue est de longueur nulle.

"""),

23 : _("""

 Le type de recherche %(k1)s invalide.
 
"""),

24 : _("""

 La taille des segments de valeurs %(i1)d invalide.
 
"""),

25 : _("""

 La taille de la partition %(r1)f invalide.
 
"""),

26 : _("""

 Le type de parcours de la segmentation m�moire %(r1)f est invalide, les valeurs possibles sont 1, 2, 3 ou 4.
 
"""),

27 : _("""

 Le param�tre d'acc�s %(r1)f est invalide, la valeur doit �tre E ou L.
 
"""),

28 : _("""

 La valeur de l'attribut %(k1)s est invalide, la valeur doit �tre LONCUM.
 
"""),

29 : _("""

 Cette requ�te n'est valide que sur une collection contigue.
 
"""),

30 : _("""

 L'attribut LONCUM n'est valide que sur une collection contigue.
 
"""),

31 : _("""

 La liste de param�tres de cr�ation d'objet est incompl�te.
 
"""),

32 : _("""

 La liste de param�tres de cr�ation d'objet contient des champs superflus.
 
"""),

33 : _("""

 Le r�pertoire de noms %(k1)s est satur�, il faut le redimensionner.
 
"""),

34 : _("""

 Le nom %(k1)s est introuvable dans le r�pertoire de noms %(k2)s.
 
"""),

35 : _("""

 Le nom %(k1)s existe d�j� dans le r�pertoire de noms %(k2)s.
 
"""),

36 : _("""

 Impossible d'ins�rer le nom %(k1)s dans le r�pertoire de noms %(k2)s, il y trop de collisions avec
 la fonction de hcoding.
 
"""),

37 : _("""

 La valeur du rapport entre les partitions est invalide, (%r1)f n'est pas comprise entre 0.0 et 1.0.
 
"""),

38 : _("""

 Un objet de genre N (r�pertoire de noms) doit �tre de type K (caract�re).
 
"""),

39 : _("""

 Il faut d�finir la longueur du type caract�re, par exemple K8 ou K32.
 
"""),

40 : _("""

 La longueur du type caract�re vaut (%i1)d, elle doit �tre comprise entre 1 et 512 .
 
"""),

41 : _("""

 Pour un objet de genre N (r�pertoire de noms), la longueur du type caract�re vaut (%i1)d, elle n'est pas un multiple de 8.
 
"""),

42 : _("""

 Pour un objet de genre N (r�pertoire de noms), la longueur du type caract�re vaut (%i1)d, elle ne peut �tre sup�rieure � 24.
 
"""),

43 : _("""

 Le type de l'objet %(k1)s est invalide, il peut valoir K, S, I, R, C ou L.
 
"""),

44 : _("""

 Pour une collection nomm�e, la cr�ation d'objet est uniquement autoris�e par nom.
 
"""),

45 : _("""

 L'objet de collection %(i1)d existe d�j�.
 
"""),

46 : _("""

 Il est impossible de cr�er l'objet de collection, le r�pertoire est satur�.
 
"""),

47 : _("""

 L'acc�s par nom � une collection num�rot�e est impossible.
 
"""),

48 : _("""

 Une erreur d'�criture de l'attribut %(k1)s au format HDF s'est produite, l'ex�cution continue.
 
"""),

49 : _("""

 Un �crasement de l'identificateur de l'objet est d�tect�, sa valeur ne peut pas �tre nulle. 
 
"""),

50 : _("""

 Un �crasement de la classe de l'objet est d�tect�, sa valeur %(i1)d est invalide. 
 
"""),

51 : _("""

 Un �crasement de la classe de l'objet est d�tect�, sa valeur %(k1)s est invalide. 
 
"""),

52 : _("""

  Il est impossible d'acc�der au dataset hdf associ� � %(k1)s. 
 
"""),

53 : _("""

  La zone m�moire � lib�rer est d�j� marqu�e libre. 
 
"""),

54 : _("""

  Un �crasement amont est d�tect�, la zone m�moire (adresse %(i1)d) a �t� utilis�e devant l'adresse autoris�e %(i1)d. 
 
"""),

55 : _("""

  Un �crasement aval est d�tect�, la zone m�moire (adresse %(i1)d) a �t� utilis�e au-del� de la longueur autoris�e. 
 
"""),

56 : _("""

  La structure du nom de l'objet est invalide au-del� des 24 premiers caract�res, elle vaut (%k1)s. 
 
"""),

57 : _("""

  La structure du nom de l'objet est invalide, elle vaut (%k1)s. 
 
"""),

58 : _("""

  La structure du nom de l'objet est invalide, le caract�re (%k1)s est illicite. 
 
"""),

59 : _("""

  L'objet ne poss�de pas d'image disque (adresse disque nulle). 
 
"""),

60 : _("""

  L'objet de type K (cha�ne de caract�res) est d�j� allou� en m�moire, il n'est pas possible de le d�placer sans l'avoir aupravant lib�r�. 
 
"""),

61 : _("""

  L'objet n'est pas en m�moire et ne poss�de pas d'image disque (adresse disque nulle). 
 
"""),

62 : _("""

  La longueur des objets de collection constante n'a pas �t� d�finie. 
 
"""),

63 : _("""

 L'attribut LONCUM n'est pas accessible pour cette collection.
 
"""),

64 : _("""

 Le volume des donn�es temporaires (objets de la base Volatile) �crites sur disque (%(r3).2f Mo)  
 est plus de %(r1).2f fois sup�rieur au volume de donn�es lues (%(r2).2f Mo). 
  
"""),

}
