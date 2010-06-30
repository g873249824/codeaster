#@ MODIF fonct0 Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg = {

1 : _("""
Le fichier %(k1)s existe d�j�, on �crit � la suite.
"""),

2 : _("""
Il n'y a pas de r�gles d'interpolation pour LIST_PARA/LIST_RESU,
LIST_PARA/LIST_RESU ne peut donc apparaitre qu'une seule fois
et � la premi�re occurence de COURBE.
"""),

3 : _("""
LIST_PARA et LIST_RESU n'ont pas la meme taille.
"""),

4 : _("""
FONC_X/FONC_Y ne peuvent pas etre des nappes !
"""),

5 : _("""
Au format 'TABLEAU', FONC_X/FONC_Y ne peut apparaitre qu'une seule fois
et � la premi�re occurence de COURBE
"""),

6 : _("""
Il n'y a pas de r�gles d'interpolation pour ABSCISSE/ORDONNEE,
ABSCISSE/ORDONNEE ne peut donc apparaitre qu'une seule fois
et � la premi�re occurence de COURBE.
"""),

7 : _("""
ABSCISSE et ORDONNEE n'ont pas la meme taille.
"""),

8 : _("""
Format inconnu : %(k1)s
"""),

9 : _("""
Erreur lors de l'interpolation de la fonction '%(k1)s'.
"""),

10 : _("""sur la maille '%(k1)s'
"""),

11 : _("""
L'interpolation de la fonction '%(k1)s' n'est pas autoris�e.
Le type d'interpolation de la fonction vaut 'NON'

  -> Risque & Conseil :
    Voir le mot-cl� INTERPOL des commandes qui cr�ent des fonctions.
"""),

12 : _("""
Une erreur s'est produite dans la recherche de l'intervalle des abscisses contenant la valeur %(r1)s.

  -> Risque & Conseil :
    V�rifiez que le type d'interpolation de la fonction ne vaut pas 'NON'
    (mot-cl� INTERPOL des commandes qui cr�ent des fonctions).
"""),

13 : _("""
Le type de la fonction '%(k1)s' est inconnu.
Seules les fonctions, nappes, fonctions constantes peuvent etre trait�es par FOINTE.

  -> Debug :
      le type est '%(k2)s'
"""),

14 : _("""
Il n'y a pas assez de param�tres pour �valuer la fonction.
Seulement %(i1)d param�tre(s) sont fourni(s) alors que la fonction en r�clame %(i2)d.
"""),

15 : _("""
Il y a des doublons dans la liste des param�tres fournis :
   %(ktout)s
"""),

16 : _("""
Les param�tres n�cessaires sont :
   %(ktout)s
"""),

17 : _("""
Les param�tres fournis sont :
   %(ktout)s
"""),

18 : _("""
La fonction n'a meme pas un point !
"""),

19 : _("""
On est hors du domaine de d�finition de la fonction.
On ne peut pas interpoler la fonction pour cette abscisse car le prolongement � gauche est exclus.
   abscisse demand�e              : %(r1)f
   borne inf�rieure des abscisses : %(r2)f

  -> Risque & Conseil :
    Voir le mot-cl� PROL_GAUCHE des commandes qui cr�ent des fonctions.
"""),

20 : _("""
On est hors du domaine de d�finition de la fonction.
On ne peut pas interpoler la fonction pour cette abscisse car le prolongement � droite est exclus.
   abscisse demand�e              : %(r1)f
   borne sup�rieure des abscisses : %(r2)f

  -> Risque & Conseil :
    Voir le mot-cl� PROL_DROITE des commandes qui cr�ent des fonctions.
"""),

21 : _("""
Erreur de programmation : type d'extrapolation inconnu.

  -> Debug :
      le type d'extrapolation est '%(k1)s'
"""),

22 : _("""
La fonction n'est d�finie qu'en un point. On ne peut pas l'interpoler en
plus d'un point si le prolongement n'est pas constant des deux cot�s.

  -> Risque & Conseil :
    Voir les mot-cl�s PROL_GAUCHE/PROL_DROITE des commandes qui cr�ent des fonctions.
"""),

23 : _("""
La fonction n'est d�finie qu'en un point. On ne peut pas l'interpoler ailleurs
qu'en ce point si le prolongement n'est pas constant des deux cot�s.

  -> Risque & Conseil :
    Voir les mot-cl�s PROL_GAUCHE/PROL_DROITE des commandes qui cr�ent des fonctions.
"""),

24 : _("""
On attend une fonction d'un seul param�tre.
La fonction '%(k1)s' est une fonction de %(i1)d param�tres.
"""),

25 : _("""
Le type de la fonction '%(k1)s' est inconnu.
Seules les fonctions, nappes, fonctions constantes et formules sont
trait�es par FOINTR.

  -> Debug :
      le type est '%(k2)s'
"""),

26 : _("""
   abscisse demand�e : %(r1)f
   intervalle trouv� : [%(r2)f, %(r3)f]
"""),

