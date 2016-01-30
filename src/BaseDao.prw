/*----------------------------------------------------------------------*\
 * advpl-orm - A Simple ORM (Object Relational Mapping) for AdvPL
 * Copyright (C) 2015 Thiago Oliveira
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

CLASS BaseDao

	METHOD New() CONSTRUCTOR
	
	METHOD query(aParams)
	METHOD excluir()
	METHOD salvar()
	METHOD getByRecno()
	METHOD getAlias()
	METHOD populate()
	METHOD executaQuery()

ENDCLASS

/*/
	METHOD:		New
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	CONSTRUCTOR
	Sintaxe:	Model():New() -> Self
/*/
METHOD New() CLASS BaseDao
Return(Self)

/*/
	METHOD:		getAlias
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Retorna o alias associado a este DAO
	Sintaxe:	Model():getAlias() -> cAlias
/*/
METHOD getAlias() CLASS BaseDao
Return("")

/*/
	METHOD:		getByRecno
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Busca um registro pelo recno
	Sintaxe:	Model():getByRecno(_nRecno) -> oObjeto
/*/
METHOD getByRecno(_nRecno) CLASS BaseDao

	local _cAlias	:= self:getAlias()
	local _cClasse	:= _cAlias + "():NEW()"
	local _oModel	:= &_cClasse
	local _aMemos	:= _oModel:getMemoFields()
	
	cQuery := " SELECT * "
	
	for nX := 1 to len(_aMemos)
		
		_cColName := _oModel:getColumn(_aMemos[nX]):getCampo()
		cQuery += ", convert(varchar(2500), convert(varbinary(2500), " + _cColName + ")) AS " + _cColName
	
	next nX
	
	cQuery += " FROM   " + RetSQLName(_cAlias) + " "
	cQuery += " WHERE  R_E_C_N_O_ = " + Alltrim(STR(_nRecno))
	
	self:executaQuery(cQuery, "BASEDAO")
	
	_xReturn := ::populate("ONE")
	
Return(_xReturn)

/*/
	METHOD:		salvar
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Salva o objeto no banco de dados
	Sintaxe:	Model():salvar(oObjeto) -> nRecno
/*/
METHOD salvar(oObjeto) CLASS BaseDao
	
	local _cAlias	:= self:getAlias()
	local _nRecno	:= oObjeto:get("R_E_C_N_O_")
	
	_aFields	:= oObjeto:getFields()
	
	if (_nRecno == 0)
	
		RecLock(_cAlias, .T.)
		for nX := 1 to len(_aFields)
			
			_cCol	:= oObjeto:getColumn(_aFields[nX]):getCampo()
			
			if (! _cCol $ "R_E_C_N_O_|R_E_C_D_E_L_|D_E_L_E_T_") 
				_cExec	:= _cAlias + "->" + _cCol
				&_cExec	:= oObjeto:get(_cCol)
			endif
			
		next nX
		MsUnLock(_cAlias)
		
		_cGetRecno	:= _cAlias + "->(recno())"
		return &_cGetRecno
	
	else
	
		_cQuery := " UPDATE " + RetSQLName(_cAlias) + " SET "
		_nLen	:= len(_aFields)
		
		for nX := 1 to _nLen
			
			_oColumn	:= oObjeto:getColumn(_aFields[nX])
			
			if (! _oColumn:getCampo() $ "R_E_C_N_O_|R_E_C_D_E_L_|D_E_L_E_T_")
				_cQuery += " " + _oColumn:getCampo() + " = " + typeCast(_oColumn) + iif(nX == (_nLen - 1), " ", ", ")
			endif
		
		next nX
		
		_cQuery += " WHERE R_E_C_N_O_ = " + alltrim(str(oObjeto:get("R_E_C_N_O_")))
		
		if (self:executaQuery(_cQuery, "") == 0)
			return oObjeto:get("R_E_C_N_O_")
  		endif
	
	endif

Return(0)

/*/
	METHOD:		excluir
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Exclui um registro da tabela
	Sintaxe:	Model():excluir(xRecno) -> Boolean
