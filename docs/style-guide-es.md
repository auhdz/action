# Acción — Guía de Estilo de Marca (Español)

---

## Colores de Marca

| Nombre | Hex | Uso |
|--------|-----|-----|
| **ROJO ACCIÓN** | `#8E2A0B` | Color principal de marca — botón SOS, CTAs, acentos |
| **NARANJA SEGURO** | `#F39A1E` | Estados pendientes/advertencia, acentos secundarios |
| **AMARILLO CONFIANZA** | `#FFD166` | Destacados, pines del mapa en el futuro |
| **AZUL MARINO CONFIANZA** | `#0D1B2A` | Tarjetas de estado, encabezados, fondos oscuros |
| **CREMA SEGURA** | `#F7F3ED` | Fondo de la app — cálido y tranquilo, no clínico |

### Principios de Color

- El ROJO ACCIÓN se reserva para momentos de alta señal: el botón SOS, estados de alerta, el botón "Tus Derechos" y CTAs principales. No lo diluyas.
- CREMA SEGURA reemplaza el blanco puro como fondo predeterminado. Transmite calma, no emergencia.
- AZUL MARINO sobre CREMA SEGURA ofrece contraste suficiente (cumple WCAG AA).
- Nunca uses negro puro (`#000000`) ni blanco puro (`#FFFFFF`) como superficies de marca.

---

## Tipografía

**Principal:** Satoshi (en desarrollo — se agregará como fuente integrada)

**Alternativa (app actual):** SF Pro (sistema iOS por defecto)

### Escala Tipográfica

| Rol | Tamaño | Peso |
|-----|--------|------|
| Título de la app | 30pt | Semibold |
| Encabezado de sección | 24–28pt | Bold |
| Encabezado de tarjeta | 16pt | Semibold |
| Cuerpo | 14–16pt | Regular |
| Pie / texto legal | 12–13pt | Regular |
| Botón | 16pt | Semibold |

---

## Componentes de UI

### Botones

**CTA Principal (ej. Continuar, Acepto)**
- Fondo: ROJO ACCIÓN
- Texto: Blanco, 16pt Semibold
- Alto: 56pt
- Radio de esquina: 12pt
- Ancho completo

**CTA Secundario (ej. Más tarde)**
- Fondo: ROJO ACCIÓN al 10% de opacidad
- Texto: ROJO ACCIÓN, 16pt Semibold
- Mismas dimensiones que el principal

**Destructivo / SOS**
- Fondo: ROJO ACCIÓN
- Etiqueta en mayúsculas
- Gesto de mantener presionado para el disparador principal de SOS

### Tarjetas

**Tarjeta de estado oscura (Estás protegido)**
- Fondo: AZUL MARINO CONFIANZA
- Texto: Blanco y blanco al 60% de opacidad
- Radio de esquina: 14pt
- Relleno: 16pt

**Tarjeta de información clara (Tus Derechos)**
- Fondo: Blanco
- Borde: Negro al 7% de opacidad, trazo de 1pt
- Radio de esquina: 14pt
- Relleno: 16pt

### Indicadores de Estado

| Estado | Color |
|--------|-------|
| Activo / OK | Verde (sistema) |
| Advertencia / Pendiente | NARANJA SEGURO |
| Error / Alerta enviada | ROJO ACCIÓN |
| Desconocido | Gris (sistema) |

---

## Voz y Tono

**Calmado y directo.** Esta app se usa en momentos de estrés. Cada palabra debe reducir la ansiedad, no aumentarla.

- Di: "Estás protegido" — no "No se detectaron incidentes"
- Di: "Mantén 3s para alertar a tus contactos" — no "Activar protocolo SOS"
- Di: "Cancelar alerta" — no "Abortar"

**Bilingüe de origen.** Cada cadena de texto visible al usuario existe tanto en inglés como en español. El español no es una traducción — es igualmente primario.

**Sin lenguaje de vigilancia.** Nunca uses en ninguna cadena visible al usuario: ICE, enforcement, agentes, retén, ilegal, indocumentado.

---

## Logo y Nombre de Marca

**Nombre de la app:** Acción (siempre con acento en la ó)

- Nunca escribas "Accion" sin el acento
- La palabra es el logo por ahora — aún no hay marca gráfica separada
- Sobre fondos oscuros: nombre en blanco
- Sobre fondos claros: nombre en AZUL MARINO CONFIANZA

---

## Espaciado

Unidad base: **8pt**

- Relleno interno de componentes: 12–16pt
- Espacio entre secciones: 12–14pt
- Relleno del borde de pantalla: 24pt
- Relleno inferior del botón: 24–32pt

---

## Qué No Hacer

- No uses blanco puro como fondo de la app — usa CREMA SEGURA
- No uses ROJO ACCIÓN para elementos decorativos — resérvalo para momentos de señal
- No uses azul en ningún lugar — era la marca anterior, ya reemplazada
- No mezcles tonos: si una tarjeta usa AZUL MARINO, su texto es blanco, no azul marino
- No omitas el acento: Acción, no Accion
