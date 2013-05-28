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
Erreur dans les donn�es. Le param�tre %(k1)s n'existe pas dans la table.
"""),

2 : _(u"""
Param�tre %(k1)s inexistant dans la table %(k2)s.
"""),

3 : _(u"""
Op�ration RENOMME. Erreur : %(k1)s
"""),

6 : _(u"""
Le fichier %(k1)s existe d�j�, on �crit � la suite.
"""),

7 : _(u"""
Param�tre absent de la table : %(k1)s.
"""),

8 : _(u"""
Param�tres absents de la table (ou de NOM_PARA) : %(k1)s.
"""),

10 : _(u"""
NUME_TABLE=%(i1)d incorrect : il n'y a que %(i2)d blocs de tables dans le fichier.
"""),

11 : _(u"""
Nombre de champs incorrect ligne %(i1)d.
"""),

12 : _(u"""
On attend %(i1)d param�tres.
"""),

13 : _(u"""
On attend %(i1)d champs dans le fichier.
"""),

14 : (u"""
Les listes %(k1)s et %(k2)s doivent avoir le m�me cardinal.
"""),

15 : _(u"""
Le format de la ligne semble incorrect.
Ligne lue :
    %(k1)s

Il ne satisfait pas l'expression r�guli�re :
    %(k2)s
"""),

16:_(u"""
L'objet %(k1)s � l'instant %(r1)f existe d�j� dans la table fournie.
On l'�crase pour le remplacer par le nouveau.
"""),

20 : _(u"""Erreur lors de la construction des n-uplets
"""),

21 : _(u"""La table doit avoir exactement deux param�tres pour une impression au format XMGRACE.
"""),

22 : _(u"""Les cellules ne doivent contenir que des nombres r�els
"""),

23 : _(u"""Le param�tre %(k1)s est en double.
"""),

24 : _(u"""Le param�tre %(k1)s existe d�j�.
"""),

25 : _(u"""'%(k1)s' n'a pas d'attribut '%(k2)s'.
"""),

27 : _(u"""Les param�tres n'existent pas dans la table : %(k1)s
"""),

28 : _(u"""L'argument '%(k1)s' doit �tre de type '%(k2)s'.
"""),

29 : _(u"""Valeur incorrecte pour ORDRE : %(k1)s
"""),

30 : _(u"""Les param�tres doivent �tre les m�mes dans les deux tables pour
faire l'intersection  ou l'union (op�rateurs &, |).
"""),

31 : _(u"""Type du param�tre '%(k1)s' non d�fini.
"""),

32 : _(u"""Type du param�tre '%(k1)s' forc� � '%(k2)s'.
"""),

33 : _(u"""Erreur pour le param�tre '%(k1)s' :
   %(k2)s
"""),

34 : _(u"""La colonne '%(k1)s' est vide.
"""),

35 : _(u"""La table est vide !
"""),

36 : _(u"""La table doit avoir exactement trois param�tres.
"""),

37 : _(u"""
   La table %(k1)s n'existe pas dans le r�sultat %(k2)s.
"""),

38 : _(u"""Champ %(k1)s inexistant � l'ordre %(i1)d .
"""),

39 : _(u"""
Aucun num�ro d'ordre associ� � l'acc�s %(k1)s de valeur %(i1)d
Veuillez v�rifier vos donn�es.
"""),

40 : _(u"""
Aucun num�ro d'ordre associ� � l'acc�s %(k1)s de valeur %(r1)f
Veuillez v�rifier vos donn�es.
"""),

41 : _(u"""
Les mots-cl�s 'NOEUD' et 'GROUP_NO' ne sont pas autoris�s pour
les champs �l�mentaires (ELNO/ELGA).
"""),

42 : _(u"""
D�veloppement non r�alis� pour les champs dont les valeurs sont complexes.
"""),

43 : _(u"""
Lecture des noms de param�tres.
On attend %(i1)d noms et on a lu cette ligne :

%(k1)s

Conseil : V�rifier que le s�parateur est correct et le format du fichier
    � lire.
"""),

44 : _(u"""
La table '%(k1)s' est compos�e de %(i1)d lignes x %(i2)d colonnes.

Son titre est :
%(k2)s
"""),

45 : _(u"""
Erreur de type lors de la lecture de la table :

Exception : %(k1)s

Conseil :
    Cette erreur se produit quand on relit au FORMAT='TABLEAU' une table qui a �t�
    imprim�e au FORMAT='ASTER' car la deuxi�me ligne contient des types et non des valeurs.
    Si c'est le cas, utilisez LIRE_TABLE au FORMAT='ASTER'.
"""),

46 : _(u"""
Plusieurs num�ros d'ordre sont associ�s � l'acc�s %(k1)s de valeur %(r1)f


Conseil :
    Vous pouvez modifier la recherche en renseignant le mot cl� PRECISION.
"""),
}
