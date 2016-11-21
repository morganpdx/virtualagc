### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	DOWN_TELEMETRY_PROGRAM.agc
## Purpose:	A module for revision 0 of BURST120 (Sunburst). It 
##		is part of the source code for the Lunar Module's
##		(LM) Apollo Guidance Computer (AGC) for Apollo 5.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2016-09-30 RSB	Created draft version.
##		2016-10-21 RSB	Transcribed.
##		2016-10-30 MAS	Corrected NOMDNLIST->NOMDNLST.
##		2016-10-31 RSB	Typos.
##		2016-11-01 RSB	More typos.

## Page 329
# PROGRAM NAME- DOWN TELEMETRY PROGRAM
# MOD NO.- 0
# MOD BY- KILROY
# DATE- 21NOV66
# LOG SECTION- DOWN-TELEMETRY PROGRAM
# ASSEMBLY- REV 12 OF SUNBURST
# FUNCTIONAL DESCRIPTION- THIS ROUTINE IS INITIATED BY TELEMETRY END
#	   PULSE FROM THE DOWNLINK TELEMETRY CONVERTER. THIS PULSE OCCURS
#	   AT 50 TIMES PER SEC(EVERY 20 MS) THEREFORE DODOWNTM IS
#	   EXECUTED AT THESE RATES. THIS ROUTINE SELECTS THE APPROPRIATE
#	   AGC DATA TO BE TRANSMITTED DOWNLINK AND LOADS IT INTO OUTPUT
#	   CHANNELS 34 AND 35. THE INFORMATION IS THEN GATED OUT FROM THE
#	   LGC IN SERIAL FASHION.
#	   THIS PROGRAM IS CODED FOR A 2 SECOND DOWNLIST. SINCE DOWNRUPTS
#	   OCCUR EVERY 20 MS AND 2 AGC COMPUTER WORDS CAN BE PLACED IN
#	   CHANNELS 34 AND 35 DURING EACH DOWNRUPT THE PROGRAM IS CAPABLE
# 	   OF SENDING 200 AGC WORDS EVERY 2 SECONDS.
# CALLING SEQUENCE- NONE
#	   PROGRAM IS ENTERED VIA TCF DODOWNTM WHICH IS EXECUTED AS A
#	   RESULT OF A DOWNRUPT. CONTROL IS RETURNED VIA TCF RESUME WHICH
#	   IN EFFECT IS A RESUME.
# SUBROUTINES CALLED- NONE
# NORMAL EXIT MODE- TCF RESUME
# ALARM OR ABORT EXIT MODE- NONE
# RESTART PROTECTION- NONE.
#	   EXCEPT THAT WHEN A RESTART DOES OCCUR :STARTSUB: WILL
#	   INITIALIZE THE DOWNLIST POINTER TO THE BEGINNING OF THE NOMINAL
#	   DOWNLIST. THIS HAS THE EFFECT OF IGNORING THE REMAINDER OF THE
#	   DOWNLIST WHICH THE DOWN-TELEMETRY PROGRAM WAS WORKING ON WHEN
#	   THE RESTART OCCURRED.
# OUTPUT-  EVERY 2 SECONDS 100 DOUBLE PRECISION WORDS(I.E., 200 LGC
#	   COMPUTER WORDS) ARE TRANSMITTED VIA DOWNLINK.
# ERASABLE INITIALIZATION REQUIRED- NONE
#	   DNTMGOTO,DNLSTADR AND EBANK ARE INITIALIZED IN STARTSUB(FRESH
#	   START AND RESTART)
# DEBRIS (ERASABLE LOCATIONS DESTROYED BY THIS PROGRAM)-
#	   LDATALST,ITEMP1,ITEMP2,DNTMBUFF TO DNTMBUFF + 21D,TMINDEX,DNQ


		BANK	15
		EBANK=	DNTMBUFF
		
ERASZERO	EQUALS	7
DMYECADR	EQUALS	ERASZERO		# USE DMYECADR TO GENERATE A DUMMY ECADR
DMYADRES	EQUALS	ERASZERO		# USE DMYADRES TO GENERATE A DUMMY ADRES
UNKNOWN		EQUALS	ERASZERO		# USE UNKNOWN WHEN THE MNEMONIC IS UNKNOWN
SPARE		EQUALS	ERASZERO		# USE SPARE TO INDICATE AVAILABLE SPACE

