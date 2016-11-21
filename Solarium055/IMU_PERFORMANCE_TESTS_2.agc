### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	IMU_PERFORMANCE_TESTS_2.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Solarium055/
## Mod history:	2009-10-04 JL	Created.
##		2009-10-30 JL	Fixed filename comment.
##		2016-08-20 RSB	Typos.
##		2016-08-23 RSB	More of the same.

## Page 426

		SETLOC	70000
		
MISALIGN	TC	BANKCALL
		CADR	OGCZERO
		TC	GRABDSP
		TC	PREGBSY
		CAF	11DEC
		TS	PTS
		CAF	ZERO
		TS	PTS +1
BBB		TS	NDXCTR
		INDEX	NDXCTR
		CS	GENPL +68D
		INDEX	NDXCTR
		AD	GENPL +74D
		INDEX	NDXCTR
		TS	GENPL +74D
		CAF	63DEC
		AD	NDXCTR
		CCS	A
		CS	THREE
		AD	NDXCTR
		TC	BBB
CCCC		TS	NDXCTR
		TC	INTPRET
		LXA,1	0
			NDXCTR
		DMOVE*	1
		DSU
			GENPL +72D,1
			GENPL
		STORE	GENPL +72D,1
		EXIT	0
		CS	NDXCTR
		AD	69DEC
		CCS	A
		CAF	THREE
		AD	NDXCTR
		TC	CCCC
		TS	GENPL
		TS	GENPL +1
		TS	RUN
		CAF	THREE
DDDD		TS	NDXCTR
		TC	INTPRET
		LXA,1	0
			NDXCTR
		DSU*	0
			GENPL +72D,1
			GENPL +66D,1
		NOLOD	1
## Page 427
		TSRT	DAD*
			1
			GENPL +66D,1
		STORE	GENPL +72D,1
		NOLOD	1
		TSLT	DAD
			2
			OGC
		STORE	OGC
		DMOVE*	2
		TSLT	DSQ
		DAD
			GENPL +72D,1
			4
			MGC
		STORE	MGC
		EXIT	0
		CS	RUN
		COM
		AD	NDXCTR
		COM
		AD	63DEC
		CCS	A
		CAF	SIX
		AD	NDXCTR
		TC	DDDD
		AD	RUN
EEEE		TS	NDXCTR
		INDEX	NDXCTR
		CS	GENPL +11D
		COM
		TS	TEMDELV
		CAF	ZERO
		TS	TEMDELV +1
		TC	INTPRET
		LXC,1	0
			NDXCTR
		DMOVE	0
			-
		NOLOD	2
		TSLT	BDDV
		DAD
			5
			TEMDELV
			IGC
		STORE	IGC
		TSLT	1
		BDDV
			-
			3
## Page 428
			TEMDELV
		DMOVE*	2
		TSLT	DMP
		DAD
			GENPL +9D,1
			4
			-
			GENPL
		STORE	GENPL
		EXIT	0
		CS	NDXCTR
		AD	63DEC
		AD	RUN
		AD	NEG3
		CCS	A
		CAF	SIX
		AD	NDXCTR
		TC	EEEE
		TC	INTPRET
		DMP	0
			OGC
			GENPL
		DMP	1
		DSU
			MGC
			IGC
		DSQ	1
		TSRT
			OGC
			1
		TSLT	2
		DMP	DSU
		BDDV	DMP
			PTS
			11
			MGC
			-
			-
			K
		STORE	DSPTEM2
		EXIT	0
		TC	BANKCALL
		CADR	FLASHON
		CAF	V06N66E
		TC	NVSUB
		TC	PRENVBSY
		TC	ENDIDLE
		TC	ENDTEST1
		CAF	THREE
		TS	RUN
## Page 429
		TC	BANKCALL
		CADR	OGCZERO
		CAF	ZERO
		TS	GENPL
		TS	GENPL +1
		TC	DDDD



K		2DEC	1.233 E3 B-14
63DEC		DEC	63
69DEC		DEC	69



ENDTEST1	TC	BANKCALL
		CADR	ENDTEST

## Page 430

