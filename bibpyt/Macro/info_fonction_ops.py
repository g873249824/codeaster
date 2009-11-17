#@ MODIF info_fonction_ops Macro  DATE 16/11/2009   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
def info_fonction_ops(self,RMS,NOCI_SEISME,MAX,NORME,ECART_TYPE,INFO,**args):
  """
     Ecriture de la macro INFO_FONCTION
  """
  ier=0
  import string
  from Cata_Utils.t_fonction import t_fonction,t_fonction_c,t_nappe
  import math
  from Accas import _F
  from Utilitai.Utmess import  UTMESS
  import types
  from types import ListType, TupleType
  EnumTypes = (ListType, TupleType)

  ### On importe les definitions des commandes a utiliser dans la macro
  CREA_TABLE     = self.get_cmd('CREA_TABLE')
  CALC_TABLE     = self.get_cmd('CALC_TABLE')
  IMPR_TABLE     = self.get_cmd('IMPR_TABLE')
  CALC_FONCTION  = self.get_cmd('CALC_FONCTION')
  
  ### Comptage commandes + d�claration concept sortant
  self.set_icmd(1)
  self.DeclareOut('C_out',self.sd)

  ### type de traitement
  
  ###
  if (MAX != None): 
     if type(MAX['FONCTION']) not in EnumTypes : l_fonc=[MAX['FONCTION'],]
     else                                       : l_fonc=MAX['FONCTION']
     __tmfonc=[None]*3
     k=0
     mfact=[]
     ltyfo=[]
     lpara=[]
     lresu=[]
     lfnom=[]
     for fonc in l_fonc :
        __ff=fonc.convert()
        __ex=__ff.extreme()
        ltyfo.append(__ff.__class__)
        lpara.append(__ff.para['NOM_PARA'])
        lresu.append(__ff.para['NOM_RESU'])
        lfnom.append(fonc.nom)
        n_mini=len(__ex['min'])
        n_maxi=len(__ex['max'])
        listeMCF=[_F(LISTE_K=[fonc.nom]*(n_mini+n_maxi),PARA='FONCTION'), 
                  _F(LISTE_K=['MINI',]*n_mini+['MAXI',]*n_maxi,PARA='TYPE'),]
        n_resu=__ff.para['NOM_RESU']
        if isinstance(__ff,t_nappe) :
           listeMCF=listeMCF+[\
              _F(LISTE_R=[i[0] for i in __ex['min']]+[i[0] for i in __ex['max']],PARA=__ff.para['NOM_PARA']),\
              _F(LISTE_R=[i[1] for i in __ex['min']]+[i[1] for i in __ex['max']],PARA=__ff.para['NOM_PARA_FONC']),\
              _F(LISTE_R=[i[2] for i in __ex['min']]+[i[2] for i in __ex['max']],PARA=__ff.para['NOM_RESU'])]
        else :
           listeMCF=listeMCF+[\
                  _F(LISTE_R=[i[0] for i in __ex['min']]+[i[0] for i in __ex['max']],PARA=__ff.para['NOM_PARA']),\
                  _F(LISTE_R=[i[1] for i in __ex['min']]+[i[1] for i in __ex['max']],PARA=__ff.para['NOM_RESU'])]
        __tmfonc[k]=CREA_TABLE(LISTE=listeMCF)
        if k!=0 :
           mfact.append(_F(OPERATION = 'COMB',TABLE=__tmfonc[k]))
        k=k+1
     ltyfo=dict([(i,0) for i in ltyfo]).keys()
     lpara=dict([(i,0) for i in lpara]).keys()
     lresu=dict([(i,0) for i in lresu]).keys()
     if len(ltyfo)>1 : 
# n'est pas homog�ne en type (fonctions et nappes) ''')
        UTMESS('F','FONCT0_37')
     if len(lpara)>1 : 
# n'est pas homog�ne en label NOM_PARA :'''+' '.join(lpara))
        UTMESS('F','FONCT0_38',valk=' '.join(lpara))
     if len(lresu)>1 : 
