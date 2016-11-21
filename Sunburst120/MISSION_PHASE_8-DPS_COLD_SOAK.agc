### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     MISSION_PHASE_8-DPS_COLD_SOAK.agc
## Purpose:      A module for revision 0 of BURST120 (Sunburst). It 
##               is part of the source code for the Lunar Module's
##               (LM) Apollo Guidance Computer (AGC) for Apollo 5.
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      www.ibiblio.org/apollo/index.html
## Mod history:  2016-09-30 RSB  Created draft version.
##               2016-10-28 MAS  Transcribed.

## Page 720
                BANK            27
                EBANK=          RATEINDX
# PROGRAM DESCRIPTION-            DATE- 07 DEC 66

# MOD NO- 4                       LOG SECTION-
# MOD BY- ELIASSEN                MISSION PHASE 8 - DPS COLD SOAK
# FUNCTIONAL DESCRIPTION-

# 0/54/23  START MISSION PHASE 8 WHEN MISSION TIMER 4 COUNTS TO ZERO.

#          CHANGE MAJOR MODE TO 15.

#          DO DFI T/M CALIBRATION  (14 SECONDS).

#          WAIT 1 SECOND

# 0/54/38  LMP COMMANDS-
#                 LANDING RADAR POWER ON*
#                 RADAR SELF TEST ON*

#          CALL TO CALCULATE REQUIRED ATTITUDE
#                 FOR DPS COLD SOAK -
#                 LM X-AXIS NORMAL TO THE ECLIPTIC PLANE
#                 AND BISECTOR OF LM +Z/-Y AXES TOWARD THE SUN.

#                 CHANGE THE ATTITUDE OF THE
#                 SPACECRAFT TO THAT REQUIRED FOR DPS COLD SOAK
#                 USING KALCMANU ROUTINE - MANEUVER RATE= 5 DEG/SEC.

#          WAIT 60 SECONDS

#          LMP COMMAND-
#                 RADAR SELF TEST OFF*

#          WAIT 60 SECONDS

# 0/56/38  LMP COMMAND-
#                 LANDING RADAR POWER OFF*

#          WAIT 15 SECONDS

# 0/56/53  VERIFY THAT MANEUVER IS COMPLETE.
#                 (IF NOT GO TO CURTAINS)

#          SET MAXIMUM DEADBAND FOR LM-DAP.

#          CALL SCHEDULE ENTRY ROUTINE FOR DPS 1 WITH
#                 J=2
#                 MP=9
#                 DT= 2H 59M 14S

## Page 721
# SUBROUTINES CALLED-
#          FINDVAC, ENDOFJOB
#          WAITLIST, TASKOVER
#          NEWMODEX, MPENTRY, PHASCHNG, 2PHSCHNG
#          INTPRET, BANKCALL, IBNKCALL, ATTSTALL, CURTAINS, P00H
#          FLAG1DWN, FLAG2DWN, SETMINDB, SETMAXDB
#          KALCMAN3, DCMTOCDU, V1STO2S
#          1LMP, 1LMP+DT, 2LMP+DT

# NORMAL EXIT MODES-
#          TC    ENDOFJOB/TASKOVER
# ALARM OR ABORT EXIT MODES-   NONE
# OUTPUT- (INTERFACE, DISPLAYS, MEANINGFUL INFORMATION LEFT IN ERASABLE)
#          SAME AS FOR KALCMANU
# ERASABLE INITIALIZATION REQUIRED-
#          TEPHEM   IN CENTISECONDS TRIPLE PRECISION
#          MP8TO9   DT FOR CALLING MP9- IN SECONDS(SEE ABOVE)

# DEBRIS- (ERASABLE LOCATIONS DESTROYED BY THIS PROGRAM)
#          SAME AS FOR KALCMANU
PRIOKM          EQUALS          PRIO20                          # PRIORITY FOR KALCMANU PHASE 8 + 16
MP8JOB          TC              NEWMODEX                        # UPDATE PROGRAM NUMBER
                OCT             15                              # ON DSKY

                TC              PHASCHNG
                OCT             05022
                OCT             20000
                CAF             BIT8
                TC              SETRSTRT                        # SET RESTART FLAG

                CAF             ONE                             # ESTABLISH TASK TO
                INHINT                                          # PERFORM DFI T/M CAL.
                TC              WAITLIST
                EBANK=          RATEINDX
                2CADR           MP8TASK

                TC              ENDOFJOB

MP8TASK         TC              1LMP+DT                         # LMP COMMAND
                DEC             236                             # DFI T/M CALIBRATE ON*
                DEC             1200                            # 12 SECONDS DELAY

                TC              2LMP+DT                         # LMP COMMANDS
                DEC             237                             # DFI T/M CALIBRATE OFF*
                DEC             198                             # MASTER C+W ALARM RESET**  COMMAND
                DEC             200                             # 2 SECONDS DELAY

                TC              1LMP+DT                         # LMP COMMAND
                DEC             199                             # MASTER C+W ALARM RESET- COMAND RESET
                DEC             100                             # 1 SECOND

