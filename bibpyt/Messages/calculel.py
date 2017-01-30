# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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
 Le champ à tester comporte %(i1)d sous-points.
 Or vous n'avez pas donné de numéro de sous-point à tester.
 Il faut renseigner POINT et SOUS_POINT.
"""),

    2 : _(u"""
Erreur Utilisateur :
 Quand on utilise AFFE_CHAR_CINE/EVOL_IMPO, c'est le champ de l'EVOL_XXX correspondant
 au premier instant qui impose sa "loi" : tous les ddls de ce champ seront imposés pour tous
 les instants du calcul.

 Malheureusement, on ne trouve pas un ddl dans l'EVOL_XXX %(k1)s :
   instant : %(r1)f  noeud : %(i1)d  composante : %(k2)s

Risques & conseils :
 Assurez-vous que l'évolution imposée %(k1)s concerne les mêmes ddls pour tous les instants.
"""),

    3 : _(u"""
 La grandeur :  %(k1)s  n'existe pas dans le catalogue des grandeurs.
"""),



    5 : _(u"""
 Erreur de programmation (ou d'utilisation ?) :
   Le changement de discrétisation : %(k1)s n'est pas encore programmé.
 Risques et conseils :
   Il y a peut-être une demande d'évolution à émettre ...
"""),

    6 : _(u"""
 Erreur d'utilisation :
   On n'arrive pas à construire correctement le champ contenant le nombre de sous-points
   des éléments finis (coques multicouches, tuyaux, poutres multifibres, ...) du modèle %(k1)s.

 Risques & conseils :
   Cette erreur intervient lorsque l'on ne définit pas TOUTES les caractéristiques élémentaires
   dans le même AFFE_CARA_ELEM.
   Pour les commandes de calcul, il ne faut qu'un seul MODELE et qu'un seul CARA_ELEM.
"""),




    9 : _(u"""
 Erreur d'utilisation dans AFFE_CHAR_CINE :
   Aucun des ddls que l'on souhaite bloquer n'appartient au modèle.
   La charge cinématique produite est donc vide.

 Risques & Conseils :
   Vérifier le nom des ddls portés par les noeuds des éléments de votre modèle.
"""),

    10 : _(u"""
Erreur de programmation lors de l'assemblage :
   Les quantités que l'on cherche à assembler (MATR_ELEM ou VECT_ELEM) ont été calculées avec au
   moins 2 partitions différentes :  %(k1)s et %(k2)s
"""),

    15 : _(u"""
 Erreur Utilisateur :
 On cherche à calculer une déformation thermique mais on ne trouve pas toutes les
 quantités nécessaires :
    - température
    - température de référence
    - coefficient de dilatation
"""),

    17 : _(u"""
 type de champ inconnu
"""),

    18 : _(u"""
 Vous utilisez CALC_CHAMP en reuse mais la structure de données en entrée est
 différente de celle en sortie. Ce n'est pas autorisé.
"""),

    19 : _(u"""
Erreur :
 Le CHAM_ELEM %(k1)s est incohérent :
   Il possède %(i1)d groupe d'éléments.
   Il a été calculé avec le LIGREL %(k2)s qui possède %(i2)d groupe d'éléments.

Risques & Conseils :
 Il peut s'agir d'une erreur de programmation.
 Mais ce problème peut aussi se produire si le LIGREL (ou le MODELE)
 a été entre temps détruit et recréé sous le même nom.
"""),

    20 : _(u"""
Le champ de grandeur %(k1)s ne respecte pas le format pour son nom.
"""),

    21 : _(u"""
Les champs réel et imaginaire à assembler ne contiennent pas la même grandeur
"""),

    22 : _(u"""
 problème dans le catalogue des grandeurs simples
 la grandeur %(k1)s  ne possède pas le même nombre de champs que son homologue complexe %(k2)s
"""),

    23 : _(u"""
 problème dans le catalogue des grandeurs simples
 la grandeur  %(k1)s  ne possède pas les mêmes champs que son homologue complexe  %(k2)s
"""),

    24 : _(u"""
 Le modèle donné dans le mot-clé MODELE n'est pas le même que celui présent dans la
 structure de données résultat. Ce n'est pas autorisé.
 En effet, le mot-clé MODELE de CALC_CHAMP n'est utilisable que dans le cas où le
 modèle est manquant dans la structure de données résultat.
"""),

    25 : _(u"""
Erreur utilisateur :
 Vous utilisez probablement la commande PROJ_SPEC_BASE ou le comportement ENDO_HETEROGENE.
 Seul le parallélisme de type METHODE='CENTRALISE' est autorisé. Modèle concerné : %(k1)s

Conseil :
 Dans la commande AFFE_MODELE (ou MODI_MODELE), il faut utiliser METHODE='CENTRALISE'
"""),

    26 : _(u"""
 Le modèle est peut-être trop grossier :
   Sur la maille %(k1)s et pour la composante %(k2)s de la grandeur %(k3)s,
   il y a une variation entre les points de la maille de %(r1)f
   alors que, globalement, les valeurs du champ ne dépassent pas %(r2)f (en valeur absolue).
   Cela fait une variation sur la maille supérieure à %(r3)f%%.
"""),

    27 : _(u"""
Erreur d'utilisation (ou de programmation) :
   On cherche à combiner deux champs par éléments qui n'ont pas la même "structure".
   La programmation ne le permet pas actuellement.
"""),

    28 : _(u"""
 Problème lors de l'utilisation de la structure de données %(k1)s.
 Cette structure de données est de type "évolution temporelle" et l'on n'a pas le droit
 de l'utiliser en dehors de l'intervalle.
 Mais ici, il n'y a qu'un seul instant dans la structure de donnée.
 Dans ce cas, on suppose alors que ce transitoire est "permanent" et que l'on peut l'utiliser
 pour toute valeur du temps.
"""),


    29 : _(u"""
 Erreur utilisateur :
   Le programme a besoin d'accéder au champ %(k2)s de la structure de données résultat %(k1)s
   pour le NUME_ORDRE: %(i1)d
   Mais ce champ n'existe pas dans la structure de données fournie.
   On ne peut pas continuer.

 Risques & conseils :
 Vérifiez que la structure de données %(k1)s est bien celle qu'il faut utiliser.
"""),

    30 : _(u"""
Erreur utilisateur :
  Le programme se sait pas interpoler entre deux champs de type "carte".

Risques et conseils :
  * Il faut faire en sorte que les champs soient des champs par éléments de type 'ELEM'.
  * La commande CREA_CHAMP peut produire directement des champs par éléments.
  * Si on imprime et on relit une structure de données résultat sur un fichier au format MED,
    les cartes de la structure de données résultat sont transformées en champs par éléments de type 'ELEM'.
  La structure de donnée "coupable" est : %(k1)s
"""),



    32 : _(u"""
Erreur utilisateur :
  -> L'utilisation de la commande %(k1)s avec l'option %(k5)s pour
     les éléments du type %(k4)s n'est pas autorisée.
  -> Vous utilisez la commande %(k1)s il n'y a pas moyen de contourner cette erreur.

La maille incriminée est %(k6)s.

Pour information :
   Le nom du résultat         : %(k3)s
   Le type de concept produit : %(k2)s
"""),


    33 : _(u"""
Vous utilisez CALC_CHAMP en reuse en surchargeant le mot-clé
%(k1)s. Or ce paramètre déjà présent dans structure de données résultat sur laquelle
vous travaillez est différent de celui donné (%(k2)s et %(k3)s).

Dans ce cas, le reuse est interdit.

Conseil :
  Relancez le calcul en créant une nouvelle structure de données résultat.
"""),



    35 : _(u"""
 Erreur utilisateur :
  On essaye de fusionner 2 CHAM_ELEM mais ils n'ont pas le même nombre
  "points" (noeuds ou points de Gauss) pour la maille numéro : %(i1)d.
  Nombres de points :  %(i2)d et %(i3)d
"""),

    36 : _(u"""
 Erreur utilisateur :
  On essaye de fusionner 2 CHAM_ELEM mais ils n'ont pas le même nombre
  de "sous-points" (fibres, couches, ...) pour la maille numéro : %(i1)d.
  Nombres de sous-points :  %(i2)d et %(i3)d
"""),

    37 : _(u"""
 Erreur dans la lecture des CHAR_CINE ou dans les CHAR_CINE
"""),

    38 : _(u"""
 la carte concerne aussi des mailles tardives qui sont oubliées
"""),

    39 : _(u"""
Le chargement (mot clé: EXCIT) fourni par l'utilisateur est différent de celui présent
dans la structure de données Résultat. Dans ce cas, le reuse est interdit.

Conseil :
  Relancez le calcul en créant une nouvelle structure de données résultat.
"""),

    40 : _(u"""
 Erreur possible d'utilisation:
   Vous avez affecté des données sur certaines mailles mais ces données
   n'ont pas de signification pour les éléments finis portés par ces mailles.
   Il s'agit peut-être d'une erreur d'affectation.

 Champ : '%(k1)s'
 Commentaire sur ce champ : %(k2)s
 Grandeur : %(k3)s   Composante non reconnue : %(k4)s

 Ce problème concerne %(i1)d mailles
 Les premières mailles concernées sont imprimées ci-dessous.
 Type de l'élément affecté sur la première maille imprimée : %(k5)s
"""),

    41 : _(u"""  Maille : %(k1)s. Cette maille appartient aux GROUP_MA : %(k2)s %(k3)s %(k4)s %(k5)s
"""),

    42 : _(u"""
 Utilisation de COEF_RIGI_DRZ en mode rotation plane :
   Vous avez affecté une valeur négative de COEF_RIGI_DRZ sur des mailles ou groupes de mailles TRIA3 et QUAD4. Ce mode d'utilisation est permis,
   mais le mode rotation plane ne s'activera pas sur les triangles. Le rotation plane permet d'associer une signification 
   physique à la troisième rotation contrairement aux modèles classiques des plaques minces.
   Il s'agit peut-être d'une erreur d'affectation.
 Conseils : 
   On conseille que cette valeur soit -1.E-2 < COEF_RIGI_DRZ < -1.E-12.

 Champ : '%(k1)s'
 Commentaire sur ce champ : %(k2)s
 Grandeur : %(k3)s   Composante non reconnue : %(k4)s

 Ce problème concerne %(i1)d mailles
 Les premières mailles concernées sont imprimées ci-dessous.
 Type de l'élément affecté sur la première maille imprimée : %(k5)s
"""),


    43 : _(u"""
 Utilisation de COEF_RIGI_DRZ en mode rotation plane :
   Vous avez affecté une valeur négative de COEF_RIGI_DRZ sur des mailles uniquement TRIA3.
   Le mode d'utilisation n'est pas possible actuellement pour ces types de mailles. Le rotation plane permet d'associer une signification 
   physique à la troisième rotation contrairement aux modèles classiques des plaques minces.
   Il s'agit peut-être d'une erreur d'affectation.
 Conseils : 
   On conseille que cette valeur soit -1.E-2 < COEF_RIGI_DRZ < -1.E-12.

 Champ : '%(k1)s'
 Commentaire sur ce champ : %(k2)s
 Grandeur : %(k3)s   Composante non reconnue : %(k4)s

 Ce problème concerne %(i1)d mailles
 Les premières mailles concernées sont imprimées ci-dessous.
 Type de l'élément affecté sur la première maille imprimée : %(k5)s
"""),


    44 : _(u"""
 Utilisation de COEF_RIGI_DRZ en mode rotation plane :
   Vous avez affecté une valeur négative de COEF_RIGI_DRZ.  Le rotation plane permet d'associer une signification physique à la troisième rotation 
   contrairement aux modèles classiques des plaques minces.
 Conseils : 
   On conseille que cette valeur soit -1.E-2 < COEF_RIGI_DRZ < -1.E-12.

 Champ : '%(k1)s'
 Commentaire sur ce champ : %(k2)s
 Grandeur : %(k3)s   Composante non reconnue : %(k4)s

 Ce problème concerne %(i1)d mailles
 Les premières mailles concernées sont imprimées ci-dessous.
 Type de l'élément affecté sur la première maille imprimée : %(k5)s
"""),


    45 : _(u"""
 Utilisation de COEF_RIGI_DRZ en mode rotation plane en non linéaire :
   Cette option n'est pas possible actuellement

 Champ : '%(k1)s'
 Commentaire sur ce champ : %(k2)s
 Grandeur : %(k3)s   Composante non reconnue : %(k4)s

 Ce problème concerne %(i1)d mailles
 Les premières mailles concernées sont imprimées ci-dessous.
 Type de l'élément affecté sur la première maille imprimée : %(k5)s
"""),

    47 : _(u"""
  le CHAM_ELEM:  %(k1)s  n'existe pas.
"""),

    48 : _(u"""
 le CHAM_ELEM: %(k1)s  n'a pas le même nombre de composantes dynamiques sur tous ses éléments.
"""),

    49 : _(u"""
 le CHAM_ELEM : %(k1)s a des sous-points.
"""),


    50 : _(u"""
 Vous cherchez à projeter un champ inhabituel sur le modèle final.
 Vérifiez que les modélisations que vous utilisez sont compatibles.

 Message destiné aux développeurs :
 Le paramètre:  %(k1)s  de l'option:  %(k2)s  n'est pas connu des TYPE_ELEM du LIGREL:  %(k3)s
 Champ : %(k4)s
"""),

    52 : _(u"""
 La composante: %(k1)s  n'appartient pas à la grandeur: %(k2)s
 Champ : %(k4)s
"""),

    53 : _(u"""
 Option : %(k1)s  inexistante dans les catalogues.
 Champ : %(k4)s
"""),

    54 : _(u"""
 Le paramètre:  %(k1)s  de l'option:  %(k2)s  n'est pas connu des TYPE_ELEM du LIGREL:  %(k3)s
 Champ : %(k4)s
"""),

    55 : _(u"""
 Erreur utilisateur :
   On cherche à créer un CHAM_ELEM mais sur certains points, on ne trouve pas la composante : %(k1)s
   Champ : %(k4)s
 Risques & conseils :
   Si la commande que vous exécutez comporte le mot clé PROL_ZERO='OUI', vous devriez peut-être l'utiliser.
"""),

    56 : _(u"""
 Le LIGREL contient des mailles tardives
 Champ : %(k4)s
"""),

    57 : _(u"""
 Erreur Utilisateur :
   On cherche à transformer un champ simple en CHAM_ELEM.
   Le nombre de "points" (points de Gauss ou noeuds) du champ simple (%(i2)d) est
   différent du nombre de points attendu pour le CHAM_ELEM (%(i1)d) :
     - maille              :  %(k1)s
     - nom du CHAM_ELEM    :  %(k4)s
     - nom du champ simple :  %(k5)s

"""),

    58 : _(u"""
Erreur lors de la fabrication d'un champ par éléments :
 Il manque la composante : %(k1)s  sur la maille : %(k2)s
 Champ : %(k4)s

Risques et conseils :
 Si cette erreur se produit lors de l'exécution de la commande PROJ_CHAMP,
 il est possible de poursuivre le calcul en choisissant PROL_ZERO='OUI'
"""),

    67 : _(u"""
 grandeur:  %(k1)s  inconnue au catalogue.
"""),

    68 : _(u"""
 numéro de maille invalide     :  %(k1)s  (<1 ou > nombre de mailles)
"""),

    69 : _(u"""
 numéro de point invalide      :  %(k1)s  (<1 ou > nombre de points)
 pour la maille                :  %(k2)s
"""),

    70 : _(u"""
 numéro de sous-point invalide :  %(k1)s  (<1 ou > nombre de sous-points)
 pour la maille                :  %(k2)s
 pour le point                 :  %(k3)s
"""),

    71 : _(u"""
 numéro de composante invalide :  %(k1)s  (<1 ou > nombre de composantes)
 pour la maille                :  %(k2)s
 pour le point                 :  %(k3)s
 pour le sous-point            :  %(k4)s
"""),

    72 : _(u"""
 Erreur commande CALC_FERRAILLAGE :
   On n'a pas réussi à calculer la carte de ferraillage sur un élément.
   Levier négatif ou nul (l'utilisateur a fourni des valeurs d'enrobage incompatibles avec l'épaisseur de l'élément)
"""),

    73 : _(u"""
 Erreur utilisateur commande CALC_FERRAILLAGE :
   Certains mots clés de CALC_FERRAILLAGE / AFFE sont obligatoires :
     pour TYPE_COMB='ELU' :
        PIVA et PIVB et ES
        ES doit être supérieur à 0
     pour TYPE_COMB='ELS' :
        CEQUI
"""),
    74 : _(u"""
 Erreur utilisateur commande CALC_FERRAILLAGE :
   La valeur du module d'Young ES est de <%(r1)E>. Elle n'est pas correcte.
"""),
    75 : _(u"""
 Votre modèle ne contient que des éléments 1D. Le lissage global n'est
 possible que pour les éléments 2D ou 3D.
"""),

    76 : _(u"""
 Votre modèle contient un mélange d'éléments 1D,2D ou 3D.
 Le lissage global n'est possible que pour les éléments 2D soit 3D.
"""),
    77 : _(u"""
 Commande CALC_FERRAILLAGE :
   ELU : On n'a pas réussi à calculer la densité de ferraillage sur une ou plusieurs facettes de Capra Maury.
   Les sections d'aciers sont complètement comprimées. La densité calculée est nulle sur ces facettes.
   Le résultat sur l'élément peut être non nul si les autres facettes sont calculables.
   ATTENTION : Aucune vérification des contraintes dans le béton n'est faite en compression sur cette facette.
   (Pivot C non calculé)   
"""),
    78 : _(u"""
 Commande CALC_FERRAILLAGE :
   ELU : On n'a pas réussi à calculer la densité de ferraillage sur l'élément.
   Toutes les facettes de Capra Maury sont en compression.
   Les sections d'aciers sont complètement comprimées. La densité calculée est mise à -1.
   C'est probablement un pivot C, ce cas n'est pas prévu.   
"""),

    79 : _(u"""
 Commande CALC_FERRAILLAGE :
   ELU : On n'a pas réussi à calculer la densité de ferraillage sur l'élément.
   Pour une des facettes de Capra Maury au moins, la section est complètement comprimée. La densité calculée est mise à -1.
   C'est probablement un pivot C, ce cas n'est pas prévu.
"""),

    80 : _(u"""
 Erreur commande CALC_FERRAILLAGE :
   On n'a pas réussi à calculer la carte de ferraillage sur un élément.
   ELS : Dépassement contrainte béton;
"""),

    90 : _(u"""
 Le champ %(k2)s ne peut pas être créé à partir de %(k1)s car il est décrit sur des
 mailles n'existant pas dans %(k1)s et il est de type VARI_ELGA.
"""),

    91 : _(u"""
 incohérence des familles de points de Gauss pour la maille  %(k1)s
 ( %(k2)s / %(k3)s )
"""),

    92 : _(u"""
 type scalaire du CHAM_NO :  %(k1)s  non réel.
"""),

    93 : _(u"""
 type scalaire du NUME_DDL :  %(k1)s  non réel.
"""),

    99 : _(u"""
 mélange de CHAM_ELEM_S et CHAM_NO_S
"""),

}
