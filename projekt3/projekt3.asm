/*
 * Projekt pokazowy 3
 * Przetwornik ADC + zakresy kolor�w. Bez przerwa�
 *
 * Potencjometr jest na pinie PC5
 * Dioda jest na pinie PB0, PB1
 *
 * Dioda �wieci, gdy na wyjsciu jest stan niski. (dioda RGB ma wspolna anode)
 *
 * Created: 23-03-2016 02:17:24
 * Author: Karol
 *
 */
 
;**********************************************
;DEKLARACJE:

.INCLUDE "m8adef.inc"
.EQU F_CPU = 1000000; cz�stotliwo�� taktowania 1 MHz

; Zakresy kolor�w. Niski od 0, sredni od 1/3 zakresu, wysoki od 2/3 zakresu
.EQU COLOR_LOW = 0
.EQU COLOR_MID = (255 / 3)
.EQU COLOR_HIGH = ((255 / 3)*2)



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
	

	;ustawienia diod
	LDI r16, (1<<PB0)|(1<<PB1)
	OUT DDRB, r16
	OUT PORTB, r16 ;Ustawienie kierunku i stanu pinu na wyj�cie w stanie wysokim

	CBI DDRC, PC5
	CBI PORTC, PC5 ;Ustawienie kierunku i stanu pinu na wej�cie p�ywaj�ce

	;Ustawienia ADC

	LDI r16, (1<<REFS0)|(1<<ADLAR)|(1<<MUX2)|(1<<MUX0); zewn�trzna vref, wyr�wnanie do lewej, ADC5
	OUT ADMUX, r16;

	LDI r16, (1<<ADEN)|(1<<ADPS2); w�aczenie ADC, preskaler 16
	OUT ADCSRA, r16;



MAIN_LOOP: ;g��wna p�tla programu

	SBI ADCSRA, ADSC	;start konwersji
	WAIT_FOR_CONVERSION:
	SBIS ADCSRA, ADIF	;je�li flaga ko�ca konwersji si� zapali, to pomijamy skok
	RJMP WAIT_FOR_CONVERSION
	SBI ADCSRA, ADIF	;gasimy flag� ko�ca konwersji (gasimy przez wpisanie logicznej jedynki!!)
	IN r16, ADCH	; przepisujemy ADCH do r16 (mamy wyr�wnanie do lewej)

	LDI r17, (1<<PB0)
	CPI r16, COLOR_HIGH
	BRSH SET_COLOR
	
	LDI r17, (1<<PB0)|(1<<PB1)
	CPI r16, COLOR_MID
	BRSH SET_COLOR

	
	LDI r17, (1<<PB1)
	SET_COLOR:
	COM r17
	ANDI r17, (1<<PB0)|(1<<PB1)
	OUT PORTB, r17

	RJMP MAIN_LOOP
	

.exit
