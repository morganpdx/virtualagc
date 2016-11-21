### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	IMU_PERFORMANCE_TESTS_1.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Solarium055/
## Mod history:	2009-10-04 JL	Created.
##		2009-10-30 JL	Fixed filename comment.
##		2016-08-20 RSB	Typos
##		2016-08-23 RSB	More of the same.

## Page 392

		SETLOC	24000
		
ALGNTST		CS	ZERO		# SXT-NB-IMU FINE ALIGNMENT TEST
		TS	CDUIND
		TC	BANKCALL
		CADR	IMUZERO
		
OPTDATA		CAF	ZERO		# CHECK TARGET AZIMUTH AND ELEVATION
		TS	STARS
		AD	ONE
		TS	DSPTEM1 +2
		CAF	V05N30E
		TC	NVSUB
		TC	PRENVBSY
		INDEX	STARS
		XCH	TAZ
		TS	DSPTEM1
		INDEX	STARS
		XCH	TEL
		TS	DSPTEM1 +1
		TC	CHECKLD		# R1 = AZIMUTH = +XXX.XX
		OCT	00661		# R2 = ELEVATION = +XX.XXX
		TC	ENDTEST
		XCH	DSPTEM1
		INDEX	STARS
		TS	TAZ
		XCH	DSPTEM1 +1
		INDEX	STARS
		TS	TEL
		CCS	STARS
		TC	+3
		CAF	ONE
		TC	OPTDATA +1
		
		TS	COARSAGN
		TS	EROPTN
		TS	TIME2
		TS	NDXCTR
		AD	72DEC
		TS	MAXPTS2
		
		TC	BANKCALL
		CADR	LATAZCHK
		
		TC	BANKCALL
		CADR	TARGSM
		
POSLOAD		CAF	V21N30E		# R1 POSITION 1,2,3
		TC	NVSUB
		TC	PRENVBSY
		TC	ENDIDLE
## Page 393
		TC	ENDTEST
		TC	-5
		XCH	DSPTEM1
		TS	POSITON
		COM
		MASK	BIT3
		CCS	A
		TC	+2
		TC	DSPYLOAD
		CAF	ONE
		TS	COAROFIN
		TC	BANKCALL
		CADR	FINDNAVB	# COARSE ALIGN MARKS
		TC	BANKCALL
		CADR	IMUSTALL	# WAIT FOR IMUZERO COMPLETION
		TC	ENDTEST
		
		
		
		TC	BANKCALL
		CADR	POSNJUMP
		
POSNRETN	TC	BANKCALL
		CADR	PUTPOSX
		
		CCS	COARSAGN
		TC	+2
		TC	+4
		CCS	NEWJOB
		TC	CHANG1
		TC	-5
		TC	OGCZERO
		
		TC	BANKCALL
		CADR	IMUFINE		# INITIATE FINE ALIGN MODE
		TC	BANKCALL
		CADR	IMUSTALL	# WAIT FOR IMUFINE COMPLETION
		TC	ENDTEST
		
		CAF	ZERO
		TS	COAROFIN
		TC	BANKCALL
		CADR	FINDNAVB	# FINE ALIGN MARKS
		TC	FREEDSP
		TC	BANKCALL
		CADR	SMDCALC		# FINE ALIGN TORQUING
		TC	BANKCALL
		CADR	IMUSTALL	# WAIT FOR PULSING COMPLETION
		TC	ENDTEST

## Page 394

ERFINAL		TC	BANKCALL
		CADR	STOPHOR
ERRETN		CCS	EROPTN
		TC	ERFINAL
		TC	+2
		TC	ENDTEST
		INHINT
		TC	TPTIME
		RELINT
		CAF	ZERO
		TS	PIPAX
		TS	PIPAY
		TS	PIPAZ
		TS	STOREPL
		TS	NDXCTR		# UPDATE STORAGE LOCATION
		TC	BANKCALL
		CADR	STORRSLT
		INHINT
		CAF	60SEC
		TC	WAITLIST
		CADR	PIP1
		CAF	PIP2ADR
		TC	JOBSLEEP
		
