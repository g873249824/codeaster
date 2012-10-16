#@ MODIF modal Messages  DATE 16/10/2012   AUTEUR ALARCON A.ALARCON 
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

cata_msg={

1: _(u"""
Arr�t du calcul des modes : pas de mode propre dans la bande de fr�quence demand�e.
"""),
2: _(u"""
Op�rateur MACRO_MODE_MECA
Pas de test de Sturm demand� (VERI_MODE=_F(STURM='NON')).
Donc, � l'issu de chaque calcul modal sur une sous-bande, on v�rifie seulement que:
   - la norme de l'erreur est bien valide (via le param�tre VERI_MODE/SEUIL),
   - chaque fr�quence est bien incluse dans la bande sp�cifi�e (VERI_MODE/PREC_SHIFT).
Pas de test de Sturm local ou global.
"""),
3: _(u"""
Op�rateur MACRO_MODE_MECA
Test de Sturm local demand� (VERI_MODE=_F(STURM='LOCAL')).
Donc, � l'issu de chaque calcul modal sur une sous-bande, on v�rifie que:
    - la norme de l'erreur est bien valide (via le param�tre param�tre VERI_MODE/SEUIL),
    - chaque fr�quence est bien incluse dans la bande sp�cifi�e (VERI_MODE/PREC_SHIFT),
    - le test de Sturm est valide.
"""),
4: _(u"""
Op�rateur MACRO_MODE_MECA
Test de Sturm global demand� (VERI_MODE=_F(STURM='GLOBAL')).
Donc, � l'issu de chaque calcul modal sur une sous-bande, on v�rifie que:
    - la norme de l'erreur est bien valide (via le param�tre param�tre VERI_MODE/SEUIL),
    - chaque fr�quence est bien incluse dans la bande sp�cifi�e (VERI_MODE/PREC_SHIFT),
    - pas de test de Sturm local.
Puis, on r�unit les fr�quences calcul�es sur toutes les sous-bandes et on fait un test
de Sturm global:
  Dans l'intervalle (%(r1)f,%(r2)f), il y a th�oriquement %(i1)d fr�quence(s) et on
  en a bien calcul� %(i2)d.
"""),
5: _(u"""
Op�rateur MACRO_MODE_MECA, test de Sturm global:
  Dans l'intervalle (%(r1)f,%(r2)f), il y a th�oriquement %(i1)d fr�quence(s) et on
  en a calcul� %(i2)d.

Conseil:
Vous pouvez relancer le calcul en demandant � faire le test de Sturm de post-v�rification
sur chaque sous-bande (VERI_MODE=_F(STURM='LOCAL')). Cela peut aider � trouver le probl�me:
mode multiple saut�, borne trop proche d'un mode multiple, mode de corps rigide...
Vous pouvez aussi relancez un INFO_MODE et/ou des MODE_ITER_SIMULT sur une sous-partie pour
corroborer (ou non) les r�sultats pr�c�dent.
"""),
6: _(u"""
Op�rateur MACRO_MODE_MECA, la sous-bande n %(i1)d est vide, on passe � la suivante.
"""),
7: _(u"""
Op�rateur MACRO_MODE_MECA: Test de Sturm global.
  On n'a pas pu faire ce test car la bande de fr�quence demand�e (%(r1)f,%(r2)f) est vide !
"""),
8: _(u"""
Op�rateur MACRO_MODE_MECA:
  Pas de mode propre dans la bande de fr�quence demand�e (%(r1)f,%(r2)f) !
  Le concept r�sultat sera vide.
"""),
}
