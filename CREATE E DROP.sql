DROP TABLE Team  CASCADE CONSTRAINT;
DROP TABLE Empresa CASCADE CONSTRAINT;
DROP TABLE Narrador CASCADE CONSTRAINT;
DROP TABLE Partida CASCADE CONSTRAINT;
DROP TABLE Jogo CASCADE CONSTRAINT;
DROP TABLE Mapa CASCADE CONSTRAINT;
DROP TABLE Jogador CASCADE CONSTRAINT;
DROP TABLE Tecnico CASCADE CONSTRAINT;
DROP TABLE Campeonato  CASCADE CONSTRAINT;
DROP TABLE Narra CASCADE CONSTRAINT;
DROP TABLE Patrocina CASCADE CONSTRAINT;
DROP TABLE JogadorAtuaJogo CASCADE CONSTRAINT;
DROP TABLE JogoHerois CASCADE CONSTRAINT;
DROP TABLE AtuaHerois CASCADE CONSTRAINT;



--JÁ ESTÁ EM ORDEM DE INSERÇÃO.
--DROP TABLE x CASCADE CONSTRAINT
CREATE TABLE Team (
	nome varchar(255),
	cidade varchar(255),
	time_codigo NUMBER,
	CONSTRAINT Team_pk PRIMARY KEY (time_codigo)
);

CREATE TABLE Empresa (
	nome varchar(255),
	cnpj NUMBER,
	CONSTRAINT Empresa_pk PRIMARY KEY (cnpj)
);

CREATE TABLE Narrador(
	nome varchar(255),
	cpf NUMBER,
	CONSTRAINT Narrador_pk PRIMARY KEY (cpf)
);

CREATE TABLE Partida (
	hora varchar(255),
	data varchar(255),
	numero NUMBER,
	time_codigo1 NUMBER,
	time_codigo2 NUMBER,
	CONSTRAINT Partimda_pk PRIMARY KEY (numero),
	CONSTRAINT Team_Time_Codigo1_fk FOREIGN KEY (time_codigo1) REFERENCES Team (time_codigo),
	CONSTRAINT Team_Time_Codigo2_fk FOREIGN KEY (time_codigo2) REFERENCES Team (time_codigo)
);


CREATE TABLE Jogo (
	numero NUMBER,
	id NUMBER,
	duracao NUMBER,
	lutas NUMBER,
	CONSTRAINT Jogo_pk PRIMARY KEY (numero),
	CONSTRAINT Jogo_Partida_fk FOREIGN KEY (id) REFERENCES Partida(numero)
);

CREATE TABLE Mapa ( 
	nome varchar(255),
	pais varchar(255),
	modalidade varchar(255),
	id NUMBER,
	id_mapa NUMBER,
	CONSTRAINT Mapa_pk PRIMARY KEY (id_mapa),
	CONSTRAINT Mapa_Jogo_fk FOREIGN KEY (id) REFERENCES Jogo (numero)
);

CREATE TABLE Jogador (
	especialidade varchar(255),
	nickname varchar(255),
	cpf_jogador NUMBER,
	time_codigo NUMBER,
	CONSTRAINT Jogador_Team_fk FOREIGN KEY (time_codigo) REFERENCES Team(time_codigo),
	CONSTRAINT Jogador_pk PRIMARY KEY (cpf_jogador)
);

CREATE TABLE Tecnico (
	cpf_tecnico NUMBER,
	nome varchar(255),
	nickname varchar(255),
	time_codigo NUMBER,
	CONSTRAINT Tecnico_Team_fk FOREIGN KEY (time_codigo) REFERENCES Team (time_codigo),
	CONSTRAINT Tecnico_pk PRIMARY KEY (cpf_tecnico)
);

CREATE TABLE Campeonato (
	ano NUMBER,
	nome varchar(255),
	camp_codigo NUMBER,
	numero NUMBER,
	CONSTRAINT Campeonato_pk PRIMARY KEY (camp_codigo),
	CONSTRAINT Campeonato_Partida_fk FOREIGN KEY (numero) REFERENCES Partida(numero)
);

CREATE TABLE Narra (
	cpf NUMBER,
	numero NUMBER,
	CONSTRAINT Narra_Narrador_fk FOREIGN KEY (cpf) REFERENCES Narrador(cpf),
	CONSTRAINT Narra_Jogo_fk FOREIGN KEY (numero) REFERENCES Jogo(numero)
);

CREATE TABLE Patrocina (
	time_codigo NUMBER,
	cnpj NUMBER,
	camp_codigo NUMBER,
	CONSTRAINT Patrocina_Team_fk FOREIGN KEY (time_codigo) REFERENCES Team(time_codigo),
	CONSTRAINT Patrocina_Empresa_fk FOREIGN KEY (cnpj) REFERENCES Empresa(cnpj),
	CONSTRAINT Patrocina_Campeonato_fk FOREIGN KEY (camp_codigo) REFERENCES Campeonato(camp_codigo)
);

CREATE TABLE JogadorAtuaJogo (
	mortes NUMBER,
	ults NUMBER,
	eliminacoes NUMBER,
	id NUMBER,
	cpf_jogador NUMBER,
	CONSTRAINT JogadorAtuaJogo_Jogador_fk FOREIGN KEY (cpf_jogador) REFERENCES Jogador(cpf_jogador),
	CONSTRAINT JogadorAtuaJogo_Jogo_fk FOREIGN KEY (id) REFERENCES Jogo(numero) 
);

CREATE TABLE JogoHerois (
	herois varchar(255),
	id NUMBER,
	CONSTRAINT JogoHerois_Jogo_fk FOREIGN KEY (id) REFERENCES Jogo(numero)
);

CREATE TABLE AtuaHerois (
	herois varchar(255),
	id NUMBER,
	cpf_jogador NUMBER,
	CONSTRAINT AtuaHerois_Jogador_fk FOREIGN KEY (cpf_jogador) REFERENCES Jogador(cpf_jogador),
	CONSTRAINT AtuaHerois_Jogo_fk FOREIGN KEY (id) REFERENCES Jogo(numero)
);