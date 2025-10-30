### 📚 Table of Contents
- [📄 File: main.lua](#📄-file-mainlua)
- [📄 File: conf.lua](#📄-file-conflua)
- [📄 File: blocks.lua](#📄-file-blockslua)
- [📄 File: grid.lua](#📄-file-gridlua)
- [📄 File: menu.lua](#📄-file-menulua)
- [📄 File: music.lua](#📄-file-musiclua)

# File Descriptions 

 ## 📄 File: main.lua

  ### 🎯 Purpose 
    -- Handles the main game loop and sets up the initial state of the game.

  ### 🔧 Global Variables
    | ---------- | ------- | ------------------------------------------------------ |
    | Variable   | Type    | Description                                            |
    | ---------- | ------- | ------------------------------------------------------ |
    | `START`    | boolean | Indicates if the game is currently in progress         |
    | `GameOver` | boolean | Indicates if the previous game session ended in a loss |
    | `PAUSE`    | boolean | `true` when the game is paused                         |
    | `PARAM`    | boolean | `true` when the settings menu is open                  |
    | `LEVELS`   | boolean | `true` when the level selection menu is displayed      |
    | `MUSIC`    | boolean | Enables/disables sound effects                         |
    | `WIDTH`    | integer | Width of the window, used for UI alignment             |
    | ---------- | ------- | ------------------------------------------------------ |

  ### ⚙️ Key Functions
    | ---------------------------| -------------------------------------------------------|
    | Function                   | Description                                            |
    | ---------------------------| -------------------------------------------------------|
    | `love.load()`              | Initializes game variables and assets                  |
    | `love.update(dt)`          | Updates game state and handles logic                   |
    | `love.draw()`              | Renders game elements to the screen                    |
    | `love.keypressed(key)`     | Handles input: movement, rotation, pause, and ending   |
    |                            | the game                                               |    
    | ---------------------------| ------------------------------------------------------ |

 ## 📄 File: conf.lua 

  ### 🎯 Purpose
    -- Configures the LÖVE framework settings such as window size, title, version, and save identity.

  ### 🔧 Configuration Settings
    | ------------------- | -------- | ----------------------------------------- |
    | Setting             |   Type   | Description                               |
    | ------------------- | -------- | ----------------------------------------- |
    | `t.identity`        | string   | Folder name used by LÖVE for saving files |
    | `t.title`           | string   | Title of the game window                  |
    | `t.version`         | string   | Target LÖVE version for compatibility     |
    | `t.console`         | boolean  | Enables or disables the debug console     |
    | `t.window.width`    | integer  | Width of the game window in pixels        |
    | `t.window.height`   | integer  | Height of the game window in pixels       |
    | ------------------- | -------- | ----------------------------------------- |

 ## 📄 File: blocks.lua

  ### 🎯 Purpose 
    -- Defines Tetromino shapes, their rotations, colors, and manages block movement and timing behavior.

  ### 🔧 Variables
    | -------------------- | -------- | ------------------------------------------------- |
    | Variable             | Type     | Description                                       |
    | -------------------- | -------- | ------------------------------------------------- |
    | `self.tetrominoes`   | table    | A list of all Tetromino shapes with               |
    |                      |          | their rotation states                             |
    |                      |          |                                                   |
    | `self.colors`        | table    | Color values (RGB) for each Tetromino shape       |
    | `self.current`       | table    | Current falling piece: `shape`, `x`, `y`,         |
    |                      |          | `index`, `rotation`                               |
    |                      |          |                                                   |
    | `self.timer.fall`    | number   | Timer tracking time since last automatic fall     |
    | `self.timer.lock`    | number   | Timer for locking a piece in place after it lands |
    | `self.delay.fall`    | number   | Time delay between automatic falls                |
    | `self.delay.lock`    | number   | Delay before a piece locks into the board         |
    | `self.isFalling`     | boolean  | `true` if the current piece is actively falling   |
    | `self.right`         | boolean  | `true` if the piece is moveable right             |
    | `self.left`          | boolean  | `true` if the piece is moveable left              |
    | `self.down`          | boolean  | `true` if the piece is moveable downward          |
    | `self.fallCounter`   | number   | Counter used for managing number of falls         |
    | -------------------- | -------- | ------------------------------------------------- |

  ### ⚙️ Key Functions
    | -------------------------- | ------------------------------------------------------ |
    | Function                   | Description                                            |
    | -------------------------- | ------------------------------------------------------ |
    | `Blocks:update(dt)`        | Updates the current block logic and spawns             |
    |                            | new blocks if needed                                   |
    |                            |                                                        |
    | `Blocks:spawn()`           | Selects a new random Tetromino and places it at        |
    |                            | the top center                                         |
    |                            |                                                        |
    | `Blocks:rotate()`          | Attempts to rotate the current block if no collision   |
    |                            | occurs                                                 |
    |                            |                                                        |
    | `Blocks:fall(dt)`          | Handles vertical movement and lock delays              |
    | `Blocks:checkFall()`       | Checks for collision below the block                   |
    | `Blocks:checkLeft()`       | Checks for collision on the left side of the block     |
    | `Blocks:checkRight()`      | Checks for collision on the right side of the block    |
    | `Blocks:checkBoundaries()` | Ensures block stays within horizontal bounds           |
    |                            | and checks side collisions                             |
    |                            |                                                        |
    | `Blocks:draw(x, y)`        | Draws the current Tetromino on the screen at given     |
    |                            | offsets                                                |
    | -------------------------- | ------------------------------------------------------ |

 ## 📄 File: grid.lua

  ### 🎯 Purpose 
    -- Manages the game grid, scoring logic, and rendering of the playing field.

  ### 🔧 Global Variables Used
    | ---------- | ------- | ------------------------------------------- |
    | Variable   | Type    | Description                                 |
    | ---------- | ------- | ------------------------------------------- |
    | `START`    | boolean | `true` when a game is running               |
    | `GameOver` | boolean | `true` if the game ended with a loss        |
    | `MUSIC`    | boolean | Enables/disables sound effects              |
    | `WIDTH`    | integer | Width of the window, used for UI alignment  |
    | `Menu.lvl` | number  | Current game level selected in menu         |
    | `Blocks`   | table   | Contains Tetromino logic, positions, shapes |
    | `Music`    | table   | Contains sound effects like `effect:play()` |
    | ---------- | ------- | ------------------------------------------- |

  ### 🧱 Internal State (self)
    | -------------- | ------- | ------------------------------------------ |
    | Variable       | Type    | Description                                |
    | -------------- | ------- | ------------------------------------------ |
    | `blockSize`    | number  | Pixel size of one block in the grid        |
    | `width`        | integer | Width of the grid in blocks                |
    | `height`       | integer | Height of the grid in blocks               |
    | `currentScore` | integer | Current score of the player                |
    | `highScore`    | integer | Highest score recorded (persisted to file) |
    | `counter`      | integer | Tracks how many rows were cleared          |
    | -------------- | ------- | -------------------------------------------|

  ### ⚙️ Key Functions
    | ----------------- | --------------------------------------------------------------- |
    | Function          | Description                                                     |
    | ----------------- | --------------------------------------------------------------- |
    | `Grid:load()`     | Initializes grid, loads high score, and creates                 |
    |                   | the playing field                                               |
    | `Grid:generate()` | Clears the grid and spawns a new Tetromino                      |
    | `Grid:score()`    | Checks and clears full rows, plays effect if enabled            |
    | `Grid:sum(t)`     | Returns sum of values in a row                                  |
    | `Grid:emptyRow()` | Returns a new empty row of the grid                             |
    | `Grid:draw(x, y)` | Renders the grid, scores, and level to the screen               |
    | `Grid:update(dt)` | Integrates falling pieces into the grid, updates score and      |
    |                   | game over status                                                |
    | ----------------- | --------------------------------------------------------------- |

  ### 📁 File Access
    -- Reads from highscore.txt
    -- Writes to highscore.txt on game over if a new high score is achieved

 ## 📄 File: menu.lua

  ### 🎯 Purpose
    -- Handles the game menu, including start screen, settings, level selection, and game over UI rendering.

  ### 🔧 Variables
    | ----------------- | -------- | -------------------------------------- |
    | Variable          | Type     | Description                            |
    | ----------------- | -------- | -------------------------------------- |
    | `Menu.buttons`    | table    | Holds the main menu buttons            |
    | `Menu.params`     | table    | Holds buttons related to settings      |
    | `Menu.levels`     | table    | Holds buttons for level selection      |
    | `Menu.font`       | Font     | Font used for rendering button labels  |
    | `Menu.lvl`        | integer  | Currently selected level number        |
    | ----------------- | -------- | -------------------------------------- |

  ### ⚙️ Key Functions
    | -------------------------- | ------------------------------------------------------ |
    | Function                   | Description                                            |
    | -------------------------- | ------------------------------------------------------ |
    | `Menu:newButton(text, fn)` | Creates a new button with label and callback action    |
    | `Menu:load()`              | Initializes menu buttons, levels, and settings buttons |
    | `Menu:update(dt)`          | Updates button labels dynamically (e.g.,current level) |
    | `Menu:draw()`              | Draws the menu interface: main menu, settings, level   |
    |                            | select, etc.                                           |
    | -------------------------- | ------------------------------------------------------ |

 ## 📄 File: music.lua

 ### 🎯 Purpose 
  -- Handles game soundtrack and sound effect playback, as well as volume control using a draggable UI slider.

 ### 🎛️ Local State
  | -------- | ------ | ------------------------------------------------------ |
  | Variable | Type   | Description                                            |
  | -------- | ------ | ------------------------------------------------------ |
  | `ww`     | number | Window width, used for layout                          |
  | `wh`     | number | Window height, used for layout                         |
  | `slider` | table  | Holds slider dimensions, knob radius, dragging state   |
  | `volume` | number | Float between 0–1 representing the master music volume |
  | -------- | ------ | ------------------------------------------------------ |

 ### 🔧 Global Table: Music
  | -------- | ------ | ---------------------------------- |
  | Key      | Type   | Description                        |
  | -------- | ------ | ---------------------------------- |
  | `loop`   | Source | Main music loop (Tetris theme)     |
  | `effect` | Source | Sound effect (e.g., on line clear) |
  | -------- | ------ | ---------------------------------- |

 ### ⚙️ Key Functions
  | ---------------------------------- | ----------------------------------------------- |
  | Function                           | Description                                     |
  | ---------------------------------- | ----------------------------------------------- |
  | `Music:load()`                     | Loads music/effect, sets loop, starts playback, |
  |                                    | and sets initial volume                         |
  |                                    |                                                 |
  | `Music:update(dt)`                 | Updates music state depending on `MUSIC` global |
  |                                    | flag, updates volume via slider                 |
  |                                    |                                                 |
  | `Music:draw()`                     | Draws the volume slider UI and current          |
  |                                    | volume value                                    |
  |                                    |                                                 |
  | `love.mousepressed(x, y, button)`  | Enables dragging the slider knob if clicked     |
  |                                    | inside knob hitbox                              |
  |                                    |                                                 |
  | `love.mousereleased(x, y, button)` | Disables dragging state after releasing mouse   |
  | ---------------------------------- | ----------------------------------------------- |

 ### 🎨 Slider UI Layout
  | ---------- | ---------------------------------------------------------- |
  | Element    | Description                                                |
  | ---------- | ---------------------------------------------------------- |
  | Slider Bar | A rectangle indicating the full volume range               |
  | Knob       | A circle that can be dragged to change volume              |
  | Label      | Displays volume in percentage (e.g., `Master Volume: 50%`) |
  | ---------- | ---------------------------------------------------------- |

 ### 🔊 Dependencies & Behavior
  -- Uses Love2D's love.audio.newSource() for both streaming (music) 
  and static (sound effects).
  -- Music is looped indefinitely using setLooping(true).
  -- Music volume is updated in real-time as user drags the slider.
  -- Volume value is a normalized float [0.0 - 1.0], displayed as a %.


