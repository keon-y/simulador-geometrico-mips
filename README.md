# Simulador Geométrico MIPS.

Este projeto em Assembly MIPS realiza a leitura de um arquivo de texto, extrai as coordenadas e cores, e desenha polígonos baseados nas informações fornecidas.

## Requisitos

- Simulador MIPS compatível (como [MARS](http://courses.missouristate.edu/KenVollmar/mars/)).
- Arquivo de entrada com formato compatível (linhas contendo coordenadas e valores RGB).

## Instruções para Execução

1. Certifique-se de que o simulador MIPS está instalado em sua máquina.
2. Coloque o caminho do arquivo no código e ajuste o offset de bits nas variáveis necessárias.
3. Conecte o Bitmap Display do Mars com o programa.
4. Execute o programa e observe os resultados no display ou nas variáveis simuladas.

## Estrutura do Arquivo de Entrada

O arquivo de entrada deve conter as coordenadas e cores para os polígonos em linhas separadas. Por exemplo:

```255, 0, 0, 10, 10, 20, 20 0, 255, 0, 30, 30, 40, 40```

- Os três primeiros valores representam a cor RGB.
- Os demais valores são pares de coordenadas (X, Y).
