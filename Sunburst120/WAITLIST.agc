### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     WAITLIST.agc
## Purpose:      A module for revision 0 of BURST120 (Sunburst). It 
##               is part of the source code for the Lunar Module's
##               (LM) Apollo Guidance Computer (AGC) for Apollo 5.
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      www.ibiblio.org/apollo/index.html
## Pages:        1062-1074
## Mod history:  2016-09-30 RSB  Created draft version.
##               2016-10-10 PDJ  Updated based on Sunburst120 scans. 

## Page 1062

# PROGRAM DESCRIPTION--                                                         DATE -- 10 OCTOBER 1966
# MOD NO -- 2                                                                   LOG SECTION -- WAITLIST
# MOD BY -- MILLER      (DTMAX INCREASED TO 162.5 SEC)                          ASSEMBLY -- SUNBURST REV 5

# FUNCTIONAL DESCRIPTION --
#       PART OF A SECTION OF PROGRAMS -- WAITLIST, TASKOVER, T3RUPT, USED TO CALL A PROGRAM (CALLED A TASK),
#       WHICH IS TO BEGIN IN C(A) CENTISECONDS.  WAITLIST UPDATES TIME3, LST1, AND LST2.  THE MEANING OF THESE LISTS
#       FOLLOW.
#
#               C(TIME3) = 16384 -(T1-T) CENTISECONDS, (T=PRESENT TIME, T1-TIME FOR TASK1)
#
#                       C(LST1)         =       -(T2-T1)+1
#                       C(LST1 +1)      =       -(T3-T2)+1
#                       C(LST1 +2)      =       -(T4-T3)+1
#                                      ...
#                                      ...
#                       C(LST1 +6)      =       -(T8-T7)+1
#                       C(LST1 +7)      =       -(T9-T8)+1
#
#                       C(LST2)         =       2CADR OF TASK1
#                       C(LST2 +2)      =       2CADR OF TASK2
#                                      ...
#                                      ...
#                       C(LST2 +14)     =       2CADR OF TASK8
#                       C(LST2 +16)     =       2CADR OF TASK9

# WARNINGS --
# -----------
#       1)      1 <= C(A) <= 16250D (1 CENTISECOND TO 162.5 SEC)
#       2)      9 TASKS MAXIMUM
#       3)      TASKS CALLED UNDER INTERRUPT INHIBITED
#       4)      TASKS END BY TC TASKOVER

# CALLING SEQUENCE --
#       L-2     CAF     DELTAT  (TIME IN CENTISECONDS TO TASK START)
#       L-1     INHINT
#       L       TC      WAITLIST
#       L+1     2CADR   DESIRED TASK
#       L+2     (MINOR OF 2CADR)
#       L+3     RELINT          (RETURNS HERE)

# NORMAL EXIT MODES --
#
#       AT L+3 OF CALLING SEQUENCE.

# ALARM OR ABORT EXIT MODES --

## Page 1063

#       TC      ABORT
#       OCT     1203    (WAITLIST OVERFLOW -- TOO MANY TASKS)

# ERASABLE INITIALIZATION REQUIRED --
#       ACCOMPLISHED BY FRESH START --  LST2, ..., LST2 +16 =ENDTASK
#                                       LST1, ..., LST1 +7  =NEG1/2

# OUTPUT --
#       LST1 AND LST2 UPDATED WTIH NEW TASK AND ASSOCIATED TIME.

