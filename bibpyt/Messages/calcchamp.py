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
# person_in_charge: nicolas.sellenet at edf.fr

cata_msg = {

1 : _(u"""
 Le champ %(k1)s est d�j� pr�sent dans la structure de donn�es
 � tous les instants demand�s.
 Aucun calcul ne sera donc r�alis� pour cette option.

Conseil :
 Si vous souhaitez r�ellement calculer � nouveau cette option,
 cr�ez une nouvelle structure de donn�es.
"""),

2 : _(u"""
 L'option %(k1)s n�cessaire au calcul de l'option %(k2)s est
 manquante dans les structures de donn�es r�sultat %(k3)s et
 %(k4)s pour le num�ro d'ordre %(i1)d.
 
 Le calcul de cette option n'est donc pas possible.
 L'option demand�e n'est calculable sur les �l�ments du mod�le.
"""),

}
