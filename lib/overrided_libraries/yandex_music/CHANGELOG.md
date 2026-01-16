# Changelog

## [1.2.2] - 2025-12-30
### Added
- Added the ability to add/remove tracks from DislikedTracks
- The TrackSource enum has been added with OWN and UGC values.
- Fields have been added to the Track class: matchedTrack (If the track was uploaded by the user and the system recognized it as a track existing on the platform, then there will be a full-fledged Track object with the recognized track)

### Changed
- The Artist class is now abstract and the functionality has been split into UGCArtist and OfficialArtist.
- Track2 class renamed to ShortTrack
- The getAsBytes and getTrackDownloadInfo functions are hidden from prying eyes
- getTracks function now directly supports shortTrack transfer

### Fixed
- Fixed display of disliked tracks

## [1.2.1] - 2025-12-13
### Added
- My vibe

## [1.0.1] - 2025-08-27
### Changed
- Modified readme

## [1.0.0] - 2025-08-27
### Added
- Changing playlists
- Mark your favorite tracks
- Working with albums
- Search
- Receiving a landing page

### Changed
- Work with downloading tracks
- Name of some methods
- Improved handling of exceptions

## [0.0.3] - 2025-08-15

### Changed
- Added example `example.dart`
- Improved description of functions

## [0.0.2] - 2025-08-15

### Deleted
- Automatic track downloading functionality (WASM compatibility)

## [0.0.1] - 2025-08-15
### Added
- First release with basic functionality
- Obtaining account information
- Getting information about playlists
- Working with tracks
- Basic exceptions