/*/
METHOD excluir(xRecno) CLASS BaseDao

	local _cQuery	:= ""
	local _cAlias	:= self:getAlias()

	_cQuery := " UPDATE " + RetSqlName(_cAlias) + " "
	_cQuery += " SET D_E_L_E_T_ = '*' "
	_cQuery += " WHERE R_E_C_N_O_ = " + iif(valType(xRecno) == "N", alltrim(str(xRecno)), alltrim(xRecno))

	_nRows := self:executaQuery(_cQuery, "", .T.)

Return(_nRows > 0)

/*/
	METHOD:		query
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Constroi e executa uma query utilizando os Parametros
	Sintaxe:	Model():query() -> xRet
/*/
METHOD query(aParams, cType) CLASS BaseDao
	
	local aModels	:= {}
	local _cAlias	:= self:getAlias()
	local _cClasse 	:= _cAlias + "():NEW()"
	local _cQuery	:= ""
	
	_cQuery := " SELECT * FROM " + RetSqlName(_cAlias) + " WHERE D_E_L_E_T_ = '' "
	
	for nX := 1 to len(aParams)
	
		_cQuery += " AND " + aParams[nX][1] + " = " + typeCast(aParams[nX][2]) + " "
	
	next nX
	
	self:executaQuery(_cQuery, "BASEDAO")
	
	_xReturn := self:populate(cType)
	
Return(_xReturn)

/*/
	METHOD:		populate
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Popula os models de acordo com o tipo
	Sintaxe:	Model():populate() -> xRet
/*/
METHOD populate(cType) CLASS BaseDao

	local cClass	:= self:getAlias() + "():NEW()"
	local aModels	:= {}

	_oModelProp	:= &cClass		
	_aFields	:= _oModelProp:getFields()
	_aProp		:= _oModelProp:getProperties()
		
	while (!BASEDAO->(eof()))
		
		oModel	:= &cClass	
	
		for nY := 1 to len(_aFields)
		
			_cNomeCampo	:= _aProp[# _aFields[nY] ]:getCampo()
			
			_xValor := "BASEDAO->(" + _cNomeCampo + ")"
			_xVal	:= &_xValor			
			
			oModel:set(_cNomeCampo, _xVal)
			
		next nY
		
		if (cType == "ONE")
			return oModel
		endif
		
		aadd(aModels, oModel)
		
		BASEDAO->(dbSkip())
			
	end
	
	_xReturn := iif(cType == "ONE", nil, aModels)
		
Return(_xReturn)

/*/
	METHOD:		executaQuery
	Autor:		Thiago Oliveira
	Data:		03/12/2015
	Descricao:	Executa query
	Sintaxe:	Model():executaQuery() -> xRet
/*/
Method executaQuery(_cQuery, _cAlias, _lReturn) Class BaseDao

	local _nRet := 0

	//Salvando o ambiente de trabalho ativo
	_aArea := GetArea()

	if (Upper(subStr(ltrim(_cQuery), 1, 6)) == "SELECT")

		If !Empty(Select(_cAlias))
			dbSelectArea(_cAlias)
			dbCloseArea()
		Endif

		TCQuery _cQuery NEW ALIAS &_cAlias

		dbSelectArea(_cAlias)

		//Verificando se sera necessario retornar o numero de linhas
		If _lReturn
			Count To _nRet
		Endif

		(_cAlias)->(dbGoTop())

	Else
		_nRet := TCSQLEXEC(_cQuery)
	Endif

	RestArea(_aArea)

Return(_nRet)


Static Function typeCast(uVal)

	if (valtype(uVal) == "O")
		oObj := uVal
		uVal := oObj:getValor()
		if (uVal == nil)
			uVal := oObj:getDefault()
		endif
	endif
	
	cValType := valtype(uVal)

	Do Case

		Case (cValType == "C")
			return "'" + uVal + "'"
			
		Case (cValType == "D")
			return "'" + Dtos(uVal) + "'"
			
		Case (cValType == "N")
			return alltrim(str(uVal))
			
		Default
			return uVal
			
	EndCase

Return