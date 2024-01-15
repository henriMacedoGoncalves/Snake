# Snake

During my second year of Computer Science at the University of Strasbourg, my classmate Alexandre Ramdoo and I collaborated on a Snake game project implemented in MIPS assembly language. The project involved utilizing predefined functions provided by our teachers, with our work commencing at the `Project` section (line 461) to make the game fully functional.

Our Snake game incorporated additional features instructed by the teachers. Notably, when the snake consumes a fruit (represented by purple blocks), its speed increases. Furthermore, obstacles (depicted as red blocks) are introduced each time the snake successfully consumes a fruit.

These enhancements aimed to challenge the player.

## Installation Instructions

To install and run the Snake game on your machine, follow these steps:

### 1. Clone the repository

```
git clone https://github.com/henriMacedoGoncalves/Snake.git
```
### 2. Navigate to the project directory

```
cd Snake
```

### 3. Install Java

```
java -version
```
If Java is not installed, you can install it using your package manager. For example, on Ubuntu system, you can use:

```
sudo apt-get install default-jre
```

## Usage

### 1. Open MARS

Once the installation is complete, you can run the Snake game on the specific MIPS evironnment:

```
java -jar Mars4_5.jar
```

### 2. Choose the snake file

You have to open the file by clicking on `File` and then `Open ...`. Now choose between `snake_wasd.s` and `snake_zqsd.s` depending on your keyboard layout.

### 3. Run the file

Click on `Run` and then `Assemble`. Nowadays, you would call it `Compile`.

### 4. Setup Display and Keyboard

Click on `Tools`, then `Bitmap Display` and `Keyboard and Display MMIO Simulator`.

On the `Bitmap Display` screen, set the configuration like the following:

```
Unit Width in Pixels            16
unit Height in Pixels           16
Display Width in Pixels         256
Display Height in Pixels        256
Base address for display        0x10010000 (static data)
```

On both new opened screens, click on `Connect to MIPS`.

### 5. Enjoy!

Finally, to execute the game, click on the green Play icon, next to the tools Icon.

To start moving, click on the KEYBOARD box.

## Controls

It is important that `Caps Lock` is not activated!

For the `snake_zqsd.s` file:

- z: Move up
- s: Move down
- q: Move left
- d: Move right

For the `snake_wasd.s` file:

- w: Move up
- s: Move down
- a: Move left
- d: Move right