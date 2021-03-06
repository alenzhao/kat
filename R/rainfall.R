#' Rainfall Plot
#'
#' A rainfall plot show the spatial clustering of mutations .. usually point mutations
#' @param VCF a VCF tbl with columns containing at least "chr", "start.position", and "end.position" (a data.frame)
#' @param chrN the chromosome to plot(character)
#' @param lower the lower range of the plot (numeric)
#' @param upper the upper range of the plot x-axis (numeric)
#' @param colour a column to specify point colours (character)
#' @param facets a column to specify plot faceting (character)
#' @param upper the upper range of the plot x-axis (numeric)
#' @keywords rainfall, mutants, kataegesis
#' @export
#' @examples
#' ## before using the rainfall plot you might want to filter the VCF to contain mutations of a certain type.
#' ## For instance this is filtering for APOBEC3A/B type point mutations
#' VCF <- filter(VCF, (WT=="C" & MUT=="T")|(WT=="C" & MUT=="G")|(WT=="G" & MUT=="A")|(WT=="G" & MUT=="C"))
#' ## You might also add a column that can be used for shape or colour, e.g.
#' VCF <- mutate(VCF, mutation_type = ifelse((WT=="C" & MUT=="T")|(WT=="G" & MUT=="A"), "transition", "transversion"))
#' ## Or guess  the strand of the mutation actual
#' VCF <- mutate(VCF, strand = ifelse((WT=="C" & MUT=="T")|(WT=="C" & MUT=="G"), "positive", "negative"))
#' rainfall(VCF, chrN = 6, lower = 1.24e8, upper = 1.4e8, facets="strand", colour="mutation_type")
#'

rainfall <- function(VCF, chrN=1, lower, upper, colour=NULL, facets=NULL, shape=NULL, bursts=F, s=3, gamma=3, vline=NULL, ...){
  library(dplyr)
  library(ggplot2)
  theme_set(theme_bw())

  # filter by chr and range, sort by position, add intermutation distance
  kat <- VCF %>%
    filter(chr == chrN, start.position > lower, end.position < upper) %>%
    arrange(start.position) %>%
    mutate(intermutation=lead(start.position)-start.position) %>%
    filter(intermutation > 1)


  qp <- qplot(x=start.position, y=intermutation, data=kat, geom="point", alpha=I(0.8), size =I(3))+
    scale_y_log10()+
    theme(legend.position="bottom", strip.background=element_rect(fill="white")) +
    scale_x_continuous()

  # add facets for e.g. strand or different samples
  if(!is.null(facets))
    qp <- qp + facet_wrap(as.formula(sprintf("~ %s", facets)))

  # add a colour e.g. for mutation types
  if(!is.null(colour))
    qp <- qp + aes_string(colour=colour) + scale_colour_brewer(palette="Set1") +

  # add a shape e.g. for tarnsition transversion
  if(!is.null(shape))
    qp <- qp + aes_string(shape=shape)

  if(!is.null(vline))
    qp<- qp + geom_vline(x=vline, linetype="longdash")

  # add kleinberg burst detection
  if(bursts==TRUE)
  {
    library(bursts)
    kl= kleinberg(kat$start.position,  s=s, gamma=gamma)
    kl<- kl[kl$level>1,]
    qp <- qp + geom_segment(aes(x = start, xend = end, y=level, yend=level), colour= I(2), size=I(6), data=kl)
  }


  return(qp)
}