## Page 722
M8RADON         CAF             PRIO10                          # SET UP JOB TO CALCULATE
                TC              FINDVAC                         # REQ CDU ANGLES
                EBANK=          RATEINDX
                2CADR           COLDSOAK

                TC              2PHSCHNG
                OCT             00054
                OCT             05012
                OCT             77777

                TC              2LMP+DT                         # LMP COMMANDS
                DEC             182                             # LANDING RADAR POWER ON*
                DEC             26                              # RADAR SELF TEST ON*
                DEC             6000                            # WAIT 1 MIN

                TC              1LMP+DT                         # LMP COMMAND
                DEC             27                              # RADAR SELF TEST OFF*
                DEC             6000                            # WAIT 1 MIN

                TC              1LMP+DT
                DEC             183                             # LANDING RADAR POWER OFF*
                DEC             1500                            # 15 SECONDS

                CAF             PRIO35                          # SET UP JOB TO
                TC              NOVAC                           # END MISSION PHASE
                EBANK=          LST1
                2CADR           MP9CALL

                TC              TASKOVER
MP9CALL         CA              FLAGWRD2                        # CHECK IF MANEUVER
                MASK            BIT11                           # WAS COMPLETED
                EXTEND
                BZF             +2
                TC              CURTAINS                        # MANEUVER NOT COMPLETED
                TC              BANKCALL
                CADR            ATTSTALL
                TC              CURTAINS                        # SICK RETURN

#                                         SET LM-DAP DEADBAND TO MAX-

                TC              PHASCHNG
                OCT             00002                           # DEACTIVATE GR 2

                TC              2PHSCHNG
                OCT             00004
                OCT             05023
                OCT             30000

                INHINT
                TC              BANKCALL
## Page 723
                CADR            SETMAXDB

#                                         CALL MISSION PHASE 9

                TC              MPENTRY                         # MANEUVER SUCCESSFUL
                DEC             2                               # J=2
                DEC             9                               # MP=9
                ADRES           MP8TO9                          # DT = 2H 59M 14S

                TC              P00H                            # END OF MISSION PHASE 8

## Page 724
#          CALCULATE CDU ANGLES FOR REQUIRED
#          COLDSOAK ATTITUDE - LEM X-AXIS NORMAL TO THE
#          ECLIPTIC AND BISECTOR OF -Y/+Z AXES TOWARD THE SUN.
COLDSOAK        EXTEND
                DCA             TIME2
                DXCH            MPAC
                EXTEND
                DCA             TLIFTOFF
                DAS             MPAC                            # ADD TIME CLOCK ZEROED TO TIME2

                CA              ZERO
                TS              MODE
                TC              INTPRET
# CALCULATE TRANSFORMATION MATRIX FROM RCS COLD SOAK ATTITUDE
# TO STABLE MEMBER COORDINATES.   CONVERT TO CDU ANGLES.
                SETPD           SR
                                0
                                14D
                TAD             DDV
                                TEPHEM                          # TIME IN CENTISEC SINCE PRECEDING JUNE 30
                                CSPERDAY                        # CENTISEC PER DAY
                PUSH                                            # T/2**9 = (DAYS SINCE JUNE 30TH)/2**9

#                                         COMPUTE  SIN(2*PI*T/365.25), COS(2*PI*T/365.25)  WHERE
#                                         T= NUMBER OF DAYS SINCE MIDNIGHT OF PRECEDING JUNE 30TH.

ALTA            DSU             BPL                             # DIMINISH T/2**9 BY 365.25/2**9
                                ONEYR                           # UNTIL A NEGATIVE RESULT OCCURS.
                                ALTA
                DAD             DDV                             # ADD BACK 365.25/2**9 ONCE.
                                ONEYR                           # LET Y=RESULT
                                ONEYR                           # Y/365.25 IS LESS THAN ONE AND POSITIVE.
                PUSH            SIN                             # .5*SIN(2*PI*Y/365.25)
                PDDL            COS                             # .5*COS(2*PI*Y/365.25)

#                                         COMPUTE (1/8 +LOS) IN REVOLUTIONS WHERE
#                                         LOS= LOS0+LOSR*T-C0Y*SIN(2*PI*Y/365.25)-C1Y*COS(2*PI*Y/365.25) .
#                                         LOS = LONGITUDE OF SUN IN PLANE OF ECLIPTIC.

                DMP             PDDL
                                C1Y                             # .5*C1Y*COS/2
                DMP             DAD
                                C0Y                             # (C0Y*SIN +C1Y*COS)/4
                PDDL                                            # T/2**9
                DMP             SL
                                LOSR                            # LOSR*T/2**9
                                7                               # LOSR*T/4
                DSU                                             # (LOSR*T-C0Y*SIN-C1Y*COS)/4
                DAD             DAD
                                LOS0                            # LOS/4= (LOS0+LOSR*T-C0Y*SIN-C1Y*COS)/4
## Page 725
                                EGHTH                           # (1/8 +LOS)/4  ,  1/8 REV = 45 DEG

