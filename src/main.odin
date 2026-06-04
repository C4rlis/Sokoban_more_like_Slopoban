package main



import rl "vendor:raylib"
import "core:mem"
import "core:math/rand"
import "core:fmt"
import "core:time"

Tile :: enum {
    Start,
    Floor,
    Wall,
    Button,
    Goal,
}

Thing :: enum {
    None,
    Box,
    Gate,


}
GameState :: enum {
    Menu,
    Game,

}

Position :: struct {
    x: int,
    y: int,
    kind: Thing,
}

Level :: struct {
    player: Position,
    width: int,
    height: int,
    tiles: [MAX_GRID_Y][MAX_GRID_X]Tile,
    things: [MAX_GRID_Y][MAX_GRID_X]Position,
}

Vector2 :: struct {
    x: i32,
    y: i32,

}

// Map: [MAX_GRID_Y][MAX_GRID_X]Tile = {
// { .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall,},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall}, // 5
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Start, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Goal, .Floor, .Floor, .Wall}, // 5
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
// { .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall}, // 5 = 15 Lets go

// }


MAX_UNDO_STATES :: 30    // IDK lets see

GRID_CELL_SIZE :: 30
MAX_GRID_X :: 20 // Not used
MAX_GRID_Y :: 15 // Not used LOL
MAX_THINGS :: 20 // Not used, does not matter in the end


WIDTH :i32: 800 // Okay
HEIGHT :i32: 550

 // Because of my imense genius, I decided to have player position and state all be tied to a dynamic array of Level structs


move_player :: proc(level: ^Level, dx, dy: int) {
    nx := level.player.x + dx
    ny := level.player.y + dy

    // Check boundaries
    if nx < 0 || ny < 0 || nx >= level.width || ny >= level.height {
        return
    }

    // Check for wall
    if level.tiles[ny][nx] == .Wall {
        return
    }

    // Check for box
    if level.things[ny][nx].kind == .Box {
        nnx := nx + dx
        nny := ny + dy

        // Check box push boundaries
        if nnx < 0 || nny < 0 || nnx >= level.width || nny >= level.height {
            return
        }

        // Check if box blocked by wall or another thing
        if level.tiles[nny][nnx] == .Wall || level.things[nny][nnx].kind != .None {
            return
        }

        // Push box
        level.things[nny][nnx].kind = .Box
        level.things[ny][nx].kind = .None
    }

    // Player moves
    level.player.x = nx
    level.player.y = ny
}
is_level_completed :: proc(level: ^Level) -> bool {
    // A level is completed if all goals have a box on them
    for y in 0..<level.height {
        for x in 0..<level.width {
            if level.tiles[y][x] == .Goal {
                if level.things[y][x].kind != .Box {
                    return false
                }
            }
        }
    }
    return true
}

save_undo :: proc(history: ^[dynamic]Level, history_index: ^int, level: Level) {
    for len(history) > history_index^ + 1 {
        pop(history)
    }
    append(history, level)
    history_index^ += 1
}

