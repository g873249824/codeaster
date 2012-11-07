#@ MODIF observation Messages  DATE 07/11/2012   AUTEUR LADIER A.LADIER 
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
# RESPONSABLE DELMAS J.DELMAS


def _(x) : return x

cata_msg = {

5 : _("""
On ne peut faire plus de %(i1)d SUIVI_DDL.
Le nombre de SUIVI_DDL permis d�pend de l'affichage du tableau de convergence et donc des fonctionnalit�s activ�es.
"""),

6 : _("""
 Erreur dans les donn�es d'observation
 pour "NOM_CHAM"  %(k1)s , il faut renseigner  %(k2)s ou  %(k3)s 
"""),


8 : _("""
 Variation de la d�formation sup�rieure au seuil fix� :
    seuil en valeur relative : %(r1)f
    entite : %(k1)s
    composante : %(k2)s
    num�ro ordre : %(i1)d
"""),

37 : _("""
  %(i1)d observations r�alis�es pour ce pas de temps
"""),



}
