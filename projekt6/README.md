# Projekt 6
W tym projekcie wykorzystaliśmy ADC wraz z licznikiem w trybie PWM. Wykorzystując potencjometr ustawiamy poziom wypełnienia sygnału PWM generowanego przez licznik. Sygnał ten steruje jasnością diody LED. Całość programu działa w przerwaniu ADC, natomiast pętla główna służy jedynie do wprowadzenia mikrokontrolera w tryb uśpienia.
## Sprzęt
Program jest napisany na mikrokontroler ATMega8A. Na potrzeby pierwszych kilku projektów został stworzony niewielki układ prototypowy, w skład którego, oprócz wspomnianego mikrokontrolera, wchodzą: przycisk, dioda RGB oraz potencjometr montażowy. Poniżej schemat układu:

![Schemat układu testowego](../schematy/schemat1.png)