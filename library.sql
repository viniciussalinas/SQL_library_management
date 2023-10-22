CREATE TABLE tipo_usuario (

	tipo varchar(50),
	prazo_emprestimo smallint NOT NULL,
	num_itens smallint NOT NULL,
	num_renovacoes smallint NOT NULL,
	prazo_renovacao smallint NOT NULL,
    
	PRIMARY KEY(tipo)
);

CREATE TABLE usuario (

	CPF varchar(11),
	nome varchar(130) NOT NULL,
	telefone varchar(15),
	celular varchar(15),
	endereco text NOT NULL,
	data_suspensao date,
	email varchar(130) NOT NULL,
	RG varchar(9) NOT NULL,
	tipo varchar(50) NOT NULL,
    
	PRIMARY KEY(CPF),
    
	FOREIGN KEY (tipo) REFERENCES tipo_usuario (tipo)
   	 ON UPDATE CASCADE
   	 ON DELETE CASCADE
);

CREATE TABLE livro (
    
	ISBN varchar(13),
	titulo varchar(250) NOT NULL,
	editora varchar(100) NOT NULL,
	ano_publicacao smallint DEFAULT 0 NOT NULL,

	PRIMARY KEY(ISBN)
);

CREATE TABLE exemplar (

	cod_exemplar smallint DEFAULT 1,
	estado varchar(13) DEFAULT 'Disponível' NOT NULL,
	ISBN varchar(13) NOT NULL,
    
	PRIMARY KEY (cod_exemplar, ISBN),
    
	FOREIGN KEY (ISBN) REFERENCES livro (ISBN)
   	 ON UPDATE CASCADE
   	 ON DELETE CASCADE
);

CREATE TABLE empresta (
 
	data_emprestimo date,
	data_devolvido date,
	n_renovacoes smallint DEFAULT 0 NOT NULL,
	ISBN varchar(13),
	CPF varchar(11),
    
	PRIMARY KEY (data_emprestimo, ISBN, CPF),
    
	FOREIGN KEY (ISBN) REFERENCES livro (ISBN)
   	 ON UPDATE CASCADE
   	 ON DELETE CASCADE,
	FOREIGN KEY (CPF) REFERENCES usuario (CPF)
   	 ON UPDATE CASCADE
   	 ON DELETE CASCADE
);

CREATE TABLE assunto (
    
	ISBN varchar(13),
	assunto varchar(60),
    
	PRIMARY KEY(ISBN, assunto),
    
	FOREIGN KEY (ISBN) REFERENCES livro (ISBN)
   	 ON UPDATE CASCADE
   	 ON DELETE CASCADE
);

CREATE TABLE autor (
    
	ISBN varchar(13),
	autor varchar(100),
    
	PRIMARY KEY(ISBN, autor),
    
	FOREIGN KEY (ISBN) REFERENCES livro (ISBN)
   	 ON UPDATE CASCADE
   	 ON DELETE CASCADE
);

SELECT * FROM usuario;
SELECT * FROM livro, assunto;
SELECT * FROM exemplar;
SELECT * FROM tipo_usuario;
SELECT * FROM empresta;
SELECT * FROM assunto;
SELECT * FROM autor;

-----------------------------------
--          Consulta 1
-- Contar o nº de livros que o
-- usuário possui emprestado no
-- momento, por meio de seu RG.
-----------------------------------
SELECT 	livro.isbn, COUNT (empresta.isbn) AS num_livros
FROM	livro, usuario, empresta
WHERE	EXISTS
	(SELECT usuario.cpf
	 FROM	usuario
	 WHERE	usuario.RG = '478222390') AND empresta.cpf = usuario.cpf AND empresta.isbn = livro.isbn
GROUP BY livro.isbn;


-----------------------------------
--          Consulta 2
-- Listar o ISBN dos livros com o 
-- nome solicitado e o número de
-- exemplares que eles possuem.
-----------------------------------
SELECT 	 livro.isbn, livro.titulo, COUNT (cod_exemplar) AS num_exemplar
FROM	 livro, exemplar
WHERE	 livro.isbn = exemplar.isbn
GROUP BY livro.isbn;

