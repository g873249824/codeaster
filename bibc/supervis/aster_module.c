/* ------------------------------------------------------------------ */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2013  EDF R&D              WWW.CODE-ASTER.ORG */
/*                                                                    */
/* THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR      */
/* MODIFY IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS     */
/* PUBLISHED BY THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE */
/* LICENSE, OR (AT YOUR OPTION) ANY LATER VERSION.                    */
/* THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL,    */
/* BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF     */
/* MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU   */
/* GENERAL PUBLIC LICENSE FOR MORE DETAILS.                           */
/*                                                                    */
/* YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE  */
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,      */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */
/* person_in_charge: mathieu.courtois at edf.fr */
/* ------------------------------------------------------------------ */

#include "Python.h"
#include <ctype.h>
#include <stdlib.h>
#include <signal.h>

#include "aster.h"
#include "aster_module.h"
#include "aster_core_module.h"
#include "shared_vars.h"
#include "aster_mpi.h"
#include "aster_fort.h"
#include "aster_utils.h"
#include "aster_exceptions.h"

/*
 *   PRIVATE FUNCTIONS
 *
 */

void TraiteMessageErreur( _IN char* ) ;


INTEGER DEF0(ISJVUP, isjvup)
{
   /* "is jeveux up ?" : retourne 1 si jeveux est démarré/initialisé, sinon 0. */
   return (INTEGER)get_sh_jeveux_status();
}

void DEFP(XFINI,xfini, _IN INTEGER *code)
{
   /* XFINI est n'appelé que par JEFINI avec code=19 (=EOFError) */
   /* jeveux est fermé */
   register_sh_jeveux_status(0);
   interruptTry(*code);
}

/*
 *   Ce module crée de nombreux objets Python. Il doit respecter les règles
 *   générales de création des objets et en particulier les règles sur le
 *   compteur de références associé à chaque objet.
 *   Tous les objets sont partagés. Seules des références à des objets peuvent
 *   etre acquises.
 *   Si une fonction a acquis une référence sur un objet elle doit la traiter
 *   proprement, soit en la transférant (habituellement à l'appelant), soit en
 *   la relachant (par appel à Py_DECREF ou Py_XDECREF).
 *   Quand une fonction transfere la propriété d'une référence, l'appelant recoit
 *   une nouvelle référence. Quand la propriété n'est pas transférée, l'appelant
 *   emprunte la référence.
 *   Dans l'autre sens, quand un appelant passe une référence à une fonction, il y a
 *   deux possibilités : la fonction vole une référence à l'objet ou elle ne le fait
 *   pas. Peu de fonctions (de l'API Python) volent des références : les deux exceptions
 *   les plus notables sont PyList_SetItem() et PyTuple_SetItem() qui volent une
 *   référence à l'item qui est inséré dans la liste ou dans le tuple.
 *   Ces fonctions qui volent des références existent, en général, pour alléger
 *   la programmation.
 */
/* ------------------------------------------------------------------ */

void TraiteMessageErreur( _IN char * message )
{
    INTEGER ier=SIGABRT;
    printf("%s\n",message);
    if ( PyErr_Occurred() ) PyErr_Print();
    CALL_ASABRT( &ier );
}

/* ------------------------------------------------------------------ */
void PRE_myabort( _IN const char *nomFichier , _IN const int numeroLigne , _IN const char *message )
{
        /*
        Procedure : PRE_myabort
        Intention
                Cette procedure prepare la chaine de caracteres affichee par TraiteMessageErreur()
                en ajoutant devant cette chaine, le nom du fichier source et le numero
                de la ligne a partir desquels PRE_myabort a ete appelee.
                Puis elle appelle elle-meme TraiteMessageErreur().
                Voir aussi la macro MYABORT qui permet de generer automatiquement le nom
                du fichier et le numero de la ligne.
        */
        char *chaine = (char*)0 ;
        int longueur = 0 ;
        longueur += strlen( nomFichier ) ;
        longueur += 1 ; /* pour le blanc de separation */
        longueur += 5 ; /* pour le numero de la ligne */
        longueur += 3 ; /* pour les deux points entre deux blancs */
        longueur += ( message != (const char*)0 ) ? strlen( message ) : 0 ;
        longueur += 1 ; /* pour le caractere de fin de chaine */

        chaine = (char*)(malloc(longueur*sizeof(char))) ;
        sprintf( chaine , "%s %u : %s" , nomFichier , numeroLigne , message ) ;
        TraiteMessageErreur( chaine ) ;

        free( chaine )   ;
        chaine=(char*)0 ;
        longueur = 0     ;
}

/* ------------------------------------------------------------------ */
#define CALL_GETLTX(a,b,c,d,e,f,g) CALLSSPPPPP(GETLTX,getltx,a,b,c,d,e,f,g)

void DEFSSPPPPP(GETLTX,getltx,_IN char *motfac,_IN STRING_SIZE lfac,
                              _IN char *motcle,_IN STRING_SIZE lcle,_IN INTEGER *iocc,
                              _IN INTEGER *taille,_IN INTEGER *mxval,
                              _OUT INTEGER *isval, _OUT INTEGER *nbval )
{
        /*
        Procedure : getltx_ (appelee par le fortran sous le nom GETLTX)
        */
        PyObject *res = (PyObject*)0 ;
        PyObject *tup = (PyObject*)0 ;
        char *mfc     = (char*)0 ;
        char *mcs     = (char*)0 ;
        int ok        = 0 ;
        int nval      = 0 ;
        int ioc       = 0 ;

        mfc = MakeCStrFromFStr(motfac,lfac);
                                                     DEBUG_ASSERT(mfc!=(char*)0);
        mcs = MakeCStrFromFStr(motcle,lcle);
                                                     DEBUG_ASSERT(mcs!=(char*)0);
        ioc=(int)*iocc ;
        ioc=ioc-1 ;
        res=PyObject_CallMethod(get_sh_etape(), "getltx", "ssiii",
                                mfc, mcs, ioc, (int)*mxval, (int)*taille);

        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");

        ok = PyArg_ParseTuple(res,"iO",&nval,&tup);
        if (!ok)MYABORT("erreur dans la partie Python");

        *nbval = (INTEGER)nval;
        if( nval < 0 ) nval=(int)*mxval;
        convert(nval,tup,isval);
        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mfc);
        FreeStr(mcs);
        return ;
}


/* ------------------------------------------------------------------ */
void DEFSP(GETFAC,getfac,_IN char *nomfac, _IN STRING_SIZE lfac, _OUT INTEGER *occu)
{
        /*
          Procedure GETFAC pour le FORTRAN : emule le fonctionnement
          de la procedure equivalente ASTER
          Entrees :
            le nom d un mot cle facteur : nomfac (string)
          Retourne :
            le nombre d occurence de ce mot cle dans les args : occu (entier)
            dans l'etape (ou la commande) courante
        */
        PyObject *res  = (PyObject*)0 ;
        char *mfc;
        mfc = MakeCStrFromFStr(nomfac, lfac);
        res=PyObject_CallMethod(get_sh_etape(),"getfac","s",mfc);

        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");

        *occu=(INTEGER)PyInt_AsLong(res);

        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mfc);
        return ;
}


/* ------------------------------------------------------------------ */
void DEFP(GETRAN,getran, _OUT DOUBLE *rval)
{
    /*
      Procedure GETRAN pour le FORTRAN : recupere un réel aleatoire (loi uniforme 0-1)
      du module python Random
      Entrees :
        neant
      Retourne :
        un reel tiré au hasard
    */
    PyObject *res  = (PyObject*)0 ;
    PyObject *val  = (PyObject*)0 ;
    int ok=0;

    res=PyObject_CallMethod(get_sh_etape(),"getran","");
    /*  si le retour est NULL : exception Python a transferer
        normalement a l appelant mais FORTRAN ??? */
    if (res == NULL)MYABORT("erreur dans la partie Python");

    ok = PyArg_ParseTuple(res,"O",&val);
    if(!ok)MYABORT("erreur dans la partie Python");

    *rval=(DOUBLE)PyFloat_AsDouble(val);

    Py_DECREF(res);                /*  decrement sur le refcount du retour */
    return ;
}

/* ------------------------------------------------------------------ */
void DEFP(INIRAN,iniran,_IN INTEGER *jump)
{
        /*
          Procedure INIRAN pour le FORTRAN : recupere un réel aleatoire (loi uniforme 0-1)
          du module python Random
          avec un shift eventuel de jump termes
        */
        PyObject *res  = (PyObject*)0 ;

        res=PyObject_CallMethod(get_sh_etape(),"iniran","i",(int)*jump);
        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        return ;
}

/* ------------------------------------------------------------------ */
void DEFSS(GETTCO,gettco,_IN char *nomobj, _IN STRING_SIZE lnom,
                        _OUT char *typobj, _IN STRING_SIZE ltyp)
{
        /*
          retrouver le type "superviseur" du concept nomobj.
        */
        char *mcs      = (char*)0 ;
        PyObject *res  = (PyObject*)0 ;
        char *nomType  = (char*)0 ;
                                                           DEBUG_ASSERT(lnom>0) ;
        mcs = MakeCStrFromFStr(nomobj,lnom);

        /*
        recherche dans le jeu de commandes python du nom du type de
         du concept Aster de nom nomobj
        */
        res=PyObject_CallMethod(get_sh_etape(),"gettco","s",mcs);
        if (res == (PyObject*)0)MYABORT("erreur dans la partie Python (gettco)");
                                                           DEBUG_ASSERT( PyString_Check(res) );
        nomType=PyString_AsString(res);
                                                           DEBUG_ASSERT(nomType!=(char*)0) ;
        CopyCStrToFStr(typobj, nomType, ltyp);
        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mcs);
        return ;
}


/* ------------------------------------------------------------------ */
void DEFPS(GETMAT,getmat,_INOUT INTEGER *nbarg,_OUT char *motcle,_IN STRING_SIZE lcle)
{
        /*
          Procedure GETMAT pour le FORTRAN
          Routine a l usage de DEFI_MATERIAU : consultation du catalogue (et non de l etape)
          Retourne :
            le nombre de mots cles facteur sous la commande, y compris en eliminant les blocs
            la liste de leur noms
        */
        PyObject *res   = (PyObject*)0 ;
        PyObject *lnom  = (PyObject*)0 ; /* liste python des noms */
        int       nval = 0 ;
        int          k = 0 ;
                                                             DEBUG_ASSERT(lcle>0);
        for ( k=0 ;k<lcle ; k++ ) motcle[k]=' ' ;
        res=PyObject_CallMethod(get_sh_etape(),"getmat","");
        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");
        /*  si non impression du retour */

        if(!PyArg_ParseTuple(res,"O",&lnom)) MYABORT("erreur dans la partie Python");
        nval=PyList_Size(lnom);

        if ( nval > 0 && *nbarg > 0 ){
                converltx(nval,lnom,motcle,lcle); /* conversion  */
        }
        *nbarg = (INTEGER)nval ;

        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        return ;
}


