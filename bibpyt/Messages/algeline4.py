#@ MODIF algeline4 Messages  DATE 07/05/2013   AUTEUR DESOZA T.DESOZA 
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
 Seules les m�thodes de r�solution LDLT, MUMPS et MULT_FRONT sont autoris�es.
"""),

2 : _(u"""
 solveur interne PETSc interdit pour l'instant avec FETI
"""),

3 : _(u"""
 Solveur GCPC :
 La r�solution du syst�me lin�aire a �chou� car le crit�re de convergence n'a pu �tre satisfait avec le nombre d'it�rations autoris�es.
   norme du r�sidu relatif apr�s %(i1)d it�rations :  %(r1)f
   crit�re de convergence � satisfaire             :  %(r2)f

 Conseils :
  * Augmentez le nombre d'it�rations autoris�es (SOLVEUR/NMAX_ITER).
  * Vous pouvez aussi augmenter le niveau de remplissage pour la factorisation incompl�te (SOLVEUR/NIVE_REMPLISSAGE).
  * Si vous utilisez une commande non-lin�aire (STAT_NON_LINE par exemple), diminuez la pr�cision demand�e pour la convergence (SOLVEUR/RESI_RELA).
    Prenez garde cependant car cela peut emp�cher la convergence de l'algorithme non-lin�aire.
"""),

4 : _(u"""
  Manque de m�moire :
     M�moire disponible = %(i1)d
     M�moire n�cessaire = %(i2)d
"""),

5 : _(u"""
Erreur utilisateur dans la commande CREA_MAILLAGE :
  Pour cr�er le nouveau maillage, il faut cr�er de nouveaux noeuds.
  Ici, on cherche � cr�er le noeud (%(k1)s) mais il existe d�j�.

  Par d�faut, les nouveaux noeuds ont des noms commen�ant par le pr�fixe 'NS', mais ce pr�fixe
  peut �tre modifi� par l'utilisateur (mots cl�s XXXX / PREF_NOEUD).

Risques & conseils :
  Quand on utilise 2 fois de suite la commande CREA_MAILLAGE, il est en g�n�ral n�cessaire
  d'utiliser au moins une fois l'un des mots cl�s PREF_NOEUD
"""),

6 : _(u"""
 Solveur GCPC :
 La r�solution du syst�me lin�aire a �chou� car le crit�re de convergence n'a pu �tre satisfait avec le nombre d'it�rations autoris�es.
   norme du r�sidu relatif apr�s %(i1)d it�rations :  %(r1)f
   crit�re de convergence � satisfaire             :  %(r2)f

 Conseils :
  * Augmentez le nombre d'it�rations autoris�es (SOLVEUR/NMAX_ITER).
  * Vous pouvez aussi r�actualiser plus souvent le pr�conditionneur en diminuant la valeur du mot-cl� SOLVEUR/REAC_PRECOND.
  * Si vous utilisez une commande non-lin�aire (STAT_NON_LINE par exemple), diminuez la pr�cision demand�e pour la convergence (SOLVEUR/RESI_RELA).
    Prenez garde cependant car cela peut emp�cher la convergence de l'algorithme non-lin�aire.
"""),

7 : _(u"""
 Erreur donn�es : maille d�j� existante :  %(k1)s
"""),
8 : _(u"""
 Erreur lors de la r�solution du syst�me lin�aire d'interface de FETI :
 Non convergence  avec le nombre d'it�rations autoris�es :  %(i1)d
   norme du r�sidu (absolu)  :  %(r1)f
   norme du r�sidu (relatif) :  %(r2)f

 Conseils :
  * Vous pouvez augmenter le nombre d'it�rations autoris�es (SOLVEUR/NMAX_ITER).
  * Vous pouvez activer le pr�conditionneur si cela n'est pas fait (PRE_COND='LUMPE').
  * Vous pouvez v�rifier votre interface via INFO_FETI (cf. U2.08.03).
  * Vous pouvez v�rifier le nombre de modes rigides en mode INFO=2.
"""),
9 : _(u"""
 Erreur donn�es GROUP_MA d�j� existant :  %(k1)s
"""),

10 : _(u"""
 Votre probl�me modal n'est pas un probl�me g�n�ralis� � matrices r�elles sym�triques :
 il comporte des matrices non sym�triques et/ou complexes, ou bien il s'agit d'un probl�me quadratique.
 Son spectre n'est donc pas uniquement restreint � l'axe r�el, il repr�sente une zone du plan complexe.

 Conseil :
 Il faut donc relancer votre calcul avec le mot-cl� TYPE_RESU='MODE_COMPLEXE' et les op�randes associ�es.
"""),

11 : _(u"""
 erreur donn�es GROUP_NO d�j� existant :  %(k1)s
"""),

12 : _(u"""
 R�duction sous forme de Hessenberg sup�rieure: erreur LAPACK %(i1)d !
