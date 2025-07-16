# Introdução
Projeto com o intuito de explorar o mercado de Dados. Focado na área de análise de dados, esse projeto explora os empregos com melhor remuneração, habilidades mais exigidas e onde alta demanda de habilidades e alta remuneração se encontram na análise de dados.

Verifique as consultas SQL aqui: [project_sql folder](/project_sql/)

# Objetivos
Esse projeto foi realizado durante o acompanhamento do curso [SQL for Data Analytics - Learn SQL in 4 hours](https://www.youtube.com/watch?v=7mz73uXD9DA&t=14296s) por Luke Barousse. O objetivo foi reforçar o aprendizado da linguagem SQL visando a aplicação em um cenário real como analista de dados.

Utilizando uma base de dados fornecido pelo curso, reforcei o aprendizado da criação de uma [base de dados](/sql_load/) para que pudesse realizar as consultas e insights.

### As questões que busquei responder através das consultas SQL foram:

1. Quais são os empregos de analista de dados com melhores remunerações?
2. Quais as habilidade exigidas para os empregos que melhor remuneram?
3. Quais são as habilidades mais exigidas para um analista de dados?
4. Quais habilidades estão associadas com os maiores salários?
5. Quais são as habilidades ideais para aprender (entenda ideais como habilidades com alta demanda e maiores remunerações).

# Ferramentas utilizadas

Para realizar esse projeto as ferramentas utilizadas foram:
- **SQL**: A principal ferramenta de aprendizado do projeto, permitindo realizar consultas ao banco de dados para extrair os insights desejados.
- **PostgreSQL**: O sistema gerenciador de banco de dados escolhido.
- **Visual Studio Code**: Utilizado para manipulação do banco de dados e executar as consultas SQL.
- **Git e GitHub**: Essencial para controle de versão e para compartilhar meus scripts de SQL e análises, assegurando colaboração e acompanhamento do projeto.

# Análises
Cada consulta desse projeto buscou investigar aspectos específicos do mercado de trabalho do analista de dados. Aqui está como abordei cada questão:

### 1. Quais são os empregos de analista de dados com melhores remunerações?
Para identificar os empregos que tem melhor remuneração filtrei a posição de analista de dados por média anual de salário e localização, focando nos empregos remotos. Essa consulta destaca as oportunidade com melhor remuneração.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
Aqui estão alguns insights obtidos:
- **Grande variação da faixa salarial:** Os maiores salários anuais para a vaga de analista de dados variaram entre $184,000 à $650,000, indicando um bom potencial de remuneração no setor.
- **Alta variedade de funções:** Foi possível observar uma grande diversidade de cargos relacionados com análise de dados, o que indica que há muitas funções e especializações na área.

### 2. Quais as habilidade exigidas para os empregos que melhor remuneram?

Na primeira consulta, verifiquei quais os empregos que ofereceram melhor remuneração e agora gostaria de saber quais habilidades exigidas nesses empregos que melhor remuneram. Para isso, utilizei a primeira consulta como uma tabela temporária (CTE) e relacionei com a tabela de habilidades para verificar quais habilidades foram exigidas nos empregos mais bem remunerados.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

![Habilidades com melhor remuneração](.\assets\graficoanalise.jpg)
*Gráfico de barras mostrando as habilidades com melhores remunerações e a frequência em que apareceram; O gráfico foi gerado pelo ChatGPT através de um resultado de minha consulta SQL.*

Insights obtidos:
- Python é a habilidade mais presente entre os empregos com melhores salários, aparecendo 8 vezes.
- SQL também foi uma habilidade muito presente, com 7 aparições.
- Em relação a ferramenta de visualização, o Tableau se destacou com 6 aparições entre as habilidades que possuem melhor remuneração.

### 3. Quais são as habilidades mais exigidas para um analista de dados?

Na terceira consulta, precisei fazer a junção de 3 tabelas utilizando INNER JOIN na busca de verificar as habilidades que mais apareceram para a vaga remota de Analista de Dados (utilizei filtros para buscar apenas analistas e trabalhos remotos).

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
Insights obtidos:
- SQL foi a habilidade mais exigida para a vaga remota de Analista de Dados com 7291 ocorrências.
- Excel continua sendo uma habilidade importante, aparecendo em segundo lugar com 4611 ocorrências.
- Tableau foi a ferramenta de visualização mais exigida, com 3745 ocorrências.

### 4. Quais habilidades estão associadas com os maiores salários?

Essa consulta foi similar a terceira consulta mas dessa vez busquei verificar quais habilidades estavam ligadas com a maior média salarial anual para a função de Analista de Dados com trabalho remoto. Não tinha aprendido sobre a função ROUND, que no caso foi utilizada para arredondar os valores das médias salariais.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

Insights obtidos:
- Pyspark foi a habilidade associada ao maior salário para a função de Analista de Dados, com remuneração médial anual de $208.172,00
- Bibliotecas como Pandas e Numpy possuem uma boa remuneração anual média com $151.821,00 e $143.513,00 respectivamente.
- Postgresql apareceu como o SGBD com maior remuneração ($123.879,00)

### 5. Quais são as habilidades ideais para aprender (entenda ideais como habilidades com alta demanda e maiores remunerações).
Essa foi a consulta mais complicada para ser realizada e só consegui acompanhando o professor do curso e mesmo assim acredito que não tenha fixado completamente o aprendizado nessa parte. Mas foi importante ver que podemos chegar ao mesmo resultado utilizando caminhos diferentes. Mas basicamente o que foi feito foi uma junção das consultas 3 e 4, onde verifiquei as habilidades mais exigidas e a maior média salarial anual. Utilizei o comando HAVING para facilitar a leitura do resultado.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home =  True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25
```

Insights obtidos:
- Python e R são as linguagens de programação com maiores demandas e com bons salários, sendo Python a linguagem com maior demanda (236 contra 148 da linguagem R).
- A linguagem Go é uma habilidade de alta demanda que teve a maior remuneração entre a função de Analista de Dados ($115.320,00)


# O que aprendi

Através desse curso e desse projeto eu obtive aprendizados valiosos:

- **Realização de consultas mais complexas:** Além de reforçar o aprendizado de consultas básicas, aprendi a realizar subconsultas e relacionar tabelas utilizando CTEs. Ainda não acredito que domino essa parte da linguagem, mas o curso conseguiu esclarecer e explicar de uma forma simples.
- **Análises e insights:** Mais do que apenas a utilização das ferramentas, o curso ajuda a fortalecer o pensamento crítico e analítico, ou seja, ensina como vou utilzar as ferramentas para buscar respostas.

# Conclusões

Esse projeto me ajudou a melhorar meus conhecimentos em SQL e em como aplicá-los em uma análise de dados. Embora os dados sejam de 2 anos atrás, também foi importante para verificar alguns aspectos da profissão de Analista de Dados como as bases salariais no exterior e principalmente quais habilidade fundamentais na área.
Embora ainda não esteja dominando aspectos mais avançados como subqueries e CTEs, e não conseguir realizar sozinho consultas mais complexas (precisei acompanhar o instrutor do vídeo), o projeto ajudou a ter o contato com as ferramentas. Além do SQL, também tive um contato inicial com o PostgreSQL pois até o momento só tinha utilizado o MySQL como SGBD. O curso também ensinou como utilizar o Git e GitHub, ferramentas importantes para versionamento e compartilhamento do código. O projeto também mostrou que ainda tenho muitas habilidades para adquirir, baseado nos insights obtidos.

