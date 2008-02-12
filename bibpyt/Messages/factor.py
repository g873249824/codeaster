#@ MODIF factor Messages  DATE 11/02/2008   AUTEUR PELLET J.PELLET 
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

def _(x) : return x

cata_msg={


#-----------------------------------------------------------------------------------------------
10: _("""
Matrice non factorisable :
  pivot presque nul � la ligne : %(i1)d
  nombre de d�cimales perdues  : %(i2)d
"""),

#-----------------------------------------------------------------------------------------------
11: _("""
Matrice non factorisable :
  pivot vraiment nul � la ligne : %(i1)d
"""),

#-----------------------------------------------------------------------------------------------
20: _("""
  -> Matrice non factorisable :
     Le pivot est presque nul � la ligne %(i1)d pour le noeud %(k1)s et
     la composante %(k2)s.
     Pour information, le nombre de d�cimales perdues est de %(i2)d.

  -> Conseil & Risque :
     Il s'agit peut etre d'un mouvement de corps rigide mal bloqu�.
     V�rifiez les conditions aux limites.
     Si vous faites du contact, il ne faut pas que la
     structure ne "tienne" que par le contact.
"""),

#-----------------------------------------------------------------------------------------------
21: _("""
Matrice non factorisable :
  pivot vraiment nul � la ligne : %(i1)d
  pour le noeud %(k1)s et la composante %(k2)s
"""),


#-----------------------------------------------------------------------------------------------
30: _("""
Matrice non factorisable :
  pivot presque nul � la ligne : %(i1)d
  nombre de d�cimales perdues  : %(i2)d
  Il s'agit sans doute d'une relation lin�aire entre ddls surabondante.
  La liste des noeuds concern�s par cette relation est imprim�e ci-dessus dans le fichier MESSAGE.
"""),

#-----------------------------------------------------------------------------------------------
31: _("""
Matrice non factorisable :
  pivot vraiment nul � la ligne : %(i1)d
  Il s'agit sans doute d'une relation lin�aire entre ddls surabondante.
  La liste des noeuds concern�s par cette relation est imprim�e ci-dessus dans le fichier MESSAGE.
"""),


#-----------------------------------------------------------------------------------------------
40: _("""
Matrice non factorisable :
  pivot presque nul � la ligne : %(i1)d
  nombre de d�cimales perdues  : %(i2)d
  Il s'agit sans doute d'une relation de blocage surabondante.
  blocage concern� : %(k4)s
"""),

#-----------------------------------------------------------------------------------------------
41: _("""
Matrice non factorisable :
  pivot vraiment nul � la ligne : %(i1)d
  Il s'agit sans doute d'une relation de blocage surabondante.
  blocage concern� : %(k4)s
"""),

#-----------------------------------------------------------------------------------------------
42: _("""
Matrice non factorisable :
  Le solveur MUMPS consid�re la matrice comme num�riquement singuli�re.
  (Mais il n'en dit pas plus)

Conseil :
  Il s'agit peut-etre d'un manque de conditions aux limites,
  ou au contraire, de redondances entre de trop nombreuses conditions.
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
51: _("""
Solveur MUMPS interdit ici.
Causes possibles :
  - frottement p�nalis� ou lagrangien (si MUMPS distribu� parall�le)
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
  Pour cela, il faut diminuer la m�moire donn�e � JEVEUX (ASTK : case "dont Aster (Mo)").
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
58: _("""
Solveur MUMPS :
  La matrice est num�riquement singuli�re.
Solution :
  Peut �tre un probl�me de mod�lisation (blocages redondants...)
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
  On peut essayer de corriger l'affectation de XMPSK%ICNTL(10) dans AMUMPR/C.F.
  Contactez l'assistance.
"""),

#-----------------------------------------------------------------------------------------------
63: _("""
Information Solveur MUMPS :
  D�s�quilibrage de charge maximum sup�rieur � %(r1)g %% sur au moins une des 6 �tapes profil�es.
Conseils: Pour optimiser l'�quilibrage de votre calcul, vous pouvez essayer
        - d'enlever du mod�le les mailles qui ne participent pas au calcul,
        - utiliser l'option 'DISTRIBUE_SD' au lieu de 'DISTRIBUE_MAILLE' ou 'CENTRALISE',
        - diminuer le nombre de processeurs utilis�s.
"""),

#-----------------------------------------------------------------------------------------------
}
