// features/keyboard/keyboard_layout.dart

import 'keyboard_key.dart';


// ================================================================
// ПЕЧАТНАЯ КЛАВИАТУРА
// ================================================================
//
// Английские буквы являются физическими клавишами,
// которые отправляются компьютеру.
//
// Русские буквы отображаются как подсказки.
//
// Например:
//
//     Q
//       Й
//
// При нажатии отправляется:
// q
//
// Если на компьютере выбрана русская раскладка,
// эта физическая клавиша напечатает:
// Й
//
// ================================================================


// ================================================================
// ЦИФРОВОЙ РЯД МОБИЛЬНОЙ КЛАВИАТУРЫ
// ================================================================
//
// Цифры отправляются через TEXT.
//
// Это позволяет не зависеть от:
// - текущей раскладки компьютера
// - состояния Shift
// - Caps Lock
//
// ================================================================

const typingNumberRow = [

  KeyboardKey(
    key: '1',
    label: '1',
  ),

  KeyboardKey(
    key: '2',
    label: '2',
  ),

  KeyboardKey(
    key: '3',
    label: '3',
  ),

  KeyboardKey(
    key: '4',
    label: '4',
  ),

  KeyboardKey(
    key: '5',
    label: '5',
  ),

  KeyboardKey(
    key: '6',
    label: '6',
  ),

  KeyboardKey(
    key: '7',
    label: '7',
  ),

  KeyboardKey(
    key: '8',
    label: '8',
  ),

  KeyboardKey(
    key: '9',
    label: '9',
  ),

  KeyboardKey(
    key: '0',
    label: '0',
  ),
];


// ================================================================
// ВЕРХНИЙ РЯД
// ================================================================
//
// QWERTY:
//
// Q W E R T Y U I O P [ ]
//
// Русская раскладка:
//
// Й Ц У К Е Н Г Ш Щ З Х Ъ
//
// ================================================================

const typingTopRow = [

  KeyboardKey(
    key: 'q',
    label: 'Q',
    secondaryLabel: 'Й',
  ),

  KeyboardKey(
    key: 'w',
    label: 'W',
    secondaryLabel: 'Ц',
  ),

  KeyboardKey(
    key: 'e',
    label: 'E',
    secondaryLabel: 'У',
  ),

  KeyboardKey(
    key: 'r',
    label: 'R',
    secondaryLabel: 'К',
  ),

  KeyboardKey(
    key: 't',
    label: 'T',
    secondaryLabel: 'Е',
  ),

  KeyboardKey(
    key: 'y',
    label: 'Y',
    secondaryLabel: 'Н',
  ),

  KeyboardKey(
    key: 'u',
    label: 'U',
    secondaryLabel: 'Г',
  ),

  KeyboardKey(
    key: 'i',
    label: 'I',
    secondaryLabel: 'Ш',
  ),

  KeyboardKey(
    key: 'o',
    label: 'O',
    secondaryLabel: 'Щ',
  ),

  KeyboardKey(
    key: 'p',
    label: 'P',
    secondaryLabel: 'З',
  ),

  KeyboardKey(
    key: '[',
    label: '[',
    shiftLabel: '{',
    secondaryLabel: 'Х',
  ),

  KeyboardKey(
    key: ']',
    label: ']',
    shiftLabel: '}',
    secondaryLabel: 'Ъ',
  ),
];


// ================================================================
// СРЕДНИЙ РЯД
// ================================================================
//
// QWERTY:
//
// A S D F G H J K L ; '
//
// Русская раскладка:
//
// Ф Ы В А П Р О Л Д Ж Э
//
// ================================================================

