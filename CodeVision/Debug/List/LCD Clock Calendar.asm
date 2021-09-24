
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : long, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Hour=R5
	.DEF _Minute=R4
	.DEF _Second=R7
	.DEF _Year=R6
	.DEF _Month=R9
	.DEF _Day=R8
	.DEF _Weekday=R11
	.DEF _sYear=R12
	.DEF _sYear_msb=R13
	.DEF _sMonth=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_degreeSymbol:
	.DB  0x6,0x9,0x9,0x6,0x0,0x0,0x0,0x0
_conv_delay_G101:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G101:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0

_0x0:
	.DB  0x25,0x2E,0x34,0x69,0x2F,0x25,0x2E,0x32
	.DB  0x69,0x2F,0x25,0x2E,0x32,0x69,0x20,0x0
	.DB  0x53,0x55,0x4E,0x0,0x4D,0x4F,0x4E,0x0
	.DB  0x54,0x55,0x45,0x0,0x57,0x45,0x44,0x0
	.DB  0x54,0x48,0x55,0x0,0x46,0x52,0x49,0x0
	.DB  0x53,0x41,0x54,0x0,0x25,0x2E,0x32,0x69
	.DB  0x3A,0x25,0x2E,0x32,0x69,0x3A,0x25,0x2E
	.DB  0x32,0x69,0x20,0x25,0x2E,0x31,0x66,0x0
	.DB  0x43,0x20,0x20,0x0,0x59,0x65,0x61,0x72
	.DB  0x20,0x43,0x65,0x6E,0x74,0x75,0x72,0x79
	.DB  0x3A,0x0,0x25,0x2E,0x32,0x69,0x0,0x59
	.DB  0x65,0x61,0x72,0x3A,0x0,0x4D,0x6F,0x6E
	.DB  0x74,0x68,0x3A,0x0,0x44,0x61,0x79,0x3A
	.DB  0x0,0x48,0x6F,0x75,0x72,0x3A,0x0,0x4D
	.DB  0x69,0x6E,0x75,0x74,0x65,0x3A,0x0,0x53
	.DB  0x65,0x63,0x6F,0x6E,0x64,0x3A,0x0,0x57
	.DB  0x65,0x65,0x6B,0x64,0x61,0x79,0x3A,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x53,0x75,0x6E
	.DB  0x64,0x61,0x79,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x4D,0x6F
	.DB  0x6E,0x64,0x61,0x79,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x54
	.DB  0x75,0x65,0x73,0x64,0x61,0x79,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x57
	.DB  0x65,0x64,0x6E,0x65,0x73,0x64,0x61,0x79
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x54,0x68,0x75,0x72,0x73,0x64,0x61,0x79
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x46,0x72,0x69,0x64,0x61,0x79
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x53,0x61,0x74,0x75,0x72,0x64
	.DB  0x61,0x79,0x20,0x20,0x20,0x20,0x0
_0x2040003:
	.DB  0x80,0xC0
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20C0060:
	.DB  0x1
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  0x07
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _0x22
	.DW  _0x0*2+64

	.DW  0x0E
	.DW  _0xF1
	.DW  _0x0*2+68

	.DW  0x06
	.DW  _0xF1+14
	.DW  _0x0*2+87

	.DW  0x07
	.DW  _0xF1+20
	.DW  _0x0*2+93

	.DW  0x05
	.DW  _0xF1+27
	.DW  _0x0*2+100

	.DW  0x06
	.DW  _0xF1+32
	.DW  _0x0*2+105

	.DW  0x08
	.DW  _0xF1+38
	.DW  _0x0*2+111

	.DW  0x08
	.DW  _0xF1+46
	.DW  _0x0*2+119

	.DW  0x09
	.DW  _0xF1+54
	.DW  _0x0*2+127

	.DW  0x11
	.DW  _0xF1+63
	.DW  _0x0*2+136

	.DW  0x11
	.DW  _0xF1+80
	.DW  _0x0*2+153

	.DW  0x11
	.DW  _0xF1+97
	.DW  _0x0*2+170

	.DW  0x11
	.DW  _0xF1+114
	.DW  _0x0*2+187

	.DW  0x11
	.DW  _0xF1+131
	.DW  _0x0*2+204

	.DW  0x11
	.DW  _0xF1+148
	.DW  _0x0*2+221

	.DW  0x11
	.DW  _0xF1+165
	.DW  _0x0*2+238

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

	.DW  0x01
	.DW  __seed_G106
	.DW  _0x20C0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : LCD Clock Calendar
