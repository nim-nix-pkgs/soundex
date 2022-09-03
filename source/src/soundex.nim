import 
  strutils,
  sequtils, 
  sugar,
  tables,
  strformat

const DELETED_SOUNDEX_CODE = ['A', 'E', 'H', 'I', 'O', 'U', 'W', 'Y']

let SOUNDEX_CODE_HISTORY = {
  'B': '1', 'F': '1', 'P': '1', 'V': '1',
  'C': '2', 'G': '2', 'J': '2', 'K': '2', 'Q': '2', 'S': '2', 'X': '2',  'Z': '2',
  'D': '3', 'T': '3',
  'L': '4',
  'M': '5', 'N': '5',
  'R': '6'
}.newTable

const SOUNDEX_NUMBER_SIZE = 3

type
  SoundexInput = object
    input*: string

  SoundexCode = object
    code*: string

  Soundex = object
    inputValueObj*: SoundexInput
    codeValueObj*: SoundexCode

proc validateInput(input: string): void = 
  # if input doesn't have alpha, then raise newExecption
  if not input.any(x => isAlphaAscii(x)): raise newException(ValueError, "The alphabet is not contain")

proc newSoundexInput(input: string): SoundexInput = 
  validateInput(input)
  result = SoundexInput(input: input)

proc validateCode(code: string): void = 
  # if code is not 4 size, then raise newExecption
  if not code.len == 4: raise newException(ValueError, "Code length is not 4")

proc newSoundexCode(code: string): SoundexCode =
  validateCode(code)
  result = SoundexCode(code: code)

proc fillZero(soundex_number: string): string = 
  var filled_soundex_number = soundex_number
  var i = filled_soundex_number.len

  while i < SOUNDEX_NUMBER_SIZE:
    filled_soundex_number.add('0')
    inc(i)

  result = filled_soundex_number

proc calcSoundexCode(input :string): string =
  let upper_input = toUpperAscii(input)
                      .filter(f => isAlphaAscii(f)) # filter only alph

  let soundex_head = upper_input[0]
  let soundex_number = upper_input[1..high(upper_input)]
                        .filter(f => not DELETED_SOUNDEX_CODE.contains(f))                         # delete soundex code
                        .map(m => SOUNDEX_CODE_HISTORY[m])                                         # convert string to integer by history
                        .foldl(if a.len > 0 and a[high(a)] == b: fmt"{a}" else: fmt"{a}{b}", "")   # Removal of consecutive numbers

  # get three number
  let three_sooundex_number = 
    if soundex_number.len >= SOUNDEX_NUMBER_SIZE:
      soundex_number[0..SOUNDEX_NUMBER_SIZE - 1]
    else:
      fillZero(soundex_number)

  # merge soundex_head and three_sooundex_number
  let code = fmt"{soundex_head}{three_sooundex_number}"
  result = code

proc newSoundex*(input: string): Soundex =
  result = Soundex(inputValueObj: newSoundexInput(input), 
                   codeValueObj: newSoundexCode(calcSoundexCode(input)))

proc getCode*(soundex :Soundex): string =
  result = soundex.codeValueObj.code

proc getInput*(soundex :Soundex): string = 
  result = soundex.inputValueObj.input