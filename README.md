# Mastermind
The Game of Mastermind written in MIPS assembly

The (modified) game of MasterMind is played as follows: First your opponent (i.e. the computer) selects a four digit number. Each of the digits in this number are guaranteed to be unique; further- more the first digit will never be a zero. The player then repeatedly guesses four digit numbers (with the same properties as the target number) until correct.
After each guess your opponent (i.e. the computer) provides the following feedback to the player:

• For each digit in the guess that appears in the target in the same place in both the target and guess; the word “Fermi” is output.

• For each digit in the guess that appears in the target, but in a different position; the work “Pico” is output.

• If no digits in the guess appear in the target, then the work “Bagels” is output.
The game is over when the target number is correctly guessed exactly. Your program should, in
addition to congratulating the player, display the number of guesses the player used. A given guess may generate

• either a single “Bagel” response, or
• between 1-3 “Fermi”s, or
• between 1-4 “Pico”s, or
• some combination of “Fermi”s and “Pico”s, with a maximum of four words total, or • an indication that the game is over since the word was correctly guessed.
