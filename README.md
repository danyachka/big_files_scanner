## **Files scanner**

This script is created for analyzing directories to find big weighted ones.
```BASH
➜  big_files_scanner git:(main) ✗ ./output/scanner.exe /home/kisik                 
Loading...
0   | directory : Music_______________________________ - 0.0     B
1   | file      : .ICEauthority_______________________ - 0.0     B
...
51  | directory : projects____________________________ - 5.561   GB
52  | directory : .local______________________________ - 6.303   GB
53  | directory : .android____________________________ - 7.575   GB
54  | directory : .gradle_____________________________ - 8.38    GB

Path = /home/kisik
Size = 58.741  GB
Process took 5.771 sec
54

Loading...
0   | directory : kotlin-profile______________________ - 0.0     B
1   | directory : .tmp________________________________ - 0.0     B
2   | directory : android_____________________________ - 22.0    B
3   | directory : jdks________________________________ - 181.0   B
4   | directory : native______________________________ - 1.513   MB
5   | directory : daemon______________________________ - 32.018  MB
6   | directory : wrapper_____________________________ - 147.183 MB
7   | directory : caches______________________________ - 8.2     GB

Path = /home/kisik/.gradle
Size = 8.38    GB
Process took 0.326 sec
```

### Usage
 - To go "up" type - ..
 - To open folder type its index
 - To exit type - exit

Use flag --remember to start with much higher (much higher!) memory usage but with faster directories opening

To produce a self-contained executable file:

```dart compile exe ./bin/big_files_scanner.dart -o output/scanner.exe```

Or run in JIT mode:

```dart run ./bin/big_files_scanner.dart *path*```
