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

 <INFO> Fichier d'informations de MACR_RECAL

"""),

 2 : _(u"""Impossible d'importer le module as_profil ! V�rifier la variable
d'environnement ASTER_ROOT ou mettez � jour ASTK.
"""),

 3 : _(u"""Le logiciel GNUPLOT ou le module python Gnuplot n'est pas disponible.
On d�sactive l'affichage des courbes par Gnuplot.
"""),

 4 : _(u"""Il n'y a pas de fichier .export dans le r�pertoire de travail !
"""),

 5 : _(u"""Il y a plus d'un fichier .export dans le r�pertoire de travail !
"""),

 6 : _(u"""Pour les calculs DISTRIBUES en mode INTERACTIF, il faut sp�cifier une valeur pour mem_aster
(menu Option de ASTK) pour limiter la m�moire allou�e au calcul ma�tre.
"""),

 7 : _(u"""Pour pouvoir lancer les calculs esclaves en MPI, le calcul ma�tre doit �tre lanc� 
en MPI sur un processeur."""),

 8 : _(u"""V�rifier les valeurs des param�tres mem_aster et memjeveux.
"""),

# 9 : _(u""" """),

10 : _(u"""Pour l'algorithme %(k1)s, on ne peut tracer qu'� la derni�re it�ration.
"""),

11 : _(u"""Pour l'algorithme %(k1)s, on ne tient pas compte des bornes sur les param�tres.
"""),

12 : _(u"""Recalage :
   %(k1)s
"""),

13 : _(u"""Lancement de l'optimisation avec la m�thode : %(k1)s.
"""),

14 : _(u"""Les d�riv�es sont calcul�es par Aster.
"""),

15 : _(u"""Les d�riv�es sont calcul�es par l'algorithme.
"""),

16 : _(u"""
--> Calcul du gradient par diff�rences finies <--

"""),

17 : _(u"""Trac� des graphiques
"""),

18 : _(u"""Erreur dans l'algorithme de bornes de MACR_RECAL.
"""),

19 : _(u"""Erreur dans le test de convergence de MACR_RECAL.
"""),

23 : _(u"""Impossible d'importer le module de lecture des tables !
"""),

24 : _(u"""Impossible de r�cup�rer les r�sultats de calcul esclave (lecture des tables) !
Message d'erreur :
   %(k1)s
"""),

25 : _(u"""
Calcul de F avec les param�tres :
     %(k1)s
"""),

26 : _(u"""
Calcul de F et G avec les param�tres :
     %(k1)s
"""),

27 : _(u"""
Calcul de G avec les param�tres :
   %(k1)s
"""),

28 : _(u"""
--> Mode de lancement BATCH impossible sur : %(k1)s, on bascule en INTERACTIF <--

"""),

29 : _(u"""
--> Mode de lancement des calculs esclaves : %(k1)s <--

"""),

30 : _(u"""
Informations de convergence :
======================================================================
"""),

31 : _(u"""It�ration %(i1)d :

"""),

32 : _(u"""
=> Param�tres :
     %(k1)s

"""),

33 : _(u"""=> Fonctionnelle                        = %(r1)f
"""),

34 : _(u"""=> R�sidu                               = %(r1)f
"""),

35 : _(u"""=> Norme de l'erreur                    = %(r1)f
"""),

36 : _(u"""=> Erreur                               = %(r1)f
"""),

37 : _(u"""=> Variation des param�tres (norme L2)  = %(r1)f
"""),

38 : _(u"""=> Variation de la fonctionnelle        = %(r1)f
"""),

39 : _(u"""=> Nombre d'�valuation de la fonction   = %(k1)s
"""),

#40 : _(u""" """),

41 : _(u"""Trac� des courbes dans le fichier : %(k1)s
"""),

42 : _(u"""Probl�me lors de l'affichage des courbes. On ignore et on continue.
Erreur :
   %(k1)s
"""),

43 : _(u"""Erreur :
   %(k1)s
"""),

44 : _(u"""Probl�me de division par z�ro dans la normalisation de la fonctionnelle.
Une des valeurs de la fonctionnelle initiale est nulle ou inf�rieure � la pr�cision machine : %(r1).2f
"""),

45 : _(u"""Probl�me de division par z�ro dans le calcul de la matrice de sensibilit�.
Le param�tre %(k1)s est nul ou plus petit que la pr�cision machine.
"""),

46 : _(u"""Le param�tre %(k1)s est en but�e sur un bord du domaine admissible.
"""),

47 : _(u"""Les param�tres %(k1)s sont en but�e sur un bord du domaine admissible.
"""),

48 : _(u"""Probl�me lors de l'interpolation du calcul d�riv� sur les donn�es exp�rimentale !
Valeur � interpoler              :  %(k1)s
Domaine couvert par l'exp�rience : [%(k2)s : %(k3)s]
"""),

50 : _(u"""
--> Crit�re d'arr�t sur le r�sidu atteint, la valeur du r�sidu est : %(r1)f <--
"""),

51 : _(u"""
--> Crit�re d'arr�t TOLE_PARA atteint, la variation des param�tres est : %(r1)f <--
"""),

52 : _(u"""
--> Crit�re d'arr�t TOLE_FONC atteint, la variation de la fonctionnelle est : %(r1)f <--
"""),

53 : _(u"""
--> Arr�t par manque de temps CPU <--
"""),

54 : _(u"""
--> Le nombre maximum d'�valuations de la fonction (ITER_FONC_MAXI) a �t� atteint <--
"""),

55 : _(u"""
--> Le nombre maximum d'it�rations de l'algorithme (ITER_MAXI) a �t� atteint <--
"""),

56 : _(u"""
======================================================================
                       CONVERGENCE ATTEINTE

