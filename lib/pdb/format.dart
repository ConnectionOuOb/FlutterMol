class Realm {
  int start;
  int end;
  String chainID;

  Realm(this.start, this.end, this.chainID);
}

class Atom {
  int serialNumber;
  String name;
  String residueName;
  String chainIdentifier;
  int residueSequenceNumber;
  double x;
  double y;
  double z;

  Atom(
    this.serialNumber,
    this.name,
    this.residueName,
    this.chainIdentifier,
    this.residueSequenceNumber,
    this.x,
    this.y,
    this.z,
  );
}

class PDB {
  List<Atom> atoms;
  List<Realm> helices;
  List<Realm> sheets;

  PDB(this.atoms, this.helices, this.sheets);

  factory PDB.fromText(String text) {
    List<Atom> atoms = [];
    List<Realm> helices = [];
    List<Realm> sheets = [];

    for (var line in text.split("\n")) {
      if (line.startsWith("ATOM")) {
        atoms.add(
          Atom(
            int.parse(line.substring(6, 11).trim()),
            line.substring(12, 16).trim(),
            line.substring(17, 20).trim(),
            line.substring(21, 22).trim(),
            int.parse(line.substring(22, 26).trim()),
            double.parse(line.substring(30, 38).trim()),
            double.parse(line.substring(38, 46).trim()),
            double.parse(line.substring(46, 54).trim()),
          ),
        );
      } else if (line.startsWith("HELIX")) {
        helices.add(
          Realm(
            int.parse(line.substring(21, 25).trim()),
            int.parse(line.substring(33, 37).trim()),
            line.substring(19, 20).trim(),
          ),
        );
      } else if (line.startsWith("SHEET")) {
        sheets.add(
          Realm(
            int.parse(line.substring(22, 26).trim()),
            int.parse(line.substring(33, 37).trim()),
            line.substring(21, 22).trim(),
          ),
        );
      } else if (line.startsWith("END")) {
        break;
      }
    }

    return PDB(atoms, helices, sheets);
  }
}
