import 'format.dart';
import '../geometry/controller.dart';

List<String> backbones = ['N', 'CA', 'C', 'O'];

StructureController transform2Controller(String textPDB) {
  PDB pdbData = PDB.fromText(textPDB);
  List<Point3D> points = [];
  List<Realm> helix = [];
  List<Realm> sheet = [];

  for (var a in pdbData.atoms) {
    points.add(Point3D(backbones.contains(a.name), a.name == 'N', a.x, a.y, a.z));
  }

  for (var h in pdbData.helices) {
    helix.add(
      Realm(
        h.initialResidueSequenceNumber,
        h.terminalResidueSequenceNumber,
        h.initialChainIdentifier,
        h.terminalChainIdentifier,
      ),
    );
  }

  for (var s in pdbData.sheets) {
    sheet.add(
      Realm(
        s.initialResidueSequenceNumber,
        s.terminalResidueSequenceNumber,
        s.initialChainIdentifier,
        s.terminalChainIdentifier,
      ),
    );
  }

  return StructureController(0, true, points, helix, sheet);
}