LOWIDCOD	OCT	00437
## Page 330


# DODOWNTM IS ENTERED EVERY 20 MS BY AN INTERRUPT TRIGGERED BY THE
# RECEIPT OF AN ENDPULSE FROM THE SPACECRAFT TELEMETRY PROGRAMMER.

# THE ORGANIZATION OF THE PROGRAM IS AS FOLLOWS......
# 1. A MAIN PROGRAM(DODOWNTM) WHICH CONTROLS A SERIES OF SUBROUTINES.
# 2. SUBROUTINES(SENDID,SENDSNAP ETC.) WHICH ARE DESIGNED TO HANDLE
#    SPECIFIC PORTIONS OF THE DOWNLIST.
# 3. :EQUALS: CARDS(NDP1, NDP2, LINCR) WHICH DEFINE NO. OF ITEMS IN THE
#    PORTIONS OF THE DOWNLISTS.
# 4. DOWNLISTS. - DOWNLISTS MUST BE COMPILED IN THE SAME BANK AS THE
#    DOWN-TELEMETRY PROGRAM. THIS IS DONE FOR EASE OF CODING, FASTER
#    EXECUTION AND TO INSURE THAT THE DOWNLIST ID:S(FIRST WORD OF EACH
#    2 SEC DOWNLIST.) ARE UNIQUE. THE LOCATION OF THE AGS DOWNLIST MUST BE
#    2001 OF THE FBANK IN WHICH THE DOWN-TELEMETRY PROGRAM RESIDES.
#    (I.E. AGSLIST = XX,2001). THIS WILL MAKE THE ID WORD FO RTHE AGS
#    DOWNLINK DATA = 00001.

DODOWNTM	TS	BANKRUPT
		EXTEND
		QXCH	QRUPT
		INDEX	DNTMGOTO	# GO TO APPROPRIATE
		TCF	0		# TELEMETRY PHASE
DNPHASE1	TC	SENDID		# SEND ID WORD(S)
		CAF	BIT7		# SET WORD ORDER
		EXTEND			# BACK TO 1 FOR
		WOR	13		# REMAINDER OF CYCLE
		CA	DNLINCR		# CALCULATE ADDRESS OF
		ADS	LDATALST	# SNAPSHOT WORDS TO BE SENT  (GROUP 1)
		TC	SNAPSHOT	# SAVE AND SEND SNAPSHOT WORDS  (GROUP 1)
		CA	DNDP1-1		# PLACE NO. OF DP WORDS IN GROUP 1 INTO A
		TC	SENDDP		# SEND DOUBLE PRECISION WORDS (GROUP 1)
		TC	SENDCH		# SEND CHANNELS 11-14 AND 31-33
		TC	SENDDSTB	# SEND DISPLAY TABLES
		TC	SENDTIME	# SEND TIME1 AND TIME2
		CS	DNSNAP		# CALCULATE ADDRESS OF
		ADS	LDATALST	# SNAPSHOT WORDS TO BE SENT(GROUP 2)
		TC	SNAPSHOT	# SAVE AND SEND SNAPSHOT WORDS  (GROUP 2)
		CA	DNDP2-1		# PLACE NO. OF DP WORDS IN GROUP 2
		TC	SENDDP		# SEND DOUBLE PRECISION WORDS(GROUP 2)
		TC	SENDCH		# SEND CHANNELS 11-14 AND 31-33
		TC	SENDDSTB	# SEND DISPLAY TABLE
		TCF	DNPHASE1	# GO BACK AND START OVER
		
		
# ................................................................................
SENDID		CA	DNLSTADR	# INITIALIZE DOWNLIST ADDRESS AS SELECTED
		TS	LDATALST	# BY A MISSION OR TEST PROGRAM
		CS	BIT7		# SET WORD
		EXTEND			# ORDER BIT 7 IN
