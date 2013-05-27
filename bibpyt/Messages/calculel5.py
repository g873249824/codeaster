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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

1 : _(u"""
Erreur utilisateur dans MODI_MAILLAGE / DEFORME :
  Le fichier de d�placement fourni est associ� au maillage : %(k2)s
  Alors que le maillage � d�former est : %(k1)s

  Il faut que ces 2 maillages soient les m�mes.

Conseils :
  Pour cr�er un champ de d�placement adapt� au maillage %(k1)s, on peut utiliser
  la commande PROJ_CHAMP.
"""),

3 : _(u"""
 Erreur d'utilisation de POST_CHAMP :
   Dans la structure de donn�es %(k2)s,
   vous avez demand� l'extraction du champ %(k1)s pour le num�ro d'ordre %(i1)d.
   Mais ce champ n'existe pas.
"""),

4 : _(u"""
 !! probl�me cr�ation CHAM_ELEM nul dans alchml !!
"""),

5 : _(u"""
Erreur utilisateur :
  Vous essayez de faire un calcul non-lin�aire m�canique sur un mod�le dont les �l�ments
  ne sont pas programm�s pour cela.
  On arr�te le calcul.

Risques & conseils :
  Vous devriez changer de MODELISATION.
  Par exemple, la mod�lisation 'DST' ne peut pas faire du non-lin�aire alors que la
  mod�lisation 'DKT' le peut.
"""),

6 : _(u"""
Erreur utilisateur :
 Vous utilisez le mot cl� NOM_CMP, mais l'une (au moins) des composantes indiqu�es
 n'appartient pas � la grandeur : %(k1)s
"""),

7 : _(u"""
Alarme utilisateur :
  Vous utilisez la commande PROJ_CHAMP ou un mot cl� n�cessitant de "projeter"
  des noeuds sur des mailles (par exemple LIAISON_MAIL).
  L'un des noeuds (%(k1)s) du maillage (%(k2)s) a �t� projet� � une distance D non nulle significative.
  (D>10%% de la taille de la maille la plus proche (%(k3)s) du maillage (%(k4)s)).
"""),

8 : _(u"""
 il faut renseigner le mot cl� MAILLE
"""),

9 : _(u"""
Erreur utilisateur :
  Vous ne pouvez pas utiliser la m�thode ECLA_PG avec le mot-cl� RESULTAT.
Conseil :
   Extrayez le champ aux ELGA que contient votre r�sultat puis utilisez la m�thode ECLA_PG avec le mot-cl� CHAM_GD.
"""),

10: _(u"""
Erreur d'utilisation dans la commande CREA_MAILLAGE :
  Le mot cl� MAILLAGE est ici obligatoire.
"""),

11 : _(u"""
 le param�tre est a valeurs de type  " %(k1)s "  et la valeur de r�f�rence de type  " %(k2)s ".
"""),

12 : _(u"""
 TYPE_TEST inconnu
"""),

13 : _(u"""
 le champ  %(k1)s  est a valeurs de type  " %(k2)s "  et la valeur de r�f�rence de type  " %(k3)s ".
"""),

14 : _(u"""
 le champ  %(k1)s  est de type inconnu.
"""),

15 : _(u"""
***********************************
 Erreur dans un calcul �l�mentaire.
 Contexte de l'erreur :
   Maille concern�e : %(k1)s
"""),

16 : _(u"""   Option de calcul : %(k1)s
   Commentaire:"""),
17 : _(u"""%(k1)s"""),
18 : _(u"""     Param�tre d'entr�e : %(k1)s
      Commentaire:"""),
19 : _(u"""     Param�tre de sortie : %(k1)s
     Commentaire:"""),

20 : _(u"""
 le GROUP_NO  %(k1)s  contient  %(k2)s  noeuds
"""),

21 : _(u"""
 le GROUP_MA  %(k1)s  contient  %(k2)s  mailles
"""),

22 : _(u"""     Grandeur associ�e au champ : %(k1)s
     Commentaire:"""),
23 : _(u"""***********************************"""),

