## You can use xgboost in train of caret in R ,just like using gmb in train.

### First, you need load the code.

```    
source("where you put the xgboost.R in your computer")
```   

### Second, you need set tuning parameters:

using expand.grid:

```   
xgbgrid <- expand.grid(eta=0.26, gamma=0, max_depth=seq(3,10,1),
                       min_child_weight=seq(1,12,1), max_delta_step=0, subsample=0.8,
                       colsample_bytree=1, colsample_bylevel = 1, lambda=0.1,
                       alpha=0, scale_pos_weight = 1, nrounds=5, eval_metric='rmse',
                       objective="reg:linear")
```   

Or set tuneLength to a number, and it generates tuneLength sets of parameters randomly.

The meaning of the parameters, you can find in [XGBoost Parameters](http://xgboost.readthedocs.io/en/latest/parameter.html#parameters-in-r-package).

>NOTE:you'd better turn two parameters or less every time, otherwise you will get a mistake that the tuneGrid is bigger then the train data or the train time is so long.

### Finally, using it in train.

```   
xgb_model <- train(x, y, method = xgboost, tuneGrid=gbmgrid)
```   

### The example:

```   
library(caret)
library(mlbench)
source("D:/xgboost_train/xgboost.R")
data(BostonHousing)

head(BostonHousing)
str(BostonHousing)
BostonHousing$chas <- as.numeric(BostonHousing$chas)

dim(BostonHousing)

xgbgrid <- expand.grid(eta=0.26, gamma=0, max_depth=seq(3,10,1),
                       min_child_weight=seq(1,12,1), max_delta_step=0, subsample=0.8,
                       colsample_bytree=1, colsample_bylevel = 1, lambda=0.1,
                       alpha=0, scale_pos_weight = 1, nrounds=5, eval_metric='rmse',
                       objective="reg:linear")

lm_model <- train(BostonHousing[, 1:13], BostonHousing[, 14], method = 'lm')

xgb_model <- train(BostonHousing[, 1:13], BostonHousing[, 14], method = xgboost)

varImp(xgb_model)
``` 

>NOTE:the data must be numeric, and you can use every function in train of caret, for example VarImp, trControl and so on.
