import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer, HashMap } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { TextFormat } from '@slink/crypto';
import { StringUtils } from './StringUtils';
import { generateSignature } from './httpHelperUtil';
import CryptoJS from '@ohos/crypto-js';

function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

const aesIv = 'J5VaZ4fNZY87YgXR'
const aesKey = 'cZP1VQZUcwfp4mxFpXGP1x22oUFRL9aP'

function genGcmParamsSpec() {
  let ivBlob0 = generateRandom(12);
  let iv = new Uint8Array(buffer.from(aesIv, TextFormat.BASE64).buffer)
  let ivBlob: cryptoFramework.DataBlob = { data: iv };
  let arr = [1, 2, 3, 4, 5, 6, 7, 8]; // 8 bytes
  let dataAad = new Uint8Array(arr);
  let aadBlob: cryptoFramework.DataBlob = { data: dataAad };
  arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
  let dataTag = new Uint8Array(arr);
  let tagBlob: cryptoFramework.DataBlob = {
    data: dataTag
  };
  // GCM的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中
  let gcmParamsSpec: cryptoFramework.GcmParamsSpec = {
    iv: ivBlob,
    //aad: aadBlob,
    aad: {data: new Uint8Array()},
    //authTag: tagBlob,
    authTag: {data: new Uint8Array()},
    algName: "GcmParamsSpec"
  };
  return gcmParamsSpec;
}

let gcmParams = genGcmParamsSpec();

// 加密消息
function encryptMessage(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('AES256|GCM|PKCS7');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams);
  let encryptUpdate = cipher.updateSync(plainText);
  // gcm模式加密doFinal时传入空，获得tag数据，并更新至gcmParams对象中。
  gcmParams.authTag = cipher.doFinalSync(null);
  return encryptUpdate;
}

function testCryptoJS() {
  let key = aesKey
  const iv3: CryptoJS.lib.WordArray = CryptoJS.enc.Hex.parse(aesIv)
  let option: CryptoJS.CipherOption = {
    iv: iv3
  }
  let result = CryptoJS.AES.encrypt('{}', key, option)
  log('CryptoJS encrypt:' + result)
}

// 解密消息
function decryptMessage(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('AES256|GCM|PKCS7');
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams);
  let decryptUpdate = decoder.updateSync(cipherText);
  // gcm模式解密doFinal时传入空，验证init时传入的tag数据，如果验证失败会抛出异常。
  let decryptData = decoder.doFinalSync(null);
  if (decryptData == null) {
    console.info('GCM decrypt success, decryptData is null');
  }
  return decryptUpdate;
}

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES256');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  console.info('convertKeySync success');
  return symKey;
}

async function sign() {
  let sigParam: HashMap<string, string> = new HashMap<string, string>()
  let encryptedAesKeyBase64String =
    'uuFdsO559D3ehkIRrU//G2yE4Q2a6U3Lf4oFjMFe8EMas2YXEkoihAsbhSW7yRICrwN8JfpgRKa1SfkXeLIEesee1UJmMhKby39c/F2ZGYfdFP7SaltqSufFBKa5wsLzdI652kjpT+d5Y0D1iIbhdp7kDnwCwOpeprUJ8Km54J8IPTEf5JHshoB9PboK2DXvckXhkhBivP3cfR8FfO8OKeyz+aV95FgX071l7cFwaebTTzdUHvk/bLWY33qR6oKJ4gFdo6KayJBWdlWAT0y3nNa/hiA3XViRfjBiEAQ+X7OXxVl0riheYwZiddpJtxgmMUD2S88Ab1PDBS+M8WWzmg=='
  let encryptedBodyBase64String = 'k8vA9HdOJs5PbrXbdxImqNSe'
  let token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyMDg4MDc3YzQ1YTA0M2YwYjU0ZGZlOTM5NzhlZWEyMiIsImV4cCI6MTczNzg3NjU2NCwidWlkIjoiMiIsInBpZCI6IkM0MjI3OENERjZBNzU1QUI2RDQ0MTkwNTk2ODlBMDQ5IiwidXJpZCI6IjIwNjE2OTY3LDMxNzc4OTYwIiwiaXNzIjoiaHR0cHM6Ly9zbGluay5jb20ifQ.-WnPlPGv6QzDCan250NngyFyLlcDEKxcsxmpc2-3cg4'
  sigParam.set('Authorization', token)
  sigParam.set('X-ENTRY-KEY', encryptedAesKeyBase64String)
  sigParam.set('X-NONCE', 'YUs4RUFDNTZCQXVPNENUeQ==')
  sigParam.set('X-TIMESTAMP', '1737703812531')
  sigParam.set('body', encryptedBodyBase64String)
  let sign = await generateSignature(sigParam)
  log('sign:' + sign)
  log('sign:' + (sign == '840f6cc0de2da27776eea31ec6e7255e89357d83fc320a9ba579cf2831c66adf'))
  return sign
}

export async function main() {
  //log('sign expect:840f6cc0de2da27776eea31ec6e7255e89357d83fc320a9ba579cf2831c66adf')
  //await sign()
  //return
  log('#########################')
  let keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
  //log(buffer.from(keyData).toString(TextFormat.BASE64))
  //U9nnTBxxF9v6R9HSzWEgnw==
  //testCryptoJS()
  let keyData2 = new Uint8Array(StringUtils.toUint8Array(aesKey))
  let symKey = genSymKeyByData(keyData2);
  let message = "{}";
  let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
  let encryptText = encryptMessage(symKey, plainText);
  log('encryptText encryptText: ' + buffer.from(encryptText.data).toString(TextFormat.BASE64));
  let decryptText = decryptMessage(symKey, encryptText);
  if (plainText.data.toString() === decryptText.data.toString()) {
    log('decrypt ok');
    log('decrypt plainText: ' + buffer.from(decryptText.data).toString('utf-8'));
  } else {
    console.error('decrypt failed');
  }
}

function log(msg: string) {
  hilog.info(0, 'testThread', '@@@ ' + msg)
}