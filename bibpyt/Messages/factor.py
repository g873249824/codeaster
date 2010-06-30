#@ MODIF factor Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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


#-----------------------------------------------------------------------------------------------
10: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
  - pivot presque nul � la ligne : %(i1)d
  - nombre de d�cimales perdues  : %(i2)d
"""),

#-----------------------------------------------------------------------------------------------
11: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
  On sait en plus que:
   - pivot vraiment nul � la ligne : %(i1)d 
"""),

#-----------------------------------------------------------------------------------------------
13: _("""
Solveur FETI :
  Le solveur FETI est impossible dans ce contexte.
Solution :
  Il faut changer de solveur.
"""),


#-----------------------------------------------------------------------------------------------
20: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
     Le pivot est presque nul � la ligne %(i1)d pour le noeud %(k1)s et
     la composante %(k2)s.
     On sait en plus que le nombre de d�cimales perdues est de %(i2)d. 

  -> Conseil & Risque :
     Il s'agit peut etre d'un mouvement de corps rigide mal bloqu�.
     V�rifiez les conditions aux limites.
     Si vous faites du contact, il ne faut pas que la
     structure ne "tienne" que par le contact.
"""),

#-----------------------------------------------------------------------------------------------
21: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
  On sait en plus que:
    - pivot est vraiment nul � la ligne %(i1)d
    - pour le noeud %(k1)s et la composante %(k2)s
"""),

#-----------------------------------------------------------------------------------------------
22: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
     Le pivot est presque nul � la ligne %(i1)d pour le noeud %(k1)s et
     la composante %(k2)s.
     On sait en plus que le nombre de d�cimales perdues est de %(i2)d.
     
  -> Conseil & Risque :
     Il s'agit peut etre d'un mouvement de corps rigide mal bloqu�.
     V�rifiez les conditions aux limites.
     Si vous faites du contact, il ne faut pas que la
     structure ne "tienne" que par le contact.

     il se peut aussi que ce ph�nom�ne soit tout � fait normal avec X-FEM si la fissure passe
     tr�s pr�s d'un noeud.
     Si le nombre de d�cimal n'est pas trop grand (maxi 10 d�cimales)
     vous pouvez relancer le calcul en augmentant le nombre de d�cimales perdues autoris� :
     mot-cl� NPREC dans STAT_NON_LINE/SOLVEUR.
     Sinon, contactez l'�quipe de d�veloppement.

"""),

#-----------------------------------------------------------------------------------------------
30: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
  - pivot presque nul � la ligne : %(i1)d
  - nombre de d�cimales perdues  : %(i2)d
  Il s'agit sans doute d'une relation lin�aire entre ddls surabondante.
  La liste des noeuds concern�s par cette relation est imprim�e ci-dessus dans le fichier MESSAGE.

Risques & conseils :
  Il faut v�rifier de plus pr�s les conditions aux limites cin�matiques.
  En particulier, il se peut que la relation lin�aire surabondante provienne des conditions de contact.
  Peut-etre devriez vous exclure certains noeuds des conditions de contact (mots cl�s SANS_NOEUD et SANS_GROUP_NO)
"""),

#-----------------------------------------------------------------------------------------------
31: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
  Si le solveur lin�aire est LDLT ou MULT_FRONT on sait en plus que:
   - pivot vraiment nul � la ligne : %(i1)d
  Il s'agit sans doute d'une relation lin�aire entre ddls surabondante.
  La liste des noeuds concern�s par cette relation est imprim�e ci-dessus dans le fichier MESSAGE.

Risques & conseils :
  Il faut v�rifier de plus pr�s les conditions aux limites cin�matiques.
  En particulier, il se peut que la relation lin�aire surabondante provienne des conditions de contact.
  Peut-etre devriez vous exclure certains noeuds des conditions de contact (mots cl�s SANS_NOEUD et SANS_GROUP_NO)
