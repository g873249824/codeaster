#@ MODIF jeveux1 Messages  DATE 29/04/2013   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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

1 : _(u"""

 L'attribut %(k1)s est non modifiable ou d�j� d�fini.

"""),

2 : _(u"""

 L'attribut %(k1)s est non modifiable ou d�j� d�fini pour un objet simple.

"""),

3 : _(u"""

 L'attribut %(k1)s n'est pas compatible avec la valeur de LONT.

"""),

4 : _(u"""

 L'attribut %(k1)s n'est pas accessible ou non modifiable.

"""),

5 : _(u"""

 Pour une collection contigu�, il faut d�finit %(k1)s dans l'ordre de cr�ation des objets.

"""),

6 : _(u"""

 L'attribut %(k1)s n'est pas modifiable ou d�j� d�fini (attribut LONO non nul).

"""),

7 : _(u"""

 L'attribut %(k1)s est incompatible avec la valeur initiale de LONT.

"""),

8 : _(u"""

 Le premier argument %(k1)s n'est pas du bon type (diff�rent de CHARACTER).

"""),

9 : _(u"""

 L'appel est invalide pour l'objet simple "%(k1)s".

"""),

10 : _(u"""

 Le nom de l'attribut est incompatible avec le genre %(k1)s.

"""),

11 : _(u"""

 La longueur ou la position de la sous cha�ne %(k1)s est invalide.

"""),

12 : _(u"""

 L'objet %(k1)s n'est pas de genre "N" r�pertoire de noms, la requ�te JENUNO est invalide.

"""),

13 : _(u"""

 Le r�pertoire de noms %(k1)s contient %(i1)d points d'entr�e, la requ�te JENUNO
 sur le num�ro %(i2)d est invalide.

"""),

14 : _(u"""

 La collection %(k1)s ne poss�de pas de pointeur de noms, la requ�te JENUNO est invalide.

"""),

15 : _(u"""

 Nom de classe %(k1)s invalide.

"""),

16 : _(u"""

 Nom d'objet attribut %(k1)s invalide.

"""),

17 : _(u"""

 Nom d'attribut %(k1)s invalide.

"""),

18 : _(u"""

 L'impression de l'attribut %(k1)s est invalide. L'objet %(k2)s n'est pas une collection.

"""),

19 : _(u"""

 Le segment de valeurs associ� � l'attribut %(k1)s n'est pas accessible en m�moire (adresse nulle).

"""),

20 : _(u"""

 L'acc�s au r�pertoire de noms %(k1)s est invalide.

"""),

21 : _(u"""

 L'acc�s � la collection dispers�e %(k1)s n'est pas valide en bloc, il faut y acc�der avec un nom ou un
 num�ro d'objet de collection.

"""),

22 : _(u"""

 L'objet de la collection %(k1)s contigu� est de longueur nulle.

"""),

27 : _(u"""

 Le param�tre d'acc�s %(r1)f est invalide, la valeur doit �tre E ou L.

"""),

28 : _(u"""

 La valeur de l'attribut %(k1)s est invalide, la valeur doit �tre LONCUM.

"""),

29 : _(u"""

 Cette requ�te n'est valide que sur une collection contigu�.

"""),

30 : _(u"""

 L'attribut LONCUM n'est valide que sur une collection contigu�.

"""),

31 : _(u"""

 La liste de param�tres de cr�ation d'objet est incompl�te.

"""),

32 : _(u"""

 La liste de param�tres de cr�ation d'objet contient des champs superflus.

"""),

33 : _(u"""

 Le r�pertoire de noms %(k1)s est satur�, il faut le redimensionner.

"""),

34 : _(u"""

 Le nom %(k1)s est introuvable dans le r�pertoire de noms %(k2)s.

"""),

35 : _(u"""

 Le nom %(k1)s existe d�j� dans le r�pertoire de noms %(k2)s.

"""),

36 : _(u"""

 Impossible d'ins�rer le nom %(k1)s dans le r�pertoire de noms %(k2)s, il y trop de collisions avec
 la fonction de hashage.

"""),

38 : _(u"""

 Un objet de genre N (r�pertoire de noms) doit �tre de type K (caract�re).

"""),

39 : _(u"""

 Il faut d�finir la longueur du type caract�re, par exemple K8 ou K32.

"""),

40 : _(u"""

 La longueur du type caract�re vaut %(i1)d, elle doit �tre comprise entre 1 et 512 .

"""),

41 : _(u"""

 Pour un objet de genre N (r�pertoire de noms), la longueur du type caract�re
 vaut %(i1)d, elle n'est pas un multiple de 8.

"""),

42 : _(u"""

 Pour un objet de genre N (r�pertoire de noms), la longueur du type caract�re
 vaut %(i1)d, elle ne peut �tre sup�rieure � 24.

"""),

43 : _(u"""

 Le type de l'objet %(k1)s est invalide, il peut valoir K, S, I, R, C ou L.

"""),

44 : _(u"""

 Pour une collection nomm�e, la cr�ation d'objet est uniquement autoris�e par nom.

"""),

45 : _(u"""

 L'objet de collection %(i1)d existe d�j�.

"""),

46 : _(u"""

 Il est impossible de cr�er l'objet de collection, le r�pertoire est satur�.

"""),

