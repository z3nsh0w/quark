import 'package:flutter/material.dart';
BoxDecoration buttonDecoration() {
  return const BoxDecoration(
    color: Color.fromARGB(31, 255, 255, 255),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  );
}


// Widget desktopWidget(
//   // BuildContext context,
//   String albumArtUri,
//   Color albumArtShadowColor,
//   String trackTitle,
//   String trackArtistNames,
//   InteractiveSliderController positionController,
//   String currentPosition,
//   double songProgress,
//   String totalSongDuration,
//   bool isSliderActive,
//   Function(double value) changePosition,
//   bool isPlayling,
//   Function(double value) changeVolume,
//   double volumeValue,
//   bool isLiked,
//   bool isPlaylistOpened,
//   bool isRepeatEnable,
//   bool isShuffleEnable,
//   VoidCallback onPlaylistToggle,
//   Function({bool next, bool previous, bool playpause, bool reload}) changeTrack,
//   Function() updateSlider
// ) {
//   print('updated');
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,

//     children: [
//       Container(
//         height: 255,
//         width: 255,

//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: CachedNetworkImageProvider(albumArtUri),
//             fit: BoxFit.cover,

//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0),
//               BlendMode.darken,
//             ),
//           ),

//           boxShadow: [
//             BoxShadow(
//               color: albumArtShadowColor,
//               blurRadius: 10,
//               offset: Offset(5, 10),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 20),

//       SizedBox(
//         width: 500,

//         child: SizedBox(
//           height: 45,
//           child: Text(
//             trackTitle,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       Text(
//         trackArtistNames,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.w300,
//         ),
//       ),

//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             currentPosition,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 15,
//               fontWeight: FontWeight.w300,
//             ),
//           ),

//           SizedBox(
//             width: 325,

//             child: InteractiveSlider(
//               controller: positionController,
//               unfocusedHeight: 5,
//               focusedHeight: 10,
//               min: 0.0,
//               max: 100.0,
//               onProgressUpdated: (value) {isSliderActive = true; changePosition(value); print(value);},
//               onFocused: (value) {updateSlider();},              

//               brightness: Brightness.light,
//               initialProgress: songProgress,
//               iconColor: Colors.white,
//               gradient: LinearGradient(colors: [Colors.white, Colors.white]),
//               shapeBorder: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(8)),
//               ),
//             ),
//           ),

//           Text(
//             totalSongDuration,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 15,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//         ],
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Material(
//             color: Colors.transparent,
//             borderRadius: BorderRadius.all(Radius.circular(30)),

//             child: InkWell(
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               onTap: () async {
//                 changeTrack(previous: true);
//               },

//               child: Container(
//                 height: 40,
//                 width: 40,

//                 decoration: buttonDecoration(),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.skip_previous, color: Colors.white, size: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(width: 15),

//           Material(
//             color: Colors.transparent,
//             borderRadius: BorderRadius.all(Radius.circular(30)),

//             child: InkWell(
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               onTap: () async {
//                 changeTrack(playpause: true);
//               },

//               child: Container(
//                 height: 50,
//                 width: 50,

//                 decoration: buttonDecoration(),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       isPlayling ? Icons.pause : Icons.play_arrow,
//                       color: Colors.white,

//                       size: 28,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(width: 15),

//           Material(
//             color: Colors.transparent,
//             borderRadius: BorderRadius.all(Radius.circular(30)),

//             child: InkWell(
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               onTap: () async {
//                 // await steps(nextStep: true);
//                 changeTrack(next: true);
//               },
//               child: Container(
//                 height: 40,
//                 width: 40,

//                 decoration: buttonDecoration(),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.skip_next, color: Colors.white, size: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       SizedBox(height: 10),

//       SizedBox(
//         width: 325,

//         child: InteractiveSlider(
//           startIcon: const Icon(Icons.volume_down),
//           endIcon: const Icon(Icons.volume_up),
//           min: 0.0,
//           max: 1.0,
//           brightness: Brightness.light,
//           initialProgress: volumeValue,
//           iconColor: Colors.white,
//           gradient: LinearGradient(colors: [Colors.white, Colors.white]),
//           onChanged: (value) => changeVolume(value),
//         ),
//       ),
//       SizedBox(height: 10),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           functionPlayerButton(
//             Icons.featured_play_list_outlined,
//             Icons.featured_play_list_outlined,
//             isPlaylistOpened,
//             onPlaylistToggle,
//           ),
//           SizedBox(width: 15),
//           functionPlayerButton(
//             Icons.shuffle,
//             Icons.shuffle_outlined,
//             isShuffleEnable,
//             () {},
//           ),
//           SizedBox(width: 15),
//           functionPlayerButton(
//             Icons.favorite_outlined,
//             Icons.favorite_outlined,
//             isLiked,
//             () {},
//           ),
//           SizedBox(width: 15),
//           functionPlayerButton(
//             Icons.repeat_one_outlined,
//             Icons.repeat_one_outlined,
//             isRepeatEnable,
//             () {},
//           ),
//           SizedBox(width: 15),
//         ],
//       ),
//     ],
//   );
// }

Widget functionPlayerButton(
  IconData enabledIcon,
  IconData disabledIcon,
  bool isEnable,
  Function() onTap,
  [Key? key,]
) {
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(30)),

    child: InkWell(
      borderRadius: BorderRadius.circular(30),

      onTap: onTap,
      
      child: Container(
        height: 35,
        width: 35,

        decoration: BoxDecoration(
          color: Color.fromARGB(31, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 120),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.center,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
              child: Icon(
                isEnable ? enabledIcon : disabledIcon,
                key: ValueKey<bool>(isEnable),
                color: isEnable
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(255, 255, 255, 0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


// Widget playerWidget(
//   albumArtUri,
//   albumArtShadowColor,
//   trackTitle,
//   trackArtistNames,
//   positionController,
//   currentPosition,
//   songProgress,
//   totalSongDuration,
//   isSliderActive,
//   Function(double value) changePosition,
//   bool isPlayling,
//   Function(double value) changeVolume,
//   double volumeValue,
//   bool isLiked,
//   bool isPlaylistOpened,
//   bool isRepeatEnable,
//   bool isShuffleEnable,
//   Function() onPlaylistToggle,
//   Function({bool next, bool previous, bool playpause, bool reload}) changeTrack,
//   Function() updateSlider
// ) {
//   if (Platform.isAndroid) {
//     return SizedBox();
//   } else {
//     return desktopWidget(
//       albumArtUri,
//       albumArtShadowColor,
//       trackTitle,
//       trackArtistNames,
//       positionController,
//       currentPosition,
//       songProgress,
//       totalSongDuration,
//       isSliderActive,
//       changePosition,
//       isPlayling,
//       changeVolume,
//       volumeValue,
//       isLiked,
//       isPlaylistOpened,
//       isRepeatEnable,
//       isShuffleEnable,
//       onPlaylistToggle,
//       changeTrack,
//       updateSlider
//     );
//   }
// }