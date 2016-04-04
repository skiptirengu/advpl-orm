/*----------------------------------------------------------------------*\
 * advpl-orm - A Simple ORM (Object Relational Mapping) for AdvPL
 * Copyright (C) 2016 Thiago Oliveira <thiago.oliveira.gt14@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
\*----------------------------------------------------------------------*/

#include 'totvs.ch'
#include 'protheus.ch'
#include 'aarray.ch'

Class BaseModel

	DATA properties		AS SHash
	DATA isLoaded		AS Boolean
	DATA daoObject		AS Object
	DATA memoFields		

	METHOD New() CONSTRUCTOR
	
	METHOD get(cVar)
	METHOD set(cVar, xVal)
	METHOD getColumn(cVar)
	METHOD getProperties()
	METHOD getFields()
	METHOD getAlias()
	METHOD getMemoFields()
	METHOD getDao()
	METHOD isLoaded()
	METHOD populateProperties()
	METHOD getAttributes()
	
	METHOD query(aParams, cType)
	METHOD salvar()
	METHOD save()
	METHOD findOne(xRecno)
	METHOD excluir()
	METHOD delete()
	METHOD hasOne(_cAlias, aRelation)
	METHOD hasMany(_cAlias, aRelation)
	METHOD hasRelation(_cAlias, aRelation, cType)
	
ENDCLASS

/*
	METHOD:		New
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	CONSTRUCTOR
	Sintaxe:	BaseModel():New() -> Self
*/
METHOD New() Class BaseModel
Return(Self)

/*
	METHOD:		getAlias
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Retorna o alias associado a este model. Este método deve ser sobrescrito por 
				subclasses
	Sintaxe:	BaseModel():getAlias() -> cAlias
*/
METHOD getAlias() Class BaseModel
Return("")

/*
	METHOD:		getProperties
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Retorna as propriedades da classe
	Sintaxe:	BaseModel():getProperties() -> SHASH
*/
METHOD getProperties() Class BaseModel

	self:populateProperties()

Return(Self:properties)

