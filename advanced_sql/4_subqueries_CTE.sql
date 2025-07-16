SELECT *
FROM ( -- Subquery começa aqui
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- Subquery termina aqui


WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs;

/* No caso a seguir, quero consultar a company_name
onde o job_no_degree_mention = true. Como a informação está em tabelas
diferentes (name em uma e job_no_degree_mention em outra), utilizamos
Subquery para realizar as consultas.
*/
SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE company_id IN (
    SELECT
        company_id,
        job_no_degree_mention
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
)

/* Econtrar as empresas que possuem maior oferta de empregos abertas
Pegar o número total de postagens de emprego por company_id (job_posting_fact)
Retornar o número total de empregos com o nome da empresa (company_dim)
*/
WITH company_job_count AS(
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count
ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC

/* ETAPAS:
1- Fazer uma query da tabela job_postings_fact para verificar:
company_id e contagem de colunas de linhas (COUNT(*))
2 - Agregar por company_id. O resultado será o total de ofertas de emprego
por company_id e chamaremos essa window function de company_job_count
3 - Agora faremos um JOIN da tabela temporária criada (company_job_count)
com a tabela que possui o nome das empresas (company_dim). A chave que liga essas
duas tabelas é a company_id.
4 - Feita a ligação, consultamos o nome da empresa e a contagem de empregos.
*/