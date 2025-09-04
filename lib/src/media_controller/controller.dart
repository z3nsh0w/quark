
import 'dart:io';

import 'package:smtc_windows/smtc_windows.dart';
import 'package:audio_service_mpris/audio_service_mpris.dart';
import 'package:audio_service/audio_service.dart';

import 'package:quark/src/media_controller/src/unix/audio_handler.dart';
import 'package:quark/src/media_controller/src/windows/audio_handler.dart';





// class UnixController {
//   late AudioHandler _audioHandler;


//   Future<dynamic> init() async {
//     _audioHandler = await AudioService.init(
//       builder:
//           () => MyAudioHandler(
//             onPlay:
//                 () => setState(() {
//                   steps(stopSteps: true);
//                 }),
//             onPause:
//                 () => setState(() {
//                   steps(stopSteps: true);
//                 }),
//             onNext:
//                 () => setState(() {
//                   steps(nextStep: true);
//                 }),
//             onPrevious:
//                 () => setState(() {
//                   steps(previousStep: true);
//                 }),
//             onSeek: (position) => setState(() => {}),
//           ),
//       config: AudioServiceConfig(
//         androidNotificationChannelId: 'quark.quarkaudio.app.channel.audio',
//         androidNotificationChannelName: 'Audio playback',
//         androidNotificationOngoing: true,
//       ),
//     );
//   }


//   Future<void> updateSMTC() async {
//     Duration? nullableDuration = await player.getDuration();
//     Duration duration = nullableDuration ?? Duration.zero;
//     await (_audioHandler as MyAudioHandler).setPlayback(
//       trackName,
//       trackArtistNames?.join(', ') ?? 'Unknown',
//       'album',
//       duration,
//       albumArtUri,
//       nowPlayingIndex.toString(),
//     );
//   }
// }




