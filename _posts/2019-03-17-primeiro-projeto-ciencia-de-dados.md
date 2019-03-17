---
layout:    post
title:    "Meu primeiro projeto em Data Science"
comments: true
excerpt:  "Nesse post pretendo descrever meu primeiro projeto de Ciência de Dados. O projeto consiste em estudar os dados da Trimania que são disponibilizados no site da instituição. Nele eu levantei informações bem simples, como: números sorteados e bairros que mais tiveram ganhadores em determinados anos."
tags:
    - data science
    - python
---

Nesse post pretendo descrever meu primeiro projeto de Ciência de Dados. O projeto consiste em estudar os dados da Trimania que são disponibilizados no site da instituição. Nele eu levantei informações bem simples, como: números sorteados e bairros que mais tiveram ganhadores em determinados anos.

### Como obtive os dados

Para obter os dados eu [criei um crawler](https://github.com/fndomariano/trimania-crawler). O mesmo foi desenvolvido em PHP utilizando uma biblioteca do framework Symfony. As informações recebidas são salvas em duas tabelas: uma para localização e outra para os números. 

![Tabelas do banco de dados]({{site.url}}/images/2019-03-17/tables.png)

Uma das dificuldades para executar esse projeto é o tratamento de dados. Sempre que importado um conjunto de dados foi necessário realizar o tratamento deles, pois, constantemente o nome das cidades divergiam. Como exemplo em sorteios que existem ganhadores na cidade Joinville. No site os dados eram apresentados da seguinte forma: ```“Bairro / Joinvillle”```, ```“Joinvile/Bairro”```, ```“Joinville /Bairro”```. Abaixo algumas imagens que ilustram o problema no sorteio do dia 02/09/2018.

![Sorteios do dia 02/09/2018]({{site.url}}/images/2019-03-17/result_draw.png)

Sendo assim, não realizando a correção desses dados, os resultados seriam errôneos. Abaixo algumas linhas da tabela de localização com dados corrigidos. 

![Tabela de localizações]({{site.url}}/images/2019-03-17/location_table.png)

Os números sorteados não tem uma quantidade exata como na Mega-Sena, ou seja, a quantidade de números sorteados por rodada vai variar. Logo, não optei por ter uma coluna para cada valor sorteado. Criei uma coluna do tipo texto e salvei usando hífen como separador. A imagem seguinte mostra um exemplo da lógica que usei para salvar os dados. 

![Tabela de númberos]({{site.url}}/images/2019-03-17/numbers_table.png)

### Os números.

Para responder a pergunta ‘Quais os números mais sorteados de Janeiro a Abril de 2018?’ eu exportei CSV utilizando o crawler. 

```python
# Neste linha eu faço a leitura do arquivo e exibo os dados.
csv = pd.read_csv('trimaniaNumbers.csv', delimiter=';');
csv
```

![Números em um DataFrame]({{site.url}}/images/2019-03-17/numbers_preview.png)

```python
# Dicionário para inserir os números
numbers = {
    'number':[]
}

# Separado os números por hífen e acrescentado os números no dicionário
for lines in csv['numbers_drawn']:    
    for number in lines.split('-'):
            numbers['number'].append(number)
        

# Utilizei o dicionado para gerar um novo DataFrame
df = pd.DataFrame(numbers)

# Conto os números repetidos e solicito os 20 primeiros 
data = df['number'].value_counts().head(20)
```

Para visualizar de maneira mais clara eu criei um gráfico com os números e suas respectivas frequências de sorteio.

```python
# Configuro a fonte
font = {
    'weight': 'normal',
    'size': 16
}

# Configuro a label dos eixos X e Y
plt.xlabel('Números', fontdict=font)
plt.ylabel('Frenquência', fontdict=font)

# Exibo um gráfico em barra
data.plot(kind='bar')
plt.show()
```

![Números sorteados x Quantidade]({{site.url}}/images/2019-03-17/chart_numbers.png)

### As localizações

Outra pergunta que eu gostaria de responder era **‘Quais os bairros que mais tiveram ganhadores entre Janeiro e Abril de 2018 na cidade de Joinville?’**. Para responder essa perguntei fiz uma simples SQL.

```SQL
SELECT COUNT(*) AS total, city_district
FROM locations
WHERE draw_date BETWEEN '2018-01-01' AND '2018-04-30'
      AND city_district like '%/Joinville%'
GROUP BY city_district
ORDER BY total DESC
```
Após executar a SQL acima eu obtive os seguintes bairros:

![Bairros que mais tiveram ganhadores]({{site.url}}/images/2019-03-17/sql_result.png)

Esse foi um projeto simples, sem muitas complexidades. Ainda preciso melhorar meus conhecimentos, mas de qualquer forma esse post é um dos meus passos iniciais. Se você tiver alguma dúvia, sugestão, fique a vontade para comentar :)