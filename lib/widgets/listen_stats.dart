// import 'package:animated_digit/animated_digit.dart';
// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
// import 'package:quark/services/cached_images.dart';
// import '../services/listen_logger.dart';
// import 'dart:ui';
// import 'dart:math';

// class ListenStatsWidget extends StatefulWidget {
//   final Isar database;
//   const ListenStatsWidget({super.key, required this.database});
//   @override
//   State<StatefulWidget> createState() => _ListenStats();
// }

// class _ListenStats extends State<ListenStatsWidget> {
//   List<Map<PlayerTrack1, PlayerTrackStat>> allTimeStat = [];
//   String? errorMessage;

//   void update() async {
//     if (!ListenStats().inited) {
//       Logger('ListenStatsWidget').severe(
//         'The LoggerStats class was not initialized, but the widget was opened.',
//       );
//       errorMessage =
//           'An error has occurred. \nYou may have disabled statistics collection.';
//       return;
//     }

//     final stats = await ListenStats().getAllStats();
//     setState(() {
//       allTimeStat = stats;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     update();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 600;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(color: Colors.white),
//         titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
//         actionsIconTheme: IconThemeData(color: Colors.white),
//       ),
//       backgroundColor: const Color.fromARGB(255, 12, 12, 12),

//       body: Center(
//         child: ClipRRect(
//           borderRadius: const BorderRadius.all(Radius.circular(15)),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
//             child: Container(
//               width: min(size.width * 0.92, 1040),
//               height: min(size.height * 0.92, 1036),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.2),
//                   width: 1,
//                 ),
//                 borderRadius: const BorderRadius.all(Radius.circular(20)),
//                 gradient: LinearGradient(
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Colors.white.withOpacity(0.15),
//                     Colors.white.withOpacity(0.05),
//                   ],
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   if (errorMessage != null) ...[
//                     SizedBox(height: 20),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white.withAlpha(10),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       padding: EdgeInsets.all(15),
//                       child: Text(
//                         errorMessage!,
//                         style: TextStyle(color: Colors.red),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],

//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: isSmallScreen ? 16 : 24,
//                       horizontal: 20,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {},
//                           borderRadius: BorderRadius.circular(8),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 10,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text(
//                               'Year',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 5),
//                         InkWell(
//                           onTap: () {},
//                           borderRadius: BorderRadius.circular(8),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 10,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text(
//                               'All time',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 5),
//                         InkWell(
//                           onTap: () {},
//                           borderRadius: BorderRadius.circular(8),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 10,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text(
//                               'Month',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isSmallScreen ? 16 : 32,
//                         vertical: isSmallScreen ? 8 : 16,
//                       ),
//                       child: AllTimeStats(allTimeStat: allTimeStat),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AllTimeStats extends StatefulWidget {
//   final List<Map<PlayerTrack1, PlayerTrackStat>> allTimeStat;

//   const AllTimeStats({super.key, required this.allTimeStat});

//   @override
//   State<StatefulWidget> createState() => _AllTimeStats();
// }

// class YearStats extends StatefulWidget {

//   const YearStats({super.key});
//   @override
//   State<StatefulWidget> createState() => _YearStats();
// }

// class MonthStats extends StatefulWidget {
//   const MonthStats({super.key});
//   @override
//   State<StatefulWidget> createState() => _MonthStats();
// }

// class _AllTimeStats extends State<AllTimeStats> {
//   int value = 0;
//   String valueDesc = 'seconds';

//   MapEntry<PlayerTrack1, int>? mostPopular;
//   MapEntry<String, int>? mostPopularArtist;

//   @override
//   void initState() {
//     super.initState();
//     _calculateTotal();
//     _findPopular();
//   }

//   @override
//   void didUpdateWidget(covariant AllTimeStats oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.allTimeStat != oldWidget.allTimeStat) {
//       _calculateTotal();
//       _findPopular();
//     }
//   }

//   void _calculateTotal() {
//     int total = 0;
//     for (var entry in widget.allTimeStat) {
//       total += entry.entries.first.value.playedSeconds;
//     }

//     if (total > 3600) {
//       setState(() {
//         value = (total / 3600).round();
//         valueDesc = value > 1 ? 'hours' : 'hour';
//       });
//       return;
//     } else if (total > 60) {
//       setState(() {
//         value = (total / 60).round();
//         valueDesc = 'minutes';
//       });
//       return;
//     }

//     setState(() {
//       value = total;
//     });
//   }

//   void _findPopular() async {
//     if (!ListenStats().inited) {
//       Logger('ListenStatsWidget').severe(
//         'The LoggerStats class was not initialized, but the widget was opened.',
//       );
//       return;
//     }

//     ListenStats().getMostPlayedTrack().then(
//       (onValue) => setState(() {
//         mostPopular = onValue;
//       }),
//     );
//     ListenStats().getMostPlayedArtist().then(
//       (onValue) => setState(() {
//         mostPopularArtist = onValue;
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 600;

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(
//               vertical: isSmallScreen ? 18 : 24,
//               horizontal: 16,
//             ),
//             child: Column(
//               children: [
//                 StretchTextAnimation(
//                   text: 'LISTEN COUNT',
//                   fontSize: isSmallScreen ? 24 : 32,
//                 ),
//                 SizedBox(height: isSmallScreen ? 12 : 16),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AnimatedDigitWidget(
//                       value: value,
//                       textStyle: TextStyle(
//                         color: Colors.white,
//                         fontSize: isSmallScreen ? 48 : 64,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       valueDesc,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: isSmallScreen ? 20 : 24,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           if (mostPopular != null) ...[
//             SizedBox(height: isSmallScreen ? 32 : 48),
//             Container(
//               padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//               margin: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.1),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   StretchTextAnimation(
//                     text: 'YOUR TOP TRACK',
//                     fontSize: isSmallScreen ? 18 : 24,
//                   ),
//                   SizedBox(height: isSmallScreen ? 20 : 32),
//                   LayoutBuilder(
//                     builder: (context, constraints) {
//                       if (isSmallScreen || constraints.maxWidth < 500) {
//                         return Column(
//                           children: [
//                             _buildAlbumCoverForMostPopularTrack(isSmallScreen),
//                             const SizedBox(height: 20),
//                             _buildTrackInfo(isSmallScreen),
//                           ],
//                         );
//                       } else {
//                         return Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildAlbumCoverForMostPopularTrack(false),
//                             const SizedBox(width: 24),
//                             Expanded(child: _buildTrackInfo(false)),
//                           ],
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],

//           if (mostPopularArtist != null) ...[
//             SizedBox(height: isSmallScreen ? 32 : 48),
//             Container(
//               padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//               margin: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.1),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   StretchTextAnimation(
//                     text: 'YOUR TOP ARTIST',
//                     fontSize: isSmallScreen ? 18 : 24,
//                   ),
//                   SizedBox(height: isSmallScreen ? 20 : 32),
//                   LayoutBuilder(
//                     builder: (context, constraints) {
//                       if (isSmallScreen || constraints.maxWidth < 500) {
//                         return Column(
//                           children: [
//                             _buildAlbumCoverForMostPopularTrack(isSmallScreen),
//                             const SizedBox(height: 20),
//                             _buildArtistInfo(isSmallScreen),
//                           ],
//                         );
//                       } else {
//                         return Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildAlbumCoverForMostPopularTrack(false),
//                             const SizedBox(width: 24),
//                             Expanded(child: _buildArtistInfo(false)),
//                           ],
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],