SELECT 	 livro.isbn, livro.titulo, COUNT (cod_exemplar) AS num_exemplar
FROM	 livro, exemplar
WHERE	 livro.titulo LIKE 'Cálculo%' AND livro.isbn = exemplar.isbn
GROUP BY livro.isbn;

-----------------------------------
--          Consulta 3
-- Listar o nome e e-mail de todos
-- os usuários suspensos.
-----------------------------------
SELECT 	nome, email
FROM 	usuario
WHERE 	usuario.data_suspensao IS NOT NULL;

-----------------------------------
--          Consulta 4
-- Listar o ISBN e nome dos livros
-- de um determinado assunto.
-----------------------------------
SELECT 	livro.isbn, titulo	
FROM	livro, assunto
WHERE 	assunto LIKE 'Mat%' AND assunto.isbn = livro.isbn;

-----------------------------------
--          Consulta 5
-- Listar o ISBN e nome dos livros
-- de um determinado autor.
-----------------------------------
SELECT 	livro.isbn, titulo
FROM	livro, autor
WHERE 	autor = 'Fasty Wolv' AND autor.isbn = livro.isbn;

SELECT retorna_nome_aluno ('45689612509');
CREATE OR REPLACE FUNCTION retorna_nome_aluno (usuarioCPF varchar)
	RETURNS text AS
    $$
    DECLARE
    	nomeAluno varchar; 	-- Variável auxiliar
    BEGIN
    	SELECT  usuario.nome INTO nomeAluno
        FROM	usuario
        WHERE	usuarioCPF = cpf;
        
        RETURN nomeAluno;
	END;
 $$ LANGUAGE plpgsql;

INSERT INTO livro VALUES ('3239832610098', 'Cálculo II', 'Math.US', 2015);
INSERT INTO livro VALUES ('7862139873276', 'Sistemas Operacionais', 'Computer Books', 2002);
INSERT INTO livro VALUES ('7640291823782', 'Linguagem e Programação em C', 'Computer Books', 2000);
INSERT INTO livro VALUES ('0017286354635', 'Linguagem e Programação em Java', 'Computer Books', 2000);
INSERT INTO livro VALUES ('6645251672362', 'Linguagem e Programação em C++', 'Computer Books', 2001);
INSERT INTO livro VALUES ('3298276437848', 'Cálculo I', 'Math.US', 2014);
INSERT INTO livro VALUES ('1276238476377', 'Pesquisa Acadêmica', 'CTH Livros', 1998);
INSERT INTO livro VALUES ('0988324776572', 'Metodologia Científica', 'CTH Livros', 1990);
INSERT INTO livro VALUES ('9281637392011', 'Manual de Produção', 'CTH Livros', 1999);
INSERT INTO livro VALUES ('0894678643672', 'Vertebrados', 'Biologia Brasil', 2001);
INSERT INTO livro VALUES ('1088872376632', 'Zoologia', 'Biologia Brasil', 2004);
INSERT INTO livro VALUES ('1872630495817', 'Cálculo Numérico', 'Math.US', 2015);
INSERT INTO livro VALUES ('9823723643773', 'Marketing e Mercadologia', 'Editora KS', 2016);
INSERT INTO livro VALUES ('0919289377263', 'Terapia Ocupacional', 'Editora Fernandes', 1993);
INSERT INTO livro VALUES ('2763635492000', 'Estrutura Produtiva', 'Nastri', 1999);
INSERT INTO livro VALUES ('4092898718222', 'Viagens e Fotografia', 'Editora Equili', 2009);
INSERT INTO livro VALUES ('0992837783097', 'Planejamento e Gestão do Turismo', 'Editora Equili', 2007);
INSERT INTO livro VALUES ('5679832092033', 'Sociologia do Turismo', 'Editora Equili', 2009);
INSERT INTO livro VALUES ('5739201134958', 'E-Turismo', 'Editora Equili', 2006);

INSERT INTO tipo_usuario VALUES ('Discente de Graduação', 10, 5, 2, 10);
INSERT INTO tipo_usuario VALUES ('Doscente', 15, 6, 0, 0);
INSERT INTO tipo_usuario VALUES ('Discente de Pós-graduação', 11, 5, 1, 11);
INSERT INTO tipo_usuario VALUES ('Discente a Distância', 15, 6, 0, 0);

