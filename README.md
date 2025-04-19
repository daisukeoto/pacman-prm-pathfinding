# Pacman PRM Pathfinding Visualizer

This project implements a Pacman-like character navigating through a 2D environment using **Probabilistic Roadmap (PRM)** and **Breadth-First Search (BFS)** for pathfinding. It's built using the **Processing** framework.

## 🎮 Features

- Interactive start (`s`) and goal (`g`) setting via mouse
- Randomly placed wall obstacles
- PRM construction with 247 nodes avoiding obstacles
- Graph-based BFS pathfinding between nodes
- Pacman moves along the path in real time
- Adjustable speed (`d` to double, `h` to halve)

## 🧠 Algorithms Used

- **PRM (Probabilistic Roadmap)** for roadmap graph generation
- **BFS (Breadth-First Search)** for shortest path finding
- **Ray-box collision detection** to validate edges
- Vec2 class for vector math

## 📦 Folder Structure

pacman-prm-pathfinding/ ├── pacman-prm.pde # Main sketch file ├── images/ │ ├── pacman2.png # Pacman image │ └── ghost2.png # Ghost image

markdown
コピーする
編集する

> Note: You can break `Vec2`, utilities, or collision code into `.pde` files, and Processing will treat them as one sketch.

## 🚀 Getting Started

### 1. Install Processing

Download from: https://processing.org/download/

### 2. Run

1. Open `pacman-prm.pde` in the Processing IDE.
2. Make sure `pacman2.png` and `ghost2.png` are in an `images/` folder inside the sketch folder.
3. Press the ▶️ (Run) button.

### 3. Controls

- `s`: Set start position (click the canvas first)
- `g`: Set goal position
- `d`: Double the Pacman speed
- `h`: Halve the Pacman speed

## 🖼️ Screenshots

> _You can add some screenshots of the grid, nodes, or animated Pacman here._

## 🛠️ Todo

- Add A* pathfinding as an alternative
- Add dynamic obstacles
- Visualize the PRM graph and BFS path
- Score or time-based gameplay

## 📜 License

MIT License
