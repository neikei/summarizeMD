# summarizeMD

SummarizeMD is a simple Ruby script that generates a summary (TOC) and anchor links for an existing markdown document.

- [Example Github page](https://neikei.github.io/notes/)

## Usage

```bash
wget https://github.com/neikei/summarizeMD/blob/master/summarizeMD.rb
chmod +x summarizeMD.rb
./tools/summarizeMD.rb <source_file>.md
```

## Output

```bash
# Desc: Simple execution
neikei@workstation:~$ ./summarizeMD.rb sourcefile.md
Generating summary for file sourcefile.md
Done.
neikei@workstation:~$ ls -l
sourcefile.md
summarized_sourcefile.md

# Desc: Execution with output specification
neikei@workstation:~$ ./summarizeMD.rb sourcefile.md -o outputfile.md
Generating summary for file sourcefile.md
Done.
neikei@workstation:~$ ls -l
sourcefile.md
outputfile.md

# Desc: Execution with output specification and force flag to overwrite the output file if exists
neikei@workstation:~$ ./summarizeMD.rb -f sourcefile.md -o outputfile.md
Generating summary for file sourcefile.md
Done.
neikei@workstation:~$ ls -l
sourcefile.md
outputfile.md
```

## Options

You can launch script with some options (work in progress).

- **-o, --output [filename]**
Specify output filename.
- **-f, --[no-]force**
Force overwrite output file if exists.
- **-v, --[no-]verbose**
Run script verbosely printing some informations.
- **-h, --help**
Display list of available options.
- **--version**
Display script version.

## Changelog

10 Aug 2017

- Version: 0.3.0
- Added meaningful anchor links based on the headlines
- Codestyle tab vs. spaces
- Updated the documentation

10 Nov 2016

- Version: 0.2.0
- Improvements by [Kreinoee](https://github.com/Kreinoee)

01 Apr 2015

- Version: 0.1.0
- Initial creation by [velthune](https://github.com/velthune)

# License

Copyright (c) 2015 velthune

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
