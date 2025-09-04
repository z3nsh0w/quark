import 'package:yandex_music/yandex_music.dart';

final String token = '';

YandexMusic yandexMusic = YandexMusic(token: token);
// Здесь указаны не все методы!
// Смотрите readme.md
void main() async {
  try {
    await yandexMusic.init();
    print('✅ Successfully initialized\n');
    
    await showAccountInfo();
    await showTracks();
    await showPlaylists();
    await search();
    
  } catch (e) {
    print('❌ Error: $e');
  }
}

Future<void> showAccountInfo() async {
  print('--- Account Information ---');
  
  try {
    int accountID = await yandexMusic.account.getAccountID();
    String accountLogin = await yandexMusic.account.getLogin();
    String fullName = await yandexMusic.account.getFullName();
    String displayName = await yandexMusic.account.getDisplayName();
    String userEmail = await yandexMusic.account.getEmail();
    bool? plusSubscriptionState = await yandexMusic.account.hasPlusSubscription();
    
    print("User's account id: $accountID");
    print("User's account login: $accountLogin");
    print("User's full name: $fullName");
    print("User's display name (nickname): $displayName");
    print("User's email: $userEmail");
    print("User's subscription: $plusSubscriptionState");
    print('');
    
  } catch (e) {
    print('Failed to get account info: $e\n');
  }
}

Future<void> showTracks() async {
  print('--- User Tracks ---');
  
  try {
    List likedTracks = await yandexMusic.usertracks.getLikedTracks();
    List dislikedTracks = await yandexMusic.usertracks.getDislikedTracks();
    
    print('Liked tracks count: ${likedTracks.length}');
    print('Disliked tracks count: ${dislikedTracks.length}');

    print('');
    
  } catch (e) {
    print('Failed to get tracks: $e\n');
  }
}

Future<void> showPlaylists() async {
  print('--- User Playlists ---');
  
  try {
    List playlists = await yandexMusic.playlists.getUsersPlaylists();
    print('Total playlists: ${playlists.length}');
    
    // Show first 5 playlists
    for (int i = 0; i < playlists.length && i < 5; i++) {
      var playlist = playlists[i];
      print('${i + 1}. ${playlist['title']} (${playlist['trackCount']} tracks)');
    }
    
    if (playlists.isNotEmpty) {
      // Get detailed info for first playlist
      var firstPlaylist = playlists[0];
      var playlistDetails = await yandexMusic.playlists.getPlaylist(firstPlaylist['kind']);
      print('\nFirst playlist details:');
      print('Title: ${playlistDetails['title']}');
      print('Description: ${playlistDetails['description'] ?? 'No description'}');
      print('Duration: ${playlistDetails['durationMs'] ?? 0}ms');
      
      // Try to get cover art
      String coverUrl = await yandexMusic.playlists.getPlaylistCoverArtUrl(
        firstPlaylist['kind'], 
        '300x300'
      );
      if (coverUrl.isNotEmpty) {
        print('Cover art: $coverUrl');
      }
    }
    print('');
    
  } catch (e) {
    print('Failed to get playlists: $e\n');
  }
}

Future<void> search() async {
  print('--- Search Examples ---');
  
  try {
    const query = 'The Beatles';
    
    // Search tracks
    var trackResults = await yandexMusic.search.tracks(query, 0);
    print('Search "$query" - Found ${trackResults['total']} tracks');
    
    if (trackResults['results'].isNotEmpty) {
      var firstTrack = trackResults['results'][0];
      var artists = firstTrack['artists']?.map((a) => a['name']).join(', ') ?? 'Unknown';
      print('Top track: ${firstTrack['title']} - $artists');
    }
    
    // Search artists
    var artistResults = await yandexMusic.search.artists(query, 0);
    print('Found ${artistResults['total']} artists');
    
    if (artistResults['results'].isNotEmpty) {
      var firstArtist = artistResults['results'][0];
      print('Top artist: ${firstArtist['name']}');
    }
    
    // Search albums
    var albumResults = await yandexMusic.search.albums(query, 0);
    print('Found ${albumResults['total']} albums');
    
    if (albumResults['results'].isNotEmpty) {
      var firstAlbum = albumResults['results'][0];
      print('Top album: ${firstAlbum['title']} - ${firstAlbum['artists']?[0]?['name'] ?? 'Unknown'}');
    }
    
    // Universal search
    print('\n--- Universal Search ---');
    var allResults = await yandexMusic.search.all('Imagine Dragons', 0);
    
    if (allResults['best'] != null) {
      var best = allResults['best'];
      print('Best result (${best['type']}): ${best['result']['title']}');
    }
    
    print('Artists found: ${allResults['artists']?['total'] ?? 0}');
    print('Tracks found: ${allResults['tracks']?['total'] ?? 0}');
    print('Albums found: ${allResults['albums']?['total'] ?? 0}');
    print('');
    
  } catch (e) {
    print('Search failed: $e\n');
  }
}

/// Example of getting track information
Future<void> getTrackInfo() async {
  print('--- Track Information ---');
  
  try {
    // Example with multiple track IDs
    List trackIds = ['12345', '67890']; // Replace with real track IDs
    
    var tracks = await yandexMusic.tracks.getTracks(trackIds);
    
    for (var track in tracks) {
      if (track != null) {
        var artists = track['artists']?.map((a) => a['name']).join(', ') ?? 'Unknown';
        print('${track['title']} - $artists (${track['durationMs']}ms)');
        
        // Get similar tracks
        var similar = await yandexMusic.tracks.getSimilarTracks(track['id']);
        print('Similar tracks: ${similar.length}');
      }
    }
    print('');
    
  } catch (e) {
    print('Failed to get track info: $e\n');
  }
}

/// Example of getting playlist recommendations
Future<void> getRecommendations() async {
  print('--- Playlist Recommendations ---');
  
  try {
    List playlists = await yandexMusic.playlists.getUsersPlaylists();
    
    if (playlists.isNotEmpty) {
      var firstPlaylistKind = playlists[0]['kind'];
      var recommendations = await yandexMusic.playlists.getRecomendationsForPlaylist(firstPlaylistKind);
      
      print('Recommendations for "${playlists[0]['title']}": ${recommendations.length} tracks');
      
      for (int i = 0; i < recommendations.length && i < 3; i++) {
        var track = recommendations[i];
        var artists = track['artists']?.map((a) => a['name']).join(', ') ?? 'Unknown';
        print('${i + 1}. ${track['title']} - $artists');
      }
    }
    print('');
    
  } catch (e) {
    print('Failed to get recommendations: $e\n');
  }
}