47 : _(u"""

 L'acc�s par nom � une collection num�rot�e est impossible.

"""),

48 : _(u"""

 Une erreur d'�criture de l'attribut %(k1)s au format HDF s'est produite, l'ex�cution continue.

"""),

49 : _(u"""

 Un �crasement de l'identificateur de l'objet est d�tect�, sa valeur ne peut pas �tre nulle.

"""),

50 : _(u"""

 Un �crasement de la classe de l'objet est d�tect�, sa valeur %(i1)d est invalide.

"""),

51 : _(u"""

 Un �crasement de la classe de l'objet est d�tect�, sa valeur %(k1)s est invalide.

"""),

52 : _(u"""

  Il est impossible d'acc�der au DATASET HDF associ� � %(k1)s.

"""),

54 : _(u"""

  Un �crasement amont est d�tect�, la zone m�moire (adresse %(i1)d) a �t� utilis�e
  devant l'adresse autoris�e %(i1)d.

"""),

55 : _(u"""

  Un �crasement aval est d�tect�, la zone m�moire (adresse %(i1)d) a �t� utilis�e
  au-del� de la longueur autoris�e.

"""),

56 : _(u"""

  La structure du nom de l'objet est invalide au-del� des 24 premiers caract�res,
  elle vaut %(k1)s.

"""),

57 : _(u"""

  La structure du nom de l'objet est invalide, elle vaut %(k1)s.

"""),

58 : _(u"""

  La structure du nom de l'objet est invalide, le caract�re %(k1)s est illicite.

"""),

59 : _(u"""

  L'objet ne poss�de pas d'image disque (adresse disque nulle).

"""),

60 : _(u"""

  L'objet de type K (cha�ne de caract�res) est d�j� allou� en m�moire, il n'est pas
  possible de le d�placer sans l'avoir auparavant lib�r�.

"""),

61 : _(u"""

  L'objet n'est pas en m�moire et ne poss�de pas d'image disque (adresse disque nulle).

"""),

62 : _(u"""

  La longueur des objets de collection constante n'a pas �t� d�finie.

"""),

63 : _(u"""

 L'attribut %(k1)s n'est pas accessible pour cette collection.

"""),

64 : _(u"""

 Le volume des donn�es temporaires (objets de la base Volatile) �crites sur disque (%(r3).2f Mo)
 est plus de %(r1).2f fois sup�rieur au volume de donn�es lues (%(r2).2f Mo).

Risques et conseils :
 Ce d�s�quilibre n'a pas de cons�quence sur les r�sultats de calcul, il indique simplement que
 certaines structures de donn�es temporaires ont �t� �crites sur disque et d�truites sans avoir
 �t� relues. C'est le cas lorsque vous utilisez le solveur MUMPS, car certaines structures de 
 donn�es sont volontairement d�charg�es pour maximiser la m�moire lors de la r�solution.

"""),

65 : _(u"""

 Le segment de valeurs associ� � l'objet %(i1)d de la collection %(k1)s ne poss�de
 ni adresse m�moire, ni adresse disque.

"""),


66 : _(u"""

 Le segment de valeurs associ� � l'objet simple %(k1)s ne poss�de ni adresse m�moire,
 ni adresse disque.

"""),

67 : _(u"""

 La valeur %(i1)d affect�e � l'attribut %(k1)s est invalide.

"""),

68 : _(u"""

 L'acc�s � l'objet simple %(k1)s par la fonction JEXNOM ou JEXNUM est invalide.
 Il faut que l'objet simple soit de genre r�pertoire de noms.
 
"""),

69 : _(u"""

 Le nom de r�pertoire associ� � la base Globale est trop long %(k1)s,
 il comporte %(i1)d caract�res, il ne doit pas d�passer 119.
 
"""),

70 : _(u"""

 Le nom de r�pertoire associ� � la base Volatile est trop long %(k1)s,
 il comporte %(i1)d caract�res, il ne doit pas d�passer 119.
 
"""),
 
71 : _(u"""
 La m�moire totale de %(r1).2f Mo allou�e � l'�tude est insuffisante, il est n�cessaire
 de disposer d'au moins %(r3).2f Mo uniquement pour d�marrer l'ex�cution.
"""),
 
72 : _(u"""
 Il n'est pas possible de modifier la valeur limite totale de l'allocation dynamique JEVEUX.
 La valeur fournie en argument vaut %(r2).2f.
 Actuellement %(r1).2f Mo sont n�cessaires au gestionnaire de m�moire.
"""),

74 : _(u"""  La m�moire consomm�e actuellement hors JEVEUX est de %(r1).2f Mo.
  La limite de l'allocation dynamique JEVEUX est fix�e � %(r2).2f Mo.
"""),

75 : _(u"""
 La plate-forme utilis�e ne permet pas d'avoir acc�s � la valeur de VmPeak.
"""),


77 : _(u"""
 La m�moire demand�e au lancement est sous estim�e, elle est de %(r2).2f Mo.
 Le pic m�moire utilis�e est de %(r1).2f Mo.

"""),

78 : _(u"""
 La m�moire demand�e au lancement est surestim�e, elle est de %(r2).2f Mo.
 Le pic m�moire utilis�e est de %(r1).2f Mo.

"""),
}
