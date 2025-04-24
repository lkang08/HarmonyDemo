/**
 * 字符串处理对象
 */
import HashMap from '@ohos.util.HashMap';
import util from '@ohos.util';

export class StringUtils {
  private static sBase64: util.Base64Helper = new util.Base64Helper()

  /**
   * 判断是否为数字
   * @param str
   * @returns
   */
  static isAllDigits(str: string): boolean {
    let num: number = Number.parseFloat(str);
    if (num.toString() == "NaN") {
      return false;
    } else {
      return true;
    }
  }

  /**
   * 判断是否为空字符串
   * @param str
   * @returns
   */
  static isEmpty(str?: string): boolean {
    if (!str) {
      return true;
    }
    if (str.length == 0) {
      return true;
    }
    return false;
  }

  static isNotEmpty(str?: string): boolean {
    return !StringUtils.isEmpty(str)
  }

  static convertJsonToRecord(json: string): Record<string, string> {
    let record: Record<string, string> = {}
    JSON.parse(json, (key, value) => {
      if (key.length > 0) {
        if (value instanceof Object) {
          record[key] = JSON.stringify(value)
        } else {
          record[key] = value
        }
      }
    })
    return record
  }

  static convertJsonToHashMap(json: string): HashMap<string, string> {
    let map = new HashMap<string, string>()
    JSON.parse(json, (key, value) => {
      if (key.length > 0) {
        if (value instanceof Object) {
          map.set(key, JSON.stringify(value))
        } else {
          map.set(key, value)
        }
      }
    })
    return map
  }

  /**
   * 将map转换为平坦string （key=value&key=value&key=value形式）
   * @param data
   * @returns
   */
  static convertMapToPlainString(data: HashMap<string, string>): string {
    let result: string = ''
    let iter = data.keys()
    let tmp: IteratorResult<string, string> = iter.next()
    while (!tmp.done) {
      let key = tmp.value
      let value = data.get(key)
      result += key + '=' + value
      tmp = iter.next()
      if (!tmp.done) {
        result += '&'
      }
    }
    return result
  }

  static convertMapToRecord(data: HashMap<string, string>): Record<string, string> {
    let theRecorde: Record<string, string> = {}
    let iter = data.keys()
    let tmp: IteratorResult<string, string> = iter.next()
    while (!tmp.done) {
      let key = tmp.value
      let value = data.get(key)
      theRecorde[key] = value
      tmp = iter.next()
    }
    return theRecorde
  }

  static convertRecordToPlainString(data: Record<string, string | number>): string {
    let result: string = ''
    let keys = Object.keys(data)
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i]
      let value = data[key]
      if (i == 0) {
        result += (key + '=' + value)
      } else {
        result += ('&' + key + '=' + value)
      }
    }
    return result
  }

  /**
   * 对字符串进行base64
   */
  static base64(str: string): string {
    return StringUtils.fromUint8Array(StringUtils.sBase64.encodeSync(StringUtils.toUint8Array(str)))
  }

  /**
   * 对字符串进行base64
   */
  static base642(str: Uint8Array): string {
    return StringUtils.fromUint8Array(StringUtils.sBase64.encodeSync(str))
  }

  /**
   * 对字符串进行base64
   */
  static base64ToString(str: string): string {
    return StringUtils.fromUint8Array(StringUtils.sBase64.decodeSync(StringUtils.toUint8Array(str)))
  }

  /**
   * string转成ASCII码的Uint8Array
   * hello->[71,69,76,76,79]
   */
  static toUint8Array(str: string): Uint8Array {
    let array: number[] = []
    for (let i = 0; i < str.length; i++) {
      array.push(str.charCodeAt(i))
    }
    return new Uint8Array(array)
  }

  /**
   * string转成ASCII码的Uint8Array(对ASCII码本身进行flat)
   * hello->[7,1,6,9,7,6,7,6,7,9]
   */
  static toFlatUint8Array(str: string): Uint8Array {
    let array: number[] = []
    let charStr = ''
    for (let i = 0; i < str.length; i++) {
      charStr += str.charCodeAt(i)
    }
    for (let i = 0; i < charStr.length; i++) {
      array.push(new Number(charStr.charAt(i)).valueOf())
    }
    return new Uint8Array(array)
  }

  /**
   * 从ASCII码数组转为string
   * [71,69,76,76,79]->hello
   */
  static fromUint8Array(array: Uint8Array): string {
    let dataString = ''
    for (let i = 0; i < array.length; i++) {
      dataString += String.fromCharCode(array[i])
    }
    return dataString
  }

  /**
   * 翻转string
   * hello->olleh
   */
  static reverse(str: string): string {
    return str.split('').reverse().join('')
  }

  static uint8ArrayToHexString(fileData: Uint8Array): string {
    return Array.prototype.map.call(fileData, (x: number) => ('00' + x.toString(16)).slice(-2)).join('');
  }

  static hexStringToUint8Array(hex: string): Uint8Array {
    const bytes = hex.match(/.{1,2}/g).map(byte => parseInt(byte, 16));
    return new Uint8Array(bytes);
  }

  static stringToUint8Array(str) {
    var arr = [];
    for (var i = 0, j = str.length; i < j; ++i) {
      arr.push(str.charCodeAt(i));
    }

    var tmpUint8Array = new Uint8Array(arr);
    return tmpUint8Array
  }

  static uint8ArrayToString(array: Uint8Array) {
    let arrayString = '';
    for (let i = 0; i < array.length; i++) {
      arrayString += String.fromCharCode(array[i]);
    }
    return arrayString;
  }

  static hexCharCodeToStr(hexCharCodeStr) {
    var trimmedStr = hexCharCodeStr.trim();
    var rawStr =
      trimmedStr.substr(0, 2).toLowerCase() === "0x"
        ?
      trimmedStr.substr(2)
        :
        trimmedStr;
    var len = rawStr.length;
    if (len % 2 !== 0) {
      return "";
    }
    var curCharCode;
    var resultStr = [];
    for (var i = 0; i < len; i = i + 2) {
      curCharCode = parseInt(rawStr.substr(i, 2), 16); // ASCII Code Value
      resultStr.push(String.fromCharCode(curCharCode));
    }
    return resultStr.join("");
  }
}