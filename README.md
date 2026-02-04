# ⚔️ Knight Pixel2D Game

Um jogo de plataforma 2D em Pixel Art desenvolvido na Godot Engine 4. Este projeto foi criado como parte do "Project 01 - Platformer", focando em mecânicas clássicas, sistema de save/load e implementação de múltiplos inimigos.

## 🎮 Funcionalidades

- **Sistema de Níveis:** Duas fases completas (`phase_1` e `phase_2`).
- **Inimigos Variados:** Enfrente Orcs, Esqueletos e Lobisomens.
- **Sistema de Colecionáveis:** - Moedas (Bronze, Prata, Ouro) baseadas em sistema de Recursos (`Resources`).
  - Vidas Extras.
- **Sistema de Progresso:**
  - Save & Load: Salva a posição do jogador, nível atual, moedas e vidas.
  - Checkpoints e persistência de dados.
- **Menus Completos:** Menu Principal, Pause, Game Over e Tela de Vitória.
- **Feedback Visual:** Animações de dano, morte e coleta de itens.

## 🕹️ Controles

| Ação | Tecla / Botão |
| :--- | :--- |
| **Mover Esquerda** | `A` ou `Seta Esquerda` |
| **Mover Direita** | `D` ou `Seta Direita` |
| **Pular** | `Espaço` ou `W` |
| **Pausar** | `Esc` ou 'P' |

## 🛠️ Tecnologias Utilizadas

- **Engine:** Godot 4.x
- **Linguagem:** GDScript
- **Arte:** Pixel Art (Assets de terceiros/próprios)
- **Áudio:** Efeitos sonoros e trilha sonora dinâmica.

## 📂 Estrutura do Projeto

O projeto segue uma organização limpa de pastas:
- `entites/`: Cenas do Player e Inimigos.
- `scripts/`: Lógica do jogo (Player, Enemy, GameManager, etc).
- `scenes/`: Níveis e Menus (Menu, Pause, GameOver).
- `resource/`: Recursos de itens (Gold, Silver, Life).
- `sprites/`: Assets visuais.
- `sounds/`: Músicas e efeitos sonoros.
