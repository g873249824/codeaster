#@ MODIF factor Messages  DATE 09/10/2007   AUTEUR COURTOIS M.COURTOIS 
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

def _(x) : return x

cata_msg = {

10 : _("""
Matrice non factorisable :
  pivot presque nul � la ligne : %(i1)d
  nombre de d�cimales perdues  : %(i2)d
"""),

11 : _("""
Matrice non factorisable :
  pivot vraiment nul � la ligne : %(i1)d
"""),

20 : _("""
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

21 : _("""
Matrice non factorisable :
  pivot vraiment nul � la ligne : %(i1)d
  pour le noeud %(k1)s et la composante %(k2)s
"""),

30 : _("""
Matrice non factorisable :
  pivot presque nul � la ligne : %(i1)d
  nombre de d�cimales perdues  : %(i2)d
  Il s'agit sans doute d'une relation lin�aire entre ddls surabondante.
  La liste des noeuds concern�s par cette relation est imprim�e ci-dessus dans le fichier MESSAGE.
"""),

31 : _("""
Matrice non factorisable :
  pivot vraiment nul � la ligne : %(i1)d
  Il s'agit sans doute d'une relation lin�aire entre ddls surabondante.
  La liste des noeuds concern�s par cette relation est imprim�e ci-dessus dans le fichier MESSAGE.
"""),

40 : _("""
Matrice non factorisable :
  pivot presque nul � la ligne : %(i1)d
  nombre de d�cimales perdues  : %(i2)d
  Il s'agit sans doute d'une relation de blocage surabondante.
  blocage concern� : %(k4)s
"""),

41 : _("""
Matrice non factorisable :
  pivot vraiment nul � la ligne : %(i1)d
  Il s'agit sans doute d'une relation de blocage surabondante.
  blocage concern� : %(k4)s
"""),

42 : _("""
Matrice non factorisable :
  Le solveur MUMPS consid�re la matrice comme num�riquement singuli�re.
  (Mais il n'en dit pas plus)

Conseil :
  Il s'agit peut-etre d'un manque de conditions aux limites,
  ou au contraire, de redondances entre de trop nombreuses conditions.
"""),

51 : _("""
Solveur MUMPS interdit ici.
Causes possibles :
  - contact/frottement discret
  - STAT_NON_LINE / FLAMBEMENT
"""),

52 : _("""
Solveurs LDLT et MULT_FRONT seuls permis ici.
Causes possibles :
  - contact/frottement discret
  - STAT_NON_LINE / FLAMBEMENT
"""),

61 : _("""
Erreur Programmeur lors de la r�solution d'un syst�me lin�aire :
 La num�rotation des inconnues est incoh�rente entre la matrice et le second membre.
 Matrice       : %(k1)s
 Second membre : %(k2)s

 Si solveur : 'Feti' : num�ro du sous-domaine (ou domaine global) : %(i1)d
"""),

}