/* ------------------------------------------------------------------ */
void DEFSPPSSP(GETMJM,getmjm,_IN char *nomfac,_IN STRING_SIZE lfac,
                             _IN INTEGER *iocc,_IN INTEGER *nbval,
                            _OUT char *motcle,_IN STRING_SIZE lcle,
                            _OUT char *type,_IN STRING_SIZE ltyp, _OUT INTEGER *nbarg)
{
        /*
          Procedure GETMJM : emule la procedure equivalente ASTER
           Retourne les nbval premiers mots cles du mot cle facteur nomfac du catalogue
           de la commande en cours
          Entrees :
           nomfac : nom du mot cle facteur
           iocc   : numero d occurence du mot cle facteur
           nbval  : nombre de mots cles facteurs demandes
          Retourne :
           motcle : liste des mots cles du mot cle facteur demande
           type   : liste des types des mots cles du mot cle facteur demande
                    R8 , R8L : un reel ou une liste de reels ;
                    C8 , C8L : un complexe ou une liste de complexes ;
                     ...
                    CO , COL : un concept ou une liste de concepts.
           nbarg  : nombre d arguments des mots cles du mot cle facteur
        */

        PyObject *res   = (PyObject*)0 ;
        PyObject *lnom  = (PyObject*)0 ;
        PyObject *lty   = (PyObject*)0 ; /* liste python des noms */
        int       nval = 0 ;
        int          k = 0 ;
        int        ioc = 0 ;
        char *mfc;
                                                                 DEBUG_ASSERT(ltyp>0);
        for ( k=0 ;k<ltyp ; k++ ) type[k]=' ' ;
        ioc=(int)*iocc ;
        ioc=ioc-1 ;
        mfc = MakeCStrFromFStr(nomfac, lfac);
        res=PyObject_CallMethod(get_sh_etape(),"getmjm","sii",mfc,ioc,(int)*nbval);
        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");
        /*  si non impression du retour */

        if(!PyArg_ParseTuple(res,"OO",&lnom,&lty)) MYABORT("erreur dans la partie Python");
        nval=(int)PyList_Size(lnom);
        *nbarg = (INTEGER)( (nval > *nbval) ? -nval : nval );
                                 DEBUG_ASSERT(((nval<=*nbval)&&(*nbarg==nval))||(*nbarg==-nval)) ;
        if(*nbarg < 0)nval=(int)*nbval;

        if ( nval > 0 ){
                converltx(nval,lnom,motcle,lcle); /* conversion  */
                converltx(nval,lty,type,ltyp);
       }

        /*
        A la demande des developpeurs (J. Pellet), le nom des concepts retourne par
        la methode EXECUTION.getmjm (par exemple grma) est ici remplace par
        la chaine CO (pour COncept).
        les types retournes sont donc parmi les valeurs : R8 , C8 , IS , TX et CO.
        */
        for( k=0 ; k<nval*ltyp ; k+=ltyp ){
                char     *mot = (char*)0 ;
                mot           = type+k ;
                if ( strncmp( mot , "R8" , 2 )!=0 && strncmp( mot , "IS" , 2 )!=0 &&
                     strncmp( mot , "TX" , 2 )!=0 && strncmp( mot , "C8" , 2 )!=0 ){
                        int j=0 ;

                     DEBUG_ASSERT(ltyp>2);
                        mot[0]='C' ;
                        mot[1]='O' ;
                        for ( j=2 ; j<ltyp ; j++ ) mot[j]=' ' ;
                }
        }
        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mfc);
        return ;
}


/* ------------------------------------------------------------------ */
INTEGER DEFSS( GETEXM, getexm, _IN char *motfac,_IN STRING_SIZE lfac,
                               _IN char *motcle,_IN STRING_SIZE lcle)
{
        /*
          Procedure GETEXM pour le FORTRAN : emule le fonctionnement
          de la procedure equivalente ASTER
          Entrees :
            le nom d un mot cle facteur : motfac (string)
            le nom d un mot cle simple ou sous mot cle : motcle (string)
          Retourne :
            0 si n existe pas 1 si existe
        */
        PyObject *res  = (PyObject*)0 ;
        char *mfc, *mcs;
        INTEGER presence;
                                                                 DEBUG_ASSERT(motcle!=(char*)0);
        mfc = MakeCStrFromFStr(motfac, lfac);
        mcs = MakeCStrFromFStr(motcle, lcle);
        res=PyObject_CallMethod(get_sh_etape(),"getexm","ss", mfc, mcs);
        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");
        presence = (INTEGER)PyLong_AsLong(res);
        /*  decrement sur le refcount du retour */
        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mfc);
        FreeStr(mcs);
        return presence;
}


/* ------------------------------------------------------------------ */
void DEFSSS( GETRES ,getres, _OUT char *nomres, _IN STRING_SIZE lres,
                             _OUT char *concep, _IN STRING_SIZE lconc,
                             _OUT char *nomcmd, _IN STRING_SIZE lcmd)
{
        /*
          Procedure GETRES pour le FORTRAN : emule le fonctionnement
          de la procedure equivalente ASTER
          Retourne
            le nom utilisateur du resultat : nomres (string)
            le nom du concept resultat     : concep (string)
            le nom de la commande          : nomcmd (string)
        */
        PyObject *res  = (PyObject*)0 ;
        PyObject *etape;
        int ok;
        char *ss1,*ss2,*ss3;

        /* (MC) le 1er test ne me semble pas suffisant car entre deux commandes,
           commande n'est pas remis à (PyObject*)0... */
        etape = get_sh_etape();
        if(etape == (PyObject*)0 || PyObject_HasAttrString(etape, "getres")==0) {
          /* Aucune commande n'est active on retourne des chaines blanches */
          BlankStr(nomres,lres);
          BlankStr(concep,lconc);
          BlankStr(nomcmd,lcmd);
          return ;
        }
        res = PyObject_CallMethod(etape,"getres","");

        ok = PyArg_ParseTuple(res,"sss",&ss1,&ss2,&ss3);
        if (!ok)MYABORT("erreur dans la partie Python");

        /* le fortran attend des chaines de caracteres completees par des blancs */
        CopyCStrToFStr(nomres, ss1, lres);
        CopyCStrToFStr(concep, ss2, lconc);
        CopyCStrToFStr(nomcmd, ss3, lcmd);

        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        return ;
}

void DEFSPS(GETTYP,gettyp, _IN char *typaster, _IN STRING_SIZE ltyp,
                        _INOUT INTEGER *nbval,
                          _OUT char *txval,    _IN STRING_SIZE ltx)
{
    /* Interface GETTYP
     * voir B_ETAPE.gettyp
     */
    PyObject *res = (PyObject*)0;
    PyObject *tup = (PyObject*)0;
    char *typ;
    int ok = 0;
    int nval = 0;

    typ = MakeCStrFromFStr(typaster, ltyp);
    res = PyObject_CallMethod(get_sh_etape(), "gettyp", "s", typ);
    if ( res == NULL ) MYABORT("erreur dans la partie Python de gettyp");

    ok = PyArg_ParseTuple(res, "iO", &nval, &tup);
    if( !ok ) MYABORT("erreur dans la partie Python");

    if ( *nbval == 0 ) {
        *nbval = (INTEGER)nval;
    } else {
        nval = nval > (int)*nbval ? (int)*nbval : nval;
        convertxt(nval, tup, txval, ltx);
    }

    FreeStr(typ);
    Py_XDECREF(res);
    Py_XDECREF(tup);
}

/* ------------------------------------------------------------------ */
void DEFSSPPPPP(GETVC8_WRAP,getvc8_wrap,_IN char *motfac,_IN STRING_SIZE lfac,
                              _IN char *motcle,_IN STRING_SIZE lcle,_IN INTEGER *iocc,
                              _IN INTEGER *iarg,_IN INTEGER *mxval,
                           _INOUT DOUBLE *val,_OUT INTEGER *nbval)
{
        /*
          Procedure GETVC8 pour le FORTRAN : emule le fonctionnement
          de la procedure equivalente ASTER
          Entrees :
            le nom d un mot cle facteur : motfac (string)
            le nom d un mot cle simple ou sous mot cle : motcle (string)
            le numero de l occurence du mot cle facteur : iocc (entier)
            le numero de l argument demande (obsolete =1): iarg (entier)
            le nombre max de valeur attendues dans val : mxval (entier)
          Retourne :
            le tableau des valeurs attendues : val (2 reels (double) par complexe)
            le nombre de valeurs effectivement retournees : nbval (entier)
               si pas de valeur nbval =0
               si plus de valeur que mxval nbval <0 et valeur abs = nbre valeurs
               si moins de valeurs que mxval nbval>0 et egal au nombre retourne
        */
        PyObject *res  = (PyObject*)0 ;
        PyObject *tup  = (PyObject*)0 ;
        int ok         = 0 ;
        int nval       = 0 ;
        int idef       = 0 ;
        int ioc        = 0 ;
        char *mfc      = (char*)0 ;
        char *mcs      = (char*)0 ;
        mfc = MakeCStrFromFStr(motfac,lfac);
                                                     DEBUG_ASSERT(mfc!=(char*)0);
        mcs = MakeCStrFromFStr(motcle,lcle);
        /*
                VERIFICATION
                Si le mot-cle simple est recherche sous un mot-cle facteur et uniquement dans ce
                cas, le numero d'occurrence (*iocc) doit etre strictement positif.
                Si le mot-cle simple est recherche sans un mot-cle facteur iocc n'est pas utilise

        */
        if( isalpha(mfc[0])&&(*iocc<=0) )
        {
                printf( "<F> GETVC8 : le numero d'occurence (IOCC=%ld) est invalide\n",*iocc) ;
                printf( "             commande : %s\n",
                       PyString_AsString(PyObject_CallMethod(get_sh_etape(),"retnom",""))) ;
                printf( "             mot-cle facteur : %s\n",mfc) ;
                printf( "             mot-cle simple  : %s\n",mcs) ;
                MYABORT( "erreur d'utilisation detectee") ;
        }

        ioc=(int)*iocc ;
        ioc=ioc-1 ;
        res=PyObject_CallMethod(get_sh_etape(),"getvc8","ssii",mfc,mcs,ioc,(int)*mxval);

        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");
                                                     DEBUG_ASSERT(PyTuple_Check(res)) ;
        ok = PyArg_ParseTuple(res,"iOi",&nval,&tup,&idef);
        if(!ok)MYABORT("erreur dans la partie Python");

        *nbval = (INTEGER)nval;
        if ( nval < 0 ) nval=(int)*mxval;
        convc8(nval,tup,val);
        *iarg = (INTEGER)idef;

        Py_DECREF(res);
        FreeStr(mfc);
        FreeStr(mcs);
        return ;
}


