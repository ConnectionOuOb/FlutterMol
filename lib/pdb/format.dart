class Atom {
  String name;
  double x;
  double y;
  double z;

  Atom(
    this.name,
    this.x,
    this.y,
    this.z,
  );
}

class Residue {
  String name;
  String chainIdentifier;
  int sequenceNumber;
  List<Atom> atoms;

  Residue(this.name, this.chainIdentifier, this.sequenceNumber, this.atoms);
}

class PDB {
  List<Residue> aas;

  PDB(this.aas);

  factory PDB.fromStringList(List<String> texts) {
    List<Residue> aas = [];

    int previousSequenceNumber = -1;
    for (var text in texts) {
      if (!text.startsWith("ATOM")) {
        continue;
      }

      int sequenceNumber = int.parse(text.substring(22, 26).trim());

      if (sequenceNumber == previousSequenceNumber) {
        aas.last.atoms.add(
          Atom(
            text.substring(12, 16).trim(),
            double.parse(text.substring(30, 38).trim()),
            double.parse(text.substring(38, 46).trim()),
            double.parse(text.substring(46, 54).trim()),
          ),
        );
      } else {
        aas.add(
          Residue(
            text.substring(17, 20).trim(),
            text.substring(21, 22).trim(),
            sequenceNumber,
            [],
          ),
        );
      }

      previousSequenceNumber = sequenceNumber;
    }

    return PDB(aas);
  }
}
