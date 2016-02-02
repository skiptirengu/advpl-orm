#Include 'Protheus.ch'

User Function TestOrm()

	Private errCount := 0

	RpcClearEnv()
 	RpcSetType(3)
 	RPCSetEnv("01","01","","","","",{"Y02","Y01"})

	Y02Dao := Y02_DAO():NEW()
	Y01Dao := Y01_DAO():NEW()
	
	Y01Dao:executaQuery("UPDATE Y01010 SET D_E_L_E_T_ = '*'", "")
	Y02Dao:executaQuery("UPDATE Y02010 SET D_E_L_E_T_ = '*'", "")
	
	Y01 := Y01():NEW()
	Y01:SET("Y01_STRING",	"THIS IS A STRING")
	Y01:SET("Y01_NUMERO",	1)
	Y01:SET("Y01_MEMO"	,	"THIS IS A MEMO")
	Y01:SET("Y01_DATA"	,	STOD("19960525"))
	
	IF(Y01:SAVE() <= 0)
		FAIL(PROCLINE())
	ELSE
		rec	:= Y01:get("R_E_C_N_O_")
		Y01	:= nil
		Y01	:= Y01Dao:getByRecno(rec)
		assertType(Y01:get("Y01_DATA")	, "D")
		assertType(Y01:get("Y01_STRING"), "C")
		assertType(Y01:get("Y01_MEMO")	, "C")
		assertType(Y01:get("Y01_NUMERO"), "N")
	ENDIF
	
	IF (errCount == 0)
		MSGINFO("ALL TESTS PASSED!")
	ELSE
		MSGINFO(ALLTRIM(STR(errCount)) + " TESTS FAILED")
	ENDIF
	
Return

STATIC FUNCTION fail(nLine)

	errCount++
	MSGINFO("TEST FAIL LINE: " + ALLTRIM(STR(nLine)))

RETURN

STATIC FUNCTION assertType(XVAL, CTYPE)

	if (valType(xVal) <> cType)
		errCount++
		MSGINFO("FAILED ASSERTING TYPE " + valType(xVal) + " IS EQUALS " + CTYPE)
	endif

RETURN