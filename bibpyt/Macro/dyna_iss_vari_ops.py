#@ MODIF dyna_iss_vari_ops Macro  DATE 16/11/2009   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
from Accas import _F
import string

def dyna_iss_vari_ops(self, NOM_CMP, PRECISION, INTERF,MATR_COHE, FREQ_INIT,UNITE_RESU_FORC,
                       NB_FREQ, PAS, UNITE_RESU_IMPE, TYPE, MATR_GENE , OPTION,INFO,
                         **args):
   """
      Macro DYNA_ISS_VARI
   """
   ier=0
   import Numeric as Num
   import LinearAlgebra as LinAl
   import MLab
   import os
   import aster
   diag = MLab.diag
   max = MLab.max
   min = MLab.min
   sum = Num.sum
   abs = Num.absolute
   conj = Num.conjugate
   from Utilitai.Table import Table
   from Utilitai.Utmess import  UTMESS

   def get_group_coord(group):
      """Retourne les coordonnees des noeuds du groupe 'group'
      """
      l_ind = Num.array(coll_grno.get('%-8s' % group, [])) - 1
      return Num.take(t_coordo, l_ind)


   # On importe les definitions des commandes a utiliser dans la macro

   COMB_MATR_ASSE = self.get_cmd('COMB_MATR_ASSE')
   LIRE_IMPE_MISS = self.get_cmd('LIRE_IMPE_MISS')
   LIRE_FORC_MISS = self.get_cmd('LIRE_FORC_MISS')
   COMB_MATR_ASSE = self.get_cmd('COMB_MATR_ASSE')   

   CREA_CHAMP = self.get_cmd('CREA_CHAMP')   
   DYNA_LINE_HARM = self.get_cmd('DYNA_LINE_HARM')   
   DETRUIRE= self.get_cmd('DETRUIRE')   

   DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
   CREA_TABLE     = self.get_cmd('CREA_TABLE')

   # Comptage commandes + declaration concept sortant
   self.set_icmd(1)
   self.DeclareOut('tab_out', self.sd)
   macro='DYNA_ISS_VARI'
#--------------------------------------------------------
   dgene = MATR_GENE[0].cree_dict_valeurs(MATR_GENE[0].mc_liste)
   if dgene['MATR_AMOR'] != None:
     aster.affiche('MESSAGE',' MATR_AMOR existe')
     __ma_amort = MATR_GENE['MATR_AMOR']
   else:         
     __ma_amort=COMB_MATR_ASSE(CALC_AMOR_GENE=_F(MASS_GENE = MATR_GENE['MATR_MASS'] ,
                                        RIGI_GENE = MATR_GENE['MATR_RIGI'] ,                                       
                                        AMOR_REDUIT= (  0.0,),
                                         ),                               
                                  );
     aster.affiche('MESSAGE',' MATR_AMOR pas donnee, on prend AMOR_REDUIT=0.0,')
