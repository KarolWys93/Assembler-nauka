/*
 * Projekt pokazowy 6
 * Przetwornik ADC + p³ynna zmiana koloru - PWM.
 *
 * Potencjometr jest na pinie PC5
 * Dioda jest na pinie PB1
 *
 * Dioda œwieci, gdy na wyjsciu jest stan niski. (dioda RGB ma wspolna anode)
 *
 * Created: 27-03-2016 01:55:12
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
	rjmp ADC_INT ; ADC Conversion Complete Handler
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
	

	;ustawienia diod
	LDI r16, (1<<PB1)
	OUT DDRB, r16
	OUT PORTB, r16 ;Ustawienie kierunku i stanu pinu na wyjœcie w stanie wysokim

	CBI DDRC, PC5
	CBI PORTC, PC5 ;Ustawienie kierunku i stanu pinu na wejœcie p³ywaj¹ce

	;Ustawienia ADC

	LDI r16, (1<<REFS0)|(1<<ADLAR)|(1<<MUX2)|(1<<MUX0); zewnêtrzna vref, wyrównanie do lewej, ADC5
	OUT ADMUX, r16;

	LDI r16, (1<<ADEN)|(1<<ADFR)|(1<<ADIE)|(1<<ADPS2); w³aczenie ADC, free runing, przerwania, preskaler 16
	OUT ADCSRA, r16;

	;Ustawienie licznika 1 w trybie PWM 8 bitowym
	LDI r16, (1<<COM1A1)|(1<<COM1A0)|(1<<WGM10)	;inverting mode, Fast PWM 8 Bit
	OUT TCCR1A, r16

	LDI r16, (1<<WGM12)|(1<<CS10)	;Fast PWM 8 Bit, preskaler 1
	OUT TCCR1B, r16

	LDI r16, 0
	OUT OCR1AH, r16
	OUT OCR1AL, r16


	SEI ; globalne zezwolenie na przerwania


	;w³aczenie trybow oszczedzania energii
	LDI r16, (1<<SE)
	OUT MCUCR, r16

	RJMP MAIN_LOOP

ADC_INT:	; obsluga przerwania
	IN r16, ADCH	; przepisujemy ADCH do r16 (mamy wyrównanie do lewej)
	CPI r16, 1

	BRSH LED_ON
	LDI r17, (1<<WGM10)
	OUT TCCR1A, r17
	SBI PORTB, PB1
	RJMP NEXT

	LED_ON:
	LDI r17, (1<<COM1A1)|(1<<COM1A0)|(1<<WGM10)
	OUT TCCR1A, r17
	NEXT:

	OUT OCR1AL, r16
	RETI

MAIN_LOOP: ;g³ówna pêtla programu

	SLEEP
	RJMP MAIN_LOOP
	
.exit
