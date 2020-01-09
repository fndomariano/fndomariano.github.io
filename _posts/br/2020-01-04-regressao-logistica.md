---
layout:    post
title:    "Regressão Logística"
comments: true
lang: br
ref: regressao-logistica
excerpt:  "Para falar sobre Regressão Logística, usei o mesmo <i>dataset</i> da publicação sobre Regressão Linear Múltipla. Ele contém pontuações de exames que ajudam os alunos a ingressar em faculdades."
image: "/images/2019-12-02/graduation.jpg"
tags:
    - python
    - regressão logística
    - ciência de dados
    - estatística
---

[English Version]({{site.url}}/2020/01/04/logistic-regression)

Para falar sobre Regressão Logística, usei o mesmo _dataset_ da [publicação sobre Regressão Linear Múltipla]({{site.url}}/2019/12/02/regressao-linear-multipla). Ele contém pontuações de exames que ajudam os alunos a ingressar em faculdades.

A regressão logística usa valores binários para classificar e esse _dataset_ não possui essa informação. Então, para resolver isso eu inseri uma nova coluna **Admitted**.

![Tabela mostrando cartorze linhas e dez colunas]({{site.url}}/images/2020-01-04/new_column.png)

Eu adicionei uma nova coluna com base na coluna **Chance of Admit**. Se as chances forem maiores que 80%, o valor é 1 senão é 0.

```python
base['Admitted'] = [1 if chance > 0.8 else 0 for chance in base['Chance of Admit ']]
```

Para obter uma melhor visualização, plotei o gráfico abaixo.

```python
labels = ['Yes', 'No']
x_pos = [0, 1]

admitted = len(base[base['Admitted'] == 1])
not_admitted = len(base[base['Admitted'] == 0])

plt.bar(x_pos, [admitted, not_admitted])
plt.xticks(x_pos, labels)
plt.title('Admitted students')
```

![Gráfico de barras mostrando o total de de estudantes admitidos e não admitidos]({{site.url}}/images/2020-01-04/admitted_chart.png)

Depois, comecei a preparar os dados. Primeiramente, criei um novo ```DataFrame``` apenas com as colunas necessárias.

```python
toefl = base.iloc[:, 2].values
gre   = base.iloc[:, 1].values
cgpa  = base.iloc[:, 6].values

x = pd.DataFrame(np.c_[toefl, gre, cgpa], columns=['toefl','gre', 'cgpa'])

# Coluna Admitted
y = base.iloc[:, -1].values
```

![Tabela mostrando nove linhas e três colunas]({{site.url}}/images/2020-01-04/new_dataframe.png)

Separei o _dataset_ em treino e teste.

```python
X_train, X_test, y_train, y_test = train_test_split(x,y, test_size=0.20, random_state=42)

logmodel = LogisticRegression()
logmodel.fit(X_train,y_train)

predictions = logmodel.predict(X_test)
```

E então eu criei uma matriz de confusão e _scores_ para avaliar os resultado.

```python
cnf_matrix = metrics.confusion_matrix(y_test, predictions)
sns.heatmap(cnf_matrix, annot=True)
plt.ylabel('Actual label')
plt.xlabel('Predicted label')
```

![Matriz de confusão]({{site.url}}/images/2020-01-04/confusion_matrix.png)

```python
print("Acurácia: ", metrics.accuracy_score(y_test, predictions))
print("Precisão: ", metrics.precision_score(y_test, predictions))
print("Lembrança: ", metrics.recall_score(y_test, predictions))

# Saída
# Acurácia: 0.85
# Precisão: 0.730769230769
# Lembrança: 0.703703703704
```

### Considerações

Com a matriz de confusão, podemos concluir que:

**Verdadeiro positivo:** 19 (o modelo previu um resultado positivo e foi positivo).  
**Verdadeiro negativo:** 66 (o modelo previu um resultado negativo e foi negativo).    
**Falso positivo:** 7 (o modelo previu um resultado positivo e foi negativo).  
**Falso negativo:** 8 (o modelo previu um resultado negativo e foi positivo).  

e com os _scores_:

**Precisão:** 85% foi previsto corretamente.  
**Precisão:** 73% do tempo o modelo está correto sobre suas previsões.  
**Sensibilidade:** 70% do tempo o modelo esperava um resultado positivo.  

Os conteúdos que tenho compartilhado são sobre o que estou aprendendo, portanto, se você encontrou algum erro, no código, nos conceitos, nas considerações ortográficas ou até na ortografia, por favor me avise, assim você, me ajudará muito a evitar mais erros.


