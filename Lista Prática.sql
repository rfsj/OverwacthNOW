-- Lista Prova Prática
-- Grupo: Matheus Gurjão, Ricardo Ferreira, Ruan Vieira e Vitor Lima


--I. Criar consulta utilizando o COUNT e o HAVING COUNT 

SELECT E.Nome, COUNT(*) 
FROM Patrocina P LEFT JOIN Empresa E ON (P.CNPJ = E.CNPJ)
GROUP BY E.Nome
HAVING COUNT(*) > 1;

--II. Criar consulta com EXISTS / NOT EXISTS 

SELECT *
FROM Team t 
WHERE NOT EXISTS( SELECT *
                FROM Patrocina p
                WHERE t.time_codigo = p.time_codigo);

--III. Criar consulta utilizando funções de agregação (MIN, MAX, AVG, SUM) e utilizar, também, as cláusulas GROUP BY e/ou ORDER BY. 
SELECT sum(JogadorAtuaJogo.eliminacoes), Jogador.time_codigo
FROM JogadorAtuaJogo LEFT OUTER JOIN Jogador on Jogador.cpf_jogador = JogadorAtuaJogo.cpf_jogador
GROUP BY Jogador.time_codigo;

--IV. Criar consulta utilizando o LEFT OUTER JOIN, RIGHT OUTER JOIN ou FULL OUTER JOIN

SELECT n.nome, nr.numero
FROM Narrador N LEFT OUTER JOIN Narra NR ON (n.cpf = nr.cpf);

--V. Criar consulta utilizando alguma operação com conjuntos (UNION, UNION ALL, INTERSECT ou EXCEPT). 

SELECT e.nome
    FROM Empresa e INNER JOIN Patrocina p ON (e.cnpj = p.cnpj) INNER JOIN Team t ON (p.time_codigo = t.time_codigo)
    WHERE t.nome = 'Los Angeles Valiant'
    UNION
SELECT e.nome
    FROM Empresa e INNER JOIN Patrocina p ON (e.cnpj = p.cnpj) INNER JOIN Team t ON (p.time_codigo = t.time_codigo)
    WHERE t.nome = 'Seoul Dynasty';


--VI. Criar um Cursor Explícito que utiliza a estrutura de LOOP para processar os dados, trata a exceção NO_DATA_FOUND e imprime os dados de cada tupla na tela.


set serveroutput on;
create or replace procedure processa_dados(p_id_mapa Mapa.id_mapa%type) IS

declare
    v_nome_mapa IN Mapa.nome%type;
    v_pais_mapa IN Mapa.pais%type;
    v_modal_mapa in Mapa.modalidade%type;
cursor c_mapa IS
select nome, pais, modalidade
from Mapa 
where p_id_mapa = id_mapa
BEGIN
open c_mapa;
loop
    fetch c_mapa INTO v_nome_mapa, v_pais_mapa, v_modal_mapa;
    exit when c_mapa%NOTFOUND;
    dbms_output.put_line('Mapa:'||to_char(v_nome_mapa)||' pais:'|| to_char(v_pais_mapa)|| ' modalidade:'|| to_char(v_modal_mapa));
end loop;
close c_mapa;
END;
/
--VII. Criar uma Function que receba 2 parâmetros de entrada, utilizar esses parâmetros para filtrar registros de uma tabela e retornar o número de registros.
create or replace function func_timespec_filtro(v_time IN Jogador.time_codigo%type, v_spec IN Jogador.especialidade%type)
RETURN NUMBER IS
    v_numero_ret NUMBER;
begin
    select count(*)
    into v_numero_ret
    from Jogador
    Where v_time = Jogador.time_codigo and v_spec = Jogador.especialidade);
RETURN V_NUMERO_RET;
END func_timespec_filtro;
/

--VIII. Criar uma Procedure que recebe um parâmetro de entrada e atualiza o valor do atributo na tabela utilizando UPDATE.

CREATE OR REPLACE PROCEDURE zera_cpf
(v_cpf IN Jogador.CPF%TYPE) IS


BEGIN
    UPDATE Jogador
        SET CPF = 00000000000
        WHERE Jogador.cpf_jogador = v_cpf;
END zera_cpf;
/

--IX. Criar uma Procedure que recebe um parâmetro de entrada do tipo VARCHAR2 e imprime na tela os registros que contém esse parâmetro. Utilizar LIKE e Cursor. 

SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE jogadores_herois

(v_heroi IN AtuaHerois.Herois%TYPE) IS

CURSOR herois_jogados IS
SELECT *
FROM AtuaHerois
WHERE Herois LIKE v_heroi;

v_tupla AtuaHerois%ROWTYPE;

BEGIN
    OPEN herois_jogados;

    LOOP
    FETCH herois_jogados INTO v_tupla;
    EXIT WHEN herois_jogados%NOTFOUND;
    dbms_output.put_line(
    'CPF Jogador: '||v_tupla.CPF_Jogador||);
END LOOP;
CLOSE herois_jogados;
END;
/

--X. Criar um trigger que verifique os valores de um INSERT ou UPDATE antes que essas operações sejam executadas. Utilizar raise_application_error e a exceção NO_DATA_FOUND. OK

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER verfica_valores
BEFORE INSERT OR UPDATE ON Jogo
FOR EACH ROW

DECLARE
v_numero Jogo.numero%TYPE

BEGIN
    BEGIN
    IF EXISTS(SELECT numero.J INTO v_numero
            FROM Jogo J 
            WHERE numero= :NEW.numero)
    THEN
        RAISE_APPLICATION_ERROR(-20101, 'Já existe um jogo com esse número.')

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('FAVORITAÇÃO ACEITA');
END IF;
END verifica_valores;
/
