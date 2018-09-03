
-->Trigger: não cadastrar o mesmo jogador duas vezes.

set serveroutput on;

CREATE OR REPLACE TRIGGER joga_um_time
BEFORE INSERT OR UPDATE ON jogador
FOR EACH ROW

DECLARE
v_cpf_jogador Jogador.cpf_jogador%TYPE
	
BEGIN
	IF EXISTS(SELECT cpf_jogador INTO v_cpf_jogador
		    FROM Jogador 
		    WHERE cpf_jogador = :NEW.cpf_jogador)
	THEN
		RAISE_APPLICATION_ERROR(-20101, 'Esse jogador já se encontra em um time')
END IF;
END joga_um_time;
/

-->Trigger: duas partidas não podem ocorrer ao mesmo tempo.

set serveroutput on;
CREATE OR REPLACE TRIGGER trig_sametime_match
BEFORE INSERT OR UPDATE Partida
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    v_data Partida.data%type;
    v_hora Partida.hora%type;
BEGIN
    IF EXISTS(SELECT hora, data
   	   FROM partida p
   	   WHERE data = :NEW.data AND hora = :NEW.hora)
    THEN
    RAISE_APPLICATION_ERROR(-20133, 'Duas partidas não podem acontecer ao mesmo tempo')
    END IF;
END trig_sametime_match;
/

-->Trigger: Impedir que um time jogue sem estar completo.

set serveroutput on;
CREATE OR REPLACE TRIGGER trig_incomp_team
BEFORE INSERT OR UPDATE OR DELETE Team
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
   	 v_quantidade_jogadores IN number;
BEGIN
  	  SELECT COUNT(jogadores)
    		INTO v_quantidade_jogadores
    		FROM Jogador J
    		WHERE :NEW.time_codigo = J.time_codigo
  	  IF v_quantidade_jogadores < 6
   		 THEN
   		 RAISE_APPLICATION_ERROR(-20134, 'O time não pode ficar incompleto')
 	   END IF;
END trig_incomp_team;
/

-->Function: Receber um id de jogo e retornar a duração e lutas.
	
set serveroutput on;
CREATE OR REPLACE FUNCTION func_temp_partida(v_jogo_id in Jogo.id%type) IS
DECLARE
    temp_partida in Jogo.duracao%type
    lut_partida in Jogo.lutas%type;
BEGIN
 	   SELECT duracao, lutas
   	   INTO temp_partida, lut_partida
   	   FROM Jogo J
   	   WHERE J.id = v_jogo_id
  	  dbms_output.put_line('id:'||v_jogo_id||' Duracao:' || temp_partida || ' Lutas:'|| lut_partida);
END func_temp_partida;
/

-->Procedure: recebe o id de dois jogadores de um mesmo time e realiza substituição.

set serveroutput on;
CREATE OR REPLACE PROCEDURE proc_sub(v_cpf_1 IN Jogador.cpf_jogador%type, v_cpf_2 IN Jogador.cpf_jogador%type)
UPDATE Jogador
SET cpf.jogador = v_cpf1
WHERE cpf.jogador = v_cpf_2;

UPDATE Jogador
SET cpf.jogador = v_cpf_2
WHERE cpf.jogador = v_cpf_1;
END proc_sub;
/

-->Trigger: verifica se houve erro de cadastro no CPF dos Jogadores

CREATE OR REPLACE TRIGGER erro_jogador_cadastro
BEFORE INSERT ON Jogador
FOR EACH ROW


DECLARE

v_CPF_jogador Jogador.CPF_jogador%TYPE;
v_Nickname Jogador.Nickname%TYPE;
BEGIN
SELECT CPF_jogador, Nickname
INTO v_CPF_jogador, v_Nickname
FROM Jogador
WHERE CPF_jogador = :NEW.CPF_jogador;

IF v_CPF_jogador IS NULL THEN
		RAISE_APPLICATION_ERROR(-20101,'Campo de CPF vazio');
	ELSE
	IF (LENGTH(v_CPF_jogador) <> 11 ) THEN 
		RAISE_APPLICATION_ERROR(-20101,'Número de CPF inválido');
	ELSE
			dbms_output.put_line('Jogador'|| v_Nickname || 'inserido com sucesso!');
	END IF;
