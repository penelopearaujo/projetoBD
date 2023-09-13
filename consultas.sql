-- Consulta alternativa para calcular o valor total do pedido 101 (substitua pelo código do pedido desejado)
SELECT p.cod_pedido,
       SUM(pr.preco) AS valor_total
FROM Pedido p
JOIN Contem c ON p.cod_pedido = c.cod_pedido
JOIN Produto pr ON c.cod_produto = pr.cod_produto
WHERE p.cod_pedido = 101
GROUP BY p.cod_pedido, p.cod_cliente;

-- Consulta com GROUP BY e HAVING: Clientes com mais de um pedido
SELECT c.nome AS cliente, COUNT(p.cod_pedido) AS total_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.cpf = p.cod_cliente
GROUP BY c.nome, c.cpf
HAVING COUNT(p.cod_pedido) > 1;

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

-- Subconsulta Escalar: Nome do cliente com o pedido mais recente
SELECT c.nome
FROM Cliente c
WHERE c.cpf = (
    SELECT p.cod_cliente
    FROM Pedido p
    WHERE p.cod_pedido = (
        SELECT MAX(p2.cod_pedido)
        FROM Pedido p2
    )
);

-- Subconsulta de Linha: Detalhes dos produtos em um pedido específico
SELECT p.cod_produto, p.nome, p.descricao
FROM Produto p
WHERE p.cod_produto IN (
    SELECT cod_produto
    FROM Contem
    WHERE cod_pedido = 101
);

-- Subconsulta de Tabela: Pedidos feitos por clientes VIP
SELECT cod_pedido, cod_cliente
FROM Pedido
WHERE cod_cliente IN (
    SELECT cpf
    FROM Cliente
    WHERE eh_vip = 1
);

-- Operação de Conjunto (UNION ALL): Lista de entidades (clientes e fornecedores) com seus respectivos tipos
SELECT nome AS entidade, 'Cliente' AS tipo FROM CLIENTE
UNION ALL
SELECT nome AS entidade, 'Fornecedor' AS tipo FROM FORNECEDOR;