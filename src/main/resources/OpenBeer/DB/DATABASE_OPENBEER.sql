DROP DATABASE OPENBEER;

CREATE DATABASE IF NOT EXISTS OPENBEER;
USE OPENBEER;

/* PREFIXO DAS TABELA
	TS = TABELA DO SISTEMA
    TB = TABELA NORMAL
    VD = TABELA DE VENDAS
    FI = TABELA DE FINANCEIRO
*/

-- TABELA DE PERMISSÃO DE ACESSO AO SISTEMA
CREATE TABLE IF NOT EXISTS TS_PERMISSAOACESSO (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
PERMISSAO CHAR(15),
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID)

);

INSERT INTO TS_PERMISSAOACESSO(PERMISSAO, DH_INCLUSAO)
VALUES("CLIENTE",NOW());

INSERT INTO TS_PERMISSAOACESSO(PERMISSAO, DH_INCLUSAO)
VALUES("FUNCIONARIO",NOW());

-- TABELA DE LOGIN
CREATE TABLE IF NOT EXISTS TS_LOGIN (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
EMAIL VARCHAR(200),
SENHA VARCHAR(150),
FK_PERMISSAOACESSO BIGINT NOT NULL,
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_PERMISSAOACESSO) REFERENCES TS_PERMISSAOACESSO ( PK_ID )

);

-- TABELA DE CLIENTES
CREATE TABLE IF NOT EXISTS TB_CLIENTE (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
CPF	CHAR(15),
NOME CHAR(100),
APELIDO CHAR(30),
DT_NASCIMENTO DATE,
TG_SEXO	CHAR(1),
TELEFONE CHAR(15),
CELULAR CHAR(15),
FK_LOGIN BIGINT NOT NULL,
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_LOGIN) REFERENCES TS_LOGIN ( PK_ID )

);
-- TABELA DE DE FUNCIONARIOS
CREATE TABLE IF NOT EXISTS TB_FUNCIONARIO (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
CPF	CHAR(15),
NOME CHAR(100),
APELIDO CHAR(30),
DT_NASCIMENTO DATE,
TG_SEXO	CHAR(1),
FK_LOGIN BIGINT NOT NULL,
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_LOGIN) REFERENCES TS_LOGIN ( PK_ID )

);

-- TABELA DE ENDEREÇOS 
CREATE TABLE IF NOT EXISTS TB_ENDERECO (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
DESTINATARIO VARCHAR(100),
CEP	CHAR(9),
ENDERECO VARCHAR(300),
NUMERO INT(5),
COMPLEMENTO CHAR(30),
REFERENCIA VARCHAR(150),
BAIRRO VARCHAR(200),
CIDADE CHAR(80),
ESTADO	CHAR(2),
FK_CLIENTE BIGINT NOT NULL,
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_CLIENTE) REFERENCES TB_CLIENTE ( PK_ID )

);

-- TABELA DE TIPOS DE CERVEJA
CREATE TABLE IF NOT EXISTS TB_TIPOCERVEJA (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
TIPOCERVEJA	CHAR(80),
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID)

);

INSERT INTO TB_TIPOCERVEJA (TIPOCERVEJA, TG_INATIVO, DH_INCLUSAO)
VALUES ('ARTESANAL',0,NOW());

INSERT INTO TB_TIPOCERVEJA (TIPOCERVEJA, TG_INATIVO, DH_INCLUSAO)
VALUES ('IMPORTADA',0,NOW());

INSERT INTO TB_TIPOCERVEJA (TIPOCERVEJA, TG_INATIVO, DH_INCLUSAO)
VALUES ('AMARGA',0,NOW());

INSERT INTO TB_TIPOCERVEJA (TIPOCERVEJA, TG_INATIVO, DH_INCLUSAO)
VALUES ('ADOCICADA',0,NOW());