/* ------------------------------------------------------------------ */
void DEFSSPPPPP(GETVR8_WRAP,getvr8_wrap,_IN char *motfac,_IN STRING_SIZE lfac,
                              _IN char *motcle,_IN STRING_SIZE lcle,_IN INTEGER *iocc,
                              _IN INTEGER *iarg,_IN INTEGER *mxval,_INOUT DOUBLE *val,
                              _OUT INTEGER *nbval)
{
        /*
          Procedure GETVR8 pour le FORTRAN : emule le fonctionnement
          de la procedure equivalente ASTER
          Entrees :
            le nom d un mot cle facteur : motfac (string)
            le nom d un mot cle simple ou sous mot cle : motcle (string)
            le numero de l occurence du mot cle facteur : iocc (entier)
            le numero de l argument demande (obsolete =1): iarg (entier)
            le nombre max de valeur attendues dans val : mxval (entier)
          Retourne :
            le tableau des valeurs attendues : val (tableau de R8    )
            le nombre de valeurs effectivement retournees : nbval (entier)
               si pas de valeur nbval =0
               si plus de valeur que mxval nbval <0 et valeur abs = nbre valeurs
               si moins de valeurs que mxval nbval>0 et egal au nombre retourne
        */
        PyObject *res  = (PyObject*)0 ;
        PyObject *tup  = (PyObject*)0 ;
        int ok         = 0 ;
        int nval       = 0 ;
        int idef       = 0 ;
        int ioc        = 0 ;
        char *mfc      = (char*)0 ;
        char *mcs      = (char*)0 ;
        mfc = MakeCStrFromFStr(motfac,lfac); /* conversion chaine fortran en chaine C */
                                                     DEBUG_ASSERT(mfc!=(char*)0);
        mcs = MakeCStrFromFStr(motcle,lcle);
        /*
         * VERIFICATION
         * Si le mot-cle simple est recherche sous un mot-cle facteur et uniquement dans ce cas,
         * le numero d'occurrence (*iocc) doit etre strictement positif.
         * Si le mot-cle simple est recherche sans un mot-cle facteur iocc n'est pas utilise
         */
        if( isalpha(mfc[0])&&(*iocc<=0) )
        {
                printf( "<F> GETVR8 : le numero d'occurence (IOCC=%ld) est invalide\n",*iocc) ;
                printf( "             commande : %s\n",
                       PyString_AsString(PyObject_CallMethod(get_sh_etape(),"retnom",""))) ;
                printf( "             mot-cle facteur : %s\n",mfc) ;
                printf( "             mot-cle simple  : %s\n",mcs) ;
                MYABORT( "erreur d'utilisation detectee") ;
        }
        ioc=(int)*iocc ;
        ioc=ioc-1 ;
        res=PyObject_CallMethod(get_sh_etape(),"getvr8","ssii",mfc,mcs,ioc,(int)*mxval);
        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");
                                                    DEBUG_ASSERT(PyTuple_Check(res)) ;
        ok = PyArg_ParseTuple(res,"iOi",&nval,&tup,&idef);
        if(!ok)MYABORT("erreur dans la partie Python");

        *nbval=(INTEGER)nval;
        if ( nval < 0 ) nval=(int)*mxval;
        if ( nval>0 ){
                convr8(nval,tup,val);
        }
        *iarg = (INTEGER)idef;

        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mfc);
        FreeStr(mcs);
        return ;
}


/* ------------------------------------------------------------------ */
#define CALL_FIINTF(a, b, c, d, e, f, g) CALLSPSPPSP(FIINTF,fiintf, a, b, c, d, e, f, g)

void DEFSPSPPSP(FIINTF,fiintf,_IN char *nomfon,_IN STRING_SIZE lfon,
                              _IN INTEGER *nbpu,_IN char *param,_IN STRING_SIZE lpara,
                              _IN DOUBLE *val,
                             _OUT INTEGER *iret,
                              _IN char *coderr, _INOUT STRING_SIZE lcod,
                             _OUT DOUBLE *resu)
{
        PyObject *tup2  = (PyObject*)0 ;
        PyObject *res, *piret;
        PyObject *tup_par;
        PyObject *tup_val;
        char *kvar, *sret;
        int i;
        tup_par = PyTuple_New( (Py_ssize_t)*nbpu ) ;
        tup_val = PyTuple_New( (Py_ssize_t)*nbpu ) ;
        for(i=0;i<*nbpu;i++){
           kvar = param + i*lpara;
           PyTuple_SetItem( tup_par, i, PyString_FromStringAndSize(kvar,(Py_ssize_t)lpara) ) ;
        }
        for(i=0;i<*nbpu;i++){
           PyTuple_SetItem( tup_val, i, PyFloat_FromDouble((double)val[i]) ) ;
        }

        tup2 = PyObject_CallMethod(get_sh_etape(),"fiintf","s#s#OO",
                                   coderr,lcod,nomfon,lfon,tup_par,tup_val);

        if (tup2 == NULL) MYABORT("erreur dans la partie Python");
        piret = PyTuple_GetItem(tup2, 0);
        res   = PyTuple_GetItem(tup2, 1);

        *iret = (INTEGER)PyInt_AsLong(piret);
        *resu = (DOUBLE)0.;
        if ( *iret == 0 ) {
           if (PyComplex_Check(res)) {
               *resu    = (DOUBLE)PyComplex_RealAsDouble(res);
               *(resu+1)= (DOUBLE)PyComplex_ImagAsDouble(res);
           } else if (PyFloat_Check(res) || PyLong_Check(res) || PyInt_Check(res)) {
               *resu    = (DOUBLE)PyFloat_AsDouble(res);
           } else {
              *iret = 4;
           }
        }

        Py_DECREF(tup_par);
        Py_DECREF(tup_val);
        Py_DECREF(tup2);
        return ;
}

void DEFSPSPPSP(FIINTFC,fiintfc,_IN char *nomfon,_IN STRING_SIZE lfon,
                                _IN INTEGER *nbpu,_IN char *param,_IN STRING_SIZE lpara,
                                _IN DOUBLE *val,
                               _OUT INTEGER *iret,
                                _IN char *coderr, _INOUT STRING_SIZE lcod,
                               _OUT DOUBLE *resuc)
{
    return DEFSPSPPSP(FIINTF,fiintf, nomfon, lfon, nbpu, param, lpara, val, iret,
                                     coderr, lcod, resuc);
}

/* ------------------------------------------------------------------ */
void DEFSSPPPPP(GETVIS_WRAP,getvis_wrap,_IN char *motfac,_IN STRING_SIZE lfac,
                              _IN char *motcle,_IN STRING_SIZE lcle,
                              _IN INTEGER *iocc,
                              _IN INTEGER *iarg,
                              _IN INTEGER *mxval,
                           _INOUT INTEGER *val,
                             _OUT INTEGER *nbval )
{
        /*
          Procedure GETVIS pour le FORTRAN : emule le fonctionnement
          de la procedure equivalente ASTER
          Entrees :
            le nom d un mot cle facteur : motfac (string)
            le nom d un mot cle simple ou sous mot cle : motcle (string)
            le numero de l occurence du mot cle facteur : iocc (entier)
            le numero de l argument demande (obsolete =1): iarg (entier)
            le nombre max de valeur attendues dans val : mxval (entier)
          Retourne :
            le tableau des valeurs attendues : val (tableau d entier )
            le nombre de valeurs effectivement retournees : nbval (entier)
               si pas de valeur nbval =0
               si plus de valeur que mxval nbval <0 et valeur abs = nbre valeurs
               si moins de valeurs que mxval nbval>0 et egal au nombre retourne
        */
        PyObject *res  = (PyObject*)0 ;
        PyObject *tup  = (PyObject*)0 ;
        int ok         = 0 ;
        int nval       = 0 ;
        int idef       = 0 ;
        int ioc        = 0 ;
        char *mfc      = (char*)0 ;
        char *mcs      = (char*)0 ;
                                                 DEBUG_ASSERT((*iocc>0)||(FStrlen(motfac,lfac)==0));
        mfc = MakeCStrFromFStr(motfac,lfac); /* conversion chaine fortran en chaine C */
                                                     DEBUG_ASSERT(mfc!=(char*)0);
        mcs = MakeCStrFromFStr(motcle,lcle);
        /*
                VERIFICATION
                Si le mot-cle simple est recherche sous un mot-cle facteur et uniquement dans ce
                cas, le numero d'occurrence (*iocc) doit etre strictement positif.
                Si le mot-cle simple est recherche sans un mot-cle facteur iocc n'est pas utilise

        */
        if( isalpha(mfc[0])&&(*iocc<=0) )
        {
                printf( "<F> GETVIS : le numero d'occurence (IOCC=%ld) est invalide\n",*iocc) ;
                printf( "             commande : %s\n",
                       PyString_AsString(PyObject_CallMethod(get_sh_etape(),"retnom",""))) ;
                printf( "             mot-cle facteur : %s\n",mfc) ;
                printf( "             mot-cle simple  : %s\n",mcs) ;
                MYABORT( "erreur d'utilisation detectee") ;
        }
        ioc=(int)*iocc ;
        ioc=ioc-1 ;
        res=PyObject_CallMethod(get_sh_etape(),"getvis","ssii",mfc,mcs,ioc,(int)*mxval);

        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");

        ok = PyArg_ParseTuple(res,"iOi",&nval,&tup,&idef);
        if (!ok)MYABORT("erreur dans la partie Python");

        *nbval = (INTEGER)nval;
        if ( nval < 0 ) nval=(int)*mxval;
        convert(nval,tup,val);
        *iarg = (INTEGER)idef;

        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mfc);
        FreeStr(mcs);
        return ;
}


/* ------------------------------------------------------------------ */
#define CALL_GETVTX(a,b,c,d,e,f,g) CALLSSPPPSP(GETVTX_WRAP,getvtx_wrap,a,b,c,d,e,f,g)

void DEFSSPPPSP(GETVTX_WRAP,getvtx_wrap,_IN char *motfac,_IN STRING_SIZE lfac,
                              _IN char *motcle,_IN STRING_SIZE lcle,_IN INTEGER *iocc,
                              _IN INTEGER *iarg,_IN INTEGER *mxval,
                           _INOUT char *txval,_IN STRING_SIZE ltx,_OUT INTEGER *nbval)
{
        /*
          Procedure GETVTX pour le FORTRAN : emule le fonctionnement
          de la procedure equivalente ASTER
          Entrees :
            le nom d un mot cle facteur : motfac (string)
            le nom d un mot cle simple ou sous mot cle : motcle (string)
            le numero de l occurence du mot cle facteur : iocc (entier)
            le numero de l argument demande (obsolete =1): iarg (entier)
            le nombre max de valeur attendues dans val : mxval (entier)
          Retourne :
            le tableau des valeurs attendues : txval (tableau de string)
            ATTENTION : txval arrive avec une valeur par defaut
            le nombre de valeurs effectivement retournees : nbval (entier)
               si pas de valeur nbval =0
               si plus de valeur que mxval nbval <0 et valeur abs = nbre valeurs
               si moins de valeurs que mxval nbval>0 et egal au nombre retourne

        */
        PyObject *res  = (PyObject*)0 ;
        PyObject *tup  = (PyObject*)0 ;
        int ok         = 0 ;
        int nval       = 0 ;
        int idef       = 0 ;
        int ioc        = 0 ;
        char *mfc      = (char*)0 ;
        char *mcs      = (char*)0 ;

        mfc = MakeCStrFromFStr(motfac, lfac);
        mcs = MakeCStrFromFStr(motcle, lcle);
        /*
                VERIFICATION
                Si le mot-cle simple est recherche sous un mot-cle facteur et uniquement dans ce
                cas, le numero d'occurrence (*iocc) doit etre strictement positif.
                Si le mot-cle simple est recherche sans un mot-cle facteur iocc n'est pas utilise

        */
        if( isalpha(mfc[0])&&(*iocc<=0) )
        {
                printf( "<F> GETVTX : le numero d'occurence (IOCC=%ld) est invalide\n",*iocc) ;
                printf( "             commande : %s\n",
                       PyString_AsString(PyObject_CallMethod(get_sh_etape(),"retnom",""))) ;
                printf( "             mot-cle facteur : %s\n",mfc) ;
                printf( "             mot-cle simple  : %s\n",mcs) ;
                MYABORT( "erreur d'utilisation detectee") ;
        }
        ioc=(int)*iocc ;
        ioc=ioc-1 ;
        res=PyObject_CallMethod(get_sh_etape(),"getvtx","ssii",mfc,mcs,ioc,(int)*mxval);

        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)
        {
                printf( "<F> GETVTX : numero d'occurence (IOCC=%ld) \n",*iocc) ;
                printf( "             commande : %s\n",
                       PyString_AsString(PyObject_CallMethod(get_sh_etape(),"retnom",""))) ;
                printf( "             mot-cle facteur : %s\n",mfc) ;
                printf( "             mot-cle simple  : %s\n",mcs) ;
                MYABORT("erreur dans la partie Python");
        }

        ok = PyArg_ParseTuple(res,"iOi",&nval,&tup,&idef);
        if (!ok)MYABORT("erreur au decodage d'une chaine dans le module C aster.getvtx");

        *nbval=(INTEGER)nval;
        if ( nval < 0 ) nval=(int)*mxval;
        if ( nval > 0 ){
                convertxt(nval,tup,txval,ltx);
        }
        *iarg = (INTEGER)idef;
        /* ATTENTION : il ne faut decrementer le compteur de references de res
         *             qu'apres en avoir fini avec l'utilisation de tup.
         *             NE PAS decrementer le compteur de references de tup car
         *             la disparition de res entrainera un decrement automatique
         *             du compteur de tup (res=(nbval,tup))
         */
        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mfc);
        FreeStr(mcs);
        return ;
}