INSERT INTO usuario VALUES ('45689612509', 'Lucas Alberto dos Santos Pinheiro', '(15) 33888972', NULL, 'Rua Tres de Marco, 193', '2017-08-26', 'lucas_pinheiro@gmail.com', '478222390', 'Discente de Graduação');
INSERT INTO usuario VALUES ('38273476372', 'Vinícius de Barro Melo Santos', '(18) 32871837', '(18) 992881230', 'Rua Santos Dumont, 981', NULL, 'viniciusdebarro@hotmail.com', '847311220', 'Discente de Pós-graduação');
INSERT INTO usuario VALUES ('68726365211', 'Maria Cunha Costa', '(11) 33823628', '(11) 988234546', 'Rua Goias, 9', '2017-11-30', 'maria07cunha@uol.com.br', '442526910', 'Discente de Graduação');
INSERT INTO usuario VALUES ('59283727627', 'Clara Alves Monteiro', '(12) 32910928', '(12) 999232187', 'Rua Santa Rita, 1001', '2017-10-31', 'clara.alves@ig.com.br', '239488055', 'Discente de Graduação');
INSERT INTO usuario VALUES ('47639283711', 'Fernando Batista', '(21) 32880091', '(21) 91425378', 'Rua Boa Vista, 236', NULL, 'fer_batista@gmail.com', '439201545', 'Discente de Pós-graduação');
INSERT INTO usuario VALUES ('48726092833', 'Laura Paes Leme', '(15) 33019282', '(15) 998371100', 'Rua Sao Sebastiao, 78', NULL, 'laraleme@gmail.com', '439211762', 'Doscente');
INSERT INTO usuario VALUES ('37627981729', 'Paulo Cardozo Barbosa', '(11) 35872983', '(11) 977822727', 'Rua Dezoito, 702', NULL, 'paulobarbosa50@hotmail.com', '562889311', 'Discente a Distância');
INSERT INTO usuario VALUES ('29839101019', 'Felipe Mendes Freitas', '(17) 31029039', '(17) 947283732', 'Avenida Três, 3449', '2017-07-07', 'fefreitas10@uol.com.br', '925516244', 'Discente a Distância');
INSERT INTO usuario VALUES ('58719083738', 'Perla Dias de Souza', '(61) 30303121', NULL, 'Avenida São Paulo, 2033', NULL, 'perladiasdesouza@hotmail.com', '801829253', 'Discente de Graduação');
INSERT INTO usuario VALUES ('23764893049', 'Maria Júlia Araújo Nascimento', '(63) 30173019', '(63) 90189045', 'Rua Martim de Luca, 90', NULL, 'maria_15_araujo@hotmail.com', '328170959', 'Discente de Graduação');
INSERT INTO usuario VALUES ('69873498022', 'José Bastos de Lima Junior', '(87) 30132634', '(87) 99883217', 'Rua Queroz de Avir, 13', '2017-05-31', 'junior_bastos@gmail.com', '521505729', 'Doscente');
INSERT INTO usuario VALUES ('72372746839', 'Daniel Silva Rocha Martins', '(81) 33827162', '(81) 93536377', 'Rua Benta Santos Souza, 40', NULL, 'daniel.rocha8@ig.com.br', '782911094', 'Discente de Graduação');
INSERT INTO usuario VALUES ('47629291837', 'Lucas de Souza Costa', '(13) 32131702', '(13) 998010123', 'Avenida Ipanema, 4028', '2017-11-19', 'costalucas@gmail.com', '289003998', 'Doscente');