## Page 331
		WAND	13		# CHANNEL 13 TO 0
		
		EXTEND			# SET UP DNTMGOTO SO NEXT ENTRY TO
		QXCH	DNTMGOTO	# DODOWNTM WILL TRANSFER CONTROL TO
					# THE INSTRUCTION AFTER TC SENDID.
					
		CAF	LOWIDCOD	# PLACE SPECIAL ID CODE INTO L
		TS	L
		
		CA	LDATALST	# ISOLATE RELATIVE LOC OF DOWNLIST IN THIS
		MASK	LOW10		# FIXED BANK. RESULT = 0000 - 1777. NO
					# CONFLICT OF DUPLICATE ID WORDS CAN OCCUR
					
		TCF	DNTMEXIT	# SEND LIST ID WORD AND SPECIAL ID CODE
		
		
# ................................................................................
SNAPSHOT	EXTEND
		QXCH	DNQ		# SAVE RETURN ADDRESS
		CAF	ZERO		# INITIALIZE THE 
		TS	ITEMP1		# DNTMBUFF INCREMENTER(ITEMP1) TO ZERO.
		CAF	DNSNAP-2	# INITIALIZE LOOP COUNTER(ITEMP2) TO
SNAPLOOP	TS	ITEMP2		# TOTAL NO. OF SNAPSHOT DP WORDS LESS 2.
		AD	LDATALST	# CALCULATE ADDRESS OF NEXT
		EXTEND			# ENTRY IN DOWNLIST
		INDEX	A		# PICK UP THE DOUBLE PRECISION WORD FROM
		INDEX	0		# THE NEXT ENTRY
		DCA	0		# IN THE DOWNLIST.
		INDEX	ITEMP1		# AND SAVE IT IN THE NEXT AVAILABLE LOC
		DXCH	DNTMBUFF	# IN DNTMBUFF SNAPSHOT BUFFER.
		CAF	TWO		# INCREMENT DNTMBUFF INCREMENTER(ITEMP1)
		ADS	ITEMP1		# BY 2.
		CCS	ITEMP2		# HAVE ALL SNAPSHOT DP WORDS BEEN SAVED...
		TCF	SNAPLOOP	# NO--GO BACK AND CONTINUE SAVING THEM
		CAF	DNSNAP-1	# YES--PLACE NO. OF DP WORDS REMAINING
		TS	TMINDEX		# TO BE SENT INTO TMINDEX.
		CAF	LSENDSNP	# SET UP DNTMGOTO SO PROGRAM CONTROL WILL
		TS	DNTMGOTO	# BE TRANSFERRED TO SENDSNAP ON NEXT
					# ENTRY TO DODOWNTM.
		EXTEND			# PICK UP FIRST DP SNAPSHOT WORD
		INDEX	LDATALST	# AND PLACE IT IN A + L.
		INDEX	NSNAP	-1	# (((THIS ADDITIONAL CODING ALTHOUGH A BIT
		DCA	0		# SUPERFLUOUS IS JUSTIFIED BECAUSE IT
					# SAVES 2 WORDS OF ERASABLE STORAGE)))
		TCF	DNTMEXIT	# GO SEND FIRST SNAPSHOT DP ENTRY.
SENDSNAP	CCS	TMINDEX		# ANY SNAPSHOT WORDS LEFT IN BUFFER
		TCF	+2		# YES--GO PROCESS THEM
		TC	DNQ		# NO--RETURN TO INSTRUCTION AFTER
					#                          TC SNAPSHOT.
					
## Page 332
		TS	TMINDEX		# SAVE COUNT OF SNAPSHOT WORDS REMAINING
		DOUBLE			# CALCULATE DECREMENTER
		COM			# FOR NEXT DP WORD IN
		EXTEND			# BUFFER.
		INDEX	A
		DCA	DNTMBUFF +20D	# TAKE NEXT DP WORD OUT OF BUFFER, PLACE
		TCF	DNTMEXIT	# IT INTO A + L AND GO SEND IT.
