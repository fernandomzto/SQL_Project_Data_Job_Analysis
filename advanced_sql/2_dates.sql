SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date     --- Ignora os horários e apresenta somente a data
FROM
    job_postings_fact;


/*Verificando a quantidade de ofertas de trabalho postadas
para a vaga de Data Analyst em cada mês e ordenando pelo
mês onde houve a maior oferta para a menor.
*/

SELECT
    COUNT (job_id) AS job_posted_count,
    EXTRACT (MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;