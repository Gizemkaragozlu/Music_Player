import 'package:flutter/material.dart';
import 'package:music_player/Music.dart';
import 'package:music_player/MusicDetay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Music>> MusicGetir() async {
    var musicListesi = <Music>[];
//Bu arada image larda boşluk olmaz/oyle yapma
    var m1 = Music("Disfruto", "disfruto.jpg",
        "carla_morrison_disfruto_letra_mp3_60789.mp3");
    var m2 = Music(
        "All I Want", "all_i_want.jpg", "mtmrfz_all_i_want_mp3_63947.mp3");
    var m3 = Music("Impossible", "impossible.jpg",
        "james_arthur_impossible_lyrics_mp3_63981.mp3");
    var m4 = Music("Antidepresan", "antidepresan.jpg",
        "mert_demir_feat_mabel_matiz_antidepresan_mp3_64012.mp3");

    musicListesi.add(m1);
    musicListesi.add(m2);
    musicListesi.add(m3);
    musicListesi.add(m4);
    return musicListesi; //Veri kümemiz oluştu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Music",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 25),
          ),
        ),
      ),
      body: FutureBuilder<List<Music>>(
        future: MusicGetir(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            var musicListesi = snapshot.data; //Listeyi buraya aktardık
            return ListView.builder(
              itemCount: musicListesi!.length,
              itemBuilder: ((context, indeks) {
                var music = musicListesi[indeks];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MusicDetay(
                                    musicListesi: musicListesi,
                                    index: indeks,
                                  ))));
                    },
                    child: Card(
                      color: Colors.grey.shade700,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 50,
                              height: 50,
                              child:
                                  // .. (asset dosyası lib dosyası içinde olmadıgı için bir
                                  // üst dizinde olğu için yazılır)
                                  Image.asset("assets/${music.music_resim}")),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Text(
                                  music.music_adi,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              //SizeBox(height:50,),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ));
              }),
            );
          } else {
            return Center();
          }
        }),
      ),
    );
  }
}
