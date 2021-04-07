------------------------------------------------------------------------------
-------- Alunos:
-- Cleiton Aparecido
-- Clemente Sepulveda
-- Fernando Fernandes
-- Jacó Rocha
-- Lucas Afonso

-- Falta: 
-- → retirar débito de cliente ao pagar uma conta/parcela
-- → criar trigger para compra/entrada


CREATE TABLE "usuario" (
	"id_usuario" int NOT NULL,
	"usuario" varchar(10),
	"senha" int,
	"email" varchar(30),
	"nome_completo" varchar(50),
	PRIMARY KEY ("id_usuario")
);

CREATE TABLE "cliente" (
	"id_cliente" int NOT NULL,
	"nome_cliente" varchar(100),
	"cpf" varchar(25),
	"credito" decimal(7,2) DEFAULT 0,
	"debito" decimal(7,2) DEFAULT 0,
	PRIMARY KEY ("id_cliente")
);

CREATE TABLE "telefone" (
	"id_telefone" int NOT NULL,
	"id_cliente" int,
	"num_telefone" varchar(25),
	"ddd" int,
	"whatsapp" bool DEFAULT false,
	PRIMARY KEY ("id_telefone")
);

CREATE TABLE "endereco" (
	"id_endereco" int NOT NULL,
	"id_cliente" int NOT NULL,
	"rua" varchar(100),
	"bairro" varchar(30),
	"cidade" varchar(30),
	"estado" char(2),
	"numero" varchar(5),	
	PRIMARY KEY ("id_endereco")
);

CREATE TABLE "funcionario" (
	"id_funcionario" int NOT NULL,
	"nome_funcionario" varchar(100),
	"telefone" varchar(30),
	"cpf" varchar(15),
	"endereço" varchar(100),
	"cargo" varchar(20),
	"salario" decimal(7,2) DEFAULT 0,
	PRIMARY KEY ("id_funcionario")
);

CREATE TABLE "caixa" (
	"id_caixa" int NOT NULL,
	"id_funcionario" int,
	"valor_em_caixa" decimal(7,2) DEFAULT 0,
	PRIMARY KEY ("id_caixa")
);

CREATE TABLE "forma_pagamento" (
	"id_forma_pagamento" int NOT NULL,
	"tipo_pagamento" varchar(50),
	PRIMARY KEY ("id_forma_pagamento")
);

CREATE TABLE "fornecedor" (
	"id_fornecedor" int NOT NULL,
	"nome_fornecedor" varchar(100),
	"telefone" varchar(30),
	"cidade" varchar(30),
	"estado" varchar(20),
	PRIMARY KEY ("id_fornecedor")
);

CREATE TABLE "categoria" (
	"id_categoria" int NOT NULL,
	"nome_categoria" varchar(20),
	PRIMARY KEY ("id_categoria")
);

CREATE TABLE "produto" (
	"id_produto" int NOT NULL,
	"id_categoria" int,
	"nome_produto" varchar(30),
	"icms" decimal(7,2) DEFAULT 0,
	"ipi" decimal(7,2) DEFAULT 0,
	"frete" decimal(7,2) DEFAULT 0,
	"acrescimo_despesas" decimal(7,2) DEFAULT 0,
	"preco_na_fabrica" decimal(7,2) DEFAULT 0,
	"preco_compra" decimal(7,2) DEFAULT 0,
	"preco_venda" decimal(7,2) DEFAULT 0,
	"lucro" decimal(7,2) DEFAULT 0,
	"desconto" decimal(5,2) DEFAULT 0,
	"quantidade" int DEFAULT 0,
	PRIMARY KEY ("id_produto")
);

CREATE TABLE "compra" (
	"id_compra" int NOT NULL,
	"id_funcionario" int,
	"id_fornecedor" int,
	"valor_total" decimal(7,2) DEFAULT 0,
	"data_compra" date,
	"parcelas" int,
	PRIMARY KEY ("id_compra")
);

CREATE TABLE "item_compra" (
	"id_item_compra" int NOT NULL,
	"id_produto" int,
	"id_compra" int,
	"ipi" decimal(5,2) DEFAULT 0,
	"frete" decimal(5,2) DEFAULT 0,
	"icms" decimal(5,2) DEFAULT 0,
	"preco_compra" decimal(7,2) DEFAULT 0,
	"quantidade" int,
	PRIMARY KEY ("id_item_compra")
);

CREATE TABLE "pagamento_compra" (
	"id_pagamento_compra" int NOT NULL,
	"id_compra" int,
	"id_forma_de_pagamento" int,
	"parcelas" int,
	"prazo" varchar(20),
	"status" char(2),
	PRIMARY KEY ("id_pagamento_compra")
);

CREATE TABLE "venda" (
	"id_venda" int NOT NULL,
	"id_caixa" int,
	"id_cliente" int,
	"num_parcelas" int2,
	"valor_total" decimal(7,2) DEFAULT 0,
	"data_venda" date,
	PRIMARY KEY ("id_venda")
);

CREATE TABLE "item_venda" (
	"id_item_venda" int NOT NULL,
	"id_produto" int,
	"id_venda" int,
	"valor_unitario" decimal(7,2) DEFAULT 0,
	"quantidade" int,
	PRIMARY KEY ("id_item_venda")
);

CREATE TABLE "pagamento_venda" (
	"id_pagamento_venda" int NOT NULL,
	"id_venda" int,
	"id_forma_pagamento" int,
	"numero_de_parcelas" int,
	"valor_a_pagar" decimal(7,2) DEFAULT 0,
	"valor_pago" decimal(7,2) DEFAULT 0,
	PRIMARY KEY ("id_pagamento_venda")
);

