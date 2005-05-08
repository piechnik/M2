--- status: DRAFT
--- author(s): kummini 
--- notes: 

document {
     Key => "Groebner bases",
     Subnodes => {
	  TO "What is a Groebner basis?",
	  TO "Computing Groebner bases",
	  TO "Normal Forms",
	  --TO "finding a Groebner basis",
	  --TO "rings that are available for Groebner basis computations",
	  --TO "fine control of a Groebner basis computation"
	  }
     }

document {
     Key => "What is a Groebner basis?",
	"A Groebner basis is a specific generating set of an ideal or submodule
	over a polynomial ring. It is not minimal in general, but has extremely
	nice properties; it is reasonably easy to extract information about
	the ideal or submodule from a Groebner basis. We first describe Groebner
	bases in the important special case of an ideal in a polynomial ring. We
	will then describe Groebner bases of submodules, and over more general
	rings.", 
	PARA,
     TEX "Let R = k[x_1, ..., x_n] be a polynomial ring over a field k,
	and let I \\subset R be an ideal.  A <it>monomial order</it>
	on R is a total order, >,  on the monomials of R, which satisfies two
	conditions: (1) m > 1, for every monomial m \\neq 1, and (2) the order is
	multiplicative: m > n implies that mp > np, for all monomials m,n,p.",
     PARA,
	"In ", TT "Macaulay 2", ", each ring has a monomial order associated with
	it. The default is ", TT "GRevLex", ". See ", TO "monomial orderings",
	".",
	PARA,
	"Given a term order, the leading term is the one whose monomial is
	greatest in this order.",
     EXAMPLE {
	  "R = ZZ/1277[a..d]",
    	  "F = 5*a^3 + d^2 + a*d + b*c + 1",
	  "leadTerm F"          
     },
	"For an ideal I \\subseteq R, the initial ideal in(I) is the ideal
	generated by the leading terms of the elements in I. A Groebner basis for
	I is a set of generators for I whose leading terms generate in(I).",
	PARA,
     EXAMPLE {
	  "R = ZZ/1277[x,y];",
    	  "I = ideal(x^3 - 2*x*y, x^2*y - 2*y^2 + x);",
	  "leadTerm I",
	  "gens gb I"
     },
	"The above example also shows that the leading terms of any set of
	generators of I do not necessarily generate in(I).",
	PARA,
	"A Groebner basis for an ideal depends on the monomial ordering used in
	the ring .",
     EXAMPLE {
	  "R = ZZ/1277[x,y, MonomialOrder => Lex];",
    	  "I = ideal(x^3 - 2*x*y, x^2*y - 2*y^2 + x);",
	  "gens gb I"
	  },
	SeeAlso => {"monomial orderings", leadTerm, "Computing Groebner bases",
	"Normal Forms"}
	}