PIP1		CAF	PIP2ADR
		TC	JOBWAKE
		TC	TASKOVER
		
PIP2		CS	PIPNDX
		TS	PIPINDEX
		TC	CHECKG
		RELINT
		TC	BANKCALL
		CADR	STORRSLT
		CS	PIPNDX +1
		TS	PIPINDEX
		TC	CHECKG
		RELINT
		TC	BANKCALL
		CADR	STORRSLT
		INHINT
		CAF	30SEC
		TC	WAITLIST
		CADR	PIP1
		CAF	PIP2ADR
		TC	JOBSLEEP
PIP2ADR		CADR	PIP2

## Page 395

GYROTORK	CAF	V21N30E
		TC	NVSUB
		TC	PRENVBSY
		TC	ENDIDLE
		TC	ENDTEST
		TC	+1
		XCH	DSPTEM1
		TS	TESTNO
		TS	CALCDIR
		TC	FREEDSP
		CAF	QUARTER
		TS	AZIMUTH
		TS	GENPL +76D
		CAF	SIX
		TS	NBPOS
		CCS	TESTNO
		TS	TESTNO
		TC	+5
		TS	TESTNO
		CS	BURSTPOS
		TS	SAVE
		TC	+3
		CAF	BURSTPOS
		TS	SAVE
		CS	TESTNO
		AD	TWO
		TS	NEGCDU2
		CCS	A
		CAF	ONE
		TC	+3
		TC	+1
		CAF	THREE
		TS	POSITON
		TC	STEVEIN
		
		
		
TORK		CS	NEGCDU2
		COM
		CCS	A
		INDEX	TESTNO
		CS	CDUX
		TC	+2
		CS	CDUX
		TS	NEGCDU1
		CS	TESTNO
		COM
		AD	TESTNO
		TS	LOCNO
		CAF	ITERNO
## Page 396
BLOGS		TS	BUBBLE
		INHINT
		CAF	TIMEINCR
		TC	WAITLIST
		CADR	WAKEUP
		RELINT
		CAF	FIVE
		TS	PLOW
		CAF	ZERO
		INDEX	PLOW
		TS	GYROD
		CCS	PLOW
		TC	-5
		CS	SAVE
		COM
		INDEX	LOCNO
		TS	GYROD +1
		CAF	LLGYROD
		TC	BANKCALL
		CADR	GYROSPNT
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST
		CAF	WAKECADR
		TC	JOBSLEEP
WAKEUP		CAF	WAKECADR
		TC	JOBWAKE
		TC	TASKOVER
WAKE		CCS	BUBBLE
		TC	BLOGS
		CS	NEGCDU2
		COM
		CCS	A
		INDEX	TESTNO
		CS	CDUX
		TC	+2
		CS	CDUX
		TS	NEGCDU2
		CCS	CALCDIR		# DONE TO INSURE PROPER SIGN
		CS	NEGCDU1
		TC	+4
		CS	NEGCDU2
		TS	NEGCDU2
		TC	+2
		TS	NEGCDU1
		INHINT
		CS	NEGCDU2
		CS	A
		TS	ITEMP2
		CS	NEGCDU1
## Page 397
		TC	BANKCALL
		CADR	2SCOMDIF
		RELINT
		TS	CUSSANG
		EXTEND
		MP	FIVE
		CS	LP
		TS	DSPTEM1
		TC	GRABDSP
		TC	PREGBSY
		TC	BANKCALL
		CADR	FLASHON
		CAF	V07N30E
		TC	NVSUB
		TC	PRENVBSY
		TC	ENDIDLE
		TC	ENDTEST



BURSTPOS	DEC	256
ITERNO		DEC	4095
TIMEINCR	DEC	24
LLGYROD		ADRES	GYROD +1
WAKECADR	CADR	WAKE

## Page 398

