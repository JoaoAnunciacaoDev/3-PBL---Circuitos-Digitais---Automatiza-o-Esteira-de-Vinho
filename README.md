# 3-PBL---Circuitos-Digitais---Automatizacao-Esteira-de-Vinho

Projeto desenvolvido no âmbito da disciplina TEC498 – Circuitos Digitais, da Universidade Estadual de Feira de Santana (UEFS). A solução proposta consiste na implementação de um circuito digital capaz de coordenar sequencialmente as etapas de um processo industrial de engarrafamento de vinho. Para a validação física e lógica do sistema, utilizou-se o kit de desenvolvimento FPGA DE10-Lite.

A lógica de controle foi modelada utilizando a linguagem de descrição de hardware Verilog com abordagens estrutural e comportamental, fundamentando-se no conceito de Máquinas de Estados Finitos (FSM) para gerenciar as transições entre os estados de operação (como enchimento, vedação e descarte). O sistema simula o ambiente real mapeando sensores, atuadores e feedbacks visuais para os periféricos da placa, através de chaves, botões, LEDs e displays de 7 segmentos, permitindo a visualização e interação com o processo em tempo real.

No que tange à interface visual, a estratégia de renderização via VGA demonstrou-se altamente eficiente. Foi desenvolvida uma interface gráfica funcional que oferece um feedback visual mais rico e intuitivo do que apenas os LEDs da placa, permitindo acompanhar o status da esteira diretamente no monitor.
