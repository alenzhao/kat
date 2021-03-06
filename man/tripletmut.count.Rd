% Generated by roxygen2 (4.0.2): do not edit by hand
\name{tripletmut.count}
\alias{tripletmut.count}
\title{Create a table of types of point mutation
A type of point mutation is TAA> TGA (triplet = "TGA", mutation ="A" )}
\usage{
tripletmut.count(triplets, mutations)
}
\arguments{
\item{triplets}{E.g. TCG, ACT, AAA etc. These might be recovered using the expandSeq function on a VCF file.}

\item{mutations}{The mutation at the centre of the triplet e.g. TCG > TGG is mutation G}
}
\description{
Create a table of types of point mutation
A type of point mutation is TAA> TGA (triplet = "TGA", mutation ="A" )
}
\examples{
qqmutation(VCF, start= "start.position", around=1)
}
\keyword{Poisson,}
\keyword{kataegesis}
\keyword{mutants,}