const typingMiddleRow = [

  KeyboardKey(
    key: 'a',
    label: 'A',
    secondaryLabel: 'Ф',
  ),

  KeyboardKey(
    key: 's',
    label: 'S',
    secondaryLabel: 'Ы',
  ),

  KeyboardKey(
    key: 'd',
    label: 'D',
    secondaryLabel: 'В',
  ),

  KeyboardKey(
    key: 'f',
    label: 'F',
    secondaryLabel: 'А',
  ),

  KeyboardKey(
    key: 'g',
    label: 'G',
    secondaryLabel: 'П',
  ),

  KeyboardKey(
    key: 'h',
    label: 'H',
    secondaryLabel: 'Р',
  ),

  KeyboardKey(
    key: 'j',
    label: 'J',
    secondaryLabel: 'О',
  ),

  KeyboardKey(
    key: 'k',
    label: 'K',
    secondaryLabel: 'Л',
  ),

  KeyboardKey(
    key: 'l',
    label: 'L',
    secondaryLabel: 'Д',
  ),

  KeyboardKey(
    key: ';',
    label: ';',
    shiftLabel: ':',
    secondaryLabel: 'Ж',
  ),

  KeyboardKey(
    key: '\'',
    label: '\'',
    shiftLabel: '"',
    secondaryLabel: 'Э',
  ),
];


// ================================================================
// НИЖНИЙ РЯД
// ================================================================
//
// QWERTY:
//
// Z X C V B N M , .
//
// Русская раскладка:
//
// Я Ч С М И Т Ь Б Ю
//
// После Ю находится BACKSPACE.
//
// ================================================================

const typingBottomLetterRow = [

  KeyboardKey(
    key: 'z',
    label: 'Z',
    secondaryLabel: 'Я',
  ),

  KeyboardKey(
    key: 'x',
    label: 'X',
    secondaryLabel: 'Ч',
  ),

  KeyboardKey(
    key: 'c',
    label: 'C',
    secondaryLabel: 'С',
  ),

  KeyboardKey(
    key: 'v',
    label: 'V',
    secondaryLabel: 'М',
  ),

  KeyboardKey(
    key: 'b',
    label: 'B',
    secondaryLabel: 'И',
  ),

  KeyboardKey(
    key: 'n',
    label: 'N',
    secondaryLabel: 'Т',
  ),

  KeyboardKey(
    key: 'm',
    label: 'M',
    secondaryLabel: 'Ь',
  ),

  KeyboardKey(
    key: ',',
    label: ',',
    shiftLabel: '<',
    secondaryLabel: 'Б',
  ),

  KeyboardKey(
    key: '.',
    label: '.',
    shiftLabel: '>',
    secondaryLabel: 'Ю',
  ),
];


// ================================================================
// СПЕЦИАЛЬНАЯ КЛАВИАТУРА
// ================================================================
//
// ЦИФРЫ
//
// 1 2 3 4 5 6 7 8 9 0
//
// СПЕЦСИМВОЛЫ
//
// ~ ` ^ = [ ] { } | \
//
// @ # $ _ & % - + ( ) /
//
// SHIFT * " ' : ; ! ? BACKSPACE
//
// 123 | 🌐 | SPACE | ENTER
//
// ================================================================


// ================================================================
// ПЕРВЫЙ РЯД СИМВОЛОВ
// ================================================================

const specialTopRow = [

  KeyboardKey(
    key: '`',
    label: '~',
    shiftLabel: '`',
  ),

  KeyboardKey(
    key: '^',
    label: '^',
  ),

  KeyboardKey(
    key: '=',
    label: '=',
  ),

  KeyboardKey(
    key: '[',
    label: '[',
    shiftLabel: '{',
  ),

  KeyboardKey(
    key: ']',
    label: ']',
    shiftLabel: '}',
  ),

  KeyboardKey(
    key: '|',
    label: '|',
  ),

  KeyboardKey(
    key: '\\',
    label: '\\',
  ),
];


// ================================================================
// ВТОРОЙ РЯД СИМВОЛОВ
// ================================================================

