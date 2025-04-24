import cryptoFramework from '@ohos.security.cryptoFramework';
import buffer from '@ohos.buffer';
import {
  InnerTextFormat,
  RSAAlgorithm, RSAPaddingMode, SM2Algorithm, SM2DigestAlgorithm, TextFormat } from './CryptoStandardDefine';

class BaseCrypto {
  protected algorithm: string
  protected paddingMode?: string
  protected digestAlgorithm?: string
  protected pubKeyString?: string
  protected priKeyString?: string
  protected keyPair?: cryptoFramework.KeyPair
  protected transformation?: string

  constructor(algorithm: string, paddingMode?: string, digestAlgorithm?: string, pubKey?: string, priKey?: string) {
    this.algorithm = algorithm
    this.paddingMode = paddingMode
    this.digestAlgorithm = digestAlgorithm
    this.pubKeyString = pubKey
    this.priKeyString = priKey
    this.genTransformation()
  }

  protected async genKeyPair() {
    if (this.keyPair == null) {
      try {
        let pubKeyBlob: cryptoFramework.DataBlob | null = null
        if (this.pubKeyString) {
          pubKeyBlob = { data: new Uint8Array(buffer.from(this.pubKeyString, TextFormat.BASE64).buffer) }
        }
        let priKeyBlob: cryptoFramework.DataBlob | null = null
        if (this.priKeyString) {
          priKeyBlob = { data: new Uint8Array(buffer.from(this.priKeyString, TextFormat.BASE64).buffer) }
        }
        let generator = cryptoFramework.createAsyKeyGenerator(this.algorithm)
        this.keyPair = await generator.convertKey(pubKeyBlob, priKeyBlob)
      } catch (e) {
        console.log('genKeyPair error: ' + 'code: ' + e.code + ' msg:' + e.message);
      }
    }
  }

  public async encrypt(plainText: string): Promise<string | null> {
    await this.genKeyPair()
    if (this.keyPair?.pubKey) {
      try {
        let cipher = cryptoFramework.createCipher(this.transformation)
        await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, this.keyPair.pubKey, null)
        let plainTextBlob: cryptoFramework.DataBlob = {
          data: new Uint8Array(buffer.from(plainText, InnerTextFormat.UTF8).buffer)
        }
        let result = await cipher.doFinal(plainTextBlob)
        if (result) {
          return buffer.from(result.data).toString(TextFormat.BASE64)
        } else {
          return null
        }
      } catch (e) {
        console.log('encrypt error: ' + 'code: ' + e.code + ' msg:' + e.message);
        return null
      }
    } else {
      return null
    }
  }

  public async decrypt(cipherText: string): Promise<string | null> {
    await this.genKeyPair()
    if (this.keyPair?.priKey) {
      try {
        let decoder = cryptoFramework.createCipher(this.transformation);
        await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, this.keyPair.priKey, null);
        let cipherTextBlob: cryptoFramework.DataBlob = {
          data: new Uint8Array(buffer.from(cipherText, TextFormat.BASE64).buffer)
        }
        let result = await decoder.doFinal(cipherTextBlob);
        if (result) {
          return buffer.from(result.data).toString(InnerTextFormat.UTF8)
        } else {
          return null
        }
      } catch (e) {
        console.log('encrypt error: ' + 'code: ' + e.code + ' msg:' + e.message);
        return null
      }
    } else {
      return null
    }
  }

  protected genTransformation() {

  }
}

/**
 * RSA加解密
 * RSA算法的Cipher实例不支持重复init操作
 */
export class RSACrypto extends BaseCrypto {
  constructor(algorithm: RSAAlgorithm, paddingMode: RSAPaddingMode, pubKey?: string, priKey?: string) {
    super(algorithm, paddingMode, undefined, pubKey, priKey)
  }

  genTransformation() {
    if (this.transformation == null) {
      this.transformation = this.algorithm + '|' + this.paddingMode
    }
  }
}

export class SM2Crypto extends BaseCrypto {
  constructor(algorithm: SM2Algorithm, digestAlgorithm: SM2DigestAlgorithm, pubKey?: string, priKey?: string) {
    super(algorithm, undefined, digestAlgorithm, pubKey, priKey)
  }

  genTransformation() {
    if (this.transformation == null) {
      this.transformation = this.algorithm + '|' + this.digestAlgorithm
    }
  }
}