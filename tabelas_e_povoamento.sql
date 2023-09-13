-- TABELA CLIENTE
CREATE TABLE CLIENTE (
    CPF VARCHAR2(11) PRIMARY KEY,
    NOME VARCHAR2(80) NOT NULL,
    TELEFONE VARCHAR2(20) NOT NULL,
    DATA_NASC DATE NOT NULL,
    END_RUA VARCHAR2(255) NOT NULL,
    END_NUMERO VARCHAR2(10) NOT NULL,
    END_CEP VARCHAR2(9) NOT NULL,
    END_CIDADE VARCHAR2(100) NOT NULL,
    END_ESTADO VARCHAR2(2) NOT NULL,
    EH_VIP NUMBER(1) NOT NULL,  -- Use NUMBER(1) para representar BOOLEAN no Oracle
    NIVEL_VIP NUMBER(3) NOT NULL,  -- Você pode ajustar o tamanho conforme necessário
    CPF_INDICADOR VARCHAR2(11),
    CONSTRAINT FK_CLIENTE_INDICADOR FOREIGN KEY (CPF_INDICADOR) REFERENCES CLIENTE(CPF)
);

-- TABELA EMAIL
CREATE TABLE EMAIL (
    CPF VARCHAR2(11),
    EMAIL VARCHAR2(255),
    CONSTRAINT PK_EMAIL PRIMARY KEY (CPF, EMAIL),
    CONSTRAINT FK_EMAIL_CLIENTE FOREIGN KEY (CPF) REFERENCES CLIENTE(CPF)
);

-- TABELA FORNECEDOR
CREATE TABLE FORNECEDOR (
    CNPJ VARCHAR2(14) PRIMARY KEY,
    NOME VARCHAR2(255) NOT NULL,
    TELEFONE VARCHAR2(20) NOT NULL,
    EMAIL VARCHAR2(255) NOT NULL
);

-- TABELA PRODUTO
CREATE TABLE PRODUTO (
    COD_PRODUTO NUMBER PRIMARY KEY,
    NOME VARCHAR2(255) NOT NULL,
    DESCRICAO CLOB NOT NULL,
    TAMANHO VARCHAR2(50) NOT NULL,
    PRECO NUMBER(10, 2) NOT NULL,
    COD_FORNECEDOR VARCHAR2(14) NOT NULL,
    CONSTRAINT FK_PRODUTO_FORNECEDOR FOREIGN KEY (COD_FORNECEDOR) REFERENCES FORNECEDOR(CNPJ)
);

-- TABELA CUPOM
CREATE TABLE CUPOM (
    COD_PROMO NUMBER PRIMARY KEY,
    DESCRICAO VARCHAR2(255)
);

-- TABELA CARTAOFIDELIDADE
CREATE TABLE CARTAOFIDELIDADE (
    COD_CARTAO NUMBER PRIMARY KEY,
    COD_CLIENTE VARCHAR2(11) NOT NULL,
    DESCRICAO VARCHAR2(255),
    NUM_REGISTROS NUMBER,
    CONSTRAINT FK_CARTAOFIDELIDADE_CLIENTE FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE(CPF)
);

-- TABELA LISTADESEJOS
CREATE TABLE LISTADESEJOS (
    CPF_CLIENTE VARCHAR2(11),
    DATA_CRIACAO DATE,
    NOME VARCHAR2(255),
    CONSTRAINT PK_LISTADESEJOS PRIMARY KEY (CPF_CLIENTE, DATA_CRIACAO),
    CONSTRAINT FK_LISTADESEJOS_CLIENTE FOREIGN KEY (CPF_CLIENTE) REFERENCES CLIENTE(CPF)
);

-- TABELA PEDIDO
CREATE TABLE PEDIDO (
    COD_PEDIDO NUMBER PRIMARY KEY,
    COD_CLIENTE VARCHAR2(11) NOT NULL,
    CONSTRAINT FK_PEDIDO_CLIENTE FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE(CPF)
);

-- TABELA REALIZACOMPRA
CREATE TABLE REALIZACOMPRA (
    CPF_CLIENTE VARCHAR2(11),
    COD_PEDIDO NUMBER,
    CONSTRAINT PK_REALIZACOMPRA PRIMARY KEY (CPF_CLIENTE, COD_PEDIDO),
    CONSTRAINT FK_REALIZACOMPRA_CLIENTE FOREIGN KEY (CPF_CLIENTE) REFERENCES CLIENTE(CPF),
    CONSTRAINT FK_REALIZACOMPRA_PEDIDO FOREIGN KEY (COD_PEDIDO) REFERENCES PEDIDO(COD_PEDIDO)
);

-- TABELA REALIZACOMPRA_CUPOM
CREATE TABLE REALIZACOMPRA_CUPOM (
    CPF_CLIENTE VARCHAR2(11),
    COD_PEDIDO NUMBER,
    COD_CUPOM NUMBER,
    CONSTRAINT PK_REALIZACOMPRA_CUPOM PRIMARY KEY (CPF_CLIENTE, COD_PEDIDO, COD_CUPOM),
    CONSTRAINT FK_REALIZACOMPRA_CUPOM_CLIENTE FOREIGN KEY (CPF_CLIENTE) REFERENCES CLIENTE(CPF),
    CONSTRAINT FK_REALIZACOMPRA_CUPOM_PEDIDO FOREIGN KEY (COD_PEDIDO) REFERENCES PEDIDO(COD_PEDIDO),
    CONSTRAINT FK_REALIZACOMPRA_CUPOM_CUPOM FOREIGN KEY (COD_CUPOM) REFERENCES CUPOM(COD_PROMO)
);

