/*
 * Projekt pokazowy 7
 * Naprzemienne œwiecenie diodami przy u¿yciu timera
 *
 * Dioda jest na pinie PB1 i PB2
 *
 * Dioda œwieci, gdy na wyjsciu jest stan niski. (dioda RGB ma wspolna anode)
 *
 * Created: 27-03-2016 02:30:22
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
	

	;ustawienia diod
	LDI r16, (1<<PB0)|(1<<PB1)|(1<<PB2)
	OUT DDRB, r16
	;LDI r16, (1<<PB1)
	OUT PORTB, r16 ;Ustawienie kierunku i stanu pinu na wyjœcie w stanie wysokim


	;Ustawienie licznika 1 w trybie CTC z obs³ug¹ pinów wyjœciowych

	LDI r16, (1<<COM1A0)|(1<<COM1B0)|(1<<FOC1A)	;Naprzemienne prze³¹czanie A i B.
	OUT TCCR1A, r16

	LDI r16, (1<<WGM12)|(1<<CS11)	;tryb ctc i preskaler 8
	OUT TCCR1B, r16

	LDI r16, (1<<COM1A0)|(1<<COM1B0)|(1<<FOC1A)	;Naprzemienne prze³¹czanie A i B.
	OUT TCCR1A, r16


	;wa¿na rzecz! Aby praca licznika podczas zmiany rejestru OCR (i innych 16bitowych) siê nie rozjecha³a,
	;najpierw zapisujemy H potem L. Czytamy w odwrotnej kolejnoœci!
	LDI r16, HIGH((F_CPU/(2*8))-1)	;Czêstotliwoœæ przerwañ 2Hz
	OUT OCR1AH, r16
	LDI r16, LOW((F_CPU/(2*8))-1)
	OUT OCR1AL, r16

	;w³aczenie trybow oszczedzania energii
	LDI r16, (1<<SE)
	OUT MCUCR, r16

	RJMP MAIN_LOOP

MAIN_LOOP: ;g³ówna pêtla programu

	SLEEP
	CBI PORTB, PB0	;To nigdy siê nie wykona. Udowadniam tylko, ¿e uC pozostaje w uœpieniu przez ca³y czas.
	RJMP MAIN_LOOP
