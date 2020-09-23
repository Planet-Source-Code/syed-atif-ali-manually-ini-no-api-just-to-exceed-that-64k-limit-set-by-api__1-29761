<div align="center">

## Manually INI \(NO API \!\!\)\.\.\.just to exceed that 64k limit set by api


</div>

### Description

Well, my IGCSE mocks just finished yesterday so I was thinking what to do...so just to brush my skills (:D), I made this...

We all know what the heck are INI files (if you don't, read their brief description at the bottom)...but did you know that these INI files have a size limit? YES! You see, when you call the Windows API, you will not be able to read files that are bigger than 10kb (on win 9.x i think...correct me if I am wrong) and 64kb on win me/nt/2k. So the next time you try to read a value that is held in position after the 64k/10k mark on a file, all u'll get is a blank (you can do the GetLastError API to see what error was, never tried it though).

But HO HO! (look who comes to the rescue) During the past 1 and a half hours (or something), I just wrote a class that will read INI's all by opening them for input and output, and ofcourse, parsing them on their way. So now, throw away ur existing API INI classes and replace these.

Features:

1. No more INI File size limit

2. Useful for writing file formats. Yes! For example, I previously wrote an INI script format(crazy idea, huh?) in which some values of keys were actually the names of other keys and in this way, a flow of data can be formed that doesn't have to follow hard-coded format.

3. As fast (well, almost....now, reading a teeny weeny value from a 500kb file that contained 50,000 items took 5 seconds or something on my computer...btw, the file was generated to test the class. Also, there is hardly any noticeable difference between the API and this class even if the file is smaller than 64k).

4. Other features that were included were: Read/Write value (basic INI I/O), Delete a key, Delete the whole darn Section, get all sections (only sectionsuseful for enumerating...file formats!), get all keys with their values all together (useful for enumerating...again file formats!), write values all at once from an array (instead of doing them one by one, which may get slow).

5. It's a drop-in class...just drop and use! very easy parameters to follow :)

WHAT INIs ARE:

INIs came along with the advent of Windows OSes. They were initially (and, well, still are) are used for storing settings of a program. You can say INI is a standard file format for saving settings (I say standard when I mean Windows standard). Windows supplies APIs that make it easy for us, the developers, to read and write values using just plain strings, which the Windows APIs organises into a format in a file.

The format is:

1. There is a section that represents a number of keys (both of which you set)

2. There are keys that represent values (you set the values too)

3. Then there are other sections,

4. with other keys,

5. with other values.

6. blah blah

and oh ya, I didn't do an example cuz I think almost everyone might have come across INI files (and anyway, it will take only 3 lines max to write a value to a file using this class)

(vote if you like :D...I dont mind, nor do I bite...so criticism [not in a harsh way, mind you] may be appreciated.)

Tata!
 
### More Info
 
none, just open a file, read it, parse it, sort it/modify it.

hmmm...

Look at the code.

avoided using VB functions and sticked to arrays


<span>             |<span>
---                |---
**Submitted On**   |2001-12-14 04:56:34
**By**             |[Syed Atif Ali](https://github.com/Planet-Source-Code/PSCIndex/blob/master/ByAuthor/syed-atif-ali.md)
**Level**          |Intermediate
**User Rating**    |5.0 (25 globes from 5 users)
**Compatibility**  |VB 4\.0 \(32\-bit\), VB 5\.0, VB 6\.0, VBA MS Access, VBA MS Excel
**Category**       |[Files/ File Controls/ Input/ Output](https://github.com/Planet-Source-Code/PSCIndex/blob/master/ByCategory/files-file-controls-input-output__1-3.md)
**World**          |[Visual Basic](https://github.com/Planet-Source-Code/PSCIndex/blob/master/ByWorld/visual-basic.md)
**Archive File**   |[Manually\_I4189812132001\.zip](https://github.com/Planet-Source-Code/syed-atif-ali-manually-ini-no-api-just-to-exceed-that-64k-limit-set-by-api__1-29761/archive/master.zip)

### API Declarations

none...cuz this caused the whole problem.





