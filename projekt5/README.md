# Projekt 5
Projekt 5 jest ulepszoną wersją projektu 3. W programie używane jest przerwanie od ADC (przetwornika analogowo-cyfrowego), w którym znajduje się właściwie cała logika przełączania kolorów między zakresami. Dzięki temu główna pętla programu jest praktycznie pusta. Jedynym wykonywanym w niej rozkazem jest rozkaz uśpienia. Tak napisany program powinien cechować się małym poborem energii.
## Sprzęt
Program jest napisany na mikrokontroler ATMega8A. Na potrzeby pierwszych kilku projektów został stworzony niewielki układ prototypowy, w skład którego, oprócz wspomnianego mikrokontrolera, wchodzą: przycisk, dioda RGB oraz potencjometr montażowy. Poniżej schemat układu:

![Schemat układu testowego](../schematy/schemat1.png)