CREATE TABLE "parcelas" (
	"id_parcela" SERIAL NOT NULL,
	"id_pagamento_venda" int,
	"numero_da_parcela" int,
	"valor_parcela" decimal(7,2) DEFAULT 0,
	"data_vencimento" date,
	"data_pagamento" date,
	"status" char(2),
	PRIMARY KEY ("id_parcela")
);

CREATE TABLE "devolucao" (
	"id_devolucao" int NOT NULL,
	"id_produto" int,
	"id_item_venda" int,
	"motivo_devolucao" varchar(255),
	"quantidade" int,
	PRIMARY KEY ("id_devolucao")
);

------------------------------------------------------------------------------
---- foreign keys

ALTER TABLE "caixa" ADD FOREIGN KEY ("id_funcionario") REFERENCES "funcionario" ("id_funcionario");
ALTER TABLE "compra" ADD FOREIGN KEY ("id_fornecedor") REFERENCES "fornecedor" ("id_fornecedor");
ALTER TABLE "compra" ADD FOREIGN KEY ("id_funcionario") REFERENCES "funcionario" ("id_funcionario");
ALTER TABLE "endereco" ADD FOREIGN KEY ("id_cliente") REFERENCES "cliente" ("id_cliente");
ALTER TABLE "item_compra" ADD FOREIGN KEY ("id_compra") REFERENCES "compra" ("id_compra");
ALTER TABLE "item_compra" ADD FOREIGN KEY ("id_produto") REFERENCES "produto" ("id_produto");
ALTER TABLE "devolucao" ADD FOREIGN KEY ("id_produto") REFERENCES "produto" ("id_produto");
ALTER TABLE "devolucao" ADD FOREIGN KEY ("id_item_venda") REFERENCES "item_venda" ("id_item_venda");
ALTER TABLE "item_venda" ADD FOREIGN KEY ("id_produto") REFERENCES "produto" ("id_produto");
ALTER TABLE "item_venda" ADD FOREIGN KEY ("id_venda") REFERENCES "venda" ("id_venda");
ALTER TABLE "pagamento_compra" ADD FOREIGN KEY ("id_forma_de_pagamento") REFERENCES "forma_pagamento" ("id_forma_pagamento");
ALTER TABLE "pagamento_compra" ADD FOREIGN KEY ("id_compra") REFERENCES "compra" ("id_compra");
ALTER TABLE "pagamento_venda" ADD FOREIGN KEY ("id_venda") REFERENCES "venda" ("id_venda");
ALTER TABLE "pagamento_venda" ADD FOREIGN KEY ("id_forma_pagamento") REFERENCES "forma_pagamento" ("id_forma_pagamento");
ALTER TABLE "produto" ADD FOREIGN KEY ("id_categoria") REFERENCES "categoria" ("id_categoria");
ALTER TABLE "telefone" ADD FOREIGN KEY ("id_cliente") REFERENCES "cliente" ("id_cliente");
ALTER TABLE "venda" ADD FOREIGN KEY ("id_cliente") REFERENCES "cliente" ("id_cliente");
ALTER TABLE "venda" ADD FOREIGN KEY ("id_caixa") REFERENCES "caixa" ("id_caixa");
ALTER TABLE "parcelas" ADD FOREIGN KEY ("id_pagamento_venda") REFERENCES "pagamento_venda" ("id_pagamento_venda");

------------------------------------------------------------------------------
-- funções para compra

-- função para atualizar o valor total da compra e a quantidade do produto
CREATE OR REPLACE FUNCTION SetCompra()
RETURNS TRIGGER AS $$

	-- lucro hipotetico de 40% encima de cada produto
	DECLARE var_acrescimo_despesas numeric(7,2) := (0.4);

	BEGIN
		
		UPDATE compra 
		SET valor_total = valor_total + (NEW.quantidade * (NEW.preco_compra + (NEW.preco_compra * (NEW.icms + NEW.ipi + NEW.frete))))
		WHERE id_compra = NEW.id_compra;

		UPDATE produto
		SET icms = NEW.icms,
			ipi = NEW.ipi,
			frete = NEW.frete,
			acrescimo_despesas = var_acrescimo_despesas,
			preco_compra = NEW.preco_compra + (NEW.preco_compra * (NEW.icms + NEW.ipi + NEW.frete)),
			preco_na_fabrica = NEW.preco_compra,
			preco_venda = NEW.preco_compra + (NEW.preco_compra * (NEW.icms + NEW.ipi + NEW.frete + var_acrescimo_despesas)),
			quantidade = quantidade + NEW.quantidade
		WHERE id_produto = NEW.id_produto;
	
		RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER SetCompra
AFTER INSERT ON item_compra
FOR EACH ROW
EXECUTE PROCEDURE SetCompra();


-- função para atualizar o valor total da compra e a quantidade do produto
CREATE OR REPLACE FUNCTION AttCompra()
RETURNS TRIGGER AS $$

	-- lucro hipotetico de 40% encima de cada produto
	DECLARE var_acrescimo_despesas numeric(7,2) := (0.4);
	DECLARE quant_estoque int := (SELECT pr.quantidade FROM produto AS pr WHERE pr.id_produto = NEW.id_produto);

	BEGIN
	
		UPDATE compra 
		SET valor_total = valor_total - (
			(OLD.quantidade * (OLD.preco_compra + (OLD.preco_compra * (OLD.icms + OLD.ipi + OLD.frete)))) -
			(NEW.quantidade * (NEW.preco_compra + (NEW.preco_compra * (NEW.icms + NEW.ipi + NEW.frete))))
		)
		WHERE id_compra = NEW.id_compra;

		UPDATE produto
		SET icms = icms - (OLD.icms - NEW.icms),
			ipi = ipi - (OLD.ipi - NEW.ipi),
			frete = frete - (OLD.frete - NEW.frete),
			preco_compra = preco_compra - (
				(OLD.preco_compra + (OLD.preco_compra * (OLD.icms + OLD.ipi + OLD.frete))) -
				(NEW.preco_compra + (NEW.preco_compra * (NEW.icms + NEW.ipi + NEW.frete)))
			),
			preco_na_fabrica = preco_na_fabrica - (OLD.preco_compra - NEW.preco_compra),
			preco_venda = preco_venda - (
				(OLD.preco_compra + (OLD.preco_compra * (OLD.icms + OLD.ipi + OLD.frete + var_acrescimo_despesas))) -
				(NEW.preco_compra + (NEW.preco_compra * (NEW.icms + NEW.ipi + NEW.frete + var_acrescimo_despesas)))
			),
			quantidade = quantidade - (OLD.quantidade - NEW.quantidade)
		WHERE id_produto = NEW.id_produto;
	
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER AttCompra
AFTER UPDATE ON item_compra
FOR EACH ROW
EXECUTE PROCEDURE AttCompra();