const specialMiddleRow = [

  KeyboardKey(
    key: '@',
    label: '@',
  ),

  KeyboardKey(
    key: '#',
    label: '#',
  ),

  KeyboardKey(
    key: r'$',
    label: r'$',
  ),

  KeyboardKey(
    key: '_',
    label: '_',
  ),

  KeyboardKey(
    key: '&',
    label: '&',
  ),

  KeyboardKey(
    key: '%',
    label: '%',
  ),

  KeyboardKey(
    key: '-',
    label: '-',
  ),

  KeyboardKey(
    key: '+',
    label: '+',
  ),

  KeyboardKey(
    key: '(',
    label: '(',
  ),

  KeyboardKey(
    key: ')',
    label: ')',
  ),

  KeyboardKey(
    key: '/',
    label: '/',
  ),
];


// ================================================================
// НИЖНИЙ РЯД СИМВОЛОВ
// ================================================================
//
// SHIFT | * | " | ' | : | ; | ! | ? | BACKSPACE
//
// ================================================================

const specialBottomRow = [

  KeyboardKey(
    key: 'shift',
    label: 'SHIFT',
  ),

  KeyboardKey(
    key: '*',
    label: '*',
  ),

  KeyboardKey(
    key: '"',
    label: '"',
  ),

  KeyboardKey(
    key: '\'',
    label: '\'',
  ),

  KeyboardKey(
    key: ':',
    label: ':',
  ),

  KeyboardKey(
    key: ';',
    label: ';',
  ),

  KeyboardKey(
    key: '!',
    label: '!',
  ),

  KeyboardKey(
    key: '?',
    label: '?',
  ),

  KeyboardKey(
    key: 'backspace',
    label: '⌫',
  ),
];


// ================================================================
// ПОЛНАЯ КЛАВИАТУРА
// ================================================================
//
// Здесь пока оставляем структуру обычной компьютерной
// клавиатуры.
//
// Русские обозначения верхнего регистра добавим отдельно,
// после того как полностью закончим печатную клавиатуру.
//
// ================================================================


// ================================================================
// F1-F12
// ================================================================

// ================================================================
// ПОЛНАЯ КЛАВИАТУРА
// ================================================================
//
// Для букв:
//
//     Q
//     Й
//
// Для символов:
//
//     {
//     [
//     Х
//
// Где:
//
// label           — основной символ клавиши
// shiftLabel      — символ английской раскладки через SHIFT
// secondaryLabel  — символ русской раскладки
//
// ================================================================


// ================================================================
// F1-F12
// ================================================================

const fullFunctionRow = [

  KeyboardKey(
    key: 'esc',
    label: 'ESC',
  ),

  KeyboardKey(
    key: 'f1',
    label: 'F1',
  ),

  KeyboardKey(
    key: 'f2',
    label: 'F2',
  ),

  KeyboardKey(
    key: 'f3',
    label: 'F3',
  ),

  KeyboardKey(
    key: 'f4',
    label: 'F4',
  ),

  KeyboardKey(
    key: 'f5',
    label: 'F5',
  ),

  KeyboardKey(
    key: 'f6',
    label: 'F6',
  ),

  KeyboardKey(
    key: 'f7',
    label: 'F7',
  ),

  KeyboardKey(
    key: 'f8',
    label: 'F8',
  ),

  KeyboardKey(
    key: 'f9',
    label: 'F9',
  ),

  KeyboardKey(
    key: 'f10',
    label: 'F10',
  ),

  KeyboardKey(
    key: 'f11',
    label: 'F11',
  ),

  KeyboardKey(
    key: 'f12',
    label: 'F12',
  ),
];


// ================================================================
// ЦИФРОВОЙ РЯД
// ================================================================
//
// Английская раскладка:
//
// ` ~ | 1 ! | 2 @ | 3 # | 4 $ | 5 % | 6 ^ | 7 & | 8 * | 9 ( | 0 ) | - _ | = +
//
// Русская раскладка:
//
// ё ~ | 1 ! | 2 " | 3 № | 4 ; | 5 % | 6 : | 7 ? | 8 * | 9 ( | 0 ) | - _ | = +
//
// ================================================================