FINDNAVB	TC	MAKECADR
		TS	RETAA
		TC	BANKCALL
		CADR	MKRELEAS
		CAF	ONE
		TS	DSPTEM1
		CAF	V01N30E		# MARK ON TARGET 1
		TC	NVSUB
		TC	PRENVBSY
		CAF	ONE
		TC	BANKCALL
		CADR	SXTMARK
		TC	BANKCALL
		CADR	OPTSTALL
		TC	ENDTEST1
		INDEX	MARKSTAT
		CS	0
		CS	A
		TS	VACADR		# TIME OF MARK
		INDEX	MARKSTAT
		CS	1
		CS	A
		TS	VACADR +1
		CS	MARKSTAT
		TS	MKSTAT1
		TC	BANKCALL
		CADR	MKRELEAS
		CAF	TWO
		TS	DSPTEM1
		CAF	V01N30E		# MARK ON TARGET 4
		TC	NVSUB
		TC	PRENVBSY
		CAF	ONE
		TC	BANKCALL
		CADR	SXTMARK
		CCS	COAROFIN	# COARSE ALIGN OR FINE ALIGN MARKS
		TC	CLGNMARK
		CS	MKSTAT1
		AD	TWO
		INDEX	FIXLOC
		TS	S1		# BASE ADDRESS GIMBAL ANGLES
		TC	INTPRET		# OPT-NB-SM    TARGET 1
		LXA,1	0
			MKSTAT1
		ITC	0
			SXTNB
		VSLT	1
		ITC
			STARM
			0
## Page 431
			NBSM
		NOLOD	0
		STORE	STARAD
		DMOVE	0
			VACADR
		STORE	TMARK
		EXIT	0
		
EARRTCOM	TC	INTPRET		# COMPENSATE BETWEEN FINE ALIGN MARKS
		ITC	0
			EARTHR
		ITC	0
			OUTGYR
		EXIT	0
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST1
		CCS	OPTCADR
		TC	+3
		TC	EARRTCOM
		TC	+1
		TC	BANKCALL
		CADR	OPTSTALL
		TC	ENDTEST1
		CAF	TWO
		AD	MARKSTAT
		INDEX	FIXLOC
		TS	S1		# BASE ADDRESS GIMBAL ANGLES
		TC	INTPRET		# OPT-NB-SM    TARGET 4
		LXC,1	0
			MARKSTAT
		ITC	0
			SXTNB
		VSLT	1
		ITC
			STARM
			0
			NBSM
		NOLOD	0
		STORE	STARAD +6
		ITC	0
			MATXDET
		
CLGNMARK	TC	INTPRET		# OPT-NB       TARGET 1
		LXA,1	0
			MKSTAT1
		ITC	0
			SXTNB
		VMOVE	0
			STARM
## Page 432
		STORE	STARAD
		EXIT	0
		TC	BANKCALL
		CADR	OPTSTALL
		TC	ENDTEST1
		TC	INTPRET		# OPT-NB       TARGET 4
		LXC,1	0
			MARKSTAT
		ITC	0
			SXTNB
		VMOVE	0
			STARM
		STORE	STARAD +6
		
MATXDET		VMOVE	0		# CALCULATE TRANSFORMATION MATRIX
			TAR1POS
		STORE	6
		VMOVE	0
			TAR1POS +6
		STORE	12D
		ITC	0
			AXISGEN
		VMOVE	0
			XDC
		STORE	STARAD
		VMOVE	0
			YDC
		STORE	STARAD +6
		VMOVE	0
			ZDC
		STORE	STARAD +12D
		EXIT	0
		XCH	RETAA
		TC	BANKJUMP
		
## Page 433

PUTPOSX		TC	MAKECADR
		TS	RETAA
		TC	INTPRET
		ITC	0
			CALCGA
		EXIT	0
		TC	BANKCALL
		CADR	IMUCOARS	# INITIATE COARSE ALIGN MODE
		TC	BANKCALL
		CADR	IMUSTALL	# WAIT FOR IMUCOARS COMPLETION
		TC	ENDTEST1
		XCH	RETAA
		TC	BANKJUMP



SMDCALC		TC	MAKECADR
		TS	RETAA
		TC	INTPRET
		MXV	1
		VSLT
			XSM
			STARAD
			1
		STORE	XDC
		MXV	1
		VSLT
			YSM
			STARAD
			1
		STORE	YDC
		VXV	1
		VSLT
			XDC
			YDC
			1
		STORE	ZDC
		ITC	0
			CALCGTA
		ITC	0
			OUTGYR
		EXIT	0
		XCH	RETAA
		TC	BANKJUMP