#   dint = INTERF[0].cree_dict_valeurs(INTERF[0].mc_liste)
#   dcoh = MATR_COHE[0].cree_dict_valeurs(MATR_COHE[0].mc_liste)
   
   from SD.sd_maillage      import sd_maillage
   from SD.sd_nume_ddl_gd   import sd_nume_ddl_gd    
   from SD.sd_nume_ddl_gene import sd_nume_ddl_gene    
   from SD.sd_mode_meca import sd_mode_meca 
   from SD.sd_resultat import sd_resultat
   from SD.sd_cham_gene import sd_cham_gene

   v_refa_rigi = MATR_GENE['MATR_RIGI'].REFA.get()
   v_refa_mass = MATR_GENE['MATR_MASS'].REFA.get()
   # MAILLAGE
   nom_bamo = v_refa_rigi[0]
   nume_ddl = aster.getvectjev(nom_bamo[0:8] + '           .REFD        ' )[3]
   nom_mail = aster.getvectjev( nume_ddl[0:19] + '.REFN        ' )[0] 
   maillage = sd_maillage(nom_mail)
   # MODELE, DDLGENE
   nom_ddlgene = v_refa_rigi[1]  
   nom_modele = aster.getvectjev( nume_ddl[0:19] + '.LILI        ' )[1]   
   resultat = self.get_concept(nom_bamo)
   nume_ddlgene = self.get_concept(nom_ddlgene)
   modele = self.get_concept(nom_modele[0:8])

   #TEST base modale
   nom_bamo2 = v_refa_mass[0]
   if nom_bamo.strip() != nom_bamo2.strip():
      UTMESS('F','ALGORITH5_42')
   
   nbnot, nbl, nbma, nbsm, nbsmx, dime = maillage.DIME.get()

   # coordonnees des noeuds
   l_coordo = maillage.COORDO.VALE.get()
   t_coordo = Num.array(l_coordo)
   t_coordo.shape = nbnot, 3
   # groupes de noeuds
   coll_grno = maillage.GROUPENO.get()
   GROUP_NO_INTER=INTERF['GROUP_NO_INTERF']
   noe_interf = get_group_coord(GROUP_NO_INTER)
   #  print noe_interf  
   nbno, nbval = noe_interf.shape
   if INFO==2:
      aster.affiche('MESSAGE','NBNO INTERFACE : '+str(nbno))
  # MODES
   iret,nbmodt,kbid=aster.dismoi('F','NB_MODES_TOT',nom_bamo,'RESULTAT')
   iret,nbmodd,kbid=aster.dismoi('F','NB_MODES_DYN',nom_bamo,'RESULTAT')
   iret,nbmods,kbid=aster.dismoi('F','NB_MODES_STA',nom_bamo,'RESULTAT')

   nbmodt2 = MATR_GENE['MATR_RIGI'].DESC.get()[1]
   if nbmodt2 != nbmodt:
       UTMESS('F','ALGORITH5_42')

   if INFO==2:
      texte = 'NOMBRE DE MODES: '+str(nbmodt)+'   MODES DYNAMIQUES: '+str(nbmodd)+'   MODES STATIQUES: '+str(nbmods)
      aster.affiche('MESSAGE',texte)
      aster.affiche('MESSAGE','COMPOSANTE '+NOM_CMP)
   SPEC = Num.zeros((NB_FREQ,nbmodt,nbmodt), Num.Float)+1j
#
#---------------------------------------------------------------------
  # BOUCLE SUR LES FREQUENCES
   VITE_ONDE = MATR_COHE['VITE_ONDE']
   alpha = MATR_COHE['PARA_ALPHA']
   abscisse = [None]*NB_FREQ

   for k in range(0,NB_FREQ):
      freqk=FREQ_INIT+PAS*k
      aster.affiche('MESSAGE','FREQUENCE DE CALCUL: '+str(freqk))

      # Matrice de coherence                  
      XX=noe_interf[:,0]
      YY=noe_interf[:,1]

      XN=Num.repeat(XX,nbno)
      YN=Num.repeat(YY,nbno)
      XR=Num.reshape(XN,(nbno,nbno))
      YR=Num.reshape(YN,(nbno,nbno))
      XRT=Num.transpose(XR)
      YRT=Num.transpose(YR)
      DX=XR-XRT
      DY=YR-YRT
      DIST=DX**2+DY**2
      COHE=Num.exp(-(DIST*(alpha*freqk/VITE_ONDE)**2.))
      
      # On desactive temporairement les FPE qui pourraient etre generees (a tord!) par blas
      aster.matfpe(-1)
      eig, vec =LinAl.eigenvectors(COHE)
      aster.matfpe(1)
      eig=eig.real
      vec=vec.real
      # on rearrange selon un ordre decroissant
      eig = Num.where(eig < 1.E-10, 0.0, eig)
      order = (Num.argsort(eig)[::-1])
      eig = Num.take(eig, order)
      vec = Num.take(vec, order, 0)

      #-----------------------
      # Nombre de modes POD a retenir
      etot=sum(diag(COHE))
      ener=0.0
      nbme=0
 
      if INFO==2:
         aster.affiche('MESSAGE','ETOT :'+str(etot))
      while nbme < nbno:
         ener= eig[nbme]+ener
         prec=ener/etot
         nbme=nbme+1
         if INFO==2:
            aster.affiche('MESSAGE','VALEUR PROPRE  '+str(nbme)+' : '+str(eig[nbme-1]))
         if prec > PRECISION :
            break

      aster.affiche('MESSAGE','NOMBRE DE MODES POD RETENUS : '+str(nbme))
      aster.affiche('MESSAGE','PRECISION (ENERGIE RETENUE) : '+str(prec))      

      PVEC=Num.zeros((nbme,nbno), Num.Float)
      for k1 in range(0,nbme):
         PVEC[k1, 0:nbno]=Num.sqrt(eig[k1])*vec[k1] 
      # CALCUL DE FS variable-------------------------------
      XO=Num.zeros((nbme,nbmods), Num.Float)
      if NOM_CMP=='DX':
         COMP = 1
      elif NOM_CMP=='DY':
         COMP = 2
      elif NOM_CMP=='DZ': 
         COMP = 3  

   #---------MODES interface
      # ----- boucle sur les modes statiques
      for mods in range(0,nbmods):
         nmo = nbmodd+mods+1
         __CHAM=CREA_CHAMP( TYPE_CHAM='NOEU_DEPL_R',
                OPERATION='EXTR',                  
                NUME_ORDRE=nmo,
                RESULTAT = resultat  ,
                NOM_CHAM = 'DEPL'
                      );
         MCMP =__CHAM.EXTR_COMP(NOM_CMP,[GROUP_NO_INTER]).valeurs

         NNO =__CHAM.EXTR_COMP(NOM_CMP,[GROUP_NO_INTER], topo=1).noeud


         som=sum(MCMP)
         max1=max(MCMP)
         min1=min(MCMP)
         maxm=max([abs(max1),abs(min1)])
      #CALCUL DE XO