NSNAP		EQUALS	12D		# NUMBER OF DP SNAPSHOT WORDS
DNSNAP		ADRES	NSNAP		# NO. OF DP SNAPSHOT WORDS  CONSTANT
DNSNAP-1	ADRES	NSNAP	-1	# NO. OF DP SNAPSHOT WORDS -1  CONSTANT
DNSNAP-2	ADRES	NSNAP	-2	# NO. OF DP SNAPSHOT WORDS -2  CONSTANT
LSENDSNP	ADRES	SENDSNAP	# LOC OF ROUTINE WHICH SENDS SNAPSHOT BUFF
		
		
# ................................................................................
SENDDP		EXTEND			# ENTER WITH NO. DP WORDS REMAINING TO
		QXCH	DNQ		# BE SEND IN A. SAVE RETURN ADDRESS.
		TS	TMINDEX		# PLACE NO. OF DP WORDS TO BE SENT AFTER
		AD	ONE		# THIS ONE INTO TMINDEX. CALCULATE NEXT
		COM			# LOCATION IN DOWNLIST AND SAVE
		ADS	LDATALST	# IT IN LDATALST.
		CAF	LSENDDPA	# SET UP DNTMGOTO SO PROGRAM CONTROL WILL
		TS	DNTMGOTO	# GO TO SENDDPA ON NEXT ENTRY TO DODOWNTM.
		CAE	TMINDEX		# PLACE NO. OF WORDS REMAINING TO BE SENT
SENDDPB		TS	TMINDEX		# INTO A. SAVE NO. DP WORDS TO BE SENT.
		AD	LDATALST	# CALCULATE NEXT DOWNLIST ENTRY.
		INDEX	A
		CA	0		# PICK UP ECADR OF NEXT DOWNLIST ENTRY.
		TS	EBANK		# SET EBANK.
		MASK	LOW8		# ISOLATE RELATIVE ADDRESS.
		EXTEND
		INDEX	A		# PICK UP DOUBLE PRECISION
		DCA	3400		# WORD INTO A + L.  (DCA 3400 = DCA 1400)
		
DNTMEXIT	EXTEND			# GENERAL DOWN-TELEMETRY EXIT
		WRITE	DNTM1		# TO SEND A + L TO CHANNELS 34 + 35
		CA	L		# RESPECTIVELY.
		
TMEXITL		EXTEND			# ALTERNATE DOWN TELEMETRY EXIT
		WRITE	DNTM2		# TO SEND A TO CHANNEL 35.
		TCF	RESUME		# EXIT DOWN TELEMETRY PROG VIA RESUME.
		
SENDDPA		CCS	TMINDEX		# ANY DP WORDS REMAINING TO BE SENT.
		TCF	SENDDPB		# YES--GO SEND THEM.
		TC	DNQ		# RETURN TO INSTR AFTER TC SENDDP.
LSENDDPA	ADRES	SENDDPA		# LOC OF ROUTINE WHICH SENDS DP WORDS.
	
		
# ................................................................................
SENDCH		EXTEND
## Page 333
		QXCH	DNQ		# SAVE RETURN ADDRESS
		CAF	LSENDCHA	# SET UP DNTMGOTO SO PROG CONTROL WILL GO
		TS	DNTMGOTO	# TO SENDCHA ON NEXT ENTRY TO DODOWNTM
		CAF	THREE		# PLACE NO. OF PAIRS OF CHANNELS TO BE
					# SENT AFTER THIS PAIR INTO A.
SENDCHB		TS	TMINDEX		# SAVE NO. OF PAIRS OF CHANNELS REMAINING
		EXTEND			# TO BE SENT INTO A. PICK UP CHANNEL
		INDEX	A		# ADDRESS FROM
		INDEX	FIXLSTCL	# NEXT ENTRY IN FIXLSTCL.
		READ	0		# PLACE CONTENTS OF THE
		TS	L		# CHANNEL INTO L.
		EXTEND			# PICK UP NEXT CHANNEL
		INDEX	TMINDEX		# ADDRESS FROM NEXT ENTRY
		INDEX	FIXLSTCA	# IN FIXLSTCA.
		READ	0		# PLACE CONTENTS OF CHANNEL INTO A.
		TCF	DNTMEXIT	# NOW GO SEND A + L.
SENDCHA		CCS	TMINDEX		# ANY MORE CHANNEL PAIRS TO BE SENT......
		TCF	SENDCHB		# YES--GO SEND THEM.
		TC	DNQ		# NO--RETURN TO INSTR AFTER TC SENDCH.
