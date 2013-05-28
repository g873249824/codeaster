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
 Cas fluides multiples : pr�cisez le GROUP_MA dans lequel vous affectez la masse volumique RHO.
"""),

2: _(u"""
 PRES_FLUIDE obligatoire une fois.
"""),

3: _(u"""
 Amortissement ajout� sur mod�le g�n�ralis� non encore implant�.
"""),

4: _(u"""
 Rigidit� ajout� sur mod�le g�n�ralis� non encore implant�.
"""),

5: _(u"""
 La construction d'un nouveau concept NUME_DDL ne peut se faire qu'en pr�sence du mot cl� MATR_ASSE avec une des options
 suivantes: RIGI_MECA, RIGI_THER, RIGI_ACOU ou RIGI_FLUI_STRU.
 Attention: si vous cherchez � assembler des vecteurs seulement, le concept NUME_DDL doit �tre construit pr�alablement. 
"""),

6: _(u"""
  Attention: le mot-cl� CHARGE d�finissant les conditions de Dirichlet n'a pas �t� renseign�. 
  Pour l'assemblage d'un vecteur selon une num�rotation impos�e (NUME_DDL), le mot-cl� CHARGE 
  doit �tre renseign� � l'identique que lors de la cr�ation du NUME_DDL, sous risque d'assemblage erron�. 
  Cependant, si votre mod�le ne contient aucune condition de Dirichlet votre syntaxe est correcte.
"""),

7: _(u"""
  Le mot-cl� CHAM_MATER est obligatoire pour la construction d'un vecteur assembl� avec l'option CHAR_ACOU. 
"""),

8: _(u"""
  Pour la construction d'un vecteur assembl� il faut renseigner au moins une charge.
"""),

9: _(u"""
 Une des options doit �tre RIGI_MECA ou RIGI_THER ou RIGI_ACOU ou RIGI_FLUI_STRU.
"""),

10: _(u"""
 Pour calculer RIGI_MECA_HYST, il faut avoir calcul� RIGI_MECA auparavant (dans le m�me appel).
"""),

11: _(u"""
 Pour calculer AMOR_MECA, il faut avoir calcul� RIGI_MECA et MASS_MECA auparavant (dans le m�me appel).
"""),

12: _(u"""
 Une des charges renseign�es pour l'assemblage des vecteurs est d�j� pr�sente dans le mot-cl� 
 CHARGE d�finissant les conditions de Dirichlet. Il est interdit de renseigner plus d'une fois la m�me charge.
"""),

13: _(u"""
La num�rotation g�n�ralis�e retenue pour la construction des
matrices ne fait pas r�f�rence au mod�le g�n�ralis�. Si vous essayez de
construire une matrice g�n�ralis�e � partir d'une matrice assembl�e et 
d'une base, il faut utiliser la commande PROJ_BASE.
"""),


}