# DEBRIS --
#       CENTRALS -- A,Q,L
#       OTHER    -- WAITEXIT, WAITADR, WAITTEMP, WAITBANK
# DETAILED ANALYSIS OF TIMING --
#
#       CONTROL WILL NOT BE RETURNED TO THE SPECIFIED ADDRESS (2CADR) IN EXACTLY DELTA T CENTISECONDS.
#       THE APPROXIMATE TIME MAY BE CALCULATED AS FOLLOWS
#
#               LET T0 = THE TIME OF THE TC WAITLIST
#               LET TS = T0 +147U + COUNTER INCREMENTS (SET UP TIME)
#               LET X  = TS -(100TS)/100  (VARIANCE FROM COUNTERS)
#               LET Y  = LENGTH OF TIME OF INHIBIT INTERRUPT AFTER T3RUPT
#               LET Z  = LENGTH OF TIME TO PROCESS TASKS WHICH ARE DUE THIS T3RUPT BUT DISPATCHED EARLIER.
#                        (Z=0, USUALLY).
#               LET DELTD  = THE ACTUAL TIME TAKEN TO GIVE CONTROL TO 2CADR
#               THEN DELTD = TS+DELTA T -X +Y +Z +1.05MS* +COUNTERS*
#
#               *-THE TIME TAKEN BY WAITLIST ITSELF AND THE COUNTER TICKING DURING THIS WAITLIST TIME.
#       IN SHORT, THE ACTUAL TIME TO RETURN CONTROL TO A 2CADR IS AUGMENTED BY THE TIME TO SET UP THE TASK'S
#       INTERRUPT, ALL COUNTERS TICKING, THE T3RUPT PROCESSING TIME, THE WAITLIST PROCESSING TIME AND THE POSSIBILITY
#       OF OTHER TASKS INHIBITING THE INTERRUPT.

                BLOCK           02                              
                EBANK=          LST1                            # TASK LISTS IN SWITCHED E BANK.

WAITLIST        XCH             Q                               # SAVE DELTA T IN Q AND RETURN IN                                          
                TS              WAITEXIT                        # WAITEXIT.
                EXTEND                                          
                INDEX           A                               
                DCA             0                               # PICK UP 2CADR OF TASK.
                TS              WAITADR                         # BBCON WILL REMAIN IN L
DLY2            CAF             WAITBB                          # ENTRY FROM FIXDELAY AND VARDELAY.
                XCH             BBANK                           
                TCF             WAIT2                           

# RETURN TO CALLER AFTER TASK INSERTION:

## Page 1064

LVWTLIST        CA              WAITBANK                        
                TS              BBANK                          
                INDEX           WAITEXIT
                TC              2                                            

                EBANK=          LST1                            
WAITBB          BBCON           WAIT2                           

# RETURN TO CALLER +2 AFTER WAITING DT SPECIFIED AT CALLER +1.

FIXDELAY        INDEX           Q                               # BOTH ROUTINES MUST BE CALLED UNDER
                CAF             0                               # WAITLIST CONTROL AND TERMINATE THE TASK
                INCR            Q                               # IN WHICH THEY WERE CALLED.

# RETURN TO CALLER +1 AFTER WAITING THE DT AS ARRIVING IN A.

VARDELAY        XCH             Q                               # DT TO Q.  TASK ADRES TO WAITADR.
                TS              WAITADR                         
                CA              BBANK                           # BBANK IS SAVED DURING DELAY.
                TS              L                               
                CAF             DELAYEX                         
                TS              WAITEXIT                        # GO TO TASKOVER AFTER TASK ENTRY.
                TCF             DLY2                            

DELAYEX         TCF             TASKOVER        -2              # RETURNS TO TASKOVER.

## Page 1065

# ENDTASK MUST ENTERED IN FIXED-FIXED SO IT IS DISTINGUISHABLE BY ITS ADRES ALONE.

                EBANK=          LST1                            
ENDTASK         -2CADR          SVCT3                           

SVCT3           CCS             FLAGWRD2                        # DRIFT FLAG
                TCF             TASKOVER                        
                TCF             TASKOVER                        
                TCF             +1                              

                CAF             PRIO35                          # COMPENSATE FOR NBD COEFFICIENTS ONLY.
                TC              NOVAC                           #       ENABLE EVERY 81.93 SECONDS
                EBANK=          NBDX                            
                2CADR           NBDONLY                         

                TCF             TASKOVER                        

## Page 1066

# BEGIN TASK INSERTION.

                BANK            01                              
WAIT2           TS              WAITBANK                        # BBANK OF CALLING PROGRAM.
                CS              TIME3                           
                AD              BIT8                            # BIT 8 = OCT 200
                CCS             A                               # TEST 200 - C(TIME3).  IF POSITIVE,
                                                                # IT MEANS THAT TIME3 OVERFLOW HAS OCCURRED PRIOR TO CS TIME3 AND THAT
                                                                # C(TIME3) = T - T1, INSTEAD OF 1.0 - (T1 - T).  THE FOLLOWING FOUR
                                                                # ORDERS SET C(A) = TD - T1 + 1 IN EITHER CASE.

                AD              OCT40001                        # OVERFLOW HAS OCCURRED.  SET C(A) =
                CS              A                               # T - T1 + 1.0 - 201