ALTB            DSU             BPL                             # DIMINISH (1/8 +LOS)/4 REVS BY (1REV)/4
                                ONEREV                          # UNTIL A NEGATIVE RESULT OCCURS.
                                ALTB
                DAD             SL2                             # ADD BACK (1REV)/4 .
                                ONEREV                          # AND MULTIPLY BY FOUR.
                PUSH                                            # (1/8 +LOS) POSITIVE AND LESS THAN ONE.

#                                         CONSTRUCT TRANSFORMATION MATRIX FROM RCS COLD SOAK ATTITUDE
#                                         TO EARTH REFERENCE COORDINATES.  MATRIX IS SCALED BY -1 .
#                                         MATRIX TRANSPOSE IS STORED STARTING IN FIRST LOCATION OF PUSHDOWN LIST.
#                                         OBL= OBLIQUITY= ANGLE BETWEEN ECLIPTIC AND EQUATORIAL PLANES.
#                                         DEFINE LOSR= 2*PI*LOS

                COS             DCOMP
                STORE           6                               # -.5*COS(PI/4+LOSR)
                DMP
                                COSOBL
                STORE           14D                             # -.5*COS(PI/4+LOSR)*COS(OBL)
                DMP
                                TANOBL
                STODL           16D                             # -.5*COS(PI/4+LOSR)*SIN(OBL)
                                0
                SIN
                STORE           12D                             #  .5*SIN(PI/4+LOSR)
                DMP             DCOMP
                                COSOBL
                STORE           8D                              # -.5*SIN(PI/4+LOSR)*COS(OBL)
                DMP
                                TANOBL
                STODL           10D                             # -.5*SIN(PI/4+LOSR)*SIN(OBL)
                                COSOBL
                SR1
                STODL           4                               #  .5*COS(OBL)
                                SINOBL
                SR1             DCOMP
                STODL           2                               # -.5*SIN(OBL)
                                DPZRO
                STORE           0                               #  0

#                                         PERFORM THE MATRIX MULTIPLICATION (REFSMMAT)X(RCS TO REF MATRIX)/2
                VLOAD           MXV
                                0
                                REFSMMAT
                VSL1
                STOVL           0
                                6
                MXV             VSL1
                                REFSMMAT

## Page 726
                STOVL           6
                                12D
                MXV             VSL1
                                REFSMMAT
                STORE           12D
                EXIT

#                                         TRANSPOSE RESULTING DIRECTION COSINE MATRIX.

                INDEX           FIXLOC
                DXCH            2
                INDEX           FIXLOC
                DXCH            6
                INDEX           FIXLOC
                DXCH            2
                INDEX           FIXLOC
                DXCH            4
                INDEX           FIXLOC
                DXCH            12D
                INDEX           FIXLOC
                DXCH            4
                INDEX           FIXLOC
                DXCH            10D
                INDEX           FIXLOC
                DXCH            14D
                INDEX           FIXLOC
                DXCH            10D
                TC              INTPRET

#                                         CALL ROUTINE TO CONVERT DIRECTION COSINE MATRIX TO CDU ANGLES.
                
                SETPD           AXC,1
                                18D
                                0
                CALL
                                DCMTOCDU

#                                         CONVERT CDU ANGLES FROM ONES TO TWOS COMPLEMENT.
                
                SSP             RTB
                                RATEINDX
                                4                               # CODE FOUR = MANEUVER RATE OF 5 DEG/SEC.
                                V1STO2S                         #     STORE CDU ANGLES IN CONSECUTIVE
                STORE           CPHI                            #     LOCATIONS  CPHI,CTHETA,CPSI.
                EXIT

#                                         SET UP PARAMETERS FOR KALCMANU MANEUVER ROUTINE

                TC              FLAG2DWN                        # RESET STATE SWITCH 33 (BIT 12)
                OCT             04000                           # FOR FINAL ROLL , IF ANY.

## Page 727
                TC              FLAG2UP                         # SET BIT FOR KALCMANU
                OCT             02000                           # BIT 11

                TC              PHASCHNG
                OCT             05024
                OCT             20000

COLDSK1         CAF             PRIOKM                          # SCHEDULE KALCMANU
                INHINT
                TC              FINDVAC
                EBANK=          RATEINDX
                2CADR           KALCMAN3

                TC              ENDOFJOB

LOS0            2DEC            .273926331      B-2             # 1966-67,IN REVOLUTIONS

LOSR            2DEC            .0027377992                     # 1966-67,IN REVOLUTIONS

C0Y             2DEC            .005306583      B-1             # 1966-67,IN REVOLUTIONS

C1Y             2DEC            -.000402139     B-1             # 1966-67,IN REVOLUTIONS

SINOBL          2DEC            .397845753                      # 1966-67

COSOBL          2DEC            .917452318                      # 1966-67

TANOBL          2DEC            .433641885                      # 1966-67

DPZRO           2DEC            0

ONEREV          2DEC            .999999999      B-2

EGHTH           2DEC            .125            B-2

ONEYR           2DEC            365.25          B-9

CSPERDAY        2DEC            8640000         B-33            # CENTISEC PER DAY

# END OF MISSION PHASE 8