;Version : 1.0
;Date    : 03.29.2019
;Author  : JUSTEDUCATION.IR
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// I2C Bus functions
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// 1 Wire Bus interface functions
;#include <1wire.h>
;
;// DS1820 Temperature Sensor functions
;#include <ds18b20.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#include <delay.h>
;#include <math.h>
;#include <stdio.h>
;
;// Declare your global variables here
;float Temp;
;char lcd_buff[16];
;unsigned char Hour, Minute, Second = 0;
;eeprom unsigned char Year_century;
;unsigned char Year, Month, Day, Weekday = 0;
;unsigned int sYear = 0;
;unsigned char sMonth, sDay = 0;
;unsigned char menu_selector = 0;
;flash char degreeSymbol[8] =
;{
;0b000110,
;0b001001,
;0b001001,
;0b000110,
;0b000000,
;0b000000,
;0b000000,
;0b000000
;};
;
;// Declare your global functions
;void time_date_functions();
;int isLeapYear(int _year, int _type);
;void main_loop();
;void up_sw();
;void menu_sw();
;void down_sw();
;void showMenu();
;void Georgian2Solar(int gYear, char gMonth, char gDay, unsigned int* sYear, char* sMonth, char* sDay);
;void define_char(char flash *pc, char char_code);
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 004F {

	.CSEG
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0050     if (Second >= 0 && Second <= 58)
	LDI  R30,LOW(0)
	CP   R7,R30
	BRLO _0x4
	LDI  R30,LOW(58)
	CP   R30,R7
	BRSH _0x5
_0x4:
	RJMP _0x3
_0x5:
; 0000 0051     {
; 0000 0052         Second++;
	INC  R7
; 0000 0053     }
; 0000 0054     else if (Second >= 59)
	RJMP _0x6
_0x3:
	LDI  R30,LOW(59)
	CP   R7,R30
	BRLO _0x7
; 0000 0055     {
; 0000 0056         Second = 0;
	CLR  R7
; 0000 0057         Minute++;
	INC  R4
; 0000 0058         if (Minute > 59)
	CP   R30,R4
	BRSH _0x8
; 0000 0059         {
; 0000 005A             Minute = 0;
	CLR  R4
; 0000 005B             Hour++;
	INC  R5
; 0000 005C             if (Hour > 23)
	LDI  R30,LOW(23)
	CP   R30,R5
	BRSH _0x9
; 0000 005D             {
; 0000 005E                 Hour = 0;
	CLR  R5
; 0000 005F                 Day++;
	INC  R8
; 0000 0060                 Weekday++;
	INC  R11
; 0000 0061             }
; 0000 0062         }
_0x9:
; 0000 0063     }
_0x8:
; 0000 0064 }
_0x7:
_0x6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0067 {
_main:
; .FSTART _main
; 0000 0068 // Declare your local variables here
; 0000 0069 
; 0000 006A // Input/Output Ports initialization
; 0000 006B // Port A initialization
; 0000 006C // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 006D DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(248)
	OUT  0x1A,R30
; 0000 006E // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=P Bit1=P Bit0=P
; 0000 006F PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
	LDI  R30,LOW(7)
	OUT  0x1B,R30
; 0000 0070 
; 0000 0071 // Port B initialization
; 0000 0072 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0073 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0074 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0075 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0076 
; 0000 0077 // Port C initialization
; 0000 0078 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0079 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 007A // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 007B PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 007C 
; 0000 007D // Port D initialization
; 0000 007E // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 007F DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0080 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0081 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0082 
; 0000 0083 // Timer/Counter 0 initialization
; 0000 0084 // Clock source: System Clock
; 0000 0085 // Clock value: Timer 0 Stopped
; 0000 0086 // Mode: Normal top=0xFF
; 0000 0087 // OC0 output: Disconnected
; 0000 0088 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0089 TCNT0=0xD8;
	LDI  R30,LOW(216)
	OUT  0x32,R30
; 0000 008A OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 008B 
; 0000 008C // Timer/Counter 1 initialization
; 0000 008D // Clock source: System Clock
; 0000 008E // Clock value: Timer1 Stopped
; 0000 008F // Mode: Normal top=0xFFFF
; 0000 0090 // OC1A output: Disconnected
; 0000 0091 // OC1B output: Disconnected
; 0000 0092 // Noise Canceler: Off
; 0000 0093 // Input Capture on Falling Edge
; 0000 0094 // Timer1 Overflow Interrupt: Off
; 0000 0095 // Input Capture Interrupt: Off
; 0000 0096 // Compare A Match Interrupt: Off
; 0000 0097 // Compare B Match Interrupt: Off
; 0000 0098 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0099 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 009A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 009B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 009C ICR1H=0x00;
	OUT  0x27,R30
; 0000 009D ICR1L=0x00;
	OUT  0x26,R30
; 0000 009E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 009F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A0 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A1 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A2 
; 0000 00A3 // Timer/Counter 2 initialization
; 0000 00A4 // Clock source: TOSC1 pin
; 0000 00A5 // Clock value: PCK2/128
; 0000 00A6 // Mode: Normal top=0xFF
; 0000 00A7 // OC2 output: Disconnected
; 0000 00A8 ASSR=1<<AS2;
	LDI  R30,LOW(8)
	OUT  0x22,R30
; 0000 00A9 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 00AA TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00AB OCR2=0x00;
	OUT  0x23,R30
; 0000 00AC 
; 0000 00AD // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00AE TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(64)
	OUT  0x39,R30
; 0000 00AF 
; 0000 00B0 // External Interrupt(s) initialization
; 0000 00B1 // INT0: Off
; 0000 00B2 // INT1: Off
; 0000 00B3 // INT2: Off
; 0000 00B4 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00B5 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00B6 
; 0000 00B7 // USART initialization
; 0000 00B8 // USART disabled
; 0000 00B9 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00BA 
; 0000 00BB // Analog Comparator initialization
; 0000 00BC // Analog Comparator: Off
; 0000 00BD // The Analog Comparator's positive input is
; 0000 00BE // connected to the AIN0 pin
; 0000 00BF // The Analog Comparator's negative input is
; 0000 00C0 // connected to the AIN1 pin
; 0000 00C1 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C2 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00C3 
; 0000 00C4 // ADC initialization
; 0000 00C5 // ADC disabled
; 0000 00C6 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00C7 
; 0000 00C8 // SPI initialization
; 0000 00C9 // SPI disabled
; 0000 00CA SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00CB 
; 0000 00CC // TWI initialization
; 0000 00CD // TWI disabled
; 0000 00CE TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00CF 
; 0000 00D0 // Bit-Banged I2C Bus initialization
; 0000 00D1 // I2C Port: PORTC
; 0000 00D2 // I2C SDA bit: 1
; 0000 00D3 // I2C SCL bit: 0
; 0000 00D4 // Bit Rate: 100 kHz
; 0000 00D5 // Note: I2C settings are specified in the
; 0000 00D6 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 00D7 i2c_init();
	CALL _i2c_init
; 0000 00D8 
; 0000 00D9 // DS1307 Real Time Clock initialization
; 0000 00DA // Square wave output on pin SQW/OUT: Off
; 0000 00DB // SQW/OUT pin state: 0
; 0000 00DC rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 00DD 
; 0000 00DE // 1 Wire Bus initialization
; 0000 00DF // 1 Wire Data port: PORTB
; 0000 00E0 // 1 Wire Data bit: 0
; 0000 00E1 // Note: 1 Wire port settings are specified in the
; 0000 00E2 // Project|Configure|C Compiler|Libraries|1 Wire menu.
; 0000 00E3 w1_init();
	CALL _w1_init
; 0000 00E4 
; 0000 00E5 // Alphanumeric LCD initialization
; 0000 00E6 // Connections are specified in the
; 0000 00E7 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00E8 // RS - PORTB Bit 1
; 0000 00E9 // RD - PORTB Bit 2
; 0000 00EA // EN - PORTB Bit 3
; 0000 00EB // D4 - PORTB Bit 4
; 0000 00EC // D5 - PORTB Bit 5
; 0000 00ED // D6 - PORTB Bit 6
; 0000 00EE // D7 - PORTB Bit 7
; 0000 00EF // Characters/line: 16
; 0000 00F0 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00F1 define_char(degreeSymbol, 0);
	LDI  R30,LOW(_degreeSymbol*2)
	LDI  R31,HIGH(_degreeSymbol*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _define_char
; 0000 00F2 lcd_clear();
	CALL _lcd_clear
; 0000 00F3 
; 0000 00F4 // Global enable interrupts
; 0000 00F5 #asm("sei")
	sei
; 0000 00F6 
; 0000 00F7 rtc_get_time(&Hour, &Minute, &Second);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL _rtc_get_time
; 0000 00F8 rtc_get_date(&Weekday, &Day, &Month, &Year);
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	RCALL _rtc_get_date
; 0000 00F9 
; 0000 00FA if (Year_century == 0) Year_century = 20;
	CALL SUBOPT_0x0
	CPI  R30,0
	BRNE _0xA
	LDI  R26,LOW(_Year_century)
	LDI  R27,HIGH(_Year_century)
	LDI  R30,LOW(20)
	CALL __EEPROMWRB
; 0000 00FB main_loop();
_0xA:
	RCALL _main_loop
; 0000 00FC 
; 0000 00FD }
_0xB:
	RJMP _0xB
; .FEND
;
;void main_loop()
; 0000 0100 {
_main_loop:
; .FSTART _main_loop
; 0000 0101     while(1)
_0xC:
; 0000 0102     {
; 0000 0103         time_date_functions();
	RCALL _time_date_functions
; 0000 0104 
; 0000 0105         switch(PINA & 0x07)
	IN   R30,0x19
	ANDI R30,LOW(0x7)
; 0000 0106         {
; 0000 0107             case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x12
; 0000 0108                 up_sw();
	RCALL _up_sw
; 0000 0109                 break;
	RJMP _0x11
; 0000 010A             case 2:
_0x12:
	CPI  R30,LOW(0x2)
	BRNE _0x13
; 0000 010B                 menu_sw();
	RCALL _menu_sw
; 0000 010C                 break;
	RJMP _0x11
; 0000 010D             case 4:
_0x13:
	CPI  R30,LOW(0x4)
	BRNE _0x11
; 0000 010E                 down_sw();
	RCALL _down_sw
; 0000 010F                 break;
; 0000 0110         }
_0x11:
; 0000 0111 
; 0000 0112         if (menu_selector == 0)
	LDS  R30,_menu_selector
	CPI  R30,0
	BREQ PC+2
	RJMP _0x15
; 0000 0113         {
; 0000 0114             Temp = ds18b20_temperature(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _ds18b20_temperature
	STS  _Temp,R30
	STS  _Temp+1,R31
	STS  _Temp+2,R22
	STS  _Temp+3,R23
; 0000 0115 
; 0000 0116             if (Second % 10 < 5)
	MOV  R26,R7
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SBIW R30,5
	BRGE _0x16
; 0000 0117             {
; 0000 0118                 sprintf(lcd_buff, "%.4i/%.2i/%.2i ", (Year_century * 100) + Year, Month, Day);
	CALL SUBOPT_0x1
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x3
	MOV  R30,R8
	RJMP _0x106
; 0000 0119             }
; 0000 011A             else
_0x16:
; 0000 011B             {
; 0000 011C                 Georgian2Solar((Year_century * 100) + Year, Month, Day, &sYear, &sMonth, &sDay);
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R9
	ST   -Y,R8
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_sDay)
	LDI  R27,HIGH(_sDay)
	RCALL _Georgian2Solar
; 0000 011D                 sprintf(lcd_buff, "%.4i/%.2i/%.2i ", sYear, sMonth, sDay);
	CALL SUBOPT_0x1
	MOVW R30,R12
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R10
	CALL SUBOPT_0x4
	LDS  R30,_sDay
_0x106:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 011E             }
; 0000 011F             lcd_gotoxy(0, 0);
	CALL SUBOPT_0x5
; 0000 0120             lcd_puts(lcd_buff);
	CALL SUBOPT_0x6
; 0000 0121 
; 0000 0122             switch(Weekday)
	MOV  R30,R11
	CALL SUBOPT_0x7
; 0000 0123             {
; 0000 0124                 case 1:
	BRNE _0x1B
; 0000 0125                     sprintf(lcd_buff, "SUN");
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,16
	RJMP _0x107
; 0000 0126                     break;
; 0000 0127                 case 2:
_0x1B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1C
; 0000 0128                     sprintf(lcd_buff, "MON");
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,20
	RJMP _0x107
; 0000 0129                     break;
; 0000 012A                 case 3:
_0x1C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1D
; 0000 012B                     sprintf(lcd_buff, "TUE");
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,24
	RJMP _0x107
; 0000 012C                     break;
; 0000 012D                 case 4:
_0x1D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1E
; 0000 012E                     sprintf(lcd_buff, "WED");
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,28
	RJMP _0x107
; 0000 012F                     break;
; 0000 0130                 case 5:
_0x1E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1F
; 0000 0131                     sprintf(lcd_buff, "THU");
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,32
	RJMP _0x107
; 0000 0132                     break;
; 0000 0133                 case 6:
_0x1F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20
; 0000 0134                     sprintf(lcd_buff, "FRI");
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,36
	RJMP _0x107
; 0000 0135                     break;
; 0000 0136                 case 7:
_0x20:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x1A
; 0000 0137                     sprintf(lcd_buff, "SAT");
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,40
_0x107:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0000 0138                     break;
; 0000 0139             }
_0x1A:
; 0000 013A             lcd_gotoxy(13, 0);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 013B             lcd_puts(lcd_buff);
	CALL SUBOPT_0x6
; 0000 013C             sprintf(lcd_buff, "%.2i:%.2i:%.2i %.1f", Hour, Minute, Second, Temp);
	CALL SUBOPT_0x8
	__POINTW1FN _0x0,44
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CALL SUBOPT_0x4
	MOV  R30,R4
	CALL SUBOPT_0x4
	MOV  R30,R7
	CALL SUBOPT_0x4
	LDS  R30,_Temp
	LDS  R31,_Temp+1
	LDS  R22,_Temp+2
	LDS  R23,_Temp+3
	CALL __PUTPARD1
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 013D             lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 013E             lcd_puts(lcd_buff);
	CALL SUBOPT_0x6
; 0000 013F             lcd_putchar(0);
	LDI  R26,LOW(0)
	CALL _lcd_putchar
; 0000 0140             lcd_puts("C  ");
	__POINTW2MN _0x22,0
	CALL _lcd_puts
; 0000 0141         }
; 0000 0142         if (menu_selector > 0)
_0x15:
	LDS  R26,_menu_selector
	CPI  R26,LOW(0x1)
	BRLO _0x23
; 0000 0143         {
; 0000 0144             showMenu();
	RCALL _showMenu
; 0000 0145         }
; 0000 0146     }
_0x23:
	RJMP _0xC
; 0000 0147 }
; .FEND

	.DSEG
_0x22:
	.BYTE 0x4
;
;void time_date_functions()
; 0000 014A {

	.CSEG
_time_date_functions:
; .FSTART _time_date_functions
; 0000 014B     if (menu_selector == 0)
	LDS  R30,_menu_selector
	CPI  R30,0
	BREQ PC+2
	RJMP _0x24
; 0000 014C     {
; 0000 014D         if (Weekday == 0 || Weekday > 7) Weekday = 1;
	TST  R11
	BREQ _0x26
	LDI  R30,LOW(7)
	CP   R30,R11
	BRSH _0x25
_0x26:
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 014E         if (Day == 0) Day = 1;
_0x25:
	TST  R8
	BRNE _0x28
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 014F         if ((Day > 31) && (Month == 1 || Month == 3 || Month == 5 || Month == 7 || Month == 8 || Month == 10 || Month == ...
_0x28:
	LDI  R30,LOW(31)
	CP   R30,R8
	BRSH _0x2A
	LDI  R30,LOW(1)
	CP   R30,R9
	BREQ _0x2B
	LDI  R30,LOW(3)
	CP   R30,R9
	BREQ _0x2B
	LDI  R30,LOW(5)
	CP   R30,R9
	BREQ _0x2B
	LDI  R30,LOW(7)
	CP   R30,R9
	BREQ _0x2B
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ _0x2B
	LDI  R30,LOW(10)
	CP   R30,R9
	BREQ _0x2B
	LDI  R30,LOW(12)
	CP   R30,R9
	BRNE _0x2A
_0x2B:
	RJMP _0x2D
_0x2A:
	RJMP _0x29
_0x2D:
; 0000 0150         {
; 0000 0151             Day = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0152             Month++;
	INC  R9
; 0000 0153         }
; 0000 0154         if ((Day > 30) && (Month == 4 || Month == 6 || Month == 9 || Month == 11))
_0x29:
	LDI  R30,LOW(30)
	CP   R30,R8
	BRSH _0x2F
	LDI  R30,LOW(4)
	CP   R30,R9
	BREQ _0x30
	LDI  R30,LOW(6)
	CP   R30,R9
	BREQ _0x30
	LDI  R30,LOW(9)
	CP   R30,R9
	BREQ _0x30
	LDI  R30,LOW(11)
	CP   R30,R9
	BRNE _0x2F
_0x30:
	RJMP _0x32
_0x2F:
	RJMP _0x2E
_0x32:
; 0000 0155         {
; 0000 0156             Day = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0157             Month++;
	INC  R9
; 0000 0158         }
; 0000 0159         if (Day > 28 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 0)
_0x2E:
	LDI  R30,LOW(28)
	CP   R30,R8
	BRSH _0x34
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x34
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CALL SUBOPT_0xA
	SBIW R30,0
	BREQ _0x35
_0x34:
	RJMP _0x33
_0x35:
; 0000 015A         {
; 0000 015B             Day = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 015C             Month++;
	INC  R9
; 0000 015D         }
; 0000 015E         if (Month == 0) Month = 1;
_0x33:
	TST  R9
	BRNE _0x36
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 015F         if (Month > 12)
_0x36:
	LDI  R30,LOW(12)
	CP   R30,R9
	BRSH _0x37
; 0000 0160         {
; 0000 0161             Month = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0162             Year++;
	INC  R6
; 0000 0163         }
; 0000 0164         if (Year > 99)
_0x37:
	LDI  R30,LOW(99)
	CP   R30,R6
	BRSH _0x38
; 0000 0165         {
; 0000 0166             Year = 0;
	CLR  R6
; 0000 0167             Year_century++;
	CALL SUBOPT_0x0
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0168         }
; 0000 0169         if (Year_century > 99)
_0x38:
	CALL SUBOPT_0x0
	CPI  R30,LOW(0x64)
	BRLO _0x39
; 0000 016A         {
; 0000 016B             Year = 0;
	CLR  R6
; 0000 016C             Year_century = 0;
	LDI  R26,LOW(_Year_century)
	LDI  R27,HIGH(_Year_century)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 016D         }
; 0000 016E     }
_0x39:
; 0000 016F }
_0x24:
	RET
; .FEND
;
;void up_sw()
; 0000 0172 {
_up_sw:
; .FSTART _up_sw
; 0000 0173     switch(menu_selector)
	CALL SUBOPT_0xB
; 0000 0174     {
; 0000 0175         case 1:
	BRNE _0x3D
; 0000 0176             if (Year_century >= 99) Year_century = 0; else Year_century++;
	CALL SUBOPT_0x0
	CPI  R30,LOW(0x63)
	BRLO _0x3E
	LDI  R26,LOW(_Year_century)
	LDI  R27,HIGH(_Year_century)
	LDI  R30,LOW(0)
	RJMP _0x108
_0x3E:
	CALL SUBOPT_0x0
	SUBI R30,-LOW(1)
_0x108:
	CALL __EEPROMWRB
; 0000 0177             break;
	RJMP _0x3C
; 0000 0178         case 2:
_0x3D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40
; 0000 0179             if (Year >= 99) Year = 0; else Year++;
	LDI  R30,LOW(99)
	CP   R6,R30
	BRLO _0x41
	CLR  R6
	RJMP _0x42
_0x41:
	INC  R6
; 0000 017A             break;
_0x42:
	RJMP _0x3C
; 0000 017B         case 3:
_0x40:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x43
; 0000 017C             if (Month >= 12) Month = 1; else Month++;
	LDI  R30,LOW(12)
	CP   R9,R30
	BRLO _0x44
	LDI  R30,LOW(1)
	MOV  R9,R30
	RJMP _0x45
_0x44:
	INC  R9
; 0000 017D             break;
_0x45:
	RJMP _0x3C
; 0000 017E         case 4:
_0x43:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x46
; 0000 017F             if ((Day >= 31) && (Month == 1 || Month == 3 || Month == 5 || Month == 7 || Month == 8 || Month == 10 ||Mont ...
	LDI  R30,LOW(31)
	CP   R8,R30
	BRLO _0x48
	LDI  R30,LOW(1)
	CP   R30,R9
	BREQ _0x49
	LDI  R30,LOW(3)
	CP   R30,R9
	BREQ _0x49
	LDI  R30,LOW(5)
	CP   R30,R9
	BREQ _0x49
	LDI  R30,LOW(7)
	CP   R30,R9
	BREQ _0x49
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ _0x49
	LDI  R30,LOW(10)
	CP   R30,R9
	BREQ _0x49
	LDI  R30,LOW(12)
	CP   R30,R9
	BRNE _0x48
_0x49:
	RJMP _0x4B
_0x48:
	RJMP _0x47
_0x4B:
	LDI  R30,LOW(1)
	MOV  R8,R30
	RJMP _0x3C
; 0000 0180             else if ((Day >= 30) && (Month == 4 || Month == 6 || Month == 9 || Month == 11)) {Day = 1; break;}
_0x47:
	LDI  R30,LOW(30)
	CP   R8,R30
	BRLO _0x4E
	LDI  R30,LOW(4)
	CP   R30,R9
	BREQ _0x4F
	LDI  R30,LOW(6)
	CP   R30,R9
	BREQ _0x4F
	LDI  R30,LOW(9)
	CP   R30,R9
	BREQ _0x4F
	LDI  R30,LOW(11)
	CP   R30,R9
	BRNE _0x4E
_0x4F:
	RJMP _0x51
_0x4E:
	RJMP _0x4D
_0x51:
	LDI  R30,LOW(1)
	MOV  R8,R30
	RJMP _0x3C
; 0000 0181             else if (Day >= 29 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 1) {Day = 1; break;}
_0x4D:
	LDI  R30,LOW(29)
	CP   R8,R30
	BRLO _0x54
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x54
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CALL SUBOPT_0xA
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x55
_0x54:
	RJMP _0x53
_0x55:
	LDI  R30,LOW(1)
	MOV  R8,R30
	RJMP _0x3C
; 0000 0182             else if (Day >= 28 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 0) {Day = 1; break;}
_0x53:
	LDI  R30,LOW(28)
	CP   R8,R30
	BRLO _0x58
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x58
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CALL SUBOPT_0xA
	SBIW R30,0
	BREQ _0x59
_0x58:
	RJMP _0x57
_0x59:
	LDI  R30,LOW(1)
	MOV  R8,R30
	RJMP _0x3C
; 0000 0183             else {Day++; break;}
_0x57:
	INC  R8
	RJMP _0x3C
; 0000 0184         case 5:
_0x46:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x5C
; 0000 0185             if (Hour >= 23) Hour = 0; else Hour++;
	LDI  R30,LOW(23)
	CP   R5,R30
	BRLO _0x5D
	CLR  R5
	RJMP _0x5E
_0x5D:
	INC  R5
; 0000 0186             break;
_0x5E:
	RJMP _0x3C
; 0000 0187         case 6:
_0x5C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x5F
; 0000 0188             if (Minute >= 59) Minute = 0; else Minute++;
	LDI  R30,LOW(59)
	CP   R4,R30
	BRLO _0x60
	CLR  R4
	RJMP _0x61
_0x60:
	INC  R4
; 0000 0189             break;
_0x61:
	RJMP _0x3C
; 0000 018A         case 7:
_0x5F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x62
; 0000 018B             Second = 0;
	CLR  R7
; 0000 018C             break;
	RJMP _0x3C
; 0000 018D         case 8:
_0x62:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x3C
; 0000 018E             if (Weekday >= 7) Weekday = 1; else Weekday++;
	LDI  R30,LOW(7)
	CP   R11,R30
	BRLO _0x64
	LDI  R30,LOW(1)
	MOV  R11,R30
	RJMP _0x65
_0x64:
	INC  R11
; 0000 018F             break;
_0x65:
; 0000 0190     }
_0x3C:
; 0000 0191     delay_ms(500);
	RJMP _0x212000E
; 0000 0192 }
; .FEND
;
;void menu_sw()
; 0000 0195 {
_menu_sw:
; .FSTART _menu_sw
; 0000 0196     lcd_clear();
	CALL _lcd_clear
; 0000 0197     if (menu_selector >= 8)
	LDS  R26,_menu_selector
	CPI  R26,LOW(0x8)
	BRLO _0x66
; 0000 0198     {
; 0000 0199         menu_selector = 0;
	LDI  R30,LOW(0)
	STS  _menu_selector,R30
; 0000 019A         rtc_set_time(Hour, Minute, Second);
	ST   -Y,R5
	ST   -Y,R4
	MOV  R26,R7
	RCALL _rtc_set_time
; 0000 019B         rtc_set_date(Weekday, Day, Month, Year);
	ST   -Y,R11
	ST   -Y,R8
	ST   -Y,R9
	MOV  R26,R6
	RCALL _rtc_set_date
; 0000 019C     }
; 0000 019D     else menu_selector++;
	RJMP _0x67
_0x66:
	LDS  R30,_menu_selector
	SUBI R30,-LOW(1)
	STS  _menu_selector,R30
; 0000 019E     delay_ms(500);
_0x67:
	RJMP _0x212000E
; 0000 019F }
; .FEND
;
;void down_sw()
; 0000 01A2 {
_down_sw:
; .FSTART _down_sw
; 0000 01A3     switch(menu_selector)
	CALL SUBOPT_0xB
; 0000 01A4     {
; 0000 01A5         case 1:
	BRNE _0x6B
; 0000 01A6             if (Year_century <= 0) Year_century = 99; else Year_century--;
	CALL SUBOPT_0x0
	CPI  R30,0
	BRNE _0x6C
	LDI  R26,LOW(_Year_century)
	LDI  R27,HIGH(_Year_century)
	LDI  R30,LOW(99)
	RJMP _0x109
_0x6C:
	CALL SUBOPT_0x0
	SUBI R30,LOW(1)
_0x109:
	CALL __EEPROMWRB
; 0000 01A7             break;
	RJMP _0x6A
; 0000 01A8         case 2:
_0x6B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6E
; 0000 01A9             if (Year <= 0) Year = 99; else Year--;
	TST  R6
	BRNE _0x6F
	LDI  R30,LOW(99)
	MOV  R6,R30
	RJMP _0x70
_0x6F:
	DEC  R6
; 0000 01AA             break;
_0x70:
	RJMP _0x6A
; 0000 01AB         case 3:
_0x6E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x71
; 0000 01AC             if (Month <= 1) Month = 12; else Month--;
	LDI  R30,LOW(1)
	CP   R30,R9
	BRLO _0x72
	LDI  R30,LOW(12)
	MOV  R9,R30
	RJMP _0x73
_0x72:
	DEC  R9
; 0000 01AD             break;
_0x73:
	RJMP _0x6A
; 0000 01AE         case 4:
_0x71:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x74
; 0000 01AF             if ((Day <= 1) && (Month == 1 || Month == 3 || Month == 5 || Month == 7 || Month == 8 || Month == 10 ||Month ...
	LDI  R30,LOW(1)
	CP   R30,R8
	BRLO _0x76
	CP   R30,R9
	BREQ _0x77
	LDI  R30,LOW(3)
	CP   R30,R9
	BREQ _0x77
	LDI  R30,LOW(5)
	CP   R30,R9
	BREQ _0x77
	LDI  R30,LOW(7)
	CP   R30,R9
	BREQ _0x77
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ _0x77
	LDI  R30,LOW(10)
	CP   R30,R9
	BREQ _0x77
	LDI  R30,LOW(12)
	CP   R30,R9
	BRNE _0x76
_0x77:
	RJMP _0x79
_0x76:
	RJMP _0x75
_0x79:
	LDI  R30,LOW(31)
	MOV  R8,R30
	RJMP _0x6A
; 0000 01B0             else if ((Day <= 1) && (Month == 4 || Month == 6 || Month == 9 || Month == 11)) {Day = 30; break;}
_0x75:
	LDI  R30,LOW(1)
	CP   R30,R8
	BRLO _0x7C
	LDI  R30,LOW(4)
	CP   R30,R9
	BREQ _0x7D
	LDI  R30,LOW(6)
	CP   R30,R9
	BREQ _0x7D
	LDI  R30,LOW(9)
	CP   R30,R9
	BREQ _0x7D
	LDI  R30,LOW(11)
	CP   R30,R9
	BRNE _0x7C
_0x7D:
	RJMP _0x7F
_0x7C:
	RJMP _0x7B
_0x7F:
	LDI  R30,LOW(30)
	MOV  R8,R30
	RJMP _0x6A
; 0000 01B1             else if (Day <= 1 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 1) {Day = 29; break;}
_0x7B:
	LDI  R30,LOW(1)
	CP   R30,R8
	BRLO _0x82
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x82
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CALL SUBOPT_0xA
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x83
_0x82:
	RJMP _0x81
_0x83:
	LDI  R30,LOW(29)
	MOV  R8,R30
	RJMP _0x6A
; 0000 01B2             else if (Day <= 1 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 0) {Day = 28; break;}
_0x81:
	LDI  R30,LOW(1)
	CP   R30,R8
	BRLO _0x86
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x86
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CALL SUBOPT_0xA
	SBIW R30,0
	BREQ _0x87
_0x86:
	RJMP _0x85
_0x87:
	LDI  R30,LOW(28)
	MOV  R8,R30
	RJMP _0x6A
; 0000 01B3             else {Day--; break;}
_0x85:
	DEC  R8
	RJMP _0x6A
; 0000 01B4         case 5:
_0x74:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x8A
; 0000 01B5             if (Hour <= 0) Hour = 23; else Hour--;
	TST  R5
	BRNE _0x8B
	LDI  R30,LOW(23)
	MOV  R5,R30
	RJMP _0x8C
_0x8B:
	DEC  R5
; 0000 01B6             break;
_0x8C:
	RJMP _0x6A
; 0000 01B7         case 6:
_0x8A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x8D
; 0000 01B8             if (Minute <= 0) Minute = 59; else Minute--;
	TST  R4
	BRNE _0x8E
	LDI  R30,LOW(59)
	MOV  R4,R30
	RJMP _0x8F
_0x8E:
	DEC  R4
; 0000 01B9             break;
_0x8F:
	RJMP _0x6A
; 0000 01BA         case 7:
_0x8D:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x90
; 0000 01BB             Second = 0;
	CLR  R7
; 0000 01BC             break;
	RJMP _0x6A
; 0000 01BD         case 8:
_0x90:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x6A
; 0000 01BE             if (Weekday <= 1) Weekday = 7; else Weekday--;
	LDI  R30,LOW(1)
	CP   R30,R11
	BRLO _0x92
	LDI  R30,LOW(7)
	MOV  R11,R30
	RJMP _0x93
_0x92:
	DEC  R11
; 0000 01BF             break;
_0x93:
; 0000 01C0     }
_0x6A:
; 0000 01C1     delay_ms(500);
_0x212000E:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 01C2 }
	RET
; .FEND
;
;int isLeapYear(int _year, int _type)
; 0000 01C5 {
_isLeapYear:
; .FSTART _isLeapYear
; 0000 01C6     switch(_type)
	ST   -Y,R27
	ST   -Y,R26
;	_year -> Y+2
;	_type -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0000 01C7     {
; 0000 01C8         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x97
; 0000 01C9             if (_year % 4 == 0) return 1; else return 0;
	CALL SUBOPT_0xC
	SBIW R30,0
	BRNE _0x98
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x212000D
_0x98:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000D
; 0000 01CA             if ((_year % 100 == 0) && (_year % 400 == 0)) return 1; else return 0;
; 0000 01CB             break;
; 0000 01CC         case 2:
_0x97:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x96
; 0000 01CD             if (_year % 4 == 3) return 1; else return 0;
	CALL SUBOPT_0xC
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x9F
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x212000D
_0x9F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
; 0000 01CE             break;
; 0000 01CF     }
_0x96:
; 0000 01D0 }
_0x212000D:
	ADIW R28,4
	RET
; .FEND
;
;void Georgian2Solar(int gYear, char gMonth, char gDay, unsigned int* sYear, char* sMonth, char* sDay)
; 0000 01D3 {
_Georgian2Solar:
; .FSTART _Georgian2Solar
; 0000 01D4     float s, r;
; 0000 01D5     int m;
; 0000 01D6     long sa, ss;
; 0000 01D7     int ma, ro;
; 0000 01D8 
; 0000 01D9     s = gYear - 1;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,16
	CALL __SAVELOCR6
;	gYear -> Y+30
;	gMonth -> Y+29
;	gDay -> Y+28
;	*sYear -> Y+26
;	*sMonth -> Y+24
;	*sDay -> Y+22
;	s -> Y+18
;	r -> Y+14
;	m -> R16,R17
;	sa -> Y+10
;	ss -> Y+6
;	ma -> R18,R19
;	ro -> R20,R21
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	SBIW R30,1
	CALL SUBOPT_0xD
	__PUTD1S 18
; 0000 01DA     m = gMonth - 1;
	LDD  R30,Y+29
	LDI  R31,0
	SBIW R30,1
	MOVW R16,R30
; 0000 01DB     r = (s * 365.25) + gDay;
	__GETD2S 18
	CALL SUBOPT_0xE
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+28
	LDI  R31,0
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
; 0000 01DC 
; 0000 01DD     if (gYear % 4 == 0)
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	SBIW R30,0
	BREQ PC+2
	RJMP _0xA1
; 0000 01DE     {
; 0000 01DF         switch(m)
	MOVW R30,R16
; 0000 01E0         {
; 0000 01E1             case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA5
; 0000 01E2                 r += 31; break;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	RJMP _0x10A
; 0000 01E3             case 2:
_0xA5:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA6
; 0000 01E4                 r += 60; break;
	CALL SUBOPT_0x10
	__GETD2N 0x42700000
	RJMP _0x10A
; 0000 01E5             case 3:
_0xA6:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA7
; 0000 01E6                 r += 91; break;
	CALL SUBOPT_0x10
	__GETD2N 0x42B60000
	RJMP _0x10A
; 0000 01E7             case 4:
_0xA7:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xA8
; 0000 01E8                 r += 121; break;
	CALL SUBOPT_0x10
	__GETD2N 0x42F20000
	RJMP _0x10A
; 0000 01E9             case 5:
_0xA8:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xA9
; 0000 01EA                 r += 152; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43180000
	RJMP _0x10A
; 0000 01EB             case 6:
_0xA9:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xAA
; 0000 01EC                 r += 182; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43360000
	RJMP _0x10A
; 0000 01ED             case 7:
_0xAA:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xAB
; 0000 01EE                 r += 213; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43550000
	RJMP _0x10A
; 0000 01EF             case 8:
_0xAB:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xAC
; 0000 01F0                 r += 244; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43740000
	RJMP _0x10A
; 0000 01F1             case 9:
_0xAC:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xAD
; 0000 01F2                 r += 274; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43890000
	RJMP _0x10A
; 0000 01F3             case 10:
_0xAD:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xAE
; 0000 01F4                 r += 305; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43988000
	RJMP _0x10A
; 0000 01F5             case 11:
_0xAE:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xA4
; 0000 01F6                 r += 335; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43A78000
_0x10A:
	CALL __ADDF12
	CALL SUBOPT_0x12
; 0000 01F7         }
_0xA4:
; 0000 01F8     }
; 0000 01F9     else
	RJMP _0xB0
_0xA1:
; 0000 01FA     {
; 0000 01FB         switch(m)
	MOVW R30,R16
; 0000 01FC         {
; 0000 01FD             case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB4
; 0000 01FE                 r += 31; break;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	RJMP _0x10B
; 0000 01FF             case 2:
_0xB4:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0200                 r += 59; break;
	CALL SUBOPT_0x10
	__GETD2N 0x426C0000
	RJMP _0x10B
; 0000 0201             case 3:
_0xB5:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB6
; 0000 0202                 r += 90; break;
	CALL SUBOPT_0x10
	__GETD2N 0x42B40000
	RJMP _0x10B
; 0000 0203             case 4:
_0xB6:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB7
; 0000 0204                 r += 120; break;
	CALL SUBOPT_0x10
	__GETD2N 0x42F00000
	RJMP _0x10B
; 0000 0205             case 5:
_0xB7:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB8
; 0000 0206                 r += 151; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43170000
	RJMP _0x10B
; 0000 0207             case 6:
_0xB8:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB9
; 0000 0208                 r += 181; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43350000
	RJMP _0x10B
; 0000 0209             case 7:
_0xB9:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xBA
; 0000 020A                 r += 212; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43540000
	RJMP _0x10B
; 0000 020B             case 8:
_0xBA:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xBB
; 0000 020C                 r += 243; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43730000
	RJMP _0x10B
; 0000 020D             case 9:
_0xBB:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xBC
; 0000 020E                 r += 273; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43888000
	RJMP _0x10B
; 0000 020F             case 10:
_0xBC:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xBD
; 0000 0210                 r += 304; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43980000
	RJMP _0x10B
; 0000 0211             case 11:
_0xBD:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xB3
; 0000 0212                 r += 334; break;
	CALL SUBOPT_0x10
	__GETD2N 0x43A70000
_0x10B:
	CALL __ADDF12
	CALL SUBOPT_0x12
; 0000 0213         }
_0xB3:
; 0000 0214     }
_0xB0:
; 0000 0215     r -= 226899;
	CALL SUBOPT_0x10
	__GETD2N 0x485D94C0
	CALL __SUBF12
	CALL SUBOPT_0x12
; 0000 0216     sa = (r / 365.25) + 1;
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL __ADDF12
	MOVW R26,R28
	ADIW R26,10
	CALL __CFD1
	CALL __PUTDP1
; 0000 0217     ss = r / 365.25;
	CALL SUBOPT_0x13
	MOVW R26,R28
	ADIW R26,6
	CALL __CFD1
	CALL __PUTDP1
; 0000 0218     r -= (ss * 365.25) + 0.25;
	__GETD1S 6
	CALL __CDF1
	__GETD2N 0x43B6A000
	CALL __MULF12
	__GETD2N 0x3E800000
	CALL __ADDF12
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x12
; 0000 0219     if (sa % 4 == 3) r += 1;
	CALL SUBOPT_0x17
	__CPD1N 0x3
	BRNE _0xBF
	CALL SUBOPT_0x10
	CALL SUBOPT_0x14
	CALL SUBOPT_0xF
; 0000 021A     if (r >= 336) {ma = 12; ro = r - 336;}
_0xBF:
	CALL SUBOPT_0x15
	__GETD1N 0x43A80000
	CALL __CMPF12
	BRLO _0xC0
	__GETWRN 18,19,12
	CALL SUBOPT_0x10
	__GETD2N 0x43A80000
	CALL SUBOPT_0x18
; 0000 021B     else if (r >= 306) {ma = 11; ro = r - 306;}
	RJMP _0xC1
_0xC0:
	CALL SUBOPT_0x15
	__GETD1N 0x43990000
	CALL __CMPF12
	BRLO _0xC2
	__GETWRN 18,19,11
	CALL SUBOPT_0x10
	__GETD2N 0x43990000
	CALL SUBOPT_0x18
; 0000 021C     else if (r >= 276) {ma = 10; ro = r - 276;}
	RJMP _0xC3
_0xC2:
	CALL SUBOPT_0x15
	__GETD1N 0x438A0000
	CALL __CMPF12
	BRLO _0xC4
	__GETWRN 18,19,10
	CALL SUBOPT_0x10
	__GETD2N 0x438A0000
	CALL SUBOPT_0x18
; 0000 021D     else if (r >= 246) {ma = 9; ro = r - 246;}
	RJMP _0xC5
_0xC4:
	CALL SUBOPT_0x15
	__GETD1N 0x43760000
	CALL __CMPF12
	BRLO _0xC6
	__GETWRN 18,19,9
	CALL SUBOPT_0x10
	__GETD2N 0x43760000
	CALL SUBOPT_0x18
; 0000 021E     else if (r >= 216) {ma = 8; ro = r - 216;}
	RJMP _0xC7
_0xC6:
	CALL SUBOPT_0x15
	__GETD1N 0x43580000
	CALL __CMPF12
	BRLO _0xC8
	__GETWRN 18,19,8
	CALL SUBOPT_0x10
	__GETD2N 0x43580000
	CALL SUBOPT_0x18
; 0000 021F     else if (r >= 186) {ma = 7; ro = r - 186;}
	RJMP _0xC9
_0xC8:
	CALL SUBOPT_0x15
	__GETD1N 0x433A0000
	CALL __CMPF12
	BRLO _0xCA
	__GETWRN 18,19,7
	CALL SUBOPT_0x10
	__GETD2N 0x433A0000
	CALL SUBOPT_0x18
; 0000 0220     else if (r >= 155) {ma = 6; ro = r - 155;}
	RJMP _0xCB
_0xCA:
	CALL SUBOPT_0x15
	__GETD1N 0x431B0000
	CALL __CMPF12
	BRLO _0xCC
	__GETWRN 18,19,6
	CALL SUBOPT_0x10
	__GETD2N 0x431B0000
	CALL SUBOPT_0x18
; 0000 0221     else if (r >= 124) {ma = 5; ro = r - 124;}
	RJMP _0xCD
_0xCC:
	CALL SUBOPT_0x15
	__GETD1N 0x42F80000
	CALL __CMPF12
	BRLO _0xCE
	__GETWRN 18,19,5
	CALL SUBOPT_0x10
	__GETD2N 0x42F80000
	CALL SUBOPT_0x18
; 0000 0222     else if (r >= 93) {ma = 4; ro = r - 93;}
	RJMP _0xCF
_0xCE:
	CALL SUBOPT_0x15
	__GETD1N 0x42BA0000
	CALL __CMPF12
	BRLO _0xD0
	__GETWRN 18,19,4
	CALL SUBOPT_0x10
	__GETD2N 0x42BA0000
	CALL SUBOPT_0x18
; 0000 0223     else if (r >= 62) {ma = 3; ro = r - 62;}
	RJMP _0xD1
_0xD0:
	CALL SUBOPT_0x15
	__GETD1N 0x42780000
	CALL __CMPF12
	BRLO _0xD2
	__GETWRN 18,19,3
	CALL SUBOPT_0x10
	__GETD2N 0x42780000
	CALL SUBOPT_0x18
; 0000 0224     else if (r >= 31) {ma = 2; ro = r - 31;}
	RJMP _0xD3
_0xD2:
	CALL SUBOPT_0x15
	__GETD1N 0x41F80000
	CALL __CMPF12
	BRLO _0xD4
	__GETWRN 18,19,2
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x18
; 0000 0225     else if (r > 0) {ma = 1; ro = r;}
	RJMP _0xD5
_0xD4:
	CALL SUBOPT_0x15
	CALL __CPD02
	BRGE _0xD6
	__GETWRN 18,19,1
	CALL SUBOPT_0x10
	CALL __CFD1
	MOVW R20,R30
; 0000 0226     else if (r == 0)
	RJMP _0xD7
_0xD6:
	CALL SUBOPT_0x10
	CALL __CPD10
	BRNE _0xD8
; 0000 0227     {
; 0000 0228         if (sa % 4 != 0) {sa -= 1; ma = 12; ro = 29;}
	CALL SUBOPT_0x17
	CALL __CPD10
	BREQ _0xD9
	CALL SUBOPT_0x19
	__GETWRN 20,21,29
; 0000 0229         else {sa -= 1; ma = 12; ro = 30;}
	RJMP _0xDA
_0xD9:
	CALL SUBOPT_0x19
	__GETWRN 20,21,30
_0xDA:
; 0000 022A     }
; 0000 022B     if (ro < 1)
_0xD8:
_0xD7:
_0xD5:
_0xD3:
_0xD1:
_0xCF:
_0xCD:
_0xCB:
_0xC9:
_0xC7:
_0xC5:
_0xC3:
_0xC1:
	__CPWRN 20,21,1
	BRLT PC+2
	RJMP _0xDB
; 0000 022C     {
; 0000 022D         switch(ma)
	MOVW R30,R18
; 0000 022E         {
; 0000 022F             case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xDF
; 0000 0230                 sa -= 1; ma = 12;
	CALL SUBOPT_0x19
; 0000 0231                 if (isLeapYear(sa, 2) == 1) ro = 30; else ro = 29;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _isLeapYear
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE0
	__GETWRN 20,21,30
	RJMP _0xE1
_0xE0:
	__GETWRN 20,21,29
; 0000 0232                 break;
_0xE1:
	RJMP _0xDE
; 0000 0233             case 2:
_0xDF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xE2
; 0000 0234                 ma = 1; ro = 31; break;
	__GETWRN 18,19,1
	__GETWRN 20,21,31
	RJMP _0xDE
; 0000 0235             case 3:
_0xE2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0236                 ma = 2; ro = 31; break;
	__GETWRN 18,19,2
	__GETWRN 20,21,31
	RJMP _0xDE
; 0000 0237             case 4:
_0xE3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xE4
; 0000 0238                 ma = 3; ro = 31; break;
	__GETWRN 18,19,3
	__GETWRN 20,21,31
	RJMP _0xDE
; 0000 0239             case 5:
_0xE4:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xE5
; 0000 023A                 ma = 4; ro = 31; break;
	__GETWRN 18,19,4
	__GETWRN 20,21,31
	RJMP _0xDE
; 0000 023B             case 6:
_0xE5:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xE6
; 0000 023C                 ma = 5; ro = 31; break;
	__GETWRN 18,19,5
	__GETWRN 20,21,31
	RJMP _0xDE
; 0000 023D             case 7:
_0xE6:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xE7
; 0000 023E                 ma = 6; ro = 31; break;
	__GETWRN 18,19,6
	__GETWRN 20,21,31
	RJMP _0xDE
; 0000 023F             case 8:
_0xE7:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0240                 ma = 7; ro = 30; break;
	__GETWRN 18,19,7
	RJMP _0x10C
; 0000 0241             case 9:
_0xE8:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0242                 ma = 8; ro = 30; break;
	__GETWRN 18,19,8
	RJMP _0x10C
; 0000 0243             case 10:
_0xE9:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0244                 ma = 9; ro = 30; break;
	__GETWRN 18,19,9
	RJMP _0x10C
; 0000 0245             case 11:
_0xEA:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0246                 ma = 10; ro = 30; break;
	__GETWRN 18,19,10
	RJMP _0x10C
; 0000 0247             case 12:
_0xEB:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xDE
; 0000 0248                 ma = 11; ro = 30; break;
	__GETWRN 18,19,11
_0x10C:
	__GETWRN 20,21,30
; 0000 0249         }
_0xDE:
; 0000 024A     }
; 0000 024B     *sYear = sa; *sMonth = ma; *sDay = ro;
_0xDB:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ST   X,R18
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ST   X,R20
; 0000 024C 
; 0000 024D     // This function has not been optimized to make understanding easier.
; 0000 024E }
	CALL __LOADLOCR6
	ADIW R28,32
	RET
; .FEND
;
;void showMenu()
; 0000 0251 {
_showMenu:
; .FSTART _showMenu
; 0000 0252     switch(menu_selector)
	CALL SUBOPT_0xB
; 0000 0253     {
; 0000 0254         case 1:
	BRNE _0xF0
; 0000 0255             lcd_gotoxy(0, 0); lcd_puts("Year Century:");
	CALL SUBOPT_0x5
	__POINTW2MN _0xF1,0
	CALL SUBOPT_0x1A
; 0000 0256             sprintf(lcd_buff, "%.2i", Year_century);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x0
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1C
; 0000 0257             lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
	LDI  R26,LOW(_lcd_buff)
	LDI  R27,HIGH(_lcd_buff)
	RJMP _0x10D
; 0000 0258             break;
; 0000 0259         case 2:
_0xF0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xF2
; 0000 025A             lcd_gotoxy(0, 0); lcd_puts("Year:");
	CALL SUBOPT_0x5
	__POINTW2MN _0xF1,14
	CALL SUBOPT_0x1A
; 0000 025B             sprintf(lcd_buff, "%.2i", Year);
	CALL SUBOPT_0x1B
	MOV  R30,R6
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1C
; 0000 025C             lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
	LDI  R26,LOW(_lcd_buff)
	LDI  R27,HIGH(_lcd_buff)
	RJMP _0x10D
; 0000 025D             break;
; 0000 025E         case 3:
_0xF2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xF3
; 0000 025F             lcd_gotoxy(0, 0); lcd_puts("Month:");
	CALL SUBOPT_0x5
	__POINTW2MN _0xF1,20
	CALL SUBOPT_0x1A
; 0000 0260             sprintf(lcd_buff, "%.2i", Month);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1C
; 0000 0261             lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
	LDI  R26,LOW(_lcd_buff)
	LDI  R27,HIGH(_lcd_buff)
	RJMP _0x10D
; 0000 0262             break;
; 0000 0263         case 4:
_0xF3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0264             lcd_gotoxy(0, 0); lcd_puts("Day:");
	CALL SUBOPT_0x5
	__POINTW2MN _0xF1,27
	CALL SUBOPT_0x1A
; 0000 0265             sprintf(lcd_buff, "%.2i", Day);
	CALL SUBOPT_0x1B
	MOV  R30,R8
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1C
; 0000 0266             lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
	LDI  R26,LOW(_lcd_buff)
	LDI  R27,HIGH(_lcd_buff)
	RJMP _0x10D
; 0000 0267             break;
; 0000 0268         case 5:
_0xF4:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0269             lcd_gotoxy(0, 0); lcd_puts("Hour:");
	CALL SUBOPT_0x5
	__POINTW2MN _0xF1,32
	CALL SUBOPT_0x1A
; 0000 026A             sprintf(lcd_buff, "%.2i", Hour);
	CALL SUBOPT_0x1B
	MOV  R30,R5
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1C
; 0000 026B             lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
	LDI  R26,LOW(_lcd_buff)
	LDI  R27,HIGH(_lcd_buff)
	RJMP _0x10D
; 0000 026C             break;
; 0000 026D         case 6:
_0xF5:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xF6
; 0000 026E             lcd_gotoxy(0, 0); lcd_puts("Minute:");
	CALL SUBOPT_0x5
	__POINTW2MN _0xF1,38
	CALL SUBOPT_0x1A
; 0000 026F             sprintf(lcd_buff, "%.2i", Minute);
	CALL SUBOPT_0x1B
	MOV  R30,R4
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1C
; 0000 0270             lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
	LDI  R26,LOW(_lcd_buff)
	LDI  R27,HIGH(_lcd_buff)
	RJMP _0x10D
; 0000 0271             break;
; 0000 0272         case 7:
_0xF6:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0273             lcd_gotoxy(0, 0); lcd_puts("Second:");
	CALL SUBOPT_0x5
	__POINTW2MN _0xF1,46
	CALL SUBOPT_0x1A
; 0000 0274             sprintf(lcd_buff, "%.2i", Second);
	CALL SUBOPT_0x1B
	MOV  R30,R7
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1C
; 0000 0275             lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
	LDI  R26,LOW(_lcd_buff)
	LDI  R27,HIGH(_lcd_buff)
	RJMP _0x10D
; 0000 0276             break;
; 0000 0277         case 8:
_0xF7:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0278             lcd_gotoxy(0, 0); lcd_puts("Weekday:");
	CALL SUBOPT_0x5
	__POINTW2MN _0xF1,54
	RCALL _lcd_puts
; 0000 0279             lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 027A             switch(Weekday)
	MOV  R30,R11
	CALL SUBOPT_0x7
; 0000 027B             {
; 0000 027C                 case 1:
	BRNE _0xFC
; 0000 027D                     lcd_puts("     Sunday     "); break;
	__POINTW2MN _0xF1,63
	RJMP _0x10D
; 0000 027E                 case 2:
_0xFC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xFD
; 0000 027F                     lcd_puts("     Monday     "); break;
	__POINTW2MN _0xF1,80
	RJMP _0x10D
; 0000 0280                 case 3:
_0xFD:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0281                     lcd_puts("     Tuesday    "); break;
	__POINTW2MN _0xF1,97
	RJMP _0x10D
; 0000 0282                 case 4:
_0xFE:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0283                     lcd_puts("    Wednesday   "); break;
	__POINTW2MN _0xF1,114
	RJMP _0x10D
; 0000 0284                 case 5:
_0xFF:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x100
; 0000 0285                     lcd_puts("    Thursday    "); break;
	__POINTW2MN _0xF1,131
	RJMP _0x10D
; 0000 0286                 case 6:
_0x100:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x101
; 0000 0287                     lcd_puts("     Friday     "); break;
	__POINTW2MN _0xF1,148
	RJMP _0x10D
; 0000 0288                 case 7:
_0x101:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0289                     lcd_puts("    Saturday    "); break;
	__POINTW2MN _0xF1,165
_0x10D:
	RCALL _lcd_puts
; 0000 028A             }
_0xFB:
; 0000 028B             break;
; 0000 028C     }
_0xEF:
; 0000 028D }
	RET
; .FEND

	.DSEG
_0xF1:
	.BYTE 0xB6
;
;void define_char(char flash *pc, char char_code)
; 0000 0290 {

	.CSEG
_define_char:
; .FSTART _define_char
; 0000 0291     char i, a;
; 0000 0292     a = (char_code << 3) | 0x40;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 0293     for (i = 0; i < 8; i++) lcd_write_byte(a++, *pc++);
	LDI  R17,LOW(0)
_0x104:
	CPI  R17,8
	BRSH _0x105
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	RCALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x104
_0x105:
; 0000 0294 }
	JMP  _0x2120005
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	CALL SUBOPT_0x1D
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL SUBOPT_0x1E
	RJMP _0x2120009
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x1D
	LDI  R26,LOW(0)
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
	RJMP _0x212000C
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	CALL SUBOPT_0x1D
	LDI  R26,LOW(0)
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1E
	RJMP _0x2120009
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x1D
	LDI  R26,LOW(3)
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0x21
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x20
	CALL _i2c_stop
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	CALL SUBOPT_0x1D
	LDI  R26,LOW(3)
	CALL _i2c_write
	LDD  R26,Y+3
	CALL SUBOPT_0x25
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1E
	JMP  _0x2120006
; .FEND

	.CSEG
_ds18b20_select:
; .FSTART _ds18b20_select
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	CALL _w1_init
	CPI  R30,0
	BRNE _0x2020003
	LDI  R30,LOW(0)
	RJMP _0x2120008
_0x2020003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2020004
	LDI  R26,LOW(85)
	CALL _w1_write
	LDI  R17,LOW(0)
_0x2020006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R26,R30
	CALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2020006
	RJMP _0x2020008
_0x2020004:
	LDI  R26,LOW(204)
	CALL _w1_write
_0x2020008:
	LDI  R30,LOW(1)
	RJMP _0x2120008
; .FEND
_ds18b20_read_spd:
; .FSTART _ds18b20_read_spd
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2020009
	LDI  R30,LOW(0)
	RJMP _0x212000B
_0x2020009:
	LDI  R26,LOW(190)
	CALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x202000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	CALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x202000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	CALL _w1_dow_crc8
	CALL __LNEGB1
_0x212000B:
	CALL __LOADLOCR4
_0x212000C:
	ADIW R28,6
	RET
; .FEND
_ds18b20_temperature:
; .FSTART _ds18b20_temperature
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x202000D
	CALL SUBOPT_0x26
	RJMP _0x2120008
_0x202000D:
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x202000E
	CALL SUBOPT_0x26
	RJMP _0x2120008
_0x202000E:
	LDI  R26,LOW(68)
	CALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G101*2)
	LDI  R27,HIGH(_conv_delay_G101*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW2PF
	CALL _delay_ms
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x202000F
	CALL SUBOPT_0x26
	RJMP _0x2120008
_0x202000F:
	CALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G101*2)
	LDI  R27,HIGH(_bit_mask_G101*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	CALL SUBOPT_0xD
	__GETD2N 0x3D800000
	CALL __MULF12
	RJMP _0x2120008
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 13
	SBI  0x18,3
	__DELAY_USB 13
	CBI  0x18,3
	__DELAY_USB 13
	RJMP _0x2120007
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x2120007
; .FEND
_lcd_write_byte:
; .FSTART _lcd_write_byte
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL __lcd_write_data
	SBI  0x18,1
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,1
	RJMP _0x212000A
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x212000A:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x27
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x27
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040004
_0x2040005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040007
	RJMP _0x2120007
_0x2040007:
_0x2040004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,1
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,1
	RJMP _0x2120007
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040008
_0x204000A:
_0x2120008:
	LDD  R17,Y+0
_0x2120009:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,3
	SBI  0x17,1
	SBI  0x17,2
	CBI  0x18,3
	CBI  0x18,1
	CBI  0x18,2
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x28
	CALL SUBOPT_0x28
	CALL SUBOPT_0x28
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2120007:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x2120006
__floor1:
    brtc __floor0
	CALL __GETD1S0
	CALL SUBOPT_0x14
	CALL __SUBF12
_0x2120006:
	ADIW R28,4
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G104:
; .FSTART _put_buff_G104
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2080010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2080012
	__CPWRN 16,17,2
	BRLO _0x2080013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2080012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x29
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2080013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2080014
	CALL SUBOPT_0x29
_0x2080014:
	RJMP _0x2080015
_0x2080010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2080015:
_0x2120005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G104:
; .FSTART __ftoe_G104
	CALL SUBOPT_0x2A
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2080019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2080000,0
	CALL _strcpyf
	RJMP _0x2120004
_0x2080019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2080018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2080000,1
	CALL _strcpyf
	RJMP _0x2120004
_0x2080018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x208001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x208001B:
	LDD  R17,Y+11
_0x208001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x208001E
	CALL SUBOPT_0x2B
	RJMP _0x208001C
_0x208001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x208001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x2B
	RJMP _0x2080020
_0x208001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x2C
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2080021
	CALL SUBOPT_0x2B
_0x2080022:
	CALL SUBOPT_0x2C
	BRLO _0x2080024
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	RJMP _0x2080022
_0x2080024:
	RJMP _0x2080025
_0x2080021:
_0x2080026:
	CALL SUBOPT_0x2C
	BRSH _0x2080028
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	SUBI R19,LOW(1)
	RJMP _0x2080026
_0x2080028:
	CALL SUBOPT_0x2B
_0x2080025:
	__GETD1S 12
	CALL SUBOPT_0x31
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2C
	BRLO _0x2080029
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
_0x2080029:
_0x2080020:
	LDI  R17,LOW(0)
_0x208002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x208002C
	__GETD2S 4
	CALL SUBOPT_0x32
	CALL SUBOPT_0x31
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x2D
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x16
	CALL SUBOPT_0x30
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x208002A
	CALL SUBOPT_0x33
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x208002A
_0x208002C:
	CALL SUBOPT_0x35
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x208002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2080116
_0x208002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2080116:
	ST   X,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x35
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x35
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2120004:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G104:
; .FSTART __print_G104
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2080030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x29
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2080032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2080036
	CPI  R18,37
	BRNE _0x2080037
	LDI  R17,LOW(1)
	RJMP _0x2080038
_0x2080037:
	CALL SUBOPT_0x36
_0x2080038:
	RJMP _0x2080035
_0x2080036:
	CPI  R30,LOW(0x1)
	BRNE _0x2080039
	CPI  R18,37
	BRNE _0x208003A
	CALL SUBOPT_0x36
	RJMP _0x2080117
_0x208003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x208003B
	LDI  R16,LOW(1)
	RJMP _0x2080035
_0x208003B:
	CPI  R18,43
	BRNE _0x208003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2080035
_0x208003C:
	CPI  R18,32
	BRNE _0x208003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2080035
_0x208003D:
	RJMP _0x208003E
_0x2080039:
	CPI  R30,LOW(0x2)
	BRNE _0x208003F
_0x208003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2080040
	ORI  R16,LOW(128)
	RJMP _0x2080035
_0x2080040:
	RJMP _0x2080041
_0x208003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2080042
_0x2080041:
	CPI  R18,48
	BRLO _0x2080044
	CPI  R18,58
	BRLO _0x2080045
_0x2080044:
	RJMP _0x2080043
_0x2080045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2080035
_0x2080043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2080046
	LDI  R17,LOW(4)
	RJMP _0x2080035
_0x2080046:
	RJMP _0x2080047
_0x2080042:
	CPI  R30,LOW(0x4)
	BRNE _0x2080049
	CPI  R18,48
	BRLO _0x208004B
	CPI  R18,58
	BRLO _0x208004C
_0x208004B:
	RJMP _0x208004A
_0x208004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2080035
_0x208004A:
_0x2080047:
	CPI  R18,108
	BRNE _0x208004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2080035
_0x208004D:
	RJMP _0x208004E
_0x2080049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2080035
_0x208004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2080053
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x39
	RJMP _0x2080054
_0x2080053:
	CPI  R30,LOW(0x45)
	BREQ _0x2080057
	CPI  R30,LOW(0x65)
	BRNE _0x2080058
_0x2080057:
	RJMP _0x2080059
_0x2080058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x208005A
_0x2080059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x3A
	CALL __GETD1P
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	LDD  R26,Y+13
	TST  R26
	BRMI _0x208005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x208005D
	CPI  R26,LOW(0x20)
	BREQ _0x208005F
	RJMP _0x2080060
_0x208005B:
	CALL SUBOPT_0x3D
	CALL __ANEGF1
	CALL SUBOPT_0x3B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x208005D:
	SBRS R16,7
	RJMP _0x2080061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x39
	RJMP _0x2080062
_0x2080061:
_0x208005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2080062:
_0x2080060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2080064
	CALL SUBOPT_0x3D
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2080065
_0x2080064:
	CALL SUBOPT_0x3D
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G104
_0x2080065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x3E
	RJMP _0x2080066
_0x208005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2080068
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3E
	RJMP _0x2080069
_0x2080068:
	CPI  R30,LOW(0x70)
	BRNE _0x208006B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2080069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x208006D
	CP   R20,R17
	BRLO _0x208006E
_0x208006D:
	RJMP _0x208006C
_0x208006E:
	MOV  R17,R20
_0x208006C:
_0x2080066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x208006F
_0x208006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2080072
	CPI  R30,LOW(0x69)
	BRNE _0x2080073
_0x2080072:
	ORI  R16,LOW(4)
	RJMP _0x2080074
_0x2080073:
	CPI  R30,LOW(0x75)
	BRNE _0x2080075
_0x2080074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2080076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x40
	LDI  R17,LOW(10)
	RJMP _0x2080077
_0x2080076:
	__GETD1N 0x2710
	CALL SUBOPT_0x40
	LDI  R17,LOW(5)
	RJMP _0x2080077
_0x2080075:
	CPI  R30,LOW(0x58)
	BRNE _0x2080079
	ORI  R16,LOW(8)
	RJMP _0x208007A
_0x2080079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20800B8
_0x208007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x208007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x40
	LDI  R17,LOW(8)
	RJMP _0x2080077
_0x208007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x40
	LDI  R17,LOW(4)
_0x2080077:
	CPI  R20,0
	BREQ _0x208007D
	ANDI R16,LOW(127)
	RJMP _0x208007E
_0x208007D:
	LDI  R20,LOW(1)
_0x208007E:
	SBRS R16,1
	RJMP _0x208007F
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3A
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2080118
_0x208007F:
	SBRS R16,2
	RJMP _0x2080081
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CALL __CWD1
	RJMP _0x2080118
_0x2080081:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
	CLR  R22
	CLR  R23
_0x2080118:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2080083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2080084
	CALL SUBOPT_0x3D
	CALL __ANEGD1
	CALL SUBOPT_0x3B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2080084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2080085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2080086
_0x2080085:
	ANDI R16,LOW(251)
_0x2080086:
_0x2080083:
	MOV  R19,R20
_0x208006F:
	SBRC R16,0
	RJMP _0x2080087
_0x2080088:
	CP   R17,R21
	BRSH _0x208008B
	CP   R19,R21
	BRLO _0x208008C
_0x208008B:
	RJMP _0x208008A
_0x208008C:
	SBRS R16,7
	RJMP _0x208008D
	SBRS R16,2
	RJMP _0x208008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x208008F
_0x208008E:
	LDI  R18,LOW(48)
_0x208008F:
	RJMP _0x2080090
_0x208008D:
	LDI  R18,LOW(32)
_0x2080090:
	CALL SUBOPT_0x36
	SUBI R21,LOW(1)
	RJMP _0x2080088
_0x208008A:
_0x2080087:
_0x2080091:
	CP   R17,R20
	BRSH _0x2080093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2080094
	CALL SUBOPT_0x41
	BREQ _0x2080095
	SUBI R21,LOW(1)
_0x2080095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2080094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x39
	CPI  R21,0
	BREQ _0x2080096
	SUBI R21,LOW(1)
_0x2080096:
	SUBI R20,LOW(1)
	RJMP _0x2080091
_0x2080093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2080097
_0x2080098:
	CPI  R19,0
	BREQ _0x208009A
	SBRS R16,3
	RJMP _0x208009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x208009C
_0x208009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x208009C:
	CALL SUBOPT_0x36
	CPI  R21,0
	BREQ _0x208009D
	SUBI R21,LOW(1)
_0x208009D:
	SUBI R19,LOW(1)
	RJMP _0x2080098
_0x208009A:
	RJMP _0x208009E
_0x2080097:
_0x20800A0:
	CALL SUBOPT_0x42
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20800A2
	SBRS R16,3
	RJMP _0x20800A3
	SUBI R18,-LOW(55)
	RJMP _0x20800A4
_0x20800A3:
	SUBI R18,-LOW(87)
_0x20800A4:
	RJMP _0x20800A5
_0x20800A2:
	SUBI R18,-LOW(48)
_0x20800A5:
	SBRC R16,4
	RJMP _0x20800A7
	CPI  R18,49
	BRSH _0x20800A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20800A8
_0x20800A9:
	RJMP _0x20800AB
_0x20800A8:
	CP   R20,R19
	BRSH _0x2080119
	CP   R21,R19
	BRLO _0x20800AE
	SBRS R16,0
	RJMP _0x20800AF
_0x20800AE:
	RJMP _0x20800AD
_0x20800AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20800B0
_0x2080119:
	LDI  R18,LOW(48)
_0x20800AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20800B1
	CALL SUBOPT_0x41
	BREQ _0x20800B2
	SUBI R21,LOW(1)
_0x20800B2:
_0x20800B1:
_0x20800B0:
_0x20800A7:
	CALL SUBOPT_0x36
	CPI  R21,0
	BREQ _0x20800B3
	SUBI R21,LOW(1)
_0x20800B3:
_0x20800AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x42
	CALL __MODD21U
	CALL SUBOPT_0x3B
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x40
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20800A1
	RJMP _0x20800A0
_0x20800A1:
_0x208009E:
	SBRS R16,0
	RJMP _0x20800B4
_0x20800B5:
	CPI  R21,0
	BREQ _0x20800B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x39
	RJMP _0x20800B5
_0x20800B7:
_0x20800B4:
_0x20800B8:
_0x2080054:
_0x2080117:
	LDI  R17,LOW(0)
_0x2080035:
	RJMP _0x2080030
_0x2080032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x43
	SBIW R30,0
	BRNE _0x20800B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120003
_0x20800B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x43
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G104)
	LDI  R31,HIGH(_put_buff_G104)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G104
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x2A
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20C000D
	CALL SUBOPT_0x44
	__POINTW2FN _0x20C0000,0
	CALL _strcpyf
	RJMP _0x2120002
_0x20C000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20C000C
	CALL SUBOPT_0x44
	__POINTW2FN _0x20C0000,1
	CALL _strcpyf
	RJMP _0x2120002
_0x20C000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20C000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x45
	CALL SUBOPT_0x46
	LDI  R30,LOW(45)
	ST   X,R30
_0x20C000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20C0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20C0010:
	LDD  R17,Y+8
_0x20C0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20C0013
	CALL SUBOPT_0x47
	CALL SUBOPT_0x32
	CALL SUBOPT_0x48
	RJMP _0x20C0011
_0x20C0013:
	CALL SUBOPT_0x49
	CALL __ADDF12
	CALL SUBOPT_0x45
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x48
_0x20C0014:
	CALL SUBOPT_0x49
	CALL __CMPF12
	BRLO _0x20C0016
	CALL SUBOPT_0x47
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x48
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20C0017
	CALL SUBOPT_0x44
	__POINTW2FN _0x20C0000,5
	CALL _strcpyf
	RJMP _0x2120002
_0x20C0017:
	RJMP _0x20C0014
_0x20C0016:
	CPI  R17,0
	BRNE _0x20C0018
	CALL SUBOPT_0x46
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20C0019
_0x20C0018:
_0x20C001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20C001C
	CALL SUBOPT_0x47
	CALL SUBOPT_0x32
	CALL SUBOPT_0x31
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x46
	CALL SUBOPT_0x34
	LDI  R31,0
	CALL SUBOPT_0x47
	CALL SUBOPT_0xD
	CALL __MULF12
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x16
	CALL SUBOPT_0x45
	RJMP _0x20C001A
_0x20C001C:
_0x20C0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2120001
	CALL SUBOPT_0x46
	LDI  R30,LOW(46)
	ST   X,R30
_0x20C001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20C0020
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x45
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x46
	CALL SUBOPT_0x34
	LDI  R31,0
	CALL SUBOPT_0x4A
	CALL SUBOPT_0xD
	CALL SUBOPT_0x16
	CALL SUBOPT_0x45
	RJMP _0x20C001E
_0x20C0020:
_0x2120001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2120002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_Temp:
	.BYTE 0x4
_lcd_buff:
	.BYTE 0x10

	.ESEG
_Year_century:
	.BYTE 0x1

	.DSEG
_sDay:
	.BYTE 0x1
_menu_selector:
	.BYTE 0x1
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G106:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_Year_century)
	LDI  R27,HIGH(_Year_century)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_lcd_buff)
	LDI  R31,HIGH(_lcd_buff)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	MOV  R30,R6
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOV  R30,R9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x4:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_lcd_buff)
	LDI  R27,HIGH(_lcd_buff)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_lcd_buff)
	LDI  R31,HIGH(_lcd_buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _isLeapYear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDS  R30,_menu_selector
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	__GETD1N 0x43B6A000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __ADDF12
	__PUTD1S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x10:
	__GETD1S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__GETD2N 0x41F80000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	__PUTD1S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	__GETD2S 14
	RCALL SUBOPT_0xE
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x15:
	__GETD2S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	__GETD2S 10
	__GETD1N 0x4
	CALL __MODD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x18:
	CALL __SUBF12
	CALL __CFD1
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	__GETD1S 10
	__SUBD1N 1
	__PUTD1S 10
	__GETWRN 18,19,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	CALL _lcd_puts
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	__POINTW1FN _0x0,82
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1C:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(8)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL _i2c_write
	LD   R26,Y
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	__GETD1N 0xC61C3C00
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2B:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2C:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2E:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x36:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x37:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x38:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3A:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	RCALL SUBOPT_0x37
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0x3A
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x41:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x46:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x49:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	__GETD2S 9
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x18
	.equ __w1_bit=0x00

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_dow_crc8:
	clr  r30
	tst  r26
	breq __w1_dow_crc83
	mov  r24,r26
	ldi  r22,0x18
	ld   r26,y
	ldd  r27,y+1
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,2
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__MODD21:
	CLT
	SBRS R25,7
	RJMP __MODD211
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	SUBI R26,-1
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	SET
__MODD211:
	SBRC R23,7
	RCALL __ANEGD1
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	BRTC __MODD212
	RCALL __ANEGD1
__MODD212:
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