"""),

13 : _(u"""
 L'algorithme APM a atteint le nombre maximal de discr�tisations du contour,
 c'est � dire %(i1)d, sans convergence du proc�d�.

 Conseils :
 Vous pouvez:
  - Changer les dimensions du contour de mani�re � r�duire son p�rim�tre,
  - Changer sa localisation. Il passe peut-�tre tr�s pr�s de valeurs propres
    ce qui peut induire des perturbations num�riques.
"""),

14 : _(u"""
 L'algorithme APM a atteint son nombre maximal d'it�rations, c'est � dire %(i1)d,
 sans convergence du proc�d�.

 Conseils :
  Vous pouvez:
  - Augmenter ce nombre maximal d'it�rations via le param�tre NMAX_ITER_CONTOUR,
  - Augmenter la discr�tisation initiale du contour via NBPOINT_CONTOUR,
  - Changer les dimensions du contour de mani�re � r�duire son p�rim�tre,
  - Changer sa localisation. Il passe peut-�tre tr�s pr�s de valeurs propres
    ce qui peut induire des perturbations num�riques.
"""),

15 : _(u"""
 L'algorithme APM avec le calcul du polyn�me caract�ristique via une factorisation
 LDLT a un probl�me num�rique: le point de v�rification (%(r1)f +i*%(r2)f)
 est tr�s proche d'une valeur propre ou le solveur lin�aire a eu un probl�me.

 Conseils :
 Vous pouvez:
 - Augmenter les dimensions du contour pour englober cette valeur propre,
 - Changer la discr�tisation du contour (plus risqu�).
 - Changer le param�trage du solveur lin�aire, ou le solveur lin�aire lui-m�me (expert).
"""),

17: _(u"""
 La variante 'ROMBOUT' de la m�thode de comptage 'APM' est en cours de fiabilisation.
 Elle n'a pas encore port�e pour:
   - les matrices complexes et/ou non sym�triques,
   - les probl�mes quadratiques,
   - les matrices g�n�ralis�es.

 Conseil :
 Vous pouvez utiliser l'autre variante de la m�thode 'APM' via le param�trage
 COMPTAGE/POLYNOME_CHARAC='LDLT'.
"""),

19 : _(u"""
 Matrice de masse non d�finie.

 Conseil : essayer un autre algorithme de r�solution.
"""),

20: _(u"""
 Pour l'instant, on est oblig� de choisir pour un r�sultat de type 'DYNAMIQUE' ou
 'FLAMBEMENT', la m�thode de comptage 'STURM', et pour 'MODE_COMPLEXE', la m�thode
 'APM'.
 Si vos choix ne respectent pas cette r�gle, on fait le changement pour vous, en
 se r�f�rant au type de probl�me que vous avez choisi.
"""),

21 : _(u"""
 Manque de place m�moire longueur de bloc insuffisante:  %(i1)d
 le super noeud  %(i2)d
  n�cessite un bloc de %(i3)d
"""),

22 : _(u"""
 L'algorithme APM a converg� sur un nombre de fr�quences aberrant !

 Conseils:
 Vous pouvez:
  - Augmenter la discr�tisation initiale du contour via NBPOINT_CONTOUR,
  - Changer les dimensions du contour de mani�re � r�duire son p�rim�tre,
  - Changer sa localisation. Il passe peut-�tre tr�s pr�s de valeurs propres
    ce qui peut induire des perturbations num�riques.
"""),

24 : _(u"""
 %(k1)s   pour le mot cl� :  %(k2)s    noeud :  %(k3)s composante :  %(k4)s
"""),

25 : _(u"""
 combinaison non pr�vue   type r�sultat :  %(k1)s    type matrice  :  %(k2)s
    type constante:  %(k3)s
"""),

27 : _(u"""
 combinaison non pr�vue
 type r�sultat :  %(k1)s
 type matrice  :  %(k2)s
"""),

31 : _(u"""
 combinaison non pr�vue
 type r�sultat :  %(k1)s
"""),

33 : _(u"""
 la normalisation doit se faire en place
 il est impossible d'avoir comme concept produit  %(k1)s et %(k2)s comme concept d'entr�e.
"""),

36 : _(u"""
 l'option de normalisation  %(k1)s  n'est pas implant�e. %(i1)d
"""),

37 : _(u"""
 probl�me(s) rencontr�(s) lors de la factorisation de la matrice : %(k1)s
"""),

38 : _(u"""
 appel erron� :
 code retour de RSEXCH : %(i1)d
 Probl�me CHAM_NO %(k1)s
"""),

39 : _(u"""
 Au moins une des matrices est non sym�trique.
 Dans ce cas, l'option 'BANDE' n'est pas utilisable.
