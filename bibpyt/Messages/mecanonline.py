#@ MODIF mecanonline Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg = {

1 : _(u"""
 Echec dans le calcul des matrices elastiques pour l'amortissement.
"""),

23 : _(u"""
 Le calcul de l'acc�l�ration initiale a ignor� les chargements de type:
 - ONDE_PLANE
 - LAPLACE
 - GRAPPE_FLUIDE
"""),

24 : _(u"""
 L'etat initial n'a pas d'acc�leration donn�e.
 On la calcule.
 """),

43 : _(u"""
 Contact et pilotage sont des fonctionnalit�s incompatibles
"""),

59 : _(u"""
 Cette loi de comportement n'est pas disponible pour le pilotage de type PRED_ELAS
"""),

60 : _(u"""
 Le pilotage de type PRED_ELAS n�cessite ETA_PILO_MIN et ETA_PILO_MAX pour la loi ENDO_ISOT_BETON
"""),

69 : _(u"""
 Probl�me rencontr� :
   la matrice de masse est non inversible.
   On ne peut donc pas s'en servir pour calculer l'acc�l�ration initiale.
   => on initialise l'acc�l�ration � z�ro.

 Conseils :
   Avez-vous bien affect� une masse sur tous les �l�ments ?
 
 Certains �l�ments ne peuvent �valuer de matrice masse.
 Dans ce cas, vous pouvez donner un champ d'acc�l�ration explicitement nul dans ETAT_INIT pour supprimer l'alarme.
"""),



78 : _(u"""
 Probl�me rencontr� :
   la matrice de masse est quasi-singuli�re.
   On se sert de cette matrice pour calculer l'acc�l�ration initiale.
   => l'acc�l�ration initiale calcul�e est peut etre excessive en quelques noeuds.

 Conseils :
   Ces �ventuelles perturbations initiales sont en g�n�ral sans influence sur
   la suite du calcul car elles sont localis�es.
   N�anmoins, il peut etre b�n�fique de laisser ces perturbations s'amortir au
   d�but du calcul en faisant plusieurs pas avec chargement transitoire nul,
   avec, eventuellement, un sch�ma d'integration choisi volontairement tr�s
   dissipatif (par exemple HHT avec alpha=-0.3).
   On peut ensuite reprendre en poursuite avec un sch�ma moins dissipatif si besoin est.
"""),




82 : _(u"""
   Arr�t pour cause de matrice non inversible.
"""),

83 : _(u"""
   Arr�t : absence de convergence avec le nombre d'it�rations requis.
"""),

84 : _(u"""
   Arr�t par �chec dans le pilotage.
"""),

85 : _(u"""
   Arr�t : absence de convergence au num�ro d'instant : %(i1)d
                                  lors de l'it�ration : %(i2)d
"""),

86 : _(u"""
   Arr�t par �chec du traitement de la collision.
"""),
}
