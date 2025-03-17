// File: bin/flattener.dart
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Input directory path', mandatory: true)
    ..addOption('output', abbr: 'o', help: 'Output directory path', mandatory: true);

  late final ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    print('Error: ${e.toString()}');
    print('Usage: flattener -i <input_dir> -o <output_dir>');
    exit(1);
  }

  final inputPath = argResults['input'] as String;
  final outputPath = argResults['output'] as String;

  final inputDir = Directory(inputPath);
  if (!inputDir.existsSync()) {
    print('Error: Input directory does not exist.');
    exit(1);
  }

  final outputDir = Directory(outputPath);
  if (outputDir.existsSync()) {
    print('Error: Output directory already exists. Please specify a new directory.');
    exit(1);
  }
  outputDir.createSync(recursive: true);

  try {
    _processDirectory(inputDir, outputDir);
    print('Directory flattened successfully.');
  } catch (e) {
    print('An error occurred while processing the directory: ${e.toString()}');
    exit(1);
  }
}

void _processDirectory(Directory inputDir, Directory outputDir) {
  for (final entity in inputDir.listSync(recursive: true, followLinks: false)) {
    if (entity is File) {
      final fileName = path.basename(entity.path);
      var destinationPath = path.join(outputDir.path, fileName);

      int counter = 1;
      while (File(destinationPath).existsSync()) {
        final extension = path.extension(fileName);
        final nameWithoutExtension = path.basenameWithoutExtension(fileName);
        destinationPath = path.join(
            outputDir.path,
            '${nameWithoutExtension}_${counter.toString().padLeft(3, '0')}$extension'
        );
        counter++;
      }

      entity.copySync(destinationPath);
    }
  }
}