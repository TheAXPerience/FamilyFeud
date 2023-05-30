# FamilyFeud

A terminal-based game of Family Feud written in the Ruby programming language.
The project can be used both to set up a game of Family Feud and to play one.

### The Game

The game will simulate a real-life game of Family Feud as much as possible.
Since there is not much of a way to determine who would go based on reaction using a single terminal, we will settle for letting to team with the least points go first. The first round will be randonmized.

A game can only be started if the program is provided with a file in the proper format containing the questions and answers. A file can have more than the standard number of questions, and questions will be chosen at random when played. Answers will appear as normal, however will contain a list of alternative answers that would be accepted the same. This allows hosts to be able to input different types of answers that are correct, like the actual show.
Unlike the actual game, there will be no timer for answers (due to being played in the terminal), players will have to manage themselves if they want this rule.

### Starting the Program

The program will accept two command-line arguments: the first is a flag determining whether a file is to be made or if the game is to be played, and the second is the name of the file.

### File Formatting

We will use binary store (.store) files to keep track of the questions and answers, using the PStore module in Ruby.
THe program will allow users to name a file and prompt them for questions, answers, and alternate answers.

**EDIT 5/30/2023**

Using JSON format instead. That way the answers and questions can be stored in a hierarchical format instead of a key-value storage.

### Playing the Game

The game will read the questions and answers from the given file and prompt the user for two team names. THe two teams will then begin playing a game of Family Feud. When a question is finished, the game will show all answers that have not been guessed.

It is unsure if the lightning round should be included or not, only because the time restraint of the real game is crucial for how the round works.
