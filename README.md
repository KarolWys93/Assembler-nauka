# Nauka assemblera
W repozytorium znajdują się przykładowe programy napisane w assemblerze na mikrokontrolery z rdzeniem AVR. Materiały te są uzupełnieniem do moich wykładów/korepetycji, czy jakkolwiek to nazwać :)

## Poruszone zagadnienia
Do tej pory poruszone zostały zagadnienia:

* Przestrzenie adresowe w mikrokontrolerach AVR
* Instrukcje assemblera
* Działanie portów IO w uC AVR
* Zagadnienie stosu i sterty oraz wywoływanie funkcji
* Podstawy działania przetwornika analogowo-cyfrowego (ADC)
* Podstawy działania liczników i ich tryby (Normal, CTC, PWM)
* Obsługa przerwań
* Sposoby oszczędzania energii

## Projekty
Poniżej przedstawiam listę programów. Każdy z nich postarałem się okrasić komentarzami, które powinny pomóc w zrozumieniu działania.

* projekt1 - Świecenie diodą po naciśnięciu przycisku
* projekt2 - Zmiana kolorów diody RGB po naciśnięciu przycisku (debouncing oraz opóźnienia programowe)
* projekt3 - Zmiana koloru diody RGB w zależności od nastawy potencjometru (przedziały kolorów)
* projekt4 - Projekt2 rozszerzony o wykorzystanie licznika, przerwań i trybów uśpienia
* projekt5 - Rozszerzona wersja projektu 3 o przerwania i oszczędzanie energii
* projekt6 - Płynna zmiana koloru świecenia diody przy pomocy potencjometru. (ADC + PWM + przerwania)
* projekt7 - Całkowicie sprzętowe naprzemienne sterowanie diodami.
