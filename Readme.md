# Jigsaw.jl

- Simple julia library for creating Jigsaw puzzles

![Van Gogh puzzle](res/puzzle.png)

# :bullettrain_side: Quick start 

- You will need working [julia](https://julialang.org/) instalation (follow instructions on site)
- You can install this package simply using builtin package manager
- open julia repl, then Type `]add https://github.com/dimchee/Jigsaw.jl`, then press enter
```sh
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.8.2 (2022-09-29)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>

(@v1.8) pkg> add https://github.com/dimchee/Jigsaw.jl
```
- After some time package will be installed
- Delete one character (to exit package mode), then type `using Jigsaw` and press enter
```sh
julia> using Jigsaw
[ Info: Precompiling Jigsaw [370b0090-9d6e-4e72-ab0c-dd1d3d3336a6]

julia>
```
- You are ready for [usage](#video_game-usage) :tada:

## :house_with_garden: Geting code localy

- Clone this repository
- Navigate to this folder
- Type `]activate .`, then press enter
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
- If no error was produced, you should be good to go :tada:

## :telescope: Experimentation

- For interactive expirience, make sure you have `pluto` installed
```sh
(@v1.8) pkg> add Pluto
```
- Now, you can navigate to directory of this repository, and run pluto notebook
```sh
julia> Pluto.run(notebook="src/Notebook.jl", auto_reload_from_file=true)
```
- Browser should automatically launch (need some time to load) 

# :video_game: Usage

- You can directly generate puzzle with `makePuzzle` function
- You can save your puzzle as individual pictures to directory
```sh
julia> makePuzzle("res/kauernder_junge.jpg") |> save("parts")
```
- You doesn't have to save it as parts, ie. you can generate example image from this document
```sh
julia> makePuzzle("res/kauernder_junge.jpg") |>  toImage |> x -> FileIO.save("res/puzzle.png", x)
```
- Don't forget to import `FileIO` package!

## :diamond_shape_with_a_dot_inside: Creating custom puzzle shapes
- There is named argument `shape` you can use to make puzzles with custom shapes
```sh
julia> makePuzzle("res/kauernder_junge.jpg"; shape = _ -> (x, y) -> x > 0) |> save("parts")
```
- Function `shape` should be of type `type :: Symbol -> (bumpcord :: Float64, othercord :: Float64) -> Symbol`,
where `bumpcord` is in segment `[-1, 1]`, `othercord` is any real number
(proportional to bumcord, so `bumpcord^2 + othercord^2 < 1` is circle, not elipse)
and `type` is one of `:bump` or `:dent`. 
Argument `type` represents if current tile should have a bump or a dent.
Dependent on its value, you should return function that calculate if pixel should be in left or right tile,
and returns `:left` or `:right`.
- if your `shape` function returns something that is not `:left` or `:right`, it is treated as pixel that
doesn't belong to either left or right tile, and you will get gap (it will be blank in both).
- Be careful when constructing your own shapes. Shape should have at most one `left` and one `right` component,
and each one should be connected to it's own tile (otherwise tiles won't be connected). For
user convenience, i made function `valid(shape)` which should tell you if you made mistakes of this kind
(although you can try to debug visualy, in Pluto notebook for example, I recommend trying this function first)
```sh
julia> valid(defaultShape)
Tile shape approved :)
(this is just heuristic, doesn't mean function is fine, try visual check)

julia> 
```

## :scissors: Generating puzzles ready for cutting
- **WIP**


# :question: Questions
- If you run into problems, or would like to request features, feel free to open Issues
- PRs are welcome too :)

# :hibiscus: Resources

- Used [Van Gogh image](https://free-images.com/display/van_gogh_kauernder_junge.html) from example

# :zap: Motivation

I wanted to make jigsaw puzzle solver. When I tried to find examples of puzzles on the internet,
I was surprised. There is no dataset, nor standard format for jigsaw puzzles I could find.
Next, I tried to find generator so I could generate puzzles from images myself.
Unfortunately, again I had no luck. Every library I could find had output unsatisfactory for my needs,
and was unpleasant to use. So, I thought, perhaps I can do better.


## Other tools with similar goals

- Python based [solution](https://github.com/jkenlooper/piecemaker) made for [game](http://puzzle.massive.xyz/)
- Java GUI [application](https://github.com/RoseTec/JigSPuzzle)

### Inkscape

There are number of [tutorials](https://www.youtube.com/watch?v=1lCfgRBz8t0),
and even extensions exist:
- <https://inkscape.org/~Neon22/%E2%98%85lasercut-jigsaw>
- <https://github.com/RainyDayHiker/Inkscape_Jigsaw_Puzzle>

## Related

- Online Jigsaw [game](http://www.jigzone.com/)
- Jigsaw puzzle [solver](https://github.com/bbrattoli/JigsawPuzzlePytorch)