-- TABELA CONTEM
CREATE TABLE CONTEM (
    COD_PEDIDO NUMBER,
    COD_PRODUTO NUMBER,
    CONSTRAINT PK_CONTEM PRIMARY KEY (COD_PEDIDO, COD_PRODUTO),
    CONSTRAINT FK_CONTEM_PEDIDO FOREIGN KEY (COD_PEDIDO) REFERENCES PEDIDO(COD_PEDIDO),
    CONSTRAINT FK_CONTEM_PRODUTO FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO(COD_PRODUTO)
);

-- TABELA ADICIONA
CREATE TABLE ADICIONA (
    CPF_CLIENTE VARCHAR2(11),
    COD_PRODUTO NUMBER,
    COD_LISTADESEJOS DATE,
    CONSTRAINT PK_ADICIONA PRIMARY KEY (CPF_CLIENTE, COD_PRODUTO, COD_LISTADESEJOS),
    CONSTRAINT FK_ADICIONA_CLIENTE FOREIGN KEY (CPF_CLIENTE) REFERENCES CLIENTE(CPF),
    CONSTRAINT FK_ADICIONA_PRODUTO FOREIGN KEY (COD_PRODUTO) REFERENCES PRODUTO(COD_PRODUTO),
    CONSTRAINT FK_ADICIONA_LISTADESEJOS FOREIGN KEY (CPF_CLIENTE, COD_LISTADESEJOS) REFERENCES LISTADESEJOS(CPF_CLIENTE, DATA_CRIACAO)
);


INSERT INTO FORNECEDOR (CNPJ, NOME, TELEFONE, EMAIL) VALUES ('12345678901234', 'Fornecedor A', '555-1234', 'fornecedorA@example.com');
INSERT INTO FORNECEDOR (CNPJ, NOME, TELEFONE, EMAIL) VALUES ('56789012345678', 'Fornecedor B', '555-5678', 'fornecedorB@example.com');

INSERT INTO CLIENTE (CPF, NOME, TELEFONE, DATA_NASC, END_RUA, END_NUMERO, END_CEP, END_CIDADE, END_ESTADO, EH_VIP, NIVEL_VIP, CPF_INDICADOR) VALUES ('11111111111', 'Cliente A', '555-1111', TO_DATE('1990-01-15', 'YYYY-MM-DD'), 'Rua A', '123', '12345-678', 'Cidade A', 'AA', 1, 2, NULL);
INSERT INTO CLIENTE (CPF, NOME, TELEFONE, DATA_NASC, END_RUA, END_NUMERO, END_CEP, END_CIDADE, END_ESTADO, EH_VIP, NIVEL_VIP, CPF_INDICADOR) VALUES ('22222222222', 'Cliente B', '555-2222', TO_DATE('1995-05-20', 'YYYY-MM-DD'), 'Rua B', '456', '98765-432', 'Cidade B', 'BB', 0, 0, NULL);


INSERT INTO PEDIDO (COD_PEDIDO, COD_CLIENTE) VALUES (101, '11111111111');
INSERT INTO PEDIDO (COD_PEDIDO, COD_CLIENTE) VALUES (102, '22222222222');


INSERT INTO PRODUTO (COD_PRODUTO, NOME, DESCRICAO, TAMANHO, PRECO, COD_FORNECEDOR) VALUES (1, 'Produto X', 'Descrição do Produto X', 'M', 49.99, '12345678901234');
INSERT INTO PRODUTO (COD_PRODUTO, NOME, DESCRICAO, TAMANHO, PRECO, COD_FORNECEDOR) VALUES (2, 'Produto Y', 'Descrição do Produto Y', 'L', 79.99, '56789012345678');


INSERT INTO CUPOM (COD_PROMO, DESCRICAO) VALUES (1001, 'Cupom de Desconto A');
INSERT INTO CUPOM (COD_PROMO, DESCRICAO) VALUES (1002, 'Cupom de Desconto B');


INSERT INTO CARTAOFIDELIDADE (COD_CARTAO, COD_CLIENTE, DESCRICAO, NUM_REGISTROS) VALUES (2001, '11111111111', 'Cartão de Fidelidade A', 5);
INSERT INTO CARTAOFIDELIDADE (COD_CARTAO, COD_CLIENTE, DESCRICAO, NUM_REGISTROS) VALUES (2002, '22222222222', 'Cartão de Fidelidade B', 3);


INSERT INTO LISTADESEJOS (CPF_CLIENTE, DATA_CRIACAO, NOME) VALUES ('11111111111', TO_DATE('2023-09-01', 'YYYY-MM-DD'), 'Lista de Desejos A');
INSERT INTO LISTADESEJOS (CPF_CLIENTE, DATA_CRIACAO, NOME) VALUES ('22222222222', TO_DATE('2023-09-02', 'YYYY-MM-DD'), 'Lista de Desejos B');
