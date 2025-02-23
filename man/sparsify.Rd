% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sparsify.R
\name{sparsify}
\alias{sparsify}
\title{sparsify BirdFlow models}
\usage{
sparsify(x, method, p, fix = TRUE)
}
\arguments{
\item{x}{A BirdFlow model}

\item{method}{One of \code{"state"}, \code{"conditional"}, \code{"marginal"}, or \code{"model"};
or \code{"state"} paired with one of the other methods in a character
vector (\code{c("state", "marginal")}) or a single string
(\code{"state+conditional"}). See "Methods" section below for details.}

\item{p}{Required unless \code{method = "state"} to control the proportion of the
probability density retained in the sparsification process. See "Methods"
below.}

\item{fix}{if TRUE call \code{\link[=fix_dead_ends]{fix_dead_ends()}} to eliminate dead ends
in the sparse model. Defaults to TRUE, unless the method is "state" in
which case it will be forced to FALSE as the state method does not
create dead ends.}
}
\value{
A BirdFlow object with many values in the marginals set to zero. The
metadata will also be updated with sparsification statistics. The
marginals will be standardized so that they sum to 1.
}
\description{
Set low values to zero in a BirdFlow model marginals to reduce object size.
}
\details{
The BirdFlow model fitting algorithm cannot predict a complete zero, however
many of the marginal values are very close to zero and have little
impact on the model predictions. \code{sparsify()} forces small values to
zero with the goal of saving memory, reducing file size, and decreasing run
time. Marginals are stored as sparse matrices
(\link[Matrix:Matrix]{Matrix::Matrix(x , sparse = TRUE)} ) so only non-zero
values consume memory.
}
\section{Methods}{
 There are four sparsification methods. The first "state"
does not use any parameters and eliminates model states entirely.

The three remaining proportion based methods all use \code{p} to control the
amount of sparsification; where \code{p} is the target
proportion of the density to retain after eliminating all values below a
(calculated) threshold.

In the different proprtional methods the thresholds are calculated and
applied either to the whole model (\code{model})  or repeatedly to its
components (\code{conditional}, \code{marginal}).

\describe{
\item{\code{state}}{State based sparsification eliminates states (in time and
space) that are zero in the training, ebirdst, distributions, from
from the marginals

For each marginal rows are zeroed out that correspond to zeroes in the
preceding timestep's distribution and columns are zeroed out that correspond
to zeroes in the following timestep's distribution.  Thus all the cells in
the marginal that represent a joint probability involving a state that is
zero in either of the distributions are zeroed out, essentially dropping
those states from the model.
}

\item{\code{model}}{ In model sparsification the values from all marginals are
pooled and then a threshold is chosen for that entire model such that zeroing
values below the threshold results in the target proportion, \code{p}, of the
model's density remaining.}

\item{\code{marginal}}{A threshold is chosen and applied separately to each
marginal in the model.  Ultimately, \code{p} is achieved for the model as a whole
but the threshold below which cells are set to zero varies across marginals.
}

\item{\code{conditional}}{ This method targets (1 - p) of both the forward and
backward conditional probabilities to be zeroed out.

Conditional probability is calculating by dividing cells in each row
or column by that row or columns total.

In this method thresholds are chosen independently for each row and each
column of a marginal prior to any zeroing and then the cells that fall
below either their row or column thresholds are set to zero.

This likely results in each marginal and the model as a whole retaining
less than \code{p} of the density. Theoretically somewhere between p - 1 and
2 * (p - 1) of the density will be lost. The higher value would be
achieved if the row and column methods don't overlap at all in the cells
they select; and the lower value if there's complete agreement. In practice
the dropped proportion will likely be near the middle of that range.
Ultimately for all the proportional methods \code{p} should be tuned based on the
performance of the sparsified model, so even though this method does not hit
the target precisely it will still work as a tuning parameter.
}
}

It's possible to combine any of the proportional methods with the state based
method by passing two methods as a vector. If this is done the state based
sparsification is done second as it is not affected by the values in the
marginal.
}

\examples{

\dontrun{
# Full models are huge so we don't distribute them.
# Assuming you have an hdf5 file wit a full model you could run:
bf <- import_birdflow(hdf5_path)
sbf <- sparsify(bf, method = "marginal+state", p = 0.99)
}
}