-- função para atualizar o valor total da compra e a quantidade do produto
CREATE OR REPLACE FUNCTION DelCompra()
RETURNS TRIGGER AS $$
	BEGIN
	
		UPDATE compra 
		SET valor_total = valor_total - (
			OLD.quantidade * (OLD.preco_compra + (OLD.preco_compra * (OLD.icms + OLD.ipi + OLD.frete)))
		)
		WHERE id_compra = OLD.id_compra;
		
		UPDATE produto SET quantidade = quantidade - OLD.quantidade WHERE id_produto = OLD.id_produto;
	
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER DelCompra
AFTER DELETE ON item_compra
FOR EACH ROW
EXECUTE PROCEDURE DelCompra();


------------------------------------------------------------------------------
---- funções para venda

CREATE OR REPLACE FUNCTION SetVenda()
RETURNS TRIGGER AS $$

	DECLARE quantidade_estoque int := (SELECT quantidade FROM produto WHERE id_produto = NEW.id_produto);
	DECLARE var_preco_compra decimal(7,2) := (SELECT preco_compra FROM produto WHERE id_produto = NEW.id_produto);

	BEGIN
		
		IF NEW.quantidade > quantidade_estoque THEN
			RAISE EXCEPTION 'A quantidade a ser vendida (%) é maior que a quantidade em estoque (%)', NEW.quantidade, quantidade_estoque;
		ELSE
			UPDATE venda SET valor_total = valor_total + (NEW.quantidade * NEW.valor_unitario) WHERE id_venda = NEW.id_venda;
			UPDATE produto 
			SET quantidade = quantidade - NEW.quantidade,
					lucro = lucro + ((NEW.valor_unitario - var_preco_compra) * NEW.quantidade)
			WHERE id_produto = NEW.id_produto;
		END IF;
		
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER SetVenda
AFTER INSERT ON item_venda
FOR EACH ROW
EXECUTE PROCEDURE SetVenda();


CREATE OR REPLACE FUNCTION AttVenda()
RETURNS TRIGGER AS $$
	
	DECLARE quantidade_estoque int := (SELECT quantidade FROM produto WHERE id_produto = NEW.id_produto);
	DECLARE var_preco_compra decimal(7,2) := (SELECT preco_compra FROM produto WHERE id_produto = NEW.id_produto);

	BEGIN
	
		IF (quantidade_estoque + (OLD.quantidade - NEW.quantidade)) < 0 THEN
			RAISE EXCEPTION 'A quantidade a ser vendida (%) é maior que a quantidade em estoque (%)', NEW.quantidade, quantidade_estoque;
		ELSE
			UPDATE venda SET valor_total = valor_total - ((OLD.quantidade * OLD.valor_unitario) - (NEW.quantidade * NEW.valor_unitario)) WHERE id_venda = OLD.id_venda;
			UPDATE produto
			SET quantidade = quantidade + (OLD.quantidade - NEW.quantidade),
				lucro = lucro - (
					((OLD.valor_unitario - var_preco_compra) * OLD.quantidade) -
					((NEW.valor_unitario - var_preco_compra) * NEW.quantidade)
				)
			WHERE id_produto = NEW.id_produto;
		END IF;
		
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER AttVenda
AFTER UPDATE ON item_venda
FOR EACH ROW
EXECUTE PROCEDURE AttVenda();


CREATE OR REPLACE FUNCTION DelVenda()
RETURNS TRIGGER AS $$

	DECLARE var_preco_compra decimal(7,2) := (SELECT preco_compra FROM produto WHERE id_produto = OLD.id_produto);
	
	BEGIN
	
		UPDATE venda SET valor_total = valor_total - (OLD.quantidade * OLD.valor_unitario) WHERE id_venda = OLD.id_venda;
		UPDATE produto
		SET quantidade = quantidade + OLD.quantidade,
			lucro = lucro - ((OLD.valor_unitario - var_preco_compra) * OLD.quantidade)
		WHERE id_produto = OLD.id_produto;
	
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER DelVenda
AFTER DELETE ON item_venda
FOR EACH ROW
EXECUTE PROCEDURE DelVenda();


------------------------------------------------------------------------------
-- funções para o caixa

-- função para atualizar o valor de caixa ao realizar uma venda
CREATE OR REPLACE FUNCTION SetValorEmCaixa()
RETURNS TRIGGER AS $$
	BEGIN
	
		UPDATE caixa SET valor_em_caixa = valor_em_caixa + NEW.valor_total WHERE id_caixa = NEW.id_caixa;
	
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER SetValorEmCaixa
AFTER INSERT ON venda
FOR EACH ROW
EXECUTE PROCEDURE SetValorEmCaixa();


