#@ MODIF mecanonline4 Messages  DATE 21/02/2011   AUTEUR ABBAS M.ABBAS 
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

def _(x) : return x

cata_msg = {

3 : _("""
 Calcul des valeurs propres en grandes d�formations
"""),

5 : _("""
Le fichier pour le SUIVI_DDL doit etre d�fini dans la premi�re occurrence
"""),

6 : _("""
Le fichier pour le SUIVI_DDL a �t� donn� sans unit� logique
"""),

14 : _("""
 Vous utilisez la m�thode CONTINUE pour le traitement du contact et faites une reprise de calcul (mot-cl� REUSE). L'�tat initial de contact sera
 non contactant sauf si vous avez utilis� le mot-cl� CONTACT_INIT.
 Cela peut entra�ner des difficult�s de convergence en pr�sence de fortes non-lin�arit�s. En pr�sence de frottement, la solution peut bifurquer
 diff�remment.
 Conseils :
   Si vous le pouvez, faites votre calcul en une seule fois.
"""),

15 : _("""
 Vous utilisez la m�thode CONTINUE pour le traitement du contact et d�finissez un �tat initial via le mot-cl� ETAT_INIT. L'�tat initial de contact
 sera non-contactant sauf si vous avez utilis� le mot-cl� CONTACT_INIT.
"""),

22 : _("""
 L'etat initial n'appartient pas � un EVOL_NOLI :
 on suppose qu'on part d'un �tat a vitesses nulles
"""),

41 : _("""
 Le champ des d�placements (ou sa d�riv�e pour la sensibilit�) n'a pas �t� trouv� 
 dans le concept EVOL_NOLI de nom <%(k1)s>
"""),

42 : _("""
 Le champ des contraintes (ou sa d�riv�e pour la sensibilit�) n'a pas �t� trouv� 
 dans le concept EVOL_NOLI de nom <%(k1)s>
"""),

43 : _("""
 Le champ des vitesses (ou sa d�riv�e pour la sensibilit�) n'a pas �t� trouv� 
 dans le concept EVOL_NOLI de nom <%(k1)s>
 On suppose qu'on part d'un champ de vitesses nulles.
"""),

44 : _("""
 Le champ des acc�l�rations (ou sa d�riv�e pour la sensibilit�) n'a pas �t� trouv� 
 dans le concept EVOL_NOLI de nom <%(k1)s>
 On calcule un champ d'acc�l�rations initiales, ce qui est possible puisque les vitesses initiales sont nulles
"""),

45 : _("""
 Le champ des acc�l�rations (ou sa d�riv�e pour la sensibilit�) n'a pas �t� trouv� 
 dans le concept EVOL_NOLI de nom <%(k1)s>
 On ne peut pas calculer un champ d'acc�l�rations initiales, car les vitesses initiales ne sont pas nulles
"""),

46 : _("""
 Le champ des variables internes (ou sa d�riv�e pour la sensibilit�) n'a pas �t� trouv� 
 dans le concept EVOL_NOLI de nom <%(k1)s>
"""),

47 : _("""
 Vous faites une reprise de calcul avec PILOTAGE en longueur d'arc et avec l'option ANGL_INCR_DEPL mais il n'y pas assez d'informations dans
 la structure de donn�es r�sultat. Il vous faut en effet au moins les deux derniers champs d�placements solutions.
 Changer l'option de PILOTAGE (utilisez NORM_INCR_DEPL) ou refaites le premier calcul pour enrichir la structure de donn�es r�sultat (modifiez vos options d'ARCHIVAGE).
"""),

}
