# **Project 01 - 2D Pixel Platformer**

## **Sobre o Projeto**

Este é um jogo de plataforma 2D com estética Pixel Art, desenvolvido como o primeiro projeto prático de aprendizado em Godot. O objetivo é criar uma experiência clássica de plataforma com foco em mecânicas de precisão e exploração.

---

## **Funcionalidades Principais**

* **Jogabilidade:** Dois níveis completos com aproximadamente 3 minutos de gameplay total.


* **Desafio:** Sistema de morte instantânea ao sofrer dano.


* **Inimigos:** Três tipos diferentes de inimigos, cada um possuindo uma habilidade única.


* **Sistema de Itens:** Coletáveis (Moedas e Vidas Extras) implementados através de *Resources* no Godot.


* **Progressão:** Sistema de pontuação que contabiliza moedas e vidas extras.


* **Combate:** Derrotar inimigos concede 5 pontos ao jogador.



---

## **Sistemas Técnicos**

### **Menus e Interface**

* **Menu Principal:** Opções para iniciar um "Novo Jogo", "Continuar" do último salvamento ou "Sair".


* 
**Menu In-Game (Pausa):** Funções para Retomar, Reiniciar, Salvar, Carregar e Sair.


* **Game Over/Vitória:** Menu final exibindo a pontuação total com opções de reiniciar o nível ou fechar o jogo.



### **Sistema de Save & Load**

* O jogo permite salvar o progresso atual, incluindo a posição do jogador, o nível em que se encontra, a quantidade de moedas e as vidas extras.


* Ao carregar, o nível é reiniciado, mas o jogador ressurge na posição exata em que salvou, mantendo todos os seus status.



---

## **Desenvolvimento e Padrões**

* **Motor Gráfico:** Godot Engine.


* **Estilo de Código:** Segue estritamente o guia de estilo oficial do GDScript para nomenclatura e ordem de código.


* **Versionamento:** O progresso é registrado via GitHub com commits diários.


* **Assets:** Utilização de artes e sons gratuitos de fontes como Itch.io e Freesound.


* **Feedback Visual:** O personagem pisca por 1 segundo ao perder uma vida extra para indicar invulnerabilidade ou dano.
