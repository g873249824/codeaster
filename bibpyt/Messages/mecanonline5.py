#@ MODIF mecanonline5 Messages  DATE 09/04/2013   AUTEUR ABBAS M.ABBAS 
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

1  : _(u"""
Avec un sch�ma de type explicite, seule la pr�diction TANGENTE est possible
"""),

2 : _(u"""
 Le calcul des �nergies n'est pas disponible avec le solveur FETI.
"""),

3 : _(u"""
 Il n'est pas possible actuellement de calculer des modes de flambement
 (CRIT_FLAMB) ou des modes vibratoires (MODE_VIBR) si on utilise la
 m�thode continue du contact ou XFEM avec du contact.
"""),


4 : _(u"""
 Vous utilisez une m�thode de contact (continue ou XFEM) qui n�cessite de r�actualiser la matrice tangente
 � chaque it�ration. La r�actualisation est donc forc�e (REAC_ITER = 1).

  -> Risque & Conseil :
   - Vous pouvez supprimer cette alarme si vous
     renseignez REAC_ITER=1 sous le mot-cl� facteur NEWTON.

"""),

5 : _(u"""
 Vous utilisez une m�thode de contact (contact discret avec p�nalisation ou �l�ment DIS_CHOC)
  qui apporte une contribution � la matrice tangente � chaque it�ration. La r�actualisation est donc forc�e (REAC_ITER=1) et ce m�me si vous utilisez la matrice
 'ELASTIQUE'.

  -> Risque & Conseil :
   - Vous pouvez supprimer cette alarme dans le cas o� vous utilisez une matrice 'TANGENTE', pour cela
     renseignez REAC_ITER=1 sous le mot-cl� facteur NEWTON.
"""),

6 : _(u"""
 Le calcul des �nergies n'est pas disponible avec le mot-cl� PROJ_MODAL.
"""),

7 : _(u"""
 �tant donn� la pr�sence du mot cl� AMOR_ALPHA et / ou AMOR_BETA,
 on va assembler la matrice d'amortissement globale de Rayleigh,
 m�me si ces coefficients sont tous les deux nuls.
 Cette op�ration engendre un surco�t de calcul.
"""),

8 : _(u"""
 Le calcul des �nergies n'est pas disponible lorsque MATR_DISTRIBUEE='OUI'.
"""),

9 : _(u"""
 Pour avoir BETA nul (sch�ma purement explicite) avec un sch�ma de Newmark (standard ou HHT),
utilisez DIFF_CENT ou TCHAMWA.
"""),

10 : _(u"""
 Pour un sch�ma purement explicite (DIFF_CENT ou TCHAMWA), seule la formulation
en acc�l�ration est possible
"""),

11 : _(u"""
 Pour un sch�ma de type NEWMARK, seules les formulations en acc�l�ration et en d�placement sont possibles
"""),

12 : _(u"""
 Pour un sch�ma de type THETA, seules les formulations en vitesse et en d�placement sont possibles
"""),

13 : _(u"""
 La matrice de masse diagonale (option MASS_DIAG) n'est pas utilisable avec un sch�ma implicite.
"""),

19 : _(u"""
Il y a plus d'amortissements modaux (AMOR_MODAL) que de modes.
"""),

20 : _(u"""
On ne trouve pas le champ de d�placement pour Dirichlet diff�rentiel dans le concept <%(k1)s>.
Votre valeur de NUME_DIDI doit �tre incorrecte ou le concept n'est pas le bon.

"""),

21 : _(u"""
  -> Crit�re de convergence est l�che !
  -> Risque & Conseil : La valeur de RESI_GLOB_RELA est sup�rieure � 10-4.
     Cela peut nuire � la qualit� de la solution. Vous ne v�rifiez pas l'�quilibre de
     mani�re rigoureuse.
"""),

22 : _(u"""
Sch�ma en dynamique explicite.
Le contact n'est pas possible.
"""),

23 : _(u"""
Sch�ma en dynamique explicite.
Les liaisons unilat�rales ne sont pas possibles.
"""),

24 : _(u"""
Sch�ma en dynamique explicite.
Les poutres en grandes rotations POU_D_T_GD et POU_D_TGM ne sont utilisables
qu'en faibles rotations.
"""),

25 : _(u"""
Dynamique non-lin�aire
Le pilotage n'est pas possible.
"""),

27 : _(u"""
Dynamique non-lin�aire avec sch�ma THETA
Les poutres en grandes rotations POU_D_T_GD et POU_D_TGM sont interdits.
"""),

28 : _(u"""
Dynamique non-lin�aire
La m�thode XFEM n'est pas possible.
"""),


