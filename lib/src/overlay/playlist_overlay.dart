
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:quark/src/services/path_manager.dart';
// import 'package:quark/src/widgets/box_decorations.dart';
// import 'package:quark/src/yandex_music_modified/example/lib/example.dart';

// class PlaylistOverlayState {
//   final List<String> songs;
//   final List ymTracksInfo;
//   final ValueNotifier<int> nowPlayingIndexNotifier;
//   final Function(int) onTrackTap;
//   final Function() onRefresh;
//   final bool search;
//   final TextEditingController searchController;

//   PlaylistOverlayState({
//     required this.songs,
//     required this.ymTracksInfo,
//     required this.nowPlayingIndexNotifier,
//     required this.onTrackTap,
//     required this.onRefresh,
//     required this.search,
//     required this.searchController,
//   });
// }

// class PlaylistOverlay extends StatefulWidget {
//   final PlaylistOverlayState overlayState;
//   final Animation<Offset> offsetAnimation;
//   final VoidCallback onClose;

//   const PlaylistOverlay({
//     super.key,
//     required this.overlayState,
//     required this.offsetAnimation,
//     required this.onClose,
//   });

//   @override
//   State<PlaylistOverlay> createState() => _PlaylistOverlayState();
// }


// class _PlaylistOverlayState extends State<PlaylistOverlay> {
//   late List<String> playlistView;

//   @override
//   void initState() {
//     super.initState();
//     playlistView = widget.overlayState.songs;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 0,
//       child: SlideTransition(
//         position: widget.offsetAnimation,
//         child: Material(
//           color: Colors.transparent,
//           child: GestureDetector(
//             onHorizontalDragEnd: (details) {
//               if (details.primaryVelocity!.abs() > 500) {
//                 widget.onClose();
//               }
//             },
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
//                 child: Container(
//                   width: 400,
//                   height: MediaQuery.of(context).size.height,
//                   decoration: overlayBoxDecoration(),
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 50),
//                         child: ListView.builder(
//                           itemCount: playlistView.length + 1,
//                           itemBuilder: (context, index) {
//                             if (!widget.overlayState.search && index == 0) {
//                               return Container();
//                             }
//                             if (widget.overlayState.search && index == 0) {
//                               return _buildSearchField();
//                             }
//                             return _buildTrackTile(index - 1);
//                           },
//                         ),
//                       ),
//                       _buildOverlayHeader(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return ListTile(
//       title: TextField(
//         cursorColor: Colors.white.withOpacity(0.8),
//         controller: widget.overlayState.searchController,
//         style: TextStyle(
//           color: Colors.white.withOpacity(0.8),
//         ),
//         decoration: InputDecoration(
//           hintText: 'Search',
//           hintStyle: TextStyle(
//             color: Colors.white.withOpacity(0.7),
//             fontSize: 16,
//           ),
//           border: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.white.withOpacity(0.3),
//               width: 1,
//             ),
//           ),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.white.withOpacity(0.3),
//               width: 1,
//             ),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.white.withOpacity(0.5),
//               width: 1.5,
//             ),
//           ),
//           filled: false,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//         onChanged: (query) => _handleSearch(query),
//       ),
//     );
//   }

//   Widget _buildTrackTile(int index) {
//     String trackID = PathManager.getFileName(playlistView[index])
//         .replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');

//     Map? foundMap = widget.overlayState.ymTracksInfo.firstWhere(
//       (map) => map['id'] == trackID,
//       orElse: () => null,
//     );

//     var name = foundMap?['title'] ?? 'Unknown';
//     var artist = foundMap?['artists'] ?? 'Unknown';
//     var image1 = foundMap != null 
//         ? 'https://${foundMap['cover']}'
//         : 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/unknown-cd-album-mixtape-cover-design-templat-template-a0089f026a71f9722a55157364f22590_screen.jpg?ts=1644153606';

//     return ListTile(
//       title: Row(
//         children: [
//           Container(
//             height: 55,
//             width: 55,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: CachedNetworkImageProvider(image1),
//                 fit: BoxFit.cover,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color.fromARGB(255, 21, 21, 21),
//                   blurRadius: 10,
//                   offset: Offset(5, 10),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 Text(
//                   artist,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           ValueListenableBuilder<int>(
//             valueListenable: widget.overlayState.nowPlayingIndexNotifier,
//             builder: (context, currentIndex, child) {
//               return AnimatedOpacity(
//                 opacity: (currentIndex == index) ? 1.0 : 0.0,
//                 duration: Duration(milliseconds: 650),
//                 curve: Curves.easeInOut,
//                 child: Icon(Icons.play_arrow_sharp, color: Colors.grey),
//               );
//             },
//           ),
//         ],
//       ),
//       onTap: () => widget.overlayState.onTrackTap(index),
//     );
//   }

//   Widget _buildOverlayHeader() {
//     // return Positioned(
//     //   top: 10,
//     //   right: 10,
//     //   child: IconButton(
//     //     icon: Icon(Icons.close, color: Colors.white.withOpacity(0.8)),
//     //     onPressed: widget.onClose,
//     //   ),
//     // );
//     return Expanded(child: 
//       Row(
//         children: [
//           IconButton(icon: Icon(Icons.search), onPressed: () {
            
//           },),

//           Text('Playlist', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24),),

//           IconButton(
//         icon: Icon(Icons.close, color: Colors.white.withOpacity(0.8)),
//         onPressed: widget.onClose,
//       ),
//         ],
//       )
//     );
//   }

//   void _handleSearch(String query) {
//     final suggestions = widget.overlayState.songs.where((info) {
//       String trackID = PathManager.getFileName(info)
//           .replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');

//       Map? foundMap = widget.overlayState.ymTracksInfo.firstWhere(
//         (map) => map['id'] == trackID,
//         orElse: () => null,
//       );

//       var name = foundMap?['title'] ?? 'Unknown';
//       return name.toLowerCase().contains(query.toLowerCase());
//     }).toList();

//     setState(() {
//       playlistView = suggestions;
//     });
//   }
// }