# n'est pas homog�ne en label NOM_RESU : '''+' '.join(lresu))
        UTMESS('F','FONCT0_39',valk=' '.join(lresu))
     __tab=CALC_TABLE(TABLE  = __tmfonc[0],
                      ACTION = mfact        )
     __min=CALC_TABLE(TABLE  = __tab,
                      ACTION = _F(OPERATION = 'FILTRE',
                                  CRIT_COMP = 'MINI',
                                  NOM_PARA  = lresu[0]  ), )
     __max=CALC_TABLE(TABLE  = __tab,
                      ACTION = _F(OPERATION = 'FILTRE',
                                  CRIT_COMP = 'MAXI',
                                  NOM_PARA  = lresu[0]  ), )
     print __min.EXTR_TABLE()
     print __max.EXTR_TABLE()
     C_out=CALC_TABLE(TABLE  = __min,
                      TITRE  = 'Calcul des extrema sur fonction '+' '.join(lfnom),
                      ACTION = _F(OPERATION = 'COMB',
                                  TABLE=__max  ), )
     print C_out.EXTR_TABLE()

  ###
  if (ECART_TYPE  != None): 
     __ff=ECART_TYPE['FONCTION'].convert()
     if ECART_TYPE['INST_INIT']!=None : tini=ECART_TYPE['INST_INIT']
     else                             : tini=__ff.vale_x[0]
     if ECART_TYPE['INST_FIN' ]!=None : tfin=ECART_TYPE['INST_FIN' ]
     else                             : tfin=__ff.vale_x[-1]
     __ff=__ff.cut(tini,__ff.vale_x[-1],ECART_TYPE['PRECISION'],ECART_TYPE['CRITERE'])
     __ff=__ff.cut(__ff.vale_x[0],tfin,ECART_TYPE['PRECISION'],ECART_TYPE['CRITERE'])
     if ECART_TYPE['METHODE'  ]=='SIMPSON' : __ex=__ff.simpson(0.)
     if ECART_TYPE['METHODE'  ]=='TRAPEZE' : __ex=__ff.trapeze(0.)
     fmoy=__ex.vale_y[-1]/(__ff.vale_x[-1]-__ff.vale_x[0])
     __ff=__ff+(-1*fmoy)
     __ff=__ff*__ff
     if ECART_TYPE['METHODE'  ]=='SIMPSON' : __ez=__ff.simpson(0.)
     if ECART_TYPE['METHODE'  ]=='TRAPEZE' : __ez=__ff.trapeze(0.)
     sigma=math.sqrt(__ez.vale_y[-1]/(__ff.vale_x[-1]-__ff.vale_x[0]))
     C_out=CREA_TABLE(LISTE=(_F(LISTE_K=ECART_TYPE['FONCTION'].nom,PARA='FONCTION'),
                             _F(LISTE_K=ECART_TYPE['METHODE']     ,PARA='METHODE'),
                             _F(LISTE_R=fmoy                      ,PARA='MOYENNE'),
                             _F(LISTE_R=sigma                     ,PARA='ECART_TYPE'),
                             _F(LISTE_R=tini                      ,PARA='INST_INIT'),
                             _F(LISTE_R=tfin                      ,PARA='INST_FIN'),)
                     )

  ###
  if (RMS != None):
     RMS  =list(RMS)
     sigm =[]
     tmpi =[]
     tmpf =[]
     nomf =[]
     meth =[]
     for i_rms in RMS :
         __ff=i_rms['FONCTION'].convert()
         if i_rms['INST_INIT']!=None : tini=i_rms['INST_INIT']
         else                        : tini=__ff.vale_x[0]
         if i_rms['INST_FIN' ]!=None : tfin=i_rms['INST_FIN' ]
         else                        : tfin=__ff.vale_x[-1]
         __ff=__ff.cut(tini,__ff.vale_x[-1],i_rms['PRECISION'],i_rms['CRITERE'])
         __ff=__ff.cut(__ff.vale_x[0],tfin,i_rms['PRECISION'],i_rms['CRITERE'])
         __ff=__ff*__ff
         if i_rms['METHODE'  ]=='SIMPSON' : __ez=__ff.simpson(0.)
         if i_rms['METHODE'  ]=='TRAPEZE' :
            __ez=__ff.trapeze(0.)
         sigm.append(math.sqrt(__ez.vale_y[-1]/(__ff.vale_x[-1]-__ff.vale_x[0])))
         tmpi.append(tini)
         tmpf.append(tfin)
         nomf.append(i_rms['FONCTION'].nom)
         meth.append(i_rms['METHODE'])
     C_out=CREA_TABLE(LISTE=(_F(LISTE_K=nomf ,PARA='FONCTION'),
                             _F(LISTE_K=meth ,PARA='METHODE'),
                             _F(LISTE_R=tmpi ,PARA='INST_INIT'),
                             _F(LISTE_R=tmpf ,PARA='INST_FIN'),
                             _F(LISTE_R=sigm ,PARA='RMS'), )
                     )

  ###
  if (NORME != None):
     __ff=NORME['FONCTION'].convert()
     norme=[]
     for __fi in __ff.l_fonc :
         norme.append(__fi.normel2())
     nom=[NORME['FONCTION'].nom,]*len(norme)
     C_out=CREA_TABLE(LISTE=(_F(LISTE_R=norme ,PARA='NORME'),
                             _F(LISTE_K=nom   ,PARA='FONCTION'), )
                     )

  ###
  if (NOCI_SEISME != None):
     l_table=[]
     if NOCI_SEISME['SPEC_OSCI'] !=None :
        ### cas intensit� spectrale d'une nappe de SRO
        ### la seule option licite est INTE_SPEC