29 : _(u"""
Vous faites de la projection modale PROJ_MODAL en explicite.
Il y a %(i1)d  modes dans la structure MODE_MECA.
Le nombre de modes (mot-clef NB_MODE dans PROJ_MODAL) vaut %(i2)d.
On prend donc %(i3)d modes.
"""),

30 : _(u"""
Vous faites de l'amortissement modal (r�duit ou non).
Il y a %(i1)d  modes dans la structure MODE_MECA.
Le nombre de modes (mot-clef NB_MODE dans AMOR_MODAL) vaut %(i2)d.
On prend donc %(i3)d modes.
"""),

31 : _(u"""
Vous faites de la projection modale PROJ_MODAL en explicite en reprise.
Il n'y a pas de modes stock�s lors du calcul pr�c�dent.
On part donc de DEPL/VITE/ACCE g�n�ralis�s nuls.
"""),


32 : _(u"""
La SD EVOL_NOLI utilis�e dans REST_COND_TRAN ne contient pas les
champs g�n�ralis�s.
V�rifiez qu'il s'agit du m�me concept que celui utilis� dans le DYNA_NON_LINE,
option PROJ_MODAL et que l'archivage a �t� fait (mot-clef ARCHIVAGE de DYNA_NON_LINE)

"""),

33 : _(u"""
Dynamique non-lin�aire
La m�thode IMPLEX n'est pas possible.
"""),

34 : _(u"""
La recherche lin�aire est incompatible avec le pilotage de type DDL_IMPO.
"""),

35 : _(u"""
La recherche lin�aire de type PILOTAGE n�cessite de faire du pilotage (pr�sence du mot-clef facteur PILOTAGE).
"""),

36 : _(u"""
La pr�diction de type EXTRAPOL ou DEPL_CALCULE est incompatible avec le pilotage.
"""),

37 : _(u"""
L'usage de ARRET='NON' dans CONVERGENCE est dangereux et doit �tre utilis� avec pr�caution car il permet � un calcul de converger
m�me lorsque l'�quilibre n'est pas v�rifi�.
"""),

43 : _(u"""
  -> Les param�tres RHO_MIN et RHO_MAX sont identiques.
"""),
44 : _(u"""
  -> La d�finition des param�tres RHO_MIN et RHO_MAX est contradictoire.
     On choisit de prendre RHO_MIN plus petit que RHO_MAX.
"""),


45 : _(u"""
Il faut pr�ciser un concept EVOL_NOLI en pr�diction de type 'DEPL_CALCULE'
"""),

46 : _(u"""
  -> La d�finition des param�tres RHO_MIN et RHO_EXCL est contradictoire.
     On choisit de prendre RHO_MIN � RHO_EXCL.
  -> Risque & Conseil :
     RHO_MIN ne doit pas �tre compris entre -RHO_EXCL et RHO_EXCL

"""),

47 : _(u"""
  -> La d�finition des param�tres RHO_MAX et RHO_EXCL est contradictoire.
     On choisit de prendre RHO_MAX � -RHO_EXCL.
  -> Risque & Conseil :
     RHO_MAX ne doit pas �tre compris entre -RHO_EXCL et RHO_EXCL

"""),

48 : _(u"""
  Le pilotage est incompatible avec la m�thode NEWTON_KRYLOV.
"""),

49 : _(u"""
Le maillage sur lequel s'appuie le mod�le et le maillage du champ des variables internes fourni dans ETAT_INIT ne sont pas les m�mes.
Conseils: V�rifiez la coh�rence des maillages.
"""),

50 : _(u"""
 Pilotage.
 La composante <%(k1)s> n'a pas �t� trouv�e dans la num�rotation.
 V�rifier NOM_CMP dans le mot-clef PILOTAGE.
"""),

51 : _(u"""
 Pour utiliser METHODE='NEWTON_KRYLOV', il faut utiliser une m�thode it�rative (GCPC, PETSC) sous le mot-cl� SOLVEUR.
"""),

53: _(u"""
   Le crit�re RESI_COMP_RELA est interdit en dynamique. Utilisez un autre crit�re de convergence
"""),


55 : _(u"""
  Vous utilisez l'indicateur de convergence RESI_REFE_RELA et une mod�lisation %(k1)s.
  Vous devez renseigner la valeur de r�f�rence %(k2)s dans CONVERGENCE.
"""),

56 : _(u"""
  Il n'est pas possible actuellement de calculer des modes vibratoires (MODE_VIBR) 
  sur un mod�le dont au moins une matrice assembl�e (masse ou raideur) est non-sym�trique.
"""),
}
