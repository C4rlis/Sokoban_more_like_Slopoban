package main












get_level_1 :: proc() -> Level {

level: Level
level.width = 8
level.height = 5

Map: [5][8]Tile = {
{ .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Goal, .Floor, .Wall},
{ .Wall, .Start, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall}, // 5 = 15 Lets go
}
Walls: [5][8]Thing = {
{ .None, .None, .None, .None, .None, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .None, .Box, .None, .None},
{ .None, .None, .None, .None, .None, .None, .None, .None},
{ .None, .None, .None, .None, .None, .None, .None, .None},
}



for y in 0..<level.height {
    for x in 0..<level.width {
        tile := Map[y][x]
        level.tiles[y][x] = tile
        level.things[y][x] = Position{x = x, y = y, kind = Walls[y][x]}

        #partial switch tile {
        case .Start:
            level.player.x = x
            level.player.y = y
            level.player.kind = .None
        }
    }
}


return level
}

get_level_2 :: proc() -> Level {

    level: Level
    level.width = 8
    level.height = 9

Map: [9][8]Tile = {
{ .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Goal, .Floor, .Wall},
{ .Wall, .Start, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Goal, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall}, // 5 = 15 Lets go
}

Walls: [9][8]Thing = {
{ .None, .None, .None, .None, .None, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .Box, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .None, .None, .None, .None},



}



for y in 0..<level.height {
    for x in 0..<level.width {
        tile := Map[y][x]
        level.tiles[y][x] = tile
        level.things[y][x] = Position{x = x, y = y, kind = Walls[y][x]}

        #partial switch tile {
        case .Start:
            level.player.x = x
            level.player.y = y
            level.player.kind = .None
        }
    }
}

return level }













get_level_3 :: proc() -> Level {

    level: Level
    level.width = 8
    level.height = 9

Map: [9][8]Tile = {
{ .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall},
{ .Wall, .Floor, .Floor, .Wall, .Floor, .Goal, .Floor, .Wall},
{ .Wall, .Start, .Floor, .Wall, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Wall, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Goal, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall}, // 5 = 15 Lets go
}

Walls: [9][8]Thing = {
{ .None, .None, .None, .None, .None, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .Box, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .None, .None, .None, .None},



}



for y in 0..<level.height {
    for x in 0..<level.width {
        tile := Map[y][x]
        level.tiles[y][x] = tile
        level.things[y][x] = Position{x = x, y = y, kind = Walls[y][x]}

        #partial switch tile {
        case .Start:
            level.player.x = x
            level.player.y = y
            level.player.kind = .None
        }
    }
}

return level }















get_level_4 :: proc() -> Level {

level: Level
level.width = 8
level.height = 9

Map: [9][8]Tile = {
{ .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall},
{ .Wall, .Floor, .Floor, .Wall, .Floor, .Goal, .Floor, .Wall},
{ .Wall, .Start, .Floor, .Wall, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Wall, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Wall, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Goal, .Floor, .Floor, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Floor, .Floor, .Goal, .Floor, .Wall},
{ .Wall, .Floor, .Floor, .Wall, .Floor, .Floor, .Floor, .Wall},
{ .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall, .Wall}, // 5 = 15 Lets go
}

Walls: [9][8]Thing = {
{ .None, .None, .None, .None, .None, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .Box, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .Box, .None, .None, .None},
{ .None, .None, .None, .None, .None, .None, .None, .None},



}



for y in 0..<level.height {
    for x in 0..<level.width {
        tile := Map[y][x]
        level.tiles[y][x] = tile
        level.things[y][x] = Position{x = x, y = y, kind = Walls[y][x]}

        #partial switch tile {
        case .Start:
            level.player.x = x
            level.player.y = y
            level.player.kind = .None
        }
    }
}

return level


 }






get_level_5 :: proc() -> Level { return get_level_1() }
LevelLoader :: proc() -> Level
LEVEL_LOADERS := [?]LevelLoader{get_level_1, get_level_2, get_level_3, get_level_4, get_level_5}