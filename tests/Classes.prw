#include 'totvs.ch'

CLASS Y01 FROM BaseModel
	METHOD New() CONSTRUCTOR
	METHOD getAlias()
ENDCLASS
METHOD New() CLASS Y01
Return
METHOD getAlias() CLASS Y01
Return("Y01")
//-----------------------------------------------------------------
CLASS Y01_DAO FROM BaseDao
	METHOD New() CONSTRUCTOR
	METHOD getAlias()
ENDCLASS
METHOD New() CLASS Y01_DAO
Return
METHOD getAlias() CLASS Y01_DAO
Return("Y01")

//-----------------------------------------------------------------
//-----------------------------------------------------------------

CLASS Y02 FROM BaseModel
	METHOD New() CONSTRUCTOR
	METHOD getAlias()
ENDCLASS
METHOD New() CLASS Y02
Return
METHOD getAlias() CLASS Y02
Return("Y02")
//-----------------------------------------------------------------
CLASS Y02_DAO FROM BaseDao
	METHOD New() CONSTRUCTOR
	METHOD getAlias()
ENDCLASS
METHOD New() CLASS Y02_DAO
Return
METHOD getAlias() CLASS Y02_DAO
Return("Y02")