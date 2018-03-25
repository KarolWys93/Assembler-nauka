/*
 * Projekt pokazowy 1
 * Przycisk monostabilny + dioda
 *
 * Przycisk znajduje si� na pinie PD2
 * Dioda jest na pinie PB0, PB1 oraz PB2
 * W przyk�adzie u�ywana b�dzie tylko dioda z PB0
 * Pozosta�e b�d� jako HiZ.
 * Dioda �wieci, gdy na wyjsciu jest stan niski. (dioda RGB ma wspolna anode)
 *
 * Wci�ni�ty przycisk daje warto�� 0, swobodnie daje 1.
 *
 * Created: 22-03-2016 22:41:01
 * Author: Karol
 *
 */
 
;**********************************************
;DEKLARACJE:

.INCLUDE "m8adef.inc"
.EQU F_CPU = 1000000; cz�stotliwo�� taktowania 1 MHz

;********************************************
;TABLICA WEKTOR�W PRZERWA�, odkomentowa� potrzebne

.CSEG	;do pami�ci programu
.ORG 0x00	;ustawienie pocz�tku pami�ci
	rjmp RESET ; Reset Handler
.ORG 0x01
;	rjmp EXT_INT0 ; IRQ0 Handler
.ORG 0x02
;	rjmp EXT_INT1 ; IRQ1 Handler
.ORG 0x03
;	rjmp TIM2_COMP ; Timer2 Compare Handler
.ORG 0x04
;	rjmp TIM2_OVF ; Timer2 Overflow Handler
.ORG 0x05
;	rjmp TIM1_CAPT ; Timer1 Capture Handler
.ORG 0x06
;	rjmp TIM1_COMPA ; Timer1 CompareA Handler
.ORG 0x07
;	rjmp TIM1_COMPB ; Timer1 CompareB Handler
.ORG 0x08
;	rjmp TIM1_OVF ; Timer1 Overflow Handler
.ORG 0x09
;	rjmp TIM0_OVF ; Timer0 Overflow Handler
.ORG 0x0A
;	rjmp SPI_STC ; SPI Transfer Complete Handler
.ORG 0x0B
;	rjmp USART_RXC ; USART RX Complete Handler
.ORG 0x0C
;	rjmp USART_UDRE ; UDR Empty Handler
.ORG 0x0D
;	rjmp USART_TXC ; USART TX Complete Handler
.ORG 0x0E
;	rjmp ADC_INT ; ADC Conversion Complete Handler
.ORG 0x0F
;	rjmp EE_RDY ; EEPROM Ready Handler
.ORG 0x10
;	rjmp ANA_COMP ; Analog Comparator Handler
.ORG 0x11
;	rjmp TWSI ; Two-wire Serial Interface Handler
.ORG 0x12
;	rjmp SPM_RDY ; Store Program Memory Ready Handler

;koniec tablicy wektor�w przerwa�
.ORG 0x13 ; kod tego miejsca zaczyna si� program
;//////////////////////////////////////////////


;**********************************************
;Program g��wny


RESET:		;inicjalizacja mikrokontrolra
	LDI r17, HIGH(RAMEND);
	LDI r16, LOW(RAMEND);
	OUT SPH, r17;
	OUT SPL, r16;	ustalenie wska�nika stosu
	
	SBI DDRB, PB0
	SBI PORTB, PB0 ;Ustawienie kierunku i stanu pinu na wyj�cie w stanie wysokim

	CBI DDRD, PD2
	SBI PORTD, PD2 ;Ustawienie kierunku i stanu pinu na wej�cie z pull-up

    RJMP MAIN_LOOP_1	;wersja 1
	;RJMP MAIN_LOOP_2	;wersja 2

MAIN_LOOP_1: ;g��wna p�tla programu wersja 1

	IN r16, PIND ;Pobranie stanu portu D
	ANDI r16, (1<<PD2)

	BRNE LED_OFF
	CBI PORTB, PB0 ; Je�li r16 == 0 (przycisk wci�ni�ty) to zapal diod�
	RJMP MAIN_LOOP_1

	LED_OFF:
	SBI PORTB, PB0 ; Je�li r16 > 0 (przycisk puszczony) to zga� diod�

	RJMP MAIN_LOOP_1


MAIN_LOOP_2: ;g��wna p�tla programu wersja 2

	SBIS PIND, PD2 ; Je�li przycisk puszczony to  pomi� nst�pny krok
	CBI PORTB, PB0 ; Zapal diod�
	SBIC PIND, PD2	; Je�li przycisk wci�ni�ty to  pomi� nst�pny krok
	SBI PORTB, PB0 ; Zga� diod�

	RJMP MAIN_LOOP_2

.exit