/* ------------------------------------------------------------------ */
void DEFSSPPPSP(GETVID_WRAP,getvid_wrap,_IN char *motfac,_IN STRING_SIZE lfac,
                              _IN char *motcle,_IN STRING_SIZE lcle,_IN INTEGER *iocc,
                              _IN INTEGER *iarg,_IN INTEGER *mxval,
                           _INOUT char *txval,_IN STRING_SIZE ltx,_OUT INTEGER *nbval)
{
        /*
          Procedure GETVID pour le FORTRAN : emule le fonctionnement
          de la procedure equivalente ASTER
          Entrees :
            le nom d un mot cle facteur : motfac (string)
            le nom d un mot cle simple ou sous mot cle : motcle (string)
            le numero de l occurence du mot cle facteur : iocc (entier)
            le numero de l argument demande (obsolete =1): iarg (entier)
            le nombre max de valeur attendues dans val : mxval (entier)
          Retourne :
            le tableau des valeurs attendues : val (tableau de string)
            le nombre de valeurs effectivement retournees : nbval (entier)
               si pas de valeur nbval =0
               si plus de valeur que mxval nbval <0 et valeur abs = nbre valeurs
               si moins de valeurs que mxval nbval>0 et egal au nombre retourne
        */
        PyObject *res  = (PyObject*)0 ;
        PyObject *tup  = (PyObject*)0 ;
        int ok,nval,ioc,idef ;
        char *mfc;
        char *mcs;
                                                 DEBUG_ASSERT((*iocc>0)||(FStrlen(motfac,lfac)==0));
        mfc = MakeCStrFromFStr(motfac,lfac); /* conversion chaine fortran en chaine C */
                                                     DEBUG_ASSERT(mfc!=(char*)0);
        mcs = MakeCStrFromFStr(motcle,lcle);
        /*
                VERIFICATION
                Si le mot-cle simple est recherche sous un mot-cle facteur et uniquement dans ce
                cas, le numero d'occurrence (*iocc) doit etre strictement positif.
                Si le mot-cle simple est recherche sans un mot-cle facteur iocc n'est pas utilise

        */
        if( isalpha(mfc[0])&&(*iocc<=0) )
        {
                printf( "<F> GETVID : le numero d'occurence (IOCC=%ld) est invalide\n",*iocc) ;
                printf( "             commande : %s\n",
                       PyString_AsString(PyObject_CallMethod(get_sh_etape(),"retnom",""))) ;
                printf( "             mot-cle facteur : %s\n",mfc) ;
                printf( "             mot-cle simple  : %s\n",mcs) ;
                MYABORT( "erreur d'utilisation detectee") ;
        }
        ioc=(int)*iocc ;
        ioc=ioc-1 ;
        res=PyObject_CallMethod(get_sh_etape(),"getvid","ssii",mfc,mcs,ioc,(int)*mxval);

        /*  si le retour est NULL : exception Python a transferer
            normalement a l appelant mais FORTRAN ??? */
        if (res == NULL)MYABORT("erreur dans la partie Python");

        ok = PyArg_ParseTuple(res,"iOi",&nval,&tup,&idef);
        if (!ok)MYABORT("erreur dans la partie Python");

        *nbval=(INTEGER)nval;
        if ( nval < 0 ) nval=(int)*mxval;
        if ( nval > 0 ){
                convertxt(nval,tup,txval,ltx);
        }
        *iarg = (INTEGER)idef;

        Py_DECREF(res);                /*  decrement sur le refcount du retour */
        FreeStr(mfc);
        FreeStr(mcs);
        return ;
}


/* ------------------------------------------------------------------ */
void DEFP(PUTVIR,putvir, _IN INTEGER *ival)
{
   /*
      Entrees:
         ival entier à affecter
      Fonction:
         renseigner l'attribut valeur associé à la sd
         n'est utile que pour DEFI_FICHIER, EXTR_TABLE
         cet attribut est ensuite évalué par la méthode traite_value
         de B_ETAPE.py
   */
   PyObject *res = (PyObject*)0 ;

   res = PyObject_CallMethod(get_sh_etape(),"putvir","i",(int)*ival);
   if (res == NULL)
      MYABORT("erreur a l appel de putvir dans la partie Python");

   Py_DECREF(res);
}

void DEFP(PUTVRR,putvrr, _IN DOUBLE *rval)
{
   /*
      Entrees:
         rval réel à affecter
      Fonction:
         renseigner l'attribut valeur associé à la sd
         n'est utile que pour EXTR_TABLE
         cet attribut est ensuite évalué par la méthode traite_value
         de B_ETAPE.py
   */
   PyObject *res = (PyObject*)0 ;

   res = PyObject_CallMethod(get_sh_etape(),"putvrr","d",(double)*rval);
   if (res == NULL)
      MYABORT("erreur a l appel de putvrr dans la partie Python");

   Py_DECREF(res);
}


/* ------------------------------------------------------------------ */
void DEFSSP(GCUCON,gcucon, _IN char *resul, STRING_SIZE lresul,
                           _IN char *concep, STRING_SIZE lconcep, INTEGER *ier)
{
   /*
            Entrees:
               resul   nom du concept
               concep type du concept
            Sorties :
               ier     >0 le concept existe avant
                        =0 le concept n'existe pas avant
                        <0 le concept existe avant mais n'est pas du bon type
            Fonction:
               Verification de l existence du couple (resul,concep) dans les
               resultats produits par les etapes precedentes
   */
   PyObject * res = (PyObject*)0 ;
                                                                           DEBUG_ASSERT(lresul) ;
                                                                           DEBUG_ASSERT(lconcep) ;
   res = PyObject_CallMethod(get_sh_etape(),"gcucon","s#s#",resul,lresul,concep,lconcep);
   /*
               Si le retour est NULL : une exception a ete levee dans le code Python appele
               Cette exception est a transferer normalement a l appelant mais FORTRAN ???
               On produit donc un abort en ecrivant des messages sur la stdout
   */
   if (res == NULL)
            MYABORT("erreur a l appel de gcucon dans la partie Python");

   *ier = (INTEGER)PyInt_AsLong(res);
   Py_DECREF(res);
}


/* ------------------------------------------------------------------ */
void DEFP(GCECDU,gcecdu, INTEGER *numint)
{
        /*
          Sortie :
            numint  numero de l operateur de la commande
          Fonction:
             Recuperation du numero de l operateur
        */
        PyObject * res = (PyObject*)0 ;
        res = PyObject_CallMethod(get_sh_etape(),"getoper","");
        /*
                    Si le retour est NULL : une exception a ete levee dans le code Python appele
                    Cette exception est a transferer normalement a l appelant mais FORTRAN ???
                    On produit donc un abort en ecrivant des messages sur la stdout
        */
        if (res == NULL)
                MYABORT("erreur a l appel de gcecdu dans la partie Python");

        *numint = (INTEGER)PyInt_AsLong(res);
        Py_DECREF(res);
}


/* ------------------------------------------------------------------ */
void gcncon2_(char *type,char *resul,STRING_SIZE ltype,int lresul)
{
/* CCAR : cette fonction devrait s appeler gcncon mais elle est utilisee par
          tous les operateurs (???) et pas seulement dans les macros
          Pour le moment il a ete decide de ne pas l'emuler dans le superviseur
          Python mais d'utiliser les fonctions FORTRAN existantes
          Ceci a l avantage d'assurer la coherence entre tous les operateurs
          et de conserver les fonctionnalites de poursuite pour les macros
*/
        /*
          Entrees:
            type vaut soit
                    '.' : le concept sera detruit en fin de job
                    '_' : le concept ne sera pas detruit

          Sorties:
            resul  nom d'un concept delivre par le superviseur
                   Ce nom est de la forme type // '000ijkl' ou ijkl est un nombre
                   incremente a chaque appel pour garantir l unicite des noms

          Fonction:
            Delivrer un nom de concept non encore utilise et unique
        */
        MYABORT("Cette procedure n est pas implementee");
}

/* ------------------------------------------------------------------ */
static PyObject* aster_prepcompcham(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
        char *nomce, *Fce;
        char *nomcs, *Fcs;
        char *nomcmp, *Fcm;
        char *ktype, *Fty;
        char *groups;
        PyObject *list;
        int inval=0;
        INTEGER nval;
        int long_nomcham=8;
        int long_nomgrp=24;
        int itopo;
        INTEGER topo;

        if (!PyArg_ParseTuple(args, "ssssiO:prepcompcham",
                              &nomce,&nomcs,&nomcmp,&ktype,&itopo,&list)) return NULL;

        Fce = MakeFStrFromCStr(nomce, 8);
        Fcs = MakeFStrFromCStr(nomcs, 8);
        Fcm = MakeFStrFromCStr(nomcmp, 8);
        Fty = MakeFStrFromCStr(ktype, 8);
        inval=PyList_Size(list);
        nval=(INTEGER)inval;
        topo=(INTEGER)itopo;
        if (inval > 0) {
          groups = MakeTabFStr(inval, long_nomgrp);
          converltx(inval,list,groups,long_nomgrp); /* conversion  */
        } else {
          groups = MakeBlankFStr(long_nomgrp);
        }

        try {
            CALL_PRCOCH(Fce,Fcs,Fcm,Fty,&topo,&nval,groups);
        }
        exceptAll {
            FreeStr(groups);
            FreeStr(Fce);
            FreeStr(Fcs);
            FreeStr(Fcm);
            FreeStr(Fty);
            raiseException();
        }
        endTry();
        FreeStr(groups);
        FreeStr(Fce);
        FreeStr(Fcs);
        FreeStr(Fcm);
        FreeStr(Fty);
        Py_INCREF( Py_None ) ;
        return Py_None;
}

/* ------------------------------------------------------------------ */
static char getvectjev_doc[]=
"getvectjev(nomsd)->valsd      \n\
\n\
Retourne la valeur du concept nomsd \n\
dans un tuple.";

