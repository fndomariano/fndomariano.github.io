---
layout:    post
title:    "Multiple Linear Regression"
comments: true
lang: en
ref: multiple-linear-regression
excerpt:  "In this post, I want to show how I've implemented multiple linear regression with a dataset about graduation that I found on Kaggle."
image: "/images/2019-12-02/graduation.jpg"
feature_text: |
    ## Multiple Linear Regression 
    A study with graduation dataset
tags:
    - python
    - linear regression
    - data science
    - statistic
---

[Portuguese Version]({{site.url}}/2019/12/02/regressao-linear-multipla)

In this post, I want to show how I've implemented Multiple Linear Regression with a [dataset about graduation that I found on Kaggle](https://www.kaggle.com/mohansacharya/graduate-admissions).

Firstly, I imported the libraries, the dataset and I verified ```NaN values``` too (there were no).

```python
import pandas as pd
import matplotlib.pyplot as plt 
import numpy as np
import seaborn as sns
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score

base = pd.read_csv('dataset.csv')
base.isna().sum()
base.head()
```

The dataset owns the following columns.

![Showing six registers from dataset with column name]({{site.url}}/images/2019-12-02/graduation_columns.png)

After this, as the [Linear Regression]({{site.url}}/2019/10/14/simple-linear-regression) post, also I used Seaborn to generate a heatmap with correlation among variables.

![Heatmap among variables from dataset]({{site.url}}/images/2019-12-02/graduation_heatmap.png)

I could see that exits strong correlations among **GRE Score**, **TOEFL Score** and **CGPA Score** with **Chance of Admit**, then I plotted charts to get better visualization.

I stored the **Change of Admit** values on a variable called ```y```.

```python
# chance of admit
y = base.iloc[:, -1].values
```

And then I generate the charts.

```python
#toefl
toefl = base.iloc[:, 2].values
toefl = toefl.reshape(-1, 1)
plt.scatter(toefl, y)
plt.xlabel('TOEFL Score')
plt.ylabel('Chance of Admit')
```

![This chart shows the correlation between TOEFL Score and Chance of Admit]({{site.url}}/images/2019-12-02/graduation_chart_toefl.png)

```python
#gre
gre = base.iloc[:, 1].values
gre = gre.reshape(-1, 1)
plt.scatter(gre, y)
plt.xlabel('GRE Score')
plt.ylabel('Chance of Admit')
```

![This chart shows the correlation between GRE Score and Chance of Admit]({{site.url}}/images/2019-12-02/graduation_chart_gre.png)

```python
#cgpa
cgpa = base.iloc[:, 6].values
cgpa = cgpa.reshape(-1, 1)
plt.scatter(cgpa, y)
plt.xlabel('CGPA Score')
plt.ylabel('Chance of Admit')
```

![This chart shows the correlation between CGPA Score and Chance of Admit]({{site.url}}/images/2019-12-02/graduation_chart_cgpa.png)


With the variables defined, I built the model to test. The first step was to create a new ```DataFrame```.

```python
x = pd.DataFrame(np.c_[toefl, gre, cgpa], columns=['toefl','gre', 'cgpa'])
x.head()
```

![Table showing a new Dataframe with columns toefl, gre and cgpa]({{site.url}}/images/2019-12-02/graduation_chart_cgpa.png)

Next, I separated this one in two sets of data.

```python
#split 20% to test and 80% to train
X_train, X_test, Y_train, Y_test = train_test_split(x, y, test_size = 0.2, random_state=42)
```

For carried out the train and the test I made the code bellow using R2 Score to adjust the model.

```python
# model evaluation for set of training
y_train_predict = lin_model.predict(X_train)
r2 = r2_score(Y_train, y_train_predict)
```

The result of the training set was:

```python
print("The model performance for the set of training")
print("--------------------------------------")
print('R2 score is %s' %r2)

# Out
# The model performance for the set of training
# --------------------------------------
# R2 score is 0.806069903902
```

The same process I repeated with the set of testing where I got:

```python
# model evaluation for the set of testing
y_test_predict = lin_model.predict(X_test)
r2 = r2_score(Y_test, y_test_predict)

print("The model performance for the set of testing")
print("--------------------------------------")
print('R2 score is %s' %r2)

# Out
# The model performance for the set of testing
# --------------------------------------
# R2 score is 0.793836133004
```

#### Considerations

The results from R2 Score showed that is a good model because set of train and test both were close from 1 that is considered great.  

Another point is that to get a high Chance of Admit, the student needs to have mainly the scores cited with great values.

