#include "pch.h"
#include <iostream>
#include <string>
#include <fstream>
using namespace std;

//Concordance - manages a table of words and their occurrence in a text
class Concordance {
public:
	int numWords;
	struct pair {
		string word;
		int ocr;
	};
	pair table[1000];
	string fileName;
	ifstream infile;
	Concordance();
	void getFile();
	int binarySearch(string t);
	void sort();
	string getWord();
	void installWords();
	void printTable();
};

//Concordance() - constructor initializes number of installed words to 0
Concordance::Concordance(void) {
	numWords = 0;
}

//getFile() - Prompts user for the name of the file and opens it
void Concordance::getFile() {
	cout << "Enter the name of the file to be read: ";
	cin >> fileName;

	infile.open(fileName);
}

//binarySearch() - conducts a binary search on the table searching for a
//					target string and returning its index
int Concordance::binarySearch(string t) {
	int low = 0;
	int high = numWords;

	//Search for the word until the low is higher than high
	while (low <= high) {
		int mid = (low + high) / 2;

		if (t.compare(table[mid].word) < 0) {
			//if mid word is higher alphabetically, run again with mid-1 as high
			high = mid - 1;
		}
		else if (t.compare(table[mid].word) > 0) {
			//if mid word is lower alphabetically, run again with mid-1 as low
			low = mid + 1;
		}
		else {
			//word is found, return mid
			return mid;
		}
	}

	//if the word is not found, return -1
	return -1;
}

//sort() - conducts an alphabetic bubble sort on the table by word
void Concordance::sort() {
	int j;
	for (j = numWords; j > 0; j--) {
		if (table[j].word.compare(table[j - 1].word) < 0) {
			pair temp = table[j];
			table[j] = table[j - 1];
			table[j - 1] = temp;
		}
	}
}

//getWord() - gets the next word of the file and returns it as a string
string Concordance::getWord() {
	string text;
	unsigned int i = 0;

	//If the EOF marker has not been reached, text is assigned the next word
	if (!infile.eof()) {
		infile >> text;
	}

	//Cycle through the characters of text, making all lower case
	for (i = 0; i < text.size(); i++) {
		text[i] = tolower(text[i]);
	}

	return text;
}

//installWords() - puts each word from a file into a table
void Concordance::installWords() {
	getFile();

	//continue reading words until the end of the file is reached
	while (!infile.eof()) {
		string temp = getWord();

		//the first word is always installed and does not require
		// searching or sorting
		if (numWords == 0) {
			table[numWords].word = temp;
			numWords++;
		}
		else {
			//search for the word in the table
			int i = binarySearch(temp);

			//if the returned index is -1 the word is not in the table
			if (i == -1) {
				table[numWords].word = temp;
				table[numWords].ocr++;
				sort();
				numWords++;
			}
			else {
				//if the word is already in the table, increment its ocr
				table[i].ocr++;
			}
		}
	}

	infile.close();
}

//printTable() - prints table of words and their occurrences
void Concordance::printTable() {
	int i = 0;
	cout << "\tWord\t\tOccurrences" << endl;
	for (i = 0; i < numWords; i++) {
		cout << (i + 1) << ".\t" << table[i].word <<
			"\t\t" << table[i].ocr << endl;
	}
}

int main() {
	Concordance con;
	con.installWords();
	con.printTable();
	return 0;
}