# THIS IS A ROUGH CHECK PROGRAM FOR THE IMU GYROS AND ACCELEROMETERS

IMUCHK		CAF	QUARTER
		TS	AZIMUTH
		TC	FREEDSP
		CAF	ZERO
		TS	AZIMUTH +1
		CAF	SIX
		TS	NBPOS
		CAF	BIT4
		TS	POSITON
		CS	A
		TS	GENPL +76D
		TC	STEVEIN
		
IMUCHKR		TC	BANKCALL	# CHECKS COARSE ALIGN AND GYRO TORQUING
		CADR	IMULOCK		# CHECK ALL MODE SWITCHING
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST
		
		TC	BANKCALL
		CADR	IMUREENT
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST
		
		TC	BANKCALL
		CADR	IMUFINE
		CAF	ZERO
		TS	PIPAX
		TS	PIPAY
		TS	PIPAZ
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST
		
		CAF	ONE
		TS	RESULTCT
		TS	POSITON
		
IMUCHK1		CAF	TWO		# MEASURE TIME OF OCCURRENCE OF EACH
IMUCHK2		TS	PIPINDEX	# PIP PULSE. ALSO STORE VELOCITY
		INHINT
		TC	CHECKG
		CS	PIPAY
		CS	A
		INDEX	POSITON
		TS	DATAPL +30D
		CS	PIPAZ
## Page 399
		CS	A
		INDEX	POSITON
		TS	DATAPL +32D
		RELINT
		TC	DATALD1
		XCH	RESULTCT
		AD	FIVE
		TS	RESULTCT
		CCS	PIPINDEX
		TC	IMUCHK2
		CCS	POSITON
		TC	+2
		TC	COMPUT
		TS	POSITON
		CAF	BIT6
		TC	WARTMAL
		CCS	COUNTPL
		TC	WARTMAL2
		TC	IMUCHK1
		
		
		
COMPUT		CAF	ZERO		# CALC V1XV2 ANDROOT(GX)2+(GY)2+(GZ)2
		TS	DATAPL
		TS	DATAPL +5
		TS	DATAPL +10D
		XCH	DATAPL +30D
		TS	DATAPL +35D
		CAF	ZERO
		XCH	DATAPL +32D
		TS	DATAPL +37D
		CAF	TWO
		TS	DATAPL +15D
		TS	DATAPL +20D
		TS	DATAPL +25D
		TS	DATAPL +34D
		TS	DATAPL +36D
		
		TC	BANKCALL
		CADR	CHKCALC

## Page 400

GYDRFT		CAF	ZERO
		TS	TESTNDX
		
SFTSTIN		CAF	BIT6		# PIP SCALE FACTOR TEST ENTRY
		TS	NBPOS
		CAF	ZERO
		TS	GENPL +76D
		CAF	ONE
		TS	POSITON
		
GYRDRFT1	TC	BANKCALL
		CADR	LATAZCHK
		
GYRDRFT2	TC	SHOWLD		# LOAD NAVBASE TILT ANGLE IN DEGREES
		TC	BANKCALL
		CADR	SHOW
		TC	FREEDSP
		CCS	NBPOS		# NUMBER IN POSITON.FOR VERTICAL DRIFT
		TC	LTNDX+		# TEST IN LAB LOAD + NUMBER IN TESTNDX
		TC	LTNDX0
		CAF	TEN
		TC	+4
LTNDX0		CAF	SIX
		TC	+2
LTNDX+		CAF	ZERO
		TS	NBPOS
		
STEVEIN		CS	ZERO
		TS	CDUIND
		CS	A
		TS	LTSTNDX
		TC	BANKCALL
		CADR	IMUZERO
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST
		
		TC	BANKCALL
		CADR	NBPOSPL
		
POSGMBL		TC	BANKCALL
		CADR	PUTPOSX
		
		TC	BANKCALL
		CADR	IMUFINE
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST
		CS	CDUX
		CS	A
