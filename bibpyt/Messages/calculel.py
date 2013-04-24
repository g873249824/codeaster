#@ MODIF calculel Messages  DATE 23/04/2013   AUTEUR ABBAS M.ABBAS 
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
 Le champ � tester comporte %(i1)d sous-points.
 Or vous n'avez pas donn� de num�ro de sous-point � tester.
 Il faut renseigner POINT et SOUS_POINT.
"""),

2 : _(u"""
Erreur Utilisateur :
 Quand on utilise AFFE_CHAR_CINE/EVOL_IMPO, c'est le champ de l'EVOL_XXX correspondant
 au 1er instant qui impose sa "loi" : tous les ddls de ce champ seront impos�s pour tous
 les instants du calcul.

 Malheureusement, on ne trouve pas un ddl dans l'EVOL_XXX %(k1)s :
   instant : %(r1)f  noeud : %(i1)d  composante : %(k2)s

Risques & conseils :
 Assurez-vous que l'�volution impos�e %(k1)s concerne les m�mes ddls pour tous les instants.
"""),

3 : _(u"""
 La grandeur :  %(k1)s  n'existe pas dans le catalogue des grandeurs.
"""),

4 : _(u"""
 incoh�rence des maillages : %(k1)s  et  %(k2)s
"""),

5 : _(u"""
 Erreur de programmation (ou d'utilisation ?) :
   Le changement de discr�tisation : %(k1)s n'est pas encore programm�.
 Risques et conseils :
   Il y a peut-�tre une demande d'�volution � �mettre ...
"""),

6 : _(u"""
 Erreur d'utilisation :
   On n'arrive pas � construire correctement le champ contenant le nombre de sous-points
   des �l�ments finis (coques multicouches, tuyaux, poutres multifibres, ...) du mod�le %(k1)s.

 Risques & conseils :
   Cette erreur intervient lorsque l'on ne d�finit pas TOUTES les caract�ristiques �l�mentaires
   dans le m�me AFFE_CARA_ELEM.
   Pour les commandes de calcul, il ne faut qu'un seul MODELE et qu'un seul CARA_ELEM.
"""),

7 : _(u"""
 Erreur de maillage :
   La maille %(k1)s de type %(k2)s est trop distordue.
   Le jacobien de la transformation g�om�trique n'a pas le m�me signe sur tous les
   points de Gauss.

 Risques & conseils :
   Le maillage a-t-il �t� produit par un mailleur ?
   La connectivit� respecte-t-elle bien la convention Aster ?
"""),

8 : _(u"""
 sur la maille %(k1)s le calcul est thermo m�canique. Or il manque la temp�rature de r�f�rence.
 On ne peut donc pas calculer de d�formation thermique.
"""),

9 : _(u"""
 Erreur d'utilisation dans AFFE_CHAR_CINE :
   Aucun des ddls que l'on souhaite bloquer n'appartient au mod�le.
   La charge cin�matique produite est donc vide.

 Risques & Conseils :
   V�rifier le nom des ddls port�s par les noeuds des �l�ments de votre mod�le.
"""),

10 : _(u"""
Erreur de programmation lors de l'assemblage :
   Les quantit�s que l'on cherche � assembler (MATR_ELEM ou VECT_ELEM) ont �t� calcul�es avec au
   moins 2 partitions diff�rentes :  %(k1)s et %(k2)s
"""),

11 : _(u"""
 le mode_local:  %(k1)s  ne doit pas �tre vecteur ou matrice.
"""),

12 : _(u"""
 le mode_local:  %(k1)s  ne doit pas �tre "DIFF__".
"""),

13 : _(u"""
Erreur utilisateur concernant le parall�lisme des calculs �l�mentaires :
  La partition des �l�ments du mod�le a �t� faite sur %(i1)d processeurs.
  Mais maintenant, le nombre de processeurs disponibles est de %(i2)d.

Conseil :
  Il faut utiliser la commande MODI_MODELE pour modifier la partition du mod�le
  afin qu'elle soit coh�rente avec le nombre de processeurs disponibles pour les calculs.
"""),

14 : _(u"""
  incompatibilit� des type_champ ("ELGA"/"ELNO")  pour l option :  %(k1)s  entre les 2 TYPE_ELEM :  %(k2)s  et  %(k3)s
"""),

15 : _(u"""
 Erreur Utilisateur :
 On cherche � calculer une d�formation thermique mais on ne trouve pas toutes les
 quantit�s n�cessaires :
    - temp�rature
    - temp�rature de r�f�rence
    - coefficient de dilatation
"""),

17 : _(u"""
 type de champ inconnu
"""),

18 : _(u"""
 Vous utilisez CALC_CHAMP en reuse mais la structure de donn�es en entr�e est
 diff�rente de celle en sortie. Ce n'est pas autoris�.
"""),

19 : _(u"""
Erreur :
 Le CHAM_ELEM %(k1)s est incoh�rent :
   Il poss�de %(i1)d GREL.
   Il a �t� calcul� avec le LIGREL %(k2)s qui poss�de %(i2)d GREL.

Risques & Conseils :
 Il peut s'agir d'une erreur de programmation.
 Mais ce probl�me peut aussi se produire si le LIGREL (ou le MODELE)
 a �t� entre temps d�truit et recr�� sous le m�me nom.
"""),

20 : _(u"""
 le champ de grandeur  %(k1)s  ne respecte pas le format XXXX_r
"""),

21 : _(u"""
 les champs r�el et imaginaire � assembler ne contiennent pas la m�me grandeur
"""),

22 : _(u"""
 probl�me dans le catalogue des grandeurs simples
 la grandeur %(k1)s  ne poss�de pas le m�me nombre de champs que son homologue complexe %(k2)s
"""),

23 : _(u"""
 probl�me dans le catalogue des grandeurs simples
 la grandeur  %(k1)s  ne poss�de pas les m�mes champs que son homologue complexe  %(k2)s
"""),

24 : _(u"""
 Le mod�le donn� dans le mot-cl� MODELE n'est pas le m�me que celui pr�sent dans la
 structure de donn�es r�sultat. Ce n'est pas autoris�.
 En effet, le mot-cl� MODELE de CALC_CHAMP n'est utilisable que dans le cas o� le
 mod�le est manquant dans la structure de donn�es r�sultat.
"""),

25 : _(u"""
Erreur utilisateur dans PROJ_SPEC_BASE :
 La commande n'accepte que le parall�lisme de type PARTITION='CENTRALISE'.
 Mod�le impliqu� : %(k1)s

Conseil :
 Dans la commande AFFE_MODELE (ou MODI_MODELE), il faut utiliser PARTITION='CENTRALISE'
"""),

26 : _(u"""
 Le mod�le est peut-�tre trop grossier :
   Sur la maille %(k1)s et pour la composante %(k2)s de la grandeur %(k3)s,
   il y a une variation entre les points de la maille de %(r1)f
   alors que, globalement, les valeurs du champ ne d�passent pas %(r2)f (en valeur absolue).
   Cela fait une variation sur la maille sup�rieure � %(r3)f%%.
"""),

27 : _(u"""
 CHAM_ELEM � combiner incompatible
"""),

28 : _(u"""
 Probl�me lors de l'utilisation de la structure de donn�es %(k1)s.
 Cette structure de donn�es est de type "�volution temporelle" et l'on n'a pas le droit
 de l'utiliser en dehors de l'intervalle [tmin, tmax].
 Mais ici, il n'y a qu'un seul instant dans la structure de donn�e (tmin=tmax).
 Dans ce cas, on suppose alors que ce transitoire est "permanent" et que l'on peut l'utiliser
 pour toute valeur du temps.
"""),


29 : _(u"""
 Erreur utilisateur :
   Le programme a besoin d'acc�der au champ %(k2)s de la structure sd_resultat %(k1)s
   pour le NUME_ORDRE: %(i1)d
   Mais ce champ n'existe pas dans la structure de donn�es fournie.
   On ne peut pas continuer.

 Risques & conseils :
 V�rifiez que la structure de donn�es %(k1)s est bien celle qu'il faut utiliser.
"""),

30 : _(u"""
Erreur utilisateur :
  -> Le TYPE_ELEMENT %(k1)s  ne sait pas encore calculer l'option:  %(k2)s.

  -> Risques & Conseils :
   * Si vous utilisez une commande de "calcul" (THER_LINEAIRE, STAT_NON_LINE, ...), il n'y a pas
     moyen de contourner ce probl�me. Il faut changer de mod�lisation ou  �mettre une demande d'�volution.

   * Si c'est un calcul de post-traitement, vous pouvez sans doute "�viter" le probl�me
     en ne faisant le post-traitement que sur les mailles qui savent le faire.
     Pour cela, il faut sans doute utiliser un mot cl� de type "GROUP_MA".
     S'il n'y en a pas, il faut faire une demande d'�volution.
"""),

31 : _(u"""
  La temp�rature n'est pas correctement renseign�e
"""),

32 : _(u"""
Erreur utilisateur :
  Sur la maille %(k1)s le calcul est thermo m�canique. Mais il manque le param�tre mat�riau
  %(k2)s . On ne peut donc pas calculer la d�formation thermique.

Conseils :
  Si le probl�me concerne TEMP_REF, v�rifiez que vous avez bien affect� une temp�rature
  de r�f�rence (AFFE_MATERIAU/AFFE_VARC/NOM_VARC='TEMP', VALE_REF=...)
"""),

33 : _(u"""
Vous utilisez CALC_CHAMP en reuse en surchargeant le mot-cl�
%(k1)s. Or ce param�tre d�j� pr�sent dans structure de donn�es r�sultat sur laquelle
vous travaillez est diff�rent de celui donn� (%(k2)s et %(k3)s).

Dans ce cas, le reuse est interdit.

Conseil :
  Relancez le calcul en cr�ant une nouvelle structure de donn�es r�sultat.
"""),

34 : _(u"""
 le calcul de l'option :  %(k1)s
 n'est possible pour aucun des types d'�l�ments du LIGREL.
"""),

35 : _(u"""
 Erreur utilisateur :
  On essaye de fusionner 2 CHAM_ELEM mais ils n'ont pas le m�me nombre
  "points" (noeuds ou points de Gauss) pour la maille num�ro : %(i1)d.
  Nombres de points :  %(i2)d et %(i3)d
"""),

36 : _(u"""
 Erreur utilisateur :
  On essaye de fusionner 2 CHAM_ELEM mais ils n'ont pas le m�me nombre
  de "sous-points" (fibres, couches, ...) pour la maille num�ro : %(i1)d.
  Nombres de sous-points :  %(i2)d et %(i3)d
"""),

37 : _(u"""
 Erreur dans la lecture des CHAR_CINE ou dans les CHAR_CINE
"""),

38 : _(u"""
 la carte concerne aussi des mailles tardives qui sont oubli�es
"""),

39 : _(u"""
Le chargement (mot cl�: EXCIT) fourni par l'utilisateur est diff�rent de celui pr�sent
dans la structure de sonn�es R�sultat. Dans ce cas, le reuse est interdit.

Conseil :
  Relancez le calcul en cr�ant une nouvelle structure de donn�es r�sultat.
"""),





42 : _(u"""
 Erreur Programmeur:
 Incoh�rence fortran/catalogue
 TYPE_ELEMENT :  %(k1)s
 OPTION       :  %(k2)s
 La routine texxxx.f correspondant au calcul �l�mentaire ci-dessus est erron�e
 Elle �crit en dehors de la zone allou�e au param�tre (OUT) %(k3)s.

"""),

47 : _(u"""
  le CHAM_ELEM:  %(k1)s  n'existe pas.
"""),

48 : _(u"""
 le CHAM_ELEM: %(k1)s  n'a pas le m�me nombre de composantes dynamiques sur tous ses �l�ments.
"""),

49 : _(u"""
 le CHAM_ELEM : %(k1)s a des sous-points.
"""),


50 : _(u"""
 Vous cherchez � projeter un champ inhabituel sur le mod�le final.
 V�rifiez que les mod�lisations que vous utilisez sont compatibles.

 Message destin� aux d�veloppeurs :
 Le param�tre:  %(k1)s  de l'option:  %(k2)s  n'est pas connu des TYPE_ELEM du LIGREL:  %(k3)s
 Champ : %(k4)s
"""),

52 : _(u"""
 La composante: %(k1)s  n'appartient pas � la grandeur: %(k2)s
 Champ : %(k4)s
"""),

53 : _(u"""
 Option : %(k1)s  inexistante dans les catalogues.
 Champ : %(k4)s
"""),

54 : _(u"""
 Le param�tre:  %(k1)s  de l'option:  %(k2)s  n'est pas connu des TYPE_ELEM du LIGREL:  %(k3)s
 Champ : %(k4)s
"""),

55 : _(u"""
 Erreur utilisateur :
   On cherche � cr�er un CHAM_ELEM mais sur certains points, on ne trouve pas la composante : %(k1)s
   Champ : %(k4)s
 Risques & conseils :
   Si la commande que vous ex�cutez comporte le mot cl� PROL_ZERO='OUI', vous devriez peut-�tre l'utiliser.
"""),

56 : _(u"""
 Le LIGREL contient des mailles tardives
 Champ : %(k4)s
"""),

57 : _(u"""
 Erreur Utilisateur :
   On cherche � transformer un champ simple en CHAM_ELEM.
   Le nombre de "points" (points de Gauss ou noeuds) du champ simple (%(i2)d) est
   diff�rent du nombre de points attendu pour le CHAM_ELEM (%(i1)d) :
     - maille              :  %(k1)s
     - nom du CHAM_ELEM    :  %(k4)s
     - nom du champ simple :  %(k5)s

"""),

58 : _(u"""
Erreur lors de la fabrication d'un champ par �l�ments :
 Il manque la composante : %(k1)s  sur la maille : %(k2)s
 Champ : %(k4)s

Risques et conseils :
 Si cette erreur se produit lors de l'ex�cution de la commande PROJ_CHAMP,
 il est possible de poursuivre le calcul en choisissant PROL_ZERO='OUI'
"""),

67 : _(u"""
 grandeur:  %(k1)s  inconnue au catalogue.
"""),

68 : _(u"""
 num�ro de maille invalide     :  %(k1)s  (<1 ou > nombre de mailles)
"""),

69 : _(u"""
 num�ro de point invalide      :  %(k1)s  (<1 ou > nombre de points)
 pour la maille                :  %(k2)s
"""),

70 : _(u"""
 num�ro de sous-point invalide :  %(k1)s  (<1 ou > nombre de sous-points)
 pour la maille                :  %(k2)s
 pour le point                 :  %(k3)s
"""),

71 : _(u"""
 num�ro de composante invalide :  %(k1)s  (<1 ou > nombre de composantes)
 pour la maille                :  %(k2)s
 pour le point                 :  %(k3)s
 pour le sous-point            :  %(k4)s
"""),

72 : _(u"""
 Erreur commande CALC_FERRAILLAGE :
   On n'a pas r�ussi � calculer la carte de ferraillage sur un �l�ment.
   Code_retour de la routine clcplq.f : %(i1)d

 Signification du code d'erreur :
   1000 : Levier n�gatif ou nul (l'utilisateur a fourni des valeurs d'enrobage incompatibles avec l'�paisseur de l'�l�ment)
   1010 : D�passement d�formation b�ton
   1020 : Erreur calcul ELU
   1050 : D�passement contrainte b�ton;
"""),

73 : _(u"""
 Erreur utilisateur commande CALC_FERRAILLAGE :
   Certains mots cl�s de CALC_FERRAILLAGE / AFFE sont obligatoires :
     pour TYPE_COMB='ELU' :
        PIVA et PIVB
     pour TYPE_COMB='ELS' :
        CEQUI
"""),

75 : _(u"""
 Votre mod�le ne contient que des �l�ments 1D. Le lissage global n'est
 possible que pour les �l�ments 2D ou 3D.
"""),

76 : _(u"""
 Votre mod�le contient un m�lange d'�l�ments 1D,2D ou 3D.
 Le lissage global n'est possible que pour les �l�ments 2D soit 3D.
"""),

90 : _(u"""
 Le champ %(k2)s ne peut pas �tre cr�� � partir de %(k1)s car il est d�crit sur des
 mailles n'existant pas dans %(k1)s et il est de type VARI_ELGA.
"""),

91 : _(u"""
 incoh�rence des familles de points de Gauss pour la maille  %(k1)s
 ( %(k2)s / %(k3)s )
"""),

92 : _(u"""
 type scalaire du CHAM_NO :  %(k1)s  non r�el.
"""),

93 : _(u"""
 type scalaire du NUME_DDL :  %(k1)s  non r�el.
"""),

99 : _(u"""
 m�lange de CHAM_ELEM_S et CHAM_NO_S
"""),

}