static PyObject* aster_getvectjev(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    char *nomsd, *nomsd32;
    char *nomob;
    DOUBLE *f;
    INTEGER *l;
    INTEGER4 *i4;
    char *kvar;
    PyObject *tup=NULL;
    INTEGER lcon, iob;
    int ishf=0, ilng=0;
    INTEGER shf;
    INTEGER lng;
    INTEGER ctype=0;
    int i, ksize=0;
    char *iaddr;

    if (!PyArg_ParseTuple(args, "s|ii:getvectjev",&nomsd,&ishf,&ilng)) return NULL;
    shf = (INTEGER)ishf;
    lng = (INTEGER)ilng;
    iob=0 ;
    nomsd32 = MakeFStrFromCStr(nomsd, 32);
    nomob = MakeBlankFStr(24);

    try {
        CALL_JEMARQ();
        CALL_GETCON(nomsd32,&iob,&shf,&lng,&ctype,&lcon,&iaddr,nomob);
        FreeStr(nomsd32);
        FreeStr(nomob);
        if(ctype < 0){
            /* Erreur : vecteur jeveux inexistant, on retourne None */
            CALL_JEDEMA();
            endTry();
            Py_INCREF( Py_None ) ;
            return Py_None;
        }
        else if(ctype == 0){
            /* Liste vide */
            tup = PyTuple_New( 0 ) ;
        }
        else if(ctype == 1){
            /* REEL */
            f = (DOUBLE *)iaddr;
            tup = PyTuple_New( (Py_ssize_t)lcon ) ;
            for(i=0;i<lcon;i++){
                PyTuple_SetItem( tup, i, PyFloat_FromDouble((double)f[i]) ) ;
            }
        }
        else if(ctype == 2){
            /* ENTIER */
            l = (INTEGER*)iaddr;
            tup = PyTuple_New( (Py_ssize_t)lcon ) ;
            for(i=0;i<lcon;i++){
                PyTuple_SetItem( tup, i, PyInt_FromLong((long)l[i]) ) ;
            }
        }
        else if(ctype == 9){
            /* ENTIER COURT */
            i4 = (INTEGER4*)iaddr;
            tup = PyTuple_New( (Py_ssize_t)lcon ) ;
            for(i=0; i<lcon; i++){
                PyTuple_SetItem( tup, i, PyInt_FromLong((long)i4[i]) ) ;
            }
        }
        else if(ctype == 3){
            /* COMPLEXE */
            f = (DOUBLE *)iaddr;
            tup = PyTuple_New( (Py_ssize_t)lcon ) ;
            for(i=0;i<lcon;i++){
                PyTuple_SetItem( tup, i, PyComplex_FromDoubles((double)f[2*i], (double)f[2*i+1]) ) ;
            }
        }
        else if (ctype == 4 || ctype == 5 || ctype == 6 || ctype == 7 || ctype == 8) {
            switch ( ctype ) {
                case 4 : ksize = 8;  break;
                case 5 : ksize = 16; break;
                case 6 : ksize = 24; break;
                case 7 : ksize = 32; break;
                case 8 : ksize = 80; break;
            }
            /* CHAINE DE CARACTERES */
            tup = PyTuple_New( (Py_ssize_t)lcon ) ;
            for(i=0; i<lcon; i++){
                kvar = iaddr + i*ksize;
                PyTuple_SetItem( tup, i, PyString_FromStringAndSize(kvar, ksize) ) ;
            }
        }
        CALL_JEDETR("&&GETCON.PTEUR_NOM");
        CALL_JEDEMA();
    }
    exceptAll {
        CALL_JEDEMA();
        FreeStr(nomsd32);
        FreeStr(nomob);
        raiseException();
    }
    endTry();
    return tup;
}

static char getcolljev_doc[]=
"getcolljev(nomsd)->valsd      \n\
\n\
Retourne la valeur du concept nomsd \n\
dans un tuple.";

/* ------------------------------------------------------------------ */
static PyObject* aster_getcolljev(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    char *nomsd, *nom, *nomsd32;
    char *nomob;
    DOUBLE *f;
    INTEGER *l;
    INTEGER4 *i4;
    char *kvar;
    PyObject *tup=NULL, *dico, *key;
    INTEGER iob,j,ishf,ilng;
    INTEGER lcon;
    INTEGER ctype=0;
    INTEGER *val, nbval;
    int i, ksize=0;
    char *iaddr;

    if (!PyArg_ParseTuple(args, "s:getcolljev",&nomsd)) return NULL;

    /* Taille de la collection */
    nbval = 1;
    nomsd32 = MakeFStrFromCStr(nomsd, 32);
    nomob = MakeBlankFStr(24);
    val = (INTEGER *)malloc((nbval)*sizeof(INTEGER));
    nom = MakeFStrFromCStr("LIST_COLLECTION", 24);
    CALL_JEMARQ();
    CALL_TAILSD(nom, nomsd32, val, &nbval);
    iob=val[0];
#define DictSetAndDecRef(dico, key, item)   PyDict_SetItem(dico, key, item); \
                                            Py_DECREF(key);  Py_DECREF(item);
    dico = PyDict_New();
    try {
        for (j=1;j<iob+1;j++) {
            ishf=0 ;
            ilng=0 ;
            CALL_GETCON(nomsd32,&j,&ishf,&ilng,&ctype,&lcon,&iaddr,nomob);
            if(nomob[0] == ' '){
                key=PyInt_FromLong( (long)j );
            }
            else {
                key=PyString_FromStringAndSize(nomob,24);
            }
            switch ( ctype ) {
                case 0 :
                    Py_INCREF( Py_None );
                    PyDict_SetItem(dico, key, Py_None);
                    break;
                case 1 :
                    /* REEL */
                    f = (DOUBLE *)iaddr;
                    tup = PyTuple_New( (Py_ssize_t)lcon ) ;
                    for(i=0;i<lcon;i++){
                       PyTuple_SetItem( tup, i, PyFloat_FromDouble((double)f[i]) ) ;
                    }
                    DictSetAndDecRef(dico, key, tup);
                    break;
                case 2 :
                    /* ENTIER */
                    l = (INTEGER*)iaddr;
                    tup = PyTuple_New( (Py_ssize_t)lcon ) ;
                    for(i=0;i<lcon;i++){
                       PyTuple_SetItem( tup, i, PyInt_FromLong((long)l[i]) ) ;
                    }
                    DictSetAndDecRef(dico, key, tup);
                    break;
                case 9 :
                    /* ENTIER COURT */
                    i4 = (INTEGER4*)iaddr;
                    tup = PyTuple_New( (Py_ssize_t)lcon ) ;
                    for(i=0; i<lcon; i++){
                       PyTuple_SetItem( tup, i, PyInt_FromLong((long)i4[i]) ) ;
                    }
                    DictSetAndDecRef(dico, key, tup);
                    break;
                case 3 :
                    /* COMPLEXE */
                    f = (DOUBLE *)iaddr;
                    tup = PyTuple_New( (Py_ssize_t)lcon ) ;
                    for(i=0;i<lcon;i++){
                       PyTuple_SetItem(tup, i,
                                       PyComplex_FromDoubles((double)f[2*i], (double)f[2*i+1]) );
                    }
                    DictSetAndDecRef(dico, key, tup);
                    break;
                case 4 :
                case 5 :
                case 6 :
                case 7 :
                case 8 :
                    switch ( ctype ) {
                        case 4 : ksize = 8;  break;
                        case 5 : ksize = 16; break;
                        case 6 : ksize = 24; break;
                        case 7 : ksize = 32; break;
                        case 8 : ksize = 80; break;
                    }
                    /* CHAINE DE CARACTERES */
                    tup = PyTuple_New( (Py_ssize_t)lcon ) ;
                    for(i=0; i<lcon; i++){
                       kvar = iaddr + i*ksize;
                       PyTuple_SetItem( tup, i, PyString_FromStringAndSize(kvar, ksize) ) ;
                    }
                    DictSetAndDecRef(dico, key, tup);
                    break;
                default :
                    /* Erreur */
                    FreeStr(nom);
                    FreeStr(nomob);
                    FreeStr(nomsd32);
                    free(val);
                    raiseExceptionString(PyExc_KeyError, "Concept inexistant, type inconnu");
            }
        }
        CALL_JEDETR("&&GETCON.PTEUR_NOM");
        CALL_JEDEMA();
        FreeStr(nom);
        FreeStr(nomob);
        FreeStr(nomsd32);
        free(val);
    }
    exceptAll {
        CALL_JEDEMA();
        FreeStr(nom);
        FreeStr(nomob);
        FreeStr(nomsd32);
        free(val);
        raiseException();
    }
    endTry();
    return dico;
}


static char putvectjev_doc[]=
"putvectjev(nomsd, nbval, indices, reel, imag, num)\n\
\n\
Renvoie le contenu d'un objet python dans un vecteur jeveux.\n\
\
    nomsd   : nom du vecteur jeveux\n\
    nbval   : nombre de valeurs\n\
    indices : indices dans le vecteur (commence a 1, de longueur nbval)\n\
    reel    : valeurs reelles ou parties reelles en cas de complexes (de longueur nbval)\n\
    imag    : parties imaginaires en cas de complexes (de longueur nbval)\n\
    num     : 1.\n\
";

/* ------------------------------------------------------------------ */
static PyObject* aster_putvectjev(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    PyObject *tupi  = (PyObject*)0 ;
    PyObject *tupr  = (PyObject*)0 ;
    PyObject *tupc  = (PyObject*)0 ;
    char *nomsd, *nomsd32;
    DOUBLE *valr;
    DOUBLE *valc;
    INTEGER *ind;
    int nind, inum;
    INTEGER num;
    INTEGER nbind;
    int ok        = 0 ;
    INTEGER iret=0;

    ok = PyArg_ParseTuple(args, "siOOOi",&nomsd,&nind,&tupi,&tupr,&tupc,&inum);
    if (!ok)MYABORT("erreur dans la partie Python");
    nomsd32 = MakeFStrFromCStr(nomsd, 32);

    nbind=(INTEGER)nind;
    num=(INTEGER)inum;

    ind = (INTEGER *)malloc((size_t)nind*sizeof(INTEGER));
    valr = (DOUBLE *)malloc((size_t)nind*sizeof(DOUBLE));
    valc = (DOUBLE *)malloc((size_t)nind*sizeof(DOUBLE));

    if ( nind > 0 ){
        convert(nind,tupi,ind);
        convr8(nind,tupr,valr);
        convr8(nind,tupc,valc);
    }
    try {
        CALL_PUTCON(nomsd32,&nbind,ind,valr,valc,&num,&iret);
        free((char *)valc);
        free((char *)valr);
        free((char *)ind);
        FreeStr(nomsd32);
        if (iret == 0) {
            /* Erreur */
            raiseExceptionString(PyExc_KeyError, "Concept inexistant");
        }
    }
    exceptAll {
        free((char *)valc);
        free((char *)valr);
        free((char *)ind);
        FreeStr(nomsd32);
        raiseException();
    }
    endTry();
    Py_INCREF( Py_None );
    return Py_None;
}


static char putcolljev_doc[]=
"putcolljev(nomsd)->valsd      \n\
\n\
Renvoie le contenu d'un objet python dans  \n\
un vecteur jeveux.";