-- função para atualizar o valor de caixa ao realizar uma venda
CREATE OR REPLACE FUNCTION AttValorEmCaixa()
RETURNS TRIGGER AS $$
	BEGIN
	
		UPDATE caixa SET valor_em_caixa = valor_em_caixa - (OLD.valor_total - NEW.valor_total) WHERE id_caixa = NEW.id_caixa;
	
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER AttValorEmCaixa
AFTER UPDATE ON venda
FOR EACH ROW
EXECUTE PROCEDURE AttValorEmCaixa();


-- função para atualizar o valor de caixa ao realizar uma venda
CREATE OR REPLACE FUNCTION DelValorEmCaixa()
RETURNS TRIGGER AS $$
	BEGIN
	
		UPDATE caixa SET valor_em_caixa = valor_em_caixa - OLD.valor_total WHERE id_caixa = OLD.id_caixa;
	
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER DelValorEmCaixa
AFTER DELETE ON venda
FOR EACH ROW
EXECUTE PROCEDURE DelValorEmCaixa();

------------------------------------------------------------------------------
---- funções para devolução

-- função para atualizar o valor de credito de um cliente e a quantidade do produto de uma venda ao realizar uma devolução
CREATE OR REPLACE FUNCTION SetDevolucao()
RETURNS TRIGGER AS $$

	DECLARE quantidade_vendida int := (SELECT quantidade FROM item_venda WHERE id_item_venda = NEW.id_item_venda);
	
	BEGIN
	
		IF NEW.quantidade > quantidade_vendida THEN
			RAISE EXCEPTION 'A quantidade a ser devolvida (%) é maior que a quantidade vendida (%)', NEW.quantidade, quantidade_vendida;
		ELSE
			
			UPDATE cliente SET credito = credito + (NEW.quantidade * (SELECT valor_unitario FROM item_venda WHERE id_item_venda = NEW.id_item_venda))
			WHERE id_cliente = (
				SELECT C.id_cliente FROM cliente AS C, venda AS V, item_venda AS IV
				WHERE C.id_cliente = V.id_cliente
				AND V.id_venda = IV.id_venda
				AND IV.id_item_venda = NEW.id_item_venda
			);
			
			UPDATE item_venda SET quantidade = quantidade - NEW.quantidade WHERE id_item_venda = NEW.id_item_venda;
			
		END IF;

	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER SetDevolucao
AFTER INSERT ON devolucao
FOR EACH ROW
EXECUTE PROCEDURE SetDevolucao();


-- função para atualizar o valor de credito de um cliente e a quantidade do produto de uma venda ao realizar uma devolução
CREATE OR REPLACE FUNCTION AttDevolucao()
RETURNS TRIGGER AS $$

	DECLARE quantidade_vendida int := (SELECT quantidade FROM item_venda WHERE id_item_venda = NEW.id_item_venda);

	BEGIN
	
		IF (quantidade_vendida + (OLD.quantidade - NEW.quantidade)) < 0 THEN
			RAISE EXCEPTION 'A quantidade a ser devolvida (%) é maior que a quantidade vendida (%)', NEW.quantidade, quantidade_vendida;
		ELSE
		
			UPDATE cliente SET credito = credito + (
				(NEW.quantidade * (SELECT valor_unitario FROM item_venda WHERE id_item_venda = NEW.id_item_venda)) - 
				(OLD.quantidade * (SELECT valor_unitario FROM item_venda WHERE id_item_venda = NEW.id_item_venda))
			)
			WHERE id_cliente = (
				SELECT C.id_cliente FROM cliente AS C, venda AS V, item_venda AS IV
				WHERE C.id_cliente = V.id_cliente
				AND V.id_venda = IV.id_venda
				AND IV.id_item_venda = NEW.id_item_venda
			);
			
			UPDATE item_venda SET quantidade = quantidade + (OLD.quantidade - NEW.quantidade) WHERE id_item_venda = NEW.id_item_venda;
			
		END IF;
	
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER AttDevolucao
AFTER UPDATE ON devolucao
FOR EACH ROW
EXECUTE PROCEDURE AttDevolucao();


-- função para atualizar o valor de credito de um cliente e a quantidade do produto de uma venda ao realizar uma devolução
CREATE OR REPLACE FUNCTION DelDevolucao()
RETURNS TRIGGER AS $$
	BEGIN
	
		UPDATE cliente SET credito = credito - (OLD.quantidade * (SELECT valor_unitario FROM item_venda WHERE id_item_venda = OLD.id_item_venda))
		WHERE id_cliente = (
			SELECT C.id_cliente FROM cliente AS C, venda AS V, item_venda AS IV
			WHERE C.id_cliente = V.id_cliente
			AND V.id_venda = IV.id_venda
			AND IV.id_item_venda = OLD.id_item_venda
		);
				
		UPDATE item_venda SET quantidade = quantidade + OLD.quantidade WHERE id_item_venda = OLD.id_item_venda;
	
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER DelDevolucao
AFTER DELETE ON devolucao
FOR EACH ROW
EXECUTE PROCEDURE DelDevolucao();


------------------------------------------------------------------------------
-- função para definir o valor e o numero de parcelas
CREATE OR REPLACE FUNCTION SetParcelas()
RETURNS TRIGGER AS $$

	DECLARE parcela int := 1;
	DECLARE data_parcela int := 30;
	
	BEGIN
	
		WHILE parcela <= NEW.numero_de_parcelas LOOP
		
			INSERT INTO parcelas (id_pagamento_venda, numero_da_parcela, valor_parcela, data_vencimento, status)
			VALUES (NEW.id_pagamento_venda, parcela, (NEW.valor_a_pagar / NEW.numero_de_parcelas), (CURRENT_DATE + data_parcela), 'NP');
			
			data_parcela := data_parcela + 30;
			parcela := parcela + 1;
			
		END LOOP;

	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER SetParcelas
AFTER INSERT ON pagamento_venda
FOR EACH ROW
EXECUTE PROCEDURE SetParcelas();


