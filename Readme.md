# Jigsaw.jl

- Simple julia library for creating Jigsaw puzzles

![Van Gogh puzzle](res/puzzle.png)

# Quick start

- Clone this repository
- Navigate to this folder
- Type ']activate .' then press enter
- Delete one character, then type 'using Jigsaw' and press enter
```sh
$ git clone https://github.com/dimchee/Jigsaw.jl
$ cd Jigsaw
$ julia
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.8.2 (2022-09-29)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>

(@v1.8) pkg> activate .
  Activating project at `<path-to-this-folder>`

(Jigsaw) pkg>

julia> using Jigsaw
[ Info: Precompiling Jigsaw [370b0090-9d6e-4e72-ab0c-dd1d3d3336a6]

julia>
```
- If no error was produced, you should be good to go :)

## Generating puzzle
- You can directly generate puzzle with `makePuzzle` function
- You can save your puzzle as individual pictures to directory
```sh
julia> makePuzzle("res/kauernder_junge.jpg") |> save("parts")
```

## Experimentation

- For interactive expirience, just run `pluto` function:
```sh
julia> pluto()
```
- Browser should automatically launch (need some time to load) 

# Resources

- [Sample Image](https://free-images.com/display/van_gogh_kauernder_junge.html)
- [Online game](http://www.jigzone.com/)
- [Solver](https://github.com/bbrattoli/JigsawPuzzlePytorch)

## Generators

- [Python based](https://github.com/jkenlooper/piecemaker)
- [Java based](https://github.com/RoseTec/JigSPuzzle)

### Using Inkscape

- [Tutorial](https://www.youtube.com/watch?v=1lCfgRBz8t0)


#### Inkscape Extensions

- <https://inkscape.org/~Neon22/%E2%98%85lasercut-jigsaw>
- <https://github.com/RainyDayHiker/Inkscape_Jigsaw_Puzzle>