document {
     Key => "Computing Groebner bases",
	"Groebner bases are computed with the ", TT "gb", " command; see ", 
	TO "gb", ". It returns an object of class ", TT "GroebnerBasis", ".",
	EXAMPLE {
	  "R = ZZ/1277[x,y];",
    	  "I = ideal(x^3 - 2*x*y, x^2*y - 2*y^2 + x);",
	  "g = gb I"
     },
	"To get the polynomials in the Groebner basis, use ", TT "gens",
     EXAMPLE {
		"gens g",
		},

	PARA,
	"How do we control the computation of Groebner bases? If we are working
	with homogeneous ideals, we may stop the computation of a Groebner basis
	after S-polynomials up to a certain degree have been handled, with the
	option ", TO "DegreeLimit", ". (This is meaningful only in homogeneous
	cases.)",     
     EXAMPLE {
		   "R = ZZ/1277[x,y,z,w];",
      	  "I = ideal(x*y-z^2,y^2-w^2);",
      	  "g2 = gb(I,DegreeLimit => 2)",
		  "gens g2",
		  },
	"The result of the computation is stored internally, so when ", TT "gb",
	"is called with a higher degree limit, only the additionally required
	computation is done.",
     EXAMPLE {
      	  "g3 = gb(I,DegreeLimit => 3);",
		  "gens g3",
	  },
     PARA,
     "The second computation advances the state of the Groebner
     basis object started by the first, and the two results are
     exactly the same Groebner basis object.",
     EXAMPLE {
	  "g2",
	  "g2 === g3"
	  },
     "The option ", TO "PairLimit", " can be used to stop after a certain
     number of S-polynomials have been reduced.  After being reduced, the
     S-polynomial is added to the basis, or a syzygy has been found.",
     EXAMPLE {
      	  "I = ideal(x*y-z^2,y^2-w^2)",
      	  "gb(I,PairLimit => 2)",
      	  "gb(I,PairLimit => 3)"
	  },
     "The option ", TO "BasisElementLimit", " can be used to stop after a
     certain number of basis elements have been found.",
     EXAMPLE {
      	  "I = ideal(x*y-z^2,y^2-w^2)",
      	  "gb(I,BasisElementLimit => 2)",
      	  "gb(I,BasisElementLimit => 3)"
	  },
     "The option ", TO "CodimensionLimit", " can be used to stop after the
     apparent codimension, as gauged by the leading terms of the basis
     elements found so far, reaches a certain number.",
     PARA,
     "The option ", TO "SubringLimit", " can be used to stop after a certain
     number of basis elements in a subring have been found.  The subring is
     determined by the monomial ordering in use.  For ", TT "Eliminate n", "
     the subring consists of those polynomials not involving any of the first
     ", TT "n", " variables.  For ", TT "Lex", " the subring consists of those
     polynomials not involving the first variable.  For
     ", TT "ProductOrder {m,n,p}", " the subring consists of those polynomials
     not involving the first ", TT "m", " variables.",
     PARA,
     "Here is an example where we are satisfied to find one relation
     from which the variable ", TT "t", " has been eliminated.",
     EXAMPLE {
	  "R = ZZ/1277[t,F,G,MonomialOrder => Eliminate 1];",
	  "I = ideal(F - (t^3 + t^2 + 1), G - (t^4 - t))",
	  "transpose gens gb (I, SubringLimit => 1)",
	  },
     PARA,
     "Sometimes a Groebner basis computation can seem to last forever.  An ongoing     
     visual display of its progress can be obtained with ", TO "gbTrace", ".",
     EXAMPLE {
	  "gbTrace = 3",
      	  "I = ideal(x*y-z^2,y^2-w^2)",
     	  "gb I",
	  },
     "Here is what the tracing symbols indicate.",
     PRE ///    {2}   ready to reduce S-polynomials of degree 2
    (0)   there are 0 more S-polynomials (the basis is empty)
     g    the generator yx-z2 has been added to the basis
     g    the generator y2-w2 has been added to the basis
    {3}   ready to reduce S-polynomials of degree 3
    (1)   there is 1 more S-polynomial
     m    the reduced S-polynomial yz2-xw2 has been added to the basis
    {4}   ready to reduce S-polynomials of degree 4
    (2)   there are 2 more S-polynomials
     m    the reduced S-polynomial z4-x2w2 has been added to the basis
     o    an S-polynomial reduced to zero and has been discarded
    {5}   ready to reduce S-polynomials of degree 5
    (1)   there is 1 more S-polynomial
     o    an S-polynomial reduced to zero and has been discarded
///,     
     PARA,
     "Let's turn off the tracing.",
     EXAMPLE {
	  "gbTrace = 0"
	  },
     PARA,
     "Each of the operations dealing with Groebner bases may be
     interrupted or stopped (by typing CTRL-C).  The computation
     is continued by re-issuing the same command.  Alternatively, the
     command can be issued with the option ", TT "StopBeforeComputation => true", ".
     It will stop immediately, and return a Groebner basis object that can
     be inspected with ", TO "gens", " or ", TO "syz", ".
     The computation can be continued later.",
	EXAMPLE {
		   "R = ZZ/1277[x..z];",
		   "I = ideal(x*y+y*z, y^2, x^2);",
		   "g = gb(I, StopBeforeComputation => true)",
		   "gens g"
	},
     PARA,
     "The function ", TO "forceGB", " can be used to create a Groebner
     basis object with a specified Groebner basis.  No computation is
     performed to check whether the specified basis is a Groebner
     basis.",
     PARA,
     "If the Poincare polynomial (or Hilbert function) for a homogeneous
     submodule ", TT "M", " is known, you can speed up the computation of a
     Groebner basis by informing the system.  This is done by storing
     the Poincare polynomial in ", TT "M.cache.poincare", ".",
     PARA,
     "As an example, we compute the Groebner basis of a random ideal,
     which is almost certainly a complete intersection, in which
     case we know the Hilbert function already.",
     EXAMPLE {
		   "R = ZZ/1277[a..e];",
      	  "T = (degreesRing R)_0",
      	  "f = random(R^1,R^{-3,-3,-5,-6});",
      	  "time betti gb f"
	  },
     "The matrix was randomly chosen, and we'd like to use the same one
     again, but this time with a hint about the Hilbert function, so first
     we must erase the memory of the Groebner basis computed above.",
     EXAMPLE {
	  "remove(f.cache,{false,0})",
	  },
     "Now we provide the hint and compute the Groebner basis anew.",
     EXAMPLE {
      	  "(cokernel f).cache.poincare = (1-T^3)*(1-T^3)*(1-T^5)*(1-T^6)",
      	  "time betti gb f"
	  },
     "The computation turns out to be substantially faster."
     }

document {
	Key => "Normal Forms",

     "Let R = k[x_1, ..., x_n] be a polynomial ring over a field k,
	and let I \\subset R be an ideal. Let \{g_1, ..., g_t\} be a Groebner
	basis for I. For any f in R, there is a unique `remainder' r in R such
	that no term of r is divisible by the leading term of any g_i and such
	that f-r belongs to I. This polynomial r is sometimes called the normal
	form of f.",

	SeeAlso => {"Computing Groebner bases", (symbol %, RingElement, Ideal)},
	}