#  on recupere la composante COMP (dx,dy,dz) des modes et on projete
         #  CAS 1: MODES DE CORPS RIGIDE
         if INTERF['MODE_INTERF'] =='CORP_RIGI':
            for modp in range(0,nbme):
               #modes de translation
               if mods+1 <=3:
                  if abs(som)<10.E-6:
                     XO[modp,mods]=0.0
                  else :
                     fact=1./som               
                     XO[modp,mods]=fact*Num.innerproduct(MCMP,PVEC[modp])
               #modes de rotation
               else:
                  if maxm<10.E-6:
                     if som<10.E-6:
                        XO[modp,mods]=0.0 
                     else :
                        UTMESS('F','ALGORITH6_86')
                  else :  
                     fact = 1./(nbno)                   
                     XO[modp,mods]=1./(maxm**2.)*fact*Num.innerproduct(MCMP,PVEC[modp])

         # CAS 2: MODES EF
         if INTERF['MODE_INTERF'] =='TOUT':
            for modp in range(0,nbme):
               if abs(som)<10.E-6:
                  if maxm<10.E-6:
                     XO[modp,mods]=0.0 
                  else:
                     UTMESS('F','UTILITAI5_89')                     
               else:
                  fact=1./som                  
                  XO[modp,mods]=fact*Num.innerproduct(MCMP,PVEC[modp])

         DETRUIRE(CONCEPT=_F(NOM=(__CHAM)),INFO=1)

   #----Impedances etc.----------------------------------------------------------------- 

      if k>0:
         DETRUIRE(CONCEPT=_F(NOM=(__impe,__fosi,__rito)),INFO=1) 

      __impe = LIRE_IMPE_MISS(BASE=resultat,  
                           TYPE=TYPE,
                           NUME_DDL_GENE=nume_ddlgene,               
                           UNITE_RESU_IMPE= UNITE_RESU_IMPE, 
                           FREQ_EXTR=freqk, 
                           );
      __rito=COMB_MATR_ASSE(COMB_C=(
                                _F(MATR_ASSE=__impe,
                                 COEF_C=1.0+0.j,),
                                _F(MATR_ASSE=MATR_GENE['MATR_RIGI'],
                                 COEF_C=1.0+0.j,),
                                 ),
                                 SANS_CMP='LAGR',
                                 );                                                                            
      __fosi = LIRE_FORC_MISS(BASE=resultat,  
                           NUME_DDL_GENE=nume_ddlgene,
                           NOM_CMP=NOM_CMP,
                           NOM_CHAM='DEPL',               
                           UNITE_RESU_FORC = UNITE_RESU_FORC, 
                           FREQ_EXTR=freqk,); 
      # impedance
      MIMPE=__impe.EXTR_MATR_GENE() 
      #  extraction de la partie modes interface 
      KRS = MIMPE[nbmodd:nbmodt,nbmodd:nbmodt]

      # force sismique pour verif
