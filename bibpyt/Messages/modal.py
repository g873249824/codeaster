#@ MODIF modal Messages  DATE 26/02/2013   AUTEUR BOITEAU O.BOITEAU 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
    - la norme de l'erreur est bien valide (via le param�tre VERI_MODE/SEUIL),
    - chaque fr�quence est bien incluse dans la bande sp�cifi�e (VERI_MODE/PREC_SHIFT),
    - le test de Sturm est valide.
"""),
4: _(u"""
Op�rateur MACRO_MODE_MECA
Test de Sturm global demand� (VERI_MODE=_F(STURM='GLOBAL')).
Donc, � l'issu de chaque calcul modal sur une sous-bande, on v�rifie que:
    - la norme de l'erreur est bien valide (via le param�tre VERI_MODE/SEUIL),
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
  On a d�cal� la bande de calcul des modes de PREC_SHIFT=%(r3)f %%.

  Conseils:
    * La bande retenue pour le test de Sturm englobe la bande de calcul. Elle est peut-�tre
      trop grande et donc elle englobe d'autres modes. Vous pouvez la r�duire en diminuant la
      valeur de VERI_MODE/PREC_SHIFT.
    * Vous pouvez relancer le calcul en demandant � faire le test de Sturm de post-v�rification
      sur chaque sous-bande (VERI_MODE=_F(STURM='LOCAL')). Cela peut aider � trouver le probl�me:
      mode multiple saut�, borne trop proche d'un mode multiple, mode de corps rigide...
    * Vous pouvez aussi relancez un INFO_MODE et/ou des MODE_ITER_SIMULT sur une sous-partie pour
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
9: _(u"""
Op�rateur MACRO_MODE_MECA:
  Le nombre de processeurs, %(i1)d, et le nombre de sous-bandes fr�quentielles non vides, %(i2)d,
  sont incompatibles !
  Avec le solveur lin�aire MUMPS, ce nombre de processeurs peut �tre sup�rieur ou �gale
  (id�alement proportionnel) au nombre de sous-bandes.
  Avec les autres solveurs lin�aires ces deux param�tres doivent �tre rigoureusement �gaux.
  Ici le solveur lin�aire utilis� est %(k1)s.
  
  Conseil:
    * Ajuster le nombre de processeurs et/ou la distribution des sous-bandes et/ou
      le solveur lin�aire en cons�quence.
"""),
10: _(u"""
Op�rateur MACRO_MODE_MECA:
  Le nombre de processeurs, %(i1)d, et le nombre de fr�quences, %(i2)d, sont incompatibles !
  Avec le solveur lin�aire MUMPS, ce nombre de processeurs peut �tre sup�rieur ou �gale
  (id�alement proportionnel) au nombre de fr�quences - 1.
  Avec les autres solveurs lin�aires ces deux param�tres doivent �tre rigoureusement �gaux.
  Ici le solveur lin�aire utilis� est %(k1)s.

  Conseil:
    * Ajuster le nombre de processeurs et/ou la distribution des sous-bandes et/ou
      le solveur lin�aire en cons�quence.
"""),
11: _(u"""
Op�rateur MACRO_MODE_MECA:
  Chacune des %(i1)d fr�quences (autre que l'initiale) utilise le solveur lin�aire
  MUMPS sur son propre paquet de processeurs.
  Cependant ces occurrences MUMPS sont parall�lis�es sur un nombre de processeurs
  diff�rent, %(i2)d ou %(i3)d, d'o� un potentiel d�s�quilibre de charge.
  Le temps d'ex�cution du calcul n'est alors probablement pas optimal !  
  
  Conseil:
    * Ajuster le nombre de processeurs et/ou la distribution des sous-bandes 
      en cons�quence. Par exemple, un nombre de processeurs = %(i1)d  x 2, 4 ou 8.
"""),
12: _(u"""
Op�rateur MACRO_MODE_MECA:
  Chacune des %(i1)d sous-bandes fr�quentielles non vides utilise, ind�pendamment des autres,
  le solveur lin�aire parall�le MUMPS.
  Cependant ces occurrences de solveur lin�aires sont parall�lis�es sur un nombre de processeurs
  diff�rent, %(i2)d ou %(i3)d, d'o� un potentiel d�s�quilibre de charge.
  Le temps d'ex�cution du calcul n'est alors probablement pas optimal !  
  
  Conseil:
    * Ajuster le nombre de processeurs et/ou la distribution des sous-bandes 
      en cons�quence. Par exemple, un nombre de processeurs = %(i1)d  x 2, 4 ou 8.
"""),
13: _(u"""
Op�rateur MACRO_MODE_MECA:
  Chacune des 2 fr�quences du test de Sturm de post-v�rification utilise le solveur lin�aire
  MUMPS sur son propre paquet de processeurs.
  Cependant ces occurrences MUMPS sont parall�lis�es sur un nombre de processeurs
  diff�rent, %(i1)d ou %(i2)d, d'o� un potentiel d�s�quilibre de charge.
  Le temps d'ex�cution du calcul n'est alors probablement pas optimal !  
  
  Conseil:
    * Id�alement, le nombre de processeurs devrait �tre pair.
"""),
14: _(u"""
Op�rateur MACRO_MODE_MECA:
  Vous avez demand� la parall�lisation, sur %(i1)d processeurs, de la partie solveur lin�aire
   de votre calcul. Mais vous avez param�tr� un solveur lin�aire s�quentiel: %(k1)s !
  
  Conseils:
    * Lancez votre calcul en s�quentiel,
    * Changez votre solveur lin�aire pour MUMPS (mot-cl� facteur SOLVEUR + METHODE='MUMPS' + 
       plus pour de meilleures performances en modal GESTION_MEMOIRE='IN_CORE' + RENUM='QAMD'),
    * Changez le niveau de parall�lisme (mot-cl� NIVEAU_PARALLELISME='TOTAL').
"""),
}