LSENDCHA	ADRES	SENDCHA		# LOCATION OF ROUTINE WHICH SENDS CHANNELS
FIXLSTCA	OCT	32		# CHANNEL 32
		OCT	30		# CHANNEL 30
		OCT	13		# CHANNEL 13
		OCT	11		# CHANNEL 11
FIXLSTCL	OCT	33		# CHANNEL 33
		OCT	31		# CHANNEL 31
		OCT	14		# CHANNEL 14
		OCT	12		# CHANNEL 12
	
		
# ................................................................................
SENDDSTB	EXTEND
		QXCH	DNQ		# SAVE RETURN ADDRESS
		CAF	LSENDDSA	# SET UP DNTMGOTO SO PROGRAM CONTROL WILL
		TS	DNTMGOTO	# GO TO SENDDSA ON NEXT ENTRY TO DODOWNTM.
		CAF	FIVE		# PLACE NO. OF PAIRS OF DSPTAB WORDS REM
SENDDSB		TS	TMINDEX		# AFTER THIS PAIR INTO A. SAVE NO. REMAIN-
		DOUBLE			# ING INTO TMINDEX. CALCULATE DECREMENTER
		COM			# FOR NEXT PAIR OF WORDS(SP)
		EXTEND			# IN DSPTAB.
		INDEX	A		# PICK UP PAIR OF DSPTAB WORDS(SP) AND
		DCA	DSPTAB	+10D	# LEAVE THEM IN A + L.
		TCF	DNTMEXIT	# NOW GO SEND A + L.
SENDDSA		CCS	TMINDEX		# ANY WORDS LEFT IN DSPTAB TO BE SENT.....
		TCF	SENDDSB		# YES--GO SEND THEM
		TC	DNQ		# NO--RETURN TO INSTR AFTER TC SENDDSTB.
LSENDDSA	ADRES	SENDDSA		# LOC OF ROUTINE WHICH SENDS DISPLAY TABLE

		
# ................................................................................
## Page 334
SENDTIME	EXTEND			# SET P DNTMGOTO SO PROGRAM CONTROLL WILL
		QXCH	DNTMGOTO	# GO TO INSTRUCTION AFTER TC SENDTIME.
		EXTEND
		DCA	TIME2		# PLACE TIME2 AND TIME1 INTO A AND L.
		TCF	DNTMEXIT	# NOW GO SEND A AND L.
	
		
# ................................................................................
DNDP1-1		ADRES	NDP1	-1	# NO. OF DP WORDS IN GROUPS 1 LESS 1
DNDP2-1		ADRES	NDP2	-1	# NO. OF DP WORDS IN GROUPS 2 LESS 1	
DNLINCR		ADRES	LINCR		# RELATIVE LOC OF FIRST GROUP IN DOWNLIST.
# ................................................................................
# ********************************************************************************
# CHANGE THE FOLLOWING 3 EQUALS CARDS WHEN MODIFYING THE STRUCTURE OF THE
# DOWNLISTS.
NDP1		EQUALS	27D		# NUMBER OF DP WORDS  (GROUP 1)
NDP2		EQUALS	27D		# NUMBER OF DP WORDS  (GROUP 2)
LINCR		EQUALS	66D		# LINCR   = NDP1 + NDP2 + 12D
# ********************************************************************************

## Page 335
# NOMINAL SUNBURST (AS206) 2 SECOND DOWNLIST
# AS OF DATE = 02FEB67