## Page 434

LATAZCHK	TC	MAKECADR
		TS	RETAA
		TC	INTPRET		# CHECK LATITUDE AND NAVBASE AZIMUTH
		TSLT	0
			LATITUDE
			2
		STORE	DSPTEM1 +1
		DMOVE	1
		RTB	EXIT
			AZIMUTH
			1STO2S
		XCH	MPAC
		TS	DSPTEM1
		TC	BANKCALL
		CADR	LATAZCK1
		
		TC	INTPRET
		SMOVE	1
		RTB
			DSPTEM1
			CDULOGIC
		STORE	AZIMUTH
		SMOVE	1
		TSRT
			DSPTEM1 +1
			2
		STORE	LATITUDE
		EXIT	0
		XCH	RETAA
		TC	BANKJUMP
		
## Page 435

TARGSM		TC	INTPRET
		ITC	0
			ERTHRVEN
		ITC	0
			PROCTARG
		VMOVE	0
			TARGET1
		STORE	TAR1POS
		VMOVE	0
			TARGET1 +6
		STORE	TAR1POS +6
		ITC	0
			MAKEXSM
		EXIT	0
		TC	BANKCALL
		CADR	POSLOAD
		
## Page 436

ALGNINIT	RTB	0
			ZEROVAC
		DMOVE	0
			ZERODP
		COS	1
		COMP
			LATITUDE
		SIN	1
		VDEF	VXSC		# (SIN,-COS,0)
			LATITUDE
			OMEG/MS
		STORE	VMARK
		RTB	0
			LOADTIME
		STORE	TMARK
		ITCQ	0

## Page 437

EARTHR		RTB	0
			LOADTIME
		STORE	S1
		NOLOD	3
		DSU	TSLT
		VXSC	MXV
		VAD
			TMARK
			10D
			VMARK
			XSM
			OGC
		STORE	OGC
		DMOVE	0
			S1
		STORE	TMARK
		ITCQ	0
		
## Page 438

OUTGYR		AXT,1	1
		AST,1	AXT,2
			6
			2
			0
OUTGYR1		TSRT*	0
			OGC +6,1
			8D,2
		STORE	GYROD +6,1
		TSLT*	1
		BDSU*
			GYROD +6,1
			8D,2
			OGC +6,1
		STORE	OGC +6,1
		TIX,1	0
			OUTGYR1
		AXT,1	1
		RTB	ITCQ
			GYROD
			PULSEIMU






STORRSLT	TC	MAKECADR
		TS	RETAA
		TC	INTPRET
		LXC,1	0
			NDXCTR
		NOLOD	2
		TSLT	DMP
		RTB
			8D
			SCALFTR
			SGNAGREE
		STORE	GENPL,1
		EXIT	0
		XCH	STOREPL
		INDEX	NDXCTR
		TS	GENPL +2
		CS	NDXCTR
		AD	MAXPTS2
		CCS	A
		CAF	THREE
		AD	NDXCTR
		TC	+4
		CCS	EROPTN
## Page 439
		TC	ENDTEST1
		TC	MISALIGN
		
## Page 440

		TS	NDXCTR
		XCH	RETAA
		TC	BANKJUMP
		
## Page 441

TJLAL		AXT,1	1
		AST,1
			6
			2
TJLAL1		DSU*	1
		DMP	DAD*
			DELVX +6,1
			FILDELX +6,1
			VRECTC3
			FILDELX +6,1
		STORE	FILDELX +6,1
		TIX,1	0
			TJLAL1
		ITCQ	0
		
## Page 442

FALNE1		CAF	TWO
		AD	FLNDX
		INDEX	FIXLOC
		TS	S1
		TC	INTPRET
		MXV	1
		VSLT	ITC
			XSM
			STARAD
			1
			NBSM
		NOLOD	0
		STORE	XDC
		MXV	1
		VSLT	ITC
			YSM
			STARAD
			1
			NBSM
		NOLOD	0
		STORE	YDC
		VXV	1
		VSLT
			XDC
			YDC
			1
		STORE	ZDC
		ITC	0
			CALCGTA
		ITC	0
			OUTGYR
		EXIT	0
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST1
		TC	BANKCALL
		CADR	FALNED