"""),

40 : _(u"""
 Au moins une des matrices est non sym�trique.
 Dans ce cas, la d�tection des modes de corps rigide (OPTION='MODE_RIGIDE')
 n'est pas utilisable.
"""),

41 : _(u"""
 Au moins une des matrices est non sym�trique.
 Dans ce cas, le calcul de flambement ne peut pas �tre men�.
"""),

42 : _(u"""
 pas de produit car les valeurs de la MATRICE sont  %(k1)s
 et celles du CHAM_NO sont  %(k2)s
"""),

43 : _(u"""
 la maille de nom  %(k1)s  existe d�j� %(k2)s
"""),

55 : _(u"""
 pas d'extraction pour  %(k1)s
 pour le num�ro d'ordre  %(i1)d
"""),

56 : _(u"""
 pas de mode extrait pour  %(k1)s
"""),

57 : _(u"""
 NUME_MODE identique pour le %(i1)d
 mode d'ordre  %(i2)d
"""),

58 : _(u"""
  probl�me dans le pr�conditionnement de la matrice MATAS par LDLT incomplet
  pivot nul � la ligne :  %(i1)d
"""),

60 : _(u"""
  incoh�rence n2 NBDDL sans multiplicateurs de Lagrange %(i1)d NBDDL reconstitu�s %(i2)d
"""),

61 : _(u"""
 pas de mode statique pour le noeud :  %(k1)s  et sa composante :  %(k2)s
"""),

62 : _(u"""
 pour les modes statiques, on attend un :  %(k1)s
 noeud :  %(k2)s
 composante   :  %(k3)s
"""),








64 : _(u"""
 d�tection d'un terme nul sur la sur diagonale
 valeur de BETA   %(r1)f
 valeur de ALPHA  %(r2)f
"""),

65 : _(u"""
 La  %(i1)d -�me valeur propre du syst�me r�duit est complexe.
 Partie imaginaire =  %(r1)f
 et partie imaginaire / partie r�elle =  %(r2)f
 """),

66 : _(u"""
 la valeur propre est :   %(r1)f
"""),




74 : _(u"""
 Calcul d'erreur modale :
 une valeur propre r�elle est d�tect�e � partir du couple (fr�quence, amortissement r�duit).
 On ne peut plus la reconstruire.
 Par convention l'erreur modale est fix�e � : %(r1)f.
"""),



76 : _(u"""
 la r�orthogonalisation diverge apr�s  %(i1)d  it�ration(s).
"""),

77 : _(u"""
 l'option de normalisation  %(k1)s  n'est pas implant�e.
"""),





80 : _(u"""
 type de valeurs inconnu   %(k1)s
"""),



82 : _(u"""
 incoh�rence de certains param�tres modaux propres � ARPACK
 num�ro d'erreur  %(i1)d
"""),




85 : _(u"""
 appel erron� mode num�ro %(i1)d position modale %(i2)d
 code retour de RSEXCH : %(i3)d
 Probl�me CHAM_NO %(k1)s
"""),

86 : _(u"""
 la r�orthogonalisation diverge apr�s  %(i1)d  it�ration(s) %(i2)d
       vecteur trait� :  %(i3)d
       vecteur test�  :  %(i4)d
 arr�t de la r�orthogonalisation %(k1)s
"""),

87 : _(u"""
 pour le probl�me r�duit
 valeur(s) propre(s) r�elle(s)                  :  %(i1)d
 valeur(s) propre(s) complexe(s) avec conjugu�e :  %(i2)d
 valeur(s) propre(s) complexe(s) sans conjugu�e :  %(i3)d
"""),

88 : _(u"""
 votre probl�me est fortement amorti.
 valeur(s) propre(s) r�elle(s)                  :  %(i1)d
 valeur(s) propre(s) complexe(s) avec conjugu�e :  %(i2)d
 valeur(s) propre(s) complexe(s) sans conjugu�e :  %(i3)d
"""),

93 : _(u"""
 Probl�me g�n�ralis� complexe.
"""),

94 : _(u"""
 Probl�me quadratique complexe.
"""),

95 : _(u"""
 Probl�me quadratique.
"""),

96 : _(u"""
 Amortissement (r�duit) de d�calage sup�rieur en valeur absolue � %(r1)f.
 On le ram�ne � la valeur : %(r2)f.
"""),

98 : _(u"""
 nombre de valeurs propres converg�es  %(i1)d < nombre de fr�quences demand�es  %(i2)d
 erreur ARPACK num�ro :  %(i3)d
 --> le calcul continue, la prochaine fois
 -->   augmenter DIM_SOUS_ESPACE =  %(i4)d
 -->   ou NMAX_ITER_SOREN =  %(i5)d
 -->   ou PREC_SOREN =  %(r1)f
 si votre probl�me est fortement amorti, il est possible que
 des modes propres non calcul�s soient sur amortis
 --> diminuez le nombre de fr�quences demand�es
"""),

}