/* ------------------------------------------------------------------ */
static PyObject* aster_putcolljev(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    PyObject *tupi  = (PyObject*)0 ;
    PyObject *tupr  = (PyObject*)0 ;
    PyObject *tupc  = (PyObject*)0 ;
    char *nomsd, *nomsd32;
    DOUBLE *valr;
    DOUBLE *valc;
    INTEGER *ind;
    int nind, inum;
    INTEGER num;
    INTEGER nbind;
    int ok        = 0 ;
    INTEGER iret=0;

    ok = PyArg_ParseTuple(args, "siOOOi",&nomsd,&nind,&tupi,&tupr,&tupc,&inum);
    if (!ok)MYABORT("erreur dans la partie Python");
    nomsd32 = MakeFStrFromCStr(nomsd, 32);
    nbind=(INTEGER)nind;
    num=(INTEGER)inum;

    ind = (INTEGER *)malloc((size_t)nind*sizeof(INTEGER));
    valr = (DOUBLE *)malloc((size_t)nind*sizeof(DOUBLE));
    valc = (DOUBLE *)malloc((size_t)nind*sizeof(DOUBLE));
    if ( nind>0 ){
             convert(nind,tupi,ind);
             convr8(nind,tupr,valr);
             convr8(nind,tupc,valc);
    }
    try {
        CALL_PUTCON(nomsd32,&nbind,ind,valr,valc,&num,&iret);
        free((char *)valc);
        free((char *)valr);
        free((char *)ind);
        FreeStr(nomsd32);
        if(iret == 0){
            /* Erreur */
            raiseExceptionString(PyExc_KeyError, "Concept inexistant");
        }
    }
    exceptAll {
        free((char *)valc);
        free((char *)valr);
        free((char *)ind);
        FreeStr(nomsd32);
        raiseException();
    }
    Py_INCREF( Py_None ) ;
    return Py_None;
}


/* ------------------------------------------------------------------ */
static PyObject* aster_GetResu(self, args)
PyObject *self; /* Not used */
PyObject *args;

/* Construit sous forme d'un dictionnaire Python l'architecture d'une SD resultat

   Arguments :
     IN Nom de la SD resultat
     IN Nature des informations recherchees
          CHAMPS      -> Champs de resultats
          COMPOSANTES -> Liste des composantes des champs
          VARI_ACCES  -> Variables d'acces
          PARAMETRES  -> Parametres


     OUT dico
       Si 'CHAMPS'
       dico['NOM_CHAM'] -> [] si le champ n'est pas calcule
                        -> Liste des numeros d'ordre ou le champ est calcule

       Si 'COMPOSANTES'
       dico['NOM_CHAM'] -> [] si le champ n'est pas calcule
                        -> Liste des composantes du champ (enveloppe sur tous les instants)

       Si 'VARI_ACCES'
       dico['NOM_VA']   -> Liste des valeurs de la variable d'acces

       Si 'PARAMETRES'
       dico['NOM_VA']   -> Liste des valeurs du parametre

*/
{
   INTEGER nbchmx, nbpamx, nbord, numch, numva, ier, nbcmp ;
   INTEGER *liord, *ival;
   INTEGER *val, nbval ;
   DOUBLE *rval;
   char *nomsd, *mode, *liscmp, *nom, *nomsd32, *cmp;
   char *kval, *kvar;
   char *nomch, *nomva;
   int i, lo, ksize=0, ksizemax=80, inbord;
   INTEGER icode, ctype;
   PyObject *dico=NULL, *liste, *key;
   char blanc[80];

   BlankStr(blanc, 80);

   if (!PyArg_ParseTuple(args, "ss",&nomsd, &mode)) return NULL;
   nomsd32 = MakeFStrFromCStr(nomsd, 32);

/* Identifiant de la SD resultat */
   nbval = 3;
   val = (INTEGER *)malloc((nbval)*sizeof(INTEGER));
   nom = MakeFStrFromCStr("LIST_RESULTAT", 24);

/* Taille de la SD resultat : nbr champs, nbr paras, nbr numeros d'ordre */
   CALL_JEMARQ();
   try {
        CALL_TAILSD(nom, nomsd32, val, &nbval);
   }
   exceptAll {
        FreeStr(nomsd32);
        FreeStr(nom);
        free(val);
        raiseException();
   }
   endTry();
   nbchmx = val[0];
   nbpamx = val[1];
   nbord  = val[2];
   inbord = (int)nbord;

    if (strcmp(mode,"CHAMPS") == 0 || strcmp(mode,"COMPOSANTES") == 0) {
/* Construction du dictionnaire : cle d'acces = nom du champ */
        liord  = (INTEGER *)malloc(inbord*sizeof(INTEGER));
        liscmp = MakeTabFStr(500, 8);
        dico = PyDict_New();
        for (numch=1; numch<=nbchmx; numch++) {
            nomch = MakeBlankFStr(16);
            try {
                CALL_RSACCH(nomsd32, &numch, nomch, &nbord, liord, &nbcmp, liscmp);
                inbord = (int)nbord;
                lo = FStrlen(nomch, 16),
                key = PyString_FromStringAndSize(nomch,lo);
                liste = PyList_New(0);
                if (strcmp(mode,"CHAMPS") == 0) {
                    for (i=0; i<inbord; i++)
                        PyList_Append(liste,PyInt_FromLong((long)liord[i]));
                }
                if (strcmp(mode,"COMPOSANTES") == 0) {
                    for (i=0; i<nbcmp; i++) {
                        cmp = &(liscmp[i*8]);
                        lo = FStrlen(cmp, 8);
                        PyList_Append(liste,PyString_FromStringAndSize(cmp,lo));
                    }
                }
                PyDict_SetItem(dico,key,liste);
                Py_XDECREF(key);
                Py_XDECREF(liste);
                FreeStr(nomch);
            }
            exceptAll {
                FreeStr(nomch);
                raiseException();
            }
            endTry();
        }
        free(liord);
        FreeStr(liscmp);
    }
    else if (strcmp(mode,"VARI_ACCES") == 0 || strcmp(mode,"PARAMETRES") == 0) {
        icode = 2;
        if (strcmp(mode,"VARI_ACCES") == 0) {
            icode = 0;
        }
/* Extraction des paramètres ou variables d'accès */
          ival = (INTEGER *)malloc(inbord*sizeof(INTEGER));
          rval = (DOUBLE *)malloc(inbord*sizeof(DOUBLE) );
          kval = MakeTabFStr(inbord, ksizemax);

          dico = PyDict_New();
          for (numva=0; numva<=nbpamx; numva++)
          {
            nomva = MakeBlankFStr(16);
            CALL_RSACPA(nomsd32, &numva, &icode, nomva, &ctype, ival, rval, kval, &ier);
            if (ier != 0) continue;

            lo = FStrlen(nomva, 16);
            key = PyString_FromStringAndSize(nomva,lo);

            liste = PyList_New(0);
            if(ctype < 0){
                /* Erreur */
                PyErr_SetString(PyExc_KeyError, "Type incorrect");
                return NULL;
            }
            else if (ctype == 1) {
                for (i=0; i<inbord; i++) {
                    if (rval[i] != CALL_R8VIDE() ) {
                        PyList_Append(liste, PyFloat_FromDouble((double)rval[i]));
                    } else {
                        PyList_Append(liste, Py_None);
                    }
                }
            }
            else if (ctype == 2) {
                for (i=0; i<inbord; i++) {
                    if (ival[i] != CALL_ISNNEM() ) {
                        PyList_Append(liste, PyInt_FromLong((long)ival[i]));
                    } else {
                        PyList_Append(liste, Py_None);
                    }
                }
            }
            else if (ctype == 4 || ctype == 5 || ctype == 6 || ctype == 7 || ctype == 8) {
                switch ( ctype ) {
                    case 4 : ksize = 8;  break;
                    case 5 : ksize = 16; break;
                    case 6 : ksize = 24; break;
                    case 7 : ksize = 32; break;
                    case 8 : ksize = 80; break;
                }
                for (i=0; i<inbord; i++) {
                    kvar = kval + i*ksizemax;
                    if ( strncmp(kvar, blanc, ksize) != 0 ) {
                        PyList_Append(liste, PyString_FromStringAndSize(kvar, ksize));
                    } else {
                        PyList_Append(liste, Py_None);
                    }
                }
            }
            PyDict_SetItem(dico,key,liste);
            Py_XDECREF(key);
            Py_XDECREF(liste);
            FreeStr(nomva);
          }

          free(ival);
          free(rval);
          FreeStr(kval);
    }
    CALL_JEDEMA();
    FreeStr(nom);
    FreeStr(nomsd32);
    free(val);
    return dico;
}


/* ------------------------------------------------------------------ */
static PyObject* aster_oper(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
        PyObject *temp;
        INTEGER jxvrf=1 ; /* FORTRAN_TRUE */
        int ijxvrf;

        if (!PyArg_ParseTuple(args, "Oi",&temp,&ijxvrf)) return NULL;
        jxvrf = (INTEGER)ijxvrf;
        /* On empile le nouvel appel */
        register_sh_etape(append_etape(temp));

        if ( PyErr_Occurred() ) {
            fprintf(stderr,"Warning: une exception n'a pas ete traitee\n");
            PyErr_Print();
            fprintf(stderr,"Warning: on l'annule pour continuer mais elle aurait\n\
                            etre traitee avant\n");
            PyErr_Clear();
        }

        fflush(stderr) ;
        fflush(stdout) ;

        try {
            /*  appel du sous programme expass pour verif ou exec */
            CALL_EXPASS (&jxvrf);
        }
        exceptAll {
            /* On depile l'appel */
            register_sh_etape(pop_etape());
            raiseException();
        }
        endTry();
        /* On depile l'appel */
        register_sh_etape(pop_etape());
        Py_INCREF(Py_None);
        return Py_None;
}

/* ------------------------------------------------------------------ */
static PyObject* aster_opsexe(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
        PyObject *temp;
        INTEGER oper=0 ;
        int ioper=0;

        if (!PyArg_ParseTuple(args, "Oi",&temp,&ioper)) return NULL;
        oper=(INTEGER)ioper;

        /* On empile le nouvel appel */
        register_sh_etape(append_etape(temp));

        if ( PyErr_Occurred() ) {
            fprintf(stderr,"Warning: une exception n'a pas ete traitee\n");
            PyErr_Print();
            fprintf(stderr,"Warning: on l'annule pour continuer mais elle aurait\n\
                            etre traitee avant\n");
            PyErr_Clear();
        }
        fflush(stderr) ;
        fflush(stdout) ;

        try {
            /*  appel du sous programme opsexe */
            CALL_OPSEXE (&oper);
        }
        exceptAll {
            /* On depile l'appel */
            register_sh_etape(pop_etape());
            raiseException();
        }
        endTry();
        /* On depile l'appel */
        register_sh_etape(pop_etape());
        Py_INCREF(Py_None);
        return Py_None;
}


/* ------------------------------------------------------------------ */
static PyObject * aster_impers(self,args)
PyObject *self, *args; /* Not used */
{
   CALL_IMPERS ();
   Py_INCREF( Py_None ) ;
   return Py_None;
}

/* ------------------------------------------------------------------ */
static PyObject * aster_affich(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
      char *texte;
      char *nomfic;

      if (!PyArg_ParseTuple(args, "ss:affiche",&nomfic,&texte)) return NULL;
      CALL_AFFICH (nomfic,texte);

      Py_INCREF( Py_None ) ;
      return Py_None;
}

/* ------------------------------------------------------------------ */
static PyObject * aster_onFatalError(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
/*
   Cette méthode définie le comportement lors des erreurs Fatales :

   aster.onFatalError('ABORT')
         => on s'arrête avec un JEFINI('ERREUR') dans UTFINM

   aster.onFatalError('EXCEPTION')
         => on lève l'exception aster.error

   aster.onFatalError()
         => retourne la valeur actuelle : 'ABORT' ou 'EXCEPTION'.
*/
      int len;
      INTEGER lng=0;
      char *tmp;
      char *comport;
      PyObject *res=NULL;

      tmp = MakeBlankFStr(16);
      len = -1;
      if (!PyArg_ParseTuple(args, "|s#:onFatalError",&comport ,&len)) return NULL;
      if (len == -1 || len == 0) {
            CALL_ONERRF(" ", tmp, &lng);
            res = PyString_FromStringAndSize(tmp, (Py_ssize_t)lng);

      } else if (strcmp(comport,"ABORT")==0 || strcmp(comport, "EXCEPTION")==0 ||
                 strcmp(comport, "EXCEPTION+VALID")==0 || strcmp(comport, "INIT")==0) {
            CALL_ONERRF(comport, tmp, &lng);
            Py_INCREF( Py_None ) ;
            res = Py_None;

      } else {
            printf("ERREUR : '%s' n'est pas une valeur autorisee.\n", comport);
            MYABORT("Argument incorrect dans onFatalError.");
      }
      FreeStr(tmp);
      return res;
}