# NORMAL CASE (C(A) NNZ) YIELDS SAME C(A):  -( -(1.0-(T1-T)) + 200) - 1

                AD              OCT40201                        
                AD              Q                               # RESULT = TD - T1 + 1.

                CCS             A                               # TEST TD - T1 + 1.

                AD              LST1                            # IF TD - T1 POS, GO TO WTLST5 WITH
                TCF             WTLST5                          # C(A) = (TD - T1) + C(LST1) = TD-T2+1

                NOOP                                            
                CS              Q                               

# NOTE THAT THIS PROGRAM SECTION IS NEVER ENTERED WHEN T-T1 G/E -1,
# SINCE TD-T1+1 = (TD-T) + (T-T1+1), AND DELTA T = TD-T G/E +1.  (G/E
# SYMBOL MEANS GREATER THAN OR EQUAL TO).  THUS THERE NEED BE NO CON-
# CERN OVER A PREVIOUS OR IMMINENT OVERFLOW OF TIME3 HERE.

                AD              POS1/2                          # WHEN TD IS NEXT, FORM QUANTITY
                AD              POS1/2                          #       1.0 - DELTA T = 1.0 - (TD - T)
                XCH             TIME3                           
                AD              NEGMAX                          
                AD              Q                               # 1.0 - DELTAT T NOW COMPLETE.
                EXTEND                                          # ZERO INDEX Q.
                QXCH            7                               # (ZQ)

## Page 1067
WTLST4          XCH             LST1                            
                XCH             LST1            +1              
                XCH             LST1            +2              
                XCH             LST1            +3              
                XCH             LST1            +4              
                XCH             LST1            +5              
                XCH             LST1            +6              
                XCH             LST1            +7              

                CA              WAITADR                         # (MINOR PART OF TASK CADR HAS BEEN IN L.)
                INDEX           Q                               
                TCF             +1                              

                DXCH            LST2                            
                DXCH            LST2            +2              
                DXCH            LST2            +4              
                DXCH            LST2            +6              
                DXCH            LST2            +8D             
                DXCH            LST2            +10D            # AT END, CHECK THAT C(LST2+10) IS STD
                DXCH            LST2            +12D            
                DXCH            LST2            +14D            
                DXCH            LST2            +16D            
                AD              ENDTASK                         # END ITEM, AS CHECK FOR EXCEEDING
                                                                # THE LENGTH OF THE LIST.
                EXTEND                                          # DUMMY TASK ADRES SHOULD BE IN FIXED-
                BZF             LVWTLIST                        # FIXED SO ITS ADRES ALONE DISTINGUISHES
                TCF             WTABORT                         # IT.

## Page 1068

WTLST5          CCS             A                               # TEST TD - T2 + 1
                AD              LST1            +1              
                TCF             +4                              
                AD              ONE                             
                TC              WTLST2                          
                OCT             1                               

 +4             CCS             A                               # TEST TD - T3 + 1
                AD              LST1            +2              
                TCF             +4                              
                AD              ONE                             
                TC              WTLST2                          
                OCT             2                               

 +4             CCS             A                               # TEST TD - T4 + 1
                AD              LST1            +3              
                TCF             +4                              
                AD              ONE                             
                TC              WTLST2                          
                OCT             3                               

 +4             CCS             A                               # TEST TD - T5 + 1
                AD              LST1            +4              
                TCF             +4                              
                AD              ONE                             
                TC              WTLST2                          
                OCT             4                               

 +4             CCS             A                               # TEST TD - T6 + 1
                AD              LST1            +5              
                TCF             +4                              
                AD              ONE                             
                TC              WTLST2                          
                OCT             5                               

 +4             CCS             A                               # TEST TD - T7 + 1
                AD              LST1            +6              
                TCF             +4                              
                AD              ONE                             
                TC              WTLST2                          
                OCT             6                               

## Page 1069

 +4             CCS             A                              
                AD              LST1            +7              
                TCF             +4                              
                AD              ONE                             
                TC              WTLST2                          
                OCT             7                               

 +4             CCS             A                               
