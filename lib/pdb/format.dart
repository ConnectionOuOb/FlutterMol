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

class PDB {
  List<Atom> atoms;

  PDB(this.atoms);

  factory PDB.fromText(String text) {
    List<Atom> atoms = [];

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
      }
    }

    return PDB(atoms);
  }
}
