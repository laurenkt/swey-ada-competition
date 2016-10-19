Ada Lovelace Competition
========================

	ruby game.rb

Data entry guide
----------------

To prepare the data ready for the tool to interpret:

* Separate into a CSV file with two columns, the first column for e-mail address, the second for moves.
* Each move is a single-letter, corresponding with the following:
	- `F` Move forward two spaces
	- `L` Rotate left
	- `R` Rotate right
	- `N` Move board up one space (north)
	- `S` Move board down one space (south)
	- `W` Move board left one space (west)
	- `E` Move board right one space (east)

So, for example, if you have two entries, the first one with the email of `ab123` and moves of left, right, left, right, north, south, north south, and the second with the email of `xy456` and moves of move forwards two, 8 times, the CSV input should look like this:

```csv
ab123,LRLRNSNS
xy456,FFFFFFFF
```
