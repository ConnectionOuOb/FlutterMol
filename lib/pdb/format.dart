class Atom {
  int serialNumber;
  String name;
  String alternateLocationIndicator;
  String residueName;
  String chainIdentifier;
  int residueSequenceNumber;
  String insertionCode;
  double x;
  double y;
  double z;
  double occupancy;
  double temperatureFactor;
  String elementSymbol;
  String charge;

  Atom(
    this.serialNumber,
    this.name,
    this.alternateLocationIndicator,
    this.residueName,
    this.chainIdentifier,
    this.residueSequenceNumber,
    this.insertionCode,
    this.x,
    this.y,
    this.z,
    this.occupancy,
    this.temperatureFactor,
    this.elementSymbol,
    this.charge,
  );
}

class Helix {
  int serialNumber;
  String helixIdentifier;
  String initialResidueName;
  String initialChainIdentifier;
  int initialResidueSequenceNumber;
  String initialInsertionCode;
  String terminalResidueName;
  String terminalChainIdentifier;
  int terminalResidueSequenceNumber;
  String terminalInsertionCode;
  int helixClass;
  String comment;
  int length;

  Helix(
    this.serialNumber,
    this.helixIdentifier,
    this.initialResidueName,
    this.initialChainIdentifier,
    this.initialResidueSequenceNumber,
    this.initialInsertionCode,
    this.terminalResidueName,
    this.terminalChainIdentifier,
    this.terminalResidueSequenceNumber,
    this.terminalInsertionCode,
    this.helixClass,
    this.comment,
    this.length,
  );
}

class Sheet {
  int strand;
  String sheetIdentifier;
  int numberOfStrands;
  String initialResidueName;
  String initialChainIdentifier;
  int initialResidueSequenceNumber;
  String initialInsertionCode;
  String terminalResidueName;
  String terminalChainIdentifier;
  int terminalResidueSequenceNumber;
  String terminalInsertionCode;
  int sense;

  Sheet(
    this.strand,
    this.sheetIdentifier,
    this.numberOfStrands,
    this.initialResidueName,
    this.initialChainIdentifier,
    this.initialResidueSequenceNumber,
    this.initialInsertionCode,
    this.terminalResidueName,
    this.terminalChainIdentifier,
    this.terminalResidueSequenceNumber,
    this.terminalInsertionCode,
    this.sense,
  );
}

class PDB {
  List<Atom> atoms;
  List<Helix> helices;
  List<Sheet> sheets;

  PDB(this.atoms, this.helices, this.sheets);

  factory PDB.fromText(String text) {
    List<Atom> atoms = [];
    List<Helix> helices = [];
    List<Sheet> sheets = [];

    for (var line in text.split("\n")) {
      if (line.startsWith("ATOM")) {
        atoms.add(
          Atom(
            int.parse(line.substring(6, 11).trim()),
            line.substring(12, 16).trim(),
            line.substring(16, 17).trim(),
            line.substring(17, 20).trim(),
            line.substring(21, 22).trim(),
            int.parse(line.substring(22, 26).trim()),
            line.substring(26, 27).trim(),
            double.parse(line.substring(30, 38).trim()),
            double.parse(line.substring(38, 46).trim()),
            double.parse(line.substring(46, 54).trim()),
            double.parse(line.substring(54, 60).trim()),
            double.parse(line.substring(60, 66).trim()),
            line.substring(76, 78).trim(),
            line.substring(78, 80).trim(),
          ),
        );
      } else if (line.startsWith("HELIX")) {
        helices.add(
          Helix(
            int.parse(line.substring(7, 10).trim()),
            line.substring(11, 14).trim(),
            line.substring(15, 18).trim(),
            line.substring(19, 20).trim(),
            int.parse(line.substring(21, 25).trim()),
            line.substring(25, 26).trim(),
            line.substring(27, 30).trim(),
            line.substring(31, 32).trim(),
            int.parse(line.substring(33, 37).trim()),
            line.substring(37, 38).trim(),
            int.parse(line.substring(38, 40).trim()),
            line.substring(40, 70).trim(),
            int.parse(line.substring(71, 76).trim()),
          ),
        );
      } else if (line.startsWith("SHEET")) {
        sheets.add(
          Sheet(
            int.parse(line.substring(7, 10).trim()),
            line.substring(11, 14).trim(),
            int.parse(line.substring(14, 16).trim()),
            line.substring(17, 20).trim(),
            line.substring(21, 22).trim(),
            int.parse(line.substring(22, 26).trim()),
            line.substring(26, 27).trim(),
            line.substring(28, 31).trim(),
            line.substring(32, 33).trim(),
            int.parse(line.substring(33, 37).trim()),
            line.substring(37, 38).trim(),
            int.parse(line.substring(38, 40).trim()),
          ),
        );
      } else if (line.startsWith("END")) {
        break;
      }
    }

    return PDB(atoms, helices, sheets);
  }
}