30 : _(u"""
PROJ_CHAMP :
  La m�thode SOUS_POINT accepte uniquement les r�sultats de type
  EVOL_THER."""),

31 : _(u"""
PROJ_CHAMP :
  Le mot-cl� facteur VIS_A_VIS est interdit avec la m�thode SOUS_POINT."""),

32 : _(u"""
PROJ_CHAMP (ou LIAISON_MAILLE) :
  La m�thode %(k1)s est incompatible avec les champs aux noeuds."""),

33 : _(u"""
PROJ_CHAMP (ou LIAISON_MAILLE) :
  La m�thode %(k1)s est incompatible avec les champs par �l�ment de type %(k2)s."""),

34 : _(u"""
   Maillage quadratique obligatoire avec terme source non nul.
"""),

35 : _(u"""
PROJ_CHAMP (ou LIAISON_MAILLE) :
  Vous cherchez � projeter un champ par �l�ment (ELGA).
  Pour cela, il vous faut renseigner le mot-cl� MODELE_1."""),

36 : _(u"""
PROJ_CHAMP (ou LIAISON_MAILLE) :
  Le mot-cl� TYPE_CHAM est incompatible avec le mot-cl� CHAM_GD.
  Il n'est utilisable qu'avec le mot-cl� RESULTAT."""),

37 : _(u"""
PROJ_CHAMP (ou LIAISON_MAILLE) :
  Vous cherchez � projeter un champ par �l�ment (ELNO, ELEM ou ELGA).
  Pour cela, il vous faut renseigner le mot-cl� MODELE_2."""),

38 : _(u"""
  il faut d�finir un champ de vitesse
"""),

39 : _(u"""
 la grandeur pour la variable:  %(k1)s  doit �tre:  %(k2)s  mais elle est:  %(k3)s
"""),

40 : _(u"""
PROJ_CHAMP  :
  Vous utilisez la m�thode SOUS_POINT.
  Pour cela, il vous faut renseigner le mot-cl� MODELE_2."""),

41 : _(u"""
 pas de variables internes initiales pour la maille  %(k1)s
"""),

42 : _(u"""
 comportements incompatibles :  %(k1)s  et  %(k2)s  pour la maille  %(k3)s
"""),

43 : _(u"""
PROJ_CHAMP (ou LIAISON_MAILLE) :
  Le noeud %(k1)s de coordonn�es (%(r1)f,%(r2)f,%(r3)f) est projet� � la distance %(r4)f"""),

44 : _(u"""
 ! le champ doit �tre un CHAM_ELEM !
"""),

45 : _(u"""
 ! longueurs des modes locaux incompatibles entre eux !
"""),

46 : _(u"""
 ! terme normalisation global nul !
"""),

48 : _(u"""
 PROJ_CHAMP (ou LIAISON_MAIL) :
 Nombre de noeuds projet�s sur des mailles un peu distantes : %(i1)d.
 (la distance � la maille est sup�rieure � 1/10�me du diam�tre de la maille)

 Le noeud %(k1)s est projet� le plus loin � la distance %(r1)f"""),


49 : _(u"""
 LIAISON_MAIL :
 La relation lin�aire destin�e � �liminer le noeud esclave %(k1)s est une tautologie
 car la maille ma�tre en vis � vis de ce noeud poss�de ce m�me noeud dans sa connectivit�.
 On ne l'�crit donc pas.
"""),

52 : _(u"""
 Le calcul du champ SIGM_ELNO n'a pas �t� fait sur la maille volumique %(k1)s qui borde
 la maille surfacique %(k2)s.

 Conseils :
  Il faut faire le calcul du champ SIGM_ELNO sur les �l�ments volumiques de l'autre "cot�"
  de la face en choisissant le bon groupe de mailles soit en faisant le calcul sur tout
  le volume.
  Il est aussi possible de supprimer le calcul pr�alable de SIGM_ELNO, le calcul sera fait
  automatiquement sur les bonnes mailles volumiques.
"""),