"""),

57 : _(u"""
======================================================================
                      CONVERGENCE NON ATTEINTE

"""),

58 : _(u"""
                 ATTENTION : L'OPTIMUM EST ATTEINT AVEC
                 DES PARAMETRES EN BUT�E SUR LE BORD
                     DU DOMAINE ADMISSIBLE
"""),

60 : _(u"""
Valeurs propres du Hessien:
%(k1)s
"""),

61 : _(u"""
Vecteurs propres associ�s:
%(k1)s
"""),

62 : _(u"""

              --------

"""),

63 : _(u"""
On peut en d�duire que :

"""),

64 : _(u"""
Les combinaisons suivantes de param�tres sont pr�pond�rantes pour votre calcul :

"""),

65 : _(u"""%(k1)s
      associ�e � la valeur propre %(k2)s

"""),

66 : _(u"""
Les combinaisons suivantes de param�tres sont insensibles pour votre calcul :

"""),

67 : _(u"""
Calcul avec les param�tres suivants (point courant) :
     %(k1)s
"""),

68 : _(u"""
Calcul avec les param�tres suivants (perturbation du param�tre %(k2)s pour le gradient) :
     %(k1)s
"""),


69 : _(u"""
Information : les calculs esclaves seront lanc�s en BATCH avec les param�tres suivants :
     Temps          : %(k1)s sec
     M�moire totale : %(k2)s Mo
     dont Aster     : %(k3)s Mo
     Classe         : %(k4)s

"""),

72 : _(u"""
Fonctionnelle au point X0:
     %(k1)s
"""),

73 : _(u"""
Gradient au point X0:
"""),

74 : _(u"""
Calcul num�ro:  %(k1)s - Diagnostic: %(k2)s
"""),

75 : _(u"""
                                    ----------------
                                      Informations

    Lors du calcul du gradient par diff�rences finies, un param�tre perturb� sort de l'intervalle de validit� :
        Param�tre                   : %(k1)s
        Param�tre perturb�e         : %(k2)s
        Valeur minimale autoris�e   : %(k3)s
        Valeur maximale autoris�e   : %(k4)s

    --> On continue avec ce param�tre, mais l'�tude esclave peut avoir des soucis.

    Pour information, voici le param�tre de perturbation (mot-cl� PARA_DIFF_FINI), v�rifier qu'il est suffisamment petit
    pour un calcul de gradient par diff�rences finies :
        Param�tre de perturbation   : %(k5)s

                                    ----------------

"""),


76 : _(u"""
Le param�tre de perturbation (mot-cl� PARA_DIFF_FINI) a pour valeur : %(k1)s

V�rifier qu'il est suffisamment petit pour un calcul de gradient par diff�rences finies

--> On continue avec ce param�tre mais le calcul du gradient pourrait �tre faux.

"""),

#77 : _(u""" """),

#78 : _(u""" """),

79 : _(u"""

======================================================================
"""),

80 : _(u"""======================================================================


"""),

81 : _(u"""

R�pertoire contenant les ex�cutions Aster :
   %(k1)s

"""),

82 : _(u"""Impossible de cr�er le r�pertoire temporaire : %(k1)s
"""),

83 : _(u"""
======================================================================

Erreur! Le calcul esclave '%(k1)s' ne s'est pas arr�t� correctement!
Les fichiers output et error du job sont recopi�s dans l'output du
ma�tre juste au dessus de ce message.

L'output du job est �galement dans : %(k2)s

======================================================================
"""),

84 : _(u"""
Erreur! Au moins un calcul esclave ne s'est pas arr�t� correctement! V�rifier le r�pertoire : %(k1)s
"""),

85 : _(u""" Erreur dans le calcul esclave:
   %(k1)s
"""),

86 : _(u"""
Erreur! Le calcul esclave '%(k1)s' n'a pas pu d�marrer !
   Diagnostic : %(k2)s

Il s'agit vraisemblablement d'un probl�me de configuration du serveur de calcul ou de ressources disponibles.
Mettre UNITE_SUIVI et INFO=2 permettra d'avoir des messages suppl�mentaires dans l'output du ma�tre.
"""),

#87 : _(u""" """),

#88 : _(u""" """),

#89 : _(u""" """),

#90 : _(u""" """),

#91 : _(u""" """),

#92 : _(u""" """),

#93 : _(u""" """),

#94 : _(u""" """),

#95 : _(u""" """),

#96 : _(u""" """),

#97 : _(u""" """),

#98 : _(u""" """),

99 : _(u"""Impossible de d�terminer l'emplacement de Code_Aster !
Fixer le chemin avec la variable d'environnement ASTER_ROOT.
"""),

}
