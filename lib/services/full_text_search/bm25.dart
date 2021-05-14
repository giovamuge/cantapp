import 'dart:math' show log;
import 'dart:typed_data' show Uint8List;

import 'matchinfo.dart';

const _pIndex = 0;
const _cIndex = 1;
const _nIndex = 2;
const _aIndex = 3;

/// The format string that should be used with matchinfo() on an FTS4
/// virtual table.
const bm25FormatString = 'pcnalx';

/// Converts matchinfo() data to a relevance score (lower is more
/// relavent).
double bm25(Uint8List matchinfo,
    {double k1 = 1.2, double b = 0.75, List<double> weights}) {
  final data = Matchinfo.decode(matchinfo);

  final termCount = data[_pIndex];
  final columnCount = data[_cIndex];
  final rowCount = data[_nIndex];

  final lIndex = _aIndex + columnCount;
  final xIndex = lIndex + columnCount;

  final weightsLength = weights?.length ?? 0;
  double score = 0;

  for (var c = 0; c < columnCount; c++) {
    final weight = c < weightsLength ? weights[c] : 1;
    if (weight == 0) continue;

    int avgLength = data[_aIndex + c];
    if (avgLength == 0) avgLength = 1;

    final columnLength = data[lIndex + c];

    for (var t = 0; t < termCount; t++) {
      final x = xIndex + (3 * (c + t * columnCount));
      final termCount = data[x];
      final rowsWithTermCount = data[x + 2];

      double idf =
          log((rowCount - rowsWithTermCount + 0.5) / (rowsWithTermCount + 0.5));
      if (idf <= 0) idf = 0.000001;

      score += idf *
          ((termCount * (k1 + 1)) /
              (termCount + k1 * (1 - b + b * columnLength / avgLength))) *
          weight;
    }
  }

  return -score;
}

double score(
    {Uint8List matchinfo, int column, double b = 0.75, double k1 = 1.2}) {
  final pOffset = 0;
  final cOffset = 1;
  final nOffset = 2;
  final aOffset = 3;

  final termCount = matchinfo[pOffset];
  final colCount = matchinfo[cOffset];

  final lOffset = aOffset + colCount;
  final xOffset = lOffset + colCount;

  final totalDocs = matchinfo[nOffset].toDouble();
  final avgLength = matchinfo[aOffset + column].toDouble();
  final docLength = matchinfo[lOffset + column].toDouble();

  var score = 0.0;

  for (var i = 0; i < termCount.bitLength; i++) {
    final currentX = xOffset + (3 * (column + i * colCount));
    final termFrequency = matchinfo[currentX].toDouble();
    final docsWithTerm = matchinfo[currentX + 2].toDouble();

    final p = totalDocs - docsWithTerm + 0.5;
    final q = docsWithTerm + 0.5;
    final idf = logBase(p, q);

    final r = termFrequency * (k1 + 1);
    final s = b * (docLength / avgLength);
    final t = termFrequency + (k1 * (1 - b + s));
    final rightSide = r / t;

    score += (idf * rightSide);
  }

  return score;
}

double logBase(num x, num base) => log(x) / log(base);