-- função para definir o valor e o numero de parcelas
CREATE OR REPLACE FUNCTION AttParcelas()
RETURNS TRIGGER AS $$

	DECLARE parcela int := 1;
	DECLARE data_parcela int := 30;
	
	BEGIN
	
		DELETE FROM parcelas WHERE id_pagamento_venda = OLD.id_pagamento_venda;
	
		WHILE parcela <= NEW.numero_de_parcelas LOOP
		
			INSERT INTO parcelas (id_pagamento_venda, numero_da_parcela, valor_parcela, data_vencimento, status)
			VALUES (NEW.id_pagamento_venda, parcela, (NEW.valor_a_pagar / NEW.numero_de_parcelas), (CURRENT_DATE + data_parcela), 'NP');
			
			data_parcela := data_parcela + 30;
			parcela := parcela + 1;
			
		END LOOP;

	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER AttParcelas
AFTER UPDATE ON pagamento_venda
FOR EACH ROW
EXECUTE PROCEDURE AttParcelas();

-- função para deletar as parcelas
-- ver sobre possivel erro nessa função
CREATE OR REPLACE FUNCTION DelParcelas()
RETURNS TRIGGER AS $$
	
	BEGIN
	
		DELETE FROM parcelas WHERE id_pagamento_venda = OLD.id_pagamento_venda;

	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER DelParcelas
AFTER DELETE ON pagamento_venda
FOR EACH ROW
EXECUTE PROCEDURE DelParcelas();

------------------------------------------------------------------------------
-- função para definir o valor devido pelo cliente
CREATE OR REPLACE FUNCTION SetDebito()
RETURNS TRIGGER AS $$

	DECLARE var_debito decimal(7,2);
	
	BEGIN
		
		-- verificação se o tipo da trigger
		-- é do tipo DELETE
		IF (TG_OP = 'DELETE') THEN
			var_debito := (
				SELECT sum(valor_parcela) FROM parcelas
				WHERE status = 'NP'
				AND id_pagamento_venda = OLD.id_pagamento_venda
			);
			
			UPDATE cliente SET debito = var_debito
			WHERE id_cliente = (
				SELECT id_cliente FROM venda AS v, pagamento_venda AS pv
				WHERE v.id_venda = pv.id_venda
				AND pv.id_pagamento_venda = OLD.id_pagamento_venda
			);
		ELSE
			var_debito := (
				SELECT sum(valor_parcela) FROM parcelas
				WHERE status = 'NP'
				AND id_pagamento_venda = NEW.id_pagamento_venda
			);
			
			UPDATE cliente SET debito = var_debito
			WHERE id_cliente = (
				SELECT id_cliente FROM venda AS v, pagamento_venda AS pv
				WHERE v.id_venda = pv.id_venda
				AND pv.id_pagamento_venda = NEW.id_pagamento_venda
			);
		END IF;
		
	RETURN NULL;
	END $$
LANGUAGE plpgsql;

CREATE TRIGGER SetDebito
AFTER INSERT OR UPDATE OR DELETE ON parcelas
FOR EACH ROW
EXECUTE PROCEDURE SetDebito();

------------------------------------------------------------------------------
-------- FUNÇOES PARA CONSULTA
------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION vendaDoDia(date)
RETURNS TABLE (valor_total numeric(7,2), data_venda date) AS $$
	BEGIN
		RETURN QUERY SELECT sum(v.valor_total), v.data_venda FROM venda AS v
		WHERE v.data_venda = $1
		GROUP BY v.data_venda;
	END $$
LANGUAGE plpgsql;

--SELECT * FROM venda;
--SELECT * from vendaDoDia('2021-03-25');

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION produtoAbaixoEstoque(int)
RETURNS TABLE (nome_produto varchar, quantidade int) AS $$
	BEGIN
		RETURN QUERY SELECT pr.nome_produto, pr.quantidade FROM produto AS pr
		WHERE pr.quantidade <= $1;
	END $$
LANGUAGE plpgsql;

--SELECT * FROM produto;
--SELECT * FROM produtoAbaixoEstoque(10);
-- 10 é o numero para pesquisa (produtos abaixo de 10)

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION clientesQueDevem()
RETURNS TABLE (nome_cliente varchar(100), debito numeric(7,2)) AS $$
	BEGIN
		RETURN QUERY SELECT cl.nome_cliente, cl.debito FROM cliente AS cl
		WHERE cl.debito > 0;
	END $$
LANGUAGE  plpgsql;

--SELECT * FROM cliente;
--SELECT * FROM clientesQueDevem();

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION produtosMaisVendidosMes(char, int)
RETURNS TABLE (nome_produto varchar(30), quantidade int, data_venda date) AS $$
	BEGIN
		RETURN QUERY SELECT pr.nome_produto, iv.quantidade, v.data_venda 
		FROM venda AS v, item_venda AS iv, produto AS pr
		WHERE v.id_venda = iv.id_venda 
		AND iv.id_produto = pr.id_produto
		AND to_char(v.data_venda, 'MM') = $1
		AND iv.quantidade > $2
		ORDER BY iv.quantidade DESC;
	END $$
LANGUAGE  plpgsql;

--SELECT * FROM venda;
--SELECT * FROM produtosMaisVendidosMes(mês, quantidade de item_vendidos);
--SELECT * FROM produtosMaisVendidosMes('03', 5);

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION mostrarTotalVenda(char)
RETURNS TABLE (valor_total numeric(7,2), data_venda Date) AS $$
	BEGIN
		RETURN QUERY SELECT sum(v.valor_total), v.data_venda FROM venda AS v
		WHERE to_char(v.data_venda, 'MM') = $1
		GROUP BY v.data_venda;
	END $$
LANGUAGE  plpgsql;

