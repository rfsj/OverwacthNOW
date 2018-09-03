-- Quantos times a empresa “Gillette” patrocina e quais são seus nomes?

	SELECT Count(t.nome), e.nome
	FROM Empresa E INNER JOIN Patrocina P ON (E.cnpj = P.cnpj) INNER JOIN Team T ON (P.time_codigo = T.time_codigo)
	WHERE E.nome LIKE ‘%Gillette%’;
	GROUP BY e.nome
	HAVING e.nome = ‘Gillette’

-- Quantos times estão participando do Overwatch League e são patrocinados pelas “Microsoft”?
	SELECT COUNT(*)
	FROM Empresa e INNER JOIN Patrocina p ON (e.cnpj = p.cnpj) INNER JOIN Team t ON (p.time_codigo = t.time_codigo)
	WHERE e.nome = ‘Microsoft’;

-- Quais os nomes das empresas que patrocinam o time Los Angeles Valiante e Seoul Dynasty independentemente de uma empresa não patrocinar os dois times?
SELECT e.nome
	FROM Empresa e INNER JOIN Patrocina p ON (e.cnpj = p.cnpj) INNER JOIN Team t ON (p.time_codigo = t.time_codigo)
	WHERE t.nome = ‘Los Angeles Valiante’
	UNION
SELECT e.nome
	FROM Empresa e INNER JOIN Patrocina p ON (e.cnpj = p.cnpj) INNER JOIN Team t ON (p.time_codigo = t.time_codigo)
	WHERE t.nome = ‘Seoul Dynasty’;

-- Quem foi o narrador que narrou o jogo entre Houston Outlaws e Philadelphia Fusion?

	SELECT nr.nome
	FROM Narrador nr INNER JOIN Narra n ON (nr.cpf = n.cpf) INNER JOIN Partida j ON (n.numero = j.numero)
	WHERE Time_Codigo1 =”Houston Outlaws” AND Time_Codigo2 = “Philadelphia Fusion”

-- Quais as partidas que tiveram mais de 9 lutas e tiveram um personagem “Lucio” em alguma partida?

	SELECT P.numero
	FROM Jogo p INNER JOIN JogoHerois ph ON (p.id=ph.id)
	Where P.lutas > 9 e ph.herois LIKE “%lucio%”


-- Recupere os dados dos times que são patrocinados por todas as empresas.
	SELECT *
	FROM Team t
	WHERE NOT EXISTS( SELECT e.cnpj
				FROM Empresa e
				WHERE NOT EXISTS( SELECT *
							FROM Patrocina p
							WHERE e.cnpj = p.cnpj and  t.time_codigo = p.time_codigo) 
 
-- Qual partida com o personagem “Widowmaker” teve menos mortes, retorne os times?

	SELECT p.Número
	FROM Jogo p INNER JOIN JogoHerois ph ON (p.id=ph.id) INNER JOIN JogadorAtuaJogo jap ON (jap.id = ph.id)
	Where ph.herois LIKE ‘%Widowmaker%’
	GROUP BY p.numero
	HAVING MIN(jap.Mortes)

-- Recupere o número do jogo em que o jogador “Striker” fez 37 eliminações
	SELECT p.Numero
	FROM Jogador j INNER JOIN Partida jo ON (j.time_codigo = jo.time_codigo1) INNER JOIN Jogo p ON (p.id = jo.numero) INNER JOIN JogadorAtuaJogo jap ON (p.id = jap.id)
	WHERE jap.eliminacoes = 37

-- Recupere os jogadores que não atuaram como support em partidas
	SELECT jr.nickname
	FROM Jogador jr INNER JOIN Partida jo ON (jr.time_codigo = jo.time_codigo1**) INNER JOIN Jogo p ON ( jo.numero= p.id)
	Where jr.especialidade NOT LIKE ‘%Support%’ 

-- Recupere todos os jogadores que jogam na modalidade ”contra”
	SELECT jr.nickname
	FROM Mapa m INNER JOIN Jogo p ON (m.id=p.id) INNER JOIN Partida jo ON (p.id = jo.numero) INNER JOIN Jogador Jr ON (jo.time_codigo1 = jr.time_codigo**)
	WHERE m.modalidade LIKE “%contra%”
