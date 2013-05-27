# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1: _(u"""
Le syst�me lin�aire � r�soudre contient %(i1)d noeuds dont:
   - %(i2)d noeuds portant des degr�s de libert� physiques
   - %(i3)d noeuds portant des degr�s de libert� de Lagrange
Pour un total de %(i4)d �quations.
"""),

2: _(u"""
La matrice est de taille %(i1)d �quations.
Elle contient %(i2)d termes non nuls si elle est sym�trique et %(i3)d termes non nuls si elle n'est pas sym�trique (le nombre de termes non nuls est susceptible de varier si l'on utilise le contact en formulation continue ou la m�thode XFEM avec contact).
Soit un taux de remplissage de  %(r1)6.3f %%.
"""),


10: _(u"""
Probl�me : la matrice n'est pas factorisable :
  Lors de la factorisation de la matrice, on a rencontr� un probl�me
  (pivot nul ou presque nul) � la ligne %(i1)d
  Le degr� de libert� associ� � cette ligne est de type : (%(k4)s)
  Le nombre de d�cimales "perdues" pour cette ligne est : %(i2)d.
  Ce nombre de d�cimales perdues est li� au degr� de singularit� de la matrice. Plus il est grand,
  plus le syst�me est singulier. Quand il d�passe 8, on consid�re que l'on a perdu 50%% de la pr�cision
  sur les nombres r�els (qui ont 15 d�cimales environ).

  Les diff�rents types du degr� de libert� sont :
    * (A) : Degr� libert� physique associ� au noeud : %(k1)s et � la composante : %(k2)s.
    * (B) : Degr� de libert� de Lagrange associ� au blocage : (%(k3)s).
    * (C) : Degr� de libert� de Lagrange associ� � une relation lin�aire entre plusieurs degr�s de libert�.
            La liste des noeuds impliqu�s dans cette relation lin�aire est imprim�e ci-dessus.
    * (D) : Degr� de libert� d'un syst�me "g�n�ralis�".
            Nom du noeud : %(k5)s
            Composante   : %(k6)s
            Information compl�mentaire (�ventuellement)   : %(k7)s

Conventions :
  Ce message peut �tre �mis dans des situations diff�rentes pour lesquelles on ne conna�t
  pas toutes les informations imprim�es ci-dessus.
  On adopte alors les conventions suivantes :
    * Si le num�ro de la ligne est -999 :
        Soit la matrice est vraiment singuli�re et la factorisation n'a pu aller jusqu'au bout.
        Soit on ne sait pas attribuer la singularit� de la matrice � une ligne de la matrice.
    * Si le nombre de d�cimales perdues est -999 :
        On ne sait pas d�terminer la perte de d�cimales sur la ligne incrimin�e,

Risques et conseils :
   * Si la ligne correspond a un degr� de libert� physique (A), il s'agit probablement d'un mouvement
     de corps rigide mal bloqu�.
     V�rifiez les conditions aux limites.
     Si vous faites du contact, il ne faut pas que la structure ne "tienne" que par le contact.
     V�rifiez �galement les caract�ristiques mat�riaux (module d'Young, ...).

   * Si la ligne correspond a un degr� de libert� de Lagrange (B) ou (C), il s'agit sans doute d'une condition
     limite redondante.
     En particulier, il se peut que la relation lin�aire surabondante provienne des conditions de contact.
     Peut-�tre devriez vous exclure certains noeuds des conditions de contact
     (mots cl�s SANS_NOEUD et SANS_GROUP_NO).

   * Si le solveur utilis� est LDLT ou MULT_FRONT, vous pouvez utiliser le solveur MUMPS
     car celui-ci est le seul � pouvoir factoriser les matrices qui ne sont pas d�finies positives.

   * Il se peut aussi que ce ph�nom�ne soit tout � fait normal avec X-FEM si la fissure passe
     tr�s pr�s d'un noeud.
     Si le nombre de d�cimales perdues n'est pas trop grand (max 10 d�cimales),
     vous pouvez relancer le calcul en augmentant le nombre de d�cimales perdues autoris� :
     mot-cl� NPREC du mot cl� facteur SOLVEUR.
     Sinon, contactez l'�quipe de d�veloppement.

"""),


13: _(u"""
Solveur FETI :
  Le solveur FETI est impossible dans ce contexte.
Solution :
  Il faut changer de solveur.
"""),



42: _(u"""
Solveur MUMPS :
  La Matrice est non factorisable. Elle est d�tect�e comme �tant singuli�re
  (en structure ou num�riquement).

Conseils :
  Il peut s'agir d'une erreur de programmation ou d'un probl�me de mise en donn�es (blocage
  absent ou surabondant).