--SELECT * FROM venda;
--SELECT * FROM mostrarTotalVenda('03'); -- '03' é o mês

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION atualizaPrecoProdutos(int, numeric(7,2))
RETURNS TABLE (nome_categoria varchar(20), nome_produto varchar(30), preco_venda numeric(7,2)) AS $$
	BEGIN
    RETURN QUERY SELECT cat.nome_categoria, pr.nome_produto, ((pr.preco_venda)+(pr.preco_venda*($2)))
    FROM produto AS pr, categoria AS cat
    WHERE pr.id_categoria = cat.id_categoria
    AND pr.id_categoria = $1
		GROUP BY cat.nome_categoria,
		pr.preco_venda,
		pr.nome_produto;
	END $$
LANGUAGE  plpgsql;

--DROP FUNCTION atualizaPrecoProdutos(int,numeric(7,2));
--SELECT * FROM atualizaPrecoProdutos(id_categoria, decimal para aumentar em porcentagem);
--SELECT * FROM atualizaPrecoProdutos(1,0.5);

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION prodMaisVendPorCategoria(int, Date, Date)
RETURNS TABLE (nome_categoria varchar, nome_produto varchar, data_inicio Date, data_final Date) AS $$
	BEGIN
    RETURN QUERY SELECT cat.nome_categoria,pr.nome_produto,ven.data_venda, com.data_compra 
    FROM venda AS ven, compra AS com, item_venda AS iv, item_compra AS ic, produto AS pr, categoria AS cat
    WHERE cat.id_categoria = pr.id_categoria
    AND com.id_compra = ic.id_compra
    AND ven.id_venda = iv.id_venda
    AND cat.id_categoria = $1
    AND ven.data_venda = $2
    AND com.data_compra = $3
    GROUP BY com.data_compra,
    ven.data_venda,
    cat.id_categoria,
    pr.nome_produto;
	END $$
LANGUAGE  plpgsql;

--DROP FUNCTION prodMaisVendPorCategoria(int,Date,Date)
--SELECT * FROM prodMaisVendPorCategoria(id_categoria, ven.data_venda, com.data_compra)
--SELECT * FROM prodMaisVendPorCategoria(2,'2021-03-18','2021-03-18')

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION prodMaisLucro(char, numeric(7,2))
RETURNS TABLE (nome_produto varchar, lucro numeric(7,2), data_venda Date) AS $$
	BEGIN
    RETURN QUERY SELECT pr.nome_produto, pr.lucro, ven.data_venda
    FROM produto AS pr,item_venda AS iv, venda AS ven
    WHERE pr.id_produto = iv.id_produto
		AND iv.id_venda = ven.id_venda
    AND to_char(ven.data_venda, 'MM') = $1
		AND pr.lucro > $2
		GROUP BY pr.nome_produto, pr.lucro, ven.data_venda;
	END $$
LANGUAGE  plpgsql;

--DROP FUNCTION prodMaisLucro(char, numeric(7,2));
--SELECT * FROM prodMaisLucro('03',9)

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION clienteParcelaVencendo(Date)
RETURNS TABLE (nome_cliente varchar, data_vencimento Date, numero_da_parcela int) AS $$
	BEGIN
		RETURN QUERY SELECT cli.nome_cliente, par.data_vencimento,par.numero_da_parcela
    FROM cliente AS cli,parcelas AS par, venda AS ven, pagamento_venda AS pv
    WHERE cli.id_cliente = ven.id_cliente
		AND ven.id_venda = pv.id_venda
    AND pv.id_pagamento_venda = par.id_pagamento_venda 
		AND par.data_vencimento = $1;
	END $$
LANGUAGE  plpgsql;

--SELECT * FROM parcelas;
--DROP FUNCTION clienteParcelaVencendo(Date);
--SELECT * FROM clienteParcelaVencendo('2021-05-17');


------------------------------------------------------------------------------
---- INSERTS NAS TABELAS
------------------------------------------------------------------------------

INSERT INTO cliente VALUES
(1, 'João da Silva', '123.456.789-09', 0),
(2, 'Ana Maria', '252.252.252-25', 0),
(3, 'Zeca Camargo', '111.111.111-11', 0),
(4, 'Marcelo David', '453.454.899-69', 0),
(5, 'Castelo Branco', '223.458.986-65', 0),
(6, 'Azir Kost', '123.125.789-63', 0),
(7, 'Jair Lula', '111.222.333-44', 0),
(8, 'Bolsonaro Boulos', '658.965.8956-362', 0),
(9, 'Iolanda Marcela', '156.789.098-78', 0),
(10, 'Dandara Alves', '234.456.679-90', 0),
(11, 'Fernanda Nobrega', '345.678.908-45', 0),
(12, 'Vitória da Silva', '679.143.254-14', 0);

------------------------------------------------------------------------------

INSERT INTO telefone VALUES
(1, 1, '999999999', 38, true),
(2, 1, '989234525', 43, true),
(3, 2, '3814325', 35, true),
(4, 3, '381423515', 32, true),
(5, 4, '381234515', 31, true),
(6, 5, '38133415', 37, false),
(7, 9, '381232415', 39, true),
(8, 6, '3812124315', 37, false),
(9, 6, '381423415', 34, false),
(10, 9, '381223415', 32, true),
(11, 11, '34243235', 21, false),
(12, 12, '3812423423415', 34, false),
(13, 10, '381464415', 38, false),
(14, 9, '38123465315', 38, false),
(15, 8, '3812423415', 38, false),
(16, 7, '3812415', 09, true),
(17, 6, '38121515', 09, true),
(18, 5, '381223415', 65, true),
(19, 4, '38124235', 76, false),
(20, 9, '381234315', 90, false);

------------------------------------------------------------------------------