27 : _("""
Un probl�me d'interpolation a �t� rencontr�.
%(k1)s

  -> Risque & Conseil :
      V�rifier les valeurs fournies derri�re le mot-cl� 'INTERPOL' lors
      de la cr�ation de cette(ces) fonction(s).

  -> Debug :
      %(k2)s
"""),

28 : _("""
Un probl�me concernant le nom des abscisses ou ordonn�es a �t� rencontr�.
Vous ne pouvez pas faire la transform�e de fourier d'une fonction dont les abscisses sont des fr�quences,
   ou si la fonction est a valeurs complexes
Vous ne pouvez pas faire la transform�e de fourier inverse d'une fonction dont les abscisses sont des instants,
   ou si la fonction est a valeur r�elle.
%(k1)s

  -> Risque & Conseil :
      V�rifier la valeur fournie derri�re les mots-cl�s 'NOM_PARA'/'NOM_RESU' lors
      de la cr�ation de cette(ces) fonction(s).

  -> Debug :
      %(k2)s
"""),

29 : _("""
Un probl�me concernant le prolongement de la (des) fonction(s) a �t� rencontr�.
%(k1)s

  -> Risque & Conseil :
      V�rifier la valeur fournie derri�re les mots-cl�s 'PROL_GAUCHE'/'PROL_DROITE'
      lors de la cr�ation de cette(ces) fonction(s).

  -> Debug :
      %(k2)s
"""),

30 : _("""
Une erreur s'est produite lors de l'op�ration.
%(k1)s

  -> Debug :
      %(k2)s

Remont�e d'erreur (pour aider � l'analyse) :

%(k3)s

"""),

31 : _("""
   G�n�ration par d�faut de 3 amortissements :[%(r1)f,%(r2)f,%(r3)f]
"""),

32 : _("""
   G�n�ration par d�faut de 150 fr�quences :
   %(k1)s
"""),

33 : _("""
   SPEC_OSCI, la norme ne peut etre nulle.
"""),

34 : _("""
   SPEC_OSCI, le type de la fonction doit etre ACCE.
"""),

35 : _("""
   SPEC_OSCI, seule la m�thode NIGAM est cod�e.
"""),

36 : _("""
   SPEC_OSCI, la m�thode choisie suppose des amortissements sous-critiques,
   amor<1.
"""),

37 : _("""
 calcul du MAX, la liste de fonctions n'est pas
 homog�ne en type (fonctions et nappes)
"""),

38 : _("""
 Calcul du MAX, la liste de fonctions n'est pas homog�ne
 en label NOM_PARA :%(k1)s
"""),

39 : _("""
 Calcul du MAX, la liste de fonctions n'est pas homog�ne
 en label NOM_RESU :%(k1)s
"""),

40 : _("""
 Intensite spectrale, avant de calculer l'intensite spectrale,
 il est prudent de verifier la norme de la nappe sur laquelle
 porte le calcul, ceci peut etre une source d erreurs.
"""),

41 : _("""
 Le fichier %(k1)s est introuvable.
"""),

42 : _("""
Erreur lors de la lecture des blocs de valeurs :
   %(k1)s
"""),

43 : _("""
Les fr�quences doivent etre strictement positives.
"""),

44 : _("""
Les abscisses de la fonction %(k1)s ne sont pas strictement croissantes.
"""),

45 : _("""
Les abscisses de la fonction %(k1)s ne sont pas croissantes.
"""),

46 : _("""
Les abscisses de la fonction %(k1)s ne sont pas d�croissantes.
"""),

47 : _("""
Les abscisses de la fonction %(k1)s ne sont pas strictement d�croissantes.
"""),

48 : _("""
La fonction ou formule ne doit avoir qu'une ou deux variables.
"""),

49 : ("""
La nappe ou formule a deux param�tres. Il faut renseigner le mot-cl� NOM_PARA_FONC
et soit VALE_PARA_FONC, soit LIST_PARA_FONC.
"""),

50 : _("""
Seules les formules � une variable peuvent �tre trait�es directement par IMPR_FONCTION.

La formule '%(k1)s' d�pend de %(i1)d param�tres.

  -> Risque & Conseil :
      - Si votre formule d�pend de 2 param�tres, utilisez CALC_FONC_INTERP pour produire
        une nappe puis appeler IMPR_FONCTION.
      - Si votre formule d�pend de 3 param�tres ou plus, vous devez d'abord cr�er une
        nouvelle formule � un seul param�tre (et appel� IMPR_FONCTION) ou � 2 param�tres
        et passer par CALC_FONC_INTERP puis IMPR_FONCTION.
"""),

51 : _("""
Erreur lors de l'interpr�tation de la formule '%(k1)s'.
"""),

52 : _("""
%(k1)s

Conseils :
  Si le probl�me report� ci-dessus ressemble � 'NameError: name 'XXX' is not defined.',
  v�rifiez que le param�tre 'XXX' fait bien partie des param�tres de d�finition de
  la formule (mot cl� FORMULE / NOM_PARA).
"""),

53 : _("""sur le noeud '%(k1)s'
"""),

54 : ("""
Nombre de param�tres fournis : %(i1)d
Noms des param�tres fournis  : %(ktout)s
"""),

}
