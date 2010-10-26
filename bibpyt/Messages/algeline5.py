#@ MODIF algeline5 Messages  DATE 26/10/2010   AUTEUR BOITEAU O.BOITEAU 
# -*- coding: iso-8859-1 -*-

#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1: _("""
 La manipulation (produit ou somme) de matrice distribu�e est impossible
"""),

4: _("""
 erreur LAPACK (ou BLAS) au niveau de la routine  %(k1)s
  le param�tre num�ro  %(i1)d
  n'a pas une valeur coh�rente %(i2)d
"""),

5: _("""
 !! Attention, vous utilisez l'option de test FETI de l'interface.
 On va donc simuler la r�solution d'un syst�me diagonal canonique,
 pour provoquer un test d'ensemble de l'algorithme qui doit trouver
 la solution U=1 sur tous les noeuds.
 Vos r�sultats sont donc articiellement fauss�s pour les besoins de
 ce test. Pour r�aliser effectivement votre calcul, d�sactiver cette
 option (INFO_FETI(12:12)='F' au lieu de 'T') !!
"""),

6: _("""
 R�solution MULTI_FRONTALE :
 probl�me dans le traitement des r�sultats de AMDBAR
 tous les NDS du SN %(i1)d ont NV nul
"""),

10: _("""
 ! le nb de noeuds de la structure   :  %(i1)d
 ! la base utilis�e est              :  %(k1)s
 ! les caract�ristiques �l�mentaires :  %(k2)s
 ! diam�tre de la structure          :  %(r1)f
 ! type de pas                       :  %(i2)d
 ----------------------------------------------
"""),

11: _("""
 ! le profil de vitesse de la zone:  %(k1)s
 !   type de r�seau de la zone    :  %(i1)d
 ----------------------------------------------
"""),

12: _("""

"""),

13: _("""
 ! le noeud d'application           :  %(k1)s
 ! la base utilis�e est             :  %(k2)s
 ! les caract�ristiques �l�mentaires:  %(k3)s
 ! diam�tre de la structure         :  %(r1)f
 ! type de configuration            :  %(k4)s
 ! le coefficient de masse ajout�e  :  %(r2)f
 ! le profil de masse volumique     :  %(r3)f
 ----------------------------------------------

"""),

14: _("""
    pas de couplage pris en compte
 ----------------------------------------------
"""),

15: _("""
   pour le concept  %(k1)s  le mode num�ro  %(i1)d
"""),

16: _("""
  de frequence  %(r1)f
"""),

17: _("""
  de charge critique  %(r1)f
"""),

18: _("""
  a une norme d'erreur de  %(r1)f  sup�rieure au seuil admis  %(r2)f
  
  Conseil: Si vous utiliser la m�thode 'TRI_DIAG' ou 'SORENSEN' vous
  pouvez am�liorer cette norme en:
    - augmentant la valeur de COEF_DIM_ESPACE (par d�faut valeur 4 pour TRI_DIAG
      et 2 pour SORENSEN),
    - r�duire le nombre de valeurs propres recherch�es (NMAX_FREQ ou taille de
     la BANDE).
"""),

19: _("""
   pour le concept  %(k1)s  le mode num�ro  %(i1)d
"""),

20: _("""
  de fr�quence  %(r1)f
  est en dehors de l'intervalle de recherche : %(r2)f
  ,  %(r3)f
"""),

21: _("""
  de charge critique  %(r1)f
  est en dehors de l'intervalle de recherche : %(r2)f
  ,  %(r3)f
"""),

22: _("""

"""),

23: _("""
   pour le concept  %(k1)s
"""),

24: _("""
  dans l'intervalle  ( %(r1)f  ,  %(r2)f )
  il y a th�oriquement  %(i1)d frequence(s)
  et on en a calcul�  %(i2)d
"""),

25: _("""
  dans l'intervalle  ( %(r1)f  ,  %(r2)f )
  il y a th�oriquement  %(i1)d charge(s) critique(s)
  et on en a calcul�  %(i2)d
"""),

26: _("""

"""),

27: _("""
 la valeur du shift %(r1)f  est une fr�quence propre
"""),

28: _("""
 les nombres de termes des matrices RIGI et MASSE diff�rent
 celui de la matrice MASSE vaut :  %(i1)d
 celui de la matrice RIGI  vaut :  %(i2)d

"""),

29: _("""
 le nombre d'amortissements reduits est trop grand
 le nombre de modes propres vaut  %(i1)d
 et le nombre de coefficients :   %(i2)d
 on ne garde donc que les %(i3)d premiers coefficients

"""),

30: _("""
 le nombre d'amortissements r�duits est insuffisant, il en manque :  %(i1)d,
 car le nombre de modes vaut :  %(i2)d
 on rajoute  %(i3)d amortissements r�duits avec la valeur du dernier mode propre.
