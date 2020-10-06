import 'package:aqueduct/aqueduct.dart';
import 'package:heroes/heroes.dart';
import 'package:heroes/model/hero.dart';

class HeroesController extends ResourceController {
  HeroesController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllHeroes({@Bind.query('name') String name}) async {
    final heroQuery = Query<Hero>(context);
    if (name != null) {
      heroQuery.where((h) => h.name).contains(name, caseSensitive: false);
    }
    final heroes = await heroQuery.fetch();

    return Response.ok(heroes);
  }

  @Operation.get('id')
  Future<Response> getHeroByID(@Bind.path('id') int id) async {
    final heroQuery = Query<Hero>(context)..where((h) => h.id).equalTo(id);

    final hero = await heroQuery.fetchOne();

    if (hero == null) {
      return Response.notFound();
    }

    return Response.ok(hero);

    // final hero =
    //     _heroes.firstWhere((hero) => hero['id'] == id, orElse: () => null);
    // if (hero == null) {
    //   return Response.notFound();
    // }

  }

  // @Operation.post()
  // Future<Response> createHero() async {
  //   final Map<String, dynamic> body = await request.body.decode();
  //   final query = Query<Hero>(context)..values.name = body['name'] as String;
  //
  //   final insertedHero = await query.insert();
  //
  //   return Response.ok(insertedHero);
  // }

  @Operation.post()
  Future<Response> createHero() async {
    final hero = Hero()..read(await request.body.decode(), ignore: ['id']);
    final query = Query<Hero>(context)..values = hero;

    final insertedHero = await query.insert();

    return Response.ok(insertedHero);
  }
}
