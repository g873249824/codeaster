#@ MODIF test_fichier_ops Macro  DATE 30/03/2004   AUTEUR MCOURTOI M.COURTOIS 
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

def test_fichier_ops(self, FICHIER, NOM_SYSTEME, NB_CHIFFRE, EPSILON, VALE_K, INFO, **args):
   """
     Macro TEST_FICHIER permettant de tester la non-regression d'un fichier
     'a une tolerance' pres pour les nombres reels en calculant
     le md5sum.
   """
   import aster
   from Accas import _F
   ier=0
   # La macro compte pour 1 dans la numerotation des commandes
   #self.icmd=1
   self.set_icmd(1)

   # On importe les definitions des commandes a utiliser dans la macro
   # Le nom de la variable doit etre obligatoirement le nom de la commande
   CREA_TABLE   =self.get_cmd('CREA_TABLE')
   TEST_TABLE   =self.get_cmd('TEST_TABLE')

   import os.path
   from Macro.test_fichier_ops import md5file

   # calcule le md5sum du fichier
   ier, mdsum = md5file(NOM_SYSTEME, NB_CHIFFRE, EPSILON, INFO)
   if ier != 0:
      if ier==4:
         texte_erreur='Fichier inexistant : '+NOM_SYSTEME
      else:
         texte_erreur='Erreur dans md5file, code retour = '+str(ier)
      texte_erreur='<F> <TEST_FICHIER> '+texte_erreur
#      raise aster.FatalError,texte_erreur
      self.cr.fatal(texte_erreur)
      return ier

   # comparaison a la reference
   is_ok=0
   if INFO > 0 :
      print ' %-20s : %32s' % ('REFERENCE',VALE_K)
      print

   if mdsum == VALE_K:
      is_ok=1

   # produit le TEST_TABLE
   __tab1=CREA_TABLE(LISTE=(_F(PARA='TEST',
                               TYPE_K='K8',
                               LISTE_K='VALEUR  ',),
                            _F(PARA='BOOLEEN',
                               LISTE_I=is_ok,),),)
   if args['REFERENCE'] == 'NON_REGRESSION':
      TEST_TABLE(FICHIER=FICHIER,
                 TABLE=__tab1,
                 FILTRE=_F(NOM_PARA='TEST',
                           VALE_K='VALEUR  ',),
                 NOM_PARA='BOOLEEN',
                 VALE_I=1,
                 PRECISION=1.e-3,
                 CRITERE='ABSOLU',
                 REFERENCE=args['REFERENCE'],
                 VERSION=args['VERSION'],)
   else:
      TEST_TABLE(FICHIER=FICHIER,
                 TABLE=__tab1,
                 FILTRE=_F(NOM_PARA='TEST',
                           VALE_K='VALEUR  ',),
                 NOM_PARA='BOOLEEN',
                 VALE_I=1,
                 PRECISION=1.e-3,
                 CRITERE='ABSOLU',
                 REFERENCE=args['REFERENCE'],)
   return ier


def md5file(fich,nbch,epsi,info=0):
   """
   Cette methode retourne le md5sum d'un fichier en arrondissant les nombres
   reels a la valeur significative.
   IN :
      fich  : nom du fichier
      nbch : nombre de decimales significatives
      epsi  : valeur en deca de laquelle on prend 0.
   OUT :
      code retour : 0 si ok, >0 sinon
      md5sum
   """
   import os.path
   import re
   import string
   import math
   import md5
   #      1 Mo   10 Mo   100 Mo
   # v0   2.6 s  20.4 s  196.6 s
   # v1   2.0 s  10.3 s  94.9 s (pas de distinction entier/reel)
   # remplacer le try/except par if re.search(...), 80% plus lent
   if not os.path.isfile(fich):
      return 4, ''
   f=open(fich,'r')
   format_float='%'+str(nbch+7)+'.'+str(nbch)+'g'
   m=md5.new()
   i=0
   for ligne in f.xreadlines():
#python2.3   for ligne in f:
      i=i+1
      # pour decouper 123E+987-1.2345
   #    r=re.split(' +|([0-9]+)\-+',ligne)
      r=string.split(ligne)
      for x in r:
         try:
            if abs(float(x))<epsi:
               s='0'
            else:
               s=format_float % float(x)
         except ValueError:
            s=x
         if info>=2:
            print 'LIGNE',i,'VALEUR RETENUE',s
         m.update(s)
   f.close()
   md5sum=m.hexdigest()
   if info>=1:
      form=' %-20s : %32s'
      print form % ('Fichier',fich)
      print form % ('Nombre de lignes',str(i))
      print form % ('Format des reels',format_float)
      print form % ('Epsilon',str(epsi))
      print form % ('md5sum',md5sum)
   return 0, md5sum
