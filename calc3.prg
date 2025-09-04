#DEFINE CPTDIR 'C:\SoftmicaCalc\PaperTape\'
#DEFINE CDXSTR 'grpc7&!,Guqx8na,bj1iZte,vA0@o9z,2sPkJ2s,mQCwRyB,34Od!XN,5WVEKD*,UHW6Bl#,T$IhSMT,LFfc%dM'
#DEFINE SAVEREGFILE 'C:\Windows\smc.smc'
SET TALK OFF 
_Screen.Visible = .F.
CLOSE Tables
PUBLIC lcontinue, cplotvar(10,2), oPlotx(10), nplot, oPlot3(10), ccfndx, lregdeleted, lgError
LOCAL nregvalid
nregvalid = .T.

_Screen.Icon = 'Gen.ico'
_Screen.WindowState = 0
_Screen.AutoCenter = .T.
_Screen.Caption = 'GigaCalc'
SET SAFETY OFF 
*SET STATUS Bar ON

SET DECIMALS TO 18
_TOOLTIPTIMEOUT = 0
nplot = 0

=MyInstance('softmicacalc')
SET CONSOLE OFF

*WAIT 'Beginning...' Window

CLOSE TABLES
ON ERROR Do SettingsError

	IF FILE('c:\windows\smcrx.dbf')
		COPY FILE c:\windows\smcrx.dbf TO smcreg2.dbf
	ENDIF 
	SELECT 0
	USE smcreg2
	ndaystorenew = dExpDate - DATE()

ON ERROR 
IF ! smcreg2.lregister OR ndaystorenew < 45
	DO FORM RegisterSoftmicaCalc WITH ndaystorenew TO nregvalid
ENDIF
_Screen.Visible = .F.
_Screen.WindowState = 1
 
IF ! nregvalid
	QUIT 
ENDIF 
SELECT smcreg2
USE
IF ! FILE('c:\windows\smcrx.dbf') 
	COPY FILE smcreg2.dbf TO c:\windows\smcrx.dbf
ENDIF
IF lregdeleted 
**WAIT 'Deleting...' Window
	DELETE FILE c:\windows\smcrx.dbf
ENDIF 
IF ! DIRECTORY(CPTDIR)
	MD CPTDIR
ENDIF 
SET SAFETY OFF
Do Form Calc5
Read Events
Rele Windows
CLOSE TABLES ALL
IF ! WEXIST('BrowDispWin')
	RELEASE WINDOW BrowDispWin
ENDIF 
SET safety OFF 
USE memsetlistbig
PACK
USE 
USE SavedChartLabels
PACK
USE 
RELEASE all
CLOSE TABLES


Set sysmenu to Defa
set cursor ON

*!*	IF VARTYPE(oEqProc) == 'O'
*!*		oEqProc.Release
*!*		RELEASE oEqProc
*!*	ENDIF
DELETE FILE TBL*.dbf
DELETE FILE TBL*.fpt



FUNCTION nDaysToRenew
PARAMETERS crc
LOCAL n1, n2, n3
	n1 = 100*nGetCodeNum(LEFT(crc,1))
	n3 = nGetCodeNum(RIGHT(crc,1))
	n2 = 10*nGetCodeNum(SUBSTR(crc,2,1))
RETURN(n1+n2+n3)

FUNCTION nGetCodeNum
PARAMETERS cx
LOCAL ny
	ny = AT(cx,CDXSTR)
	IF ny # 7
		ny = INT(ny/8)+1
		IF ny == 10
			ny = 0
		ENDIF 
	ENDIF 	
	SELECT smcreg
Retu(ny)

Function ChkRegNum
Local rcode, daystogo, xx, ndaystorenew
SELECT smcreg
daystogo = 30-(Date()-smcreg.dInstdate)
ndaystorenew = smcreg.dExpdate - DATE()
IF ndaystorenew < 0
	ndaystorenew = 0
ENDIF 
If UnRegUses < 1
	daystogo = -1
Else
	If daystogo < 0
		daystogo = 0
	Endif
ENDIF
IF EMPTY(serialnum)
	REPLACE serialnum WITH MakeSnum()
ENDIF 
If ! Empty(Registcode)
	If lrv
		IF ndaystorenew < 50
			_Screen.Visible = .T.
			Do form Register with ndaystorenew, .T. to xx
			Retu(xx)
		ELSE 
			Retu(.T.)
		ENDIF 
	ELSE
		_Screen.Visible = .T.
*** invalid registration code
		REPLACE Registcode WITH '' 
		Do form Register with daystogo, .F. to xx
		Retu(xx)
	ENDIF 
ELSE
	_Screen.Visible = .T.
	Do form Register with daystogo, .F. to xx
	Retu(xx)
ENDIF 
ENDFUNC 

PROCEDURE UpdateCalcSelectForm
	IF VARTYPE(oMemScriptSelect) == 'O'
		oMemScriptSelect.UpdateCell
	ENDIF 
ENDPROC 

PROCEDURE CheckMemIntegrity
LOCAL irec, ims, nms
	IF ! USED('Calc')
		SELECT 0
		USE Calc
	ELSE
		SELECT Calc 
	ENDIF 
	IF RECCOUNT() == 0
		FOR irec = 1 TO 8
			APPEND BLANK
			REPLACE label WITH i, memset WITH 1, labelc WITH 13421772
		ENDFOR 
	ENDIF 
	IF ! RECCOUNT()%8 == 0
		irec = 8 * INT(RECCOUNT()/8)
		DELETE FOR RECNO() > irec
		PACK
*!*			GO Top
*!*			nms = 1
*!*			FOR ims = 1 TO RECCOUNT()/8
*!*				FOR irec = 1 TO 8
*!*					REPLACE label WITH RECNO(),memset WITH nms
*!*				ENDFOR  
*!*				nms = nms + 1 
*!*			ENDFOR 
	ENDIF 
ENDPROC 

PROCEDURE NavigateToWebpage
PARAMETERS nurl
DECLARE INTEGER ShellExecute IN "shell32.dll" ;
  INTEGER hWnd, STRING cOperation, STRING cFile, ;
  STRING cParameters, STRING cDirectory, INTEGER nShowCmd
LOCAL curl, lcEdgePath
 lcEdgePath = '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"'
nShowCmd = 1  && SW_SHOWNORMAL, you can change it as needed
IF VARTYPE(nurl) == 'C'
	curl = nurl
ELSE 
	DO Case
		CASE nurl == 1
			curl = 'https://airnav.com/'
		CASE nurl == 2
			curl = 'https:/gigacalc.net/'
		CASE nurl == 4
			curl = 'https://gigacalc.net/subscribe'

		OTHERWISE
			RETURN 
	ENDCASE 
ENDIF 
=  ShellExecute(0, "open", lcEdgePath, '"' + cURL + '"', "", 1)
ENDPROC 

PROCEDURE ReleaseForm
PARAMETERS oFrmx
	IF VARTYPE(oFrmx) == 'O'
		oFrmx.Release
	ENDIF 
ENDPROC 

FUNCTION SetLabelWidth
PARAMETERS cTextCaption, nFontSize
   * ctextCaption - The caption text for the label
   * Returns: The calculated width in pixels

   LOCAL cFontName, cFontStyle, nTextWidth, nAvgCharWidth, nTotalWidth
   cFontName = "Arial"
*   nFontSize = 9
   cFontStyle = "N"  && Normal style

   * Calculate the number of average character widths
   nTextWidth = TXTWIDTH(ctextCaption, cFontName, nFontSize, cFontStyle)

   * Get the average character width in pixels
   nAvgCharWidth = FONTMETRIC(4, cFontName, nFontSize, cFontStyle)

   * Calculate the total width in pixels
   nTotalWidth = nTextWidth * nAvgCharWidth

   * Add 5 pixels
   nTotalWidth = nTotalWidth + 5

   RETURN nTotalWidth
ENDFUNC

FUNCTION cInParenthesis
PARAMETERS cstr
IF VARTYPE(cstr)=='N'
	cstr = FormatNumber(cstr,OCalc.Check11.Value,oCalc.Combo1.ListIndex-1)
ENDIF 
Retu("("+cstr+")")

FUNCTION cInSingleQuotes
PARAMETERS cstr
Retu("'"+cstr+"'")

FUNCTION cAddBrackets
PARAMETERS cstr
IF VARTYPE(cstr) == 'N'
	cstr = nIntToStr(cstr)
ENDIF 
RETURN '['+ALLTRIM(cstr)+']'

FUNCTION cAddQuotes
PARAMETERS cstr
RETURN Alltrim(cInQuotes(cstr))

FUNCTION cInQuotes
PARAMETERS cstr
RETURN '"'+Alltrim(cstr)+'" '

FUNCTION cremovequotes
PARAMETERS cstr
IF INLIST(LEFT(cstr,1),'"',"'") and INLIST(RIGHT(cstr,1),'"',"'")
	Retu(SUBSTR(cstr,2,LEN(cstr)-2))
ELSE
	Retu(cstr)
ENDIF 

PROCEDURE RunScript
PARAMETERS cscript
LOCAL cerror
cerror = .F.
WITH Thisform
	TRY 
		EXECSCRIPT(cscript)
	CATCH TO cerror
	ENDTRY 
	IF VARTYPE(cerror) == 'O'
		DO FORM Warning WITH 'Execution Halted -Error Condition',cerror.Message+IIF(EMPTY(SYS(2018)),'',': '+SYS(2018))
	ENDIF 
ENDWITH 

FUNCTION GetEmptynPlot
*	IF VARTYPE(oPlotx) == NULL
PUBLIC oplotx(10)
*	ENDIF 
	LOCAL i
	FOR i = 1 TO 10
		IF VARTYPE(oplotx(i)) # 'O'
			RETURN i
		ENDIF 
	ENDFOR 
	RETURN 0
ENDFUNC 

PROCEDURE ClickCalcButton
PARAMETERS cbutton, lclose
LOCAL cbuttlabel
	cbutton = LOWER(cbutton)
	DO Case
		CASE cbutton == 'savemem'
			cbuttlabel = IIF(lclose,'68','58')
		CASE cbutton == 'datecalc'
			cbuttlabel = IIF(lclose,'64','63')
		CASE cbutton == 'timecalc'
			cbuttlabel = IIF(lclose,'65','62')
		CASE cbutton == 'dtccalc'
			cbuttlabel = IIF(lclose,'79','78')
		CASE cbutton == 'distcalc'
			cbuttlabel = IIF(lclose,'87','86')
		CASE cbutton == 'ffcalc'
			cbuttlabel = IIF(lclose,'81','82')
		CASE cbutton == 'fnproc'
			cbuttlabel = IIF(lclose,'61','66')
		CASE cbutton == 'eqproc'
			cbuttlabel = IIF(lclose,'60','67')

	ENDCASE 
	IF VARTYPE(cbuttlabel) == 'C'
		IF lClose
			oCalc.Command&cbuttlabel..Click
		Else
			oCalc.Command&cbuttlabel..Click(.T.)
		ENDIF 
	ENDIF 
ENDPROC 

PROCEDURE OpenFFCalc
PARAMETERS lClose
	IF VARTYPE(oCalc) == 'O'
		IF lClose
			oCalc.Command82.Click
		ELSE 
			oCalc.Command81.Click(.T.)
*			oCalc.Command81.Click(.T.)
*!*				IF oFFCalc.WindowState == 0
*!*					oCalc.WindowState = 1
*!*				ENDIF 
		ENDIF 
	ENDIF 	
ENDPROC 

FUNCTION EnableScriptFn
PARAMETERS nMenuNo
LOCAL ncount
	SELECT memscripts
	ncount = 0
	SCAN FOR lshowinMen AND ncount < nMenuNo
		ncount = ncount + 1 
		IF ncount = nMenuNo
			RETURN RECNO()
		ENDIF 
	ENDSCAN 
RETURN 0
ENDFUNC 

FUNCTION AddCellToMemIfNeeded
PARAMETERS ntotalmemRequired, lextendmem
LOCAL iix
	IF (ntotalMemRequired) > RECCOUNT('Calc') 
		IF lextendmem
			FOR iix = 1 TO nTotalMemRequired - RECCOUNT('Calc')
				oCalc.TransferValueToMem(0,'',.T.,.T.)
			ENDFOR 
		ELSE
			RETURN .F.
		ENDIF 
	ENDIF 
	RETURN .T.
ENDPROC 

FUNCTION cGetQuarter
PARAMETERS nqtr,nyr,lfullword
	RETURN STR(nqtr,1)+ICASE(nqtr==1,'st',nqtr==2,'nd',nqtr==3,'rd',nqtr==4,'th')+IIF(lfullword,' Quarter ',' Qtr ')+;
		IIF(VARTYPE(nyr)=='N',STR(nyr,4),'')
ENDFUNC 
	
FUNCTION cRemoveSpaces
PARAMETERS cInline
LOCAL ix, cOutLine, ich
	cOutLine = ''
	FOR ix = 1 TO LEN(cInline)
		ich = SUBSTR(cInLine,ix,1)
		IF ich # ' '
			cOutLine = cOutLine + ich
		ENDIF 
	ENDFOR
	IF RIGHT(cOutLine,1) == ','
		cOutLine = LEFT(cOutLine,LEN(cOutLine)-1)
	ENDIF 
RETURN cOutLine 

FUNCTION Quotient
   PARAMETERS x, y
   IF y == 0
      RETURN 0
   ENDIF
   RETURN INT(x / y)
ENDFUNC	

FUNCTION q
	PARAMETERS x,y
	RETURN Quotient(x,y)
ENDFUNC 

FUNCTION NthRoot
   PARAMETERS x, n
   LOCAL result
   
   * Input validation
   IF n == 0
*      MESSAGEBOX("Error: Root cannot be zero", 16, "Error")
      RETURN x
   ENDIF
   
   IF x < 0 AND MOD(n, 2) == 0
*      MESSAGEBOX("Error: Cannot calculate even root of negative number", 16, "Error")
      RETURN x
   ENDIF
   
   * Calculate nth root using EXP and LOG
   * nth root of x = x^(1/n) = EXP(LOG(x)/n)
   IF x == 0
      result = 0
   ELSE
      result = EXP(LOG(ABS(x))/n)
      * Handle negative numbers for odd roots
      IF x < 0 AND MOD(n, 2) == 1
         result = -result
      ENDIF
   ENDIF
   
   RETURN result
ENDFUNC

FUNCTION INTVAL
PARAMETERS cstr
IF VARTYPE(cstr) == 'N'
	Retu(INT(cstr))
ENDIF 
IF UPPER(RIGHT(cstr,1)) == 'D'
	cstr = LEFT(cstr,LEN(cstr)-1)
ENDIF 
RETURN INT(VAL(ALLTRIM(cstr)))

FUNCTION nvaltostr
PARAMETERS nvx
Retu(ALLTRIM(STR(nvx,30)))

FUNCTION nvaltostrd
PARAMETERS nvx,nd
IF VARTYPE(nd) == 'C'
	nd = INT(VAL(nd))
ENDIF 
Retu(ALLTRIM(STR(nvx,30,nd)))

FUNCTION nIntToStr
PARAMETERS nInt
RETURN ALLTRIM(STR(nInt,6,0))

FUNCTION nThisMemLoc
Retu(RECNO('Calc'))

FUNCTION nThisMemValue
Retu(Calc.Memoryn)

FUNCTION nMemLocVal
PARAMETERS nloc
LOCAL nsavemem, nretval
	IF VARTYPE(nloc) == 'N'
		nsavemem = RECNO('Calc')
		IF BETWEEN(nloc,1,RECCOUNT('Calc'))
			GO nloc IN 'Calc'
			nretval = Calc.Memoryn
			GO nsavemem IN 'Calc'
			RETURN nretval
		ELSE 
			RETURN 0
		ENDIF 
	ENDIF  
	Retu(Calc.Memoryn)
ENDFUNC 

FUNCTION ClearAllMem
PARAMETERS norenumber
	oCalc.ClearAllMem(0)
	oCalc.nmemscriptresult = .F.
	IF norenumber
		RETURN 0
	ELSE 
		oCalc.RenumMem(.f.,.t.)
		RETURN 0
	ENDIF 
ENDFUNC 


FUNCTION nInc
PARAMETERS nVariable, nValue
IF VARTYPE(nValue) == 'L'
	RETURN nVariable + IIF(nValue,-1,1)
ENDIF 
Retu(nVariable + nValue)

FUNCTION SumPrevMem
PARAMETERS nback, nmemstart
LOCAL nsaveloc, nresult, iix, nstartx, nendx
	nsaveloc = nThisMemLoc()
	SELECT Calc
	IF VARTYPE(nmemstart) == 'N'
		IF nmemstart > RECCOUNT()
			nmemstart = RECCOUNT()
		ENDIF 
		nstartx = nmemstart-nback
	ELSE 
		nstartx = RECNO('Calc')- nback
	ENDIF 
	IF nstartx <= 0
		nstartx = 1
	ENDIF 
	nendx = RECNO('Calc')-1 
	IF nendx <= 0
		nendx = 1
	ENDIF 
	nresult = 0
	FOR iix = nstartx TO nendx
		GO iix
		nresult = nresult + memoryn
*	WAIT nresult window
	ENDFOR 
	GO nsaveloc
RETURN nresult

FUNCTION nIntToStrl
    LPARAMETERS nx, lcomma

    * Check if the input is an integer
    IF TYPE('nx') <> 'N' OR INT(nx) <> nx
        RETURN ""
    ENDIF

    * Check if lcomma is logical
    IF TYPE('lcomma') <> 'L'
        RETURN ""
    ENDIF

    * Convert the integer to a string
    LOCAL cResult
    cResult = TRANSFORM(nx)

    * Add comma separators if lcomma is .T.
    IF lcomma
        cResult = STRTRAN(TRANSFORM(nx, '999,999,999,999,999'), ' ', '')
    ENDIF

    RETURN cResult
ENDFUNC

PROCEDURE OpenFnProc
PARAMETERS lClose,lNoShow
	IF VARTYPE(oCalc) == 'O'
		IF lClose
			oCalc.Command66.Click()
		ELSE 
			oCalc.Command61.Click(lNoShow)
		ENDIF 
	ENDIF 	
ENDPROC 

FUNCTION cToolTip
PARAMETERS cline1, cline2

RETURN cline1+CBREAK+cline2

FUNCTION FormatNumberByCalc
PARAMETERS nvx
RETURN FormatNumber(nvx,oCalc.Check11.Value,oCalc.Combo1.ListIndex-1)


PROCEDURE EqProcSelectEq
PARAMETERS nEq

	IF VARTYPE(oEqProc) == 'O'
		oEqProc.PageFrame1.ActivePage = nEq
		oEqProc.PageFrame1.Click
	ENDIF 
ENDPROC

PROCEDURE EqProcDoCalc
	IF VARTYPE(oEqProc) == 'O'
		oEqProc.oPagex.Command2.Click
		RETURN oEqProc.oPagex.Text1.Value
	ENDIF 
ENDPROC 

PROCEDURE EqProcSetVarVal
PARAMETERS nvarx, nvalue
LOCAL cvarx
	cvarx = ALLTRIM(STR(nvarx+1,2))
	WITH oEqProc.oPagex
		IF .Text&cvarx..visible
			.Text&cvarx..value = nvalue
		ENDIF 
	ENDWITH 
ENDPROC

PROCEDURE FnProcFindEq
PARAMETERS cequation, lMakeTable, lplot, lRightClick, lexact
LOCAL lfound
	IF Vartype(oMakeTable) == 'O'
		WITH oMakeTable.Combo3
			.ListIndex = 1
			IF lexact
				DO WHILE ! (LOWER(cequation) == LOWER(ALLTRIM(.Value))) AND .ListIndex < RECCOUNT('Formulas')
					.ListIndex = .ListIndex + 1 
				ENDDO 
				IF (LOWER(cequation) == LOWER(ALLTRIM(.Value)))
					lfound = .T.
				ELSE 
					.ListIndex = 1
				ENDIF 

			ELSE 
				DO WHILE ! (LOWER(cequation) $ LOWER(.Value)) AND .ListIndex < RECCOUNT('Formulas')
					.ListIndex = .ListIndex + 1 
				ENDDO 
				IF (LOWER(cequation) $ LOWER(.Value))
					lfound = .T.
				ELSE 
					.ListIndex = 1
				ENDIF 
			ENDIF 
			.Interactivechange
		ENDWITH 
		IF lfound AND lMakeTable
			oMakeTable.autoplot.value = lplot
			oMakeTable.alternate.value = lRightClick
			oMakeTable.Command1.Click
		ENDIF 
	ENDIF 
ENDPROC 

FUNCTION lIsNumber
PARAMETERS cstrx
LOCAL ix,cx
	FOR ix = 1 TO LEN(cstrx)
		cx = SUBSTR(cstrx,ix,1)
		IF cx == ' '
			LOOP
		ENDIF 
		IF ! (ISDIGIT(cx) OR cx == '.')
			RETURN .F.
		ENDIF 
	ENDFOR 
RETURN .T.
ENDFUNC 

FUNCTION lx
PARAMETERS nx
LOCAL lopened, xretval
	xretval = 0
	IF VARTYPE(oFFcalc) # 'O'
		lopened = .T.
		OpenFFCalc()
	ENDIF 
	xretval = oFFcalc.getlinevalue(nx)
	IF lopened
		OpenFFCalc(.T.)
	ENDIF 
	RETURN xretval
ENDFUNC 

FUNCTION cConvTrim
PARAMETERS nvx, nlen, linquotes
LOCAL cvx
cvx = ALLTRIM(STR(nvx,nlen))
**WAIT 'here' window
RETURN IIF(linquotes,cAddQuotes(cvx),cvx)
		
		
FUNCTION OpenCustomForm
PARAMETERS cTitle
	DO FORM Customform WITH cTitle
	RETURN ccfndx
ENDFUNC 

PROCEDURE OpenEqProc
PARAMETERS lClose
	IF VARTYPE(oCalc) == 'O'
		IF lClose
			oCalc.Command67.Click
		ELSE 
			oCalc.Command60.Click(.T.)
		ENDIF 
	ENDIF 	
ENDPROC 

PROCEDURE DoMemFn
PARAMETERS nfn, nscope, nmemcell
ENDPROC 

FUNCTION GetValue
PARAMETERS cprompt, lInteger, ndefault, cinputmask
LOCAL nretval
	DO FORM entervalue WITH cprompt, lInteger, ndefault, cinputmask TO nretval
	Retu(IIF(VARTYPE(nretval) == 'N',nretval,0))
ENDFUNC 

FUNCTION GetSpinnerValue
PARAMETERS cprompt, ndefault
LOCAL nretval
	DO FORM enterspinnervalue WITH cprompt, ndefault TO nretval
	Retu(IIF(VARTYPE(nretval) == 'N',nretval,0))
ENDFUNC 

FUNCTION GetText
PARAMETERS ccaption, cprompt, ncx, lmandatory
LOCAL cretval
	DO FORM entertext WITH ccaption, cprompt, ncx, lmandatory TO cretval
	RETURN ALLTRIM(cretval)
ENDFUNC 

PROCEDURE GetWptDistance
PARAMETERS cID1, cID2, ldriving, lformat
LOCAL ndistx
	IF VARTYPE(oAptDist) # 'O'
		RETURN 0
	ENDIF 
	WITH oAptDist
		.Command7.Click
		.Command8.Click
		.ID1.Value = UPPER(cID1)
		.ID1.Interactivechange
		IF EMPTY(.Point1.Value)
			ShowWarning('Waypoint NOT Found',cInQuotes(cID1)+'not in stored waypoints! Function aborted.',.F.,6)
			RETURN .F.
		ENDIF 
		.ID2.Value = UPPER(cID2)
		.ID2.Interactivechange
		IF EMPTY(.Point2.Value)
			ShowWarning('Waypoint NOT Found',cInQuotes(cID2)+'not in stored waypoints! Function aborted.',.F.,6)
			RETURN .F.
		ENDIF 

		ndistx = IIF(ldriving,.ndrivedistmin,.nwptdist)
		IF lformat
			RETURN IIF(ldriving,'Driving','Air')+ ' Distance: '+cAddQuotes(.Point1.Value) +' to '+cAddQuotes(.Point2.Value) +' is '+ ALLTRIM(STR(ndistx,5))+ ' miles'
		ELSE 
			RETURN ndistx
		ENDIF 
	ENDWITH 
ENDPROC 

PROCEDURE GetAptDistance
PARAMETERS cID1, cID2, lformat
	IF VARTYPE(oAptDist) # 'O'
		OpenDistCalc()
	ENDIF 
	WITH oAptDist
		.Text5.Value = UPPER(cID1)
		.Text5.Interactivechange
		.Text6.Value = UPPER(cID2)
		.Text6.Interactivechange
*WAIT .Text5.Value+' to '+.Text6.Value+' is '+ .Text1.Value Window
		IF lFormat
			RETURN 'Air Distance: '+cAddQuotes(.Text5.Value)+' to '+cAddQuotes(.Text6.Value)+' is '+ .Text1.Value
		ELSE 
			Retu(INT(ROUND(VAL(.Text1.Value),0)))
		ENDIF 
	ENDWITH 
ENDPROC 

Function AddWaypoint
PARAMETERS CWptName, CWptID
	IF VARTYPE(oAptDist) # 'O'
		OpenDistCalc()
	ENDIF 
	WITH oAptDist
		.Command8.Click
		.ID2.Value = UPPER(CWptID)
		.ID2.Interactivechange
		IF EMPTY(.Point2.Value)
			.Point2.Value = CWptName
			.GetC2.Click
			IF ! EMPTY(.Long2.Value)
				.SavePt2.Click
				OpenDistCalc(.T.)
				RETURN .T.
			ELSE
				ShowWarning('No Coordinates Found in GM','Could not Locate Coordinates for '+cAddQuotes(CWptName),.F.,8)
				OpenDistCalc(.T.)
				RETURN .F.
			ENDIF 
		ELSE 
			ShowWarning('Duplicate Waypoint',cAddQuotes(UPPER(CWptName))+' already exists in Saved Waypoints',.F.,8)
			OpenDistCalc(.T.)
			RETURN .F.
		ENDIF 
	ENDWITH 