/* ------------------------------------------------------------------ */
static PyObject * aster_ulopen(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
        char *fichie;
        char *name;
        char *acces;
        char *autor;
        int iunit=0;
        INTEGER unit ;

        if (!PyArg_ParseTuple(args, "ssssi:ulopen",&fichie,&name,&acces,&autor,&iunit)) return NULL;
        unit=(INTEGER)iunit;
        CALL_ULOPEN (&unit,fichie,name,acces,autor);

        Py_INCREF( Py_None ) ;
        return Py_None;
}


/* ------------------------------------------------------------------ */
static PyObject * aster_fclose(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
        int iunit=0;
        INTEGER unit ;

        if (!PyArg_ParseTuple(args, "i:fclose",&iunit)) return NULL;
        unit=(INTEGER)iunit;
        CALL_FCLOSE (&unit);

        Py_INCREF( Py_None ) ;
        return Py_None;
}


/* ------------------------------------------------------------------ */
static PyObject * aster_gcncon(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    PyObject *res;
    char *type, *Fty, *result;

    if (!PyArg_ParseTuple(args, "s", &type)) return NULL;
    result = MakeBlankFStr(8);
    Fty = MakeFStrFromCStr(type, 1);
    if (CALL_ISJVUP() == 1) {
        try {
            CALL_GCNCON(Fty, result);
        }
        exceptAll {
            FreeStr(result);
            FreeStr(Fty);
            raiseException();
        }
        endTry();
    }
    res = PyString_FromStringAndSize(result,FStrlen(result,8));
    FreeStr(result);
    FreeStr(Fty);
    return res;
}

/* ---------------------------------------------------------------------- */
static char rcvale_doc[] =
"Interface d'appel a la routine fortran RCVALE.\n"
"   Arguments : nommat, phenomene, nompar, valpar, nomres, stop\n"
"   Retourne  : valres, codret (tuples)\n"
" Aucune verification n'est faite sur les arguments d'entree (c'est l'appelant,\n"
" a priori mater_sdaster.rcvale, qui le fait)";

static PyObject * aster_rcvale(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
   char *nommat, *phenom;
   int istop;
   PyObject *t_nompar, *t_valpar, *t_nomres;
   PyObject *t_valres, *t_codret;
   PyObject *t_res;
   int inbres, inbpar;
   INTEGER nbpar, nbres, stop;
   char *nompar, *nomres;
   INTEGER *codret;
   DOUBLE *valpar, *valres;
   int long_nompar = 8;       /* doivent impérativement correspondre aux  */
   int long_nomres = 8;       /* longueurs des chaines de caractères      */
   void *malloc(size_t size);

   if (!PyArg_ParseTuple(args, "ssOOOi", &nommat, &phenom, \
                  &t_nompar, &t_valpar, &t_nomres, &istop)) return NULL;

   /* Conversion en tableaux de chaines et réels */
   inbpar = PyTuple_Size(t_nompar);
   nbpar = (INTEGER)inbpar;
   nompar = MakeTabFStr(inbpar, long_nompar);
   convertxt(inbpar, t_nompar, nompar, long_nompar);

   valpar = (DOUBLE *)malloc(inbpar*sizeof(DOUBLE));
   convr8(inbpar, t_valpar, valpar);

   inbres = PyTuple_Size(t_nomres);
   nbres = (INTEGER)inbres;
   stop = (INTEGER)istop;
   nomres = MakeTabFStr(inbres, long_nomres);
   convertxt(inbres, t_nomres, nomres, long_nomres);

   /* allocation des variables de sortie */
   valres = (DOUBLE *)malloc(inbres*sizeof(DOUBLE));
   codret = (INTEGER *)malloc(inbres*sizeof(INTEGER));

   CALL_RCVALE(nommat, phenom, &nbpar, nompar, valpar, &nbres, nomres, valres, codret, &stop);

   /* création des tuples de sortie */
   t_valres = MakeTupleFloat((long)inbres, valres);
   t_codret = MakeTupleInt((long)inbres, codret);

   /* retour de la fonction */
   t_res = PyTuple_New(2);
   PyTuple_SetItem(t_res, 0, t_valres);
   PyTuple_SetItem(t_res, 1, t_codret);

   FreeStr(nompar);
   free(valpar);
   FreeStr(nomres);
   free(valres);
   free(codret);

   return t_res;
}

/* ---------------------------------------------------------------------- */
static char dismoi_doc[] =
"Interface d'appel a la routine fortran DISMOI.\n"
"   usage: iret, repi, repk = aster.dismoi(question, concept, type_concept, codmes) \n\n"
"     question     : texte de la question\n"
"     concept      : nom du concept\n"
"     type_concept : type du concept\n\n"
"     codmes       :'F','E','A','I',...\n"
"   Retourne :\n"
"     iret         : 0 si ok, 1 en cas d'erreur\n"
"     repi         : reponse entiere\n"
"     repk         : reponse de type chaine de caracteres\n";

static PyObject * aster_dismoi(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    char *codmes, *question, *concept, *typeconcept;
    char *Fcod, *Fque, *Fcon, *Ftyc, *Fres;
    INTEGER repi=0, iret;
    char *repk;
    PyObject *res;

    repk = MakeBlankFStr(32);
    if (!PyArg_ParseTuple(args, "ssss", &question, &concept, &typeconcept, &codmes))
        return NULL;

    Fque = MakeFStrFromCStr(question, 32);
    Fcon = MakeFStrFromCStr(concept, 32);
    Ftyc = MakeFStrFromCStr(typeconcept, 32);
    Fcod = MakeFStrFromCStr(codmes, 1);
    CALL_DISMOI(Fque, Fcon, Ftyc, &repi, repk, Fcod, &iret);
    Fres = MakeCStrFromFStr(repk, 32);

    res = Py_BuildValue("iis", (int)iret, (int)repi, Fres);

    FreeStr(Fcod);
    FreeStr(Fque);
    FreeStr(Fcon);
    FreeStr(Ftyc);
    FreeStr(Fres);
    FreeStr(repk);
    return res;
}

/* ---------------------------------------------------------------------- */
static char getoptdep_doc[] =
"Interface d'appel a la routine fortran CCLIOP.\n"
"   usage: parent_options = aster.get_option_dependency(option) \n\n"
"     option       : option dont on veut les dependances\n"
"   Retourne :\n"
"     parent_options : listes des options parentes\n";

static PyObject * aster_getoptdep(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    char *Fopt, *Fres, *opt;
    int tmax = 100;  /* taille maximale dans OPTDEP/CCLIOP */
    INTEGER nbopt;
    PyObject *res;

    if (!PyArg_ParseTuple(args, "s", &opt))
        return NULL;

    Fopt = MakeFStrFromCStr(opt, 16);
    Fres = MakeBlankFStr(24 * tmax);
    CALL_OPTDEP(Fopt, Fres, &nbopt);

    res = MakeTupleString((long)(nbopt), Fres, 24, NULL);

    FreeStr(Fopt);
    FreeStr(Fres);
    return res;
}

/* ---------------------------------------------------------------------- */
static PyObject * aster_mdnoma(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
        PyObject *temp = (PyObject*)0 ;
        INTEGER lnomam=0;
        INTEGER codret=0;
        char *nomast, *Fnom;
        char *nomamd;

        if (!PyArg_ParseTuple(args, "s",&nomast)) return NULL;
        nomamd = MakeBlankFStr(64);
        Fnom = MakeFStrFromCStr(nomast, 8);
        CALL_MDNOMA (nomamd,&lnomam,Fnom,&codret);

        temp= PyString_FromStringAndSize(nomamd,FStrlen(nomamd, (Py_ssize_t)lnomam));
        FreeStr(nomamd);
        FreeStr(Fnom);
        return temp;
}

/* ------------------------------------------------------------------ */
static PyObject * aster_mdnoch(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    PyObject *temp = (PyObject*)0 ;
    INTEGER lnochm=0;
    INTEGER lresu ;
    int ilresu;
    char *noresu;
    char *nomsym;
    char *nopase;
    INTEGER codret=0;
    char *nochmd, *n1, *n2, *n3;

    if (!PyArg_ParseTuple(args, "isss",&ilresu,&noresu,&nomsym,&nopase)) return NULL;
    nochmd = MakeBlankFStr(64);
    n1 = MakeFStrFromCStr(noresu, 32);
    n2 = MakeFStrFromCStr(nomsym, 16);
    n3 = MakeFStrFromCStr(nopase, 8);
    lresu = (INTEGER)ilresu;
    CALL_MDNOCH (nochmd,&lnochm,&lresu,n1,n2,n3,&codret);
    temp = PyString_FromStringAndSize(nochmd,FStrlen(nochmd, (Py_ssize_t)lnochm));
    FreeStr(nochmd);
    FreeStr(n1);
    FreeStr(n2);
    FreeStr(n3);
    return temp;
}


/* ------------------------------------------------------------------ */
static PyObject * aster_poursu(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
        /*
        FONCTIONALITE : poursuite
        est appele par cata.POURSUITE (cf. ops.py)
        */
        PyObject *temp = (PyObject*)0 ;
        static int nbPassages=0 ;
                                     DEBUG_ASSERT((nbPassages==1)||(get_sh_etape()==(PyObject*)0));
        nbPassages++ ;
        if (!PyArg_ParseTuple(args, "O",&temp)) return NULL;

        /* On empile le nouvel appel */
        register_sh_etape(append_etape(temp));

        if ( PyErr_Occurred() ) {
            fprintf(stderr,"Warning: une exception n'a pas ete traitee\n");
            PyErr_Print();
            fprintf(stderr,"Warning: on l'annule pour continuer mais elle aurait\n\
                            etre traitee avant\n");
            PyErr_Clear();
        }
        fflush(stderr) ;
        fflush(stdout) ;
        try {
            /* appel de la commande POURSUTE */
            CALL_POURSU();
        }
        exceptAll {
            /* On depile l'appel */
            register_sh_etape(pop_etape());
            raiseException();
        }
        endTry();
        /* On depile l'appel */
        register_sh_etape(pop_etape());
        Py_INCREF(Py_None);
        return Py_None;
}

/* ------------------------------------------------------------------ */
static PyObject * aster_debut(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
        PyObject *temp = (PyObject*)0 ;
        static int nbPassages=0 ;
                                     DEBUG_ASSERT((nbPassages==1)||(get_sh_etape()==(PyObject*)0));
        nbPassages++ ;
        if (!PyArg_ParseTuple(args, "O",&temp)) return NULL;

        /* On empile le nouvel appel */
        register_sh_etape(append_etape(temp));

        if ( PyErr_Occurred() ) {
            fprintf(stderr,"Warning: une exception n'a pas ete traitee\n");
            PyErr_Print();
            fprintf(stderr,"Warning: on l'annule pour continuer mais elle aurait\n\
                            etre traitee avant\n");
            PyErr_Clear();
        }
        fflush(stderr) ;
        fflush(stdout) ;
        try {
            /* appel de la commande debut */
            CALL_DEBUT();
        }
        exceptAll {
            /* On depile l'appel */
            register_sh_etape(pop_etape());
            raiseException();
        }
        endTry();
        /* On depile l'appel */
        register_sh_etape(pop_etape());
        Py_INCREF(Py_None);
        return Py_None;
}