## Page 401
		INDEX	FLNDX12		# FIXED BY *UNEEDA* DEBUGGING SERVICE
		TS	6
		CS	CDUY
		CS	A
		INDEX	FLNDX12		# FIXED BY *UNEEDA* DEBUGGING SERVICE
		TS	2
		CS	CDUZ
		CS	A
		INDEX	FLNDX12		# FIXED BY *UNEEDA* DEBUGGING SERVICE
		TS	4
		TC	BANKCALL	# READ CDU ANGLES AND COMPLETE
		CADR	FALNE1
		
		
		
FALNED		CCS	GENPL +76D
		TC	TORK
		TC	+2
		TC	IMUCHKR
		TC	BANKCALL
		CADR	FALNED1

## Page 402

ACCELTST	CAF	NINTHOU
		TS	TESTTIME	# ACCELEROMETER OUTPUT TO GRAVITY
		CS	ZERO
		TS	TESTNDX
		TC	SFTSTIN

## Page 403

CHECKG		XCH	Q		# PIP PULSE CATCHING ROUTINE
		XCH	QPLACE
		
CHECKG1		RELINT
		CCS	NEWJOB
		TC	CHANG1
		INHINT
		CAF	ZERO
		INDEX	PIPINDEX
		XCH	PIPAX
		TS	STOREPL
		CCS	STOREPL
		TC	CHECKP
		TC	RESTORE1
		TC	CHECKM
		TC	RESTORE1
		
CHECKP		CAF	BIT6		# LOOKS FOR ONE MORE   PULSE
CHECKP1		TS	PIPANO
		INDEX	PIPINDEX
		CCS	PIPAX
		TC	CHECKG3
		TC	+3
		TC	RESTORE1
		TC	+1
		CCS	PIPANO
		TC	CHECKP1
		TC	RESTORE1
CHECKM		CAF	BIT6		# LOOK FOR ONE MORE  INUS
CHECKM1		TS	PIPANO
		INDEX	PIPINDEX
		CCS	PIPAX
		TC	RESTORE1
		TC	+3
		TC	CHECKG3
		TC	+1
		CCS	PIPANO
		TC	CHECKM1
		TC	RESTORE1

CHECKG3		TC	TPTIME

		CAF	BIT4
CHECKG5		TS	PIPANO
		INDEX	PIPINDEX
		CCS	PIPAX
		TC	+4
		TC	RESTORE1
		TC	+2
		TC	RESTORE1
## Page 404
		CCS	PIPANO
		TC	CHECKG5
NREAD		TC	RESTORE
		TS	STOREPL
		TC	QPLACE
		
RESTORE1	TC	RESTORE
		TC	CHECKG1
		
RESTORE		XCH	STOREPL
		INDEX	PIPINDEX
		AD	PIPAX
		INDEX	PIPINDEX
		TS	PIPAX
		TC	Q

## Page 405

WEIKPL		INHINT
		TC	CHECKG
		RELINT
		CAF	FOUR
		AD	RESULTCT
		TS	RESULTCT
		TC	DATALD1
		CCS	COUNTPL
		TC	DOSCTEST
		TC	BANKCALL
		CADR	RESULTS

## Page 406

TSTJUMP		CCS	TESTNDX
		TC	LABTEST
		TC	SCRTEST
		TC	LABTEST
PIPTST		CAF	ONE		# MEASURE PIP PULSE RATE FOR 90 SEC.
		TS	COUNTPL
		CAF	ZERO
		INDEX	PIPINDEX
		TS	PIPAX
		TS	RESULTCT
		TC	WEIKPL
		
DOSCTEST	TS	COUNTPL		# HORIZ DRIFT TEST SET UP TO
		INHINT			# READ EAST PIP FOUR TIMES
		CS	TESTTIME
		CS	A
		TC	WAITLIST
		CADR	CARRYON
		RELINT
		CAF	CONCADR
		TC	JOBSLEEP
		
CARRYON		CAF	CONCADR
		TC	JOBWAKE
		TC	TASKOVER
		