INSERT INTO endereco VALUES
(1, 1, 'Rua da Sorte', 'Brasilia', 'Janaúba', 'MG','56'),
(2, 2, 'Rua do Azar', 'Cigano', 'Janaúba', 'MG','59'),
(3, 2, 'Rua da Felicidade', 'Santana', 'Espinosa', 'MG','89'),
(4, 6, 'Rua Carlos da Silva', 'Brasilia', 'Janaúba', 'MG','695'),
(5, 2, 'Rua Urandi', 'Cigano', 'Janaúba', 'MG','598'),
(6, 4, 'Rua Bahia', 'Centro', 'Espinosa', 'MG','985'),
(7, 5, 'Rua China', 'Brindes', 'Janaúba', 'MG','689'),
(8, 7, 'Rua Albânia', 'Paraiso', 'Janaúba', 'MG','695'),
(9, 8, 'Rua Golias', 'Portugal', 'Espinosa', 'MG','9863'),
(10, 9, 'Rua França', 'Inglaterra', 'Janaúba', 'MG','3256'),
(11, 10, 'Rua Russia', 'Guilama', 'Janaúba', 'MG','6978'),
(12, 11, 'Rua China', 'Santana', 'Espinosa', 'MG','2356'),
(13, 12, 'Rua Tiara', 'Joice', 'Janaúba', 'MG','5894'),
(14, 11, 'Rua Das Graças', 'Costa', 'Janaúba', 'MG','2356'),
(15, 9, 'Rua Aparecida', 'Santana', 'Espinosa', 'MG','2369'),
(16, 8, 'Rua Roma', 'Brasilia', 'Janaúba', 'MG','5893'),
(17, 6, 'Rua Hiamato', 'Cigano', 'Janaúba', 'MG','2365'),
(18, 7, 'Rua Jorje', 'Santana', 'Espinosa', 'MG','23698');

------------------------------------------------------------------------------

INSERT INTO funcionario VALUES
(1, 'George da Silva', '03855555555', '555.222.333-15', 'Rua 8787 - Nº 15 - Cidade A', 'Gerente', 1500),
(2, 'Cleiton de Jesus', '07715151553', '155.155.155-23', 'Rua 878 - Nº 36 - Cidade A', 'Caixa', 1000),
(3, 'Matheus Silva', '07165451584', '121.121.121-00', 'Rua 87 - Nº 1 - Cidade XYZ', 'Caixa', 1000),
(4, 'Jorge Mateus', '465644464', '121.186.195-55', 'Rua 66 - Nº 98 - Cidade de Deus', 'Atendente', 1000),
(5, 'Woquiton da Silva', '0343255555', '543.222.333-45', 'Rua 95 - Nº 15 - Cidade FAntasma', 'Entregador', 1500),
(6, 'Antonio de Jesus', '077234253', '155.155.155-43', 'Rua 87 - Nº 36 - Cidade dos Anjos', 'Serviços Gerais', 1000),
(7, 'Max Silva', '07164234584', '154.561.521-40', 'Rua 87 - Nº 1 - Cidade XYZ', 'Caixa', 1000),
(8, 'Favio Mateus', '4642342344', '121.186.195-55', 'Rua 696 - Nº 1 - Cidade de Deus', 'Atendente', 1000);

------------------------------------------------------------------------------

INSERT INTO caixa VALUES
(1, 2, 0),
(2, 3, 0),
(3, null, 0);

------------------------------------------------------------------------------

INSERT INTO categoria VALUES
(1, 'Brinquedo'),
(2, 'Utensilios'),
(3, 'Ferramentas'),
(4, 'Material Escolar'),
(5, 'Porcelana'),
(6, 'Garrafas'),
(7, 'Presentes'),
(8, 'Eletronicos');

------------------------------------------------------------------------------

INSERT INTO produto VALUES
(1, 1, 'Boneca Barbie'),
(2, 2, 'Garfo'),
(3, 3, 'Furadeira Bosh'),
(4, 4, 'Lapis da China'),
(5, 4, 'Caneta da China'),
(6, 4, 'Mochila da China'),
(7, 4, 'Giz de Cera da China'),
(8, 4, 'Lapis de cor da China'),
(9, 4, 'Lapis da Faber'),
(10, 4, 'Caneta da Faber'),
(11, 4, 'Mochila da Faber'),
(12, 4, 'Giz de cera da Faber'),
(13, 4, 'Lapis de cor da Faber'),
(14, 4, 'Lancheira da Faber'),
(15, 5, 'Jarro'),
(16, 5, 'Panela'),
(17, 5, 'Vaso'),
(18, 5, 'Prato'),
(19, 1, 'Peão'),
(20, 1, 'Bola de Basquete'),
(21, 1, 'Bola de Futebol'),
(22, 1, 'Carrinho'),
(23, 1, 'Caminhão'),
(24, 1, 'Cubo Mágico'),
(25, 2, 'Faca'),
(26, 2, 'Colher de sopa'),
(27, 2, 'Colher de Madeira'),
(28, 2, 'Faca de Serra'),
(29, 2, 'Colher de sobremesa'),
(30, 3, 'Chave de Fenda'),
(31, 3, 'Chave de Rosca'),
(32, 3, 'Chave Inglesa'),
(33, 3, 'Martelo'),
(34, 3, 'Prego'),
(35, 3, 'Alicate'),
(36, 3, 'Chave de Fenda'),
(37, 3, 'Trena'),
(38, 3, 'Chave de Rosca'),
(39, 6, 'Garrafa de 500ml'),
(40, 6, 'Garrafa de 750ml'),
(41, 6, 'Garrafa de 1l'),
(42, 6, 'Garrafa de 1,5l'),
(43, 6, 'Garrafa de 2l'),
(44, 6, 'Garrafa de café'),
(45, 6, 'Garrafa Termica 500ml'),
(46, 7, 'Garrafa Termica 500ml'),
(47, 8, 'Relogio'),
(48, 8, 'Mouse'),
(49, 8, 'Teclado'),
(50, 8, 'Caixa de Som'),
(51, 8, 'Fone de Ouvido'),
(52, 8, 'Microfone');

