#!/usr/bin/python
#
# ns_per_day.py
#
# Find nanoseconds per day simulation rate from log file
# by averaging time per step using "TIMING:" lines.
# Also need to determine TIMESTEP value.
#
import sys
import string
import math
scaling = 3        # scaling of standard deviation
do_remove = False  # remove outliers?
do_list = False    # list all timings?
do_quiet = False   # print only final ns/day value
fname = ''         # the file name for value
argcnt = len(sys.argv)
i = 1
while i < argcnt:
  arg = sys.argv[i]
  if arg=="-s" or arg=="--scaling":
    if i >= argcnt-1:
      sys.stderr.write('Missing value for scaling\n')
      sys.exit(1)
    scaling = float(sys.argv[i+1])
    i += 1
  elif arg=="-f" or arg=="--file":
    if i >= argcnt-1:
      sys.stderr.write('Missing name of log file\n')
      sys.exit(1)
    fname = sys.argv[i+1]
    i += 1
  elif arg=="-r" or arg=="--remove":
    do_remove = True
  elif arg=="-l" or arg=="--list":
    do_list = True
  elif arg=="-q" or arg=="--quiet":
    do_quiet = True
  elif i < argcnt-1:
    sys.stderr.write('Found extra argument after file name\n')
    sys.exit(1)
  else:
    fname = arg
  i += 1

if fname=='':
  sys.stderr.write('No log file specified\n')

# for debugging
#print 'scaling= ', scaling
#print 'do_remove= ', do_remove
#print 'do_list= ', do_list
#print 'fname= ', fname

f = open(fname, 'r')
dt = 1.0    # assume time step of 1.0 until otherwise specified
tlist = []  # list of timings is initially empty
for line in f:
  s = string.split(line)
  if len(s) > 1 and s[1] == 'TIMESTEP':
    dt = float(s[2])
  if len(s) > 0 and s[0] == 'TIMING:':
    # parse the TIMING line for wall clock seconds per step
    t = float(string.split(s[7],'/')[0])
    tlist.append(t)

n = len(tlist)

# calculate the mean
t_avg = 0.0
for t in tlist:
  t_avg += t
if n > 0:
  t_avg /= n

# calculate the variance
t_var = 0.0
for t in tlist:
  t_var += (t - t_avg)**2
if n > 0:
  t_var /= n

# calculate the standard deviation
t_std = math.sqrt(t_var)

# calculate outlier limit by scaling standard deviation
t_out = scaling * t_std + t_avg

# list all values?
if do_list and not do_quiet:
  print '----------------------------------------'
  print 'Listing %d values:' % n
  for t in tlist:
    if t < t_out:
      print t
    else:
      print t, '  <--- outlier'
  print '----------------------------------------'

# calculate nanoseconds per day
ns_per_day = 0.0
if t_avg != 0.0:
  ns_per_day = (dt / t_avg) * (60 * 60 * 24 * 1e-6)

if not do_quiet:
  # print results
  print 'Nanoseconds per day:    %g' % ns_per_day
  print
  print 'Mean time per step:     %g' % t_avg
  #print 'Variance:               %g' % t_var
  print 'Standard deviation:     %g' % t_std
elif not do_remove:
  print '%g' % ns_per_day

# remove the outliers?
if do_remove:
  nt_avg = 0.0  # calculate new time average
  nt = 0        # new count
  for t in tlist:
    if t < t_out:
      nt_avg += t
      nt += 1
  if nt > 0:
    nt_avg /= nt
  # calculate new variance and standard deviation
  nt_var = 0.0
  for t in tlist:
    if t < t_out:
      nt_var += (t - nt_avg)**2
  if nt > 0:
    nt_var /= nt
  nt_std = math.sqrt(nt_var)
  # calculate new nanoseconds per day
  nns_per_day = 0.0
  if nt_avg != 0.0:
    nns_per_day = (dt / nt_avg) * (60 * 60 * 24 * 1e-6)
  if not do_quiet:
    # print adjusted results
    print '----------------------------------------'
    print 'Remove outliers beyond (avg + %g sigma) = %g' % (scaling, t_out)
    print '(removing %d of %d values)' % (n - nt, n)
    print
    print 'Adjusted nanoseconds per day:    %g' % nns_per_day
    print
    print 'Adjusted mean time per step:     %g' % nt_avg
    #print 'Adjusted variance:               %g' % nt_var
    print 'Adjusted standard deviation:     %g' % nt_std
  else:
    print '%g' % nns_per_day

