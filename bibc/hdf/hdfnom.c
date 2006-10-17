/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF hdfnom hdf  DATE 17/10/2006   AUTEUR MCOURTOI M.COURTOIS */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2003  EDF R&D              WWW.CODE-ASTER.ORG */
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
#include <stdlib.h>
#include "aster.h"
/*-----------------------------------------------------------------------------/
/ R�cup�ration des noms (dataset,group) de chaque entit� contenu dans
/ d'un groupe donn� au sein d'un fichier HDF 
/  Param�tres :
/   - in  idfic : identificateur du fichier (hid_t)
/   - in  nomgr : identificateur du fichier (hid_t)
/  R�sultats :
/     nombre de datasets et de groups
/-----------------------------------------------------------------------------*/
#include "hdf5.h"

INTEGER DEFPSS(HDFNOM, hdfnom, INTEGER *idf, char *nomgr, int ln, char *nom, int lnm)
{
  hid_t idfic;
  char *nomg, *pnomdts, *pnom;   
  int k,l,ind,indx,ll;
  long nbobj=0;
  void *malloc(size_t size);
  
  herr_t indiceName(hid_t loc_id, const char *name, void *opdata);
  herr_t indiceNbName(hid_t loc_id, const char *name, void *opdata);

  idfic=(hid_t) *idf;
  nomg = (char *) malloc((ln+1) * sizeof(char));
  for (k=0;k<ln;k++) {
     nomg[k] = nomgr[k];
  }
  k=ln-1;
  while (nomg[k] == ' ') { k--;}
  nomg[k+1] = '\0';
  indx = H5Giterate(idfic, nomg, NULL, indiceNbName, &nbobj);
  
  pnomdts = (char *) malloc((lnm+1) * sizeof(char));
  pnom=nom;
  for (k=0;k<nbobj;k++) {
    ind =k;
    indx = H5Giterate(idfic, nomg, &ind, indiceName, pnomdts);
    ll=strlen(pnomdts);
    for (l=0;l<ll;l++)
      *(pnom+l) = *(pnomdts+l);
    for (l=ll;l<lnm;l++)
      *(pnom+l) = ' ';
    pnom=pnom+lnm;
  }
  free(nomg);
  free(pnomdts);
  return nbobj; 
}

herr_t indiceName(hid_t id, const char *nom, void *donnees)
{
  char *p;

  p=(char *) donnees;
  strcpy(p,nom);
  return 1;
}