const fullNumberRow = [

  KeyboardKey(
    key: '`',
    label: '`',
    shiftLabel: '~',
    secondaryLabel: 'Ё',
  ),

  KeyboardKey(
    key: '1',
    label: '1',
    shiftLabel: '!',
  ),

  KeyboardKey(
    key: '2',
    label: '2',
    shiftLabel: '@',
    secondaryLabel: '"',
  ),

  KeyboardKey(
    key: '3',
    label: '3',
    shiftLabel: '#',
    secondaryLabel: '№',
  ),

  KeyboardKey(
    key: '4',
    label: '4',
    shiftLabel: r'$',
    secondaryLabel: ';',
  ),

  KeyboardKey(
    key: '5',
    label: '5',
    shiftLabel: '%',
  ),

  KeyboardKey(
    key: '6',
    label: '6',
    shiftLabel: '^',
    secondaryLabel: ':',
  ),

  KeyboardKey(
    key: '7',
    label: '7',
    shiftLabel: '&',
    secondaryLabel: '?',
  ),

  KeyboardKey(
    key: '8',
    label: '8',
    shiftLabel: '*',
  ),

  KeyboardKey(
    key: '9',
    label: '9',
    shiftLabel: '(',
  ),

  KeyboardKey(
    key: '0',
    label: '0',
    shiftLabel: ')',
  ),

  KeyboardKey(
    key: '-',
    label: '-',
    shiftLabel: '_',
  ),

  KeyboardKey(
    key: '=',
    label: '=',
    shiftLabel: '+',
  ),

  KeyboardKey(
    key: 'backspace',
    label: 'BACK',
  ),
];


// ================================================================
// ВЕРХНИЙ РЯД
// ================================================================
//
// Q W E R T Y U I O P [ ] \
//
// Й Ц У К Е Н Г Ш Щ З Х Ъ
//
// ================================================================

const fullTopRow = [

  KeyboardKey(
    key: 'tab',
    label: 'TAB',
  ),

  KeyboardKey(
    key: 'q',
    label: 'Q',
    secondaryLabel: 'Й',
  ),

  KeyboardKey(
    key: 'w',
    label: 'W',
    secondaryLabel: 'Ц',
  ),

  KeyboardKey(
    key: 'e',
    label: 'E',
    secondaryLabel: 'У',
  ),

  KeyboardKey(
    key: 'r',
    label: 'R',
    secondaryLabel: 'К',
  ),

  KeyboardKey(
    key: 't',
    label: 'T',
    secondaryLabel: 'Е',
  ),

  KeyboardKey(
    key: 'y',
    label: 'Y',
    secondaryLabel: 'Н',
  ),

  KeyboardKey(
    key: 'u',
    label: 'U',
    secondaryLabel: 'Г',
  ),

  KeyboardKey(
    key: 'i',
    label: 'I',
    secondaryLabel: 'Ш',
  ),

  KeyboardKey(
    key: 'o',
    label: 'O',
    secondaryLabel: 'Щ',
  ),

  KeyboardKey(
    key: 'p',
    label: 'P',
    secondaryLabel: 'З',
  ),

  KeyboardKey(
    key: '[',
    label: '[',
    shiftLabel: '{',
    secondaryLabel: 'Х',
  ),

  KeyboardKey(
    key: ']',
    label: ']',
    shiftLabel: '}',
    secondaryLabel: 'Ъ',
  ),

  KeyboardKey(
    key: '\\',
    label: '\\',
    shiftLabel: '|',
  ),
];


// ================================================================
// СРЕДНИЙ РЯД
// ================================================================
//
// A S D F G H J K L ; '
//
// Ф Ы В А П Р О Л Д Ж Э
//
// ================================================================

