% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inputs.R
\name{robyn_inputs}
\alias{robyn_inputs}
\title{Input data sanity check & transformation}
\usage{
robyn_inputs(
  dt_input = NULL,
  dt_holidays = NULL,
  date_var = "auto",
  dep_var = NULL,
  dep_var_type = NULL,
  prophet_vars = NULL,
  prophet_signs = NULL,
  prophet_country = NULL,
  context_vars = NULL,
  context_signs = NULL,
  paid_media_vars = NULL,
  paid_media_signs = NULL,
  paid_media_spends = NULL,
  organic_vars = NULL,
  organic_signs = NULL,
  factor_vars = NULL,
  adstock = NULL,
  hyperparameters = NULL,
  window_start = NULL,
  window_end = NULL,
  cores = parallel::detectCores(),
  iterations = 2000,
  trials = 5,
  nevergrad_algo = "TwoPointsDE",
  calibration_input = NULL,
  InputCollect = NULL,
  ...
)
}
\arguments{
\item{dt_input}{A data.frame. Raw input data. Load simulated
dataset using \code{data("dt_simulated_weekly")}}

\item{dt_holidays}{A data.frame. Raw input holiday data. Load standard
Prophet holidays using \code{data("dt_prophet_holidays")}}

\item{date_var}{A character. Name of date variable. Daily, weekly
and monthly data supported. Weekly requires weekstart of Monday or Sunday.
date_var must have format "2020-01-01". Default to automatic date detection.}

\item{dep_var}{Character. Name of dependent variable. Only one allowed}

\item{dep_var_type}{Character. Type of dependent variable
as "revenue" or "conversion". Only one allowed and case sensitive.}

\item{prophet_vars}{Character vector. Include any of "trend",
"season", "weekday", "holiday". Are case-sensitive. Highly recommended
to use all for daily data and "trend", "season", "holiday" for
weekly and above cadence.}

\item{prophet_signs}{Character vector. Choose any of
\code{c("default", "positive", "negative")}. Control
the signs of coefficients for prophet variables. Must have same
order and same length as \code{prophet_vars}.}

\item{prophet_country}{Character. Only one country allowed once.
Including national holidays for 59 countries, whose list can
be found loading \code{data("dt_prophet_holidays")}.}

\item{context_vars}{Character vector. Typically competitors,
price & promotion, temperature, unemployment rate, etc.}

\item{context_signs}{Character vector. Choose any of
\code{c("default", "positive", "negative")}. Control
the signs of coefficients for context_vars. Must have same
order and same length as \code{context_vars}.}

\item{paid_media_vars}{Character vector. Recommended to use exposure
level metrics (impressions, clicks, GRP etc) other than spend. Also
recommended to split media channel into sub-channels
(e.g. fb_retargeting, fb_prospecting etc.) to gain more variance.
paid_media_vars only accept numerical variable}

\item{paid_media_signs}{Character vector. Choose any of
\code{c("default", "positive", "negative")}. Control
the signs of coefficients for paid_media_vars. Must have same
order and same length as \code{paid_media_vars}.}

\item{paid_media_spends}{Character vector. When using exposure level
metrics (impressions, clicks, GRP etc) in paid_media_vars, provide
corresponding spends for ROAS calculation. For spend metrics in
paid_media_vars, use the same name. media_spend_vars must have same
order and same length as \code{paid_media_vars}.}

\item{organic_vars}{Character vector. Typically newsletter sendings,
push-notifications, social media posts etc. Compared to paid_media_vars
organic_vars are often  marketing activities without clear spends}

\item{organic_signs}{Character vector. Choose any of
\code{c("default", "positive", "negative")}. Control
the signs of coefficients for organic_signs. Must have same
order and same length as \code{organic_vars}.}

\item{factor_vars}{Character vector. Specify which of the provided
variables in organic_vars or context_vars should be forced as a factor}

\item{adstock}{Character. Choose any of \code{c("geometric", "weibull_cdf",
"weibull_pdf")}. Weibull adtock is a two-parametric function and thus more
flexible, but takes longer time than the traditional geometric one-parametric
function. CDF, or cumulative density function of the Weibull function allows
changing decay rate over time in both C and S shape, while the peak value will
always stay at the first period, meaning no lagged effect. PDF, or the
probability density function, enables peak value occuring after the first
period when shape >=1, allowing lagged effect. Run \code{plot_adstock()} to
see the difference visually. Time estimation: with geometric adstock, 2000
iterations * 5 trials on 8 cores, it takes less than 30 minutes. Both Weibull
options take up to twice as much time.}

\item{hyperparameters}{List containing hyperparameter lower and upper bounds.
Names of elements in list must be identical to output of \code{hyper_names()}}

\item{window_start}{Character. Set start date of modelling period.
Recommended to not start in the first date in dataset to gain adstock
effect from previous periods.}

\item{window_end}{Character. Set end date of modelling period. Recommended
to have columns to rows ratio in the input data to be >=10:1, or in other
words at least 10 observations to 1 independent variable.}

\item{cores}{Integer. Default to \code{parallel::detectCores()}}

\item{iterations}{Integer. Recommended 2000 for default
\code{nevergrad_algo = "TwoPointsDE"}}

\item{trials}{Integer. Recommended 5 for default
\code{nevergrad_algo = "TwoPointsDE"}}

\item{nevergrad_algo}{Character. Default to "TwoPointsDE". Options are
\code{c("DE","TwoPointsDE", "OnePlusOne", "DoubleFastGADiscreteOnePlusOne",
"DiscreteOnePlusOne", "PortfolioDiscreteOnePlusOne", "NaiveTBPSA",
"cGA", "RandomSearch")}}

\item{calibration_input}{A data.table. Optional provide experimental results.
Check "Guide for calibration source" section.}

\item{InputCollect}{Default to NULL. \code{robyn_inputs}'s output when
\code{hyperparameters} are not yet set.}

\item{...}{Additional parameters passed to \code{prophet} functions.}
}
\value{
A list containing the all input parameters and modified input data from
\code{robyn_engineering()}. The list is passed to further functions like
\code{robyn_run()}, \code{robyn_save()} and \code{robyn_allocator()}
}
\description{
\code{robyn_inputs()} is the function to input all model parameters and
check input correctness for the initial model build. It includes the
\code{robyn_engineering()} function that conducts trend, season,
holiday & weekday decomposition using Facebook's time-serie forecasting
library \code{prophet} and fit a nonlinear model to spend and exposure
metrics in case exposure metrics are used in \code{paid_media_vars}.
}
\section{Guide for calibration source}{

 \enumerate{
   \item We strongly recommend to use experimental and causal results
   that are considered ground truth to calibrate MMM. Usual experiment
   types are people-based (e.g. Facebook conversion lift) and
   geo-based (e.g. Facebook GeoLift).
   \item Currently, Robyn only accepts point-estimate as calibration
   input. For example, if 10k$ spend is tested against a hold-out
   for channel A, then input the incremental return as point-estimate
   as the example below.
   \item The point-estimate has to always match the spend in the variable.
   For example, if channel A usually has 100k$ weekly spend and the
   experimental HO is 70%, input the point-estimate for the 30k$, not the 70k$.
}
}

\examples{
# load similated input data
data("dt_simulated_weekly")

# load standard prophet holidays
data("dt_prophet_holidays")
\dontrun{
InputCollect <- robyn_inputs(
  dt_input = dt_simulated_weekly,
  dt_holidays = dt_prophet_holidays,
  date_var = "DATE",
  dep_var = "revenue",
  dep_var_type = "revenue",
  prophet_vars = c("trend", "season", "holiday"),
  prophet_signs = c("default", "default", "default"),
  prophet_country = "DE",
  context_vars = c("competitor_sales_B", "events"),
  context_signs = c("default", "default"),
  paid_media_vars = c("tv_S", "ooh_S", "print_S", "facebook_I", "search_clicks_P"),
  paid_media_signs = c("positive", "positive", "positive", "positive", "positive"),
  paid_media_spends = c("tv_S", "ooh_S", "print_S", "facebook_S", "search_S"),
  organic_vars = c("newsletter"),
  organic_signs = c("positive"),
  factor_vars = c("events"),
  window_start = "2016-11-23",
  window_end = "2018-08-22",
  adstock = "geometric",
  iterations = 2000,
  trials = 5,
  hyperparameters = hyperparameters # to be defined separately
  , calibration_input = dt_calibration # to be defined separately
)
}
}
