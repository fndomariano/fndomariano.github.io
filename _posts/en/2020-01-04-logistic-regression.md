---
layout:    post
title:    "Logistic Regression"
comments: true
lang: en
ref: logistic-regression
excerpt:  "To talk about Logistic Regression, I used the same dataset of the post about Multiple Linear Regression. This one own scores about exams that help students to enter in colleges."
image: "/images/2019-12-02/graduation.jpg"
feature_text: |
    ## Logistic Regression
tags:
    - python
    - linear regression
    - data science
    - statistic
---

[Portuguese Version]({{site.baseurl}}/2020/01/04/regressao-logistica)

To talk about Logistic Regression, I used the same dataset of the [post about Multiple Linear Regression]({{site.baseurl}}/2019/12/02/multiple-linear-regression). It has scores of exams that help students to enter colleges.  

The Logistic Regression uses binary values to classify and this dataset doesn't have this type of data. So, I inserted a new column **Admitted**.

![Table showing fourteen lines and ten columns]({{site.baseurl}}/images/2020-01-04/new_column.png)

I added a new column with a basis on column **Chance of Admit**. If the chances are greater than 80% then the value is 1 if not is 0.

```python
base['Admitted'] = [1 if chance > 0.8 else 0 for chance in base['Chance of Admit ']]
```

To get a better visualization I plotted the chart below.

```python
labels = ['Yes', 'No']
x_pos = [0, 1]

admitted = len(base[base['Admitted'] == 1])
not_admitted = len(base[base['Admitted'] == 0])

plt.bar(x_pos, [admitted, not_admitted])
plt.xticks(x_pos, labels)
plt.title('Admitted students')
```

![Bar chart showing total admitted and not admitted students]({{site.baseurl}}/images/2020-01-04/admitted_chart.png)

After I started to prepare the data. Firstly, I made a new ```DataFrame``` only with the necessary columns.

```python
toefl = base.iloc[:, 2].values
gre   = base.iloc[:, 1].values
cgpa  = base.iloc[:, 6].values


x = pd.DataFrame(np.c_[toefl, gre, cgpa], columns=['toefl','gre', 'cgpa'])

# Admitted Column
y = base.iloc[:, -1].values
```

![Table showing nine lines and three columns]({{site.baseurl}}/images/2020-01-04/new_dataframe.png)

I separated dataset on training and test data for I can create a model to predict.

```python
X_train, X_test, y_train, y_test = train_test_split(x,y, test_size=0.20, random_state=42)

logmodel = LogisticRegression()
logmodel.fit(X_train,y_train)

predictions = logmodel.predict(X_test)
```

Then I generated a Confusion Matrix and scores to evaluate the result.

```python
cnf_matrix = metrics.confusion_matrix(y_test, predictions)
sns.heatmap(cnf_matrix, annot=True)
plt.ylabel('Actual label')
plt.xlabel('Predicted label')
```

![Confusion Matrix]({{site.baseurl}}/images/2020-01-04/confusion_matrix.png)

```python
print("Accuracy: ", metrics.accuracy_score(y_test, predictions))
print("Precision: ", metrics.precision_score(y_test, predictions))
print("Recall: ", metrics.recall_score(y_test, predictions))

# Output
# Accuracy: 0.85
# Precision: 0.730769230769
# Recall: 0.703703703704
```

### Considerations

With the Confusion Matrix we can conclude that:

**True positive:** 19 (the model predicted a positive result and it was positive).  
**True negative:** 66 (the model predicted a negative result and it was negative).    
**False-positive:** 7 (the model predicted a positive result and it was negative).  
**False-negative:** 8 (the model predicted a negative result and it was positive).  

and with the scores:

**Accuracy:** 85% was predicted correctly.  
**Precision:** 73% of the time the model is correct about its predictions.  
**Recall:** 70% of the time the model expected true result.  

The contents that I have shared are about what I am learning, so, if you found some error, on the code, concepts, considerations even spelling please let me know, like this, you will help me a lot to avoid more mistakes. 




