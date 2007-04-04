#@ MODIF algeline5 Messages  DATE 04/04/2007   AUTEUR ABBAS M.ABBAS 
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

def _(x) : return x

cata_msg={
1: _("""
 incoherence de certains parametres modaux propres a arpack
  numero d'erreur  %(i1)d
"""),

2: _("""
 nombre de valeurs propres convergees  %(i1)d
 < nombre de frequences demandees  %(i2)d
 erreur arpack numero :  %(i3)d
 --> le calcul continue, la prochaine fois %(i4)d
 -->   augmenter dim_sous_espace =  %(i5)d
 -->   ou nmax_iter_soren =  %(i6)d
 -->   ou prec_soren =  %(r1)f
 si votre probleme est fortement amorti  %(i7)d
 il est possible que des modes propres  %(i8)d
 non calcules soient sur-amortis  %(i9)d
 --> diminuez le nombre de frequences  %(i10)d
 demandees %(i11)d
"""),

3: _("""
 incoherence de certains parametres modaux propres a arpack
  numero d'erreur  %(i1)d
"""),

4: _("""
 erreur lapack (ou blas) au niveau de la routine  %(k1)s
  le parametre numero  %(i1)d
  n'a pas une valeur coherente %(i2)d
"""),

5: _("""
 !! Attention, vous utilisez l'option de test FETI de l'interface.
 On va donc simuler la r�solution d'un syst�me diagonal canonique,
 pour provoquer un test d'ensemble de l'algorithme qui doit trouver
 la solution U=1 sur tous les noeuds. 
 Vos r�sultats sont donc articiellement fauss�s pour les besoins de
 ce test. Pour r�aliser effectivement votre calcul, d�sactiver cette
 option (INFO_FETI(12:12)='F' au lieu de 'T') !!
"""),

}