## Page 443

VERTRECT	NOLOD	1
		VXM	VSLT
			XSM
			1
		STORE	0
		DMOVE	0
			VAC +2
		COMP	0
			VAC +4
		SMOVE	1
		VDEF
			ZERODP
		NOLOD	1
		VXSC	VSLT
			INTCON1
			1
		VSU	3
		BOV	VXSC
		VSLT	VAD
		MXV	VAD
			0
			18D
			ERECTND
			INTCON1
			1
			-
			XSM
			OGC
		STORE	OGC
		VMOVE	0
		STORE	18D
ERECTND		ITCQ	0

## Page 444

POSNJUMP	INDEX	POSITON
		TC	+1
		TC	ENDTEST1
		TC	POS1
		TC	POS2
		TC	POS3
		TC	POS4
		TC	BANKCALL
		CADR	POSNRETN
		
POS1		CS	ONE
		TS	PIPNDX
		CS	TWO
		TS	PIPNDX +1
		TC	POS1 -2
		
		
		
POS2		TC	INTPRET
		VMOVE	1
		COMP
			XSM
		VMOVE	0
			ZSM
		STORE	XSM
		VMOVE	0
			-
		STORE	ZSM
		EXIT	0
		CS	ZERO
		TS	PIPNDX
		CS	ONE
		TS	PIPNDX +1
		TC	POS1 -2
		
		
		
POS3		TC	INTPRET
		VMOVE	0
			XSM
		VMOVE	0
			ZSM
		VMOVE	0
			YSM
		STORE	ZSM
		VMOVE	0
			-
		STORE	XSM
		VMOVE	0
			-
## Page 445
		STORE	YSM
		EXIT	0
		CS	ZERO
		TS	PIPNDX
		CS	TWO
		TS	PIPNDX +1
		TC	POS1 -2
		
## Page 446

POS4		TC	INTPRET
		VXV	1
		UNIT
			YSM
			ZSM
		STORE	XSM
		EXIT	0
		TC	POS1 -2



NBPOSPL		CAF	MTRXLD
		TS	OVCTR		# ZERO STARAD
		CAF	ZERO
		INDEX	OVCTR
		TS	STARAD
		CCS	OVCTR
		TC	NBPOSPL +1
		
		TC	INTPRET		# SETS UP AZIMUTH AND VERTICAL VECTORS
		RTB	0		# FOR AXISGEN,RESULTS TO BE USED IN CALCGA
			ZEROVAC		# TO COMPUTE COARSE ALIGN ANGLES
		AXC,1	1
		XSU,1	VMOVE*
			SCNBAZ
			NBPOS
			0,1
		STORE	STARAD		# AZIMUTH IN NB COORDS
		AXC,1	1
		XSU,1	VMOVE*
			SCNBVER
			NBPOS
			0,1
		STORE	STARAD +6	# VERTICAL IN NB COORDS
		COS	1
		COMP
			AZIMUTH
		STORE	8D
		
		SIN	0
			AZIMUTH
		STORE	10D		# AZIMUTH IN CER
		VMOVE	0
			LABNBVER
		STORE	12D		#  VERTICAL IN CER
		ITC	0
			AXISGEN
		
		VMOVE	0
			XDC
## Page 447
		STORE	STARAD
		
		VMOVE	0
			YDC
		STORE	STARAD +6
		
		VMOVE	0
			ZDC
		STORE	STARAD +12D
		EXIT	0
		TC	BANKCALL
		CADR	POSSET
		
## Page 448

RESULTS		CCS	TESTNDX
		TC	CDUCALC
		TC	PIPCALC
		TC	CDUCALC
SFCALC		CS	DATAPL +4
		AD	DATAPL +8D
		TS	DATAPL
		
		TC	INTPRET
		TSU	1
		TSLT	ROUND
			DATAPL +9D
			DATAPL +5
			14D
		SMOVE	2
		DMP	DDV
		RTB
			DATAPL
			DC585
			0
			SGNAGREE
		STORE	DSPTEM2
		EXIT	0
		TC	GRABDSP
		TC	PREGBSY
		TC	BANKCALL
		CADR	FINISH
		