"""),


#-----------------------------------------------------------------------------------------------
40: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
  - pivot presque nul � la ligne : %(i1)d
  - nombre de d�cimales perdues  : %(i2)d
  Il s'agit sans doute d'une relation de blocage surabondante.
  blocage concern� : %(k4)s
"""),

#-----------------------------------------------------------------------------------------------
41: _("""
(Solveur lin�aire LDLT ou MULT_FRONT) Matrice non factorisable !
  On sait en plus que:
  - pivot vraiment nul � la ligne : %(i1)d
  Il s'agit sans doute d'une relation de blocage surabondante.
  blocage concern� : %(k4)s
"""),

#-----------------------------------------------------------------------------------------------
42: _("""
Matrice non factorisable :
  Le solveur MUMPS consid�re la matrice comme singuli�re (en structure ou num�riquement).

Conseil :
  Il peut s'agir d'une erreur de programmation ou d'un probl�me de mise en donn�es (blocage
  absent ou surabondant).
"""),
#-----------------------------------------------------------------------------------------------
50: _("""
 Solveur MUMPS :
   -> Vous avez demand� comme renum�roteur RENUM = '%(k1)s', or MUMPS en a
      utilis� un autre.
   -> Risque & Conseil :
      Il se peut que votre version de MUMPS n'ait pas �t� compil�e avec
      le support de ce renum�roteur. Dans le doute, RENUM='AUTO' permet
      de laisser MUMPS faire le meilleur choix.
 """),

#-----------------------------------------------------------------------------------------------
52: _("""
Solveurs LDLT et MULT_FRONT seuls permis ici.
Causes possibles :
  - STAT_NON_LINE / FLAMBEMENT
"""),

#-----------------------------------------------------------------------------------------------
53: _("""
Solveur MUMPS :
  Mumps manque de m�moire lors de la factorisation de la matrice.
Solution :
  Il faut augmenter la valeur du mot cl�  SOLVEUR/PCENT_PIVOT.
Remarque : on a le droit de d�passer la valeur 100.
"""),

#-----------------------------------------------------------------------------------------------
54: _("""
Solveur MUMPS :
  Le solveur Mumps manque de m�moire lors de la factorisation de la matrice.

Solution :
  Il faut augmenter la m�moire accessible � Mumps (et autres programmes hors fortran d'Aster).
  Pour cela, il faut diminuer la m�moire donn�e � JEVEUX (ASTK : case "dont Aster (Mo)") ou bien
  augmenter la m�moire totale (ASTK : case "M�moire totale (Mo))".
"""),

#-----------------------------------------------------------------------------------------------
55: _("""
Solveur MUMPS :
  Probl�me ou alarme dans le solveur MUMPS.
  Le code retour de mumps (INFOG(1)) est : %(i1)d
Solution :
  Consulter le manuel d'utilisation de Mumps.
  Pr�venir l'�quipe de d�veloppement de Code_Aster.
"""),

#-----------------------------------------------------------------------------------------------
56: _("""
Solveur MUMPS :
  Il ne faut pas utiliser TYPE_RESOL = '%(k1)s'
  Pour une matrice non-sym�trique.
Solution :
  Il faut utiliser TYPE_RESOL = 'NONSYM' (ou 'AUTO').
"""),

#-----------------------------------------------------------------------------------------------
57: _("""
Solveur MUMPS :
  La solution du syst�me lin�aire est trop impr�cise :
  Erreur calcul�e   : %(r1)g
  Erreur acceptable : %(r2)g   (RESI_RELA)
Solution :
  On peut augmenter la valeur du mot cl� SOLVEUR/RESI_RELA.
"""),

#-----------------------------------------------------------------------------------------------
59: _("""
Solveur MUMPS :
  La matrice est d�j� factoris�e. On ne fait rien.
Solution :
  Il y a sans doute une erreur de programmation.
  Contactez l'assistance.
"""),

#-----------------------------------------------------------------------------------------------
60: _("""
Solveur MUMPS :
  Limite atteinte : le solveur Mumps est utilis� par plus de 5 matrices simultan�ment.
Solution :
  Il faut corriger le programme (PARAMETER (NMXINS=5) dans amumps.f)
  Contactez l'assistance.
"""),

