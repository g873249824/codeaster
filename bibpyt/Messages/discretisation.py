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

cata_msg = {

1 : _(u"""
Certains pas de temps de la liste (LISTE_INST) sont plus petits
 que le pas de temps minimal renseign� (SUBD_PAS_MINI)
"""),

2 : _(u"""
 L'instant initial de la liste est plus grand que le deuxi�me instant.
 Si vous faites une reprise de calcul (REUSE), vous pouvez utiliser le mot-clef ETAT_INIT/INST_ETAT_INIT pour corriger cela.
"""),

3 : _(u"""
 Probl�me lors de la r�cup�ration de la table contenant les param�tres calcul�s du r�sultat <%(k1)s>.
Conseils :
   V�rifiez que le r�sultat <%(k1)s> provient bien de la commande STAT_NON_LINE ou DYNA_NON_LINE.
"""),

4 : _(u"""
 Probl�me lors de la r�cup�ration de la table contenant les param�tres calcul�s du r�sultat <%(k1)s>.
 Ce r�sultat a �t� construit en reprise (REUSE). On ne sait pas extraire une liste d'instants correcte.
Conseils :
   Faites votre calcul initial sans reprise.
"""),


5 : _(u"""
 L'adaptation du pas de temps a �t� d�sactiv�e. Seuls les instants d�finis par LIST_INST seront calcul�s
 (hormis les sous d�coupages �ventuels).
"""),

8 : _(u"""
 Vous faites un calcul de thermique sans r�solution stationnaire et sans
 non plus de r�solution transitoire.

 Conseils :
   Renseignez la discr�tisation temporelle par le mot cl� INCREMENT
"""),

9 : _(u"""
 Attention, en cas d'erreur (contact, loi de comportement, pilotage, ...), le pas de temps
 ne sera pas red�coup�.
"""),


10 : _(u"""
 On ne peut d�finir qu'une seule occurrence de ECHEC/EVENEMENT='ERREUR'.
"""),

14 : _(u"""
 Attention : avec MODE_CALCUL_TPLUS = 'IMPLEX', on doit demander le calcul � tous les instants
 (EVENEMENT='TOUT_INST')
"""),

15 : _(u"""
 Attention : MODE_CALCUL_TPLUS = 'IMPLEX' ne permet qu'un mot cl� ADAPTATION
"""),

40 : _(u"""
  Le solveur <%(k1)s> ne permet pas la d�tection de singularit�.
  La d�coupe du pas de temps en cas d'erreur (pivot nul) n'est donc pas possible.
"""),

41 : _(u"""
  Le pr�conditionneur <%(k1)s> ne supporte pas la r�actualisation automatique.
"""),

42 : _(u"""
  Le solveur <%(k1)s> n'est pas un solveur it�ratif.
  La r�actualisation du pr�conditionneur n'est donc pas possible.
"""),

86 : _(u"""
Il n'y a aucun pas de calcul temporel.
En m�canique, 'LIST_INST' est absent.
En thermique, 'LIST_INST' est absent ou un singleton.
"""),

87 : _(u"""
La liste d'instants n'est pas strictement croissante.
"""),

89 : _(u"""
L'instant initial est introuvable dans la liste d'instants (LIST_INST).
Risque & Conseil :
   V�rifiez le mot-cl� INST_INIT (ou NUME_INST_INIT), en tenant compte de la pr�cision (mot-cl� PRECISION).
"""),

92 : _(u"""
On ne peut faire le calcul car l'instant final donn� est �gal au dernier instant stock� dans la structure de donn�es RESULTAT. Il n'y a qu'un incr�ment disponible alors qu'il faut au moins deux pas de temps dans les op�rateurs non-lin�aires.
"""),

94 : _(u"""
L'instant final est introuvable dans la liste d'instants (LIST_INST).
Risque & Conseil :
   V�rifiez le mot-cl� INST_FIN (ou NUME_INST_FIN), en tenant compte de la pr�cision (mot-cl� PRECISION).
"""),


}
