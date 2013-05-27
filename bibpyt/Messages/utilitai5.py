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
 Le fichier de nom %(k1)s associ� � l'unit� logique %(k2)s n'existe pas.
"""),

3 : _(u"""
 s�lection de ddl : choix < %(k1)s > inconnu
"""),

4 : _(u"""
 argument d'appel invalide :  typf =  %(k1)s
"""),

5 : _(u"""
 argument d'appel invalide :  ACCES =  %(k1)s
"""),

6 : _(u"""
 argument d'appel invalide :  autor =  %(k1)s
"""),

7 : _(u"""
 red�finition de l'unit� logique  %(k1)s  non autoris�e
"""),

8 : _(u"""
 nombre maximum d'unit�s logiques ouvertes atteint  %(k1)s
"""),

9 : _(u"""
 argument d'appel invalide :  unit =  %(k1)s
"""),

10 : _(u"""
 aucun num�ro d'unit� logique disponible
"""),

11 : _(u"""
 unit� logique  %(k1)s  associ�e au nom  %(k2)s  et au fichier  %(k3)s
"""),

12 : _(u"""
 vous devez d'abord le fermer pour l'associer au nom  %(k1)s
"""),

13 : _(u"""
 unit� logique  %(k1)s  d�j� utilis�e en acc�s  %(k2)s  par le fichier  %(k3)s
"""),

14 : _(u"""
 vous devez d'abord le fermer
"""),

15 : _(u"""
 unit� logique  %(k1)s  d�j� utilis�e en mode binaire par le fichier  %(k2)s
"""),

16 : _(u"""
 vous devez d'abord fermer le fichier associe
"""),

17 : _(u"""
 unit� logique  %(k1)s  d�j� utilis�e par le fichier  %(k2)s  associ�e au nom  %(k3)s
"""),

18 : _(u"""
 unit� logique  %(k1)s , probl�me lors de l'open  %(k2)s
"""),

19 : _(u"""
 unit� logique  %(k1)s , probl�me lors du positionnement
"""),

20 : _(u"""
 Probl�me lors de la r�cup�ration d'informations sur l'unit� logique %(k1)s.
"""),

21 : _(u"""
 Le nombre d'unit�s logiques ouvertes est sup�rieur � %(i1)d.
"""),

22 : _(u"""
 unit� logique  %(k1)s , probl�me lors du close de la r�servation.
"""),

23 : _(u"""
 La red�finition de l'unit� logique  %(k1)s n'est pas autoris�e.
"""),

24 : _(u"""
 Le type d'acc�s est inconnu "%(k1)s" pour l'unit� %(k2)s.
"""),

25 : _(u"""
 fichier non nomme, unit�  %(k1)s
"""),

26 : _(u"""
 fichier non ouvert, unit�  %(k1)s
"""),

27 : _(u"""
 rembobinage impossible, unit�  %(k1)s
"""),

28 : _(u"""
 positionnement inconnu " %(k1)s ", unit�  %(k2)s
"""),

29 : _(u"""
 les champs de type " %(k1)s " sont interdits.(a faire ...)
"""),

30 : _(u"""
 composante  %(k1)s inexistante pour la grandeur  %(k2)s
"""),

31 : _(u"""
 La maille '%(k1)s' n'appartient pas au maillage '%(k2)s'.
"""),

32 : _(u"""
 Le champ '%(k1)s' n'est pas un champ par �l�ments aux noeuds.
"""),

34 : _(u"""
 La maille '%(k1)s' n'est pas affect�e dans le groupe d'�l�ments finis '%(k2)s'.
"""),

35 : _(u"""
 La maille '%(k1)s' poss�de un type d'�l�ment ignorant le champ par �l�ment test�.
"""),

36 : _(u"""
 Le num�ro de sous-point demand� est sup�rieur au num�ro maximum de sous-point.
"""),

37 : _(u"""
 Le num�ro de point demand� (%(i1)d) est sup�rieur au num�ro maximum de point (%(i2)d).
"""),

38 : _(u"""
 L'�l�ment n'admet pas la composante '%(k1)s'.
"""),

39 : _(u"""
 D�termination de la localisation des points de gauss.
"""),

41 : _(u"""
 XOUS :  %(k1)s  non pr�vu.
"""),

42 : _(u"""
 cha�ne sch1 trop longue >24
"""),

43 : _(u"""
 ipos hors de l intervalle (0 24)
"""),

44 : _(u"""
 longueur totale > 24
"""),

45 : _(u"""
 on demande un nombre de composantes n�gatif pour  %(k1)s
"""),

46 : _(u"""
 on demande des composantes inconnues pour  %(k1)s
"""),

47 : _(u"""
 mot-clef :  %(k1)s  inconnu.
"""),

48 : _(u"""
 composante inexistante dans le champ:  %(k1)s
"""),

49 : _(u"""
 type de champ non traite:  %(k1)s
"""),

50 : _(u"""
    La valeur de l'argument est en dehors de l'intervalle [-1, 1].
"""),

52 : _(u"""
 mauvaise valeur pour fonree
"""),

53 : _(u"""
 pas de composantes
"""),

54 : _(u"""
Erreur Programmeur / UTTCPU :
 l"argument "INDI" est non valide
"""),

55 : _(u"""
Erreur Programmeur / UTTCPU  :
 L"appel a uttcpu ne peut �tre effectue avec la valeur "DEBUT" pour l"argument PARA
 Il faut d'abord avoir fait "INIT".
"""),

56 : _(u"""
Erreur Programmeur / UTTCPU  :
 L"appel a uttcpu ne peut �tre effectu� avec la valeur "FIN" pour l"argument PARA.
 Il faut d'abord avoir fait "DEBUT".
"""),

57 : _(u"""
Erreur Programmeur / UTTCPU  :
 L"appel a uttcpu ne peut �tre effectue avec la valeur  %(k1)s  pour l"argument PARA
"""),

58 : _(u"""
 (uttrif) type de fonction non connu.
"""),

59 : _(u"""
 il existe au moins un noeud qui n appartient pas au groupe de mailles.
"""),

60 : _(u"""
 un sous-domaine  est non connexe
"""),

88 : _(u"""
 L'option " %(k1)s " est � recalculer
"""),

89 : _(u"""
 Erreur de programmation : contacter l'assistance
"""),

90 : _(u"""
 On ne trouve pas le VALE_PARA_FONC exact dans la liste de la nappe
"""),





92 : _(u"""
 Interpolation LOG et complexe en ordonn�es sont incompatibles !
"""),

93 : _(u"""
 Vous essayez de stocker le mod�le, le champ mat�riau ou
 des caract�ristiques �l�mentaires dans la SD r�sultat.
 Ce n'est pas possible pour une SD r�sultat de type %(k1)s,
 on ne stocke aucun de ces trois �l�ments.
"""),

94 : _(u"""
 Vous essayer de stocker la SD charge dans la SD r�sultat.
 Ce n'est pas possible pour une SD r�sultat de type %(k1)s,
 on ne stocke pas la charge.
"""),

97 : _(u"""
 le type de champ  %(k1)s n'est pas accept�
 veuillez consulter la documentation U correspondante
"""),

98 : _(u"""
 Pour une SD r�sultat de type %(k1)s, le mod�le ne sera pas stock�.
"""),
}