END IF;

END erro_jogador_cadastro;
/

-->Trigger: Impedir que um time jogue contra ele mesmo

CREATE OR REPLACE TRIGGER erro_mesmo_time
BEFORE INSERT ON Jogo
FOR EACH ROW

DECLARE

v_Time_Codigo1 Jogador.Time_Codigo1%TYPE;
v_Time_Codigo2 Jogador.Time_Codigo2%TYPE;

BEGIN
SELECT Time_Codigo1, Time_Codigo2
INTO v_Time_Codigo1, v_Time_Codigo2
FROM Jogo
WHERE Time_Codigo1 = :NEW.Time_Codigo1 AND Time_Codigo2 = :NEW.Time_Codigo2 ;

IF v_Time_Codigo1 = v_Time_Codigo2 THEN
		RAISE_APPLICATION_ERROR(-20101,'O time não pode jogar com ele mesmo');
	ELSE
	v_Time_Codigo1 <> v_Time_Codigo2 THEN
		dbms_output.put_line(v_Time_Codigo1 || 'VS' || v_Time_Codigo2);
END IF;
END erro_mesmo_time;
/

-->Procedure: mostra a média de mortes e ults de um jogador

set serveroutput on;
CREATE OR REPLACE PROCEDURE media_mortes_jogador(v_CPF_Jogador in JogadorAtuaPartida.CPF_Jogador%TYPE) IS

v_Mortes in JogadorAtuaPartida.Mortes%TYPE; 
v_Ults in JogadorAtuaPartida.Ults%TYPE;

BEGIN
SELECT AVG(Mortes), AVG(Ults)
INTO v_Mortes, v_Ults
FROM JogadorAtuaPartida;
WHERE CPF_jogador = :NEW.CPF_jogador;

dbms_output.put_line('Mortes: ' || v_Mortes || 'e Ults:' || v_Ults);

END media_mortes_jogador;
/


-->Trigger: ativa uma restrição ao tentar inserir em algum time um jogador já inserido

CREATE OR REPLACE TRIGGER verifica_esta_cadastrado
BEFORE INSERT ON Jogador
FOR EACH ROW

DECLARE 

v_CPF_Jogador Jogador.CPF_Jogador%TYPE;

BEGIN
	SELECT CPF_Jogador INTO v_CPF_Jogador
	FROM Jogador
	WHERE CPF_Jogador = :NEW.CPF_Jogador
	
IF v_CPF_Jogador IS NULL THEN
	dbms_output.put_line('Jogador inserido!');
ELSE
	RAISE_APPLICATION_ERROR(0000, 'Jogador já participa de um time’');

END IF;

END verifica_esta_cadastrado;
/

-->Function: ao receber o ID de um time, retorna o número de jogadores

CREATE OR REPLACE FUNCTION qtdJogadores
	(v_Time_Codigo IN Team.Time_Codigo%TYPE)
	RETURN NUMBER IS  v_retorno NUMBER;

  v_aux Jogador.Time_Codigo%TYPE;

BEGIN
	SELECT Time_Codigo, COUNT(DISTINCT CPF_Jogador) 
 	INTO v_aux, v_retorno
  	FROM Jogador
  	WHERE Time_Codigo = v_Time_Codigo
  	GROUP BY Time_Codigo;
	
RETURN v_retorno;

END qtdJogadores;
/

-->Procedure: recebe o CPF de um jogador e deleta seu cadastro

	CREATE OR REPLACE PROCEDURE deleta_jogador
(v_CPF_Jogador IN Jogador.CPF_Jogador%TYPE) IS

	aux_CPF_Jogador Jogador.CPF_Jogador%TYPE;

BEGIN
	SELECT CPF_Jogador 
INTO aux_CPF_Jogador
	FROM Jogador
	WHERE CPF_Jogador = v_CPF_Jogador
	
IF aux_CPF_Jogador IS NULL THEN
	RAISE_APPLICATION_ERROR(0001, 'O jogador não existe');
ELSE
	DELETE FROM Jogador
WHERE CPF_Jogador = v_CPF_Jogador;
END IF;

END deleta_jogador;
