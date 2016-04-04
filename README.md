ADVPL ORM
=========
Biblioteca ORM (Object Relational Mapping) desenvolvida inteiramente em ADVPL!

Instalação
----------
Para utilização da biblioteca, basta copiar os arquivos de `src/` e `include/` para pasta do seu projeto.

Utilização
----------
Para cada tabela existente no banco, basta criar as classes DAO e Model extendendo as classes base e sobrescrever o método `getAlias()` para retornar corretamente o alias da tabela. Ex:

```xBase
//SA2.prw
#include 'totvs.ch'

CLASS SA2 FROM BaseModel
	METHOD New() CONSTRUCTOR
	METHOD getAlias()
ENDCLASS

METHOD New() CLASS SA2
Return

METHOD getAlias() CLASS SA2
Return("SA2")
```

```xBase
//SA2_DAO.prw
#include 'totvs.ch'

CLASS SA2_DAO FROM BaseDao
	METHOD New() CONSTRUCTOR
	METHOD getAlias()
ENDCLASS

METHOD New() CLASS SA2_DAO
Return

METHOD getAlias() CLASS SA2_DAO
Return("SA2")
```

Exemplos de uso
---------------
Além de serem totalmente dinâmicas por se basearem no SX3, as classes são extremamente fáceis e intuitivas.

Instanciando um novo objeto
```xBase
// Instancia um novo model
oModel := SA2():new()
oModel:set("A2_LOJA", "1")
oModel:get("A2_LOJA") // 1
```

Trabalhando com o banco de dados
```xBase
oModel  := SA2():new()
oSA2    := oModel:findOne(10) // Busca o registro com o RECNO 10

// Manipulando o model
oSA2:set("A2_LOJA", "1")
oSA2:get("A2_LOJA") // 1
oSA2:save() // Atualiza os valores no banco de dados
oSA2:delete() // Marca o campo D_E_L_E_T_ com *
```

Trabalhando com queries mais complexas
```xBase
oModel  := SA2():new()
// Busca o primeiro registro com A2_FILIAL = 01 e A2_LOJA = 02
oModel:query({{"A2_FILIAL", "01"}, {"A2_LOJA", "02"}, "ONE") 
// Retorna uma array com todos os registros que possuem A2_FILIAL = 01 e A2_LOJA = 02
oModel:query({{"A2_FILIAL", "01"}, {"A2_LOJA", "02"}, "MANY") 
```
