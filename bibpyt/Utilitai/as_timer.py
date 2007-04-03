#@ MODIF as_timer Utilitai  DATE 02/04/2007   AUTEUR COURTOIS M.COURTOIS 
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

"""
   Definition of ASTER_TIMER class.
"""

__revision__ = "$Id: as_timer.py 2860 2007-02-12 08:37:17Z courtois $"

# ----- differ messages translation
def _(mesg):
   return mesg

import os
import time

#-------------------------------------------------------------------------------
def _dtimes():
   """Returns a dict of cpu, system and total times.
   """
   l_t = os.times()
   return { 'cpu'   : (l_t[0], l_t[2]),
            'sys'   : (l_t[1], l_t[3]),
            'tot'   : l_t[4], }

#-------------------------------------------------------------------------------
def _conv_hms(t):
   """Convert a number of seconds in hours, minutes, seconds.
   """
   h = int(t/3600)
   m = int(t % 3600)/60
   s = (t % 3600) % 60
   return h, m, s

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
class ASTER_TIMER:
   """This class provides methods to easily measure time spent during
   different steps.
   Methods :
      Start : start a timer in mode 'INIT' ([re]start from 0) or 'CONT'
         (restart from last value).
      Stop  : stop a timer
   Attributes :
      timers : dict {
         timer_id : {
            'name'   : timer legend (=timer_id by default),
            'state'  : state,
            'cpu_t0' : initial cpu time,
            'cpu_dt' : spent cpu time,
            'sys_t0' : initial system time,
            'sys_dt' : spent system time,
            'tot_t0' : start time,
            'tot_dt' : total spent time,
            'num'    : timer number (to print timers in order of creation),
            'hide'   : boolean,
         },
         ...
      }
         state is one of 'start', 'stop'
   """
   MaxNumTimer = 9999999

#-------------------------------------------------------------------------------
   def __init__(self, add_total=True, format='as_run'):
      """Constructor
      """
      # ----- initialisation
      self.timers = {}
      self.add_total = add_total
      
      if not format in ('as_run', 'aster'):
         format = 'as_run'
      
      if format == 'as_run':
         self.fmtlig = '   %(name)-26s  %(cpu_dt)9.2f  %(sys_dt)9.2f  %(cpu_sys)9.2f  %(tot_dt)9.2f'
         self.fmtstr = '   %(title)-26s  %(cpu)9s  %(sys)9s  %(cpu+sys)9s  %(elapsed)9s'
         self.sepa   = ' ' + '-'*74
         self.TotalKey = _('Total time')
         self.d_labels = {
            'title'   : '',
            'cpu'     : _('cpu'),
            'sys'     : _('system'),
            'cpu+sys' : _('cpu+sys'),
            'elapsed' : _('elapsed'),
         }
      elif format == 'aster':
         self.fmtlig = ' * %(name)-16s : %(cpu_dt)10.2f : %(sys_dt)10.2f : %(cpu_sys)10.2f : %(tot_dt)10.2f *'
         self.fmtstr = ' * %(title)-16s : %(cpu)10s : %(sys)10s : %(cpu+sys)10s : %(elapsed)10s *'
         self.sepa   = ' ' + '*'*72
         self.TotalKey = 'TOTAL_JOB'
         self.d_labels = {
            'title'   : 'COMMAND',
            'cpu'     : 'USER',
            'sys'     : 'SYSTEM',
            'cpu+sys' : 'USER+SYS',
            'elapsed' : 'ELAPSED',
         }      
      
      self.total_key = id(self)
      if self.add_total:
         self.Start(self.total_key, name=self.TotalKey, num=self.MaxNumTimer)