const fullMiddleRow = [

  KeyboardKey(
    key: 'capslock',
    label: 'CAPS',
  ),

  KeyboardKey(
    key: 'a',
    label: 'A',
    secondaryLabel: 'Ф',
  ),

  KeyboardKey(
    key: 's',
    label: 'S',
    secondaryLabel: 'Ы',
  ),

  KeyboardKey(
    key: 'd',
    label: 'D',
    secondaryLabel: 'В',
  ),

  KeyboardKey(
    key: 'f',
    label: 'F',
    secondaryLabel: 'А',
  ),

  KeyboardKey(
    key: 'g',
    label: 'G',
    secondaryLabel: 'П',
  ),

  KeyboardKey(
    key: 'h',
    label: 'H',
    secondaryLabel: 'Р',
  ),

  KeyboardKey(
    key: 'j',
    label: 'J',
    secondaryLabel: 'О',
  ),

  KeyboardKey(
    key: 'k',
    label: 'K',
    secondaryLabel: 'Л',
  ),

  KeyboardKey(
    key: 'l',
    label: 'L',
    secondaryLabel: 'Д',
  ),

  KeyboardKey(
    key: ';',
    label: ';',
    shiftLabel: ':',
    secondaryLabel: 'Ж',
  ),

  KeyboardKey(
    key: '\'',
    label: '\'',
    shiftLabel: '"',
    secondaryLabel: 'Э',
  ),

  KeyboardKey(
    key: 'enter',
    label: 'ENTER',
  ),
];


// ================================================================
// НИЖНИЙ РЯД
// ================================================================
//
// Z X C V B N M , . /
//
// Я Ч С М И Т Ь Б Ю .
//
// ================================================================

const fullBottomRow = [

  KeyboardKey(
    key: 'shift',
    label: 'SHIFT',
  ),

  KeyboardKey(
    key: 'z',
    label: 'Z',
    secondaryLabel: 'Я',
  ),

  KeyboardKey(
    key: 'x',
    label: 'X',
    secondaryLabel: 'Ч',
  ),

  KeyboardKey(
    key: 'c',
    label: 'C',
    secondaryLabel: 'С',
  ),

  KeyboardKey(
    key: 'v',
    label: 'V',
    secondaryLabel: 'М',
  ),

  KeyboardKey(
    key: 'b',
    label: 'B',
    secondaryLabel: 'И',
  ),

  KeyboardKey(
    key: 'n',
    label: 'N',
    secondaryLabel: 'Т',
  ),

  KeyboardKey(
    key: 'm',
    label: 'M',
    secondaryLabel: 'Ь',
  ),

  KeyboardKey(
    key: ',',
    label: ',',
    shiftLabel: '<',
    secondaryLabel: 'Б',
  ),

  KeyboardKey(
    key: '.',
    label: '.',
    shiftLabel: '>',
    secondaryLabel: 'Ю',
  ),

  KeyboardKey(
    key: '/',
    label: '/',
    shiftLabel: '?',
    secondaryLabel: '.',
  ),

  KeyboardKey(
    key: 'shift',
    label: 'SHIFT',
  ),
];


// ================================================================
// СИСТЕМНЫЙ РЯД
// ================================================================

const fullControlRow = [

  KeyboardKey(
    key: 'ctrl',
    label: 'CTRL',
  ),

  KeyboardKey(
    key: 'win',
    label: 'WIN',
  ),

  KeyboardKey(
    key: 'alt',
    label: 'ALT',
  ),

  KeyboardKey(
    key: 'space',
    label: 'SPACE',
  ),

  KeyboardKey(
    key: 'alt',
    label: 'ALT',
  ),

  KeyboardKey(
    key: 'win',
    label: 'WIN',
  ),

  KeyboardKey(
    key: 'menu',
    label: 'MENU',
  ),

  KeyboardKey(
    key: 'ctrl',
    label: 'CTRL',
  ),
];