# LAST ENTRY IN DOWNLIST WILL BE SENT FIRST, THEN LAST ENTRY - 1  ETC.----
NOMDNLST	EQUALS
UPDNLIST	EQUALS	NOMDNLST	# NOT USED IN 206.
# ----------------------------DISPLAY TABLES--------------------------------------
#                                       DSPTAB +10D AND DSPTAB +11D
#                                       DSPTAB +8D AND DSPTAB +9D
#					DSPTAB +6  AND DSPTAB +7
#					DSPTAB +4  AND DSPTAB +5
#  					DSPTAB +2  AND DSPTAB +3
#					DSPTAB     AND DSPTAB +1
# -----------------------------CHANNELS-------------------------------------------
#					CHANNELS 32 AND 33
#					CHANNELS 30 AND 31
#					CHANNELS 13 AND 14
# 					CHANNELS 11 AND 12
# -------------------DOUBLE PRECISION - ANY EBANK  (GROUP 2)----------------------
		ECADR	STATE	+2	# (FLAGWRD2,DAPBOOLS) FLAGWORDS
		ECADR	STATE		# (STATE,FLAGWRD1) FLAGWORDS
		ECADR	OMEGAR	-1	# (GARBAGE,OMEGAR) ANGULAR RATES ABOUT THE
		ECADR	OMEGAP		# (OMEGAP,OMEGAQ) P,Q,R BODY AXES  (DAP)
					# SCALED AT 45 DEG/SEC.
		ECADR	CDUY		# (CDUY,CDUZ) ACTUAL CDU:S
		ECADR	CDUX	-1	# (GARBAGE, CDUX) ACTUAL CDU:S
		ECADR	RD	+4	# APS2 DESIRED RADIUS VECTOR IN STABLE
		ECADR	RD	+2	# MEMBER CO-ORDINATES.
		ECADR	RD		# SCALED METERS X 2(-25).
		ECADR	VDVECT	+4	# APS2,DPS1 DESIRED VELOCITY VECTOR IN
		ECADR	VDVECT	+2	# STABLE MEMBER CO-ORDINATES.
		ECADR	VDVECT		# SCALED M/CS X 2(-7).
		ECADR	VGVECT	+4	# APS2,DPS1 VELOCITY IN GAINED SCALED
		ECADR	VGVECT	+2	# M/CS X 2(-7). IN LOCAL VERTICAL (APS2)
		ECADR	VGVECT		# OR STABLE MEMBER (DPS1).
		ECADR	TTGO		# ESTIMATED TIME TO GO IN CS(APS2,DPS1,2).
		ECADR	PHASENUM	# (PHASENUM,1/PIPADT)PRESENT MISSION PHASE
					# , IMU COMP TIME BASE OR DT IN C.S.
		ECADR	MTIMER2		# (MTIMER2,MTIMER1) REGISTERS CONTAINING
		ECADR	MTIMER4		# (MTIMER4,MTIMER3) DELTA T:S OF MP:S.
		ECADR	MPHASE2		# (MPHASE2,MPHASE1) REGISTERS CONTAINING
		ECADR	MPHASE4		# (MPHASE4,MPHASE3) MP:S TO BE CALLED.
		ECADR	DELAREA		# SCALED IN UNITS OF 2(7) PERCENT INCREASE
		ECADR	LMPIN		# (LMPIN,LMPOUT)
		ECADR	LMPCMD	+6	# OUTPUT TO LMP = REGISTERS
		ECADR	LMPCMD	+4	# CONTAINING THE
		ECADR	LMPCMD	+2	# LAST EIGHT LMP COMMANDS
		ECADR	LMPCMD		# TO BE SENT BY THE LGC.
# ---------SNAPSHOT DP WORDS FROM EBANK E7 OR UNSWITCHABLE ERASABLE(GROUP 2)------
		ADRES	CDUY		# (CDUY,CDUZ)
## Page 336
		ADRES	CDUY		# (CDUY,CDUZ)
		ADRES	MASS		# MASS  SCALED IN UNITS OF 2(15) KGS.
		ADRES	STATE	+4	# (STATE +4,GARBAGE) LAMBERT FLAGS
		ADRES	PIPAZ		# (PIPAZ,GARBAGE) ACTUAL Z PIP COUNTS.
		ADRES	PIPAX		# (PIPAX,PIPAY) ACTUAL X,Y PIP COUNTS.
		ADRES	ALMCADR	+1	# (ALMCADR +1,ERCOUNT)ALM LOC BBCON,SLFCK
					# FAIL COUNTER.
		ADRES	FAILREG	+2	# (FAILREG +2,ALMCADR)ALM CODE,ALM LOC Q.
		ADRES	FAILREG		# (FAILREG, +1)LAST AND PREV. ALARM CODES.
		ADRES	COMPTORK +4	# E)GYROCOMPASS GYRO TORQUES IN VERTICAL,
		ADRES	COMPTORK +2	# S)SOUTH, EAST SYSTEM,ERATE NOT INCLUDED.
		ADRES	COMPTORK	# V) 37777,37777 = (1 - 2(-28))REVS.
