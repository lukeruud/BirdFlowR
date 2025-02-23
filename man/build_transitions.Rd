% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/build_transitions.R
\name{build_transitions}
\alias{build_transitions}
\alias{drop_transitions}
\title{add or drop transition matrices}
\usage{
build_transitions(x, rebuild = FALSE)

drop_transitions(x)
}
\arguments{
\item{x}{BirdFlow object}

\item{rebuild}{set to TRUE to rebuild transitions if they are already
present.}
}
\value{
BirdFlow object with transition matrices
}
\description{
Given a BirdFlow object with marginals and without transitions
\code{build_transitions()} return a BirdFlow object with both marginals
and transitions, \code{drop_tansitions()} will reverse the process.
}
\examples{
\dontrun{
bf1 <- BirdFlowModels::amewoo
bf2 <- build_transitions(bf)
bf2

bf3 <- drop_transitions(bf2)
bf3
}
}
\seealso{
\code{\link[=has_transitions]{has_transitions()}}
}
