#!/usr/bin/env python2
# -*- coding: utf-8 -*-

__author__ = "Kurt Pagani <nilqed@gmail.com>"
__svn_id__ = "$Id: spadtex.py 1 2018-04-27 18:11:03Z pagani $"


# Default parameters
type_color = r"blue"
type_size = r"\scriptsize"
tex_color = r"black"
tex_size = r"\normalsize"


# Templates (TeX)

pretex1 = r"\(\def\sp{^}\def\sb{_}\def\leqno(#1){}\)"
pretex2 = r"\(\def\erf\{\mathrm{erf}}\def\sinh{\mathrm{sinh}}\)"
pretex3 = r"\(\def\zag#1#2{{{ \left.{#1}\right|}\over{\left|{#2}\right.}}}\)"
pretex4 = r"\(\require{color}\)"
pretex = pretex1+pretex2+pretex3+pretex4
ljax = r"$$"  # variants: r"\("
rjax = r"$$"  #           r"\)"

# texout_types.format(tex_color,tex_size,tex,type_color,type_size,type)
texout_types = r"""
{{\color{{{0}}} {1} {2}}} \\[0.9ex] {{\color{{{3}}} {4} \text{{{5}}}}} \\
"""

# texout.format(tex_color,tex_size,tex)
texout = r"""
{{\color{{{0}}} {1} {2}}}
"""

def makeTeX(rawtex):
    r = rawtex.strip().strip('$$')
    r = texout.format(tex_color,tex_size,r)
    r = pretex + ljax + r + rjax
    return r

def makeTeXType(rawtex,rawtype):
    r = rawtex.strip().strip('$$')
    r = texout_types.format(tex_color,tex_size,r,type_color,type_size,rawtype)
    r = pretex + ljax + r + rjax
    return r    
    