CONCADR		CADR	WEIKPL

## Page 407

LABTEST		CCS	LTSTNDX		# SET UP TO MEASURE VERTICAL DRIFT
		TC	CDUD
		CAF	ZERO
		TS	XSM
		TS	XSM +6
		TS	XSM +12D
CDUCK		CAF	BIT6
CDUCK1		TS	STOREPL
		TC	STOPHOR1
		
		CCS	STOREPL
		TC	CDUCK1
		CAF	ZERO
		INDEX	CDUNDX
		TS	CDUX
CDUCK2		CAF	BIT6
CDUCK3		TS	STOREPL
		INDEX	CDUNDX
		CCS	CDUX
		TC	CDUCK4
		TC	+3
		TC	CDUCK1
		TC	CDUCK4
		CCS	STOREPL
		TC	CDUCK3
		TC	STOPHOR1
		TC	CDUCK2
CDUCK4		TC	READTIME
		RELINT
		CS	RUPTSTOR
		TS	DATAPL
		CS	RUPTSTOR +1
		TS	DATAPL +1
		CAF	THREE
CDUCK5		TS	STOREPL
		TC	STOPHOR1
		
		CCS	STOREPL
		TC	CDUCK5
		INDEX	CDUNDX
		CCS	CDUX
		TC	POSPLS
		TC	CDUCK1
		TC	CDUCK1
		TC	NEGPLS
		
POSPLS		CS	TESTNDX		# INITIALIZES VERTICAL DRIFT TEST
		CCS	A
		TC	LONGTST
		NOOP
## Page 408
		CS	SXTTR
		TC	+6
NEGPLS		CS	TESTNDX
		CCS	A
		TC	LONGTST
		NOOP
		CAF	SXTTR
		NDX	CDUNDX
		TS	CDUX
		
CDUCK6		TC	STOPHOR1
		CAF	BIT6
CDUCK7		TS	STOREPL
		INDEX	CDUNDX
		CCS	CDUX
		TC	+4
		TC	CDUD1
		TC	+2
		TC	CDUD1
		CCS	STOREPL
		TC	CDUCK7
		TC	CDUCK6
		
CDUD1		CAF	BIT7
		INDEX	CDUNDX
		TS	CDUX
		TC	CDUD
		
		
		
STOPHOR1	XCH	Q
		TS	QPLACE
		TC	BANKCALL
		CADR	STOPHOR
		TC	QPLACE
		
## Page 409

CDUD		INDEX	CDUNDX
		XCH	CDUX
		TS	GENPL +77D
		TC	READTIME
		RELINT
		CS	RUPTSTOR
		TS	DATAPL +2
		CS	RUPTSTOR +1
		TS	DATAPL +3
		TC	BANKCALL
		CADR	CDUCALC
		
		
		
LONGTST		CAF	DECX		#  CHANGED BY MR. FIXIT.
		TS	STOREPL		# VERTICAL ERECTION FOR 14480 SECONDS
		CAF	ONE
		TS	LTSTNDX
		TC	BANKCALL
		CADR	FRECT +2
DSPYLOAD	XCH	Q
		TS	QPLACE
		TC	+2
		TS	NDXCTR
		INDEX	NDXCTR
		CS	YSM
		COM
		TS	DSPTEM1
		INDEX	NDXCTR
		CS	YSM +1
		COM
		TS	DSPTEM1 +1
		CS	NDXCTR
		COM
		AD	YSMCADR
		TS	DSPTEM1 +2
		TC	BANKCALL
		CADR	FLASHON
		CAF	V05N30E
		TC	NVSUB
		TC	PRENVBSY
		CAF	V07N30E
		TC	NVSUB
		TC	PRENVBSY
		TC	ENDIDLE		# WAIT FOR DATA OR PROCEED
		TC	ENDTEST
		TC	+2
		TC	DSPYLOAD +4	# RE-DISPLAY IF DATA LOADED
		CS	NDXCTR
		AD	TEN
