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

CLASS Column
	
	Data xDefault
	DATA xValor
	DATA cTipo		AS STRING
	DATA nTamanho	AS INTEGER
	DATA cNome		AS STRING
	DATA cCampo		AS STRING

	METHOD New() CONSTRUCTOR
	
	METHOD setValor()
	METHOD setTipo()
	METHOD setTamanho()
	METHOD setNome()
	METHOD setCampo()
	METHOD setDefault()

	METHOD getValor()
	METHOD getTipo()
	METHOD getTamanho()
	METHOD getNome()
	METHOD getCampo()
	METHOD getDefault()
	
	
ENDCLASS

METHOD New() CLASS Column

	self:xValor   	:= nil
	self:cTipo		:= nil
	self:nTamanho	:= nil
	self:cNome		:= nil
	self:cCampo		:= nil
	self:xDefault	:= nil

Return(self)

METHOD setDefault(xVal) CLASS Column
	self:xDefault := xVal
Return

METHOD setValor(xVal) CLASS Column
	self:xValor := xVal
Return

METHOD setTipo(xVal) CLASS Column
	self:cTipo := xVal
Return

METHOD setTamanho(xVal) CLASS Column
	self:nTamanho := xVal
Return

METHOD setNome(xVal) CLASS Column
	self:cNome := xVal
Return

METHOD setCampo(xVal) CLASS Column
	self:cCampo := xVal
Return

METHOD getValor() CLASS Column
return self:xValor

METHOD getTipo() CLASS Column
return self:cTipo

METHOD getTamanho() CLASS Column
return self:nTamanho

METHOD getNome() CLASS Column
return self:cNome

METHOD getCampo() CLASS Column
return self:cCampo

METHOD getDefault() CLASS Column
return self:xDefault