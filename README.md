# Text-Editor-in-Assembly-Language

 Menu driver program that serves as a text editor and save the resulting text to a file. Able to enter new strings manually and/or via a file (input.txt). All additions are additive (i.e. i can call 2b 5 x times and 5 copies of the text file would be stored in the data structure (linked list of strings). Use the enclosed file for possible input. Do not load automatically, only via the menu.

Menu Structure:

        TEXT EDITOR
        Data Structure Heap Memory Consumption: 00000000 bytes
        Number of Nodes: 0
        
<1> View all strings

<2> Add string
    <a> from Keyboard
    <b> from File. Static file named input.txt

<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node).

<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.

<5> String search. Regardless of case, return all strings that match the substring given.

<6> Save File (output.txt)

<7> Quit