## Page 410
		CCS	A
		CAF	TWO
		AD	NDXCTR
		TC	DSPYLOAD +3
		TC	QPLACE
YSMCADR		CADR	YSM

## Page 411

LATAZCK1	TC	MAKECADR
		TS	RETBB
		TC	CHECKLD
		OCT	00661
		TC	ENDTEST
		XCH	RETBB
		TC	BANKJUMP
		
		
		
CHECKLD		XCH	Q
		TS	QPLAC
		INDEX	QPLAC
		XCH	A
		TC	NVSUB
		TC	CHECKLD1
		TC	BANKCALL
		CADR	FLASHON
		TC	ENDIDLE
		TC	+3
		TC	+4
		TC	CHECKLD +2
		INDEX	QPLAC
		TC	Q
		INDEX	QPLAC
		TC	2
CHECKLD1	CAF	CHECKLD2
		TC	NVSUBUSY
CHECKLD2	CADR	CHECKLD +2

## Page 412

SHOW		TC	MAKECADR
		TS	RETAA
SHOW1		CS	POSITON
		CS	A
		TS	DSPTEM2 +2
		TC	BANKCALL
		CADR	FLASHON
		CAF	VB06N66
		TC	NVSUB
		TC	PRENVBSY
		TC	ENDIDLE
		TC	ENDTEST
		TC	+3
		TC	SHOWLD
		TC	SHOW1
		XCH	RETAA
		TC	BANKJUMP
		
		
		
		
		
SHOWLD		CS	NBPOS
		CS	A
		TS	DSPTEM2
		CS	TESTNDX
		CS	A
		TS	DSPTEM2 +1
		TC	Q
		
		
		
		
		
DATALD1		CS	STOREPL
		CS	A
		INDEX	RESULTCT
		TS	DATAPL
		CS	MPAC
		CS	A
		INDEX	RESULTCT
		TS	DATAPL +1
		CS	MPAC +1
		CS	A
		INDEX	RESULTCT
		TS	DATAPL +2
		CS	MPAC +2
		CS	A
		INDEX	RESULTCT
		TS	DATAPL +3
## Page 413
		TC	Q
		
## Page 414

FINISH		TC	BANKCALL
		CADR	SHOW
		CAF	BIT6
		TS	NBPOS
		CAF	ONE
		AD	POSITON
		TS	POSITON
		CS	POSITON
		AD	DEC11
		CCS	A
		TC	+2
		TC	ENDTEST
		INHINT
		CAF	PRIO20
		TC	FINDVAC
		CADR	GYRDRFT2
		TC	ENDOFJOB
		
## Page 415

TPTIME		XCH	Q
		TS	QPLAC
		CS	TIME2
		CS	A
		TS	MPAC
		CS	TIME1
		CS	A
		TS	MPAC +1
		INHINT
		TC	FINETIME
		RELINT
		TS	MPAC +2
		CCS	A
		TC	+7
		CS	TIME2
		CS	A
		TS	MPAC
		CS	TIME1
		CS	A
		TS	MPAC +1
		XCH	MPAC +2
		EXTEND
		MP	BIT11
		XCH	LP
		TS	MPAC +2
		TC	QPLAC
		
## Page 416

OGCZERO		XCH	Q		# ZERO RESIDUAL TORQUING
		TS	QPLACE
		CAF	FIVE
		TS	OVCTR
		CAF	ZERO
		INDEX	OVCTR
		TS	OGC
		CCS	OVCTR
		TC	OGCZERO +3
		TC	QPLACE
		
		
		
FLTRZERO	XCH	Q
		TS	QPLACE
		CAF	FIVE
		TS	OVCTR
		CAF	ZERO
		INDEX	OVCTR
		TS	FILDELX
		CCS	OVCTR
		TC	FLTRZERO +3
		TC	QPLACE
		
## Page 417

WARTMAL		XCH	Q
		TS	QPLACE
		CS	Q
		TS	COUNTPL
