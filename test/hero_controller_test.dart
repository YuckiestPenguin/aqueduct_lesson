
import 'harness/app.dart';

void main() {
  final harness = Harness()..install();

  test("POST /heroes returns 200 OK", () async {
    await harness.agent.post("/heroes", body: {
      "name": "Fred"
    });

    final badResponse = await harness.agent.post("/heroes", body: {
      "name": "Fred"
    });
    expectResponse(badResponse, 409);
  });



}
