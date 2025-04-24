//摘要算法
import cryptoFramework from '@ohos.security.cryptoFramework';
import buffer from '@ohos.buffer';
import { HASHAlgorithm, TextFormat, AESAlgorithm, InnerTextFormat } from './CryptoStandardDefine';

export class DigestAlgorithm {
  static async digest(algorithm: HASHAlgorithm, text: string) {
    try {
      let md = cryptoFramework.createMd(algorithm);
      await md.update({ data: new Uint8Array(buffer.from(text, InnerTextFormat.UTF8).buffer) });
      return await md.digest();
    } catch (e) {
      console.log('digest error: ' + 'code: ' + e.code + ' msg:' + e.message);
      return null
    }
  }

  static async hmac(algorithm: HASHAlgorithm, aesAlgorithm: AESAlgorithm, text: string, key: string) {
    try {
      let symKeyData: Uint8Array = new Uint8Array(buffer.from(key, InnerTextFormat.UTF8).buffer)
      let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
      let aesGenerator = cryptoFramework.createSymKeyGenerator(aesAlgorithm);
      let symKey = await aesGenerator.convertKey(symKeyBlob);
      let mac = cryptoFramework.createMac(algorithm);
      await mac.init(symKey);
      await mac.update({ data: new Uint8Array(buffer.from(text, InnerTextFormat.UTF8).buffer) });
      let macResult = await mac.doFinal();
      return macResult
    } catch (e) {
      console.log('hmac error: ' + 'code: ' + e.code + ' msg:' + e.message);
      return null
    }
  }

  static dataToHex(data: cryptoFramework.DataBlob | null | undefined): string | null {
    if (data) {
      let result = buffer.from(data.data).toString('hex');
      return result
    } else {
      return null
    }
  }

  public static async SHA1(text: string) {
    let result = await DigestAlgorithm.digest(HASHAlgorithm.SHA1, text)
    return DigestAlgorithm.dataToHex(result)
  }

  public static async SHA224(text: string) {
    let result = await DigestAlgorithm.digest(HASHAlgorithm.SHA224, text)
    return DigestAlgorithm.dataToHex(result)
  }

  public static async SHA256(text: string) {
    let result = await DigestAlgorithm.digest(HASHAlgorithm.SHA256, text)
    return DigestAlgorithm.dataToHex(result)
  }

  public static async SHA384(text: string) {
    let result = await DigestAlgorithm.digest(HASHAlgorithm.SHA384, text)
    return DigestAlgorithm.dataToHex(result)
  }

  public static async SHA512(text: string) {
    let result = await DigestAlgorithm.digest(HASHAlgorithm.SHA512, text)
    return DigestAlgorithm.dataToHex(result)
  }

  public static async MD5(text: string) {
    let result = await DigestAlgorithm.digest(HASHAlgorithm.MD5, text)
    return DigestAlgorithm.dataToHex(result)
  }

  public static async SM3(text: string) {
    let result = await DigestAlgorithm.digest(HASHAlgorithm.SM3, text)
    return DigestAlgorithm.dataToHex(result)
  }

  public static async HMAC_SHA256(text: string, key: string) {
    let length = key.length
    let aesAlgorithm = AESAlgorithm.AES128
    if (length == 16) {
      aesAlgorithm = AESAlgorithm.AES128
    } else if (length == 24) {
      aesAlgorithm = AESAlgorithm.AES192
    } else if (length == 32){
      aesAlgorithm = AESAlgorithm.AES256
    } else {
      console.log('HMAC_SHA256 不支持的密钥长度')
      return null
    }
    let result = await DigestAlgorithm.hmac(HASHAlgorithm.SHA256, aesAlgorithm, text, key)
    return DigestAlgorithm.dataToHex(result)
  }


  public static async HMAC_SHA256_NEW(text: string, key: string) {
    let length = key.length
    let aesAlgorithm = AESAlgorithm.AES128
    if (length == 16) {
      aesAlgorithm = AESAlgorithm.AES128
    } else if (length == 24) {
      aesAlgorithm = AESAlgorithm.AES192
    } else if (length == 32) {
      aesAlgorithm = AESAlgorithm.AES256
    } else {
      //console.log('HMAC_SHA256 不支持的密钥长度')
      //return null
      aesAlgorithm = AESAlgorithm.AES256
    }
    let result = await DigestAlgorithm.hmac2(HASHAlgorithm.SHA256, aesAlgorithm, text, key)
    return DigestAlgorithm.dataToHex(result)
  }

  static async hmac2(algorithm: HASHAlgorithm, aesAlgorithm: AESAlgorithm, text: string, key: string) {
    try {
      let format = TextFormat.BASE64
      let symKeyData: Uint8Array = new Uint8Array(buffer.from(key, format).buffer)
      let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
      let symKeyGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
      let symKey = symKeyGenerator.convertKeySync(symKeyBlob);
      let mac = cryptoFramework.createMac(algorithm);
      await mac.init(symKey);
      await mac.update({ data: new Uint8Array(buffer.from(text, InnerTextFormat.UTF8).buffer) });
      let macResult = await mac.doFinal();
      return macResult
    } catch (e) {
      console.log('hmac error: ' + 'code: ' + e.code + ' msg:' + e.message);
      return null
    }
  }
}