main :: proc() {

    rl.InitWindow(WIDTH, HEIGHT,"Slopoban")


    level := get_level_1()
    current_state := GameState.Menu

    completed_levels: [len(LEVEL_LOADERS)]bool
    current_level_index := 0
    gridPosition : Vector2 = {100, 50} // Default grid starting point

    history: [dynamic]Level
    history_index := 0
    append(&history, level)

    rl.SetTargetFPS(60)
    rl.SetExitKey(rl.KeyboardKey(0))


    for !rl.WindowShouldClose() {
        free_all(context.temp_allocator)

        if current_state == .Menu {
                rl.BeginDrawing()
                rl.ClearBackground(rl.DARKGRAY)
                rl.DrawText("Select Level", WIDTH/2 - 100, 50, 30, rl.WHITE)

                mouse_pos := rl.GetMousePosition()
                clicked := rl.IsMouseButtonPressed(.LEFT)

                for i in 0..<len(LEVEL_LOADERS) {
                    rect := rl.Rectangle{ x = auto_cast(WIDTH/2 - 100), y = auto_cast(120 + i * 60), width = 200, height = 40 }
                    color := completed_levels[i] ? rl.GREEN : rl.GRAY
                    hover_color := completed_levels[i] ? rl.LIME : rl.LIGHTGRAY

                    if rl.CheckCollisionPointRec(mouse_pos, rect) {
                        color = hover_color
                        if clicked {
                            level = LEVEL_LOADERS[i]()
                            current_level_index = i
                            current_state = .Game
                        }
                    }
                    rl.DrawRectangleRec(rect, color)
                    rl.DrawText(fmt.ctprintf("Level %d", i+1), auto_cast(rect.x + 50), auto_cast(rect.y + 10), 20, rl.BLACK)
                }
                rl.EndDrawing()
            } else if current_state == .Game {
                if is_level_completed(&level) {
                    completed_levels[current_level_index] = true
                    time.sleep(300_000_000)
                    current_state = .Menu


                }


            if rl.IsKeyPressed(.ESCAPE) {
                current_state = .Menu
            }

                // if rl.IsKeyPressed(rl.KeyboardKey.RIGHT) {Level.player.x += 1}
                // else if rl.IsKeyPressed(rl.KeyboardKey.LEFT) {Level.player.x -= 1}
                // else if rl.IsKeyPressed(rl.KeyboardKey.UP) {Level.player.y += 1}
                // else if rl.IsKeyPressed(rl.KeyboardKey.DOWN) {Level.player.y -= 1}


            //#assert(level.height <= MAX_GRID_Y && level.width <= MAX_GRID_X)
            //     if Level.player.x < 0 {Level.player.x = 0}
            // else if Level.player.x >= Level.width {Level.player.x = Level.width - 1}
            // if Level.player.y < 0 {Level.player.y = 0}
            // else if Level.player.y >= Level.height {Level.player.y = Level.height - 1}



            if rl.IsKeyPressed(.LEFT) {
                old := level
                move_player(&level, -1, 0)
                if level != old {save_undo(&history, &history_index, level)}
            }


            if rl.IsKeyPressed(.RIGHT) {
                old := level
                move_player(&level, 1, 0)
                if level != old {save_undo(&history, &history_index, level)}
            }

            if rl.IsKeyPressed(.UP) {
                old := level
                move_player(&level, 0, -1)
                if level != old {save_undo(&history, &history_index, level)}
            }

            if rl.IsKeyPressed(.DOWN) {
                old := level
                move_player(&level, 0, 1)
                if level != old {save_undo(&history, &history_index, level)}
            }

            if rl.IsKeyDown(.LEFT_CONTROL) && rl.IsKeyPressed(.Z) {
                if history_index > 0 {
                    history_index -= 1
                    level = history[history_index]
                }

            }



            if rl.IsKeyDown(.LEFT_CONTROL) && rl.IsKeyPressed(.Y) {
                if history_index < len(history) - 1 {
                    history_index += 1
                    level = history[history_index]

                }

            }



            if rl.IsKeyPressed(.R) { // Restart level
                level = LEVEL_LOADERS[current_level_index]()
                clear(&history)
                history_index = 0
                append(&history, level)
            }


            // if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
            //     player.color.r = auto_cast(rand.int32_range(20,255))
            //     player.color.g = auto_cast(rand.int32_range(20,255))
            //     player.color.b = auto_cast(rand.int32_range(20,255))
            // }



            gridPosition.x = (WIDTH - auto_cast(level.width*GRID_CELL_SIZE)) / 2
            gridPosition.y = (HEIGHT - auto_cast(level.height*GRID_CELL_SIZE)) / 2
            // How to center the drawing? if I just do width/2 messed up some sometihng like
            // (Width - level.width*GRID_CELL_SIZE) / 2


            rl.BeginDrawing()
                rl.ClearBackground(rl.WHITE)
            for y in 0..=level.height {
                rl.DrawLine(auto_cast(gridPosition.x), auto_cast(gridPosition.y) + auto_cast(y*GRID_CELL_SIZE),
                            auto_cast(gridPosition.x) + auto_cast(level.width*GRID_CELL_SIZE), auto_cast(gridPosition.y) + auto_cast(y*GRID_CELL_SIZE), rl.BLACK)
            }
            for x in 0..=level.width {
                rl.DrawLine(auto_cast(gridPosition.x) + auto_cast(x*GRID_CELL_SIZE), auto_cast(gridPosition.y),
                            auto_cast(gridPosition.x) + auto_cast(x*GRID_CELL_SIZE), auto_cast(gridPosition.y) + auto_cast(level.height*GRID_CELL_SIZE), rl.BLACK)
            }
            // Drew in the grid first then walls Goal

            for y in 0..<level.height {
                for x in 0..<level.width {
                    tile := level.tiles[y][x]

                    #partial switch tile {
                    case .Wall:
                        rl.DrawRectangle(auto_cast(gridPosition.x) + auto_cast(x*GRID_CELL_SIZE), auto_cast(gridPosition.y) + auto_cast(y*GRID_CELL_SIZE), GRID_CELL_SIZE, GRID_CELL_SIZE, rl.BLUE)
                        break
                    case .Goal:
                        rl.DrawRectangle(auto_cast(gridPosition.x) + auto_cast(x*GRID_CELL_SIZE), auto_cast(gridPosition.y) + auto_cast(y*GRID_CELL_SIZE), GRID_CELL_SIZE, GRID_CELL_SIZE, rl.RED)
                        break

                    case:
                        // fmt.printf("But")
                        break

                    }

                }
            }

            // Draw boxes
            for y in 0..<level.height {
                for x in 0..<level.width {
                    if level.things[y][x].kind == .Box {

                        rl.DrawRectangle(auto_cast(gridPosition.x) + auto_cast(x*GRID_CELL_SIZE) + 2, auto_cast(gridPosition.y) + auto_cast(y*GRID_CELL_SIZE) + 2, GRID_CELL_SIZE - 4, GRID_CELL_SIZE - 4, rl.ORANGE)
                    }
                }
            }
            // Drawing the player
            rl.DrawRectangle(auto_cast(gridPosition.x) + auto_cast(level.player.x*GRID_CELL_SIZE) + 2, auto_cast(gridPosition.y) + auto_cast(level.player.y*GRID_CELL_SIZE) + 2,GRID_CELL_SIZE - 4, GRID_CELL_SIZE - 4, rl.VIOLET)


            rl.EndDrawing()
            } // End of current_state == .Game





    }
    delete(history)
    rl.CloseWindow()




}