ENDFUNC 

PROCEDURE ShowMessageInWindowSz
PARAMETERS cCaption, cMessage, lCenter, lLeaveOpen
	Do Form ShowMessage2 with cMessage,lCenter,lLeaveOpen,cCaption
ENDPROC 

PROCEDURE ShowBriefMessage
PARAMETERS cCaption, cMessage, nSecOpen
	DO FORM ShowMsgWinXSt WITH cMessage,cCaption, nSecOpen
ENDPROC 

PROCEDURE ShowWarning
PARAMETERS cCaption, cMessage, lleaveopen, nsecs
	DO FORM Warningx WITH cCaption, cMessage, lleaveopen, nsecs
ENDPROC 

FUNCTION nffln
PARAMETERS nlinex
LOCAL nres, lclose, calias
	calias = ALIAS()
	IF VARTYPE(oFFcalc) == '0' OR USED('FreeFormResultsHistory')
		SELECT FreeFormResultsHistory
	ELSE 
		SELECT 0 
		USE('FreeFormResultsHistory')
		lclose = .T.
	ENDIF 
	LOCATE FOR nlineno == nlinex
	nres = IIF(FOUND(),nresult,0)
	IF lclose
		USE
	ENDIF
	SELECT &cAlias
	RETURN nres
ENDFUNC 
		
	

PROCEDURE SaveMemFn
PARAMETERS cbutton, xvalue
LOCAL cbuttlabel, ix
	DO Case
		CASE cbutton == 'cmTransToCalc'
			cbuttlabel = '1'
		CASE cbutton == 'cmSaveFromCalc'
			cbuttlabel = '2'
		CASE cbutton == 'cmPlot'
			cbuttlabel = '8'
		CASE cbutton == 'cmDeleteMemSet'
			cbuttlabel = '3'
		CASE cbutton == 'ckNew'
			cbuttlabel = 'check2'
		CASE cbutton == 'chSwap'
			cbuttlabel = 'check1'
	ENDCASE 
	DO Case
		CASE LEFT(cbutton,2) == 'cm'
			oMsbig.Command&cbuttlabel..Click
		CASE LEFT(cbutton,2) == 'ck'
			oMsbig.&cbuttlabel..Value = xvalue
			oMsbig.&cbuttlabel..Interactivechange
		CASE LEFT(cbutton,2) == 'Se'
			FOR ix = 1 TO RECCOUNT('memsetlistbig')
				GO ix IN 'memsetlistbig'
				IF xvalue $ memsetlistbig.cmemname
					oMsbig.Combo1.ListIndex = ix
					oMsbig.Combo1.Interactivechange
				ENDIF 
			ENDFOR 
	ENDCASE 
ENDPROC 

PROCEDURE ChartMemory
	IF VARTYPE(oCalc) == 'O'
		oCalc.Command85.Click
	ENDIF 
ENDPROC 

PROCEDURE OpenDistCalc
PARAMETERS lClose
	IF VARTYPE(oCalc) == 'O'
		IF lClose
			oCalc.Command87.Click
		ELSE 
			oCalc.Command86.Click(.T.)
		ENDIF 
	ENDIF 	
ENDPROC 

PROCEDURE OpenTimeCalc
PARAMETERS lClose
	IF VARTYPE(oCalc) == 'O'
		IF lClose
			oCalc.Command65.Click
		ELSE 
			oCalc.Command62.Click(.T.)
		ENDIF 
	ENDIF 	
ENDPROC 

PROCEDURE OpenDateTimeCalc
PARAMETERS lClose
	IF VARTYPE(oCalc) == 'O'
		IF lClose
			oCalc.Command79.Click
		ELSE 
			oCalc.Command78.Click(.T.)
		ENDIF 
	ENDIF 	
ENDPROC 

PROCEDURE OpenDateCalc
PARAMETERS lClose,lInVisible
	IF VARTYPE(oCalc) == 'O'
		IF lClose AND VARTYPE(oDaysBetweenDates)=='O'
			oCalc.Command64.Click
		ELSE 
			oCalc.Command63.Click(.T.)
		ENDIF 
		IF VARTYPE(oDaysBetweenDates)=='O' AND lInVisible
			oDaysBetweenDates.Visible = .F.
		ENDIF 
	ENDIF 	
ENDPROC 

PROCEDURE CalcMemScroll
PARAMETERS lup
	oCalc.memscroll(IIF(lup,1,-1))
ENDPROC 


PROCEDURE OpenWaypointPairs
	IF VARTYPE(oAptDist) == 'O'
		oAptDist.ShowSaved.Click(.T.)
	ENDIF 
ENDPROC 

PROCEDURE SelectWptPairsToChart
PARAMETERS crange,nx,nchart
	LOCAL nrange
	IF VARTYPE(nchart) == 'L'
		nchart = 0
	ENDIF 
	IF VARTYPE(crange) == 'C'
		crange = UPPER(crange)
		DO Case
			CASE crange == 'ALL'
				nrange = 1
			CASE crange == 'RED'
				nrange = 2
			CASE crange == 'GREEN'
				nrange = 3
			CASE crange == 'BLUE'
				nrange = 4
			CASE crange == 'PURPLE'
				nrange = 5
		OTHERWISE
			nrange = 1	
		ENDCASE 
	ELSE
		nrange = 1
	ENDIF 
	oWptPairs.Optiongroup1.Value = nrange
	IF VARTYPE(oWptPairs) == 'O'
		oWptPairs.Optiongroup2.Value = IIF(VARTYPE(nx)=='N' AND BETWEEN(nx,1,3),nx,1)
		IF nchart == 1
			oWptPairs.Command1.Click
		ELSE
			IF nchart == 2
				oWptPairs.Command3.Click
			ENDIF 
		ENDIF 
	ENDIF 
ENDPROC 
		

PROCEDURE ValToCalc
PARAMETERS cValx
LOCAL ix, cx
	IF VARTYPE(oCalc) == 'O'
		FOR ix = 1 TO LEN(cValx)
			cx = SUBSTR(cValx,ix,1)
			IF cx $ '123456789'
				oCalc.Command&cx..Click
			ELSE 
				IF cx $ '0.'
					IF cx == '0'
						cx = '10'
					ELSE 
						cx = '11'
					ENDIF 
					oCalc.Command&cx..Click
				ENDIF 
			ENDIF 
		ENDFOR 
	ENDIF 
ENDPROC 

PROCEDURE CalcFunction
PARAMETERS cFn
LOCAL cx, ix
	ix = AT(cFn,'+-x/')+11
	IF ix > 11
		cx = STR(ix,2)
		oCalc.Command&cx..Click
	ENDIF 
ENDPROC 

FUNCTION ValToMem
PARAMETERS nvalx,clabel,nmem,nmemset
LOCAL ccap
	clabel = ALLTRIM(clabel)
	IF VARTYPE(nmemset) # 'N'
		nmemset = 1
	ENDIF 
	IF VARTYPE(nmem) # 'N'
		nmem = 1
	ENDIF 
	IF BETWEEN(nmemset,1,99) AND BETWEEN(nmem,1,8)
		oCalc.TransferValToMemcell(nvalx,clabel,nmem,nmemset)
		IF ! EMPTY(clabel)
			ccap = STR(nmem+1,1)
			SELECT Calc
			GO (nmemset-1)*8 + nmem
			REPLACE Label WITH clabel
			oCalc.Label1&ccap..caption = clabel
		ENDIF 
	ENDIF 
ENDFUNC

PROCEDURE OpenPlotfx
	IF VARTYPE(oPlotFrm) # 'O'
		Do Form PlotFunctions4
	ELSE 
		oPlotFrm.WindowState = 0
		OPlotFrm.AlwaysOnTop = .T.
		OPlotFrm.AlwaysOnTop = .F.
	ENDIF 
ENDPROC



FUNCTION ValToMemLoc
PARAMETERS nvalx,clabel,nloc
LOCAL nmem,nmemset,ntemp
	IF VARTYPE(nloc) # 'N'
		nloc = 1
	ENDIF 
	IF BETWEEN(nloc,1,8*99)
		ntemp = nloc % 8
		nmemset = INT(nloc/8)+ IIF(ntemp==0,0,1)
		nmem = ntemp
		IF nmem == 0
			nmem = 8
		ENDIF 
		ValToMem(nvalx,clabel,nmem,nmemset)
	ENDIF 
ENDFUNC 

FUNCTION FormatEvent
PARAMETERS choliday, cdays, limpevent, lnextt
LOCAL cddays
	cdays = ALLTRIM(cdays)
*WAIT cdays window
	cddays = ICASE(cdays=='0','" Today',cdays=='1','" in '+cdays+' day','" in '+cdays+' days')
*WAIT cddays window

RETURN IIF(lnextt, 'Next ','')+'Next '+IIF(limpevent,'Important Event "','Holiday "')+ALLTRIM(choliday)+cddays

FUNCTION DateCalcHoliday
PARAMETERS nfn, lformatted
LOCAL cretval
	IF VARTYPE(oDaysBetweenDates) # 'O'
		RETURN '-1'
	ENDIF 
	WITH oDaysBetweenDates
		DO Case
			CASE nfn == 2
				cretval = .label7.Caption
			CASE nfn == 1
				cretval = .Combo1.Value
				IF lformatted
					cretval = FormatEvent(.Combo1.Value,.label7.Caption,.F.,.F.)
				ELSE
					cretval = .Combo1.Value
				ENDIF 
			CASE nfn == 3  && Next after holiday
					IF .Combo1.ListIndex < RECCOUNT('holidays')
						.Combo1.Listindex = .Combo1.Listindex + 1
					ELSE
						.Combo1.ListIndex = 1
						.Combo2.ListIndex = .Combo2.ListIndex + 1
						.Combo2.Interactivechange
					ENDIF 
					.Combo1.Interactivechange
				
				IF lformatted
					cretval = FormatEvent(.Combo1.Value,.label7.Caption,.F.,.T.)
				ELSE
					cretval = .Combo1.Value
				ENDIF 

		ENDCASE
		RETURN ALLTRIM(cretval) 
	ENDWITH 
ENDFUNC 

FUNCTION DateCalcImportantDate
PARAMETERS nx, lformatted
LOCAL cretval
	WITH oDaysBetweenDates
		DO Case
			CASE nx == 1
				cretval = ALLTRIM(.Combo3.Value)
				IF lformatted
					cretval = FormatEvent(cretval,.Label12.Caption,.T.,.F.)
				ENDIF 
			CASE nx == 2
				cretval = ALLTRIM(.Label12.Caption)
			CASE nx == 3
				IF .Combo3.ListIndex < RECCOUNT('ImportantDates')
					.Combo3.ListIndex = .Combo3.ListIndex + 1
				ELSE
					.Combo3.ListIndex = 1
					.Combo4.ListIndex = .Combo4.ListIndex + 1
					.Combo4.Interactivechange
				ENDIF 
				.Combo3.InteractiveChange
				cretval = ALLTRIM(.Combo3.Value)
				IF lformatted
					cretval = FormatEvent(cretval,.Label12.Caption,.T.,.T.)
				ENDIF 
		ENDCASE 
	ENDWITH 
	RETURN cretval
ENDFUNC

FUNCTION cGetNextTwoImportantDates
	WITH oDaysBetweenDates
		RETURN ALLTRIM(RIGHT(.Label17.Caption,LEN(.Label17.Caption)-1))+CHR(13)+ALLTRIM(RIGHT(.Label18.Caption,LEN(.Label18.Caption)-1))
	ENDWITH 
ENDFUNC 

FUNCTION DateCalcCompute
PARAMETERS nfn, ddate1, ddate2, lworkdays
Local cretval
	WITH oDaysBetweenDates
		DO Case
			CASE nfn == 1  && Calc days between the two dates
				.date1 = ddate1
				.date2 = ddate2
				.command3.Click
				.Command6.Click
				cretval = IIF(lworkdays,.Label9.Caption,.Label3.Caption)
				
			CASE nfn == 2 && Add a value to date 1 to get date2
				.date1 = ddate1
				.Spinner1.Value = ddate2
				.Command11.Click
				cretval = .date2
			CASE nfn == 3  && Subtrace a value from date2 to get date1
				.date2 = ddate1
				.Spinner1.Value = ddate2
				.Command12.Click
				cretval = .date1
		ENDCASE 
	ENDWITH 
	RETURN cretval
	&& Add days to date1 and return date2
	&& Subtract days from date2 and return date1
	&& Get number of days between date1 and date2 and number of workdays
ENDFUNC 

PROCEDURE DateCalcPrintIdates
	DO FORM EnterOccassionModal
		oIdatesM.Visible = .F.
		oIdatesM.DoPrint.Click
		oIdatesM.Release
ENDPROC


PROCEDURE SetDTCalcDT
PARAMETERS ntime, nyear, nmonth, nday, nhr, nmin
LOCAL ctime
	IF VARTYPE(oDateTimeCalc) == 'O'
		ctime = STR(ntime,1)
		WITH oDateTimeCalc
			.Date&ctime = DATETIME(nyear,nmonth,nday,nhr,nmin)
			.UpdateDateTime&ctime
		ENDWITH 
	ENDIF 
ENDPROC 

FUNCTION nMemValThis
PARAMETERS ndisp, nretnoval
LOCAL nsavememloc, nretval
	nsavememloc = RECNO('Calc')
&&WAIT RECCOUNT('Calc') window
	IF (RECCOUNT('Calc') >= (nsavememloc + ndisp)) AND ((nsavememloc + ndisp) > 0)
*WAIT 'we are here' window
		GO nsavememloc + ndisp IN 'Calc'
		nretval = Calc.Memoryn
*brow
		GO nsavememloc in 'Calc'
