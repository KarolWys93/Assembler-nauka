/*
 * Projekt pokazowy 1
 * Przycisk monostabilny + dioda
 *
 * Przycisk znajduje siê na pinie PD2
 * Dioda jest na pinie PB0, PB1 oraz PB2
 * W przyk³adzie u¿ywana bêdzie tylko dioda z PB0
 * Pozosta³e bêd¹ jako HiZ.
 * Dioda œwieci, gdy na wyjsciu jest stan niski. (dioda RGB ma wspolna anode)
 *
 * Wciœniêty przycisk daje wartoœæ 0, swobodnie daje 1.
 *
 * Created: 22-03-2016 22:41:01
 * Author: Karol
 *
 */
 
;**********************************************
;DEKLARACJE:

.INCLUDE "m8adef.inc"
.EQU F_CPU = 1000000; czêstotliwoœæ taktowania 1 MHz

;********************************************
;TABLICA WEKTORÓW PRZERWAÑ, odkomentowaæ potrzebne

.CSEG	;do pamiêci programu
.ORG 0x00	;ustawienie pocz¹tku pamiêci
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

;koniec tablicy wektorów przerwañ
.ORG 0x13 ; kod tego miejsca zaczyna siê program
;//////////////////////////////////////////////


;**********************************************
;Program g³ówny


RESET:		;inicjalizacja mikrokontrolra
	LDI r17, HIGH(RAMEND);
	LDI r16, LOW(RAMEND);
	OUT SPH, r17;
	OUT SPL, r16;	ustalenie wskaŸnika stosu
	
	SBI DDRB, PB0
	SBI PORTB, PB0 ;Ustawienie kierunku i stanu pinu na wyjœcie w stanie wysokim

	CBI DDRD, PD2
	SBI PORTD, PD2 ;Ustawienie kierunku i stanu pinu na wejœcie z pull-up

    RJMP MAIN_LOOP_1	;wersja 1
	;RJMP MAIN_LOOP_2	;wersja 2

MAIN_LOOP_1: ;g³ówna pêtla programu wersja 1

	IN r16, PIND ;Pobranie stanu portu D
	ANDI r16, (1<<PD2)

	BRNE LED_OFF
	CBI PORTB, PB0 ; Jeœli r16 == 0 (przycisk wciœniêty) to zapal diodê
	RJMP MAIN_LOOP_1

	LED_OFF:
	SBI PORTB, PB0 ; Jeœli r16 > 0 (przycisk puszczony) to zgaœ diodê

	RJMP MAIN_LOOP_1


MAIN_LOOP_2: ;g³ówna pêtla programu wersja 2

	SBIS PIND, PD2 ; Jeœli przycisk puszczony to  pomiñ nstêpny krok
	CBI PORTB, PB0 ; Zapal diodê
	SBIC PIND, PD2	; Jeœli przycisk wciœniêty to  pomiñ nstêpny krok
	SBI PORTB, PB0 ; Zgaœ diodê

	RJMP MAIN_LOOP_2

.exit