#------------------------------------LGC CLOCK------------------------------------
#					TIME2 AND TIME1
# ----------------------------DISPLAY TABLES--------------------------------------
#                                       DSPTAB +10D AND DSPTAB +11D
#                                       DSPTAB +8D AND DSPTAB +9D
#					DSPTAB +6  AND DSPTAB +7
#					DSPTAB +4  AND DSPTAB +5
#  					DSPTAB +2  AND DSPTAB +3
#					DSPTAB     AND DSPTAB +1
# -----------------------------CHANNELS-------------------------------------------
#					CHANNELS 32 AND 33
#					CHANNELS 30 AND 31
#					CHANNELS 13 AND 14
# 					CHANNELS 11 AND 12
# -------------------DOUBLE PRECISION - ANY EBANK  (GROUP 1)----------------------
		ECADR	STATE	+2	# (FLAGWRD2,DAPBOOLS) FLAGWORDS
		ECADR	STATE		# (STATE,FLAGWRD1) FLAGWORDS
		ECADR	OMEGAR	-1	# (GARBAGE,OMEGAR) ANGULAR RATES ABOUT THE
		ECADR	OMEGAP		# (OMEGAP,OMEGAQ) P,Q,R BODY AXES  (DAP)
					# SCALED AT 45 DEG/SEC.
		ECADR	CDUY		# (CDUY,CDUZ) ACTUAL CDU:S
		ECADR	CDUX	-1	# (GARBAGE, CDUX) ACTUAL CDU:S
		ECADR	REDOCTR		# (REDOCTR,SFAIL)RESTART CTR,FLFCK FAIL Q.
		ECADR	TIGN		# TIME FOR ENGINE ON IN CS (MP'S 9,11,13).
		ECADR	AOSQ		# (AOSQ,AOSR) MOMENT OFFSET(Q,R)
					# SCALED AT 90 DEG/SEC/SEC.
		ECADR	FC		# THRUST COMMAND SCALED 3 LBS X 2(-14).
		ECADR	TEVENT		# TIME OF GRR, LIFTOFF, ENGINE ON/OFF (CS)
		ECADR	IMODES30	# (IMODES30,IMODES33) PGNCS FLAGWORDS.
		ECADR	STBUFF	+12D	# STBUFF = 14 REGISTERS
		ECADR	STBUFF	+10D	# IN WHICH THE UPLINKED DATA
		ECADR	STBUFF	+8D	# IS PLACED FOR GROUND
		ECADR	STBUFF	+6D	# DISPLAY AND VERIFICATION
		ECADR	STBUFF	+4D	# BEFORE PLACEMENT
		ECADR	STBUFF	+2D	# IN THE APPROPRIATE
		ECADR	STBUFF		# ERASABLE LOCATIONS
		ECADR	STCOUNT		# (STCOUNT,UPOLDMD)
		ECADR	UPVERB		# (UPVERB,COMPNUMB)
## Page 337
		ECADR	ALPHAR		# (ALPHAR,GARBAGE)DIST, ACC, ABOUT R-AXIS
		ECADR	LMPIN		# (LMPIN,LMPOUT)
		ECADR	LMPCMD	+6	# OUTPUT TO LMP = REGISTERS
		ECADR	LMPCMD	+4	# CONTAINING THE
		ECADR	LMPCMD	+2	# LAST EIGHT LMP COMMANDS
		ECADR	LMPCMD		# TO BE SENT BY THE LGC.