WARTMAL4	CCS	COUNTPL
		TC	+4
		TC	QPLACE
		TC	+2
		TC	WARTMAL4 -1
		INHINT
		CAF	BIT11
		TC	WAITLIST
		CADR	WARTMAL3
		RELINT
		CCS	COUNTPL
		TC	QPLACE
		TC	QPLACE
		NOOP
WARTMAL2	TS	COUNTPL
		CAF	WTMLCADR
		TC	JOBSLEEP
WTMLCADR	CADR	WARTMAL4
WARTMAL3	CAF	WTMLCADR
		TC	JOBWAKE
		TC	TASKOVER
		
## Page 418

ENDTEST		TC	FREEDSP
		TC	NEWMODE
		OCT	00000
		CS	ZERO
		TS	CDUIND
		TC	BANKCALL
		CADR	MKRELEAS
		TC	ENDOFJOB
		
## Page 419

SCRTEST		CAF	ZERO
		TS	DATAPL
		TS	GENPL +1
		TS	GENPL +2
		TS	GENPL +3
		TS	GENPL +4
		CAF	TWO
		TS	CDUNDX
		INHINT
		CAF	NINTHOU
		TC	WAITLIST
		CADR	CARYON
		RELINT
		CAF	CONTCADR
		TC	JOBSLEEP
		
CARYON		CAF	CONTCADR
		TC	JOBWAKE
		TC	TASKOVER
		
CONTCADR	CADR	ULES



ULES		INHINT
		TC	CHECKG
		RELINT
		TC	DATALD1
		CAF	FOUR
		TS	RESULTCT
		TC	DATALD1
		TC	+5
REPEET		TS	CDUNDX		# CDUNDX USED FOR CONV
		CAF	FIVE
		AD	RESULTCT
		TS	RESULTCT
		CAF	DEC1500		#  LENGTH OF TEST SELECTED IN LAB
SUMSUM		TS	COUNTPL
		INHINT
		CAF	TEN		#  LENGTH OF SAMPLE SELECTED BY LAB TEST
		TC	WAITLIST
		CADR	REPMAL
		RELINT
		CAF	REPCADR
		TC	JOBSLEEP
		
REPCADR		CADR	RETPLS

REPMAL		CAF	REPCADR
		TC	JOBWAKE
## Page 420
		TC	TASKOVER
		
RETADR		ADRES	RETHERE

RETPLS		CAF	RETADR
		TS	QPLACE
		INHINT
		CAF	ZERO
		TS	STOREPL
		TC	CHECKG3
RETHERE		RELINT
		CS	DATAPL
		AD	STOREPL
		TS	GENPL
		TC	BANKCALL
		CADR	SCRINTP
		
		CCS	CDUNDX
		TC	REPEET
		TC	BANKCALL
		CADR	RESULTS
		
## Page 421

POSSET		CAF	ZERO
		TS	RESULTCT
		CAF	MTRXLD1
		TS	OVCTR
		CAF	ZERO
		INDEX	OVCTR
		TS	XSM
		CCS	OVCTR
		TC	-5
		INDEX	POSITON
		TC	+1
		TC	ENDTEST
		TC	POSN1
		TC	POSN2
		TC	POSN3
		TC	POSN4
		TC	POSN5
		TC	POSN6
		TC	POSN7
		TC	POSN8
		TC	POSN9
		TC	POSN10
		TC	POSN11
POSN1		CAF	HALF		# X UP Y SOUTH Z EAST
		TS	XSM
		TS	YSM +2
		TS	ZSM +4
		CCS	TESTNDX
		TC	+2
		TC	LPNDX1
		NOOP
		CAF	ZERO
		TS	PIPINDEX
		TS	CDUNDX
		TC	POSGMBL
LPNDX1		CAF	TWO
		TS	PIPINDEX
		TC	POSGMBL
