# ScrabbleHelper

Aim of this app to find suitable words while playing Scrabble

### Inputs:
The player enter 1 mandatory and 5 optional inputs;
- **Letters at hand**: The player should write their available letters. Maximum input length is 7 letters as it is the maximum at the game. Input format is *"abcdefg"*
- **Maximum length**: Limits the length of the resulting words. As default it is set to 10
- **Starts/Ends/Contains**: If the player wants to include any letters that are available at the board, should use those fields respectively. Input format: *"abcd.."*
- **Specific length**: If the player wants to limit the length of the resulting words, this will override the *Maximum length* and only words with the specified length will be displayed

### Needs to be fixed:

- Progress View while searching is displayed on top of the button
- Searching for unlimited length is slow
- Results should be sorted by their scores