*BROWSE
*		WAIT nretval window
		RETURN nretval 

	ELSE
	 	RETURN IIF(VARTYPE(nretnoval) # 'N',0,nretnoval)
	ENDIF 
ENDFUNC 

FUNCTION DTCalcCalc
	oDateTimeCalc.Command3.Click(1)
RETURN oDateTimeCalc.ntimediffx

PROCEDURE ShowMessageInWindow
PARAMETERS ctitle,cmessage, nleaveOpen,nWindowbc,nBoxbc,nBoxfc,nBtnbc,nBtnfc,lFontBold
	DO WHILE VARTYPE(oScriptMsg) == 'O'
		WAIT '' window TIMEOUT .5
	ENDDO 
  DO FORM showmessagescript WITH ctitle,cmessage, .T., nleaveOpen,nWindowbc,nBoxbc,nBoxfc,nBtnbc,nBtnfc,lFontBold
ENDPROC 

PROCEDURE ChartTable
*ChartTable('mytable362',2,'2023 Sales','2024 Sales','','','Sales','Monthly Sales',13)
PARAMETERS ctablename,nvars,nfieldlegend1,nfieldlegend2,nfieldlegend3,nfieldlegend4,ctitle,cyaxis,ntype
PUBLIC cplotvar(5,2)
LOCAL i,c_i

	FOR i = 1 TO nvars
		c_i = STR(i,1)
		cplotvar(i,1) = FIELD(i+1)
		cplotvar(i,2) = nfieldlegend&c_i
	ENDFOR 
	PlotTableVar3(ctablename,nvars,ntype,ctitle,FIELD(1),'Month','Sales $',.T.,'','')
ENDPROC 

FUNCTION GetMemVal
PARAMETERS nmemloc
	IF nmemloc <= RECCOUNT('Calc')
		GO nmemloc IN Calc
		RETURN Calc.memoryn
	ELSE
		RETURN 0
	ENDIF 
ENDFUNC 

PROCEDURE CalcEqual
	oCalc.Command16.Click
ENDPROC 

PROCEDURE CalcClear
	oCalc.Command19.Click
ENDPROC 


PROCEDURE CalcToMem
	oCalc.Command69.Click
ENDPROC 

PROCEDURE CalcCheckMem
PARAMETERS nMemLoc, lcheck
LOCAL ci
	ci = STR(nMemLoc,1)
	oCalc.Check&ci..Value = lcheck
ENDPROC 

PROCEDURE CalcClrMem
PARAMETERS cWhichtoClear, lconfirm
LOCAL ci
	ci = ''
	cWhichtoClear = UPPER(cWhichtoClear)
	DO CASE 
		CASE cWhichtoClear == 'ALL' OR cWhichtoClear == 'A'
			ci = '70'
		CASE cWhichtoClear == 'CHECKED'  OR cWhichtoClear == 'C'
			ci = '74'
		CASE cWhichtoClear == 'UNCHECKED' OR cWhichtoClear == 'U'
			ci = '75'
	ENDCASE 
	IF ! EMPTY(ci)
		oCalc.Command&ci..click(! lconfirm)
	ENDIF 
ENDPROC 

PROCEDURE CalcCheckMemWithCondition
PARAMETERS cCondition, lthismemset
	cCondition = STRTRAN(UPPER(cCondition),'MEMVAL','Memoryn')
	oCalc.Command72.Click  &&Uncheck all
	SELECT Calc
	Go Top
	IF lthismemset
		REPLACE ALL Checked WITH .T. For &cCondition AND memset == INT(Val(oCalc.Combo2.Value))
	ELSE
		REPLACE ALL Checked WITH .T. For &cCondition
	ENDIF 
	Locate for memset == Val(oCalc.Combo2.Value)
	oCalc.Check(3)
	oCalc.Combo3.InteractiveChange
ENDPROC 

PROCEDURE CalcChartMemory
PARAMETERS nchart
	oCalc.Command85.Click(nchart)
ENDPROC 

PROCEDURE CalcMemCompress
	oCalc.CompressMem
ENDPROC

PROCEDURE CalcMemSort
PARAMETERS lAscending
	oCalc.SortMemory(lAscending)
ENDPROC  

PROCEDURE CalcMemRenumberLabels
	oCalc.RenumMem
ENDPROC 

PROCEDURE CalcMemRandomize
PARAMETERS lThisSetOnly
	oCalc.Randomize(lThisSetOnly)
ENDPROC 

PROCEDURE TCSelectCurrentTime
PARAMETERS ntime
	ctime = IIF(ntime==1,'4','6')
	IF VARTYPE(oTimeCalc) == 'O'
		oTimeCalc.Command&ctime..click
	ENDIF 
ENDPROC 

PROCEDURE TCAddSubMin
PARAMETERS nmins, lSubtract
	IF VARTYPE(oTimeCalc) == 'O'
		WITH oTimeCalc
			.Spinner2.Value = IIF(BETWEEN(nmins,1,99),nmins,1)
			IF lSubtract
				.Command10.Click
				Retu(.Label27.Caption)
			ELSE
				.Command9.Click
				Retu(.Label28.Caption)
			ENDIF 
		ENDWITH 
	ENDIF 
ENDPROC 

PROCEDURE TCStartTimer
PARAMETERS nsecs, lCloseAfter, lPlayTicks, nchimetime
LOCAL ntimer
*!*		ntimer = AT(UPPER(cTimer),'ABC')
*!*		IF ntimer == 0
*!*			Retu
*!*		ENDIF 
	IF VARTYPE(oTimeCalc) == 'O'
		WITH oTimeCalc
			.lCloseAfterTimer = lCloseAfter
			.OptionGroup4.Value = 1
			.OptionGroup4.InteractiveChange
*			.Visible = .T.
			.Spinner7.Value = nsecs
			.Spinner7.Interactivechange
			.Check2.Value = lPlayTicks
			IF VARTYPE(nchimetime) == 'N'
				.Spinner3.Value = nchimetime
			ENDIF 
			.Command2.Click
		ENDWITH 
	ENDIF 
ENDPROC 

PROCEDURE TCStartAlarm
PARAMETERS nclockx, lCloseAfter
	IF VARTYPE(oTimeCalc) == 'O'
		WITH oTimeCalc
			.lCloseAfterTimer = lCloseAfter
			.OptionGroup3.Value = nclockx
			.OptionGroup3.InteractiveChange
			.Command7.Click
		ENDWITH 
	ENDIF 
ENDPROC 

FUNCTION GetDate
PARAMETERS cformat
LOCAL dretdate
	SET CENTURY ON
	DO FORM NewDatePicker33 WITH DATE() TO dretdate
	IF VARTYPE(cformat) == 'C'
		cformat = UPPER(cformat)
		DO Case
			CASE cformat == 'DMY'
				Retu(DMY(dretdate))
			CASE cformat == 'C'
				Retu(DTOC(dretdate))
			CASE cformat ==	'MDY'
				Retu(MDY(dretdate))
			CASE cformat ==	'YMD'
				SET DATE TO YMD
				dretdate = DTOC(dretdate)
				SET DATE TO USA
				RETURN dretdate
			CASE LEFT(cformat,1) ==	'J' 
				dretdate = (VAL(SYS(11,dretdate))-VAL(SYS(11,'01/01/'+STR(YEAR(DATE()),4)))+1)
				IF RIGHT(cformat,1) == 'C'
					dretdate = ALLTRIM(STR(dretdate))
				ENDIF 
				RETURN dretdate
		ENDCASE 
	ELSE 
		RETURN dretdate
	ENDIF 
ENDFUNC 

PROCEDURE SwapCalcValues
PARAMETERS n1, n2
	WITH oCalc
		.Swap1.Value = n1
		.Swap2.Value = n2
		IF .MemSwap.Enabled 
			.MemSwap.Click
		ENDIF 
	ENDWITH 
ENDPROC 

PROCEDURE CreateNewGenericTable
PARAMETERS ctablename
	IF EMPTY(ctablename)
		RAND(-1)
		ctablename = 'mytable'+ALLTRIM(STR(INT(1000*RAND())))
	ENDIF 
	IF FILE(ctablename+'.dbf')
		WAIT 'Table "'+ctablename+'" Already Exists.  Open with OpenTable' Window
		RETURN ""
	ELSE 
		SELECT 0
		USE generictable
		COPY STRUCTURE TO &ctablename
		USE &ctablename
		RETURN ctablename
	ENDIF 
ENDPROC 

Function EditSalesTableData
PARAMETERS ctablenamex
LOCAL ncolumns,i,cfield,lgettable,lyes
	lgettable = VARTYPE(ctablename)=='L'
	IF lgettable
		ctablenamex = ALLTRIM(GetText('Data Table Name:'))
	ENDIF 
*WAIT ctablenamex window
	IF ! (ALIAS() == ALLTRIM(ctablenamex))
		IF ! FILE(ALLTRIM(ctablenamex)+'.dbf')
			DO FORM ShowMessageScriptInTop WITH 'Table "'+ctablenamex+'" does not exist',.T.,5
			RETURN .F.
		ENDIF 
	ENDIF 
*!*		DO FORM ShowMessageScriptInTop WITH '"'+ctablenamex+'" totals will be updated automatically after you edit sales data.',;
*!*					.T.,5
				
*WAIT ' ' WINDOW TIMEOUT .1
	OpenTable(ctablenamex)
	DO FORM EditSalesData WITH ctablenamex,FIELD(2),FIELD(3),FIELD(4),FIELD(5) 

	RETURN .T. 
ENDPROC 


PROCEDURE CreateNewSalesChartWithData
PARAMETERS nyr1,nyr2,nyr3,nyr4
	CreateMonthlySalesChart(GetText('Data Table Name:'),.T.,.F.,.F.,nyr1,nyr2,nyr3,nyr4)
ENDPROC 

PROCEDURE DispSalesChart
PARAMETERS cchartname, lShowtotals, lShowQuarterly, nyr1, nyr2, nyr3, nyr4
	CreateMonthlySalesChart(cchartname,.F.,lShowtotals,lShowQuarterly, .T.,nyr1, nyr2, nyr3, nyr4)
ENDPROC 

PROCEDURE CreateNewSalesTable
PARAMETERS ctablename,ccol1,ccol2,ccol3,ccol4,ccol5
LOCAL ccreatestr
	ccreatestr = '&ctablename (&ccol1 C(20), &ccol2 N(12,2)'+;
		IIF(! EMPTY(ccol3),',&ccol3 N(12,2)','')+IIF(! EMPTY(ccol4),',&ccol4 N(12,2)','')+IIF(! EMPTY(ccol5),',&ccol5 N(12,2)','')+')'
	CREATE TABLE &ccreatestr
ENDPROC 

PROCEDURE CreateMonthlySalesChart
PARAMETERS cxtable,lnewtable, ltotal, lincludequarterly, ldonotaddrecords,nyr1,nyr2,nyr3,nyr4
LOCAL ctable,ctable2,ntotal,cfield, ncolumns, i, c_i, cyr1,cyr2,cyr3,cyr4
	FOR i = 2 TO 5
		c_i = STR(i-1,1)
		IF VARTYPE(nyr&c_i) == 'L'
			cyr&c_i = ''
		ELSE 
			cyr&c_i = STR(nyr&c_i,4)
		ENDIF 
	ENDFOR 
	ci = 'Yr_'
	IF ! EMPTY(cxtable) AND lnewtable
		CreateNewSalesTable(cxtable,'Months',ci+cyr1,IIF(EMPTY(cyr2),'',ci)+cyr2,IIF(EMPTY(cyr3),'',ci)+cyr3,IIF(EMPTY(cyr4),'',ci)+cyr4)
		ctable = cxtable
	ELSE 
		ctable = cxtable
	ENDIF 
	OpenTable(cxtable)

	IF ! ldonotaddrecords
		AddnEmptyRecords(17,.T.,.T.,.F.)
		EditSalesTableData(cxtable)
	ELSE 
		ctable = ALIAS()
		ncolumns = 0
		FOR i = 2 TO 5
			GO Top
			cfield = FIELD(i)
			IF ! EMPTY(cfield)
				ntotal = SumField(i,1,12)
				IF ntotal > 0
					LOCATE FOR ALLTRIM(Months) == 'Total'
					IF FOUND()
						REPLACE &cfield WITH ntotal
					ENDIF 
					ncolumns = ncolumns + 1 
				ENDIF 
			ENDIF
		ENDFOR 
		IF ! ltotal OR ! lincludequarterly
			cfield = FIELD(1)
			IF ! ltotal
				DELETE FOR ALLTRIM(&cfield) == 'Total'
			ENDIF 
			IF ! lincludequarterly
				DELETE FOR 'Qtr_' $ &cfield
			ENDIF 
			SET DELETED ON
			Try			
				COPY STRUCTURE TO Temptable
				SELECT 0
				USE Temptable
				ctable2 = 'Temptable'
			CATCH 
				IF USED('Temptable2')
					SELECT Temptable2
					USE
					SELECT &ctable
				ENDIF 
				COPY STRUCTURE TO Temptable2
				SELECT 0
				USE Temptable2
				ctable2 = 'Temptable2'
			ENDTRY 
			APPEND FROM &ctable FOR ! DELETED()
			SET DELETED OFF 
			SELECT &ctable
			RECALL All
		ENDIF 
	*	PARAMETERS ctablename,nvars,nfieldlegend1,nfieldlegend2,nfieldlegend3,nfieldlegend4,ctitle,cyaxis,ntype
		ChartTable(IIF(ltotal,ctable,ctable2),ncolumns,'Sales '+cyr1,'Sales '+cyr2,'Sales '+cyr3,'Sales '+cyr4,'Annual Sales Report for "'+;
		+PROPER(ctable)+'"','Monthly Sales $',6)
		IF VARTYPE(oPlotx(nplot)) # 'O'
			SELECT &ctable2
			USE
			DELETE FILE &ctable2..dbf
		ENDIF 
		SELECT &ctable
		RECALL ALL 
	ENDIF 
ENDPROC 

PROCEDURE StoreValuesInTable
PARAMETERS ctable,nval,val1,val2,val3,val4,val5
LOCAL cfield,i,c_i
	SELECT &ctable 
	APPEND BLANK 
	FOR i = 1 TO IIF(nval>5,5,nval)
		c_i = STR(i,1)
		cfield = FIELD(i)
		REPLACE &cfield WITH val&c_i
	ENDFOR 
ENDPROC 

PROCEDURE AddnEmptyRecords
PARAMETERS nblank, ldefinemonths, ltotal, laverage
LOCAL i, nrec, cfield, i_ch
	FOR i = 1 TO nblank
		i_ch = ALLTRIM(STR(i,2))
		IF i < 10
			i_ch = '0'+i_ch
		ENDIF 
		APPEND Blank
		IF i == 1
			nrec = RECCOUNT()
		ENDIF 
		IF ldefinemonths 
			cfield = FIELD(1)
			IF RECNO()<=12
				REPLACE &cfield WITH CMONTH({^2023-&i_ch-16})
			ENDIF 
			IF RECNO() == 13
				IF ltotal AND ! laverage
					REPLACE &cfield WITH 'Total'
				ENDIF 
				IF laverage 
					REPLACE &cfield WITH 'Average'
				ENDIF 
			ENDIF 
			IF ltotal AND laverage AND RECNO()== 14
				REPLACE &cfield WITH 'Total'
			ENDIF
		ENDIF 
	ENDFOR 
	GO RECCOUNT() 
	FOR i = 4 to 1 STEP -1
		i_ch = '_'+STR(i,1)
		REPLACE &cfield WITH 'Qtr'+i_ch
		SKIP - 1
	ENDFOR 
	GO nrec
RETURN nrec
ENDPROC 

FUNCTION sumfield
PARAMETERS nfield, nrec1,nrec2
LOCAL ntotal, cfield
	cfield = FIELD(nfield)
	SUM FOR BETWEEN(RECNO(),nrec1,nrec2) &cfield TO ntotal
	RETURN ntotal
ENDPROC 

FUNCTION XtotheY
Para x,y
	IF y == INT(y)
		RETURN x^y
	ENDIF 
	IF x == 0
		RETURN 0
	ENDIF 
	IF x < 0
		RETURN - EXP(y*LOG(ABS(x)))
	ELSE
		Retu(EXP(y*LOG(x)))
	ENDIF 
ENDFUNC 

FUNCTION Avgfield
PARAMETERS nfield, nrec1,nrec2
LOCAL ntotal, cfield
	cfield = FIELD(nfield)
	CALCULATE AVG(&cfield) FOR BETWEEN(RECNO(),nrec1,nrec) TO ntotal
	RETURN ntotal
ENDPROC 
	
PROCEDURE sumfieldsAppend
PARAMETERS nfield1, nfield2, nfield3, nfield4, nfield5
LOCAL i, i_c, cfield, ntotal(5)
	FOR i = 1 TO PCOUNT()
		i_c = STR(i,1)
		cfield = FIELD(nfield&i_c)
		SUM ALL &cfield TO ntotal(i) 
	ENDFOR 
	APPEND BLANK
	FOR i = 1 TO PCOUNT()
		i_c = STR(i,1)
		cfield = FIELD(nfield&i_c)
		REPLACE &cfield WITH ntotal(i)
	ENDFOR 
ENDPROC 

PROCEDURE OpenTable
PARAMETERS ctablename
	IF FILE(ctablename+'.dbf')
		IF USED(ctablename)
			SELECT &ctablename
		ELSE 
			SELECT 0
			USE &ctablename
		ENDIF 
		RETURN .T.
	ELSE 
		RETURN .F.
	ENDIF 
ENDPROC

PROCEDURE CLOSETable
PARAMETERS ctablename
IF USED(ctablename)
	SELECT &ctablename
	USE
ENDIF 
ENDPROC 

PROCEDURE SelectTable
PARAMETERS ctablename
	IF USED(ctablename)
		SELECT &ctablename
		RETURN .T.
	ELSE
		RETURN .F.
	ENDIF 
ENDPROC

FUNCTION CloseTable
PARAMETERS ctablename
	IF USED(ctablename)
		SELECT &ctablename
		USE
		RETURN .T.
	ELSE
		RETURN .F.
	ENDIF 
ENDPROC 

PROCEDURE OpenAphorismsScreen
PARAMETERS lstartcycle, ntimedelay
	IF VARTYPE(oCycleF) # 'O'
		DO FORM Cycle WITH lstartcycle, ntimedelay
	ENDIF 
ENDPROC 

PROCEDURE CloseAphorismsScreen
	IF VARTYPE(oCycleF) == 'O'
		oCycleF.Release
	ENDIF
ENDPROC 

PROCEDURE CalcCopyValue
	oCalc.Copy.Click
RETURN _ClipText

PROCEDURE CalcCheckMem
PARAMETERS ncond, nfirst, nsecond, luncheck, lthismemset
	oCalc.Command89.Click
	WITH oMemChk
		.Combo1.ListIndex = ncond
		.Combo1.Interactivechange
		.Text3.Value = nfirst
		.Text4.Value = nsecond
		.Optiongroup1.Value = IIF(luncheck,2,1)
		.Optiongroup1.Interactivechange
		.Check2.Value = lthismemset
		.Command5.Click
	ENDWITH 
ENDPROC

PROCEDURE CalcCheckNZ
PARAMETERS lthismemset
	IF lthismemset
		.Command71.RightClick
	ELSE
		.Command71.Click
	ENDIF 
ENDPROC  

PROCEDURE CalcOpenSciFm
PARAMETERS lclose
	IF lclose AND VARTYPE(oSciFm) == 'O'
		oSciFm.Release
	ELSE 
		IF oCalc.Sci.BackColor == RGB(45,174,244) AND ! lclose
			oCalc.Sci.Click
		ENDIF 
	ENDIF 
ENDPROC 

PROCEDURE SciFmFn
PARAMETERS nfntab, cnfn, cdomain, lrightclick
LOCAL cp, nopt, lclose
	
	IF VARTYPE(oScifm) # 'O'
		oCalc.Sci.Click
		oScifm.Visible = .F.
		lclose = .T.
	ENDIF 
	IF VARTYPE(oScifm) == 'O' AND BETWEEN(nfntab,0,5)
		WITH oScifm
			cp = STR(nfntab,1)
			IF nfntab > 0
				.Pageframe1.ActivePage = nfntab
				.Pageframe1.Page&cp..Click
			ENDIF 
			IF VARTYPE(cnfn) == 'N'
				cnfn = ALLTRIM(STR(cnfn,2))
			ENDIF 
			IF VARTYPE(cnfn) == 'C' 
				IF  nfntab # 0
					cnfn = LOWER(cnfn)
				ENDIF 
*WAIT cnfn window
				DO Case
					CASE nfntab == 0
						.&cnfn..click
					CASE nfntab == 1
						IF INLIST(cnfn,'payment','futval','discann','loanaff','npv','fvpi')
							.Pageframe1.Page&cp..&cnfn..click
						ENDIF 
					CASE nfntab == 2
						IF VARTYPE(cdomain) == 'C'
							cdomain = LOWER(cdomain)
							nopt = 1
							DO Case
								CASE cDomain == 'all' OR cdomain == '1'
								CASE cDomain == 'ck' OR cdomain == '2'
									nopt = 2
								CASE cDomain == 'un' OR cdomain == '3'
									nopt = 3
								CASE cDomain == 'nz' OR cdomain == '4'
									nopt = 4
							ENDCASE 
							.Pageframe1.Page&cp..OptionGroup1.Value = nopt
						ENDIF 
						IF INLIST(cnfn,'sum','mean','min','max','variance','stdev','med','range')
							.Pageframe1.Page&cp..&cnfn..click
						ENDIF 
					CASE nfntab == 3 OR nfntab == 4
						TRY
							IF lrightclick
								.Pageframe1.Page&cp..&cnfn..rightclick
							ELSE 
								.Pageframe1.Page&cp..&cnfn..click
							ENDIF 
						CATCH
							WAIT 'Button Not Found' Window
						ENDTRY	
					CASE nfntab == 5
						IF BETWEEN(VAL(cnfn),1,24)
							cnfn = 'udf'+cnfn
							.Pageframe1.Page&cp..&cnfn..click
						ENDIF 
				ENDCASE 
			ENDIF
		ENDWITH 
	ENDIF 
	IF lclose
		oScifm.Release
	ENDIF 
ENDPROC 

PROCEDURE CalcClrChecked
PARAMETERS lThismemset
	IF lThismemset
		oCalc.Command74.RightClick
	ELSE 
		oCalc.Command74.Click
	ENDIF 
ENDPROC 

PROCEDURE PlotSavedMemSet
PARAMETERS nsetx
ClickCalcButton('SaveMem')
SaveMemFn('Sel',ALLTRIM(STR(nsetx)))
SaveMemFn('cmPlot')
ClickCalcButton('SaveMem',.T.)

PROCEDURE SetTimerAndStart
PARAMETERS nseconds,lseconds, lplayticks, nchimtimelimit
	OpenTimeCalc()
*	TCAddSubMin(nminx)
	TCStartTimer(nseconds,.T., lplayticks, nchimtimelimit)
ENDPROC 

FUNCTION UDFX
PARAMETERS nudf, nxval
LOCAL cfnx, nretval, x, caliasx

	caliasx = ALIAS()

	IF USED('udf')
		SELECT udf
	ELSE
		SELECT 0
		USE udf
	ENDIF 

	IF ! BETWEEN(nudf,1,24)
		SELECT &caliasx
		RETURN 0
	ENDIF 
	GO nudf
	IF EMPTY(cfndef)
		SELECT &caliasx
		RETURN 0
	ENDIF 	
	cfnx = cfndef
	TRY
		x = nxval
		nretval = EVALUATE(cfnx)
	CATCH
		nretval = x
	ENDTRY
	SELECT &caliasx 
	RETURN nretval
ENDFUNC 

FUNCTION cGetPieText
PARAMETERS cintable
LOCAL cAlias, cretval
cAlias = ALIAS()
SELECT &cintable
cretval = cmemloc
SELECT &cAlias
Retu(cretval)



PROCEDURE PlotTableVar3
PARAMETERS ctablename,nvariables,;
			ndefaultgraph,cgraphtitle,cxaxistfieldname,cxaxislabel,;
			cyaxislabel,ldiscreet,cshapelegendExpression,cextra,lbef,lmem
	IF GetEmptynPlot() == 0
		DO FORM ShowMessage2 WITH 'Maximum number [10] chart windows currently open.  Close one of them if you want to create this chart',.t.,.t.	
	ELSE 	
		IF VARTYPE(oSetChartBC) == 'O'
			oSetChartBC.Release
		ENDIF 
*!*			IF nplot > 0 AND VARTYPE(oPlotx(nplot)) == 'O'
*!*				oPlotx(nplot).Release
*!*			ENDIF 
		DO FORM PlotMultiData WITH ctablename,nvariables,ndefaultgraph,cgraphtitle,cxaxistfieldname,;
			cxaxislabel,cyaxislabel,ldiscreet,cshapelegendExpression,cextra,lbef,lmem
	ENDIF 
ENDPROC 

PROCEDURE PlotTableVar1
PARAMETERS ctablename,cvariablename,ndefplot,ccaption
	IF VARTYPE(oPlot) == 'O'
		oPlot.Release
	ENDIF 
*	ShowBriefMessage('Feature deactivated','Alternate charting unavailable at this time',8)
*	RETURN 
	Try
		DO FORM PlotData WITH ctablename,cvariablename,ndefplot,ccaption
	CATCH
		WAIT 'Feature not available at this time'
	ENDTRY 
ENDPROC 

FUNCTION RandMem
PARAMETERS nMemSet
IF VARTYPE(nMemSet) # 'N'
	nMemSet = 1
ENDIF 
IF nMemSet == 0
	oCalc.Randomize(.F.)
	RETURN 1
ENDIF 
SELECT Calc
GO Top
LOCATE FOR MemSet == nMemSet
IF FOUND()
	oCalc.Combo2.ListIndex = MemSet
	oCalc.Combo2.Interactivechange
	oCalc.Randomize(.T.)
	RETURN 1
ELSE 	
	RETURN 0
ENDIF 
ENDFUNC 
				
PROCEDURE RandomizeMemory
PARAMETERS lThisMemSet, ljustvalues
LOCAL lnRnum, tnStartRecordNumber, tnEndRecordNumber, lnRandomRecordNumber, ixx
Public cfieldx(12), temp1(12), temp2(12)
	FOR ixx = 1 TO FCOUNT('Calc')
		cfieldx(ixx) = ixx
	ENDFOR 

	SELECT Calc
	
	IF ! lThisMemSet
		tnStartRecordNumber = 1
		tnEndRecordNumber = RECCOUNT()
	ELSE
		oCalc.GoTopDisplayedMem
		tnStartRecordNumber = RECNO()
		tnEndRecordNumber = RECNO()+7
*WAIT tnStartRecordNumber window
*WAIT tnEndRecordNumber window
	ENDIF 
	= RAND(-1)
	FOR lnRnum = tnStartRecordNumber TO tnEndRecordNumber
	    lnRandomRecordNumber = INT((tnEndRecordNumber - tnStartRecordNumber + 1) * RAND() + tnStartRecordNumber)
		SELECT Calc
		GOTO lnRnum
	    GetTemp1Values()

		GOTO lnRandomRecordNumber
		GetTemp2Values()
		
		GOTO lnRnum
		StoreTemp2Values(ljustvalues)
		
		GOTO lnRandomRecordNumber
	    StoreTemp1Values(ljustvalues)
	ENDFOR 
	REPLACE ALL cmemloc WITH nIntToStr(RECNO('Calc'))
	RELEASE cfieldx, temp1, temp2
ENDPROC 

Function CheckCompressEnable
LOCAL lHasZero, lHasNonZeroAfter
   
   SELECT Calc
   IF RECCOUNT() == 8
	   GO TOP
	   SCAN
	      IF memoryn == 0
	         lHasZero = .T.
	      ELSE
	         IF lHasZero AND memoryn # 0
	            lHasNonZeroAfter = .T.
	            EXIT
	         ENDIF
	      ENDIF
	   ENDSCAN
   RETURN lHasNonZeroAfter
   ENDIF 
	GO Top
	LOCATE FOR Memoryn == 0 
	IF FOUND()  
		RETURN .T.
	ELSE 
		RETURN .F.
	ENDIF 
ENDFUNC  

FUNCTION AVG
PARAMETERS nvx1, nvx2, nvx3, nvx4, nvx5, nvx6, nvx7, nvx8, nvx9, nvx10
LOCAL iix, cix, ntotalx
	ntotalx = 0
*WAIT nvx1 window
	FOR iix = 1 TO 10
		cix = nIntToStr(iix)
		IF VARTYPE(nvx&cix) == 'N'
*Wait nvx&cix window
			ntotalx = ntotalx + nvx&cix
*Wait ntotalx Window
		ELSE
			iix = iix - 1
			EXIT 
		ENDIF 
	ENDFOR 
*WAIT iix window
RETURN ntotalx/iix
ENDFUNC 

* Function: CalcMedian
* Purpose: Calculate the median of up to 10 numeric parameters
* Parameters: Up to 10 numeric values (p1 to p10, optional)
* Returns: Numeric median value; -999999999 if no valid numeric parameters
* Usage: lnMedian = CalcMedian(5, 2, 8, 1, 9)  && Returns median of 5 values

FUNCTION Median
    PARAMETERS p1, p2, p3, p4, p5, p6, p7, p8, p9, p10

    * Local array to store valid numeric values
    LOCAL ARRAY laValues[10]
    LOCAL lnCount, lnMedian, i

    * Initialize count of valid values
    lnCount = 0

    * Check each parameter and store valid numeric values
    IF VARTYPE(p1) == 'N' AND !ISNULL(p1)
        lnCount = lnCount + 1
        laValues[lnCount] = p1
    ENDIF
    IF VARTYPE(p2) == 'N' AND !ISNULL(p2)
        lnCount = lnCount + 1
        laValues[lnCount] = p2
    ENDIF
    IF VARTYPE(p3) == 'N' AND !ISNULL(p3)
        lnCount = lnCount + 1
        laValues[lnCount] = p3
    ENDIF
    IF VARTYPE(p4) == 'N' AND !ISNULL(p4)
        lnCount = lnCount + 1
        laValues[lnCount] = p4
    ENDIF
    IF VARTYPE(p5) == 'N' AND !ISNULL(p5)
        lnCount = lnCount + 1
        laValues[lnCount] = p5
    ENDIF
    IF VARTYPE(p6) == 'N' AND !ISNULL(p6)
        lnCount = lnCount + 1
        laValues[lnCount] = p6
    ENDIF
    IF VARTYPE(p7) == 'N' AND !ISNULL(p7)
        lnCount = lnCount + 1
        laValues[lnCount] = p7
    ENDIF
    IF VARTYPE(p8) == 'N' AND !ISNULL(p8)
        lnCount = lnCount + 1
        laValues[lnCount] = p8
    ENDIF
    IF VARTYPE(p9) == 'N' AND !ISNULL(p9)
        lnCount = lnCount + 1
        laValues[lnCount] = p9
    ENDIF
    IF VARTYPE(p10) == 'N' AND !ISNULL(p10)
        lnCount = lnCount + 1
        laValues[lnCount] = p10
    ENDIF

    * Check if there are valid values
    IF lnCount == 0
*        MESSAGEBOX("Error: No valid numeric parameters provided.", 16, "Error")
        RETURN 0  && Error indicator
    ENDIF

    * Resize array to valid values only
    DIMENSION laValues[lnCount]

    * Sort the array in ascending order
    ASORT(laValues)

    * Calculate median
    IF lnCount % 2 == 0
        * Even number of values: average of two middle values
        lnMedian = (laValues[lnCount/2] + laValues[lnCount/2 + 1]) / 2
    ELSE
        * Odd number of values: middle value
        lnMedian = laValues[CEILING(lnCount/2)]
    ENDIF

    RETURN lnMedian
ENDFUNC

FUNCTION Range
    PARAMETERS p1, p2, p3, p4, p5, p6, p7, p8, p9, p10
    
    * Create an array to store non-empty parameters
    LOCAL ARRAY laValues[10]
    LOCAL lnCount, lnMin, lnMax, i
    
    * Initialize count of valid parameters
    lnCount = 0
    
    * Store non-empty parameters in array
    FOR i = 1 TO 10
        lcParam = "p" + TRANSFORM(i)
        IF VARTYPE(&lcParam) == "N"  && Check if parameter is numeric
            lnCount = lnCount + 1
            laValues[lnCount] = EVALUATE(lcParam)
        ENDIF
    ENDFOR
    
    * Check if we have at least 2 values
    IF lnCount < 2
        RETURN .NULL.  && Return NULL if less than 2 values
    ENDIF
    
    * Find minimum and maximum
    lnMin = laValues[1]
    lnMax = laValues[1]
    
    FOR i = 2 TO lnCount
        lnMin = MIN(lnMin, laValues[i])
        lnMax = MAX(lnMax, laValues[i])
    ENDFOR
    
    * Return the range
    RETURN lnMax - lnMin
ENDFUNC


Function LinearRegression 
PARAMETERS lAllMem, lsmdskt
* Program: LinearRegressionWithPlot.prg
* Purpose: Perform linear regression on 'memoryn' field in 'Calc' table and create 'LR' table for plotting
* Assumptions: 'Calc' table has a numeric field 'memoryn'; X is the record number (1, 2, 3, ...)
* Output: Slope, intercept, R-squared, regression equation, and 'LR' table with X, Y points for plotting

* Ensure the Calc table is open
*!*	IF !USED('Calc')
*!*	    USE Calc IN 0
*!*	ENDIF
SELECT Calc

* Initialize variables for calculations
LOCAL lnCount, lnSumX, lnSumY, lnSumXY, lnSumX2, lnSumY2,cfrm
STORE 0 TO lnCount, lnSumX, lnSumY, lnSumXY, lnSumX2, lnSumY2
LOCAL lnMeanX, lnMeanY, lnSlope, lnIntercept, lnRSS, lnTSS, lnR2, ccondx, nrec

* Count records and calculate sums
lnCount = RECCOUNT()
*!*	IF lnCount < 2
*!*	    MESSAGEBOX("Error: At least two data points are required for linear regression.", 16, "Error")
*!*	    RETURN
*!*	ENDIF

* Iterate through records to compute sums
ccondx = IIF(lAllMem,'',oCalc.GetMemScanDomain())
GO TOP
nrec = 1
SCAN &ccondx
    IF ! ISNULL(Calc.memoryn)
        lnSumX = lnSumX + nrec  && X is the record number
        lnSumY = lnSumY + Calc.memoryn
        lnSumXY = lnSumXY + (nrec * Calc.memoryn)
        lnSumX2 = lnSumX2 + (nrec ^ 2)
        lnSumY2 = lnSumY2 + (Calc.memoryn ^ 2)
    ELSE
        MESSAGEBOX("Error: Null data in memory location: " + cAddQuotes(STR(RECNO(), 6, 0)), 16, "Linear Regression Error")
        RETURN .F.
    ENDIF
    nrec = nrec + 1 
ENDSCAN

IF nrec < 3
	DO FORM ShowMsgXS WITH 'Insufficient Data Points to Calc Linear Regression',.F.,'Domain Error'
	RETURN 
ENDIF 

* Calculate means
lnMeanX = lnSumX / lnCount
lnMeanY = lnSumY / lnCount

* Calculate slope (ß1) and intercept (ß0)
lnSlope = (lnSumXY - lnCount * lnMeanX * lnMeanY) / (lnSumX2 - lnCount * lnMeanX^2)
lnIntercept = lnMeanY - lnSlope * lnMeanX

* Calculate R-squared
lnRSS = 0  && Residual Sum of Squares
lnTSS = 0  && Total Sum of Squares
GO TOP
nrec = 1
SCAN &ccondx
    lnPredictedY = lnIntercept + lnSlope * nrec
    lnRSS = lnRSS + (Calc.memoryn - lnPredictedY)^2
    lnTSS = lnTSS + (Calc.memoryn - lnMeanY)^2
    nrec = nrec + 1 
ENDSCAN
lnR2 = 1 - (lnRSS / lnTSS)

* Output results
*!*	? "Linear Regression Results:"
*!*	? "Slope (ß1): ", TRANSFORM(lnSlope, "99.999999")
*!*	? "Intercept (ß0): ", TRANSFORM(lnIntercept, "999.999999")
*!*	? "R-squared: ", TRANSFORM(lnR2, "0.999999")
*!*	? "Regression Equation: Y = ", TRANSFORM(lnIntercept, "999.999999"), " + ", ;
*!*	  TRANSFORM(lnSlope, "99.999999"), " * X"
**MESSAGEBOX(
cfrm = IIF(lsmdskt,'4','3')
 
	DO FORM ShowMessage&cfrm WITH "Linear Regression Data: "+cInQuotes(IIF(lAllMem,'ALL',oCalc.ccelldomainbrief))+'Mem Cells' + CHR(13)+ CHR(13) + ;
	           "Slope: " + ALLTRIM(TRANSFORM(lnSlope, "9999.999999")) + CHR(13) + ;
	           "Intercept: " + ALLTRIM(TRANSFORM(lnIntercept, "999999.999999")) + CHR(13) + ;
	           "R-squared: " + TRANSFORM(lnR2, "0.999999") + CHR(13) + CHR(13) + ;
	           "Equation: Y = " + ALLTRIM(TRANSFORM(lnIntercept, "999999.999999")) + " + " + ;
	           ALLTRIM(TRANSFORM(lnSlope, "9999.999999")) + " * X" + CHR(13) + ;
	           '(Equation is available to paste as copied text)',.T.,.T.
	      
_ClipText =  "Y = " + ALLTRIM(TRANSFORM(lnIntercept, "999999.99999")) + " + " + ;
           TRANSFORM(lnSlope, "99.99999") + " * X"
* Create LR table for plotting
IF ! USED('linregressiondata')
	SELECT 0
    USE linregressiondata
ELSE 
	SELECT linregressiondata
ENDIF
ZAP
SELECT Calc
SCAN &ccondx
	SELECT linregressiondata
	APPEND BLANK 
	REPLACE xaxis WITH ALLTRIM(Calc.Label)+' / '+ALLTrim(STR(RECNO(), 6, 0)), memval WITH Calc.Memoryn
	SELECT Calc 
ENDSCAN 
SELECT linregressiondata
GO Top
* Generate data points over the range of X (1 to lnCount)
LOCAL lnStep, lnX
lnStep = 1  && Step size for X (adjust for smoother or coarser line)
FOR lnX = 1 TO RECCOUNT() STEP lnStep
	GO lnx
    REPLACE linregval WITH lnIntercept + lnSlope * lnx
ENDFOR

* Store regression results in a cursor
*!*	CREATE CURSOR Results (Slope N(10,6), Intercept N(10,6), RSquared N(10,6))
*!*	APPEND BLANK
*!*	REPLACE Slope WITH lnSlope, Intercept WITH lnIntercept, RSquared WITH lnR2
*!*	? "Results stored in cursor 'Results'."
*!*	? "Plotting data stored in table 'LR' with X and Y values for the regression line."
*!*	MESSAGEBOX("Plotting data stored in 'LR' table for X = 1 to " + STR(lnCount, 10, 0), 64, "Plotting Data")
cplotvar(1,1) = 'Memval'
cplotvar(1,2) = 'Memory Value'
cplotvar(2,1) = 'LinRegVal'
cplotvar(2,2) = 'Linear Reg Val'
*!*	ctablename,nvariables,;
*!*				ndefaultgraph,cgraphtitle,cxaxistfieldname,cxaxislabel,;
*!*				cyaxislabel,ldiscreet,cshapelegendExpression,cextra,lbef,lmem
PlotTableVar3('linregressiondata',2,1,cInQuotes(IIF(lAllMem,'ALL',oCalc.ccelldomainbrief))+'Mem / Linear Reg - Eq: '+_ClipText,'Xaxis','Memory Label / X','Mem Value / Lin Reg Value Y',.F.,'Data',.F.,.F.)
SELECT linregressiondata
Use
SELECT Calc
RETURN .T.
ENDPROC 

PROCEDURE GetCalcDomainSubset
LOCAL cdomain
	cdomain = oCalc.getmemscandomain()
	IF USED('CalcSubset')
		SELECT CalcSubset
		USE
	ENDIF 
	SELECT Calc
	COPY STRUCTURE TO CalcSubset
	SELECT 0
	USE CalcSubset
	APPEND FROM Calc &cdomain
ENDPROC 

PROCEDURE CompressMemory
LOCAL nRecsToAdd, ix, nnotdel
	SELECT Calc
	DELETE FOR Memoryn == 0
	PACK
	REPLACE ALL clabelnum WITH RECNO(), cmemloc WITH nvaltostr(RECNO())
	DO WHILE RECCOUNT() < 8
		oCalc.PopulateNewMemset
	ENDDO 
ENDPROC 


PROCEDURE DoBezier
   PARAMETERS nX1, nY1, nX2, nY2, nX3, nY3, nX4, nY4
   * Parameters:
   * nX1, nY1: First control point
   * nX2, nY2: Second control point
   * nX3, nY3: Third control point
   * nX4, nY4: Fourth control point
   * aDensePoints: Array to store dense [x, y] points (passed by reference)
	Public ARRAY aDensePoints[1, 2]
   LOCAL nT, nXCalc, nYCalc, nIndex

   * Initialize array
   nIndex = 0
*   DIMENSION aDensePoints[1, 2]
   aDensePoints[1, 1] = nX1
   aDensePoints[1, 2] = nY1

   * Generate dense points using small delta t
   LOCAL nDeltaT
   nDeltaT = 0.001  && Small t increment for accuracy
   FOR nT = nDeltaT TO 1 STEP nDeltaT
      nXCalc = (1-nT)^3 * nX1 + 3*(1-nT)^2 * nT * nX2 + 3*(1-nT) * nT^2 * nX3 + nT^3 * nX4
      nYCalc = (1-nT)^3 * nY1 + 3*(1-nT)^2 * nT * nY2 + 3*(1-nT) * nT^2 * nY3 + nT^3 * nY4
      nIndex = nIndex + 1
      DIMENSION aDensePoints[nIndex, 2]
      aDensePoints[nIndex, 1] = nXCalc
      aDensePoints[nIndex, 2] = nYCalc
   ENDFOR

   * Add final point
   nIndex = nIndex + 1
   DIMENSION aDensePoints[nIndex, 2]
   aDensePoints[nIndex, 1] = nX4
   aDensePoints[nIndex, 2] = nY4

   RETURN 'aDensePoints'
ENDPROC

FUNCTION GetBezier
   PARAMETERS nX
   * Parameters:
   * nX: Input x value
   * aDensePoints: Array of dense [x, y] points (passed by reference)
   * Returns: y value for given x, or .NULL. if x is out of range

   LOCAL nYResult, nX1Calc, nY1Calc, nX2Calc, nY2Calc, nFrac

   * Initialize
   nYResult = .NULL.

   * Find y using linear interpolation
   FOR i = 1 TO ALEN(aDensePoints, 1) - 1
      nX1Calc = aDensePoints[i, 1]
      nY1Calc = aDensePoints[i, 2]
      nX2Calc = aDensePoints[i + 1, 1]
      nY2Calc = aDensePoints[i + 1, 2]
      IF (nX1Calc <= nX AND nX <= nX2Calc) OR (nX2Calc <= nX AND nX <= nX1Calc)
         nFrac = IIF(nX2Calc != nX1Calc, (nX - nX1Calc) / (nX2Calc - nX1Calc), 0)
         nYResult = nY1Calc + nFrac * (nY2Calc - nY1Calc)
         EXIT
      ENDIF
   ENDFOR

   RETURN nYResult
ENDFUNC

PROCEDURE DoScriptNo
PARAMETERS nscript
LOCAL cPublicVariableName, cAlias
	cAlias = ALIAS()
	SELECT Scripts
	GO udf.nScriptNo 
	TRY 
		cPublicVariableName = EXECSCRIPT(cscript)
	CATCH TO cerror
	ENDTRY 
	IF VARTYPE(cerror) == 'O'
		DO FORM Warning WITH 'Execution Halted -Error Condition',cerror.Message+IIF(EMPTY(SYS(2018)),'',': '+SYS(2018))
		SELECT &cAlias
		RETURN .F.
	ENDIF 
	SELECT &cAlias
	RETURN cPublicVariableName
ENDPROC 


FUNCTION Eq
PARAMETERS nPagex, nvx
LOCAL nvxxx, nRecNox, nvarx, cworkarea
	cworkarea = ALIAS()
	IF ! BETWEEN(nPagex,1,10) OR ! BETWEEN(nvx,1,10)
		Retu(0)
	ENDIF 
	IF ! USED('VariableList2')
		SELECT 0
		USE VariableList2
	ENDIF 
	nRecnox = RECNO('VariableList2')
	SELECT VariableList2
	GO INT(nPagex)
	nvarx = 'nv'+ALLTRIM(STR(nvx,2))
	nvxxx = EVALUATE(nvarx)
	GO nRecnox 
	SELECT &cworkarea
	Retu(nvxxx)
ENDFUNC 

FUNCTION Memx
PARAMETERS nLoc
LOCAL cworkarea
	cworkarea = ALIAS()
	IF Used('Calc')
		Sele Calc
	ELSE
		SELECT &cworkarea
		RETURN 0
	ENDIF 
	IF nLoc > RECCOUNT('Calc') OR nLoc < 1
		SELECT &cworkarea
		RETURN 0
	ENDIF 
	GO nLoc IN Calc
	SELECT &cworkarea
	RETURN Calc.Memoryn
ENDFUNC 

FUNCTION Xmem
PARAMETERS nmval, ndec
LOCAL cworkarea
	cworkarea = ALIAS()
	IF Used('Calc')
		Sele Calc
	ELSE
		RETURN 0
	ENDIF 
	GO Top
	IF VARTYPE(ndec) == 'L'
		LOCATE FOR memoryn == nmval
	ELSE 
		IF ndec < 0
			LOCATE FOR INT(memoryn) == nmval
		ELSE 
			LOCATE FOR ROUND(memoryn,ndec) == ROUND(nmval,ndec)
		ENDIF 
	ENDIF 
	SELECT &cworkarea
	RETURN IIF(FOUND('Calc'),RECNO('Calc'),0)
ENDFUNC 

FUNCTION MemFnAll
PARAMETERS x
ENDFUNC 

FUNCTION HeronArea
PARAMETERS na,nb,nc
LOCAL s
	s = (na+nb+nc)/2
RETURN(SQRT(s*(s-na)*(s-nb)*(s-nc)))
	
FUNCTION LN
PARAMETERS xx
RETURN IIF(xx>0,LOG(xx),xx)

FUNCTION Integer
PARAMETERS xx
Retu(INT(xx))

FUNCTION SQR
PARAMETERS xx
Retu(xx^2)

FUNCTION Cube
PARAMETERS xx
Retu(xx^3)

FUNCTION CubeRoot
PARAMETERS xx
IF xx < 0
	Retu( -(ABS(xx)^(1/3)))
ELSE 
	RETURN ( xx^(1/3))
ENDIF 


FUNCTION THREEXPLUSONE
PARAMETERS nseed
RETURN IIF(nseed % 2 > 0,nseed*3+1,nseed/2)

FUNCTION HAILSTONE
PARAMETERS nseed
RETURN IIF(nseed % 2 > 0,nseed*3+1,nseed/2)

FUNCTION SECANT
PARAMETERS xx
IF COS(xx) == 0
	RETURN 0
ENDIF 
Retu(1/COS(xx))

FUNCTION ASEC
PARAMETERS xx
LOCAL nretval
TRY 
	IF ACOS(1/xx) == 0
		nretval = 0
	ENDIF 
	nretval = ACOS(1/xx)
CATCH
	nretval = 0
	WAIT 'Input value outside of acceptable range' WINDOW TIMEOUT 3 nowait
ENDTRY 
RETURN nretval


FUNCTION CSC
PARAMETERS xx
IF SIN(xx) == 0
	RETURN 0
ENDIF 
RETURN 1/SIN(xx)

FUNCTION ACSC
PARAMETERS xx
IF ASIN(1/xx) == 0
	RETURN 0
ENDIF 
RETURN ASIN(1/xx)

FUNCTION COT
PARAMETERS xx
IF TAN(xx) == 0
	RETURN 0
ENDIF 
RETURN 1/TAN(xx)

FUNCTION ACOT
PARAMETERS xx
IF ATAN(1/xx) == 0
	RETURN 0
ENDIF 
RETURN ATAN(1/xx)

FUNCTION SECD
PARAMETERS xx
Retu(1/COS(DTOR(xx)))

FUNCTION CSCD
PARAMETERS xx
RETURN 1/SIN(DTOR(xx))

FUNCTION COTD
PARAMETERS xx
RETURN 1/TAN(DTOR(xx))

FUNCTION SINH
PARAMETERS xv
Retu( (EXP(xv)-EXP(-xv))/2)

FUNCTION ASINH
PARAMETERS xv
*ln[x + v(x2 + 1)]
RETURN  LOG(xv+SQRT(xv*xv+1))

FUNCTION COSH
PARAMETERS xv
Retu( (EXP(xv)+EXP(-xv))/2)

FUNCTION ACOSH
PARAMETERS xv
RETURN  LOG(xv+SQRT(xv*xv-1))

FUNCTION TANH
PARAMETERS xv
* [ex – e-x] / [ex + e-x]
LOCAL tr1, tr2
	tr1 = EXP(xv)
	tr2 = EXP(-xv)
RETURN (tr1-tr2)/(tr1+tr2)

FUNCTION ATANH
PARAMETERS xv
IF xv == 1
	RETURN 0
ENDIF 
RETURN  (LOG((1+xv)/(1-xv)))/2

FUNCTION COTH
PARAMETERS xv
LOCAL tr1, tr2
	tr1 = EXP(xv)
	tr2 = EXP(-xv)
	IF tr1-tr2 == 0
		RETURN 0
	ENDIF 
RETURN (tr1+tr2)/(tr1-tr2)

FUNCTION ACOTH
PARAMETERS xv
IF xv == 1
	RETURN 0
ENDIF
*½ ln[(x + 1)/(x – 1)]
RETURN LOG((xv+1)/(xv-1))/2

FUNCTION SECH
PARAMETERS xv
RETURN 1/COSH(xv)

FUNCTION ASECH
PARAMETERS xv
IF xv == 0
	RETURN 0
ENDIF 
*ln[(1 + v(1 – x2)/x]
RETURN LOG((1 + SQRT(1-xv*xv))/xv)

FUNCTION CSCH
PARAMETERS xv
LOCAL tr1, tr2
	tr1 = EXP(xv)
	tr2 = EXP(-xv)
IF tr1-tr2 == 0
	RETURN 0
ENDIF 
RETURN 1/SINH(xv)

FUNCTION ACSCH
PARAMETERS xv
IF xv == 0
	RETURN 0
ENDIF 
*ln[(1 + v(x2 + 1)/x]
RETURN LOG(1/xv + SQRT((1/(xv*xv))+1))

FUNCTION DMStodecimal
PARAMETERS cdmsval,lradians
LOCAL ndeg,nmin,nsec,nfirstperiod,nsecperiod,nmult, nminsec
	nsecperiod = AT('.',cdmsval,2)
	nfirstperiod = AT('.',cdmsval,1)
	cdmsval = STRTRAN(cdmsval,' ','')
	nmult = IIF(RIGHT(cdmsval,1) $ 'SW',-1,1)
	ndeg = VAL(LEFT(cdmsval,nfirstperiod-1))
	nmin = VAL(SUBSTR(cdmsval,nfirstperiod+1,2))/60
	nsec = VAL(Substr(cdmsval,nsecperiod+1,2))/3600
	nminsec = ROUND(nmin+nsec,3)
Retu(nmult*IIF(lradians,DTOR(ndeg+nminsec),ndeg+nminsec))

FUNCTION DecDegtodms
PARAMETERS ndecdeg, llat
PUBLIC cvx(4)
LOCAL ndecpart, ndegpart, nminpart, nsecpart
	cvx(4) = IIF(ndecdeg<0,1,2)
	ndecdeg = ABS(ndecdeg)
	ndegpart = INT(ndecdeg)
*	 nLatMinutes = INT((lLatitude - nLatDegrees) * 60)
	nminpart = INT((ndecdeg-ndegpart)*60)
	nsecpart = ROUND(((ndecdeg - ndegpart) * 60 - nminpart) * 60,0)
	cvx(1) = STRTRAN(STR(ndegpart,IIF(llat,2,3)),' ','0')
	IF LEFT(cvx(1),1) == '0'
		cvx(1) = RIGHT(cvx(1),LEN(cvx(1))-1)
	ENDIF
	cvx(2) = STRTRAN(STR(nminpart,2),' ','0')
	cvx(3) = STRTRAN(STR(nsecpart,2),' ','0')
	RETURN .T.
ENDFUNC 


FUNCTION LLDIST
PARAMETERS clat_1, clong1, clat_2, clong2
LOCAL Phi_1, Phi_2, Deltaphi, DeltaLambda, lna, lnc, nr
	nr = 3958.7558657440545 &&Radius of earth in miles
	Phi_1 = DTOR(clat_1)
	Phi_2 = DTOR(clat_2)
	Deltaphi = (Phi_2-Phi_1)
	DeltaLambda = DTOR(clong2) - DTOR(clong1)

	lna = SIN(DeltaPhi/2)**2 + COS(Phi_1)*COS(Phi_2)* SIN(deltaLambda/2)**2
	lnc = 2*ATN2(SQRT(lna),SQRT(1-lna))
Retu(nr * lnc)
*!*	a = math.sin(delta_phi / 2.0) ** 2 + math.cos(phi_1) * math.cos(phi_2) * math.sin(delta_lambda / 2.0) ** 2
*!*	    
*!*	    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
FUNCTION LLDISTKM
PARAMETERS clat_1, clong1, clat_2, clong2
Retu(Convert(5,LLDIST(clat_1, clong1, clat_2, clong2)))

PROCEDURE TransferValToCalc
PARAMETERS nValToTransfer,cpapertapecap
LOCAL lstp, decstr
IF VARTYPE(oCalc) == 'O'
	WITH oCalc
*		decstr = IIF(lminus1,RIGHT(.DecimalStr,LEN(.DecimalStr)-1),.DecimalStr)
		.SaveRestoreVal
		.ValueStack(.ValLevel,2) = nValToTransfer
		.ValueStack(.ValLevel,3) = .Mode
		.ValueStack(.Vallevel,1) =  ICASE(.Mode=='B',DECTOBINc(.ValueStack(.Vallevel,2)),.Mode=='D',.ValxtoStr(nValToTransfer),;
								.Mode=='T',.nmintochrmin(.ValueStack(.Vallevel,2)))
		.AssignValueStackToPreconvertedValues
		.SetValConvertedTrue
		.EnableClr(.T.)
		.EnabledCE()
		.EnableBack(.F.)
		lstp = .SaveToPaperTape 
		.SaveToPaperTape = .F.
		.ShowValue(.ValLevel)
*!*			.UnaryOperator('PM')
*!*			.UnaryOperator('PM')
		.SaveToPaperTape = lstp
* WAIT cpapertapecap window
		.WriteNewCalcLine
		.WriteToPaperTape(ALLTRIM(cpapertapecap)+.FormatResultForPT(.Vallevel),.F.,.T.)
		.equalpressed = .F.
		.Enablefn(.ValueStack(.ValLevel,2))
*		.WriteToPaperTape(,.F.,.T.)
	ENDWITH 
ENDIF
ENDPROC 

FUNCTION cRemoveTrailingZeros
PARAMETERS clinex
LOCAL i, icomma, cvalx, ilastcomma, cresult, nlastval
	ilastcomma = 0
	cresult = ''
	nlastval = OCCURS(',',clinex)+1
	FOR i = 1 TO nlastval
		icomma = AT(',',clinex,i)
		IF icomma == 0
			cvalx = ALLTRIM(SUBSTR(clinex,ilastcomma+1,15))
		ELSE 
			cvalx = ALLTRIM(SUBSTR(clinex,ilastcomma+1,icomma-ilastcomma-1))
		ENDIF 
		cresult = cresult+cRTZ(cvalx)+IIF(i#nlastval,',','')
		ilastcomma = icomma 
	ENDFOR 
RETURN cresult

FUNCTION cRTZ
PARAMETERS cvx
	DO WHILE RIGHT(cvx,1) == '0'
		cvx = LEFT(cvx,LEN(cvx)-1)
	ENDDO 
RETURN cvx 

FUNCTION cGetHexValue
PARAMETERS cvx
LOCAL ix, cdigit, ndigit, nvalue, nmultiplyer
	ndigit = 0
	nvalue = 0
	cvx = UPPER(ALLTRIM(cvx))
	IF RIGHT(cvx,1) == 'H'
		cvx = LEFT(cvx,LEN(cvx)-1)
	ENDIF 
	IF LEFT(cvx,1) == '-'
		cvx = RIGHT(cvx,LEN(cvx)-1)
	ENDIF 
	FOR ix = LEN(cvx) TO 1 STEP -1
		cdigit = SUBSTR(cvx,ix,1)
		IF cdigit $ '0123456789ABCDEF'
			nmultiplyer = AT(cdigit,'0123456789ABCDEF')-1
			nvalue = nvalue + 16^ndigit*nmultiplyer
			ndigit = ndigit + 1 
		ENDIF 
	ENDFOR 
RETURN nvalue

FUNCTION lIsDecimalStr
PARAMETERS cvx
LOCAL ix
	cvx = UPPER(ALLTRIM(cvx))
	IF RIGHT(cvx,1) == 'D'
		cvx = LEFT(cvx,LEN(cvx)-1)
	ENDIF 
	IF RIGHT(cvx,1) == 'H'
		RETURN .F.
	ENDIF 
	FOR ix = 1 TO LEN(cvx)
		IF ! ISDIGIT(SUBSTR(cvx,ix,1))
			RETURN .F.
		ENDIF 
	ENDFOR 
RETURN .T.

FUNCTION lIsHexStr
PARAMETERS cvx
LOCAL ix
	cvx = UPPER(ALLTRIM(cvx))
	IF RIGHT(cvx,1) == 'D'
		RETURN .F.
	ENDIF 
	IF RIGHT(cvx,1) == 'H'
		cvx = LEFT(cvx,LEN(cvx)-1)
	ENDIF 
	IF LEFT(cvx,1) == '-'
		cvx = RIGHT(cvx,LEN(cvx)-1)
	ENDIF 

	FOR ix = 1 TO LEN(cvx)
		IF ! SUBSTR(chexstr,ix,1) $ '0123456789ABCDEF'
			RETURN .F.
		ENDIF 
	ENDFOR 
RETURN .T.

FUNCTION OpenFile
PARAMETERS cfilename
	cfilename = ALLTRIM(cfilename)
	IF FILE(cfilename)
		nFileHandle = FOPEN(cfilename)
	ELSE
		nFileHandle = - 1
	ENDIF 
RETURN nFileHandle

FUNCTION cGetNextFileLine
PARAMETERS nFileHandle
IF ! FEOF(nFileHandle)
	RETURN cRemoveSpaces(FGETS(nFileHandle))
ELSE 
	RETURN '##EOF'
ENDIF 
ENDFUNC 

&& 2024-03-09T20:58:03
FUNCTION cDispDateTimeSec
PARAMETERS cdtxml
LOCAL cmx, cdxx, cyrx,ctimex
ctimex = RIGHT(cdtxml,8)
cmx = SUBSTR(cdtxml,6,2)
cyrx = LEFT(cdtxml,4)
cdxx = SUBSTR(cdtxml,9,2)
RETURN cmx+'/'+cdxx+'/'+cyrx+'::'+ctimex

FUNCTION cCreateThreeLetterID
PARAMETERS cPhrase
LOCAL ii, cID(3), nidndx, cVowels, cThisChr, cConsonants, nfirstvowel
	IF LEN(cPhrase) < 4
		Retu(PADC(cPhrase,3,'X'))
	ENDIF 
	cVowels = ''
	cConsonants = ''
	nidndx = 0
	nfirstvowel = 0
	cPhrase = STRTRAN(UPPER(cPhrase),' ','',1,5)
	FOR ii = 1 TO LEN(cPhrase)
		cThisChr = SUBSTR(cPhrase,ii,1)
		IF cThisChr $ 'AEIOU'
			cVowels = cVowels + cThisChr
			IF LEN(cVowels) == 1
				nfirstvowel = ii
			ENDIF 
		ELSE
			cConsonants = cConsonants + cThisChr
		ENDIF 
	ENDFOR
	IF ! EMPTY(cVowels)
	
		IF LEN(cConsonants) > 1
			IF nfirstvowel > 2
				nidndx = nidndx + 1 
				cId(nidndx) = LEFT(cConsonants,2)+LEFT(cVowels,1)
				nidndx = nidndx + 1 
				cId(nidndx) = LEFT(cConsonants,1)+LEFT(cVowels,1)+Right(cConsonants,1)
				nidndx = nidndx + 1 
				cId(nidndx) = LEFT(cConsonants,2)+Right(cConsonants,1)
			ELSE 
				IF nfirstvowel == 1
					nidndx = nidndx + 1 
					cId(nidndx) = LEFT(cPhrase,3)
					nidndx = nidndx + 1 
					cId(nidndx) = LEFT(cPhrase,2)+Right(cConsonants,1)
					nidndx = nidndx + 1 
					cId(nidndx) = LEFT(cPhrase,1)+RIGHT(cPhrase,2)

				ELSE 
					nidndx = nidndx + 1 
					cId(nidndx) = LEFT(cPhrase,3)
					nidndx = nidndx + 1
					IF LEN(cConsonants) > 3
						IF LEN(cConsonants) > 5
							cId(nidndx) = LEFT(cConsonants,1) +SUBSTR(cConsonants,3,1)+ RIGHT(cPhrase,1)
							nidndx = nidndx + 1
							cId(nidndx) = LEFT(cConsonants,1) + +SUBSTR(cConsonants,2,1)+ RIGHT(cPhrase,1)
						ELSE
							cId(nidndx) = LEFT(cConsonants,1)+Right(cConsonants,2)
							IF LEN(cId(nidndx)) == 2
								cId(nidndx) = cId(nidndx)+RIGHT(cVowels,1)
							ENDIF 
							nidndx = nidndx + 1
							cId(nidndx) = LEFT(cPhrase,2)+RIGHT(cPhrase,1)
							cId(nidndx) = LEFT(cConsonants,1)+SUBSTR(cConsonants,2,1)+IIF(LEN(cConsonants)==2,RIGHT(cVowels,1),Right(cConsonants,1))
							IF cId(1) == cid(3)
								cid(3) = LEFT(cid(3),2)+SUBSTR(cConsonants,LEN(cConsonants)-1,1)
							ENDIF 
						ENDIF 
					ELSE 
						cId(nidndx) = LEFT(cConsonants,3)
						IF LEN(cId(nidndx)) == 2
							cId(nidndx) = cId(nidndx) + RIGHT(cVowels,1)
						ENDIF 
						nidndx = nidndx + 1 
						cId(nidndx) = LEFT(cPhrase,2)+RIGHT(cPhrase,1)
					ENDIF 
				ENDIF 			
			ENDIF 
		ELSE  
			IF LEN(cConsonants) > 2
				IF LEN(cConsonants) > 4
					nidndx = nidndx + 1 
					cId(nidndx) = LEFT(cConsonants,1) + SUBSTR(cConsonants,3,1) + RIGHT(cConsonants,1)
					nidndx = nidndx + 1 
					IF LEN(cVowels) > 0
						IF nFirstVowel == 1 OR nFirstVowel == 2
							cId(nidndx) = LEFT(cPhrase,2)+RIGHT(cPhrase,1)
						ELSE
							nidndx = nidndx + 1 
							cId(nidndx) =LEFT(cConsonants,1)+ LEFT(cVowels,1)+RIGHT(cConsonants,1)
						ENDIF 
					ELSE 
						cId(nidndx) = LEFT(cConsonants,2) +RIGHT(cConsonants,1)
					ENDIF 
				ELSE 
					nidndx = nidndx + 1 
					cId(nidndx) = LEFT(cConsonants,3)
					IF LEN(cConsonants) > 3
						nidndx = nidndx + 1 
						IF LEFT(cConsonants,2) = 'PH'
							cId(nidndx) = 'PH'+RIGHT(cConsonants,1)
						ELSE 
							cId(nidndx) = LEFT(cConsonants,1)+right(cConsonants,2) &&+RIGHT(cVowels,1)
						ENDIF 
					ELSE 
						nidndx = nidndx + 1 
						IF LEFT(cConsonants,2) = 'PH'
							cId(nidndx) = 'PH'+RIGHT(cConsonants,1)
						ELSE 
							cId(nidndx) = LEFT(cConsonants,1)+RIGHT(cConsonants,1)+RIGHT(cVowels,1)
						ENDIF 
					ENDIF 
				ENDIF 
			ELSE 
				nidndx = nidndx + 1 
				cId(nidndx) = cConsonants+RIGHT(cVowels,1)			
			ENDIF 
		ENDIF 
	ELSE 
		nidndx = nidndx + 1 
		cId(nidndx) = LEFT(cConsonants,3)
		nidndx = nidndx + 1 
		cId(nidndx) = LEFT(cConsonants,2)+RIGHT(cConsonants,1)
		nidndx = nidndx + 1
		cId(nidndx) = LEFT(cConsonants,1)+RIGHT(cConsonants,2)
	ENDIF  
	Retu(cId(1)+','+cID(2)+','+cID(3))
ENDFUNC 

FUNCTION CBINTODEC
PARAMETERS cxv
LOCAL ix, cdecvalue, kx ,idxx, cvx, cxvv
*WAIT cxv window
cxv = ALLTRIM(cxv)
idxx = AT('.',cxv)
*WAIT idxx window
IF idxx > 0
	cxv = LEFT(cxv,idxx-1)
ENDIF 
cxvv = ''
FOR ix = 1 TO LEN(cxv)
	IF Substr(cxv,ix,1) == ','
		LOOP
	ELSE 
		cxvv = cxvv + SUBSTR(cxv,ix,1)
	ENDIF 
ENDFOR 
*WAIT cxvv window
cdecvalue = 0
kx = LEN(cxvv) 
FOR ix = 1 to LEN(cxvv)
	cvx = SUBSTR(cxvv,ix,1)
	IF ! INLIST(cvx,'0','1')
		RETURN 0
	ELSE 
		cdecvalue = cdecvalue + IIF(cvx=='1',2^(kx-1),0)
		kx = kx - 1 
	ENDIF 
ENDFOR 
*WAIT cdecvalue window
RETURN cdecvalue

FUNCTION LISPRIME
PARAMETERS xv
LOCAL cworkarea, lfound
	cworkarea = ALIAS()
	SELECT Primes
	Seek xv
	lfound = FOUND()
	SELECT &cworkarea
	RETURN IIF(lfound,1,0)
ENDFUNC 

FUNCTION RotateString
LPARAMETERS lcInputString, lnDigitsToRotate, lleft  && lcDirection: "left" or "right"

LOCAL lcRotatedString

	IF EMPTY(lcInputString) &&OR !ISALNUM(lcInputString)
	    RETURN ""  && Input string must not be empty and must contain only alphanumeric characters
	ENDIF
	IF RIGHT(lcInputString,1) $ 'DH'
		lcInputString = LEFT(lcInputString,LEN(lcInputString)-1)
	ENDIF 
	lnInputLength = LEN(lcInputString)
	lnDigitsToRotate = MOD(lnDigitsToRotate, lnInputLength)  && Ensure rotation is within the string length

	IF lleft
	    lcRotatedString = SUBSTR(lcInputString, lnDigitsToRotate + 1) + ;
	                      SUBSTR(lcInputString, 1, lnDigitsToRotate)
	ELSE
	    lnRotatedIndex = lnInputLength - lnDigitsToRotate
	    lcRotatedString = SUBSTR(lcInputString, lnRotatedIndex + 1) + ;
	                      SUBSTR(lcInputString, 1, lnRotatedIndex)
	ENDIF 
RETURN lcRotatedString
ENDFUNC 


FUNCTION nRotate
PARAMETERS nvx, ndigits,lleft
LOCAL cvx
	cvx = RotateString(IIF(IsBinary(nvx),INTSTR(nvx),DECTOBINc(nvx)),ndigits,lleft)
RETURN INT(VAL(cvx))
ENDFUNC 

FUNCTION IsHexStr
PARAMETERS chexstr
LOCAL ix
	FOR ix = 1 TO LEN(chexstr)
		IF ! SUBSTR(chexstr,ix,1) $ '0123456789ABCDEF'
			RETURN .F.
		ENDIF 
	ENDFOR 
RETURN .T.

FUNCTION IsBinaryStr
PARAMETERS cstrx
LOCAL ix
	FOR ix = 1 TO LEN(cstrx)
		IF ! SUBSTR(cstrx,ix,1) $ '01'
			RETURN .F.
		ENDIF 
	ENDFOR 
RETURN .T.

FUNCTION IsBinary
PARAMETERS nvx
LOCAL cvx, ix
cvx = IntStr(nvx)
	FOR ix = 1 TO LEN(cvx)
		IF ! SUBSTR(cvx,ix,1) $ '01'
			RETURN .F.
		ENDIF 
	ENDFOR 
RETURN .T.

FUNCTION cBitNot
PARAMETERS cbinx
LOCAL ix, cbnx
cbnx = ''
FOR ix = 1 TO LEN(cbinx)
	cbnx = cbnx + IIF(SUBSTR(cbinx,ix,1)=='1','0','1')
ENDFOR 
*!*	DO WHILE LEFT(cbnx,1) == '0'
*!*		cnbx = RIGHT(cbnx,LEN(cbnx)-1)
*!*	ENDDO 
RETURN cbnx

FUNCTION cBinToDec
PARAMETERS cstr
LOCAL cxv, ix, cdecvalue, cvx, kx ,idxx
kx = LEN(cstr)
cdecvalue = 0
FOR ix = 1 to kx
	cvx = SUBSTR(cstr,ix,1)
	IF ! INLIST(cstr,'0','1')
		RETURN 0
	ELSE 
		cdecvalue = cdecvalue + IIF(cvx=='1',2^(kx-1),0)
		kx = kx - 1 
	ENDIF 
ENDFOR 
RETURN cdecvalue

FUNCTION BINTODEC
PARAMETERS xv
*WAIT xv window
LOCAL cxv, ix, cdecvalue, cvx, kx ,idxx
IF VARTYPE(xv)=='N'
	cxv = ALLTRIM(STR(xv,50,0))
ELSE
	cxv = xv
ENDIF 
*WAIT cxv window
idxx = AT('.',cxv) 
*WAIT idxx window
IF idxx > 0 
	IF '+' $ cxv
		cxv = LEFT(cxv,AT('+',cxv)-2)
*WAIT cxv window
	ELSE 
		cxv = LEFT(cxv,idxx-1)
	ENDIF 
ENDIF 
*WAIT cxv window
cdecvalue = 0
kx = LEN(cxv) 
*WAIT kx window
FOR ix = 1 to LEN(cxv) 
	cvx = SUBSTR(cxv,ix,1)
	IF ! INLIST(cvx,'0','1','.')
		RETURN 0
	ELSE 
		cdecvalue = cdecvalue + IIF(cvx=='1',2^(kx-1),0)
		kx = kx - 1 
	ENDIF 
ENDFOR 
RETURN cdecvalue

FUNCTION DECTOBIN
PARAMETERS xv
IF VARTYPE(xv) == 'L'
	RETURN IIF(xv,1,0)
ENDIF 
Retu(INT(VAL(DECTOBINc(xv))))

FUNCTION DECTOBINc
PARAMETERS cxv
LOCAL ix, Bin(40), cbinx, kx
ix = 1
cbinx = ''
IF VARTYPE(cxv) == 'L'
	xv = IIF(cxv,1,0)
ELSE 
	IF VARTYPE(cxv) == 'N'
		xv = cxv
	ELSE 
		xv = INT(VAL(cxv))
	ENDIF 
ENDIF 
DO WHILE xv/2 != 0
	Bin(ix) = STR(xv % 2,1)
	xv = INT(xv/2)
	ix = ix + 1 
ENDDO 
FOR kx = ix-1 TO 1 STEP -1
	cbinx = cbinx + Bin(kx)
ENDFOR 
*WAIT cbinx window
Retu(cbinx)

FUNCTION SanitizeBinary
PARAMETERS cbinx
Retu(SUBSTR(cbinx,AT('1',cbinx),24))

FUNCTION DecimalToHex
LPARAMETERS lnBinaryValue

LOCAL lcHexStr, lnTemp
IF lnBinaryValue < 0
	lnBinaryValue = -lnBinaryValue
ENDIF 
lcHexStr = ""
DO WHILE lnBinaryValue > 0
    lnTemp = MOD(lnBinaryValue, 16)
    lnBinaryValue = INT(lnBinaryValue / 16)
    lcHexStr = IIF(lnTemp < 10, CHR(48 + lnTemp), CHR(55 + lnTemp)) + lcHexStr
ENDDO
RETURN lcHexStr

*!*	FUNCTION BinaryToHex
*!*	LPARAMETERS lnBinaryValue

*!*	RETURN TRANSFORM(lnBinaryValue, "@0x")



PROCEDURE StopScriptCmdShow
	oSciFm.StopScript.Visible = .T.
ENDPROC

PROCEDURE StopScript
	oSciFm.StopScript.Click
endproc

FUNCTION FACTORIAL
PARAMETERS nxf
LOCAL nres
IF nxf == 0
	Retu(1)
ENDIF 
IF nxf == 1
	Retu(1)
ENDIF 
nres = 1
IF nxf > 30
	WAIT 'Max Factorial is 30' WINDOW TIMEOUT 2
	RETURN nxf
ENDIF 
FOR i = 2 TO nxf
	nres = nres*i
ENDFOR
RETURN nres 

FUNCTION FAC
PARAMETERS xn
Retu(Factorial(xn))

FUNCTION HailstoneNumber
PARAMETERS x
x = ROUND(x,0)
LOCAL y,z
	y = 5
	z = 0
	DO WHILE y > 1
		y = IIF(x % 2 > 0,x*3+1,x/2) 
		x = y
		z = z + 1 
	ENDDO 
Retu(z)

FUNCTION MaxHailStone
PARAMETERS x, nmax
LOCAL nz
DO WHILE HailstoneNumber(x) <= nmax
	x = x + 1 
ENDDO 
RETURN x
ENDFUNC 

	

FUNCTION HSN
PARAMETERS x
Retu(HailstoneNumber(x))


FUNCTION GetMinMathTable
PARAMETERS Lnx
LOCAL nmax, nxx, nrecmax 
	nmax = 0
	SELECT MathTable
	GO Top
	SCAN
		IF Lnx
			nmax = MIN(nmax,nx)
			IF nmax == nx
*				nxx = nx
				nrecmax = RECNO()
			ENDIF 
		ELSE
			nmax = MIN(nmax,ny)
			IF nmax == ny
*				nxx = nx
				nrecmax = RECNO()
			ENDIF 
		ENDIF 
	ENDSCAN 
RETURN nrecmax

FUNCTION Primen
PARAMETERS n
LOCAL cAlias
	cAlias = ALIAS()
	n = INT(n)
	IF BETWEEN(n,1,5000000)
		GO INT(n) IN 'Primes'
		SELECT &cAlias
		RETURN Primes.Prime
	ELSE 
		RETURN 0
	ENDIF 
ENDFUNC 
	
FUNCTION IsPrime
PARAMETERS nx, lshow
LOCAL cworkarea, nretval, cwhere, nxval, cxval
	cworkarea = ALIAS()
	SELECT Primes
	nxval = ROUND(ABS(nx),0)
	Seek nxval
	nretval = FOUND()
	IF ! EMPTY(cworkarea)
		SELECT &cworkarea
	ENDIF 
*	cwhere = 'WINDOW '+IIF(VARTYPE(nr) == 'N',' AT '+TRIM(STR(nr,3))+','+TRIM(STR(nc,3)),'')
	cxval = ALLTRIM(STR(nxval))
	IF oCalc.Check11.Value
		cxval = AddCommas(cxval)
	ENDIF 
	IF lshow
		DO FORM ShowMsgwinxs with cAddQuotes(cxval)+IIF(nretval,' IS',' IS NOT')+' Prime','','Prime Result'
	ELSE 
		RETURN IIF(FOUND('Primes'),1,0)
	ENDIF 
ENDFUNC 
	

FUNCTION GETPRIME
PARAMETERS xv
LOCAL cworkarea, nseed
	cworkarea = ALIAS()
	SELECT Primes
	SET NEAR ON
	GO Bott
	nseed = prime
	GO Top
	IF xv <= 0
		xv = RandBtwn(nseed)
	ENDIF 
	SEEK xv
	IF FOUND() AND RECNO() > 1
		SKIP -1
	ELSE 
		IF RECCOUNT() > 0 AND RECNO() != RECCOUNT()
			SKIP -1
		ENDIF
	ENDIF 
	xv = prime
	IF ! EMPTY(cworkarea)
		SELECT &cworkarea
	ENDIF 
	RETURN xv
ENDFUNC

FUNCTION CV
RETURN 299792458 

FUNCTION PRIME
PARAMETERS xp
RETURN PRIMEN(xp)
ENDFUNC 

FUNCTION RemoveCommas
PARAMETERS cvalx
LOCAL cnewval ,iix
	IF AT(',',cvalx)>0
		cnewval = ''
		FOR iix = 1 TO LEN(cvalx)
			IF SUBSTR(cvalx,iix,1) # ','
				cnewval = cnewval + SUBSTR(cvalx,iix,1)
			ENDIF 
		ENDFOR 
		RETURN cnewval
	ELSE
		Retu(cvalx)
	ENDIF 
ENDFUNC 

FUNCTION CheckSciFnOpen
RETURN VARTYPE(oSciFm) == 'O'

FUNCTION EnableButton
PARAMETERS oBtn, oVarx, lEnablex, nbutt
IF VARTYPE(oVarx) == 'O'
	oBtn.BackColor = IIF(lEnablex,RGB(45,174,244),RGB(0,255,0))
*	IF VARTYPE(oSciFm) == 'O'
		WITH oSciFm.Pageframe1.Page1
			DO Case
				CASE nbutt == 1
					.Closepmt.Visible = ! lEnablex
				CASE nbutt == 2
					.CloseFV.Visible = ! lEnablex
				CASE nbutt == 3
					.ClosePVA.Visible = ! lEnablex
				CASE nbutt == 4
					.CloseLAF.Visible = ! lEnablex
				CASE nbutt == 5
					.CloseNPV.Visible = ! lEnablex
				CASE nbutt == 6
					.CloseFVPI.Visible = ! lEnablex
			ENDCASE 
		ENDWITH 
*	ENDIF 
ENDIF 

FUNCTION GetValidMatrix2Sizes
    LPARAMETERS n, p

    LOCAL validSizes[10]
    LOCAL n2, p2, count

    count = 0

    FOR n2 = 1 TO n
        FOR p2 = 1 TO p
            IF p2 = n2
                count = count + 1
                validSizes(count) = STR(n2,1)+'x'+STR(p2,1)
            ENDIF
        ENDFOR
    ENDFOR
* ? count
	FOR i = 1 TO count
		? validSizes(i)
	ENDFOR 
    RETURN validSizes
ENDFUNC

Function BrowseInWindow
PARAMETERS cfilenamex
*WAIT 'we are in browse' WINDOW TIMEOUT 5
	IF VARTYPE(cfilenamex)== 'L' OR OpenTable(cfilenamex)
		IF ! WEXIST('BrowDispWin')
			DEFINE WINDOW BrowDispWin FROM 3,3 TO 50,150 IN desktop close float GROW HALFHEIGHT SYSTEM ICON FILE 'gen.ico' TITLE 'Browse Window' NAME oBrowseWindow
		ENDIF 
		ACTIVATE WINDOW BrowDispWin 
		IF WVISIBLE('BrowDispWin')
			BROWSE IN WINDOW BrowDispWin NOMENU 
		ELSE 
			_Screen.Left = 3
			_Screen.Top = 3
			_Screen.Height = 400
			_Screen.Width = 600
			_Screen.Visible = .T.
			SET SYSMENU OFF
			BROWSE IN WINDOW BrowDispWin NOMENU NORMAL
*			BROWSE IN Screen
			_Screen.Visible = .F.
			SET SYSMENU ON
			_Screen.WindowType = 0
		ENDIF 
*		KEYBOARD "{ENTER}"
		DEACTIVATE WINDOW BrowDispWin
		RELEASE WINDOW BrowDispWin
		RETURN .T.
	ELSE 
*WAIT 'File not found' WINDOW TIMEOUT 5
		RETURN .F.
	ENDIF 
ENDPROC 

PROCEDURE BrowseInWindow
DEFINE WINDOW browsewindow FROM 3,3 TO 50,140 IN desktop close float GROW HALFHEIGHT system ICON FILE 'gen.ico' TITLE 'Browse Data Window' NAME oRepWindow
ACTIVATE WINDOW browsewindow
SET SYSMENU OFF
_Screen.WindowState = 2
_Screen.AlwaysOnTop = .T.
_Screen.ControlBox = .F.
SET SYSMENU OFF
_Screen.Visible = .T. 
_Screen.AlwaysOnTop = .F.
BROWSE && IN WINDOW browsewindow
_Screen.Visible = .F.
_Screen.ControlBox = .T.
SET SYSMENU ON
RELEASE WINDOWS browsewindow
ENDPROC 

PROCEDURE DoThisReport
PARAMETERS cReportx,lhtml,lrange, lpreview, lrep90
LOCAL cFilename, cpreview
*!*	PUBLIC csaveddbf
*!*	csavedbf = ALIAS()
cFilename = 'C:\SoftmicaCalcReports\'+creportx+DTOC(DATETIME())
DEFINE WINDOW repwindow FROM 7,5 TO 50,150 IN desktop close float GROW HALFHEIGHT system ICON FILE 'gen.ico' TITLE 'Report Preview' NAME oRepWindow
*ACTIVATE WINDOW repwindow
_Screen.WindowState = 2
_Screen.Caption = 'SoftmicCalc Print'
_Screen.AlwaysOnTop = .T.
_Screen.ControlBox = .F.
SET SYSMENU OFF
_Screen.Visible = .T. 
_Screen.AlwaysOnTop = .F.
cpreview = IIF(lpreview,'PREVIEW WINDOW RepWindow','')
IF lrep90
	SET REPORTBEHAVIOR 90
ELSE 
	SET REPORTBEHAVIOR 80 
ENDIF 
IF lhtml
	IF lrange
		REPORT FORM &cReportx TO File &cFilename  OBJECT TYPE 5 RANGE 1,1
	ELSE 
		REPORT FORM &cReportx TO File &cFilename  OBJECT TYPE 5
	ENDIF 
ELSE 
	IF lrange
		REPORT FORM &cReportx RANGE 1,1 &cpreview TO PRINTER PROMPT NOCONSOLE
	ELSE
*WAIT 'we are here ' window 
		REPORT FORM &cReportx PREVIEW WINDOW RepWindow TO PRINTER PROMPT NOCONSOLE
	ENDIF 
ENDIF 

_Screen.Visible = .F.
_Screen.ControlBox = .T.
SET SYSMENU ON
RELEASE WINDOWS repwindow

*oRepWindow.Release

FUNCTION StripCommas
PARAMETERS cInstr
RETURN STRTRAN(ALLTRIM(cInstr),',','')

FUNCTION AddCommas
PARAMETERS cInstr
LOCAL cOutStr, laddneg
	IF LEFT(cInstr,1) == '-'
		cInstr = RIGHT(cInstr,LEN(cInstr)-1)
		laddneg = .T. 
	ENDIF 
	cOutStr = ''
	IF LEN(cInstr) <= 3 
		RETURN IIF(laddneg,'-','')+cInstr
	ENDIF 
	DO WHILE LEN(cInstr) > 3
		cOutStr = ','+RIGHT(cInstr,3)+cOutStr
		cInstr = SUBSTR(cInstr,1,LEN(cInstr)-3)
	ENDDO 
	RETURN IIF(laddneg,'-','')+IIF(LEN(cInstr)>0,cInstr,'')+cOutStr
ENDFUNC 
		
FUNCTION CommaFormat(cInput AS STRING) AS STRING
  LOCAL lcOutput AS STRING, lnDecimal AS INTEGER, lcDecimal AS STRING, llNegative AS LOGICAL
  
  * Determine if the input is negative
  llNegative = (LEFT(cInput, 1) = "-")
  
  * Remove the negative sign from the input if it exists
  IF llNegative THEN
    cInput = SUBSTR(cInput, 2)
  ENDIF
  
  * Determine the position of the decimal point
  lnDecimal = AT(".", cInput)
  
  * If there is a decimal point, split the input string into the whole number part and the decimal part
  IF lnDecimal > 0 THEN
    lcDecimal = SUBSTR(cInput, lnDecimal)
    cInput = LEFT(cInput, lnDecimal-1)
  ENDIF
  
  * Start with an empty output string
  lcOutput = ""
  
  * While the input string is not empty, add the rightmost three digits to the output string, followed by a comma if there are more digits left
  DO WHILE LEN(cInput) > 0
    lcOutput = right(cInput,3) + lcOutput
    cInput = LEFT(cInput, LEN(cInput) - 3)
    IF LEN(cInput) > 0 THEN
      lcOutput = "," + lcOutput
    ENDIF
  ENDDO
  
  * If there was a decimal part, add it to the output string
  IF lnDecimal > 0 THEN
    lcOutput = lcOutput + lcDecimal
  ENDIF
  
  * If the input was negative, add the negative sign to the output string
  IF llNegative THEN
    lcOutput = "-" + lcOutput
  ENDIF
  
  * Return the output string
  RETURN lcOutput
ENDFUNC

FUNCTION cGetExpression
PARAMETERS cfield
Brow
Retu(ALLTRIM(&cfield))

FUNCTION FormatAsInCalc
PARAMETERS nvalx, ndecimals, cprefix, lfront, lmem
&&PUBLIC lfirst
LOCAL cretval, cpfx
*!*		IF VARTYPE(oPlot3) == 'O' AND INLIST(charttypes.nchart,1,2)
*!*			IF lfirst
*!*				GO Top
*!*				lfirst = .F.
*!*			ELSE 
*!*				skip
*!*			ENDIF 
*!*	*WAIT RECNO() window
*!*		ENDIF 

	cpfx = ''
	IF VARTYPE(nvalx) == 'C'
		nvalx = &nvalx
	ENDIF 
	cretval = FormatNumber(nvalx,oCalc.Check11.Value,ndecimals)
	IF ! EMPTY(cprefix)
		IF lfront
			IF lmem
				cretval = 'Mem '+ALLTRIM(cprefix)+': '+cretval
			ELSE 
				cretval = cprefix + cretval
			ENDIF 
		ELSE 
			cretval = cretval + cprefix
		ENDIF 
	ENDIF 
RETURN cretval
ENDFUNC 

FUNCTION FormatNumber
PARAMETERS nvalx,lcommas,ndecimals,lcurrency
IF VARTYPE(nvalx) == 'C'
	RETURN IIF(LEFT(nvalx,1) == '$',SUBSTR(nvalx,2,30),nvalx)
ENDIF 
IF VARTYPE(nvalx) == 'L'
	nvalx = 0
ENDIF 
LOCAL cvalx, clx, ndecx, ncommas,nfirstcomma, ii,cfinalstr,lminus, cdecpart
IF VARTYPE(ndecimals) == 'C'
	ndecimals = VAL(ndecimals)
ENDIF 
IF VARTYPE(cvalx) # 'N'
	cvalx = 0
ENDIF 
lminus = nvalx < 0
IF ndecimals == 13
	RETURN TRANSFORM(nvalx,'@^')
ENDIF 
cvalx = ALLTRIM(STR(ROUND(nvalx,ndecimals),20,ndecimals))

IF ! lcommas OR ABS(nvalx) < 1000
	RETURN cvalx
ENDIF 
IF lminus
	cvalx = SUBSTR(cvalx,2)
ENDIF 

clx = cvalx

	ndecx = AT('.',cvalx)
	IF ndecimals > 0
		clx = SUBSTR(clx,1,ndecx-1)
	ENDIF 
*!*		SET ESCAPE ON
*!*		WAIT clx window
	IF LEN(clx) < 4
*WAIT clx + IIF(ndecimals > 0, '.'+SUBSTR(cvalx,ndecx+1,ndecimals),'') window ndecx+1
		RETURN IIF(lminus,'-','')+clx + IIF(ndecimals > 0, '.'+SUBSTR(cvalx,ndecx+1,ndecimals),'')
	ENDIF 
*WAIT clx +' '+STR(LEN(clx),7) window
	ncommas = INT(LEN(clx)/3)-1 + IIF(LEN(clx) % 3 > 0,1,0)
*WAIT ncommas window
	IF ncommas > 0
		nfirstcomma = LEN(clx) % 3
		IF nfirstcomma == 0
			nfirstcomma = 3
		ENDIF 
		cfinalstr = SUBSTR(clx,1,nfirstcomma)+','
		FOR ii = 1 TO ncommas-1
			cfinalstr = cfinalstr + SUBSTR(clx,nfirstcomma+1,3)+','
			nfirstcomma = nfirstcomma+ 3
		ENDFOR 
		cfinalstr = cfinalstr+RIGHT(clx,3)
*WAIT cfinalstr+ '.'+SUBSTR(cvalx,ndecx+1,ndecimals) window
	IF ndecx > 0 
		cdecpart = SUBSTR(cvalx,ndecx+1,ndecimals)
*!*			IF LEN(cdecpart) > ndecimals
*!*				cdecpart = ALLTRIM(STR(Round(INTVAL(cdecpart),ndecimals)))
*!*			ENDIF
	ENDIF  
	IF VARTYPE(cdecpart) == 'L'
		cfinalstr = IIF(lcurrency,'$','')+IIF(lminus,'-','')+cfinalstr
	ELSE
		cfinalstr = IIF(lcurrency,'$','')+IIF(lminus,'-','')+cfinalstr + '.'+cdecpart
	ENDIF 
*WAIT cfinalstr window
*	WAIT cfinalstr window
	RETURN cfinalstr
ENDIF 
ENDFUNC

PROCEDURE ReformatMathTable
PARAMETERS lcommas, ndecimals,cInTable, cvar11,cvar12, cvar21,cvar22,cvar31,cvar32,cvar41,cvar42,cvar51,cvar52
LOCAL ccx, ccy
	SELECT &cInTable
	SCAN
*		ccx = 
*		ccy = FormatNumber(ny,lcommas,ndecimals)
		IF ! EMPTY(cvar11)
*			IF VARTYPE(&cvar12) == 'N'
				REPLACE &cvar12 WITH VAL(TRIM(FormatNumber(&cvar11,lcommas,ndecimals)))
*!*				ELSE 
*!*					REPLACE &cvar12 WITH FormatNumber(&cvar11,lcommas,ndecimals)
*!*				ENDIF 
		ENDIF 
		IF ! EMPTY(cvar21)
			REPLACE &cvar22 WITH VAL(TRIM(FormatNumber(&cvar21,lcommas,ndecimals)))
		ENDIF 
		IF ! EMPTY(cvar31)
			REPLACE &cvar32 WITH VAL(TRIM(FormatNumber(&cvar31,lcommas,ndecimals)))
		ENDIF 
		IF ! EMPTY(cvar41)
			REPLACE &cvar42 WITH VAL(TRIM(FormatNumber(&cvar41,lcommas,ndecimals)))
		ENDIF 
		IF ! EMPTY(cvar51)
			REPLACE &cvar52 WITH VAL(TRIM(FormatNumber(&cvar51,lcommas,ndecimals)))
		ENDIF 
	ENDSCAN 
ENDPROC 

FUNCTION FIB
PARAMETERS xv
LOCAL nres, cdbf
	TRY
		cdbf = ALIAS()
		SELECT fibonoci
		GO IIF(xv<=RECCOUNT('fibonoci'),xv,1)
		nres = nfn
	CATCH
		SELECT 0
		USE fibonoci
		GO IIF(xv<RECCOUNT('fibonoci'),xv,1)
		nres = nfn
		USE
	ENDTRY 
	IF ! EMPTY(cdbf)
		SELECT &cdbf
	ENDIF
RETURN nres
*!*	FUNCTION FIB
*!*	PARAMETERS xvv
*!*	Retu(FIBONNACI(xvv))

PROCEDURE OpenPlotFunctions 
Para lnowshow
	IF lnowShow
		DO FORM Plotfunctions4 NoShow
	ELSE
		DO FORM Plotfunctions4
	ENDIF 
ENDPROC 

PROCEDURE ClosePlotFunctions
	IF VARTYPE(oPlotFrm) == 'O'
		oPlotFrm.Release
	ENDIF 
ENDPROC 

PROCEDURE EnterFunction
PARAMETERS nloc, cfunction, nbegvalx, nenedvalx, nincrement, ncolorx, nlinewidth
	IF VARTYPE(oPlotFrm) == 'O'
		SELECT FunctionDefinition
		IF BETWEEN(nloc,1,100)
			GO nloc
			REPLACE cfn WITH cfunction,nbegval WITH nbegvalx, nenedval WITH nenedvalx, ninc WITH nincrement,;
			ncolor WITH ncolorx, nplotwith WITH nlinewidth
		ENDIF 
	ENDIF 
ENDPROC 

PROCEDURE SetFDAxis
PARAMETERS nxaxisx, nyaxisx, naxiscolorx, naxiswidthx,ctitlex
IF VARTYPE(oPlotFrm) == 'O'
	WITH oPlotFrm
		.Spinner1.Value = IIF(BETWEEN(nxaxisx,5,95),nxaxisx,.Spinner1.Value)
		.Spinner1.Interactivechange
		.Spinner2.Value = IIF(BETWEEN(nyaxisx,5,95),nyaxisx,.Spinner2.Value)
		.Spinner2.Interactivechange
		.Spinner3.Value = IIF(BETWEEN(naxiswidthx,1,10),naxiswidthx,.Spinner3.Value)
		.Spinner3.Interactivechange
		.Shape1.BackColor = naxiscolorx
		.lsame.value = .T.
		.Shape1.Click(.T.)
		IF VARTYPE(ctitlex) == 'C'
			.Text1.Value = ctitlex 
		ENDIF 
		.Text1.Interactivechange
	ENDWITH 
ENDIF
ENDPROC  

PROCEDURE MinimizePlotFunctions
	IF VARTYPE(oPlotFrm) == 'O'
		oPlotFrm.WindowState = 1
	ENDIF 
ENDPROC 

PROCEDURE DoPlotFunctions
PARAMETERS n1, n2, n3, n4, n5, n6, n7, n8, n9
LOCAL ix, cx
IF VARTYPE(oPlotFrm) == 'O'
	WITH oPlotFrm
		.Command1.Click
		SELECT FunctionDefinition
		FOR ix = 1 TO 9
			cx = STR(ix,1)
			IF VARTYPE(n&cx) == 'N' AND BETWEEN(n&cx,1,100)
				GO n&cx
				REPLACE lChecked WITH .T.
			ENDIF 
		ENDFOR 
		GO Top
		.Command5.Click
	ENDWITH 
ENDIF 
ENDPROC 

PROCEDURE DoPlotFunctionsc
PARAMETERS cList
*WAIT cList Window
LOCAL ix, cx, nx
IF VARTYPE(oPlotFrm) == 'O'
	WITH oPlotFrm
		.Command1.Click
		SELECT FunctionDefinition
		IF VARTYPE(cList) == 'C'
			cx = ''
			FOR ix = 1 TO LEN(cList)
				IF SUBSTR(cList,ix,1) # ',' 
					IF SUBSTR(cList,ix,1) $ '0123456789'
						cx = cx + SUBSTR(cList,ix,1)
					ENDIF 
				ELSE
					nx = INT(VAL(cx))
					IF BETWEEN(nx,1,100)
						GO nx
						REPLACE lChecked WITH .T.
					ENDIF 
					cx = ''
				ENDIF 
				
			ENDFOR 
			nx = INT(VAL(cx))
			IF BETWEEN(nx,1,100)
				GO nx
				REPLACE lChecked WITH .T.
			ENDIF 
		ELSE
			RETURN
		ENDIF 
		GO Top
		.Command5.Click
	ENDWITH 
ENDIF 
ENDPROC 

FUNCTION cGetValueList
LOCAL cOutputList
RETURN cEliminateNonNumbers(INPUTBOX('Comma separated values:','Input Values'))

FUNCTION cNumListToArray
PARAMETERS cnumlist
PUBLIC ARRAY nnumlist(10)
LOCAL ix, nx, cx, cxn, nndx
	cxn = ''
	nndx = 0
	FOR ix = 1 TO LEN(cnumlist)
		cx = SUBSTR(cnumlist,ix,1)
		IF cx == ','
			nndx = nndx + 1 
			nnumlist(nndx) = INT(VAL(cxn))
			cxn = ''
		ELSE
			cxn = cxn + cx
		ENDIF 
	ENDFOR 
	IF cx # ','	
		nndx = nndx + 1 
		nnumlist(nndx) = INT(VAL(cxn))
	ENDIF 
RETURN nndx
ENDFUNC 


FUNCTION cEliminateNonNumbers
PARAMETERS cInputList
LOCAL ix, cx, cOutputList
	cOutputList = ''
	FOR ix = 1 TO LEN(cInputList)
		cx = SUBSTR(cInputList,ix,1)
		IF cx == ',' OR ISDIGIT(cx)
			IF cx == ',' AND RIGHT(cOutputList,1) == ','
				LOOP
			ENDIF 
			cOutputList = cOutputList + cx
		ENDIF 
	ENDFOR 
	IF RIGHT(cOutputList,1) == ','
		cOutputList = LEFT(cOutputList,LEN(cOutputList)-1)
	ENDIF 
	RETURN cOutputList
ENDFUNC 

FUNCTION cPutValuesInQuotes
PARAMETERS cInputList
LOCAL ix, cx, cOutputList
	cOutputList = '"'
	FOR ix = 1 TO LEN(cInputList)
		cx = SUBSTR(cInputList,ix,1)
		IF cx == ',' 
			cOutputList = cOutputList + '","'
		ELSE 
			cOutputList = cOutputList + cx
		ENDIF 
	ENDFOR
	cOutputList = cOutputList + '"' 	
	IF RIGHT(cOutputList,1) == ','
		cOutputList = LEFT(cOutputList,LEN(cOutputList)-1)
	ENDIF 
	RETURN cOutputList
ENDFUNC 

FUNCTION lisCharMatch
PARAMETERS cSrchStr, CStrSearch
Retu(ATC(cSrchStr,CStrSearch,1)>0)


PROCEDURE DoPlotFunctionsByName
PARAMETERS cList
*WAIT cList Window
LOCAL ix, cx, nx
IF VARTYPE(oPlotFrm) == 'O'
	WITH oPlotFrm
		.Command1.Click
		SELECT FunctionDefinition
		IF VARTYPE(cList) == 'C'
			cx = ''
			FOR ix = 1 TO LEN(cList)
				IF ! SUBSTR(cList,ix,1) $ ', ' 
					cx = cx + SUBSTR(cList,ix,1)
				ELSE
					Checkcx(cx)
					cx = ''
				ENDIF 
			ENDFOR 
			IF ! EMPTY(cx)
				Checkcx(cx)
			ENDIF 
		ELSE
			RETURN
		ENDIF 
		GO Top
		.Command5.Click
	ENDWITH 
ENDIF 
ENDPROC 

PROCEDURE Checkcx
PARAMETERS cx
LOCAL ixx, lisnumber, nx
	SELECT FunctionDefinition
	lisnumber = .T.
	FOR ixx = 1 TO LEN(cx)
		IF ! ISDIGIT(SUBSTR(cx,ixx,1))
			lisnumber = .F.
			EXIT 
		ENDIF
	ENDFOR  
	IF lisnumber
		nx = INT(VAL(cx))
		IF BETWEEN(nx,1,100)
*WAIT nx window
			GO nx
			REPLACE lChecked WITH .T.
		ENDIF 
	ELSE
*WAIT cx window
		REPLACE lChecked WITH .T. FOR LOWER(cx) $ LOWER(cfn_name)
	ENDIF 
ENDPROC 
		

FUNCTION GenerateSquareWaveDeg
   LPARAMETERS nFrequency, nDuration, nHarmonics, nDeg

   LOCAL nSampleRate, nSamples, nPeriod, nWaveform, n, k, term

   * Set the sample rate (samples per second)
   nSampleRate = 44100  && Adjust as needed

   * Convert degree input to radians
   nFreqRad = nFrequency * PI() / 180

   * Calculate the number of samples
   nSamples = nSampleRate * nDuration

   * Calculate the period of the square wave
   nPeriod = 1 / nFreqRad

   * Generate square wave sample using Taylor series
   term = 0
   FOR k = 1 TO nHarmonics
      term = term + (1 / (2 * k - 1)) * SIN((2 * k - 1) * nFreqRad * nDeg / 180)
   ENDFOR

   nWaveform = 4 / PI() * term

   RETURN nWaveform
ENDFUNC

FUNCTION cGetMemScriptName
PARAMETERS nscript
IF BETWEEN(nscript,1,RECCOUNT('Memscripts'))
	GO nscript IN 'Memscripts'
ELSE 
	GO 1 IN 'Memscripts'
ENDIF 
RETURN cAddQuotes(IIF(EMPTY(Memscripts.Scriptname),nvaltoStr(nscript),Alltrim(Memscripts.Scriptname)))

FUNCTION ScriptNameDefined
LOCAL ncount
SELECT MemScripts
COUNT FOR ! EMPTY(Scriptname) AND ! EMPTY(cprocedure) TO ncount
RETURN ncount > 0

FUNCTION FACT
PARAMETERS nxf
RETURN (Factorial(nxf))

FUNCTION SIND
PARAMETERS xv
RETURN SIN(DTOR(xv))

FUNCTION COSD
PARAMETERS xv
RETURN COS(DTOR(xv))

FUNCTION TAND
PARAMETERS xv
RETURN TAN(DTOR(xv))

FUNCTION ASIND
PARAMETERS xv
RETURN RTOD(ASIN(xv))

FUNCTION ACOSD
PARAMETERS xv
RETURN RTOD(ACOS(xv))

FUNCTION ATAND
PARAMETERS xv
RETURN RTOD(ATAN(xv))

FUNCTION ISEVEN
PARAMETERS xv
RETURN (xv % 2 == 0)

FUNCTION ISODD
PARAMETERS xv
RETURN (xv % 2 > 0)

FUNCTION RANDX
PARAMETERS nmax
LOCAL nrand
nrand = INT(100*RAND(-1))
DO WHILE .T.
	nrand = INT(100*RAND())
WAIT '' TIMEOUT .001
	IF BETWEEN(nrand,0,nmax)
		RETURN nrand
	ENDIF
ENDDO

FUNCTION RandBtwn
PARAMETERS nmax
LOCAL nr
	nr = RAND(-1)
	WAIT '' TIMEOUT .001
RETURN ABS(INT((nmax - 2) * RAND( ) + 1))

*!*	FUNCTION SumDigits
*!*	PARAMETERS nxx
*!*	LOCAL cxx, ntotalx, ixx
*!*		nxx = INT(nxx)
*!*		cxx = ALLTRIM(STR(nxx))
*!*		ntotalx = 0
*!*		FOR ixx = 1 TO LEN(cxx)
*!*			ntotalx = ntotalx + VAL(SUBSTR(cxx,ixx,1))
*!*	*		WAIT ntotalx window
*!*		ENDFOR 
*!*		RETURN ntotalx
*!*	ENDFUNC 
*!*		
*!*	FUNCTION SumAllDigits
*!*	PARAMETERS nxyz
*!*	DO WHILE .T.
*!*		nxyz = SumDigits(nxyz)
*!*		IF nxyz < 10
*!*			RETURN nxyz
*!*		ENDIF 
*!*	ENDDO 
FUNCTION sectommss
PARAMETERS nsecs
Retu(INT(nsecs/60)+(nsecs % 60)/100)

FUNCTION mmsstosec
PARAMETERS nmins
LOCAL nmin, nsecs
	nmin = INT(nmins)
	nsec = (nmins - nmin)*100
Retu(nmin*60+nsec)


FUNCTION mintommss
PARAMETERS nmin
LOCAL nwholemin, nsecs
	nwholemin = INT(nmin)
	nsecs = ROUND((nmin-nwholemin)*60,0)
Retu(nwholemin+nsecs/100)

FUNCTION mmsstomin
PARAMETERS mmss
LOCAL nwholemin, nsecs
	nwholemin = INT(mmss)
	nsecs = 100*(mmss-nwholemin)/60
Retu(nwholemin+nsecs)

FUNCTION GetStrfromVar
PARAMETERS nmemno, nPage
LOCAL nsaverec, cretval, nvndxx
	SELECT VariableList2
	nsaverec = RECNO()
	IF VARTYPE(npage) == 'N' AND BETWEEN(npage,1,10)
		GO nPage
	ENDIF 
	IF VARTYPE(nmemno) == 'N' AND BETWEEN(nmemno,1,5)
		nvndxx = '.SV'+STR(nmemno,1)
	ELSE
		nvndxx = '.SV1'
	ENDIF 
	cretval = VariableList2&nvndxx
	GO nsaverec
RETURN cretval

FUNCTION SaveSV
PARAMETERS cvalx, nvarx, npagex
LOCAL cVx
SELECT VariableList2
	cVx = FIELD(FCOUNT()-5+nvarx)
	IF VARTYPE(npagex) == 'N' AND BETWEEN(npagex,1,10)
		GO npagex
	ENDIF 
	IF VARTYPE(cvalx) == 'C'
		REPLACE &cVx WITH cvalx
		UpdateStrVarDisp()
		RETURN 1
	ELSE 
		RETURN 0
	ENDIF 
ENDFUNC 

PROCEDURE UpdateStrVarDisp
LOCAL ixx
	IF VARTYPE(oStrDisp) == 'O'
		oStrDisp.Spinner1.Interactivechange
	ENDIF 
ENDPROC 

FUNCTION VartypeIsObject
PARAMETERS invarx
RETURN VARTYPE(invarx)=='O'

FUNCTION SV
PARAMETERS nx,np
Local cretval, cx, nsaverec
	cx = 'SV'+STR(nx,1)
	IF VARTYPE(np) == 'N'
		IF ! BETWEEN(np,1,10)
			Retu('')
		ENDIF 
		nsaverec = RECNO('Variablelist2')
		GO np IN 'VariableList2'
		nretval = Variablelist2.&cx
		GO nsaverec IN 'VariableList2'
		RETURN nretval
	ENDIF
Retu(Variablelist2.&cx)
	
FUNCTION SVX
PARAMETERS cnstrx
LOCAL cprevalias, lretok
cprevalias = ALIAS()
IF ! USED('StringVariables')
	SELECT 0
	USE StringVariables
ELSE
	SELECT StringVariables
ENDIF 
GO Top
IF VARTYPE(cnstrx) == 'C'
	LOCATE FOR LOWER(cnstrx) == LOWER(TRIM(Vname))
	lretok = FOUND()
ENDIF 
IF VARTYPE(cnstrx) == 'N'
	IF BETWEEN(cnstrx,1,RECCOUNT())
		GO cnstrx
		lretok = .T.
	ENDIF 
ENDIF 
*brow
SELECT &cprevalias
RETURN IIF(lretok,TRIM(StringVariables.strval),0)

FUNCTION SNX
PARAMETERS cnstrx, lvalue
LOCAL cprevalias, lretok
cprevalias = ALIAS()
IF ! USED('StringVariables')
	SELECT 0
	USE StringVariables
ELSE
	SELECT StringVariables
ENDIF 
GO Top
IF VARTYPE(cnstrx) == 'C'
	LOCATE FOR LOWER(cnstrx) $ LOWER(TRIM(strval))
	lretok = FOUND()
ENDIF 
IF VARTYPE(cnstrx) == 'N' AND BETWEEN(cnstrx,1,RECCOUNT())
	GO cnstrx
	lretok = .T.
	lvalue = .F.
ENDIF 
*brow
SELECT &cprevalias
RETURN IIF(lretok,IIF(lvalue,RECNO('StringVariables'),ALLTRIM(StringVariables.Vname)),0)

FUNCTION SwapSV
PARAMETERS nvar1,npage1,nvar2,npage2
LOCAL cv1, nretval
	Try
		cv1 = SV(nvar1,npage1)
		nretval = SaveSV(SV(nvar2,npage2),nvar1,npage1)
		SaveSV(cv1,nvar2,npage2)
		nretval = 1
		UpdateStrVarDisp()
	CATCH
		nretval = 0
	ENDTRY 
	RETURN nretval
ENDFUNC 

FUNCTION SwapSVX
PARAMETERS nvar1,nvar2
LOCAL cv1(2), cv2(2), cprevalias, nretval, n1, n2
	cprevalias = ALIAS()
	TRY
		IF VARTYPE(nvar1) == 'N' AND  VARTYPE(nvar2) == 'N'
			IF BETWEEN(nvar1,1,RECCOUNT()) AND BETWEEN(nvar2,1,RECCOUNT())
				SELECT StringVariables
				GO nvar1
				cv1(1) = vname
				cv1(2) = strval
				GO nvar2
				cv2(1) = vname
				cv2(2) = strval
				REPLACE strval WITH cv1(2), vname WITH cv1(1)
				GO nvar1
				REPLACE strval WITH cv2(2), vname WITH cv2(1)
				nretval = 1
			ELSE
				nretval = 0 
			ENDIF 
		ELSE 
			IF VARTYPE(nvar1) == 'C' AND VARTYPE(nvar2) == 'C'
				SELECT StringVariables	
				LOCATE FOR TRIM(nvar1) == TRIM(Vname)
				IF FOUND()
					n1 = RECNO()
					cv1(1) = vname
					cv1(2) = strval
					LOCATE FOR TRIM(nvar2) == TRIM(Vname)
					IF FOUND()
						cv2(1) = vname
						cv2(2) = strval
						REPLACE strval WITH cv1(2), vname WITH cv1(1)
						GO n1
						REPLACE strval WITH cv2(2), vname WITH cv2(1)
						nretval = 1
					ELSE 
						nretval = 0
					ENDIF 
				ELSE
					nretval = 0  
				ENDIF 
			ENDIF 
		ENDIF 
	CATCH
		nretval = 0
	ENDTRY
	SELECT &cprevalias 
	RETURN nretval
ENDFUNC 

FUNCTION SaveSVX
PARAMETERS cvname, cvstrval, nloc
LOCAL cprevalias, nretval
	cprevalias = ALIAS()
	Try
		SELECT StringVariables
		GO nloc
		REPLACE vname WITH cvname, strval WITH cvstrval
		nretval = 1
	CATCH 
		nretval = 0
	ENDTRY 
	SELECT &cprevalias 
	RETURN nretval
ENDFUNC 

FUNCTION FindSV
PARAMETERS csrchstr
LOCAL niv, nip, nsaverec, cfld, calias
	calias = ALIAS()
	SELECT Variablelist2
	nsaverec = RECNO()
	FOR nip = 1 TO 10
		GO nip
		FOR niv = 1 TO 5
			cfld = FIELD(FCOUNT()-5+niv)
*WAIT cfld window
			IF csrchstr == ALLTRIM(&cfld)
				GO nsaverec
				SELECT &calias
				Retu(niv+nip/100)
			ENDIF 
		ENDFOR 
	ENDFOR
	GO nsaverec
	SELECT &calias 
	RETURN 0 
ENDFUNC 
* SumDigits.prg
*
* This program calculates the sum of the digits in a given number
* and repeats the process until the value is reduced to a single digit.

* Define the main function
FUNCTION SumDigits(nValue AS INTEGER) AS INTEGER
  LOCAL nSum AS INTEGER
  LOCAL nTemp AS INTEGER
  * Loop until the value is reduced to a single digit
  DO WHILE nValue > 9
    * Initialize the sum to zero
    nSum = 0
    * Calculate the sum of the digits
    nTemp = nValue
    DO WHILE nTemp > 0
      nSum = nSum + MOD(nTemp, 10)
      nTemp = INT(nTemp / 10)
    ENDDO
    * Update the value with the new sum
    nValue = nSum
  ENDDO
  * Return the final value
  RETURN nValue
ENDFUNC 

FUNCTION SumAlphaStr
PARAMETERS lcString,Ljuststring
LOCAL lnSum, lnIndex
lnSum = 0
*WAIT 'string = '+ lcString window

FOR lnIndex = 1 TO LEN(lcString)
    lcChar = SUBSTR(lcString, lnIndex, 1)
    IF UPPER(lcChar) >= "A" AND UPPER(lcChar) <= "Z"
        lnSum = lnSum + (ASC(UPPER(lcChar)) - ASC("A") + 1)
    ELSE
    	IF BETWEEN(lcChar,'0','9')
    		lnSum = lnSum + VAL(lcChar)
    	ENDIF 
    ENDIF
ENDFOR
IF lJuststring
	RETURN lnSum
ELSE 
	RETURN SumDigits(lnSum)
ENDIF 
ENDFUNC 

FUNCTION Fibonacci(n)
  IF n <= 1
    RETURN n
  ELSE
    RETURN Fibonacci(n-1) + Fibonacci(n-2)
  ENDIF
ENDFUNC

FUNCTION IsWholeNumber
PARAMETERS nval
Retu((nval - INT(nval)) == 0)


FUNCTION INTSTR
PARAMETERS nxx
RETURN ALLTRIM(STR(INT(nxx)))

FUNCTION SetStatscope
PARAMETERS nscp
Retu(cCompleteDomain(Statscope(IIF(nscp==1,0,-nscp+1))))

FUNCTION Statscope
PARAMETERS nscope, nmax, nChecked
LOCAL ccheckeddomain
	IF VARTYPE(nscope) # 'N'
		nscope = 0
	ENDIF 
	IF VARTYPE(nChecked) == 'L'
		ccheckeddomain = ''
	ELSE	
		IF nscope < 3
			ccheckeddomain = ' AND ' + IIF(nchecked # 1,'!','')+' Checked '
		ELSE 
			ccheckeddomain = 'AND memoryn # 0'
		ENDIF 
	ENDIF 
	IF VARTYPE(nmax) == 'N'
		IF nmax > RECCOUNT('Calc')
			nmax = RECCOUNT('Calc')
		ENDIF 
		IF nscope > RECCOUNT('Calc')
			nscope = RECCOUNT('Calc')
		ELSE 
			IF nscope < 1
				nscope = 1
			ENDIF 
		ENDIF 
		DO Case
			CASE nscope == 0
				RETURN 'For BETWEEN(RECNO(),'+Intstr(nscope)+','+Intstr(nmax)+') ' + ccheckeddomain
			CASE nscope == -1
				RETURN 'For BETWEEN(RECNO(),1,'+Intstr(nmax)+') ' + ccheckeddomain
			CASE nscope == -2
				RETURN 'For BETWEEN(RECNO(),1,'+Intstr(nmax)+') ' + ccheckeddomain
			CASE nscope == -3
				RETURN 'For BETWEEN(RECNO(),1,'+Intstr(nmax)+') ' + ccheckeddomain

		ENDCASE 
	ELSE 
		DO Case
			CASE nscope == 0
				RETURN ' ALL '
			CASE nscope == -1
				RETURN 'For Checked'
			CASE nscope == -2
				RETURN 'For ! Checked'
			CASE nscope == -3
				RETURN 'For memoryn # 0'
		
			CASE nscope > 1
				RETURN 'For RECNO() >= '+Intstr(nscope)
		ENDCASE 
	ENDIF 
ENDFUNC 

&&& More Calc Scripting Commands  &&&
PROCEDURE Calcnthroot
	oCalc.Command23.RightClick
ENDPROC 

PROCEDURE CalcRTP
	oCalc.Command23.Click
ENDPROC 

PROCEDURE CalcFactorial
	oCalc.Command27.Click
ENDPROC 

PROCEDURE CalcExponent
	oCalc.Command57.Click
ENDPROC 

PROCEDURE CalcModulus
	oCalc.Command80.Click
ENDPROC 

PROCEDURE CalcQuotient
	oCalc.Command80.RightClick
ENDPROC 

PROCEDURE CalcSqrt
	oCalc.Command20.Click
ENDPROC 

PROCEDURE CalcSqr
	oCalc.Command20.RightClick
ENDPROC 

PROCEDURE CalcCubeRt
	oCalc.Command22.RightClick
ENDPROC 

PROCEDURE CalcCube
	oCalc.Command22.Click
ENDPROC 

PROCEDURE PressToContinue
	Wait 'Press Any Key to Continue...' Window
ENDPROC 
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

FUNCTION cCompleteDomain
PARAMETERS cInx
RETURN cInx + ' TO nresult'

FUNCTION Memsum
PARAMETERS nx,ny,nz
	SELECT Calc
RETURN Statfn('SUM',cCompleteDomain(Statscope(nx,ny,nz)))

FUNCTION MemAvg
PARAMETERS nx,ny,nz
	SELECT Calc
RETURN Statfn('AVG',cCompleteDomain(Statscope(nx,ny,nz)))

FUNCTION MemMin
PARAMETERS nx,ny,nz
	SELECT Calc
RETURN Statfn('MIN',cCompleteDomain(Statscope(nx,ny,nz)))

FUNCTION MemMax
PARAMETERS nx,ny,nz
	SELECT Calc
RETURN Statfn('MAX',cCompleteDomain(Statscope(nx,ny,nz)))


FUNCTION MemStDev
PARAMETERS nx,ny,nz
	SELECT Calc
RETURN Statfn('SDEV',cCompleteDomain(Statscope(nx,ny,nz)))

FUNCTION MemVariance
PARAMETERS nx,ny,nz
	SELECT Calc
RETURN Statfn('VAR',cCompleteDomain(Statscope(nx,ny,nz)))
 
PROCEDURE ScrollMemory
PARAMETERS ndirection,lnobackup
	IF VARTYPE(ndirection) == 'L'
		ndirection = IIF(ndirection,1,-1)
	ENDIF 
	oCalc.ScrollMemory(ndirection,lnobackup)
ENDPROC 

PROCEDURE SetTimer4Interval
PARAMETERS nmilliseconds
	oCalc.Timer4.Interval = nmilliseconds
ENDPROC 

PROCEDURE StartTimer4
PARAMETERS lstart
	oCalc.Timer4.Enabled = lstart
ENDPROC 

PROCEDURE Timer4Proc
&& cproc is a public string variable
LOCAL cerror
	TRY 
		EXECSCRIPT(cproc)
	CATCH TO cerror
	ENDTRY 
	IF VARTYPE(cerror) == 'O'
		oCalc.Timer4.Enabled = .F.
		DO FORM Warning WITH 'Execution Halted -Error Condition',cerror.Message+IIF(EMPTY(SYS(2018)),'',': '+SYS(2018))
	ENDIF 
ENDPROC 

PROCEDURE ShowStopScript
PARAMETERS lshow
	oDoScript.Stop.Visible = lshow
ENDPROC 

PROCEDURE MemMenuStatFn
PARAMETERS cFnx
LOCAL nresult, cxdomain, csavealias
	csavealias = ALIAS()
	cxdomain = oCalc.Getmemscandomain()+' to nresult'
	TransferValToCalc(Statfn(cFnx,cxdomain),PROPER(cFnx)+'(Mem['+oCalc.ccelldomainbrief+']) = ')
ENDPROC  

FUNCTION MemStatfn
PARAMETERS cFnx, nbegmem, nendmem, nchecked, ncomparevalue1, ncomparevalue2
LOCAL nresult, cdomain, csavealias

csavealias = ALIAS()
IF VARTYPE(cFnx) == 'N'
	DO Case
		CASE cFnx == 1
			cFnx = 'SUM'
		CASE cFnx == 2
			cFnx = 'AVG'
		CASE cFnx == 3
			cFnx = 'MIN'
		CASE cFnx == 4
			cFnx = 'MAX'
		CASE cFnx == 5
			cFnx = 'MEDIAN'
		CASE cFnx == 6
			cFnx = 'RANGE'
		CASE cFnx == 7
			cFnx = 'COUNT'
		CASE cFnx == 8
			cFnx = 'SDEV'
		CASE cFnx == 9
			cFnx = 'VAR'
		OTHERWISE
			cFnx = 'SUM'
	ENDCASE
ELSE  
	cFnx = UPPER(cFnx)
ENDIF 
cFnx = UPPER(cFnx)
IF VARTYPE(nbegmem) == 'L'
	nresult = Statfn(cFnx,'For RECNO("Calc")>0 TO nresult')
	SELECT &csavealias
	RETURN nresult
ENDIF
PUBLIC gnbegmem, gnendmem, ncpv, ncpv2
IF nendmem > RECCOUNT('Calc')
	nendmem = RECCOUNT('Calc')
ENDIF
gnbegmem = nbegmem
gnendmem = nendmem
IF VARTYPE(ncomparevalue1) == 'L'
	ncpv = 0
ELSE 
	ncpv = ncomparevalue1
ENDIF 
IF VARTYPE(ncomparevalue2) == 'L'
	ncpv2 = 0
ELSE 
	ncpv2 = ncomparevalue2
ENDIF 
IF VARTYPE(nchecked) == 'L'
	cdomain = ''
ELSE 
	DO Case
		CASE nchecked==1
			cdomain = 'AND Checked'
		CASE nchecked==2
			cdomain = 'AND ! Checked'
		CASE nchecked==3
			cdomain = 'AND MemoryN # ncpv'
		CASE nchecked==4
			cdomain = 'AND MemoryN > ncpv'
		CASE nchecked==5
			cdomain = 'AND MemoryN <= ncpv'
		CASE nchecked==6
			cdomain = 'AND BETWEEN(MemoryN,ncpv,ncpv2)'
		OTHERWISE
			cdomain = ''	
	ENDCASE 
ENDIF 
nresult = Statfn(cFnx,'For BETWEEN(RECNO("Calc"),gnbegmem,gnendmem)'+cdomain+' TO nresult')
RELEASE gnbegmem, gnendmem, ncpv, ncpv2
SELECT &csavealias
RETURN nresult

FUNCTION Statfn
PARAMETERS Fnx, ccndomain
LOCAL nResult, nTemp
*WAIT ccndomain window
	IF VARTYPE(ccndomain) # 'C'
		ccndomain = 'For Checked TO nResult'
	ENDIF 
	Sele Calc
	Go Top
	Do Case
		Case Fnx == 'SUM'
			Calculate SUM(MemoryN) &ccndomain
		Case Fnx == 'AVG' OR Fnx == 'MEAN'
			Calculate AVG(MemoryN) &ccndomain
		Case Fnx == 'COUNT'
			Calculate COUNT(MemoryN) &ccndomain
		Case Fnx == 'SDEV'
			Calculate STD(MemoryN) &ccndomain
		Case Fnx == 'VAR'
			Calculate VAR(MemoryN) &ccndomain
		Case Fnx == 'MIN'
			Calculate MIN(MemoryN) &ccndomain
		Case Fnx == 'MAX'
			Calculate MAX(MemoryN) &ccndomain
		Case Fnx == 'RANGE'
			Calculate MAX(MemoryN) &ccndomain
			nTemp = nResult
			Calculate MIN(MemoryN) &ccndomain
			nResult = nTemp - nResult
		Case Fnx == 'MEDIAN'

			ccndomain = SUBSTR(ccndomain,1,AT('TO',ccndomain)-1)
			SORT TO SortTemp ON Memoryn &ccndomain FIELDS MemoryN 
			SELECT 0
			USE SortTemp
			IF RECCOUNT() % 2 == 1  &&Odd Case
				GO INT(RECCOUNT()/2)+1
				nresult = Memoryn
			ELSE
				GO INT(RECCOUNT()/2)
				nTemp = Memoryn
				SKIP
				nresult = (nTemp+Memoryn)/2
			ENDIF 	
			USE
			SELECT Calc
	ENDCASE
RETURN nResult


PROCEDURE XValToMem
PARAMETERS nvalx, nmemloc
LOCAL cAlias, nsaveloc
cAlias = ALIAS()
nmemloc = Round(nmemloc,0)
IF ! BETWEEN(nmemloc,1,RECCOUNT('Calc'))
	WAIT 'Memory Value is outside valid range of "1" to "'+ALLTRIM(STR(REccount('Calc'),4,0))+'"' WINDOW TIMEOUT 3
	RETURN 0
ENDIF 
	nsaveloc = RECNO('Calc')
	oCalc.ntransfervaltomemx(nmemloc,nvalx)
	GO nsaveloc IN 'Calc'
	SELECT &cAlias
RETURN nmemloc

PROCEDURE ReComputePage
PARAMETERS npagexxx
LOCAL nsavepage, nresult, cxxeval
	SELECT VariableList2
	nsavepage = RECNO()
	GO npagexxx
	cxxeval = cevx
	REPLACE nv1 WITH EVALUATE(cxxeval), nvd1 WITH VAL(FormatNumber(nv1,.F.,ndecndx-1-1))
	nresult = nv1
	GO nsavepage
RETURN nresult

FUNCTION lVarValid
PARAMETERS nvvx, nvvxx
RETURN VARTYPE(nvvx) == 'N' AND BETWEEN(nvvx,2,Variablelist2.nVariables) AND VARTYPE(nvvxx) == 'N'

PROCEDURE ReCalcPagex
PARAMETERS npagex,nv1x,nv1xv,nv2x,nv2xv,nv3x,nv3xv
LOCAL nsavepage, nresult, cxxeval, nvtorep
	SELECT VariableList2
	nsavepage = RECNO()
	GO npagex
	cxxeval = cevx
	IF lVarValid(nv1x,nv1xv)
		nvtorep = 'NV'+ALLTRIM(STR(nv1x))
*WAIT 'replace variable '+nvtorep+' with '+STR(nv1xv,5) window
		REPLACE &nvtorep WITH nv1xv
	ENDIF 
	IF lVarValid(nv2x,nv2xv)
		nvtorep = 'NV'+ALLTRIM(STR(nv2x))
*WAIT 'replace variable '+nvtorep+' with '+STR(nv2xv,4) WINDOW 
		REPLACE &nvtorep WITH nv2xv
	ENDIF 
	IF lVarValid(nv3x,nv3xv)
		nvtorep = 'NV'+ALLTRIM(STR(nv3x))
		REPLACE &nvtorep WITH nv3xv
	ENDIF 
	REPLACE nv1 WITH EVALUATE(cxxeval), nvd1 WITH VAL(FormatNumber(nv1,.F.,ndecndx-1))
	nresult = nv1
	GO nsavepage
RETURN nresult

PROCEDURE CheckSrchOpen
IF VARTYPE(oSrchForm) == 'O'
	oSrchForm.Release
ENDIF 

PROCEDURE PlotFromExcel
PARAMETERS cFilename
Public oExcel as Excel.Application
Public oWorkbook as Excel.Workbook
Public oWorksheet as Excel.Worksheet
SET OLEOBJECT ON
*	cFilename = 'C:\Calc_Excel_Files\'+cFilename
* 	oExcel = CREATEOBJECT('Excel.Sheet')
*WAIT cFilename window
	oExcel = CREATEOBJECT("Excel.Application")
	oWorkbook = oExcel.Workbooks.Open(cFilename)
	oWorksheet = oWorkbook.Worksheets.Item(1)

	* Assume that the data to be plotted is in columns A and B of the worksheet

	* Create a chart using the selected data
	oExcel.Charts.Add()
	oExcel.ActiveChart.SetSourceData(oWorksheet.UsedRange)
	oExcel.ActiveChart.ChartType= 4  && xlLine
	oExcel.ActiveChart.ProtectData = .F.
	oExcel.ActiveChart.Activate
	oExcel.Visible = .T.
*	oExcel.ActiveChart.Location(1)=1

	* Display the chart in a chart sheet
*	oExcel.ActiveChart.Location(1) = 1
*	oWorkbook.Close()
*	oExcel.Quit()
ENDPROC 

PROCEDURE ReleaseExcelVariables
	IF VARTYPE(oExcel) == 'O'
*		oWorkbook.Close()
		oExcel.Quit()
		RELEASE oExcel, oWorkBook, oWorkSheet
	ENDIF 
ENDPROC

PROCEDURE SaveAndStartExcel
PARAMETERS cfname, cvariables, lplot, oFrm
#DEFINE CEXCELDIR 'C:\CALC_EXCEL_FILES\'
SET SAFETY ON
LOCAL ctname, cvariable, lsuccess
	IF ! DIRECTORY(CEXCELDIR)
		MD(CEXCELDIR)	
	ENDIF 
	lsuccess = .F.

		ctname = CEXCELDIR+ TRIM(cfname)+'.xls'
		TRY 
			COPY TO &ctname XL5 FIELDS &cvariables
	*		WAIT MESSAGE() window
			lsuccess = .T.
		CATCH
			 DO FORM ShowMessage2 WITH MESSAGE(),.T.,.F.
		ENDTRY 
		IF ! lsuccess
			RETURN
		ENDIF
		oFrm.Release 
	*	DO FORM ShowMessage2 WITH 'Table successfully saved to '+ctname,.T.,.F.
		IF lPlot
			TRY 
				=PlotFromExcel(ctname)
	*			RUN /n "C:\Program Files (x86)\Microsoft Office\root\Office16\EXCEL.EXE"
			CATCH
				TRY 
					RUN /n "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
				CATCH 
	  				DO FORM Warning WITH 'Problem finding Excel','Excel not in expected location.  Open manually'
	  			ENDTRY 
			ENDTRY 
		ENDIF 
		SET safety OFF
ENDPROC 

FUNCTION MultiSind
PARAMETERS nx, nd, lodd
LOCAL ix, ntotal
	ntotal = 0
	ix = IIF(lodd,1,0)
	FOR ix = ix TO nd STEP IIF(lodd,2,1)
		ntotal = ntotal + SINd(nx*ix)
	ENDFOR
RETURN ntotal 
 
FUNCTION MultiCosd
PARAMETERS nx, nd, lodd
LOCAL ix, ntotal
	ntotal = 0
	ix = IIF(lodd,1,0)
	FOR ix = ix TO nd STEP IIF(lodd,2,1)
		ntotal = ntotal + Cosd(nx*ix)
	ENDFOR
RETURN ntotal 
ENDFUNC 

PROCEDURE SizeForm
PARAMETERS cformndx,ladd,nwidth,nheight,ntop,nleft
	WITH CustomForm&cformndx
		.AutoCenter = .F.
		.width = IIF(ladd,.width+nwidth,nwidth)
		.height = IIF(ladd,.height+nheight,nheight)
		IF VARTYPE(ntop) == 'N'
			.Top = ntop
		ENDIF 
		IF VARTYPE(nleft) == 'N'
			.Left = nleft
		ENDIF 
		.AutoCenter = .T.
	ENDWITH 
ENDPROC 

PROCEDURE DrawAxis
PARAMETERS cformndx, nxaxis, nyaxis, naxiscolor, nlinewidth
Local i, ccf_ndx, npx,npy

	WITH CustomForm&cformndx
		IF VARTYPE(nlinewidth) == 'N'
			.DrawWidth = nlinewidth
		ENDIF 
		IF VARTYPE(naxiscolor) # 'N'
			 .ForeColor = RGB(140,140,140)
		ELSE 
			.ForeColor = naxiscolor
		ENDIF 
		IF nxaxis == 0
			nxaxis = INT(.height/2)
		ELSE 
			nxaxis = INT(nxaxis*.height/100)
		ENDIF 
		.nxaxis = nxaxis
		nyaxis = IIF(nyaxis==0,10,INT(nyaxis*.width/100))
		.nyaxis = nyaxis
		.Line(0,nxaxis,.width,nxaxis)
	*	.Line1.Anchor = 8
		.Line(nyaxis,0,nyaxis,.height)
	*	.Line2.Anchor = 4
		.DrawWidth = 1
	ENDWITH 
ENDPROC 


PROCEDURE CalculateScaleFactors
    PARAMETERS cwindwoNo, cFunction, nbegval, ninc, nendval, nPercentFromTop, nPercentFromLeft
    LOCAL x, y, nx, nMaxXpos, nMinXpos, nMaxXneg,nMinxneg, nMaxYpos, nMinYpos, nMaxyneg, nMinyneg, nFormWidth, nFormHeight,;
    nscaleyrange, nscalexrange

    WITH CustomForm&cwindwoNo
   		nFormWidth = .Width
    	nFormHeight = .Height
        nMaxXpos = 0
        nMinXpos = 0
        nMaxXneg = 0
        nMinxneg = 0
        nMaxYpos = 0
        nMinYpos = 0
        nMaxyneg = 0
        nMinyneg = 0

        nx = nbegval

        DO WHILE ABS(nx) <= ABS(nendval)
            x = nx   
            y = EVALUATE(cFunction)
			IF x < 0
				IF x < nMaxXneg
					nMaxXneg = x
				ENDIF 
			ELSE 
				IF x > nMaxXPos
					nMaxXPos = x
				ENDIF 
			ENDIF 

			IF y < 0
				IF y < nMaxyNeg
					nMaxyNeg = y
				ENDIF 
			ELSE
				IF y > nMaxyPos
					nMaxyPos = y
				ENDIF 
			ENDIF 
            nx = nx + ninc
        ENDDO 
*WAIT nMaxyPos window
*WAIT nMaxyNeg Window
		IF ROUND(ABS(nMaxyNeg),4) == ROUND(nMaxyPos,4)
*WAIT 'we are here' window
			nscaleyrange = MIN(.nxaxis,.height-.nxaxis)-6
			IF nscaleyrange > nMaxyPos
				.nyscalefactor = nscaleyrange/nMaxyPos
			ELSE 
				.nyscalefactor = nMaxyPos/nscaleyrange
			ENDIF 

		ELSE 
			IF ABS(nMaxyNeg) >= ABS(nMaxyPos) AND  ABS(nMaxyNeg) > .001
*WAIT 'Maxyneg > Maxypos' window
				&& Scale factor determined by negative y values in negative y range
				nscaleyrange = .height- .nxaxis-6
				IF nscaleyrange > ABS(nMaxyNeg)
					.nyscalefactor = nscaleyrange/ABS(nMaxyNeg)
				ELSE 
					.nyscalefactor = ABS(nMaxyNeg)/nscaleyrange
				ENDIF 
			ELSE 
				nscaleyrange = .nxaxis-6
				IF nscaleyrange > ABS(nMaxyPos)
					.nyscalefactor = nscaleyrange/nMaxyPos
				ELSE 
					.nyscalefactor = nMaxyPos/nscaleyrange
				ENDIF 
			ENDIF 
		ENDIF 
*WAIT .nyscalefactor window
		
		IF ABS(nMaxxNeg) > ABS(nMaxxPos)
			nscalexrange = .nyaxis
			.nxscalefactor = nscalexrange/ABS(nMaxxNeg)
		ELSE 
			nscalexrange = .width -.nyaxis
			.nxscalefactor = nscalexrange/nMaxxPos
		ENDIF 
		
    ENDWITH
ENDPROC

PROCEDURE CalculateScaleFactorsGDI
    PARAMETERS cwindwoNo, cFunction, nbegval, ninc, nendval, nPercentFromTop, nPercentFromLeft
    LOCAL x, y, nx, nMaxXpos, nMinXpos, nMaxXneg,nMinxneg, nMaxYpos, nMinYpos, nMaxyneg, nMinyneg, nFormWidth, nFormHeight,;
    nscaleyrange, nscalexrange

    WITH CustomForm&cwindwoNo
   		nFormWidth = .Width
    	nFormHeight = .Height
        nMaxXpos = 0
        nMinXpos = 0
        nMaxXneg = 0
        nMinxneg = 0
        nMaxYpos = 0
        nMinYpos = 0
        nMaxyneg = 0
        nMinyneg = 0

        nx = nbegval

        DO WHILE ABS(nx) <= ABS(nendval)
            x = nx   
            y = EVALUATE(cFunction)
			IF x < 0
				IF x < nMaxXneg
					nMaxXneg = x
				ENDIF 
			ELSE 
				IF x > nMaxXPos
					nMaxXPos = x
				ENDIF 
			ENDIF 

			IF y < 0
				IF y < nMaxyNeg
					nMaxyNeg = y
				ENDIF 
			ELSE
				IF y > nMaxyPos
					nMaxyPos = y
				ENDIF 
			ENDIF 
            nx = nx + ninc
        ENDDO 
*WAIT nMaxyPos window
*WAIT nMaxyNeg Window
		IF ROUND(ABS(nMaxyNeg),4) == ROUND(nMaxyPos,4)
*WAIT 'we are here' window
			nscaleyrange = MIN(.nxaxis,.height-.nxaxis)-6
			IF nscaleyrange > nMaxyPos
				.nyscalefactor = nscaleyrange/nMaxyPos
			ELSE 
				.nyscalefactor = nMaxyPos/nscaleyrange
			ENDIF 

		ELSE 
			IF ABS(nMaxyNeg) >= ABS(nMaxyPos) AND  ABS(nMaxyNeg) > .001
*WAIT 'Maxyneg > Maxypos' window
				&& Scale factor determined by negative y values in negative y range
				nscaleyrange = .height- .nxaxis-6
				IF nscaleyrange > ABS(nMaxyNeg)
					.nyscalefactor = nscaleyrange/ABS(nMaxyNeg)
				ELSE 
					.nyscalefactor = ABS(nMaxyNeg)/nscaleyrange
				ENDIF 
			ELSE 
				nscaleyrange = .nxaxis-6
				IF nscaleyrange > ABS(nMaxyPos)
					.nyscalefactor = nscaleyrange/nMaxyPos
				ELSE 
					.nyscalefactor = nMaxyPos/nscaleyrange
				ENDIF 
			ENDIF 
		ENDIF 
*WAIT .nyscalefactor window
		
		IF ABS(nMaxxNeg) > ABS(nMaxxPos)
			nscalexrange = .nyaxis
			.nxscalefactor = nscalexrange/ABS(nMaxxNeg)
		ELSE 
			nscalexrange = .width -.nyaxis
			.nxscalefactor = nscalexrange/nMaxxPos
		ENDIF 
		
    ENDWITH
ENDPROC

PROCEDURE PlotFunctionx
    PARAMETERS cwindowNo, cFunction, ndrawcolor, nxscale, nyscale, nbegval, ninc, nendval, lconnect, lCalcScaleFactor, nPercentFromTop, nPercentFromLeft
    LOCAL i, ccf_ndx, npx, npy, nx, x, y

    npx = 0
    npy = 0

    WITH CustomForm&cwindowNo
        .DrawWidth = 1
        .ForeColor = ndrawcolor

        IF lCalcScaleFactor
            CalculateScaleFactors(cwindowNo,cFunction, nbegval, ninc, nendval, nPercentFromTop, nPercentFromLeft)
        ELSE 
            .nxscalefactor = nxscale
            .nyscalefactor = nyscale
        ENDIF 

        nx = nbegval

        DO WHILE ABS(nx) <= ABS(nendval)
            x = nx   

            .Pset(.nyaxis + .nxscalefactor * x, .nxaxis - .nyscalefactor * EVALUATE(cFunction))

            IF lconnect
                IF npx > 0
                    .DrawWidth = 2
                    .Line(npx, npy, .Currentx, .Currenty)
                    .DrawWidth = 1
                ENDIF

                npx = .Currentx
                npy = .Currenty
            ENDIF 

            nx = nx + ninc
        ENDDO 
    ENDWITH 
ENDPROC


PROCEDURE PlotFunction
PARAMETERS cwindowNo, cFunction, ndrawcolor, nxscale, nyscale, nbegval, ninc, nendval, lconnect, lCalcScaleFactor
Local i, ccf_ndx, npx,npy, nx, x, y, nminx, nminy, nmaxx, nmaxy, nxrange, nyrange
npx = 0
npy = 0
	WITH CustomForm&cwindowNo
	  .DrawWidth = 1
	  .ForeColor = ndrawcolor
	  IF lCalcScaleFactor
	 	 x = nbegval
	 	 nminx = x
	 	 nminy = EVALUATE(cFunction)
	 	 nmaxx = x
	 	 nmaxy = nminy
	 	 nx = x
	 	 DO WHILE ABS(nx) <= ABS(nendval)
	  		x = nx	
	  		y = EVALUATE(cFunction)
	  		IF x > nmaxx
	  			nmaxx = x
	  		ENDIF 
	  		IF x < nminx
	  			nminx = x
	  		ENDIF 
	  		IF y > nmaxy
	  			nmaxy = y
	  		ENDIF 
	  		IF y < nminy
	  			nminy = y
	  		ENDIF 
	  		nx = nx + ninc
		  ENDDO 
	  	  nxrange = nmaxx - nminx
	  	  nyrange = nmaxy - nminy
*WAIT nxrange window
*WAIT nyrange window
	  	  .nxscalefactor = .width/nxrange
	  	  .nyscalefactor = .height/nyrange- .1*.height/nyrange
*!*	WAIT .nxscalefactor window
*!*	WAIT .nyscalefactor window
	  ELSE 
		  .nxscalefactor = nxscale
		  .nyscalefactor = nyscale
	  ENDIF 
	  nx = nbegval
	  DO WHILE ABS(nx) <= ABS(nendval)
	  		x = nx	
	* WAIT EVALUATE(cFunction) Window
		    .Pset(.nyaxis+nx*.nxscalefactor,.nxaxis-.nyscalefactor*EVALUATE(cFunction))
		    IF lconnect
			     IF npx > 0
			         .DrawWidth = 2
			        .Line(npx,npy,.Currentx,.Currenty)
			         .DrawWidth = 1
			     Endif
			     npx = .Currentx
			     npy = .Currenty
			ENDIF 
			nx = nx + ninc
		ENDDO 
	ENDWITH 
ENDPROC 
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
PROCEDURE cNumtoStr
PARAMETERS nx
RETURN ALLTRIM(STR(nx))


PROCEDURE DoMathFn
PARAMETERS cnfx, lRightClick
IF VARTYPE(oSciFm) # 'O'
	oCalc.sci.Click
ENDIF 
WITH oSciFm
	TRY 
		IF .&cnfx..enabled 
			IF lRightClick
				.&cnfx..rightclick
			ELSE 
				.&cnfx..click
			ENDIF 
		ENDIF 
	CATCH
		WAIT 'Error Condition: Function '+cInQuotes(cnfx)+'not found' window
	ENDTRY 
ENDWITH 
ENDPROC 

PROCEDURE ClickUdfButton
PARAMETERS nudf
LOCAL cudf
cudf = 'udf'+cNumtoStr(nudf)
IF VARTYPE(oSciFm) # 'O'
	RETURN NULL
ENDIF 
WITH oSciFm.Pageframe1.Page5.&cudf
	IF ! EMPTY(.caption)
		.Click
	ENDIF 
ENDWITH 
ENDPROC 
	
FUNCTION GetCalcValuen
RETURN oCalc.ValueStack(oCalc.ValLevel,2)

FUNCTION GetCalcValuec
RETURN oCalc.ValueStack(oCalc.ValLevel,1)

FUNCTION nCalcValueCopy
	oCalc.Copy.Click
RETURN _ClipText

PROCEDURE CalcClear
	oCalc.Command19.Click
ENDPROC 


FUNCTION cEncode
PARAMETERS nToEncode
LOCAL cxxstring
IF ! USED('cstrings')
	SELECT 0
	USE cstrings
ELSE
	SELECT cstrings
ENDIF 
GO nToEncode
cxxstring = cxstring
Use
RETURN (cEncodeStr(cxxstring))

FUNCTION cEncodeStr
PARAMETERS cIstr
LOCAL cnewstr
	cnewstr = cReverseString(cIstr) 
	FOR ij = 1 TO 4
		cnewstr = cShuffleStr(cnewstr)
	ENDFOR 
RETURN cFoldString(cReverseString(cnewstr))

FUNCTION cDecodeStr
PARAMETERS cIstr
LOCAL cnewstr
	cnewstr = cReverseString(cFoldString(cIstr))
	FOR ij = 1 TO 4
		cnewstr = cInterleaveStr(cnewstr)
	ENDFOR 
RETURN cReverseString(cnewstr) 

FUNCTION cReverseString
PARAMETERS cInstr
LOCAL i, cOutStr
cOutStr = ''
FOR i = 16 TO 1 STEP -1
	cOutStr = cOutStr + SUBSTR(cInstr,i,1)
ENDFOR
RETURN(cOutStr)

FUNCTION cInterleaveStr
PARAMETERS cInstr
LOCAL i, k, cOutStr
cOutStr = ''
k = 16
FOR i = 1 TO 8
	cOutStr = cOutStr + SUBSTR(cInstr,k,1)+SUBSTR(cInstr,i,1)
	k = k - 1 
ENDFOR 
Retu(cOutStr)

FUNCTION cShuffleStr
PARAMETERS cInstr
#DEFINE CSHUFFLESTR '16,1,15,2,14,3,13,4,12,5,11,6,10,7,9,8'
LOCAL ARRAY cArray(16), nArray(16)
LOCAL i,k,j, cstrx
k = 16
j= 1
FOR i = 1 TO 8 
	nArray(j) = k
	nArray(j+1) = i
	k = k - 1 
	j = j + 2 
ENDFOR 
cstr = cInstr
FOR i = 1 TO 16
	cArray(i) = SUBSTR(cstr,i,1)
ENDFOR 
cstr = SPACE(16)
FOR i = 1 TO 16
	cstr = STUFF(cstr,nArray(i),1,cArray(i))
ENDFOR 
RETURN cstr

PROCEDURE LogBaseN
   PARAMETERS lnNumber, lnBase
   LOCAL lnResult
   
   * Input validation
   IF (lnNumber <= 0) OR (lnBase <= 0) OR (lnBase == 1)
      RETURN 0
   ENDIF
   
   * Calculate log base n using change of base formula: log_n(x) = ln(x)/ln(n)
   RETURN  LOG(lnNumber) / LOG(lnBase)
   
ENDPROC

FUNCTION cFoldString
PARAMETERS CInstr
Retu(RIGHT(CInstr,8)+LEFT(CInstr,8))

#DEFINE FC 1
#DEFINE CF 2
#DEFINE KC 3
#DEFINE CK 4
#DEFINE MIKM 5
#DEFINE KMMI 6
#DEFINE FME 7
#DEFINE MEF 8
#DEFINE FMI 9
#DEFINE MIF 10
#DEFINE YMI 11
#DEFINE MIY 12
#DEFINE YF 13
#DEFINE FY 130
#DEFINE YI 14
#DEFINE IY 140
#DEFINE YM 15
#DEFINE MY 16
#DEFINE FI 17
#DEFINE IF 18
#DEFINE MI 19
#DEFINE IM 20
#DEFINE IC 21
#DEFINE CI 22
#DEFINE KGLB 23
#DEFINE LBKG 24
#DEFINE KGN 25
#DEFINE NKG 26
#DEFINE HPWATT 27
#DEFINE WATTHP 28
#DEFINE FTLBJ 29
#DEFINE JFTLB 30
#DEFINE WATTFTLB 31
#DEFINE FTLBWATT 32
#DEFINE BTUJ 33
#DEFINE JBTU 34
#DEFINE EVJ 35
#DEFINE JEV 36
#DEFINE BTUWHR 37
#DEFINE WHRBTU 38
#DEFINE BTUKWHR 39
#DEFINE KWHRBTU 40
#DEFINE BTUFTLB 41
#DEFINE FTLBBTU 42
#DEFINE BTUCAL 43
#DEFINE CALBTU 44
#DEFINE LBN 45
#DEFINE NLB 46
#DEFINE KCALBTU 47
#DEFINE BTUKCAL 48
#DEFINE MPHFPS 49
#DEFINE FPSMPH 50
#DEFINE MPHKPH 51
#DEFINE KPHMPH 52
#DEFINE MPHMEPS 53
#DEFINE MEPSMPH 54
#DEFINE MEPSMIPS 55
#DEFINE MIPSMEPS 56
#DEFINE FPSMEPS 57
#DEFINE MEPSFPS 58
#DEFINE MPHMPM 59
#DEFINE MPMMPH 159
#DEFINE MPHMPS 60
#DEFINE MPSMPH 160
#DEFINE GL 61
#DEFINE LG 62
#DEFINE GQ 63
#DEFINE QG 64
#DEFINE GO 65
#DEFINE OG 66
#DEFINE LQ 67
#DEFINE QL 68
#DEFINE OL 69
#DEFINE LO 70
#DEFINE QO 71
#DEFINE OQ 72
#DEFINE OML 73
#DEFINE MLO 74


#DEFINE DAYSEC 77
#DEFINE SECDAY 78
#DEFINE SECMIN 79
#DEFINE MINSEC 80
#DEFINE HRSEC 81
#DEFINE SECHR 82
#DEFINE YRSEC 83
#DEFINE SECYR 84
#DEFINE YRDAY 86
#DEFINE DAYYR 87
#DEFINE LBOZ 88
#DEFINE OZLB 89
#DEFINE OZGM 90
#DEFINE GMOZ 91
#DEFINE MIMET 92
#DEFINE METMI 93
#DEFINE SQFTSQMET 94
#DEFINE SQMETSQFT 95
#DEFINE SQFTACRE 96
#DEFINE ACRESQFT 97
#DEFINE ACRESQME 98
#DEFINE SQMEACRE 99
#DEFINE SQMESQKM 100
#DEFINE SQKMSQME 101
#DEFINE MRMIN 102
#DEFINE MINHR 103
#DEFINE NLBF 104
#DEFINE LBFN 105
#DEFINE NKGF 106
#DEFINE KGFN 107
#DEFINE NDYN 108
#DEFINE DYNN 109
#DEFINE NKIP 110
#DEFINE KIPN 111
#DEFINE MEMI 112



FUNCTION Convert
PARAMETERS cx, nValue

DO Case
		Case cx == 1 &&'fc'
			RETURN (nValue-32)*5/9
		Case cx == 2 &&'cf'
			RETURN 1.8*nValue + 32
		Case cx == 3 &&'ck'
			RETURN nValue + 273.15
		Case cx == 4 &&'kc'
			RETURN nValue - 273.15
		Case cx == 140 &&FK
			RETURN(Convert(3,Convert(1,nValue)))
		Case cx == 141 &&KF
			RETURN(Convert(2,Convert(4,nValue)))

		Case cx == 5 &&'mik'
			RETURN nValue*(1.61)
		Case cx == 6 &&'kmi'
			RETURN nValue/(1.61)
		Case cx == 7 &&'fme'
			RETURN nValue/(3.28084)
		Case cx == 8 &&'mef'
			RETURN nValue*(3.28084)
		Case cx == 9 &&'fmi'
			RETURN nValue/(5280)
		Case cx == 10 &&'mif'
			RETURN nValue*(5280)
		Case cx == 11 &&'ymi'
			RETURN nValue/(1760)
		Case cx == 12 &&'miy'
			RETURN nValue*(1760)
		Case cx == 13 &&'yf'
			RETURN nValue*(3)
		Case cx == 14 &&'yi'
			RETURN nValue*(36)
		Case cx == 15 &&'ym'
			RETURN nValue/(1.09361)
		Case cx == 16 &&'my'
			RETURN nValue*(1.09361)
		Case cx == 17 &&'fi'
			RETURN nValue*(12)
		Case cx == 18 &&'if'
			RETURN nValue/(12)
		Case cx == 19 &&'mi'
			RETURN nValue*(39.37)
		Case cx == 20 &&'im'
			RETURN nValue/(39.37)
		Case cx == 21 &&'ic'
			RETURN nValue*(2.54)
		Case cx == 22 &&'ci'
			RETURN nValue/(2.54)
		Case cx == 23 &&'kglb'
			RETURN nValue*(2.2)
		Case cx == 24 &&'lbkg'
			RETURN nValue/(2.2)
		Case cx == 25 &&'kgn'
			RETURN nValue*(4.45*2.21)
		Case cx == 26 &&'nkg'
			RETURN nValue/(2.21*4.45)
		Case cx == 27 &&'hpwatt'
			RETURN nValue*(745.7)
		Case cx == 28 &&'watthp'
			RETURN nValue/(745.7)
		Case cx == 29 &&'ftlbj'
			RETURN nValue*(1.36)
		Case cx == 30 &&'jftlb'
			RETURN nValue/(1.36)
		Case cx == 31 &&'wattftlb'
			RETURN nValue*(.738)
		Case cx == 32 &&'ftlbwatt'
			RETURN nValue/(.738)
		Case cx == 33 &&'btuj'
			RETURN nValue*(1054)
		Case cx == 34 &&'jbtu'
			RETURN nValue/(1054)
		Case cx == 35 &&'evj'
			RETURN nValue*(1.60E-19)
		Case cx == 36 &&'jev'
			RETURN nValue/(1.60E-19)
		Case cx == 37 &&'btuwhr'
			RETURN nValue*(.2931)
		Case cx == 39 &&'btukwhr'
			RETURN nValue*(.2931/1000)
		Case cx == 38 &&'whrbtu'
			RETURN nValue/(.2931)
		Case cx == 40 &&'kwhrbtu'
			RETURN nValue/(.2931/1000)

		Case cx == 41 &&'btuftlb'
			RETURN nValue*(778.169)
		Case cx == 42 &&'ftlbbtu'
			RETURN nValue/(778.169)
		Case cx == 43 &&'btucal'
			RETURN nValue*(252.164)
		Case cx == 44 &&'calbtu'
			RETURN nValue/(252.164)
		Case cx == 45 &&'lbn'
			RETURN nValue*(4.45)
		Case cx == 46 &&'nlb'
			RETURN nValue/(4.45)
		Case cx == 47 &&'kcalbtu'
			RETURN nValue*(3.96567)
		Case cx == 48 &&'btukcal'
			RETURN nValue/(3.96567)
		Case cx == 49 &&'mphfps'
			RETURN nValue*(5280/3600)
		Case cx == 50 &&'fpsmph'
			RETURN nValue*(3600/5280)
		Case cx == 51 &&'mphkph'
			RETURN nValue*(1.60934)
		Case cx == 52 &&'kphmph'
			RETURN nValue/(1.60934)
		Case cx == 53 &&'mphms'
			RETURN nValue*(5280/3.28084)/3600
		Case cx == 54 &&'msmph'
			RETURN nValue*(3.28084*3600/5280)
		Case cx == 55 &&'mpsms'
			RETURN nValue/(5280/3.28084)
		Case cx == 56 &&'msmps'
			RETURN nValue*(5280/3.28084)
		Case cx == 57 &&'fpsms'
			RETURN nValue/(3.28084)
		Case cx == 58 && 'msfps'
			RETURN nValue*(3.28084)
		Case cx == 59 &&'mphmpm'
			RETURN nValue/(60)
		Case cx == 60 &&'mpsmps'
			RETURN nValue*(5280/3.28084)
		Case cx == 161 &&'mpsmpm'
			RETURN nValue*(60)
		Case cx == 162 &&'mpsmph'
			RETURN nValue*(3600)	
		
		Case cx == 160 
			RETURN nValue*(3600)
		Case cx == 61 &&'gl'
			RETURN nValue*(3.78541)
		Case cx == 62 &&'lg'
			RETURN nValue/(3.78541)
		Case cx == 63 &&'gq'
			RETURN nValue*(4)
		Case cx == 64 &&'qg'
			RETURN nValue/(4)		
		Case cx == 65 &&'go'
			RETURN nValue*(128)
		Case cx == 66 &&'og'
			RETURN nValue/(128)		
		Case cx == 67 &&'lq'
			RETURN nValue*(1.05669)
		Case cx == 68 &&'ql'
			RETURN nValue/(1.05669)
		Case cx == 69 &&'ol'
			RETURN nValue/(32*1.05669)
		Case cx == 70 &&'lo'
			RETURN nValue*(32*1.05669)
		Case cx == 71 &&'qo'
			RETURN nValue*(32)
		Case cx == 72 &&'oq'
			RETURN nValue/(32)
		Case cx == 73 &&'onml'
			RETURN nValue*(1000/(32*1.05669))
		Case cx == 74 &&'mlon'
			RETURN nValue/(1000/(32*1.05669))
		Case cx == 75 &&'pk'
			RETURN nValue/(2.20462)
		Case cx == 76 &&'kp'
			RETURN nValue*(2.20462)
		Case cx == 77 &&'ds'
			RETURN nValue*(86400)
		Case cx == 78 &&'sd'
			RETURN nValue/(86400)
		Case cx == 79 &&'sm'
			RETURN nValue/(60)
		Case cx == 80 &&'ms'
			RETURN nValue*(60)
		Case cx == 81 &&'hs'
			RETURN nValue*(3600)
		Case cx == 82 &&'sh'
			RETURN nValue/(3600)
		Case cx == 83 &&'ys'
			RETURN nValue*(31536000)
		Case cx == 84 &&'sy'
			RETURN nValue/(31536000)
		Case cx == 86 &&'yd'
			RETURN nValue*(365.25)
		Case cx == 87 &&'dy'
			RETURN nValue/(365.25)
		Case cx == 88 &&'lboz'
			RETURN nValue*(16)
		Case cx == 89 &&'ozlb'
			RETURN nValue/(16)
		Case cx == 90 &&'ozgm'
			RETURN nValue*(28.3495)
		Case cx == 91 &&'gmoz'
			RETURN nValue/(28.3495)
		Case cx == 92 &&'mimet'
			RETURN nValue*(1609.35)
		Case cx == 93 &&'metmi'
			RETURN nValue/(1609.35)
		Case cx == 94 &&'sqftsqm'
			RETURN nValue*(.09290304)
		Case cx == 95 &&'sqmsqft'
			RETURN nValue*(10.763910417)
		Case cx == 96 &&'sqftac'
			RETURN nValue*(.0000229568)
		Case cx == 97 &&'acsqft'
			RETURN nValue*(43560)
		Case cx == 98 &&'acsqm'
			RETURN nValue*(.0015624989)
		Case cx == 99 &&'sqmac'
			RETURN nValue*(640.00046695)
		Case cx == 100 &&'sqmskm'
			RETURN nValue*(2.58999)
		Case cx == 101 &&'sksqm'
			RETURN nValue*(0.3861018768)
		Case cx == 102 &&'hr-min'
			RETURN nValue*(60)
		Case cx == 103 &&'min-hr'
			RETURN nValue/(60)
		Case cx == 104 &&'Nlbf'
			RETURN nValue/(.138255)
		Case cx == 105 &&'lbfN'
			RETURN nValue*(.138255)
		Case cx == 106 &&'Nkgf'
			RETURN nValue/(9.80665)
		Case cx == 107 &&'kgfN'
			RETURN nValue*(9.80665)
		Case cx == 108 &&'NDyn'
			RETURN nValue*(100000)
		Case cx == 109 &&'DynN'
			RETURN nValue/(100000)
		Case cx == 110 &&'NKip'
			RETURN nValue/(4448.222)
		Case cx == 111 &&'KipN'
			RETURN nValue*(4448.222)
		Case cx == 112 &&'mpsmps'
			RETURN nValue*(3.28/5280)
		Case cx == 113 &&'nm-sm'
			RETURN nValue*1.15078		
		Case cx == 114 &&'nm-sm'
			RETURN nValue/1.15078		
		Case cx == 115 &&'ms-kph'
			RETURN nValue*3.6		
		Case cx == 116 &&'psi-bar'
			RETURN nValue/14.5038		
		Case cx == 117 &&'bar-psi'
			RETURN nValue*14.5038		
		Case cx == 118 &&'inhg-psi'
			RETURN nValue/2.036	
		Case cx == 119 &&'psi-inhg'
			RETURN nValue*2.036	
		Case cx == 120 &&'hpa-inhg'
			RETURN nValue/33.8639
		Case cx == 121 &&'inhg-hpa'
			RETURN nValue*33.8639
		CASE cx == 122
			RETURN nvalue * 33.8639
		CASE cx == 123
			RETURN nvalue/33.8639	
		Case cx == 124 &&'hpkwatt'
			RETURN nValue*(.7457)
		Case cx == 125 &&'kwatthp'
			RETURN nValue/(.7457)
		Case cx == 126
			RETURN nValue*5
		Case cx == 127 
			RETURN nValue/5
		Case cx == 128 
			RETURN nValue*141.748
		Case cx == 129
			RETURN nValue/141.748
&&&& Start here for new conversion factors
		Case cx == 200  &&days -> min
			RETURN nValue*1440
		Case cx == 201 && hours -> days
			RETURN nValue*0.0417
		Case cx == 202 && min -> days
			RETURN nValue* 0.000694
		Case cx == 203 && min -> years
			RETURN nValue*0.0000019
*!*			Case cx == 204 && min -> years
*!*				RETURN nValue/141.748
		Case cx == 205 && years -> hr
			RETURN nValue*8760
		Case cx == 206 && years -> min
			RETURN nValue*525600
		Case cx == 207 &&acre -> sq yards
			RETURN nValue* 4840
		Case cx == 208 && acre -> sq miles
			RETURN nValue/640
		Case cx == 209 && sqft -> sq yards
			RETURN nValue*0.111
		Case cx == 210 && sqft -> sq km
			RETURN nValue/10763910
		Case cx == 211 && sqft -> sq miles
			RETURN nValue*3.59E-8
		Case cx == 212 && sq km -> sqft
			RETURN nValue*10763910
		Case cx == 213 && sq km -> acre
			RETURN nValue* 247.105	
		Case cx == 218 && acre -> sq km 
			RETURN nValue/247.105	
	
		Case cx == 214 && sq km -> sq miles
			RETURN nValue* 0.3861
		Case cx == 215 && sq meters -> sq mile
			RETURN nValue*3.861E-7
		Case cx == 216 && kgmeter -> neuton
			RETURN nValue*9.8
		Case cx == 217 && neuton -> kgmeter
			RETURN nValue/9.8
		Case cx == 219 && sq miles -> sq km 
			RETURN nValue/0.3861
		Case cx == 220 && sq miles -> acre 
			RETURN nValue*640
		Case cx == 221 && sq miles -> sqft
			RETURN nValue/3.59E-8
		Case cx == 222 && mph -> miles/sec
			RETURN nValue/3600
		CASE cx == 223 && cubic inches -> liters
			RETURN nValue * 0.0163871
		CASE cx == 224 &&  liters -> cubic inches
			RETURN nValue / 0.0163871
	ENDCASE 
RETURN 
ENDFUNC 

PROCEDURE GetTemp1Values
LOCAL i
FOR i = 1 TO FCOUNT('Calc')
	temp1(i) = EVALUATE(FIELD(cfieldx(i)))
ENDFOR 
ENDPROC 

PROCEDURE GetTemp2Values
LOCAL i
FOR i = 1 TO FCOUNT('Calc')
	temp2(i) = EVALUATE(FIELD(cfieldx(i)))
ENDFOR
ENDPROC  

PROCEDURE StoreTemp1Values
PARAMETERS ljustvalues
LOCAL i, cxfield
FOR i = IIF(ljustvalues,6,1) TO IIF(ljustvalues,7,FCOUNT('Calc'))
	cxfield = FIELD(cfieldx(i))
	REPLACE &cxfield WITH temp1(i)
ENDFOR 
ENDPROC 

PROCEDURE StoreTemp2Values
PARAMETERS ljustvalues
LOCAL i, cxfield
FOR i = IIF(ljustvalues,6,1) TO IIF(ljustvalues,7,FCOUNT('Calc'))
	cxfield = FIELD(cfieldx(i))
	REPLACE &cxfield WITH temp2(i)
ENDFOR 
ENDPROC


FUNCTION PerformLinearRegression
LPARAMETERS tcTableName, tcNumericField1, tcNumericField2, tcConditionField

* Check if the table exists

* Calculate linear regression parameters
LOCAL lnCount, lnSumX, lnSumY, lnSumXY, lnSumX2, lnSlope, lnIntercept

	lnCount = RECCOUNT("tempCursor")

	SELECT tempCursor
	SCAN
	    lnSumX = lnSumX + &tcNumericField1
	    lnSumY = lnSumY + &tcNumericField2
	    lnSumXY = lnSumXY + &tcNumericField1 * &tcNumericField2
	    lnSumX2 = lnSumX2 + &tcNumericField1^2
	ENDSCAN

	* Calculate slope and intercept
	lnSlope = (lnCount * lnSumXY - lnSumX * lnSumY) / (lnCount * lnSumX2 - lnSumX^2)
	lnIntercept = (lnSumY - lnSlope * lnSumX) / lnCount

	* Display results
	? "Slope:", lnSlope
	? "Intercept:", lnIntercept

	USE IN SELECT("tempCursor")

RETURN
ENDFUNC 





 

