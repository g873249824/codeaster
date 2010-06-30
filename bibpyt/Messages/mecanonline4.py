#@ MODIF mecanonline4 Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg = {

3 : _("""
Il y a trop de colonnes de SUIVI_DDL (limit� � quatre)
"""),

5 : _("""
Le fichier pour le SUIVI_DDL doit etre d�fini dans la premi�re occurrence
"""),

6 : _("""
Le fichier pour le SUIVI_DDL a �t� donn� sans unit� logique
"""),

21 : _("""
Le format est trop grand pour la largeur max. d'une colonne (16)
"""),


35 : _("""
 On utilise MECA_NON_LINE en enrichissant les r�sultats (REUSE).
 Mais on ne d�finit pas d'�tat initial: on prend un �tat initial nul.
"""),

37 : _("""
 On ne trouve aucun num�ro d'ordre pour le concept EVOl_NOLI de nom <%(k1)s> 
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

}
