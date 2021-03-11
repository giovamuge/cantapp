import 'package:flutter/material.dart';

class DisclaimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                    "Lo scopo di questo sito \u00E8 quello di supportare i vari gruppi parrocchiali all'animazione delle liturgie attraverso l'uso di nuovi strumenti. Il sito non ha fini di lucro e gli accordi inseriti non sono tratti da alcuna pubblicazione ma sono una libera interpretazione di diversi gruppi parrocchiali.\r\n\r\nGli autori che non desiderano le loro opere apparire in questa raccolta, possono ottenerne la rimozione inviando una richiesta al seguente indirizzo email: canticristiani.libretto@gmail.com. Una volta accertata l'identit\u00E0 del richiedente i contenuti saranno rimossi entro 24 ore.\r\n\r\nGli accordi contenuti nel sito sono liberamente rielaborati dai componenti dei vari cori parrocchiali e quindi non rappresentano una copia degli spartiti originali protetti dal diritto d'autore. La tutela dei diritti d'autore relativa invece ai video pubblicati \u00E8 demandata al sito dal quale sono stati tratti, www.youtube.com.\r\n\r\nSi invita a leggere l'accordo tra Youtube e SIAE pubblicato sul seguente sito http:\/\/it.wikipedia.org\/wiki\/YouTube\r\n\r\nRIFERIMENTO LEGISLATIVO\r\n\r\nIn base alla LEGGE del 22 maggio 1993 n. 159 tutto il materiale presente su questo sito \u00E8 da intendersi per scopi esclusivamente didattici, di studio e di ricerca attraverso lo scambio di informazioni tra i diversi utenti del sito e dell'app. Tutti i canti contenuti nel database sono il frutto di lavoro creativo personale dei singoli utenti e non sussistono pertanto atti lesivi di qualsivoglia diritto d\u2019autore."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
