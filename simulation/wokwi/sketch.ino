#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// Extractor de aguamiel: D5 -> R1 (1 kohm) -> 2N2222 -> bobina del rele
// En Wokwi el modulo rele actua como sustituto DIGITAL de la etapa discreta.
// En el montaje REAL: rele de bobina desnuda 5V y diodo 1N4004 en antiparalelo.
const uint8_t PIN_STOP = 3;
const uint8_t PIN_START = 4;
const uint8_t PIN_RELE = 5; // Activo alto: HIGH = encender bomba
const uint8_t PIN_GREEN = 6;
const uint8_t PIN_RED = 7;

const float Q_L_MIN = 5.0f;
const float LIMITE_L = 10.0f;
const unsigned long DEBOUNCE_MS = 35;
const unsigned long LCD_INTERVAL_MS = 200;
LiquidCrystal_I2C lcd(0x27, 16, 2);

enum Estado { STANDBY, EXTRACTION, FULL_STOP };
Estado estado = STANDBY;
unsigned long ultimoTiempo = 0;
unsigned long ultimaPantalla = 0;
float litrosEstimados = 0.0f;

struct Boton {
  uint8_t pin;
  bool estable;
  bool previo;
  unsigned long cambio;
  Boton(uint8_t numeroPin) : pin(numeroPin), estable(HIGH), previo(HIGH), cambio(0) {}
};
Boton start(PIN_START);
Boton stop(PIN_STOP);

bool pulsacion(Boton &b, unsigned long ahora) {
  bool lectura = digitalRead(b.pin);
  if (lectura != b.previo) b.cambio = ahora;
  b.previo = lectura;
  if (ahora - b.cambio >= DEBOUNCE_MS && lectura != b.estable) {
    b.estable = lectura;
    return b.estable == LOW;
  }
  return false;
}

void actualizarSalidas() {
  bool activo = (estado == EXTRACTION);
  digitalWrite(PIN_RELE, activo ? HIGH : LOW);
  digitalWrite(PIN_GREEN, activo ? HIGH : LOW);
  digitalWrite(PIN_RED, activo ? LOW : HIGH);
}

void mostrarLCD() {
  lcd.setCursor(0, 0);
  if (estado == STANDBY) lcd.print("AGUAMIEL READY  ");
  else if (estado == EXTRACTION) lcd.print("EXTRACTING      ");
  else lcd.print("FULL / STOP     ");
  lcd.setCursor(0, 1);
  if (estado == FULL_STOP) lcd.print("REPLACE + START ");
  else {
    char texto[17];
    char volumen[8];
    dtostrf(litrosEstimados, 5, 2, volumen);
    snprintf(texto, sizeof(texto), "EST %s/10.00L", volumen);
    lcd.print(texto);
    int len = strlen(texto);
    while (len++ < 16) lcd.print(' ');
  }
}

void setup() {
  // Fail-safe: el control de bomba arranca en LOW
  digitalWrite(PIN_RELE, LOW);
  pinMode(PIN_RELE, OUTPUT);
  pinMode(PIN_GREEN, OUTPUT);
  pinMode(PIN_RED, OUTPUT);
  pinMode(PIN_START, INPUT_PULLUP);
  pinMode(PIN_STOP, INPUT_PULLUP);
  Serial.begin(115200);
  lcd.init(); lcd.backlight();
  ultimoTiempo = millis();
  actualizarSalidas();
  mostrarLCD();
  Serial.println(F("Extractor listo. START = D4; STOP = D3; transistor = D5"));
}

void loop() {
  unsigned long ahora = millis();
  bool startPulsado = pulsacion(start, ahora);
  bool stopPulsado = pulsacion(stop, ahora);
  bool stopPresionado = digitalRead(PIN_STOP) == LOW;

  // STOP domina START, incluso si ambos botones se pulsan simultaneamente
  if (stopPresionado || stopPulsado) {
    estado = STANDBY;
    litrosEstimados = 0.0f;
  } else if (startPulsado && estado != EXTRACTION) {
    litrosEstimados = 0.0f;
    estado = EXTRACTION;
  }

  unsigned long dt = ahora - ultimoTiempo;
  ultimoTiempo = ahora;
  if (estado == EXTRACTION) {
    litrosEstimados += Q_L_MIN * (dt / 60000.0f);
    if (litrosEstimados >= LIMITE_L) {
      litrosEstimados = LIMITE_L;
      estado = FULL_STOP;
      Serial.println(F("10 L estimados: bomba desactivada"));
    }
  }
  actualizarSalidas();
  if (ahora - ultimaPantalla >= LCD_INTERVAL_MS) {
    ultimaPantalla = ahora;
    mostrarLCD();
  }
}
