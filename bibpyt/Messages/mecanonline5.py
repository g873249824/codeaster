#@ MODIF mecanonline5 Messages  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
# -*- coding: iso-8859-1 -*-

def _(x) : return x

cata_msg = {

1  : _("""
Avec un sch�ma de type explicite, seule la pr�diction TANGENTE est possible
"""),

3 : _("""
 Il n'est pas possible actuellement de calculer des modes de flambement
 (CRIT_FLAM) ou des modes vibratoires (MODE_VIBR) si on utilise la
 m�thode continue du contact ou XFEM avec du contact.
"""),


4 : _("""
 Le contact avec m�thode continue ou XFEM avec du contact n�cessite de r�actualiser la matrice tangente
 � chaque it�ration (REAC_ITER = 1).
"""),

7 : _("""
 Etant donn� la pr�sence du mot cl� AMOR_ALPHA et / ou AMOR_BETA, 
 on va assembler la matrice d'amortissement globale de Rayleigh, 
 m�me si ces coefficients sont tous les deux nuls.
 Cette op�ration engendre un surco�t de calcul.
"""),

9 : _("""
 Pour avoir BETA nul (sch�ma purement explicite) avec un sch�ma de Newmark (standard ou HHT),
utilisez DIFF_CENT ou TCHAMWA.
"""),

10 : _("""
 Pour un sch�ma purement explicite (DIFF_CENT ou TCHAMWA), seule la formulation
en acc�l�ration est possible
"""),

11 : _("""
 Pour un sch�ma de type NEWMARK, seule les formulations en acc�l�ration et en d�placement sont possibles
"""),

12 : _("""
 Pour un sch�ma de type THETA, seule les formulations en vitesse et en d�placement sont possibles
"""),


19 : _("""
Il y plus d'amortissements modaux (AMOR_MODAL) que de modes.
"""),

20 : _("""
On ne trouve pas le champ de d�placement pour Dirichlet diff�rentiel dans le concept <%(k1)s>.
Votre valeur de NUME_DIDI doit etre incorrecte ou le concept n'est pas le bon.

"""),

21 : _("""
  -> Crit�re de convergence est lache !
  -> Risque & Conseil : La valeur de RESI_GLOB_RELA est sup�rieure � 10-4.
     Cela peut nuire � la qualit� de la solution. Vous ne v�rifiez pas l'�quilibre de 
     mani�re rigoureuse.
"""),

22 : _("""
Sch�ma en dynamique explicite.
Le contact n'est pas possible.
"""),

23 : _("""
Sch�ma en dynamique explicite.
LIAISON_UNILATER n'est pas possible.
"""),

24 : _("""
Sch�ma en dynamique explicite.
Les poutres en grandes rotations POU_D_T_GD et POU_D_TGM ne sont utilisables
qu'en faibles rotations.
"""),

25 : _("""
Dynamique non-lin�aire
Le pilotage n'est pas possible.
"""),

26 : _("""
Dynamique non-lin�aire
La recherche lin�aire n'est pas possible.
"""),

27 : _("""
Dynamique non-lin�aire avec sch�ma THETA
Les poutres en grandes rotations POU_D_T_GD et POU_D_TGM sont interdits.
"""),

28 : _("""
Dynamique non-lin�aire
La m�thode XFEM n'est pas possible.
"""),

44 : _("""
Pour la pr�diction de type 'DEPL_CALCULE', il faut obligatoirement:
 - ITER_GLOB_MAXI = 0
 - ARRET = 'NON'
"""),

45 : _("""
Il faut pr�ciser un concept EVOL_NOLI en pr�diction de type 'DEPL_CALCULE'
"""),

46 : _("""
  -> La d�finition des param�tres RHO_MIN et RHO_EXCL est contradictoire.
     On choisit de prendre RHO_MIN � RHO_EXCL.
  -> Risque & Conseil :
     RHO_MIN ne doit pas etre compris entre -RHO_EXCL et RHO_EXCL

"""),

47 : _("""
  -> La d�finition des param�tres RHO_MAX et RHO_EXCL est contradictoire.
     On choisit de prendre RHO_MAX � -RHO_EXCL.
  -> Risque & Conseil :
     RHO_MAX ne doit pas etre compris entre -RHO_EXCL et RHO_EXCL

"""),

}
