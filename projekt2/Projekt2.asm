/*
 * Projekt pokazowy 2
 * Przycisk distabilny + prze��czanie kolor�w
 *
 * Przycisk znajduje si� na pinie PD2
 * Dioda jest na pinie PB0, PB1 oraz PB2
 *
 * Dioda �wieci, gdy na wyjsciu jest stan niski. (dioda RGB ma wspolna anode)
 *
 * Wci�ni�ty przycisk daje warto�� 0, swobodnie daje 1.
 *
 * Created: 22-03-2016 23:46:40
 * Author: Karol
 *
 */
 
;**********************************************
;DEKLARACJE:

.INCLUDE "m8adef.inc"
.EQU F_CPU = 1000000; cz�stotliwo�� taktowania 1 MHz

; ilo�� kolor�w. Wraz z czarnym jest 8.
.EQU COLOR_NUM = 8;

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
	LDI r16, (1<<PB0)|(1<<PB1)|(1<<PB2)
	OUT DDRB, r16
	OUT PORTB, r16 ;Ustawienie kierunku i stanu pinu na wyj�cie w stanie wysokim

	CBI DDRD, PD2
	SBI PORTD, PD2 ;Ustawienie kierunku i stanu pinu na wej�cie z pull-up

	LDI r18, 0	;wyzerowanie licznika aktualnego koloru

MAIN_LOOP: ;g��wna p�tla programu

	IN r16, PIND	;pobieramy stan portu D do r16
	ANDI r16, (1<<PD2)	; usuwamy �mieci
	BRNE MAIN_LOOP	;jesli r16 != 0 (przycisk zwolniony), to wracamy na pocz�tek p�tli
	RCALL WAIT_20_MS	;wywo�ujemy funkcj� oczekiwania (debouncing)
	IN r17, PIND	;pobieramy stan portu D do r17
	ANDI r17, (1<<PD2) ; usuwamy �mieci
	CPSE r16, r17 ; por�wnujemy r16 i r17. Je�li r�wne, to pomijamy kolejn� instrukcj� 
	RJMP MAIN_LOOP ; je��i r16 i r17 nie by� r�wne, to wykona si� instrukcja skoku na pocz�tek p�tli

	INC r18	; nast�pny kolor

	MOV r19, r18	;kopiujemy r18 do r19
	COM r19	; robimy negacj� r19, bo diodami sterujemy "odwrotn� logik�" 
	ANDI r19, (1<<PB0)|(1<<PB1)|(1<<PB2) ; zerujemy co niepotrzebne
	OUT PORTB, r19	; ustawiamy stan led�w

	WAIT_FOR_RELEASE_BUTTON:	;oczekiwanie a� przycisk zostanie puszczony
	IN r16, PIND
	ANDI r16, (1<<PD2)
	BREQ WAIT_FOR_RELEASE_BUTTON
	RCALL WAIT_20_MS
	IN r17, PIND
	ANDI r17, (1<<PD2)
	CPSE r16, r17
	RJMP WAIT_FOR_RELEASE_BUTTON


	CPI r18, COLOR_NUM	;sprawdzamy, czy osi�gneli�my ostatni kolor
	BRLO MAIN_LOOP	;je�li nie, to wacamy na poczatek
	LDI r18, 0	;jesli tak, to zerujemy kolor
	RJMP MAIN_LOOP


WAIT_20_MS:
	PUSH XH	;wrzucamy na stos rejestry kt�re chcemy zachowa�
	IN XH, SREG
	PUSH XH
	PUSH XL

	LDI XH, HIGH(F_CPU*0.02/4)	;wyliczamy warto�ci licznik�w ze wzoru
	LDI XL, LOW(F_CPU*0.02/4)
	
	DELAY_LOOP:	;zmniejszanie warto�ci licznika w p�tli a� dojdzie do 0
	SBIW XL, 1
	BRNE DELAY_LOOP


	POP XL	; przywracamy warto�ci rejestr�w
	POP XH
	OUT SREG, XH
	POP XH
	RET	;powr�t

.exit
