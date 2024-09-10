package main

import (
	"fmt"
	"unicode/utf8"
	"os"
	"strings"
	"regexp"
	"os/exec"
	//"strconv"
)

func Print(str string) {
	cmd := exec.Command("notify-send", str)
	cmd.Run()
}

var EMOJIS []rune = []rune{'❌', '✅', '❔', '❓', '📅', '🚗', '🌙', '⏳'}

func isEmoji(r rune) bool {
	for _, emoji := range EMOJIS {
		if r == emoji {
			return true
		}
	}
	return false
}

func properLen(input string) int {
	var noEndSpaces string = strings.TrimRight(input, " ")
	var length int = utf8.RuneCountInString(noEndSpaces) + 1
	
	//fmt.Printf("A:%s:B\n", input)
	//fmt.Printf("C:%s:D\n", noEndSpaces)
	
	for _, r := range noEndSpaces {
		if isEmoji(r) {
			length++
		}
	}
	return length
}

func readFile(filename string) []string {
	dat, err := os.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	
	return strings.Split(string(dat), "\n")
}

func testForAlignRow(line string) bool {
	if len(line) < 1 {
		return false
	}
	
	if line[0] != '|' || line[len(line)-1] != '|' {
		return false
	}
	split := strings.Split(line, "|")
	var isCorrect = regexp.MustCompile("^(-*:* *)*$").MatchString
	for _, x := range split {
		if !isCorrect(x) {
			return false
		}
	}
	
	return true
}

func testForEnd(line string) bool {
	if len(line) == 0 || line[0] != '|' {
		return true
	}
	return false
}

func findTables(input []string) [][]int {
	var tables [][]int
	
	var inTable bool = false
	
	for i, line := range input {
		if !inTable && testForAlignRow(line) {
			tables = append(tables, []int{i-1})
			inTable = true
		} else if inTable && testForEnd(line) {
			tables[len(tables)-1] = append(tables[len(tables)-1], i-1)
			inTable = false
		}
	}
	
	return tables
}

func calcLengths(thisTable []string) []int {
	numCells := strings.Count(thisTable[0], "|") - 1
	
	var columnLengths []int = make([]int, numCells)
	
	for i, line := range thisTable {
		if i == 1 {
			continue
		}
		cells := strings.Split(line, "|")
		cells = cells[1:len(cells)-1]
		
		for j, cell := range cells {
			var cellLen int = properLen(cell)
			//fmt.Println(cell)
			if cellLen > columnLengths[j] {
				columnLengths[j] = cellLen
			}
		}
	}
	return columnLengths
}

func alignTable(table []int, data[]string) []string {
	//fmt.Println("Table:")
	thisTable := data[table[0]:table[1]+1]
	columnLengths := calcLengths(thisTable)
	//fmt.Println(columnLengths)
	
	for i:=0; i<len(thisTable); i++ {
		cells := strings.Split(thisTable[i], "|")
		cells = cells[1:len(cells)-1]
		
		newCells := []string{}
		for j, cell := range cells {
			cell = strings.TrimRight(cell, " ") + " "
			var cellLen int = properLen(cell)
			if cellLen != columnLengths[j] {
				var paddedCell string = padCell(cell, cellLen, i, j, columnLengths)
				newCells = append(newCells, paddedCell)
				
			} else {
				newCells = append(newCells, cell)
			}
		}
		// Build new row string
		var newCellString string = "|"
		for _, cell := range newCells {
			newCellString = newCellString + cell + "|"
		}
		thisTable[i] = newCellString
	}
	return data
}

func padCell(cell string, cellLen int, i int, j int, columnLengths []int) string {
	var paddedCell string
	if i == 1 {
		paddedCell = " :" + strings.Repeat("-", columnLengths[j]-4) + ": "
	} else {
		paddedCell = cell + strings.Repeat(" ", columnLengths[j]-cellLen)
	}
	return paddedCell
}

func alignTables(tables [][]int, data []string) []string {
	for _, table := range tables {
		data = alignTable(table, data)
	}
	return data
}

func saveToFile(data []string, filename string) {
	if len(data[len(data)-1]) == 0 {
		data = data[:len(data)-1]
	}
	var toSave string
	for _, line := range data {
		toSave = toSave + line + "\n"
	}
	err := os.WriteFile(filename, []byte(toSave), 0666)
	if err != nil {
		panic(err)
	}
}

func main() {
	if len(os.Args) != 3 {
		fmt.Println("Usage: \n  tablealigner input.md output.md")
		panic("wrong args")
	}
	
	var inputFile string = os.Args[1]
	var outputFile string = os.Args[2]
	if os.Args[1] == "-s" {
		inputFile = os.Args[2]
		outputFile = os.Args[2]
	}
		
	data := readFile(inputFile)
	
	tables := findTables(data)
	//fmt.Println(tables)
	data = alignTables(tables, data)
	
	//data = fixEmojis(data)
	
	saveToFile(data, outputFile)
}
