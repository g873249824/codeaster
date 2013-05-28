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
# person_in_charge: josselin.delmas at edf.fr

cata_msg={

1: _(u"""
 le fichier IDEAS est vide
 ou ne contient pas de DATASET traite par l'interface
"""),

2: _(u"""
 couleur inconnue
"""),

3: _(u"""
  attention le DATASET 2420 appara�t plusieurs fois.
"""),

4: _(u"""
  attention le DATASET 18 appara�t plusieurs fois.
"""),

5: _(u"""
 groupe  %(k1)s  de longueur sup�rieure � 8 (troncature du nom)
"""),

6: _(u"""
 le nom du groupe est invalide:  %(k1)s  : non trait�
"""),

7: _(u"""
 le nom du groupe  %(k1)s  est tronqu� :  %(k2)s 
"""),

8: _(u"""
 le nom du groupe ne peut commencer par COUL_ : non trait�
"""),

9: _(u"""
  aucun syst�me de coordonn�s n'est d�fini
"""),

10: _(u"""
  attention syst�me de coordonn�es autre que cart�sien non relu dans ASTER.
"""),

11: _(u"""
  attention votre maillage utilise plusieurs syst�mes de coordonn�es
  v�rifiez qu'ils sont tous identiques
  ASTER ne g�re qu'un syst�me de coordonn�es cart�sien unique.
"""),
}
