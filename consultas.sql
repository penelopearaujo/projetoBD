-- Consulta com GROUP BY: Número de produtos vendidos por pedido
SELECT p.cod_pedido, COUNT(c.cod_produto) AS quantidade_produto
FROM Pedido p
LEFT JOIN Contém c ON p.cod_pedido = c.cod_pedido
GROUP BY p.cod_pedido
HAVING COUNT(c.cod_produto) > 3;

-- Junção Interna (INNER JOIN): Produtos e seus fornecedores
SELECT p.nome AS produto, f.nome AS fornecedor
FROM Produto p
INNER JOIN Fornecedor f ON p.cod_fornecedor = f.cnpj;

-- Junção Externa (LEFT JOIN): Clientes e pedidos (incluindo clientes sem pedidos)
SELECT c.nome AS cliente, p.cod_pedido
FROM Cliente c
LEFT JOIN Pedido p ON c.cpf = p.cod_cliente;

-- Semi-Junção: Clientes que fizeram pelo menos um pedido
SELECT c.cpf, c.nome
FROM Cliente c
WHERE EXISTS (
    SELECT 1
    FROM Pedido p
    WHERE p.cod_cliente = c.cpf
);

-- Anti-Junção: Clientes que não fizeram nenhum pedido
SELECT c.cpf, c.nome
FROM Cliente c
WHERE NOT EXISTS (
    SELECT 1
    FROM Pedido p
    WHERE p.cod_cliente = c.cpf
);

-- Subconsulta Escalar: Nome do cliente com o pedido de maior valor
SELECT nome
FROM Cliente
WHERE cpf = (
    SELECT cod_cliente
    FROM Pedido
    WHERE cod_pedido = (
        SELECT MAX(preco)
        FROM Pedido
    )
);

-- Subconsulta de Linha: Detalhes dos produtos em um pedido específico
SELECT p.cod_produto, p.nome, p.descricao
FROM Produto p
WHERE p.cod_produto IN (
    SELECT cod_produto
    FROM Contém
    WHERE cod_pedido = 'codigo_do_pedido'
);

-- Subconsulta de Tabela: Pedidos feitos por clientes VIP
SELECT cod_pedido, cod_cliente
FROM Pedido
WHERE cod_cliente IN (
    SELECT cpf
    FROM Cliente
    WHERE eh_vip = true
);

-- Operação de Conjunto (UNION): Combinação de emails de clientes e fornecedores
SELECT email FROM Cliente
UNION
SELECT email FROM Fornecedor;