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
 Rien que des constantes pour une nappe.
 Nombre de fonctions constantes %(i1)d
"""),

2 : _(u"""
 Param�tres diff�rents.
 fonction %(k1)s de param�tre %(k2)s au lieu de %(k3)s
"""),

3 : _(u"""
 Le nombre de param�tres  %(i1)d  est diff�rent du nombre de fonctions  %(i2)d
"""),

4 : _(u"""
 Il n'y a pas un nombre pair de valeurs, "DEFI_FONCTION" occurrence  %(i1)d
"""),

5 : _(u"""
 Les abscisses de la fonction  %(k1)s ont �t� r�ordonn�es.
"""),

6 : _(u"""
 L'ordre des abscisses de la fonction num�ro  %(i1)d a �t� invers� .
"""),

7 : _(u"""
 Appel erron�
  archivage num�ro :  %(i1)d
  code retour de rsexch :  %(i2)d
"""),

8 : _(u"""
 Lecture des champs:
"""),

9 : _(u"""
   Num�ro d'ordre :  %(i1)d             instant :  %(r1)g
"""),

10 : _(u"""
 Le mod�le est manquant.

 Conseil :
  Il faut remplir le mot-cl� MODELE si la commande utilis�e le permet.
"""),






13 : _(u"""
  Dans la structure de donn�es r�sultat %(k1)s,
  le champ %(k2)s
"""),

14 : _(u"""
  ou le champ %(k1)s
"""),

15 : _(u"""
  n'existe pas.
"""),

16 : _(u"""
  Pour le num�ro d'ordre NUME_ORDRE %(i1)d,
  l'option %(k1)s n'est pas calcul�e.

  Conseil :
    V�rifiez le nom de la structure de donn�e et v�rifiez que les champs existent.
    Si le concept n'est pas r�entrant les champs ne sont pas cherch�s dans %(k2)s.
"""),

17 : _(u"""
 pas de NUME_ORDRE trouv� pour le num�ro  %(i1)d
"""),

18 : _(u"""
 pas de champs trouv� pour l'instant  %(r1)g
"""),

19 : _(u"""
 Plusieurs pas de temps trouv�s  dans l'intervalle de pr�cision
 autour de l'instant  %(r1)g
 nombre de pas de temps trouv�s  %(i1)d
 Conseil : modifier le param�tre PRECISION
"""),

20 : _(u"""
 Erreur dans les donn�es :
 Le param�tre existe d�j�:  %(k1)s  dans la table:  %(k2)s
"""),

21 : _(u"""
 Erreur dans les donn�es
 Le type du param�tre:  %(k1)s
  est diff�rent pour le param�tre:  %(k2)s
  et le param�tre:  %(k3)s
"""),

22 : _(u"""
  Valeur de M maximale atteinte pour r�soudre F(M)=0,
  Conseil : V�rifiez vos listes d'instants de rupture, M maximal admissible =  %(r1)f
"""),

23 : _(u"""
  Valeur de M minimale atteinte pour r�soudre F(M)=0,
  Conseil : V�rifiez vos listes d'instants de rupture, valeur de M =  %(r1)f
"""),

24 : _(u"""
 Le champ demand� est incompatible avec le type de r�sultat
  type de r�sultat : %(k1)s
      nom du champ : %(k2)s
"""),

25 : _(u"""
 Le nombre d'ast�risques pour les noms de fichiers ENSIGHT de pression est trop grand.
 Il est limite � 7
 Il y a %(i1)d ast�risques.
"""),

26 : _(u"""
 Appel erron�  r�sultat :  %(k1)s   archivage num�ro :  %(i1)d
   code retour de rsexch :  %(i2)d
   probl�me champ :  %(k2)s
"""),

27 : _(u"""
 Appel erron�  r�sultat :  %(k1)s   archivage num�ro :  %(i1)d
   code retour de rsexch :  %(i2)d
   probl�me champ :  %(k2)s
"""),

28 : _(u"""
 Fin de fichier dans la lecture des fichiers ENSIGHT
"""),

29 : _(u"""
 Erreur dans la lecture du fichier ENSIGHT
"""),

30 : _(u"""
  probl�me pour le fichier:  %(k1)s
"""),

31 : _(u"""
  Option d�j� calcul�e:  option  %(k1)s  NUME_ORDRE  %(i1)d
  On la recalcule car les donn�es peuvent �tre diff�rentes