/* ------------------------------------------------------------------ */
static PyObject *aster_init(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
   INTEGER ier=0 ;
   int idbg=0;
   INTEGER dbg ; /* FORTRAN_FALSE */

   if (!PyArg_ParseTuple(args, "i",&idbg)) return NULL;
   dbg = (INTEGER)idbg;

   fflush(stderr) ;
   fflush(stdout) ;

   CALL_IBMAIN();

   /* jeveux est parti ! */
   register_sh_jeveux_status(1);

return PyInt_FromLong((long)ier);
}

/* ------------------------------------------------------------------ */
static PyObject *jeveux_getobjects( PyObject* self, PyObject* args)
{
    INTEGER nmax, total;
    char* base;
    PyObject* the_list, *pystr;
    char *dummy;
    char *tmp, *ptr;
    int i;

    if (!PyArg_ParseTuple(args, "s",&base))
        return NULL;

    if (strlen(base)!=1) {
        MYABORT("le type de base doit etre 1 caractere" );
    }

    dummy = MakeBlankFStr(24);
    nmax = 0;
    /* premier appel avec nmax==0 pour connaitre le total */
    CALL_JELST3( base, dummy, &nmax, &total );
    FreeStr(dummy);
    tmp = MakeTabFStr(total, 24);
    nmax = total;
    /* second appel après allocation mémoire */
    CALL_JELST3( base, tmp, &nmax, &total );

    the_list = PyList_New( (Py_ssize_t)total);
    for( i=0, ptr=tmp; i<total;++i, ptr+=24 ) {
        pystr = PyString_FromStringAndSize( ptr, 24 );
        PyList_SetItem( the_list, i, pystr );
    }
    FreeStr( tmp );
    return the_list;
}


/* ------------------------------------------------------------------ */
static PyObject *jeveux_getattr( PyObject* self, PyObject* args)
{
    PyObject *res;
    char *nomobj, *attr;
    char *charval;
    INTEGER intval = 0;

    charval = MakeBlankFStr(32);
    if (!PyArg_ParseTuple(args, "ss",&nomobj,&attr))
        return NULL;
    CALL_JELIRA( nomobj, attr, &intval, charval );

    res = Py_BuildValue( "is", (int)intval, charval );
    FreeStr(charval);
    return res;
}


static PyObject *jeveux_exists( PyObject* self, PyObject* args)
{
    char *nomobj;
    char *tmpbuf;
    INTEGER intval = 0;

    if (!PyArg_ParseTuple(args, "s",&nomobj))
        return NULL;
    tmpbuf = MakeFStrFromCStr(nomobj, 32);
    try {
        CALL_JEEXIN( tmpbuf, &intval );
        FreeStr(tmpbuf);
    }
    exceptAll {
        FreeStr(tmpbuf);
        raiseException();
    }
    endTry();

    if (intval==0) {
        Py_INCREF( Py_False );
        return Py_False;
    } else {
        Py_INCREF( Py_True );
        return Py_True;
    }
}

/* ------------------------------------------------------------------ */
/*   Routines d'interface pour le catalogue de loi de comportement    */
/* ------------------------------------------------------------------ */
void DEFPSS(LCCREE, lccree, _IN INTEGER *nbkit,
                            _IN char *lkit, STRING_SIZE llkit,
                            _OUT char *compor, STRING_SIZE lcompor)
{
/*
   Créer un assemblage de LC composé des comportements listés dans 'list_kit'
   et retourne le nom attribué automatiquement à ce comportement.

      CALL LCCREE(NBKIT, LKIT, COMPOR)
      ==> comport = catalc.create(*list_kit)
*/
   PyObject *catalc, *res, *tup_kit;
   char *scomp;

   catalc = GetJdcAttr("catalc");
   /* transforme le tableau de chaines fortran en tuple */
   tup_kit = MakeTupleString((long)*nbkit, lkit, llkit, NULL);

   res = PyObject_CallMethod(catalc, "create", "O", tup_kit);
   if (res == NULL) {
      MYABORT("Echec lors de la creation du comportement (lccree/create) !");
   }

   scomp = PyString_AsString(res);
   CopyCStrToFStr(compor, scomp, lcompor);

   Py_XDECREF(res);
   Py_XDECREF(tup_kit);
   Py_XDECREF(catalc);
}

/* ------------------------------------------------------------------ */
void DEFSS(LCALGO, lcalgo, _IN char *compor, STRING_SIZE lcompor,
                           _OUT char *algo, STRING_SIZE lalgo
                            )
{
/*
   Retourne le premier algorithme d'intégration

      CALL LCALGO(COMPOR, ALGO)
      ==> algo_inte = catalc.get_algo(COMPOR)
*/
   PyObject *catalc, *res;

   catalc = GetJdcAttr("catalc");
   res = PyObject_CallMethod(catalc, "get_algo", "s#", compor, lcompor);
   if (res == NULL) {
      MYABORT("Echec lors de la recuperation du premier algorithme " \
              "d'integration (lcalgo/get_algo) !");
   }

   convertxt(1, res, algo, lalgo);

   Py_XDECREF(res);
   Py_XDECREF(catalc);
}

/* ------------------------------------------------------------------ */
void DEFSPP(LCINFO, lcinfo, _IN char *compor, STRING_SIZE lcompor,
                            _OUT INTEGER *numlc,
                            _OUT INTEGER *nbvari)
{
/*
   Retourne le numéro de routine et le nbre de variables internes

      CALL LCINFO(COMPOR, NUMLC, NBVARI)
      ==> num_lc, nb_vari = catalc.get_info(COMPOR)
*/
   PyObject *catalc, *res;

   catalc = GetJdcAttr("catalc");
   res = PyObject_CallMethod(catalc, "get_info", "s#", compor, lcompor);
   if (res == NULL) {
      MYABORT("Echec lors de la recuperation des informations sur le " \
              "comportement (lcinfo/get_info) !");
   }

   *numlc  = (INTEGER)PyInt_AsLong(PyTuple_GetItem(res, 0));
   *nbvari = (INTEGER)PyInt_AsLong(PyTuple_GetItem(res, 1));

   Py_XDECREF(res);
   Py_XDECREF(catalc);
}

/* ------------------------------------------------------------------ */
void DEFSPS(LCVARI, lcvari, _IN char *compor, STRING_SIZE lcompor,
                            _IN INTEGER *nbvari,
                            _OUT char *nomvar, STRING_SIZE lnomvar)
{
/*
   Retourne la liste des variables internes

      CALL LCVARI(COMPOR, NBVARI, LVARI)
      ==> nom_vari = catalc.get_vari(COMPOR)
*/
   PyObject *catalc, *res;

   catalc = GetJdcAttr("catalc");
   res = PyObject_CallMethod(catalc, "get_vari", "s#", compor, lcompor);
   if (res == NULL) {
      MYABORT("Echec lors de la recuperation des noms des variables internes du "\
              "comportement (lcvari/get_vari) !");
   }

   convertxt((int)*nbvari, res, nomvar, lnomvar);

   Py_XDECREF(res);
   Py_XDECREF(catalc);
}

/* ------------------------------------------------------------------ */
void DEFSSSP(LCTEST, lctest, _IN char *compor, STRING_SIZE lcompor,
                             _IN char *prop, STRING_SIZE lprop,
                             _IN char *valeur, STRING_SIZE lvaleur,
                             _OUT INTEGER *iret)
{
/*
   Est-ce que VALEUR est un valeur autorisée de PROPRIETE ?
         CALL LCTEST(COMPOR, PROPRIETE, VALEUR, IRET)
         ==> iret = catalc.query(COMPOR, PROPRIETE, VALEUR)
*/
   PyObject *catalc, *res;

   catalc = GetJdcAttr("catalc");
   res = PyObject_CallMethod(catalc, "query", "s#s#s#",
                             compor, lcompor, prop, lprop, valeur, lvaleur);
   if (res == NULL) {
      MYABORT("Echec lors du test d'une propriete du comportement (lctest/query) !");
   }

   *iret = (INTEGER)PyInt_AsLong(res);

   Py_XDECREF(res);
   Py_XDECREF(catalc);
}

/* ----------   FIN catalogue de loi de comportement   -------------- */
/* ------------------------------------------------------------------ */

/* ------------------------------------------------------------------ */
static PyObject *aster_argv( _UNUSED  PyObject *self, _IN PyObject *args )
{
        Py_INCREF( Py_None ) ;
        return Py_None;
}


/* List of functions defined in the module */
static PyMethodDef aster_methods[] = {
                {"onFatalError", aster_onFatalError, METH_VARARGS},
                {"fclose",       aster_fclose,       METH_VARARGS},
                {"ulopen",       aster_ulopen,       METH_VARARGS},
                {"affiche",      aster_affich,       METH_VARARGS},
                {"init",         aster_init,         METH_VARARGS},
                {"debut",        aster_debut,        METH_VARARGS},
                {"poursu",       aster_poursu,       METH_VARARGS},
                {"oper",         aster_oper,         METH_VARARGS},
                {"opsexe",       aster_opsexe,       METH_VARARGS},
                {"impers",       aster_impers,       METH_VARARGS},
                {"mdnoma",       aster_mdnoma,       METH_VARARGS},
                {"mdnoch",       aster_mdnoch,       METH_VARARGS},
                {"rcvale",       aster_rcvale,       METH_VARARGS, rcvale_doc},
                {"dismoi",       aster_dismoi,       METH_VARARGS, dismoi_doc},
                {"get_option_dependency", aster_getoptdep, METH_VARARGS, getoptdep_doc},
                {"argv",         aster_argv,         METH_VARARGS},
                {"prepcompcham", aster_prepcompcham, METH_VARARGS},
                {"getvectjev",   aster_getvectjev,   METH_VARARGS, getvectjev_doc},
                {"putvectjev",   aster_putvectjev,   METH_VARARGS, putvectjev_doc},
                {"putcolljev",   aster_putcolljev,   METH_VARARGS, putcolljev_doc},
                {"getcolljev",   aster_getcolljev,   METH_VARARGS, getcolljev_doc},
                {"GetResu",      aster_GetResu,      METH_VARARGS},
                {"jeveux_getobjects", jeveux_getobjects, METH_VARARGS},
                {"jeveux_getattr", jeveux_getattr,   METH_VARARGS},
                {"jeveux_exists", jeveux_exists,     METH_VARARGS},
                {"get_nom_concept_unique", aster_gcncon, METH_VARARGS},
                {NULL,                NULL}/* sentinel */
};

#ifndef _WITHOUT_PYMOD_
/* Initialization function for the module (*must* be called initaster) */
static char aster_module_documentation[] =
"C implementation of the Python aster module\n"
"\n";

PyMODINIT_FUNC initaster(void)
{
    PyObject *aster = (PyObject*)0 ;
    PyObject *dict = (PyObject*)0 ;

    /* Create the module and add the functions */
    aster = Py_InitModule3("aster", aster_methods, aster_module_documentation);

    /* Add some symbolic constants to the module */
    dict = PyModule_GetDict(aster);
    initExceptions(dict);
    init_etape_stack();
    /* don't take of mpirun arguments */
    aster_mpi_init(0, NULL);
}
#endif
