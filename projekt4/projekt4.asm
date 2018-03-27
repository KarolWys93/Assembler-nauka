/*
 * Projekt pokazowy 4
 * Ulepszenie projektu 2 - u¿ycie licznika i przerwañ
 *
 * Przycisk znajduje siê na pinie PD2
 * Dioda jest na pinie PB0, PB1 oraz PB2
 *
 * Dioda œwieci, gdy na wyjsciu jest stan niski. (dioda RGB ma wspolna anode)
 *
 * Wciœniêty przycisk daje wartoœæ 0, swobodnie daje 1.
 *
 * Created: 26-03-2016 22:51:12
 * Author: Karol
 *
 */
 
;**********************************************
;DEKLARACJE:

.INCLUDE "m8adef.inc"
.EQU F_CPU = 1000000; czêstotliwoœæ taktowania 1 MHz

; iloœæ kolorów. Wraz z czarnym jest 8.
.EQU COLOR_NUM = 8;

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
	rjmp TIM1_COMPA ; Timer1 CompareA Handler
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
	OUT PORTB, r16 ;Ustawienie kierunku i stanu pinu na wyjœcie w stanie wysokim

	CBI DDRD, PD2
	SBI PORTD, PD2 ;Ustawienie kierunku i stanu pinu na wejœcie z pull-up

	LDI r18, 0	;wyzerowanie licznika aktualnego koloru

	;inicjalizacja licznika 1 w trybie CTC

	LDI r16, (1<<WGM12)|(1<<CS11)	;tryb ctc i preskaler 8
	OUT TCCR1B, r16

	;wa¿na rzecz! Aby praca licznika podczas zmiany rejestru OCR (i innych 16bitowych) siê nie rozjecha³a,
	;najpierw zapisujemy H potem L. Czytamy w odwrotnej kolejnoœci!
	LDI r16, HIGH((F_CPU/(1000*8))-1)	;Czêstotliwoœæ przerwañ 1000Hz
	OUT OCR1AH, r16
	LDI r16, LOW((F_CPU/(1000*8))-1)
	OUT OCR1AL, r16

	LDI r16, (1<<OCIE1A)	;w³¹czenie przerwania dla Output Compare A dla licznika 1
	OUT TIMSK, r16

	SEI ; globalne zezwolenie na przerwania

	;w³aczenie trybow oszczedzania energii
	LDI r16, (1<<SE)
	OUT MCUCR, r16

	RJMP MAIN_LOOP


TIM1_COMPA:	;Obs³uga przerwania
	PUSH r16
	IN r16, SREG
	PUSH r16

	INC r20

	POP r16
	OUT SREG, r16
	pop r16
	RETI


MAIN_LOOP: ;g³ówna pêtla programu

	SLEEP	;œpimy :)
	IN r16, PIND	;pobieramy stan portu D do r16
	ANDI r16, (1<<PD2)	; usuwamy œmieci
	BRNE MAIN_LOOP	;jesli r16 != 0 (przycisk zwolniony), to wracamy na pocz¹tek pêtli
	RCALL WAIT_20_MS	;wywo³ujemy funkcjê oczekiwania (debouncing)
	IN r17, PIND	;pobieramy stan portu D do r17
	ANDI r17, (1<<PD2) ; usuwamy œmieci
	CPSE r16, r17 ; porównujemy r16 i r17. Jeœli równe, to pomijamy kolejn¹ instrukcjê 
	RJMP MAIN_LOOP ; jeœ³i r16 i r17 nie by³ równe, to wykona siê instrukcja skoku na pocz¹tek pêtli

	INC r18	; nastêpny kolor

	MOV r19, r18	;kopiujemy r18 do r19
	COM r19	; robimy negacjê r19, bo diodami sterujemy "odwrotn¹ logik¹" 
	ANDI r19, (1<<PB0)|(1<<PB1)|(1<<PB2) ; zerujemy co niepotrzebne
	OUT PORTB, r19	; ustawiamy stan ledów

	WAIT_FOR_RELEASE_BUTTON:	;oczekiwanie a¿ przycisk zostanie puszczony
	SLEEP
	IN r16, PIND
	ANDI r16, (1<<PD2)
	BREQ WAIT_FOR_RELEASE_BUTTON
	RCALL WAIT_20_MS
	IN r17, PIND
	ANDI r17, (1<<PD2)
	CPSE r16, r17
	RJMP WAIT_FOR_RELEASE_BUTTON


	CPI r18, COLOR_NUM	;sprawdzamy, czy osi¹gneliœmy ostatni kolor
	BRLO MAIN_LOOP	;jeœli nie, to wacamy na poczatek
	LDI r18, 0	;jesli tak, to zerujemy kolor
	RJMP MAIN_LOOP


WAIT_20_MS:
	PUSH r16	;wrzucamy na stos rejestry które chcemy zachowaæ
	IN r16, SREG
	PUSH r16

	LDI r16, 20
	ADD r16, r20
	
	DELAY_LOOP:	;porownanie wartoœci licznika milisekund z wartoœci¹ zadan¹
	SLEEP	;œpij oczekuj¹c na kolejn¹ zmianê
	CP r16, r20
	BRNE DELAY_LOOP


	POP r16	; przywracamy wartoœci rejestrów
	OUT SREG, r16
	POP r16
	RET	;powrót

.exit