## Page 449

CDUCALC		TC	INTPRET
		DSU	2
		BDDV	DMP
		RTB
			DATAPL +2
			DATAPL
			GENPL +76D
			ERUNITS		# 2DEC.66666
			SGNAGREE
		STORE	DSPTEM2
		EXIT	0
		
		TC	GRABDSP
		TC	PREGBSY
		TC	BANKCALL
		CADR	FINISH
		
## Page 450

PIPCALC		TC	INTPRET
		RTB	0
			FRESHPD
		TSU	1
		TSLT	ROUND
			GENPL +4
			DATAPL +1
			11D
		DSQ	0
			0		# T1(2) IN 2,3
		DMP	1
		VDEF
			0
			2
		STORE	GENPL +25D
		TSU	1
		TSLT	ROUND
			GENPL +9D
			DATAPL +1
			11D
		DSQ	0
			0
		DMP	1		# T2(2) IN 6
		VDEF
			0
			2
		STORE	GENPL +31D
		TSU	1
		TSLT	ROUND
			GENPL +14D
			DATAPL +1D
			11D
		DSQ	0
			0
		DMP	1
		VDEF
			0
			2
		STORE	GENPL +37D
		VXV	1
		DOT
			GENPL +31D
			GENPL +37D
			GENPL +25D
		STORE	GENPL +45D	# D2
		DMOVE	0
			GENPL +7
		STORE	GENPL +25D
		DMOVE	0
			GENPL +12D
## Page 451
		STORE	GENPL +31D
		DMOVE	0
			GENPL +17D
		STORE	GENPL +37D
		VXV	2
		DOT	DDV
		DMP	RTB
			GENPL +31D
			GENPL +37D
			GENPL +25D
			GENPL +45D
			ERUNITS2
			SGNAGREE
		STORE	DSPTEM2
		EXIT	0
		TC	GRABDSP
		TC	PREGBSY
		TC	BANKCALL
		CADR	FINISH
		
## Page 452

CHKCALC		TC	INTPRET
		RTB	1
		RTB
			ZEROVAC
			FRESHPD
		TSU	1
		TSLT	ROUND
			DATAPL +17D
			DATAPL +2
			12D
		DSU	2
		TSLT	DMP
		DDV
			DATAPL +15D
			DATAPL
			12D
			DC585		# GZ IN 0,1
		TSU	1
		TSLT	ROUND
			DATAPL +22D
			DATAPL +7
			12D
		DSU	2
		TSLT	DMP
		DDV
			DATAPL +20D
			DATAPL +5
			12D
			DC585		# GY IN 2,3
		TSU	1
		TSLT	ROUND
			DATAPL +27D
			DATAPL +12D
			12D
		STORE	TESTTIME
		DSU	2
		TSLT	DMP
		DDV	VDEF
			DATAPL +25D
			DATAPL +10D
			12D
			DC585
			TESTTIME	# G IN 0,1,2,3,4,5
		ABVAL	1
		TSLT	RTB
			0
			1
			SGNAGREE
		STORE	DSPTEM2
		EXIT	0
## Page 453
		TC	GRABDSP
		TC	PREGBSY
		TC	BANKCALL
		CADR	SHOW
		
		TC	INTPRET
		DMOVE	0
			DATAPL +32D
		DMOVE	0
			DATAPL +30D
		DMOVE	2
		VDEF	UNIT
		VSLT
			DATAPL +10D
			1		# V1 IN 6,7,8,9,10,11
		DMOVE	0
			DATAPL +36D
		DMOVE	0
			DATAPL +34D
		DMOVE	2
		VDEF	UNIT
		VSLT
			DATAPL +25D
			1		# V2 IN 12,13,14,15,1 ,17
		
		VXV	3
		ABVAL	TSLT
		DDV	DMP
		RTB
			6
			12D
			1
			TESTTIME
			ERUNITS1
			SGNAGREE
		STORE	DSPTEM2
		EXIT	0
		
		TC	BANKCALL
		CADR	SHOW
		TC	ENDTEST1

## Page 454

STOPHOR		TC	MAKECADR
		TS	RETAA
		TC	INTPRET
		ITC	0
			EARTHR
		ITC	0
			OUTGYR
		EXIT	0
		TC	BANKCALL
		CADR	IMUSTALL
		TC	ENDTEST1
		XCH	RETAA
		TC	BANKJUMP