"""),


50: _(u"""
Solveur MUMPS :
   Vous avez demand� comme num�roteur RENUM = '%(k1)s', or MUMPS en a
   utilis� un autre.

Conseils :
   Il se peut que votre version de MUMPS n'ait pas �t� compil�e avec le support de ce num�roteur.
   Dans le doute, RENUM='AUTO' permet de laisser MUMPS faire le meilleur choix.
 """),
 
51: _(u"""
Solveur MUMPS :
  JEVEUX a d�charg� sur disque le maximum d'objets possibles afin de laisser de la
  place � MUMPS. Il a ainsi gagn� %(i1)d Mo. Mais ce d�chargement peut ralentir le calcul.

Conseils :
  La prochaine fois, relancez avec plus de m�moire globale ou avec une option de calcul plus �conome
  (par ordre d�croissant d'efficacit�):
    - Si le calcul est parall�le, r�duisez la consommation MUMPS en augmentant le nombre de processeurs,
    - Dans tous les cas, r�duisez la consommation MUMPS en activant l'option OUT_OF_CORE (SOLVEUR/GESTION_MEMOIRE='OUT_OF_CORE'),
    - Si le calcul est parall�le, r�duisez la consommation JEVEUX en activant l'option SOLVEUR/MATR_DISTRIBUEE.
"""),

52: _(u"""
  -> Vous avez demand� une analyse de stabilit� et vous utilisez le solveur lin�aire '%(k1)s'.
     Ces deux fonctionnalit�s ne sont pas compatibles.

  -> Conseil :
     Changez de solveur lin�aire en utilisant le mot-cl� METHODE de SOLVEUR.
"""),

53: _(u"""
Solveur MUMPS :
  MUMPS a manqu� de m�moire lors de la factorisation de la matrice � cause du pivotage.
  L'espace suppl�mentaire requis par ce pivotage est difficilement pr�visible a priori.
  Il est contr�l� par le param�tre SOLVEUR/PCENT_PIVOT.
  MUMPS a essay�, sans succ�s, %(i1)d valeurs de ce param�tre:
                 partant de %(i2)d %% pour finir � %(i3)d %%.
Conseils :
  - Augmenter la valeur du mot cl�  SOLVEUR/PCENT_PIVOT. On a le droit de d�passer la valeur 100
    (surtout sur les petits syst�mes),
  - Passer en mode de gestion m�moire automatique (GESTION_MEMOIRE='AUTO'),
  - En dernier ressort, passer en mode OUT_OF_CORE (GESTION_MEMOIRE='OUT_OF_CORE') ou augmenter la m�moire
    d�volue au calcul ou le nombre de processeurs (si le calcul est parall�le).
"""),

54: _(u"""
Solveur MUMPS :
  Le solveur MUMPS manque de m�moire lors de la factorisation de la matrice.

Conseils :
  Il faut augmenter la m�moire accessible � MUMPS (et autres programmes hors fortran de Code_Aster).
  Pour cela, il faut diminuer la m�moire donn�e � JEVEUX (ASTK : case "dont Aster (Mo)") ou bien
  augmenter la m�moire totale (ASTK : case "M�moire totale (Mo))".
"""),

55: _(u"""
Solveur MUMPS :
  Probl�me ou alarme dans le solveur MUMPS.
  Le code retour de MUMPS (INFOG(1)) est : %(i1)d

Conseils :
  Consulter le manuel d'utilisation de MUMPS.
  Pr�venir l'�quipe de d�veloppement de Code_Aster.
"""),

56: _(u"""
Solveur MUMPS :
  Il ne faut pas utiliser TYPE_RESOL = '%(k1)s'
  Pour une matrice non-sym�trique.

Conseils :
  Il faut utiliser TYPE_RESOL = 'NONSYM' (ou 'AUTO').
"""),

57: _(u"""
Solveur MUMPS :
  La solution du syst�me lin�aire est trop impr�cise :
  Erreur calcul�e   : %(r1)g
  Erreur acceptable : %(r2)g   (RESI_RELA)

Conseils :
  On peut augmenter la valeur du mot cl� SOLVEUR/RESI_RELA.
"""),

58: _(u"""
Solveur MUMPS :
  MUMPS manque de m�moire lors de la factorisation de la matrice � cause du pivotage.
  L'espace suppl�mentaire requis par ce pivotage est difficilement pr�visible a priori.
  MUMPS vient d'�chouer avec une valeur de cet espace suppl�mentaire �gale �: 
                               SOLVEUR/PCENT_PIVOT=%(i1)d %%.
  On va r�essayer avec une valeur plus importante: %(i2)d %% et/ou en passant en gestion
  m�moire OUT_OF_CORE (SOLVEUR/GESTION_MEMOIRE='OUT_OF_CORE').
  La prochaine fois, relancer votre calcul en prenant ces nouvelles valeurs du param�trage.
  C'est la tentative n %(i3)d de factorisation ! 

Attention :
  Ce proc�d� automatique de correction est limit� � %(i4)d tentatives !
  Cette nouvelle valeur SOLVEUR/PCENT_PIVOT devient la valeur par d�faut pour les
  futures r�solutions de syst�mes lin�aires avec MUMPS dans cet op�rateur.
"""),

59: _(u"""
Solveur MUMPS :
  La matrice est d�j� factoris�e. On ne fait rien.

Conseils :
  Il y a sans doute une erreur de programmation.
  Contactez l'assistance.
"""),

60: _(u"""
Solveur MUMPS :
  Limite atteinte : le solveur MUMPS est utilis� par plus de 5 matrices simultan�ment.

Conseils :
  Contactez l'assistance.
"""),

61: _(u"""
Erreur Programmeur lors de la r�solution d'un syst�me lin�aire :
 La num�rotation des inconnues est incoh�rente entre la matrice et le second membre.
 Matrice       : %(k1)s
 Second membre : %(k2)s

 Si solveur : 'FETI' : num�ro du sous-domaine (ou domaine global) : %(i1)d
"""),

62: _(u"""
Solveur MUMPS :
  La proc�dure de raffinement it�ratif aurait besoin de plus que les %(i1)d d'it�rations
  impos�es en dur dans l'appel MUMPS par Code_Aster.

Conseils :
  On peut essayer la valeur du mot-cl� POSTTRAITEMENTS='FORCE'.
"""),

64: _(u"""
Solveur MUMPS :
  Le solveur MUMPS manque de m�moire lors de la phase d'analyse de la matrice.

Conseils :
  Il faut augmenter la m�moire accessible � MUMPS (et autres programmes hors fortran de Code_Aster).
  Pour cela, il faut diminuer la m�moire donn�e � JEVEUX (ASTK : case "dont Aster (Mo)") ou bien
  augmenter la m�moire totale (ASTK : case "M�moire totale (Mo))".
"""),

65: _(u"""
Solveur MUMPS :
  MUMPS ne peut pas factoriser la matrice � cause d'un d�passement d'entiers.

Conseils :
  Si vous utilisez la version s�quentielle, alors il vous faut passer � la version parall�le.
  Si vous utilisez d�j� la version parall�le, alors il faut augmenter le nombre de processeurs
  allou�s au calcul.
"""),

66: _(u"""
Solveur MUMPS :
  �chec de la factorisation OUT_OF_CORE de MUMPS.
  Consulter les  messages d�livr�s  par MUMPS.

Conseils :
   Augmenter  le nombre de processeurs utilis�s.
"""),

67: _(u"""
Erreur d'utilisation (commande RESOUDRE) :
  La matrice et le second membre fournis � la commande RESOUDRE
  ne sont pas de m�me dimension (nombre de ddls).

Conseils :
  V�rifier la coh�rence des arguments MATR et CHAM_NO.
"""),

68: _(u"""
Erreur d'utilisation (commande RESOUDRE) :
  La matrice et le second membre fournis � la commande RESOUDRE
  ne sont pas du m�me type (r�el/complexe).

Conseils :
  V�rifier la coh�rence des arguments MATR et CHAM_NO.
"""),


70: _(u"""
Solveur MUMPS :
  Vous avez activ� l'option IMPR="OUI_SOLVE" en surchargeant AMUMPS.F. La r�solution
  du syst�me lin�aire en cours va donc s'effectuer normalement mais en plus
  sa matrice et son second membre vont �tre �crits dans le fichier d'unit� logique
  %(i1)d. Vous pouvez le r�cup�rer (sur le processeur 0) via ASTK.
"""),

71: _(u"""
Solveur MUMPS :
  Vous avez activ� l'option IMPR="OUI_NOSOLVE" en surchargeant AMUMPS.F. La r�solution
  du syst�me lin�aire en cours ne va donc pas s'effectuer mais sa matrice et
  son second membre vont �tre �crits dans le fichier d'unit� logique %(i1)d.
  Apr�s cette �criture, l'ex�cution Aster s'arr�te en ERREUR_FATALE pour vous
  permettre de r�cup�rer plus rapidement votre fichier.
  Vous pouvez le r�cup�rer (sur le processeur 0) via ASTK.
"""),

72: _(u"""
Solveur MUMPS :
  Votre ex�cutable Aster embarque la version de MUMPS: %(k1)s
  Les seules versions de MUMPS support�e dans Code_Aster sont, pour l'instant:
                              la 4.9.2 et la 4.10.0.
  
Conseils :
  T�l�charger, installer et relier � Code_Aster une version de MUMPS ad�quate.
  Utiliser un autre solveur lin�aire (mot-cl� SOLVEUR/METHODE, par exemple "MULT_FRONT" ou "PETSC")
  Sinon, contactez l'�quipe de d�veloppement.
"""),

73: _(u"""
Solveur MUMPS :
  Lors de la factorisation num�rique, le pourcentage de pivots, %(r1).0f %%, a d�pass� le
  pourcentage pr�vu par le param�tre SOLVEUR/PCENT_PIVOT= %(r2).0f %%.
  Cela peut engendrer un r�sultat de mauvaise qualit�. V�rifiez bien la qualit� de celui-ci
  en fin de r�solution via la mot-cl� RESI_RELA.
  
Conseils :
  Pour am�liorer la qualit� de la solution vous pouvez activez les options de pr� et
  post-traitements (PRETRAITEMENTS='AUTO' et POSTTRAITEMENTS='FORCE' ou 'AUTO'), durcir le crit�re
  de qualit� RESI_RELA ou, si vous avez beaucoup de Lagrange (>10%% de la taille du probl�me),
  d�sactivez l'option ELIM_LAGR2 (ELIM_LAGR2='NON').
  Sinon, contactez l'�quipe de d�veloppement.
"""),

74: _(u"""
Solveur MUMPS :
  Attention, vous avez demand� un calcul IN_CORE, mais MUMPS estime avoir besoin pour cela de
  %(i1)d Mo (avec %(i2)d %% de marge), alors qu'il n'y a que %(i3)d Mo de disponible sur ce processeur !
  Le calcul pourrait donc �tre ralenti ou achopper pour cette raison.
  
Conseils :
  La prochaine fois, relancez avec plus de m�moire globale ou avec une option de calcul plus �conome
  (par ordre d�croissant d'efficacit�):
    - Si le calcul est parall�le, r�duisez la consommation MUMPS en augmentant le nombre de processeurs,
    - Dans tous les cas, r�duisez la consommation MUMPS en activant l'option OUT_OF_CORE (SOLVEUR/GESTION_MEMOIRE='OUT_OF_CORE')
      ou passer en mode automatique (SOLVEUR/GESTION_MEMOIRE='AUTO'),
    - Si le calcul est parall�le, r�duisez la consommation Aster en activant l'option SOLVEUR/MATR_DISTRIBUEE.
"""),

75: _(u"""
Solveur MUMPS :
  Attention, vous avez demand� un calcul OUT_OF_CORE, mais MUMPS estime avoir besoin pour cela de
  %(i1)d Mo (avec %(i2)d %% de marge), alors qu'il n'y a que %(i3)d Mo de disponible sur ce processeur !
  Le calcul pourrait donc �tre ralenti ou achopper pour cette raison.
  
Conseils :
  La prochaine fois, relancez avec plus de m�moire globale ou avec une option de calcul plus �conome
  (par ordre d�croissant d'efficacit�):
   - Si le calcul est parall�le, r�duisez la consommation MUMPS en augmentant le nombre de processeurs,
   - Si le calcul est parall�le, r�duisez la consommation Aster en activant l'option SOLVEUR/MATR_DISTRIBUEE,
  Ou, plus radicalement:
   - Utilisez un solveur moins exigeant en m�moire (par exemple: SOLVEUR/METHODE='PETSC' + PRECOND='LDLT_SP').
"""),

76: _(u"""
Solveur MUMPS :
  Pour essayer de passer en m�moire, il a fallu d�charger sur disque un maximum d'objets JEVEUX.
  Ce d�chargement a pu ralentir le calcul.
  La m�moire disponible est ainsi pass�e de %(i1)d Mo � %(i2)d Mo. Mais cela n'a pas �t� suffisant car
  MUMPS a besoin, suivant son mode de gestion m�moire (param�tr� par le mot-cl� SOLVEUR/GESTION_MEMOIRE),
  d'au moins:
     - IN_CORE    : %(i3)d Mo,
     - OUT_OF_CORE: %(i4)d Mo.
  Estimations � %(i5)d %% de marge pr�s.
  
Conseils :
  La prochaine fois, relancez avec plus de m�moire globale ou avec une option de calcul
  plus �conome (par ordre d�croissant d'efficacit�):
   - Si le calcul est parall�le, r�duisez la consommation MUMPS en augmentant le nombre de processeurs ou
     r�duisez celle de JEVEUX en activant l'option MATR_DISTRIBUEE.
  Ou, plus radicalement:
   - Utilisez un solveur moins exigeant en m�moire (par exemple: SOLVEUR/METHODE='PETSC' + PRECOND='LDLT_SP').
"""),

77: _(u"""
Solveur MUMPS :
  Vous avez demand� les estimations m�moire (m�moire et disque, Aster et MUMPS) de votre calcul.
  Une fois ces estimations affich�es (sur le processeur 0), l'ex�cution Aster s'arr�te en
  ERREUR_FATALE pour vous permettre de relancer votre calcul en tenant compte de ces �l�ments.
"""),

78: _(u"""
Solveur MUMPS :
  D�passement de capacit� des termes de la matrice. On a d�tect� au moins:
    - %(i1)d termes trop petits,
    - %(i2)d termes trop grands.
"""),

79: _(u"""
Solveur MUMPS :
  D�passement de capacit� du terme n %(i1)d du second membre. Sa valeur absolue vaut %(r1)g alors que la 
  limite est fix�e � %(r2)g.
"""),

80: _(u"""
Solveur MUMPS :

  Attention, vous avez param�tr� le solveur lin�aire de mani�re a r�soudre un syst�me lin�aire 
  SPD (r�el Sym�trique D�fini Positif): mot-cl� SOLVEUR/TYPE_RESOL='SYMDEF'. Or votre syst�me
  lin�aire � valeur complexe. Ceci est contradictoire.

Conseil :
  Utilisez le solveur lin�aire MUMPS avec TYPE_RESOL='AUTO'.
"""),

81: _(u"""

- Taille du syst�me lin�aire: %(i1)d
 
- M�moire minimale consomm�e par Code_Aster (JEVEUX, Superviseur, Python...) : %(i2)d Mo
- Estimation de la m�moire MUMPS avec GESTION_MEMOIRE='IN_CORE'              : %(i3)d Mo
- Estimation de la m�moire MUMPS avec GESTION_MEMOIRE='OUT_OF_CORE'          : %(i4)d Mo
- Estimation de l'espace disque pour MUMPS avec GESTION_MEMOIRE='OUT_OF_CORE': %(i5)d Mo
 
  > Pour ce calcul, il faudrait donc une quantit� de m�moire au minimum de 
        - %(i6)d Mo si GESTION_MEMOIRE='IN_CORE',
        - %(i7)d Mo si GESTION_MEMOIRE='OUT_OF_CORE'. 
  En cas de doute, utilisez GESTION_MEMOIRE='AUTO'.

"""),
82: _(u"""
Solveur MUMPS :
  La machine sur laquelle ce calcul a �t� lance ne permet pas l'�valuation du pic m�moire
  'VmPeak'. En mode SOLVEUR/GESTION_MEMOIRE='AUTO' cela peut fausser les �valuations
  de m�moire disponibles.
  > Par pr�caution on bascule automatiquement en mode GESTION_MEMOIRE='OUT_OF_CORE'.

Conseils :
  Pour acc�l�rer le calcul vous pouvez (conseils cumulatifs):
    - passer en mode IN_CORE (GESTION_MEMOIRE='IN_CORE'),
    - lancer le calcul en parall�le,
    - changer de machine en laissant le mode GESTION_MEMOIRE='AUTO'.
"""),
83: _(u"""
Solveur MUMPS :
  La machine sur laquelle ce calcul a �t� lanc� ne permet pas l'�valuation du pic m�moire
  'VmPeak'. En mode SOLVEUR/GESTION_MEMOIRE='EVAL' cela peut fausser la calibration
  de la m�moire minimale consomm�e par Code_Aster.

Conseil :
  Pour lancer le calcul, il faut donc se fier plut�t aux estimations m�moire MUMPS.
"""),
84: _(u"""
Solveur MUMPS :

  Attention, vous avez param�tr� le solveur lin�aire MUMPS de mani�re a r�soudre un syst�me
  lin�aire SPD (r�el Sym�trique D�fini Positif): mot-cl� SOLVEUR/TYPE_RESOL='SYMDEF'. Or votre
  matrice comporte des termes n�gatifs ou nuls sur sa diagonale. Ceci est contradictoire.

Conseil :
  Si il s'agit d'un test vous voila averti, sinon utilisez le solveur lin�aire MUMPS
  avec TYPE_RESOL='AUTO'.
"""),

85: _(u"""
Solveur MUMPS :
  MUMPS essaye d'allouer %(i1)d Mo de m�moire mais il n'y arrive pas. Il se base
  sur une estimation de la m�moire disponible et celle-ci est sans doute fauss�e. Cela peut 
   arriver, par exemple, sur d'anciens noyaux syst�me.

  > Par pr�caution, on va r�essayer en laissant compl�tement la main � MUMPS. Le calcul sera
    potentiellement plus lent, mais cela gommera ces probl�mes d'estimations m�moire pr�alables.
  
Conseil :
  Contactez l'�quipe de d�veloppement.

"""),
86: _(u"""
Solveur MUMPS :
  Un op�rateur a demand� � MUMPS de ne pas conserver les termes de la matrice factoris�e.
  Cela permet d'optimiser un peu les performances dans les cas ou seul le d�terminant, la
  d�tection de singularit� ou le test de Sturm sont requis (par ex. MODE_ITER_SIMULT option 'BANDE').
  Or la version de MUMPS embarqu�e dans votre ex�cutable: %(k1)s
  ne permet pas cette optimisation.

  > On ne tient donc pas compte de cette optimisation et on stocke, comme pour un calcul standard,
    tous les termes de la factoris�e.

"""),
87: _(u"""
Solveur MUMPS :
  Un op�rateur a demand� � MUMPS de calculer un d�terminant. Or cette option n'est disponible
  qu'a partir de la v 4.10.0. Or votre ex�cutable est li� a MUMPS v: %(k1)s.

  Conseils:
    - Reconstruisez un ex�cutable en prenant une bonne version de MUMPS,
    - Changer de solveur lin�aire (par exemple, mot-cl� SOLVEUR/METHODE='MULT_FRONT') dans l'op�rateur
      incrimin�.

"""),
88: _(u"""
Solveur MUMPS :
  Un op�rateur a demand� � MUMPS de calculer un d�terminant. Pour ne pas fausser ce calcul on a
  d�branch� automatiquement l'option SOLVEUR/ELIM_LAGR2.
Attention :
  Cette nouvelle valeur SOLVEUR/ELIM_LAGR2 devient la valeur par d�faut pour les
  futures r�solutions de syst�mes lin�aires avec MUMPS dans cet op�rateur.

"""),
}
