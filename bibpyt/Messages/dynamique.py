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
 sch�ma inconnu
"""),

2: _(u"""
 la liste d'instants fournie ne respecte pas la condition de stabilit�.
"""),

3: _(u"""
 la condition de stabilit� n'a pas pu �tre calcul�e pour tous les �l�ments. elle peut �tre trop grande.
"""),

4: _(u"""
  -> La condition de stabilit� n'a pu �tre calcul�e pour aucun �l�ment.
  -> Risque & Conseil :
     Vous prenez le risque de sortir du cadre de la stabilit� conditionnelle du sch�ma de temps explicite. V�rifiez bien
     que vos �l�ments finis ont une taille et un mat�riau (module de Young) compatibles avec le respect de la condition
     de Courant vis-�-vis du pas de temps que vous avez impos� (temps de propagation des ondes dans la maille, voir
     documentation). Si c'est le cas, lever l'arr�t fatal en utilisant l'option "STOP_CFL", � vos risques et p�rils
     (risques de r�sultats faux).
"""),

5: _(u"""
 Pas de temps maximal (condition CFL) pour le sch�ma des diff�rences centr�es : %(r1)g s, sur la maille : %(k1)s
"""),

6: _(u"""
  Pas de temps maximal (condition CFL) pour le sch�ma de Tchamwa-Wilgosz : %(r1)g s, sur la maille : %(k1)s
"""),

7: _(u"""
 Pas de temps maximal (condition CFL) pour le sch�ma des diff�rences centr�es : %(r1)g s
"""),

8: _(u"""
  Pas de temps maximal (condition CFL) pour le sch�ma de Tchamwa-Wilgosz : %(r1)g s
"""),

9: _(u"""
  On ne peut pas avoir plus d'une charge de type FORCE_SOL.
"""),

10: _(u"""
   Arr�t par manque de temps CPU au groupe de pas de temps : %(i1)d
                                 au "petit" pas de temps   : %(i2)d
      - Temps moyen par "petit" pas : %(r1)f
      - Temps CPU restant           : %(r2)f

   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

11: _(u"""
   Arr�t par manque de temps CPU apr�s le calcul de %(i1)d pas.
      - Dernier instant archiv� : %(r1)f
      - Num�ro d'ordre correspondant : %(i2)d
      - Temps moyen pour les %(i3)d pas de temps : %(r2)f
      - Temps CPU restant            : %(r3)f

   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

12: _(u"""
 Dans l\'intervalle : %(i2)d
 Le pas de temps est trop grand : %(r1)f
 le pas de temps maximal est    : %(r2)f

 Avec le pas de temps maximal, le nombre de pas de calcul est %(i1)d
"""),

13: _(u"""
   Arr�t par manque de temps CPU � la fr�quence : %(i1)d
      - Temps moyen par pas fr�quence : %(r1)f
      - Temps CPU restant             : %(r2)f

   La base globale est sauvegard�e. Elle contient les pas archiv�s avant l'arr�t.
"""),

14: _(u"""
   La matrice est presque singuli�re � la fr�quence : %(r1)f
   Cette fr�quence est probablement une fr�quence propre du syst�me.
"""),

15 : _(u"""
 Pas de temps maximal (mot-cl� PAS_MAXI) demand� : %(r1)f plus petit que
 le pas de temps initial demand� par l'utilisateur (mot-cl� PAS) : %(r2)f
 Il faut s'assurer que PAS est bien inf�rieur ou �gal � PAS_MAXI
"""),

16 : _(u"""
 Pas de temps maximal calcul� pour le sch�ma ADAPT : %(r1)f

 Risque & Conseil : la m�thode de calcul automatique de ce pas maximal semble �tre prise en d�faut.
 On recommande donc de d�finir explicitement cette valeur avec le mot-cl� PAS_MAXI (sous INCREMENT).
"""),

17 : _(u"""
 Pas de temps maximal (mot-cl� PAS_MAXI) demand� trop grand :   %(r1)f
 Pas de temps n�cessaire pour le calcul: %(r2)f
 Risques de probl�mes de pr�cision
"""),

18 : _(u"""
 Le nombre maximal de sous division du pas : %(i1)d est atteint � l'instant : %(r1)f
 Le pas de temps vaut alors : %(r2)f
 On continue cependant la r�solution en passant au pas suivant.

 Risque & Conseil : la solution calcul�e risque d'�tre impr�cise.
 Il faudrait relancer la calcul en autorisant le sch�ma ADAPT � utiliser un pas de temps plus petit.
 Pour cela on peut jouer sur au moins un des trois param�tres suivants :
 - diminuer le pas de temps initial (mot-cl� PAS),
 - augmenter le nombre maximal de sous d�coupages du pas (mot-cl� NMAX_ITER_PAS),
 - augmenter le facteur de division du pas (mot-cl� COEF_DIVI_PAS)
"""),

19 : _(u"""
 Le chargement contient plus d'une charge r�partie.
 Le calcul n'est pas possible pour les mod�les de poutre.
"""),

20 : _(u"""
 La fr�quence d'actualisation de FORCE_SOL est prise dans le fichier des raideurs.
"""),

21 : _(u"""
 La fr�quence d'actualisation de FORCE_SOL est prise dans le fichier des masses.
"""),

22 : _(u"""
 La fr�quence d'actualisation de FORCE_SOL est prise dans le fichier des amortissements.
"""),

23 : _(u"""
    Nombre de fr�quences: %(i1)d
    Intervalle des fr�quences: %(r1)f
"""),

30 : _(u"""
 La fr�quence d'actualisation de FORCE_SOL dans le fichier des masses est incoh�rente avec
celle choisie pr�c�demment.
"""),

31 : _(u"""
 La fr�quence d'actualisation de FORCE_SOL dans le fichier des amortissements est incoh�rente avec
celle choisie pr�c�demment.
"""),

25 : _(u"""
 La fr�quence d'actualisation de FORCE_SOL n'est pas coh�rente avec la fr�quence d'archivage des r�sultats dans
 DYNA_NON_LINE.
"""),

}
