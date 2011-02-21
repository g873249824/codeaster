#@ MODIF mecanonline6 Messages  DATE 21/02/2011   AUTEUR ABBAS M.ABBAS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg = {

1 : _("""
 Instant de calcul: %(r1)19.12e 
"""),

2 : _("""
 Post-traitement: calcul d'un mode de flambement
"""),

3 : _("""
 Post-traitement: calcul d'un mode vibratoire
"""),

10 : _("""
  Le mode vibratoire de num�ro d'ordre %(i1)d a pour fr�quence %(r1)19.12e
"""),

11 : _("""
  Le mode de flambement de num�ro d'ordre %(i1)d a pour charge critique %(r1)19.12e
"""),

12 : _("""
  Temps CPU consomm� dans ce pas de temps: %(k1)s.
    * Temps par it�ration de Newton     : %(k2)s ( %(i1)d it�rations )
    * Temps total archivage             : %(k3)s
    * Temps total cr�ation num�rotation : %(k4)s ( %(i2)d cr�ations )
    * Temps total factorisation matrice : %(k5)s ( %(i3)d factorisations )
    * Temps total int�gration LDC       : %(k6)s ( %(i4)d int�grations )
    * Temps total r�solution K.U=F      : %(k7)s ( %(i5)d r�solutions )
"""),

13 : _("""
    * Temps total r�solution contact    : %(k1)s ( %(i1)d it�rations )
"""),

14 : _("""
  Statistiques de r�solution du contact discret dans ce pas de temps.
    * Nombre d'it�rations de contact          : %(i1)d 
    * Nombre de r�actualisations g�om�triques : %(i2)d 
    * Temps total consomm� par l'appariement  : %(k1)s
    * Temps total consomm� par la r�solution  : %(k2)s
    * Nombre final de liaisons de contact     : %(i3)d 
"""),

15 : _("""
    * Nombre final de liaisons de frottement  : %(i1)d 
"""),

16 : _("""
  Statistiques de r�solution du contact continu dans ce pas de temps.
    * Nombre d'it�rations de contact                       : %(i1)d 
    * Nombre d'it�rations de frottement                    : %(i2)d 
    * Nombre d'it�rations de r�actualisations g�om�triques : %(i3)d 
"""),

17 : _("""
  Statistiques sur tout le transitoire.
    * Nombre de pas de temps                      : %(i1)d 
    * Nombre d'it�rations de Newton               : %(i2)d 
    * Nombre de cr�ation num�rotation             : %(i3)d
    * Nombre de factorisation matrice             : %(i4)d 
    * Nombre d'int�gration LDC                    : %(i5)d
    * Nombre de r�solution K.U=F                  : %(i6)d
"""),

18 : _("""
    * Nombre d'it�rations de recherche lin�aire   : %(i1)d 
"""),

19 : _("""
    * Nombre d'it�rations du solveur FETI         : %(i1)d 
"""),

20 : _("""
    * Nombre d'it�rations de contact              : %(i1)d 
    * Nombre de r�actualisations g�om�triques     : %(i2)d 
"""),

21 : _("""
    * Nombre d'it�rations de frottement           : %(i1)d 
"""),

22 : _("""
    * Temps total cr�ation num�rotation           : %(k1)s 
    * Temps total factorisation matrice           : %(k2)s 
    * Temps total int�gration LDC                 : %(k3)s
    * Temps total r�solution K.U=F                : %(k4)s 
"""),

23 : _("""
    * Temps total pour le contact (appariement)   : %(k1)s
    * Temps total pour le contact (r�solution)    : %(k2)s
"""),

24 : _("""
  Subdivision du pas de temps en %(i1)d sous-pas
"""),

25 : _("""
  Crit�re(s) de convergence atteint(s)
"""),

26 : _("""
  Pas de crit�re(s) de convergence
"""),

27 : _("""
  Convergence forc�e (mode ARRET='NON')
"""),

28 : _("""
  <*> Attention ! Convergence atteinte avec RESI_GLOB_MAXI valant %(r1)19.12e pour cause de chargement presque nul.
"""),

29 : _("""
 <Erreur> Echec dans l'int�gration de la loi de comportement
"""),

30 : _("""
 <Erreur> Echec dans le pilotage
"""),

31 : _("""
 <Erreur> Le nombre maximum d'it�rations est atteint
"""),

32 : _("""
 <Erreur> Echec dans le traitement du contact discret
"""),

33 : _("""
 <Erreur> La matrice de contact est singuli�re
"""),

34 : _("""
 <Erreur> La matrice du syst�me est singuli�re
"""),

35 : _("""
 V�rifiez votre mod�le ou essayez de subdiviser le pas de temps
"""),

36 : _("""
    Le r�sidu de type <%(k1)s> vaut %(r1)19.12e au noeud et degr� de libert� <%(k2)s> 
"""),

37 : _("""
  Le pilotage a �chou�. On recommence en utilisant la solution rejet�e initialement.
 """),

}
