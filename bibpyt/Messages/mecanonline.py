#@ MODIF mecanonline Messages  DATE 12/01/2010   AUTEUR GRANET S.GRANET 
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

1 : _("""
 Echec dans le calcul des matrices elastiques pour l'amortissement.
"""),


10 : _("""
 Le concept dans ETAT_INIT n'est pas du type EVOL_NOLI
"""),

12 : _("""
 L'instant sp�cifi� sous ETAT_INIT n'est pas trouv�
"""),

13 : _("""
 Plusieurs instants correspondent � celui sp�cifi� sous ETAT_INIT
"""),

14 : _("""
 Vous utilisez la m�thode CONTINUE pour le traitement du contact et faites une reprise de calcul (mot-cl� reuse). L'�tat initial de contact sera
 non contactant sauf si vous avez utilis� le mot-cl� CONTACT_INIT.
 Cela peut entra�ner des difficult�s de convergence en pr�sence de fortes non-lin�arit�s. En pr�sence de frottement, la solution peut bifurquer
 diff�remment.
 
 Conseils :
   Si vous le pouvez, faites votre calcul en une seule fois.
"""),

15 : _("""
 Vous utilisez la m�thode CONTINUE pour le traitement du contact et d�finissez un �tat initial via le mot-cl� ETAT_INIT. L'�tat initial de contact
 sera non contactant sauf si vous avez utilis� le mot-cl� CONTACT_INIT.
"""),


22 : _("""
 L'etat initial n'appartient pas � un EVOL_NOLI :
 on suppose qu'on part d'un �tat a vitesses nulles
"""),

23 : _("""
 Le calcul de l'acc�l�ration initiale a ignor� les chargements de type:
 - ONDE_PLANE
 - LAPLACE
 - GRAPPE_FLUIDE
"""),

24 : _("""
 L'etat initial n'a pas d'acc�leration donn�e.
 On la calcule.
 """),

43 : _("""
 Contact et pilotage sont des fonctionnalit�s incompatibles
"""),

59 : _("""
 Cette loi de comportement n'est pas disponible pour le pilotage de type PRED_ELAS
"""),

60 : _("""
 Le pilotage de type PRED_ELAS n�cessite ETA_PILO_MIN et ETA_PILO_MAX pour la loi ENDO_ISOT_BETON
"""),

69 : _("""
 Probl�me rencontr� :
   la matrice de masse est non inversible.
   On ne peut donc pas s'en servir pour calculer l'acc�l�ration initiale.
   => on initialise l'acc�l�ration � z�ro.

 Conseils :
   Avez-vous bien affect� une masse sur tous les �l�ments ?
"""),

77 : _("""
 Vous faites une reprise de calcul avec PILOTAGE en longueur d'arc et avec l'option ANGL_INCR_DEPL mais il n'y pas assez d'informations dans
 la structure de donnees resultats. Il vous faut en effet au moins les deux derniers champs d�placements solutions.
 Changer l'option de PILOTAGE (utilisez NORM_INCR_DEPL) ou refaites le premier calcul pour enrichir la SD resultat (modifiez vos options d'ARCHIVAGE).
"""),

78 : _("""
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

79 : _("""
   Arret par manque de temps CPU au num�ro d'instant : %(i1)d
                                 lors de l'it�ration : %(i2)d
      - Temps moyen par it�ration : %(r1)f
      - Temps cpu restant         : %(r2)f
   
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arret.
"""),

80 : _("""
   Arret par manque de temps CPU au num�ro d'instant : %(i1)d
      - Temps moyen par %(k1)s : %(r1)f
      - Temps cpu restant      : %(r2)f
   
   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arret.
"""),


82 : _("""
   Arret pour cause de matrice non inversible.
"""),

83 : _("""
   Arret : absence de convergence avec le nombre d'it�rations requis.
"""),

84 : _("""
   Arret par �chec dans le pilotage.
"""),

85 : _("""
   Arret : absence de convergence au num�ro d'instant : %(i1)d
                                  lors de l'it�ration : %(i2)d
"""),

86 : _("""
    Erreur dans la gestion des erreurs. Contactez les d�veloppeurs.
"""),

}
