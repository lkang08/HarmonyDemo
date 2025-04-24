import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer, util } from '@kit.ArkTS';
import hilog from '@ohos.hilog';
import { StringUtils } from './StringUtils';
import { AESAlgorithm, AESCrypto, AESGroupMode,
  AESPaddingMode,
  RSAAlgorithm, RSACrypto, RSAPaddingMode,
  TextFormat } from '@slink/crypto';

const aesKey = 'Naptj13u6MTtS2RgVL3gx4CEFPgxAwpI'
const aesIv = 'aK8EAC56BAuO4CTy'
export const  RSA_PUBLIC_KEY = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu0t04NOqvlqjxCsF2eW6C8+DzvibkeRiuUgFoLOd5OWPpQwaIAiDkYha5iIqScAu3Uh0TliHM6tXALwqjFPo6aqAIrSrxkxjClMffAh5tUZuDsSbyYu4+wvPQQ5TJFbsmbq6Zm4QWJm4RUE+O9wSXJNga5juduYDhhvpZbgmTV8RfmNU8B6mWyLoH2aRIzX0l093EZk8CQJKftGtonYa83Rhtxvxh/CIBjeRW4Jx4PJPp3AhDYaNFzNOnekWjGKpECwhtW9JYAlP3RGfGy36+B1UZnPjUUMzyG4KJrBRZGR2ejKjRXGjvUq5iUavtMFWIPEsGuU5tG1Om+HGQDp1DwIDAQAB';  // Java打印出的公钥
 const  RSA_PRIVATE_KEY = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC7S3Tg06q+WqPEKwXZ5boLz4PO+JuR5GK5SAWgs53k5Y+lDBogCIORiFrmIipJwC7dSHROWIczq1cAvCqMU+jpqoAitKvGTGMKUx98CHm1Rm4OxJvJi7j7C89BDlMkVuyZurpmbhBYmbhFQT473BJck2BrmO525gOGG+lluCZNXxF+Y1TwHqZbIugfZpEjNfSXT3cRmTwJAkp+0a2idhrzdGG3G/GH8IgGN5FbgnHg8k+ncCENho0XM06d6RaMYqkQLCG1b0lgCU/dEZ8bLfr4HVRmc+NRQzPIbgomsFFkZHZ6MqNFcaO9SrmJRq+0wVYg8Swa5Tm0bU6b4cZAOnUPAgMBAAECggEAP2vduAP03WBz9Aldgdt4lGdAiuVESLK9e2AYB8LKxKe3bHwcnJxFcRJrNWJ8T1z0gZn3SFBR9/0dCPKutbX0OKuzmAz13cAgCW78SlPUYr3mprmMx0K48Mme9LiVDskgdS310JmUj2v+KfVdzYdH8HE3RTgUB877gn4RGpCw56Gkdw+BjapUXV9GgmjiyafXzdu9ZkWS2fXuDeY2pzrsXRaIHAknRQZlt/8I7fCpOKSC9961TmfygEyuptODQm2RyAOgkHDdJcQSY0CnhbahKvAsm/nKw1XWA8Cm+0jbwZ9UJAnH1Oa/MRqSUh0/lCQeVw/DPDmXzUUBimKUT6LlgQKBgQDzm4SQM2hlsm8J2rOZAZsGKiCmDyPSRtBV/kNpLKaYdCbt1yCOVFLI88hxrWX/sVJ1SkR+4CHn9hr+md6w1JumNZcQTLpr/MUAPgfaG894CYeHODzkIIzerVQlk0hNIwi16aFUK49xOBp+6eEx0Rky7Ss5yhwUiX77PVLvZFKggwKBgQDE0pUGeiEYhKtVTBbDIUxJie9g86ieXd8swI16A+l+KOPRbD3LgVj2RvtjFVw5mZgm0W5L1NSrTz9E5qs6FzDoBtEjonX0MrXpp08LPuIH/VXaVFjhUqqYu5ncgGW4ddVRagQo6P0Y9XrBlRDBDp6C3Zm3HVO2KU6AOiZjG3/bhQKBgQCyPRSWKXb2CcMis6j6h2k07nfq6GLuRK/Ea4BJIMlX/IxLMz73xIy5yVzch+F8XvKVLNzG9Bj6zl/b7xs3yKeFyeoYm/s+bbh6P+ig1f5LtrU545Tx2TsY5jsOLyAUiFCkQSewHRsb3M/OEjOZroNAdrVM2CsJf7yv+KOI0p9+HwKBgGz4GcHoRAKLEUC8S63k9ZORZpLK1AQ5/KGOScXP/Kn4gYkk4GGXT2Wqjuugm9rYCsETGnmpb8UYrvK6svoKdO1BOPD9tUhp+wVNuBmFyyaZP7sND9hQKFs/IkROYgLqWhwlEgCEXfw/jKM4oHoCWggiIESdXAdyfx/HEhG02+jxAoGAZT9U+f1pG7xVowdE/QDR0IIcgLvCTxIx+qJ1DGUWzBkbDNJ+Gd+BSsHptGFaYZioda0+OnMUFpQMgsghhNDoKwcJanlty83kWYXv6MLp/sFMK8Y9pVlmzno6ZTbHC483QjWjv6DtV7yxfx9gxDKxbQGc6vsnCEO/raOnR2qfQBs='; // Java打印出的私钥