# ---------SNAPSHOT DP WORDS FROM EBANK E7 OR UNSWITCHABLE ERASABLE(GROUP 1)------
		ADRES	DELVZ		# THE CHANGE IN VELOCITY ALONG
		ADRES	DELVY		# EACH OF THE STABLE MEMBER AXES IN THE 
		ADRES	DELVX		# 2 SEC INTERVAL PRECEEDING PIPTIME.
		ADRES	CDUYD		# (CDUYD,CDUZD)  DESIRED CDU:S
		ADRES	CDUXD	-1	# (GARBAGE,CDUXD)  DESIRED CDU:S
		ADRES	STATIME		# TIME FOR RN AND VN IN CENTISECONDS
		ADRES	VN	+4	# AVE.G/ORBIT.INT. STATE VECTOR Z VEL
		ADRES	VN	+2	# AVE.G/ORBIT.INT. STATE VECTOR Y VEL
		ADRES	VN		# AVE.G/ORBIT.INT. STATE VECTOR X VEL
					# VN IN SCALED METERS/CS X 2(-7).
		ADRES	RN	+4	# AVE.G/ORBIT.INT. STATE VECTOR Z VEL
		ADRES	RN	+2	# AVE.G/ORBIT.INT. STATE VECTOR Y VEL
		ADRES	RN		# AVE.G/ORBIT.INT. STATE VECTOR X VEL
					# RN IN SCALED METERS X 2(-7).
# ----------------------------------ID WORDS--------------------------------------
#					I.D., SYNCH BITS
# -------------START HERE AND READ BACK FOR CONTENTS OF DOWNLIST------------------

## Page 338
# SPECIAL DOWN-LINK PROGRAM TO SEND SAMPLES OF CDUY & Z, AND TO TURN THE DAP BACK ON.

DNCDUS		CA	LOW10		# MAKE THIS ID UNIQUE.
		TC	SENDID	+1	# SEND ID & EXIT.
		
		CAF	BIT7		# ENTER HERE THE SECOND TIME.
		EXTEND
		WOR	13		# SET WORD ORDER CODE =1
		CA	LDNCDUGO
		TS	DNTMGOTO	# SET DNTMGOTO FOR NEXT CDUY,Z DOWN TM PAS
		CA	DNCDUN		# INITIALIZE DOWN CDUY,Z COUNTER
# START CODING FOR MODULE 3 REMAKE, AUGUST 1967***START CODING FOR MODULE 3 REMAKE, AUGUST 1967******************

		TCF	15INSRT		# TERMINATE GIMBAL DRIVES, IF ANY.
		
# **END CODING FOR MODULE 3 REMAKE, AUGUST 1967*****END CODING FOR MODULE 3 REMAKE, AUGUST 1967******************

DNCDUSGO	CA	ONE		# ENTER HERE THE THIRD TIME, & AFTER.
 +1		TS	ITEMP1		# SET UP INDEX FOR CDU ERROR CHECK.
 		INDEX	A
 		CA	CDUYD		# PICK UP CDUD FOR COMPARISON WITH CDU.
 		EXTEND
 		INDEX	ITEMP1
 		MSU	CDUY		# GET DIFFERENCE BETWEEN ACTUAL CDU & CDUD
 		EXTEND
 		BZMF	+2		# GET NEG OF ABSOLUTE MAG OF DIFFERENCE
 		COM
 		AD	CDULMIT		# COMPARE DIFFERENCE WITH ALLOWED MAXIMUM.
 		EXTEND
 		BZMF	DNCDUEND	# IF ERROR IS TOO BIG, RESTORE DAP NOW.
 		
 		CCS	ITEMP1		# IS CHECK COMPLETE?
 		TCF	DNCDUSGO +1	# NO.  GO CHECK CDUY.
 		
 		CCS	DNCDUCNT	# YES.  ARE WE THRU SENDING CDU'S?
 		TCF	+2		# NO.
 		TCF	DNCDUEND	# YES.
 		
 		TS	DNCDUCNT
FETCHCDU	EXTEND
		DCA	CDUY		# PICK UP CDUY AND CDUZ
		TCF	DNTMEXIT	# GO SEND THEM
		
DNCDUEND	CA	OLDDVSEL
		TS	DVSELECT
		
		CS	DAPBOOLS	# RESTORE GODAPGO TO TURN DAP BACK ON.
		MASK	GODAPGO
		ADS	DAPBOOLS
		
## Page 339
		CA	LDNFAZE1	# REESTABLISH THE NORMAL DOWNLIST.
		TS	DNTMGOTO
		
		TCF	FETCHCDU	# SEND THE FINAL CDU PAIR.

LDNFAZE1	ADRES	DNPHASE1
LDNCDUGO	ADRES	DNCDUSGO
