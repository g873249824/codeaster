#@ MODIF impr_table_ops Macro  DATE 30/11/2004   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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

# RESPONSABLE MCOURTOI M.COURTOIS

import os.path
import re

from types import ListType, TupleType, StringTypes
EnumTypes=(ListType, TupleType)


# ------------------------------------------------------------------------------
def impr_table_ops(self, FORMAT, TABLE, INFO, **args):
   """
   Macro IMPR_TABLE permettant d'imprimer une table dans un fichier.
   Erreurs<S> dans IMPR_TABLE pour ne pas perdre la base.
   """
   macro='IMPR_TABLE'
   import aster
   from Accas import _F
   from Cata.cata import table_jeveux
   from Utilitai.Utmess import UTMESS
   ier=0
   # La macro compte pour 1 dans la numerotation des commandes
   self.set_icmd(1)

   # On importe les definitions des commandes a utiliser dans la macro
   # Le nom de la variable doit etre obligatoirement le nom de la commande
   DETRUIRE         = self.get_cmd('DETRUIRE')
   DEFI_FICHIER     = self.get_cmd('DEFI_FICHIER')
   RECU_FONCTION    = self.get_cmd('RECU_FONCTION')

   #----------------------------------------------
   # 0. Traitement des arguments, initialisations
   # unit� logique des fichiers r�serv�s
   ul_reserve=(8,)

   # 0.1. Fichier
   nomfich=None
   if args['UNITE'] and args['UNITE']<>6:
      nomfich='fort.'+str(args['UNITE'])
   if nomfich and os.path.exists(nomfich):
      if FORMAT=='XMGRACE':
         UTMESS('A',macro,'Le fichier '+nomfich+' existe d�j�, on �crit ' \
                '� la suite.')

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

   # 0.3. Cr�ation de la liste des tables (une seule sans SENSIBILITE)
   form_sens='\n... SENSIBILITE AU PARAMETRE %s'
   ltab=[]
   if args['SENSIBILITE']:
      nmemo='&NOSENSI.MEMO.CORR'.ljust(24)
      vect=aster.getvectjev(nmemo)
      if vect:
         lps=args['SENSIBILITE']
         if not type(lps) in EnumTypes:
            lps=[lps,]
         for ps in [ps.get_name() for ps in lps]:
            trouv=False
            for ch in vect[0:len(vect):2]:
               if ch[0:8].strip()==TABLE.get_name() and ch[8:16].strip()==ps:
                  trouv=True
                  ncomp=ch[16:24].strip()
                  sdtab=table_jeveux(ncomp)
                  tabs=sdtab.EXTR_TABLE()
                  tabs.titr+=form_sens % ps
                  ltab.append([tabs, sdtab])
            if not trouv:
               UTMESS('A',macro,'D�riv�e de %s par rapport � %s non disponible'\
                     % (TABLE.get_name(), ps))
      else:
         UTMESS('A',macro,'Pas de calcul de sensibilit� accessible.')
   else:
      ltab.append([TABLE.EXTR_TABLE(), TABLE])

   if len(ltab)<1:
      return ier

   # 0.4.1. liste des param�tres � conserver
   nom_para=ltab[0][0].para
   if args['NOM_PARA']:
      nom_para=args['NOM_PARA']

   # 0.4.2. Traiter le cas des UL r�serv�es
   if args['UNITE'] and args['UNITE'] in ul_reserve:
      DEFI_FICHIER( ACTION='LIBERER', UNITE=args['UNITE'], )

   #----------------------------------------------
   # Boucle sur les tables
   for tab, sdtab in ltab:

      # ----- 1. Infos de base
      if INFO==2:
         print 'IMPRESSION DE LA TABLE : %s' % sdtab.get_name()

      if args['TITRE']:
         tab.titr=args['TITRE'] + '\n' + tab.titr

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
      timp=tab[nom_para]
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

      # 4.1. au format AGRAF
      if FORMAT=='AGRAF':
         kargs['dform']={ 'formR' : '%12.5E' }
         kfonc['FORMAT']='TABLEAU'
      
      # 4.2. au format XMGRACE et d�riv�s
      elif FORMAT=='XMGRACE':
         kargs['dform']={ 'formR' : '%.8g' }
         kargs['PILOTE']=args['PILOTE']
         kfonc['PILOTE']=args['PILOTE']

      # 4.3. format sp�cifi� dans les arguments
      if args['FORMAT_R']:
         kargs['dform'].update({ 'formR' : fmtF2PY(args['FORMAT_R']) })

      # 4.4. regroupement par param�tre : PAGINATION
      if args['PAGINATION']:
         kargs['PAGINATION']=args['PAGINATION']

      timp.Impr(**kargs)

      # ----- 5. IMPR_FONCTION='OUI'
      if args['IMPR_FONCTION'] and args['IMPR_FONCTION']=='OUI':
         # cherche parmi les cellules celles qui contiennent un nom de fonction
         dfon={}
         for row in timp:
            for par,cell in row.items():
               if type(cell) in StringTypes:
                if aster.getvectjev(cell.strip().ljust(19)+'.PROL')<>None:
                  dfon[cell.strip().ljust(19)]=par
         # impression des fonctions trouv�es
         for f,par in dfon.items():
            __fonc=RECU_FONCTION(
               TABLE=sdtab,
               FILTRE=_F(
                  NOM_PARA=par,
                  VALE_K=f,
               ),
               NOM_PARA_TABL=par,
            )
            __fonc.Trace(**kfonc)
            DETRUIRE(CONCEPT=_F(NOM=('__fonc',),), ALARME='NON', INFO=1,)

   # 99. Traiter le cas des UL r�serv�es
   if args['UNITE'] and args['UNITE'] in ul_reserve:
      DEFI_FICHIER( ACTION='ASSOCIER', UNITE=args['UNITE'],
            TYPE='ASCII', ACCES='APPEND' )

   return ier

# ------------------------------------------------------------------------------
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
