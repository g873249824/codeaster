#@ MODIF algeline5 Messages  DATE 11/02/2013   AUTEUR DESOZA T.DESOZA 
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

cata_msg={

1: _(u"""
 La somme de matrices distribu�es n'ayant pas le m�me profil est impossible
"""),

4: _(u"""
 erreur LAPACK (ou BLAS) au niveau de la routine  %(k1)s
  le param�tre num�ro  %(i1)d
  n'a pas une valeur coh�rente %(i2)d
"""),

5: _(u"""
 !! Attention, vous utilisez l'option de test FETI de l'interface.
 On va donc simuler la r�solution d'un syst�me diagonal canonique,
 pour provoquer un test d'ensemble de l'algorithme qui doit trouver
 la solution U=1 sur tous les noeuds.
 Vos r�sultats sont donc artificiellement fauss�s pour les besoins de
 ce test. Pour r�aliser effectivement votre calcul, d�sactiver cette
 option (INFO_FETI(12:12)='F' au lieu de 'T') !!
"""),

6: _(u"""
 R�solution MULTI_FRONTALE :
 probl�me dans le traitement des r�sultats de AMDBAR
 tous les NDS du SN %(i1)d ont NV nul
"""),

10: _(u"""
  le nombre de noeuds de la structure   :  %(i1)d
  la base utilis�e est              :  %(k1)s
  les caract�ristiques �l�mentaires :  %(k2)s
  diam�tre de la structure          :  %(r1)f
  type de pas                       :  %(i2)d
"""),

11: _(u"""
  le profil de vitesse de la zone :  %(k1)s
  type de r�seau de la zone       :  %(i1)d
"""),

13: _(u"""
  le noeud d'application            :  %(k1)s
  la base utilis�e est              :  %(k2)s
  les caract�ristiques �l�mentaires :  %(k3)s
  diam�tre de la structure          :  %(r1)f
  type de configuration             :  %(k4)s
  le coefficient de masse ajout�e   :  %(r2)f
  le profil de masse volumique      :  %(r3)f
"""),

14: _(u"""
    pas de couplage pris en compte
"""),

15: _(u"""
   pour le concept  %(k1)s, le mode num�ro  %(i1)d
"""),

16: _(u"""
  de fr�quence  %(r1)f
"""),

17: _(u"""
  de charge critique  %(r1)f
"""),

18: _(u"""
  a une norme d'erreur de  %(r1)f  sup�rieure au seuil admis  %(r2)f.
"""),



20: _(u"""
  est en dehors de l'intervalle de recherche : [ %(r2)f,  %(r3)f ].
"""),



23: _(u"""
   pour le concept  %(k1)s,
"""),

24: _(u"""
  dans l'intervalle [%(r1)f  ,  %(r2)f]
  il y a th�oriquement  %(i1)d fr�quence(s) propres()
  et on en a calcul�  %(i2)d.
"""),

25: _(u"""
  dans l'intervalle [%(r1)f  ,  %(r2)f]
  il y a th�oriquement  %(i1)d charge(s) critique(s)
  et on en a calcul�  %(i2)d.
"""),

26: _(u"""
 Ce probl�me peut appara�tre lorsqu'il y a des modes multiples (structure avec sym�tries)
 ou une forte densit� modale.
"""),

27: _(u"""
 La valeur du SHIFT %(r1)f co�ncide avec une fr�quence propre.
"""),

28: _(u"""
 les nombres de termes des matrices RIGI et MASSE diff�rent
 celui de la matrice MASSE vaut :  %(i1)d
 celui de la matrice RIGI  vaut :  %(i2)d

"""),

29: _(u"""
 le nombre d'amortissements r�duits est trop grand
 le nombre de modes propres vaut  %(i1)d
 et le nombre de coefficients :   %(i2)d
 on ne garde donc que les %(i3)d premiers coefficients

"""),

30: _(u"""
 le nombre d'amortissements r�duits est insuffisant, il en manque :  %(i1)d,
 car le nombre de modes vaut :  %(i2)d
 on rajoute  %(i3)d amortissements r�duits avec la valeur du dernier mode propre.
"""),

31: _(u"""
  incoh�rence :
   DEEQ I      =  %(i1)d
   DEEQ(2*I-1) =  %(i2)d
   DEEQ(2*I)   =  %(i3)d

"""),

32: _(u"""
  erreur de type DELG(IDDL) diff�rent de -1 ou -2  %(i1)d
"""),

33: _(u"""
 un ddl bloqu� a au moins 2 LAMBDA1 ou 2 LAMBDA2
 le ddl bloqu� est  %(i1)d

"""),

34: _(u"""
 incoh�rence des multiplicateurs de Lagrange
 DDL %(i1)d
 LAMBDA1 %(i2)d
 LAMBDA2 %(i3)d
"""),

35: _(u"""
 erreur programmeur
 le LAMBDA2  %(i1)d a moins de 2 voisins
 il faut le LAMBDA1 et au moins un DDL

"""),

36: _(u"""
 Probl�me dans le calcul des DDL :
 NUM devrait �tre �gal � n1 :
 NUM = %(i1)d , n1 = %(i2)d
 impression des multiplicateurs de Lagrange
"""),

37: _(u"""
 NUME_DDL incoh�rence des multiplicateurs de Lagrange
  DDL     %(i1)d
  LAMBDA1 %(i2)d
  LAMBDA2 %(i3)d
"""),

38: _(u"""
 nombre de relations lin�aires %(i1)d
"""),

39: _(u"""
 LAMBDA1 de R lin�aire : %(i1)d
 LAMBDA2 de R lin�aire : %(i2)d
"""),

40: _(u"""
 Donn�es erron�es
"""),

41: _(u"""
 pas de mode statique pour  le noeud :  %(k1)s  et sa composante :  %(k2)s

"""),

42: _(u"""
 pour les modes statiques :
 on attend un :  %(k1)s
 noeud :  %(k2)s
 composante   :  %(k3)s

"""),

43: _(u"""
 champ inexistant.
 champ :  %(k1)s
 noeud :  %(k2)s
 composante   :  %(k3)s

"""),

48: _(u"""
 incoh�rence de certains param�tres modaux propres � ARPACK
  num�ro d'erreur  %(i1)d

"""),

49: _(u"""
 nombre de valeurs propres converg�es  %(i1)d < nombre de fr�quences demand�es  %(i2)d
 erreur ARPACK num�ro :  %(i3)d
 --> le calcul continue, la prochaine fois
 -->   augmenter DIM_SOUS_ESPACE =  %(i4)d
 -->   ou NMAX_ITER_SOREN =  %(i5)d
 -->   ou PREC_SOREN =  %(r1)f

"""),

51: _(u"""
 La valeur propre num�ro  %(i1)d a une partie imaginaire non nulle.
 partie r�elle     = %(r1)f
 partie imaginaire = %(r2)f

 Ce ph�nom�ne num�rique est fr�quent sur les premi�res valeurs propres
 lorsque le spectre recherch� est tr�s �tendu.
"""),

52: _(u"""
 LAIGLE: Erreur
   - Non convergence � l'it�ration max : %(i1)d
   - Convergence irr�guli�re & erreur >   %(r1)f
   - Diminuer la taille d'incr�ment.
"""),

53: _(u"""
 Erreur de programmation MULT_FRONT (NUME_DDL / PREML0) :
   * Sur connexit� des Lagrange Lambda1
"""),

54: _(u"""
     ==== Type de maille Aster / Type de maille GMSH ====
"""),

55: _(u"""
    %(i1)d  �l�ments %(k1)s d�coup�s en %(i2)d  �l�ments %(k2)s a %(i3)d noeuds
"""),

56: _(u"""
    La matrice factoris�e produit par l'op�rateur FACTOR ne peut faire l'objet
    d'un concept r�entrant car la m�thode de r�solution d�finie dans NUME_DDL
    est 'GCPC'.
"""),

57: _(u"""
    Le pr�conditionnement d'une matrice assembl�e complexe n'est pas permis.
"""),

58: _(u"""
    La masse du mod�le est nulle.
    On ne peut donc pas normer par rapport � la masse.
"""),

59: _(u"""
 MULT_FRONT: Erreur dans la renum�rotation
   - Le super noeud : %(i1)d
   - devrait �tre le fils de   %(i2)d

 Risques & conseils :
   - Vous devriez rencontrer des probl�mes lors de la factorisation.
   - Essayez un autre algorithme pour la renum�rotation : 'MD', 'MDA', ...
"""),

60: _(u"""
    La variante 'QZ_QR' de la m�thode 'QZ' ne fonctionne qu'avec une matrice %(k1)s sym�trique r�elle
    et %(k2)s sym�trique r�elle d�finie positive. Donc elle ne traite pas les probl�mes de flambement,
    les Lagrange issus de AFFE_CHAR_MECA, des matrices complexes ou non sym�triques,
    ni les probl�mes modaux quadratiques.
"""),

61: _(u"""
    M�thode 'QZ' : propri�t� spectrale non respect�e sur la valeur propre num�ro %(i1)d.
    Les relations |alpha| < ||A|| et |b�ta| < ||B|| ne sont pas v�rifi�es :
          |alpha|=%(r1)f,  ||A||=%(r2)f
          |b�ta| =%(r3)f,  ||B||=%(r4)f
"""),

62: _(u"""
    M�thode QZ dans MODE_ITER_SIMULT: On trouve un nombre de valeurs propres
    %(i1)d diff�rent du nombre de ddls physiques actifs %(i2)d !
"""),

63: _(u"""
    M�thode QZ dans MODE_ITER_SIMULT + OPTION='BANDE': On trouve un nombre de
    valeurs propres %(i1)d diff�rent du nombre de valeurs propres d�tect�es
    dans la bande %(i2)d !
"""),

64: _(u"""
    La m�thode de 'JACOBI' n'est pas utilisable pour un probl�me modal quadratique
    (pr�sence d'une matrice %(k1)s).

    Conseil :
    Utiliser la m�thode 'SORENSEN' ou 'TRI_DIAG'.
"""),

65: _(u"""
    L'option de calcul 'TOUT' (sous le mot-cl� facteur %(k1)s)
    est licite seulement avec METHODE='QZ'.
"""),

66: _(u"""
    M�thode QZ dans MODE_ITER_SIMULT : On souhaite un nombre de valeurs
    propres %(i1)d sup�rieur au nombre de valeurs propres d�tect�es %(i2)d !
"""),



68: _(u"""
    M�thode 'QZ' dans MODE_ITER_SIMULT: erreur LAPACK %(i1)d !
"""),

69: _(u"""
    Au moins une des matrices est non sym�trique.
    Pour l'instant, seules les m�thodes 'SORENSEN' et 'QZ' peuvent traiter le cas de
    matrices non sym�triques.

    Conseils :
    - Si le probl�me modal est de petite taille (quelques centaines de DDL),
      utiliser la m�thode 'QZ'.
    - Sinon, utiliser 'SORENSEN'.
"""),

70: _(u"""
    Au moins une des matrices est non sym�trique, et la matrice %(k1)s est complexe.
    Pour l'instant, ce cas n'a pas �t� d�velopp� dans le code.
"""),

71: _(u"""
    Cette fonctionnalit� requiert un solveur lin�aire permettant de
    d�tecter les �ventuelles singularit�s des matrices.

    Conseil :
    changer de solveur lin�aire : sous le mot-cl� facteur SOLVEUR,
    utiliser 'MULT_FRONT' ou 'MUMPS'.
"""),

73: _(u"""
    On a besoin d'effectuer un calcul de d�terminant.
    Pour l'instant seuls les solveurs lin�aires directs 'MULT_FRONT', 'LDLT'
    et MUMPS (� partir de la version 4.10.0) peuvent effectuer ce type de calcul.

    Conseil :
    Choisir un de ces deux solveurs (mot-cl� METHODE sous le mot-cl� facteur SOLVEUR).
    De pr�f�rence, utiliser 'MUMPS' (� partir de la version 4.10.0) qui est souvent
    le plus efficace pour des gros probl�mes et/ou des probl�mes difficiles
    (X-FEM, incompressibilit�, THM, ...).
"""),

74: _(u"""
    Vous utilisez une fonctionnalit� qui n�cessite de conna�tre le degr� de singularit� de matrices associ�es �
    des syst�mes lin�aires. Or, vous avez d�sactiv� la d�tection de singularit� avec le mot-cl� NPREC.

    Conseils :
      - Relancez le calcul avec NPREC > 0 (par exemple 8) sous le mot-cl� facteur SOLVEUR.
      - S'il vous est indispensable de d�sactiver la d�tection de singularit�, essayez d'utiliser un autre solveur lin�aire, comme MULT_FRONT par exemple.
"""),

75: _(u"""
    Le solveur modal n'a pas r�ussi � capturer tous les modes propres souhait�s
    avec le niveau de convergence requis.

    Conseils :
    Pour am�liorer la convergence des algorithmes modaux vous pouvez par exemple :
     - Diminuer le nombre de modes recherch�s � chaque fois en d�coupant votre calcul modal en plusieurs bandes
       (avec l'op�rateur MACRO_MODE_MECA, ou � la main).
       Cela am�liore aussi souvent grandement les performances des calculs.
     - Avec la m�thode de 'SORENSEN', augmenter la taille de l'espace de projection (DIM_SOUS_ESPACE/COEF_DIM_ESPACE)
       ou jouer sur les param�tres num�riques qui pilotent la convergence (PREC_SOREN et NMAX_ITER_SOREN).
     - Avec la m�thode 'QZ', diminuer NMAX_FREQ ou changer de variante (mot-cl� TYPE_QZ).
     Si vous voulez tout de m�me utiliser les modes ainsi calcul�s (� vos risques et p�rils),
     relancer le calcul en augmentant la valeur du seuil de convergence (mot-cl� SEUIL)
     ou en utilisant l'option STOP_ERREUR='NON' sous le mot-cl� facteur VERI_MODE.
"""),

76 : _(u"""
   Solveur GCPC :
   la cr�ation du pr�conditionneur 'LDLT_SP' a �chou� car on manque de m�moire.

   Conseil :
   augmenter la valeur du param�tre PCENT_PIVOT sous le mot-cl� facteur SOLVEUR.
"""),

77 : _(u"""
Conseils :
Si vous utilisez METHODE='SORENSEN' ou 'TRI_DIAG' ou 'JACOBI', vous pouvez am�liorer cette norme :
 - en augmentant la valeur de COEF_DIM_ESPACE (la valeur par d�faut est 4 pour 'TRI_DIAG' et 2 pour 'SORENSEN' et 'JACOBI'),
 - en r�duisant le nombre de valeurs propres recherch�es (%(k1)s ou taille de la BANDE).
"""),

78 : _(u"""
Conseils :
Vous pouvez am�liorer cette norme :
 - en augmentant les nombres d'it�rations des algorithmes
    (param�tres NMAX_ITER_SEPARE/AJUSTE sous le mot-cl� facteur %(k1)s
     et/ou param�tre NMAX_ITER sous le mot-cl� facteur CALC_MODE),
 - en augmentant la pr�cision requise
    (param�tres PREC_SEPARE/PREC_AJUSTE sous le mot-cl� facteur %(k1)s
     et/ou param�tre PREC sous le mot-cl� facteur CALC_MODE),
 - en changeant d'algorithme
    (mot-cl� OPTION sous le mot-cl� facteur %(k1)s
     et/ou mot-cl� OPTION sous le mot-cl� facteur CALC_MODE).
"""),

79: _(u"""
    On souhaite un nombre de valeurs propres NMAX_%(k1)s=%(i1)d
    sup�rieur au nombre de valeurs propres d�tect�es NUM=%(i2)d !
"""),

80: _(u"""
    Pour poursuivre le calcul, on impose NMAX_%(k1)s=NUM.
"""),

81: _(u"""
    Ce probl�me peut �tre d� :
    - � un mauvais tri dans les valeurs propres complexes conjugu�es.
      Contacter l'�quipe de d�veloppement.

    - � une mauvaise convergence de la m�thode.
      Regarder les param�tres permettant d'am�liorer celle-ci.

    - � une action incompl�te du SHIFT.
      En diminuant la valeur %(k1)s de l'option 'CENTRE'
      et en augmentant le nombre de valeurs propres retenues (NMAX_%(k1)s),
      on peut souvent capter tous les couples (lambda,conjugu�(lambda)) souhait�s.

    Sinon utiliser METHODE='QZ' pour les probl�mes de petites tailles (<500 ddls).
"""),

82 : _(u"""
L'option 'PLUS_GRANDE' n'est pas utilisable en pr�sence d'une matrice d'amortissement,
d'une matrice de rigidit� complexe, ou de matrices non sym�triques.
"""),

}
