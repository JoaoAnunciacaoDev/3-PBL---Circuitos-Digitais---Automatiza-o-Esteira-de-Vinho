# 3-PBL---Circuitos-Digitais---Automatização de Esteira de Vinho (FPGA)

Projeto desenvolvido no âmbito da disciplina **TEC498 – Circuitos Digitais** da **Universidade Estadual de Feira de Santana (UEFS)** no semestre 2025.2.

## 📝 Sobre o Projeto
A solução proposta consiste na implementação de um circuito digital capaz de coordenar sequencialmente as etapas de um processo industrial (engarrafamento). O sistema utiliza o kit de desenvolvimento **FPGA DE10-Lite** para validação física e lógica.

## ⚙️ Arquitetura e Lógica
A lógica de controle foi modelada em **Verilog**, combinando abordagens estrutural e comportamental. O núcleo do sistema baseia-se em **Máquinas de Estados Finitos (FSM)** para gerenciar transições operacionais críticas, como:
* Enchimento da garrafa;
* Vedação (rolha);
* Controle de qualidade e Descarte.

O sistema simula o ambiente industrial mapeando sensores e atuadores para os periféricos da placa (chaves, botões, LEDs e displays de 7 segmentos), permitindo interação em tempo real.

## 🖥️ Interface Gráfica (VGA)
Um dos diferenciais do projeto é a implementação de um controlador de vídeo VGA.
* **Feedback Visual:** Diferente da limitação dos LEDs, a saída VGA oferece uma representação gráfica animada do processo.
* **Eficiência:** A renderização foi otimizada para fornecer feedback instantâneo do estado atual da esteira, tornando o monitoramento mais intuitivo para o operador.