POSN2		CAF	HALF		# X DOWN Y WEST ZNORTH
		COM
		TS	XSM
		TS	YSM +4
		TS	ZSM +2
		CCS	TESTNDX
		TC	+2
		TC	LPNDX2
		NOOP
		CAF	ZERO
		TS	CDUNDX
		TS	PIPINDEX
## Page 422
		TC	POSGMBL
LPNDX2		CAF	ONE
		TS	PIPINDEX
		TC	POSGMBL
POSN3		CAF	HALF		# Z UP Y WEST X NORTH
		TS	ZSM
		COM
		TS	XSM +2
		TS	YSM +4
		CCS	TESTNDX
		TC	LCNDX3
		TC	LPNDX2
		NOOP
		TC	LPNDX1

LCNDX3		CAF	ZERO
		TS	CDUNDX
		TC	POSGMBL
POSN4		CAF	HALF		# Z DOWN Y SOUTH X EAST
		TS	XSM +4
		TS	YSM +2
		COM
		TS	ZSM
		CCS	TESTNDX
		TC	LCNDX3
		TC	LPNDX4
		NOOP
		TC	LPNDX1

LPNDX4		TS	PIPINDEX
		TC	POSGMBL
POSN5		CAF	HALF		# Y UP Z NORTH X WEST
		TS	YSM
		COM
		TS	XSM +4
		TS	ZSM +2
		CCS	TESTNDX
		TC	LCNDX5
		TC	LPNDX4
		TC	LCNDX5
		TC	LPNDX2

LCNDX5		CAF	ONE
		TS	CDUNDX
		TC	POSGMBL
POSN6		CAF	HALF		# Y DOWN Z EAST X SOUTH
		TS	XSM +2
		TS	ZSM +4
		COM
		TS	YSM
## Page 423
		CCS	TESTNDX
		TC	LCNDX5
		TC	LPNDX1
		TC	LCNDX5
		TC	LPNDX2

POSN7		CAF	ROOT2/4		## (jiml) was "ROOT 2/4"
		TS	ZSM
		TS	ZSM +2
		TS	YSM
		COM
		TS	YSM +2
		CAF	HALF
		TS	XSM +4
		CAF	ZERO
		TS	PIPINDEX
		CCS	NBPOS
		TC	GYRDRFT2
		TS	TESTNDX
		TC	POSGMBL
POSN8		CAF	ROOT2/4		## (jiml) was "ROOT 2/4"
		TS	YSM
		TS	YSM +2
		TS	XSM
		COM
		TS	XSM +2
		CAF	HALF
		TS	ZSM +4
		CAF	TWO
		TS	PIPINDEX
		CAF	ZERO
		TS	TESTNDX
		TC	POSGMBL
POSN9		CAF	ROOT2/4		## (jiml) was "ROOT 2/4"
		TS	XSM
		TS	XSM +2
		TS	ZSM
		COM
		TS	ZSM +2
		CAF	HALF
		TS	YSM +4
		CAF	ONE
		TS	PIPINDEX
		CCS	NBPOS
		TC	GYRDRFT2
		TS	TESTNDX
		TC	POSGMBL
POSN10		CS	ONE		# POSITION FOR LONG TEST FOR ADIAY
		TS	TESTNDX
		TC	POSN5
## Page 424
POSN11		CS	ONE
		TS	TESTNDX
		TC	POSN6
		
## Page 425

V05N30E		OCT	00530
72DEC		DEC	72
V21N30E		OCT	02130
60SEC		DEC	6000
30SEC		DEC	3000
V07N30E		OCT	00730
NINTHOU		DEC	9000
SXTTR		DEC	64		#    THIS FIXES  INACCURACY DUE TO ENCODER
DEC180		DEC	180
VB06N66		OCT	00666
DEC11		DEC	11
MTRXLD1		DEC	17
ROOT2/4		DEC	.35355339	## (jiml) was "ROOT 2/4"
FLNDX12		ADRES	GENPL		# FIXED BY *UNEEDA* DEBUGGING SERVICE
DEC1500		DEC	1500
DECX		DEC	1448
