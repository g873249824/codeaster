#@ MODIF calculel7 Messages  DATE 24/04/2012   AUTEUR MACOCCO K.MACOCCO 
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


1 : _("""
  pour calculer  %(k1)s  il faut SIEF_NOEU 
"""),

2 : _("""
  option %(k1)s : pour l �l�ment  %(k2)s  il faut ajouter dans le %(k3)s
 le nombre de composante calcul�es du flux
"""),

3: _("""
  Le MODELE doit �tre le m�me pour tous les num�ros d'ordre du RESULTAT.
  Faire le post-traitement en rentrant le num�ro d'ordre ou explicitement
  le nom du mod�le.
"""),

4 : _("""
  Le nombre de couches est limit� � %(i1)d, or vous en avez d�finies %(i2)d !
  Veuillez contacter votre assistance technique.
"""),

5 : _("""
  Pour l'option %(k1)s, le nombre de couches est limit� � 1,
  or vous en avez d�finies %(i1)d !
  Veuillez contacter votre assistance technique.
"""),
}