#      FS0=__fosi.EXTR_VECT_GENE_C()
#      FSE=FS0[nbmodd:nbmodt][:]
      SP=Num.zeros((nbmodt,nbmodt),Num.Float)
      for k1 in range(0,nbme):
         #  calcul de la force sismique mode POD par mode POD
         FS = Num.matrixmultiply(KRS,XO[k1]) 
         Fzero=Num.zeros((1,nbmodd),Num.Float) 
         FS2=Num.concatenate((Fzero,Num.reshape(FS,(1,nbmods))),1)
      #  Calcul harmonique
         __fosi.RECU_VECT_GENE_C(FS2[0]) 
         __dyge = DYNA_LINE_HARM(MODELE=modele,
                          MATR_MASS = MATR_GENE['MATR_MASS'],
                          MATR_RIGI = __rito, 
                          FREQ = freqk,
                          MATR_AMOR = __ma_amort,                          
                          EXCIT =_F ( VECT_ASSE = __fosi,
                                      COEF_MULT= 1.0,
                                  ),
                        );                              
         #  recuperer le vecteur modal depl calcule par dyge                                                     
         desc = __dyge.DESC.get()
         assert desc[0].strip() == 'DEPL', 'Champ DEPL non trouv�'
         nomcham = __dyge.TACH.get()[1][0].strip()
         cham = sd_cham_gene(nomcham)
         RS = Num.array(cham.VALE.get())      
         SP=SP+RS*conj(RS[:,Num.NewAxis])   
         DETRUIRE(CONCEPT=_F(NOM=(__dyge)),INFO=1) 


      SPEC[k]=SP

      abscisse[k]= freqk
##---------------------------------------------------------------------
#  Ecriture des tables
#--------------------------------------------------------------------- 
#   ------ CREATION DE L OBJET TABLE 
   tab = Table()
   tab.append({'NOM_CHAM' : 'DSP', 'OPTION' : 'TOUT',  'DIMENSION' : nbmodt})
   for k2 in range(nbmodt):
      if OPTION =='DIAG' : # on ecrit uniquement les termes diagonaux (autospectres) de la matrice
         foncc=[]
         for k in range(NB_FREQ) :
                foncc.append(abscisse[k])
                foncc.append(SPEC[k][k2,k2].real)
                foncc.append(SPEC[k][k2,k2].imag)      
         _f = DEFI_FONCTION(NOM_PARA='FREQ',
                      NOM_RESU='SPEC',
                      VALE_C  = foncc )      
         # Ajout d'une ligne dans la Table
         tab.append({'NUME_ORDRE_I' : k2+1, 'NUME_ORDRE_J' : k2+1, 'FONCTION_C' : _f.nom})

      else: # on ecrit tout
         for k1 in range(k2+1):
            foncc=[]
            for k in range(NB_FREQ) :
               foncc.append(abscisse[k])
               foncc.append(SPEC[k][k1,k2].real)
               foncc.append(SPEC[k][k1,k2].imag)      
            _f = DEFI_FONCTION(NOM_PARA='FREQ',
                      NOM_RESU='SPEC',
                      VALE_C  = foncc )
            # Ajout d'une ligne dans la Table
            tab.append({'NUME_ORDRE_I' : k1+1, 'NUME_ORDRE_J' : k2+1, 'FONCTION_C' : _f.nom})

   # Creation du concept en sortie
   dict_keywords = tab.dict_CREA_TABLE()
   tab_out = CREA_TABLE(TYPE_TABLE='TABLE_FONCTION',
                        **dict_keywords)                       
   return ier