"""),

31: _("""
  incoherence :
   DEEQ I      =  %(i1)d
   DEEQ(2*I-1) =  %(i2)d
   DEEQ(2*I)   =  %(i3)d

"""),

32: _("""
  erreur de type DELG(IDDL) diff�rent de -1 ou -2  %(i1)d
"""),

33: _("""
 un ddl bloqu� a au moins 2 LAMBDA1 ou 2 LAMBDA2
 le ddl bloqu� est  %(i1)d

"""),

34: _("""
 incoh�rence des lagranges
 DDL %(i1)d
 LAMBDA1 %(i2)d
 LAMBDA1 %(i3)d
"""),

35: _("""
 erreur programmeur
 le LAMBDA2  %(i1)d a moins de 2 voisins
 il faut le LAMBDA1 et au moins un DDL

"""),

36: _("""
 Probl�me dans le calcul des DDL :
 NUM devrait etre �gal � n1 :
 num = %(i1)d , n1 = %(i2)d
 impression des lagranges
"""),

37: _("""
 NUME_DDL incoh�rence des lagranges
  ddl     %(i1)d
  lambda1 %(i2)d
  lambda1 %(i3)d
"""),

38: _("""
 nombre de relations lin�aires %(i1)d
"""),

39: _("""
 LAMBDA1 de R lin�aire : %(i1)d
 LAMBDA2 de R lin�aire : %(i2)d
"""),

40: _("""
 Donn�es erron�es
"""),

41: _("""
 pas de mode statique pour  le noeud :  %(k1)s  et sa composante :  %(k2)s

"""),

42: _("""
 pour les modes statiques :
 on attend un :  %(k1)s
 noeud :  %(k2)s
 cmp   :  %(k3)s

"""),

43: _("""
 champ inexistant.
 champ :  %(k1)s
 noeud :  %(k2)s
 cmp   :  %(k3)s

"""),

48: _("""
 incoh�rence de certains param�tres modaux propres � ARPACK
  num�ro d'erreur  %(i1)d

"""),

49: _("""
 nombre de valeurs propres converg�es  %(i1)d < nombre de fr�quences demand�es  %(i2)d
 erreur ARPACK num�ro :  %(i3)d
 --> le calcul continue, la prochaine fois
 -->   augmenter DIM_SOUS_ESPACE =  %(i4)d
 -->   ou NMAX_ITER_SOREN =  %(i5)d
 -->   ou PREC_SOREN =  %(r1)f

"""),

51: _("""
 la valeur propre num�ro  %(i1)d a une partie imaginaire non nulle
 re(vp) = %(r1)f
 im(vp) = %(r2)f
 --> ce ph�nom�ne num�rique est fr�quent
 --> sur les premi�res valeurs propres
 --> lorsque le spectre recherche est
 --> tres �tendu (en pulsation)

"""),

52: _("""
 LAIGLE: Erreur
   - Non convergence � l'it�ration maxi : %(i1)d
   - Convergence irr�guli�re & erreur >   %(r1)f
   - Diminuer la taille d'incr�ment.
"""),

53: _("""
 Erreur de programmation MULT_FRONT (NUME_DDL / PREML0) :
   * Sur-connexion des Lagranges Lambda1
"""),

54: _("""
     ==== Type de maille Aster / Type de maille GMSH ====
"""),

55: _("""
    %(i1)d  �l�ments %(k1)s d�coup�s en %(i2)d  �l�ments %(k2)s a %(i3)d noeuds
"""),

56: _("""
    La matrice factoris�e produit par l'op�rateur FACTOR ne peut faire l'objet
    d'un concept r�entrant car la m�thode de r�solution d�finie dans NUME_DDL
    est 'GCPC'.
"""),

57: _("""
    Le pr�conditionnement d'une matrice assembl�e complexe n'est pas permis.
"""),

58: _("""
    La masse du modele est nulle. On ne peut normer par rapport a la masse.
"""),

59: _("""
 MULT_FRONT: Erreur dans la renumerotation
   - Le Super-Noeud : %(i1)d
   - devrait etre le fils de   %(i2)d

 Risques & conseils :
   - Vous devriez rencontrer des probl�mes lors de la factorisation.
   - Essayez un autre algorithme pour la renum�rotation : 'MD', 'MDA', ...
"""),

60: _("""
    M�thode QZ dans MODE_ITER_SIMULT: La variante QR ne fonctionne qu'avec une
    matrice A sym�trique r�elle et B sym�trique r�elle d�finie positive ! 
    Donc elle n'accepte pas le flambement, les Lagranges d'AFFE_CHAR_MECA, 
    une matrice de rigidit�/de masse complexe ou non sym�trique, ainsi que les
    probl�mes modaux quadratiques.
