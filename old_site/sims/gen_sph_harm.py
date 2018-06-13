#!/usr/bin/env python
'''
Automatic Code Generator for a spherical harmonics function .js library.

Format for written functions:
function y_lm(l,m) {

}
'''

import numpy as np
import math

N = 8
# theta = np.linspace(0,np.pi/2,N/2)
# phi = np.linspace(0,2*np.pi,N)
#
# x = []
# y = []
# z = []
#
# for t in theta:
#     for p in phi:
#         x.append(np.sin(t)*np.cos(p))
#         y.append(np.sin(t)*np.sin(p))
#
# z_data = []
# for xi in x:
#     vec = []
#     for yi in y:
#         vec.append(np.sqrt(1. - xi*xi - yi*yi))
    # z.append(vec)
u = np.linspace(-1,1,N/2)
phi = np.linspace(0,2*np.pi,N)
x = []
y = []
z = []
for ui in u:
    for p in phi:
        x.append(np.sqrt(1-ui*ui) * np.cos(p))
        y.append(np.sqrt(1-ui*ui) * np.sin(p))

print "var x_data=",x
print "var y_data=",y
print "var z_data=",z
print len(x)
print len(y)
print len(z)

fileName = "sph_harm.js"
max_l = 10
max_m = 10

# with open(fileName, "w") as f:
