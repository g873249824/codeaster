/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF fetsco scotch  DATE 02/06/2006   AUTEUR MCOURTOI M.COURTOIS */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2005  EDF R&D              WWW.CODE-ASTER.ORG */
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
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO : EDF R&D CODE_ASTER,    */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */
#include <stdio.h>
#include "common.h"
#include "scotch.h"

#if  defined IRIX || P_LINUX || TRU64 || LINUX64 || SOLARIS || SOLARIS64
void fetsco_ ( int *nbmato, int *nblien, int *connect, int *idconnect, int *nbpart, int *mapsd, int *edlo, int *velo,int err)
#elif defined HPUX
void fetsco ( int *nbmato, int *nblien, int *connect, int *idconnect, int *nbpart, int *mapsd, int *edlo, int *velo,int err)
#elif defined PPRO_NT
void __stdcall FETSCO ( int *nbmato, int *nblien, int *connect, int *idconnect, int *nbpart, int *mapsd, int *edlo, int *velo,int err)
#endif
{

  SCOTCH_Graph        grafdat;
  SCOTCH_Arch         archdat; 
  SCOTCH_Strat        mapstrat;  
  SCOTCH_Mapping      mapdat;  

  err=0;

  err = SCOTCH_graphInit (&grafdat);
  
  if ( err == 0 )
    err = SCOTCH_graphBuild(&grafdat,1,*nbmato,idconnect,NULL,velo,NULL,*nblien,connect,edlo);

  if ( err == 0 ) 
    err = SCOTCH_graphCheck (&grafdat);

  if ( err == 0 ) 
    err = SCOTCH_archInit (&archdat);                     

  if ( err == 0 ) 
    err = SCOTCH_archCmplt (&archdat,*nbpart);   

  if ( err == 0 ) 
    err = SCOTCH_stratInit (&mapstrat);                     

  if ( err == 0 ) 
    err = SCOTCH_graphMapInit (&grafdat, &mapdat, &archdat,mapsd);

  if ( err == 0 ) 
    err =  SCOTCH_graphMapCompute (&grafdat, &mapdat, &mapstrat);

  if ( err == 0 ) {
    SCOTCH_stratExit (&mapstrat);
    SCOTCH_graphMapExit (&grafdat, &mapdat);
    SCOTCH_archExit     (&archdat);
    SCOTCH_graphExit    (&grafdat);
  }

}

