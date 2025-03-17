This Dart script creates a CLI tool that flattens a directory structure as requested. Here's a brief explanation of its functionality:

1. It uses the `args` package to parse command-line arguments for input and output directories.
2. It validates the input directory and creates the output directory.
3. The `_processDirectory` function recursively processes the input directory, copying all files to the root of the output directory.
4. It handles potential file name conflicts by appending a numeric suffix to duplicate file names.

To use this tool, you would run it from the command line like this:
```
dart run flattener -i <input_directory> -o <output_directory>
```
