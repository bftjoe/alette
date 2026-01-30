# alette
Another UCI-compatible chess engine written in C++. alette is based on [Belette by Vincent Bab](https://github.com/vincentbab/Belette/). 

It only supports CPUs with AVX2 and BMI2 instructions.

## Compiling

Tested on Windows and Linux with clang++ 20 or higher.

```sh
make release
```
Executable will be in `./build/alette[.exe]`

## UCI Options

### Debug Log File
Log every input and output of the engine to the specified file

### Hash
Specify the hash table size in megabytes

### Threads
For now this option doesn't do anything.

## Internals

### Board & Move generation
 - Bitboard
 - Zobrist hashing
 - Fast legal move enumeration inspired by [Gigantua](https://github.com/Gigantua/Gigantua)
```
perft 7, start position, Core i7 12700k

Nodes: 3195901860
NPS: 925007774
Time: 3455ms
```

### Search
 - Iterative deepening
 - Aspiration window
 - Negamax
 - Transposition Table
 - SEE pruning
 - Quiescence

 ### Move ordering
  - Hash move (TT Move)
  - MVV-LVA
  - Killer moves
  - Counter move
  - Threats
  - Checks
  - Butterfly history heuristic
  - Staged move generation (good captures, good quiets, bad captures, bad quiets)

### Evaluation
 - Tapered
 - Material
 - PSQT ([PeSTO](https://www.chessprogramming.org/PeSTO%27s_Evaluation_Function))

## Credits

Resources and other engines that inspired me:
 - [Chess Programming Wiki](https://www.chessprogramming.org/)
 - [Gigantua](https://github.com/Gigantua/Gigantua)
 - [Stockfish](https://stockfishchess.org/)
 - [Ethereal](https://github.com/AndyGrant/Ethereal)
