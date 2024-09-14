; ---------------------------------------------------------
; Programa: Calculo de la raíz cuadrada de un número en BCD
; Autor: González Orihuela Luis Ángel
; ITSE - Ingeniería en Telecomunicaciones, Sistemas y Electrónica
; Fecha: 13 de Septiembre de 2024
; ---------------------------------------------------------

        ORG 0000h         ; Comienzo del código en la dirección 0

        ; Cargar el número en BCD desde el registro B al acumulador
        LD A, B           
        
        ; Conversión de BCD a binario
        LD C, A           ; Guardar el valor de BCD en C
        AND 0Fh           ; Obtener las unidades
        LD E, A           ; Guardar las unidades en E
        LD A, C           ; Cargar nuevamente el valor original en A
        SRL A             ; Desplazar 4 bits a la derecha
        SRL A             ; Mover el valor a la derecha 2 veces
        SRL A             ; (equivalente a dividir entre 16)
        SRL A
        ADD A, A          ; Multiplicar por 10 (decenas * 10)
        ADD A, A
        ADD A, A
        ADD A, A
        ADD A, A
        ADD A, E          ; Sumar las unidades al resultado
        LD B, A           ; Ahora B contiene el valor en binario

        ; Calcular la raíz cuadrada de B
        XOR A             ; Inicializar el acumulador en 0
        LD C, A           ; Inicializar el registro C (posible raíz cuadrada)
        
CALC_RAIZ:
        INC C             ; Incrementar la raíz candidata
        LD A, C           ; Cargar C en A
        LD E, A           ; Guardar el valor en E para evitar alteraciones

        ; Multiplicar A * A usando sumas repetitivas
        LD A, C           ; Cargar el valor de C en A
        LD D, C           ; Guardar el valor de C en D
        XOR A             ; Inicializar A en 0
MULTIPLY:
        ADD A, D          ; Sumar D (C) a A
        DEC C             ; Decrementar C
        JR NZ, MULTIPLY   ; Repetir hasta que C sea 0

        CP B              ; Comparar A (C^2) con el valor original
        JR C, CALC_RAIZ   ; Si el cuadrado es menor que el número, continuar

        DEC C             ; Decrementar C porque la última comparación falló

        ; Conversión de binario a BCD (el resultado de la raíz está en C)
        LD A, C           ; Cargar el valor de la raíz en A
        LD H, 0           ; Inicializar H en 0
        LD L, A           ; Guardar el valor en L

        LD D, 0           ; Iniciar el contador para decenas
        LD E, 0           ; Iniciar el contador para unidades

CONV_BIN_TO_BCD:
        CP 10             ; Comparar si el valor en A es mayor o igual a 10
        JR C, FIN_CONV    ; Si es menor que 10, pasar al siguiente paso
        SUB 10            ; Restar 10 para extraer la decena
        INC D             ; Incrementar el contador de decenas
        JR CONV_BIN_TO_BCD; Repetir el proceso hasta que A < 10

FIN_CONV:
        LD E, A           ; Guardar las unidades restantes en E
        LD A, D           ; Cargar las decenas en A
        SLA A             ; Desplazar a la izquierda 4 veces para formar el BCD
        SLA A
        SLA A
        SLA A
        OR E              ; Combinar con las unidades para obtener el BCD completo
        LD C, A           ; Guardar el resultado final en C

        RET               ; Finalizar el programa
      