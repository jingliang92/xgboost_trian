#train中模型函数编写详见http://topepo.github.io/caret/custom_models.html
xgboost <- list(type = c("Classification", "Regression"),
                library = c("xgboost", "dplyr"),
                loop = NULL)

parameter = c("eta", "gamma", "max_depth", "min_child_weight", "max_delta_step","subsample", "colsample_bytree", "colsample_bylevel", "lambda", "alpha", "scale_pos_weight", "nrounds", "eval_metric", "objective")
label=c("eta", "gamma", "maximun depth", " minimum sum of instance weight", "Maximum delta step", "subsample ratio of the training instance", "subsample ratio of columns", "subsample ratio of columns for each split", "L2 regularization term on weights", "L1 regularization term on weights", "Control the balance of positive and negative weights", "nrounds", "eval_metric", "objective")
class = c(rep("numeric", 12), "charactor", "charactor")
prm <- data.frame(parameter = parameter,
                  class = class,
                  label = label)
xgboost$parameters <- prm

xgboostGrid <- function(x, y, len=NULL, search="grid"){
  
  if(search == "grid"){
    out <-expand.grid(eta = 0.1, gamma = 0, max_depth = 3, 
                      min_child_weight = 3, max_delta_step = 0, subsample = 0.8, 
                      colsample_bytree = 0.8, colsample_bylevel = 1, lambda =0,
                      alpha = 0, nrounds = 2, scale_pos_weight = 1, eval_metric = "auc", objective="reg:linear")
    out$eval_metric = as.character(out$eval_metric)
  }else{
    out <- data.frame(eta = runif(len, min = 0.01, max = 0.2),
                      gamma = runif(len, min = 0, max = 0.2),
                      max_depth = sample(1:10, replace = TRUE, size = len),
                      min_child_weight = sample(1:10, replace = TRUE, size = len),
                      max_delta_step = 0,
                      subsample = runif(len, min = 0.6, max = 1),
                      colsample_bytree = runif(len, min = 0.6, max = 1),
                      colsample_bylevel = 1,
                      lambda = runif(len, min = 0, max = 0.1),
                      alpha = runif(len, min = 0, max = 0.1),
                      scale_pos_weight = 1,
                      nrounds = 2,
                      eval_metric=sample(c("auc", "rmse", "error", "logloss"), replace=FALSE, size = 1),
                      objective="reg:linear")
    out$eval_metric = as.character(out$eval_metric)
    out <- out[!duplicated(out), ]
    
  }
  out
}
xgboost$grid <- xgboostGrid

xgboostFit <- function(x, y, wts, param, lev, last, classProbs, ...){
  
  modArgs <- list(data=as.matrix(x), label=as.matrix(as.numeric(as.character(y))),
                  eta=param$eta, gamma=param$gamma, max_depth=param$max_depth,  
                  min_child_weight=param$min_child_weight, max_delta_step=param$max_delta_step, subsample=param$subsample, 
                  colsample_bytree=param$colsample_bytree, colsample_bylevel=param$colsample_bylevel, lambda=param$lambda, 
                  alpha = param$alpha, scale_pos_weight=param$scale_pos_weight, nrounds=param$nrounds, 
                  verbose=0, eval_metric=param$eval_metric,  objective=param$objective)
  do.call("xgboost", modArgs)
}
xgboost$fit <- xgboostFit

xgboostPred <- function(modelFit, newdata, preProc = NULL, submodels = NULL){
  out <- predict(modelFit, as.matrix(newdata))
  out
}
xgboost$predict <- xgboostPred

xgboostProb <- function(modelFit, newdata, preProc = NULL, submodels = NULL){
  out <- predict(modelFit, as.matrix(newdata))
  out
}
xgboost$prob <- xgboostProb

xgboostSort <- function(x){
  x[order(x$max_depth, x$min_child_weight, x$eta, x$gamma, x$subsample, x$colsample_bytree, x$alpha), ]
}
xgboost$sort <- xgboostSort

xgboost$levels <- function(x){
  
  if (is.null(x$classes)) {
    out <- if (any(names(x) == "obsLevels")) 
      x$obsLevels
    else NULL
  }
  else {
    out <- x$classes
  }
  out
}