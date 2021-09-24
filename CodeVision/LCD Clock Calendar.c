/*******************************************************
Project                 : LCD Clock Calendar
Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32a.h>
#include <i2c.h>
#include <ds1307.h>
#include <1wire.h>
#include <ds18b20.h>
#include <alcd.h>
#include <delay.h>
#include <math.h>
#include <stdio.h>

float Temp;
char lcd_buff[16];
unsigned char Hour, Minute, Second = 0;
eeprom unsigned char Year_century;
unsigned char Year, Month, Day, Weekday = 0;
unsigned int sYear = 0;
unsigned char sMonth, sDay = 0;
unsigned char menu_selector = 0;
flash char degreeSymbol[8] = 
{
0b000110,
0b001001,
0b001001,
0b000110,
0b000000,
0b000000,
0b000000,
0b000000
};

void time_date_functions();
int isLeapYear(int _year, int _type);
void main_loop();
void up_sw();
void menu_sw();
void down_sw();
void showMenu();
void Gregorian2Solar(int gYear, char gMonth, char gDay, unsigned int* sYear, char* sMonth, char* sDay);
void define_char(char flash *pc, char char_code);

interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    if (Second >= 0 && Second <= 58)
    {
        Second++;  
    }
    else if (Second >= 59)
    {
        Second = 0;
        Minute++;
        if (Minute > 59)
        {
            Minute = 0;
            Hour++;
            if (Hour > 23)
            {
                Hour = 0;
                Day++;
                Weekday++;
            }
        }
    }
}

void main(void)
{

DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);

DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0xD8;
OCR0=0x00;

TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=1<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2=0x00;

TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

i2c_init();

rtc_init(0,0,0);

w1_init();

lcd_init(16);
define_char(degreeSymbol, 0);
lcd_clear();

#asm("sei")

rtc_get_time(&Hour, &Minute, &Second);
rtc_get_date(&Weekday, &Day, &Month, &Year);

if (Year_century == 0) Year_century = 20;

main_loop();
   
}

void main_loop()
{
    while(1)
    {             
        time_date_functions(); 
        
        switch(PINA & 0x07)
        {
            case 1:
                up_sw();
                break;   
            case 2:
                menu_sw();
                break; 
            case 4:
                down_sw();  
                break; 
        }
        
        if (menu_selector == 0)
        {       
            Temp = ds18b20_temperature(0);   
            
            if (Second % 10 < 5)
            {
                sprintf(lcd_buff, "%.4i/%.2i/%.2i ", (Year_century * 100) + Year, Month, Day); 
            }
            else
            {
                Gregorian2Solar((Year_century * 100) + Year, Month, Day, &sYear, &sMonth, &sDay);
                sprintf(lcd_buff, "%.4i/%.2i/%.2i ", sYear, sMonth, sDay);
            }
            lcd_gotoxy(0, 0);
            lcd_puts(lcd_buff); 

            switch(Weekday)
            {
                case 1:
                    sprintf(lcd_buff, "SUN"); 
                    break;
                case 2:
                    sprintf(lcd_buff, "MON"); 
                    break;
                case 3:
                    sprintf(lcd_buff, "TUE"); 
                    break;             
                case 4:
                    sprintf(lcd_buff, "WED");   
                    break;            
                case 5:
                    sprintf(lcd_buff, "THU"); 
                    break;             
                case 6:
                    sprintf(lcd_buff, "FRI");     
                    break;        
                case 7:
                    sprintf(lcd_buff, "SAT");  
                    break;
            } 
            lcd_gotoxy(13, 0);        
            lcd_puts(lcd_buff);
            sprintf(lcd_buff, "%.2i:%.2i:%.2i %.1f", Hour, Minute, Second, Temp);   
            lcd_gotoxy(0, 1);
            lcd_puts(lcd_buff);
            lcd_putchar(0); 
            lcd_puts("C  ");
        }
        if (menu_selector > 0)
        {
            showMenu();
        }
    }    
}

void time_date_functions()
{
    if (menu_selector == 0)
    {
        if (Weekday == 0 || Weekday > 7) Weekday = 1; 
        if (Day == 0) Day = 1;
        if ((Day > 31) && (Month == 1 || Month == 3 || Month == 5 || Month == 7 || Month == 8 || Month == 10 || Month == 12))
        {
            Day = 1;
            Month++;
        }
        if ((Day > 30) && (Month == 4 || Month == 6 || Month == 9 || Month == 11))
        {
            Day = 1;
            Month++;
        } 
        if (Day > 28 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 0)
        {
            Day = 1;
            Month++;        
        }    
        if (Month == 0) Month = 1;
        if (Month > 12)
        {
            Month = 1;
            Year++;
        }
        if (Year > 99)
        {
            Year = 0;     
            Year_century++;
        }
        if (Year_century > 99)
        {
            Year = 0;     
            Year_century = 0;
        }        
    }    
}

void up_sw()
{
    switch(menu_selector)
    {
        case 1:
            if (Year_century >= 99) Year_century = 0; else Year_century++; 
            break;
        case 2:
            if (Year >= 99) Year = 0; else Year++;   
            break;
        case 3:
            if (Month >= 12) Month = 1; else Month++; 
            break;
        case 4:
            if ((Day >= 31) && (Month == 1 || Month == 3 || Month == 5 || Month == 7 || Month == 8 || Month == 10 ||Month == 12)) {Day = 1; break;}
            else if ((Day >= 30) && (Month == 4 || Month == 6 || Month == 9 || Month == 11)) {Day = 1; break;}   
            else if (Day >= 29 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 1) {Day = 1; break;}  
            else if (Day >= 28 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 0) {Day = 1; break;} 
            else {Day++; break;}   
        case 5:
            if (Hour >= 23) Hour = 0; else Hour++;  
            break;
        case 6:
            if (Minute >= 59) Minute = 0; else Minute++;  
            break;
        case 7:
            Second = 0; 
            break;
        case 8:
            if (Weekday >= 7) Weekday = 1; else Weekday++; 
            break;  
    }
    delay_ms(500);
}

void menu_sw()
{
    lcd_clear();
    if (menu_selector >= 8) 
    {
        menu_selector = 0; 
        rtc_set_time(Hour, Minute, Second);
        rtc_set_date(Weekday, Day, Month, Year);
    }
    else menu_selector++;
    delay_ms(500);
}

void down_sw()
{
    switch(menu_selector)
    {
        case 1:
            if (Year_century <= 0) Year_century = 99; else Year_century--;     
            break;
        case 2:
            if (Year <= 0) Year = 99; else Year--;     
            break;
        case 3:
            if (Month <= 1) Month = 12; else Month--;  
            break;
        case 4:
            if ((Day <= 1) && (Month == 1 || Month == 3 || Month == 5 || Month == 7 || Month == 8 || Month == 10 ||Month == 12)) {Day = 31; break;} 
            else if ((Day <= 1) && (Month == 4 || Month == 6 || Month == 9 || Month == 11)) {Day = 30; break;} 
            else if (Day <= 1 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 1) {Day = 29; break;} 
            else if (Day <= 1 && Month == 2 && isLeapYear((Year_century * 100) + Year, 1) == 0) {Day = 28; break;}
            else {Day--; break;}   
        case 5:
            if (Hour <= 0) Hour = 23; else Hour--;    
            break;
        case 6:
            if (Minute <= 0) Minute = 59; else Minute--; 
            break;
        case 7:
            Second = 0;    
            break;
        case 8:
            if (Weekday <= 1) Weekday = 7; else Weekday--;    
            break;
    }
    delay_ms(500);
}

int isLeapYear(int _year, int _type)
{
    switch(_type)
    {
        case 1:
            if (_year % 4 == 0) return 1; else return 0; 
            if ((_year % 100 == 0) && (_year % 400 == 0)) return 1; else return 0;    
            break;
        case 2:
            if (_year % 4 == 3) return 1; else return 0;       
            break;
    }
} 

void Gregorian2Solar(int gYear, char gMonth, char gDay, unsigned int* sYear, char* sMonth, char* sDay)
{
    float s, r;
    int m; 
    long sa, ss; 
    int ma, ro;    
    
    s = gYear - 1; 
    m = gMonth - 1; 
    r = (s * 365.25) + gDay;
    
    if (gYear % 4 == 0)
    {
        switch(m)
        {  
            case 1:
                r += 31; break;
            case 2:
                r += 60; break;
            case 3:
                r += 91; break;
            case 4:
                r += 121; break;
            case 5:
                r += 152; break;
            case 6:
                r += 182; break;
            case 7:
                r += 213; break;
            case 8:
                r += 244; break;
            case 9:
                r += 274; break;
            case 10:
                r += 305; break;
            case 11:
                r += 335; break;
        }
    }
    else 
    {
        switch(m)
        {  
            case 1:
                r += 31; break;
            case 2:
                r += 59; break;
            case 3:
                r += 90; break;
            case 4:
                r += 120; break;
            case 5:
                r += 151; break;
            case 6:
                r += 181; break;
            case 7:
                r += 212; break;
            case 8:
                r += 243; break;
            case 9:
                r += 273; break;
            case 10:
                r += 304; break;
            case 11:
                r += 334; break;
        }
    }
    r -= 226899;
    sa = (r / 365.25) + 1;
    ss = r / 365.25;
    r -= (ss * 365.25) + 0.25;
    if (sa % 4 == 3) r += 1;
    if (r >= 336) {ma = 12; ro = r - 336;}
    else if (r >= 306) {ma = 11; ro = r - 306;}
    else if (r >= 276) {ma = 10; ro = r - 276;}
    else if (r >= 246) {ma = 9; ro = r - 246;}
    else if (r >= 216) {ma = 8; ro = r - 216;}
    else if (r >= 186) {ma = 7; ro = r - 186;}
    else if (r >= 155) {ma = 6; ro = r - 155;}
    else if (r >= 124) {ma = 5; ro = r - 124;}
    else if (r >= 93) {ma = 4; ro = r - 93;}
    else if (r >= 62) {ma = 3; ro = r - 62;}
    else if (r >= 31) {ma = 2; ro = r - 31;}
    else if (r > 0) {ma = 1; ro = r;}
    else if (r == 0)
    {
        if (sa % 4 != 0) {sa -= 1; ma = 12; ro = 29;}
        else {sa -= 1; ma = 12; ro = 30;}      
    }
    if (ro < 1)
    {
        switch(ma)
        {
            case 1: 
                sa -= 1; ma = 12;
                if (isLeapYear(sa, 2) == 1) ro = 30; else ro = 29;
                break;
            case 2:
                ma = 1; ro = 31; break;
            case 3:
                ma = 2; ro = 31; break;
            case 4:
                ma = 3; ro = 31; break;                
            case 5:
                ma = 4; ro = 31; break;                
            case 6:
                ma = 5; ro = 31; break;        
            case 7:
                ma = 6; ro = 31; break;                
            case 8:
                ma = 7; ro = 30; break;                
            case 9:
                ma = 8; ro = 30; break;                
            case 10:
                ma = 9; ro = 30; break;                
            case 11:
                ma = 10; ro = 30; break;                
            case 12:
                ma = 11; ro = 30; break;                
        }
    } 
    *sYear = sa; *sMonth = ma; *sDay = ro;
    
}

void showMenu()
{
    switch(menu_selector)
    {
        case 1:
            lcd_gotoxy(0, 0); lcd_puts("Year Century:");     
            sprintf(lcd_buff, "%.2i", Year_century);
            lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
            break;
        case 2:
            lcd_gotoxy(0, 0); lcd_puts("Year:");
            sprintf(lcd_buff, "%.2i", Year);
            lcd_gotoxy(8, 1); lcd_puts(lcd_buff); 
            break;        
        case 3:
            lcd_gotoxy(0, 0); lcd_puts("Month:");
            sprintf(lcd_buff, "%.2i", Month);
            lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
            break;
        case 4:
            lcd_gotoxy(0, 0); lcd_puts("Day:");
            sprintf(lcd_buff, "%.2i", Day);
            lcd_gotoxy(8, 1); lcd_puts(lcd_buff);  
            break;        
        case 5:
            lcd_gotoxy(0, 0); lcd_puts("Hour:");
            sprintf(lcd_buff, "%.2i", Hour);
            lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
            break;        
        case 6:
            lcd_gotoxy(0, 0); lcd_puts("Minute:");
            sprintf(lcd_buff, "%.2i", Minute);
            lcd_gotoxy(8, 1); lcd_puts(lcd_buff); 
            break;         
        case 7:
            lcd_gotoxy(0, 0); lcd_puts("Second:");
            sprintf(lcd_buff, "%.2i", Second);
            lcd_gotoxy(8, 1); lcd_puts(lcd_buff);
            break;          
        case 8:
            lcd_gotoxy(0, 0); lcd_puts("Weekday:");
            lcd_gotoxy(0, 1);
            switch(Weekday)
            {
                case 1:
                    lcd_puts("     Sunday     "); break;
                case 2:
                    lcd_puts("     Monday     "); break;
                case 3:
                    lcd_puts("     Tuesday    "); break;
                case 4:
                    lcd_puts("    Wednesday   "); break;
                case 5:
                    lcd_puts("    Thursday    "); break;
                case 6:
                    lcd_puts("     Friday     "); break;
                case 7:
                    lcd_puts("    Saturday    "); break;
            }  
            break;
    }
}

void define_char(char flash *pc, char char_code)
{
    char i, a;
    a = (char_code << 3) | 0x40;
    for (i = 0; i < 8; i++) lcd_write_byte(a++, *pc++);
}
