#@ MODIF etatinit Messages  DATE 21/02/2011   AUTEUR ABBAS M.ABBAS 
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

def _(x) : return x

cata_msg = {

1 : _("""
 On utilise l'op�rateur en enrichissant les r�sultats (REUSE).
 Mais on ne d�finit pas d'�tat initial: on prend un �tat initial nul.
"""),

2 : _("""
 On ne trouve aucun num�ro d'ordre dans la structure de donn�es r�sultat de nom <%(k1)s> 
"""),

3 : _("""
 L'instant sp�cifi� sous ETAT_INIT/INST n'est pas trouv� dans la structure de donn�es r�sultat de nom <%(k1)s>.
"""),

4 : _("""
 Il y a plusieurs instants dans la structure de donn�es r�sultat de nom <%(k1)s> qui correspondent � celui sp�cifi� sous ETAT_INIT/INIT.
"""),

}