#intensite spectrale, il est prudent de verifier la norme de la nappe sur laquelle \
#porte le calcul, ceci peut etre une source d erreurs.''')
        UTMESS('I','FONCT0_40')
        amor=NOCI_SEISME['AMOR_REDUIT']
        fini=NOCI_SEISME['FREQ_INIT'  ]
        ffin=NOCI_SEISME['FREQ_FIN'   ]
        __sp  =NOCI_SEISME['SPEC_OSCI'].convert()
        vale_x=__sp.l_fonc[0].vale_x
        vale_y=[__sp(amor,f) for f in vale_x]
        para  =__sp.l_fonc[0].para
        __srov=t_fonction(vale_x,vale_y,para)
        if   NOCI_SEISME['NATURE']=='DEPL' : 
             __srov.vale_y=(__srov.vale_y/__srov.vale_x)*2.*math.pi
        elif NOCI_SEISME['NATURE']=='VITE' : 
             __srov.vale_y=__srov.vale_y/__srov.vale_x/__srov.vale_x
        elif NOCI_SEISME['NATURE']=='ACCE' : 
             __srov.vale_y=__srov.vale_y/__srov.vale_x/__srov.vale_x
             __srov.vale_y=__srov.vale_y/__srov.vale_x/2./math.pi
        __srov=__srov.cut(fini,ffin,NOCI_SEISME['PRECISION'],NOCI_SEISME['CRITERE'])
        insp=__srov.trapeze(0.).vale_y[-1]
        l_table.append(_F(LISTE_R=fini ,PARA='FREQ_INIT'  ))
        l_table.append(_F(LISTE_R=ffin ,PARA='FREQ_FIN'   ))
        l_table.append(_F(LISTE_R=amor ,PARA='AMOR_REDUIT'))
        l_table.append(_F(LISTE_R=insp ,PARA='INTE_SPECT' ))
     if NOCI_SEISME['FONCTION'] !=None :
        ### cas fonction
        l_table.append(_F(LISTE_K=NOCI_SEISME['FONCTION'].nom,PARA='FONCTION'))
        __ac=NOCI_SEISME['FONCTION'].convert()
        option= NOCI_SEISME['OPTION']
        if   NOCI_SEISME['INST_INIT']!=None : tdeb=NOCI_SEISME['INST_INIT']
        else                                : tdeb=__ac.vale_x[0]
        if   NOCI_SEISME['INST_FIN' ]!=None : tfin=NOCI_SEISME['INST_FIN' ]
        else                                : tfin=__ac.vale_x[-1]
        # calcul de la vitesse :
        __vi=__ac.trapeze(NOCI_SEISME['COEF'])
        # calcul du d�placement :
        __de=__vi.trapeze(NOCI_SEISME['COEF'])
        # calcul de |acceleration| :
        __aa=__ac.abs()
        # calcul de integrale(|acceleration|) :
        ### on "coupe" la fonction entre tdeb et tfin
        __ac=__ac.cut(tdeb,tfin,NOCI_SEISME['PRECISION'],NOCI_SEISME['CRITERE'])
        __vi=__vi.cut(tdeb,tfin,NOCI_SEISME['PRECISION'],NOCI_SEISME['CRITERE'])
        __de=__de.cut(tdeb,tfin,NOCI_SEISME['PRECISION'],NOCI_SEISME['CRITERE'])
        __aa=__aa.cut(tdeb,tfin,NOCI_SEISME['PRECISION'],NOCI_SEISME['CRITERE'])
        if   NOCI_SEISME['FREQ'     ]!=None : l_freq=NOCI_SEISME['FREQ']
        elif NOCI_SEISME['LIST_FREQ']!=None : l_freq=NOCI_SEISME['LIST_FREQ'].Valeurs()
        else                                :  
           # fr�quences par d�faut
           l_freq=[]
           for i in range(56) : l_freq.append( 0.2+0.050*i)
           for i in range( 8) : l_freq.append( 3.0+0.075*i)
           for i in range(14) : l_freq.append( 3.6+0.100*i)
           for i in range(24) : l_freq.append( 5.0+0.125*i)
           for i in range(28) : l_freq.append( 8.0+0.250*i)
           for i in range( 6) : l_freq.append(15.0+0.500*i)
           for i in range( 4) : l_freq.append(18.0+1.000*i)
           for i in range(10) : l_freq.append(22.0+1.500*i)
        if option in('TOUT','MAXI','ACCE_SUR_VITE') : 
           #   calcul du max des valeurs absolues
           maxa_ac=__ac.abs().extreme()['max'][0][1]
           maxa_vi=__vi.abs().extreme()['max'][0][1]
           maxa_de=__de.abs().extreme()['max'][0][1]
           l_table.append(_F(LISTE_R=maxa_ac,PARA='ACCE_MAX'))
           l_table.append(_F(LISTE_R=maxa_vi,PARA='VITE_MAX'))
           l_table.append(_F(LISTE_R=maxa_de,PARA='DEPL_MAX'))
           l_table.append(_F(LISTE_R=maxa_ac/maxa_vi,PARA='ACCE_SUR_VITE'))
        if option in('TOUT','INTE_ARIAS') : 
           __a2=__ac*__ac
           inte_arias=__a2.trapeze(0.).vale_y[-1]
           inte_arias=inte_arias*math.pi/NOCI_SEISME['PESANTEUR']/2.
           l_table.append(_F(LISTE_R=inte_arias,PARA='INTE_ARIAS'))
        if option in('TOUT','POUV_DEST') : 
           __v2=__vi*__vi
           pouv_dest=__v2.trapeze(0.).vale_y[-1]
           pouv_dest=pouv_dest*(math.pi)**3/NOCI_SEISME['PESANTEUR']/2.
           l_table.append(_F(LISTE_R=pouv_dest,PARA='POUV_DEST'))
        if option in('TOUT','VITE_ABSO_CUMU') : 
           __vc=__aa.trapeze(0.)
           vite_abso=__vc.vale_y[-1]
           l_table.append(_F(LISTE_R=vite_abso,PARA='VITE_ABSO_CUMU'))
        if option in('TOUT','INTE_SPEC') :
           amor=NOCI_SEISME['AMOR_REDUIT']
           fini=NOCI_SEISME['FREQ_INIT'  ]
           ffin=NOCI_SEISME['FREQ_FIN'   ]
           __so= CALC_FONCTION(SPEC_OSCI=_F(
                                      NATURE     ='VITE',
                                      NATURE_FONC='ACCE',
                                      FONCTION   =NOCI_SEISME['FONCTION'],
                                      METHODE    ='NIGAM',
                                      NORME      =NOCI_SEISME['NORME'],
                                      FREQ       =l_freq,
                                      AMOR_REDUIT=(amor,)
                                      ), )
           __srov=__so.convert().l_fonc[0]
           __srov=__srov.cut(fini,ffin,NOCI_SEISME['PRECISION'],NOCI_SEISME['CRITERE'])
           __srov.vale_y=__srov.vale_y/__srov.vale_x/__srov.vale_x
           insp=__srov.trapeze(0.).vale_y[-1]
           l_table.append(_F(LISTE_R=fini ,PARA='FREQ_INIT'  ))
           l_table.append(_F(LISTE_R=ffin ,PARA='FREQ_FIN'   ))
           l_table.append(_F(LISTE_R=amor ,PARA='AMOR_REDUIT'))
           l_table.append(_F(LISTE_R=insp ,PARA='INTE_SPECT' ))
        if option in('TOUT','DUREE_PHAS_FORT') : 
           __a2=__ac*__ac
           __i2=__a2.trapeze(0.)
           arias = __i2.vale_y[-1]*math.pi/NOCI_SEISME['PESANTEUR']/2.
           valinf = arias * NOCI_SEISME['BORNE_INF']
           valsup = arias * NOCI_SEISME['BORNE_SUP']
           for i in range(len(__i2.vale_x)) :
               ariask = __i2.vale_y[i]*math.pi/NOCI_SEISME['PESANTEUR']/2.
               if ariask>=valinf : break
           for j in range(len(__i2.vale_x)-1,-1,-1) :
               ariask = __i2.vale_y[j]*math.pi/NOCI_SEISME['PESANTEUR']/2.
               if ariask<=valsup : break
           dphfor = __i2.vale_x[j] - __i2.vale_x[i]
           l_table.append(_F(LISTE_R=dphfor,PARA='DUREE_PHAS_FORT'))
     C_out=CREA_TABLE(LISTE=l_table)

  if INFO > 1:
     IMPR_TABLE(UNITE=6,
                TABLE=C_out)
  return ier
