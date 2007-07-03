#@ MODIF subdivise Messages  DATE 02/07/2007   AUTEUR FLEJOU J-L.FLEJOU 
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
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

# Pour la m�thode de subdivision

cata_msg={

# Plus de messages pour d�veloppeur ==> ASSERT

# Messages utilisateurs
10: _("""Le nombre d'it�ration autoris�e est atteint. La m�thode de subdivision ne peut
pas faire d'extrapolation. La subdivision UNIFORME est d�clanch�e.
Cela peut etre du � une oscillation de l'erreur ou � une divergence.
   Nombre d'intervalle             = <%(i1)d>
   Niveau de subdivision           = <%(i2)d>
   Ratio sur le premier intervalle = <%(r1)E>
   Pas de Temps actuel             = <%(r2)E>"""),

11: _("""La m�thode de subdivision ne peut pas faire d'extrapolation.
Il n'y a pas de convergence et la m�thode de subdivision trouve un nombre
d'it�ration � convergence < au nombre donn� sous le mot cl� CONVERGENCE.
La subdivision UNIFORME est d�clanch�e.
   Nombre d'intervalle             = <%(i1)d>
   Niveau de subdivision           = <%(i2)d>
   Ratio sur le premier intervalle = <%(r1)E>
   Pas de Temps actuel             = <%(r2)E>"""),

12: _("""Le nombre maximal de niveau de subdivision est atteint.
      SUBD_NIVEAU doit etre >= <%(i1)d>
      SUBD_NIVEAU est de     = <%(i2)d>
Conseil :
   Augmenter SUBD_NIVEAU. Il est �galement possible d'ajuster SUBD_PAS_MINI pour
   imposer un incr�ment de temps en-dessous duquel on ne peut plus subdiviser.
   Si les 2 mots clefs SUBD_NIVEAU et SUBD_PAS_MINI sont utilis�s la subdivision
   s'arrete d�s que l'un des 2 crit�res est v�rifi�."""),

13: _("""M�thode de subdivision : %(k1)s"""),

14: _("""La subdivision est forc�e, m�thode UNIFORME.
   Nombre d'intervalle             = <%(i1)d>
   Niveau de subdivision           = <%(i2)d>
   Ratio sur le premier intervalle = <%(r1)E>
   Pas de Temps actuel             = <%(r2)E>"""),

15: _("""Le pas minimal de la subdivision est atteint.
   Pas de Temps actuel          = <%(r1)E>
   Pas de Temps minimum impos�  = <%(r2)E>
   Niveau de subdivision        = <%(i1)d>
   M�thode de subdivision       = <%(k1)s>
Conseil :
   Diminuer SUBD_PAS_MINI. Il est �galement possible d'ajuster SUBD_NIVEAU pour
   indiquer le nombre successif de subdivision d'un pas de temps.
   Si les 2 mots clefs SUBD_NIVEAU et SUBD_PAS_MINI sont utilis�s la subdivision
   s'arrete d�s que l'un des 2 crit�res est v�rifi�."""),

16: _("""M�thode extrapolation, convergence pr�vue en %(i1)d iterations pour un maximum
d'it�rations autoris� de %(i2)d."""),

17: _("""It�ration n %(i1)d, poursuite autoris�e."""),

18: _("""Subdivision du pas de temps en %(i1)d intervalles. Le ratio sur le premier
intervalle est de %(r1)e.
   Niveau de subdivision = <%(i2)d>
   Pas de Temps actuel   = <%(r2)E>"""),

}