async function signMessageBySegment(priKey: cryptoFramework.PriKey, plainText: Uint8Array) {
  let signAlg = "RSA2048|PKCS1|SHA256";
  let signer = cryptoFramework.createSign(signAlg);
  await signer.init(priKey);
  let textSplitLen = 64; // 自定义的数据拆分长度，此处取64
  for (let i = 0; i < plainText.length; i += textSplitLen) {
    let updateMessage = plainText.subarray(i, i + textSplitLen);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 分段update
    await signer.update(updateMessageBlob);
  }
  //let updateMessageBlob: cryptoFramework.DataBlob = { data: plainText };
  //let signData = await signer.sign(updateMessageBlob)
  // 已通过分段传入所有明文，故此处sign传入null
  let signData = await signer.sign(null);
  log(fromUint8Array(signData.data))
  log('base64:' + StringUtils.base642(signData.data))
  return signData;
}

function fromUint8Array(array: Uint8Array): string {
  let dataString = ''
  for (let i = 0; i < array.length; i++) {
    dataString += String.fromCharCode(array[i])
  }
  return dataString
}

async function verifyMessagBySegment(pubKey: cryptoFramework.PubKey, plainText: Uint8Array,
  signMessageBlob: cryptoFramework.DataBlob) {
  let verifyAlg = "RSA1024|PKCS1|SHA256";
  let verifier = cryptoFramework.createVerify(verifyAlg);
  await verifier.init(pubKey);
  let textSplitLen = 64; // 自定义的数据拆分长度，此处取64
  for (let i = 0; i < plainText.length; i += textSplitLen) {
    let updateMessage = plainText.subarray(i, i + textSplitLen);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 分段update
    await verifier.update(updateMessageBlob);
  }
  // 已通过分段传入所有明文，故此处verify第一个参数传入null
  let res = await verifier.verify(null, signMessageBlob);
  log("verify result is " + res);
  return res;
}

function uint8ArrayToString(arr: Uint8Array): string {
  let str = ''
  if (arr && arr.length > 0) {
    try {
      let textDecode = util.TextDecoder.create('utf-8')
      str = textDecode.decodeToString(arr)
    } catch (err) {
    }
  }
  return str
}

async function rsa(str:string) {
  let rsa = new RSACrypto(RSAAlgorithm.RSA2048,
    RSAPaddingMode.PKCS1,
    RSA_PUBLIC_KEY,
    RSA_PRIVATE_KEY
  )
  let encryptResult = await rsa.encrypt(str)
  log(`>>>>>> cipherText:${encryptResult}`)
  let decryptResult = await rsa.decrypt(encryptResult ?? '');
  log(`>>>>>> plainText:${decryptResult}`)
}
async function aes(str: string) {
  /*let aes = new AESCrypto(AESAlgorithm.AES256, AESGroupMode.CBC, AESPaddingMode.PKCS7, aesKey, aesIv,
    TextFormat.BASE64, TextFormat.BASE64)
  let encryptResult = await aes.encrypt(str);
  log(`>>>>>> aes cipherText:${encryptResult}`)
  let decryptResult = await aes.decrypt(encryptResult ?? '');
  log(`>>>>>> aes plainText:${decryptResult}`)*/
  let result = await encryptMessage(str)
  let encryptResult = buffer.from(result.data).toString(TextFormat.BASE64)
  log('########aes encryptResult:' + encryptResult)
  result =  decryptMessage(encryptResult)
  encryptResult = buffer.from(result.data).toString(TextFormat.BASE64)
  log('########aes decryptResult:' + encryptResult)
}

