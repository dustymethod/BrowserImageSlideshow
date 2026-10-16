const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const html = fs.readFileSync(path.join(__dirname, '..', 'BrowserImageSlideshow.html'), 'utf8');
const script = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)][0][1];

function createPlayer({store = new Map(), enabled = true, mode = 0, files = ['1.png','2.png','10.png','20.png'], seed = .37, url = 'http://localhost/show.html', throwRead = false, throwWrite = false, autoplay = false, captions = false, omitSetting = false} = {}) {
    const listeners = {};
    const elements = {};
    const storage = {
        getItem(key) { if (throwRead) throw new Error('Storage blocked'); return store.get(key) ?? null; },
        setItem(key, value) { if (throwWrite) throw new Error('Quota exceeded'); store.set(key, value); }
    };
    const math = Object.create(Math);
    math.random = () => seed;
    const context = {
        imageNamesStr: '\n' + files.join('\n') + '\n', mode,
        slideDuration: 4000, loopSlideshow: true, startWithAutoplay: autoplay, captionEnabled: captions,
        window: {location: {href: url}, localStorage: storage}, Math: math,
        document: {
            createElement() { return {style: {}}; },
            getElementById(id) { return elements[id] ??= {appendChild(child) { elements[child.id] = child; }}; },
            addEventListener(name, callback) { listeners[name] = callback; }
        },
        $() { return {stop() {}, animate(_, options) { if (options.done) options.done(); }}; },
        setInterval() { return 1; }, clearInterval() {}, console: {log() {}, warn() {}}
    };
    if (!omitSetting) context.rememberPlayback = enabled;
    vm.createContext(context);
    vm.runInContext(script, context);
    const evaluate = code => vm.runInContext(code, context);
    return {
        evaluate, store, elements,
        press(key) { listeners.keydown({key}); },
        snapshot() { return JSON.parse(evaluate('JSON.stringify({index, indexes, images, current: images[indexes[index]], paused: isSlideshowPaused})')); }
    };
}

for (const mode of [0,1,2,3]) {
    test(`restores current image and full order in mode ${mode}`, () => {
        const first = createPlayer({mode, captions: true});
        first.press('3'); first.press('3');
        const saved = first.snapshot();
        const reloaded = createPlayer({mode, store: first.store, seed: .91, captions: true});
        assert.deepEqual(reloaded.snapshot(), saved);
        first.press('3'); reloaded.press('3');
        assert.deepEqual(reloaded.snapshot(), first.snapshot());
        assert.ok(reloaded.evaluate('caption.innerText').length > 0);
    });
}

test('explicitly disabling history never accesses browser storage', () => {
    const store = new Map();
    const player = createPlayer({enabled: false, store, throwRead: true, throwWrite: true});
    player.press('3'); assert.equal(store.size, 0);
});

test('older settings enable history by default and restore it on reload', () => {
    const player = createPlayer({omitSetting: true, mode: 1});
    player.press('3'); player.press('3');
    assert.equal(player.store.size, 1);
    const restored = createPlayer({omitSetting: true, mode: 1, store: player.store});
    assert.deepEqual(restored.snapshot(), player.snapshot());
});

test('bundled JavaScript and Lua settings both enable history by default', () => {
    const settings = fs.readFileSync(path.join(__dirname, '..', 'settings.js'), 'utf8');
    const lua = fs.readFileSync(path.join(__dirname, '..', 'SlideshowSettings.lua'), 'utf8');
    assert.match(settings, /let rememberPlayback = true;/);
    assert.match(lua, /obs_data_set_default_bool\(settings, "rememberPlayback", true\)/);
});

test('manual previous persists the selected image', () => {
    const player = createPlayer({mode: 1}); player.press('3'); player.press('3'); player.press('4');
    assert.deepEqual(createPlayer({mode: 1, store: player.store}).snapshot(), player.snapshot());
});

test('restored shuffle has no repeats before its remaining images are exhausted', () => {
    const first = createPlayer(); first.press('3');
    const saved = first.snapshot();
    const player = createPlayer({store: first.store, seed: .9});
    const seen = [player.snapshot().current];
    for (let i = saved.index + 1; i < saved.images.length; i++) {
        player.press('3'); seen.push(player.snapshot().current);
    }
    assert.equal(new Set(seen).size, seen.length);
});

test('restart replaces history with a fresh order at the beginning', () => {
    const player = createPlayer({mode: 1}); player.press('3'); player.press('3'); player.press('7');
    assert.equal(player.snapshot().index, 0);
    assert.equal(createPlayer({mode: 1, store: player.store}).snapshot().index, 0);
});

test('changed mode, image list, or page URL does not restore incompatible history', () => {
    const first = createPlayer({mode: 1}); first.press('3'); first.press('3');
    const original = new Map(first.store);
    assert.equal(createPlayer({mode: 3, store: new Map(original)}).snapshot().index, 0);
    assert.equal(createPlayer({mode: 1, files: ['1.png','new.png'], store: new Map(original)}).snapshot().index, 0);
    assert.equal(createPlayer({mode: 1, url: 'http://localhost/other.html', store: new Map(original)}).snapshot().index, 0);
});

for (const bad of [null, {}, {version: 1, mode: 0}, {version: 1, mode: 0, images: ['images/1.png','images/2.png','images/10.png','images/20.png'], indexes: [0,0,2,3], index: 1}, {version: 1, mode: 0, images: ['images/1.png','images/2.png','images/10.png','images/20.png'], indexes: [0,1,2,3], index: 99}]) {
    test(`invalid saved state is ignored: ${JSON.stringify(bad)}`, () => {
        const key = 'BrowserImageSlideshow.playback.v1:http://localhost/show.html';
        const player = createPlayer({store: new Map([[key, JSON.stringify(bad)]])});
        assert.equal(player.snapshot().index, 0);
        assert.equal(new Set(player.snapshot().indexes).size, 4);
    });
}

test('malformed JSON and blocked/full local storage do not break playback', () => {
    const key = 'BrowserImageSlideshow.playback.v1:http://localhost/show.html';
    for (const options of [{store: new Map([[key, '{broken']])}, {throwRead: true}, {throwWrite: true}]) {
        const player = createPlayer(options); player.press('3');
        assert.equal(player.snapshot().index, 1);
    }
});

test('empty and single-image lists remain supported', () => {
    const empty = createPlayer({files: []}); empty.press('3'); assert.equal(empty.snapshot().images.length, 0);
    const single = createPlayer({files: ['only.png']});
    assert.equal(single.snapshot().current, 'images/only.png');
    assert.equal(createPlayer({files: ['only.png'], store: single.store}).snapshot().current, 'images/only.png');
});

test('autoplay still uses the configured startup behavior after restore', () => {
    const first = createPlayer({mode: 1, autoplay: false}); first.press('3');
    const reloaded = createPlayer({mode: 1, autoplay: true, store: first.store});
    assert.equal(reloaded.snapshot().current, first.snapshot().current);
    reloaded.press('1'); reloaded.press('2');
    assert.equal(reloaded.snapshot().current, 'images/10.png');
});
