'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-512.png": "b95085b8f947dfb3832bd1cc30321cb3",
"icons/Icon-192.png": "3ed0322faa0a1d9803fe149b742eab28",
"icons/Icon-512.png": "b95085b8f947dfb3832bd1cc30321cb3",
"icons/Icon-maskable-192.png": "3ed0322faa0a1d9803fe149b742eab28",
"assets/FontManifest.json": "0849ad1ffae49468df21f1b1184b1c1a",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/assets/tiles/colored_bricks.tsx": "550af13acf62a8fde3b3f06f14569a2a",
"assets/assets/tiles/gameMap.tmx": "93d51520feb286dd22c08c95b183b5e2",
"assets/assets/tiles/Terrain%2520(16x16).tsx": "65afb2185d108b7edf97f18845c894d8",
"assets/assets/fonts/Sabo-Filled.otf": "92339ee0b5016accb9cb65787c60e628",
"assets/assets/fonts/Sabo-Regular.otf": "3659fdbfcec3dfb901f071dee53088a8",
"assets/assets/images/background/Blue.png": "f86e07aab82505fc49710152f83cc385",
"assets/assets/images/background/Purple.png": "f8cc6aa8fd738e6e4db8b6607b7e6c37",
"assets/assets/images/background/Yellow.png": "c3f96416e21f366bc0c3635ce5b530d5",
"assets/assets/images/background/Brown.png": "45c9c887fa73b0ade76974de63ab9157",
"assets/assets/images/background/Pink.png": "31b5e360eb9610c58138bb7cfdfb96a1",
"assets/assets/images/background/Green.png": "e6eeace8a9d516f2e9768e5228e824fb",
"assets/assets/images/background/Gray.png": "31fb9bc36ec926ee64d999d3387b7e09",
"assets/assets/images/app_icon.png": "f1cb6cce880bc1c6447bcba3a44663c6",
"assets/assets/images/Terrain%2520(16x16).png": "df891f02449c0565d51e2bf7823a0e38",
"assets/assets/images/brick_vfx/walk_dust_left.png": "4e070126efa025af020a8f135183872a",
"assets/assets/images/brick_vfx/jumpGlitch__dust_jump.png": "ba55458ba01da15a47b645ce5941c588",
"assets/assets/images/brick_vfx/death_explosion.png": "2c9fc23da2978ad835cb9fb3a06f356b",
"assets/assets/images/brick_vfx/walk_dust_right.png": "cab7034318df367b175928c0f640e689",
"assets/assets/images/brick_vfx/jumpA__dust_jump.png": "ba55458ba01da15a47b645ce5941c588",
"assets/assets/images/brick_vfx/jumpB__dust_jump.png": "ba55458ba01da15a47b645ce5941c588",
"assets/assets/images/brick_vfx/jumpA__dust_fall.png": "c052d00955ff4bbf8bf8ff4eaceb51b4",
"assets/assets/images/brick_vfx/jumpB__dust_fall.png": "fc52e7d629276708f1bb75bf9a7f506c",
"assets/assets/images/brick_vfx/jumpGlitch__dust_fall.png": "fc52e7d629276708f1bb75bf9a7f506c",
"assets/assets/images/colored_bricks.png": "2c1058628986247fb6c2666a0da0d58f",
"assets/assets/images/paddleboard/Paddle_board.png": "e6ffa7ebfa7501aeee70a10a53333014",
"assets/assets/images/paddleboard/Paddle_shaking.png": "4c197924fb1ff93fe70a7a8f71b7866f",
"assets/assets/images/colored_bricks/colored_brick_1.png": "f753114d9b59502cd46bbeb548e8da84",
"assets/assets/images/colored_bricks/colored_brick_3.png": "03149e990c11fed1430492ab65ffbf0c",
"assets/assets/images/colored_bricks/colored_brick_2.png": "f9203fa56efd2e5f5ea5c93fa5b6c10c",
"assets/assets/images/colored_bricks/colored_brick_5.png": "a5356736e6f4e946a5547ac119f4b9e2",
"assets/assets/images/colored_bricks/colored_vfx_explosion.png": "f5270f07baf100548acc1721b985ae7b",
"assets/assets/images/colored_bricks/colored_brick_4.png": "ad9c1e33b73b326a02a885b389edc5d4",
"assets/assets/images/ball/Ball_explosion_final.png": "792360421f389a715675abff4f2d662c",
"assets/assets/images/ball/Ball_mini_explosion_to_green.png": "810af6c817af49c8feb4932685ce66a4",
"assets/assets/images/ball/Ball_red_idle.png": "d059b3c7d0972e014cf0f0fcdf4527b1",
"assets/assets/images/ball/Ball_green_idle.png": "1f074ad507ac83cb66784e2e48100742",
"assets/assets/images/brick/brick_alive_antecipation.png": "0424fd59b18220514a2b16ed386924a2",
"assets/assets/images/brick/brick_alive_jump_a.png": "dde2acf5af352b3fa6f7b1355516a458",
"assets/assets/images/brick/brick_alive_idle.png": "df1670a63bf1bca84cb965a44dc60771",
"assets/assets/images/brick/brick_alive_turn_vertical.png": "8eeb2edf429b04b822e8bf1eb4b3442c",
"assets/assets/images/brick/brick_alive_walk.png": "c41d6617eff5b615c8558cb4d656630e",
"assets/assets/images/brick/brick_dead.png": "73554188a8422b927bc3927d03069404",
"assets/assets/images/brick/brick_base.png": "a712f84986156759e9e7e75f3c1ba408",
"assets/assets/images/brick/brick_alive_jump_b.png": "6a128696e539880dc3b87e14fadd32bb",
"assets/assets/images/brick/brick_glitch.png": "2d696cb90da871a7e66715e343942b4e",
"assets/assets/audio/jump.wav": "a18eeb91dce90dfdcb3c828b636159ae",
"assets/assets/audio/Three-Red-Hearts-Out-of-Time.mp3": "f91867de0acc87cc3d4c2de3af25dec1",
"assets/assets/audio/death.wav": "d586e268d7521425878cb168bbc0d1c7",
"assets/assets/audio/explosion.wav": "bb5d12f513c29941aa01c87368016a9b",
"assets/assets/audio/typing.mp3": "c9edfd07d43ba3efec73f0c1e277d3ca",
"assets/assets/audio/click.wav": "2de245cf63eb94409bd5d71a82b87807",
"assets/assets/audio/powerUp.wav": "2c3b420404b508fcfccd6a22b6812856",
"assets/assets/audio/Three-Red-Hearts-Pixel-War-2.mp3": "ecb6fcfac2b2dd0ccb395198f3915479",
"assets/fonts/MaterialIcons-Regular.otf": "3417dd3a1c29314e8cf6701a9ab65ca3",
"assets/AssetManifest.bin": "67d0b209a5b7d7bb451bb4774fab872d",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/AssetManifest.json": "e14f1f0710d10270ba474ce38c1c2d81",
"assets/NOTICES": "a71a9948ce67fb0b551ce7c2bda96bb4",
"index.html": "6a56d285d8d61b43c2c48af7df37b888",
"/": "6a56d285d8d61b43c2c48af7df37b888",
"main.dart.js": "412ed96934c7309bb0a3b57236b2afef",
"favicon.png": "f907beceff011a16234c224118760443",
"version.json": "2ed067033eaf537740c732b4606d39f2",
"favicon.ico": "b8af43ffd6a97854038b5a051b201d4a",
"canvaskit/skwasm.wasm": "1a074e8452fe5e0d02b112e22cdcf455",
"canvaskit/chromium/canvaskit.wasm": "be0e3b33510f5b7b0cc76cc4d3e50048",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/canvaskit.wasm": "42df12e09ecc0d5a4a34a69d7ee44314",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"manifest.json": "ddd95b05df231181a311b2d59b47e0fb",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