export async function rsaSignatureBySegment() {
  log('rsaSignatureBySegment')
  aes('{}')
  // log('x_nonce:' + StringUtils.base64(aesIv))
  // let aesKeyBase64String = StringUtils.base64(aesKey)
  // log('aesKeyBase64String:' + aesKeyBase64String)
  // let keyGenAlg = "RSA2048";
  // let generator = cryptoFramework.createAsyKeyGenerator(keyGenAlg);
  // let keyPair = await generator.generateKeyPair();
  //
  // rsa(aesKeyBase64String)
  // let data = await signMessageBySegment(keyPair.priKey, new Uint8Array(buffer.from(aesKeyBase64String, 'utf-8').buffer))
  // let encryptedAesKeyBase64String = StringUtils.base642(data.data)
  // log('encryptedAesKeyBase64String:' + encryptedAesKeyBase64String)
  /*let message = "This is a long plainTest! This is a long plainTest! This is a long plainTest!" +
    "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!" +
    "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!" +
    "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!" +
    "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!" +
    "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!" +
    "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!" +
    "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!";
  let messageData = new Uint8Array(buffer.from(message, 'utf-8').buffer);
  log('msg0:' + uint8ArrayToString(messageData))
  log('msg:' + fromUint8Array(messageData))
  let signData = await signMessageBySegment(keyPair.priKey, messageData);
  let verifyResult = await verifyMessagBySegment(keyPair.pubKey, messageData, signData);
  log('signData:' + signData)
  if (verifyResult == true) {
    log('verify success');
  } else {
    log('verify failed');
  }*/
}

function log(msg: string) {
  hilog.info(0, 'testThread', msg)
}


function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

function genGcmParamsSpec() {
  let ivBlob0 = generateRandom(12);
  let iv = new Uint8Array(buffer.from(aesIv, TextFormat.BASE64).buffer)
  let ivBlob : cryptoFramework.DataBlob = { data: iv };
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
    aad: { data: new Uint8Array() },
    authTag: tagBlob,
    algName: "GcmParamsSpec"
  };
  return gcmParamsSpec;
}

let gcmParams = genGcmParamsSpec();

// 加密消息
async function encryptMessage(str: string) {
  let format = TextFormat.BASE64
  let keyData = new Uint8Array(buffer.from(aesKey, 'utf-8').buffer)
  //let keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
  let symKey = genSymKeyByData(keyData);
  //let list = StringUtils.toUint8Array(str)
  let list = new Uint8Array(buffer.from(str, 'utf-8').buffer)
  //let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(str, 'utf-8').buffer) };
  let plainText: cryptoFramework.DataBlob = { data: list };
  let cipher = cryptoFramework.createCipher('AES256|GCM|NoPadding');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams);
  let encryptUpdate = cipher.updateSync(plainText);
  // gcm模式加密doFinal时传入空，获得tag数据，并更新至gcmParams对象中。
  let res = cipher.doFinalSync(null);
  log('tag:' + buffer.from(res.data).toString(TextFormat.BASE64))
  return encryptUpdate;
}
// 解密消息
function decryptMessage( str: string) {
  let keyData = new Uint8Array(buffer.from(aesKey, 'utf-8').buffer)
  //let keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
  let symKey = genSymKeyByData(keyData);
  let list = StringUtils.toUint8Array(str)
  //let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(str, 'utf-8').buffer) };
  let cipherText: cryptoFramework.DataBlob = { data: list };
  let decoder = cryptoFramework.createCipher('AES256|GCM|NoPadding');
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