------------------------------------------------------------------------------

INSERT INTO fornecedor VALUES
(1, 'Brinquedos LTDA', '22222222', 'Janaúba', 'MG'),
(2, 'Ferramentas LTDA', '5555555', 'Montes Claros', 'MG'),
(3, 'ForHome LTDA', '66666666', 'Igaporã', 'BA'),
(4, 'XingLing LTDA', '12345678', 'Caculé', 'BA'),
(5, 'Ferramentas LTDA', '87654321', 'Caculé', 'BA'),
(6, 'Faber LTDA', '12121212', 'Igaporã', 'BA'),
(7, 'ForHouse LTDA', '13131313', 'Guanambi', 'BA'),
(8, 'De Casa LTDA', '14141414', 'Guanambi', 'BA'),
(9, 'Porcelanato LTDA', '1890980', 'Guanambi', 'BA'),
(10, 'ForYOU LTDA', '44556677', 'Guanambi', 'BA');

------------------------------------------------------------------------------

INSERT INTO forma_pagamento VALUES
(1, 'Cartão'),
(2, 'à vista'),
(3, 'à prazo'),
(4, 'Carnê');

------------------------------------------------------------------------------

INSERT INTO usuario VALUES
(1, 'cleiton', '123', '@', 'Cleiton do Carmo'),
(2, 'neto', '123', '@', 'Clemente Sepulveda'),
(3, 'fernando', '123', '@', 'Fernando Fernandes'),
(4, 'jaco', '123', '@', 'Jacó rocha'),
(5, 'lucas', '123', '@', 'Lucas Afonso');

------------------------------------------------------------------------------

INSERT INTO compra VALUES
(1, 1, 1, 0, CURRENT_DATE, 1),
(2, 1, 2, 0, CURRENT_DATE, 1),
(3, 2, 1, 0, CURRENT_DATE, 1);

------------------------------------------------------------------------------

INSERT INTO item_compra VALUES
(1, 1, 1, 0.1, 0.10, 0.18, 10, 15),
(2, 2, 2, 0.1, 0.15, 0.18, 15, 10),
(3, 3, 3, 0.1, 0.06, 0.18, 25, 80),
(4, 4, 3, 0.1, 0.60, 0.19, 20, 100),
(5, 4, 3, 0.1, 0.30, 0.19, 20, 100),
(6, 50, 3, 0.1, 0.40, 0.19, 10, 100),
(7, 45, 3, 0.1, 0.50, 0.19, 15, 100),
(8, 10, 2, 0.1, 0.20, 0.19, 30, 100),
(9, 2, 3, 0.1, 0.13, 0.18, 60, 100),
(10, 3, 2, 0.1, 0.17, 0.17, 48, 100),
(11, 6, 1, 0.1, 0.41, 0.16, 82, 100),
(12, 7, 3, 0.1, 0.25, 0.17, 61, 100),
(13, 48, 3, 0.1, 0.36, 0.18, 19, 100),
(14, 50, 2, 0.1, 0.36, 0.18, 300, 100),
(15, 18, 1, 0.1, 0.50, 0.35, 20, 100),
(16, 20, 1, 0.1, 0.50, 0.16, 40, 100),
(17, 10, 3, 0.1, 0.50, 0.14, 18, 100),
(18, 14, 2, 0.1, 0.30, 0.15, 36, 100),
(19, 22, 3, 0.1, 0.35, 0.15, 104, 100),
(20, 34, 3, 0.1, 0.40, 0.20, 98, 100),
(21, 8, 2, 0.2, 0.20, 0.18, 50, 80);

------------------------------------------------------------------------------

INSERT INTO pagamento_compra VALUES
(1, 1, 2, 1, '--', 'PG'),
(2, 2, 1, 3, '30 dias', 'NP'),
(3, 3, 3, 2, '90 dias', 'NP');

------------------------------------------------------------------------------

INSERT INTO venda VALUES
(1, 1, 1, 1, 0, CURRENT_DATE),
(2, 2, 3, 1, 0, CURRENT_DATE),
(3, 1, 2, 1, 0, CURRENT_DATE);

------------------------------------------------------------------------------

INSERT INTO item_venda VALUES 
(1, 1, 1, 17.80, 7),
(2, 2, 2, 108.60, 1),
(3, 3, 2, 88.32, 2),
(4, 1, 3, 17.80, 1),
(5, 50, 3, 612, 1),
(6, 45, 1, 32.85, 5),
(7, 10, 1, 38.52, 10),
(8, 4, 2, 39.80, 1),
(9, 3, 2, 88.32, 3),
(10, 6, 3, 169.74, 20),
(11, 7, 2, 117.12, 1),
(12, 48, 1, 38.76, 4),
(13, 50, 3, 612, 8),
(14, 18, 3, 47, 15),
(15, 20, 2, 86.40, 20),
(16, 8, 1, 99, 2),
(17, 10, 2, 38.52, 6),
(18, 14, 1, 70.20, 13),
(19, 22, 3, 208, 2),
(20, 34, 3, 205.80, 5);

------------------------------------------------------------------------------

INSERT INTO pagamento_venda VALUES
(1, 1, 2, 1, 1939.69),
(2, 2, 1, 3, 2666.24),
(3, 3, 3, 2, 11070.60);

------------------------------------------------------------------------------

INSERT INTO devolucao VALUES
(1, 1, 1, 'Motivo qualquer', 1),
(2, 2, 2, 'Motivo qualquer', 1),
(3, 3, 3, 'Motivo qualquer', 1);

------------------------------------------------------------------------------








