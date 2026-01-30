'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "8439beb8b1732c0a2985d22d90c57484",
".git/config": "920a11de313bfb8d93d81f4a3a5b71b6",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "721290001a2a43ebc7b55bf070af44e7",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "1349d4b382b8d538c6336f10563efc3b",
".git/logs/refs/heads/master": "1349d4b382b8d538c6336f10563efc3b",
".git/objects/00/6501c3d8016adc78d4209cb72f1f048f9c51bd": "2666eb3a7ac440a1b84c3f13a827cfe2",
".git/objects/04/9c05f4a419745597dcc9f3c7cf5a3fd859480e": "e00cc8a5628ff3edbae7c0bd316cc11c",
".git/objects/08/27c17254fd3959af211aaf91a82d3b9a804c2f": "360dc8df65dabbf4e7f858711c46cc09",
".git/objects/0b/bcf55801dcf4838166801faf398d96e2986343": "0df3c851dbc3dba966ef58f6fe8a0e49",
".git/objects/1d/5539245ca40adeda95a9e84e6752362b1c3b8a": "43da37df4cf876ccc264509f00b7cd24",
".git/objects/27/9806facd6bb14910bce0c19b2ed7fc4cbfb15d": "e14a5127c4217e63f20a26828b344a61",
".git/objects/31/024408ba3f15643d76648c6d18d4c18383b0af": "a51ec27c5286a39cbc16737a10b9e073",
".git/objects/3a/8cda5335b4b2a108123194b84df133bac91b23": "1636ee51263ed072c69e4e3b8d14f339",
".git/objects/3a/a247d307084ab42a590d92e4d7864daa94b885": "aa33f3c3bff92437ad77c43ab32b1067",
".git/objects/3c/f22393c38c690980363565d02eee59e1ff49e6": "1d4f7f5dff730839a45c9c99e0939a2b",
".git/objects/40/5f5e2aae00f01bc7e811b9085fde0bba93cfa5": "1d05f7b99de1df37f94fb610d5391685",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/48/374caf5b0005144debfc84ec59a115d0020a29": "a4e723c6f0f96b9b018a08689bcb3bc4",
".git/objects/49/7b8723538e9a202011fae0bd125463196fddc6": "7f2d80a147445dc8dcc09c1a8c9105a1",
".git/objects/51/03e757c71f2abfd2269054a790f775ec61ffa4": "d437b77e41df8fcc0c0e99f143adc093",
".git/objects/63/9a660ae17aff866ae3cdb5c23c6cd202d77c49": "89949d22b81d230f6162f440f9951b26",
".git/objects/66/c1268a395c19423fe57ea7075e4c4710717ec4": "691ab5012031fbbe404ce2d7bc596ace",
".git/objects/68/43fddc6aef172d5576ecce56160b1c73bc0f85": "2a91c358adf65703ab820ee54e7aff37",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6b/faa96eda2f1dba4fed694eb863471c0b8d381c": "5fc3dac06f3ab8b5a938924bdc801064",
".git/objects/6f/7661bc79baa113f478e9a717e0c4959a3f3d27": "985be3a6935e9d31febd5205a9e04c4e",
".git/objects/71/230eae10a1e56a5547742f163e254d42e4e6ee": "8c2df74e9b177a37681534aa0b17fba4",
".git/objects/7b/c4984d9bfbb1ec2f0eba090fadf4ec4db73f01": "e994528a0c8f7ae7de62d5e580cb3f4b",
".git/objects/7c/3463b788d022128d17b29072564326f1fd8819": "37fee507a59e935fc85169a822943ba2",
".git/objects/7d/855e22dc3b8e8fb890820034672b146d7cf983": "3a7daaf439901a198c5443a7134387d9",
".git/objects/85/18621e5662e01c4e26b3055346c8cc26a61008": "26b6d8d7a0081abf435f4bfc1e2376ad",
".git/objects/85/63aed2175379d2e75ec05ec0373a302730b6ad": "997f96db42b2dde7c208b10d023a5a8e",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/89/872b42c5c82c73f2ca14108d063311b2073234": "1497547fe5f62947b5dba8dfdd038b8f",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8c/5988199a70eace6c7d96e9fb7594dc49a679b4": "b18a9739ebbf315ecd90513d7a98c7b9",
".git/objects/8e/21753cdb204192a414b235db41da6a8446c8b4": "1e467e19cabb5d3d38b8fe200c37479e",
".git/objects/92/ad3715817b2cf53712e1d19aefd3f25befc70c": "dcfccb52ee6f14b7534fb17b26721af6",
".git/objects/93/b363f37b4951e6c5b9e1932ed169c9928b1e90": "c8d74fb3083c0dc39be8cff78a1d4dd5",
".git/objects/9c/3c5b4368e94e033e6206d2f238e949d6d5d687": "7001959cd4cd875daadd5f8e893168ce",
".git/objects/9e/1421a04ac6fc3f2d59e3bc02a4622f85db0eaf": "f402d8403df555e3cee11e177444b0c4",
".git/objects/a4/228d59f0ecd3be28d9f9984723e50c2d5de5e5": "c6cba7089f5a8b81643fc9895262342e",
".git/objects/a7/3f4b23dde68ce5a05ce4c658ccd690c7f707ec": "ee275830276a88bac752feff80ed6470",
".git/objects/ad/ced61befd6b9d30829511317b07b72e66918a1": "37e7fcca73f0b6930673b256fac467ae",
".git/objects/ae/1daa3ade67045c85d80b7618ebd21ac60b6a64": "3ccb6f7d44cac0884916931e43ccb629",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/3e39bd49dfaf9e225bb598cd9644f833badd9a": "666b0d595ebbcc37f0c7b61220c18864",
".git/objects/ba/f3122e09fdd204820d14a373a3cac084325fcd": "9943fca24d438e0c343995f94cf078aa",
".git/objects/bc/9eeceaa8977f99c0914656fbbeb4955e3f1866": "7230f0519e0dd9e035f2b6a895cda3b3",
".git/objects/bf/e9e03d1e0f3608a0f5e6fbff5829729c10c38c": "7f8bec96f323aa1eea2fbcfb9955a827",
".git/objects/bf/fd3be2f756a61e7e5496c64a125927f7aca1d9": "44c0035a1cfc75ea97c0bcef3f6285cd",
".git/objects/c4/3d15375c0950b87f355e37d95aa4f39f72c30b": "afff3eab695d8fdb46d82a3687e48d32",
".git/objects/c6/466d4d31941ebc621b6946db7dd6bc6d5104d7": "6c66f73e974a1dd93a9cfdde114c46c7",
".git/objects/c7/187a75ddad72c64eb99f8d3752651233988205": "4e4a3df5d1e5881db3642105e8374085",
".git/objects/c8/3af99da428c63c1f82efdcd11c8d5297bddb04": "144ef6d9a8ff9a753d6e3b9573d5242f",
".git/objects/ca/f6fb3c5ad0419461163bf2d15b603d22cd71a1": "8ddc0102355dffef62c94efcd8cc3990",
".git/objects/d2/cbf0c66899021712873be397f667866b79c27e": "6016873866202e1d16959c60885fa78f",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/2bdb74ed6abad282bc6c32974c7531ab5c33b3": "e061100f43b351a17283384a99bc146b",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d8/53aa55540c8bb644fbd1d6b7be61f8cb89f0e7": "18c43f82b93b2bee7dba799c1c40a5fe",
".git/objects/d9/5b1d3499b3b3d3989fa2a461151ba2abd92a07": "a072a09ac2efe43c8d49b7356317e52e",
".git/objects/e6/14a46403d6a751d747beeb52dc738e7e3cc327": "b95134c6f3644eaa1840bc748d44d25d",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f3/3e0726c3581f96c51f862cf61120af36599a32": "afcaefd94c5f13d3da610e0defa27e50",
".git/objects/f3/ee172f487a6da75b98cc43df158ff0d6571d20": "1ed6e7c5441b6c8d03125d954986025f",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f6/e6c75d6f1151eeb165a90f04b4d99effa41e83": "95ea83d65d44e4c524c6d51286406ac8",
".git/objects/fd/05cfbc927a4fedcbe4d6d4b62e2c1ed8918f26": "5675c69555d005a1a244cc8ba90a402c",
".git/refs/heads/master": "6869a30707cb69ec9f448f997bff71ea",
"assets/AssetManifest.bin": "7b9e3ee07b1a06f89896a28864cb8e62",
"assets/AssetManifest.bin.json": "aaa6e8c99bbecc301326efbaff721a8e",
"assets/assets/cuv.json": "ca94fa479cee48a07e4ff77cda9323f6",
"assets/assets/cuvmp.json": "ea8f4acaae8b0ec5171f91d3f2a80902",
"assets/assets/niv.json": "f17e7396024e86eb406e5b35ebeffade",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "088273582258b17406bc68acc5085993",
"assets/NOTICES": "f95b4f9267cd79cadbca7aab496b9b97",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "9dc1b60a1800c2e0bce390ea1790ea88",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "a18ff37f1a95ae6e5748cc84169a7808",
"/": "a18ff37f1a95ae6e5748cc84169a7808",
"main.dart.js": "df48ecf5e74375d1c6a56b5e4f7c3731",
"manifest.json": "b8347d177b75c01f52916df9fd0c4384",
"version.json": "deb178b09fed7d48e8631f2350276dea"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