-- TABELA DE CERVEJAS
CREATE TABLE IF NOT EXISTS TB_CERVEJA (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
CERVEJA	VARCHAR(350),
DESCRICAO TEXT,
VL_TOTAL NUMERIC(13,2),
CODIGO CHAR(60),
MARCA  CHAR(80),
QUANTIDADE BIGINT,
ML NUMERIC(13,2),
TEOR BIGINT,
FK_TIPOCERVEJA BIGINT,
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_TIPOCERVEJA) REFERENCES TB_TIPOCERVEJA ( PK_ID )

);

-- TABELA DE STATUS DO PEDIDOS
CREATE TABLE IF NOT EXISTS TB_STATUSPEDIDO (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
STATUSPEDIDO	CHAR(60),
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID)

);

INSERT INTO TB_STATUSPEDIDO (STATUSPEDIDO, DH_INCLUSAO)
VALUES('PEDIDO EFETUADO', NOW());

INSERT INTO TB_STATUSPEDIDO (STATUSPEDIDO, DH_INCLUSAO)
VALUES('PEDIDO APROVADO', NOW());

INSERT INTO TB_STATUSPEDIDO (STATUSPEDIDO, DH_INCLUSAO)
VALUES('PEDIDO RECUSADO', NOW());

INSERT INTO TB_STATUSPEDIDO (STATUSPEDIDO, DH_INCLUSAO)
VALUES('PEDIDO EM TRANSPORTE', NOW());

INSERT INTO TB_STATUSPEDIDO (STATUSPEDIDO, DH_INCLUSAO)
VALUES('PEDIDO ENTREGUE', NOW());

CREATE TABLE IF NOT EXISTS TB_TIPOENTREGA (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
TIPOENTREGA CHAR(50),
VL_ENTREGA NUMERIC(13,2),
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID)

);

INSERT INTO TB_TIPOENTREGA (TIPOENTREGA, VL_ENTREGA, TG_INATIVO, DH_INCLUSAO)
VALUES ('Rápida', 15.95 ,0,NOW());

INSERT INTO TB_TIPOENTREGA (TIPOENTREGA, VL_ENTREGA, TG_INATIVO, DH_INCLUSAO)
VALUES ('Agendada', 25.00 ,0,NOW());

-- TABELA DE PEDIDOS
CREATE TABLE IF NOT EXISTS VD_PEDIDO (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
FK_CLIENTE BIGINT NOT NULL,
FK_CERVEJA BIGINT NOT NULL,
FK_TIPOENTREGA BIGINT NOT NULL,
FK_STATUSPEDIDO BIGINT NOT NULL,
VL_PEDIDO NUMERIC(13,2),
DH_PEDIDO DATETIME,
DT_PREVICAOENTREGA DATE,
DT_ENTREGA	DATE,
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_CLIENTE) REFERENCES TB_CLIENTE ( PK_ID ),
FOREIGN KEY (FK_TIPOENTREGA) REFERENCES TB_TIPOENTREGA ( PK_ID ),
FOREIGN KEY (FK_CERVEJA) REFERENCES TB_CERVEJA ( PK_ID ),
FOREIGN KEY (FK_STATUSPEDIDO) REFERENCES TB_STATUSPEDIDO ( PK_ID )

);

/*CREATE TABLE IF NOT EXISTS VD_CARRINHO (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
QUANTIDADE NUMERIC(10),
VL_TOTAL NUMERIC(13,2),
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID)
);*/

CREATE TABLE IF NOT EXISTS VD_ITENSCARRINHO (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
FK_CLIENTE BIGINT NOT NULL,
FK_CERVEJA BIGINT NOT NULL,
QUANTIDADE BIGINT,
VL_TOTAL NUMERIC(13,2),
DH_COMPRAR DATETIME,
DH_INCLUSAO DATETIME,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_CLIENTE) REFERENCES TB_CLIENTE ( PK_ID ),
FOREIGN KEY (FK_CERVEJA) REFERENCES TB_CERVEJA ( PK_ID )

);