#-----------------------------------------------------------------------------------------------
61: _("""
Erreur Programmeur lors de la r�solution d'un syst�me lin�aire :
 La num�rotation des inconnues est incoh�rente entre la matrice et le second membre.
 Matrice       : %(k1)s
 Second membre : %(k2)s

 Si solveur : 'Feti' : num�ro du sous-domaine (ou domaine global) : %(i1)d
"""),

#-----------------------------------------------------------------------------------------------
62: _("""
Alarme Solveur MUMPS :
  La proc�dure de raffinement it�ratif aurait besoin de plus que les %(i1)d d'it�rations
  impos�es en dur dans l'appel MUMPS par Code_Aster.
Solution :
  On peut essayer la valeur du mot-cl� POSTTRAITEMENTS='FORCE'.
"""),

#-----------------------------------------------------------------------------------------------

64: _("""
Solveur MUMPS :
  Le solveur Mumps manque de m�moire lors de la phase d'analyse de la matrice.

Solution :
  Il faut augmenter la m�moire accessible � Mumps (et autres programmes hors fortran d'Aster).
  Pour cela, il faut diminuer la m�moire donn�e � JEVEUX (ASTK : case "dont Aster (Mo)") ou bien
  augmenter la m�moire totale (ASTK : case "M�moire totale (Mo))".
"""),

#-----------------------------------------------------------------------------------------------

65: _("""
Solveur MUMPS :
  Mumps ne peut pas factoriser la matrice � cause d'un d�passement d'entiers.

Solution :
  Si vous utilisez la version s�quentielle, alors il vous faut passer � la version parall�le.
  Si vous utilisez d�j� la version parall�le, alors il faut augmenter le nombre de processeurs
  allou�s au calcul.
"""),

#-----------------------------------------------------------------------------------------------

66: _("""
Solveur MUMPS :
  Echec de la factorisation OUT-OF-CORE de MUMPS.
  Consulter les  messages d�livr�s  par MUMPS.
Conseil: Augmenter  le nombre de processeurs utilis�s.
"""),
#-----------------------------------------------------------------------------------------------

67: _("""
Erreur d'utilisation (commande RESOUDRE) :
  La matrice et le second membre fournis � la commande RESOUDRE
  ne sont pas de meme dimension (nombre de ddls).
Conseil: V�rifier la coh�rence des arguments MATR et CHAM_NO.
"""),
#-----------------------------------------------------------------------------------------------

68: _("""
Erreur d'utilisation (commande RESOUDRE) :
  La matrice et le second membre fournis � la commande RESOUDRE
  ne sont pas du meme type (r�el/complex).
Conseil: V�rifier la coh�rence des arguments MATR et CHAM_NO.
"""),

#-----------------------------------------------------------------------------------------------

70: _("""
Solveur MUMPS :
  Vous avez activ� l'option IMPR='OUI_SOLVE' en surchargeant AMUMPS.F. La r�solu
  tion du syst�me lin�aire en cours va donc s'effectuer normalement mais en plus
  sa matrice et son second membre vont �tre �crits dans le fichier d'unit� logique
  %(i1)d. Vous pouvez le r�cup�rer (sur le proc 0) via ASTK.
"""),

#-----------------------------------------------------------------------------------------------

71: _("""
Solveur MUMPS :
  Vous avez activ� l'option IMPR='OUI_NOSOLVE' en surchargeant AMUMPS.F. La r�solu
  tion du syst�me lin�aire en cours ne va donc pas s'effectuer mais sa matrice et
  son second membre vont �tre �crits dans le fichier d'unit� logique %(i1)d.
  Apr�s cette �criture, l'execution Aster s'arr�te en ERREUR_FATALE pour vous
  permettre de r�cuperer plus rapidement votre fichier.
  Vous pouvez le r�cup�rer (sur le proc 0) via ASTK.
"""),
#-----------------------------------------------------------------------------------------------