"""),
61: _("""
    M�thode QZ dans MODE_ITER_SIMULT: propri�t� spectrale non respect�e sur la
    valeur propre n %(i1)d !. On a pas |alpha| < ||A|| et |b�ta| < ||B|| 
                     |alpha|=%(r1)f, ||A||=%(r2)f
                     | b�ta|=%(r3)f, ||B||=%(r4)f
"""),
62: _("""
    M�thode QZ dans MODE_ITER_SIMULT: On trouve un nombre de valeurs propres 
    %(i1)d diff�rent du nombre de ddls physiques actifs %(i2)d ! 
"""),
63: _("""
    M�thode QZ dans MODE_ITER_SIMULT + OPTION='BANDE': On trouve un nombre de 
    valeurs propres %(i1)d diff�rent du nombre de valeurs propres d�tect�es
    dans la bande %(i2)d ! 
"""),
64: _("""
    Probl�me modal quadratique et m�thode de JACOBI sont incompatible !
    Essayer plut�t la m�thode de SORENSEN (METHODE='SORENSEN'). 
"""),
65: _("""
    L'option de calcul 'TOUT' n'est licite qu'avec METHODE='QZ'! 
"""),
66: _("""
    M�thode QZ dans MODE_ITER_SIMULT : On souhaite un nombre de valeurs
    propres %(i1)d sup�rieur au nombre de valeurs propres d�tect�es %(i2)d ! 
"""),
67: _("""
    Attention on souhaite un nombre de valeurs propres NMAX_FREQ=%(i1)d sup�rieur
    au nombre de valeurs propres d�tect�es NCONV=%(i2)d !
    Pour poursuivre le calcul on impose NMAX_FREQ=NCONV.
    Sans doute est-ce du, soit:
     -� un mauvais tri dans les valeurs propres complexes conjugu�es.
      Contacter l'�quipe de d�veloppement.
     -� une mauvaise convergence de la m�thode. Regarder les param�tres permettant
      d'am�liorer celle-ci.
     -� une action incompl�te du shift. En diminuant la valeur de l'option CENTRE
      (FREQ) et en augmentant le nombre de valeurs propres retenues (NMAX_FREQ) on
      peut souvent capter tous les couples (lambda,conjg(lambda)) souhait�s.
      Sinon utiliser METHODE='QZ' pour les probl�mes de petites tailles (<500 ddls).
"""),
68: _("""
    M�thode QZ dans MODE_ITER_SIMULT: erreur LAPACK %(i1)d !
"""),
69: _("""
    Matrices de raideur, de masse et/ou d'amortissement non sym�trique(s) dans
    MODE_ITER_SIMULT. Pour l'instant, seules les m�thodes QZ et SORENSEN 
    acceptent ce type de matrice.
    La m�thode QZ est � r�server aux petits probl�mes modaux (centaines de ddls)
    dont on souhaite connaitre une grosse partie du spectre.
"""),
70: _("""
    Matrices de  raideur, de masse et/ou d'amortissement non sym�trique(s) dans
    MODE_ITER_SIMULT avec,une matrice de raideur complexe. 
    Pour l'instant, ce cas n'a pas �t� pris en compte.
"""),
71: _("""
    Cette fonctionnalit� requiert un solveur lin�aire permettant de d�tecter les
    �ventuelles singularit�s des matrices.
    Conseil:
    ========
    Changer de solveur lin�aire (mot-cl� SOLVEUR), utiliser MULT_FRONT ou MUMPS.
"""),
72: _("""
    Les matrices utilis�es ne s'appuient pas sur des donn�es issues d'un maillage.
    Dans ce cas on doit utiliser, soit le solveur lin�aire LDLT, soit celui MUMPS.
    On a donc chang� le param�trage pour vous et selectionn� le solveur lin�aire
    MUMPS (avec son param�trage usuel par d�faut).
    Conseil:
    ========
    La prochaine fois, dans une telle situation (NUME_DDL_GENE...), param�trer
    explicitement SOLVEUR/METHODE='MUMPS'.
"""),
73: _("""
    On a besoin d'effectuer un calcul de d�terminant. Pour l'instant seuls les
    solveurs lin�aires directs 'MULT_FRONT' et 'LDLT' l'effectuent. Veuillez chan
    ger le param�trage du mot-cl� SOLVEUR/METHODE pour prendre en compte un de
    ces deux solveurs. De pr�f�rence utilisez 'MULT_FRONT' qui est plus efficace
    que 'LDLT'.
"""),
74: _("""
    Lors d'un calcul modal (MODE_ITER_SIMULT/INV, CRIT_FLAMB...) utilisant le
    solveur lin�aire MUMPS (SOLVEUR/METHODE='MUMPS'), il ne faut pas d�brancher
    la d�tection de singularit�.
    Conseil:
    ========
    Relancer le calcul avec SOLVEUR/NPREC>0 (par exemple 8).
"""),
}
