import cryptoFramework from '@ohos.security.cryptoFramework';
import buffer from '@ohos.buffer';
import {
  AESAlgorithm,
  AESGroupMode,
  AESPaddingMode,
  InnerTextFormat,
  SM4Algorithm,
  SM4GroupMode,
  SM4PaddingMode,
  TextFormat,
  TripleDesAlgorithm,
  TripleDesGroupMode,
  TripleDesPaddingMode
} from './CryptoStandardDefine';
import XXTEA from './XXTEA';

class BaseCrypto {
  protected algorithm: string
  protected groupMode: string
  protected paddingMode: string
  protected key: string
  protected iv?: string
  protected encryptOutputFormat?: TextFormat
  protected decryptInputFormat?: TextFormat
  protected symKey?: cryptoFramework.SymKey
  protected ivParamsSpec?: cryptoFramework.IvParamsSpec
  protected transformation?: string
  protected encryptCipher?: cryptoFramework.Cipher
  protected decryptCipher?: cryptoFramework.Cipher

  constructor(algorithm: string, groupMode: string, paddingMode: string, key: string, iv?: string, encryptOutputFormat?: TextFormat, decryptInputFormat?: TextFormat) {
    this.algorithm = algorithm
    this.groupMode = groupMode
    this.paddingMode = paddingMode
    this.key = key
    this.iv = iv ?? '0000000000000000'
    this.encryptOutputFormat = encryptOutputFormat ?? TextFormat.HEX
    this.decryptInputFormat = decryptInputFormat ?? TextFormat.HEX
    this.genTransformation()
  }

  public async encrypt(plainText: string): Promise<string | null> {
    try {
      await this.initEncrypt()
      if (this.encryptCipher) {
        let plainTextBlob: cryptoFramework.DataBlob = {
          data: new Uint8Array(buffer.from(plainText, InnerTextFormat.UTF8).buffer)
        }
        let result = await this.encryptCipher?.doFinal(plainTextBlob);
        if (result) {
          return buffer.from(result.data).toString(this.encryptOutputFormat)
        } else {
          return null
        }
      } else {
        return null
      }
    } catch (e) {
      console.log('encrypt error: ' + 'code: ' + e.code + ' msg:' + e.message);
      return null
    }
  }

  public async decrypt(cipherText: string): Promise<string | null> {
    try {
      await this.initDecrypt()
      let cipherTextBlob: cryptoFramework.DataBlob = {
        data: new Uint8Array(buffer.from(cipherText, this.decryptInputFormat).buffer)
      }
      let result = await this.decryptCipher?.doFinal(cipherTextBlob)
      if (result) {
        return buffer.from(result.data).toString(InnerTextFormat.UTF8)
      } else {
        return null
      }
    } catch (e) {
      console.log('encrypt error: ' + 'code: ' + e.code + ' msg:' + e.message);
      return null
    }
  }

  protected async initEncrypt() {
    await this.genSymKey()
    this.genIvParamsSpec()
    if (this.encryptCipher == null) {
      this.encryptCipher = cryptoFramework.createCipher(this.transformation);
    }
    await this.encryptCipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, this.symKey, this.ivParamsSpec);
  }

  protected async initDecrypt() {
    await this.genSymKey()
    this.genIvParamsSpec()
    if (this.decryptCipher == null) {
      this.decryptCipher = cryptoFramework.createCipher(this.transformation)
    }
    await this.decryptCipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, this.symKey, this.ivParamsSpec)
  }

  protected genTransformation() {
    if (this.transformation == null) {
      this.transformation = this.algorithm + '|' + this.groupMode + '|' + this.paddingMode
    }
  }

  protected async genSymKey() {
    if (this.symKey == null) {
      try {
        let symKeyData: Uint8Array = new Uint8Array(buffer.from(this.key, 'utf-8').buffer)
        let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
        let aesGenerator = cryptoFramework.createSymKeyGenerator(this.algorithm);
        this.symKey = await aesGenerator.convertKey(symKeyBlob);
      } catch (e) {
        console.log('genSymKey error: ' + 'code: ' + e.code + ' msg:' + e.message);
      }
    }
  }

  protected genIvParamsSpec() {
    if (this.iv) {
      if (this.ivParamsSpec == null) {
        let arr = new Uint8Array(buffer.from(this.iv, 'utf-8').buffer)
        let dataIv = new Uint8Array(arr);
        let ivBlob: cryptoFramework.DataBlob = { data: dataIv };
        this.ivParamsSpec = {
          algName: "IvParamsSpec",
          iv: ivBlob
        };
      }
    }
  }
}

/**
 * AES
 */
export class AESCrypto extends BaseCrypto {
  constructor(algorithm: AESAlgorithm, groupMode: AESGroupMode, paddingMode: AESPaddingMode, key: string, iv?: string, encryptOutputFormat?: TextFormat, decryptInputFormat?: TextFormat) {
    super(algorithm, groupMode, paddingMode, key, iv, encryptOutputFormat, decryptInputFormat);
  }
}

/**
 * 3DES
 */
export class TripleDesCrypto extends BaseCrypto {
  constructor(algorithm: TripleDesAlgorithm, groupMode: TripleDesGroupMode, paddingMode: TripleDesPaddingMode, key: string, iv?: string, encryptOutputFormat?: TextFormat, decryptInputFormat?: TextFormat) {
    super(algorithm, groupMode, paddingMode, key, iv, encryptOutputFormat, decryptInputFormat);
  }
}

/**
 * SM4
 */
export class SM4Crypto extends BaseCrypto {
  constructor(algorithm: SM4Algorithm, groupMode: SM4GroupMode, paddingMode: SM4PaddingMode, key: string, iv?: string, encryptOutputFormat?: TextFormat, decryptInputFormat?: TextFormat) {
    super(algorithm, groupMode, paddingMode, key, iv, encryptOutputFormat, decryptInputFormat);
  }
}

export class XXTEACrypto extends BaseCrypto {
  constructor(key: string, encryptOutputFormat?: TextFormat, decryptInputFormat?: TextFormat) {
    super('', '', '', key, '', encryptOutputFormat, decryptInputFormat)
  }

  public async encrypt(plainText: string): Promise<string | null> {
    try {
      let binaryStr = XXTEA.encryptToBase64(plainText, this.key)
      if (binaryStr) {
        if (this.encryptOutputFormat == TextFormat.BASE64) {
          return binaryStr
        } else {
          let data = new Uint8Array(buffer.from(binaryStr, TextFormat.BASE64).buffer)
          return buffer.from(data).toString(this.encryptOutputFormat)
        }
      } else {
        return null
      }
    } catch (e) {
      console.log('encrypt error: ' + 'code: ' + e.code + ' msg:' + e.message)
      return null
    }
  }

  public async decrypt(cipherText: string): Promise<string | null> {
    try {
      let base64String: string | null = cipherText
      if (this.decryptInputFormat != TextFormat.BASE64) {
        let data = new Uint8Array(buffer.from(cipherText, this.decryptInputFormat).buffer)
        base64String = buffer.from(data).toString(TextFormat.BASE64)
      }
      return XXTEA.decryptFromBase64(base64String, this.key)
    } catch (e) {
      console.log('encrypt decrypt: ' + 'code: ' + e.code + ' msg:' + e.message)
      return null
    }
  }
}