WTABORT         TC              ABORT                           # NO ROOM IN THE INN.                         
                OCT             1203
   
                AD              ONE                             
                TC              WTLST2                          
                OCT             10                              

OCT40201        OCT             40201                           

## Page 1070

# THE ENTRY TC WTLST2 JUST PRECEDING OCT N IS FOR T  LE TD LE T   -1.
#                                                  N           N+1
# (LE MEANS LESS THAN OR EQUAL TO).  AT ENTRY, C(A) = -(TD - T   + 1)
#                                                             N+1
# THE LST1 ENTRY -(T   -T +1) IS TO BE REPLACED BY -(TD - T  + 1), AND
#                   N+1  N                                 N
# THE ENTRY -(T   - TD + 1) IS TO BE INSERTED IMMEDIATELY FOLLOWING.
#              N+1

WTLST2          TS              WAITTEMP                        # C(A) = -(TD - T + 1)
                INDEX           Q                               
                CAF             0                               
                TS              Q                               # INDEX VALUE INTO Q.

                CAF             ONE                             
                AD              WAITTEMP                        
                INDEX           Q                               # C(A) = -(TD - T ) + 1.
                ADS             LST1            -1              #                N

                CS              WAITTEMP                        
                INDEX           Q                               
                TCF             WTLST4                          

#       C(TIME3)        =       1.0 - (T1 - T)

#       C(LST1)         =       - (T2 - T1) + 1
#       C(LST1+1)       =       - (T3 - T2) + 1
#       C(LST1+2)       =       - (T4 - T3) + 1
#       C(LST1+3)       =       - (T5 - T4) + 1
#       C(LST1+4)       =       - (T6 - T5) + 1

#       C(LST2)         =       2CADR TASK1
#       C(LST2+2)       =       2CADR TASK2
#       C(LST2+4)       =       2CADR TASK3
#       C(LST2+6)       =       2CADR TASK4
#       C(LST2+8)       =       2CADR TASK5
#       C(LST2+10)      =       2CADR TASK6

## Page 1071

# ENTERS HERE ON T3 RUPT TO DISPATCH WAITLISTED TASK.

T3RUPT          TS              BANKRUPT                                          
                EXTEND                                          
                QXCH            QRUPT                           

T3RUPT2         CAF             NEG1/2                          # DISPATCH WAITLIST TASK.
                XCH             LST1            +7              
                XCH             LST1            +6              
                XCH             LST1            +5              
                XCH             LST1            +4              # 1. MOVE UP LST1 CONTENTS, ENTERING
                XCH             LST1            +3              #    A VALUE OF 1/2 +1 AT THE BOTTOM
                XCH             LST1            +2              #    FOR T6-T5, CORRESPONDING TO THE
                XCH             LST1            +1              #    INTERVAL 81.91 SEC FOR ENDTASK.
                XCH             LST1                            
                AD              POSMAX                          # 2. SET T3 = 1.0 - T2 - T USING LIST 1.
                ADS             TIME3                           #    SO T3 WON'T TICK DURING UPDATE.
                TS              RUPTAGN                         
                CS              ZERO                            
                TS              RUPTAGN                         # SETS RUPTAGN TO +1 ON OVERFLOW.

                EXTEND                                          # DISPATCH TASK.
                DCS             ENDTASK                         
                DXCH            LST2            +16D            
                DXCH            LST2            +14D            
                DXCH            LST2            +12D            
                DXCH            LST2            +10D            
                DXCH            LST2            +8D             
                DXCH            LST2            +6              
                DXCH            LST2            +4              
                DXCH            LST2            +2              
                DXCH            LST2                            

                DTCB                                            

## Page 1072

# RETURN, AFTER EXECUTION OF T3 OVERFLOW TASK:

                BLOCK           02                              
TASKOVER        CCS             RUPTAGN                         # IF +1 RETURN TO T3RUPT, IF -0 RESUME.
                CAF             WAITBB                          
                TS              BBANK                           
                TCF             T3RUPT2                         # DISPATCH NEXT TASK IF IT WAS DUE.

RESUME          EXTEND                                          
                QXCH            QRUPT                           