INSERT INTO exemplar VALUES (1, 'Emprestado', '3239832610098');
INSERT INTO exemplar VALUES (2, 'Emprestado', '3239832610098');
INSERT INTO exemplar VALUES (3, DEFAULT, '3239832610098');
INSERT INTO exemplar VALUES (1, 'Emprestado', '7862139873276');
INSERT INTO exemplar VALUES (2, 'Emprestado', '7862139873276');
INSERT INTO exemplar VALUES (1, DEFAULT, '7640291823782');
INSERT INTO exemplar VALUES (2, DEFAULT, '7640291823782');
INSERT INTO exemplar VALUES (3, DEFAULT, '7640291823782');
INSERT INTO exemplar VALUES (4, 'Emprestado', '7640291823782');
INSERT INTO exemplar VALUES (1, DEFAULT, '0017286354635');
INSERT INTO exemplar VALUES (2, DEFAULT, '0017286354635');
INSERT INTO exemplar VALUES (1, DEFAULT, '6645251672362');
INSERT INTO exemplar VALUES (2, DEFAULT, '6645251672362');
INSERT INTO exemplar VALUES (3, 'Emprestado', '6645251672362');
INSERT INTO exemplar VALUES (1, 'Emprestado', '3298276437848');
INSERT INTO exemplar VALUES (2, 'Emprestado', '3298276437848');
INSERT INTO exemplar VALUES (3, 'Emprestado', '3298276437848');
INSERT INTO exemplar VALUES (4, DEFAULT, '3298276437848');
INSERT INTO exemplar VALUES (1, DEFAULT, '1276238476377');
INSERT INTO exemplar VALUES (2, DEFAULT, '1276238476377');
INSERT INTO exemplar VALUES (1, DEFAULT, '0988324776572');
INSERT INTO exemplar VALUES (2, DEFAULT, '0988324776572');
INSERT INTO exemplar VALUES (3, DEFAULT, '0988324776572');
INSERT INTO exemplar VALUES (1, 'Emprestado', '9281637392011');
INSERT INTO exemplar VALUES (1, 'Emprestado', '0894678643672');
INSERT INTO exemplar VALUES (2, DEFAULT, '0894678643672');
INSERT INTO exemplar VALUES (1, 'Emprestado', '1088872376632');
INSERT INTO exemplar VALUES (2, DEFAULT, '1088872376632');
INSERT INTO exemplar VALUES (3, DEFAULT, '1088872376632');
INSERT INTO exemplar VALUES (1, DEFAULT, '1872630495817');
INSERT INTO exemplar VALUES (1, 'Emprestado', '9823723643773');
INSERT INTO exemplar VALUES (2, 'Emprestado', '9823723643773');
INSERT INTO exemplar VALUES (3, DEFAULT, '9823723643773');
INSERT INTO exemplar VALUES (4, 'Emprestado', '9823723643773');
INSERT INTO exemplar VALUES (1, DEFAULT, '0919289377263');
INSERT INTO exemplar VALUES (2, DEFAULT, '0919289377263');
INSERT INTO exemplar VALUES (1, DEFAULT, '2763635492000');
INSERT INTO exemplar VALUES (2, 'Emprestado', '2763635492000');
INSERT INTO exemplar VALUES (1, 'Emprestado', '4092898718222');
INSERT INTO exemplar VALUES (2, DEFAULT, '4092898718222');
INSERT INTO exemplar VALUES (1, DEFAULT, '0992837783097');
INSERT INTO exemplar VALUES (2, DEFAULT, '0992837783097');
INSERT INTO exemplar VALUES (1, 'Emprestado', '5679832092033');
INSERT INTO exemplar VALUES (1, DEFAULT, '5739201134958');
INSERT INTO exemplar VALUES (2, DEFAULT, '5739201134958');
INSERT INTO exemplar VALUES (3, 'Emprestado', '5739201134958');

INSERT INTO empresta VALUES ('2017-11-09', '2017-11-25', DEFAULT, '3239832610098', '45689612509');
INSERT INTO assunto VALUES ('3239832610098', 'Matemática');
INSERT INTO assunto VALUES ('3239832610098', 'Ciências Exatas');
INSERT INTO assunto VALUES ('3239832610098', 'Acadêmico');
INSERT INTO autor VALUES('3239832610098', 'John Salk');
INSERT INTO autor VALUES('3239832610098', 'Fasty Wolv');
INSERT INTO autor VALUES('3239832610098', 'Lara Caudacier');

SELECT * FROM usuario;
SELECT * FROM livro;
SELECT * FROM exemplar;
SELECT * FROM tipo_usuario;
SELECT * FROM empresta;
SELECT * FROM assunto;
SELECT * FROM autor;