"""),

32 : _(u"""
 L'extrapolation ne peut �tre faite � gauche (interdit).
"""),

33 : _(u"""
 L'extrapolation ne peut �tre faite � droite (interdit).
"""),

34 : _(u"""
 L'interpolation ne peut �tre faite car aucun champ de : %(k1)s n'est calcule.
"""),

35 : _(u"""
 La variable d'acc�s %(k1)s est invalide pour une interpolation.
"""),

36 : _(u"""
 Ce nom de champ est interdit : %(k1)s pour une interpolation.
"""),

37 : _(u"""
 R�sultat: %(k1)s NOM_CHAM: %(k2)s  variable d'acc�s: %(k3)s valeur: %(r1)g

"""),

38 : _(u"""
 Plusieurs champs correspondant � l'acc�s demand� pour la SD_RESULTAT  %(k1)s
"""),

39 : _(u"""
 acc�s %(k1)s : %(i1)d
"""),

40 : _(u"""
 acc�s %(k1)s : %(r1)g
"""),

41 : _(u"""
 acc�s %(k1)s  : %(k1)s
"""),

46 : _(u"""
  nombre : %(i1)d NUME_ORDRE retenus : %(i2)d, %(i3)d
"""),

47 : _(u"""
 Pas de champ correspondant � un acc�s demand� pour la SD_RESULTAT  %(k1)s
"""),

48 : _(u"""
  nombre : %(i1)d NUME_ORDRE retenus (les trois premiers) : %(i2)d, %(i3)d, %(i4)d
"""),

56 : _(u"""
 pas de champs pour l'acc�s  %(k1)s de valeur  %(r1)g
"""),

57 : _(u"""
Erreur utilisateur :
  Plusieurs champs correspondent � l'acc�s demand� pour la sd_r�sultat  %(k1)s
  - acc�s "INST"             : %(r1)19.12e
  - nombre de champs trouv�s : %(i1)d
Conseil:
  Resserrer la pr�cision avec le mot cl� PRECISION
"""),

58 : _(u"""
 Pas de champs pour l'acc�s  %(k1)s de valeur  %(r1)g
"""),

59 : _(u"""
Erreur utilisateur :
  Plusieurs champs correspondent � l'acc�s demand� pour la sd_r�sultat  %(k1)s
  - acc�s "FREQ"             : %(r1)19.12e
  - nombre de champs trouv�s : %(i1)d
Conseil:
  Resserrer la pr�cision avec le mot cl� PRECISION
"""),

60 : _(u"""
 L'int�grale d'un champ sur des �l�ments de structure
(poutre, plaque, coque, tuyau, poutre multifibre) n'est pas programm�e.
 R�duisez la zone de calcul par le mot-cl� GROUP_MA/MAILLE.
"""),

61 : _(u"""
 Erreur dans les donn�es pour le champ  %(k1)s
 Aucun noeud ne supporte les composantes
 %(k2)s, %(k3)s, %(k4)s, %(k5)s, ...
"""),

62 : _(u"""
 Erreur dans les donn�es pour le champ  %(k1)s
 Aucune maille ne supporte les composantes
 %(k2)s, %(k3)s, %(k4)s, %(k5)s, ...
"""),

63 : _(u"""
 POST_ELEM INTEGRALE : la maille %(i1)d de type %(k1)s ne sait pas
 (ou ne peut pas) calculer le post-traitement demand�
Conseil:
   Limiter le post-traitement � des GROUP_MA contenant des mailles
de type valide
"""),

64 : _(u"""
  Vous d�finissez une charge thermique sur un mod�le m�canique !
  Le MODELE doit �tre de type thermique.
"""),

65 : _(u"""
  Vous d�finissez une charge m�canique sur un mod�le thermique !
  Le MODELE doit �tre de type m�canique.
"""),

66 : _(u"""
  Le MACR_ELEM_DYNA a �t� cr�� avec une base modale qui entre-temps a �t�
  modifi�e/enrichie. Le nombre d'�quations dans le MACR_ELEM_DYNA ne 
  correspond plus au nombre de vecteurs de projection modale.
  
  -> Conseil: Pour mettre � jour le MACR_ELEM_DYNA, il faut d'abord d�truire 
              le concept associ� et le r�cr�er ensuite avec la nouvelle base modale.
  
  Nombre d'�quations dans le MACR_ELEM_DYNA      = %(i1)d
  Nombre de vecteurs de projection modale        = %(i2)d
"""),

}