NOQRSM          CA              BANKRUPT                        
                XCH             BBANK                           
NOQBRSM         DXCH            ARUPT                           
                RESUME                                          

## Page 1073

# LONGCALL

#       LONGCALL IS CALLED WITH THE DELTA TIME ARRIVING IN A,L SCALED AS TIME2,TIME1 WITH THE 2CADR OF THE TASK
#       IMMEDIATELY FOLLOWING THE TC LONGCALL.  FOR EXAMPLE, IT MIGHT BE DONE AS FOLLOWS WHERE TIMELOC IS THE NAME OF
#       A DP REGISTER CONTAINING A DELTA TIME AND WHERE TASKTODO IS THE NAME OF THE LOCATION AT WHICH LONGCALL IS TO
#       START.

# *** THE FOLLOWING IS TO BE IN FIXED-FIXED AND UNSWITCHED ERRASIBLE ***

                BLOCK           02                              
                EBANK=          LST1                            
LONGCALL        DXCH            LONGTIME                        # OBTAIN THE DELTA TIME

                EXTEND                                          # OBTAIN THE 2CADR
                NDX             Q                               
                DCA             0                               
                DXCH            LONGCADR                        

                EXTEND                                          # NOW GO TO THE APPROPRIATE SWITCHED BANK
                DCA             LGCL2CDR                        # FOR THE REST OF LONGCALL
                DTCB                                            

                EBANK=          LST1                            
LGCL2CDR        2CADR           LNGCALL2                        

# *** THE FOLLOWING MAY BE IN A SWITCHED BANK, INCLUDING ITS ERASABLE ***

                BANK            01                              
LNGCALL2        LXCH            LONGEXIT        +1              # SAVE THE CORRECT BB FOR RETURN
                CA              TWO                             # OBTAIN THE RETURN ADDRESS
                ADS             Q                               
                TS              LONGEXIT                        

# *** WAITLIST TASK LONGCYCL ***

LONGCYCL        EXTEND                                          # CAN WE SUCCESFULLY TAKE ABOUT 1.25
                DCS             DPBIT14                         # MINUTES OFF OF LONGTIME
                DAS             LONGTIME                        

                CCS             LONGTIME        +1              # THE REASONING BEHIND THIS PART IS
                TCF             MUCHTIME                        # INVOLVED, TAKING INTO ACCOUNT THAT THE
                                                                # WORDS MAY NOT BE SIGNED CORRECTED (DP
                                                                # BASIC INSTRUCTIONS
                                                                # DO NOT SIGN CORRECT) AND THAT WE SUBTRAC-
                                                                # TED BIT14 (1 OVER HALF THE POS. VALUE
                                                                # REPRESENTABLE IN SINGLE WORD)

## Page 1074                

                NOOP                                            # CAN'T GET HERE *************
                TCF             +1                              
                CCS             LONGTIME                        
                TCF             MUCHTIME                        
DPBIT14         OCT             00000                           
                OCT             20000                           

                                                                # LONGCALL

LASTTIME        CA              BIT14                           # GET BACK THE CORRECT DELTA T FOR WAITLIST
                ADS             LONGTIME        +1              
                TC              WAITLIST                        
                EBANK=          LST1                            
                2CADR           GETCADR                         # THE ENTRY TO OUR LONGCADR

LONGRTRN        CA              TSKOVCDR                        # SET IT UP SO THAT ONLY THE FIRST EXIT IS
                DXCH            LONGEXIT                        # TO THE CALLER OF LONGCALL
                DTCB                                            # THE REST ARE TO TASKOVER

MUCHTIME        CA              BIT14                           # WE HAVE OVER OUR ABOUT 1.25 MINUTES
                TC              WAITLIST                        # SO SET UP FOR ANOTHER CYCLE THROUGH HERE
                EBANK=          LST1                            
                2CADR           LONGCYCL                        

                TCF             LONGRTRN                        # NOW EXIT PROPERLY

# *** WAITLIST TASK GETCADR ***

GETCADR         DXCH            LONGCADR                        # GET THE LONGCALL THAT WE WISHED TO START
                DTCB                                            # AND TRANSFER CONTROL TO IT

TSKOVCDR        GENADR          TASKOVER                        
