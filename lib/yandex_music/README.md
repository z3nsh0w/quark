![logo](https://github.com/z3nsh0w/yandex_music_flutter/blob/main/logo.png?raw=true)
<h1 align='center'>Simple, Robust & Full-Featured Yandex Music Library<br>created for Dart &  Flutter</h1>

**Library implements all popular core functions**, such as downloading lossless tracks, accessing "My Vibe (My Wave)", retrieving information, lyrics, artists, and albums, as well as performing searches, and more.

**To use yandex_music, you need to obtain an API token.** 

1. Official &&  Recommended method (if you are developing an application with an interface)
	The method consists of using WebView, redirecting the user to the [official Yandex authorization page](https://oauth.yandex.ru/authorize?response_type=token&client_id=23cabbbdc6cd418abb4b39c32c41195d), and tracking their movement.
	When the user logs in, the link will contain a token that can be used in the library.
	See the example at the example.dart.

  2. Alternative method
	Alternative methods for obtaining a token are described in [instructions for obtaining a token yourself](https://yandex-music.readthedocs.io/en/main/token.html).
	Important! There is no guarantee that the token will not fall into the wrong hands when using these methods. Use them at your own risk!

## Usage
You can see a complete example of using the library in the example.dart file.

