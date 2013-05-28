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

# person_in_charge: mathieu.courtois at edf.fr

import os.path
import re


def impr_table_ops(self, FORMAT, TABLE, INFO, **args):
   """
   Macro IMPR_TABLE permettant d'imprimer une table dans un fichier.
   Erreurs<S> dans IMPR_TABLE pour ne pas perdre la base.
   """
   macro='IMPR_TABLE'
   import aster
   from Accas import _F
   from Cata.cata import table_jeveux
   from Utilitai.Utmess  import  UTMESS
   from Utilitai.UniteAster import UniteAster
   ier=0
   # La macro compte pour 1 dans la numerotation des commandes
   self.set_icmd(1)

   # On importe les definitions des commandes a utiliser dans la macro
   # Le nom de la variable doit etre obligatoirement le nom de la commande
   DETRUIRE         = self.get_cmd('DETRUIRE')
   RECU_FONCTION    = self.get_cmd('RECU_FONCTION')

   #----------------------------------------------
   # 0. Traitement des arguments, initialisations
   # unit� logique des fichiers r�serv�s
   ul_reserve=(8,)
   UL = UniteAster()

   # 0.1. Fichier
   nomfich=None
   if args['UNITE'] and args['UNITE']<>6:
      nomfich=UL.Nom(args['UNITE'])
   if nomfich and os.path.exists(nomfich) and os.stat(nomfich).st_size<>0:
      if FORMAT=='XMGRACE':
         UTMESS('A','TABLE0_6',valk=nomfich)

   # 0.2. Cr�ation des dictionnaires des FILTRES
   Filtre=[]
   if args['FILTRE']:
      for Fi in args['FILTRE']:
         dF = Fi.cree_dict_valeurs(Fi.mc_liste)
         for mc in dF.keys():
            if dF[mc]==None: del dF[mc]
         Filtre.append(dF)
   # format pour l'impression des filtres
   form_filtre='\nFILTRE -> NOM_PARA: %-16s CRIT_COMP: %-4s VALE: %s'

   # 0.3. Cr�ation de la liste des tables
   # on conserve la liste m�me si aujourd'hui, on n'en imprime qu'une � la fois
   ltab=[[TABLE.EXTR_TABLE(), TABLE]]

   # 0.4.1. liste des param�tres � conserver
   nom_para=ltab[0][0].para
   if args['NOM_PARA']:
      nom_para=args['NOM_PARA']
   if not type(nom_para) in (list, tuple):
      nom_para=[nom_para,]

   # 0.4.2. Traiter le cas des UL r�serv�es
   if args['UNITE'] and args['UNITE'] in ul_reserve:
      UL.Etat(args['UNITE'], etat='F')

   #----------------------------------------------
   # Boucle sur les tables
   for tab, sdtab in ltab:

      # ----- 1. Infos de base
      if INFO==2:
         print 'IMPRESSION DE LA TABLE : %s' % sdtab.get_name()

      if args['TITRE']:
         tab.titr=os.linesep.join(args['TITRE'] + (tab.titr, ))

      # ----- 2. Filtres
      for Fi in Filtre:
         col = getattr(tab, Fi['NOM_PARA'])
         # peu importe le type
         opts=[Fi[k] for k in ('VALE','VALE_I','VALE_C','VALE_K') if Fi.has_key(k)]
         kargs={}
         for k in ('CRITERE','PRECISION'):
            if Fi.has_key(k):
               kargs[k]=Fi[k]
         tab = tab & ( getattr(col, Fi['CRIT_COMP'])(*opts,**kargs) )
         # trace l'operation dans le titre
         #if FORMAT in ('TABLEAU','ASTER'):
         tab.titr+=form_filtre % (Fi['NOM_PARA'], Fi['CRIT_COMP'], \
               ' '.join([str(v) for v in opts]))

      # ----- 3. Tris
      if args['TRI']:
         # une seule occurence de TRI
         T0=args['TRI'][0]
         dT=T0.cree_dict_valeurs(T0.mc_liste)
         tab.sort(CLES=dT['NOM_PARA'], ORDRE=dT['ORDRE'])

      # ----- 4. Impression
      # v�rification des param�tres
      for p in nom_para:
         if not p in tab.para:
           UTMESS('A','TABLE0_7',valk=p)

      # s�lection des param�tres et suppression des colonnes vides
      timp = tab.SansColonneVide(nom_para)

      # passage des mots-cl�s de mise en forme � la m�thode Impr
      kargs=args.copy()
      kargs.update({
         'FORMAT'    : FORMAT,
         'FICHIER'   : nomfich,
         'dform'     : {},
      })
      # pour l'impression des fonctions
      kfonc={
         'FORMAT'    : FORMAT,
         'FICHIER'   : nomfich,
      }

      # 4.1. au format TABLEAU
      if FORMAT=='TABLEAU':
         # surcharge par les formats de l'utilisateur
         kargs['dform']={
            'csep'   : args['SEPARATEUR'],
            'ccom'   : args['COMMENTAIRE'],
            'ccpara' : args['COMM_PARA'],
            'cdeb'   : args['DEBUT_LIGNE'],
            'cfin'   : args['FIN_LIGNE'],
         }

      # 4.2. au format AGRAF
      elif FORMAT=='AGRAF':
         kargs['dform']={ 'formR' : '%12.5E' }
         kfonc['FORMAT']='TABLEAU'

      # 4.3. au format XMGRACE et d�riv�s
      elif FORMAT=='XMGRACE':
         kargs['dform']={ 'formR' : '%.8g' }
         kargs['PILOTE']=args['PILOTE']
         kfonc['PILOTE']=args['PILOTE']

      # 4.4. format sp�cifi� dans les arguments
      if args['FORMAT_R']:
         kargs['dform'].update({ 'formR' : fmtF2PY(args['FORMAT_R']) })

      # 4.5. regroupement par param�tre : PAGINATION
      if args['PAGINATION']:
         l_ppag=args['PAGINATION']
         if not type(l_ppag) in (list, tuple):
            l_ppag=[l_ppag,]
         kargs['PAGINATION'] = [p for p in l_ppag if p in nom_para]
         l_para_err          = [p for p in l_ppag if not p in nom_para]
         if len(l_para_err)>0:
             UTMESS('A','TABLE0_8',valk=l_para_err)

      timp.Impr(**kargs)

      # ----- 5. IMPR_FONCTION='OUI'
      if args['IMPR_FONCTION'] == 'OUI':
         # cherche parmi les cellules celles qui contiennent un nom de fonction
         dfon = []
         p_extr = set(['FONCTION', 'FONCTION_C'])
         p_extr.intersection_update(timp.para)
         if len(p_extr) > 0:
            # on r�duit timp aux colonnes FONCTION et FONCTION_C
            textr = timp.__getitem__(list(p_extr))
            for row in textr:
               for par,cell in row.items():
                  if type(cell) in (str, unicode):
                     cell = cell.strip()
                     if aster.getvectjev('%-19s.PROL' % cell) != None:
                        dfon.append(['%-19s' % cell, par])
            # impression des fonctions trouv�es
            for f,par in dfon:
               __fonc=RECU_FONCTION(
                  TABLE=sdtab,
                  FILTRE=_F(
                     NOM_PARA=par,
                     VALE_K=f,
                  ),
                  NOM_PARA_TABL=par,
                  TITRE = 'Fonction %s' % f,
               )
               __fonc.Trace(**kfonc)
               DETRUIRE(CONCEPT=_F(NOM=(__fonc,),), INFO=1,)

   # 99. Traiter le cas des UL r�serv�es
   UL.EtatInit()
   return ier


def fmtF2PY(fformat):
   """Convertit un format Fortran en format Python (printf style).
   G�re uniquement les fortrans r�els, par exemple : E12.5, 1PE13.6, D12.5...
   """
   fmt=''
   matP=re.search('([0-9]+)P',fformat)
   if matP:
      fmt+=' '*int(matP.group(1))
   matR=re.search('([eEdDfFgG]{1})([\.0-9]+)',fformat)
   if matR:
      fmt+='%'+matR.group(2)+re.sub('[dD]+','E',matR.group(1))
   try:
      s=fmt % -0.123
   except (ValueError, TypeError), msg:
      fmt='%12.5E'
      print 'Error :',msg
      print 'Format par d�faut utilis� :',fmt
   return fmt