53 : _(u"""
 La SUPER_MAILLE %(k1)s n'existe pas dans le maillage %(k2)s.
"""),

54 : _(u"""
 Aucune maille de peau n'a �t� fournie.

 Vous devez renseigner le mot-cl� MAILLE/GROUP_MA en donnant une liste de mailles ou
 un groupe de maille contenant des mailles de peau.
 Si vous avez renseign� le mot-cl� TOUT='OUI', cela signifie qu'il n'y a pas de mailles
 de peau dans votre mod�le ; il faut revoir le maillage.
"""),

56 : _(u"""
 La combinaison 'fonction multiplicatrice' et 'chargement de type fonction' n'est pas autoris�e car
 votre chargement %(k1)s contient une charge exprim�e par une formule.
 Pour r�aliser cette combinaison, vous devez transformer votre charge 'formule' en charge 'fonction'
 (via l'op�rateur DEFI_FONCTION ou CALC_FONC_INTERP).
 On poursuit sans tenir compte de la fonction multiplicatrice.
"""),

57 : _(u"""
 La combinaison de chargements de m�me type n'est pas autoris�e car l'un des chargements
 contient une charge exprim�e par une formule.
 Pour r�aliser cette combinaison, vous devez transformer votre charge 'formule' en charge 'fonction'
 (via l'op�rateur DEFI_FONCTION ou CALC_FONC_INTERP)
"""),

58 : _(u"""
 La combinaison de chargements de type 'd�formation initiale' n'a aucun sens physique.'
"""),

59 : _(u"""
 La combinaison de chargements de type 'pesanteur' n'a aucun sens physique.'
"""),

60 : _(u"""
 La combinaison de chargements de type 'rotation' est d�conseill�e.
 Veuillez plut�t utiliser un chargement de type 'force interne'.
"""),

65 : _(u"""
 composante non d�finie dans  la grandeur.  composante:  %(k1)s
"""),

66 : _(u"""

 le nombre de composantes affect�es n'est pas �gal  au nombre de composantes a affecter
 occurrence de AFFE num�ro %(i1)d
 nombre de composante affect�es :  %(i2)d
 nombre de composante a affecter :  %(i3)d
"""),

67 : _(u"""
 erreurs donn�es le GROUP_MA  %(k1)s
  n'a pas le m�me nombre de mailles  que le GROUP_MA  %(k2)s
"""),

68 : _(u"""
 erreurs donn�es le GROUP_MA  %(k1)s
  n'a pas les m�mes types de maille  que le GROUP_MA  %(k2)s
"""),

69 : _(u"""
 erreurs donn�es : la maille  %(k1)s  du maillage  %(k2)s
  n'est pas la translation de la  maille  %(k3)s
  du maillage  %(k4)s
    vecteur translation :  %(r1)f %(r2)f %(r3)f
"""),

70 : _(u"""
 l'instant  de calcul  %(r1)f  n'existe pas dans  %(k1)s
"""),

71 : _(u"""
 plusieurs num�ros d'ordre trouves pour l'instant  %(r1)f
"""),

72 : _(u"""
 cette commande est r�entrante :   sd resultat en sortie     %(k1)s
    sd resultat "RESU_FINAL"  %(k2)s
"""),

73 : _(u"""
 la sd resultat en sortie  %(k1)s
  doit contenir qu'un seul NUME_ORDRE %(k2)s
"""),

76 : _(u"""
 Il n'est pas encore possible de d�couper le type_�l�ment :  %(k1)s  en sous-�l�ments
    elrefa  :  %(k2)s ;
    famille :  %(k3)s.
 Faites une demande d'�volution.
"""),

78 : _(u"""
 Il n'est pas encore possible de d�couper le type_�l�ment :  %(k1)s  en sous-�l�ments
    elrefa :  %(k2)s.
 Faites une demande d'�volution.
"""),






85 : _(u"""
 Probl�me liste de mailles carte : %(k1)s  num�ro entit� : %(i1)d
  position dans liste : %(i2)d
  num�ro de maille  : %(i3)d
"""),

}
