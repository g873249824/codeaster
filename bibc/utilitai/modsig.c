/* ------------------------------------------------------------------ */
/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2011  EDF R&D              WWW.CODE-ASTER.ORG */
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
/* ------------------------------------------------------------------ */
/*
** Initialisation et modification de l'interception des signaux
** du type Floating Point Exception (FPE)
** Sur CRAY et HPUX seule la l'initialisationest prise en compte
** Sous SOLARIS et WINDOWS NT la detection des erreurs suivantes peut
** etre activee ou non :
**                   underflow
**                   overflow
**                   zerodivide
** La fonction admet en entree deux parametres:
**   enable  =  0      : desactive la detection
**   enable  =  1      : active la detection
**   TypeErreur = INIT       : initialisation par defaut de la detection
**                             (la valeur de enable est ignoree)
**   TypeErreur = UNDERFLOW  : depassement de capacite
**   TypeErreur = OVERFLOW   : depassement de capacite
**   TypeErreur = ZERODIVIDE : division par zero
*/

#include "aster.h"
#include <signal.h>

#ifdef _WINDOWS
#include <float.h>
#endif

#if defined SOLARIS
#include <siginfo.h>
#include <ucontext.h>
  void hanfpe(int sig, siginfo_t *sip, ucontext_t *uap);
#else
  void hanfpe(int sig);
#endif

void DEFPS(MODSIG, modsig, INTEGER *enable, char *TypeErreur, STRING_SIZE lte)
{
#if defined SOLARIS
   static int valsig[3];
   int i;
   if( strncmp ( TypeErreur , "INIT" , lte) == 0 ) {
      for (i=0;i<3;i++) { valsig[0] = 0; }
      }
   else {
     if ( *enable == 1 ) {
       if( strncmp ( TypeErreur , "UNDERFLOW" , lte) == 0 ) {
           valsig[0] = 1 ;
       }
       else if ( strncmp ( TypeErreur , "OVERFLOW" , lte) == 0 ) {
           valsig[1] = 1 ;
       }
       else if ( strncmp ( TypeErreur , "ZERODIVIDE" , lte) == 0 ) {
           valsig[2]= 1 ;
            }
     }
     else if ( *enable == 0 ) {
       if( strncmp ( TypeErreur , "UNDERFLOW" , lte) == 0 ) {
           valsig[0] = -1 ;
       }
       else if ( strncmp ( TypeErreur , "OVERFLOW" , lte) == 0 ) {
           valsig[1] = -1 ;
       }
       else if ( strncmp ( TypeErreur , "ZERODIVIDE" , lte) == 0 ) {
           valsig[2] = -1 ;
       }
     }
   }
   ieee_handler("set","common",hanfpe);
   ieee_handler("clear","invalid",hanfpe);
   if      ( valsig[0] > 0 ) {ieee_handler("set","underflow",hanfpe);}
   else if ( valsig[0] < 0 ) {ieee_handler("clear","underflow",hanfpe);}
   if      ( valsig[1] > 0 ) {ieee_handler("set","overflow",hanfpe);}
   else if ( valsig[1] < 0 ) {ieee_handler("clear","overflow",hanfpe);}
   if      ( valsig[2] > 0 ) {ieee_handler("set","division",hanfpe);}
   else if ( valsig[2] < 0 ) {ieee_handler("clear","division",hanfpe);}
#elif defined _POSIX
   signal(SIGFPE,  hanfpe);
#elif defined _WINDOWS
   unsigned int  _controlfp (unsigned int new, unsigned int mask);
   void _fpreset(void);
   static unsigned int valsig[3];
   unsigned int vmask;
   int i;
   if( strncmp ( TypeErreur , "INIT" , lte) == 0 ) {
      for (i=0;i<3;i++) { valsig[i] = 0; }
      }
   else {
     if ( *enable == 0 ) {
       if( strncmp ( TypeErreur , "UNDERFLOW" , lte) == 0 ) {
           valsig[0] = _EM_UNDERFLOW ;
       }
       else if ( strncmp ( TypeErreur , "OVERFLOW" , lte) == 0 ) {
           valsig[1] = _EM_OVERFLOW ;
       }
       else if ( strncmp ( TypeErreur , "ZERODIVIDE" , lte) == 0 ) {
           valsig[2]= _EM_ZERODIVIDE ;
            }
     }
     else if ( *enable == 1 ) {
       if( strncmp ( TypeErreur , "UNDERFLOW" , lte) == 0 ) {
           valsig[0] = 0 ;
       }
       else if ( strncmp ( TypeErreur , "OVERFLOW" , lte) == 0 ) {
           valsig[1] = 0 ;
       }
       else if ( strncmp ( TypeErreur , "ZERODIVIDE" , lte) == 0 ) {
           valsig[2]= 0 ;
       }
     }
   }
   _fpreset();
   vmask = 0 ;
   for (i=0;i<3;i++) {vmask = vmask + valsig[i];}
   vmask = _EM_INEXACT + vmask ;
   _controlfp(vmask,_MCW_EM);
   signal(SIGFPE,  hanfpe);
#endif
}
