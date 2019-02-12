#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector toC(NumericVector x) {
  int n = x.size();
  NumericVector out(n);
  
  for(int i = 0; i < n; i++) {
    out[i] = x[i] - 273.15;
  }
  return out;
}

/*** R
# Confirm Kelvin -> C Works right, should get -273.15 and 0
toC(c(0, 273.15))
*/

// [[Rcpp::export]]
NumericVector toF(NumericVector x) {
  int n = x.size();
  NumericVector out(n);
  
  for(int i = 0; i < n; i++) {
    out[i] = (x[i] - 273.15) * 9/5 + 32;
  }
  return out;
}

/*** R
# Confirm Kelvin -> F works right, should get -459.67 and 32
toF(c(0, 273.15))
*/