#-------------------------------------------------------------------------------
   def Start(self, timer, mode='CONT', num=None, hide=False, name=None):
      """Start a new timer or restart one
      """
      name = name or str(timer)
      isnew = not timer in self.timers.keys()
      if not num:
         num = len(self.timers)
      if mode == 'INIT':
         num = self.timers[timer]['num']
      dico = _dtimes()
      if isnew or mode == 'INIT':
         self.timers[timer] = {
            'name'   : name,
            'state'  : 'start',
            'cpu_t0' : dico['cpu'],
            'cpu_dt' : 0.,
            'sys_t0' : dico['sys'],
            'sys_dt' : 0.,
            'tot_t0' : dico['tot'],
            'tot_dt' : 0.,
            'num'    : num,
            'hide'   : hide,
         }
      elif mode == 'CONT' and self.timers[timer]['state'] == 'stop':
         self.timers[timer].update({
            'state'  : 'start',
            'cpu_t0' : dico['cpu'],
            'sys_t0' : dico['sys'],
            'tot_t0' : dico['tot'],
         })

#-------------------------------------------------------------------------------
   def Stop(self, timer, hide=False):
      """Stop a timer
      """
      if not timer in self.timers.keys():
         self.timers[timer] = {
            'name'   : str(timer),
            'hide'   : hide,
            'state'  : 'stop',
            'cpu_t0' : 0.,
            'cpu_dt' : 0.,
            'sys_t0' : 0.,
            'sys_dt' : 0.,
            'tot_t0' : 0.,
            'tot_dt' : 0.,
            'num': len(self.timers),
         }
      elif self.timers[timer]['state'] == 'start':
         dico = _dtimes()
         self.timers[timer]['state'] = 'stop'
         for i in range(len(dico['cpu'])):
            self.timers[timer]['cpu_dt'] += \
               dico['cpu'][i] - self.timers[timer]['cpu_t0'][i]
         self.timers[timer]['cpu_t0'] = dico['cpu']
         for i in range(len(dico['sys'])):
            self.timers[timer]['sys_dt'] += \
               dico['sys'][i] - self.timers[timer]['sys_t0'][i]
         self.timers[timer]['sys_t0'] = dico['sys']
         self.timers[timer]['tot_dt'] = self.timers[timer]['tot_dt'] + \
               dico['tot'] - self.timers[timer]['tot_t0']
         self.timers[timer]['tot_t0'] = dico['tot']

#-------------------------------------------------------------------------------
   def StopAndGet(self, timer, *args, **kwargs):
      """Stop a timer and return "delta" values.
      """
      self.Stop(timer, *args, **kwargs)
      cpu_dt  = self.timers[timer]['cpu_dt']
      sys_dt  = self.timers[timer]['sys_dt']
      tot_dt  = self.timers[timer]['tot_dt']
      return cpu_dt, sys_dt, tot_dt

#-------------------------------------------------------------------------------
   def StopAndGetTotal(self):
      """Stop the timer and return total "delta" values.
      """
      return self.StopAndGet(self.total_key)

#-------------------------------------------------------------------------------
   def StopAll(self):
      """Stop all timers
      """
      lk = self.timers.keys()
      if self.add_total:
         lk.remove(self.total_key)
      for timer in lk:
         self.Stop(timer)

#-------------------------------------------------------------------------------
   def __repr__(self):
      """Pretty print content of the timer.
      NB : call automatically StopAll
      """
      self.StopAll()
      if self.add_total:
         self.Stop(self.total_key)
      
      labels = self.fmtstr % self.d_labels
      out = ['']
      # get timers list and sort by 'num'
      lnum = [[val['num'], timer] for timer, val in self.timers.items() if not val['hide']]
      lnum.sort()
      if lnum:
         out.append(self.sepa)
         if self.add_total and labels:
            out.append(labels)
            out.append(self.sepa)
      for num, timer in lnum:
         d_info = self.timers[timer].copy()
         d_info['cpu_sys'] = d_info['cpu_dt'] + d_info['sys_dt']
         if self.add_total and num == self.MaxNumTimer and len(lnum)>1:
            out.append(self.sepa)
         out.append(self.fmtlig % d_info)
      if lnum:
         out.append(self.sepa)
      out.append('')
      return os.linesep.join(out)

#-------------------------------------------------------------------------------
if __name__ == '__main__':
   chrono = ASTER_TIMER(format='aster')
   chrono.Start('Compilation')
   chrono.Start('CALC_FONCTION')
   chrono.Start(23, name='CALC_FONCTION')
   time.sleep(0.4)
   chrono.Stop('Compilation')
   chrono.Stop(23)
   chrono.Start('Child')
   print chrono