72: _("""
Solveur MUMPS :
  Vous utilisez une version de MUMPS ant�rieure � la 4.7.3: la %(k1)s.
  Celle-ci n'est plus support�e pour le couplage Code_Aster/MUMPS.
Solution:
  T�l�charger et installer une version de MUMPS plus r�cente.
"""),
#-----------------------------------------------------------------------------------------------

73: _("""
Solveur MUMPS :
  Lors de la factorisation num�rique, le pourcentage de pivots, %(r1)d %%, a d�pass� le 
  pourcentage pr�vu par le param�tre SOLVEUR/PCENT_PIVOT= %(r2)d %%.
  Cela peut engendrer un r�sultat de mauvaise qualit�. V�rifiez bien la qualit� de celui-ci
  en fin de r�solution via la mot-cl� RESI_RELA.
Solution:
  Pour am�liorer la qualit� de la solution vous pouvez activez les options de pr� et post-
  traitements (PRETRAITEMENTS='AUTO' et POSTTRAITEMENTS='FORCE' ou 'AUTO'), durcir le crit�re
  de qualit� RESI_RELA ou, si vous avez beaucoup de Lagranges (>10%% de la taille du pb),
  d�sactivez l'option ELIM_LAGR2 (ELIM_LAGR2='NON').
  Sinon, contactez l'�quipe de d�veloppement.
"""),

#-----------------------------------------------------------------------------------------------
74: _("""
Solveur MUMPS :
  Vous utilisez une version de MUMPS ant�rieure � la 4.8.4: la %(k1)s.
  Celle-ci ne permet pas la d�tection de singularit�. On d�sactive cette fonctionnalit� avec
  une valeur SOLVEUR/NPREC n�gative.
Attention:
  Cette d�sactivation peut nuire � certains type de calculs (modal, option CRIT_FLAMB...).
"""),

#-----------------------------------------------------------------------------------------------
75: _("""
(solveur lin�aire MUMPS) Matrice non factorisable !
  - pivot presque nul � la ligne : %(i1)d
"""),

#-----------------------------------------------------------------------------------------------
76: _("""
(solveur lin�aire MUMPS) Matrice non factorisable !

 -> Conseil & Risque :
   Il s'agit peut etre d'un mouvement de corps rigide mal bloqu�.
   V�rifiez les conditions aux limites.
   Si vous faites du contact, il ne faut pas que la
   structure ne "tienne" que par le contact.
"""),

#-----------------------------------------------------------------------------------------------
77: _("""
(solveur lin�aire MUMPS) Matrice non factorisable !
     Le pivot est presque nul � la ligne %(i1)d pour le noeud %(k1)s et
     la composante %(k2)s.

  -> Conseil & Risque :
     Il s'agit peut etre d'un mouvement de corps rigide mal bloqu�.
     V�rifiez les conditions aux limites.
     Si vous faites du contact, il ne faut pas que la
     structure ne "tienne" que par le contact.
"""),

#-----------------------------------------------------------------------------------------------
78: _("""
(solveur lin�aire MUMPS) Matrice non factorisable !
  - pivot presque nul � la ligne : %(i1)d
  Il s'agit sans doute d'une relation lin�aire entre ddls surabondante.
  La liste des noeuds concern�s par cette relation est imprim�e ci-dessus dans le fichier MESSAGE.

Risques & conseils :
  Il faut v�rifier de plus pr�s les conditions aux limites cin�matiques.
  En particulier, il se peut que la relation lin�aire surabondante provienne des conditions de contact.
  Peut-etre devriez vous exclure certains noeuds des conditions de contact (mots cl�s SANS_NOEUD et SANS_GROUP_NO)
"""),

#-----------------------------------------------------------------------------------------------
79: _("""
(solveur lin�aire MUMPS) Matrice non factorisable !
  - pivot presque nul � la ligne : %(i1)d
  Il s'agit sans doute d'une relation de blocage surabondante.
  blocage concern� : %(k4)s
"""),
}
