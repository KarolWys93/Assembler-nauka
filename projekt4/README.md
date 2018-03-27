# Projekt 4
Wynik działania programu z projektu 4 jest taki sam jak projektu 2. Różnica polega na tym, że w programie użyliśmy licznika generującego przerwania co 1ms oraz unikamy aktywnych oczekiwań poprzez uśpienie mikrokontrolera. Dzięki temu program jest bardziej "energooszczędny".
## Sprzęt
Program jest napisany na mikrokontroler ATMega8A. Na potrzeby pierwszych kilku projektów został stworzony niewielki układ prototypowy, w skład którego, oprócz wspomnianego mikrokontrolera, wchodzą: przycisk, dioda RGB oraz potencjometr montażowy. Poniżej schemat układu:

![Schemat układu testowego](../schematy/schemat1.png)