//           SizedBox(height: isSmallScreen ? 24 : 32),
//         ],
//       ),
//     );
//   }

//   Widget _buildAlbumCoverForMostPopularTrack(bool isSmallScreen) {
//     final coverSize = isSmallScreen ? 160.0 : 137.0;

//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: mostPopular!.key.source == Source.yandexMusic
//             ? CachedImage(
//                 coverUri:
//                     'https://${mostPopular!.key.cover.replaceAll('%%', '1000x1000')}',
//                 height: coverSize,
//                 width: coverSize,
//               )
//             : Container(
//                 height: coverSize,
//                 width: coverSize,
//                 color: Colors.white.withOpacity(0.1),
//                 child: const Icon(
//                   Icons.music_note,
//                   size: 80,
//                   color: Colors.white54,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildTrackInfo(bool isSmallScreen) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: isSmallScreen
//           ? CrossAxisAlignment.center
//           : CrossAxisAlignment.start,
//       children: [
//         Text(
//           mostPopular!.key.title,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w800,
//             fontSize: isSmallScreen ? 20 : 24,
//             height: 1.2,
//           ),
//           textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           mostPopular!.key.artists.isNotEmpty
//               ? mostPopular!.key.artists.join(', ')
//               : 'Unknown artist',
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontWeight: FontWeight.w500,
//             fontSize: isSmallScreen ? 14 : 16,
//           ),
//           textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         if (mostPopular!.key.albums.isNotEmpty) ...[
//           const SizedBox(height: 4),
//           Text(
//             mostPopular!.key.albums.join(', '),
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.6),
//               fontWeight: FontWeight.w400,
//               fontSize: isSmallScreen ? 12 : 14,
//             ),
//             textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//         const SizedBox(height: 16),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             'Listened for ${(mostPopular!.value / 60).round()} minutes',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontSize: isSmallScreen ? 12 : 14,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildArtistInfo(bool isSmallScreen) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: isSmallScreen
//           ? CrossAxisAlignment.center
//           : CrossAxisAlignment.start,
//       children: [
//         Text(
//           mostPopularArtist!.key,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w800,
//             fontSize: isSmallScreen ? 20 : 24,
//             height: 1.2,
//           ),
//           textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           mostPopularArtist!.key,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontWeight: FontWeight.w500,
//             fontSize: isSmallScreen ? 14 : 16,
//           ),
//           textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         const SizedBox(height: 16),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             'Listened for ${(mostPopularArtist!.value / 60).round()} minutes',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontSize: isSmallScreen ? 12 : 14,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _YearStats extends State<YearStats> {
//   @override
//   Widget build(BuildContext context) {
//     throw UnimplementedError();
//   }
// }

// class _MonthStats extends State<MonthStats> {
//   @override
//   Widget build(BuildContext context) {
//     throw UnimplementedError();
//   }
// }

// class StretchTextAnimation extends StatelessWidget {
//   final String text;
//   final Duration duration;
//   final Curve curve;
//   final double fontSize;

//   const StretchTextAnimation({
//     super.key,
//     required this.text,
//     this.fontSize = 32.0,
//     this.duration = const Duration(milliseconds: 800),
//     this.curve = Curves.easeInOutQuint,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween<double>(begin: 0.3, end: 1),
//       duration: duration,
//       curve: curve,
//       builder: (context, scaleX, child) {
//         return Transform.scale(
//           scaleX: scaleX,
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: Colors.white,
//               letterSpacing: 1.2,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       },
//     );
//   }
// }