-- TABELA DE MOVIMENTAÇÃO FINANCEIRA
CREATE TABLE IF NOT EXISTS FI_MOVFIN (

PK_ID BIGINT NOT NULL AUTO_INCREMENT,
FK_CLIENTE BIGINT NOT NULL,
FK_CERVEJA BIGINT NOT NULL,
VL_TOTAL NUMERIC(13,2),
VL_DESCONTO NUMERIC(13,2),
DH_COMPRA DATETIME,
TG_INATIVO TINYINT DEFAULT 0,
DH_INCLUSAO DATETIME,
DH_ALTERACAO DATETIME,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_CLIENTE) REFERENCES TB_CLIENTE ( PK_ID ),
FOREIGN KEY (FK_CERVEJA) REFERENCES TB_CERVEJA ( PK_ID )

);

-- INDEXS TS_CLIENTE
CREATE INDEX IDX_CLIENTE_PK_ID ON TB_CLIENTE(PK_ID);
CREATE INDEX IDX_CLIENTE_NOME ON TB_CLIENTE(NOME);
CREATE INDEX IDX_CLIENTE_CPF ON TB_CLIENTE(CPF);
CREATE INDEX IDX_CLIENTE_APELIDO ON TB_CLIENTE(APELIDO);

-- INDEXS TB_PRODUTO
CREATE INDEX IDX_CERVEJA_PK_ID ON TB_CERVEJA(PK_ID);
CREATE INDEX IDX_CERVEJA_PRODUTO ON TB_CERVEJA(CERVEJA);
CREATE INDEX IDX_CERVEJA_CODIGO ON TB_CERVEJA(CODIGO);
CREATE INDEX IDX_CERVEJA_MARCA ON TB_CERVEJA(MARCA);

-- INDEXS VD_PEDIDO
CREATE INDEX IDX_PEDIDO_PK_ID ON VD_PEDIDO(PK_ID);
CREATE INDEX IDX_PEDIDO_FK_CLIENTE ON VD_PEDIDO(FK_CLIENTE);
CREATE INDEX IDX_PEDIDO_FK_CERVEJA ON VD_PEDIDO(FK_CERVEJA);
CREATE INDEX IDX_PEDIDO_FK_STATUSPEDIDO ON VD_PEDIDO(FK_STATUSPEDIDO);
CREATE INDEX IDX_PEDIDO_DH_PEDIDO ON VD_PEDIDO(DH_PEDIDO);
CREATE INDEX IDX_PEDIDO_DT_PREVICAOENTREGA ON VD_PEDIDO(DT_PREVICAOENTREGA);
CREATE INDEX IDX_PEDIDO_DT_ENTREGA ON VD_PEDIDO(DT_ENTREGA);

-- INDEXS FI_MOVFIN
CREATE INDEX IDX_MOVFIN_PK_ID ON FI_MOVFIN(PK_ID);
CREATE INDEX IDX_MOVFIN_FK_CLIENTE ON FI_MOVFIN(FK_CLIENTE);
CREATE INDEX IDX_MOVFIN_FK_CERVEJA ON FI_MOVFIN(FK_CERVEJA);
CREATE INDEX IDX_MOVFIN_DH_COMPRA ON FI_MOVFIN(DH_COMPRA);

-- INDEXS TS_LOGIN
CREATE INDEX IDX_LOGIN_PK_ID ON TS_LOGIN(PK_ID);

-- INDEXS TS_PERMISSAOACESSO
CREATE INDEX IDX_PERMISSAOACESSO_PK_ID ON TS_PERMISSAOACESSO(PK_ID);

DELIMITER|

CREATE 
	EVENT `LIMPA_ITENSPEDIDOS` 
	ON SCHEDULE EVERY 1 DAY
	DO BEGIN
		TRUNCATE TABLE VD_ITENSCARRINHO
	END|

DELIMITER ;

