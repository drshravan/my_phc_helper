'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "52379613aa8d499d62bacd7d8efde1f4",
".git/config": "d261836b7ba642d0b6b8a05e468b0b2c",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
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
".git/index": "5c7ebd84e7e09997590207997a5206d6",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "319b599954284d1311680835ea2424ba",
".git/logs/refs/heads/gh-pages": "e7625dc1f73b6bcc0d2dc9fc4f443fcf",
".git/logs/refs/heads/main": "e7b14dfe39a6455434dd6691a381ed55",
".git/logs/refs/heads/master": "ec98c3a0c29d6ed242e41025774cc901",
".git/logs/refs/remotes/origin/gh-pages": "5c32bc5c5c7b4778d809619fe5a06b99",
".git/objects/08/27c17254fd3959af211aaf91a82d3b9a804c2f": "360dc8df65dabbf4e7f858711c46cc09",
".git/objects/0b/0dffcd822bd24e2c7e6b34f2d2862143d697cc": "23329da976966e5bab830f28e3ab61df",
".git/objects/0f/7b8752ede6c4d1b62319d090d3edcb7b1d3d56": "e7ea237a767b282a75a6e5511410abd0",
".git/objects/1a/246e42b9a62f00ef9b380bb3671e6a04fc1de2": "efb0d630154a59af9ea0a50080b7950a",
".git/objects/20/183732fc7708dab193ef7cf546cf10ba393ad8": "4490a43eb00cfa1906b96b8e6ae51bb7",
".git/objects/20/a163b6809633525f70dfa5183466d9895be83a": "0135624b6a76816d799a3af8b373955c",
".git/objects/32/0f96b068f6e75b2e774c7ddfbbe8e22e40955e": "a312b5881a75e675ae2925a6a6b25f1b",
".git/objects/35/0238629326e83fb6eb807e011301c2ff5592a1": "1c2ff6e7c995066c266e4aa58b4b1f25",
".git/objects/37/b2f5ea17c2d1301c66e5dd50aa5b6f90af778e": "59a86624a9ce81f3a68a73bd9675cd0a",
".git/objects/38/b38ad6309370d7b8a4ef8f9ace9f853127d1c3": "2a5b22c754fd28dba43313c22e73754a",
".git/objects/38/f7c94c27b35f0bc30dfca803e4c146ab7bf84d": "df051593c4cbc133ce503b4a26089a58",
".git/objects/3a/8cda5335b4b2a108123194b84df133bac91b23": "1636ee51263ed072c69e4e3b8d14f339",
".git/objects/3b/adcfb63a40cf60fe6e463f88084410442738a8": "0adcd0c4e7ef441051c0be3f6fc754e8",
".git/objects/3f/ad3c354f03a51b66a75d08b9beba100b6d63e4": "1815c6f23e25777a43fed309109ee748",
".git/objects/42/a03d3fd5771df28dbe6f013036551c2c4a3929": "2c54946f6a3be5a22c0f1ac9ccc2c4c2",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/46/624e9ceba5293bc4e86c66e8708742c2686134": "00cb46cd1756e85ce46b05f847646134",
".git/objects/47/722a0c3a6579072d0705421d2966dc8dd73ee3": "c10b625503fe9bbe6cffa5a49c269b7f",
".git/objects/47/ba926039cd6163c6c86520c990bc257a1ee01f": "6e0a500eb282355aaa7942c45c3ae953",
".git/objects/48/ced445171b84f02bc7520f63dd429e5a1e6bce": "dc0640e4939f0553f1b828573f89cff7",
".git/objects/4a/d164392353ff45584afb0ebd45c5c58808552e": "aed43370e3d00f608c2eead0f36e3257",
".git/objects/51/03e757c71f2abfd2269054a790f775ec61ffa4": "d437b77e41df8fcc0c0e99f143adc093",
".git/objects/5b/417d97c39232efd021ea6227d59d136403d527": "ec64b0e7319088ac7b26fe0cec10a35c",
".git/objects/5f/ecd1901fbd66936b8e88e711a5e90887a608aa": "2c0abb4daa88f71a936f521051e7c17a",
".git/objects/64/b0bb6de4a1782cf6504d3bd965084131642292": "d8c37191f3ac0f3d78a37a532f87415f",
".git/objects/67/a9f2c6ec901c64cf21ce067ab6671140cef8e6": "8fa060a54317ba313f0df23b7318a631",
".git/objects/68/43fddc6aef172d5576ecce56160b1c73bc0f85": "2a91c358adf65703ab820ee54e7aff37",
".git/objects/69/dd618354fa4dade8a26e0fd18f5e87dd079236": "8cc17911af57a5f6dc0b9ee255bb1a93",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6f/7661bc79baa113f478e9a717e0c4959a3f3d27": "985be3a6935e9d31febd5205a9e04c4e",
".git/objects/70/56dc198e8bae27d98b9748a2482cde2e4501a7": "cc3a55574273b64f4a5eb8bfcc225dd9",
".git/objects/77/77abaf49357771cacbb622d1dd63c264879a39": "d7284ed6f84f1cbb24f7b26f1ab946b2",
".git/objects/78/e1c715bd4f03955148ef906c2d1519664ffe29": "c55bd9785200b808e8ea8f403a52955a",
".git/objects/7c/3463b788d022128d17b29072564326f1fd8819": "37fee507a59e935fc85169a822943ba2",
".git/objects/7d/afd78c574f8591818c45a76b786ec152815f0b": "6fa920865c8657e75cb255b91c4dae94",
".git/objects/7f/e3660560f0383e2acff64af874730f72de76cf": "d0c237f4f9fc33e788a427e03f93fa5e",
".git/objects/80/b62a6715aa2a097edfa3569673acd1b8d58a60": "be1c4a0753fb9d9b28903c9fb042e5e9",
".git/objects/82/aef68bd2a9c126247ba19014ea840e81f92da2": "9682e786ddb2d9d82002f3a918b7d747",
".git/objects/85/63aed2175379d2e75ec05ec0373a302730b6ad": "997f96db42b2dde7c208b10d023a5a8e",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8d/b92f151764e58a34f36db500f89f16524d2258": "5ef33c5163847cdc5094874d93de3dae",
".git/objects/8e/21753cdb204192a414b235db41da6a8446c8b4": "1e467e19cabb5d3d38b8fe200c37479e",
".git/objects/8f/e7af5a3e840b75b70e59c3ffda1b58e84a5a1c": "e3695ae5742d7e56a9c696f82745288d",
".git/objects/92/dadafb7c9e01cf73b33bd084810f59776a6af9": "7d936080d78106bdf2d26789674a9b9c",
".git/objects/93/b363f37b4951e6c5b9e1932ed169c9928b1e90": "c8d74fb3083c0dc39be8cff78a1d4dd5",
".git/objects/9b/65eeef78e13dce671b811f195c6403c7b907b5": "ad93ad70b547071afb125ace248ac3f0",
".git/objects/a0/c69c4352d0390685fddc82d3ed600ef4dc00d6": "a7d95542f8491b132baf589a3e5af7e1",
".git/objects/a7/3f4b23dde68ce5a05ce4c658ccd690c7f707ec": "ee275830276a88bac752feff80ed6470",
".git/objects/ad/ced61befd6b9d30829511317b07b72e66918a1": "37e7fcca73f0b6930673b256fac467ae",
".git/objects/b5/6a5e46e64de790203578c5525b9215d741058c": "87dfabc396763ffbaaae0c66a9ceea55",
".git/objects/b5/b88bb27eddfd219f02d3fe7bda0f165beb8e4a": "d032eeea7f90aef7d009a774a2b533fe",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/3e39bd49dfaf9e225bb598cd9644f833badd9a": "666b0d595ebbcc37f0c7b61220c18864",
".git/objects/ba/e4bad74e95a8204d0814fa25b2317cd164e510": "9b1011edf968f2a59c38876ede89d61d",
".git/objects/c1/10c9fac4b83451d914086654dc039ec6961a81": "cb3315472f258b61c067a46435f06944",
".git/objects/c6/ab502bb847a389bde210acb74038988b8ce622": "25f4404cccbe6b4760eeec7d5230a84a",
".git/objects/c8/3af99da428c63c1f82efdcd11c8d5297bddb04": "144ef6d9a8ff9a753d6e3b9573d5242f",
".git/objects/cd/e270588a09cd21667c7a9b0e5f27603ffe60f0": "808829cc619d9a56ccaed9198e026cf9",
".git/objects/d2/01abf7b3a4e04133dbc9caaad79eaeb71a4911": "ecdfaefd173914805caf60b6dfd6dfc8",
".git/objects/d2/7c8bc6025261f11fd63d9265e2b026b329636c": "323f2459c612a146b14c145cd44bfec0",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d9/3778e84ea13f99c969347b4cc816d2556adb3f": "f134d7d5fcdef2fdbf92e7abf9c5a477",
".git/objects/d9/5b1d3499b3b3d3989fa2a461151ba2abd92a07": "a072a09ac2efe43c8d49b7356317e52e",
".git/objects/dc/e13a99449bb206a32393538256b65f2a95b587": "96d66b4e0fa9bad8ab035c808ac0362c",
".git/objects/e4/a4a4181c3105d8944f316ba32612cdf1682170": "3a2b998ee14ae560171c94516590132e",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ee/7c61d80bd68aa7bb62c245ab0f6d3f6e40f943": "9794dda5c9fcb84889761e44af50b50c",
".git/objects/f0/e48152f33c057de2fcc2cc47c673ad26cf9ba6": "0ef867d2882925a80ecf098db10c5deb",
".git/objects/f3/3e0726c3581f96c51f862cf61120af36599a32": "afcaefd94c5f13d3da610e0defa27e50",
".git/objects/f3/c086fbdd89ef34ecd23069ea1cea8f713847d2": "1cd30b5c7b2cec7b0553daff8e1d82c0",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f6/e6c75d6f1151eeb165a90f04b4d99effa41e83": "95ea83d65d44e4c524c6d51286406ac8",
".git/objects/fa/218c627fd33c789ab628a7c087509453a1c5fb": "42a6b50e62969cfb156bb79e13b2d35c",
".git/objects/fb/8c94d10b52f45c25b77b9e54cb8981d8652a15": "4cf986e9e6e1148bb5520e915dc913c3",
".git/objects/fc/c9f750097c15e3df45badd48c892e9b765a58a": "2f75dbd5a04d62e4b5ade6a76cfe686a",
".git/objects/fc/e43bfada5915ccddf79500bbef147da07eeedc": "b50c7ae2f3e493d6bee98030b558655d",
".git/objects/fd/05cfbc927a4fedcbe4d6d4b62e2c1ed8918f26": "5675c69555d005a1a244cc8ba90a402c",
".git/refs/heads/gh-pages": "51f200186c5efef5537be0c5e57f052f",
".git/refs/heads/main": "2b25cd5c21ff87afe17adcbe2da214d5",
".git/refs/heads/master": "4f7dd24481868ccde409927453cefea1",
".git/refs/remotes/origin/gh-pages": "51f200186c5efef5537be0c5e57f052f",
"assets/AssetManifest.bin": "693635b5258fe5f1cda720cf224f158c",
"assets/AssetManifest.bin.json": "69a99f98c8b1fb8111c5fb961769fcd8",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "41bc567e0652cd595458902bb13d2f88",
"assets/NOTICES": "dde99bcd69deb9e95ad606512010bd2a",
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
"flutter_bootstrap.js": "f0cd0e103720db7cebb197ca00efa409",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "171d1a07770bff1b0d16c8fbd3c26fee",
"/": "171d1a07770bff1b0d16c8fbd3c26fee",
"main.dart.js": "7a6e244e95660d1d1428aaf1452c23d6",
"manifest.json": "b850cbd3a03af06cedd619a52c898018",
"sqlite3.wasm": "59b0b16e9818fad51d4ec7c1400fd1dd",
"version.json": "f982d0be00d9d7fd2e744df4c03f8a1e"};
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
