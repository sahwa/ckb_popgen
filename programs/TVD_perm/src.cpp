#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double TVD_cpp(Rcpp::NumericMatrix x) {
	int x_nrow = x.nrow();
	Rcpp::NumericVector res(x_nrow * x_nrow, 0.0);
	Rcpp::NumericVector diff;		
	int counter = -1;
	for (int i = 0; i<x_nrow; i++) {
		for (int j=0; j<x_nrow; j++) {
			counter++;
			diff = x(i,_) - x(j, _);
			Rcpp::NumericVector abs_diff = Rcpp::abs(diff);	
			double sum = Rcpp::sum(abs_diff);
			res[counter] = sum;	
		}
	}
	double TVD = Rcpp::mean(res);
	return TVD;
}

// [[Rcpp::export]]
double TVD_cpp_gpt(Rcpp::NumericMatrix x) {
  const int x_nrow = x.nrow();
  Rcpp::NumericVector res(x_nrow * x_nrow, 0.0);
  for (int i = 0; i < x_nrow; i++) {
    Rcpp::NumericVector row_i = x.row(i);
    for (int j = 0; j < x_nrow; j++) {
      Rcpp::NumericVector diff = row_i - x.row(j);
      double sum = Rcpp::sum(Rcpp::abs(diff));
      res[i * x_nrow + j] = sum;
    }
  }
  double TVD = Rcpp::mean(res);
  return TVD;
}