/*
	METHOD:		getAttributes
	Autor:		Thiago Oliveira
	Data:		04/04/2016
	Descricao:	Retorna um array associativo com os atributos do model
	Sintaxe:	BaseModel():getAttributes() -> SHASH
*/
METHOD getAttributes() Class BaseModel

	local property	:= array(#)
	local fields	:= self:getFields()
	
	for nX := 1 to len(fields)
	
		property[# fields[nX] ] := self:get(fields[nX])
		
	next nX
	
Return(property)

/*
	METHOD:		getDao
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Retorna uma instancia da Data Layer associada a classe
	Sintaxe:	BaseModel():getDao() -> Self:daoObject
*/
METHOD getDao() Class BaseModel

	self:populateProperties()

	if (self:daoObject <> nil)
		return self:daoObject
	endif
	
	cFuncao := self:getAlias() + "_DAO():NEW()"
	
	self:daoObject := &cFuncao
	
	return self:daoObject

Return

/*
	METHOD:		getMemoFields
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Retorna os campos MEMO da classe
	Sintaxe:	BaseModel():getMemoFields() -> Array
*/
METHOD getMemoFields() Class BaseModel

	if (!empty(self:memoFields))
		return self:memoFields
	endif
	
	self:memoFields	:= {}
	_aFields 		:= self:getFields()
	
	for nX := 1 to len (_aFields)
	
		oColumn := self:getColumn(_aFields[nX])
		
		if (oColumn:getTipo() == "M")
			aadd(self:memoFields, oColumn:getCampo())
		endif
	
	next

Return(self:memoFields)
 
/*
	METHOD:		isLoaded
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Indica se as propriedades da classe ja foram populadas
	Sintaxe:	BaseModel():isLoaded() -> Self:isLoaded
*/
METHOD isLoaded() Class BaseModel

	return self:isLoaded == .t.

Return

/*
	METHOD:		getColumn
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Retorna o objeto column associado a propriedade
	Sintaxe:	BaseModel():getColumn(cVar) -> Column
*/
METHOD getColumn(cVar) Class BaseModel
	
	self:populateProperties()
	
	return self:properties[# upper(cVar) ]
	
Return

/*
	METHOD:		getFields
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Retorna um array com as propriedades declaradas
	Sintaxe:	BaseModel():getFields() -> Array
*/
METHOD getFields() Class BaseModel

	self:populateProperties()

Return(Self:properties:getKeys())

/*
	METHOD:		get
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Retorna o valor de uma propriedade da classe
	Sintaxe:	BaseModel():get(cVar) -> xVal
*/
METHOD get(cVar) Class BaseModel

	self:populateProperties()

	return self:properties[# upper(cVar) ]:getValor()

Return

/*
	METHOD:		set
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Atribui o valor a uma propriedade da classe
	Sintaxe:	BaseModel():set(cVar, xVal) -> nil
*/
METHOD set(cVar, xVal) Class BaseModel

	self:populateProperties()

	self:properties[# upper(cVar) ]:setValor(xVal)

Return

/*
	METHOD:		salvar
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Salva este model. Retorna o Recno do registro ou zero caso ocorra um erro
	Sintaxe:	BaseModel():salvar() -> nRecno
*/
METHOD salvar() Class BaseModel

	xRet := self:getDao():salvar(self)
	self:set("R_E_C_N_O_", xRet)

Return(xRet)

/*
	METHOD:		save
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Salva este model. Retorna o Recno do registro ou zero caso ocorra um erro
	Sintaxe:	BaseModel():save() -> nRecno
*/
METHOD save() Class BaseModel

	return self:salvar()

Return

/*
	METHOD:		query
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Faz uma nova busca com os parametros
	Sintaxe:	BaseModel():query(aParams, cType = "ONE|MANY") -> xRet
*/
METHOD query(aParams, cType) Class BaseModel

	xRet := self:getDao():query(aParams, cType)

Return(xRet)

/*
	METHOD:		findOne
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Busca um model pelo Recno
	Sintaxe:	BaseModel():findOne() -> Self
*/
METHOD findOne(xRecno) Class BaseModel

	xRet := self:getDao():getByRecno(xRecno)

Return(xRet)

/*
	METHOD:		delete
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Exclui o model do banco de dados
	Sintaxe:	BaseModel():delete() -> Boolean
*/
METHOD delete() Class BaseModel

	lRet := self:getDao():delete(self:get('R_E_C_N_O_'))

Return(lRet)

/*
	METHOD:		hasOne
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Estabelece uma relacao 1 - 1 entre duas classes
	Sintaxe:	BaseModel():hasOne(_cAlias, aRelation) -> Object
*/
Method hasOne(_cAlias, aRelation) Class BaseModel

	return self:hasRelation(_cAlias, aRelation, "ONE")

Return

/*
	METHOD:		hasMany
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Estabelece uma relacao 1 - n entre duas classes
	Sintaxe:	BaseModel():hasMany(_cAlias, aRelation) -> Array
*/
Method hasMany(_cAlias, aRelation) Class BaseModel

	return self:hasRelation(_cAlias, aRelation, "MANY")

Return

/*
	METHOD:		hasMany
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Estabelece uma relacao entre duas classes
	Sintaxe:	BaseModel():hasMany(_cAlias, aRelation, cType) -> xRet
*/
METHOD hasRelation(_cAlias, aRelation, cType) Class BaseModel

	local aQuery := {}
	local oRelation	
	local xRet

	default aRelation := {}
	
	// Monta a classe da relacao
	cClassRel	:= _cAlias + "():New()"
	
	// Instancia a classe 
	oRelation	:= &cClassRel
	
	for nX := 1 to len(aRelation)
		
		// Busca o nome do campo	
		oColumn := oRelation:getColumn(aRelation[nX][1])
		
		// Cria uma nova condicao para a query: (Nome do campo = Valor da propriedade desta classe)
		aadd(aQuery, {oColumn:getCampo(), self:get(aRelation[nX][2])})
	
	next nX
	
	// Filial sempre esta presente na relacao
	aadd(aRelation, {oRelation:getAlias() + "_FILIAL", xFilial(oRelation:getAlias())})
	
	// Instancia a Data layer da classe relacional
	oDao := oRelation:getDao()
	
	// Passa o array com as condicoes para o metodo construir a query
	_xResult := oDao:query(aQuery, cType)
	
	if (valtype(_xResult) <> "L")
	
		return _xResult
	
	// Caso a relacao nao for estabelecida, atribui os valores padrao a variavel de retorno
	else
		
		iif(cType == "ONE", xRet := nil, xRet := {})
		
	endif

Return(xRet)

/*
	METHOD:		populateProperties
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Carrega as propriedades da classe baseando-se no dicionario de dados (SX3)
	Sintaxe:	BaseModel():populateProperties() -> nil
*/
METHOD populateProperties() Class BaseModel

	if (self:isLoaded())
		return
	endif

	_cAlias		:= self:getAlias()
	_nTamAlias	:= tamAlias(_cAlias)
	
	self:properties	:= SHash():New()
	
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(_cAlias))
	
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == _cAlias
	
		If SX3->X3_CONTEXT == "V"
			SX3->(dbSkip())
			Loop
		Endif
	
		_cLetra		:= ""
		_cPadrao	:= nil
	
		If 	SX3->X3_TIPO == "C" .or. SX3->X3_TIPO == "M"
			_cLetra		:= "c"
			_cPadrao	:= Space(SX3->X3_TAMANHO)
		ElseIf 	SX3->X3_TIPO == "N"
			_cLetra		:= "n"
			_cPadrao 	:= 0
		ElseIf 	SX3->X3_TIPO == "D"
			_cLetra  	:= "d"
			_cPadrao 	:= StoD("")
		ElseIf 	SX3->X3_TIPO == "L"
			_cLetra   	:= "l"
			_cPadrao 	:= nil
		Endif
		
		oColumn := Column():New()
		oColumn:setNome(alltrim(upper(_cLetra + Substr(SX3->X3_CAMPO,_nTamAlias,10))))
		oColumn:setValor(_cPadrao)
		oColumn:setTamanho(SX3->X3_TAMANHO)
		oColumn:setCampo(alltrim(SX3->X3_CAMPO))
		oColumn:setTipo(alltrim(SX3->X3_TIPO))
		oColumn:setDefault(SX3->X3_RELACAO)
		
		self:properties[# oColumn:getCampo() ] := oColumn
		
		SX3->(dbSkip())
	
	End
	
	oColumn := Column():New()
	oColumn:setNome("R_E_C_N_O_")
	oColumn:setValor(0)
	oColumn:setTamanho(8)
	oColumn:setCampo("R_E_C_N_O_")
	oColumn:setTipo("N")
	oColumn:setDefault(0)
	
	self:properties[# oColumn:getCampo() ] := oColumn
	
	self:isLoaded := .T.

Return

Static Function tamAlias(_cAlias)

	_nTamAlias := 0

	If Substr(_cAlias,1,1) == "S"
		_nTamAlias := 4
	Else
		_nTamAlias := 5
	Endif

Return(_nTamAlias)