## Page 455

SCRINTP		TC	MAKECADR
		TS	RETAA
		TC	INTPRET
		NOLOD	1
		TSU
			DATAPL +5
		STORE	0		# T1:T0
		
		NOLOD	1
		TAD
			DATAPL +5
		STORE	DATAPL +5	# TN
		
		TMOVE	2
		TSLT	ROUND
		DMP	DAD
			0
			12D
			GENPL
			GENPL +2
		STORE	GENPL +2
		EXIT	0
		
		CCS	COUNTPL
		TC	SUMSUM1
		
		TC	INTPRET
		LXC,1	0
			RESULTCT	# FIRST=4
		TMOVE	0		# SECOND=9
			DATAPL +5
		STORE	GENPL,1
		DMOVE	0
			GENPL +2
		STORE	GENPL +3,1
		EXIT	0
		XCH	RETAA
		TC	BANKJUMP



SUMSUM1		TC	BANKCALL
		CADR	SUMSUM

## Page 456

FALNED1		TC	INTPRET
		ITC	0
			ALGNINIT
		EXIT	0
		CCS	TESTNDX
		TC	LABTEST1
		TC	+2
		TC	+1
		TC	BANKCALL
		CADR	OGCZERO
		TC	BANKCALL
		CADR	FLTRZERO
FRECT		CAF	BIT7
		TS	STOREPL
		CAF	ZERO		# VERTICAL ERECTION BY NULLING PIPAS
		TS	PIPAX
		TS	PIPAY
		TS	PIPAZ
WARTNEW		CAF	TEN		# CALL A SPADE A SPADE...HOMER
		TS	COUNTPL
		INHINT
		CAF	50DEC
		TC	WAITLIST
		CADR	WARTNEW1
		CAF	WART2ADR
		TC	JOBSLEEP
WART2ADR	CADR	WART2NEW
WARTNEW1	CAF	WART2ADR
		TC	JOBWAKE
		TC	TASKOVER
WART2NEW	TC	INTPRET
		RTB	0
			READPIPS
		STORE	DELVX
		ITC	0
			TJLAL
		EXIT	0
		CCS	COUNTPL
		TC	WARTNEW +1
		TC	INTPRET
		VMOVE	1
		ITC
			FILDELX
			VERTRECT
		ITC	0
			EARTHR
		ITC	0
			OUTGYR
		EXIT	0
		TC	BANKCALL
## Page 457
		CADR	IMUSTALL
		TC	ENDTEST1
		
		CCS	STOREPL
		TC	FRECT +1
		TC	BANKCALL
		CADR	TSTJUMP



LABTEST1	TC	BANKCALL
		CADR	LABTEST
		
## Page 458

SCNBAZ		2DEC	-.27232		# AZIMUTH OF NB IS ERAD IN AS Z AXIS EAST
		2DEC	0
		2DEC	.4194335
LABNBAZ		2DEC	0
		2DEC	0
		2DEC	.5
LABNBAZ1	2DEC	0
		2DEC	0
SCNBVER		2DEC	.4194335
		2DEC	0
		2DEC	.27232
LABNBVER	2DEC	.5
		2DEC	0
		2DEC	0
LBNBVER1	2DEC	0
		2DEC	-.5
V06N66E		OCT	00666
V01N30E		OCT	00130
OMEG/MS		2DEC	.12169524
SCALFTR		2DEC	.64
INTCON1		DEC	40 B+8
		DEC	0
FLNDX		ADRES	GENPL
MTRXLD		DEC	17
DC585		2DEC	585 B+14
ERUNITS		2DEC	4308205 B-28	# CONSTANT CORRECTED FOR SIDEREAL RATE
ERUNITS2	2DEC	38357 B-28
VRECTC3		2DEC	.1
## Page 459
ERUNITS1	2DEC	685683 B-28

## Page 460

ERTHRVEN	RTB	0
			ZEROVAC
		COS	0
			LATITUDE
		DMOVE	0
			ZERODP
		SIN	1
		VDEF	VXSC
			LATITUDE
			OMEG/MS
		STORE	VMARK
		ITCQ	0
